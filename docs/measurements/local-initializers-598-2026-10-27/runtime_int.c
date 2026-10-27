// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Original #598 runtime sampler's signed-int oracle: the issue's unwrapped 1, 8, 15, ... values.
#define _POSIX_C_SOURCE 200809L
#include <dlfcn.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>

typedef unsigned (*Initializer)(unsigned);

static uint64_t now(void)
{
    struct timespec time;
    clock_gettime(CLOCK_MONOTONIC_RAW, &time);
    return (uint64_t)time.tv_sec * 1000000000 + time.tv_nsec;
}

static uint64_t run(Initializer function, unsigned iterations, uint64_t* checksum)
{
    uint64_t sum = 0;
    const uint64_t start = now();
    for (unsigned i = 0; i < iterations; i += 1)
    {
        sum += function(i);
    }
    const uint64_t elapsed = now() - start;
    *checksum = sum;
    return elapsed;
}

int main(int argc, char** argv)
{
    const unsigned size = argc == 5 ? (unsigned)strtoul(argv[4], NULL, 10) : 0;
    void* handles[2] = { NULL, NULL };
    Initializer functions[2] = { NULL, NULL };
    unsigned iterations[2] = { 1, 1 };
    int status = size < 2;
    for (unsigned p = 0; !status && p < 2; p += 1)
    {
        handles[p] = dlopen(argv[p + 1], RTLD_NOW | RTLD_LOCAL);
        functions[p] = handles[p] != NULL ? (Initializer)dlsym(handles[p], "initialized") : NULL;
        status = functions[p] == NULL;
        if (status)
        {
            fprintf(stderr, "runtime: %s\n", dlerror());
        }
        for (unsigned i = 0; !status && i < size; i += 1)
        {
            const unsigned expected = i * 7 + 1;
            status = functions[p](i) != expected;
            if (status)
            {
                fprintf(stderr, "runtime: variant=%u index=%u expected=%u\n", p, i, expected);
            }
        }
        if (!status)
        {
            printf("verified,%s,%s,%u,%u\n", p ? "head" : "base", argv[3], size, size);
        }
        uint64_t sum = 0;
        while (!status && run(functions[p], iterations[p], &sum) < 5000000 && iterations[p] < (1u << 26))
        {
            iterations[p] *= 2;
        }
    }
    for (unsigned round = 0; !status && round < 9; round += 1)
    {
        for (unsigned k = 0; k < 2; k += 1)
        {
            const unsigned p = k ^ (round & 1);
            uint64_t sum = 0;
            run(functions[p], iterations[p] / 8 + 1, &sum);
            const uint64_t ns = run(functions[p], iterations[p], &sum);
            printf("runtime,%s,%s,%u,%u,%u,%llu,%llu\n", p ? "head" : "base", argv[3], size, round,
                   iterations[p], (unsigned long long)ns, (unsigned long long)sum);
        }
    }
    for (unsigned p = 0; p < 2; p += 1)
    {
        if (handles[p] != NULL)
        {
            dlclose(handles[p]);
        }
    }
    return status;
}
