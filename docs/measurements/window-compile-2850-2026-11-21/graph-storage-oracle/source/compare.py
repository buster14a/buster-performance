from pathlib import Path
import hashlib,sys,os,subprocess
root=Path(sys.argv[1]).resolve(); cc=Path(sys.argv[2]).resolve(); frozen=sys.argv[3:]; root.mkdir(exist_ok=True)
source=root/'many-returns.c'
with source.open('w') as f:
 print('extern volatile int unknown;\n',file=f)
 for i in range(6000):
  v=i%106
  body=f'return {v} + 17;' if i%5 else ('return x * 2 + unknown;' if i%10 else 'return x == unknown;')
  print(f'int f{i}(int x) {{ {body} }}',file=f)
for name,opts in [('sqlite',frozen),('high-take',[str(source)])]:
 rows=[]
 for route,extra in [('ordinary',[]),('window',['--node-window'])]:
  for bound in ['full','tight']:
   tag=f'{name}-{route}-{bound}'; stats=root/f'{tag}.tsv'
   if stats.exists(): stats.unlink()
   env=dict(os.environ,BUSTER_GRAPH_STORAGE=str(stats))
   if bound=='tight': env['BUSTER_GRAPH_CAP_OVERRIDE']=str(live)
   result=subprocess.run([str(cc),*extra,'--time-stages','--lanes','1','-c',*opts,'-o',str(root/f'{tag}.o')],capture_output=True,env=env)
   (root/f'{tag}.log').write_bytes(result.stderr)
   assert result.returncode==0 and not result.stdout,(tag,result.stderr[-800:])
   seen=[row.split('\t') for row in stats.read_text().splitlines()]
   cap,live=next((int(r[3]),int(r[4])) for r in seen if r[:3]==['typed','graph','ops'])
   h=hashlib.sha256((root/f'{tag}.o').read_bytes()).hexdigest()
   rows.append(h)
   for grp in ('graph','stream','scheduler','reader','token'):
    stage='after-expressions' if grp in ('reader','token') else 'typed'
    subset=[r for r in seen if r[0]==stage and r[1]==grp]
    virtual=sum(int(r[3])*int(r[5]) for r in subset); used=sum(int(r[4])*int(r[5]) for r in subset)
    present=sum(int(r[6]) for r in subset);priv=sum(int(r[7]) for r in subset);tail=sum(int(r[8]) for r in subset)
    print(tag,grp,cap,live,virtual,used,present,priv,tail,h,sep='\t',flush=True)
 assert len(set(rows))==1,(name,rows)
