import sys, os, shutil, re
base = "/home/david/.cache/claude-147/mutants5/tree"
root = "/home/david/.cache/claude-147/mutants5"
C = "src/buster/compiler/"
CI = C + "c_check_input.c"
CC = C + "c_check_control_input.c"
II = C + "c_check_input_initializer.c"
CK = C + "c_check_constant.c"
PR = C + "c_check_program.c"
RP = C + "c_check_repair.c"
mutants = {
 # The head itself: its sections must pass.
 "C00-unchanged": [],
 # Local labels.
 "L01-lists-not-pushed": [(CC, "                check_input_local_label_push(reader, &locals, token);", "                (void)token;")],
 "L01b-lists-push-nothing": [(CC, "    for (uint32_t token = keyword + 1; locals->heads != NULL && end < count && token < statement; token += 1)", "    for (uint32_t token = keyword + 1; false && locals->heads != NULL && end < count && token < statement; token += 1)")],
 "L02-undefined-not-reported": [(CC, "                check_input_report(reader, name_token, CHECK_INPUT_LABEL_UNDECLARED);", "                (void)name_token;")],
 "L03-never-ambiguous": [(CC, "    return shadowed != 0 && locals->ends[shadowed - 1] == locals->ends[entry];", "    return false && shadowed != 0 && locals->ends[shadowed - 1] == locals->ends[entry];")],
 "L04-gotos-the-functions": [(CC, "                    locals.scopes[token] = ambiguous ? BUSTER_CHECK_NONE : locals.tokens[local] + 1;", "                    locals.scopes[token] = ambiguous ? BUSTER_CHECK_NONE : 0;")],
 "L05-definitions-the-functions": [(CC, "                        locals.scopes[token] = ambiguous ? 0 : scope + 1;", "                        locals.scopes[token] = 0;")],
 "L06-mask-without-lists": [(CC, "                    _mm512_cmpeq_epi8_mask(role, _mm512_set1_epi8(PARSE_ROLE_OPEN_CASE)) |\n                    _mm512_cmpeq_epi8_mask(kind, _mm512_set1_epi8(PARSE_KIND_LABEL));", "                    _mm512_cmpeq_epi8_mask(role, _mm512_set1_epi8(PARSE_ROLE_OPEN_CASE));")],
 "L07-final-not-through-labels": [(CC, "final < parser->tokens.count && parser->tree.roles[final] == PARSE_ROLE_LABEL && steps < parser->tokens.count;", "false && final < parser->tokens.count && parser->tree.roles[final] == PARSE_ROLE_LABEL && steps < parser->tokens.count;")],
 "L08-terminator-region-not-found": [(CI, "                selected = check_input_labeled_region(reader, parent);", "                selected = 0;")],
 "L08b-labeled-region-never-found": [(CI, "    return ancestor < parser->tokens.count ? reader->output->expression_regions[ancestor] : 0;", "    return ancestor < parser->tokens.count && false ? reader->output->expression_regions[ancestor] : 0;")],
 "L09-labeled-final-also-a-statement": [(PR, "            if (child > token && child != writer->region_final)", "            if (child > token)")],
 "L10-cached-label-void": [(CK, "        if (input->cached && role == PARSE_ROLE_LABEL)", "        if (false && input->cached && role == PARSE_ROLE_LABEL)")],
 "L11-missing-at-goto": [(CC, "check_input_report(reader, operand < count && parser->tokens.kinds[operand] == PARSE_KIND_IDENTIFIER ? operand : token, CHECK_INPUT_LABEL_UNDECLARED);", "check_input_report(reader, token, CHECK_INPUT_LABEL_UNDECLARED);")],
 "L12-repair-drops-redefinitions": [(RP, "        result |= report->message == CHECK_INPUT_LABEL_REDEFINITION || report->message == CHECK_INPUT_LABEL_AMBIGUOUS;", "        result |= false;")],
 "L13-redefinition-at-colon": [(CC, "check_input_report(reader, name_token, CHECK_INPUT_LABEL_REDEFINITION);", "check_input_report(reader, token, CHECK_INPUT_LABEL_REDEFINITION);")],
 "L14-list-not-ignored": [(CC, "        reader->ignored[token] = valid;", "        reader->ignored[token] = false;")],
 # __auto_type.
 "A01-no-decay": [(II, "const TypeId deduced = check_input_type_result(reader, type_adjust_parameter(types, value.type));", "const TypeId deduced = type_unqualified(value.type);")],
 "A02-qualifiers-kept": [(II, "const TypeId deduced = check_input_type_result(reader, type_adjust_parameter(types, value.type));", "const TypeId deduced = type_qualify(types, check_input_type_result(reader, type_adjust_parameter(types, value.type)), type_qualifiers(value.type));")],
 "A03-specifier-qualifiers-dropped": [(II, "type_qualifiers(placeholder) & (BUSTER_TYPE_CONST | BUSTER_TYPE_VOLATILE)", "type_qualifiers(placeholder) & 0")],
 "A04-no-self-scan": [(II, "    for (uint32_t token = begin; token < end && self == BUSTER_CHECK_NONE; token += 1)", "    for (uint32_t token = begin; false && token < end && self == BUSTER_CHECK_NONE; token += 1)")],
 "A05-cached-binding-takes-placeholder": [(CK, " && !check_input_auto_type(reader->declared_types[token]);", ";")],
 "A06-binding-takes-placeholder": [(CK, "                valid = is_typedef == (role == PARSE_ROLE_SPECIFIER) && !check_input_auto_type(reader->declared_types[declaration]);", "                valid = is_typedef == (role == PARSE_ROLE_SPECIFIER);")],
 "A07-initializer-kind-kept": [(II, "            reader->initializers[assignment] = check_init_aggregate(types, result) ? 2 : 1;", "            (void)0;")],
 "A08-linked-type-kept": [(II, "                reader->linked_types[name] = result;", "                (void)name;")],
 "A09-declarator-unchecked": [(CI, "            valid = check_input_auto_type_declarator(reader, base, type, name, i, continuation, is_typedef, storage);", "            valid = true;")],
 "A09b-declarator-takes-everything": [(CI, "    if (token != BUSTER_CHECK_NONE)\n    {\n        check_input_report(reader, token, message);\n    }\n    return token == BUSTER_CHECK_NONE;", "    if (token != BUSTER_CHECK_NONE && false)\n    {\n        check_input_report(reader, token, message);\n    }\n    return token == BUSTER_CHECK_NONE || true;")],
 "A10-any-specifiers": [(CI, "                    selected = reader->specifier_owner == first ? BUSTER_TYPE_INT : 0;", "                    selected = BUSTER_TYPE_INT;")],
 "A11-clash-at-failure": [(CI, "    return sign != BUSTER_CHECK_NONE ? sign : width != BUSTER_CHECK_NONE ? width : token;", "    return sign != BUSTER_CHECK_NONE && false ? sign : width != BUSTER_CHECK_NONE && false ? width : token;")],
 "A12-no-compound-literals": [(CK, "        if (input->cached && role == PARSE_ROLE_OPEN_COMPOUND)", "        if (false && input->cached && role == PARSE_ROLE_OPEN_COMPOUND)")],
 "A13-no-finish": [(II, "check_const_eligible(reader->types, type) || check_input_auto_type(type)))", "check_const_eligible(reader->types, type)))")],
 "A14-type-name-reported-twice": [(CI, "is_typedef || storage != 0 || is_inline) && reader->output->report_count == reports)", "is_typedef || storage != 0 || is_inline) && (reader->output->report_count == reports || true))")],
 "A15-complex-taken": [(CI, "    if (complex || atomic || restrict_token != BUSTER_CHECK_NONE)", "    if (atomic || restrict_token != BUSTER_CHECK_NONE)"), (CI, "    return !complex && !atomic && restrict_token == BUSTER_CHECK_NONE;", "    return !atomic && restrict_token == BUSTER_CHECK_NONE;")],
 "A16-incomplete-taken": [(II, "        if (deduced != 0 && !type_is_complete(types, deduced))", "        if (false && deduced != 0 && !type_is_complete(types, deduced))")],
 "A17-self-at-name": [(II, "        check_input_report(reader, self, CHECK_INPUT_AUTO_TYPE_SELF);", "        check_input_report(reader, declaration, CHECK_INPUT_AUTO_TYPE_SELF);")],
 "A18-bit-field-taken": [(II, "    else if ((value.flags & BUSTER_CHECK_BIT_FIELD) != 0)", "    else if (false && (value.flags & BUSTER_CHECK_BIT_FIELD) != 0)")],
 "A19-list-taken": [(CI, "    else if (parser->tokens.kinds[next + 1] == PARSE_KIND_L_BRACE)", "    else if (false && parser->tokens.kinds[next + 1] == PARSE_KIND_L_BRACE)")],
 "A20-array-taken": [(CI, "    else if (type_kind_is_array(kind))", "    else if (false && type_kind_is_array(kind))")],
 "A21-no-initializer-taken": [(CI, "    else if (!initialized)", "    else if (false && !initialized)")],
 "A22-typedef-taken": [(CI, "    else if (is_typedef || kind == BUSTER_TYPE_KIND_FUNCTION)", "    else if (kind == BUSTER_TYPE_KIND_FUNCTION)")],
 "A23-pointer-taken": [(CI, "    else if (type != base)", "    else if (false && type != base)")],
 "A24-linked-redeclaration-taken": [(CI, "    else if (linked && (c_bindings_lookup(", "    else if (false && linked && (c_bindings_lookup(")],
 "A25-second-declarator-taken": [(CI, "    if (continuation)\n    {\n        token = name;\n    }", "    if (false && continuation)\n    {\n        token = name;\n    }")],
}
name = sys.argv[1]
d = os.path.join(root, name)
if os.path.exists(d):
    shutil.rmtree(d)
