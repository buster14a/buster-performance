# probe-b.py SRC_DIR: TSC probes into check_input_run's phases and the attested passes (a measurement patch, never
# committed): probe.py's phases, the clears split from the NONE fills (p24), the sparse arena's release (p25), and the
# passes before the reader (a0..a9). BUSTER_PROBE_PHASES=1 prints the sums after each unit's reader.
import sys, subprocess
src = sys.argv[1]
p = src + '/src/buster/compiler/c_check_input.c'
subprocess.check_call(['python3', sys.argv[0].replace('probe-b.py', 'probe.py'), p])
s = open(p).read()
def before(anchor, text):
    global s
    assert s.count(anchor) == 1, anchor[:60]
    s = s.replace(anchor, text + anchor, 1)
def after(anchor, text):
    global s
    assert s.count(anchor) == 1, anchor[:60]
    s = s.replace(anchor, anchor + text, 1)
before('''static uint64_t probe_phase[32];''', '''static uint64_t probe_attested[16];
''')
before('''            check_input_output_none(input, &reader, count);''', '''            PROBE(24);
''')
before('''    arena_release(&sparse);
    return valid;''', '''    PROBE(13);
''')
after('''    arena_release(&sparse);''', '''
    PROBE(25);''')
s = s.replace('''for (int k = 0; k < 24; k += 1) fprintf(stderr, " p%d %llu", k, (unsigned long long)probe_phase[k]);''',
              '''for (int k = 0; k < 26; k += 1) fprintf(stderr, " p%d %llu", k, (unsigned long long)probe_phase[k]);
        for (int k = 0; k < 10; k += 1) fprintf(stderr, " a%d %llu", k, (unsigned long long)probe_attested[k]);''')
open(p, 'w').write(s)
p = src + '/src/buster/compiler/c_check_attested.c'
s = open(p).read()
before('''static bool check_attested_decide(CheckAttested* attested, const Parser* parser, Preprocessor* pp)
{''', '''#define PROBE_A(n) do { const uint64_t probe_now = __rdtsc(); probe_attested[(n)] += probe_now - probe_a_last; probe_a_last = probe_now; } while (0)
''')
after('''static bool check_attested_decide(CheckAttested* attested, const Parser* parser, Preprocessor* pp)
{''', '''
    uint64_t probe_a_last = __rdtsc();''')
after('''    const bool listed = check_attested_lists(attested, parser, scalar) && check_attested_pragmas(attested, parser, pp);
    if (listed)
    {''', '''
        PROBE_A(0);''')
after('''        check_attested_hashes(attested, parser, scalar);
        check_attested_literals(attested, parser, pp, scalar);''', '''
        PROBE_A(9);''')
s = s.replace('''        check_attested_hashes(attested, parser, scalar);
        check_attested_literals(attested, parser, pp, scalar);
        PROBE_A(9);''', '''        check_attested_hashes(attested, parser, scalar);
        PROBE_A(1);
        check_attested_literals(attested, parser, pp, scalar);
        PROBE_A(2);''', 1)
after('''        check_attested_chain(attested);
        // Without the runtime''', '')
s = s.replace('''        check_attested_chain(attested);
        // Without the runtime''', '''        check_attested_chain(attested);
        PROBE_A(3);
        // Without the runtime''', 1)
after('''        check_attested_reach(attested, parser, pp, attested->reached, false);
        check_attested_marks(attested);''', '''
        PROBE_A(4);''')
before('''    if (whole && check_attested_unit_arrays(attested, count, parser->tokens.pragma_count, pp->output.count))
    {''', '''    uint64_t probe_a_last = __rdtsc();
''')
s = s.replace('''        check_attested_ids(attested, pp->table);
        check_attested_levels(attested, parser, pp);
        attested->unit_ready = check_attested_decide(attested, parser, pp);''', '''        PROBE_A(5);
        check_attested_ids(attested, pp->table);
        PROBE_A(6);
        check_attested_levels(attested, parser, pp);
        PROBE_A(7);
        attested->unit_ready = check_attested_decide(attested, parser, pp);
        probe_a_last = __rdtsc();''', 1)
open(p, 'w').write(s)
