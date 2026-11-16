#!/usr/bin/env python3
# skip-knobs.py ROOT: a temporary knob in the own form (BUSTER_NODE_TESTS_SKIP, bits), for the parts' costs: 1 the
# leaves' tests, 2 the tree's, 4 the operators', 8 the expression's own, 16 the pass itself, 32 the calls, 64 the
# operators a constant alone sent, 128 the walk and the census's visits, 256 the other operators.
import sys
path = sys.argv[1] + '/src/buster/compiler/c_check_node_census.c'
text = open(path).read()
def swap(old, new):
    global text
    assert text.count(old) == 1, (text.count(old), old[:90])
    text = text.replace(old, new)
swap("""    uint8_t own_sends[128];
""", """    uint8_t own_sends[128];
    uint32_t own_skip;
""")
swap("""        node_tests_tables(s, reader->types);
""", """        node_tests_tables(s, reader->types);
        s->own_skip = getenv("BUSTER_NODE_TESTS_SKIP") != NULL ? (uint32_t)atoi(getenv("BUSTER_NODE_TESTS_SKIP")) : 0;
""")
swap("""    s->mixed_system = false;
    for (uint32_t r = 0; r < count; r += 1)
    {
        const uint32_t node = r + 1 == count ? root : first + r;
        const uint32_t code = codes[r] & 0x7fu;""", """    s->mixed_system = false;
    const uint32_t skip = s->own_skip;
    for (uint32_t r = 0; (skip & 16u) == 0 && r < count; r += 1)
    {
        const uint32_t node = r + 1 == count ? root : first + r;
        const uint32_t code = codes[r] & 0x7fu;""")
swap("""    const uint32_t object_count = program->object_count;
    for (uint32_t i = 0; i < leaves; i += 1)
    {""", """    const uint32_t object_count = program->object_count;
    for (uint32_t i = 0; (skip & 1u) == 0 && i < leaves; i += 1)
    {""")
swap("""    for (uint32_t i = 0; i < trees; i += 1)
    {
        const uint32_t r = tree_list[i];""", """    for (uint32_t i = 0; (skip & 2u) == 0 && i < trees; i += 1)
    {
        const uint32_t r = tree_list[i];""")
swap("""    if (operators != 0 || root_truth)
    {""", """    operators = (skip & 4u) != 0 ? 0 : operators;
    if (operators != 0 || root_truth)
    {""")
swap("""    tests |= node_tests_root(s, root, context, count, lowest, highest, unsequenced, walk_count, class_bits, type_bits);
    *walked = count;""", """    tests |= (skip & 8u) != 0 ? 0 : node_tests_root(s, root, context, count, lowest, highest, unsequenced, walk_count, class_bits, type_bits);
    s->span_low = lowest;
    s->span_high = highest;
    *walked = count;""")
swap("""    uint32_t walk_count = count;
    if (visits != 0 || unsequenced)
    {""", """    uint32_t walk_count = count;
    if ((visits != 0 || unsequenced) && (skip & 128u) == 0)
    {""")
swap("""    bool fires = false;
    if (s->own_always[op] == 0 && sent == BUSTER_NODE_TESTS_OPERAND_CONSTANT)
    {
        trigger = node_tests_constants(s, r, node, op, o, &fires);
    }""", """    bool fires = false;
    const bool skipped = ((s->own_skip & 32u) != 0 && op == CHECK_OP_CALL) || ((s->own_skip & 64u) != 0 && s->own_always[op] == 0 && sent == BUSTER_NODE_TESTS_OPERAND_CONSTANT) ||
                         ((s->own_skip & 256u) != 0 && op != CHECK_OP_CALL && !(s->own_always[op] == 0 && sent == BUSTER_NODE_TESTS_OPERAND_CONSTANT));
    if (skipped)
    {
        trigger = NODE_TESTS_TRIGGERS;
    }
    else if (s->own_always[op] == 0 && sent == BUSTER_NODE_TESTS_OPERAND_CONSTANT)
    {
        trigger = node_tests_constants(s, r, node, op, o, &fires);
    }""")
swap("""    if (s->own_always[op] == 0 && sent == BUSTER_NODE_TESTS_OPERAND_CONSTANT)
    {
        // Done above.
    }""", """    if (skipped || (s->own_always[op] == 0 && sent == BUSTER_NODE_TESTS_OPERAND_CONSTANT))
    {
        // Done above.
    }""")
open(path, 'w').write(text)
print('knobs in')
