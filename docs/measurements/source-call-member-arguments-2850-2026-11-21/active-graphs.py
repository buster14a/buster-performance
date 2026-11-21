import os
import csv,os,shlex,subprocess,sys,tempfile,json
from pathlib import Path
d=Path(os.environ.get("BUSTER_CASE_DIR",Path(__file__).resolve().parent)).resolve();cc=Path(sys.argv[1]).resolve()
flags={key:[arg for arg in shlex.split(args) if not arg.endswith('.c')] for key,args in zip(['sqlite','lua','musl','buster'],sys.argv[2:6])}
active=[r for r in csv.DictReader((d/'corpus.tsv').open(),delimiter='\t') if r['policy']=='default' and int(r['sites'])>0]
with (d/'active-graphs.jsonl').open('w',buffering=1) as dst:
 for r in active:
  with tempfile.TemporaryDirectory(dir=d) as scratch:
   tmp=Path(scratch);src=r['source'];name=r['corpus']
   for mode in ['base','arrow']:
    env=dict(os.environ,BUSTER_WINDOW_CALL_LOG='1',NODE_SOURCE_NATIVE_ORACLE=str(tmp/(mode+'.native')),NODE_SOURCE_GRAPH_ORACLE=str(tmp/(mode+'.graph')),BUSTER_CALL_REFERENCES=str(tmp/(mode+'.refs')))
    if mode=='arrow':env['BUSTER_CALL_ARROW']='1'
    with (tmp/(mode+'.log')).open('wb') as err:
     subprocess.run([cc,'--lanes','1','--node-window-calls','-c',*flags[name],src,'-o',tmp/(mode+'.o')],env=env,stderr=err,check=True)
   cmp=json.loads(subprocess.check_output([sys.executable,Path(__file__).resolve().parent/'compare-arrow.py',tmp]))
   print(json.dumps(dict(corpus=name,source=src,comparison=cmp),sort_keys=True),file=dst)
