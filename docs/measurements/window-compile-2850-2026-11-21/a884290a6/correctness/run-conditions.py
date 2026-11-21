from pathlib import Path
import shutil,subprocess,tempfile,hashlib,csv,random
from measure import d
rng=random.Random(2850);lines=['#include <stdio.h>','static unsigned state, side;','static unsigned step(unsigned v){side=side*33u+v;return v^side;}']
for i in range(48):
 k=rng.randrange(1,30);m=rng.randrange(1,32);mask=rng.randrange(255)+1
 tests=['x<y','x==y','(step(x)&1u)!=0','(x++ & y) != 0','(int)(x ^ y)','(x>y) + (y==0)','(x<y) && (step(y)!=0)','(x!=y) || (step(x)==0)','(x==y ? x+3u : y+7u)!=0','((volatile unsigned*)&x)[0] & y','(x & y) == 0u','((x>>1)^y)!=0']
 q=[tests[(i+j*3)%len(tests)] for j in range(4)]
 lines.append(f'static unsigned f{i}(unsigned x,unsigned y){{unsigned z=0; if({q[0]}) z+=x; if({q[1]}) z+=step(y)&{mask}u; for(unsigned i=0;i<3;i++){{if({q[2]})z^=x>>{k}; if({q[3]})z+=(y<<{m}); x=7u*x+y;}} return z;}}')
lines+=['int main(void){','for(unsigned i=0;i<64;i++){']+[f'state=state*17u+f{i}(state+i+{i}u,side^{1+i}u);' for i in range(48)]+['}', 'printf("%u %u\\n",state,side); return 0;}']
src=d/'runtime-conditions.c';src.write_text('\n'.join(lines)+'\n');clang=shutil.which('clang')
with tempfile.TemporaryDirectory() as tmp,(d/'runtime-conditions.tsv').open('w') as out:
 w=csv.writer(out,delimiter='\t',lineterminator='\n');w.writerow('compiler flags functions calls result object_sha256'.split());tmp=Path(tmp);ref=None;digests={}
 for cc in ('clang','base','condition'):
  for tag,flag in [('default',[]),('debug',['-g'])]:
   obj=tmp/'r.o';exe=tmp/'r'
   compiler=clang if cc=='clang' else str(d/('native-'+cc));p=subprocess.run([compiler,*flag,'-c',src,'-o',obj],capture_output=True);assert p.returncode==0,(cc,p.stderr[:260])
   p=subprocess.run([clang,'-no-pie',obj,'-o',exe],capture_output=True);assert p.returncode==0,(cc,p.stderr[:250]);p=subprocess.run([exe],capture_output=True);value=p.stdout.decode().strip();assert p.returncode==0 and (ref is None or value==ref),(cc,ref,value);ref=value
   h=hashlib.sha256(obj.read_bytes()).hexdigest()
   if cc!='clang':assert h==digests.setdefault(tag,h),(cc,tag)
   w.writerow([cc,tag,48,3072,value,h])
