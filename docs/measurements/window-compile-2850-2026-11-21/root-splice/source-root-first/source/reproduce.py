from pathlib import Path
import subprocess,os,sys,hashlib
cc=Path(sys.argv[1]).resolve(); sqlite=Path(sys.argv[2]).resolve(); out=Path(sys.argv[3]).resolve(); out.mkdir(parents=True,exist_ok=True)
args=['-DSQLITE_OMIT_LOAD_EXTENSION','-DSQLITE_THREADSAFE=0','-DSQLITE_ENABLE_MEMSYS5','-DSQLITE_ENABLE_RTREE','-I'+str(sqlite),str(sqlite/'sqlite3.c')]
features={k:'1' for k in ('NODE_PROOF_NO_FP','NODE_PROOF_POINTERS','NODE_PROOF_CALLS','NODE_PROOF_NATIVE','NODE_SOURCE_ROWS','NODE_SPLICE_FRONT','NODE_SPLICE_REPORT')}
for debug in (False,True):
 d=out/('debug' if debug else 'default');d.mkdir(exist_ok=True)
 for mode in ('plain','original','full'):
  env=dict(os.environ) if mode=='plain' else dict(os.environ,**features)
  if mode=='full':env.update(NODE_SOURCE_COMPACT='1',NODE_SOURCE_COMPACT_FULL='1',NODE_SOURCE_COMPACT_REPORT='1')
  if mode=='original':env.update(NODE_SPLICE_ENABLE='1')
  env['NODE_SOURCE_GRAPH_ORACLE']=str(d/(mode+'.bin'))
  if not debug:env['NODE_SOURCE_NATIVE_ORACLE']=str(d/(mode+'.native'))
  with (d/(mode+'.err')).open('wb') as log:
   subprocess.run([str(cc),'--lanes','1',*(['-g'] if debug else []),'-c',*args,'-o',str(d/(mode+'.o'))],env=env,stderr=log,check=True)
 subprocess.run([sys.executable,str(Path(__file__).with_name('graph_check.py')),str(d),'plain','full','original'],check=True)
 assert (d/'plain.o').read_bytes()==(d/'full.o').read_bytes()
 if not debug:assert (d/'plain.native').read_bytes()==(d/'full.native').read_bytes()
