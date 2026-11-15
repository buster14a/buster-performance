// stores.c: what a record's stores cost on the host, by where they land. A record of the node machine's T is nine stores
// (4, 4, 1, 4, 4, 8, 8, 8 and 8 bytes); here the same nine values of each of N records are stored
//   columns: each to its own array (T's columns, staggered 128 bytes apart modulo 4 KB),
//   line:    all to one 64-byte line a record (nine stores to the one line),
//   wide:    as one 64-byte vector store a record (the values assembled in a register from two loads),
// for records taken one after another (step 1) and one in three (step 3, the leaves' spacing), and for K of the nine
// columns alone (K = 1..9). Times by the TSC and, where perf_event_open works, cycles and instructions.
//
//   clang -O3 -march=native -o stores stores.c && taskset -c 2 ./stores [records] [passes]
#define _GNU_SOURCE
#include <immintrin.h>
#include <inttypes.h>
#include <linux/perf_event.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/syscall.h>
#include <unistd.h>
#include <x86intrin.h>

#define MOST 4096u
#define STAGGER 128u

typedef struct Columns Columns;
struct Columns
{
    uint32_t types[MOST];
    uint8_t s0[STAGGER];
    uint32_t words[MOST];
    uint8_t s1[STAGGER];
    uint32_t flags[MOST];
    uint8_t s2[STAGGER];
    uint32_t objects[MOST];
    uint8_t s3[STAGGER];
    uint64_t payloads[MOST];
    uint8_t s4[STAGGER];
    uint8_t standings[MOST];
    uint8_t s5[STAGGER];
    uint64_t converted[MOST];
    uint8_t s6[STAGGER];
    uint64_t conversion_flags[MOST];
    uint8_t s7[STAGGER];
    uint64_t member_offsets[MOST];
};

typedef struct Line Line;
struct Line
{
    uint32_t type;
    uint32_t word;
    uint32_t flags;
    uint32_t object;
    uint64_t payload;
    uint8_t standing;
    uint8_t padding[7];
    uint64_t converted;
    uint64_t conversion_flags;
    uint64_t member_offset;
    uint64_t spare;
};

_Static_assert(sizeof(Line) == 64, "a record's line");

static int counter(uint64_t config)
{
    struct perf_event_attr attribute;
    memset(&attribute, 0, sizeof(attribute));
    attribute.type = PERF_TYPE_HARDWARE;
    attribute.size = sizeof(attribute);
    attribute.config = config;
    attribute.exclude_kernel = 1;
    attribute.exclude_hv = 1;
    return (int)syscall(SYS_perf_event_open, &attribute, 0, -1, -1, 0);
}

static uint64_t read_counter(int fd)
{
    uint64_t value = 0;
    if (fd < 0 || read(fd, &value, sizeof(value)) != (ssize_t)sizeof(value))
    {
        value = 0;
    }
    return value;
}

// The source of each record's values: 16 bytes a record (a declaration's line), read through a list of record numbers.
static __attribute__((noinline)) void columns_run(Columns* c, const uint64_t* lines, const uint32_t* list, uint32_t count, uint32_t fields)
{
    for (uint32_t i = 0; i < count; i += 1)
    {
        const uint32_t w = list[i];
        const uint64_t first = lines[2 * (uint64_t)i];
        const uint64_t second = lines[2 * (uint64_t)i + 1];
        c->types[w] = (uint32_t)first;
        if (fields > 1) c->words[w] = (uint32_t)(first >> 32);
        if (fields > 2) c->standings[w] = (uint8_t)second;
        if (fields > 3) c->flags[w] = (uint32_t)(second >> 8) & 0xffu;
        if (fields > 4) c->objects[w] = (uint32_t)(second >> 16);
        if (fields > 5) c->payloads[w] = second >> 48;
        if (fields > 6) c->converted[w] = (uint32_t)first;
        if (fields > 7) c->conversion_flags[w] = 0;
        if (fields > 8) c->member_offsets[w] = 0;
    }
}

