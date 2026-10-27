// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Original #599 independent runtime benchmark, linked against separately compiled wrappers.
#define _GNU_SOURCE
#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <unistd.h>
#include <sys/mman.h>
#include <sys/syscall.h>
#include <linux/perf_event.h>
#include <sys/ioctl.h>
#include <inttypes.h>

typedef void *(*Copy)(void *, const void *, unsigned long);
typedef void *(*Set)(void *, int, unsigned long);
typedef int (*Compare)(const void *, const void *, unsigned long);
#define DECLARE(N) \
extern void *bench_copy_##N(void *, const void *, unsigned long); \
extern void *bench_move_##N(void *, const void *, unsigned long); \
extern void *bench_set_##N(void *, int, unsigned long); \
extern int bench_compare_##N(const void *, const void *, unsigned long);
DECLARE(d)
DECLARE(0)
DECLARE(1)
DECLARE(8)
DECLARE(16)
DECLARE(32)
DECLARE(64)
DECLARE(256)
DECLARE(4096)
DECLARE(1048576)
extern unsigned long bench_length_d(const char *);
static const unsigned long sizes[] = { 0, 1, 8, 16, 32, 64, 256, 4096, 1048576 };
static const Copy copies[] = { bench_copy_0, bench_copy_1, bench_copy_8, bench_copy_16, bench_copy_32, bench_copy_64, bench_copy_256, bench_copy_4096, bench_copy_1048576 };
static const Copy moves[] = { bench_move_0, bench_move_1, bench_move_8, bench_move_16, bench_move_32, bench_move_64, bench_move_256, bench_move_4096, bench_move_1048576 };
static const Set fills[] = { bench_set_0, bench_set_1, bench_set_8, bench_set_16, bench_set_32, bench_set_64, bench_set_256, bench_set_4096, bench_set_1048576 };
static const Compare compares[] = { bench_compare_0, bench_compare_1, bench_compare_8, bench_compare_16, bench_compare_32, bench_compare_64, bench_compare_256, bench_compare_4096, bench_compare_1048576 };
static volatile uint64_t sink;
static uint64_t now(void)
{
    struct timespec t;
    clock_gettime(CLOCK_MONOTONIC_RAW, &t);
    return (uint64_t)t.tv_sec * 1000000000 + t.tv_nsec;
}
static int sign(int v) { return (v > 0) - (v < 0); }
static void require(int condition, const char *what)
{
    if (!condition) { fprintf(stderr, "failed: %s\n", what); exit(1); }
}
int main(int argc, char **argv)
{
    const char *label = argc > 1 ? argv[1] : "unknown";
    struct perf_event_attr attr = { .type = PERF_TYPE_HARDWARE, .size = sizeof(attr), .config = PERF_COUNT_HW_INSTRUCTIONS, .exclude_kernel = 1, .exclude_hv = 1 };
    int fd = (int)syscall(SYS_perf_event_open, &attr, 0, -1, -1, 0);
    const size_t bytes = 1048576 + 512;
    unsigned char *a = malloc(bytes), *b = malloc(bytes), *expected = malloc(bytes);
    require(a && b && expected, "allocation");
    puts("variant,operation,constant,n,alignment,shape,ns_per_call,instructions_per_byte");
    for (unsigned s = 0; s < sizeof(sizes) / sizeof(sizes[0]); s++)
    {
        unsigned long n = sizes[s];
        // Cap baseline byte-loop time while keeping short calls above clock resolution.
        unsigned long runs = 4194304 / (n + 1);
        if (runs < 8) runs = 8;
        if (runs > 100000) runs = 100000;
        for (unsigned known = 0; known < 2; known++)
        {
            Copy copy = known ? copies[s] : bench_copy_d;
            Copy move = known ? moves[s] : bench_move_d;
            Set fill = known ? fills[s] : bench_set_d;
            Compare compare = known ? compares[s] : bench_compare_d;
            for (unsigned alignment = 0; alignment <= 7; alignment += 7)
            {
                unsigned char *left = a + 128 + alignment;
                unsigned char *right = b + 128 + (7 - alignment);
                for (unsigned op = 0; op < 5; op++)
                {
                    unsigned shapes = op == 1 ? 3 : op == 3 ? 4 : 1;
                    for (unsigned shape = 0; shape < shapes; shape++)
                    {
                        for (size_t i = 0; i < bytes; i++) a[i] = b[i] = (unsigned char)(1 + i % 255);
                        if (op == 3) memcpy(right, left, n);
                        if (op == 3 && shape && n)
                        {
                            unsigned long at = shape == 1 ? 0 : shape == 2 ? n / 2 : n - 1;
                            right[at] ^= 128;
                        }
                        if (op == 4) left[n] = 0;
                        void *dest = shape == 1 ? left + 1 : shape == 2 ? left - 1 : right;
                        if (op == 0) require(copy(right, left, n) == right && !memcmp(right, left, n), "copy");
                        if (op == 1)
                        {
                            memcpy(expected, a, bytes);
                            if (shape) memmove(expected + ((unsigned char *)dest - a), expected + (left - a), n);
                            else memcpy(expected, b, bytes), memmove(expected + (right - b), left, n);
                            require(move(dest, left, n) == dest && !memcmp(shape ? a : b, expected, bytes), "move");
                        }
                        if (op == 2) require(fill(right, 0x1a5, n) == right, "fill return");
                        if (op == 2) for (unsigned long i = 0; i < n; i++) require(right[i] == 0xa5, "fill bytes");
                        if (op == 3) require(sign(compare(left, right, n)) == sign(memcmp(left, right, n)), "compare");
                        if (op == 4) require(bench_length_d((char *)left) == n, "length");
                        uint64_t times[3], counts[3];
                        for (unsigned pass = 0; pass < 3; pass++)
                        {
                            uint64_t before = 0, after = 0, sum = 0;
                            if (fd >= 0) read(fd, &before, sizeof(before));
                            uint64_t start = now();
                            for (unsigned long r = 0; r < runs; r++)
                            {
                                if (op == 0) sum += (uintptr_t)copy(right, left, n);
                                if (op == 1) sum += (uintptr_t)move(dest, left, n);
                                if (op == 2) sum += (uintptr_t)fill(right, 0xa5, n);
                                if (op == 3) sum += (unsigned)compare(left, right, n);
                                if (op == 4) sum += bench_length_d((char *)left);
                            }
                            times[pass] = now() - start;
                            if (fd >= 0) read(fd, &after, sizeof(after));
                            counts[pass] = after - before;
                            sink += sum;
                        }
                        unsigned median = 0;
                        if ((times[1] >= times[0] && times[1] <= times[2]) || (times[1] >= times[2] && times[1] <= times[0])) median = 1;
                        else if ((times[2] >= times[0] && times[2] <= times[1]) || (times[2] >= times[1] && times[2] <= times[0])) median = 2;
                        printf("%s,%u,%u,%lu,%u,%u,%.3f,%.6f\n", label, op, known, n, alignment, shape, (double)times[median] / runs, n && fd >= 0 ? (double)counts[median] / runs / n : 0);
                    }
                }
            }
        }
    }
    // Strings end immediately before an inaccessible page, at all short tail positions.
    unsigned char *guard = mmap(0, 8192, PROT_READ | PROT_WRITE, MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
    require(guard != MAP_FAILED && !mprotect(guard + 4096, 4096, PROT_NONE), "guard");
    for (unsigned n = 0; n < 256; n++)
    {
        memset(guard, 0x81, 4096);
        guard[4095] = 0;
        require(bench_length_d((char *)guard + 4095 - n) == n, "guarded length");
    }
    munmap(guard, 8192);
    free(a); free(b); free(expected);
    if (fd >= 0) close(fd);
    return 0;
}
