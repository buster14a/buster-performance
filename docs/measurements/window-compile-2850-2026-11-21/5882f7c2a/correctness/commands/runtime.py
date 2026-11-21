"""Construct C arithmetic at ordinary graph boundaries and execute with Buster and Clang."""
from pathlib import Path
import ctypes, hashlib, itertools, json, random, subprocess, sys, shlex, os
d=Path(__file__).resolve().parent; r=d/sys.argv[1]/'runtime';r.mkdir(exist_ok=True);cc=d/sys.argv[1]/'compiler';parent=d/'b86eadcbd-compiler';clang=Path('~/.cache/buster/toolchain/4444af0bee44de2d/llvm-23.1.4/bin/clang')
g=random.Random(285021); ops=['+','-','^','&','|','*','/','%','>>']; outputs=[]
def integer(n):
 return [str(n),hex(n),('0'+format(n,'o'))][g.randrange(3)]
def const(depth):
 if depth==0 or g.randrange(3)==0:
  n=g.randrange(1,512);return integer(n),n
 x,a=const(depth-1);y,b=const(depth-1);op=g.choice(ops)
 if op=='>>': y=str(b&7);b=b&7
 if op in ('/','%') and b==0: y='1';b=1
 if op=='+' :v=a+b
 elif op=='-' :v=a-b
 elif op=='*':v=a*b
 elif op=='^':v=a^b
 elif op=='&':v=a&b
 elif op=='|':v=a|b
 elif op=='/':v=int(a/b)
 elif op=='%':v=a-int(a/b)*b
 else:v=a >> b
 if not (-0x7fffffff<=v<=0x7fffffff):return integer(1),1
 return '('+x+' '+op+' '+y+')',v
source=['#define M(x) (x)','static __attribute__((noinline)) int take(int v) { return v ^ 913; }']
for i in range(144):
 a,x=const(3);b,y=const(3);n=g.randrange(1,256);p=g.randrange(5);idx=g.randrange(5)
 # Guarantee a concrete compactible subtree even when the random operand is itself a literal.
 a='M(('+a+') ^ '+integer(603)+')';x^=603
 b='M(('+b+') + 1)';y+=1
 if p==0:body='return take((n ^ ('+a+')) + (('+b+') & 63));';v=((n^x)+(y&63))^913
 elif p==1:body='int v[] = {17,3,45,9,2,11,15,7}; return v[(n ^ ('+a+')) & 7] + (('+b+') & 127);';v=[17,3,45,9,2,11,15,7][(n^x)&7]+(y&127)
 elif p==2:body='return n > (('+a+') & 255) ? n + (('+b+') & 127) : n - (('+b+') & 127);';v=n+(y&127) if n>(x&255) else n-(y&127)
 elif p==3:body='switch (n & 3) { case (('+a+') & 3): return ('+b+') & 1023; default: return 21; }';v=y&1023 if n&3==x&3 else 21
 else:body='return ({ int v = n ^ ('+a+'); v + (('+b+') & 1023); });';v=(n^x)+(y&1023)
 source.append('int f%d(int n){%s}'%(i,body));outputs.append((i,n,v))
source+=['int main(void){',*['if(f%d(%d) != %d) return %d;'%(i,n,v,i+1) for i,n,v in outputs],'return 0;}']
s=r/'runtime.c';s.write_text('\n'.join(source)+'\n')
modes=[('parent',parent,[]),('plain',cc,[]),('source',cc,['--node-window-constants']),('clang',clang,[])]
m=hashlib.sha256; records=[]
for i,f in enumerate([[],['-g'],['-Wall','-Wextra'],['-O2'],['-std=c23'],['-fwrapv']]):
 out=[]
 for key,exe,opt in modes:
  o=r/(key+'-'+str(i)+'.o');x=r/(key+'-'+str(i)+'.exe')
  cmd=[exe,*([] if key=='clang' else ['--lanes','1']),*opt,*f,'-c',s,'-o',o]
  cp=subprocess.run(cmd,capture_output=True);assert not cp.returncode,(cmd,cp.stderr[-1200:])
  lp=subprocess.run(['cc','-no-pie',o,'-o',x],capture_output=True);assert not lp.returncode,(cmd,lp.stderr[-1200:])
  ap=subprocess.run([x],capture_output=True);assert not ap.returncode,(cmd,ap.returncode,ap.stderr)
  er=cp.stderr;out.append((m(o.read_bytes()).hexdigest(),m(er).hexdigest(),m(ap.stdout).hexdigest()))
  records.append([i,key,int(ap.returncode),*out[-1]])
 assert out[0]==out[1]==out[2],(i,out)
stage=subprocess.run([cc,'--lanes','1','--time-stages','--node-window-constants','-c',s,'-o',r/'stage.o'],capture_output=True)
(r/'stage.err').write_bytes(stage.stderr);assert stage.returncode==0 and b'constant-window: roots=' in stage.stderr
(r/'records.json').write_text(json.dumps({'seed':285021,'runtime_functions':len(outputs),'source_sha256':m(s.read_bytes()).hexdigest(),'records':records},indent=2)+'\n')
