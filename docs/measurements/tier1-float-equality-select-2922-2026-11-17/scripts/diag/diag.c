// #2922's loop variants (loops.s, gen.sh), each over 2^20 doubles (bench.c's draw: small integers, a sixteenth NaN) 80
// times, t from -2 to 2 by pass as bench.c's; best's result is an int, sum's selects 7 or the pass.
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>
typedef long (*Loop)(const double*, int, double, long, long);
#define OFFSETS(v) long v_##v##_00(); long v_##v##_10(); long v_##v##_20(); long v_##v##_30();
OFFSETS(best_truth)
OFFSETS(best_fused)
OFFSETS(equal_truth)
OFFSETS(equal_fused)
OFFSETS(sum_truth)
OFFSETS(sum_fused)
#define ENTRIES(v) { #v "_00", (Loop)v_##v##_00 }, { #v "_10", (Loop)v_##v##_10 }, { #v "_20", (Loop)v_##v##_20 }, { #v "_30", (Loop)v_##v##_30 },
static uint64_t state = 0x9e3779b97f4a7c15u;
static inline uint64_t next(void)
{
    state ^= state << 13;
    state ^= state >> 7;
    state ^= state << 17;
    return state;
}
int main(int argc, char** argv)
{
    const char* v = argc > 1 ? argv[1] : "";
    static const struct { const char* name; Loop f; } variants[] = { ENTRIES(best_truth) ENTRIES(best_fused) ENTRIES(equal_truth) ENTRIES(equal_fused) ENTRIES(sum_truth) ENTRIES(sum_fused) };
    Loop f = 0;
    for (unsigned i = 0; i < sizeof(variants) / sizeof(variants[0]); i += 1)
    {
        f = strcmp(v, variants[i].name) == 0 ? variants[i].f : f;
    }
    if (f == 0)
    {
        fprintf(stderr, "diag: unknown variant '%s'\n", v);
        return 2;
    }
    enum { ELEMENTS = 1 << 20, PASSES = 80 };
    double* p = malloc(sizeof(double) * ELEMENTS);
    for (int i = 0; i < ELEMENTS; i += 1)
    {
        const uint64_t x = next();
        p[i] = (x & 15) == 0 ? __builtin_nan("") : (double)((int)((x >> 8) & 7) - 3);
    }
    const bool best = strncmp(v, "best", 4) == 0;
    long acc = 0;
    for (int pass = 0; pass < PASSES; pass += 1)
    {
        const long r = f(p, ELEMENTS, (double)(pass % 5 - 2), 7, pass);
        acc += best ? (long)(int)r : r;
    }
    printf("%.*s %ld\n", (int)(strchr(v, '_') - v), v, acc);
    return 0;
}
