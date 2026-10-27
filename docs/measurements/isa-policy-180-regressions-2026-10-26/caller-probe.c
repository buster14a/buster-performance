// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin.
// Short functional diagnostic of supplied metadata and NOP's template slots. No timing claim.
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#pragma clang diagnostic ignored "-Wunused-function"
#pragma clang diagnostic ignored "-Wunterminated-string-initialization"
#include "buster/compiler/x86_64_encoder.c"

int main(void)
{
    X86FormDescription* descriptions = malloc(sizeof(x86_form_descriptions));
    X86TemplateEntry* entries = malloc((BUSTER_X86_FORM_FIXUP + BUSTER_X86_FORM_TEMPLATES) * sizeof(*entries));
    bool passed = descriptions != 0 && entries != 0;
    if (passed)
    {
        memcpy(descriptions, x86_form_descriptions, sizeof(x86_form_descriptions));
        descriptions[X86_FORM_NOP].opcode = 0x91;
        passed = x86_build_nonlegacy_templates(X86_ENCODER_MODE_64, descriptions, entries);
        printf("ready=%d NOP slots=%02x,%02x duplicate-opcode=%02x fixup-opcode=%02x global-opcode=%02x\n",
               passed, (unsigned)entries[X86_FORM_NOP].template.bytes[0], (unsigned)entries[X86_FORM_NOP].template.bytes[1],
               (unsigned)entries[X86_FORM_NOP].bytes[1], (unsigned)entries[BUSTER_X86_FORM_FIXUP + X86_FORM_NOP].template.bytes[1],
               (unsigned)x86_form_descriptions[X86_FORM_NOP].opcode);
        passed &= entries[X86_FORM_NOP].template.bytes[1] == 0x91 && entries[X86_FORM_NOP].bytes[1] == 0x91;
        passed &= entries[BUSTER_X86_FORM_FIXUP + X86_FORM_NOP].template.bytes[1] == 0x91 && x86_form_descriptions[X86_FORM_NOP].opcode == 0x90;
    }
    free(entries);
    free(descriptions);
    return passed ? 0 : 1;
}
