// Calls one of kernels.c's functions: 50 M times on doubles from xorshift64's high bits (a sixteenth of them NaN, a
// quarter equal to the other operand), or over 2^20 such elements 80 times.
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
int k_null(double a, double b, int x, int y);
int k_lt(double a, double b, int x, int y);
int k_ge(float a, float b, int x, int y);
long k_nle(double a, double b, long x, long y);
int k_eq(double a, double b, int x, int y);
int k_ne(float a, float b, int x, int y);
long k_count(const double* p, int n, double t);
long k_equal(const double* p, int n, double t);
static uint64_t state = 0x9e3779b97f4a7c15u;
static inline uint64_t next(void)
{
    state ^= state << 13;
    state ^= state >> 7;
    state ^= state << 17;
    return state;
}
// A small integer's double, or NaN for a sixteenth of the draws.
static inline double draw(uint64_t x)
{
    return (x & 15) == 0 ? __builtin_nan("") : (double)((int)((x >> 8) & 7) - 3);
}
int main(int argc, char** argv)
{
    const char* kernel = argc > 1 ? argv[1] : "";
    long acc = 0;
    enum { CALLS = 50000000, ELEMENTS = 1 << 20, PASSES = 80 };
    if (strcmp(kernel, "count") == 0 || strcmp(kernel, "equal") == 0)
    {
        double* p = malloc(sizeof(double) * ELEMENTS);
        for (int i = 0; i < ELEMENTS; i += 1)
        {
            p[i] = draw(next());
        }
        for (int pass = 0; pass < PASSES; pass += 1)
        {
            acc += kernel[0] == 'c' ? k_count(p, ELEMENTS, 0.0) : k_equal(p, ELEMENTS, 1.0);
        }
        free(p);
    }
    else
    {
        const int which = strcmp(kernel, "null") == 0 ? 0 : strcmp(kernel, "lt") == 0 ? 1 : strcmp(kernel, "ge") == 0 ? 2 : strcmp(kernel, "nle") == 0 ? 3 :
                          strcmp(kernel, "eq") == 0 ? 4 : strcmp(kernel, "ne") == 0 ? 5 : -1;
        if (which < 0)
        {
            fprintf(stderr, "bench: unknown kernel '%s'\n", kernel);
            return 2;
        }
        for (int i = 0; i < CALLS; i += 1)
        {
            const uint64_t x = next();
            const double a = draw(x);
            const double b = draw(x >> 20);
            const int u = (int)(x >> 40);
            const int v = (int)(x >> 44);
            switch (which)
            {
                case 0: acc += k_null(a, b, u, v); break;
                case 1: acc += k_lt(a, b, u, v); break;
                case 2: acc += k_ge((float)a, (float)b, u, v); break;
                case 3: acc += k_nle(a, b, u, v); break;
                case 4: acc += k_eq(a, b, u, v); break;
                default: acc += k_ne((float)a, (float)b, u, v); break;
            }
        }
    }
    printf("%ld\n", acc);
    return 0;
}
