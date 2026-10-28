// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md in the pinned compiler source.
//
// Preserve every timed sample before benchmark-foreign sorts it for the median. qsort is called only after the
// resolution loop's clock stops; no logging enters a timed interval. Use without --linkers (whose samples are double).
// The benchmark/source path, input generation, warm-up and clock boundaries otherwise remain the pinned originals.

#include <stddef.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>

static __attribute__((noinline)) void foreign_cost_qsort(void* values, size_t count, size_t bytes, int (*compare)(const void*, const void*))
{
    static uint64_t group = 0;
    if (bytes == sizeof(uint64_t))
    {
        const uint64_t* samples = values;
        for (size_t i = 0; i < count; i += 1)
        {
            fprintf(stderr, "RAW,%llu,%zu,%zu,%llu\n", (unsigned long long)group, count, i, (unsigned long long)samples[i]);
        }
        group += 1;
    }
    qsort(values, count, bytes, compare);
}

#define qsort foreign_cost_qsort
#include "buster/compiler/foreign_benchmark.c"
#undef qsort

int main(int argc, char** argv)
{
    return run_foreign_benchmark(argc, argv);
}
