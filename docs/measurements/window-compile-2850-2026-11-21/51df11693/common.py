from pathlib import Path
import os
D=Path(__file__).resolve().parent;W=D.parent;CC=W/'source-operand-proof/build/compiler';PRIOR=W/'native-source-facts-study/compiler';ROOT=W/'switch-inputs'
src=str(ROOT)+'/../pregraph-warning-study/compiler-source'
args={'sqlite':['-DSQLITE_OMIT_LOAD_EXTENSION','-DSQLITE_THREADSAFE=0','-DSQLITE_ENABLE_MEMSYS5','-DSQLITE_ENABLE_RTREE','-I'+str(ROOT/'sqlite'),str(ROOT/'sqlite/sqlite3.c')],
      'main':['-march=native','-I'+src+'/src','-fwrapv','-funsigned-char','--predefines',str(ROOT)+'/../proof-predefines.h',src+'/src/buster/compiler/main.c']}
env={k:v for k,v in os.environ.items() if not k.startswith(('BUSTER_CONTROL_','BUSTER_SOURCE_','BUSTER_CHECK_BODY_','BUSTER_CHECK_SOURCE_DECLARATIONS','BUSTER_BODY_'))}
native={'BUSTER_CONTROL_SOURCE_NATIVE':'1'}
producer={'BUSTER_SOURCE_ARITHMETIC':'1'}
audit={'BUSTER_SOURCE_ARITHMETIC_AUDIT':'1','BUSTER_CONTROL_SOURCE_AUDIT':'1'}
local={'BUSTER_CHECK_BODY_SOURCE_ONLY':'1','BUSTER_CHECK_BODY_ADMIT_ALL':'1'}
def fingerprints(raw,mode):
 out={}
 for line in raw.splitlines():
  if line.startswith(('body-'+mode+'-row\t').encode()):
   _,close,n,h=line.split(b'\t');key=int(close);assert key not in out;out[key]=(int(n),h.decode())
 return out
