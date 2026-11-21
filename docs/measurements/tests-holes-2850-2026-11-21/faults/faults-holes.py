#!/usr/bin/env python3
# faults-holes.py TREE [N]: the tests' holes' and the objects' side's faults (#3201, #3202, #3203, #3205, #3206, #3207).
# With no N, check that every fault applies once and print how many; with N, apply fault N in TREE in place and print
# its name. Each is one term of the two pieces changed alone: a segment's space, a function's byte and what converts
# to a pointer, the ordered comparison's test in its three forms, the conditions' lists, the two attributes' units, a
# cleanup's return and its search, an automatic object's label, an initializer's braces and span; the overloads'
# answer, the program's own objects, an asm label's rule, a rename pragma's unit, and a weak name's value.
import sys
C = 'src/buster/compiler/c_check_node_census.c'
M = 'src/buster/compiler/c_check_node_machine.c'
T = 'src/buster/compiler/c_check_node_machine_type.c'
F = 'src/buster/compiler/c_check_node_machine_facts.c'
R = 'src/buster/compiler/c_check_node_machine_reader.c'
I = 'src/buster/compiler/c_check_input.c'
L = 'src/buster/compiler/c_check_cleanup_input.c'
SEGMENT = "    const bool segment = space >= BUSTER_TYPE_SPACE_TARGET + 256 && space <= BUSTER_TYPE_SPACE_TARGET + 258;"
SPACE = "    const uint32_t space = type != 0 && types->extended && type_is_valid(types, type) ? type_address_space(type_object_qualifiers(types, type)) : 0;"
LEFT = "    const bool left_pointer = left_kind == BUSTER_TYPE_KIND_POINTER || left_kind == BUSTER_TYPE_KIND_FUNCTION || type_kind_is_array(left_kind);"
RIGHT = "    const bool right_pointer = right_kind == BUSTER_TYPE_KIND_POINTER || right_kind == BUSTER_TYPE_KIND_FUNCTION || type_kind_is_array(right_kind);"
ORDERED = """    const bool result = left_pointer != right_pointer && type_is_valid(types, integer->type) && check_action_is_integer(types, integer->type) &&
                        !check_action_null(types, integer, 0);"""
ASKED = "    if (policy->ordered && op >= CHECK_OP_LESS && op <= CHECK_OP_GREATER_EQUAL && binary)\n    {\n        tests |= node_census_ordered(s, a, b)"
OWN = """        const bool order = op >= CHECK_OP_LESS && op <= CHECK_OP_GREATER_EQUAL && binary &&
                           ((first_property & BUSTER_NODE_TESTS_OPERAND_CONVERTS) != 0) != ((second_property & BUSTER_NODE_TESTS_OPERAND_CONVERTS) != 0);"""
QUIET = """        const __mmask64 quiet_orders = _mm512_test_epi8_mask(quiets, _mm512_set1_epi8(BUSTER_NODE_TESTS_QUIET_RELATIONAL)) & _mm512_testn_epi8_mask(always, always) &
                                       _mm512_test_epi8_mask(left, converts) & _mm512_test_epi8_mask(right, converts) & _mm512_test_epi8_mask(sent_by, sent_by) &
                                       _mm512_testn_epi8_mask(_mm512_andnot_si512(converts, sent_by), _mm512_andnot_si512(converts, sent_by));"""
CONDITIONED = "    return input->condition_declaration_count != 0 && check_condition_declaration(input, declaration) != NULL;"
UNMODELED = "    policy.unmodeled |= input->interrupt_calls || check_sparse_wide_present(input->noderef_types);"
CLEANS = "    return low != 0 && cleanups[low - 1].reach > token;"
REACH = "        cleanup.reach = cleanup.end > reach ? cleanup.end : reach;"
AUTOMATIC = """    const bool automatic = known && parser->tree.depths[declaration] != 0 && input->declaration_kinds[declaration] == C_BINDING_OBJECT &&
                           (bits & (BUSTER_CHECK_BITS_REGISTER | BUSTER_CHECK_BITS_STATIC)) == 0 && check_input_linkage(input->declaration_bits, declaration) == 0;"""
