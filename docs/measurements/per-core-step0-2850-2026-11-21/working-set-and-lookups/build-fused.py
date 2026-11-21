from pathlib import Path
d=Path(__file__).resolve().parent
for parent,name in [('single','fused'),('windowone','fusedwindow')]:
 s=(d/'tools'/f'{parent}.c').read_text(); a=s.index('// The order the hashes of a block');b=s.index('// The template of each record of blocks',a)
 code=s[a:b];s=s[:a]+s[b:]
 code=code.replace('static __attribute__((noinline)) void lanes_keys(Lanes* lanes, uint32_t first, uint32_t end)','static inline __attribute__((always_inline)) void lanes_keys_block(Lanes* lanes, uint32_t block)')
 code=code.replace('    for (uint32_t block = first; block < end; block += 1)\n    {','    {')
 p=s.index('static __attribute__((noinline)) void lanes_contexts(');s=s[:p]+code+s[p:]
 p=s.index('    lanes->context_rounds += rounds;');start=s.rindex('    }',0,p)
 s=s[:start]+'        lanes_keys_block(lanes,block);\n'+s[start:]
 s=s.replace('            lanes_keys(lanes, first_block, end_block);','            // Context selection finished each block\'s templates before moving upstream.')
 (d/'tools'/f'{name}.c').write_text(s)
