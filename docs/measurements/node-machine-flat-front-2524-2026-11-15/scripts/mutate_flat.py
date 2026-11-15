#!/usr/bin/env python3
# mutate_flat.py FILE N: applies single fault N to the flat front's source (c_check_node_machine_flat.c), in place; prints
# the fault's name. N from 1; exits 1 past the last. Each fault is one textual change that keeps the file compiling.
import sys
faults = [
    ("a binary's first distance one more", "node_flat_fill(flat->records, place, token, op, 2, first, second);", "node_flat_fill(flat->records, place, token, op, 2, first + 1, second);"),
    ("a binary's operands swapped", "            const uint32_t first = node_flat_distance(place, values[1]);\n            const uint32_t second = node_flat_distance(place, values[0]);", "            const uint32_t first = node_flat_distance(place, values[0]);\n            const uint32_t second = node_flat_distance(place, values[1]);"),
    ("a unary's operand not taken", "                node_flat_fill(flat->records, place, token, op, 1, distance, 0);\n                node_flat_take(flat, place, values[0], distance, 0);", "                node_flat_fill(flat->records, place, token, op, 1, distance, 0);"),
    ("a passing class visited", "#define BUSTER_NODE_FLAT_PASSING (1u << CHECK_INPUT_CODE_LIST | 1u << CHECK_INPUT_CODE_SEPARATOR | 1u << CHECK_INPUT_CODE_GROUP)", "#define BUSTER_NODE_FLAT_PASSING (1u << CHECK_INPUT_CODE_LIST | 1u << CHECK_INPUT_CODE_SEPARATOR)"),
    ("a passing token's step its length (vector path)", "_mm512_mask_blend_epi32(passing, lengths, _mm512_set1_epi32(1))", "lengths"),
    ("an identifier without a declared type makes a record", "        const bool made = !left && type != 0;", "        const bool made = !left;"),
    ("a left literal gives its place", "        flat->metas[i] = BUSTER_NODE_FLAT_META(!left, left ? BUSTER_NODE_FLAT_GIVES_UNKNOWN : BUSTER_NODE_FLAT_GIVES_RECORD);", "        flat->metas[i] = BUSTER_NODE_FLAT_META(!left, BUSTER_NODE_FLAT_GIVES_RECORD);"),
    ("a braced initializer's step stays its length", "            flat->steps[flat->positions[i] & (BUSTER_NODE_FLAT_WINDOW - 1)] = 1;\n", ""),
    ("an empty record's consumer stays", "            walking = consumer != BUSTER_NODE_FLAT_NONE && consumer - flat->chunk_ordinal < flat->ordinal - flat->chunk_ordinal && node_flat_empty(flat, consumer);", "            walking = false;"),
    ("a statement's other discards stay when one is empty", "                if ((made->flags & BUSTER_NODE_FLAT_ROOT) != 0 && made->up == 0)", "                if (false && (made->flags & BUSTER_NODE_FLAT_ROOT) != 0 && made->up == 0)"),
    ("an emptied consumer's operands keep its bytes", "                memcpy(&flat->records[(place - distance) & (BUSTER_NODE_FLAT_RECORDS - 1)].up, &none, sizeof(none));\n            }\n        }\n        if (record->op == CHECK_OP_CALL", "            }\n        }\n        if (record->op == CHECK_OP_CALL"),
    ("an earlier chunk's empty record is taken", "        usable = usable && flat->records[operand & (BUSTER_NODE_FLAT_RECORDS - 1)].op != BUSTER_NODE_FLAT_EMPTY;", "        usable = usable && true;"),
    ("a statement of one expression discards nothing", "                count = word == BUSTER_NODE_FLAT_NONE ? 0 : word == BUSTER_NODE_FLAT_UNKNOWN ? BUSTER_NODE_FRONT_UNKNOWN : 1;", "                count = 0;"),
    ("a statement of one unknown value discards it", "                count = word == BUSTER_NODE_FLAT_NONE ? 0 : word == BUSTER_NODE_FLAT_UNKNOWN ? BUSTER_NODE_FRONT_UNKNOWN : 1;", "                count = word == BUSTER_NODE_FLAT_NONE ? 0 : 1;"),
    ("a discard is no root", "node_flat_store(records, ordinal, token, condition ? CHECK_OP_CONDITION : CHECK_OP_CAST, 1, distance, 0, 0, BUSTER_NODE_FLAT_ROOT, 0);", "node_flat_store(records, ordinal, token, condition ? CHECK_OP_CONDITION : CHECK_OP_CAST, 1, distance, 0, 0, 0, 0);"),
    ("a call's arguments' places one more", "                node_flat_take(flat, place, argument, distance, k);", "                node_flat_take(flat, place, argument, distance, k + 1);"),
    ("a call's callee its last value", "            const uint32_t callee = values[taken - 1];\n            const bool listed", "            const uint32_t callee = values[0];\n            const bool listed"),
    ("a conditional with its middle omitted takes its last value twice", "            const uint32_t b = taken == 2 ? a : values[1];", "            const uint32_t b = taken == 2 ? values[0] : values[1];"),
    ("the classes' lists by the vector path miss a class", "     1u << CHECK_INPUT_CODE_CALL | 1u << CHECK_INPUT_CODE_CONDITION | 1u << CHECK_INPUT_CODE_RETURN | 1u << CHECK_INPUT_CODE_INITIALIZE)", "     1u << CHECK_INPUT_CODE_CALL | 1u << CHECK_INPUT_CODE_CONDITION | 1u << CHECK_INPUT_CODE_INITIALIZE)"),
    ("a far consumer's place not kept", "        flat->consumers[operand & (BUSTER_NODE_FLAT_RECORDS - 1)] = ordinal;", "        flat->consumers[operand & (BUSTER_NODE_FLAT_RECORDS - 1)] = BUSTER_NODE_FLAT_NONE;"),
    ("the hops stop a child early", "    for (uint32_t hop = 0; hop < BUSTER_NODE_FLAT_HOPS && child >= bound; hop += 1)", "    for (uint32_t hop = 0; hop < BUSTER_NODE_FLAT_HOPS && child > bound; hop += 1)"),
    ("a value past the rings' reach is taken", "    const bool out = child >= lower && count <= BUSTER_NODE_FRONT_VALUES;", "    const bool out = false;"),
    ("a member without a name is an operator", "                    op = !(token + 1 < token_count && parser->tree.roles[token + 1] == PARSE_ROLE_MEMBER) ? CHECK_OP_COUNT :\n                         kinds[token] == PARSE_KIND_ARROW ? CHECK_OP_ARROW : CHECK_OP_MEMBER;", "                    op = kinds[token] == PARSE_KIND_ARROW ? CHECK_OP_ARROW : CHECK_OP_MEMBER;"),
    ("a switch's condition is a condition", "                    op = keyword < token_count && kinds[keyword] == PARSE_KIND_SWITCH ? CHECK_OP_POSITIVE : CHECK_OP_CONDITION;", "                    op = keyword < token_count && kinds[keyword] == PARSE_KIND_SWITCH ? CHECK_OP_CONDITION : CHECK_OP_CONDITION;"),
]
path, n = sys.argv[1], int(sys.argv[2])
if n < 1 or n > len(faults):
    sys.exit(1)
name, a, b = faults[n - 1]
s = open(path).read()
assert s.count(a) == 1, (n, name, s.count(a))
open(path, "w").write(s.replace(a, b))
print(name)
