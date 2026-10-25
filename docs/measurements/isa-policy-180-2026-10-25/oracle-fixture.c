// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin.
// Original diagnostic harness for the strict GAS architecture oracle's positive syntax control. Build unchanged
// against the frozen candidate, then assemble its output with as --64 -march=znver5. Any diagnostic is a failure.
#include <stdio.h>
#include <stdint.h>
#include <stdbool.h>
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused-function"
#pragma clang diagnostic ignored "-Wmissing-field-initializers"
#include "buster/compiler/x86_64_encoder.c"
#include "buster/compiler/x86_64_encoder_test.c"
#include "buster/compiler/x86_target_forms.c"
#pragma clang diagnostic pop

int main(void)
{
    bool passed = x86_encoder_initialize();
    uint64_t random = 180;
    fputs(".intel_syntax noprefix\n.text\n", stdout);
    for (uint32_t form = 1; passed && form < X86_FORM_COUNT; form += 1)
    {
        if (x86_target_requirements[form] != 0)
        {
            X86Instruction instruction = x86_random_instruction(&random, (uint16_t)form, true);
            instruction.form = (uint16_t)form;
            if ((form == X86_FORM_LEA_R16_M || form == X86_FORM_LEA_R32_M || form == X86_FORM_LEA_R64_M) && instruction.mode == BUSTER_X86_MEMORY_ABSOLUTE)
            {
                instruction.mode = BUSTER_X86_MEMORY_RIP;
            }
            passed &= x86_validate(&instruction, 1) == 1;
            x86_print_instruction(stdout, &instruction, 0);
            fputc('\n', stdout);
        }
    }
    passed &= fflush(stdout) == 0 && !ferror(stdout);
    return passed ? 0 : 1;
}
