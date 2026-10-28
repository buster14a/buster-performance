// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin.
// Complete-validator synthetic size controls; compile in the Buster checkout with -Isrc.
#define main regression_main
#include "validation.c"
#undef main
#include <time.h>
#include <linux/perf_event.h>
#include <sys/syscall.h>
#include <unistd.h>

static uint64_t bucket_now(void)
{
    struct timespec now;
    clock_gettime(CLOCK_MONOTONIC_RAW, &now);
    return (uint64_t)now.tv_sec * 1000000000ull + now.tv_nsec;
}
static int bucket_counter(uint32_t config)
{
    struct perf_event_attr attr = { .type = PERF_TYPE_HARDWARE, .size = sizeof(attr), .config = config, .exclude_kernel = 1, .exclude_hv = 1 };
    return (int)syscall(SYS_perf_event_open, &attr, 0, -1, -1, 0);
}
static uint64_t bucket_read(int fd)
{
    uint64_t count = 0;
    if (fd >= 0 && read(fd, &count, sizeof(count)) != sizeof(count))
    {
        count = 0;
    }
    return count;
}
static volatile uint64_t bucket_sink;
static __attribute__((noinline)) void bucket_run(const Tier0Function* function, uint64_t iterations, uint32_t mode)
{
    uint64_t taken = 0;
    for (uint64_t i = 0; i < iterations; i += 1)
    {
        __asm__ volatile("" : : "r"(function) : "memory");
        taken += mode == 0 ? tier0_validate_accepts(function) : tier0_validate_scalar(function).error == TIER0_OK;
    }
    bucket_sink += taken;
}
int main(int argc, char** argv)
{
    const bool conditioned = argc == 2 && strcmp(argv[1], "--conditioned") == 0;
    const uint32_t counts[] = { 0, 1, 2, 4, 8, 16, 24, 32, 48, 64, 128, 256, 1024 };
    const int cycles = bucket_counter(PERF_COUNT_HW_CPU_CYCLES);
    const int instructions = bucket_counter(PERF_COUNT_HW_INSTRUCTIONS);
    uint8_t kinds[1024];
    uint8_t classes[1024];
    uint64_t values[1024];
    bool valid = true;
    puts("shape,count,conditioned,sample,mode,iterations,ns_per_call,cycles_per_call,instructions_per_call");
    for (uint32_t shape = 0; valid && shape < 2; shape += 1)
    {
        for (uint32_t c = 0; valid && c < BUSTER_ARRAY_LENGTH(counts); c += 1)
        {
            const uint32_t count = counts[c];
            Tier0TestScan fixture;
            tier0_test_scan_function(&fixture, count, false);
            Tier0Function function = shape == 0 ? (Tier0Function){ 0 } : fixture.function;
            function.kinds = kinds;
            function.classes = classes;
            function.values = values;
            function.count = count;
            for (uint32_t p = 0; p < BUSTER_ABI_RESULT_PARTS; p += 1)
            {
                function.result.registers[p] = BUSTER_ABI_REGISTER_NONE;
            }
            for (uint32_t i = 0; i < count; i += 1)
            {
                const bool terminal = (count & 1) != 0 && i == count - 1;
                kinds[i] = terminal ? BUSTER_TYPED_RETURN : (i & 1) != 0 ? BUSTER_TYPED_DISCARD : BUSTER_TYPED_CONST;
                classes[i] = terminal ? BUSTER_TYPED_CLASS_VOID : BUSTER_TYPED_CLASS_I32;
                values[i] = 0;
            }
            valid = tier0_validate_accepts(&function) && tier0_validate_scalar(&function).error == TIER0_OK;
            uint64_t iterations[2] = { 1, 1 };
            for (uint32_t mode = 0; valid && mode < 2; mode += 1)
            {
                uint64_t elapsed = 0;
                while (elapsed < 2000000)
                {
                    const uint64_t start = bucket_now();
                    bucket_run(&function, iterations[mode], mode);
                    elapsed = bucket_now() - start;
                    if (elapsed < 2000000)
                    {
                        iterations[mode] *= 2;
                    }
                }
            }
            for (uint32_t sample = 0; valid && sample < 7; sample += 1)
            {
                for (uint32_t turn = 0; turn < 2; turn += 1)
                {
                    const uint32_t mode = (sample + turn) & 1;
                    if (conditioned)
                    {
                        const uint64_t stop = bucket_now() + 200000000;
                        while (bucket_now() < stop)
                        {
                            bucket_run(&function, 64, 1);
                        }
                    }
                    const uint64_t cy0 = bucket_read(cycles);
                    const uint64_t in0 = bucket_read(instructions);
                    const uint64_t start = bucket_now();
                    bucket_run(&function, iterations[mode], mode);
                    const uint64_t elapsed = bucket_now() - start;
                    const uint64_t ins = bucket_read(instructions) - in0;
                    const uint64_t cy = bucket_read(cycles) - cy0;
                    printf("%s,%u,%u,%u,%s,%" PRIu64 ",%.3f,%.3f,%.3f\n", shape == 0 ? "plain" : "metadata", count, conditioned, sample,
                           mode == 0 ? "vector" : "scalar", iterations[mode], (double)elapsed / iterations[mode], (double)cy / iterations[mode], (double)ins / iterations[mode]);
                }
            }
        }
    }
    if (cycles >= 0) { close(cycles); }
    if (instructions >= 0) { close(instructions); }
    scratch_release();
    return valid ? 0 : 1;
}
