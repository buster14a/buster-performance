import sys,subprocess,tempfile,os,csv,json
from pathlib import Path
from measure import args,d
with tempfile.TemporaryDirectory() as tmp,(d/'native-entry.tsv').open('w',buffering=1) as out:
 w=None
 for c in ('sqlite','lua','musl','self'):
  f=Path(tmp)/'r.o'
  p=subprocess.run(['gdb','-nx','-nh','--batch','-ex','set debuginfod enabled off','-ex','set print thread-events off','-ex','set multiple-symbols all','-ex','break check_graph_leaf_blocks','-ex','run','-ex','source '+str(d/'entry.gdb.py'),'--args',str(d/'native-blocks'),'--lanes','1','-c',*args(c),'-o',f],capture_output=True,env=dict(os.environ,DEBUGINFOD_URLS=''));s=(p.stdout+p.stderr).decode();rec=[line[4:] for line in s.splitlines() if line.startswith('OBS ')];assert len(rec)==1,(c,s[-850:]);v=json.loads(rec[0]);v['case']=c
  if w is None:w=csv.DictWriter(out,['case',*[k for k in v if k!='case']],delimiter='\t',lineterminator='\n');w.writeheader()
  w.writerow(v)
