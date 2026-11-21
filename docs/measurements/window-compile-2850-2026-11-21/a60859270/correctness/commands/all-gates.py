from concurrent.futures import ThreadPoolExecutor
from pathlib import Path
import sys,subprocess,re,csv
d=Path(__file__).resolve().parent;r=d/sys.argv[1];p=r/'full-checks';p.mkdir(exist_ok=True);tree=d.parent/'window-constants';cc=r/'compiler';cl='~/.cache/buster/toolchain/4444af0bee44de2d/llvm-23.1.4/bin/clang'
def run(a):
 mode,part=a;opt=['--seed','133'] if mode=='checker' else ['--in-process','--executable',cc];f=p/(mode+'-'+str(part)+'.log')
 with f.open('wb') as out:ret=subprocess.call([cc,'test-'+('checker-driver' if mode=='driver' else 'checker'),*opt,'--clang',cl,*(['--fixtures','tests'] if mode=='checker' else []),'--part',str(part)+'/8'],cwd=tree,stderr=subprocess.STDOUT,stdout=out)
 m=re.search(rb'(\d+) checks, (\d+) failures',f.read_bytes());return [mode,part,ret,*(m.groups() if m else [b'0',b'-1'])]
modes=['checker','driver'] if len(sys.argv)<3 else [sys.argv[2]]
keep=[]
if len(modes)==1 and (p/'counts.tsv').exists():
 with (p/'counts.tsv').open() as old:keep=[a for a in list(csv.reader(old,delimiter='\t'))[1:] if a[0] not in modes]
with ThreadPoolExecutor(max_workers=2) as ex,(p/'counts.tsv').open('w') as f:
 wr=csv.writer(f,delimiter='\t',lineterminator='\n');wr.writerow(['suite','part','status','checks','failures']);wr.writerows(keep);f.flush()
 for m,n,rc,k,failed in ex.map(run,[(m,n) for m in modes for n in range(1,9)]):
  wr.writerow([m,n,rc,int(k),int(failed)]);f.flush()
