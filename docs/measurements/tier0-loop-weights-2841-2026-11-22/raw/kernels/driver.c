// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
// #1398's kernel driver (clang -O2): 4,096 elements, 100,000 calls a pass, 5 passes a kernel; prints each kernel's
// median and least pass in ms and a checksum of its results, which every build must print alike.
#include <stdint.h>
#include <stdio.h>
#include <string.h>
#include <time.h>

void k_sum(const float* p, int n, float* out);
void k_adds(uint8_t* d, const uint8_t* a, const uint8_t* b, int n);
uint64_t k_count(const int32_t* p, int n, int32_t k);
void k_fma(const float* a, const float* b, int n, float* out);

#define N 4096
#define CALLS 100000
#define PASSES 5

static float fa[N], fb[N];
static uint8_t ba[N], bb[N], bd[N];
static int32_t ia[N];

static double now_ms(void)
{
    struct timespec t;
    clock_gettime(CLOCK_MONOTONIC, &t);
    return (double)t.tv_sec * 1e3 + (double)t.tv_nsec / 1e6;
}

static uint64_t mix(uint64_t h, const void* p, size_t n)
{
    const uint8_t* b = p;
    for (size_t i = 0; i < n; i += 1)
    {
        h = (h ^ b[i]) * 1099511628211ull;
    }
    return h;
}

static void report(const char* name, double* times, uint64_t check)
{
    for (int i = 1; i < PASSES; i += 1)
    {
        for (int j = i; j > 0 && times[j - 1] > times[j]; j -= 1)
        {
            double t = times[j];
            times[j] = times[j - 1];
            times[j - 1] = t;
        }
    }
    printf("%s\tmedian_ms=%.1f\tmin_ms=%.1f\tcheck=%016llx\n", name, times[PASSES / 2], times[0], (unsigned long long)check);
}

int main(void)
{
    uint32_t s = 12345;
    for (int i = 0; i < N; i += 1)
    {
        s = s * 1664525u + 1013904223u;
        fa[i] = (float)(s >> 20) / 4096.0f;
        fb[i] = (float)(s & 0xfff) / 8192.0f;
        ba[i] = (uint8_t)(s >> 8);
        bb[i] = (uint8_t)(s >> 16);
        ia[i] = (int32_t)((s >> 4) & 7);
    }
    double times[PASSES];
    float out[8];
    uint64_t check = 1469598103934665603ull;
    for (int p = 0; p < PASSES; p += 1)
    {
        const double t = now_ms();
        for (int c = 0; c < CALLS; c += 1)
        {
            k_sum(fa, N, out);
        }
        times[p] = now_ms() - t;
    }
    check = mix(check, out, sizeof(out));
    report("k_sum", times, check);
    check = 1469598103934665603ull;
    for (int p = 0; p < PASSES; p += 1)
    {
        const double t = now_ms();
        for (int c = 0; c < CALLS; c += 1)
        {
            k_adds(bd, ba, bb, N);
        }
        times[p] = now_ms() - t;
    }
    check = mix(check, bd, sizeof(bd));
    report("k_adds", times, check);
    uint64_t counted = 0;
    for (int p = 0; p < PASSES; p += 1)
    {
        counted = 0;
        const double t = now_ms();
        for (int c = 0; c < CALLS; c += 1)
        {
            counted += k_count(ia, N, c & 7);
        }
        times[p] = now_ms() - t;
    }
    report("k_count", times, counted);
    check = 1469598103934665603ull;
    for (int p = 0; p < PASSES; p += 1)
    {
        const double t = now_ms();
        for (int c = 0; c < CALLS; c += 1)
        {
            k_fma(fa, fb, N, out);
        }
        times[p] = now_ms() - t;
    }
    check = mix(check, out, sizeof(out));
    report("k_fma", times, check);
    return 0;
}
