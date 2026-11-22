from pathlib import Path
import sys
prefix = '/*'+'x'*8192+'*/\n'
body = 'int seed;\n#define VALUE 1 '+chr(92)+'\n/* first physical comment line\n'+(' inside comment\n'*1300)+'*/ + 2\nint value=VALUE;\n'
raw=(prefix+body).encode()
pad=(1<<20)-len(raw)
Path(sys.argv[1]).write_bytes(raw+b' '*int(pad-1)+b'\n')