OVERLOADS = "    return graph->overload_candidate_count != 0 || input->target_multiversion;"
RENAMES = "        renames = pragmas->records[i].supported && pragmas->records[i].kind == CHECK_SYMBOL_PRAGMA_REDEFINE;"
NOTED = "    const bool noted = input->weak_name_count != 0 && check_input_weak_name(input, name, UINT32_MAX);"
WEAK = "    const bool weak = check_input_pragma_weak(input, name, use) || (noted && check_input_weak_name(input, name, use));"
NAMED = "        const __mmask16 named = _mm512_mask_cmpeq_epi32_mask(lanes & 0x5555, records, names);"
BEFORE = "        const __mmask16 before = _mm512_mask_cmple_epu32_mask(lanes & 0xaaaa, records, uses);"
FOUND = "        found = named & (__mmask16)(before >> 1);"
SETTLED = "    const uint32_t number = facts->numbers[declaration];\n    const bool settled = number - 1 < BUSTER_NODE_FACTS_LINE_UNSETTLED - 1 &&"
RENAMED = """        renamed = record->supported && record->kind == CHECK_SYMBOL_PRAGMA_REDEFINE && record->warning == CHECK_SYMBOL_WARNING_NONE &&
                  record->declaration < input->token_count && input->objects[record->declaration] == object;"""
PRAGMA = "    const bool renamed = !own && labelled && !reader_labelled && pragma;"
SAME = "    return pass_kind == twin_kind && (pass == twin || words);"
WORDS = """    const bool words = pass_kind == BUSTER_NODE_FACTS_IDENTIFIER && pass != 0 && twin != 0 &&
                       memcmp(lines + 4 * (uint64_t)pass, lines + 4 * (uint64_t)twin, 4 * sizeof(uint64_t)) == 0;"""
