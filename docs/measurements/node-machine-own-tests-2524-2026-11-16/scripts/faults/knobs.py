#!/usr/bin/env python3
# knobs.py ROOT [list]: puts every single fault of the tests' own form (node_tests_expression and its parts,
# c_check_node_census.c) into the sources under ROOT, each selected at run time by BUSTER_NODE_TESTS_FAULT=N (N from 1;
# 0 or unset: none), so that one build serves the campaign. With `list`, prints "N<TAB>NAME" a fault and changes nothing.
# A fault makes the own form miss or misplace one of its conditions: the census's code beside it (--verify) and the
# fixtures must show it.
import sys
root = sys.argv[1]
path = root + '/src/buster/compiler/c_check_node_census.c'
F = lambda n: '(node_tests_fault == %du)' % n
faults = []
def fault(name, old, new, occurrence=None):
    faults.append((name, old, new, occurrence))
N = lambda: len(faults) + 1

# The unit's tables.
fault("an operator outside the set has no class", "(!node_census_coded(op) ? BUSTER_NODE_TESTS_CLASS_UNCODED : 0)", "(!node_census_coded(op) && !%s ? BUSTER_NODE_TESTS_CLASS_UNCODED : 0)" % F(N()))
fault("a write has no class (the unsequenced test's count)", "(node_census_modifies(op) ? BUSTER_NODE_TESTS_CLASS_WRITE : 0)", "(node_census_modifies(op) && !%s ? BUSTER_NODE_TESTS_CLASS_WRITE : 0)" % F(N()))
fault("an address has no class (a packed member's, a return's)", "(op == CHECK_OP_ADDRESS ? BUSTER_NODE_TESTS_CLASS_ADDRESS : 0)", "(op == CHECK_OP_ADDRESS && !%s ? BUSTER_NODE_TESTS_CLASS_ADDRESS : 0)" % F(N()))
fault("a `!` and an `=` are not the tree's", "(op == CHECK_OP_NOT || op == CHECK_OP_ASSIGN ? BUSTER_NODE_TESTS_CLASS_TREE : 0)", "((op == CHECK_OP_NOT || op == CHECK_OP_ASSIGN) && !%s ? BUSTER_NODE_TESTS_CLASS_TREE : 0)" % F(N()))
fault("a sum is no operand's property", "(op == CHECK_OP_ADD || op == CHECK_OP_SUBTRACT ? BUSTER_NODE_TESTS_OPERAND_SUM : 0)", "((op == CHECK_OP_ADD || op == CHECK_OP_SUBTRACT) && !%s ? BUSTER_NODE_TESTS_OPERAND_SUM : 0)" % F(N()))
fault("a comparison is no operand's property", "(comparison ? BUSTER_NODE_TESTS_OPERAND_COMPARISON : 0)", "(comparison && !%s ? BUSTER_NODE_TESTS_OPERAND_COMPARISON : 0)" % F(N()))
fault("a left shift or a product is no operand's property", "(op == CHECK_OP_SHIFT_LEFT || op == CHECK_OP_MULTIPLY ? BUSTER_NODE_TESTS_OPERAND_TRUTH : 0)", "((op == CHECK_OP_SHIFT_LEFT || op == CHECK_OP_MULTIPLY) && !%s ? BUSTER_NODE_TESTS_OPERAND_TRUTH : 0)" % F(N()))
fault("no operator copies an aggregate", "s->own_copies[code] = copies ? UINT8_MAX : 0;", "s->own_copies[code] = copies && !%s ? UINT8_MAX : 0;" % F(N()))
n_call = N(); fault("a call has no tests of its own", "const bool always = op == CHECK_OP_CALL || op == CHECK_OP_CONDITIONAL ||", "const bool always = (op == CHECK_OP_CALL && !%s) || (op == CHECK_OP_CONDITIONAL && !%s) ||" % (F(n_call), F(n_call + 1)))
fault("a conditional's third operand is not read", None, None)
n_size = N(); fault("a sizeof and an alignof have no tests of their own", "op == CHECK_OP_SIZEOF || op == CHECK_OP_ALIGNOF || op == CHECK_OP_COMMA ||", "((op == CHECK_OP_SIZEOF || op == CHECK_OP_ALIGNOF) && !%s) || (op == CHECK_OP_COMMA && !%s) ||" % (F(n_size), F(n_size + 1)))
fault("a comma has no tests of its own", None, None)
fault("a member is not asked in a unit with an atomic record", "(types->atomic_records && (op == CHECK_OP_MEMBER || op == CHECK_OP_ARROW)) ||", "(types->atomic_records && (op == CHECK_OP_MEMBER || op == CHECK_OP_ARROW) && !%s) ||" % F(N()))
fault("a comparison is not asked under -Wsign-compare", "(policy->sign_compare && comparison) ||", "(policy->sign_compare && comparison && !%s) ||" % F(N()))
fault("an assignment is not asked under -Wself-assign", "(policy->self_assign && op == CHECK_OP_ASSIGN);", "(policy->self_assign && op == CHECK_OP_ASSIGN && !%s);" % F(N()))
fault("a constant operand sends no operator", "(op != CHECK_OP_CAST ? BUSTER_NODE_TESTS_OPERAND_CONSTANT : 0)", "(op != CHECK_OP_CAST && !%s ? BUSTER_NODE_TESTS_OPERAND_CONSTANT : 0)" % F(N()))
fault("an enumeration's operand sends no operator", "(policy->enums ? BUSTER_NODE_TESTS_OPERAND_ENUM : 0)", "(policy->enums && !%s ? BUSTER_NODE_TESTS_OPERAND_ENUM : 0)" % F(N()))
fault("a pointer operand sends no cast", "(op == CHECK_OP_CAST && policy->pointer_casts ? BUSTER_NODE_TESTS_OPERAND_POINTER : 0)", "(op == CHECK_OP_CAST && policy->pointer_casts && !%s ? BUSTER_NODE_TESTS_OPERAND_POINTER : 0)" % F(N()))
fault("a void pointer sends no dereference", "policy->void_dereference ? BUSTER_NODE_TESTS_OPERAND_VOID_POINTEE : 0)", "policy->void_dereference && !%s ? BUSTER_NODE_TESTS_OPERAND_VOID_POINTEE : 0)" % F(N()))
fault("an array operand sends no addition (a string's)", "(op == CHECK_OP_ADD && policy->string_plus_int ? BUSTER_NODE_TESTS_OPERAND_ARRAY : 0)", "(op == CHECK_OP_ADD && policy->string_plus_int && !%s ? BUSTER_NODE_TESTS_OPERAND_ARRAY : 0)" % F(N()))
fault("a sum operand sends no shift", "(shift && policy->shift_parentheses ? BUSTER_NODE_TESTS_OPERAND_SUM : 0)", "(shift && policy->shift_parentheses && !%s ? BUSTER_NODE_TESTS_OPERAND_SUM : 0)" % F(N()))
fault("a comparison operand sends no comparison", "(comparison && policy->chained ? BUSTER_NODE_TESTS_OPERAND_COMPARISON : 0)", "(comparison && policy->chained && !%s ? BUSTER_NODE_TESTS_OPERAND_COMPARISON : 0)" % F(N()))
fault("a shift or a product sends no truth's operator", "(truth_parent && truths ? BUSTER_NODE_TESTS_OPERAND_TRUTH : 0)", "(truth_parent && truths && !%s ? BUSTER_NODE_TESTS_OPERAND_TRUTH : 0)" % F(N()))
# The pass.
fault("a null address constant is no constant", "(kind != CHECK_CONSTANT_ADDRESS || (standing & BUSTER_NODE_MACHINE_WIDE) != 0 || objects[r] == 0)", "(kind != CHECK_CONSTANT_ADDRESS || (!%s && ((standing & BUSTER_NODE_MACHINE_WIDE) != 0 || objects[r] == 0)))" % F(N()))
fault("an enumeration's type is no operand's property", "((own >> 2) & BUSTER_NODE_TESTS_OPERAND_ENUM)", "(%s ? 0 : ((own >> 2) & BUSTER_NODE_TESTS_OPERAND_ENUM))" % F(N()))
fault("a type's pointer, void pointee and array bits are no operand's property", "((own >> 3) & (BUSTER_NODE_TESTS_OPERAND_POINTER | BUSTER_NODE_TESTS_OPERAND_VOID_POINTEE | BUSTER_NODE_TESTS_OPERAND_ARRAY))", "(%s ? 0 : ((own >> 3) & (BUSTER_NODE_TESTS_OPERAND_POINTER | BUSTER_NODE_TESTS_OPERAND_VOID_POINTEE | BUSTER_NODE_TESTS_OPERAND_ARRAY)))" % F(N()))
fault("no leaf is listed", "leaves += (class & BUSTER_NODE_TESTS_CLASS_LEAF) != 0;", "leaves += (class & BUSTER_NODE_TESTS_CLASS_LEAF) != 0 && !%s;" % F(N()))
fault("a comparison's token is not the tree's", "trees += role == PARSE_ROLE_EQUALITY || role == PARSE_ROLE_RELATIONAL || (class & BUSTER_NODE_TESTS_CLASS_TREE) != 0;", "trees += (!%s && (role == PARSE_ROLE_EQUALITY || role == PARSE_ROLE_RELATIONAL)) || (class & BUSTER_NODE_TESTS_CLASS_TREE) != 0;" % F(N()))
fault("no operator is listed", "operators += (always[code] | (sends[code] & operands)) != 0;", "operators += (always[code] | (sends[code] & operands)) != 0 && !%s;" % F(N()))
fault("a special type passes", "tests |= (type_bits & BUSTER_NODE_CENSUS_TYPE_SPECIAL) != 0 ? UINT64_C(1) << NODE_CENSUS_TYPE : 0;", "tests |= (type_bits & BUSTER_NODE_CENSUS_TYPE_SPECIAL) != 0 && !%s ? UINT64_C(1) << NODE_CENSUS_TYPE : 0;" % F(N()), 'last')
fault("a bit-field passes", "tests |= (flag_bits & BUSTER_CHECK_BIT_FIELD) != 0 ? UINT64_C(1) << NODE_CENSUS_BIT_FIELD : 0;", "tests |= (flag_bits & BUSTER_CHECK_BIT_FIELD) != 0 && !%s ? UINT64_C(1) << NODE_CENSUS_BIT_FIELD : 0;" % F(N()), 'last')
fault("a copied aggregate passes", "tests |= (copied_bits & BUSTER_NODE_CENSUS_TYPE_AGGREGATE) != 0 ? UINT64_C(1) << NODE_CENSUS_AGGREGATE : 0;", "tests |= (copied_bits & BUSTER_NODE_CENSUS_TYPE_AGGREGATE) != 0 && !%s ? UINT64_C(1) << NODE_CENSUS_AGGREGATE : 0;" % F(N()))
fault("a packed member's address passes", "(class_bits & BUSTER_NODE_TESTS_CLASS_ADDRESS) != 0 && policy->packed_member && s->packed_unit ?", "(class_bits & BUSTER_NODE_TESTS_CLASS_ADDRESS) != 0 && policy->packed_member && s->packed_unit && !%s ?" % F(N()))
fault("a floating-point pragma's region is not read", "    if (input->fp_environments != NULL && graph->fp_environments != NULL)\n    {\n        for (uint32_t r = 0; r < count; r += 1)", "    if (!%s && input->fp_environments != NULL && graph->fp_environments != NULL)\n    {\n        for (uint32_t r = 0; r < count; r += 1)" % F(N()))
fault("the tokens' span has no start (the reader's events)", "lowest = placed && token < lowest ? token : lowest;", "lowest = placed && token < lowest && !%s ? token : lowest;" % F(N()))
# The leaves.
fault("a leaf's object's bits are not read", "const uint8_t declared = object != 0 && object < object_count ? object_bits[object - 1] : 0;", "const uint8_t declared = object != 0 && object < object_count && !%s ? object_bits[object - 1] : 0;" % F(N()))
fault("a leaf's declaration's byte is not read", "(known & BUSTER_NODE_CENSUS_DECLARATION_FLAGGED) != 0;\n            tests |= ((declared", "(!%s && (known & BUSTER_NODE_CENSUS_DECLARATION_FLAGGED) != 0);\n            tests |= ((declared" % F(N()))
fault("a leaf's register flag is not read", "(value_flags[r] & (BUSTER_CHECK_REGISTER | BUSTER_CHECK_REGISTER_NAME)) != 0 ||", "(!%s && (value_flags[r] & (BUSTER_CHECK_REGISTER | BUSTER_CHECK_REGISTER_NAME)) != 0) ||" % F(N()))
fault("a wide leaf is not the census's code's", "if ((standings[r] & BUSTER_NODE_MACHINE_WIDE) != 0 || (declaration != BUSTER_CHECK_NONE && (known & BUSTER_NODE_CENSUS_DECLARATION_FLAGGED_KNOWN) == 0))", "if ((!%s && (standings[r] & BUSTER_NODE_MACHINE_WIDE) != 0) || (declaration != BUSTER_CHECK_NONE && (known & BUSTER_NODE_CENSUS_DECLARATION_FLAGGED_KNOWN) == 0))" % F(N()))
# The tree's tests.
fault("a comparison under a bitwise operator passes", "bool parentheses = check_common_comparison_role(role) && policy->parentheses && bitwise && check_common_bitwise_precedence(parser, token, parent);", "bool parentheses = !%s && check_common_comparison_role(role) && policy->parentheses && bitwise && check_common_bitwise_precedence(parser, token, parent);" % F(N()))
fault("a `!` under a comparison passes", "parentheses |= op == CHECK_OP_NOT && policy->logical_not && check_common_comparison_role(parent_role) && token < parent;", "parentheses |= !%s && op == CHECK_OP_NOT && policy->logical_not && check_common_comparison_role(parent_role) && token < parent;" % F(N()))
fault("an assignment as a condition passes", "parentheses |= (parent_role == PARSE_ROLE_CLOSE_CONDITION || for_condition) && !switch_condition;", "parentheses |= !%s && (parent_role == PARSE_ROLE_CLOSE_CONDITION || for_condition) && !switch_condition;" % F(N()))
fault("a comparison as a statement passes", "const bool unused = policy->unused_comparison && check_common_comparison_role(role) && parent_role == PARSE_ROLE_TERMINATOR &&", "const bool unused = !%s && policy->unused_comparison && check_common_comparison_role(role) && parent_role == PARSE_ROLE_TERMINATOR &&" % F(N()))
# The operators' tests.
fault("a string's sum passes", "tests |= op == CHECK_OP_ADD && policy->string_plus_int && binary && (node_census_string(program, graph->operand0[node])", "tests |= !%s && op == CHECK_OP_ADD && policy->string_plus_int && binary && (node_census_string(program, graph->operand0[node])" % F(N()))
fault("a pointer's cast to a narrow integer passes", "tests |= (width != 0 && width < 64) || (own & BUSTER_NODE_CENSUS_TYPE_ENUM) != 0 ? UINT64_C(1) << NODE_CENSUS_POINTER_CAST : 0;", "tests |= !%s && ((width != 0 && width < 64) || (own & BUSTER_NODE_CENSUS_TYPE_ENUM) != 0) ? UINT64_C(1) << NODE_CENSUS_POINTER_CAST : 0;" % F(N()))
fault("a shift or a product read as a truth is not sent", "if (o[i] != UINT32_MAX && (properties[o[i]] & BUSTER_NODE_TESTS_OPERAND_TRUTH) != 0)", "if (!%s && o[i] != UINT32_MAX && (properties[o[i]] & BUSTER_NODE_TESTS_OPERAND_TRUTH) != 0)" % F(N()))
fault("a call's aggregate argument passes", "aggregate |= argument != UINT32_MAX && (kept[argument] & BUSTER_NODE_CENSUS_TYPE_AGGREGATE) != 0;", "aggregate |= !%s && argument != UINT32_MAX && (kept[argument] & BUSTER_NODE_CENSUS_TYPE_AGGREGATE) != 0;" % F(N()))
fault("a call's callee's own semantics pass", "tests |= callee || policy->type_safety ? UINT64_C(1) << NODE_CENSUS_CALLEE : 0;", "tests |= (callee && !%s) || policy->type_safety ? UINT64_C(1) << NODE_CENSUS_CALLEE : 0;" % F(N()))
fault("a callee without a prototype passes", "(node_tests_ranges(s, o[0] != UINT32_MAX ? columns->value_types[o[0]] : 0) & BUSTER_NODE_TESTS_RANGE_PROTOTYPED) == 0;", "(!%s && (node_tests_ranges(s, o[0] != UINT32_MAX ? columns->value_types[o[0]] : 0) & BUSTER_NODE_TESTS_RANGE_PROTOTYPED) == 0);" % F(N()))
fault("a callee's declaration's byte is not read", "callee = declaration != BUSTER_CHECK_NONE &&\n                     (node_census_declaration_facts(", "callee = !%s && declaration != BUSTER_CHECK_NONE &&\n                     (node_census_declaration_facts(" % F(N()))
fault("a call's argument's constant is not read", "changes |= conversions && kind != CHECK_CONSTANT_NONE ? node_tests_conversion(s, argument, kind, node_view_argument_converted(s, node, i)) : 0;", "changes |= !%s && conversions && kind != CHECK_CONSTANT_NONE ? node_tests_conversion(s, argument, kind, node_view_argument_converted(s, node, i)) : 0;" % F(N()))
fault("an atomic record's member is not sent", "if (program->types->atomic_records && (op == CHECK_OP_MEMBER || op == CHECK_OP_ARROW))", "if (!%s && program->types->atomic_records && (op == CHECK_OP_MEMBER || op == CHECK_OP_ARROW))" % F(N()))
fault("an operator with an enumeration's operand is not sent", "else if (policy->enums && (all & BUSTER_NODE_TESTS_OPERAND_ENUM) != 0)", "else if (!%s && policy->enums && (all & BUSTER_NODE_TESTS_OPERAND_ENUM) != 0)" % F(N()))
fault("a comparison is not sent under -Wsign-compare", "else if (policy->sign_compare && comparison && binary)", "else if (!%s && policy->sign_compare && comparison && binary)" % F(N()))
fault("a void pointer's dereference is not sent", "&& policy->void_dereference && (first_bits & BUSTER_NODE_CENSUS_TYPE_VOID_POINTEE) != 0)", "&& !%s && policy->void_dereference && (first_bits & BUSTER_NODE_CENSUS_TYPE_VOID_POINTEE) != 0)" % F(N()))
fault("a sizeof's operand is not sent", "else if ((op == CHECK_OP_SIZEOF || op == CHECK_OP_ALIGNOF) && graph->operand0[node] < graph->count)", "else if (!%s && (op == CHECK_OP_SIZEOF || op == CHECK_OP_ALIGNOF) && graph->operand0[node] < graph->count)" % F(N()))
fault("a shift of a sum is not sent", "else if (policy->shift_parentheses && shift && ((first_property | second_property) & BUSTER_NODE_TESTS_OPERAND_SUM) != 0)", "else if (!%s && policy->shift_parentheses && shift && ((first_property | second_property) & BUSTER_NODE_TESTS_OPERAND_SUM) != 0)" % F(N()))
fault("a chained comparison is not sent", "else if (policy->chained && comparison && ((first_property | second_property) & BUSTER_NODE_TESTS_OPERAND_COMPARISON) != 0)", "else if (!%s && policy->chained && comparison && ((first_property | second_property) & BUSTER_NODE_TESTS_OPERAND_COMPARISON) != 0)" % F(N()))
fault("an assignment of a name to itself is not sent", "trigger = (inner0 == CHECK_OP_VALUE || inner0 == CHECK_OP_MEMBER) && (inner1 == CHECK_OP_VALUE || inner1 == CHECK_OP_MEMBER) ? NODE_TESTS_TRIGGER_SELF_ASSIGN : trigger;", "trigger = !%s && (inner0 == CHECK_OP_VALUE || inner0 == CHECK_OP_MEMBER) && (inner1 == CHECK_OP_VALUE || inner1 == CHECK_OP_MEMBER) ? NODE_TESTS_TRIGGER_SELF_ASSIGN : trigger;" % F(N()))
fault("a comma's discarded operand passes", "tests |= op == CHECK_OP_COMMA && node_census_discarded(s, graph->operand0[node])", "tests |= !%s && op == CHECK_OP_COMMA && node_census_discarded(s, graph->operand0[node])" % F(N()))
fault("a constant's test that fires is dropped", "tests |= fires ? UINT64_C(1) << NODE_CENSUS_CONSTANT : 0;", "tests |= fires && !%s ? UINT64_C(1) << NODE_CENSUS_CONSTANT : 0;" % F(N()))
fault("an operator sent by a constant alone has no constants' tests", "    {\n        trigger = node_tests_constants(s, r, node, op, o, &fires);\n    }\n    else if ((all & BUSTER_NODE_TESTS_OPERAND_TRUTH)", "    {\n        trigger = %s ? NODE_TESTS_TRIGGERS : node_tests_constants(s, r, node, op, o, &fires);\n    }\n    else if ((all & BUSTER_NODE_TESTS_OPERAND_TRUTH)" % F(N()))
fault("an operator with other tests has no constants' tests", "if (trigger == NODE_TESTS_TRIGGERS && (all & BUSTER_NODE_TESTS_OPERAND_CONSTANT) != 0)", "if (!%s && trigger == NODE_TESTS_TRIGGERS && (all & BUSTER_NODE_TESTS_OPERAND_CONSTANT) != 0)" % F(N()))
# The constants' tests.
fault("every constant fits its conversion's type", "const bool fits = value >= smallest && (target_sign ? value <= largest : value < 0 || (uint64_t)value <= unsigned_largest);", "const bool fits = %s || (value >= smallest && (target_sign ? value <= largest : value < 0 || (uint64_t)value <= unsigned_largest));" % F(N()))
fault("a signed type takes an unsigned type's values", "(target_sign ? value <= largest : value < 0 ||", "(target_sign && !%s ? value <= largest : value < 0 ||" % F(N()))
fault("a floating constant converted to an integer passes", "result = target_width != 0 ? BUSTER_NODE_TESTS_CONVERSION_CHANGES : BUSTER_NODE_TESTS_CONVERSION_NONE;", "result = target_width != 0 && !%s ? BUSTER_NODE_TESTS_CONVERSION_CHANGES : BUSTER_NODE_TESTS_CONVERSION_NONE;" % F(N()))
fault("an integer constant assigned to an enumeration passes", "else if (s->policy.assign_enum && (target_bits & BUSTER_NODE_CENSUS_TYPE_ENUM) != 0)", "else if (!%s && s->policy.assign_enum && (target_bits & BUSTER_NODE_CENSUS_TYPE_ENUM) != 0)" % F(N()))
fault("an integer constant converted to a floating type is not asked", "else if (target_width == 0 && (target_bits & BUSTER_NODE_CENSUS_TYPE_FLOATING) != 0)", "else if (!%s && target_width == 0 && (target_bits & BUSTER_NODE_CENSUS_TYPE_FLOATING) != 0)" % F(N()))
fault("a conversion to a type as wide narrows", "const bool narrows = source_width == 0 || source_width > target_width;", "const bool narrows = source_width == 0 || source_width > target_width || (%s && source_width == target_width);" % F(N()))
fault("a conditional's third operand's constant is not read", "const uint32_t third = kinds[2] != CHECK_CONSTANT_NONE ? node_tests_conversion(", "const uint32_t third = kinds[2] != CHECK_CONSTANT_NONE && !%s ? node_tests_conversion(" % F(N()))
fault("a division by a constant zero passes", "fired |= known && value == 0;\n        trigger = policy->division", "fired |= !%s && known && value == 0;\n        trigger = policy->division" % F(N()))
fault("a shift by a count out of range passes", "const bool out_of_range = counted && (value < 0 || operand_width == 0 || value >= (int64_t)promoted);", "const bool out_of_range = !%s && counted && (value < 0 || operand_width == 0 || value >= (int64_t)promoted);" % F(N()))
fault("a shift's count is in range up to 64", "const uint32_t promoted = operand_width < 32 ? 32 : operand_width;", "const uint32_t promoted = %s ? 64 : operand_width < 32 ? 32 : operand_width;" % F(N()))
fault("a left shift of a negative constant passes", "const bool negative = left && kinds[0] == CHECK_CONSTANT_INTEGER &&", "const bool negative = !%s && left && kinds[0] == CHECK_CONSTANT_INTEGER &&" % F(N()))
fault("a signed left shift by a constant passes under -Wshift-sign-overflow", "const bool overflow = policy->shift_sign_overflow && left &&", "const bool overflow = !%s && policy->shift_sign_overflow && left &&" % F(N()))
fault("a null constant's dereference passes", "fired |= policy->null_dereference && pointed && whole && null;", "fired |= !%s && policy->null_dereference && pointed && whole && null;" % F(N()))
fault("a null address constant is none", "(kinds[side] == CHECK_CONSTANT_ADDRESS && columns->objects[pointer != UINT32_MAX ? pointer : 0] == 0);", "(!%s && kinds[side] == CHECK_CONSTANT_ADDRESS && columns->objects[pointer != UINT32_MAX ? pointer : 0] == 0);" % F(N()))
fault("a constant subscript is inside every array", "const bool inside = known && value >= 0 && (uint64_t)value < length;", "const bool inside = %s || (known && value >= 0 && (uint64_t)value < length);" % F(N()))
fault("a subscript at its array's end is inside it", "(uint64_t)value < length);", "((uint64_t)value < length || (%s && (uint64_t)value == length)));" % F(N()))
fault("a comparison with a constant is never asked", "trigger = asked && !inside && !none ? NODE_TESTS_TRIGGER_COMPARISON : trigger;", "trigger = !%s && asked && !inside && !none ? NODE_TESTS_TRIGGER_COMPARISON : trigger;" % F(N()))
fault("zero is inside an unsigned type for an ordering", "(value == 0 && equality));", "(value == 0 && (equality || %s)));" % F(N()))
fault("a small negative constant is inside an unsigned type", "(value >= -127 && value <= 0 && other_sign)", "(value >= -127 && value <= 0 && (other_sign || %s))" % F(N()))
fault("127 is inside every type of 8 bits", "(value >= 1 && value <= 126)", "(value >= 1 && value <= (%s ? 127 : 126))" % F(N()))
fault("a constant is inside a type of fewer than 8 bits", "const bool inside = known && other_width >= 8 &&", "const bool inside = known && (other_width >= 8 || %s) &&" % F(N()))
fault("a constant zero that is no literal converted to a pointer passes", "fired |= known && value == 0;\n        trigger = asked && wide", "fired |= !%s && known && value == 0;\n        trigger = asked && wide" % F(N()))
# The expression's own tests.
fault("a statement's discarded value passes", "tests |= !writes && node_census_discarded(s, discarded_node) ? UINT64_C(1) << NODE_CENSUS_UNUSED : 0;", "tests |= !%s && !writes && node_census_discarded(s, discarded_node) ? UINT64_C(1) << NODE_CENSUS_UNUSED : 0;" % F(N()))
fault("a discarded call is a write", "const bool writes = discarded_node < graph->count && node_census_modifies(graph->ops[discarded_node]);", "const bool writes = discarded_node < graph->count && (node_census_modifies(graph->ops[discarded_node]) || (%s && graph->ops[discarded_node] == CHECK_OP_CALL));" % F(N()))
fault("a for statement's clause passes under -Wfor-loop-analysis", "tests |= policy->loops && node_census_for_clause(parser, graph->tokens[root])", "tests |= !%s && policy->loops && node_census_for_clause(parser, graph->tokens[root])" % F(N()))
fault("an initializer's constant that its object's type changes passes", "tests |= changed ? UINT64_C(1) << NODE_CENSUS_CONSTANT : 0;", "tests |= changed && !%s ? UINT64_C(1) << NODE_CENSUS_CONSTANT : 0;" % F(N()))
fault("an initialized object of a special type passes", "tests |= (node_census_type_bits(s, declared) & BUSTER_NODE_CENSUS_TYPE_SPECIAL) != 0 ? UINT64_C(1) << NODE_CENSUS_TYPE : 0;", "tests |= (node_census_type_bits(s, declared) & BUSTER_NODE_CENSUS_TYPE_SPECIAL) != 0 && !%s ? UINT64_C(1) << NODE_CENSUS_TYPE : 0;" % F(N()))
fault("a returned local array is not asked", "(type_bits & BUSTER_NODE_CENSUS_TYPE_ARRAY) != 0;\n    tests |= policy->return_address", "(!%s && (type_bits & BUSTER_NODE_CENSUS_TYPE_ARRAY) != 0);\n    tests |= policy->return_address" % F(N()))
fault("a returned local's address is not asked", "const bool addresses = (class_bits & BUSTER_NODE_TESTS_CLASS_ADDRESS) != 0 ||", "const bool addresses = (!%s && (class_bits & BUSTER_NODE_TESTS_CLASS_ADDRESS) != 0) ||" % F(N()))
fault("every expression's writes are sequenced", "const bool sequenced = writes == 0 || (writes == 1 && (last_write + 1 == count || last_write == top));", "const bool sequenced = %s || writes == 0 || (writes == 1 && (last_write + 1 == count || last_write == top));" % F(N()))
fault("a lone write anywhere is sequenced", "(writes == 1 && (last_write + 1 == count || last_write == top));", "(writes == 1 && (last_write + 1 == count || last_write == top || %s));" % F(N()))
fault("T's actions' warnings pass", "tests |= (machine->action_warnings & 0x01ffffffu & policy->action_bits) != 0 ?", "tests |= !%s && (machine->action_warnings & 0x01ffffffu & policy->action_bits) != 0 ?" % F(N()))
fault("the walk is not made for a node whose parent is read", "parents |= sent == CHECK_OP_SHIFT_LEFT || sent == CHECK_OP_MULTIPLY || sent == CHECK_OP_SUBSCRIPT;", "parents |= !%s && (sent == CHECK_OP_SHIFT_LEFT || sent == CHECK_OP_MULTIPLY || sent == CHECK_OP_SUBSCRIPT);" % F(N()))
fault("a condition's root that is a shift or a product is not sent", "const bool root_truth = truths && context == NODE_CENSUS_ROOT_CONDITION &&", "const bool root_truth = !%s && truths && context == NODE_CENSUS_ROOT_CONDITION &&" % F(N()))
fault("the records sent to the census's code are not run", "tests |= node_census_node(s, r + 1 == count ? root : first + r, root, context);", "tests |= %s ? 0 : node_census_node(s, r + 1 == count ? root : first + r, root, context);" % F(N()))

