"""Compare the fixed 64-frame codec workloads against their independently checked output."""
from pathlib import Path
from statistics import median
import csv, hashlib, itertools, math, os, subprocess, tempfile, sys
p=Path(__file__).resolve().parent
arch=os.environ.get('OPUS_TEST_ARCH','x86-64-v3')
d=p/('audio' if arch=='znver5' else 'audio-'+arch)
modes=[m if arch=='znver5' else m+'-'+arch for m in ['portable-nosp','dispatch-nosp']]
actions=['encode','decode']
pads=[0,16,32,48]
variants=['control','candidate']
cases=list(itertools.product(modes,range(7),actions,pads))
metrics=['cycles:u','instructions:u','branches:u','branch-misses:u','task-clock']
def sha(path): return hashlib.file_digest(path.open('rb'),'sha256').hexdigest()
def table(path):
 return list(csv.DictReader(path.open(),delimiter='\t'))
def save(path,columns,rows):
 with path.open('w') as f:
  tab=csv.writer(f,delimiter='\t',lineterminator='\n');tab.writerow(columns);tab.writerows(rows)
rows=[]
raw=p/('timing-'+arch);raw.mkdir(exist_ok=True)
if sys.argv[1]=='run':
 with tempfile.TemporaryDirectory(dir='/dev/shm') as tmp:
  tmp=Path(tmp); stats=tmp/'perf'; output=tmp/'output'
  for r in range(8):
   log=raw/f'round-{r}.tsv'
   if log.exists():continue
   local=[]
   for i in range(len(cases)):
    mode,k,action,pad=cases[(17*r+i)%len(cases)]
    goldpacket=d/f'{mode}-{k}-control.packets'
    gold=goldpacket if action=='encode' else d/f'{mode}-{k}-control-decode-control.pcm'
    expected=sha(gold)
    for v in (variants if (r+i)%2==0 else variants[::-1]):
     exe=d/f'{mode}-{v}-{pad}'
     args=[exe,action,str(k),output,'unused'] if action=='encode' else [exe,action,str(k),goldpacket,output]
     subprocess.run(['perf','stat','--no-big-num','-x',';','-e',','.join(metrics),'-o',stats,'--',*args],check=True,env=dict(os.environ,LC_ALL='C'),timeout=60)
     obs={}
     for l in stats.read_text().splitlines():
      z=l.split(';')
      if len(z)>2 and z[2] in metrics:obs[z[2]]=float(z[0])
     actual=sha(output);assert actual==expected and len(obs)==len(metrics),(mode,k,v)
     local.append([r,mode,k,action,pad,v,actual,*[obs[m] for m in metrics]])
   save(log,['round','mode','profile','action','pad','variant','verified_sha256',*metrics],local);print('round',r,flush=True)
 observations=[row for r in range(8) for row in table(raw/f'round-{r}.tsv')]
 assert len(observations)==8*2*len(cases)
 save(raw/'observations.tsv',list(observations[0]),[list(x.values()) for x in observations])
 by={(int(x['round']),x['mode'],int(x['profile']),x['action'],int(x['pad']),x['variant']):x for x in observations}
 for m,k,a,pad in cases:
  for stat in metrics:
   aa=[float(by[r,m,k,a,pad,'control'][stat]) for r in range(1,8)]
   bb=[float(by[r,m,k,a,pad,'candidate'][stat]) for r in range(1,8)]
   z=[100*(y/x-1) for x,y in zip(aa,bb)];rows.append([m,k,a,pad,stat,len(z),median(aa),median(bb),median(z),min(z),max(z)])
 save(raw/'paired.tsv',['mode','profile','action','pad','metric','pairs','base','candidate','paired_pct','min_pct','max_pct'],rows)
else:
 for m in modes:
  for k,a in [(0,'encode'),(2,'encode'),(6,'decode')]:
   key=f'{m}-{k}-{a}';exe=d/f'{m}-control-0';pk=d/f'{m}-{k}-control.packets'
   args=[exe,a,str(k),'/dev/null','unused'] if a=='encode' else [exe,a,str(k),pk,'/dev/null']
   cmd=['sh','-c','for i in $(seq 1 30); do "$@" || exit; done','sh',*args]
   prof=raw/(key+'.perf')
   subprocess.run(['perf','record','-q','-F','897','-e','cycles:u','-o',prof,'--',*cmd],check=True)
   with (raw/(key+'.txt')).open('w') as f:subprocess.run(['perf','report','--stdio','--percent-limit','0.5','--sort','dso,symbol','-i',prof],stdout=f,check=True)
