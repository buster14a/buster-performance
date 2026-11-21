from pathlib import Path
from measure import d,args,compile_one
import csv,hashlib,struct,subprocess,tempfile,os
with (d/'semantic.tsv').open('w',buffering=1) as out,tempfile.TemporaryDirectory() as tmp:
 w=csv.writer(out,delimiter='\t',lineterminator='\n');w.writerow('policy case variant status nodes fresh types payloads scalar_nodes vector_nodes block_hits arity_hits condition_hits full_graph_sha256 diagnostics_sha256 object_sha256'.split());o=Path(tmp)/'r.o';g=Path(tmp)/'r.bin'
 for pol,opts in {'plain':[],'warnings':['-Wall','-Wextra'],'debug':['-g'],'poison':['--poison-arenas'],'transitions':['--check-transitions']}.items():
  for c in ('sqlite','lua','musl','self','clean','warnings','rejected','conditions'):
   aa=args(c) if c in ('sqlite','lua','musl','self') else [d/(c+'.c')];reference=None
   for name,sel in [('reference',{}),('blocks',{'LEAF_BLOCKS':'1'}),('arity',{'LEAF_ARITY':'1'}),('condition',{'LEAF_CONDITION':'1'}),('combined',{'LEAF_BLOCKS':'1','LEAF_ARITY':'1','LEAF_CONDITION':'1'})]+([('omit-leaf-conversion',{'LEAF_BLOCKS':'1','LEAF_MUTATE':'1'}),('omit-condition-flags',{'LEAF_CONDITION':'1','LEAF_MUTATE_FLAGS':'1'}),('omit-live-conversions',{'LEAF_ARITY':'1','LEAF_MUTATE_ARITY':'1'})] if pol=='plain' and c=='sqlite' else []):
    hits=Path(tmp)/'hits';hits.unlink(missing_ok=True);g.unlink(missing_ok=True);r=compile_one(d/'oracle',[*opts,*aa],o,dict(os.environ,CHECKED_LEAF_ORACLE=str(g),CHECKED_LEAF_HITS=str(hits),**sel));diag=hashlib.sha256(r[1]+r[2]).hexdigest()
    if g.exists():
     with g.open('rb') as stream: head=struct.unpack('<9I',stream.read(36));stream.seek(0);h=hashlib.file_digest(stream,'sha256').hexdigest()
     n,fresh,nargs,types,payloads,scalar,vec,_,_=head
    else:n=fresh=types=payloads=scalar=vec=0;h='-'
    if name=='reference':reference=(h,r)
    elif name.startswith('omit-'):assert h!='-' and h!=reference[0],(name,c,pol)
    else:assert (h,r)==reference,(pol,c,name,reference[0],h,reference[1][0],r[0],reference[1][3],r[3])
    w.writerow([pol,c,name,r[0],n,fresh,types,payloads,scalar,vec,*(hits.read_text().split() if hits.exists() else [0,0,0]),h,diag,r[3]])
tpath=Path(os.environ['BUSTER_CHECK_TEST_SOURCE'])
toolchain=Path(os.environ['BUSTER_CHECK_TOOLCHAIN'])
with (d/'barrier-shard.tsv').open('w',buffering=1) as out:
 w=csv.writer(out,delimiter='\t',lineterminator='\n');w.writerow(['route','part','status','summary'])
 for route,sel in [('parent',{}),('combined',{'LEAF_BLOCKS':'1','LEAF_CONDITION':'1','LEAF_ARITY':'1'})]:
  log=d/('barrier-'+route+'.log')
  with log.open('wb') as f:p=subprocess.run([d/'oracle','test-checker','--seed','133','--part','1/8'],cwd=tpath,env=dict(os.environ,PATH=str(toolchain)+':'+os.environ['PATH'],**sel),stdout=f,stderr=subprocess.STDOUT)
  summary=log.read_text(errors='replace').splitlines()[-1];w.writerow([route,'1/8',p.returncode,summary]);assert p.returncode==0,(route,summary)
