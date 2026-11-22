"""Compare complete warning streams and native semantics for the discard and postorder representations."""
from pathlib import Path
import csv, hashlib, os, subprocess, sys
w=Path(__file__).resolve().parent.parent
study=w/sys.argv[1]; tree=w/sys.argv[2];d=study/('padded-source-cases' if len(sys.argv)>3 else 'source-cases');d.mkdir(exist_ok=True)
ref=w/'main-fbef-clean/build/compiler';new=tree/'build/compiler'
clang=Path('/home/david/.cache/buster/toolchain/4444af0bee44de2d/llvm-23.1.4/bin/clang')
prefix='extern int printf(const char *,...);\n'
def case(src, main):
    return prefix+src+'\nint main(void){'+main+'}\n'
valid={
'volatile':case('volatile int v;int a;int f(int x){v=x;v++;a+=v;((void)v); return a;}','int r=f(3);printf("%d %d\\n",r,v);return 0;'),
'call':case('int n;void pv(int x){n=n*3+x;}int pi(int x){pv(x);return n;} struct S{int a,b;};struct S ps(int x){pv(x);return (struct S){x,x+1};}', 'pv(1);pi(2);(ps(3));(void)pi(4); printf("%d\\n",n);return 0;'),
'ptrcall':case('int n; void f(int x){n+=x;} void (* volatile fn)(int)=f;','fn(3);(fn)(5);printf("%d\\n",n);return 0;'),
'assign':case('struct S { int a; float b; }; struct S x,y={2,3}; _Atomic unsigned a; unsigned b;', 'x=y; a=5; a++; b+=a; b<<=1; printf("%d %d %u %u\\n",x.a,(int)x.b,b,(unsigned)a);return 0;'),
'bits':case('struct S{unsigned a:3,b:3;};struct S s;','s.a=4;s.a++;s.b+=s.a;((void)s.b);printf("%u %u\\n",s.a,s.b);return 0;'),
'groups':case('int n;int f(int x){return n=n*5+x;}','((f(2)));{(void)(f(3),f(4));} if(n) f(5);else f(6);printf("%d\\n",n);return 0;'),
'loop':case('int n;int f(int x){return n+=x;}','for(int i=0;i<3;i++){f(i);if(i==1) continue;else {n++;}}printf("%d\\n",n);return 0;'),
'region':case('int n;int f(int x){n+=x;return n;}','int r=({f(2);int y=({f(3);f(4);}); y+n;}); printf("%d %d\\n",r,n);return 0;'),
'region-final':case('int n;int f(int x){return ++n+x;}','int r=({n=1;lab: f(5);});int q=({n+=2;});printf("%d %d %d\\n",r,q,n);return 0;'),
'noreturn':case('_Noreturn void halt(void){__builtin_trap();} int f(int x){if(x){halt();}return 9;}','printf("%d\\n",f(0));return 0;'),
'complex':case('typedef float _Complex C; C z; C f(int x){z+=x+2.0fi;return z;}','f(2);(void)f(3);printf("%d %d\\n",(int)__real__ z,(int)__imag__ z);return 0;'),
'varbounds':case('int n;int take(int x){++n; return x;}','int a[3]={1,2,3}; __typeof__(int (*)[take(3)]) p=(void *)&a; (void)p;printf("%d %d\\n",n,a[1]);return 0;'),
'checked-choose':case('int n;int f(int x){return n+=x;}','__builtin_choose_expr(1,f(1),f(2));_Generic(f(22),int: f(3),default:f(4));printf("%d\\n",n);return 0;'),
'fp':case('#pragma STDC FENV_ACCESS ON\nvolatile float f;float g(float a){return f+=a;}','g(2);f+=3;printf("%d\\n",(int)f);return 0;'),
'wide-call':case('int take(int x,...){return x;} int sink; int f(void){sink=take(11,'+','.join(str(i) for i in range(330))+');return sink;}','printf("%d\\n",f());return 0;'),
'after-wide':case('int take(int x,...){return x;} int f(int v){int t=take(v,'+','.join(f'v+{i}' for i in range(315))+');t+=(v+1)*(v+2);return t;}','printf("%d\\n",f(3));return 0;'),
'deep':case('int f(int a,int n){return '+'(a+'*180+'n'+')'*180+';}','printf("%d\\n",f(2,3));return 0;')}
valid['open-assignments']=case('int a[360];int f(int x){'+''.join(f'a[{i}]=' for i in range(350))+'x;return a[0]+a[181]+a[349];}','printf("%d\\n",f(4));return 0;')
valid['open-conditions']=case('int f(int x){return '+''.join(f'(x=={i})?{i+3}:' for i in range(310))+'x;}','printf("%d %d\\n",f(159),f(311));return 0;')
invalid={
'nodiscard':'[[nodiscard]] int a(int);int f(void){a(1);((a(2)));(void)a(3);if(0){a(4);}return 0;}',
'warn-result':'__attribute__((warn_unused_result)) int t(void);void f(void){t(); (void)t(); (t());}',
'ignored-comma':'[[nodiscard]] int g(int);void f(int x){g(1),g(2);x?g(3):g(4);(void)(x?g(5):g(6));}',
'ignored-aggregate':'struct [[nodiscard]] S{int a;};struct S f(void);void g(void){f(); (void)f();}',
'order':'[[nodiscard]] int g(int);void f(int x){x==1;g(2);x=g(3);x=x++ + x++;g(4);}',
'missing':'int f(int x){ x=not_declared(); x+=z; return x;}',
'const':'void f(void){const int x=1;x++;x=3;}',
'implicit':'struct X;struct X f(void);void h(void){f();}',
'args':'[[nodiscard]] int f(int, int);void g(void){f(1);f(2,3);}',
'where':'int f(void);void g(int x){for(f();x;f()) f(); L: f(); if (x){f();}else f();}'}
def h(b):return hashlib.sha256(b).hexdigest()
def run(args):return subprocess.run(args,capture_output=True,timeout=70)
with (d/'results.tsv').open('w',buffering=1) as log:
 t=csv.writer(log,delimiter='\t',lineterminator='\n');t.writerow(['case','mode','match','status','stdout','stderr','object','runtime'])
 for name,source in (valid|invalid).items():
    f=d/(name+'.c');padding=''.join(f'typedef int Pad{i};\n' for i in range(2200)) if len(sys.argv)>3 else '';f.write_text(padding+source+'\n')
    for mode,flags in [('syntax',['-fsyntax-only','-Wall','-Wextra']),('everything',['-fsyntax-only','-Weverything','-Wno-c++-compat']),('object',['-c']),('debug',['-g','-c']),('tier1',['--tier1','-c'])]:
        twins=[]
        for cc in [ref,new]:
            obj=d/(name+'.o');obj.unlink(missing_ok=True);p=run([cc,'-std=gnu23',*flags,f,'-o',obj])
            twins.append((p.returncode,p.stdout,p.stderr,obj.read_bytes() if obj.exists() else b''))
        ok=twins[0]==twins[1];a=twins[1];rr='-'
        if ok and name in valid and mode in ('object','tier1') and a[0]==0:
            b=d/(name+'.out');r=d/(name+'.clang'); lp=run([clang,'-no-pie',obj,'-o',b]); cp=run([clang,'-std=gnu23','-O0',f,'-o',r])
            if lp.returncode or cp.returncode: raise RuntimeError((name,lp.stderr,cp.stderr))
            x=run([b]);y=run([r]);ok=(x.returncode,x.stdout,x.stderr)==(y.returncode,y.stdout,y.stderr);rr=h(y.stdout)
        t.writerow([name,mode,int(ok),a[0],h(a[1]),h(a[2]),h(a[3]),rr])
        if not ok:
            (d/(name+'-'+mode+'.baseline.stderr')).write_bytes(twins[0][2]);(d/(name+'-'+mode+'.candidate.stderr')).write_bytes(a[2])
 print('comparisons',len(valid|invalid)*5)
