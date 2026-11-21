from pathlib import Path
from itertools import product
import subprocess, collections, re, sys, hashlib, concurrent.futures
root=Path(__file__).resolve().parent
cc=Path(sys.argv[1]).resolve();out=Path(sys.argv[2]).resolve();out.mkdir(exist_ok=True,parents=True)
forms=[]
for val in ['0','18','7','0x2a','077','2147483647','2147483648','23u','1L',"'A'",'123.0','-7','(1 + 2)','x','x++','(x,9)','1/0','(1 << 32)']:
 for expr in ['(void)V;','((void)V);','(void)((V));','#MACRO','((const void)(V));','(alias_t)(V);']:
  forms.append((expr.replace('V',val).replace('#MACRO',f'IGNORE({val});'),'numeric'))
for prefix in ['(void)0;','IGNORE(7);','((void)(19));']:
 for context in ['if(x) S else x++;','if(x) {S} else {S}', 'while(x--){S}', 'do {S} while(x--);', 'for (S x--; ) {}','for (; x--; (void)0) {S}', 'L: S if (x) goto L;', 'switch(x) {case 1:S break;default:S}', 'x++; S x--;', 'S S S','if (0) {S} S', 'x = ({S 3;});', '({x++; S});','sizeof(({S 7;}));','{__attribute__((unused)) int v=x; S}', 'S __builtin_unreachable(); S', 'x++;\n#line 127 "stmt.h"\nS\n#line 63 "back.h"\n x--;']:
  forms.append((context.replace('S',prefix), 'context'))
policies=[[],['-Wall','-Wextra'],['-Weverything','-Wno-c++-compat'],['-Wall','-Wextra','-Werror','-Wunreachable-code-aggressive']]
for i,(body,_) in enumerate(forms): (out/f'f{i}.c').write_text('#define IGNORE(arg) ((void)((arg)))\ntypedef void alias_t;\nvoid f(int x){'+body+'}\n')
def pair(inp):
 i,pi,mode=inp; f=out/f'f{i}.c';obj=out/f'f{i}-{pi}-{mode[1:]}.o'
 args=[mode,'-std=gnu17','-fdiagnostics-color=never',*policies[pi],'-nostdinc']
 def call(flags):
  obj.unlink(missing_ok=True)
  r=subprocess.run([cc,*args,*flags,f,'-o',obj],capture_output=True);return r.returncode,r.stdout,r.stderr,hashlib.sha256(obj.read_bytes()).hexdigest() if obj.exists() else ''
 a=call([]);b=call(['--node-window']);z=call(['--node-window','--time-stages'])
 m=re.search(rb'node-window: taken=(\d+)',z[2])
 if a!=b:
  for k,v in [('plain',a),('window',b)]: (out/f'{i}-{pi}-{mode}.{k}.diag').write_bytes(v[2])
 obj.unlink(missing_ok=True)
 return i,pi,mode,int(a==b),a[0],int(bool(a[3])),int(m[1]) if m else 0
stats=collections.Counter()
with (out/'results.tsv').open('w') as o, concurrent.futures.ThreadPoolExecutor(2) as pool:
 for i,pi,m,eq,rc,obj,n in pool.map(pair,product(range(len(forms)),range(len(policies)),['-fsyntax-only','-c'])):
  print(i,pi,m,eq,rc,obj,n,sep='\t',file=o)
  stats['pairs']+=1;stats['differences']+=not eq;stats['objects']+=obj;stats['rejected']+=rc!=0;stats['admitted_files']+=n!=0;stats['admitted_total']+=n
print(dict(stats))
sys.exit(stats['differences']!=0)
