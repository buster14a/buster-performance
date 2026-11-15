#!/usr/bin/env python3
# mutate.py FRONT.c: rewrites the front with every mutation in, each selected at run time by BUSTER_FRONT_MUTATION=N.
# The unmutated file is kept by the caller; a run with the variable unset or 0 is the front as it is.
import sys
p = sys.argv[1]
s = open(p).read()
M = 'node_front_mutation'
U = 'BUSTER_NODE_FRONT_UNKNOWN'
sites = []
def rep(number, old, new):
    global s
    assert s.count(old) == 1, (number, s.count(old), old[:80])
    s = s.replace(old, new)
    sites.append(number)

rep(0, "static inline bool node_front_consumes(", "static int node_front_mutation = -1;\n\nstatic inline bool node_front_consumes(")
rep(0, "    const uint64_t start = __rdtsc();\n    node_front_keep(front);\n",
       "    if (node_front_mutation < 0)\n    {\n        const char* mutation = getenv(\"BUSTER_FRONT_MUTATION\");\n        node_front_mutation = mutation != NULL ? atoi(mutation) : 0;\n    }\n"
       "    const uint64_t start = __rdtsc();\n    node_front_keep(front);\n")
rep(1, "        front->ops[record] = (uint8_t)op;\n", f"        front->ops[record] = (uint8_t)({M} == 1 && op == CHECK_OP_ADD ? CHECK_OP_SUBTRACT : op);\n")
rep(2, "        const uint32_t operands[3] = { a, b, c };\n",
       f"        const bool swapped = {M} == 2 && b != {U} && c == {U};\n        const uint32_t operands[3] = {{ swapped ? b : a, swapped ? a : b, c }};\n")
rep(3, "        front->leaf_integers[record] = (uint64_t)value->integer;\n", f"        front->leaf_integers[record] = (uint64_t)value->integer + ({M} == 3);\n")
rep(4, "                        front->members[record] = member;\n", f"                        front->members[record] = member + ({M} == 4 && member != 0);\n")
rep(5, "                            front->arguments[front->argument_count] = values[k];\n",
       f"                            front->arguments[front->argument_count] = values[{M} == 5 && count > 2 ? count - k : k];\n")
rep(6, "        front->types[record] = type;\n", f"        front->types[record] = (TypeId)(type + ({M} == 6 && op == CHECK_OP_CAST && form == CHECK_INPUT_FORM_OPERATOR));\n")
rep(7, "        if (BUSTER_CHECK_RARE(reader, static_initializers, token))\n", f"        if ({M} != 7 && BUSTER_CHECK_RARE(reader, static_initializers, token))\n")
rep(8, f"            const uint32_t distance = operands[k] != {U} ? ordinal - front->ordinals[operands[k]] : 0;\n",
       f"            const uint32_t distance = operands[k] != {U} ? ordinal - front->ordinals[operands[k]] + ({M} == 8 && k == 0 && ordinal - front->ordinals[operands[k]] > 1) : 0;\n")
rep(9, "            front->ordinals[kept] = front->ordinals[record];\n", f"            front->ordinals[kept] = {M} == 9 ? kept : front->ordinals[record];\n")
rep(10, "        else if (top != 0 && front->group_consumers[top - 1] == consumer)\n", f"        else if ({M} != 10 && top != 0 && front->group_consumers[top - 1] == consumer)\n")
rep(11, "            node_front_taken_by_left(front);\n        }\n        if (value)\n", f"            if ({M} != 11)\n            {{\n                node_front_taken_by_left(front);\n            }}\n        }}\n        if (value)\n")
rep(12, "        front->leaf_types[record] = value->type;\n", f"        front->leaf_types[record] = (TypeId)(value->type + ({M} == 12 && value->type == BUSTER_TYPE_INT));\n")
rep(13, "    library = library != 0 && check_input_no_builtin(reader, reader->parser->tokens.names[use], use) ? 0 : library;\n",
        f"    library = {M} == 13 || (library != 0 && check_input_no_builtin(reader, reader->parser->tokens.names[use], use)) ? 0 : library;\n")
