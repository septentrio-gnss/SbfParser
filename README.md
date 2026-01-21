<div align="center">
  <img src="https://github.com/septentrio-gnss/SbfParser/blob/master/sbf_parser_white.png" alt="SBF Parser Logo">
</div>

# SbfParser
A Python module to parse output of Septentrio receiver, including Septentrio Binary Format (SBF) & more !

This project is an update of [PySbf](https://github.com/jashandeep-sohi/pysbf) made by [Jashandeep-Sohi](https://github.com/jashandeep-sohi) & [Nodd](https://github.com/Nodd) and [SbfParser](https://github.com/MJeanneRose/sbfParser) made by [MJeanneRose](MJeanneRose). 

### Install

Using `pip` :
```bash
pip install sbf-parser
```

From source :
```bash
pip install -e .
```

## Release Notes

* 2x faster than [SbfParser](https://github.com/MJeanneRose/sbfParser) (12mo/s)
* Parsing based on SBF v4.14.10.1, including more than 35 blocks
* Can encode sbf message
* Lossless decoding, get raw binary of decoded messages

## Usage
### Parsing input stream

You have many examples in `example` directory :
- Decoding input streaming : `decode.py`, `decode_with_memory.py`
- Save parser state between calls : `memory_manipulation.py`
- Encoding of sbf blocks : `create_complex_block.py`, `create_simple_block.py`
And somes tools in `utils`
- Split sbf files : `split_sbf_file.py`
- Re-order sbd time of week : `replace_header_time.py`
- Speed benchmark : `benchmark.py`
- Compare result of SbfParser with Septentrio sbf2ascii : `comapre_with_ascii.py`

```python
import serial
from sbf_parser import SbfParser, load

# Open your files 
with open("sbf_files/log_0000.sbf", "rb") as fobj:
    for block_type, infos in load(fobj):
        print(block_type, infos)


# or read directly from serial connection
parser = SbfParser()
ser = serial.Serial(
    port='COM5', baudrate=115200,\
    parity=serial.PARITY_NONE,\
    stopbits=serial.STOPBITS_ONE,\
    bytesize=serial.EIGHTBITS,\
)

while True:
    for binary in ser.read(100):
        for block_type, infos in parser.parse(binary):
            print(block_type, infos)
```

You can call `read(path)`, `load(fobj)` or `parse(binary)`, directly or with SbfParser to use memory between calls.
`infos` use this structure for SBF block:
```
{
    'TOW': 49638143, 
    'WNc': 2368, 
    .... 
    'AGCState': [
        {'FrontendID': 1, 'Gain': 2, 'SampleVar': 4, 'BlankingStat': 8}, 
        {'FrontendID': 16, 'Gain': 32, 'SampleVar': 64, 'BlankingStat': 128}
    ], 
    
    'blockName': 'ReceiverStatus',
    'blockType': 'SBF',
    'payload': bytearray(b'$@.......')
}
```

`block_type` can be etheir, the name of the SBF block or `"Replie"`, `"Transmission"`, `"Description"`, `"Snmp"`, `"BadSBF"`.

### Encode block

Encode a basic block; for more examples, check `example.py` (block with sub-block or working with files).

```python
from sbf_parser import encode
    
event_block = {
    'TOW': 123456789,  # Time of Week in milliseconds
    'WNc': 2120,       # Week number (continuous)
    'Source': 1,       # Source identifier
    'Polarity': 0,     # Polarity (0 = rising edge)
    'Offset': 0.005,   # Time offset in seconds
    'RxClkBias': 0.0,  # Receiver clock bias
    'PVTAge': 0,        # Age of PVT in ms

    'BlockType':'SBF',
    'BlockName':'ExtEvent'
}

block_bytes = encode(event_block)

with open('ext_event.sbf', 'wb') as f:
    f.write(block_bytes)
```

If you don't modify block, `payload` is the original binary representation of the block from the parser.
You can set `payload_priority` of `encode` to theses values :
```python
PAYLOAD_PRIORITY_ALWAYS = 0 # Use payload has soon we have one
PAYLOAD_PRIORITY_ONLY_ON_FAIL = -1 # Use payload for not implemented block and when encoding failed
PAYLOAD_PRIORITY_ONLY_NOT_IMPLEMENTED = -2 # Use payload only for not implemented block
PAYLOAD_PRIORITY_NO_PAYLOAD = -3 # Never use payload
```

## Utils
You can also use some script in `utils/` to edit your sbf files :
- `split_sbf_file` : Split Sbf file using two `TOW`
- `replace_herder_time` : Change the value of `TOW`, usefull when your receiver is not connected to satellites during recording
- `benchmark` : If you want to stress test SbfParser
- `compare_with_ascii` : Compare Sbf block with ascii given by RxTools

## FAQ

### Can I call sbf parser from C/C++ project ?

Cython allows you to call cdef functions directly from C.
You may need to make minor changes to `_parse` function from `parser.pyx` to make it accessible from C, check [this tutorial](https://cython.readthedocs.io/en/latest/src/userguide/external_C_code.html).

### Why this code is faster even if it has more feature ?

[SbfParser](https://github.com/MJeanneRose/sbfParser) was using `fread` to parse block from files, whereas this project loads the file directly into memory and casts the blocks in the correct structure rather than reading them.

### Can I read a block larger than 1 MB ?

The actual implementation uses a structure `memory` with a `uint_8[1000000]` buffer, hence the limits of 1 MB. If needed, you can fork this project and increase this memory; otherwise, larger blocks will be split in smaller `unknown` blocks. 

For your information, large sbf blocks can be up to `4096` bytes.



