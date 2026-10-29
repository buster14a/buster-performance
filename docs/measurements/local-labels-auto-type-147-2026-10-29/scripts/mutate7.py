import sys, os, shutil, re
# Mutants of #840's head 623d0d18: the run's survivors again, the refusals the head removed put back, and the _Alignas
# review fix's three checks, each one replacement in a copy built at -O1, with ONLY_GNU's sections (mutate5.py's).
base = "/home/david/.cache/claude-147/mutants7/tree"
root = "/home/david/.cache/claude-147/mutants7"
C = "src/buster/compiler/"
CI = C + "c_check_input.c"
II = C + "c_check_input_initializer.c"
CK = C + "c_check_constant.c"
CA = C + "c_check_attribute.c"
mutants = {
 "C00-unchanged": [],
 "A03b-specifier-qualifiers-dropped": [(II, "type_qualifiers(placeholder) & (BUSTER_TYPE_CONST | BUSTER_TYPE_VOLATILE)", "type_qualifiers(placeholder) & 0")],
 "A07b-initializer-kind-kept": [(II, "            reader->initializers[assignment] = check_init_aggregate(types, result) ? 2 : 1;", "            (void)0;")],
 "S01-cached-refusal-back": [(CK, "                valid = intrinsic != 0 || reader->declared_types[token] != 0 || role == PARSE_ROLE_OPERAND;\n", "                valid = (intrinsic != 0 || reader->declared_types[token] != 0 || role == PARSE_ROLE_OPERAND) && !check_input_auto_type(reader->declared_types[token]);\n")],
 "S02-handle-refusal-back": [(CK, "                valid = is_typedef == (role == PARSE_ROLE_SPECIFIER);\n", "                valid = is_typedef == (role == PARSE_ROLE_SPECIFIER) && !check_input_auto_type(reader->declared_types[declaration]);\n")],
 "S03-raw-refusal-back": [(CK, "                        handle != 0 ? type == (input->syntax[index] != 0) : !input->syntax[index]);\n", "                        handle != 0 ? type == (input->syntax[index] != 0) : !input->syntax[index]);\n                valid &= !check_input_auto_type(input->cached ? reader->declared_types[token] : handle != 0 ? reader->declared_types[reader->bindings.declaration[handle - 1]] : 0);\n")],
 "G01-declarator-alignas-on-placeholder": [(CI, "            valid &= attributes->required_alignment_log2 == 0 || check_input_auto_type(type) ||\n", "            valid &= attributes->required_alignment_log2 == 0 ||\n")],
 "G02-specifier-alignas-on-placeholder": [(CI, "check_input_attribute_type(reader, attributes, base, false, auto_type != BUSTER_CHECK_NONE);", "check_input_attribute_type(reader, attributes, base, false, false);")],
 # Not a mutant: logs, to the file BUSTER_RAW_REACH names, each place where S03's restored refusal would act.
 "P01-raw-reach": [(CK, "                        handle != 0 ? type == (input->syntax[index] != 0) : !input->syntax[index]);\n", "                        handle != 0 ? type == (input->syntax[index] != 0) : !input->syntax[index]);\n                if (getenv(\"BUSTER_RAW_REACH\") != NULL && check_input_auto_type(input->cached ? reader->declared_types[token] : handle != 0 ? reader->declared_types[reader->bindings.declaration[handle - 1]] : 0))\n                {\n                    FILE* reach = fopen(getenv(\"BUSTER_RAW_REACH\"), \"a\");\n                    if (reach != NULL)\n                    {\n                        fprintf(reach, \"raw binding of the placeholder at token %u\\n\", token);\n                        fclose(reach);\n                    }\n                }\n")],
 "G03-no-deduced-alignas": [(II, "        else if (deduced != 0 && required != 0 && required - 1 < type_alignment_log2(types, deduced))", "        else if (false && deduced != 0 && required != 0 && required - 1 < type_alignment_log2(types, deduced))")],
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
              "                check_test_program_source(&test,\n" + program("auto-type") + "                \"auto-type\", clang);\n"
              "                check_test_program_source(&test,\n" + program("auto-type-alignment") + "                \"auto-type-alignment\", clang);\n"
              "                check_test_program_source(&test,\n" + program("auto-type-static-structures") + "                \"auto-type-static-structures\", clang); } else {\n" + old)
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
