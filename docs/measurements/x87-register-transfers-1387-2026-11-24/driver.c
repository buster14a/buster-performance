#define _POSIX_C_SOURCE 200809L
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>

enum { count = 4096, repetitions = 20000 };
static int integers[count];
static long double p[count], q[count];

long double affine(const int*, int);
long double sum(const long double*, int);
long double dot(const long double*, const long double*, int);

static uint64_t nanoseconds(void)
{
    struct timespec t;
    if (clock_gettime(CLOCK_MONOTONIC_RAW, &t) != 0)
    {
        perror("clock_gettime");
        exit(2);
    }
    return (uint64_t)t.tv_sec * 1000000000 + t.tv_nsec;
}

int main(int argc, char** argv)
{
    if (argc != 2 || strlen(argv[1]) != 1 || argv[1][0] < '0' || argv[1][0] > '2')
    {
        return 2;
    }
    int kernel = argv[1][0] - '0';
    long double expected[3] = { 0 };
    for (int i = 0; i < count; ++i)
    {
        integers[i] = (i * 107 % 101) - 50;
        p[i] = (long double)((i * 101 % 97) - 47) / 32;
        q[i] = (long double)((i * 83 % 79) - 37) / 64;
        expected[0] = expected[0] * 0.5L + integers[i];
        expected[1] += p[i];
        expected[2] += p[i] * q[i];
    }
    long double result = 0;
    uint64_t start = nanoseconds();
    for (int rep = 0; rep < repetitions; ++rep)
    {
        switch (kernel)
        {
            case 0: result = affine(integers, count); break;
            case 1: result = sum(p, count); break;
            case 2: result = dot(p, q, count); break;
        }
    }
    uint64_t elapsed = nanoseconds() - start;
    if (memcmp(&result, &expected[kernel], 10) != 0)
    {
        fprintf(stderr, "wrong result %La, expected %La\n", result, expected[kernel]);
        return 1;
    }
    printf("%llu %La\n", (unsigned long long)elapsed, result);
    return 0;
}
