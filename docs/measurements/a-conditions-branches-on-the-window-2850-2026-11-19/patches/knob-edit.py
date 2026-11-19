#!/usr/bin/env python3
# knob-edit.py TREE: the experiment's switch for the branches' block (not for a pull request): BUSTER_TESTS_SKIP=1 makes
# the loop skip the block's masks by a branch and list every `&&` and `||`, as before the piece.
import sys
p = sys.argv[1] + '/src/buster/compiler/c_check_node_machine_window.c'
t = open(p).read()
def rep(old, new, count=1):
    global t
    assert t.count(old) == count, (t.count(old), old[:90])
    t = t.replace(old, new)
rep("""static void node_contexts_tables(NodeContextsTables* tables)
{
""", """// EXPERIMENT: BUSTER_TESTS_SKIP=1 turns the branches' block off in one executable: the loop skips its masks by a branch
// and lists every `&&` and `||`, as before the piece.
static uint32_t node_branches_x_level;
__attribute__((constructor)) static void node_branches_x_read(void)
{
    const char* x = getenv("BUSTER_TESTS_SKIP");
    node_branches_x_level = x != NULL ? (uint32_t)atoi(x) : 0;
}

static void node_contexts_tables(NodeContextsTables* tables)
{
""")
rep("""    const bool extended = state->facts.machine->types->extended;
""", """    const bool extended = state->facts.machine->types->extended;
    const bool branches_off = node_branches_x_level != 0;
""")
# The first operand's standing is the block's alone: read inside it.
rep("""        __m512i left_standings = node_window_operands(at_left, near_left, previous_standings, standings);
""", """        const __mmask64 near_left_before = near_left;
""")
rep("""            left_standings = _mm512_mask_loadu_epi8(left_standings, far_left, far_bytes[BUSTER_NODE_CONTEXTS_FAR_LEFT_STANDING]);
""", "")
right = "        const __mmask64 right_tested = _mm512_testn_epi8_mask(right_facts, _mm512_set1_epi8(BUSTER_CHECK_LOWER_TYPE_AGGREGATE));\n"
rep(right, "")
start = t.index("        const __mmask64 consumer_logical = ")
end = t.index("        // A truth's value is an int's (check_action_logic): its own class asks no mask.")
block = t[start:end]
lines = block.rstrip('\n').split('\n')
inner = []
for line in lines:
    line = line.replace('const __mmask64 branched = ', 'branched = ').replace('const __mmask64 made_branches = ', 'made_branches = ').replace('const __mmask64 unbranched = ', 'unbranched = ')
    line = line.replace('const __mmask64 is_condition = ', 'is_condition = ')
    inner.append('    ' + line if line.strip() else line)
new = """        __mmask64 branched = 0;
        __mmask64 made_branches = 0;
        __mmask64 unbranched = is_logical;
        __mmask64 is_condition = 0;
        if (__builtin_expect(!branches_off, 1))
        {
            const __m512i left_standings = _mm512_mask_loadu_epi8(node_window_operands(at_left, near_left_before, previous_standings, standings), far_left,
                                                                  far_bytes[BUSTER_NODE_CONTEXTS_FAR_LEFT_STANDING]);
""" + '    ' + right + '\n'.join(inner) + """
        }
"""
t = t[:start] + new + t[end:]
rep("""        const __m512i templates = _mm512_mask_mov_epi8(updated_templates, made_branches, _mm512_set1_epi8(NODE_MACHINE_TEMPLATE_BRANCHES));
""", """        __m512i templates = updated_templates;
        if (__builtin_expect(!branches_off, 1))
        {
            templates = _mm512_mask_mov_epi8(updated_templates, made_branches, _mm512_set1_epi8(NODE_MACHINE_TEMPLATE_BRANCHES));
        }
""")
open(p, 'w').write(t)
