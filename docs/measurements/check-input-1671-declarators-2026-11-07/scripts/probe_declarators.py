# probe_declarators.py SOURCE: patches c_check_input.c (not committed anywhere) so that each check_input_declarator call
# is classed by its tokens (a name; pointers and a name; empty or pointers alone; a function's; an array's; attributed;
# other) and timed with __rdtsc, the sums printed at exit. Built with ./build.sh and run with taskset on -c sqlite3.c off
# the 9700X: counts, and TSC sums whose shares, not values, the record uses.
import sys
p = sys.argv[1]
s = open(p).read()
old = """static TypeId check_input_declarator(CheckInputReader* reader, TypeId base, uint32_t* cursor, uint32_t end, uint32_t* name, uint32_t* names)
{
    CheckDeclaratorRun* run = check_input_declarator_begin(reader, base, *cursor, end);"""
assert s.count(old) == 1
new = """static TypeId check_input_declarator_probed(CheckInputReader* reader, TypeId base, uint32_t* cursor, uint32_t end, uint32_t* name, uint32_t* names);
static uint64_t probe_count[8];
static uint64_t probe_cycles[8];
static void probe_print(void)
{
    const char* names[] = { "name", "pointer+name", "empty/pointer-only", "function", "array", "attributed", "other" };
    for (int c = 0; c < 7; c += 1) fprintf(stderr, "probe %-20s %7lu calls %10lu cycles %6lu per call\\n", names[c], probe_count[c], probe_cycles[c], probe_count[c] ? probe_cycles[c] / probe_count[c] : 0);
}
static TypeId check_input_declarator(CheckInputReader* reader, TypeId base, uint32_t* cursor, uint32_t end, uint32_t* name, uint32_t* names)
{
    static bool once;
    if (!once) { once = true; atexit(probe_print); }
    int c = 6;
    {
        const Parser* parser = reader->parser;
        uint32_t t = *cursor;
        bool pointer = false;
        while (t < end && (parser->tokens.kinds[t] == PARSE_KIND_STAR || parser->tokens.kinds[t] == PARSE_KIND_QUALIFIER)) { pointer |= parser->tokens.kinds[t] == PARSE_KIND_STAR; t += 1; }
        const uint8_t k = t < end ? parser->tokens.kinds[t] : PARSE_KIND_SEMI;
        if (k == PARSE_KIND_IDENTIFIER)
        {
            const uint8_t n = t + 1 < end ? parser->tokens.kinds[t + 1] : PARSE_KIND_SEMI;
            c = (n == PARSE_KIND_COMMA || n == PARSE_KIND_SEMI || n == PARSE_KIND_EQUAL || n == PARSE_KIND_R_PAREN || n == PARSE_KIND_COLON || t + 1 >= end) ? (pointer ? 1 : 0) :
                n == PARSE_KIND_L_PAREN ? 3 : n == PARSE_KIND_L_SQUARE ? 4 : n == PARSE_KIND_ATTRIBUTE ? 5 : 6;
        }
        else if (k == PARSE_KIND_COMMA || k == PARSE_KIND_R_PAREN || k == PARSE_KIND_SEMI || t >= end) c = 2;
    }
    const uint64_t t0 = __rdtsc();
    const TypeId probe_result = check_input_declarator_probed(reader, base, cursor, end, name, names);
    probe_cycles[c] += __rdtsc() - t0;
    probe_count[c] += 1;
    return probe_result;
}
static TypeId check_input_declarator_probed(CheckInputReader* reader, TypeId base, uint32_t* cursor, uint32_t end, uint32_t* name, uint32_t* names)
{
    CheckDeclaratorRun* run = check_input_declarator_begin(reader, base, *cursor, end);"""
s = s.replace(old, new)
open(p, 'w').write(s)
