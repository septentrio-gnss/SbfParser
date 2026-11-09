# type: ignore 
# Initial code by Jashandeep Sohi (2013, jashandeep.s.sohi@gmail.com)
# adapted by Marco Job (2019, marco.job@bluewin.ch)
# Update Meven Jeanne-Rose 2023
# Update Louis-Max Harter 2025


from .block_structure import BLOCKNAMES, BLOCKNUMBERS
from .block_parsers cimport BLOCKPARSERS
from .memory cimport Memory, memory_compact, memory_load_from_file, memory_save_to_file, memory_clear
from .parser cimport *


from ctypes import create_string_buffer
from libc.stdint cimport uint16_t, uint8_t, uint64_t
from libc.stdio cimport fread, fdopen, FILE, fseek, SEEK_CUR, ftell, fopen, fclose, SEEK_SET, SEEK_END
from libc.stdlib cimport malloc, free
from libc.string cimport memcpy 
import os
import traceback

cdef struct SeptentrioHeader:
    uint16_t Sync
    uint16_t CRC
    uint16_t ID
    uint16_t Length

"""
def read(path)
def load(fobj)
def parse(bytearray)
def encode(block_data, payload_priority=PAYLOAD_PRIORITY_ONLY_NOT_IMPLEMENTED)

def _parse(Memory *memory, uint8_t *data, size_t length, bint block_on_new_line)

PAYLOAD_PRIORITY_NO_PAYLOAD = -3
PAYLOAD_PRIORITY_ONLY_NOT_IMPLEMENTED = -2
PAYLOAD_PRIORITY_ONLY_ON_FAIL = -1
PAYLOAD_PRIORITY_ALWAYS = 0
"""

def read(path, block_on_new_line=True):
    with open(path, "rb") as fobj:
        for infos in load(fobj, block_on_new_line=block_on_new_line):
            yield infos


def load(fobj, block_on_new_line=True):
    try:
        fileno = fobj.fileno()
    except:
        raise Exception('Could not obtain fileno from file-like object')
    
    cdef FILE * fp = fdopen(fileno, 'rb')
    if fp == NULL:
        raise Exception('File is NULL.')

    cdef Memory memory 
    memory_clear(&memory)

    cdef uint8_t[1000000] buffer
    cdef size_t length = 0

    while True:
        length = fread(&buffer, sizeof(uint8_t), sizeof(buffer), fp)
        if length == 0:
            break
        
        for infos in _parse(&memory, buffer, length, block_on_new_line):
            yield infos
    

def parse(content, block_on_new_line=True):
    cdef Memory memory
    memory_clear(&memory)
    
    # Convert input to bytes if it's not already
    if not isinstance(content, (bytes, bytearray)):
        raise TypeError("Input must be bytes or bytearray")
    
    # Convert to uint8_t array
    data = create_string_buffer(bytes(content), len(content)).raw
    cdef size_t length = len(content)
    
    return _parse(&memory, data, length, block_on_new_line)


