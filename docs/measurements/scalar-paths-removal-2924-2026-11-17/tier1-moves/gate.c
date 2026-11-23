// Gate for #3450's moves: main's tier1_resolve_moves (old: the scalar scan to 8, the indexed path beyond) against the
// branch's (new: the register form to 16, the wide form beyond), one executable, rdtsc a call, by count.
//   gate replay FILE     every dumped real set once a pass, in order, 21 passes alternating which side goes first
//   gate synth           per count: 256 distinct random sets (fan-out and cycles) once a pass, 21 passes
#include <stdint.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <x86intrin.h>
uint32_t old_side(const uint32_t*, const uint32_t*, uint32_t, uint32_t, uint32_t**, uint32_t**);
uint32_t new_side(const uint32_t*, const uint32_t*, uint32_t, uint32_t, uint32_t**, uint32_t**);
typedef struct { uint32_t count; uint32_t scratch; uint32_t* s; uint32_t* d; } Set;
#define PASSES 21
static int cmp(const void* a, const void* b) { double x = *(const double*)a, y = *(const double*)b; return x < y ? -1 : x > y; }
static uint64_t mismatches;
static void check(const Set* set)
{
    uint32_t *os, *od, *ns, *nd;
    const uint32_t a = old_side(set->s, set->d, set->count, set->scratch, &os, &od);
    uint32_t* keep = malloc((uint64_t)(a == UINT32_MAX ? 0 : a) * 8 + 8);
    if (a != UINT32_MAX) { memcpy(keep, os, a * 4ull); memcpy(keep + a, od, a * 4ull); }
    const uint32_t b = new_side(set->s, set->d, set->count, set->scratch, &ns, &nd);
    mismatches += a != b || (a != UINT32_MAX && (memcmp(keep, ns, a * 4ull) != 0 || memcmp(keep + a, nd, a * 4ull) != 0));
    free(keep);
}
// Median ticks a call of each side over `sets`.
static void time_sets(const Set* sets, uint32_t n, double* old_ticks, double* new_ticks, uint32_t repeat)
{
    double samples[2][PASSES];
    for (uint32_t pass = 0; pass < PASSES; pass += 1)
    {
        for (uint32_t order = 0; order < 2; order += 1)
        {
            const uint32_t side = order ^ (pass & 1);
            uint64_t total = 0;
            for (uint32_t r = 0; r < repeat; r += 1)
            {
                for (uint32_t i = 0; i < n; i += 1)
                {
                    uint32_t *x, *y;
                    const uint64_t before = __rdtsc();
                    const uint32_t c = side == 0 ? old_side(sets[i].s, sets[i].d, sets[i].count, sets[i].scratch, &x, &y) : new_side(sets[i].s, sets[i].d, sets[i].count, sets[i].scratch, &x, &y);
                    total += __rdtsc() - before;
                    __asm__ volatile("" : : "r"(c), "r"(x) : "memory");
                }
            }
            samples[side][pass] = (double)total / ((double)n * repeat);
        }
    }
    qsort(samples[0], PASSES, sizeof(double), cmp);
    qsort(samples[1], PASSES, sizeof(double), cmp);
    *old_ticks = samples[0][PASSES / 2];
    *new_ticks = samples[1][PASSES / 2];
}
static uint64_t state = 3450;
static uint32_t rnd(void) { state ^= state << 13; state ^= state >> 7; state ^= state << 17; return (uint32_t)(state >> 16); }
int main(int argc, char** argv)
{
    if (argc == 3 && strcmp(argv[1], "replay") == 0)
    {
        FILE* f = fopen(argv[2], "rb");
        if (!f) return 1;
        fseek(f, 0, SEEK_END); long bytes = ftell(f); fseek(f, 0, SEEK_SET);
        uint32_t* words = malloc(bytes + 8);
        if (fread(words, 1, bytes, f) != (size_t)bytes) return 1;
        fclose(f);
        uint64_t length = bytes / 4, at = 0; uint32_t n = 0;
        Set* sets = malloc(sizeof(Set) * (length / 2 + 1));
        while (at + 2 <= length) { Set s = { words[at], words[at + 1], words + at + 2, words + at + 2 + words[at] }; at += 2 + 2ull * s.count; sets[n++] = s; }
        for (uint32_t i = 0; i < n; i += 1) check(&sets[i]);
        // By count: each count's sets, in their order.
        uint32_t maximum = 0;
        for (uint32_t i = 0; i < n; i += 1) maximum = sets[i].count > maximum ? sets[i].count : maximum;
        printf("replay file=%s sets=%u mismatches=%llu\n", argv[2], n, (unsigned long long)mismatches);
        Set* group = malloc(sizeof(Set) * n);
        double all_old = 0, all_new = 0;
        for (uint32_t c = 0; c <= maximum; c += 1)
        {
            uint32_t k = 0;
            for (uint32_t i = 0; i < n; i += 1) if (sets[i].count == c) group[k++] = sets[i];
            if (k == 0) continue;
            double o, w;
            time_sets(group, k, &o, &w, k < 64 ? 64 / k + 1 : 1);
            all_old += o * k; all_new += w * k;
            printf("  count=%u sets=%u old_ticks=%.1f new_ticks=%.1f new/old=%.3f\n", c, k, o, w, w / o);
        }
        printf("  all old_ticks=%.0f new_ticks=%.0f new/old=%.3f\n", all_old, all_new, all_new / all_old);
        return mismatches != 0;
    }
    if (argc == 2 && strcmp(argv[1], "synth") == 0)
    {
        const uint32_t counts[] = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 20, 24, 28, 32, 40, 48, 64, 96, 128, 192, 256, 512, 1024, 4096, 16384, 65536, 262144, 1048576 };
        for (uint32_t ci = 0; ci < sizeof(counts) / sizeof(counts[0]); ci += 1)
        {
            const uint32_t c = counts[ci];
            const uint32_t k = c <= 1024 ? 256 : (c <= 65536 ? 8 : 2);
            Set* sets = malloc(sizeof(Set) * k);
            for (uint32_t i = 0; i < k; i += 1)
            {
                sets[i].count = c; sets[i].scratch = 4 * c + 7;
                sets[i].s = malloc(c * 4ull + 4); sets[i].d = malloc(c * 4ull + 4);
                for (uint32_t j = 0; j < c; j += 1) sets[i].d[j] = j;
                for (uint32_t j = c; j > 1; j -= 1) { uint32_t o = rnd() % j, t = sets[i].d[j - 1]; sets[i].d[j - 1] = sets[i].d[o]; sets[i].d[o] = t; }
                // Mostly other destinations (chains, fan-out and cycles), some from outside.
                for (uint32_t j = 0; j < c; j += 1) sets[i].s[j] = rnd() % 4 == 0 ? 2 * c + rnd() % (c + 1) : sets[i].d[rnd() % c];
                check(&sets[i]);
            }
            double o, w;
            time_sets(sets, k, &o, &w, c <= 64 ? 4 : 1);
            printf("synth count=%u sets=%u old_ticks=%.1f new_ticks=%.1f new/old=%.3f mismatches=%llu\n", c, k, o, w, w / o, (unsigned long long)mismatches);
            fflush(stdout);
            for (uint32_t i = 0; i < k; i += 1) { free(sets[i].s); free(sets[i].d); }
            free(sets);
        }
        return mismatches != 0;
    }
    return 2;
}
