#!/usr/bin/env python3
# gat-knob-edit.py TREE: the experiment's switch for the sweep's columns (not for a pull request): BUSTER_TESTS_SKIP=1
# makes the bytes' sweep read its records' four columns by the four gathers, as before the piece, by a branch a step.
import sys
p = sys.argv[1] + '/src/buster/compiler/c_check_node_census.c'
t = open(p).read()
def rep(old, new, count=1):
    global t
    assert t.count(old) == count, (t.count(old), old[:90])
    t = t.replace(old, new)
rep("""static inline __attribute__((always_inline)) void node_tests_window_bytes_by(""", """// EXPERIMENT: BUSTER_TESTS_SKIP=1 reads the sweep's four columns by gathers in one executable, as before the piece.
static uint32_t node_sweep_x_gathers;
__attribute__((constructor)) static void node_sweep_x_read(void)
{
    const char* x = getenv("BUSTER_TESTS_SKIP");
    node_sweep_x_gathers = x != NULL ? (uint32_t)atoi(x) : 0;
}

static inline __attribute__((always_inline)) void node_tests_window_bytes_by(""")
start = t.index("            // Four columns of the step's sixteen records (a record's word, flags, object and standing), by sixteen loads")
end = t.index("            // Its type's byte: the word's six bits at the byte's bits 1 to 3 and 5 to 7")
block = t[start:end]
block = block.replace("const __m512i words = ", "words = ").replace("const __m512i flags = ", "flags = ").replace("const __m512i objects = ", "objects = ").replace("const __m512i standings = ", "standings = ")
inner = '\n'.join(('    ' + line if line.strip() else line) for line in block.rstrip('\n').split('\n'))
new = """            __m512i words;
            __m512i flags;
            __m512i objects;
            __m512i standings;
            if (__builtin_expect(gathers, 0))
            {
                words = _mm512_mask_i32gather_epi32(zero, placed, lines, base + offsetof(NodeFactsRecord, word), 1);
                flags = _mm512_mask_i32gather_epi32(zero, placed, lines, base + offsetof(NodeFactsRecord, flags), 1);
                objects = _mm512_mask_i32gather_epi32(zero, placed, lines, base + offsetof(NodeFactsRecord, object), 1);
                standings = _mm512_mask_i32gather_epi32(zero, placed, lines, base + offsetof(NodeFactsRecord, standing), 1);
            }
            else
            {
""" + inner + """
            }
"""
t = t[:start] + new + t[end:]
rep("""    const NodeMachine* machine = state->facts.machine;
    for (uint32_t x = 0; x < end; x += 16)
""", """    const NodeMachine* machine = state->facts.machine;
    const bool gathers = node_sweep_x_gathers != 0;
    for (uint32_t x = 0; x < end; x += 16)
""")
open(p, 'w').write(t)
