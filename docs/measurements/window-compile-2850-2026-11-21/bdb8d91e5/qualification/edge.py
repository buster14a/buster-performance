import csv, hashlib, os, subprocess, tempfile, sys
from pathlib import Path
st=Path(__file__).resolve().parent;w=st.parent
base=w/'main-fbef-clean/build/compiler';new=w/'pending-native-windows/build/compiler';clang=Path('/home/david/.cache/buster/toolchain/4444af0bee44de2d/llvm-23.1.4/bin/clang')
d=st/'source-fixtures';d.mkdir(exist_ok=True)
prefix=''.join(f'typedef int Pad{i};\n' for i in range(2055))+'extern int printf(const char *, ...);\n'
def runnable(functions,call):return functions+'\nint main(void){printf("%d\\n",'+call+');return 0;}'
cases={
'zero':runnable('int f(void){return 0;}int g(void){return 1;}','f()+3*g()'),
'local':runnable('int f(int a){int b=0;b=a;{int a=3;b=a;}return b;}','f(1)'),
'reassigned':runnable('int f(int a){int b=a;b=23;b=32766;a=b;return a;}','f(4)'),
'sources':runnable('int f(int a){int b=0;b=0;a=b;b=021;b=0x4e;b=2147483647;return b;}','f(21)'),
'typed':runnable('int f(int a){char s=1;short b=3;long h=3;_Bool z=0;s=4;b=7;h=8;z=b;a=b;return a+s+z+h;}','f(3)'),
'branches':runnable('int f(int a){int b=4;if(a) b=a; else b=7; while(a-- >2){b=a;}for(a=5;a>2;a--){b=a;} return b;}','f(3)'),
'macro':runnable('#define ST(x,y) x=y\n#define ID(x) x\n#define R(x) return x\nint f(int x){int y=0;ST(y,x);ST(x,2);R(y);}', 'f(9)'),
'shadow':runnable('int f(int a){int b=0;{int a=4;{int b=a;b=9;a=b;}b=a;}return b;}','f(22)'),
'flags':runnable('int f(int a){register int b=5;volatile int c=6;_Atomic int t=7;static int e=8;c=a;a=c;t=a;e=t;a=e;b=a;return b;}','f(3)'),
'register':runnable('register int fixed asm("r15");int f(int a){int b=0;b=a;fixed=b;b=fixed;return b;}','f(3)'),
'const':runnable('int f(int a){const int b=4;int c=a;c=b;a=c;return a;}','f(2)'),
'comma':runnable('int f(int a){int b=0,c=1;b=c,a=b; { ({b=3;}); }a=c;return a;}','f(3)'),
'region-value':runnable('int f(int x){int y=2,r=({x=y;});int s=({y=6;x=y;});return r+s;}','f(8)'),
'recover': 'int f(int a){int b; a=b; z=a;return b; }',
'uninitialized':'int f(int a){int b;b=b;int c;c=b;return c;}int g(int a){int b;if(a){b=5;}return b;}',
'unused':'int f(int a){int b,c;b=a;c=b;return a;}',
'attr':'int f(int a){int b __attribute__((deprecated))=0;b=a;return b;}',
'labels':runnable('int f(int a){int b=1;L:b=a;if(a>2){a=1;goto L;}return b;}','f(7)'),
'vla':runnable('int f(int n){int r=3;int a[n];a[n-1]=r;r=4;return r+a[n-1];}','f(3)'),
'extern-in-block':runnable('int shared=3;int f(int a){int b=0;{extern int shared;b=shared;shared=a;}a=b;return a+shared;}','f(19)'),
'extern-prior-block':runnable('int f(int a){extern int shared;int b=2;shared=a;b=shared;return b;}int shared=3;','f(19)'),
'pragma':runnable('int f(int x){int a=0;\n#pragma clang diagnostic push\n#pragma clang diagnostic ignored "-Wself-assign"\n a=a; a=x;\n#pragma clang diagnostic pop\n return a;}','f(3)'),
'cleanup':runnable('int seen;static void collect(int *x){seen=*x;}int f(int v){int a __attribute__((cleanup(collect)))=0;a=v;return a;}int g(void){int n=f(6);return n+seen;}','g()'),
'asm-local':runnable('int f(int a){register int r asm("r10")=7;int b=0;r=a;b=r;return b;}','f(3)'),
'odd-constant':runnable('int f(int x){int a=0;{a=0b1111;a=0Xab;a=0x7fffffff;}x=a;return x;}','f(3)'),
'computed-goto':runnable('int f(int x){int r=1;void *dest=&&back;{goto *dest;}back: r=x;return r;}','f(7)'),
'if-return':runnable('int f(int a){int b=0;if(a){b=7;return b;}if(a) return 0; else return a;}','f(4)'),
'negative':'int f(int a){const int b=2;b=a;return b;}',
'long-block':runnable('int f(int a){int b=2;'+''.join(f'b={i};a=b;\n' for i in range(1100))+'return a;}','f(2)'),
'branch-gaps':runnable('int f(int a){int b=0;'+''.join(f'if((a&{i})!=0){{b=a;}}else{{a={i};}}\n' for i in range(210))+'return b;}','f(4)'),
}
valid=set(cases)-{'recover','uninitialized','unused','attr','register','negative'}
def run(cmd):return subprocess.run(cmd,capture_output=True,timeout=60)
def hash(x):return hashlib.sha256(x).hexdigest()
flags={'default':['-c'],'walls':['-c','-Wall','-Wextra'],'everything':['-c','-Weverything','-Wno-c++-compat'],'typed':['--dump-typed','-c'],'verify':['--verify','-c'],'tier1':['--tier1','-c'],'debug':['-g','-c'],'syntax':['-fsyntax-only','-Weverything','-Wno-c++-compat']}
with (st/'edges.tsv').open('w',buffering=1) as out:
 t=csv.writer(out,delimiter='\t',lineterminator='\n');t.writerow(['case','mode','match','status','stdout','stderr','object','clang_runtime'])
 for name,source in cases.items():
    f=d/(name+'.c');f.write_text(prefix+source+'\n')
    for mode,margs in flags.items():
        recv=[]
        for cc in [base,new]:
            obj=d/(name+'.o');obj.unlink(missing_ok=True);p=run([cc,'-std=gnu23',*margs,f,'-o',obj])
            recv.append((p.returncode,p.stdout,p.stderr,obj.read_bytes() if obj.is_file() else b''))
        r=recv[1];same=recv[0]==r;runtime='-'
        if same and name in valid and mode in ['default','tier1'] and r[0]==0:
            e=d/'unit';ref=d/'clang';a=run([clang,'-no-pie',obj,'-o',e]);b=run([clang,'-std=gnu23','-O0',f,'-o',ref])
            assert a.returncode==b.returncode==0,(name,a.stderr,b.stderr)
            x=run([e]);y=run([ref]);same=(x.returncode,x.stdout,x.stderr)==(y.returncode,y.stdout,y.stderr);runtime=hash(y.stdout)
        if not same:
            print('mismatch',name,mode,[v[0] for v in recv],[len(v[1]) for v in recv],[len(v[2]) for v in recv],flush=True)
            for side,v in zip(['before','after'],recv):
                for i,s in enumerate(['stdout','stderr','o'],1):(d/(name+'.'+mode+'.'+side+'.'+s)).write_bytes(v[i])
        t.writerow([name,mode,int(same),r[0],*[hash(v) for v in r[1:]],runtime])
