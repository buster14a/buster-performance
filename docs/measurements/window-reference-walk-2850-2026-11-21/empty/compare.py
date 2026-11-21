from pathlib import Path
import csv,subprocess,tempfile,os,hashlib,sys
d=Path(__file__).resolve().parent;cc=Path(os.environ['BUSTER_COMPILER']).resolve();out=d/'proof';out.mkdir(exist_ok=True)
def h(f):return hashlib.sha256(f.read_bytes()).hexdigest() if f.exists() else '-'
flags=[];src=[];arg=False
for v in sys.argv[2:]:
 if not arg and v.endswith('.c'):src.append(v)
 else:flags.append(v)
 arg=v in ('--predefines','-include','-I','-isystem')
assert src
with (out/(sys.argv[1]+'.tsv')).open('w',buffering=1) as t,tempfile.TemporaryDirectory(dir=d) as temp:
 w=csv.writer(t,delimiter='\t',lineterminator='\n');w.writerow(['source','mode','same','status','elf','references','diagnostics','nodes','neutral'])
 for tag,extra in [('plain',[]),('debug',['-g']),('warnings',['-Wall','-Wextra'])]:
  for file in src:
   receipts=[]
   for variant in ['off','on']:
    f=Path(temp)/'file.o';q=Path(temp)/'refs';q.unlink(missing_ok=True);f.unlink(missing_ok=True)
    env=dict(os.environ,NODE_REF_ORACLE=str(q))
    env.pop('NODE_REF_REPORT',None);env.pop('NODE_REF_WINDOW',None)
    if variant=='on':env.update(NODE_REF_WINDOW='1',NODE_REF_REPORT='1')
    r=subprocess.run([str(cc),'--lanes','1','-c',*flags,*extra,file,'-o',str(f)],capture_output=True,env=env,timeout=120)
    proof=[l for l in r.stderr.splitlines() if l.startswith(b'reference-proof ')]
    err=b''.join(l for l in r.stderr.splitlines(True) if not l.startswith(b'reference-proof '))
    receipts.append((r.returncode,h(f),h(q),hashlib.sha256(err).hexdigest(),r.stdout))
   a,b=receipts
   fields=[sum(int(l.split()[i].split(b'=')[1]) for l in proof) for i in (1,2)]
   w.writerow([file,tag,int(a==b),*b[:4],*fields])
   if a!=b:print('different',file,tag,a[:4],b[:4],flush=True)
