"""Compare all printed tree roles, node depths, parents and diagnostics for streaming parser boundary cases."""
from pathlib import Path
import csv, hashlib, os, subprocess, sys
w=Path(__file__).resolve().parent.parent
study=w/sys.argv[1];tree=w/sys.argv[2];d=study/'parse-boundaries';d.mkdir(exist_ok=True)
def make(n,tail):
    return ''.join(f'int v{i}={i%19};\n' for i in range(n))+tail
cases={}
for n in (126,218,510,1021):
    for k,tail in {
        'brace':'int f(int x){'+'{'*48+'return (x+1);'+'}'*48+'}',
        'under':'int f(int x){'+'('*46+'x'+')'*62+';return x;}',
        'mixed':'int a[4];int f(int x){return (((((a[(x+1)&3]))))+x);}',
        'pragma':'\n#pragma pack(push,1)\nstruct S { char c; long x; };\n#pragma pack(pop)\nint f(void){return sizeof(struct S);}',
        'scope':'[[__clang__::unused]] int v;\nint f(void){return v;}',
        'split':'\n'.join(f'[[gnu::unused]] int a{i};' for i in range(160)),
        'failed':'int f(int x){do {if(x) break;} while(0);return ((x];}',
        'macro':'#define F(x) (((x)==0) ? 9 : ((x)+1))\nint f(int a){return F(F(a));}',
        'statement':'int f(int x){return ({int y=(x);({int z=y+1;z;});});}',
        'typedef':'typedef int I; int f(I x){ { typedef char I; I a=x; if(a) return sizeof(I); }return sizeof(I);}'}.items():
        cases[f'{n}-{k}']=make(n,tail)
def sha(v):return hashlib.sha256(v).hexdigest()
with (d/'results.tsv').open('w') as f:
    t=csv.writer(f,delimiter='\t',lineterminator='\n');t.writerow(['case','mode','matched','status','stdout bytes','stdout sha256','stderr sha256'])
    for k,v in cases.items():
        src=d/(k+'.c');src.write_text(v+'\n')
        for mode,flags in [('tree',['test-parser','--print-tree',str(src)]),('check',['-fsyntax-only','-Wall','-Wextra',str(src)]),('object',['-c','-o',str(d/'case.o'),str(src)])]:
            observed=[]
            for compiler in (w/'main-fbef-clean/build/compiler',tree/'build/compiler'):
                out=d/'case.o';out.unlink(missing_ok=True);p=subprocess.run([compiler,*flags],capture_output=True)
                observed.append((p.returncode,p.stdout,p.stderr,out.read_bytes() if out.exists() else b''))
            x,y=observed
            t.writerow([k,mode,int(x==y),x[0],len(x[1]),sha(x[1]),sha(x[2])]);f.flush()
            if x!=y:raise ValueError((k,mode,tuple((xx[0],len(xx[1]),xx[2][:80],len(xx[3])) for xx in observed)))
print(len(cases)*3,'exact tree, syntax and object cases')