static __attribute__((noinline)) void line_run(Line* records, const uint64_t* lines, const uint32_t* list, uint32_t count)
{
    for (uint32_t i = 0; i < count; i += 1)
    {
        Line* r = records + list[i];
        const uint64_t first = lines[2 * (uint64_t)i];
        const uint64_t second = lines[2 * (uint64_t)i + 1];
        r->type = (uint32_t)first;
        r->word = (uint32_t)(first >> 32);
        r->standing = (uint8_t)second;
        r->flags = (uint32_t)(second >> 8) & 0xffu;
        r->object = (uint32_t)(second >> 16);
        r->payload = second >> 48;
        r->converted = (uint32_t)first;
        r->conversion_flags = 0;
        r->member_offset = 0;
    }
}

// The record as its declaration's line holds it: 32 bytes copied, and its second half from the line's first four bytes.
static __attribute__((noinline)) void wide_run(Line* records, const uint64_t* wide_lines, const uint32_t* list, uint32_t count)
{
    for (uint32_t i = 0; i < count; i += 1)
    {
        Line* r = records + list[i];
        const __m256i low = _mm256_loadu_si256((const __m256i*)(const void*)(wide_lines + 4 * (uint64_t)i));
        const __m256i high = _mm256_zextsi128_si256(_mm_cvtsi32_si128((int)(uint32_t)wide_lines[4 * (uint64_t)i]));
        _mm512_storeu_si512(r, _mm512_inserti64x4(_mm512_castsi256_si512(low), high, 1));
    }
}

int main(int argc, char** argv)
{
    const uint32_t records = argc > 1 ? (uint32_t)strtoul(argv[1], NULL, 10) : 1024;
    const uint32_t passes = argc > 2 ? (uint32_t)strtoul(argv[2], NULL, 10) : 20000;
    Columns* c = aligned_alloc(4096, (sizeof(Columns) + 4095) & ~(size_t)4095);
    Line* lines_out = aligned_alloc(64, sizeof(Line) * MOST);
    uint64_t* lines = aligned_alloc(64, sizeof(uint64_t) * 4 * MOST);
    uint32_t* list = aligned_alloc(64, sizeof(uint32_t) * MOST);
    memset(c, 0, sizeof(Columns));
    memset(lines_out, 0, sizeof(Line) * MOST);
    for (uint32_t i = 0; i < 4 * MOST; i += 1)
    {
        lines[i] = (uint64_t)i * UINT64_C(0x9e3779b97f4a7c15);
    }
    const int cycles = counter(PERF_COUNT_HW_CPU_CYCLES);
    const int instructions = counter(PERF_COUNT_HW_INSTRUCTIONS);
    printf("stores: records=%u passes=%u counters=%s\n", records, passes, cycles >= 0 ? "yes" : "no");
    for (uint32_t step = 1; step <= 3; step += 2)
    {
        const uint32_t count = records / step < MOST / step ? records / step : MOST / step;
        for (uint32_t i = 0; i < count; i += 1)
        {
            list[i] = i * step;
        }
        for (uint32_t variant = 0; variant < 11; variant += 1)
        {
            uint64_t least[3] = { UINT64_MAX, UINT64_MAX, UINT64_MAX };
            for (uint32_t round = 0; round < 5; round += 1)
            {
                const uint64_t c0 = read_counter(cycles);
                const uint64_t i0 = read_counter(instructions);
                const uint64_t t0 = __rdtsc();
                for (uint32_t pass = 0; pass < passes; pass += 1)
                {
                    if (variant < 9)
                    {
                        columns_run(c, lines, list, count, variant + 1);
                    }
                    else if (variant == 9)
                    {
                        line_run(lines_out, lines, list, count);
                    }
                    else
                    {
                        wide_run(lines_out, lines, list, count);
                    }
                }
                const uint64_t t1 = __rdtsc();
                const uint64_t i1 = read_counter(instructions);
                const uint64_t c1 = read_counter(cycles);
                const uint64_t measured[3] = { c1 - c0, i1 - i0, t1 - t0 };
                for (uint32_t k = 0; k < 3; k += 1)
                {
                    least[k] = measured[k] < least[k] ? measured[k] : least[k];
                }
            }
            const double runs = (double)passes * (double)count;
            char name[32];
            if (variant < 9)
            {
                snprintf(name, sizeof(name), "columns=%u", variant + 1);
            }
            else
            {
                snprintf(name, sizeof(name), "%s", variant == 9 ? "line" : "wide");
            }
            printf("stores: step=%u %-10s cycles=%.2f instructions=%.2f ticks=%.2f a record\n", step, name, (double)least[0] / runs, (double)least[1] / runs, (double)least[2] / runs);
        }
    }
    return 0;
}
