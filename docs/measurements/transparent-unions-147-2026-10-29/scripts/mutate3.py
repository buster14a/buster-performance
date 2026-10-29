import sys, os, shutil
base = "/home/david/.cache/claude-147/mutants3/tree"
root = "/home/david/.cache/claude-147/mutants3"
C = "src/buster/compiler/"
L = C + "c_check_program_lower.c"
mutants = {
 "T01-calls-as-unions": (L, "    return converted ? check_lower_transparent(writer, parameter) : !atomic && check_lower_aggregate(writer, conversion->type) ? check_lower_transparent(writer, conversion->type) : 0;",
                            "    (void)converted;\n    (void)atomic;\n    return 0;"),
 "T02-parameters-as-unions": (L, "abi->arguments[abi->argument_count++] = aggregate ? check_lower_passed_as(writer, parameter_type) : parameter_type;",
                                 "abi->arguments[abi->argument_count++] = parameter_type;"),
 "T03-va-arg-as-union": (L, "call->plan = abi_va_arg(writer->abi_table, types, aggregate ? check_lower_passed_as(writer, requested) : requested);",
                            "call->plan = abi_va_arg(writer->abi_table, types, requested);"),
 "T04-values-as-bytes": (L, "    return value && class >= BUSTER_TYPED_CLASS_I8 && class <= BUSTER_TYPED_CLASS_U64 ? class : UINT8_MAX;",
                            "    return value && class >= BUSTER_TYPED_CLASS_I8 && class <= BUSTER_TYPED_CLASS_U64 && false ? class : UINT8_MAX;"),
 "T05-no-convert": (L, "        if (member_class != first_class)\n", "        if (false && member_class != first_class)\n"),
 "T06-temporary-not-loaded": (L, "        if (first_class != UINT8_MAX)\n        {\n            check_lower_instruction(writer, BUSTER_TYPED_LOAD, first_class, 0);\n        }\n        check_lower_instruction(writer, BUSTER_TYPED_LOCAL_ADDRESS",
                                 "        check_lower_instruction(writer, BUSTER_TYPED_LOCAL_ADDRESS"),
 "T07-address-not-loaded": (L, "    else if (first_class != UINT8_MAX)\n    {\n        check_lower_instruction(writer, BUSTER_TYPED_LOAD, first_class, 0);\n    }\n    check_lower_operand(writer, node, operand, false, member);",
                               "    check_lower_operand(writer, node, operand, false, member);"),
 "T08-no-size-refusal": (L, "        if (feature == NULL && (table->stack_bytes[own] != table->stack_bytes[first]", "        if (false && feature == NULL && (table->stack_bytes[own] != table->stack_bytes[first]"),
 "T09-no-late-refusal": (L, "        else if (feature == NULL && first != own && ((table->pass[own] ^ table->pass[first]) & places) != 0", "        else if (false && feature == NULL && first != own && ((table->pass[own] ^ table->pass[first]) & places) != 0"),
 "T10-late-always": (L, "first != own && ((table->pass[own] ^ table->pass[first]) & places) != 0 &&", "first != own && (places | 1) != 0 &&"),
 "T11-atomic-transparent": (L, ": !atomic && check_lower_aggregate(writer, conversion->type) ?", ": (atomic || !atomic) && check_lower_aggregate(writer, conversion->type) ?"),
 "T12-conversions-ignored": (L, "    return converted ? check_lower_transparent(writer, parameter) :", "    return converted && false ? check_lower_transparent(writer, parameter) :"),
 "T13-passed-as-itself": (L, "    return first != 0 ? first : type;", "    return first != 0 && false ? first : type;"),
 "T14-bytes-class": (L, "= aggregate || wide ? BUSTER_TYPED_CLASS_U64 : member != 0 ? member_class : check_lower_value_class(writer, argument);",
                        "= wide || (aggregate && member == 0) ? BUSTER_TYPED_CLASS_U64 : member != 0 && !aggregate ? member_class : check_lower_value_class(writer, argument);"),
 "T15-aggregates-as-values": (L, "    const bool address = check_lower_aggregate(writer, member);", "    const bool address = false && check_lower_aggregate(writer, member);"),
 "T16-no-vector-object": (L, "        const bool object = check_lower_wide(writer, member) || check_lower_vector_of(writer, member) != 0;", "        const bool object = check_lower_wide(writer, member);"),
 "T17-late-after-last-body": (L, "graph->transparent_unions[tag] > program->bodies[0].opening;", "graph->transparent_unions[tag] > program->bodies[program->body_count - 1].opening;"),
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
