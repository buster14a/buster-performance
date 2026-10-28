// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Exact region helper extracted from the identified source revision; original minimal bounded-work adapter.
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#define BUSTER_CHECK_NONE UINT32_MAX
typedef struct { uint32_t opening; uint32_t closing; } CheckInputRegion;
typedef struct { struct { bool scalar; } options; struct { uint32_t count; } tokens; struct { uint32_t* parents; } tree; uint32_t* sizes; } Parser;
typedef struct { uint32_t region_count; uint32_t* expression_regions; CheckInputRegion* regions; } CheckInput;
typedef struct { const Parser* parser; CheckInput* output; uint32_t* postorder_positions; } CheckInputReader;
#ifdef BUSTER_REGION_BASE
#include "base-region.c"
#else
#include "head-region.c"
#endif
static __attribute__((noinline)) bool transfer(const CheckInputReader* reader, uint32_t source, uint32_t target)
{
    return check_input_region_transfer(reader, source, target);
}
int main(void)
{
    enum { COUNT = 65536 };
    uint32_t* parents = malloc(COUNT * sizeof(uint32_t));
    uint32_t* order = malloc(COUNT * sizeof(uint32_t));
    uint32_t* sizes = malloc(COUNT * sizeof(uint32_t));
    uint32_t* selected = calloc(COUNT, sizeof(uint32_t));
    int result = 1;
    if (parents != 0 && order != 0 && sizes != 0 && selected != 0)
    {
        for (uint32_t i = 0; i < COUNT; i += 1)
        {
            parents[i] = i + 1;
            order[i] = i;
            sizes[i] = i + 1;
        }
        CheckInputRegion region = { .opening = 0, .closing = COUNT - 1 };
        Parser parser = { .tokens = { .count = COUNT }, .tree = { .parents = parents }, .sizes = sizes };
        CheckInput output = { .expression_regions = selected, .regions = &region };
        const CheckInputReader reader = { .parser = &parser, .output = &output, .postorder_positions = order };
        result = 0;
        for (uint32_t variant = 0; variant < 2; variant += 1)
        {
            output.region_count = variant;
            selected[COUNT - 1] = variant;
            struct timespec start = { 0 }, end = { 0 };
            clock_gettime(CLOCK_PROCESS_CPUTIME_ID, &start);
            uint32_t accepted = 0;
            for (uint32_t target = 1; target + 2 < COUNT; target += 1)
            {
                accepted += transfer(&reader, target + 1, target);
            }
            clock_gettime(CLOCK_PROCESS_CPUTIME_ID, &end);
            const int64_t ns = ((int64_t)end.tv_sec - start.tv_sec) * INT64_C(1000000000) + end.tv_nsec - start.tv_nsec;
            printf("regions=%u accepted=%u cpu_ns=%lld\n", variant, accepted, (long long)ns);
            result |= accepted != COUNT - 3 || ns >= INT64_C(1000000000);
        }
    }
    free(selected);
    free(sizes);
    free(order);
    free(parents);
    return result;
}
