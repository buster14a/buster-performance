from pathlib import Path
import os,sys
requested,clang,*args=sys.argv[1:]
# All three static builds use the same non-PIC flags. The option for unused driver arguments is Clang-specific.
args=[a for a in args if a not in ('-Qunused-arguments','-fPIC')]
if requested!='reference' and '-c' in args and any(a.endswith('.c') for a in args):
 os.execv(requested,[requested,'--tier1','--lanes','1','-w',*args])
os.execv(clang,[clang,*args])
