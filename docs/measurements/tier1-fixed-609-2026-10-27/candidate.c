// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Match baseline.c's translation-unit and call boundary; only the included allocator revision differs.
#include "buster/compiler/lane.c"
#include "buster/compiler/tier1_allocate.c"

__attribute__((noinline, aligned(64))) Tier1AllocationError candidate_allocate(const Tier1AllocationInput* input, Arena* arena, Tier1Allocation* result);
__attribute__((noinline, aligned(64))) Tier1AllocationError candidate_allocate(const Tier1AllocationInput* input, Arena* arena, Tier1Allocation* result)
{
    return tier1_allocate(input, arena, result);
}
