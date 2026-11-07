// masked_loads.c: the cost of an AVX-512 load masked to no lanes, by the state of the base page it addresses (buster#628).
// Each case maps its own 64 MB of anonymous memory in base pages (MADV_NOHUGEPAGE) and times 16,384 loads, one per
// page, with TSC ticks, after the pages are: written (present), read (the zero page mapped), or untouched (not present).
// It also times loads with every lane, at written pages, as the reference. Each case runs ROUNDS times and prints the
// median ticks per load.
#include <immintrin.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/mman.h>
#include <x86intrin.h>

#define PAGES 16384
#define PAGE 4096
#define ROUNDS 9

static uint8_t* map_pages(void)
{
    uint8_t* result = mmap(0, (size_t)PAGES * PAGE, PROT_READ | PROT_WRITE, MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
    if (result == MAP_FAILED || madvise(result, (size_t)PAGES * PAGE, MADV_NOHUGEPAGE) != 0)
    {
        perror("mmap");
        exit(1);
    }
    return result;
}

static double run(const uint8_t* base, uint64_t mask_value, uint64_t* sink)
{
    __mmask8 mask = (__mmask8)mask_value;
    __asm__ volatile("" : "+r"(mask));
    __m512i acc = _mm512_setzero_si512();
    _mm_lfence();
    const uint64_t start = __rdtsc();
    for (uint32_t page = 0; page < PAGES; page += 1)
    {
        acc = _mm512_or_si512(acc, _mm512_maskz_loadu_epi64(mask, base + (size_t)page * PAGE + 64));
    }
    _mm_lfence();
    const uint64_t end = __rdtsc();
    *sink += (uint64_t)_mm512_reduce_or_epi64(acc);
    return (double)(end - start) / PAGES;
}

static int compare(const void* a, const void* b)
{
    const double x = *(const double*)a;
    const double y = *(const double*)b;
    return (x > y) - (x < y);
}

int main(void)
{
    static const char* names[] = {"all lanes, written pages", "no lanes, written pages", "no lanes, read pages (zero page)", "no lanes, untouched pages"};
    uint64_t sink = 0;
    for (int c = 0; c < 4; c += 1)
    {
        double ticks[ROUNDS];
        for (int r = 0; r < ROUNDS; r += 1)
        {
            uint8_t* base = map_pages();
            volatile uint8_t* touch = base;
            for (uint32_t page = 0; c < 2 && page < PAGES; page += 1)
            {
                touch[(size_t)page * PAGE] = 1;
            }
            for (uint32_t page = 0; c == 2 && page < PAGES; page += 1)
            {
                sink += touch[(size_t)page * PAGE];
            }
            ticks[r] = run(base, c == 0 ? 0xff : 0, &sink);
            munmap(base, (size_t)PAGES * PAGE);
        }
        qsort(ticks, ROUNDS, sizeof(double), compare);
        printf("%-34s %8.1f TSC ticks a load (median of %d, min %.1f, max %.1f)\n", names[c], ticks[ROUNDS / 2], ROUNDS, ticks[0], ticks[ROUNDS - 1]);
    }
    printf("sink %llu\n", (unsigned long long)sink);
    return 0;
}
