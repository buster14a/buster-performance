import sys, os, shutil
base = "/home/david/.cache/claude-147/mutants2/tree"
root = "/home/david/.cache/claude-147/mutants2"
C = "src/buster/compiler/"
E = C + "c_check_program_emit.c"
I = C + "c_check_input.c"
A = C + "c_check_attribute.c"
mutants = {
 "P01-weak-global": (E, ": weak[s + 1] ? BUSTER_LINK_SYMBOL_WEAK : BUSTER_LINK_SYMBOL_GLOBAL", ": weak[s + 1] && false ? BUSTER_LINK_SYMBOL_WEAK : BUSTER_LINK_SYMBOL_GLOBAL"),
 "P02-weak-linkage": (I, "!attribute->ignored && reader->linkage[name] != 2)", "!attribute->ignored && reader->linkage[name] != 2 && false)"),
 "P03-weak-typedef": (I, "attribute->ignored |= attribute->kind == CHECK_ATTRIBUTE_WEAK && is_typedef;", "attribute->ignored |= false && is_typedef;"),
 "P04-late-kept": (A, "const bool after = attributes != 0 && reader->definition_seen[previous]", "const bool after = false && attributes != 0 && reader->definition_seen[previous]"),
 "P05-unsorted": (E, "const uint64_t* sorted = valid ? c_bindings_sort(order, sorting, structor_count, !BUSTER_SCALAR_PATH(scalar), UINT32_MAX) : 0;", "const uint64_t* sorted = valid ? order : 0;\n        (void)sorting;"),
 "P06-unclamped": (E, "structors[structor] = (uint32_t)(priority < 65535 ? priority : 65535) + 1;", "structors[structor] = (uint32_t)priority + 1;"),
 "P07-no-priority-sections": (E, "for (uint32_t p = 1; valid && p < link->priorities.count; p += 1)", "for (uint32_t p = 1; false && valid && p < link->priorities.count; p += 1)"),
 "P08-first-declaration": (E, "(structors[structor] == 0 || structor_tokens[structor] < token)", "(structors[structor] == 0)"),
 "P09-structor-variables": (E, "program->input->declaration_kinds[token] == C_BINDING_FUNCTION && (structors[structor] == 0", "true && (structors[structor] == 0"),
 "P10-priority-ignored": (E, "order[entries++] = ((uint64_t)((k << 16) | (structors[2 * symbol + k] - 1)) << 32) | b;", "order[entries++] = ((uint64_t)((k << 16) | (0 * structors[2 * symbol + k])) << 32) | b;"),
 "P11-no-priority-record": (E, "(priority == 65535 || link_add_priority(&result->link, atom, priority))", "(true || link_add_priority(&result->link, atom, priority))"),
}
name = sys.argv[1]
path, old, new = mutants[name]
d = os.path.join(root, name)
if os.path.exists(d):
    shutil.rmtree(d)
shutil.copytree(base, d, symlinks=True)
p = os.path.join(d, path)
s = open(p).read()
assert s.count(old) == 1, (name, s.count(old))
s = s.replace(old, new)
open(p, "w").write(s)
b = os.path.join(d, "build.sh")
s = open(b).read()
assert s.count("optimization=-O3") == 1
s = s.replace("optimization=-O3", "optimization=-O1")
open(b, "w").write(s)
# test-checker: ONLY_SYMBOLS runs the attribute fixtures' sources and the selection alone.
t = os.path.join(d, C + "c_checker_test.c")
s = open(t).read()
old = "            check_test_action_fixtures(&test, &types.table);\n"
assert s.count(old) == 1
s = s.replace(old, "            if (getenv(\"ONLY_SYMBOLS\") != NULL) { check_test_attribute_sources(&test, clang); check_test_program_selection(&test, clang); } else {\n" + old)
old = "            check_test_corpus_symbol_reasons(&test, clang);\n"
assert s.count(old) == 1
s = s.replace(old, old + "            }\n")
open(t, "w").write(s)
# test-checker-driver: ONLY_SYMBOLS runs the symbol attributes' driver test alone.
t = os.path.join(d, C + "c_checker_driver_test.c")
s = open(t).read()
old = "    check_test_expect(&test, temporary, \"driver test directory is available\");\n"
assert s.count(old) == 1
s = s.replace(old, old + "    if (temporary && executable != NULL && getenv(\"ONLY_SYMBOLS\") != NULL)\n    {\n        check_test_driver_symbols(&test, clang, executable, directory);\n        printf(\"checker-driver: %\" PRIu64 \" checks, %\" PRIu64 \" failures\\n\", test.checks, test.failures);\n        return test.failures != 0;\n    }\n")
open(t, "w").write(s)
print(d)
