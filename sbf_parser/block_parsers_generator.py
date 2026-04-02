# Created by Louis-Max Harter 2025
from typing import List, Tuple
import os

def get_c_type_conversion(struct_name: str, field_name: str, type_: str) -> str:
    """
    Convert C struct field to Python with special type handling.
    
    Args:
        struct_name: Name of the C struct variable (e.g., 'sb0')
        field_name: Name of the field in the struct
        type_: C type of the field (e.g., 'u1', 'f4', 'u1[16]', 'u1[N]')
    
    Returns:
        String representing the Python conversion
    """
    # Handle array types
    if '[' in type_:
        base_type, size = type_.split('[')
        size = size.rstrip(']')

        multiplier = int(base_type[-1])

        if multiplier is None:
            print(f"Multiplier not found for {base_type} part of {type_} for {struct_name}")
        
        # Handle dynamic size (N, PRNMask, or int)
        if size.isdigit():
            size = int(size) * multiplier
        else:
            size = f"{struct_name}.{size}"
            if multiplier > 1:
                size += f" * {multiplier}"

        # Convert array to Python list
        return f"(<c1*>&{struct_name}.{field_name})[0:{size}]"
    
    return f"{struct_name}.{field_name}"

# Read blocks.py content
with open(os.path.join(os.path.dirname(__file__), 'block_structure.py'), 'r') as f:
    blocks_content = f.read()

# Create a namespace for eval and execute the entire file
blocks_namespace = {}
exec(blocks_content, blocks_namespace)

# Get BLOCKNAMES from the namespace
BLOCKNAMES = blocks_namespace['BLOCKNAMES']

SUB_BLOCK_HANDLERS = {
    "MeasExtra": ("MeasExtraChannel", "MeasExtraChannelSub"),
    "ReceiverStatus": ("AGCState", "ReceiverStatus_AGCState"),
    "BaseVectorCart": ("VectorInfoCart", "BaseVectorCart_VectorInfoCart"),
    "BaseVectorGeod": ("VectorInfoGeod", "BaseVectorGeod_VectorInfoGeod"),
    "GEOFastCorr": ("FastCorr", "GEOFastCorr_FastCorr"),
    "GEOIonoDelay": ("IDC", "GEOIonoDelay_IDC"),
    "GEOServiceLevel": ("ServiceRegion", "GEOServiceLevel_ServiceRegion"),
    "GEOClockEphCovMatrix": ("CovMatrix", "GEOClockEphCovMatrix_CovMatrix"),
    "LBandTrackerStatus": ("TrackData", "LBandTrackerStatus_TrackData"),
    "GISStatus": ("DatabaseStatus", "DatabaseStatus"),
    "InputLink": ("InputStats", "InputLink_InputStats"),
    "RFStatus": ("RFBand", "RFBand"),
    "SatVisibility" : ("SatInfo", "SatVisibility_SatInfo"),
    "NTRIPClientStatus" : ("NTRIPClientConnection", "NTRIPClientConnection"),
    "NTRIPServerStatus" : ("NTRIPServerConnection", "NTRIPServerConnection"),
    "DiskStatus" : ("DiskData", "DiskData"),
    "P2PPStatus" : ("P2PPSession", "P2PPSession"),
    "MeasEpoch": ("Type_1", "MeasEpoch_Type_1"),
    "MeasEpoch_Type_1": ("Type_2", "MeasEpoch_Type_2"),
    "ChannelStatus": ("SatInfo", "ChannelStatus_ChannelSatInfo"),
    "ChannelStatus_ChannelSatInfo": ("StateInfo", "ChannelStatus_ChannelStateInfo"),
    "ISMR": ("ISMRChannel", "ISMRChannel"),

    # This block/sub-block needs nested Reserved array handling
    # You can make a PR for support or contact Septentrio for support.
    # "OutputLink": ("OutputStats", "OutputLink_OutputStats"),
    # "OutputLink_OutputStats": ("OutputType", "OutputLink_OutputType"),
}

def get_block_structure(block_name: str) -> List[Tuple[str, str]]:
    """Get the structure of a block from the blocks namespace."""
    block = blocks_namespace.get(block_name)
    if block is None:
        raise ValueError(f"Block {block_name} not found in blocks.py")
    return block

