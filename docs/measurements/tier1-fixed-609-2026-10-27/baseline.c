// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Original wrapper around the unmodified allocator at the report's baseline source revision.
#include "buster/compiler/lane.c"
#include "buster/compiler/tier1_allocate.c"

__attribute__((noinline, aligned(64))) Tier1AllocationError baseline_allocate(const Tier1AllocationInput* input, Arena* arena, Tier1Allocation* result);
__attribute__((noinline, aligned(64))) Tier1AllocationError baseline_allocate(const Tier1AllocationInput* input, Arena* arena, Tier1Allocation* result)
{
    return tier1_allocate(input, arena, result);
}
