import csv,hashlib,subprocess
from pathlib import Path
st=Path(__file__).resolve().parent;w=st.parent;d=st/'colon-fixtures';d.mkdir(exist_ok=True)
base=w/'main-fbef-clean/build/compiler';new=w/'closed-parse-blocks/build/compiler';clang=Path('/home/david/.cache/buster/toolchain/4444af0bee44de2d/llvm-23.1.4/bin/clang')
functions={
'nested':('int f(int x){switch(x){case 1?2:3:{x=4; break;} default: {x+=2;} }label: {if(x<2){x+=2;goto label;}}return x?x:7;}','f(2)',True),
'labels':('int f(int x){goto A;B: {return x+2;}A: {x+=3;goto B;}}','f(3)',True),
'bitfield':('struct S { unsigned x:3,y:1; };int f(int a){struct S s={a,0};return a ? s.x : a?33:7;}','f(2)',True),
'jump':('int f(int x){switch(x){case 2:case 3: {return 4;} case 4: ;return 6;default:{ return 1;}}}','f(3)',True),
'nest':('int f(int x){return '+('(x?'*85)+'1'+(':0)'*85)+';}','f(1)',True),
'broken':('int f(int x){return x:?x ? 2:; }','f(2)',False),
'missing':('int f(int x){switch(x){case: {int i=x?;return i;}default return 0;}}','f(0)',False),
'macro':('#define BLOCK(a) { a; }\n#define ALT(a,b,c) ((a)?(b):(c))\nint f(int x){switch(x){case 2:BLOCK(x=ALT(x,6,2));break;default:BLOCK(x=2);};return x;}','f(2)',True)}
with (st/'colons.tsv').open('w',buffering=1) as out:
 t=csv.writer(out,delimiter='\t',lineterminator='\n');t.writerow(['case','prefix','mode','match','status','stdout','stderr','runtime'])
 for name,(func,expr,runnable) in functions.items():
  for n in [0,1,15,16,31,32,61,62,63,64,65,126,127,128]:
   src=d/'case.c';src.write_text('int pad0;\n'+';'*n+'\n'+func+'\nint main(void){return ('+expr+')&255;}\n')
   for mode,args in [('tree',['test-parser','--print-tree']),('native',['-c','-Wall','-Wextra']),('dump',['--dump-typed','-c'])]:
    claims=[];obj=d/'case.o'
    for compiler in [base,new]:
     obj.unlink(missing_ok=True);p=subprocess.run([compiler,*args,src,*(['-o',obj] if mode!='tree' else [])],capture_output=True);claims.append((p.returncode,p.stdout,p.stderr,obj.read_bytes() if obj.exists() else b''))
    a,b=claims;ok=a==b;runtime='-'
    if runnable and n in (1,63,64) and mode=='native' and b[0]==0:
     e=d/'candidate';f=d/'reference'
     subprocess.run([clang,'-no-pie',obj,'-o',e],check=True,capture_output=True);subprocess.run([clang,'-O0',src,'-o',f],check=True,capture_output=True)
     cmd=lambda v:subprocess.run([v],capture_output=True,timeout=3)
     x,y=cmd(e),cmd(f);ok&=(x.returncode,x.stdout,x.stderr)==(y.returncode,y.stdout,y.stderr);runtime=y.returncode
    digest=lambda x:hashlib.sha256(x).hexdigest()
    t.writerow([name,n,mode,int(ok),b[0],digest(b[1]),digest(b[2]),runtime])
    if not ok:raise RuntimeError((name,n,mode,[(c[0],len(c[1]),len(c[2]),len(c[3])) for c in claims]))
