"""Compile independent static initializers through both graph producers using the same compiler executable."""
import os
from pathlib import Path
import subprocess
import sys
study=Path(__file__).resolve().parent
cc=study/'compiler'
p=study/'cases';p.mkdir(exist_ok=True)
n=384
samples={
  'members': ('struct T {const char *name; unsigned value;};', 'struct T',lambda i:'{"table",V('+str(i)+')}', 'x[33].value'),
  'float': ('struct T { double a; float b; unsigned short c;};', 'struct T',lambda i:'{1.75,'+str(i)+'.5,3}', '(unsigned)x[15].b'),
  'enum': ('enum E {A=1,B=3}; struct T {enum E v; unsigned long x;};','struct T',lambda i:'{A,(B << 3) | '+str(i)+'}', 'x[17].x'),
  'numbers': ('', 'unsigned[4]',lambda i:'{V('+str(i)+'),2,3,4}','x[13][0]'),
  'aggregate': ('struct Q{int a,b;};struct T{struct Q q;int x;};','struct T',lambda i:'{{2,3},'+str(i)+'}','x[14].q.a+x[33].x'),
  'function': ('static int inc(int x){return x+1;}struct T{int(*f)(int);int x;};','struct T',lambda i:'{&inc,V('+str(i)+')}', 'x[99].f(x[4].x)'),
  'sizeof': ('typedef short H; struct T{int a; int b;};','struct T',lambda i:'{sizeof(H), _Generic((H)1, short: '+str(i)+', default: 4)}','x[17].a+x[17].b'),
  'omitted': ('struct T{int a,b,c;};','struct T',lambda i:'{'+str(i)+',3}' if i%2 else '{.c=4, .a='+str(i)+'}','x[144].a+x[140].c'),
}
for name,(decl,typ,make,read) in samples.items():
    symbol='unsigned x[][4]' if typ=='unsigned[4]' else typ+' x[]'
    cases=[make(i) for i in range(n)]
    src=p/(name+'.c');src.write_text('#define V(x) (((x)&255)+2)\n'+decl+'\nstatic const '+symbol+'={\n'+',\n'.join(cases)+(',\n' if name in ('float','enum') else '\n')+'};\nint main(void){return (int)('+read+')&127;}\n')
    for arm,marks in [('source',{'BUSTER_CHECK_BODY_SOURCE_ONLY':'1','BUSTER_CHECK_BODY_ADMIT_ALL':'1'}),('whole',{'BUSTER_CHECK_BODY_WHOLE_FINGERPRINT':'1'})]:
        env=os.environ|{'BUSTER_CHECK_SOURCE_DECLARATIONS':'1','BUSTER_STATIC_ROW_WINDOWS':'1'}|marks
        path=study/(name+'.'+arm+'.log')
        with path.open('wb') as log:
            proc=subprocess.run([cc,'--lanes','1','-std=gnu23','-c',src,'-o',p/(name+'.o')],env=env,stdout=log,stderr=subprocess.STDOUT)
        if proc.returncode:print(name,arm,proc.returncode,flush=True)
subprocess.run([sys.executable,study/'verify.py',*samples],check=True)
