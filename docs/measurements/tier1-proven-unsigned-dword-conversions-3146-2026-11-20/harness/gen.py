from pathlib import Path
import shutil
p=Path(__file__).resolve().parent;w=p.parent
cases=[('parameter','return x;','x'),('load','return *a;','y'),('sum','return x + key;','x+key'),('xor','return x ^ key;','x^key'),('dirtycall','return dirty_u32(x);','x'),('volatileload','return *(const volatile uint32_t*)a;','y'),('aftercall','uint32_t n=*a; touch_u32(); return n;','y'),('mixed','uint32_t n; if(key&1)n=x;else n=*(const volatile uint32_t*)a;return n;','(key&1)?x:y'),('signedview','int32_t n=*(const int32_t*)a; *side=(int64_t)n; return (uint32_t)n;','y'),('rotate','return (x << (key&31)) | (x >> ((0u-key)&31));','(x<<(key&31))|(x>>((0u-key)&31))')]
pr='#include <stdint.h>\nextern uint32_t dirty_u32(uint32_t);\nextern void touch_u32(void);\n'
ds=[];arrays=[];sels=[]
for tag,t in [('f','float'),('d','double')]:
 for n,body,expr in cases:
  sig=f'{t} c_{n}_{tag}(uint32_t x,const uint32_t *a,uint32_t key,uint64_t *side)'
  pr+=sig+' { '+body+' }\n';ds.append('extern '+sig+';')
 arrays.append('static '+t+' (*const calls_'+tag+'[])(uint32_t,const uint32_t*,uint32_t,uint64_t*)={'+','.join('c_'+n+'_'+tag for n,_,_ in cases)+'};')
for i,(_,_,x) in enumerate(cases):sels.append(f'case {i}:return {x};')
(p/'leaves.c').write_text(pr);(p/'bridge.S').write_text('''.text
.globl callf_u32,calld_u32,dirty_u32,touch_u32
callf_u32:
calld_u32:
    jmp *%r8
dirty_u32:
    movl %edi,%eax
    movabsq $0xa5a55a5a00000000,%r10
    orq %r10,%rax
    ret
touch_u32:
    movabsq $0x87987665a5a5a5a5,%rdi
    movabsq $0xfedc9876f00d1234,%rsi
    movabsq $0xadda12349876fdec,%rdx
    ret
.section .note.GNU-stack,"",@progbits
''')
orig=(w/'unsigned64-evidence/oracle.c').read_text();integer=orig[orig.index('static U mix('):orig.index('int main(void)')]
(p/'oracle.c').write_text('#include <stdint.h>\n#include <stdio.h>\n#include <string.h>\n#include <xmmintrin.h>\n#include <sys/mman.h>\n#include <unistd.h>\ntypedef unsigned long long U;\n'+'\n'.join(ds+arrays)+'\n'+integer+'''
extern float callf_u32(uint64_t,const uint32_t*,uint32_t,uint64_t*,float (*)(uint32_t,const uint32_t*,uint32_t,uint64_t*));
extern double calld_u32(uint64_t,const uint32_t*,uint32_t,uint64_t*,double (*)(uint32_t,const uint32_t*,uint32_t,uint64_t*));
static uint32_t wanted(unsigned k,uint32_t x,uint32_t y,uint32_t key){switch(k){'''+''.join(sels)+'''}return 0;}
int main(void){
    uint32_t points[8000];unsigned n=0,initialcsr=_mm_getcsr();long pg=sysconf(_SC_PAGESIZE);
    char *memory=mmap(NULL,pg*2,PROT_READ|PROT_WRITE,MAP_PRIVATE|MAP_ANONYMOUS,-1,0);
    if(memory==MAP_FAILED||mprotect(memory+pg,pg,PROT_NONE))return 2;
    uint32_t *ptr=(uint32_t*)(memory+pg)-1;
    for(unsigned e=0;e<32;e++)for(int adj=-5;adj<=5;adj++){points[n++]=(1u<<e)+adj;points[n++]=~((1u<<e)+adj);}
    for(unsigned e=24;e<32;e++){unsigned step=1u<<(e-23);for(unsigned j=0;j<8;j++)for(int d=-3;d<=3;d++)points[n++]=(1u<<e)+step*j+(step/2)+d;}
    for(unsigned i=0;i<2048;i++)points[n++]=(uint32_t)mix(i+9713);
    uint64_t cnt=0,hash=0;
    for(unsigned mode=0;mode<4;mode++)for(unsigned env=0;env<4;env++)for(unsigned i=0;i<n;i++){
        uint32_t x=points[i],y=points[(71*i+17)%n],key=(uint32_t)mix(i);*ptr=y;
        uint64_t raw=((mix(i+373)|0x8000000000000000ULL)&0xffffffff00000000ULL)|x;
        unsigned initial=0x1f80|(mode<<13)|(env&1?0x8040:0)|(env&2?0x15:0);
        for(unsigned k=0;k<10;k++)for(unsigned precision=0;precision<2;precision++){
            int inexact;uint32_t value=wanted(k,x,y,key);uint64_t expect=oracle(value,precision?53:24,mode,&inexact),side=0x1234f0f05a5a4321ULL;
            _mm_setcsr(initial);uint64_t got=precision?db(calld_u32(raw,ptr,key,&side,calls_d[k])):fb(callf_u32(raw,ptr,key,&side,calls_f[k]));
            unsigned flags=_mm_getcsr();uint64_t sideexpect=k==8?(uint64_t)(int64_t)(int32_t)y:0x1234f0f05a5a4321ULL;
            if(got!=expect||flags!=(initial|(inexact?32:0))||side!=sideexpect){fprintf(stderr,"case %u precision %u mode %u input %08x expected %llx got %llx flags %x/%x side %llx/%llx\\n",k,precision,mode,x,(U)expect,(U)got,initial|(inexact?32:0),flags,(U)sideexpect,(U)side);return 1;}
            hash=(hash^got^side^flags)*1099511628211ULL;cnt++;
        }
    }
    _mm_setcsr(initialcsr);printf("%llu integer-oracle result, MXCSR and side-effect checks %016llx\\n",(U)cnt,(U)hash);return 0;
}
''')
loop=p/'loops';loop.mkdir(exist_ok=True)
for n in ['stream.c','driver.c','run.py']:
 s=(w/'unsigned64-evidence/loops'/n).read_text().replace('typedef unsigned long long Input;','typedef unsigned int Input;').replace("w/'eighteen-control/build/compiler'","w/'late-control/build/compiler'").replace("w/'unsigned64/build/compiler'","w/'unsigned32/build/compiler'").replace('kinds=[(64,o,1)','kinds=[(32,o,1)')
 (loop/n).write_text(s)