def generate_parser_function(block_name: str) -> str:
    """Generate a Cython parser function for a block structure."""
    # Function signature
    code = f"def {block_name}_toDict(c1 * data):\n"
    code += f"    cdef {block_name} * sb0 = <{block_name} *>data\n\n"
    
    # Create dictionary for main block
    code += "    block_dict = {\n"
    fields = get_block_structure(block_name)
    for name, type_ in fields:
        conversion = get_c_type_conversion('sb0', name, type_)
        code += f"        '{name}': {conversion},\n"
    code += "    }\n\n"
    
    # Handle sub-blocks if present
    if block_name in SUB_BLOCK_HANDLERS.keys():
        sub_block_key, sub_block_class = SUB_BLOCK_HANDLERS[block_name]
        has_sub_sub_block = sub_block_class in SUB_BLOCK_HANDLERS.keys()
        sb0_n = "sb0.N1" if has_sub_sub_block and block_name != "ChannelStatus" else "sb0.N"
        sb0_sblength = "sb0.SB1Length" if has_sub_sub_block else "sb0.SBLength"
        
        code += f"    sub_block_list = []\n"
        code += f"    cdef {sub_block_class} subblock\n"
        code += f"    cdef size_t i = sizeof({block_name})\n"
        if has_sub_sub_block:
            sub_sub_block_key, sub_sub_block_class = SUB_BLOCK_HANDLERS[sub_block_class]
            code += f"    cdef {sub_sub_block_class} subsubblock\n"
        code += f"    for _ in xrange({sb0_n}):\n"
        code += f"        subblock = (<{sub_block_class}*>(data + i))[0]\n"
        code += f"        i += {sb0_sblength}\n\n"
        code +=  "        sub_block_dict = {\n"

        # Get sub-block fields from the block structure
        sub_block_fields = get_block_structure(sub_block_class)
        for name, type_ in sub_block_fields:
            conversion = get_c_type_conversion('subblock', name, type_)
            code += f"            '{name}': {conversion},\n"
        code += "        }\n"

        # Handle sub-sub-blocks if present
        if has_sub_sub_block:
            code += f"        sub_sub_block_list = []\n"
            code += f"        for _ in xrange(subblock.N2):\n"
            code += f"            subsubblock = (<{sub_sub_block_class}*>(data + i))[0]\n"
            code += f"            i += sb0.SB2Length\n\n"
            code +=  "            sub_sub_block_list.append({\n"

            # Get sub-block fields from the block structure
            sub_sub_block_fields = get_block_structure(sub_sub_block_class)
            for name, type_ in sub_sub_block_fields:
                conversion = get_c_type_conversion('subsubblock', name, type_)
                code += f"                '{name}': {conversion},\n"
            code += "            })\n"
            code +=f"        sub_block_dict['{sub_sub_block_key}'] = sub_sub_block_list\n"

        code += "        sub_block_list.append(sub_block_dict)\n"

        code += f"    block_dict['{sub_block_key}'] = sub_block_list\n\n"
    
    code += "    return block_dict\n\n"
    code += f"BLOCKPARSERS['{block_name}'] = {block_name}_toDict\n\n"
    return code

def generate_all_parsers() -> str:
    """Generate parser functions for all blocks in BLOCKNAMES."""
    code = """# type: ignore 
# Initial code by Jashandeep Sohi (2013, jashandeep.s.sohi@gmail.com)
# adapted by Marco Job (2019, marco.job@bluewin.ch)
# Update Meven Jeanne-Rose 2023
# Update Louis-Max Harter 2025
# Update Loïc Dubois 2025

from libc.stdint cimport uint8_t, uint16_t, uint32_t, uint64_t, int8_t, int16_t, int32_t, int64_t
from libc.stdlib cimport free, malloc

# Import all type definitions from the .pxd file
from .block_parsers cimport *

cdef dict BLOCKPARSERS = dict()

def unknown_toDict(c1 * data):
    block_dict = dict()
    block_dict['payload'] = data
    return block_dict
BLOCKPARSERS['Unknown'] = unknown_toDict

"""
    
    for block_name in BLOCKNAMES:
        try:
            code += generate_parser_function(block_name)
        except ValueError as e:
            print(f"Warning: {e}")
            continue
    
    return code

if __name__ == "__main__":
    # Generate parser functions for blocks
    parser_code = generate_all_parsers()
    
    # Write to file
    with open("block_parsers.pyx", "w") as f:
        f.write(parser_code)
