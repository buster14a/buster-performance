from pathlib import Path
import itertools,subprocess,os,re,sys,json
root=Path(__file__).resolve().parent
cc=str(root/(sys.argv[1] if len(sys.argv)>1 else "project-ec76"))
out=root/os.environ.get('BUSTER_SUBSCRIPT_SUITE','directed')
out.mkdir(exist_ok=True)
pre="""
struct Pair { int x; int a[4]; };
union Variant { int i; unsigned u; int *ptr; };
enum E { M=-3, Z=0, P=3 };
static int global[8];
static const unsigned char chars[] = {1,2,3};
static const int table[3][4] = {{1}};
extern int (*fromfn(void))[4];
typedef int Row[4];
"""
types=("char","signed char","unsigned char","short","unsigned short","int","unsigned","long","unsigned long","long long","unsigned long long","__int128","unsigned __int128","_Bool","enum E","_BitInt(17)","unsigned _BitInt(71)")
cases=[]
for i,t in enumerate(types):
    for j,base in enumerate(("p","cp","vp","gp","local","global","s->a","r[0]","*fromfn()","(q ? p : gp)","(p+q)","(int *)0","(int *)32","(int *)v","table[q]","chars")):
        for k,idx in enumerate(("idx","(const "+t+")idx", "("+t+")-1","("+t+")0","("+t+")3","ix","q ? idx : q","q++")):
            body="return (int)"+base+"["+idx+"];" if re.fullmatch(r'[a-z]+|s->a|r\[0\]|table\[q\]',base) else "return (int)("+base+")["+idx+"];"
            cases.append(f"int f{i}_{j}_{k}(int *p, const int *cp, volatile int *vp, int *volatile gp, {t} idx, volatile {t} ix, struct Pair *s, Row *r, int q, unsigned long v) {{ int local[4]={{0}}; {body} }}")
cases += [
"int reverse(int *p,int i) { return i[p]; }",
"int access(int *p,int i) { return &p[i] == p; }",
"int va(int n, int i){ int a[n]; return a[i]; }",
"int indexbit(int *p, struct Bits { signed int i:3; } b){ return p[b.i]; }",
"int arith(union Variant *v, int n){return v->ptr[n];}",
"int side(int *p, volatile int *v){return p[(*v)++];}",
"int reg(int i){ register int *p=global; return p[i]; }",
"int nested(int i){ return table[1][i]; }",
"int str(int i){ return \"0123\"[i]; }",
"int atom(_Atomic(int*) *p, int i){return (*p)[i];}",
"int complete(struct Later *p,int i); struct Later {int x;}; int later(struct Later *p,int i){return p[i].x;}",
"int constrow(const Row *r,int i){return (*r)[i];}",
"int volatile_row(volatile Row *r,int i){return (*r)[i];}",
]
(out/'valid.c').write_text(pre+'\n'.join(cases)+'\n')
invalid={
'incomplete':'struct X; int f(struct X *p) {return (int)(unsigned long)&p[1];} struct X{int x;};',
'nonint':'int f(int *p,double i){return p[i];}',
'notpointer':'int f(int a,int i){return a[i];}',
'register-array':'int f(int i){register int a[4];return a[i];}',
'function':'typedef int F(void); int f(F *p,int n){return p[n]();}',
'bitfield-address':'struct S { int x:3; }; int f(struct S *p,int i){return (int)(unsigned long)&p[i].x;}',
}
for name,t in invalid.items(): (out/(name+'.c')).write_text(t+'\n')
def run(extra,args):
    return subprocess.run([cc,*args],stdout=subprocess.PIPE,stderr=subprocess.PIPE,env={**os.environ,**extra})
def canonical(p):
    return [line for line in p.stdout.decode().splitlines() if line.startswith(("node-facts: taken","node-facts: lookup=","node-census: files=","node-facts: window records=","node-facts: records="))]
summary=[]
for f in sorted(out.glob('*.c')):
    for style in ([],["-Wall","-Wextra"]):
        a=run({},["-std=gnu23",*style,"-c",str(f),"-o",str(out/'a.o')])
        b=run({"BUSTER_SUBSCRIPT_PROJECT":"1"},["-std=gnu23",*style,"-c",str(f),"-o",str(out/'b.o')])
        assert (a.returncode,a.stdout,a.stderr)==(b.returncode,b.stdout,b.stderr),(f,style,a.stderr[:300],b.stderr[:300])
        assert a.returncode or (out/'a.o').read_bytes()==(out/'b.o').read_bytes()
        summary.append(("driver",f.name,str(style),a.returncode,len(a.stderr)))
    for mode,packed in itertools.product(([],['--facts-lean']),([],['--facts-packed'])):
        for scalar in ([],['--scalar']):
            args=['measure-node-machine','--shadow','--facts',*mode,*packed,*scalar,'--passes','1','--list','1','-std=gnu23',str(f)]
            a=run({},args); b=run({'BUSTER_SUBSCRIPT_VERIFY':'1','BUSTER_SUBSCRIPT_PROJECT':'1'},args)
            c=canonical(a);d=canonical(b)
            assert (a.returncode,c,a.stderr)==(b.returncode,d,b.stderr),(f,args,a.returncode,b.returncode,a.stderr[:200],b.stderr[:200],c,d)
            assert b.returncode>=0
            if f.stem=='valid': assert b.returncode==0 and any('lookup=[] records=' in r for r in d),(f,d,b.stderr[:300])
            summary.append(("shadow",f.name,','.join([*mode,*packed,*scalar]) or "whole",b.returncode,'|'.join(r for r in d if "lookup=[]" in r or "differences=" in r)))
(out/'results.jsonl').write_text(''.join(json.dumps(row)+'\n' for row in summary))
print(len(cases),len(summary))
