// One x86_target_forms, from the tree on the include path, behind an exported wrapper named by SIDE.
#include "host_isa.h"
#include <stdint.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "buster/compiler/x86_64_encoder.c"
#include "buster/compiler/x86_target_forms.c"
void SIDE(uint64_t features, uint8_t* allowed)
{
    const X86Target target = { .features = features };
    x86_target_forms(&target, allowed);
}
