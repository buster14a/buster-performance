// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Original review experiment; includes the pinned compiler's real scalar/vector helpers.
#define BUSTER_UNIT 99
#include "buster/compiler/main.c"
_Thread_local ThreadContext thread_context = { .lane = { .count = 1 } };
static volatile uint64_t review_sink;

static uint64_t review_clock(void)
{
    struct timespec now;
    clock_gettime(CLOCK_MONOTONIC, &now);
    return (uint64_t)now.tv_sec * UINT64_C(1000000000) + (uint64_t)now.tv_nsec;
}

static void review_warm(void)
{
    const uint64_t start = review_clock();
    uint64_t value = review_sink;
    do
    {
        for (uint32_t i = 0; i < 16384; i += 1)
        {
            value = value * UINT64_C(6364136223846793005) + UINT64_C(1442695040888963407);
        }
        review_sink = value;
    } while (review_clock() - start < UINT64_C(100000000));
}

// Controls for 256/4096-byte early-exit blocks and the preceding complete-range OR reduction.
static bool review_scan(const uint8_t* bytes, uint64_t size, uint32_t block, bool full)
{
    uint64_t at = 0;
    bool nonzero = false;
    __m512i combined = _mm512_setzero_si512();
    while ((full || !nonzero) && size - at >= 64)
    {
        if (!full)
        {
            combined = _mm512_setzero_si512();
        }
        const uint64_t through = size - at < block ? size : at + block;
        while (through - at >= 64)
        {
            combined = _mm512_or_si512(combined, _mm512_loadu_si512(bytes + at));
            at += 64;
        }
        nonzero |= _mm512_test_epi64_mask(combined, combined) != 0;
    }
    for (; (full || !nonzero) && at < size; at += 1)
    {
        nonzero |= bytes[at] != 0;
    }
    return nonzero;
}

// The original eight-pass project radix control, before reuse of c_bindings_sort's twins and varying digits.
static uint64_t* review_old_sort(uint64_t* input, uint64_t* output, uint32_t count)
{
    for (uint32_t shift = 0; shift < 64; shift += 8)
    {
        uint32_t counts[256] = { 0 };
        for (uint32_t i = 0; i < count; i += 1)
        {
            counts[(input[i] >> shift) & 255] += 1;
        }
        uint32_t total = 0;
        for (uint32_t bucket = 0; bucket < 256; bucket += 1)
        {
            const uint32_t size = counts[bucket];
            counts[bucket] = total;
            total += size;
        }
        for (uint32_t i = 0; i < count; i += 1)
        {
            const uint32_t bucket = (uint32_t)((input[i] >> shift) & 255);
            output[counts[bucket]++] = input[i];
        }
        uint64_t* swap = input;
        input = output;
        output = swap;
    }
    return input;
}

static uint64_t review_run(bool sorting, uint32_t variant, const uint8_t* bytes, uint64_t size,
                            const uint64_t* original, uint64_t* keys, uint64_t* temporary, uint32_t iterations)
{
    const uint64_t start = review_clock();
    for (uint32_t i = 0; i < iterations; i += 1)
    {
        __asm__ volatile("" : : "r"(bytes), "r"(keys) : "memory");
        if (sorting)
        {
            memcpy(keys, original, size * 8);
            const uint64_t* result = variant == 2 ? review_old_sort(keys, temporary, (uint32_t)size) :
                                     check_data_sort_boundaries(keys, temporary, (uint32_t)size, variant == 1);
            review_sink ^= result[size / 2];
        }
        else
        {
            const bool result = variant < 2 ? check_data_nonzero_bits(bytes, 0, size * 8, variant == 1) :
                                review_scan(bytes, size, variant == 2 ? 256 : 4096, variant == 4);
            review_sink += result;
        }
    }
    return review_clock() - start;
}

static void review_measure(bool sorting, uint32_t shape, uint32_t variant, const uint8_t* bytes, uint64_t size,
                            const uint64_t* original, uint64_t* keys, uint64_t* temporary, bool conditioned)
{
    uint32_t iterations = 1;
    while (review_run(sorting, variant, bytes, size, original, keys, temporary, iterations) < UINT64_C(1000000) && iterations < (1u << 20))
    {
        iterations *= 2;
    }
    for (uint32_t sample = 0; sample < 9; sample += 1)
    {
        if (conditioned)
        {
            review_warm();
        }
        const uint64_t elapsed = review_run(sorting, variant, bytes, size, original, keys, temporary, iterations);
        printf("%s,%u,%llu,%u,%u,%u,%.6f\n", sorting ? "sort" : "scan", shape, (unsigned long long)size, variant,
               sample, iterations, (double)elapsed / iterations);
    }
}

int main(int argc, char** argv)
{
    const char* mode = argc > 1 ? argv[1] : "all";
    const bool scan = strcmp(mode, "scan") == 0 || strcmp(mode, "all") == 0;
    const bool sort = strcmp(mode, "sort") == 0 || strcmp(mode, "all") == 0;
    const bool conditioned = argc > 2 && strcmp(argv[2], "conditioned") == 0;
    uint8_t* bytes = malloc(1u << 20);
    uint64_t* original = malloc(65536 * sizeof(uint64_t));
    uint64_t* keys = malloc(65536 * sizeof(uint64_t));
    uint64_t* temporary = malloc(65536 * sizeof(uint64_t));
    const bool ready = (scan || sort) && argc <= 3 && bytes != 0 && original != 0 && keys != 0 && temporary != 0;
    if (ready)
    {
        puts("kind,shape,size,variant,sample,iterations,ns_per_operation");
        const uint32_t scan_sizes[] = { 1024, 65536, 1u << 20 };
        for (uint32_t shape = 0; scan && shape < 4; shape += 1)
        {
            for (uint32_t s = 0; s < BUSTER_ARRAY_LENGTH(scan_sizes); s += 1)
            {
                const uint32_t size = scan_sizes[s];
                memset(bytes, 0, size);
                if (shape != 0)
                {
                    bytes[shape == 1 ? 0 : shape == 2 ? size - 1 : size / 3] = 1;
                }
                for (uint32_t variant = 0; variant < 5; variant += 1)
                {
                    review_measure(false, shape, variant, bytes, size, original, keys, temporary, conditioned);
                }
            }
        }
        const uint32_t sort_sizes[] = { 4, 16, 64, 256, 4096, 65536 };
        for (uint32_t shape = 0; sort && shape < 2; shape += 1)
        {
            for (uint32_t s = 0; s < BUSTER_ARRAY_LENGTH(sort_sizes); s += 1)
            {
                const uint32_t size = sort_sizes[s];
                for (uint32_t i = 0; i < size; i += 1)
                {
                    const uint64_t value = (uint64_t)i * UINT64_C(11400714819323198485);
                    original[i] = shape == 0 ? value & UINT32_MAX : value;
                }
                for (uint32_t variant = 0; variant < 3; variant += 1)
                {
                    review_measure(true, shape, variant, bytes, size, original, keys, temporary, conditioned);
                }
            }
        }
    }
    free(temporary);
    free(keys);
    free(original);
    free(bytes);
    return ready ? 0 : 2;
}
