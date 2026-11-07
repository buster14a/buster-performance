# probe_visits.py SOURCE: patches c_check_input.c (not committed anywhere) so that the top level's walk in source order
# prints, after it ends, its visits by class: the plain names' and the ignored tokens' (the head's two paths), and the
# rest by role and by mark. Built with ./build.sh and run on -c sqlite3.c off the 9700X; counts, not timings.
import sys
p = sys.argv[1]
s = open(p).read()
anchor = """        if (!scalar && mark == BUSTER_CHECK_RESOLVE_SYNTAX)
        {"""
assert s.count(anchor) == 1
s = s.replace(anchor, """        if (!scalar)
        {
            const int cls = mark == BUSTER_CHECK_RESOLVE_SYNTAX ? (kind == PARSE_KIND_IDENTIFIER && role == PARSE_ROLE_OPERAND && syntax == 0 ? 0 : reader->ignored[i] && role != PARSE_ROLE_RETURN && role != PARSE_ROLE_OPEN_FOR ? 1 : 2) : 3;
            probe_classes[cls] += 1;
            if (cls >= 2) probe_roles[role][cls - 2][reader->ignored[i] != 0] += 1;
            if (cls == 3) probe_marks[mark] += 1;
        }
""" + anchor)
s = s.replace("""static void check_input_resolve_range(CheckInputReader* reader, uint32_t begin, uint32_t end)
{""", """static uint64_t probe_classes[4];
static uint64_t probe_roles[256][2][2];
static uint64_t probe_marks[256];
static void check_input_resolve_range(CheckInputReader* reader, uint32_t begin, uint32_t end)
{""", 1)
s = s.replace("""    reader->output->resolve_visits += visits;
}""", """    reader->output->resolve_visits += visits;
    if (!reader->lane)
    {
        fprintf(stderr, "probe visits %u: plain names %lu, ignored %lu, other syntax-only %lu, other marks %lu\\n", visits, probe_classes[0], probe_classes[1], probe_classes[2], probe_classes[3]);
        for (int r = 0; r < 256; r += 1)
        {
            if (probe_roles[r][0][0] + probe_roles[r][0][1] + probe_roles[r][1][0] + probe_roles[r][1][1] > 400)
                fprintf(stderr, "probe role %d: syntax-only live %lu ignored %lu; other marks live %lu ignored %lu\\n", r, probe_roles[r][0][0], probe_roles[r][0][1], probe_roles[r][1][0], probe_roles[r][1][1]);
        }
        for (int m = 0; m < 256; m += 1) if (probe_marks[m] > 400) fprintf(stderr, "probe mark %#x: %lu\\n", m, probe_marks[m]);
    }
}""", 1)
open(p, 'w').write(s)
