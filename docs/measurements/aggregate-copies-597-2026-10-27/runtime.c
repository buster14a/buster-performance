// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Original #597 guard-page validation and generated-code runtime harness.
#define _GNU_SOURCE
#include <inttypes.h>
#include <stddef.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/mman.h>
#include <time.h>
#include <unistd.h>

struct S
{
    unsigned char bytes[N];
};
extern void copy(struct S* d, const struct S* s);
extern unsigned char kept(struct S* d, const struct S* s);
extern void same(struct S* d);

static uint64_t now(void)
{
    struct timespec time;
    clock_gettime(CLOCK_MONOTONIC_RAW, &time);
    return (uint64_t)time.tv_sec * UINT64_C(1000000000) + (uint64_t)time.tv_nsec;
}

int main(void)
{
    const size_t page = (size_t)sysconf(_SC_PAGESIZE);
    const size_t rounded = ((N + 64 + page - 1) / page) * page;
    const size_t span = rounded + page * 2;
    unsigned char* mappings[2] = { NULL, NULL };
    struct S* objects[2] = { NULL, NULL };
    int valid = 1;
    for (unsigned i = 0; i < 2 && valid; i += 1)
    {
        mappings[i] = mmap(NULL, span, PROT_NONE, MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
        valid = mappings[i] != MAP_FAILED && mprotect(mappings[i] + page, rounded, PROT_READ | PROT_WRITE) == 0;
        if (valid)
        {
            objects[i] = (struct S*)(mappings[i] + page + rounded - N);
            memset((unsigned char*)objects[i] - 64, 0xa5, 64);
        }
    }
    for (unsigned round = 0; round < 11 && valid; round += 1)
    {
        for (size_t i = 0; i < N; i += 1)
        {
            objects[0]->bytes[i] = (unsigned char)(i * 37 + round * 13);
            objects[1]->bytes[i] = (unsigned char)~objects[0]->bytes[i];
        }
        copy(objects[1], objects[0]);
        valid = memcmp(objects[0], objects[1], N) == 0;
        memset(objects[1], 0x5a, N);
        valid = kept(objects[1], objects[0]) == objects[0]->bytes[N - 1] && valid;
        same(objects[1]);
        copy(objects[1], objects[1]);
        valid = kept(objects[1], objects[1]) == objects[1]->bytes[N - 1] && memcmp(objects[0], objects[1], N) == 0 && valid;
        for (unsigned k = 0; k < 2; k += 1)
        {
            for (size_t i = 1; i <= 64; i += 1)
            {
                valid = ((unsigned char*)objects[k])[-(ptrdiff_t)i] == 0xa5 && valid;
            }
        }
    }
    printf("guard size=%u valid=%d\n", N, valid);
    for (unsigned mode = 0; mode < 3 && valid; mode += 1)
    {
        uint64_t iterations = 1024;
        for (unsigned sample = 0; sample < 8; sample += 1)
        {
            const uint64_t begin = now();
            for (uint64_t i = 0; i < iterations; i += 1)
            {
                if (mode == 0)
                {
                    copy(objects[1], objects[0]);
                }
                else if (mode == 1)
                {
                    kept(objects[1], objects[0]);
                }
                else
                {
                    same(objects[1]);
                }
            }
            const uint64_t elapsed = now() - begin;
            if (elapsed < UINT64_C(10000000))
            {
                iterations *= 2;
                sample -= 1;
            }
            else
            {
                printf("runtime size=%u mode=%u sample=%u iterations=%" PRIu64 " ns_per_call=%.3f\n", N, mode, sample, iterations,
                       (double)elapsed / (double)iterations);
            }
        }
    }
    for (unsigned i = 0; i < 2; i += 1)
    {
        if (mappings[i] != NULL && mappings[i] != MAP_FAILED)
        {
            munmap(mappings[i], span);
        }
    }
    return valid ? 0 : 1;
}
