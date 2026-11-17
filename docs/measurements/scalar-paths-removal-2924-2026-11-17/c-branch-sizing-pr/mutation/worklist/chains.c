#include "buster/compiler/host_isa.h"
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/mman.h>
#include "buster/compiler/lane.c"
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused-function"
#include "buster/compiler/x86_64_encoder.c"
#include "buster/compiler/branch_sizing.c"
#include "buster/compiler/branch_sizing_generate.c"
#pragma clang diagnostic pop
int main(void)
{
    static const uint32_t links_list[] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 20, 63, 64, 65, 100, 1000 };
    if (!x86_encoder_initialize()) return 1;
    uint64_t cap = BUSTER_BRANCH_SIZING_CHAIN_RECORDS(1000);
    X86Instruction* records = calloc(cap + 1, sizeof(*records));
    uint32_t* branches = calloc(1001, 4); uint32_t* targets = calloc(1001, 4); uint32_t* offsets = calloc(cap + 1, 4);
    for (uint32_t backward = 0; backward < 2; backward += 1)
    {
        for (uint32_t i = 0; i < sizeof(links_list) / sizeof(links_list[0]); i += 1)
        {
            uint64_t state = 1;
            const uint64_t count = branch_sizing_chain(&state, links_list[i], backward != 0, records, branches, targets);
            const BranchSizing r = size_branches(records, count, branches, targets, links_list[i], offsets);
            printf("%s links=%u rounds=%u evaluations=%llu\n", backward ? "backward" : "forward", links_list[i], r.rounds, (unsigned long long)r.evaluations);
        }
    }
    return 0;
}