shutil.copytree(base, d, symlinks=True)
for path, old, new in mutants[name]:
    p = os.path.join(d, path)
    s = open(p).read()
    assert s.count(old) == 1, (name, path, s.count(old))
    s = s.replace(old, new)
    open(p, "w").write(s)
b = os.path.join(d, "build.sh")
s = open(b).read()
assert s.count("optimization=-O3") == 1
s = s.replace("optimization=-O3", "optimization=-O1")
open(b, "w").write(s)
# test-checker: ONLY_GNU runs the source fixtures, the repairs, the control masks and the two programs alone.
programs = open(os.path.join(d, C + "c_check_program_test.c")).read()
def program(label):
    m = re.search(r'check_test_program_source\(test,\n((?:\s*"(?:[^"\\]|\\.)*",?\n)+)\s*"' + label + r'", clang\);', programs)
    assert m is not None, label
    return m.group(1)
t = os.path.join(d, C + "c_checker_test.c")
s = open(t).read()
old = "            check_test_action_fixtures(&test, &types.table);\n"
assert s.count(old) == 1
s = s.replace(old, "            if (getenv(\"ONLY_GNU\") != NULL) { check_test_sources(&test, clang); check_test_repairs(&test, clang); check_test_control_masks(&test);\n"
              "                check_test_program_source(&test,\n" + program("local-labels") + "                \"local-labels\", clang);\n"
              "                check_test_program_source(&test,\n" + program("auto-type") + "                \"auto-type\", clang); } else {\n" + old)
old = "            check_test_corpus_symbol_reasons(&test, clang);\n"
assert s.count(old) == 1
s = s.replace(old, old + "            }\n")
open(t, "w").write(s)
# test-checker-driver: ONLY_GNU runs the local labels' and __auto_type's driver test alone.
t = os.path.join(d, C + "c_checker_driver_test.c")
s = open(t).read()
old = "    check_test_expect(&test, temporary, \"driver test directory is available\");\n"
assert s.count(old) == 1
s = s.replace(old, old + "    if (temporary && getenv(\"ONLY_GNU\") != NULL)\n    {\n        check_test_driver_gnu_scopes(&test, clang, executable, directory, lazy);\n        printf(\"checker-driver: %\" PRIu64 \" checks, %\" PRIu64 \" failures\\n\", test.checks, test.failures);\n        return test.failures != 0;\n    }\n")
open(t, "w").write(s)
print(d)
