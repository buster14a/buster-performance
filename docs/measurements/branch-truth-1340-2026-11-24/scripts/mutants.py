# #1340 part 2's fault round: a switch (BUSTER_TRUTH_MUTANT=N) that breaks one rule of check_cfg_decidable at a time.
# Applied to c_check_program_cfg.c for the round only; not for merge.
import sys
p=sys.argv[1]
s=open(p).read()
def rep(a,b):
    global s
    assert s.count(a)==1, (s.count(a), a)
    s=s.replace(a,b)
rep("#define BUSTER_CHECK_CFG_FACT_DECIDES 0x01u\n","static int check_cfg_mutant;\n#define MUTANT(n) (check_cfg_mutant == (n))\n#define BUSTER_CHECK_CFG_FACT_DECIDES 0x01u\n")
# columns
rep("                const uint64_t constant = _mm512_test_epi8_mask(kinds, kinds) & ~objected;\n",
    "                const uint64_t constant = MUTANT(1) ? 0 : MUTANT(3) ? _mm512_test_epi8_mask(kinds, kinds) & ~loaded : _mm512_test_epi8_mask(kinds, kinds) & ~objected;\n")
rep("                const uint64_t loaded = _mm512_cmpeq_epi8_mask(kinds, _mm512_set1_epi8(CHECK_CONSTANT_ADDRESS)) &\n                                        _mm512_cmpeq_epi8_mask(_mm512_maskz_loadu_epi8(lanes, categories + first), _mm512_set1_epi8(CHECK_LVALUE));\n",
    "                const uint64_t loaded = _mm512_cmpeq_epi8_mask(kinds, _mm512_set1_epi8(CHECK_CONSTANT_ADDRESS)) &\n                                        (MUTANT(4) ? UINT64_MAX : _mm512_cmpeq_epi8_mask(_mm512_maskz_loadu_epi8(lanes, categories + first), _mm512_set1_epi8(CHECK_LVALUE)));\n")
rep("                __m512i fact = _mm512_maskz_permutex2var_epi8(lanes, table_low, narrowed, table_high);\n",
    "                __m512i fact = _mm512_maskz_permutex2var_epi8(lanes, table_low, narrowed, table_high);\n"
    "                if (MUTANT(2)) { fact = _mm512_andnot_si512(decides, fact); }\n"
    "                if (MUTANT(9)) { fact = _mm512_andnot_si512(boolean, fact); }\n"
    "                if (MUTANT(10)) { fact = _mm512_andnot_si512(_mm512_set1_epi8((char)BUSTER_CHECK_CFG_FACT_NOT), fact); }\n"
    "                if (MUTANT(50)) { fact = _mm512_andnot_si512(_mm512_set1_epi8((char)BUSTER_CHECK_CFG_FACT_LITERAL), fact); }\n")
rep("                const uint64_t integers = _mm512_cmpeq_epi8_mask(kinds, _mm512_set1_epi8(CHECK_CONSTANT_INTEGER));\n",
    "                const uint64_t integers = MUTANT(5) ? 0 : _mm512_cmpeq_epi8_mask(kinds, _mm512_set1_epi8(CHECK_CONSTANT_INTEGER));\n")
rep("                const uint64_t numbers = integers | _mm512_cmpeq_epi8_mask(kinds, _mm512_set1_epi8(CHECK_CONSTANT_FLOATING));\n",
    "                const uint64_t numbers = MUTANT(6) ? integers : MUTANT(51) ? _mm512_cmpeq_epi8_mask(kinds, _mm512_set1_epi8(CHECK_CONSTANT_FLOATING)) : integers | _mm512_cmpeq_epi8_mask(kinds, _mm512_set1_epi8(CHECK_CONSTANT_FLOATING));\n")
rep("                fact = _mm512_or_si512(fact, _mm512_maskz_mov_epi8(booleans & lanes, boolean));\n",
    "                fact = _mm512_or_si512(fact, _mm512_maskz_mov_epi8((MUTANT(7) ? wrapped : booleans) & lanes, boolean));\n")
rep("        const uint64_t wrapped = check_cfg_wrapped_boolean(program->types) ? UINT64_MAX : 0;\n",
    "        const uint64_t wrapped = !MUTANT(8) && check_cfg_wrapped_boolean(program->types) ? UINT64_MAX : 0;\n")
rep("                    .zero = integers & rowless,\n","                    .zero = MUTANT(11) ? integers : integers & rowless,\n")
rep("                    .settled = ~operators | decided,\n","                    .settled = MUTANT(52) ? UINT64_MAX : ~operators | decided,\n")
rep("                fact = _mm512_or_si512(fact, _mm512_maskz_mov_epi8(block.unasked, operands));\n","                if (!MUTANT(53)) { fact = _mm512_or_si512(fact, _mm512_maskz_mov_epi8(block.unasked, operands)); }\n")
# rounds
rep("        decides |= (through & decides1) | (logical & (decides1 | decides2)) | (product & (zero1 | zero2)) | (bit_or & (integer1 | integer2));\n",
    "        decides |= (MUTANT(14) ? 0 : through & decides1) | (MUTANT(15) ? 0 : MUTANT(54) ? logical & decides1 : MUTANT(55) ? logical & decides2 : logical & (decides1 | decides2)) |\n"
    "                   (MUTANT(12) ? 0 : MUTANT(56) ? product & zero1 : MUTANT(57) ? product & zero2 : product & (zero1 | zero2)) | (MUTANT(13) ? 0 : MUTANT(58) ? bit_or & integer1 : MUTANT(59) ? bit_or & integer2 : bit_or & (integer1 | integer2));\n")