cdef list _parse(Memory* memory, uint8_t* data, size_t length, bint block_on_new_line):
    # ------------------------------ Setup memory ------------------------------
    # We assume the max size of one block is 1MB.
    # No input should be more than that since memory can store up to 2MB and the first half can be used by unfinished message.

    if length > 1000000:
        raise Exception("Can't read input longer than 1000000. Please, split it into smaller chunk or increase this limit.")

    cdef list results = []
    
    if memory.length > 1000000:
        memory_compact(memory)

    if memory.length > 1000000:
        # Compacting is not enough. Flushing data.
        results.append(("Unknown", {"blockType": "Unknown", "payload": memory.data[memory.last_decoded:memory.length]}))
        memory_clear(memory)

    # Since data can contain 2MB and we have at most 1MB of existing data and at most 1MB of data to process,
    # we can safely copy the data to the memory.
    memcpy(memory.data + memory.length, data, length)
    memory.length += length

    # ------------------------------ Init parsing ------------------------------
    cdef uint8_t MESSAGE_NONE = 0
    cdef uint8_t MESSAGE_SEND_PREVIOUS = 1
    cdef uint8_t MESSAGE_SEND_SSS = 2
    cdef uint8_t MESSAGE_SEND_SBF = 3
    cdef uint8_t MESSAGE_BAD_SBF = 4
    cdef uint8_t MESSAGE_SEND_NEW_LINE = 5
    cdef uint8_t message_detected = MESSAGE_NONE

    cdef size_t sept_header_LEN = 8 

    cdef uint8_t first_byte
    cdef uint8_t second_byte
    cdef uint8_t header1
    cdef uint8_t header2
    cdef uint16_t blockno

    cdef uint8_t* current_ptr
    cdef uint8_t* unkn_body_ptr
    cdef uint8_t* sept_body_ptr
    cdef SeptentrioHeader sept_header
    sept_body_length = 0
    cdef uint16_t[5] sept_force_msg

    num_name_dict = dict(zip(BLOCKNUMBERS, BLOCKNAMES))
    blockparsers = {
        x: BLOCKPARSERS.get(x)
        for x in set(num_name_dict.viewvalues())
        if x in BLOCKPARSERS.keys()
    }
    if not blockparsers:
        raise Exception("Unable to create parsers")

    blockheaders = {
        9298: "Replie",       # $R
        9300: "Transmission", # $T
        9261: "Description",  # $-
        9254: "Snmp",         # $&

        # correct SBF block with be decoded by a proper function 
        9280: "BadSBF"        # $@
    }

    # -------------------------- Read object ------------------------------
    try:
        while True:
            # ================== Detect header ============================
            if memory.current + 2 > memory.length:
                break
            
            message_detected = MESSAGE_NONE
            current_ptr = <uint8_t*>(memory.data + memory.current)
            header = (current_ptr[0] << 8) + current_ptr[1] # Big-endian
            # memory.current should remain at the beginning of the block and move only before the next iteration.
            
            
            # ------------------ Septentrio SBF ---------------------------
            if header == 9280: # $@
                # Header
                if (memory.current + sept_header_LEN) > memory.length:
                    break

                sept_header = (<SeptentrioHeader*>(current_ptr))[0]

                # Body
                # Check the raw Length before subtracting: the subtraction is
                # unsigned, so a Length below the header size would wrap around.
                if sept_header.Length > sept_header_LEN and sept_header.Length % 4 == 0:
                    sept_body_length = sept_header.Length - sept_header_LEN
                    
                    if (memory.current + sept_header.Length) > memory.length:
                        break

                    sept_body_ptr = <uint8_t*>(current_ptr + sept_header_LEN)
                    if sept_header.CRC == crc16(sept_body_ptr, sept_body_length, crc16( & (sept_header.ID), 4, 0)):
                        message_detected = MESSAGE_SEND_SBF
                    else:
                        message_detected = MESSAGE_BAD_SBF
                
                else:
                    message_detected = MESSAGE_BAD_SBF

            # ------------------- Septentrio force input  -----------------
            elif header == 21331: # SS
                # Read possible force message
                if memory.current + 10 > memory.length:
                    break

                if (<uint64_t*>(current_ptr + 2))[0] == 6004234345560363859:
                    message_detected = MESSAGE_SEND_SSS
                # 6004234345560363859 = SSSS SSSS casted to 64 bit integers. 
                # The 2 first SS have already been checked using header, thence the 10 S

            # ------------------- Septentrio message ----------------------
            elif header == 9298: # $R Replie
                message_detected = MESSAGE_SEND_PREVIOUS
            elif header == 9300: # $T Transmission
                message_detected = MESSAGE_SEND_PREVIOUS
            elif header == 9261: # $- Description
                message_detected = MESSAGE_SEND_PREVIOUS
            elif header == 9254: # $=& Septentrio Snmp 
                message_detected = MESSAGE_SEND_PREVIOUS

            # ------------------- New line      ---------------------------
            elif current_ptr[0] == ord('\n') and block_on_new_line:
                memory.current = memory.current + 1 # Add \n at the end of the message
                message_detected = MESSAGE_SEND_NEW_LINE
    
    
            # ====================== Block handling ===========================
            if message_detected == MESSAGE_NONE:
                memory.current = memory.current + 1
                continue

            # ---------------------- Send previous  ---------------------------
            # In every case when message is detected, send previous message stored in [last_decoded : current]

            size = memory.current - memory.last_decoded
            if size > 0:
                # Read
                unkn_body_ptr = <uint8_t*>(memory.data + memory.last_decoded)
                block_info = bytearray((<char*>unkn_body_ptr)[0:size])

                # Send
                if size < 2:
                    block_type = "Unknown"
                else:
                    # Read first two bytes and combine them in big-endian format
                    first_byte = unkn_body_ptr[0]
                    second_byte = unkn_body_ptr[1]
                    previous_header = (first_byte << 8) + second_byte  # Big-endian
                    block_type = blockheaders.get(previous_header, "Unknown")

                results.append((block_type, {
                    "blockType":block_type,
                    "payload": block_info
                }))

            # ----------------------- Send Message       --------------------------

            if message_detected == MESSAGE_SEND_SSS:
                results.append(("ForceInput", {
                    "blockType":"ForceInput",
                    "payload": bytearray("SSSSSSSSSS", encoding="ascii")
                }))
                
                memory.current = memory.current + 10
                memory.last_decoded = memory.current


            elif message_detected == MESSAGE_SEND_SBF:
                blockno = sept_header.ID & 0x1fff
                block_name = num_name_dict.get(blockno, 'Unknown')
                parser_func = blockparsers.get(block_name, None)

                if parser_func is None:
                    block_dict = {}
                    block_dict['blockType'] = "RawSBF"

                else:
                    block_dict = parser_func(( <char*>sept_body_ptr)[0:sept_body_length])
                    block_dict['blockType'] = "SBF"
                    
                block_dict['blockName'] = block_name
                    
                # Create binary payload containing header and body
                header_bytes = bytearray((<char*>&sept_header)[0:sept_header_LEN])
                body_bytes = bytearray((<char*>sept_body_ptr)[0:sept_body_length])

                block_dict['payload'] = header_bytes + body_bytes
                    
                results.append((block_name, block_dict))

                memory.current = memory.current +  sept_header.Length
                memory.last_decoded = memory.current


            elif message_detected == MESSAGE_SEND_NEW_LINE:
                memory.last_decoded = memory.current
                # memory.current = memory.current + 1
                # Don't increment since we have it already incremented to include \n at the end of the message


            else: # BAD_SBF, SEND_PREVIOUS
                memory.last_decoded = memory.current
                memory.current = memory.current + 1
                # We have encounter a new message without specific handling.
                # We have already send the previous message, we can read next char



    except Exception as e:
        print("Error load:", e)
        traceback.print_exc()
    
    return results







