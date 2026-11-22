import csv,re,subprocess
from pathlib import Path
st=Path(__file__).resolve().parent
w=st.parent
compilers={'clang':Path('/home/david/.cache/buster/toolchain/4444af0bee44de2d/llvm-23.1.4/bin/clang'),'baseline':w/'main-fbef-clean/build/compiler','candidate':w/'pending-native-windows/build/compiler'}
cases={
'read-uninitialized':('int f(void){int a,b;b=a;return b;}', '-Wuninitialized'),
'set-unused':('int f(int a){int b;b=a;return a;}','-Wunused-but-set-variable'),
'self-assignment':('int f(int a){a=a;return a;}','-Wself-assign'),
'live-store':('int f(int a){int b;b=a;return b;}','-Wuninitialized'),
'read-id-return':('int f(void){int a;return a;}','-Wuninitialized'),
'shadowed-writes':('int f(int a){int b=0;{int a=2;b=a;}return b;}','-Wshadow'),
'const-target':('int f(int a){const int b=3;b=a;return b;}','-Wall')
}
pad=''.join('typedef int Pad%d;\n'%i for i in range(2055))
src=st/'warnings';src.mkdir(exist_ok=True)
with (st/'warning-oracle.tsv').open('w') as out:
 writer=csv.writer(out,delimiter='\t',lineterminator='\n')
 writer.writerow(['case','mode','compiler','status','diagnostics','clang-match'])
 for name,(body,flag) in cases.items():
  path=src/(name+'.c');path.write_text(pad+body+'\n')
  for error in (False,True):
   claims={}
   for kind,cc in compilers.items():
    args=['-std=gnu23','-c',flag,*(['-Werror'] if error else []),str(path),'-o',str(src/'case.o')]
    p=subprocess.run([cc,*args],capture_output=True)
    msgs=[]
    for l in p.stderr.decode().splitlines():
     m=re.search(r':(\d+):(\d+): (warning|error): (.*)',l)
     if m:
      loc=tuple(m.group(i) for i in (1,2,3))
      tag=re.search(r'\[(-W[^\]]+)\]$',m[4])
      code=(tag[1].replace('-Werror,','').lstrip(',') if tag else 'hard')
      msgs.append(':'.join([*loc,code]))
    claims[kind]=(p.returncode,','.join(msgs))
    (src/(name+('.error.' if error else '.warn.')+kind+'.log')).write_bytes(p.stderr)
    writer.writerow([name,'error' if error else 'warn',kind,*claims[kind],int(claims['clang']==claims[kind])])
