#!/usr/bin/env python3
# usage: probe_coded.py SOURCE_ROOT: patch src/buster/compiler/c_check_expression_input.c in place to count and time the
# coded walk's parts (#1671): each flush by its cause (a full batch, a visit, the walk's end) with its nodes, each visit of
# the walk by its token's role, the value splice (check_input_expression_values) with its children, and the chunks'
# preparation and actions. The ticks are __rdtsc deltas; the counts go to standard error at the end of the walk.
# With BUSTER_PROBE_VALUES=1 the splice is timed per call too (two reads a token, which inflate the actions).
import sys, pathlib
path = pathlib.Path(sys.argv[1]) / "src/buster/compiler/c_check_expression_input.c"
s = path.read_text()
def sub(old, new, count=1):
    global s
    assert s.count(old) == count, (old, s.count(old))
    s = s.replace(old, new)

sub("#define BUSTER_CHECK_EXPRESSION_CHUNK 1024u\n", """#define BUSTER_CHECK_EXPRESSION_CHUNK 1024u
#include <stdio.h>
#include <stdlib.h>
static uint64_t probe_flush_ticks[3], probe_flush_calls[3], probe_flush_nodes[3];
static uint64_t probe_visit_ticks[256], probe_visit_count[256], probe_visit_kind[256];
static uint64_t probe_values_ticks, probe_values_calls, probe_values_children, probe_values_nonempty;
static uint64_t probe_values_histogram[8];
static uint64_t probe_prepare_ticks, probe_loop_ticks, probe_acting, probe_positions;
static uint64_t probe_class_count[32];
static int probe_values_timed = -1;
""")

# The splice: its children counted, and with BUSTER_PROBE_VALUES its ticks.
sub("""    CheckInputValues values = { .first = BUSTER_CHECK_NONE, .last = BUSTER_CHECK_NONE, .count = 0 };
    for (uint32_t child = reader->first_child[token]; child != BUSTER_CHECK_NONE; child = reader->next_child[child])
    {
""", """    CheckInputValues values = { .first = BUSTER_CHECK_NONE, .last = BUSTER_CHECK_NONE, .count = 0 };
    probe_values_calls += 1;
    for (uint32_t child = reader->first_child[token]; child != BUSTER_CHECK_NONE; child = reader->next_child[child])
    {
        probe_values_children += 1;
        probe_values_nonempty += reader->first_value[child] != BUSTER_CHECK_NONE;
""")

# A flush by a full batch.
sub("""    if (batch->count + need > BUSTER_CHECK_EXPRESSION_BATCH)
    {
        check_input_expression_flush(reader, batch, false);
    }""", """    if (batch->count + need > BUSTER_CHECK_EXPRESSION_BATCH)
    {
        probe_flush_calls[0] += 1;
        probe_flush_nodes[0] += batch->count;
        const uint64_t probe_start = __rdtsc();
        check_input_expression_flush(reader, batch, false);
        probe_flush_ticks[0] += __rdtsc() - probe_start;
    }""")

# The splice's ticks, and the class counts.
sub("""        reader->first_value[token] = BUSTER_CHECK_NONE;
        const CheckInputValues values = check_input_expression_values(reader, token);
""", """        reader->first_value[token] = BUSTER_CHECK_NONE;
        if (probe_values_timed < 0)
        {
            probe_values_timed = getenv("BUSTER_PROBE_VALUES") != NULL;
        }
        const uint64_t probe_before = probe_values_timed ? __rdtsc() : 0;
        const CheckInputValues values = check_input_expression_values(reader, token);
        probe_values_ticks += probe_values_timed ? __rdtsc() - probe_before : 0;
        probe_values_histogram[values.count < 7 ? values.count : 7] += 1;
""")
sub("""    const uint32_t code = (classes & BUSTER_CHECK_EXPRESSION_CODE_MASK) >> BUSTER_CHECK_EXPRESSION_CODE_SHIFT;
    bool acted = coded && code != CHECK_INPUT_CODE_SCALAR;
""", """    const uint32_t code = (classes & BUSTER_CHECK_EXPRESSION_CODE_MASK) >> BUSTER_CHECK_EXPRESSION_CODE_SHIFT;
    bool acted = coded && code != CHECK_INPUT_CODE_SCALAR;
    probe_class_count[code & 31] += 1;
""")

