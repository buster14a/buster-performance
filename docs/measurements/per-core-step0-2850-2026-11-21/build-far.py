from pathlib import Path
d=Path(__file__).resolve().parent
for base in ('lanes','gather'):
 s=(d/'tools'/f'{base}.c').read_text()
 s=s.replace('    uint32_t* root_of;', '''    uint32_t* root_of;
    uint32_t* far_roots;
    uint32_t far_count;
    uint32_t far_next;
    Work* far_work;
    const Tables* far_tables;''')
 p=s.index('    memcpy(lanes->marks, lanes->marks_made, count);')
 s=s[:p]+'''    lanes->far_tables = tables;
    lanes->far_roots = must(malloc(((uint64_t)unit->root_count + 1) * sizeof(uint32_t)));
    for (uint32_t g=0; g<count; ++g)
    {
        if (((lanes->layout[g] | lanes->context_layout[g]) & LANES_LAYOUT_FAR) == 0) continue;
        const uint32_t root=lanes->root_of[g];
        if (lanes->far_count == 0 || lanes->far_roots[lanes->far_count-1] != root)
            lanes->far_roots[lanes->far_count++] = root;
    }
    lanes->far_roots[lanes->far_count] = unit->root_count;
'''+s[p:]
 p=s.index('// The second path over the whole unit')
 s=s[:p]+'''// Split X only at roots containing a structurally far edge. Rebuild that whole expression
// from the scalar rules under the same counter interval. An unsuccessful rule still refuses the root.
static uint64_t lanes_expand_with_far(Lanes* lanes, Unit* unit, const Template* templates,
                                      uint32_t first, uint32_t end, uint64_t out)
{
    while (lanes->far_roots[lanes->far_next] < end)
    {
        const uint32_t r=lanes->far_roots[lanes->far_next++];
        if (first<r) out=lanes_expand(lanes,unit,templates,first,r,out);
        const uint32_t lo=unit->root_first[r];
        const uint32_t hi=unit->roots[r]+1;
        const Tables* tables=lanes->far_tables;
        Work* work=lanes->far_work;
        if (lanes->keep) {
            memset(unit->facts+lo, 0xa5, (hi-lo)*sizeof(*unit->facts));
            memset(unit->code+lo, 0xa5, (hi-lo)*sizeof(*unit->code));
            memset(unit->context+lo, 0xa5, hi-lo);
            memset(unit->target+lo, 0xa5, (hi-lo)*sizeof(*unit->target));
            memset(work->chosen+lo, 0xa5, (hi-lo)*sizeof(*work->chosen));
            memset(work->missed+lo, 0xa5, hi-lo);
        }
        types_range(unit,tables,work,lo,hi);
        contexts_range(unit,tables,work,lo,hi);
        templates_range(unit,tables,work,lo,hi);
        out=expand_root(unit,tables,work,r,out);
        if (lanes->keep && unit->root_taken[r])
            for (uint32_t g=lo;g<hi;++g)
                if (work->missed[g] || unit->facts[g]!=unit->facts_truth[g] ||
                    unit->code[g]!=unit->code_truth[g] || unit->context[g]!=unit->context_truth[g] ||
                    unit->target[g]!=unit->target_truth[g]) abort();
        first=r+1;
    }
    return first<end ? lanes_expand(lanes,unit,templates,first,end,out) : out;
}

'''+s[p:]
 s=s.replace('    uint32_t root = 0;\n    while (root < unit->root_count)','    uint32_t root = 0;\n    lanes->far_next = 0;\n    while (root < unit->root_count)')
 s=s.replace('out = lanes_expand(lanes, unit, templates, root, end_root, out);','out = lanes_expand_with_far(lanes, unit, templates, root, end_root, out);')
 p=s.index('    clock_counters[0] = counter_open',s.index('    Work work = {'))
 s=s[:p]+'''    lanes.far_work = &work;
    printf("structural distant roots\\t%u\\n",lanes.far_count);
'''+s[p:]
 p=s.index('    printf("rules\\tX')
 s=s[:p]+'''    if (only_first!=0 || only_second!=0 || first_emitted!=emitted) {
        fprintf(stderr, "different root sets: only-first=%llu only-second=%llu, entries %llu/%llu\\n",
           (unsigned long long)only_first,(unsigned long long)only_second,
           (unsigned long long)first_emitted,(unsigned long long)emitted);
        return 1;
    }
'''+s[p:]
 (d/'tools'/('far'+base+'.c')).write_text(s)
