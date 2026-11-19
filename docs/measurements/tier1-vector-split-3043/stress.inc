// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Same one-block input size for both shapes. Dense definitions alternate loads and copies.
static void split_measure_stress(Tier1WideTest* test)
{
    const uint32_t sizes[] = { 1024, 16384, 65536 };
    for (uint32_t shape = 0; shape < 2; shape++)
    {
        for (uint32_t s = 0; s < BUSTER_ARRAY_LENGTH(sizes); s++)
        {
            const uint32_t rows = sizes[s];
            const uint64_t mark = test->output.length;
            const uint32_t count = rows + 5;
            const IrSizes sizes_ir = { .instruction_count = count, .block_count = 1, .parameter_count = 2 };
            IrFunction f = { 0 };
            if (ir_create(&test->output, &sizes_ir, &f) != IR_OK) abort();
            f.parameter_types[0] = IR_PTR;
            f.parameter_types[1] = IR_I32;
            f.result_type = IR_I32;
            f.block_offsets[1] = count;
            for (uint32_t p = 0; p < 2; p++)
            {
                f.op[p] = IR_PARAM;
                f.type[p] = f.parameter_types[p];
                f.a[p] = p;
            }
            uint32_t scalar = 1;
            uint32_t vector = BUSTER_IR_NONE;
            for (uint32_t k = 0; k <= rows; k++)
            {
                const uint32_t i = k + 2;
                if (shape != 0 || k == rows / 2)
                {
                    const bool load = vector == BUSTER_IR_NONE || (k & 1) == 0;
                    f.type[i] = IR_V16I32;
                    f.op[i] = load ? IR_LOAD : IR_COPY;
                    f.a[i] = load ? 0 : vector;
                    vector = i;
                }
                else
                {
                    f.type[i] = IR_I32;
                    f.op[i] = IR_COPY;
                    f.a[i] = scalar;
                    scalar = i;
                }
            }
            f.op[count - 2] = IR_STORE;
            f.type[count - 2] = IR_VOID;
            f.a[count - 2] = 0;
            f.b[count - 2] = vector;
            f.op[count - 1] = IR_RET;
            f.type[count - 1] = IR_VOID;
            f.a[count - 1] = scalar;
            const IrDebugInfo debug = { .entry_count = count };
            if (!ir_debug_create(&test->output, &f, &debug)) abort();
            for (uint32_t i = 0; i < count; i++) f.debug->origins[i] = i;
            if (ir_verify(&f, &test->scratch, NULL).error != IR_OK) abort();
            for (uint32_t width = 16; width <= 32; width *= 2)
            {
                Arena scratch = arena_reserve(4u << 20);
                if (arena_push(&scratch, 13, 1) == NULL) abort();
                const uint64_t output_mark = test->output.length;
                const uint64_t scratch_mark = scratch.length;
                IrVectorSplitResult split = { 0 };
                IrCheck check = ir_vector_split(&f, width, &test->output, &scratch, &split);
                if (check.error != IR_OK || !split.split || split.wide != (shape != 0 ? rows + 1 : 1) || scratch.length != scratch_mark) abort();
                if (ir_verify(&split.function, &test->scratch, NULL).error != IR_OK) abort();
                const uint64_t out_end = test->output.length;
                printf("STRESS shape=%s scalar_control_rows=%u width=%u source=%u wide=%u output_rows=%u scratch_peak_above_mark=%" PRIu64 " output_above_mark=%" PRIu64 "\n",
                       shape != 0 ? "dense" : "sparse", rows, width, count, split.wide, split.function.instruction_count, scratch.peak - scratch_mark, out_end - output_mark);
                arena_pop_to(&test->output, output_mark);
                // Exercise both failure paths with nonzero marks and an arena exactly one byte short.
                const uint64_t capacity = scratch.capacity;
                scratch.capacity = scratch.peak - 1;
                check = ir_vector_split(&f, width, &test->output, &scratch, &split);
                if (check.error != IR_ERROR_MEMORY || split.split || split.function.op != NULL || scratch.length != scratch_mark || test->output.length != output_mark) abort();
                scratch.capacity = capacity;
                const uint64_t output_capacity = test->output.capacity;
                test->output.capacity = out_end - 1;
                check = ir_vector_split(&f, width, &test->output, &scratch, &split);
                if (check.error != IR_ERROR_MEMORY || split.split || split.function.op != NULL || scratch.length != scratch_mark || test->output.length != output_mark) abort();
                test->output.capacity = output_capacity;
                arena_release(&scratch);
            }
            arena_pop_to(&test->output, mark);
        }
    }
}