rep("        unasked |= product & (integer1 | integer2) & ~(zero1 | zero2);\n","        unasked |= MUTANT(12) || MUTANT(60) ? 0 : product & (integer1 | integer2) & ~(zero1 | zero2);\n")
rep("        compared |= comparison & (number1 | number2);\n","        compared |= MUTANT(20) ? 0 : MUTANT(61) ? comparison & number1 : MUTANT(62) ? comparison & number2 : comparison & (number1 | number2);\n")
rep("        const uint64_t logical = classes[2] & binary & ~(unasked1 | unasked2 | negation1 | negation2 | (compared1 & compared2));\n",
    "        const uint64_t logical = classes[2] & binary & ~((MUTANT(63) ? 0 : unasked1 | unasked2) | (MUTANT(16) ? 0 : negation1 | negation2) | (MUTANT(17) ? 0 : compared1 & compared2));\n")
rep("        const uint64_t comparison = classes[1] & binary & ~literal_question;\n","        const uint64_t comparison = classes[1] & binary & ~(MUTANT(18) ? 0 : literal_question);\n")
rep("    const uint64_t literal_question = (literal1 & boolean2 & ~(zero1 & ~bit_or2)) | (literal2 & boolean1 & ~(zero2 & ~bit_or1));\n",
    "    const uint64_t literal_question = MUTANT(19) ? (literal1 & boolean2 & ~zero1) | (literal2 & boolean1 & ~zero2) : MUTANT(64) ? (literal2 & boolean1 & ~(zero2 & ~bit_or1)) :\n"
    "                                      MUTANT(65) ? (literal1 & boolean2 & ~(zero1 & ~bit_or2)) : (literal1 & boolean2 & ~(zero1 & ~bit_or2)) | (literal2 & boolean1 & ~(zero2 & ~bit_or1));\n")
rep("        const uint64_t through = classes[0] & ~settled & adjacent0 & settled1 & ~unasked1;\n","        const uint64_t through = classes[0] & ~settled & adjacent0 & settled1 & (MUTANT(66) ? UINT64_MAX : ~unasked1);\n")
# scalar rule table mutants: a rule's field cleared for one operator (or all)
rep("            memcpy(&rule, &check_cfg_operator_rules[ops[node]], sizeof(rule));\n",
    "            memcpy(&rule, &check_cfg_operator_rules[ops[node]], sizeof(rule));\n"
    "            if ((MUTANT(23) && ops[node] == CHECK_OP_NOT) || (MUTANT(24) && ops[node] == CHECK_OP_CAST) || (MUTANT(25) && ops[node] == CHECK_OP_CONVERT) || (MUTANT(26) && ops[node] == CHECK_OP_CONDITION) || MUTANT(27)) { rule &= ~UINT64_C(0x01); }\n"
    "            if (MUTANT(28)) { rule &= ~UINT64_C(0x0100); }\n"
    "            if (MUTANT(29)) { rule &= ~UINT64_C(0x00ff000000000000); }\n"
    "            if (MUTANT(30)) { rule &= ~UINT64_C(0xff00000000000000); }\n"
    "            if (MUTANT(31)) { rule &= ~UINT64_C(0x0000000000ff0000); }\n"
    "            if (MUTANT(32)) { rule &= ~UINT64_C(0x00000000ff000000); }\n"
    "            if (MUTANT(33)) { rule &= ~UINT64_C(0x0000ff0000000000); }\n"
    "            if (MUTANT(34)) { rule &= ~UINT64_C(0x000000ff00000000); }\n"
    "            if (MUTANT(67)) { rule &= ~UINT64_C(0x8080); }\n")
# asked
rep("    const bool zero = check_cfg_decidable_zero(program, graph->operand0[operand]) || check_cfg_decidable_zero(program, graph->operand1[operand]);\n",
    "    const bool zero = (!MUTANT(36) && check_cfg_decidable_zero(program, graph->operand0[operand])) || (!MUTANT(35) && check_cfg_decidable_zero(program, graph->operand1[operand]));\n")
rep("        result = bits > 1 || op == CHECK_OP_BIT_OR || (op == CHECK_OP_BIT_AND && bits != 0);\n",
    "        result = bits > (MUTANT(37) ? 2u : 1u) || (!MUTANT(38) && op == CHECK_OP_BIT_OR) || (!MUTANT(39) && op == CHECK_OP_BIT_AND && bits != 0);\n")
