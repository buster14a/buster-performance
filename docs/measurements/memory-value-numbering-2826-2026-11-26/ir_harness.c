// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin.
// Correctness replay harness for buster issue #2826. No timing claims.
#include <stdint.h>
#include <inttypes.h>
#include <stdbool.h>
#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include <limits.h>
#include <assert.h>
#include <errno.h>
#include <stdarg.h>
#define BUSTER_ARRAY_LENGTH(x) (sizeof(x) / sizeof((x)[0]))
#define BUSTER_COMPILE_TIME_STRING_LENGTH(strlit) (BUSTER_ARRAY_LENGTH(strlit) - 1)
#define BUSTER_S8_INIT(strlit) {.pointer = (char*)(strlit), .length = BUSTER_COMPILE_TIME_STRING_LENGTH(strlit)}
#define BUSTER_S8(strlit) ((String8)BUSTER_S8_INIT(strlit))
#include "host_isa.h"
#include "string8.h"
#include "host_math.h"
#include "lane.c"
#define BUSTER_UNIT_BACKEND 8
#define BUSTER_IN_UNIT(unit) 1
#include "x86_64_encoder.c"
#include "x86_zen5.c"
#include "x86_target.c"
#include "x86_target_forms.c"
#include "link.c"
#include "x86_semantics.c"
#include "c_types.c"
#include "calling_convention.c"
#include "tier0.c"
#include "dataflow.c"
#include "dominators.c"
#include "ssa.c"
#include "ir.c"
#include "ir_simd_typed.c"
// ir_lower.c normally provides this default; lowering is not part of this harness.
#define BUSTER_TIER1_PRIVATE_VALUES 0
#include "ssa_ir.c"
#include "ir_validate.c"
#include "interpreter.c"
#include "interpreter_native.c"
#include "interpreter_typed_abi.c"
#include "ir_parse.c"
#include "ir_interpreter.c"
#include "ir_test.c"
#include "ir_parse_test.c"
#include "ir_dataflow.c"
#ifndef BUSTER_VALIDATION_OPTIMIZER
#define BUSTER_VALIDATION_OPTIMIZER "ir_optimize.c"
#endif
#include BUSTER_VALIDATION_OPTIMIZER
#include "ir_rebuild.c"
#include "tier1_schedule_ir.c"
#include "ir_optimize_test.c"
#include "ir_optimize_gvn.c"
#include "ir_optimize_licm.c"
#include "ir_optimize_unroll.c"
#include "ir_optimize_sroa.c"
#include "ir_optimize_text_test.c"

int main(int argc, char** argv)
{
    int result = 2;
    if (argc >= 2 && strcmp(argv[1], "test-ir-optimize") == 0)
    {
        result = run_ir_optimize_tests(argc - 1, argv + 1);
    }
    else if (argc >= 2 && strcmp(argv[1], "test-ir-parse") == 0)
    {
        result = run_ir_parse_tests(argc - 2, argv + 2);
    }
    else if (argc == 2 && strcmp(argv[1], "test-memory-scopes") == 0)
    {
        IrOptimizeTest test = { .random = BUSTER_IR_OPTIMIZE_TEST_SEED };
        Arena input = arena_reserve(1ull << 24);
        Arena output = arena_reserve(1ull << 24);
        Arena scratch = arena_reserve(1ull << 26);
        char* text = malloc(1u << 16);
        const bool ready = input.base != NULL && output.base != NULL && scratch.base != NULL && text != NULL;
        ir_optimize_test_expect(&test, ready, "scope harness arenas");
        if (ready)
        {
            ir_memory_test_scopes(&test, &input, &output, &scratch, text, 1u << 16);
        }
        printf("memory scopes: %" PRIu64 " checks, %" PRIu64 " failures\n", test.checks, test.failures);
        free(text);
        arena_release(&scratch);
        arena_release(&output);
        arena_release(&input);
        result = test.failures == 0 ? 0 : 1;
    }
    return result;
}