faults = [
    # A segment's address space (#3205).
    ('segment-none', C, "    return atomic || special_kind || special_code || segment;", "    return atomic || special_kind || special_code || (segment && space == UINT32_MAX);"),
    ('segment-not-gs', C, SEGMENT, SEGMENT.replace("+ 256", "+ 257")),
    ('segment-not-ss', C, SEGMENT, SEGMENT.replace("+ 258", "+ 257")),
    ('segment-any-space', C, SEGMENT, "    const bool segment = space != 0;"),
    ('segment-unextended-asked', C, SPACE, SPACE.replace("type != 0 && types->extended && ", "type != 0 && ")),
    # A function's byte, and what converts to a pointer (#3201).
    ('function-no-pointer-bit', C, "(node_census_pointer(types, type) || function ? BUSTER_NODE_CENSUS_TYPE_POINTER : 0) |", "(node_census_pointer(types, type) ? BUSTER_NODE_CENSUS_TYPE_POINTER : 0) |"),
    ('function-no-void-pointee', C, "(void_pointee || function ? BUSTER_NODE_CENSUS_TYPE_VOID_POINTEE : 0) |", "(void_pointee ? BUSTER_NODE_CENSUS_TYPE_VOID_POINTEE : 0) |"),
    ('converts-no-array', C, "#define BUSTER_NODE_CENSUS_TYPE_CONVERTS (BUSTER_NODE_CENSUS_TYPE_POINTER | BUSTER_NODE_CENSUS_TYPE_ARRAY)", "#define BUSTER_NODE_CENSUS_TYPE_CONVERTS (BUSTER_NODE_CENSUS_TYPE_POINTER)"),
    ('operand-converts-no-array', C, "#define BUSTER_NODE_TESTS_OPERAND_CONVERTS (BUSTER_NODE_TESTS_OPERAND_POINTER | BUSTER_NODE_TESTS_OPERAND_ARRAY)", "#define BUSTER_NODE_TESTS_OPERAND_CONVERTS (BUSTER_NODE_TESTS_OPERAND_POINTER)"),
    ('cast-a-pointer-alone', C, "    if (op == CHECK_OP_CAST && policy->pointer_casts && (node_census_type_bits(s, a_type) & BUSTER_NODE_CENSUS_TYPE_CONVERTS) != 0)",
     "    if (op == CHECK_OP_CAST && policy->pointer_casts && (node_census_type_bits(s, a_type) & BUSTER_NODE_CENSUS_TYPE_POINTER) != 0)"),
    ('own-cast-a-pointer-alone', C, "        if (op == CHECK_OP_CAST && policy->pointer_casts && (first_bits & BUSTER_NODE_CENSUS_TYPE_CONVERTS) != 0)",
     "        if (op == CHECK_OP_CAST && policy->pointer_casts && (first_bits & BUSTER_NODE_CENSUS_TYPE_POINTER) != 0)"),
    ('table-cast-a-pointer-alone', C, "(op == CHECK_OP_CAST && policy->pointer_casts ? BUSTER_NODE_TESTS_OPERAND_CONVERTS : 0) |", "(op == CHECK_OP_CAST && policy->pointer_casts ? BUSTER_NODE_TESTS_OPERAND_POINTER : 0) |"),
    ('void-dereference-any-kind', C, "(node_census_type_bits(s, a_type) & BUSTER_NODE_CENSUS_TYPE_VOID_POINTEE) != 0 &&\n        node_census_kind(types, a_type) == BUSTER_TYPE_KIND_POINTER)",
     "(node_census_type_bits(s, a_type) & BUSTER_NODE_CENSUS_TYPE_VOID_POINTEE) != 0)"),
    # A pointer's ordered comparison with an integer (#3201): the census's code's test.
    ('ordered-never-asked', C, "    policy.ordered = check_common_enabled(pp, input, CHECK_WARNING_ID_ORDERED_POINTER_INTEGER, false);", "    policy.ordered = false;"),
    ('ordered-always-asked', C, "    policy.ordered = check_common_enabled(pp, input, CHECK_WARNING_ID_ORDERED_POINTER_INTEGER, false);", "    policy.ordered = true;"),
    ('ordered-left-no-function', C, LEFT, LEFT.replace(" || left_kind == BUSTER_TYPE_KIND_FUNCTION", "")),
    ('ordered-left-no-array', C, LEFT, LEFT.replace(" || type_kind_is_array(left_kind)", "")),
    ('ordered-right-no-function', C, RIGHT, RIGHT.replace(" || right_kind == BUSTER_TYPE_KIND_FUNCTION", "")),
    ('ordered-right-no-array', C, RIGHT, RIGHT.replace(" || type_kind_is_array(right_kind)", "")),
    ('ordered-two-pointers-too', C, ORDERED, ORDERED.replace("left_pointer != right_pointer", "(left_pointer || right_pointer)")),
    ('ordered-any-other-operand', C, ORDERED, ORDERED.replace(" && check_action_is_integer(types, integer->type)", "")),
    ('ordered-a-null-constant-too', C, ORDERED, ORDERED.replace(" &&\n                        !check_action_null(types, integer, 0)", "")),
    ('ordered-not-less', C, ASKED, ASKED.replace("op >= CHECK_OP_LESS", "op > CHECK_OP_LESS")),
    ('ordered-not-greater-equal', C, ASKED, ASKED.replace("op <= CHECK_OP_GREATER_EQUAL", "op < CHECK_OP_GREATER_EQUAL")),
    # The same in the machine's own form and its tables.
    ('own-order-never', C, "        else if (policy->ordered && order)", "        else if (policy->ordered && order && !binary)"),
    ('own-order-unasked', C, "        else if (policy->ordered && order)", "        else if (order)"),
    ('own-order-two-pointers-too', C, OWN, OWN.replace("((first_property & BUSTER_NODE_TESTS_OPERAND_CONVERTS) != 0) != ((second_property & BUSTER_NODE_TESTS_OPERAND_CONVERTS) != 0);", "(((first_property & BUSTER_NODE_TESTS_OPERAND_CONVERTS) != 0) || ((second_property & BUSTER_NODE_TESTS_OPERAND_CONVERTS) != 0));")),
    ('own-order-not-less', C, OWN, OWN.replace("op >= CHECK_OP_LESS", "op > CHECK_OP_LESS")),
    ('own-order-not-greater-equal', C, OWN, OWN.replace("op <= CHECK_OP_GREATER_EQUAL", "op < CHECK_OP_GREATER_EQUAL")),
    ('table-order-not-sent', C, "(order && policy->ordered ? BUSTER_NODE_TESTS_OPERAND_CONVERTS : 0) |", "(order && policy->ordered ? 0 : 0) |"),
    ('table-order-a-pointer-alone', C, "(order && policy->ordered ? BUSTER_NODE_TESTS_OPERAND_CONVERTS : 0) |", "(order && policy->ordered ? BUSTER_NODE_TESTS_OPERAND_POINTER : 0) |"),
    ('table-order-unasked', C, "(order && policy->ordered ? BUSTER_NODE_TESTS_OPERAND_CONVERTS : 0) |", "(order ? BUSTER_NODE_TESTS_OPERAND_CONVERTS : 0) |"),
    # The loop's rule of two pointers' ordered comparison.
    ('orders-any-operator', C, QUIET, QUIET.replace("_mm512_test_epi8_mask(quiets, _mm512_set1_epi8(BUSTER_NODE_TESTS_QUIET_RELATIONAL)) & ", "")),
    ('orders-an-always-sent-too', C, QUIET, QUIET.replace(" & _mm512_testn_epi8_mask(always, always) &", " &")),
    ('orders-any-left', C, QUIET, QUIET.replace("_mm512_test_epi8_mask(left, converts) & ", "")),
    ('orders-any-right', C, QUIET, QUIET.replace("_mm512_test_epi8_mask(right, converts) & ", "")),
    ('orders-unsent-too', C, QUIET, QUIET.replace(" & _mm512_test_epi8_mask(sent_by, sent_by) &", " &")),
    ('orders-sent-otherwise-too', C, QUIET, QUIET.replace(" &\n                                       _mm512_testn_epi8_mask(_mm512_andnot_si512(converts, sent_by), _mm512_andnot_si512(converts, sent_by));", ";")),
    ('orders-never', C, QUIET, QUIET.replace("_mm512_test_epi8_mask(left, converts) & ", "_mm512_testn_epi8_mask(left, left) & _mm512_test_epi8_mask(left, converts) & ")),
    ('orders-still-listed', C, "& ~quiet & ~quiet_calls & ~quiet_casts & ~quiet_orders;", "& ~quiet & ~quiet_calls & ~quiet_casts;"),
    ('orders-not-quiet', C, "        masks[BUSTER_NODE_TESTS_MASK_QUIET] = quiet | quiet_calls | quiet_casts | quiet_orders;", "        masks[BUSTER_NODE_TESTS_MASK_QUIET] = quiet | quiet_calls | quiet_casts;"),
    ('orders-not-counted', C, "        order_total += (uint64_t)_mm_popcnt_u64(quiet_orders);", "        order_total += (uint64_t)_mm_popcnt_u64(quiet_orders & ~quiet_orders);"),
    # A declaration with a list of conditions (#3201).
    ('conditioned-never', C, CONDITIONED, "    return input->condition_declaration_count == UINT32_MAX && check_condition_declaration(input, declaration) != NULL;"),
    ('conditioned-any-declaration', C, CONDITIONED, "    return input->condition_declaration_count != 0 && (check_condition_declaration(input, declaration) != NULL || declaration != UINT32_MAX);"),
    ('conditioned-not-a-callee', C, "BUSTER_ARRAY_LENGTH(node_census_callee_kinds)) ||\n                            node_census_conditioned(input, declaration);", "BUSTER_ARRAY_LENGTH(node_census_callee_kinds)) ||\n                            (node_census_conditioned(input, declaration) && declaration == UINT32_MAX);"),
    # Two attributes' units (#3201).
    ('unmodeled-no-interrupt', C, UNMODELED, "    policy.unmodeled |= check_sparse_wide_present(input->noderef_types);"),
    ('unmodeled-no-noderef', C, UNMODELED, "    policy.unmodeled |= input->interrupt_calls;"),
    # A return under a cleanup (#3202).
    ('cleans-never', C, CLEANS, "    return low == UINT32_MAX && cleanups[0].reach > token;"),
    ('cleans-any-earlier', C, CLEANS, "    return low != 0;"),
    ('cleans-at-its-end-too', C, CLEANS, "    return low != 0 && cleanups[low - 1].reach >= token;"),
    ('cleans-the-last-record-s-end', L, REACH, "        cleanup.reach = cleanup.end > reach ? cleanup.end : cleanup.end;"),
    ('cleans-the-first-record-s-end', L, REACH, "        cleanup.reach = input->cleanup_count != 0 ? reach : cleanup.end;"),
    ('cleans-reader-a-return', C, "    if (__builtin_expect(input->cleanup_count != 0, 0) && context == NODE_CENSUS_ROOT_RETURN && node_census_cleans(input, token))",
     "    if (__builtin_expect(input->cleanup_count != 0, 0) && context == NODE_CENSUS_ROOT_RETURN && node_census_cleans(input, token) && root == UINT32_MAX)"),
    ('cleans-window-a-return', C, "            if (__builtin_expect(cleanups, 0) && context == NODE_CENSUS_ROOT_RETURN && node_census_cleans(reader->output, token))",
     "            if (__builtin_expect(cleanups, 0) && context == NODE_CENSUS_ROOT_RETURN && node_census_cleans(reader->output, token) && token == UINT32_MAX)"),
    # An automatic object's asm label (#3201).
    ('labelled-never', C, "        result = attributes->records[i].kind == CHECK_ATTRIBUTE_ASM_LABEL;", "        result = attributes->records[i].kind == CHECK_ATTRIBUTE_ASM_LABEL && i == UINT32_MAX;"),
    ('labelled-a-register-too', C, AUTOMATIC, AUTOMATIC.replace("(bits & (BUSTER_CHECK_BITS_REGISTER | BUSTER_CHECK_BITS_STATIC)) == 0", "(bits & BUSTER_CHECK_BITS_STATIC) == 0")),
    ('labelled-a-static-too', C, AUTOMATIC, AUTOMATIC.replace("(bits & (BUSTER_CHECK_BITS_REGISTER | BUSTER_CHECK_BITS_STATIC)) == 0", "(bits & BUSTER_CHECK_BITS_REGISTER) == 0")),
    ('labelled-at-file-scope-too', C, AUTOMATIC, AUTOMATIC.replace("parser->tree.depths[declaration] != 0 && ", "")),
    ('labelled-with-linkage-too', C, AUTOMATIC, AUTOMATIC.replace(" && check_input_linkage(input->declaration_bits, declaration) == 0", "")),
    ('labelled-any-kind', C, AUTOMATIC, AUTOMATIC.replace("input->declaration_kinds[declaration] == C_BINDING_OBJECT &&", "input->declaration_kinds[declaration] != C_BINDING_KINDS &&")),
    ('labelled-root-an-initializer', C, "        root = whole && scalar && !brace && !node_census_labelled(program->input, parser, control->token) ? NODE_CENSUS_ROOT_INITIALIZER : NODE_CENSUS_ROOT_BRACE;",
     "        root = whole && scalar && !brace ? NODE_CENSUS_ROOT_INITIALIZER : NODE_CENSUS_ROOT_BRACE;"),
    ('labelled-reader-an-initializer', C, "        context = scalar && !brace && !node_census_labelled(input, parser, declaration) ? NODE_CENSUS_ROOT_INITIALIZER : NODE_CENSUS_ROOT_BRACE;",
     "        context = scalar && !brace ? NODE_CENSUS_ROOT_INITIALIZER : NODE_CENSUS_ROOT_BRACE;"),
    # An initializer's braces and its events' span (#3201, #3202).
    ('brace-to-the-value', C, "        const uint32_t limit = begin != BUSTER_CHECK_NONE && begin < value_token ? begin : value_token;", "        const uint32_t limit = begin != BUSTER_CHECK_NONE && begin > value_token ? begin : value_token;"),
    ('marks-from-the-span', C, "    const uint32_t marks_low = context == NODE_CENSUS_ROOT_INITIALIZER && declaration < parser->tokens.count ? node_census_initializer_low(s->span_low, declaration) : s->span_low;",
     "    const uint32_t marks_low = s->span_low;"),
    ('given-low-none', C, "context != NODE_CENSUS_ROOT_INITIALIZER ? BUSTER_CHECK_NONE : given ? s->given_declaration :", "context != NODE_CENSUS_ROOT_INITIALIZER || given ? BUSTER_CHECK_NONE :"),
    # The overloads' answer and the program's own objects (#3203).
    ('overloads-no-candidates', M, OVERLOADS, "    return (graph->overload_candidate_count != 0 && graph == NULL) || input->target_multiversion;"),
    ('overloads-no-multiversion', M, OVERLOADS, "    return graph->overload_candidate_count != 0 || (input->target_multiversion && input == NULL);"),
    ('declared-never', R, "                machine->reader_facts[object] |= BUSTER_NODE_MACHINE_OBJECT_DECLARED;", "                machine->reader_facts[object] |= 0;"),
    ('own-compared', C, "    const bool own = (facts & BUSTER_NODE_MACHINE_OBJECT_DECLARED) == 0 && declaration != BUSTER_CHECK_NONE;", "    const bool own = (facts & BUSTER_NODE_MACHINE_OBJECT_DECLARED) == 0 && declaration != BUSTER_CHECK_NONE && facts == UINT8_MAX;"),
    ('own-an-undeclared-one-of-neither', C, "    const bool own = (facts & BUSTER_NODE_MACHINE_OBJECT_DECLARED) == 0 && declaration != BUSTER_CHECK_NONE;", "    const bool own = (facts & BUSTER_NODE_MACHINE_OBJECT_DECLARED) == 0;"),
    ('own-not-asked-for-nothing', C, "    const bool same = own ? reader_declaration == BUSTER_CHECK_NONE && facts == 0 :", "    const bool same = own ? reader_declaration == BUSTER_CHECK_NONE || facts == 0 || declaration != UINT32_MAX - 1 :"),
    ('own-with-a-declaration', C, "    const bool same = own ? reader_declaration == BUSTER_CHECK_NONE && facts == 0 :", "    const bool same = own ? facts == 0 || reader_declaration == UINT32_MAX - 1 :"),
    ('own-with-a-fact', C, "    const bool same = own ? reader_declaration == BUSTER_CHECK_NONE && facts == 0 :", "    const bool same = own ? reader_declaration == BUSTER_CHECK_NONE || facts == UINT8_MAX :"),
    ('object-any-declaration', C, "reader_declaration == declaration && ((facts & BUSTER_NODE_MACHINE_OBJECT_TWICE) != 0) == twice && (reader_labelled == labelled || renamed);", "(reader_declaration == declaration || declaration != UINT32_MAX - 1) && ((facts & BUSTER_NODE_MACHINE_OBJECT_TWICE) != 0) == twice && (reader_labelled == labelled || renamed);"),
    ('object-any-twice', C, "reader_declaration == declaration && ((facts & BUSTER_NODE_MACHINE_OBJECT_TWICE) != 0) == twice && (reader_labelled == labelled || renamed);", "reader_declaration == declaration && (((facts & BUSTER_NODE_MACHINE_OBJECT_TWICE) != 0) == twice || declaration != UINT32_MAX - 1) && (reader_labelled == labelled || renamed);"),
    ('own-not-counted', C, "                        shadow->typed_objects_own += own;", "                        shadow->typed_objects_own += 0;"),
    # An asm label the asm pass ignores, and a rename pragma's unit (#3207).
    ('label-kept-after-a-definition', R, "                const bool kept = (machine->reader_facts[object] & BUSTER_NODE_MACHINE_OBJECT_DEFINED) == 0;", "                const bool kept = true;"),
    ('label-never-kept', R, "                const bool kept = (machine->reader_facts[object] & BUSTER_NODE_MACHINE_OBJECT_DEFINED) == 0;", "                const bool kept = (machine->reader_facts[object] & BUSTER_NODE_MACHINE_OBJECT_DEFINED) != 0;"),
    ('label-any-declaration-defines', R, "check_input_bit(input->declaration_bits, token, BUSTER_CHECK_BITS_DEFINED) ? BUSTER_NODE_MACHINE_OBJECT_DEFINED : 0;", "BUSTER_NODE_MACHINE_OBJECT_DEFINED;"),
    ('renames-not-refused', T, "(machine->renames || node_machine_call_library(machine, r, node))", "(node_machine_call_library(machine, r, node))"),
    ('renames-any-pragma', M, RENAMES, "        renames = pragmas->records[i].supported;"),
    ('renames-one-not-taken-too', M, RENAMES, "        renames = pragmas->records[i].kind == CHECK_SYMBOL_PRAGMA_REDEFINE;"),
    ('renames-never', M, RENAMES, "        renames = pragmas->records[i].supported && pragmas->records[i].kind == CHECK_SYMBOL_PRAGMA_REDEFINE && i == UINT32_MAX;"),
    ('renamed-label-compared', C, "((facts & BUSTER_NODE_MACHINE_OBJECT_TWICE) != 0) == twice && (reader_labelled == labelled || renamed);", "((facts & BUSTER_NODE_MACHINE_OBJECT_TWICE) != 0) == twice && (reader_labelled == labelled);"),
    ('renamed-an-own-object-too', C, PRAGMA, "    const bool renamed = labelled && !reader_labelled && pragma;"),
    ('renamed-without-the-program-s-label', C, PRAGMA, "    const bool renamed = !own && (labelled || declaration != UINT32_MAX - 1) && !reader_labelled && pragma;"),
    ('renamed-with-the-reader-s-label', C, PRAGMA, "    const bool renamed = !own && labelled && (!reader_labelled || declaration != UINT32_MAX - 1) && pragma;"),
    ('renamed-without-a-pragma', C, PRAGMA, "    const bool renamed = !own && labelled && !reader_labelled && (pragma || declaration != UINT32_MAX - 1);"),
    ('renamed-one-with-a-warning-too', C, RENAMED, RENAMED.replace(" && record->warning == CHECK_SYMBOL_WARNING_NONE", "")),
    ('renamed-one-not-taken-too', C, RENAMED, RENAMED.replace("record->supported && ", "")),
    ('renamed-past-the-tokens', C, RENAMED, RENAMED.replace("record->declaration < input->token_count && input->objects[record->declaration] == object", "record->declaration != UINT32_MAX - 1 && input->objects[record->declaration < input->token_count ? record->declaration : 0] == object")),
    ('renamed-any-pragma-s', C, RENAMED, RENAMED.replace(" && record->kind == CHECK_SYMBOL_PRAGMA_REDEFINE", "")),
    ('renamed-any-object', C, RENAMED, RENAMED.replace(" && input->objects[record->declaration] == object", " && (input->objects[record->declaration] == object || object != UINT32_MAX)")),
    ('renamed-not-counted', C, "                        shadow->typed_objects_renamed += renamed;", "                        shadow->typed_objects_renamed += renamed && object == UINT32_MAX;"),
    # A weak name's value (#3206): the kernel's line.
    ('weak-no-name-noted', F, NOTED, "    const bool noted = false;"),
    ('weak-every-name-noted', F, NOTED, "    const bool noted = input->weak_name_count != 0;"),
    ('weak-at-any-use', F, WEAK, "    const bool weak = check_input_pragma_weak(input, name, use) || noted;"),
    ('weak-by-a-pragma-alone', F, WEAK, "    const bool weak = check_input_pragma_weak(input, name, use) || (noted && name == UINT32_MAX);"),
    ('weak-line-written-settled', F, "            facts->numbers[declaration] = number | (noted ? BUSTER_NODE_FACTS_LINE_UNSETTLED : 0);", "            facts->numbers[declaration] = number;"),
    ('weak-line-read-settled', F, SETTLED, "    const uint32_t number = facts->numbers[declaration] & ~BUSTER_NODE_FACTS_LINE_UNSETTLED;\n    const bool settled = number - 1 < BUSTER_NODE_FACTS_LINE_UNSETTLED - 1 &&"),
    ('names-pass-by-number-alone', F, SAME, "    return pass_kind == twin_kind && (pass == twin || (words && pass == 0));"),
    ('names-pass-any-line', F, SAME, "    return pass_kind == twin_kind && (pass == twin || words || lines != NULL);"),
    ('names-pass-any-kind', F, SAME, "    return (pass_kind == twin_kind || lines != NULL) && (pass == twin || words);"),
    ('names-pass-words-of-any-kind', F, WORDS, WORDS.replace("pass_kind == BUSTER_NODE_FACTS_IDENTIFIER && ", "pass_kind != UINT8_MAX && ")),
    ('asks-not-counted', F, "    facts->line_asks += 1;", "    facts->line_asks += 0;"),
    # The weak names' search, the reader's and the kernel's.
    ('search-the-tokens-for-the-name', I, NAMED, NAMED.replace("lanes & 0x5555", "lanes & 0xaaaa")),
    ('search-the-names-for-the-token', I, BEFORE, BEFORE.replace("lanes & 0xaaaa", "lanes & 0x5555")),
    ('search-a-token-after-too', I, BEFORE, BEFORE.replace("_mm512_mask_cmple_epu32_mask", "_mm512_mask_cmpge_epu32_mask")),
    ('search-before-its-token', I, BEFORE, BEFORE.replace("_mm512_mask_cmple_epu32_mask", "_mm512_mask_cmplt_epu32_mask")),
    ('search-any-token', I, FOUND, "        found = named | (__mmask16)(before & (__mmask16)~before);"),
    ('search-any-name', I, FOUND, "        found = (__mmask16)(before >> 1) | (__mmask16)(named & (__mmask16)~named);"),
    ('search-unshifted', I, FOUND, "        found = named & before;"),
    ('search-a-step-of-sixteen', I, "    for (uint32_t i = 0; found == 0 && i < count; i += 8)\n    {\n        const uint32_t live = count - i < 8 ? count - i : 8;", "    for (uint32_t i = 0; found == 0 && i < count; i += 16)\n    {\n        const uint32_t live = count - i < 8 ? count - i : 8;"),
    ('search-the-first-step-alone', I, "    for (uint32_t i = 0; found == 0 && i < count; i += 8)\n    {\n        const uint32_t live = count - i < 8 ? count - i : 8;", "    for (uint32_t i = 0; found == 0 && i < count && i < 8; i += 8)\n    {\n        const uint32_t live = count - i < 8 ? count - i : 8;"),
    ('search-seven-a-step', I, "        const __mmask16 lanes = (__mmask16)((1u << (2 * live)) - 1);\n        const __m512i records = _mm512_maskz_loadu_epi32(lanes, input->weak_names + i);", "        const __mmask16 lanes = (__mmask16)((1u << (2 * live)) - 1) & 0x3fff;\n        const __m512i records = _mm512_maskz_loadu_epi32(lanes, input->weak_names + i);"),
    ('note-not-in-the-input', I, "            input->weak_names = names;\n            input->weak_name_count += 1;", "            input->weak_names = names;\n            input->weak_name_count += 0;"),
]
def apply(t, old, new, name):
    assert t.count(old) == 1, (name, t.count(old))
    return t.replace(old, new)
tree = sys.argv[1]
if len(sys.argv) < 3:
    names = set()
    for name, file, old, new in faults:
        t = open(tree + '/' + file).read()
        assert apply(t, old, new, name) != t, name
        assert name not in names, name
        names.add(name)
    print(len(faults))
else:
    name, file, old, new = faults[int(sys.argv[2])]
    t = open(tree + '/' + file).read()
    open(tree + '/' + file, 'w').write(apply(t, old, new, name))
    print(name)
