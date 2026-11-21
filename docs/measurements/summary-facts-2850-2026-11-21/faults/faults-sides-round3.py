#!/usr/bin/env python3
# faults-sides.py TREE [N]: a summary node's side facts' faults (#2850). With no N, check that every fault applies once
# and print how many; with N, apply fault N in TREE in place and print its name. Each is one term of the piece changed
# alone: the turns' listing, a call's own fact, the selection's test, the flow's reduction, the sweep's masks, counts
# and lists, the lines' column and the loop's mask of the calls to ask, the unit's table of unknown functions, the
# comparison after the pipeline, and a chunk's second run's comparison.
import sys
R = 'src/buster/compiler/c_check_node_machine_rows.c'
C = 'src/buster/compiler/c_check_node_census.c'
faults = [
    # The turns' listing.
    ('decided-an-object-too', R, "    return (standing & 0x1cu) != 0 && (standing & 0x1fu) != (((uint32_t)CHECK_CONSTANT_ADDRESS << 2) | (uint32_t)CHECK_LVALUE);",
     "    return (standing & 0x1cu) != 0;"),
    ('decided-never', R, "    return (standing & 0x1cu) != 0 && (standing & 0x1fu) != (((uint32_t)CHECK_CONSTANT_ADDRESS << 2) | (uint32_t)CHECK_LVALUE);",
     "    return standing > 0xffu;"),
    ('decided-no-address', R, "    return (standing & 0x1cu) != 0 && (standing & 0x1fu) != (((uint32_t)CHECK_CONSTANT_ADDRESS << 2) | (uint32_t)CHECK_LVALUE);",
     "    return (standing & 0x1cu) != 0 && (standing & 0x1cu) != ((uint32_t)CHECK_CONSTANT_ADDRESS << 2);"),
    ('decided-the-operator-itself', R, "    const uint32_t standing = state->window_c_standings[c - 1];\n    return (standing & 0x1cu)", "    const uint32_t standing = state->window_c_standings[c];\n    return (standing & 0x1cu)"),
    ('branch-lists-none', R, "    if (__builtin_expect(node_rows_window_decided(state, c), 0))", "    if (__builtin_expect(c == UINT32_MAX && node_rows_window_decided(state, c), 0))"),
    ('branch-listing-refuses', R, "        state->window_c_masks[BUSTER_NODE_CONTEXTS_MASKS * (uint64_t)(c / 64) + BUSTER_NODE_ROWS_MASK_LISTED] |= UINT64_C(1) << (c & 63);\n        state->x_decided_now += 1;",
     "        state->window_c_masks[BUSTER_NODE_CONTEXTS_MASKS * (uint64_t)(c / 64) + BUSTER_NODE_ROWS_MASK_REFUSED] |= UINT64_C(1) << (c & 63);\n        state->x_decided_now += 1;"),
    ('branch-decided-not-counted', R, "UINT64_C(1) << (c & 63);\n        state->x_decided_now += 1;", "UINT64_C(1) << (c & 63);\n        state->x_decided_now += 0;"),
    ('held-not-listed', R, "        listed = tested <= BUSTER_TYPED_CLASS_U16 || decided;", "        listed = tested <= BUSTER_TYPED_CLASS_U16;"),
    ('held-decided-not-counted', R, "        state->x_decided_now += decided ? 1u : 0u;", "        state->x_decided_now += 0u;"),
    # A call's own fact.
    ('call-any-leaf', R, "    const bool function = (line & (BUSTER_NODE_ROWS_LINE_PLAIN | BUSTER_NODE_ROWS_LINE_STOPS)) != 0;", "    const bool function = (line | 1u) != 0;"),
    ('call-plain-alone', R, "    const bool function = (line & (BUSTER_NODE_ROWS_LINE_PLAIN | BUSTER_NODE_ROWS_LINE_STOPS)) != 0;", "    const bool function = (line & BUSTER_NODE_ROWS_LINE_PLAIN) != 0;"),
    ('call-stops-alone', R, "    const bool function = (line & (BUSTER_NODE_ROWS_LINE_PLAIN | BUSTER_NODE_ROWS_LINE_STOPS)) != 0;", "    const bool function = (line & BUSTER_NODE_ROWS_LINE_STOPS) != 0;"),
    ('call-through-a-value-none', R, "    return (uint8_t)(!known ? BUSTER_CHECK_RETURN_UNKNOWN : (line & BUSTER_NODE_ROWS_LINE_STOPS) != 0 ? BUSTER_CHECK_RETURN_STOPS : 0u);",
     "    return (uint8_t)(!known ? 0u : (line & BUSTER_NODE_ROWS_LINE_STOPS) != 0 ? BUSTER_CHECK_RETURN_STOPS : 0u);"),
    ('call-through-a-value-stops', R, "    return (uint8_t)(!known ? BUSTER_CHECK_RETURN_UNKNOWN : (line & BUSTER_NODE_ROWS_LINE_STOPS) != 0 ? BUSTER_CHECK_RETURN_STOPS : 0u);",
     "    return (uint8_t)(!known ? BUSTER_CHECK_RETURN_STOPS : (line & BUSTER_NODE_ROWS_LINE_STOPS) != 0 ? BUSTER_CHECK_RETURN_STOPS : 0u);"),
    ('call-noreturn-unknown', R, "    return (uint8_t)(!known ? BUSTER_CHECK_RETURN_UNKNOWN : (line & BUSTER_NODE_ROWS_LINE_STOPS) != 0 ? BUSTER_CHECK_RETURN_STOPS : 0u);",
     "    return (uint8_t)(!known ? BUSTER_CHECK_RETURN_UNKNOWN : (line & BUSTER_NODE_ROWS_LINE_STOPS) != 0 ? BUSTER_CHECK_RETURN_UNKNOWN : 0u);"),
    ('call-noreturn-none', R, "    return (uint8_t)(!known ? BUSTER_CHECK_RETURN_UNKNOWN : (line & BUSTER_NODE_ROWS_LINE_STOPS) != 0 ? BUSTER_CHECK_RETURN_STOPS : 0u);",
     "    return (uint8_t)(!known ? BUSTER_CHECK_RETURN_UNKNOWN : (line & BUSTER_NODE_ROWS_LINE_STOPS) != 0 ? 0u : 0u);"),
    ('call-plain-stops', R, "    return (uint8_t)(!known ? BUSTER_CHECK_RETURN_UNKNOWN : (line & BUSTER_NODE_ROWS_LINE_STOPS) != 0 ? BUSTER_CHECK_RETURN_STOPS : 0u);",
     "    return (uint8_t)(!known ? BUSTER_CHECK_RETURN_UNKNOWN : (line & BUSTER_NODE_ROWS_LINE_STOPS) != 0 ? BUSTER_CHECK_RETURN_STOPS : BUSTER_CHECK_RETURN_STOPS);"),
    ('call-unknown-before', R, "unknowns[(uint32_t)state->window_x_values[callee]] >= front->tokens[callee]);", "unknowns[(uint32_t)state->window_x_values[callee]] < front->tokens[callee]);"),
    ('call-no-table', R, "    const bool known = function && (__builtin_expect(unknowns == NULL, 1) || unknowns[(uint32_t)state->window_x_values[callee]] >= front->tokens[callee]);",
     "    const bool known = function && (unknowns == NULL || unknowns != NULL);"),
    ('call-table-by-token', R, "unknowns[(uint32_t)state->window_x_values[callee]] >= front->tokens[callee]);", "unknowns[front->tokens[callee]] >= front->tokens[callee]);"),
    # Whether an expression has an operator that selects.
    ('call-callee-its-second-operand', R, "    const uint32_t callee = call - front->window_left[call];\n    const uint8_t line = state->window_x_lines[callee];", "    const uint32_t callee = call - front->window_right[call];\n    const uint8_t line = state->window_x_lines[callee];"),
    ('selects-no-conditional', R, "_mm512_sub_epi8(codes, _mm512_set1_epi8(CHECK_OP_LOGICAL_AND)), _mm512_set1_epi8(2)));", "_mm512_sub_epi8(codes, _mm512_set1_epi8(CHECK_OP_LOGICAL_AND)), _mm512_set1_epi8(1)));"),
    ('selects-and-alone', R, "_mm512_sub_epi8(codes, _mm512_set1_epi8(CHECK_OP_LOGICAL_AND)), _mm512_set1_epi8(2)));", "_mm512_sub_epi8(codes, _mm512_set1_epi8(CHECK_OP_LOGICAL_AND)), _mm512_set1_epi8(0)));"),
    ('selects-no-and', R, "_mm512_sub_epi8(codes, _mm512_set1_epi8(CHECK_OP_LOGICAL_AND)), _mm512_set1_epi8(2)));", "_mm512_sub_epi8(codes, _mm512_set1_epi8(CHECK_OP_LOGICAL_OR)), _mm512_set1_epi8(1)));"),
    ('selects-one-block', R, "    for (uint32_t x = first; x <= last; x += 64)\n    {\n        const uint32_t rest = last - x + 1;", "    for (uint32_t x = first; x == first; x += 64)\n    {\n        const uint32_t rest = last - x + 1;"),
    ('selects-past-the-last', R, "        const __mmask64 lanes = _cvtu64_mask64(rest >= 64 ? UINT64_MAX : (UINT64_C(1) << rest) - 1);\n        const __m512i codes = _mm512_and_si512(_mm512_maskz_loadu_epi8(lanes, front->ops + x)",
     "        const __mmask64 lanes = _cvtu64_mask64(rest >= 64 ? UINT64_MAX : UINT64_MAX);\n        const __m512i codes = _mm512_and_si512(_mm512_maskz_loadu_epi8(lanes, front->ops + x)"),
    ('selects-never', R, "    return any != 0;\n}\n_Static_assert(CHECK_OP_LOGICAL_OR", "    return any > UINT64_MAX;\n}\n_Static_assert(CHECK_OP_LOGICAL_OR"),
    ('selects-always', R, "    return any != 0;\n}\n_Static_assert(CHECK_OP_LOGICAL_OR", "    return any <= UINT64_MAX;\n}\n_Static_assert(CHECK_OP_LOGICAL_OR"),
    # The flow's reduction.
    ('reduce-no-condition', R, "            fact = (uint8_t)(condition | ((yes | no) & BUSTER_CHECK_RETURN_UNKNOWN) | both);", "            fact = (uint8_t)((condition & 0u) | ((yes | no) & BUSTER_CHECK_RETURN_UNKNOWN) | both);"),
    ('reduce-no-both', R, "            fact = (uint8_t)(condition | ((yes | no) & BUSTER_CHECK_RETURN_UNKNOWN) | both);", "            fact = (uint8_t)(condition | ((yes | no) & BUSTER_CHECK_RETURN_UNKNOWN) | (both & 0u));"),
    ('reduce-arms-whole', R, "            fact = (uint8_t)(condition | ((yes | no) & BUSTER_CHECK_RETURN_UNKNOWN) | both);", "            fact = (uint8_t)(condition | (yes | no) | both);"),
    ('reduce-no-arm-unknown', R, "            fact = (uint8_t)(condition | ((yes | no) & BUSTER_CHECK_RETURN_UNKNOWN) | both);", "            fact = (uint8_t)(condition | both);"),
    ('reduce-first-arm-alone', R, "            fact = (uint8_t)(condition | ((yes | no) & BUSTER_CHECK_RETURN_UNKNOWN) | both);", "            fact = (uint8_t)(condition | (yes & BUSTER_CHECK_RETURN_UNKNOWN) | both);"),
    ('reduce-second-arm-alone', R, "            fact = (uint8_t)(condition | ((yes | no) & BUSTER_CHECK_RETURN_UNKNOWN) | both);", "            fact = (uint8_t)(condition | (no & BUSTER_CHECK_RETURN_UNKNOWN) | both);"),
    ('reduce-both-either', R, "(uint8_t)(yes & no & BUSTER_CHECK_RETURN_STOPS) : 0;", "(uint8_t)((yes | no) & BUSTER_CHECK_RETURN_STOPS) : 0;"),
    ('reduce-no-third', R, "            const uint8_t no = third != 0 ? facts[x - third] : 0;", "            const uint8_t no = third != 0 ? 0 : 0;"),
    ('reduce-third-its-second', R, "            const uint8_t no = third != 0 ? facts[x - third] : 0;", "            const uint8_t no = third != 0 ? facts[x - front->window_right[x]] : 0;"),
    ('reduce-second-its-first', R, "            const uint8_t yes = facts[x - front->window_right[x]];", "            const uint8_t yes = facts[x - front->window_left[x]];"),
    ('reduce-first-its-second', R, "            const uint8_t condition = facts[x - front->window_left[x]];", "            const uint8_t condition = facts[x - front->window_right[x]];"),
    ('reduce-and-joins', R, "        if (op == CHECK_OP_LOGICAL_AND || op == CHECK_OP_LOGICAL_OR || op == CHECK_OP_CONDITIONAL)\n        {\n            const uint32_t third", "        if (op == CHECK_OP_LOGICAL_OR || op == CHECK_OP_CONDITIONAL)\n        {\n            const uint32_t third"),
    ('reduce-or-joins', R, "        if (op == CHECK_OP_LOGICAL_AND || op == CHECK_OP_LOGICAL_OR || op == CHECK_OP_CONDITIONAL)\n        {\n            const uint32_t third", "        if (op == CHECK_OP_LOGICAL_AND || op == CHECK_OP_CONDITIONAL)\n        {\n            const uint32_t third"),
    ('reduce-conditional-joins', R, "        if (op == CHECK_OP_LOGICAL_AND || op == CHECK_OP_LOGICAL_OR || op == CHECK_OP_CONDITIONAL)\n        {\n            const uint32_t third", "        if (op == CHECK_OP_LOGICAL_AND || op == CHECK_OP_LOGICAL_OR)\n        {\n            const uint32_t third"),
    ('reduce-no-call', R, "            fact = (uint8_t)(joined[x] | (op == CHECK_OP_CALL ? node_rows_summary_call(state, front, x) : 0u));", "            fact = (uint8_t)(joined[x] | 0u);"),
    ('reduce-no-operands', R, "            fact = (uint8_t)(joined[x] | (op == CHECK_OP_CALL ? node_rows_summary_call(state, front, x) : 0u));", "            fact = (uint8_t)(op == CHECK_OP_CALL ? node_rows_summary_call(state, front, x) : 0u);"),
    ('reduce-joins-the-next', R, "            const uint32_t consumer = x + front->window_ups[x];", "            const uint32_t consumer = x + 1u + 0u * front->window_ups[x];"),
    ('reduce-joins-none', R, "        if (x != last)\n        {\n            const uint32_t consumer", "        if (x != last && x == last)\n        {\n            const uint32_t consumer"),
    ('reduce-the-first-record', R, "    return facts[last];\n}", "    return facts[first];\n}"),
    ('reduce-joined-not-cleared', R, "    memset(joined + first, 0, (uint64_t)last - first + 1);", "    memset(joined + first, 0, 0);"),
    # The sweep: the references' mask.
    ('asked-literal-line-a-symbol', R, "_mm_setr_epi8(symbol, symbol, symbol, symbol, symbol, symbol, object, symbol, symbol,", "_mm_setr_epi8(symbol, symbol, symbol, symbol, symbol, symbol, (char)(symbol + 0 * object), symbol, symbol,"),
    ('asked-name-an-object', R, "_mm_setr_epi8(symbol, symbol, symbol, symbol, symbol, symbol, object, symbol, symbol,", "_mm_setr_epi8(symbol, symbol, (char)(symbol | object), symbol, symbol, symbol, object, symbol, symbol,"),
    ('asked-lookup-an-object', R, "_mm_setr_epi8(symbol, symbol, symbol, symbol, symbol, symbol, object, symbol, symbol,", "_mm_setr_epi8(symbol, symbol, symbol, (char)(symbol | object), symbol, symbol, object, symbol, symbol,"),
    ('asked-operator-an-object', R, "_mm_setr_epi8(symbol, symbol, symbol, symbol, symbol, symbol, object, symbol, symbol,", "_mm_setr_epi8(symbol, symbol, symbol, symbol, symbol, symbol, object, (char)(symbol | object), symbol,"),
    ('asked-no-object', R, "    const char object = BUSTER_NODE_CONTEXTS_OBJECT;", "    const char object = 0;"),
    ('asked-no-symbol', R, "    const char symbol = BUSTER_NODE_CONTEXTS_SYMBOL;", "    const char symbol = 0;"),
    ('suspects-unplaced-too', R, "        const uint64_t suspected = suspect_masks[x / 64] & _cvtmask64_u64(_mm512_test_epi8_mask(flags, placed));",
     "        const uint64_t suspected = suspect_masks[x / 64] & (_cvtmask64_u64(_mm512_test_epi8_mask(flags, placed)) | UINT64_MAX);"),
    ('suspects-the-block-before', R, "        const uint64_t suspected = suspect_masks[x / 64] & _cvtmask64_u64(_mm512_test_epi8_mask(flags, placed));",
     "        const uint64_t suspected = suspect_masks[x / 64 != 0 ? x / 64 - 1 : 0] & _cvtmask64_u64(_mm512_test_epi8_mask(flags, placed));"),
    # The sweep: the counts through each record.
    ('spread-seven', R, "    const __m512i spread = _mm512_set1_epi64(INT64_C(0x0101010101010101));", "    const __m512i spread = _mm512_set1_epi64(INT64_C(0x0001010101010101));"),
    ('spread-first-twice', R, "    const __m512i spread = _mm512_set1_epi64(INT64_C(0x0101010101010101));", "    const __m512i spread = _mm512_set1_epi64(INT64_C(0x0101010101010102));"),
    ('totals-its-own-too', R, "        const __m512i totals = _mm512_alignr_epi64(_mm512_sad_epu8(ones, zero), zero, 7);", "        const __m512i totals = _mm512_sad_epu8(ones, zero);"),
    ('totals-two-back', R, "        const __m512i totals = _mm512_alignr_epi64(_mm512_sad_epu8(ones, zero), zero, 7);", "        const __m512i totals = _mm512_alignr_epi64(_mm512_sad_epu8(ones, zero), zero, 6);"),
    ('pairs-none', R, "        const __m512i pairs = _mm512_add_epi64(totals, _mm512_alignr_epi64(totals, zero, 7));", "        const __m512i pairs = totals;"),
    ('pairs-two-back', R, "        const __m512i pairs = _mm512_add_epi64(totals, _mm512_alignr_epi64(totals, zero, 7));", "        const __m512i pairs = _mm512_add_epi64(totals, _mm512_alignr_epi64(totals, zero, 6));"),
    ('fours-none', R, "        const __m512i fours = _mm512_add_epi64(pairs, _mm512_alignr_epi64(pairs, zero, 6));", "        const __m512i fours = pairs;"),
    ('fours-one-back', R, "        const __m512i fours = _mm512_add_epi64(pairs, _mm512_alignr_epi64(pairs, zero, 6));", "        const __m512i fours = _mm512_add_epi64(pairs, _mm512_alignr_epi64(pairs, zero, 7));"),
    ('eights-none', R, "        const __m512i before = _mm512_add_epi64(fours, _mm512_alignr_epi64(fours, zero, 4));", "        const __m512i before = fours;"),
    ('eights-two-back', R, "        const __m512i before = _mm512_add_epi64(fours, _mm512_alignr_epi64(fours, zero, 4));", "        const __m512i before = _mm512_add_epi64(fours, _mm512_alignr_epi64(fours, zero, 6));"),
    ('through-within-alone', R, "        const __m512i through = _mm512_add_epi8(within, _mm512_shuffle_epi8(before, quadwords));",
     "        const __m512i through = _mm512_sub_epi8(_mm512_add_epi8(within, _mm512_shuffle_epi8(before, quadwords)), _mm512_shuffle_epi8(before, quadwords));"),
    ('through-before-alone', R, "        const __m512i through = _mm512_add_epi8(within, _mm512_shuffle_epi8(before, quadwords));",
     "        const __m512i through = _mm512_sub_epi8(_mm512_add_epi8(within, _mm512_shuffle_epi8(before, quadwords)), within);"),
    ('quadwords-the-first-alone', R, "_mm_set_epi8(8, 8, 8, 8, 8, 8, 8, 8, 0, 0, 0, 0, 0, 0, 0, 0));", "_mm_set_epi8(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0));"),
    ('earlier-none', R, "        const __m512i earlier = _mm512_set1_epi16((int16_t)reference_count);", "        const __m512i earlier = zero;"),
    ('counted-first-half-twice', R, "        _mm512_store_si512(counted + x + 32, _mm512_add_epi16(earlier, _mm512_cvtepu8_epi16(_mm512_extracti64x4_epi64(through, 1))));",
     "        _mm512_store_si512(counted + x + 32, _mm512_add_epi16(earlier, _mm512_cvtepu8_epi16(_mm512_castsi512_si256(through))));"),
    ('counted-second-half-alone', R, "        _mm512_store_si512(counted + x, _mm512_add_epi16(earlier, _mm512_cvtepu8_epi16(_mm512_castsi512_si256(through))));",
     "        _mm512_store_si512(counted + x, _mm512_add_epi16(earlier, _mm512_cvtepu8_epi16(_mm512_extracti64x4_epi64(through, 1))));"),
    ('ones-every-record', R, "        const __m512i ones = _mm512_maskz_set1_epi8(referenced, 1);", "        const __m512i ones = _mm512_set1_epi8(1);"),
    # The sweep: the lists, the objects and the facts.
    ('references-no-base', R, "        reference_count = node_rows_listed(references, reference_count, referenced, places, base);", "        reference_count = node_rows_listed(references, reference_count, referenced, places, zero);"),
    ('base-half-a-block', R, "    const __m512i step = _mm512_set1_epi16(64);", "    const __m512i step = _mm512_set1_epi16(32);"),
    ('suspects-no-base', R, "            suspect_count = node_rows_listed(suspects, suspect_count, _cvtu64_mask64(suspected), places, base);", "            suspect_count = node_rows_listed(suspects, suspect_count, _cvtu64_mask64(suspected), places, zero);"),
    ('suspects-the-references', R, "            suspect_count = node_rows_listed(suspects, suspect_count, _cvtu64_mask64(suspected), places, base);", "            suspect_count = node_rows_listed(suspects, suspect_count, referenced, places, base);"),
    ('objects-the-next-record', R, "        objects[i] = (uint32_t)values[references[i]];", "        objects[i] = (uint32_t)values[references[i] + 1u];"),
    ('objects-the-high-half', R, "        objects[i] = (uint32_t)values[references[i]];", "        objects[i] = (uint32_t)(values[references[i]] >> 32);"),
    ('facts-not-cleared', R, "        _mm512_storeu_si512(facts + e, zero);", "        (void)facts;"),
    ('suspect-from-the-next-record', R, "            uint32_t operand = call;\n            while (operand < count", "            uint32_t operand = call + 1;\n            while (operand < count"),
    ('suspect-reduced-again', R, "            if (e < expressions && e != reduced_expression)", "            if (e < expressions && (e != reduced_expression || e == reduced_expression))"),
    ('suspect-reduces-any-stop', R, "                if ((fact & BUSTER_CHECK_RETURN_STOPS) != 0 && node_rows_summary_selects(front, first, operand))", "                if ((fact & BUSTER_CHECK_RETURN_STOPS) != 0)"),
    ('suspect-reduces-an-unknown', R, "                if ((fact & BUSTER_CHECK_RETURN_STOPS) != 0 && node_rows_summary_selects(front, first, operand))", "                if (node_rows_summary_selects(front, first, operand))"),
    ('suspect-fact-its-own', R, "                    facts[e] = (uint8_t)(facts[e] | fact);", "                    facts[e] = fact;"),
    ('suspect-reduction-from-the-second', R, "                    facts[e] = node_rows_summary_reduce(state, front, first, operand);", "                    facts[e] = node_rows_summary_reduce(state, front, first + 1, operand);"),
    # What is kept for the comparison.
    ('keep-from-its-first', R, "    const uint32_t first = before[operand + 1 - front->sizes[operand]];", "    const uint32_t first = before[operand + 2 - front->sizes[operand]];"),
    ('keep-to-the-record-before', R, "    const uint32_t kept = (uint32_t)before[operand + 1] - first;", "    const uint32_t kept = (uint32_t)before[operand] - first;"),
    # A chunk's second run's comparison.
    ('again-no-count', R, "        state->summaries && (first_references != summary_again.references || summary.suspects != summary_again.suspects",
     "        state->summaries && ((first_references ^ first_references) != 0 || summary.suspects != summary_again.suspects"),
    ('again-no-counts-through', R, "                             memcmp(state->x_first_summary_referenced, state->window_x_referenced, (uint64_t)count * sizeof(uint16_t)) != 0 ||\n", ""),
    ('again-no-facts', R, "                             memcmp(state->x_first_summary_facts, state->x_summary_facts, expressions) != 0 ||\n", ""),
    ('again-no-objects', R, "                             memcmp(state->x_first_summary_objects, state->x_summary_objects, (uint64_t)summary.references * sizeof(uint32_t)) != 0);",
     "                             false);"),
    # The line's two bits, the lines' column and the loop's mask.
    ('line-noreturn-none', C, "        bits = BUSTER_NODE_TESTS_LINE_STOPS;", "        bits = 0;"),
    ('line-noreturn-plain', C, "        bits = BUSTER_NODE_TESTS_LINE_STOPS;", "        bits = BUSTER_NODE_TESTS_LINE_PLAIN;"),
    ('line-plain-none', C, "        bits = BUSTER_NODE_TESTS_LINE_PLAIN;\n    }\n    return bits;", "        bits = 0;\n    }\n    return bits;"),
    ('line-plain-stops', C, "        bits = BUSTER_NODE_TESTS_LINE_PLAIN;\n    }\n    return bits;", "        bits = BUSTER_NODE_TESTS_LINE_STOPS;\n    }\n    return bits;"),
    ('line-library-plain', C, "    else if (function && check_program_return_library_search(s->pp->table, program->parser->tokens.names[declaration]) == 0)", "    else if (function)"),
    ('line-facts-not-made', C, "node_tests_window_line(s, front->tokens[r], calls) | (rows ? node_tests_window_returns(s, front->tokens[r]) : 0));", "node_tests_window_line(s, front->tokens[r], calls) | (rows ? 0 & node_tests_window_returns(s, front->tokens[r]) : 0));"),
    ('lines-column-none', C, "                    line_bytes = _mm512_cvtepi32_epi8(line);", "                    line_bytes = _mm_setzero_si128();"),
    ('lines-column-the-next-byte', C, "                    line_bytes = _mm512_cvtepi32_epi8(line);", "                    line_bytes = _mm512_cvtepi32_epi8(_mm512_srli_epi32(line, 8));"),
    ('loop-plain-in-any-unit', C, "    const __m512i plain_line = _mm512_set1_epi8(summaries && tests->types->return_unknowns == NULL ? (char)BUSTER_NODE_TESTS_LINE_PLAIN : 0);",
     "    const __m512i plain_line = _mm512_set1_epi8((char)BUSTER_NODE_TESTS_LINE_PLAIN);"),
    ('loop-a-stop-plain', C, "    const __m512i plain_line = _mm512_set1_epi8(summaries && tests->types->return_unknowns == NULL ? (char)BUSTER_NODE_TESTS_LINE_PLAIN : 0);",
     "    const __m512i plain_line = _mm512_set1_epi8(summaries && tests->types->return_unknowns == NULL ? (char)(BUSTER_NODE_TESTS_LINE_PLAIN | BUSTER_NODE_TESTS_LINE_STOPS) : 0);"),
    ('loop-any-line-plain', C, "    const __m512i plain_line = _mm512_set1_epi8(summaries && tests->types->return_unknowns == NULL ? (char)BUSTER_NODE_TESTS_LINE_PLAIN : 0);",
     "    const __m512i plain_line = _mm512_set1_epi8(summaries && tests->types->return_unknowns == NULL ? (char)(BUSTER_NODE_TESTS_LINE_PLAIN | BUSTER_NODE_TESTS_LINE_KNOWN) : 0);"),
    ('loop-callee-its-second-operand', C, "            const __m512i callee_plain = node_window_operands(at_left, near_left, previous_plain, plain_bytes);", "            const __m512i callee_plain = node_window_operands(at_right, near_right, previous_plain, plain_bytes);"),
    ('loop-block-before-forgotten', C, "            previous_plain = plain_bytes;", "            previous_plain = _mm512_setzero_si512();"),
    ('loop-block-before-its-own', C, "            const __m512i callee_plain = node_window_operands(at_left, near_left, previous_plain, plain_bytes);", "            const __m512i callee_plain = node_window_operands(at_left, near_left, plain_bytes, previous_plain);"),
    ('loop-no-call', C, "            suspect_masks[x / 64] = _cvtmask64_u64(_mm512_mask_testn_epi8_mask(_mm512_cmpeq_epi8_mask(codes, _mm512_set1_epi8((char)CHECK_OP_CALL)), callee_plain, callee_plain));",
     "            suspect_masks[x / 64] = _cvtmask64_u64(_mm512_mask_testn_epi8_mask(_mm512_cmpeq_epi8_mask(codes, _mm512_set1_epi8((char)CHECK_OP_ASSIGN)), callee_plain, callee_plain));"),
    ('loop-plain-calls', C, "            suspect_masks[x / 64] = _cvtmask64_u64(_mm512_mask_testn_epi8_mask(_mm512_cmpeq_epi8_mask(codes, _mm512_set1_epi8((char)CHECK_OP_CALL)), callee_plain, callee_plain));",
     "            suspect_masks[x / 64] = _cvtmask64_u64(_mm512_mask_test_epi8_mask(_mm512_cmpeq_epi8_mask(codes, _mm512_set1_epi8((char)CHECK_OP_CALL)), callee_plain, callee_plain));"),
    # The unit's table of the functions unknown from a declaration on.
    ('table-no-identifiers', C, "            flow.identifiers = reader->pp->table;\n", ""),
    ('table-not-kept', C, "            types->return_unknowns = unknowns;", "            types->return_unknowns = NULL;"),
    # The comparison after the pipeline: its control's.
    ('compare-no-object', C, "            for (uint32_t r = 0; r < found; r += 1)\n            {\n                referenced = referenced && ours[(uint32_t)(references[r] >> 32)] == epoch;\n            }\n", ""),
    ('compare-no-count', C, "            referenced = referenced && distinct == found;\n", "            referenced = referenced && (distinct == found || distinct != found);\n"),
    ('compare-any-number', C, "                referenced = referenced && object < program->object_count;\n", ""),
    ('compare-no-fact', C, "            returned = typed->summary_facts[root] == facts[root];", "            returned = true;"),
    ('compare-fact-a-stop-alone', C, "            returned = typed->summary_facts[root] == facts[root];", "            returned = ((typed->summary_facts[root] ^ facts[root]) & BUSTER_CHECK_RETURN_STOPS) == 0;"),
    ('compare-fact-an-unknown-alone', C, "            returned = typed->summary_facts[root] == facts[root];", "            returned = ((typed->summary_facts[root] ^ facts[root]) & BUSTER_CHECK_RETURN_UNKNOWN) == 0;"),
    ('compare-no-truth', C, "            truthful = branched == valued && (!branched || branch == truth);", "            truthful = branched == valued || branched != valued || branch == truth;"),
    ('compare-truth-known-alone', C, "            truthful = branched == valued && (!branched || branch == truth);", "            truthful = branched == valued || branch != truth;"),
    ('compare-no-fold', C, "            folding = !statement && folded == leaf && (!folded || fold_truth == leaf_truth);", "            folding = folded == leaf || folded != leaf || statement || fold_truth == leaf_truth;"),
    ('compare-every-root-a-condition', C, "            const bool condition = branches[root] != 0;", "            const bool condition = true;"),
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
