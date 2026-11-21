from pathlib import Path
import re
d=Path(__file__).resolve().parent
s=(d/'tools/scratchfargather.c').read_text()
fs={'operators':1,'operators_dense':1,'by_table':1,'graph':2,'given_types':4,'children':3,'operand_counts':1,'given_store':1,'up':1,'context_given':1,'index':1,'counts_whole':1}
p=s.index('typedef struct Lanes Lanes;')
s=s[:p]+'''// Immutable input for one 64-record block. Adjacent vectors share a hardware-prefetch stream.
typedef struct PackedInput {
'''+''.join('    __m512i '+f+(';' if n==1 else f'[{n}];')+'\n' for f,n in fs.items())+'} PackedInput;\n'+s[p:]
s=s.replace('    uint32_t scratch_origin;', '    PackedInput* packed;\n    uint32_t scratch_origin;')
p=s.index('    free(learned);')
init='''    lanes->packed = must(aligned_alloc(64, ((uint64_t)lanes->blocks+2) * sizeof(PackedInput)));
    for (uint32_t b=0; b<lanes->blocks+2; ++b) {
        const int64_t at=((int64_t)b-1)*64;
        PackedInput* block=lanes->packed+b;
'''
for f,n in fs.items():
 for i in range(n):
  member=f+(f'[{i}]' if n!=1 else '')
  init+=f'        block->{member} = _mm512_load_si512(lanes->{member}+at);\n'
s=s[:p]+init+'    }\n'+s[p:]
a=s.index('static __attribute__((noinline)) void lanes_types(');b=s.index('// The template of each record of blocks',a);chunk=s[a:b]
def rep(m):
 field,ix,delta=m.groups()
 if field not in fs:return m.group()
 offs={' + 64':'+2',None:'+1',' - 64':''}[delta]
 return f'lanes->packed[block{offs}].{field}'+(ix or '')
chunk=re.sub(r'_mm512_load_si512\(lanes->([a-z_]+)(\[[^\]]+\])? \+ base( \+ 64| - 64)?\)',rep,chunk)
s=s[:a]+chunk+s[b:];(d/'tools/packed.c').write_text(s)