# A flush before a visit, and the visit by its token's role.
sub("""        check_input_expression_flush(reader, batch, false);
        const bool clocked = coded && visited != NULL;
        const uint64_t start = clocked ? __rdtsc() : 0;
        check_input_expression_visit(reader, token, classes);
""", """        probe_flush_calls[1] += 1;
        probe_flush_nodes[1] += batch->count;
        const uint64_t probe_start = __rdtsc();
        check_input_expression_flush(reader, batch, false);
        const uint64_t probe_flushed = __rdtsc();
        probe_flush_ticks[1] += probe_flushed - probe_start;
        const bool clocked = coded && visited != NULL;
        const uint64_t start = clocked ? __rdtsc() : 0;
        check_input_expression_visit(reader, token, classes);
        const uint8_t probe_role = reader->parser->tree.roles[token];
        probe_visit_ticks[probe_role] += __rdtsc() - probe_flushed;
        probe_visit_count[probe_role] += 1;
        probe_visit_kind[probe_role] = reader->parser->tokens.kinds[token];
""")

# The chunks' parts, the last flush and the report.
sub("""        const uint64_t done = __rdtsc();
        prepared += ready - start;
        acted += done - ready;
""", """        const uint64_t done = __rdtsc();
        prepared += ready - start;
        acted += done - ready;
        probe_prepare_ticks += ready - start;
        probe_loop_ticks += done - ready;
        probe_acting += acting;
        probe_positions += end - first;
""")
sub("""        const uint64_t start = __rdtsc();
        check_input_expression_flush(reader, batch, false);
        acted += __rdtsc() - start;
""", """        const uint64_t start = __rdtsc();
        probe_flush_calls[2] += 1;
        probe_flush_nodes[2] += batch->count;
        check_input_expression_flush(reader, batch, false);
        acted += __rdtsc() - start;
        probe_flush_ticks[2] += __rdtsc() - start;
""")
sub("""    reader->expression_declined = NULL;
    arena_pop_to(reader->scratch, scratch_mark);
}
""", """    reader->expression_declined = NULL;
    arena_pop_to(reader->scratch, scratch_mark);
    if (begin == 0 && stop == count)
    {
        fprintf(stderr, "probe: positions=%llu acting=%llu prepare_ticks=%llu loop_ticks=%llu nodes=%u\\n", (unsigned long long)probe_positions,
                (unsigned long long)probe_acting, (unsigned long long)probe_prepare_ticks, (unsigned long long)probe_loop_ticks, reader->output->graph.count);
        static const char* const causes[3] = { "room", "visit", "end" };
        for (uint32_t c = 0; c < 3; c += 1)
        {
            fprintf(stderr, "probe: flush cause=%s calls=%llu nodes=%llu ticks=%llu\\n", causes[c], (unsigned long long)probe_flush_calls[c],
                    (unsigned long long)probe_flush_nodes[c], (unsigned long long)probe_flush_ticks[c]);
        }
        fprintf(stderr, "probe: values calls=%llu children=%llu nonempty=%llu ticks=%llu\\n", (unsigned long long)probe_values_calls,
                (unsigned long long)probe_values_children, (unsigned long long)probe_values_nonempty, (unsigned long long)probe_values_ticks);
        for (uint32_t v = 0; v < 8; v += 1)
        {
            fprintf(stderr, "probe: values count=%u%s tokens=%llu\\n", v, v == 7 ? "+" : "", (unsigned long long)probe_values_histogram[v]);
        }
        for (uint32_t c = 0; c < 32; c += 1)
        {
            if (probe_class_count[c] != 0)
            {
                fprintf(stderr, "probe: class=%s tokens=%llu\\n", c < BUSTER_CHECK_EXPRESSION_CODES ? check_input_expression_code_names[c] : "?",
                        (unsigned long long)probe_class_count[c]);
            }
        }
        for (uint32_t r = 0; r < 256; r += 1)
        {
            if (probe_visit_count[r] != 0)
            {
                fprintf(stderr, "probe: visit role=%u kind=%llu count=%llu ticks=%llu\\n", r, (unsigned long long)probe_visit_kind[r],
                        (unsigned long long)probe_visit_count[r], (unsigned long long)probe_visit_ticks[r]);
            }
        }
    }
}
""")
path.write_text(s)
print("patched", path)
