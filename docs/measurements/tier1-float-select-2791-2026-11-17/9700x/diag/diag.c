// #2791's loop variants (loops.s), each over 2^20 doubles (bench.c's draw: small integers, a sixteenth NaN) 80 times.
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#define VARIANT(v) long v_##v##_00(const double*, int, double); long v_##v##_10(const double*, int, double); long v_##v##_20(const double*, int, double); long v_##v##_30(const double*, int, double);
VARIANT(equal_main)
VARIANT(equal_fused)
VARIANT(equal_own)
VARIANT(count_main)
VARIANT(count_head)
#define ENTRIES(v) { #v "_00", v_##v##_00 }, { #v "_10", v_##v##_10 }, { #v "_20", v_##v##_20 }, { #v "_30", v_##v##_30 },
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
    static const struct { const char* name; long (*f)(const double*, int, double); } variants[] = { ENTRIES(equal_main) ENTRIES(equal_fused) ENTRIES(equal_own) ENTRIES(count_main) ENTRIES(count_head) };
    long (*f)(const double*, int, double) = 0;
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
    const double t = strncmp(v, "equal", 5) == 0 ? 1.0 : 0.0;
    long acc = 0;
    for (int pass = 0; pass < PASSES; pass += 1)
    {
        acc += f(p, ELEMENTS, t);
    }
    printf("%s %ld\n", strncmp(v, "equal", 5) == 0 ? "equal" : "count", acc);
    return 0;
}
