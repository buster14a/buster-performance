// #2924 gate (EXPERIMENT ONLY): dependency_rule by its vector and scalar classifier, alternating, rdtsc cycles per rule.
// Rules of 200 prerequisites whose paths are LENGTH bytes ('a'..'z' and '/'), for each length, and the real paths given
// on stdin (one a line). Median of 41 alternated samples of 200 rules each.
#define _GNU_SOURCE
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <x86intrin.h>
typedef struct String8 String8;
struct String8 { char* pointer; uint64_t length; };
#include "c_dependency.c"
static int cmp(const void* a, const void* b) { uint64_t x = *(const uint64_t*)a, y = *(const uint64_t*)b; return x < y ? -1 : x > y; }
static char out[1 << 22];
static void run(const char* label, DependencyFile* files, uint32_t n)
{
    enum { SAMPLES = 41, RULES = 200 };
    uint64_t t[2][SAMPLES];
    DependencyRule rule = { .source = { .pointer = "src/a.c", .length = 7 }, .object = { .pointer = "a.o", .length = 3 }, .files = files, .file_count = n, .include_system = true };
    uint64_t sizes[2] = {0, 0};
    for (uint32_t s = 0; s <= SAMPLES; s += 1)
    {
        for (uint32_t k = 0; k < 2; k += 1)
        {
            const uint32_t path = (s + k) & 1;
            rule.scalar = path == 1;
            const uint64_t start = __rdtsc();
            for (uint32_t r = 0; r < RULES; r += 1)
            {
                uint64_t written = 0;
                if (dependency_rule(&rule, out, sizeof(out), &written) != DEPENDENCY_OK) { fprintf(stderr, "fail\n"); exit(1); }
                sizes[path] = written;
            }
            const uint64_t end = __rdtsc();
            if (s != 0) t[path][s - 1] = end - start;
        }
    }
    qsort(t[0], SAMPLES, 8, cmp); qsort(t[1], SAMPLES, 8, cmp);
    printf("%-10s files %4u bytes %7lu  vector %10.1f  scalar %10.1f  scalar/vector %.3f%s\n", label, n, (unsigned long)sizes[0], t[0][SAMPLES / 2] / (double)RULES, t[1][SAMPLES / 2] / (double)RULES,
           (double)t[1][SAMPLES / 2] / t[0][SAMPLES / 2], sizes[0] == sizes[1] ? "" : " SIZE DIFFERS");
}
int main(void)
{
    static DependencyFile files[4096];
    static char text[1 << 20];
    const uint32_t lengths[] = {1, 2, 3, 4, 6, 8, 12, 16, 24, 32, 48, 64, 65, 96, 128};
    for (uint32_t l = 0; l < sizeof(lengths) / 4; l += 1)
    {
        for (uint32_t i = 0; i < 200; i += 1)
        {
            char* p = text + i * 256;
            for (uint32_t j = 0; j < lengths[l]; j += 1) p[j] = j % 7 == 6 ? '/' : (char)('a' + (i + j) % 26);
            files[i] = (DependencyFile){ .path = { .pointer = p, .length = lengths[l] }, .used = true };
        }
        char label[32]; snprintf(label, sizeof(label), "len %u", lengths[l]);
        run(label, files, 200);
    }
    uint32_t n = 0; size_t at = 0; char line[4096];
    while (n < 4096 && fgets(line, sizeof(line), stdin))
    {
        size_t len = strcspn(line, "\n");
        memcpy(text + at, line, len);
        files[n] = (DependencyFile){ .path = { .pointer = text + at, .length = len }, .used = true };
        at += len; n += 1;
    }
    if (n != 0) run("real", files, n);
    return 0;
}
