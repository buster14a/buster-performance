#!/usr/bin/env python3
# usage: probe_resolve.py SOURCE_ROOT: patch src/buster/compiler/c_check_input.c in place to sum __rdtsc deltas of the
# walk in source order's visits by path (#1671): a plain name's, an ignored token's, and the general visit's (its search
# for the next marked token included), with their counts, printed to standard error after each walk. Shares only: run
# off the host, its reads cost about as much as a short visit.
import sys, pathlib
path = pathlib.Path(sys.argv[1]) / "src/buster/compiler/c_check_input.c"
s = path.read_text()
def sub(a, b):
    global s
    assert s.count(a) == 1, a
    s = s.replace(a, b)
sub("""static void check_input_resolve_range(CheckInputReader* reader, uint32_t begin, uint32_t end)
{""", """static uint64_t probe_resolve_ticks[3], probe_resolve_counts[3];
static void check_input_resolve_range(CheckInputReader* reader, uint32_t begin, uint32_t end)
{
    uint32_t probe_class = 3;
    uint64_t probe_start = 0;""")
sub("""        visits += 1;
        if (__builtin_expect(parser->options.scalar, !BUSTER_HOST_VECTOR))""", """        visits += 1;
        {
            const uint64_t probe_now = __rdtsc();
            if (probe_class < 3)
            {
                probe_resolve_ticks[probe_class] += probe_now - probe_start;
                probe_resolve_counts[probe_class] += 1;
            }
            probe_start = probe_now;
            probe_class = 2;
        }
        if (__builtin_expect(parser->options.scalar, !BUSTER_HOST_VECTOR))""")
sub("""                if (!reader->ignored[i])
                {
                    check_input_resolve_name(reader, i, role);
                }
                continue;""", """                if (!reader->ignored[i])
                {
                    check_input_resolve_name(reader, i, role);
                }
                probe_class = 0;
                continue;""")
sub("""            if (reader->ignored[i] && role != PARSE_ROLE_RETURN && role != PARSE_ROLE_OPEN_FOR)
            {
                continue;
            }""", """            if (reader->ignored[i] && role != PARSE_ROLE_RETURN && role != PARSE_ROLE_OPEN_FOR)
            {
                probe_class = 1;
                continue;
            }""")
path.write_text(s)
# The report, after the walk's function: appended where the range's callers return (a destructor at exit).
s = path.read_text()
s += """
__attribute__((destructor)) static void probe_resolve_report(void)
{
    static const char* const names[3] = { "plain", "ignored", "general" };
    for (uint32_t c = 0; c < 3; c += 1)
    {
        fprintf(stderr, "probe-resolve: %s visits=%llu ticks=%llu\\n", names[c], (unsigned long long)probe_resolve_counts[c], (unsigned long long)probe_resolve_ticks[c]);
    }
}
"""
path.write_text(s)
print("patched", path)
