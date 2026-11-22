"""Exercise file-scope braced initializers against the parent and native Clang with identical source paths."""
import csv
import hashlib
import subprocess
import sys
from pathlib import Path

work = Path(__file__).resolve().parent.parent
study, tree = sys.argv[1:]
out = work / study / 'static-source'
out.mkdir(exist_ok=True)
parent = work / 'main-fbef-clean/build/compiler'
candidate = work / tree / 'build/compiler'
clang = Path('/home/david/.cache/buster/toolchain/4444af0bee44de2d/llvm-23.1.4/bin/clang')
cases = {
    'characters': ("static const unsigned char v[] = {'a','\\n',255, 0, 'z'};", 'v[0]+v[1]+v[2]+v[3]+v[4]'),
    'enumerators': ('enum E { A=3, B=A+4, C=0xffffu }; static const unsigned long v[]={A,B,C,B|C, (A+B)*C};','v[0]+v[1]+v[2]+v[3]+v[4]'),
    'designated': ('static int v[10]={[3]=255,[9]=8,[3]=2,[0]=3};','v[0]+v[3]+v[9]'),
    'nested': ('struct S {char a; unsigned b:4; int c[2];}; static struct S v[2]={{1,2,{3,4}},{.b=17,.c[0]=9,.a=7}};', 'v[0].c[1]+v[1].a+v[1].b+v[1].c[0]'),
    'unions': ('union U{unsigned a;char b[4];};static union U v[2]={{.b={5,4,3,2}},{.a=85}};','v[0].b[2]+v[1].a'),
    'float-and-pointer': ('static int t=4; static struct S{int *p; double a; int v[3];} v={&t,9.75,{3,4,5}};', '*v.p+(int)v.a+v.v[2]'),
    'compound': ('struct S{int a,b;}; static struct S *v[]={&(struct S){1,2}, &(struct S){3,4}};','v[0]->b+v[1]->a'),
    'local-region': ('static int v[]={1,2,3}; static int f(int z){return ({int x=z+1; x*2;});}', 'f(v[0])+f(v[2])'),
    'multi-declarator': ('static int a[3]={1,2,3}, b[3]={4,5,6};', 'a[1]+b[2]'),
    'narrow': ('static signed char a[]={255, 254, 257}; static _Bool b[]={1,0,-2};', 'a[0]+a[1]+a[2]+b[0]+b[1]+b[2]'),
    'large-list': ('static unsigned v[2049]={'+','.join(str(i%251) for i in range(2049))+'};', 'v[15]+v[255]+v[256]+v[1024]+v[2048]'),
    'nonconstant': ('extern int a;static int v[]={0,a,2};',None),
    'wrong-designator': ('static struct S{int x,y;} v={.x=2,.unresolved=6};',None),
    'excess': ('static char v[2]={1,2,3,4};','v[0]+v[1]'),
    'bad-arithmetic': ('static int v[3]={2,3/0,4};',None),
    'wrong-integer-address': ('static int *p[]={0,3,1};',None),
    'expression-qualifiers': ('static int x;static const volatile int *z[]={&x,0};','z[0]!=0'),
    'large-enum-nesting': ('enum E{A=5,B=9};struct X{int a;int b;}; static struct X v[]={'+','.join('{A,B|A}' for i in range(305))+'};','v[255].a+v[299].b'),
}
modes = {'ordinary':['-c'],'warning':['-Weverything','-c'],'debug':['-g','-c'],'tier1':['--tier1','-c'], 'scalar':['--scalar','-c'], 'typed':['--dump-typed','-c'], 'syntax':['-fsyntax-only','-Wall','-Wextra']}
prefix='extern int printf(const char *,...);\n'
def run(args):
    return subprocess.run(args,capture_output=True,timeout=75)
def sha(s):
    return hashlib.sha256(s).hexdigest()
errors=0
with (out/'results.tsv').open('w',buffering=1) as fp:
    wr=csv.writer(fp,delimiter='\t',lineterminator='\n')
    wr.writerow(['case','padded','mode','same','exit','stdout','stderr','object','clang_runtime'])
    for name,(decl,expr) in cases.items():
        for padded in [False,True]:
            src=out/'unit.c'; obj=out/'unit.o'
            source=prefix+decl+'\n'+('int main(void){printf("%llu\\n",(unsigned long long)('+expr+'));return 0;}\n' if expr else '')
            src.write_text(source+(''.join(f'typedef int StaticPad{i};\n' for i in range(2052)) if padded else ''))
            for mode,args in modes.items():
                results=[]
                for cc in (parent,candidate):
                    obj.unlink(missing_ok=True)
                    proc=run([cc,'-std=gnu23',*args,src,'-o',obj])
                    results.append((proc.returncode,proc.stdout,proc.stderr,obj.read_bytes() if obj.exists() else b''))
                equal=results[0]==results[1]; status,stdout,stderr,native=results[1]; runtime='-'
                if expr and mode in ('ordinary','tier1') and status==0:
                    generated,reference=out/'generated',out/'reference'
                    link=run([clang,'-no-pie',obj,'-o',generated]); oracle=run([clang,'-std=gnu23',src,'-o',reference])
                    if link.returncode or oracle.returncode: raise RuntimeError((name,link.stderr,oracle.stderr))
                    a,b=run([generated]),run([reference]);equal &= (a.returncode,a.stdout,a.stderr)==(b.returncode,b.stdout,b.stderr);runtime=sha(b.stdout)
                wr.writerow([name,int(padded),mode,int(equal),status,sha(stdout),sha(stderr),sha(native),runtime])
                if not equal:
                    stem=f'{name}-{int(padded)}-{mode}'
                    (out/(stem+'.c')).write_bytes(src.read_bytes())
                    for idx,result in enumerate(results):
                        for suffix,blob in zip(('stdout','stderr','o'),result[1:]): (out/f'{stem}-{idx}.{suffix}').write_bytes(blob)
                    errors+=1
sys.exit(errors!=0)
