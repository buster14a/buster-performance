from pathlib import Path
import re, subprocess,sys
if len(sys.argv) != 3:
    sys.exit("usage: boundary.py COMPILER SCRATCH")
cc=Path(sys.argv[1]).resolve()
dst=Path(sys.argv[2]).resolve()
dst.mkdir(parents=True,exist_ok=True)
path=dst/'boundary-control.c'
regex=re.compile(rb'node-window-conditions: controls=(\d+) bounded=(\d+) taken=(\d+) native-rows=(\d+)')
refused=None
seen=0
def source(n):
 return 'int f(int x,int y){\n'+'    ++x;\n'*n+'    if (x == y) return x+7;\n    return y-3;\n}\n'
def status(n):
 path.write_text(source(n))
 proc=subprocess.run([cc,'--node-window-conditions','--lanes','1','--time-stages','-fsyntax-only',path],capture_output=True,check=True)
 m=regex.search(proc.stderr)
 return tuple(int(i) for i in m.groups())
for n in range(330,1027):
 st=status(n)
 if st==(1,0,0,0):
  refused=n
  break
 if st!=(1,1,1,3):raise Exception((n,st))
 seen+=1
assert refused is not None,seen
for n in range(refused-1,refused+2):
 st=status(n)
 ans=[]
 for i,op in enumerate([[],['--node-window'],['--node-window-conditions']]):
  out=dst/f'boundary-{i}.o'
  proc=subprocess.run([cc,*op,'--lanes','1','-Wall','-Wextra','-Werror','-c',path,'-o',out],capture_output=True)
  ans.append((proc.returncode,proc.stdout,proc.stderr,out.read_bytes() if proc.returncode==0 else None))
 assert ans[0]==ans[1]==ans[2] and ans[0][0]==0,(n,st,ans[0][0])
 print('prefix increments',n,'controls/bounded/taken/rows',st,'object match',len(ans[0][3]))
print('matched',seen,'complete predicates before first chunk-split refusal')
