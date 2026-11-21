from pathlib import Path
d=Path(__file__).resolve().parent
s=(d/'tools/dynamic.c').read_text();repair=(d/'tools/sparserepair.c').read_text()
a=s.index('static inline void lanes_run_records');b=s.index('// `length` entries',a)
ar=repair.index('static inline void lanes_run_records');br=repair.index('// `length` entries',ar)
s=s[:a]+repair[ar:br]+s[b:]
a=s.index('// Split X only at roots');b=s.index('// The second path over the whole unit',a)
ar=repair.index('// Restore distant expressions');br=repair.index('// The second path over the whole unit',ar)
s=s[:a]+repair[ar:br]+s[b:]
s=s.replace('lanes_run_records(lanes, record,','lanes_run_records(lanes, unit, record,')
s=s.replace('            lanes_keys(lanes, first_block, end_block);','            if (__builtin_expect(lanes->far_roots[lanes->far_next]<end_root,0)) lanes_repair_far(lanes,unit,end_root);\n            lanes_keys(lanes, first_block, end_block);').replace('out = lanes_expand_with_far(', 'out = lanes_expand(')
(d/'tools/dynamicrepair.c').write_text(s)
s=s.replace('            const uint32_t room = (uint32_t)gaps[before[run] - origin] + t->runs[run];','            if(t->runs[run]==0) continue;\n            const uint32_t room = (uint32_t)gaps[before[run] - origin] + t->runs[run];')
a=s.index('    const __mmask32 bytes',s.index('static inline void lanes_copy_run('))
s=s[:a]+'''    if(length<=1){
        if(length){
            unit->out_kinds[at]=t->kinds[offset];
            unit->out_classes[at]=t->classes[offset];
            unit->out_values[at]=unit->pool[payload+offset];
        }
        return;
    }
'''+s[a:]
(d/'tools/earlyone.c').write_text(s)
