// #2843's kernels' driver, built by clang -O2: calls one kernel (argv[1]) REPS times over N elements whose comparisons'
// outcomes repeat every four elements (predictable), and prints its milliseconds, then a checksum of every call's sum.
#include <stdint.h>
#include <stdio.h>
#include <string.h>
#include <time.h>

long k_one(const int* p, long n);
unsigned long k_unsigned(const unsigned* p, long n);
long k_half(const unsigned short* p, long n);
long k_both(const int* p, long n);
long k_logic(const int* p, long n);

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
    static int p[N];
    static unsigned u[N];
    static unsigned short h[N];
    // -1, 5, 0, 2000, repeating, as #2678's record's kernels: the unsigned words are their bits, the halves 65535, 5, 0
    // and 2000.
    static const int pattern[4] = { -1, 5, 0, 2000 };
    for (int i = 0; i < N; i++)
    {
        p[i] = pattern[i & 3];
        u[i] = (unsigned)pattern[i & 3];
        h[i] = (unsigned short)pattern[i & 3];
    }
    const char* only = argc > 1 ? argv[1] : NULL;
    const char* names[] = { "one", "unsigned", "half", "both", "logic" };
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
                case 0: check += (uint64_t)k_one(p, N); break;
                case 1: check += (uint64_t)k_unsigned(u, N); break;
                case 2: check += (uint64_t)k_half(h, N); break;
                case 3: check += (uint64_t)k_both(p, N); break;
                case 4: check += (uint64_t)k_logic(p, N); break;
            }
            __asm__ volatile("" ::: "memory");
        }
        printf("%s %.1f\n", names[k], now() - start);
    }
    printf("check %llu\n", (unsigned long long)check);
    return 0;
}
