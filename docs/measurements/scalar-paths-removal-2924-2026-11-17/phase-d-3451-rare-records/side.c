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
#ifdef SIDE_RARE
// The old side alone: how many of a call's records its scalar resolver took (x86_instruction_rare).
uint32_t SIDE_NAME(SIDE, _rare)(const void* records, uint64_t count, bool with_opmasks)
{
    const X86Instruction* instructions = records;
    uint32_t rare = 0;
    for (uint64_t i = 0; i < count; i += 1)
    {
        rare += x86_instruction_rare(&instructions[i], with_opmasks);
    }
    return rare;
}
#endif