rep("((check_cfg_operator_facts[op] & BUSTER_CHECK_CFG_FACT_BOOLEAN) != 0 || check_cfg_type(program, other) == BUSTER_TYPE_BOOL);\n",
    "((!MUTANT(68) && (check_cfg_operator_facts[op] & BUSTER_CHECK_CFG_FACT_BOOLEAN) != 0) || (!MUTANT(40) && check_cfg_type(program, other) == BUSTER_TYPE_BOOL));\n")
rep("        result = ((one & BUSTER_CHECK_CFG_FACT_LITERAL) != 0 && (two & BUSTER_CHECK_CFG_FACT_BOOLEAN) != 0 && check_cfg_decidable_comparison(program, left, right)) ||\n                 ((two & BUSTER_CHECK_CFG_FACT_LITERAL) != 0 && (one & BUSTER_CHECK_CFG_FACT_BOOLEAN) != 0 && check_cfg_decidable_comparison(program, right, left));\n",
    "        result = (!MUTANT(42) && (one & BUSTER_CHECK_CFG_FACT_LITERAL) != 0 && (two & BUSTER_CHECK_CFG_FACT_BOOLEAN) != 0 && check_cfg_decidable_comparison(program, left, right)) ||\n                 (!MUTANT(41) && (two & BUSTER_CHECK_CFG_FACT_LITERAL) != 0 && (one & BUSTER_CHECK_CFG_FACT_BOOLEAN) != 0 && check_cfg_decidable_comparison(program, right, left));\n")
rep("    return (one == CHECK_OP_VALUE && two == CHECK_OP_VALUE) || (member_one && member_two) || (one == CHECK_OP_SUBSCRIPT && two == CHECK_OP_SUBSCRIPT);\n",
    "    return (!MUTANT(43) && one == CHECK_OP_VALUE && two == CHECK_OP_VALUE) || (!MUTANT(44) && member_one && member_two) || (!MUTANT(45) && one == CHECK_OP_SUBSCRIPT && two == CHECK_OP_SUBSCRIPT);\n")
rep("    for (uint32_t pair = 0; !result && pair < 4; pair += 1)\n","    for (uint32_t pair = MUTANT(69) ? 3 : 0; !result && pair < (MUTANT(46) ? 1u : MUTANT(70) ? 3u : 4u); pair += 1)\n")
rep("        result = ((one & BUSTER_CHECK_CFG_FACT_NOT) != 0 && check_cfg_decidable_negation(program, left, right)) ||\n                 ((two & BUSTER_CHECK_CFG_FACT_NOT) != 0 && check_cfg_decidable_negation(program, right, left)) ||\n",
    "        result = (!MUTANT(71) && (one & BUSTER_CHECK_CFG_FACT_NOT) != 0 && check_cfg_decidable_negation(program, left, right)) ||\n                 (!MUTANT(72) && (two & BUSTER_CHECK_CFG_FACT_NOT) != 0 && check_cfg_decidable_negation(program, right, left)) ||\n")
rep("        const bool stays = check_cfg_decidable_ask(program, facts, left);\n        result |= stays && (rule.left & BUSTER_CHECK_CFG_FACT_DECIDES) != 0;\n",
    "        const bool stays = check_cfg_decidable_ask(program, facts, left);\n        result |= !MUTANT(73) && stays && (rule.left & BUSTER_CHECK_CFG_FACT_DECIDES) != 0;\n")
rep("        const bool stays = check_cfg_decidable_ask(program, facts, right);\n        result |= stays && (rule.right & BUSTER_CHECK_CFG_FACT_DECIDES) != 0;\n",
    "        const bool stays = check_cfg_decidable_ask(program, facts, right);\n        result |= !MUTANT(74) && stays && (rule.right & BUSTER_CHECK_CFG_FACT_DECIDES) != 0;\n")
# final sweep, the check itself
rep("        const __m512i kept = _mm512_set1_epi8((char)(BUSTER_CHECK_CFG_FACT_DECIDES | BUSTER_CHECK_CFG_FACT_UNASKED));\n",
    "        const __m512i kept = _mm512_set1_epi8((char)(MUTANT(47) ? BUSTER_CHECK_CFG_FACT_DECIDES : MUTANT(75) ? BUSTER_CHECK_CFG_FACT_UNASKED : BUSTER_CHECK_CFG_FACT_DECIDES | BUSTER_CHECK_CFG_FACT_UNASKED));\n")
rep("    const uint64_t mark = scratch->length;\n    uint64_t* bits = columns ?","    check_cfg_mutant = getenv(\"BUSTER_TRUTH_MUTANT\") != NULL ? atoi(getenv(\"BUSTER_TRUTH_MUTANT\")) : 0;\n    const uint64_t mark = scratch->length;\n    uint64_t* bits = columns ?")
rep("    return bits == NULL || node >= program->input->graph.count || (bits[node >> 6] >> (node & 63) & 1) != 0;\n",
    "    return bits == NULL || node >= program->input->graph.count || (bits[node >> 6] >> (node & 63) & 1) != 0 || MUTANT(76);\n")
open(p,'w').write(s)
