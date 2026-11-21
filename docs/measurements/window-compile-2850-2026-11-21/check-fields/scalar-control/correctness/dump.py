from pathlib import Path
import subprocess,hashlib,sys,tempfile,csv,os,re,itertools,collections
from measure import args,d
modes=sys.argv[1:] or ['base','blocks','arity'];dut='-'.join(modes[1:]);ref_exe='native-'+modes[0]
def sha(f):return hashlib.file_digest(f.open('rb'),'sha256').hexdigest() if f.exists() else '-'
with tempfile.TemporaryDirectory() as tmp,(d/('typed-'+dut+'.tsv')).open('w',buffering=1) as out:
 tmp=Path(tmp);o=tmp/'r.o';dump=tmp/'typed';w=csv.writer(out,delimiter='\t',lineterminator='\n');w.writerow('case compiler nodes values value_runs_ge2_nodes value_runs_ge4_nodes conditions same_bytes_as_reference typed_dump_sha256 diagnostics_sha256 object_sha256'.split())
 for c in ('sqlite','lua','musl','self','conditions'):
  aa=args(c) if c!='conditions' else [d/'conditions.c'];ref=None;nvals=n2=n4=conds=nodes=0
  for m in modes:
   o.unlink(missing_ok=True)
   with dump.open('wb') as handle:p=subprocess.run([d/('native-'+m),'--lanes','1','--dump-typed','-c',*aa,'-o',o],stdout=handle,stderr=subprocess.PIPE)
   assert p.returncode==0,(c,m,p.stderr[:150]);z=(sha(dump),hashlib.sha256(p.stderr).hexdigest(),sha(o))
   if ref is None:
    ref=z
    with dump.open('rb') as f:ops=[int(r[1]) for line in f if (r:=re.match(rb'^\d+ token=\d+ op=(\d+) ',line))]
    runs=collections.Counter(sum(1 for _ in g) for k,g in itertools.groupby(ops) if k==0)
    nodes=len(ops);nvals=ops.count(0);n2=sum(k*v for k,v in runs.items() if k>=2);n4=sum(k*v for k,v in runs.items() if k>=4);conds=ops.count(37);assert nodes>0
   assert ref==z,(c,m,ref,z);w.writerow([c,m,nodes,nvals,n2,n4,conds,1,*z])