# Class wrapper, provides a memory between calls 

cdef class SbfParser:
    cdef Memory memory

    def __init__(self):
        memory_clear(&self.memory)

    def load_memory(self, path):
        """Load memory state from a file"""
        cdef FILE * fp
        if not os.path.exists(path):
            raise FileNotFoundError(f"Memory file not found: {path}")
        
        with open(path, 'rb') as fobj:
            try:
                fileno = fobj.fileno()
            except:
                raise Exception('Could not obtain fileno from file-like object')
            
            fp = fdopen(fileno, 'rb')
            if fp == NULL:
                raise Exception('File is NULL.')
            
            error_code = memory_load_from_file(&self.memory, fp)
            if error_code:
                raise IOError(f"Failed to load memory from file (error_code: {error_code})")


    def save_memory(self, path):
        """Save current memory state to a file"""
        cdef FILE * fp 

        with open(path, 'wb+') as fobj:
            try:
                fileno = fobj.fileno()
            except:
                raise Exception('Could not obtain fileno from file-like object')
            
            fp = fdopen(fileno, 'wb')
            if fp == NULL:
                raise Exception('File is NULL.')
            
            error_code = memory_save_to_file(&self.memory, fp)
            if error_code:
                raise IOError(f"Failed to save memory to file (error code: {error_code})")


    def clear_memory(self):
        """Clear the memory state"""
        memory_clear(&self.memory)


    def memory_infos(self):
        print(f"Memory(length={self.memory.length}, current={self.memory.current}, last_decoded={self.memory.last_decoded})")


    def read(self, path, block_on_new_line=True):
        """Read and parse SBF data from a file"""
        with open(path, "rb") as fobj:
            for infos in self.load(fobj, block_on_new_line=block_on_new_line):
                yield infos


    def load(self, fobj, block_on_new_line=True):
        """Load and parse SBF data from a file-like object"""
        cdef FILE * fp 
        cdef uint8_t[1000000] buffer
        cdef size_t length_read = 0

        # Open file
        try:
            fileno = fobj.fileno()
        except:
            raise Exception('Could not obtain fileno from file-like object')
        
        fp = fdopen(fileno, 'rb')
        if fp == NULL:
            raise Exception('File is NULL.')

        # Read file by chunk
        while True:
            length_read = fread(&buffer, sizeof(uint8_t), sizeof(buffer), fp)
            if length_read == 0:
                break
            
            for infos in _parse(&self.memory, buffer, length_read, block_on_new_line):
                yield infos
        

    def parse(self, content, block_on_new_line=True):
        """Parse SBF data from bytes or bytearray"""

        # Convert input to bytes if it's not already
        if not isinstance(content, (bytes, bytearray)):
            raise TypeError("Input must be bytes or bytearray")
        
        # Convert to uint8_t array
        data = create_string_buffer(bytes(content), len(content)).raw
        cdef size_t length = len(content)
        
        for i in range(0, length, 1000000):
            for infos in self._parse(data[i:i+1000000], block_on_new_line):
                yield infos

    def _parse(self, content, block_on_new_line=True):
        """Should be called only on content with length < 1000000"""

        # Convert to uint8_t array
        data = create_string_buffer(bytes(content), len(content)).raw
        cdef size_t length = len(content)
        
        for infos in _parse(&self.memory, data, length, block_on_new_line):
            yield infos
