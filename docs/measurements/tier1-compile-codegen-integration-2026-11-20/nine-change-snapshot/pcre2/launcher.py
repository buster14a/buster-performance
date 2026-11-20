import os,sys
from pathlib import Path
# CMake identifies the pinned Clang toolchain and links its binaries. Each ordinary source compile in the
# Buster builds passes through the Buster driver with the exact preprocessor, dependency and output options.
compiler,*args=sys.argv[1:]
if args and not args[0].startswith('-'):
    cc,*args=args
else:raise ValueError(args)
args=[arg for arg in args if arg != '-fvisibility=hidden']
if '-c' in args and compiler!='reference':
    os.execv(compiler,[compiler,'--tier1','--lanes','1','-march=znver5','-w',*args])
os.execv(cc,[cc,*args])
