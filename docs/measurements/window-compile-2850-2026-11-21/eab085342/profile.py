from common import *
from collections import Counter
import csv,gzip,hashlib,json,shutil,subprocess,sys
folder=D/'profile';folder.mkdir(exist_ok=True);period=250007;repeat=6;LLVM='/home/david/.cache/buster/toolchain/4444af0bee44de2d/llvm-23.1.4/bin/llvm-addr2line'
LLVM=LLVM if Path(LLVM).exists() else shutil.which('addr2line')
if len(sys.argv)>1 and sys.argv[1]=='--worker':
 name=sys.argv[2];mode=sys.argv[3];obj=folder/(name+'.'+mode+'.o');expected=hashlib.sha256((W/'source-typed-study'/(name+'.o')).read_bytes()).hexdigest()
 for _ in range(repeat):
  r=subprocess.run([CC,'--lanes','1','-c',*args[name],'-o',obj],env=env|native|(producer if mode=='producer' else {}),cwd=ROOT,capture_output=True);assert r.returncode==0;assert hashlib.sha256(obj.read_bytes()).hexdigest()==expected
 sys.exit(0)
for name in ('sqlite','main'):
 parts={}
 for mode in ('control','producer'):
  stem=folder/(name+'.'+mode);trace=stem.with_suffix('.'+mode+'.data')
  r=None if trace.exists() and trace.stat().st_size>0 else subprocess.run(['perf','record','-q','-e','instructions:u','-c',str(period),'-o',trace,'--',sys.executable,__file__,'--worker',name,mode],capture_output=True)
  if r is not None:
   (folder/(stem.name+'.perf.stderr')).write_bytes(r.stderr);assert r.returncode==0,r.stderr[:500]
  r=subprocess.run(['perf','script','-i',trace,'-F','ip,sym,symoff,dso'],capture_output=True,check=True);(folder/(stem.name+'.script.gz')).write_bytes(gzip.compress(r.stdout,mtime=0))
  pairs=Counter()
  for line in r.stdout.decode().splitlines():
   a=line.split()
   if len(a)>=3 and a[2].strip('()').rsplit('/',1)[-1]=='compiler':pairs[a[0],a[1].split('+')[0].removesuffix('.buster_split')]+=1
  assert pairs,(name,mode,r.stdout[:300])
  bins=Counter();sites=Counter();addrs=list(pairs)
  mapped=subprocess.run([LLVM,'-e',CC,'-f'],input=''.join(ip+'\n' for ip,k in addrs),text=True,capture_output=True,check=True).stdout.splitlines();assert len(mapped)==2*len(addrs)
  for i,(ip,k) in enumerate(addrs):
   n=pairs[ip,k];fn,loc=mapped[2*i:2*i+2];loc=loc.split('/src/buster/compiler/')[-1];bins[k]+=n;sites[k,fn,loc]+=n
  parts[mode]=(bins,sites)
  with (folder/(stem.name+'.symbols.tsv')).open('w') as f:
   t=csv.writer(f,delimiter='\t',lineterminator='\n');t.writerow(('symbol','samples','estimated-instructions-per-compile'));t.writerows((k,n,round(n*period/repeat)) for k,n in bins.most_common())
  with (folder/(stem.name+'.sites.tsv')).open('w') as f:
   t=csv.writer(f,delimiter='\t',lineterminator='\n');t.writerow(('symbol','source-function','location','samples','estimated-instructions-per-compile'));t.writerows((*k,n,round(n*period/repeat)) for k,n in sites.most_common())
 with (folder/(name+'.deltas.tsv')).open('w') as f:
  t=csv.writer(f,delimiter='\t',lineterminator='\n');t.writerow(('symbol','control-samples','producer-samples','estimated-instructions-per-compile-delta'))
  a,b=(parts[k][0] for k in ('control','producer'));t.writerows((k,a[k],b[k],round((b[k]-a[k])*period/repeat)) for k in sorted(set(a)|set(b),key=lambda k:-abs(b[k]-a[k])))
(folder/'config.json').write_text(json.dumps({'event':'instructions:u','period':period,'compiles-per-arm':repeat,'compiler':str(CC),'source-native':native,'producer':producer},indent=2))


