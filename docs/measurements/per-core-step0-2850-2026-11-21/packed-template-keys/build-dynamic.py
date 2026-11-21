from pathlib import Path
import re
d=Path(__file__).resolve().parent
out=['// Partition the first context answer by dependence on the parent context.']
for i,corpus in enumerate(['musl','sqlite3']):
 s=(d/f'baked-{corpus}.h').read_text();fp=re.search(r'#define BAKED_c_PRINT (.+)',s)[1]
 out.append(f'{"#if" if i==0 else "#elif"} BAKED_c_PRINT == {fp}')
 a=s.index('static inline __m512i baked_c_answer_0(');b=s.index('    return value;',a)
 fn=s[a:b];signature=fn.split('\n')[0]
 parts=re.findall(r'    value = [^\n]+;\n|    \{\n.*?    \}\n', fn,re.S)
 assert len(parts)>1
 dyn=[];stat=[];masks=[]
 for part in parts:
  # The close must end an exact shape, so every extracted piece contains the select.
  cond=re.search(r'block->((?:copy|step)_lanes\[\d+\]) & lanes',part)
  assert cond
  if 'inputs[1]' in part:dyn.append(part);masks.append('block->'+cond[1])
  else:stat.append(part)
 for name,group in [('static',stat),('inherited',dyn)]:
  out+=[signature.replace('baked_c_answer_0','baked_c_'+name),' {',''.join(group),'    return value;','}']
 out+=['static inline __mmask64 baked_c_inherits(const LanesBlock* block){return '+(' | '.join(masks) or 'UINT64_C(0)')+';}']
out+=['#else','#error unexpected frozen baked rules','#endif'];(d/'tools/baked_splits.h').write_text('\n'.join(out)+'\n')
for parent,name in [('single','dynamic'),('fused','dynamicfused')]:
 s=(d/'tools'/f'{parent}.c').read_text().replace('#include LANES_BAKED','#include LANES_BAKED\n#include "baked_splits.h"')
 p=s.index('            bool changed = contexts;')
 s=s[:p]+s[p:].replace('            bool changed = contexts;', '''#ifdef LANES_BAKED
            dense=baked_c_static(&state,dense,~UINT64_C(0),inputs);
            const __mmask64 inherited=baked_c_inherits(&state);
            const __mmask64 nested=inherited & _mm512_movepi8_mask(_mm512_permutex2var_epi8(_mm512_movm_epi8(inherited),parent,_mm512_setzero_si512()));
            bool changed=inherited!=0;
#else
            bool changed=contexts;
#endif''',1)
 s=s.replace('const __m512i next = baked_c_answer_0(&state, dense, ~UINT64_C(0), inputs);','const __m512i next = baked_c_inherited(&state, dense, ~UINT64_C(0), inputs);')
 s=s.replace('                dense = next;','''#ifdef LANES_BAKED
                changed = changed && nested != 0;
#endif
                dense = next;''')
 (d/'tools'/f'{name}.c').write_text(s)
