# Applies #456's attribution switches to a copy of the tree: BUSTER_456_VARIANT bits, read by the benchmark after its
# setup and applied only to the emission with raw rows. 1: no per-function rows; 2: no Tier 0 entry records; 4: the
# plain lowering; 8: no rows' room. Not for commit.
import sys, re
root = sys.argv[1]
emit = root + "/src/buster/compiler/c_check_program_emit.c"
text = open(emit).read()
def sub(old, new):
    global text
    assert text.count(old) == 1, old
    text = text.replace(old, new)
sub("typedef struct CheckProgramBinding CheckProgramBinding;", "static uint32_t check_program_emit_experiment;\ntypedef struct CheckProgramBinding CheckProgramBinding;")
sub("valid = rows != NULL ? check_program_lower_sources(", "valid = rows != NULL && (check_program_emit_experiment & 4) == 0 ? check_program_lower_sources(")
sub("result->lowered.functions[b].entry_records = rows != NULL;", "result->lowered.functions[b].entry_records = rows != NULL && (check_program_emit_experiment & 2) == 0;")
sub("if (valid && rows != NULL)\n    {\n        valid = check_program_emit_reserve_rows(", "if (valid && rows != NULL && (check_program_emit_experiment & 8) == 0)\n    {\n        valid = check_program_emit_reserve_rows(")
sub("if (valid && source_body && rows != NULL)\n", "if (valid && source_body && rows != NULL && (check_program_emit_experiment & 1) == 0)\n")
open(emit, "w").write(text)
bench = root + "/src/buster/compiler/c_check_debug_benchmark.c"
text = open(bench).read()
sub("        uint64_t* samples = malloc((uint64_t)runs * 2 * sizeof(uint64_t));\n", "        uint64_t* samples = malloc((uint64_t)runs * 2 * sizeof(uint64_t));\n        const char* variant = getenv(\"BUSTER_456_VARIANT\");\n        check_program_emit_experiment = variant != 0 ? (uint32_t)strtoul(variant, 0, 0) : 0;\n        printf(\"  experiment variant %u\\n\", check_program_emit_experiment);\n")
open(bench, "w").write(text)
