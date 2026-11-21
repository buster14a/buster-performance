from pathlib import Path
import re
d=Path(__file__).resolve().parent
for source,dest in [('scratchfargather','window'),('single','windowone')]:
 s=(d/'tools'/f'{source}.c').read_text()
 fields={'facts':7,'types':4,'typed':1,'store':1,'context':1,'context_dense':1,'target_class':1,'target_facts':1}
 s=s.replace('    uint32_t scratch_origin;', ''.join(f'    uint8_t* local_{f}'+(f'[{n}]' if n>1 else '')+';\n' for f,n in fields.items())+'    uint32_t scratch_origin;')
 pos=s.index('static void lanes_make(')
 helper='''static uint32_t block_window_end(const Unit* unit,uint32_t root,uint32_t window) {
    const uint32_t first=unit->root_first[root];
    uint32_t stop=root+1;
    while(stop<unit->root_count && (window==0 || unit->roots[stop-1]+1-first<window || (unit->roots[stop-1]&63)!=63))
        ++stop;
    return stop;
}

'''
 s=s[:pos]+helper+s[pos:]
 a=s.index('    uint32_t longest=0;');b=s.index('    lanes->places =',a)
 s=s[:a]+'''    uint32_t largest=0;
    for(uint32_t r=0;r<unit->root_count;) {
        uint32_t stop=block_window_end(unit,r,window);
        uint32_t n=unit->roots[stop-1]+1-unit->root_first[r];
        largest=n>largest?n:largest;
        r=stop;
    }
    const uint64_t scratch=largest;
    lanes->scratch_count=largest;
'''+''.join(f'    lanes->local_{f}'+(f'[{i}]' if n>1 else '')+' = lanes_column(largest+64);\n' for f,n in fields.items() for i in range(n))+s[b:]
 a=s.index('        uint32_t end_root = root + 1;',s.index('uint64_t lanes_run('));b=s.index('        const uint32_t end = ',a)
 s=s[:a]+'        const uint32_t end_root=block_window_end(unit,root,window);\n'+s[b:]
 a=s.index('static void lanes_type_scalar(');b=s.index('static __attribute__((noinline)) void lanes_types(',a)
 chunk=s[a:b].replace('lanes->facts[f][g]','lanes->local_facts[f][g-lanes->scratch_origin]').replace('lanes->typed[g]','lanes->local_typed[g-lanes->scratch_origin]');s=s[:a]+chunk+s[b:]
 a=s.index('static __attribute__((noinline)) void lanes_types(');b=s.index('static void lanes_context_scalar(',a)
 ch=s[a:b];ch=ch.replace('lanes->facts[f] + base - 64','lanes->local_facts[f] + (base-lanes->scratch_origin) - 64').replace('lanes->typed + base - 64','lanes->local_typed + (base-lanes->scratch_origin) - 64')
 p=ch.index('                // A ready record'); ch=ch[:p]+ch[p:].replace('lanes->facts[f] + base','lanes->local_facts[f] + (base-lanes->scratch_origin)').replace('lanes->typed + base','lanes->local_typed + (base-lanes->scratch_origin)').replace('lanes->types[2 * k + f] + base','lanes->local_types[2 * k + f] + (base-lanes->scratch_origin)').replace('lanes->store + base','lanes->local_store + (base-lanes->scratch_origin)')
 p=ch.index('            for (uint32_t f = 0; f < LANES_FACTS;',ch.index('                rounds += 1;'));q=ch.index('        // A store',p)
 ch=ch[:p]+'''        }
        for (uint32_t f=0; f<LANES_FACTS; ++f)
            _mm512_store_si512(lanes->local_facts[f] + (base-lanes->scratch_origin), facts[f]);
        _mm512_store_si512(lanes->local_typed + (base-lanes->scratch_origin), typed);
'''+ch[q:]
 s=s[:a]+ch+s[b:]
 a=s.index('static void lanes_context_scalar(');b=s.index('static inline __m512i lanes_reach',a)
 ch=s[a:b]
 for f in ('context','context_dense','target_class','target_facts'):ch=ch.replace(f'lanes->{f}[g]',f'lanes->local_{f}[g-lanes->scratch_origin]')
 s=s[:a]+ch+s[b:]
 a=s.index('static __attribute__((noinline)) void lanes_contexts(');b=s.index('// The order the hashes',a)
 ch=s[a:b].replace('lanes->facts[f] + base','lanes->local_facts[f] + (base-lanes->scratch_origin)').replace('lanes->context_dense + base + 64','lanes->local_context_dense + (base-lanes->scratch_origin) + 64')
 fs=['context','context_dense','target_class','target_facts']
 p=ch.index('        if (live != 0)')
 ch=ch[:p]+''.join(f'        __m512i out_{f}=_mm512_load_si512(lanes->{f}+base);\n' for f in fs)+ch[p:]
 for f in fs[1:]:
  ch=ch.replace(f'_mm512_load_si512(lanes->{f} + base);',f'out_{f};')
 for f in fs:
  ch=re.sub(rf'_mm512_mask_storeu_epi8\(lanes->{f} \+ base, taken, (.*)\);',rf'out_{f}=_mm512_mask_mov_epi8(out_{f},taken,\1);',ch)
 p=ch.index('        // The operands out of the layout')
 ch=ch[:p]+''.join(f'        _mm512_store_si512(lanes->local_{f}+(base-lanes->scratch_origin),out_{f});\n' for f in fs)+ch[p:]
 s=s[:a]+ch+s[b:]
 a=s.index('static __attribute__((noinline)) void lanes_keys(');b=s.index('// The template of each record',a);ch=s[a:b]
 for f in fields:ch=re.sub(rf'lanes->{f}(\[[^\]]+\])? \+ base',lambda m:f'lanes->local_{f}'+(m[1] or '')+' + (base-lanes->scratch_origin)',ch)
 s=s[:a]+ch+s[b:]
 # Collect all verification columns after their last read. Windows end between complete expressions on a block boundary.
 a=s.index('        root = end_root;',s.index('uint64_t lanes_run('))
 ops=[]
 for f in ['typed','facts','context','context_dense','target_class','target_facts']:
  n=fields[f]
  for i in range(n):
   idx=f'[{i}]' if n>1 else ''
   ops.append(f'            memcpy(lanes->{f}{idx}+first,lanes->local_{f}{idx},end-first);')
 s=s[:a]+'        if(lanes->keep) {\n'+'\n'.join(ops)+'\n        }\n'+s[a:]
 (d/'tools'/f'{dest}.c').write_text(s)
