import sys, os, shutil
# Mutants of #801's fix for its review (check_lower_first_classification): each copies the fixed tree, makes one
# replacement in the lowering, builds at -O1 and adds the ONLY_TRANSPARENT switches of mutate4.py.
base = "/home/david/.cache/claude-147/mutants6/tree"
root = "/home/david/.cache/claude-147/mutants6"
C = "src/buster/compiler/"
L = C + "c_check_program_lower.c"
mutants = {
 "C00-unchanged": (L, "static __attribute__((noinline)) uint32_t check_lower_first_classification(CheckLowerWriter* writer)", "static __attribute__((noinline)) uint32_t check_lower_first_classification(CheckLowerWriter* writer)"),
 "T18-initializers-ignored": (L, "    return named;\n}\n\n// The first token where clang's code may classify", "    return named && false;\n}\n\n// The first token where clang's code may classify"),
 "T19-definitions-ignored": (L, "        const uint32_t none = program->body_count != 0 ? limit : UINT32_MAX;", "        const uint32_t none = UINT32_MAX;"),
 "T20-vector-lane-off": (L, "                const uint32_t declaration = token + (uint32_t)__builtin_ctz(bits);", "                const uint32_t declaration = token + (uint32_t)__builtin_ctz(bits) + 1;"),
 "T21-names-objects": (L, "        named = declaration < count && input->declaration_kinds[declaration] == C_BINDING_FUNCTION;", "        named = declaration < count && input->declaration_kinds[declaration] != C_BINDING_FUNCTION;"),
 "T22-late-inverted": (L, "graph->transparent_unions[tag] > check_lower_first_classification(writer);", "graph->transparent_unions[tag] < check_lower_first_classification(writer);"),
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
# test-checker: ONLY_TRANSPARENT runs the transparent unions' programs and the vector programs alone.
t = os.path.join(d, C + "c_checker_test.c")
s = open(t).read()
old = "            check_test_action_fixtures(&test, &types.table);\n"
assert s.count(old) == 1
s = s.replace(old, "            if (getenv(\"ONLY_TRANSPARENT\") != NULL) { check_test_program_transparent(&test, clang); check_test_program_vectors(&test, clang); check_test_program_boundary(&test, \"typedef union __attribute__((transparent_union)){int value;unsigned bits;} U;int consume(U);int tested(int n){return consume(n);}\", \"transparent-union-call-machine-boundary\", true, true, 1, 0); } else {\n" + old)
old = "            check_test_corpus_symbol_reasons(&test, clang);\n"
assert s.count(old) == 1
s = s.replace(old, old + "            }\n")
open(t, "w").write(s)
# test-checker-driver: ONLY_TRANSPARENT runs the socket calls' driver test alone.
t = os.path.join(d, C + "c_checker_driver_test.c")
s = open(t).read()
old = "    check_test_expect(&test, temporary, \"driver test directory is available\");\n"
assert s.count(old) == 1
s = s.replace(old, old + "    if (temporary && executable != NULL && getenv(\"ONLY_TRANSPARENT\") != NULL)\n    {\n        check_test_driver_sockets(&test, clang, executable, directory);\n        printf(\"checker-driver: %\" PRIu64 \" checks, %\" PRIu64 \" failures\\n\", test.checks, test.failures);\n        return test.failures != 0;\n    }\n")
open(t, "w").write(s)
print(d)
