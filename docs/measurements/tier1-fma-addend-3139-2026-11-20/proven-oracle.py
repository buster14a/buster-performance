"""Independently check FMA multiplicand priority with constants and integer-to-float conversions."""
from pathlib import Path
import csv,hashlib,itertools,subprocess
p=Path(__file__).resolve().parent;w=p.parent;d=p/'proven';d.mkdir(exist_ok=True);driver=[];leaves=[];test=[]
for idx,(s,t,ut,inf,one,sign,qnan,snan,ref) in enumerate([('f','float','uint32_t',0x7f800000,0x3fa00000,0x80000000,0x7fc00321,0x7f800321,'ss'),('d','double','uint64_t',0x7ff0000000000000,0x3ff4000000000000,0x8000000000000000,0x7ff8000000000321,0x7ff0000000000321,'sd')]):
 suf='f' if s=='f' else '';cs=[('one','1.25'+suf,one),('minuszero','-0.0'+suf,sign),('infinity','__builtin_inf'+suf+'()',inf),('qnan','__builtin_nan'+suf+'("0x321")',qnan),('snan','__builtin_nans'+suf+'("0x321")',snan),('neginf','-__builtin_inf'+suf+'()',sign|inf)]
 ints=[('int32','int'),('uint32','unsigned int'),('int64','long long'),('uint64','unsigned long long')]
 points=[0,sign,1,sign|1,one,sign|one,inf,sign|inf,qnan,qnan+937,sign|qnan,snan,sign|snan,inf-1,(1<<23) if s=='f' else 1<<52,one+1]
 dr=f'static const {ut} words_{s}[]={{'+','.join(f'0x{x:x}ULL' for x in points)+'};\n';makes=[];i=0
 for tag,expr,b in cs+[(a,f'({t})({k})u',None) for a,k in ints]+[('square','x',None)]:
  for left in [True,False]:
   n=tag+'_'+('left_' if left else 'right_')+s;a=expr if left else 'x';bexp='x' if left else expr
   leaves.append(f'{t} {n}({t} x,unsigned long long u,const {t} *c,unsigned long z) {{ return ({a})*({bexp})+c[z+1]; }}')
   dr+=f'extern {t} {n}({t},unsigned long long,const {t}*,unsigned long);\n'
   if b is not None:gen=f'{ut} bits=0x{b:x}ULL;memcpy(&k,&bits,sizeof(k));'
   elif tag=='square':gen='k=x;'
   else:gen=f'k={expr};'
   makes.append(f'case {i}:{{{gen} break;}}');i+=1
 names=[a.split('(')[0].split()[-1] for a in leaves[-i:]]
 dr+=f'static {t} (*const functions_{s}[])({t},unsigned long long,const {t}*,unsigned long)={{'+','.join(names)+'};\n';driver.append(dr)
 test.append(f'''static int check_{s}(void *last) {{
 volatile unsigned long long integers[]={{0,1,0x7fffffff,0x80000001,0x1000001,0x1fffffffffffffULL,0x8000000000000001ULL,~0ULL}};
 for(unsigned mode=0;mode<4;mode++)for(unsigned flush=0;flush<4;flush++)for(unsigned sticky=0;sticky<2;sticky++)for(unsigned i=0;i<16;i++)for(unsigned j=0;j<16;j++)for(unsigned n=0;n<{i};n++) {{
  {t} x,c,k=0,reference,got;{ut} xb=words_{s}[i],cb=words_{s}[j];memcpy(&x,&xb,sizeof(x));memcpy(&c,&cb,sizeof(c));memcpy(last,&c,sizeof(c));
  unsigned long long u=integers[(i+3*j)%8];unsigned init=0x1f80|(mode<<13)|((flush&1)?0x40:0)|((flush&2)?0x8000:0)|(sticky?5:0);
  unsigned status,expected;__asm__ volatile("ldmxcsr %0"::"m"(init):"memory");
  switch(n){{{''.join(makes)}}}
  {t} a=n%2?x:k,b=n%2?k:x;__asm__ volatile("vfmadd213{ref} %2,%1,%0" : "+x"(b) : "x"(a),"x"(c) : "memory");reference=b;
  __asm__ volatile("stmxcsr %0":"=m"(expected)::"memory");__asm__ volatile("ldmxcsr %0"::"m"(init):"memory");
  got=functions_{s}[n](x,u,(({t}*)last)-3,2);__asm__ volatile("stmxcsr %0":"=m"(status)::"memory");
  if(memcmp(&reference,&got,sizeof(got))||status!=expected){{fprintf(stderr,"{s} n=%u i=%u j=%u mode=%u flush=%u sticky=%u flags=%x/%x\\n",n,i,j,mode,flush,sticky,status,expected);return 1;}}
  unsigned long long raw=0;memcpy(&raw,&got,sizeof(got));hash=(hash^raw^status)*UINT64_C(1099511628211);checks++;
 }}return 0;
}}''')
(d/'leaves.c').write_text('\n'.join(leaves)+'\n')
(d/'oracle.c').write_text('#include <stdint.h>\n#include <stdio.h>\n#include <string.h>\n#include <sys/mman.h>\n#include <unistd.h>\n#pragma STDC FENV_ACCESS ON\nstatic uint64_t hash=UINT64_C(1469598103934665603),checks;\n'+'\n'.join(driver+test)+'''
int main(void){
 size_t pg=(size_t)sysconf(_SC_PAGESIZE);char*b=mmap(NULL,2*pg,PROT_READ|PROT_WRITE,MAP_PRIVATE|MAP_ANONYMOUS,-1,0);
 if(b==MAP_FAILED||mprotect(b+pg,pg,PROT_NONE))return 2;
 if(check_f(b+pg-4)||check_d(b+pg-8))return 1;
 printf("%llu hardware value and raw MXCSR checks %016llx\\n",(unsigned long long)checks,(unsigned long long)hash);return 0;
}
''')
cc='/home/david/.cache/buster/toolchain/4444af0bee44de2d/llvm-23.1.4/bin/clang'
def run(*a,**kw):return subprocess.run(list(map(str,a)),check=True,**kw)
def sha(f):return hashlib.file_digest(f.open('rb'),'sha256').hexdigest()
run(cc,'-O1','-march=x86-64-v3','-ffp-model=strict','-c',d/'oracle.c','-o',d/'driver.o')
rows=[]
for arch,mode,v in itertools.product(('x86-64-v3','znver5'),('default','post'),('parent','first','head')):
 c={'parent':w/'fma/build/compiler','first':p/'first-prototype/compiler','head':w/'fma-addend/build/compiler'}[v];tag=f'{v}-{arch}-{mode}';obj=d/(tag+'.o');ex=d/tag
 run(c,'--tier1','--verify','--lanes','1','-O2','-march='+arch,*(['--tier1-schedule=post'] if mode=='post' else []),'-c',d/'leaves.c','-o',obj)
 run(cc,'-no-pie',d/'driver.o',obj,'-o',ex);z=run(ex,capture_output=True,text=True).stdout.strip();print(tag,z,flush=True)
 asm=run('objdump','-d','-Mintel','--no-show-raw-insn',obj,capture_output=True,text=True).stdout;(d/(tag+'.asm')).write_text(asm);rows.append([v,arch,mode,sha(obj),sha(ex),z,sum('vfmadd213' in l and 'PTR' in l for l in asm.splitlines())])
assert len(set(r[-2] for r in rows))==1
with (d/'checks.tsv').open('w') as h:t=csv.writer(h,delimiter='\t',lineterminator='\n');t.writerow(['variant','arch','schedule','object','executable','oracle','213_memory_sites']);t.writerows(rows)
