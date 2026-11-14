# probe.py FILE: TSC probes into check_input_run's phases (a measurement patch, never committed).
import sys
p=sys.argv[1]
s=open(p).read()
def before(anchor, text):
    global s
    assert s.count(anchor)==1, anchor[:60]
    s=s.replace(anchor, text+anchor,1)
def after(anchor, text):
    global s
    assert s.count(anchor)==1, anchor[:60]
    s=s.replace(anchor, anchor+text,1)
before('''static bool check_input_run(CheckInput* input, const Parser* parser, Preprocessor* pp, TypeTable* types, Arena* arena, Arena* scratch,''','''static uint64_t probe_phase[32];
static uint64_t probe_tokens;
#define PROBE(n) do { const uint64_t probe_now = __rdtsc(); probe_phase[(n)] += probe_now - probe_last; probe_last = probe_now; } while (0)
''')
before('''    const bool output_zero = fresh_output && arena_untouched(arena);''','''    uint64_t probe_last = __rdtsc();
''')
after('''    const CheckInputTokenCounts counts = check_input_count_tokens(parser, names, groups, name_count, syntax, visits, BUSTER_SCALAR_PATH(parser->options.scalar));''','''
    PROBE(0);''')
before('''    valid = valid && check_sparse_reserve_wide(arena, &input->sparse_pool''','''    PROBE(19);
''')
before('''    input->rare_columns_shared = deferred != 0 && check_deferred_shared(deferred);''','''    PROBE(21);
''')
before('''    // (The arena is the reading's own''','''    PROBE(22);
''')
after('''arena_untouched(&sparse));''','''
    PROBE(23);''')
before('''        memset(reader.declared_types, 0, ((uint64_t)count + 1) * sizeof(TypeId));''','''        PROBE(1);
''')
before('''        if (traversal != 0)
        {
            // The views of c_check_prefix.c''','''        PROBE(2);
''')
before('''        check_input_expression_commas(&reader);''','''        PROBE(3);
''')
before('''        valid &= check_input_intrinsic_initialize(&reader);''','''        PROBE(4);
''')
after('''        valid &= check_input_intrinsic_initialize(&reader);''','''
        PROBE(5);''')
before('''                if (reader.skips != NULL)
                {
                    check_input_skip''','''                PROBE(6);
''')
after('''                check_input_resolve_range(&reader, 0, count);
            }''','''
            PROBE(7);''')
before('''            check_input_bindings(&reader, binding_mode);''','''            PROBE(8);
''')
after('''            check_input_bindings(&reader, binding_mode);''','''
            PROBE(9);''')
before('''                    struct rusage before;
                    const bool used = getrusage(RUSAGE_SELF, &before) == 0;''','''                    PROBE(17);
''')
before('''                if (!input->resource && input->graph.x86_count != 0 && counts.groups[CHECK_INPUT_COUNT_SELECTIONS] != 0)''','''                PROBE(18);
''')
before('''        if (valid && attested != NULL)
        {
            check_attested_events''','''        PROBE(10);
''')
before('''        if (valid && environment)
        {
            valid = check_environment_publish''','''        PROBE(11);
''')
before('''    arena_pop_to(scratch, mark);
    arena_release(&sparse);
    return valid;
}''','''    PROBE(12);
    probe_tokens += count;
    if (getenv("BUSTER_PROBE_PHASES") != NULL)
    {
        fprintf(stderr, "PROBE tokens %llu", (unsigned long long)probe_tokens);
        for (int k = 0; k < 24; k += 1) fprintf(stderr, " p%d %llu", k, (unsigned long long)probe_phase[k]);
        fprintf(stderr, "\\n");
    }
''')
open(p,'w').write(s)
