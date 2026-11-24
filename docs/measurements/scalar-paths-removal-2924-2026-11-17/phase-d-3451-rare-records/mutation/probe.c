#include "host_isa.h"
#include <stdint.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "buster/compiler/x86_64_encoder.c"
#include "buster/compiler/x86_semantics.c"
int main(void)
{
    if (!x86_semantics_initialize()) return 1;
    uint32_t vsib = 0, address_only = 0;
    for (uint32_t form = 0; form < X86_FORM_COUNT; form += 1)
    {
        const X86Effects* e = x86_effects(form);
        if (e->operation == X86_OPERATION_NONE || !(x86_form_description(form)->rm & BUSTER_X86_OPERAND_VSIB)) continue;
        vsib += 1;
        const uint32_t rm = x86_effects_role(e, BUSTER_X86_ROLE_RM);
        if ((e->memory & BUSTER_X86_MEMORY_EFFECT_ADDRESS) && !(rm & (BUSTER_X86_ROLE_READ | BUSTER_X86_ROLE_WRITE)))
        {
            address_only += 1;
            printf("address-only VSIB: %s\n", x86_form_description(form)->mnemonic);
        }
    }
    printf("covered VSIB forms %u, address-only %u\n", vsib, address_only);
    return 0;
}
