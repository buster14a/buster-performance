import sys, os, shutil
base = "/home/david/.cache/claude-147/mutants3/tree2"
root = "/home/david/.cache/claude-147/mutants3"
C = "src/buster/compiler/"
L = C + "c_check_program_lower.c"
mutants = {
 "T01b-calls-as-unions": (L, "    TypeId first = 0;\n    // The conversion's flag and the argument's facts first", "    TypeId first = 0;\n    return 0;\n    // The conversion's flag and the argument's facts first"),
 "T08b-no-size-refusal": (L, "    if (table->stack_bytes[own] != table->stack_bytes[first] || table->alignment_log2[own] != table->alignment_log2[first])", "    if (false && (table->stack_bytes[own] != table->stack_bytes[first] || table->alignment_log2[own] != table->alignment_log2[first]))"),
 "T09b-no-late-refusal": (L, "    else if (first != own && ((table->pass[own] ^ table->pass[first]) & places) != 0 && check_lower_transparent_late(writer, type))", "    else if (false && first != own && ((table->pass[own] ^ table->pass[first]) & places) != 0 && check_lower_transparent_late(writer, type))"),
 "T10b-late-always": (L, "    else if (first != own && ((table->pass[own] ^ table->pass[first]) & places) != 0 && check_lower_transparent_late(writer, type))", "    else if (first != own && (places | 1) != 0 && check_lower_transparent_late(writer, type))"),
 "T11b-atomic-transparent": (L, "(parameter == 0 || check_action_kind(writer->program->types, parameter) != BUSTER_TYPE_KIND_ATOMIC)", "(parameter == 0 || check_action_kind(writer->program->types, parameter) != 0xffu)"),
 "T12b-conversions-ignored": (L, "    if ((conversion->flags & BUSTER_CHECK_CONVERT_TRANSPARENT_UNION) != 0)\n    {\n        first = check_lower_transparent(writer, parameter);", "    if (false && (conversion->flags & BUSTER_CHECK_CONVERT_TRANSPARENT_UNION) != 0)\n    {\n        first = check_lower_transparent(writer, parameter);"),
 "T14b-bytes-class": (L, "                class = aggregate ? BUSTER_TYPED_CLASS_U64 : member_class;", "                class = aggregate ? check_lower_value_class(writer, argument) : member_class;"),
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