rep(14, "                    (void)node_front_add(front, condition ? CHECK_OP_CONDITION : CHECK_OP_CAST, token,",
        f"                    (void)node_front_add(front, condition != ({M} == 14) ? CHECK_OP_CONDITION : CHECK_OP_CAST, token,")
rep(15, f"                    const uint32_t b = omitted ? values[0] : count >= 2 ? values[1] : {U};\n",
        f"                    const uint32_t b = omitted && {M} != 15 ? values[0] : count >= 2 ? values[1] : {U};\n")
rep(16, "        if (!front->full)\n", f"        if (!front->full && {M} != 16)\n")
rep(18, "        front->uses[record] = op == CHECK_OP_VALUE ? token :", f"        front->uses[record] = {M} == 18 ? BUSTER_CHECK_NONE : op == CHECK_OP_VALUE ? token :")
rep(19, "                    record = node_front_add(front, switched ? CHECK_OP_POSITIVE : CHECK_OP_CONDITION, token,",
        f"                    record = node_front_add(front, switched && {M} != 19 ? CHECK_OP_POSITIVE : CHECK_OP_CONDITION, token,")
rep(20, f"                    record = node_front_add(front, CHECK_OP_CONVERT, token, values[0], {U}, {U}, CHECK_INPUT_FORM_OPERATOR, type);\n",
        f"                    record = node_front_add(front, CHECK_OP_CONVERT, token, values[0], {U}, {U}, CHECK_INPUT_FORM_OPERATOR, (TypeId)(type + ({M} == 20)));\n")
rep(21, "        front->leaf_categories[record] = (uint8_t)value->category;\n", f"        front->leaf_categories[record] = (uint8_t)(value->category + ({M} == 21));\n")
rep(22, "        front->leaf_flags[record] = value->flags;\n", f"        front->leaf_flags[record] = value->flags ^ ({M} == 22);\n")
rep(23, "        front->leaf_objects[record] = value->object;\n", f"        front->leaf_objects[record] = value->object + ({M} == 23);\n")
rep(24, "            front->uses[kept] = front->uses[record];\n", f"            front->uses[kept] = {M} == 24 ? BUSTER_CHECK_NONE : front->uses[record];\n")
rep(25, "                                         CHECK_INPUT_FORM_DISCARD, BUSTER_TYPE_VOID);\n",
        f"                                         CHECK_INPUT_FORM_DISCARD, {M} == 25 ? BUSTER_TYPE_INT : BUSTER_TYPE_VOID);\n")
rep(27, "reader->enum_values[identifiers->declarations[at]] : 0,", f"reader->enum_values[identifiers->declarations[at]] + ({M} == 27) : 0,")
rep(28, "        if (!node_front_consumes(reader, consumer))\n        {\n            front->stack_count = first;\n",
        f"        if (!node_front_consumes(reader, consumer) && {M} != 28)\n        {{\n            front->stack_count = first;\n")
rep(29, "                        front->argument_counts[record] = count - 1;\n", f"                        front->argument_counts[record] = count - 1 - ({M} == 29 && count > 1);\n")
rep(30, "            front->nodes[kept] = front->nodes[record];\n", f"            front->nodes[kept] = {M} == 30 ? BUSTER_CHECK_NONE : front->nodes[record];\n")
rep(31, "        front->leaf_constants[record] = (uint8_t)value->constant_kind;\n", f"        front->leaf_constants[record] = (uint8_t)(value->constant_kind + ({M} == 31));\n")
rep(32, "        front->leaf_heads[record] = value->overload_head;\n", f"        front->leaf_heads[record] = value->overload_head + ({M} == 32);\n")
rep(35, "            front->ops[kept] = front->ops[record];\n", f"            front->ops[kept] = (uint8_t)(front->ops[record] + ({M} == 35));\n")
rep(36, "            front->tokens[kept] = front->tokens[record];\n", f"            front->tokens[kept] = {M} == 36 ? 0 : front->tokens[record];\n")
rep(39, "        front->stack_count += 1;\n        front->full = false;\n", f"        front->stack_count += 1;\n        front->full = {M} == 39;\n")
open(p, 'w').write(s)
print(' '.join(str(n) for n in sorted(set(sites)) if n))
