#!/usr/bin/env python3
# order-edit.py TREE: an experiment (pure code motion): each mask the loop makes from a gathered vector, or from one
# of the record's own bytes' vectors, is made where the vector is read, so that no vector lives across the rules.
import sys
p = sys.argv[1] + '/src/buster/compiler/c_check_node_machine_window.c'
t = open(p).read()
def take(start):
    """Remove the one line that starts (after its indentation) with `start`, and return it."""
    global t
    lines = t.split('\n')
    found = [i for i, line in enumerate(lines) if line.strip().startswith(start)]
    assert len(found) == 1, (len(found), start)
    line = lines.pop(found[0])
    t = '\n'.join(lines)
    return line + '\n'
def after(anchor, text):
    """Put `text` after the one line that starts with `anchor`."""
    global t
    lines = t.split('\n')
    found = [i for i, line in enumerate(lines) if line.strip().startswith(anchor)]
    assert len(found) == 1, (len(found), anchor)
    lines[found[0] + 1:found[0] + 1] = text.rstrip('\n').split('\n')
    t = '\n'.join(lines)
consumer = take("const __m512i consumer_kinds = ") + take("const __mmask64 consumer_logical = ") + take("const __mmask64 consumer_truth = ") + take("const __mmask64 callee = ")
after("const __mmask64 addressed = ", consumer)
left = (take("const __mmask64 left_logical = ") + take("const __mmask64 left_not = ") + take("const __mmask64 left_variable = ") + take("const __mmask64 left_placed = ") +
        take("const __mmask64 left_object = ") + take("const __mmask64 left_register = ") + take("const __mmask64 left_named = "))
after("const __mmask64 named_global = ", left)
# The record's own vectors' late readers: its operator's class's bits, a call's two flags, its standing's offset.
old_condition = "        const __mmask64 is_condition = is_truth & _mm512_test_epi8_mask(classes, _mm512_set1_epi8(BUSTER_NODE_CONTEXTS_CLASS_CONDITION));\n"
assert t.count(old_condition) == 1
t = t.replace(old_condition, "        const __mmask64 is_condition = is_truth & class_condition;\n")
old_divisor = "        const __mmask64 update_divisor = integral & right_constant & _mm512_test_epi8_mask(classes, _mm512_set1_epi8(BUSTER_NODE_CONTEXTS_CLASS_QUOTIENT));\n"
assert t.count(old_divisor) == 1
t = t.replace(old_divisor, "        const __mmask64 update_divisor = integral & right_constant & class_quotient;\n")
own = (take("const __mmask64 increment = ") + take("const __mmask64 converted_call = ") + take("const __mmask64 plain_call = ") + take("const __mmask64 offset = "))
own += "        const __mmask64 class_condition = _mm512_test_epi8_mask(classes, _mm512_set1_epi8(BUSTER_NODE_CONTEXTS_CLASS_CONDITION));\n"
own += "        const __mmask64 class_quotient = _mm512_test_epi8_mask(classes, _mm512_set1_epi8(BUSTER_NODE_CONTEXTS_CLASS_QUOTIENT));\n"
after("const __mmask64 symbol = ", own)
open(p, 'w').write(t)
