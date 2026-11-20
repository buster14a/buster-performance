from pathlib import Path
import csv,hashlib,re,subprocess
p=Path(__file__).resolve().parent;w=p.parent;d=p/'pressure';d.mkdir(exist_ok=True);cc='/home/david/.cache/buster/toolchain/4444af0bee44de2d/llvm-23.1.4/bin/clang'
def run(*a,**kw):return subprocess.run(list(map(str,a)),check=True,**kw)
def sha(f):return hashlib.file_digest(f.open('rb'),'sha256').hexdigest()
N=24
(d/'leaves.c').write_text('#include <stdint.h>\nextern void touch_u32(void);\nvoid pressure(const volatile uint32_t *v,float *f,double *b){\n'+''.join(f'    uint32_t n{i}=v[{i}];\n' for i in range(N))+'    touch_u32();\n'+''.join(f'    f[{i}]=(float)n{i}; b[{i}]=(double)n{i};\n' for i in range(N))+'}\n')
base=(p/'oracle.c').read_text();oracle=base[base.index('static U mix('):base.index('extern float callf_u32')]
(d/'oracle.c').write_text('#include <stdint.h>\n#include <string.h>\n#include <stdio.h>\n#include <xmmintrin.h>\n#include <sys/mman.h>\n#include <unistd.h>\ntypedef unsigned long long U;\n'+oracle+'''
extern void pressure(const volatile uint32_t*,float*,double*);
int main(void){
    long pg=sysconf(_SC_PAGESIZE);char*b=mmap(0,pg*2,PROT_READ|PROT_WRITE,MAP_PRIVATE|MAP_ANONYMOUS,-1,0);
    if(b==MAP_FAILED||mprotect(b+pg,pg,PROT_NONE))return 2;
    uint32_t*input=(uint32_t*)(b+pg)-24;float f[24];double d[24];U count=0,hash=0;unsigned original=_mm_getcsr();
    for(unsigned r=0;r<1024;r++)for(unsigned mode=0;mode<4;mode++)for(unsigned env=0;env<4;env++){
        unsigned initial=0x1f80|(mode<<13)|(env&1?0x8040:0)|(env&2?0x15:0),status=initial;
        for(unsigned i=0;i<24;i++)input[i]=(r&1)?(uint32_t)mix(24*r+i):((1u<<((r+i)%32))+(i%7)-3);
        _mm_setcsr(initial);pressure(input,f,d);unsigned actual=_mm_getcsr();
        for(unsigned i=0;i<24;i++){
            int inexact;U yf=oracle(input[i],24,mode,&inexact);status|=inexact?32:0;U yd=oracle(input[i],53,mode,&inexact);
            if(fb(f[i])!=yf||db(d[i])!=yd)return 1;
            hash=(hash^yf^yd)*1099511628211ULL;count+=2;
        }
        if(actual!=status)return 1;
    }
    _mm_setcsr(original);printf("%llu guarded spill conversion results and 16384 raw MXCSR checks %016llx\\n",count,hash);return 0;
}
''')
run(cc,'-O2','-ffp-model=strict','-c',d/'oracle.c','-o',d/'oracle.o');run(cc,'-c',p/'bridge.S','-o',d/'bridge.o');rows=[]
for arch in ['x86-64','znver5']:
 for mode in ['default','post']:
  for v in ['clang','parent','head']:
   if v=='clang' and mode=='post':continue
   c=cc if v=='clang' else w/('convert' if v=='parent' else 'u32-memory')/'build/compiler';tag=f'{v}-{arch}-{mode}';o=d/(tag+'.o');ex=d/tag
   opt=['-fno-vectorize','-fno-slp-vectorize','-ffp-model=strict'] if v=='clang' else ['--tier1','--verify','--lanes','1']+(['--tier1-schedule=post'] if mode=='post' else [])
   run(c,'-O2','-march='+arch,*opt,'-c',d/'leaves.c','-o',o);run(cc,'-no-pie',o,d/'oracle.o',d/'bridge.o','-o',ex)
   asm=run('objdump','-d','-Mintel','--no-show-raw-insn',o,capture_output=True,text=True).stdout;(d/(tag+'.asm')).write_text(asm)
   stack=sum(bool(re.search(r'\[(rsp|rbp)[+-]',l)) for l in asm.splitlines());assert stack>=8,(tag,stack)
   x=run(ex,capture_output=True,text=True).stdout.strip();rows.append([v,arch,mode,sha(o),sha(ex),stack,x]);print(tag,x,stack,flush=True)
assert len(rows)==10 and len({r[-1] for r in rows})==1
with (d/'checks.tsv').open('w') as h:t=csv.writer(h,delimiter='\t',lineterminator='\n');t.writerow(['compiler','arch','schedule','object','executable','stack_address_references','oracle']);t.writerows(rows)
