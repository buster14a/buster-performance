#include "host_isa.h"
#include <stdint.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "buster/compiler/x86_64_encoder.c"
#include "buster/compiler/x86_target_forms.c"
int main(void)
{
    uint32_t blocks = 0, ext_blocks = 0, ext = 0, runs = 0; int last = -2;
    for (uint32_t i = 0; i < X86_FORM_COUNT; i += 16)
    {
        uint32_t n = 0;
        for (uint32_t j = i; j < i + 16 && j < X86_FORM_COUNT; j += 1) n += (x86_target_compact_requirements[j] & BUSTER_X86_TARGET_COMPACT_EXTENDED) != 0;
        blocks += 1; ext_blocks += n != 0; ext += n;
    }
    for (uint32_t j = 0; j < X86_FORM_COUNT; j += 1) { bool e = (x86_target_compact_requirements[j] & BUSTER_X86_TARGET_COMPACT_EXTENDED) != 0; if (e && last != (int)j - 1) runs += 1; if (e) last = j; }
    printf("forms %u blocks %u with extended %u, extended %u in %u runs\n", X86_FORM_COUNT, blocks, ext_blocks, ext, runs);
    return 0;
}
