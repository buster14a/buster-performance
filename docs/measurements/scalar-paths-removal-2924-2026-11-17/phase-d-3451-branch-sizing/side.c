// One size_branches, from the tree on the include path, behind exported wrappers named by SIDE.
#include "host_isa.h"
#include <stdint.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "buster/compiler/lane.c"
#include "buster/compiler/x86_64_encoder.c"
#include "buster/compiler/branch_sizing.c"
#include "buster/compiler/branch_sizing_generate.c"
#define SIDE_NAME2(a, b) a##b
#define SIDE_NAME(a, b) SIDE_NAME2(a, b)
bool SIDE_NAME(SIDE, _initialize)(void)
{
    return x86_encoder_initialize();
}
uint64_t SIDE_NAME(SIDE, _chain)(uint64_t* state, uint64_t links, bool backward, void* records, uint32_t* branches, uint32_t* targets)
{
    return branch_sizing_chain(state, links, backward, records, branches, targets);
}
// Returns the length; writes rounds, long branches and evaluations.
uint64_t SIDE_NAME(SIDE, _size)(void* records, uint64_t count, const uint32_t* branches, const uint32_t* targets, uint64_t branch_count, uint32_t* offsets, uint64_t* out)
{
    const BranchSizing r = size_branches(records, count, branches, targets, branch_count, offsets);
    out[0] = r.rounds;
    out[1] = r.long_branches;
    out[2] = r.evaluations;
    out[3] = r.error;
    return r.length;
}
