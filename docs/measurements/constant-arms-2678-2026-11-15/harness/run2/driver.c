#include <stdint.h>
#include <stdio.h>
#include <string.h>
#include <time.h>

long k_both(const int* p, long n);
long k_one(const int* p, long n);
long k_logic(const int* p, long n);
double k_dboth(const int* p, long n);

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
    for (int i = 0; i < N; i++)
    {
        // -1, 5, 0, 2000, repeating: each branch's outcome repeats every four elements.
        static const int pattern[4] = { -1, 5, 0, 2000 };
        p[i] = pattern[i & 3];
    }
    const char* only = argc > 1 ? argv[1] : NULL;
    const char* names[] = { "both", "one", "logic", "dboth" };
    uint64_t check = 0;
    for (int k = 0; k < 4; k++)
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
                case 0: check += (uint64_t)k_both(p, N); break;
                case 1: check += (uint64_t)k_one(p, N); break;
                case 2: check += (uint64_t)k_logic(p, N); break;
                case 3: check += (uint64_t)k_dboth(p, N); break;
            }
            __asm__ volatile("" ::: "memory");
        }
        printf("%s %.1f\n", names[k], now() - start);
    }
    printf("check %llu\n", (unsigned long long)check);
    return 0;
}
