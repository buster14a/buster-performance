// One effects implementation, from the tree on the include path, behind exported wrappers named by SIDE.
#include "host_isa.h"
#include <stdint.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "buster/compiler/x86_64_encoder.c"
#include "buster/compiler/x86_semantics.c"
#define SIDE_NAME2(a, b) a##b
#define SIDE_NAME(a, b) SIDE_NAME2(a, b)
bool SIDE_NAME(SIDE, _initialize)(void)
{
    return x86_semantics_initialize();
}
void SIDE_NAME(SIDE, _effects)(const void* records, uint64_t count, uint64_t* reads, uint64_t* writes, uint16_t* opmasks)
{
    if (opmasks != 0)
    {
        x86_instructions_effects_opmasks(records, count, reads, writes, opmasks);
    }
    else
    {
        x86_instructions_effects(records, count, reads, writes);
    }
}
