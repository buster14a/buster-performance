// One frame planner, from the tree on the include path, behind a wrapper named SIDE.
#include "host_isa.h"
#include <stdint.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <assert.h>
#include <inttypes.h>
typedef struct String8 String8;
struct String8
{
    char* pointer;
    uint64_t length;
};
#include "buster/compiler/lane.c"
#include "buster/compiler/c_types.c"
#include "buster/compiler/calling_convention.c"
#include "buster/compiler/tier1_frame.c"
static Arena side_output;
static Arena side_scratch;
// Returns the slot count, or UINT32_MAX on refusal; *slots and *offsets the plan's columns until the next call.
uint32_t SIDE(const uint32_t* header, const uint32_t* start, const uint32_t* end, const uint32_t* size, const uint32_t* alignment, const uint32_t* indices,
    const void* calls, const uint32_t** slots, const int32_t** offsets)
{
    if (side_output.base == 0)
    {
        side_output = arena_reserve(1u << 28);
        side_scratch = arena_reserve(1u << 28);
    }
    arena_pop_to(&side_output, 0);
    arena_pop_to(&side_scratch, 0);
    const Tier1FrameRequest request = {
        .slots = { .start = start, .end = end, .size = size, .alignment = alignment, .indices = indices, .count = header[0], .column_count = header[1] },
        .calls = (const AbiCall*)calls,
        .call_count = header[3],
        .used_callee_saved = header[4],
        .flags = header[5],
    };
    Tier1Frame frame;
    const Tier1FrameError error = tier1_frame_plan(&request, &side_output, &side_scratch, &frame);
    *slots = frame.slot;
    *offsets = frame.offset;
    return error == TIER1_FRAME_OK ? frame.slot_count : UINT32_MAX;
}
