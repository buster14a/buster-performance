from pathlib import Path
import re
d=Path(__file__).resolve().parent
for base in ('farlanes','fargather'):
 s=(d/'tools'/f'{base}.c').read_text()
 s=s.replace('    uint64_t* hashes;', '    uint32_t scratch_origin;\n    uint32_t scratch_count;\n    uint64_t* hashes;')
 s=s.replace('static void lanes_make(Lanes* lanes, const Unit* unit, const Tables* tables)','static void lanes_make(Lanes* lanes, const Unit* unit, const Tables* tables, uint32_t window)').replace('lanes_make(&lanes, &unit, &tables);','lanes_make(&lanes, &unit, &tables, window);')
 p=s.index('    lanes->places = must(')
 s=s[:p]+'''    // A window includes the expression that crosses its target and the enclosing vector blocks.
    // Bound it from the longest input tree so an oversized expression remains one window.
    uint32_t longest=0;
    for (uint32_t r=0; r<unit->root_count; ++r) {
        uint32_t width=unit->roots[r]+1-unit->root_first[r];
        if (width>longest) longest=width;
    }
    uint64_t bound = window == 0 ? count : (uint64_t)window + longest + 63;
    lanes->scratch_count = bound < count ? (uint32_t)bound : count;
    const uint64_t scratch = (uint64_t)lanes->scratch_count;
'''+s[p:]
 a=s.index('    lanes->places = must(');b=s.index('    lanes->chosen_kept =',a)
 head=s[a:b]
 head=head.replace('((uint64_t)count + 64)', '(scratch + 64)').replace('lanes_column(count)', 'lanes_column((uint32_t)scratch)').replace('((uint64_t)lanes->blocks + 2) * 64', '((scratch+127)/64) * 64')
 head=head.replace("lanes->span8 = lanes_column((uint32_t)scratch);", "lanes->span8 = lanes_column(count);")
 s=s[:a]+head+s[b:]
 s=s.replace('((uint64_t)lanes->count + 64) * sizeof(uint32_t)','((uint64_t)lanes->scratch_count + 64) * sizeof(uint32_t)')
 s=s.replace('        const uint32_t end_block = (end + 63) / 64;', '        const uint32_t end_block = (end + 63) / 64;\n        lanes->scratch_origin = first_block*64;')
 s=s.replace('lanes->hashes + base','lanes->hashes + (base-lanes->scratch_origin)').replace('chosen[base + lanes_hash_order[j]]','chosen[base-lanes->scratch_origin + lanes_hash_order[j]]').replace('lanes->chosen+base','lanes->chosen+(base-lanes->scratch_origin)').replace('lanes->chosen + first,','lanes->chosen + (first-lanes->scratch_origin),')
 a=s.index('static __attribute__((noinline)) uint64_t lanes_expand(');b=s.index('    return out_end;',a);chunk=s[a:b]
 chunk=chunk.replace('    const uint32_t first =','    const uint32_t origin = lanes->scratch_origin;\n    const uint32_t first =',1)
 for arr in ['chosen','places','gaps']:
  for key in ['record','root_first','before[run]']:
   chunk=chunk.replace(f'{arr}[{key}]',f'{arr}[{key} - origin]')
  for key in ['group','root_first']:
   chunk=chunk.replace(f'{arr} + {key}',f'{arr} + ({key} - origin)')
 chunk=chunk.replace('lanes_rows(places, unit->payload,','lanes_rows(places, unit->payload + origin,').replace('unit->out_values, first, end);','unit->out_values, first-origin, end-origin);')
 s=s[:a]+chunk+s[b:]
 (d/'tools'/('scratch'+base+'.c')).write_text(s)