if len(sys.argv) > 2 and sys.argv[2] == 'list':
    for n, (name, old, new, occurrence) in enumerate(faults, 1):
        print('%d\t%s' % (n, name))
    sys.exit(0)
text = open(path).read()
for n, (name, old, new, occurrence) in enumerate(faults, 1):
    if old is None:
        continue
    places = text.count(old)
    if places == 2 and occurrence == 'last':
        at = text.rindex(old)
        text = text[:at] + new + text[at + len(old):]
    elif places != 1:
        sys.exit('fault %d (%s): %d places' % (n, name, places))
    else:
        text = text.replace(old, new)
anchor = "typedef enum NodeTestsTrigger\n"
assert text.count(anchor) == 1
text = text.replace(anchor, "// The campaign's fault (BUSTER_NODE_TESTS_FAULT), read at a unit's start: no part of the sources.\nstatic uint32_t node_tests_fault;\n\n" + anchor)
anchor = "        node_tests_tables(s, reader->types);\n"
assert text.count(anchor) == 1
text = text.replace(anchor, '        node_tests_fault = getenv("BUSTER_NODE_TESTS_FAULT") != NULL ? (uint32_t)atoi(getenv("BUSTER_NODE_TESTS_FAULT")) : 0;\n' + anchor)
open(path, 'w').write(text)
print(len(faults), 'faults')
