import sys,subprocess,tempfile,os,csv,json,hashlib
from pathlib import Path
from measure import args,d
policy=os.getenv('BUSTER_CHECK_COLUMN_POLICY','plain');options={'plain':[],'poison':['--poison-arenas'],'transitions':['--check-transitions'],'debug':['-g'],'deferred':['--deferred-bodies']}[policy]
for c in sys.argv[1:]:
 with tempfile.TemporaryDirectory() as tmp,(d/('native-columns-'+(policy+'-' if policy!='plain' else '')+c+'.tsv')).open('w',buffering=1) as out:
  w=csv.writer(out,delimiter='\t',lineterminator='\n');w.writerow('case compiler nodes types payloads arguments scalar_nodes vector_nodes column sha256'.split());ref=None
  for cc in ('base','blocks','arity','condition'):
   extra=['-ex','set $leaf_g=graph','-ex','set $leaf_t=types','-ex','set $leaf_s=stream','-ex','finish','-ex','source '+str(d/'checked.gdb.py')]
   aa=args(c) if c in ('sqlite','lua','musl','self') else [d/(c+'.c')]
   p=subprocess.run(['gdb','-nx','-nh','--batch','-ex','set debuginfod enabled off','-ex','set print thread-events off','-ex','set multiple-symbols all','-ex','break check_graph_run','-ex','run',*extra,'--args',str(d/('native-'+cc)),'--lanes','1',*options,'-c',*aa,'-o',Path(tmp)/'r.o'],capture_output=True,env=dict(os.environ,DEBUGINFOD_URLS=''));s=(p.stdout+p.stderr).decode();rec=[v[8:] for v in s.splitlines() if v.startswith('RECEIPT ')];assert len(rec)==1,(c,cc,s[-1300:]);v=json.loads(rec[0]);assert ref is None or ref==v,(c,cc,[(k,ref['columns'].get(k),v['columns'].get(k)) for k in ref['columns'] if ref['columns'].get(k)!=v['columns'].get(k)],{k:v[k] for k in v if k!='columns'});ref=v
   w.writerows([c,cc,v['nodes'],v['types'],v['payloads'],v['arguments'],v['scalar'],v['vector'],k,h] for k,h in v['columns'].items())
