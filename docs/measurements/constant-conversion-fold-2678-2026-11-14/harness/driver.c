#include <stdint.h>
#include <stdio.h>
#include <string.h>
#include <time.h>

unsigned k_index(const unsigned* p, unsigned long n);
unsigned long k_conv(const unsigned long* p, long n);
double k_dconv(const double* p, long n);
long k_zero(const long* p, long n);
float k_fconv(const float* p, long n);

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
    static unsigned long w[N];
    static double d[N];
    static long l[N];
    static float f[N];
    uint64_t x = 0x9e3779b97f4a7c15u;
    for (int i = 0; i < N; i++)
    {
        x ^= x << 13; x ^= x >> 7; x ^= x << 17;
        u[i] = (unsigned)x;
        w[i] = x;
        d[i] = (double)(x >> 40) * 0.5;
        l[i] = (x & 3) == 0 ? 0 : (long)x >> 8;
        f[i] = (float)(x >> 52) * 0.25f;
    }
    const char* only = argc > 1 ? argv[1] : NULL;
    const char* names[] = { "index", "conv", "dconv", "zero", "fconv" };
    uint64_t check = 0;
    for (int k = 0; k < 5; k++)
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
                case 0: check += k_index(u, N); break;
                case 1: check += k_conv(w, N); break;
                case 2: check += (uint64_t)k_dconv(d, N); break;
                case 3: check += (uint64_t)k_zero(l, N); break;
                case 4: check += (uint64_t)k_fconv(f, N); break;
            }
            __asm__ volatile("" ::: "memory");
        }
        printf("%s %.1f\n", names[k], now() - start);
    }
    printf("check %llu\n", (unsigned long long)check);
    return 0;
}
