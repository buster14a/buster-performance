// micro.c: divisions by constants on the 9700X (#141), as each compiler's code divides: dependent chains, each division
// waiting for the one before (its latency), and independent ones over an array (their throughput). Each kernel's best of
// 7 trials, in nanoseconds per division, then a checksum of every result, which keeps each compiler's work.
#include <stdint.h>
#include <stdio.h>
#include <time.h>

#define ELEMENTS 4096u
#define CHAIN 1048576u
#define PASSES 256u
#define TRIALS 7u

static uint64_t nanoseconds(void)
{
    struct timespec t;
    clock_gettime(CLOCK_MONOTONIC, &t);
    return (uint64_t)t.tv_sec * 1000000000u + (uint64_t)t.tv_nsec;
}

uint64_t chain_udiv64(uint64_t x, uint32_t n)
{
    for (uint32_t i = 0; i < n; i += 1)
    {
        x = x / 10 + UINT64_C(0x9e3779b97f4a7c15);
    }
    return x;
}

uint32_t chain_sdiv32(uint32_t x, uint32_t n)
{
    int32_t v = (int32_t)x;
    for (uint32_t i = 0; i < n; i += 1)
    {
        v = v / 7 - 0x12345678;
    }
    return (uint32_t)v;
}

uint64_t chain_srem64(uint64_t x, uint32_t n)
{
    int64_t v = (int64_t)x;
    for (uint32_t i = 0; i < n; i += 1)
    {
        v = (int64_t)((uint64_t)(v % 1000003) * UINT64_C(6364136223846793005) + UINT64_C(1442695040888963407));
    }
    return (uint64_t)v;
}

uint64_t stream_urem32(const uint32_t* a, uint32_t n)
{
    uint64_t s = 0;
    for (uint32_t i = 0; i < n; i += 1)
    {
        s += a[i] % 10;
    }
    return s;
}

int64_t stream_sdiv64(const int64_t* a, uint32_t n)
{
    int64_t s = 0;
    for (uint32_t i = 0; i < n; i += 1)
    {
        s += a[i] / 1000;
    }
    return s;
}

static uint32_t words[ELEMENTS];
static int64_t values[ELEMENTS];

int main(void)
{
    uint64_t state = UINT64_C(0x2545f4914f6cdd1d);
    for (uint32_t i = 0; i < ELEMENTS; i += 1)
    {
        state = state * UINT64_C(6364136223846793005) + 1;
        words[i] = (uint32_t)(state >> 32);
        values[i] = (int64_t)state;
    }
    uint64_t checksum = 0;
    const char* names[5] = { "chain_udiv64", "chain_sdiv32", "chain_srem64", "stream_urem32", "stream_sdiv64" };
    for (uint32_t kernel = 0; kernel < 5; kernel += 1)
    {
        uint64_t best = UINT64_MAX;
        for (uint32_t trial = 0; trial < TRIALS; trial += 1)
        {
            const uint64_t start = nanoseconds();
            if (kernel == 0)
            {
                checksum += chain_udiv64(state + trial, CHAIN);
            }
            else if (kernel == 1)
            {
                checksum += chain_sdiv32((uint32_t)state + trial, CHAIN);
            }
            else if (kernel == 2)
            {
                checksum += chain_srem64(state + trial, CHAIN);
            }
            else
            {
                for (uint32_t pass = 0; pass < PASSES; pass += 1)
                {
                    checksum += kernel == 3 ? stream_urem32(words, ELEMENTS) : (uint64_t)stream_sdiv64(values, ELEMENTS);
                }
            }
            const uint64_t elapsed = nanoseconds() - start;
            best = elapsed < best ? elapsed : best;
        }
        const uint64_t divisions = kernel < 3 ? CHAIN : (uint64_t)PASSES * ELEMENTS;
        printf("%s %llu.%03llu ns\n", names[kernel], (unsigned long long)(best / divisions), (unsigned long long)(best * 1000 / divisions % 1000));
    }
    printf("checksum %016llx\n", (unsigned long long)checksum);
    return 0;
}
