// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
// Fast local diagnostic; fixture copied verbatim from the policy-owned test.
#include "buster/compiler/x86_64_encoder.c"

static bool x86_target_test_encode_templates(X86FormDescription* descriptions, X86TemplateEntry* templates)
{
    descriptions[X86_FORM_NOP].opcode = 0x91;
    bool passed = x86_build_nonlegacy_templates(X86_ENCODER_MODE_64, descriptions, templates);
    descriptions[X86_FORM_NOP].opcode = x86_form_descriptions[X86_FORM_NOP].opcode;
    X86Instruction instructions[33] = { 0 };
    for (uint32_t i = 0; i < BUSTER_ARRAY_LENGTH(instructions); i += 1)
    {
        instructions[i].form = X86_FORM_NOP | (i % 2 != 0 ? BUSTER_X86_FORM_FIXUP : 0);
    }
    uint32_t checks = 0;
    for (uint32_t count = 0; passed && count <= BUSTER_ARRAY_LENGTH(instructions); count += 1)
    {
        for (uint32_t options = 0; passed && options < 4; options += 1)
        {
            // Alternate private and ordinary tables to catch accidental home-table reads or retained caller state.
            for (uint32_t table = 0; passed && table < 2; table += 1)
            {
                uint8_t output[64 + BUSTER_X86_ENCODER_CAPACITY(33) + 64];
                uint32_t offsets[8 + 33 + 8];
                uint32_t fixups[8 + BUSTER_X86_ENCODER_FIXUP_CAPACITY(33) + 8];
                memset(output, 0xa5, sizeof(output));
                memset(offsets, 0xa5, sizeof(offsets));
                memset(fixups, 0xa5, sizeof(fixups));
                uint32_t* positions = (options & 1) != 0 ? offsets + 8 : 0;
                uint32_t* ends = (options & 2) != 0 ? fixups + 8 : 0;
                const int64_t length = table == 0 ? x86_encode_templates_16(instructions, count, output + 64, positions, ends, templates)
                                                  : x86_encode_16(instructions, count, output + 64, positions, ends);
                passed &= length == count;
                for (uint32_t i = 0; i < count; i += 1)
                {
                    passed &= output[64 + i] == (table == 0 ? 0x91 : 0x90);
                }
                for (size_t i = 0; i < sizeof(output); i += 1)
                {
                    if (i < 64 || i >= 64 + BUSTER_X86_ENCODER_CAPACITY(count))
                    {
                        passed &= output[i] == 0xa5;
                    }
                }
                for (uint32_t i = 0; i < BUSTER_ARRAY_LENGTH(offsets); i += 1)
                {
                    const uint32_t expected = positions != 0 && i >= 8 && i < 8 + count ? i - 8 : UINT32_C(0xa5a5a5a5);
                    passed &= offsets[i] == expected;
                }
                const uint32_t marked = count / 2;
                for (uint32_t i = 0; i < BUSTER_ARRAY_LENGTH(fixups); i += 1)
                {
                    if (ends != 0 && i >= 8 && i < 8 + marked)
                    {
                        passed &= fixups[i] == 2 * (i - 8) + 2;
                    }
                    else if (ends == 0 || i < 8 || i >= 8 + BUSTER_X86_ENCODER_FIXUP_CAPACITY(marked))
                    {
                        passed &= fixups[i] == UINT32_C(0xa5a5a5a5);
                    }
                }
                checks += 1;
            }
        }
    }
    passed &= checks == 272;
    printf("target caller-private encoding templates: %s (%u count/offset/fixup/table cases, guarded outputs)\n", passed ? "pass" : "FAIL", checks);
    return passed;
}

int main(void)
{
    const size_t extent = (BUSTER_X86_FORM_FIXUP + BUSTER_X86_FORM_TEMPLATES) * sizeof(X86TemplateEntry);
    X86TemplateEntry* templates = aligned_alloc(64, extent);
    X86FormDescription* descriptions = malloc(sizeof(x86_form_descriptions));
    bool passed = templates != 0 && descriptions != 0 && x86_encoder_initialize();
    if (passed)
    {
        memcpy(descriptions, x86_form_descriptions, sizeof(x86_form_descriptions));
        passed = x86_target_test_encode_templates(descriptions, templates);
    }
    free(descriptions);
    free(templates);
    return passed ? 0 : 1;
}
