import sys, os, shutil, subprocess
base = "/home/david/.cache/claude-147/mutants/tree"
root = "/home/david/.cache/claude-147/mutants"
C = "src/buster/compiler/"
mutants = {
 "M01-no-call": (C+"c_check_program_lower.c", "        check_lower_cleanup(writer, control);\n", "        (void)check_lower_cleanup;\n"),
 "M02-no-reverse": (C+"c_check_program.c", "low + 1 < high; low += 1, high -= 1)", "false && low + 1 < high; low += 1, high -= 1)"),
 "M03-never-named": (C+"c_check_program.c", "&& !check_control_named(writer, jump);", "&& !(jump == UINT32_MAX && check_control_named(writer, jump));"),
 "M04-always-named": (C+"c_check_program.c", "&& !check_control_named(writer, jump);", "&& (jump == UINT32_MAX && !check_control_named(writer, jump));"),
 "M05-no-into": (C+"c_check_cleanup_input.c", "reader->vla_scope_ends[name] = valid ? cleanup.end : reader->vla_scope_ends[name];", "reader->vla_scope_ends[name] = valid ? reader->vla_scope_ends[name] : cleanup.end;"),
 "M06-no-indirect-exit": (C+"c_check_vla_input.c", "const bool leaves = innermost != NULL && (", "const bool leaves = innermost != NULL && false && ("),
 "M07-any-parameter": (C+"c_check_cleanup_input.c", "accepted = answer == TYPE_ANSWER_YES;", "accepted = answer == TYPE_ANSWER_YES || true;"),
 "M08-no-region": (C+"c_check_program.c", "check_control_cleanups(writer, source->block, BUSTER_CHECK_NONE, block);", "(void)block;"),
 "M09-no-for-end": (C+"c_check_program.c", "check_control_cleanups(writer, token, BUSTER_CHECK_NONE, scope);", "(void)scope;"),
 "M10-break-runs-for": (C+"c_check_program.c", "check_control_cleanups(writer, jump, check_control_loop(writer, jump, targets, label), BUSTER_CHECK_NONE);", "check_control_cleanups(writer, jump, BUSTER_CHECK_NONE + 0 * check_control_loop(writer, jump, targets, label), BUSTER_CHECK_NONE);"),
 "M11-no-register-copy": (C+"c_check_program_lower.c", "    if (hidden || registers)\n", "    if (hidden)\n"),
 "M12-no-region-copy": (C+"c_check_program_lower.c", "const bool copied = cleanups != 0 &&", "const bool copied = false && cleanups != 0 &&"),
 "M13-no-reference": (C+"c_check_program.c", "if (object != 0 && object < program->object_count && seen[object] != epoch)\n        {\n            seen[object] = epoch;\n            needed[object] = 1;\n            references[reference_count++] = (uint64_t)object << 32;\n        }\n    }\n    return reference_count;", "if (false && object != 0 && object < program->object_count && seen[object] != epoch)\n        {\n            seen[object] = epoch;\n            needed[object] = 1;\n            references[reference_count++] = (uint64_t)object << 32;\n        }\n    }\n    return reference_count;"),
 "M14-lane-merge": (C+"c_check_cleanup_input.c", "check_input_lane_refuse(reader, reader->lane, ", "check_input_lane_refuse(reader, false && reader->lane, "),
 "M15-objects-accepted": (C+"c_check_cleanup_input.c", "(kind != C_BINDING_FUNCTION || parameter_types == NULL)", "(kind == C_BINDING_TYPEDEF && parameter_types == NULL)"),
 "M16-parameter-count": (C+"c_check_cleanup_input.c", "(!prototype || parameters != 1)", "(!prototype || parameters == 0)"),
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
t = os.path.join(d, C + "c_checker_test.c")
s = open(t).read()
old = "            check_test_action_fixtures(&test, &types.table);\n"
assert s.count(old) == 1
s = s.replace(old, "            if (getenv(\"ONLY_CLEANUP\") != NULL) { check_test_cleanups(&test, clang); check_test_program_selection(&test, clang); } else {\n" + old)
old = "            check_test_corpus_symbol_reasons(&test, clang);\n"
assert s.count(old) == 1
s = s.replace(old, old + "            }\n")
open(t, "w").write(s)
print(d)
