#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>

unsigned k_udiv(const unsigned* p, unsigned n);
unsigned k_umod(const unsigned* p, unsigned n);
unsigned k_index(const unsigned* p, unsigned long n);
int k_sdiv(const int* p, int n);
int k_smod(const int* p, int n);
long k_ldiv(const long* p, long n);
long k_pdiff(const unsigned* const* p, const unsigned* base, int n);
int k_bytes(const unsigned char* p, int n);
unsigned long k_conv(const unsigned long* p, long n);
double k_dconv(const double* p, long n);

#define N 4096
#define REPS 20000

static double now(void)
{
    struct timespec t;
    clock_gettime(CLOCK_MONOTONIC, &t);
    return t.tv_sec * 1e3 + t.tv_nsec * 1e-6;
}

int main(int argc, char** argv)
{
    static unsigned u[N];
    static int s[N];
    static long l[N];
    static const unsigned* q[N];
    static unsigned char b[N];
    static unsigned long w[N];
    static double d[N];
    uint64_t x = 0x9e3779b97f4a7c15u;
    for (int i = 0; i < N; i++)
    {
        x ^= x << 13; x ^= x >> 7; x ^= x << 17;
        u[i] = (unsigned)x;
        s[i] = (int)(x >> 32);
        l[i] = (long)x;
        q[i] = u + (x % N);
        b[i] = (unsigned char)(x >> 24);
        w[i] = x;
        d[i] = (double)(x >> 40) * 0.5;
    }
    const char* only = argc > 1 ? argv[1] : NULL;
    const char* names[] = { "udiv", "umod", "index", "sdiv", "smod", "ldiv", "pdiff", "bytes", "conv", "dconv" };
    uint64_t check = 0;
    for (int k = 0; k < 10; k++)
    {
        if (only != NULL && strcmp(only, names[k]) != 0)
        {
            continue;
        }
        const double start = now();
        for (int r = 0; r < REPS; r++)
        {
            switch (k)
            {
                case 0: check += k_udiv(u, N); break;
                case 1: check += k_umod(u, N); break;
                case 2: check += k_index(u, N); break;
                case 3: check += (uint64_t)k_sdiv(s, N); break;
                case 4: check += (uint64_t)k_smod(s, N); break;
                case 5: check += (uint64_t)k_ldiv(l, N); break;
                case 6: check += (uint64_t)k_pdiff(q, u, N); break;
                case 7: check += (uint64_t)k_bytes(b, N); break;
                case 8: check += k_conv(w, N); break;
                case 9: check += (uint64_t)k_dconv(d, N); break;
            }
            __asm__ volatile("" ::: "memory");
        }
        printf("%s %.1f\n", names[k], now() - start);
    }
    printf("check %llu\n", (unsigned long long)check);
    return 0;
}
