#!/usr/bin/env python3
# mutate_tests.py ROOT N: applies single fault N to the reader-time tests' path (the census's view and its reader-time
# driver, the reader's chunk, T's record of its actions' warnings and of a conditional's third conversion), in place
# under ROOT/src/buster/compiler; prints "FILE\tNAME". N from 1; exits 1 past the last. Each fault is one textual change
# that keeps the unit compiling.
import sys
R = "c_check_node_machine_reader.c"
C = "c_check_node_census.c"
T = "c_check_node_machine_type.c"
M = "c_check_node_machine.c"
faults = [
    (C, "the view reads the record before a node's",
     "    return node == machine->root ? machine->count - 1 : node >= machine->first && record + 1 < machine->count ? record : UINT32_MAX;",
     "    return node == machine->root ? machine->count - 1 : node >= machine->first && record + 1 < machine->count ? (record != 0 ? record - 1 : 0) : UINT32_MAX;"),
    (C, "the view has no flags of a node's value",
     "record != UINT32_MAX ? node_machine_record_flags(s->records, record) : 0;", "record != UINT32_MAX ? 0 : 0;"),
    (C, "the view has no constant",
     "           record != UINT32_MAX ? node_machine_record_constant_kind(s->records, record) : CHECK_CONSTANT_NONE;", "           record != UINT32_MAX ? CHECK_CONSTANT_NONE : CHECK_CONSTANT_NONE;"),
    (C, "the view has no object at a leaf",
     "record != UINT32_MAX ? node_machine_record_object(s->records, record) : 0;", "record != UINT32_MAX ? 0 : 0;"),
    (C, "the view has no operand's conversion",
     "           record == UINT32_MAX ? 0 : k < 2 ? node_machine_record_converted(s->records, record, k) : node_machine_record_converted_third(s->records, record);",
     "           record == UINT32_MAX ? 0 : k < 2 ? 0 : node_machine_record_converted_third(s->records, record);"),
    (C, "the view has no conversion of a conditional's third operand",
     "           record == UINT32_MAX ? 0 : k < 2 ? node_machine_record_converted(s->records, record, k) : node_machine_record_converted_third(s->records, record);",
     "           record == UINT32_MAX ? 0 : k < 2 ? node_machine_record_converted(s->records, record, k) : 0;"),
    (C, "the view has no argument's conversion",
     "           record != UINT32_MAX && i < node_machine_record_argument_count(s->records, record) ? node_machine_record_argument_converted(s->records, record, i) : 0;",
     "           record != UINT32_MAX && i < node_machine_record_argument_count(s->records, record) ? 0 : 0;"),
    (C, "the view has no member's offset",
     "           record != UINT32_MAX ? node_machine_record_member_offset(s->records, record) : 0;", "           record != UINT32_MAX ? 0 : 0;"),
    (C, "the tests read none of T's actions' warnings",
     "    const uint32_t actions = s->records != NULL ? s->records->action_warnings & 0x01ffffffu : 0;", "    const uint32_t actions = s->records != NULL ? 0 : 0;"),
    (T, "T keeps none of its actions' warnings",
     "    machine->action_warnings |= node_machine_action_warnings(machine, r, &result);", "    machine->action_warnings |= 0;"),
    (T, "an expression's warnings are every expression's so far",
     "    machine->argument_total = 0;\n    machine->action_warnings = 0;", "    machine->argument_total = 0;"),
    (R, "every root's kind is a statement's",
     "verdict = node_census_reader_expression(typer->tests, root, (CheckOp)front->ops[record], token, declaration, declared, &kind);",
     "verdict = node_census_reader_expression(typer->tests, root, CHECK_OP_CAST, token, declaration, declared, &kind);"),
    (R, "an initializer's object's type isn't given",
     "const TypeId declared = declaration < reader->output->token_count ? reader->declared_types[declaration] : 0;", "const TypeId declared = declaration < reader->output->token_count ? 0 : 0;"),
    (C, "no pragma's body is found",
     "    bits |= region ? UINT64_C(1) << NODE_CENSUS_REGION : 0;\n    // The reader's own warning events so far", "    bits |= region && false ? UINT64_C(1) << NODE_CENSUS_REGION : 0;\n    // The reader's own warning events so far"),
    (C, "the reader's events aren't taken in",
     "            tests->event_bits[event->token >> 6] |= UINT64_C(1) << (event->token & 63);", "            tests->event_bits[event->token >> 6] |= 0;"),
    (C, "a statement expression's roots have their own kinds",
     "    const bool nested = token < parser->tokens.count && (tests->nested_bits[token >> 6] >> (token & 63) & 1) != 0;",
     "    const bool nested = false && token < parser->tokens.count && (tests->nested_bits[token >> 6] >> (token & 63) & 1) != 0;"),
    (C, "a unit's packed records aren't known",
     "    const bool packed = s->records != NULL ? s->packed_unit : token < parser->tokens.count && s->packed[token] != 0;",
     "    const bool packed = s->records != NULL ? false : token < parser->tokens.count && s->packed[token] != 0;"),
    (R, "a declaration's discard is a root",
     "                const bool discard = node_machine_reader_discard(reader, front, record, operand);", "                const bool discard = false && node_machine_reader_discard(reader, front, record, operand);"),
    (R, "only an initialization's own node is a declaration's discard",
     "        discard = reader->initializers[at] != 0;\n        at = parser->tree.parents[at];", "        discard = reader->initializers[at] != 0;\n        at = count;"),
    (R, "the tests' bits aren't kept",
     "                            types->tests[root] = verdict;", "                            types->tests[root] = 0;"),
    (R, "no root is marked as tested",
     "                            types->refusals[root] |= BUSTER_NODE_FRONT_TYPED_TESTED;", "                            types->refusals[root] |= 0;"),
    (M, "a conditional's third conversion is read as its second's",
     "    return node_machine_record_op(machine, r) == CHECK_OP_CONDITIONAL ? machine->converted_third[r] : 0;",
     "    return node_machine_record_op(machine, r) == CHECK_OP_CONDITIONAL ? machine->columns->converted[2 * r + 1] : 0;"),
    (T, "the rule keeps no third conversion of a conditional",
     "        machine->converted_third[r] = conversions[2].type;", "        machine->converted_third[r] = 0;"),
    (T, "the action's third conversion of a conditional isn't kept",
     "        machine->converted_third[r] = result->conversions[2].type;", "        machine->converted_third[r] = 0;"),
    (C, "the unit's enabled warnings are read as none at reader time",
     "        s->policy = node_census_policy(reader->pp, input);\n        *policy = s->policy;", "        memset(&s->policy, 0, sizeof(s->policy));\n        *policy = s->policy;"),
    (C, "an initializer's root is one of a brace's",
     "        context = scalar && !brace ? NODE_CENSUS_ROOT_INITIALIZER : NODE_CENSUS_ROOT_BRACE;", "        context = scalar && !brace ? NODE_CENSUS_ROOT_BRACE : NODE_CENSUS_ROOT_BRACE;"),
]
root, n = sys.argv[1], int(sys.argv[2])
if n < 1 or n > len(faults):
    sys.exit(1)
name_file, name = faults[n - 1][0], faults[n - 1][1]
pairs = faults[n - 1][2:]
path = root + "/src/buster/compiler/" + name_file
s = open(path).read()
for k in range(0, len(pairs), 2):
    a, b = pairs[k], pairs[k + 1]
    assert s.count(a) == 1, (n, name, s.count(a))
    s = s.replace(a, b)
open(path, "w").write(s)
print(name_file + "\t" + name)
