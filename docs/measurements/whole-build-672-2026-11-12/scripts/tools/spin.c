// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md of buster14a/buster.
//
// spin SECONDS: a thread that computes for SECONDS and exits: the other process of busy.sh, which pins it to one of the
// CPUs the measured commands may run on.
#include <stdint.h>
#include <stdlib.h>
#include <time.h>

int main(int argc, char** argv)
{
    const double seconds = argc > 1 ? strtod(argv[1], 0) : 1.0;
    struct timespec start;
    struct timespec now;
    clock_gettime(CLOCK_MONOTONIC, &start);
    volatile uint64_t sink = 0;
    double elapsed = 0.0;
    while (elapsed < seconds)
    {
        for (uint32_t i = 0; i < 1000000; i += 1)
        {
            sink += i;
        }
        clock_gettime(CLOCK_MONOTONIC, &now);
        elapsed = (double)(now.tv_sec - start.tv_sec) + (double)(now.tv_nsec - start.tv_nsec) / 1e9;
    }
    return 0;
}
