#!/usr/bin/env python3
# usage: probe_declarations.py SOURCE_ROOT: patch src/buster/compiler/c_check_input.c in place (#1671's declaration
# study) to sum __rdtsc deltas of check_input_declaration by scope (file or block), and of check_input_specifiers by
# whether the call repeats an earlier one's tokens exactly (the same kinds and names, and the same parameter flag),
# with the number of distinct sequences, printed to standard error at exit. Off the host: counts and shares only.
import sys, pathlib
path = pathlib.Path(sys.argv[1]) / "src/buster/compiler/c_check_input.c"
s = path.read_text()
def sub(a, b):
    global s
    assert s.count(a) == 1, a
    s = s.replace(a, b)
sub("""static TypeId check_input_specifiers(CheckInputReader* reader, uint32_t* cursor, uint32_t end, bool* is_typedef, uint32_t* storage_class, bool* is_inline,
                                    bool parameter)
{""", """static TypeId check_input_specifiers_probed(CheckInputReader* reader, uint32_t* cursor, uint32_t end, bool* is_typedef, uint32_t* storage_class, bool* is_inline,
                                           bool parameter);
#define PROBE_SLOTS 65536u
static uint64_t probe_spec_keys[PROBE_SLOTS];
static uint64_t probe_spec_calls[2], probe_spec_ticks[2], probe_spec_tokens[2], probe_spec_distinct;
static uint64_t probe_decl_calls[2], probe_decl_ticks[2];
static uint64_t probe_shape_calls[4], probe_shape_ticks[4];
static void probe_declarations_report(void)
{
    fprintf(stderr, "probe-spec: first calls=%llu tokens=%llu ticks=%llu\\n", (unsigned long long)probe_spec_calls[0], (unsigned long long)probe_spec_tokens[0], (unsigned long long)probe_spec_ticks[0]);
    fprintf(stderr, "probe-spec: repeat calls=%llu tokens=%llu ticks=%llu\\n", (unsigned long long)probe_spec_calls[1], (unsigned long long)probe_spec_tokens[1], (unsigned long long)probe_spec_ticks[1]);
    fprintf(stderr, "probe-spec: distinct=%llu\\n", (unsigned long long)probe_spec_distinct);
    static const char* const shapes[4] = { "one-identifier", "one-keyword", "two-or-more", "none" };
    for (uint32_t c = 0; c < 4; c += 1)
    {
        fprintf(stderr, "probe-shape: %s calls=%llu ticks=%llu\\n", shapes[c], (unsigned long long)probe_shape_calls[c], (unsigned long long)probe_shape_ticks[c]);
    }
    fprintf(stderr, "probe-decl: file calls=%llu ticks=%llu\\n", (unsigned long long)probe_decl_calls[0], (unsigned long long)probe_decl_ticks[0]);
    fprintf(stderr, "probe-decl: block calls=%llu ticks=%llu\\n", (unsigned long long)probe_decl_calls[1], (unsigned long long)probe_decl_ticks[1]);
}
static TypeId check_input_specifiers(CheckInputReader* reader, uint32_t* cursor, uint32_t end, bool* is_typedef, uint32_t* storage_class, bool* is_inline,
                                    bool parameter)
{
    static bool registered;
    if (!registered)
    {
        registered = true;
        atexit(probe_declarations_report);
    }
    const uint32_t first = *cursor;
    const uint64_t start = __rdtsc();
    const TypeId result = check_input_specifiers_probed(reader, cursor, end, is_typedef, storage_class, is_inline, parameter);
    const uint64_t ticks = __rdtsc() - start;
    uint64_t key = 0x9e3779b97f4a7c15ull ^ (uint64_t)parameter;
    for (uint32_t t = first; t < *cursor; t += 1)
    {
        key = (key ^ ((uint64_t)reader->parser->tokens.kinds[t] << 32 | reader->parser->tokens.names[t])) * 0xff51afd7ed558ccdull;
        key ^= key >> 29;
    }
    key |= 1;
    uint32_t slot = (uint32_t)(key >> 40) & (PROBE_SLOTS - 1);
    while (probe_spec_keys[slot] != 0 && probe_spec_keys[slot] != key)
    {
        slot = (slot + 1) & (PROBE_SLOTS - 1);
    }
    const uint32_t repeat = probe_spec_keys[slot] == key;
    probe_spec_distinct += !repeat;
    probe_spec_keys[slot] = key;
    probe_spec_calls[repeat] += 1;
    probe_spec_ticks[repeat] += ticks;
    probe_spec_tokens[repeat] += *cursor - first;
    const uint32_t length = *cursor - first;
    const uint32_t shape = length == 0 ? 3 : length > 1 ? 2 : reader->parser->tokens.kinds[first] == PARSE_KIND_IDENTIFIER ? 0 : 1;
    probe_shape_calls[shape] += 1;
    probe_shape_ticks[shape] += ticks;
    return result;
}
static TypeId check_input_specifiers_probed(CheckInputReader* reader, uint32_t* cursor, uint32_t end, bool* is_typedef, uint32_t* storage_class, bool* is_inline,
                                           bool parameter)
{""")
sub("""static void check_input_declaration(CheckInputReader* reader, uint32_t first)
{""", """static void check_input_declaration_probed(CheckInputReader* reader, uint32_t first);
static void check_input_declaration(CheckInputReader* reader, uint32_t first)
{
    const uint32_t block = reader->function_body != BUSTER_CHECK_NONE;
    const uint64_t start = __rdtsc();
    check_input_declaration_probed(reader, first);
    probe_decl_ticks[block] += __rdtsc() - start;
    probe_decl_calls[block] += 1;
}
static void check_input_declaration_probed(CheckInputReader* reader, uint32_t first)
{""")
path.write_text(s)
print("patched", path)
