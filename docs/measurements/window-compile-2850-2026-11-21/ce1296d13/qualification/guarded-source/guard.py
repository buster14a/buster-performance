"""Compile large guarded field-access programs with both Buster revisions and run valid objects against Clang."""
import csv, gzip, hashlib, os, shutil, subprocess, sys
from pathlib import Path
d = Path(__file__).resolve().parent; w = d.parent
out = d / 'guard'; out.mkdir(exist_ok=True)
trees = {'base':w/'main-fbef-clean/build/compiler','candidate': w/'typed-call-signatures/build/compiler'}
clang = Path('/home/david/.cache/buster/toolchain/4444af0bee44de2d/llvm-23.1.4/bin/clang')
pad='int warm(int i){\n'+('i = (i ^ 79) + 13;\n'*880)+'return i;}\n'
types = '''
struct Rec { int value; unsigned bits:5; union { int alias; short words[2]; };
             struct Rec *next; int slots[3]; };
static struct Rec a = { .value=11, .bits=9, .alias=7, .slots={2,5,8} };
static struct Rec b = { .value=15, .bits=25, .alias=6, .slots={4,3,7} };
static struct Rec *pass(struct Rec *p) { return p; }
int printf(const char *, ...);
'''
read = '''
int fields(struct Rec *p, struct Rec *q, const struct Rec *c,
           volatile struct Rec *restrict v, struct Rec *volatile vp) {
  int x=p->value+q->value+p->bits+q->bits+p->alias+q->alias;
  x+=p->slots[1]+q->slots[2]+c->slots[0]+v->slots[1];
  x+=p->next->value+q->next->value+pass(p)->value+vp->value;
  return x;
}
int main(void) {
 a.next=&b;b.next=&a;
 int x=fields(&a,&b,&b,&a,&b);
 a.value+=5; b.bits+=1;
 printf("%d %d\\n",x,fields(&b,&a,&a,&b,&a));
 return 0;
}
'''
cases={'ordinary': (types+read, True), 'fenv': ('#pragma STDC FENV_ACCESS ON\n'+types+read, True),
       'offset': (types+'''struct Flex { struct Rec *r; int first; char tail[]; };
static struct Flex f={&a,12}; static const int *fixed=&a.slots[1];
int main(void){ struct Flex *s=&f; struct Flex *t=&f;
printf("%d %d %ld\\n",s->r->value+t->r->value,s->first+*fixed,
       (long)(s->tail - (char *)t));return 0;}''',True),
       'incomplete': ('struct Later; int early(struct Later *p){return p->x+p->x;}\nstruct Later {int x;}; int late(struct Later *p){return p->x+p->x;}\n',False),
       'const-field': (types+'int bad(const struct Rec *p){int x=p->value+p->value; p->value=x;return x;}\n',False),
       'bitfield-address':(types+'int *bad(struct Rec *p){int x=p->bits+p->bits; return &p->bits;}\n',False),
       'missing': (types+'int bad(struct Rec *p){int x=p->value+p->value;return p->invalid+x;}\n',False),
       'atomic': (types+'int bad(_Atomic(struct Rec) *p){return p->value+p->value;}\n',False),
       'shadow': (types+'''static int read1(struct Rec *p){return p->value+p->value;}
int main(void){struct Rec {short x;int value;};struct Rec local={1,40};struct Rec *p=&local;
int x=read1(&a)+p->value+p->value; printf("%d\\n",x);return 0;}''',True)}
cases['guarded-bitwise'] = (types + '''
static int bits(struct Rec *p, struct Rec *q, unsigned m) {
  return (p->value & m) ^ (m | q->alias) ^ (p->bits & (q->value ^ m)) ^ (q->bits | m);
}
int main(void) {
 unsigned long long hash=17;
 for(unsigned i=0;i<4096;i++) {
   a.value = (int)(i*7u);b.value=(int)(i*73u);
   a.bits=i&31; b.bits=(i^17)&31;
   hash=hash*131+(unsigned)bits((i&4)?&a:&b,(i&8)?&a:&b,i*17u);
 }
 printf("%llu\\n",hash);
 return 0;
}
''',True)
for name,(body,_) in cases.items(): (out/(name+'.c')).write_text(pad+body+'\n')
if len(sys.argv)>1 and sys.argv[1]=='generate': sys.exit(0)
def digest(s): return hashlib.sha256(s).hexdigest()
def capture(cmd,stem):
    r=subprocess.run(list(map(str,cmd)),stdout=subprocess.PIPE,stderr=subprocess.PIPE,timeout=120)
    for k in ('stdout','stderr'):
        (out/(stem+'.'+k+'.gz')).write_bytes(gzip.compress(getattr(r,k),mtime=0))
    return (r.returncode,digest(r.stdout),digest(r.stderr))
modes={'object':['-c'],'policy':['-c','-g','-Wall','-Wextra'],'tier1':['-c','--tier1'],
       'typed':['-fsyntax-only','--dump-typed','--dump-static'],'transition':['-fsyntax-only','--check-transitions','--dump-typed'],
       'verify':['-fsyntax-only','--verify','--dump-typed'],'scalar':['-fsyntax-only','--scalar','--dump-typed']}
with (out/'receipts.tsv').open('w',buffering=1) as f:
    wr=csv.writer(f,delimiter='\t',lineterminator='\n');wr.writerow(['case','mode','compiler','status','stdout','stderr','object'])
    for case,(_,valid) in cases.items():
        src=out/(case+'.c'); obj=out/'test.o';exe=out/'test.exe'
        if valid:
            r=capture([clang,'-std=gnu17','-O0',src,'-o',exe],case+'.clang-build');assert r[0]==0,(case,r);origin=capture([exe],case+'.clang-run')
            wr.writerow([case,'execute','clang',*origin,'-']);assert origin[0]==0
        for mode,flags in modes.items():
            twins=[]
            for label,compiler in trees.items():
                obj.unlink(missing_ok=True)
                add=['-o',obj] if '-c' in flags else []
                stem=f'{case}.{mode}.{label}';r=capture([compiler,'--lanes','1','-nostdinc','-std=gnu17',*flags,src,*add],stem)
                h=digest(obj.read_bytes()) if obj.exists() else '-';twins.append((*r,h))
                wr.writerow([case,mode,label,*r,h])
                if valid and mode in ('object','tier1'):
                    assert r[0]==0 and h!='-',(case,mode,label,r)
                    l=capture([clang,obj,'-o',exe],stem+'.link');assert l[0]==0,(case,mode,label,l)
                    run=capture([exe],stem+'.run');wr.writerow([case,mode+'.execute',label,*run,'-'])
                    assert run==origin,(case,mode,label,run,origin)
            assert twins[0]==twins[1],(case,mode,twins)
            if not valid: assert twins[0][0]!=0,(case,mode,twins[0])
print(f'{len(cases)} cases, {len(cases)*len(modes)} exact parent comparisons')
