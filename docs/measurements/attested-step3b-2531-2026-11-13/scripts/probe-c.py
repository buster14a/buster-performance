# probe-b.py SRC_DIR: TSC probes into check_input_run's phases and the attested passes (a measurement patch, never
# committed): probe.py's phases, the clears split from the NONE fills (p24), the sparse arena's release (p25), and the
# passes before the reader (a0..a9). BUSTER_PROBE_PHASES=1 prints the sums after each unit's reader.
import sys, subprocess
src = sys.argv[1]
p = src + '/src/buster/compiler/c_check_input.c'
subprocess.check_call(['python3', sys.argv[0].replace('probe-c.py', 'probe.py'), p])
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
D = 'static bool check_attested_decide(CheckAttested* attested, const Parser* parser, Preprocessor* pp)\n{'
before(D, '#define PROBE_A(n) do { const uint64_t probe_now = __rdtsc(); probe_attested[(n)] += probe_now - probe_a_last; probe_a_last = probe_now; } while (0)\n')
after(D, '\n    uint64_t probe_a_last = __rdtsc();')
after('    const bool listed = check_attested_lists(attested, parser, scalar) && check_attested_pragmas(attested, parser, pp);\n    if (listed)\n    {', '\n        PROBE_A(0);')
old = '        check_attested_literals(attested, parser, pp, scalar);\n        check_attested_chain(attested);\n        // Without'
assert s.count(old) == 1
s = s.replace(old, '        PROBE_A(1);\n        check_attested_literals(attested, parser, pp, scalar);\n        PROBE_A(2);\n        check_attested_chain(attested);\n        PROBE_A(3);\n        // Without', 1)
after('        check_attested_reach(attested, parser, pp, attested->reached, false);\n        check_attested_marks(attested);', '\n        PROBE_A(4);')
before('    if (whole && check_attested_unit_arrays(attested, count, parser->tokens.pragma_count, pp->output.count))\n    {', '    uint64_t probe_a_last = __rdtsc();\n')
old = '        check_attested_ids(attested, pp->table);\n        check_attested_levels(attested, parser, pp);\n        attested->unit_ready = check_attested_decide(attested, parser, pp);'
assert s.count(old) == 1
s = s.replace(old, '        PROBE_A(5);\n        check_attested_ids(attested, pp->table);\n        PROBE_A(6);\n        check_attested_levels(attested, parser, pp);\n        PROBE_A(7);\n        attested->unit_ready = check_attested_decide(attested, parser, pp);\n        probe_a_last = __rdtsc();', 1)
open(p, 'w').write(s)
