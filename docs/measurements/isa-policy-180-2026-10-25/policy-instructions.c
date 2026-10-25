// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin.
// Original external measurement harness. Compile unchanged against each frozen source checkout, on the locked
// 9700X. The compiler's benchmark separately measures cycles/power states; this probe measures retired instructions
// without nesting perf stat around another hardware-counter user. Counter unavailability is a failure, never zero.
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <time.h>
#include <unistd.h>
#include <linux/perf_event.h>
#include <sys/ioctl.h>
#include <sys/syscall.h>

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused-function"
#include "buster/compiler/x86_64_encoder.c"
#include "buster/compiler/x86_target_forms.c"
#pragma clang diagnostic pop

static __attribute__((noinline)) void scalar_table(const X86Target* target, uint8_t* allowed)
{
    x86_target_forms_scalar(target, allowed);
}

static __attribute__((noinline)) void vector_table(const X86Target* target, uint8_t* allowed)
{
    x86_target_forms(target, allowed);
}

static bool nanoseconds(uint64_t* value)
{
    struct timespec now = {0};
    const bool valid = clock_gettime(CLOCK_MONOTONIC_RAW, &now) == 0;
    if (valid)
    {
        *value = (uint64_t)now.tv_sec * UINT64_C(1000000000) + (uint64_t)now.tv_nsec;
    }
    return valid;
}

static double median(double* values)
{
    for (uint32_t i = 1; i < 21; i += 1)
    {
        const double value = values[i];
        uint32_t j = i;
        while (j != 0 && values[j - 1] > value)
        {
            values[j] = values[j - 1];
            j -= 1;
        }
        values[j] = value;
    }
    return values[10];
}

int main(int argc, char** argv)
{
    X86Target target = {0};
    bool passed = argc == 2 && x86_target_parse(argv[1], strlen(argv[1]), &target);
    uint8_t scalar[X86_FORM_COUNT];
    uint8_t vector[X86_FORM_COUNT];
    x86_target_forms_scalar(&target, scalar);
    x86_target_forms(&target, vector);
    passed &= memcmp(scalar, vector, sizeof(scalar)) == 0;
    struct perf_event_attr event = {0};
    event.size = sizeof(event);
    event.type = PERF_TYPE_HARDWARE;
    event.config = PERF_COUNT_HW_INSTRUCTIONS;
    event.disabled = 1;
    event.exclude_kernel = 1;
    event.exclude_hv = 1;
    event.read_format = PERF_FORMAT_TOTAL_TIME_ENABLED | PERF_FORMAT_TOTAL_TIME_RUNNING;
    const int fd = (int)syscall(SYS_perf_event_open, &event, 0, -1, -1, PERF_FLAG_FD_CLOEXEC);
    passed &= fd >= 0;
    double instructions[2][21];
    double times[2][21];
    const uint32_t iterations = 10000;
    for (uint32_t pass = 0; passed && pass < 21; pass += 1)
    {
        for (uint32_t order = 0; passed && order < 2; order += 1)
        {
            const uint32_t variant = (pass + order) & 1;
            passed &= ioctl(fd, PERF_EVENT_IOC_RESET, 0) == 0 && ioctl(fd, PERF_EVENT_IOC_ENABLE, 0) == 0;
            uint64_t start = 0;
            uint64_t end = 0;
            passed &= nanoseconds(&start);
            for (uint32_t i = 0; i < iterations; i += 1)
            {
                if (variant == 0)
                {
                    scalar_table(&target, scalar);
                }
                else
                {
                    vector_table(&target, vector);
                }
                __asm__ volatile("" : : "r"(scalar), "r"(vector) : "memory");
            }
            passed &= nanoseconds(&end) && end > start;
            times[variant][pass] = passed ? (double)(end - start) / iterations : 0;
            passed &= ioctl(fd, PERF_EVENT_IOC_DISABLE, 0) == 0;
            uint64_t counters[3] = {0};
            passed &= read(fd, counters, sizeof(counters)) == sizeof(counters) && counters[0] > 0 && counters[1] != 0 && counters[1] == counters[2];
            instructions[variant][pass] = (double)counters[0] / iterations;
        }
    }
    if (passed)
    {
        printf("policy-instructions v2: forms=%u requirements=%zu bytes allowed=%zu bytes; 21 rotating passes, %u tables/sample\n", X86_FORM_COUNT, sizeof(x86_target_requirements), sizeof(scalar), iterations);
        for (uint32_t variant = 0; variant < 2; variant += 1)
        {
            printf("%s: %.4f instructions/table, %.4f ns/table\n", variant == 0 ? "scalar" : "AVX-512", median(instructions[variant]), median(times[variant]));
        }
    }
    else
    {
        fprintf(stderr, "policy instruction probe failed (arguments, equivalence or unmultiplexed hardware counter unavailable)\n");
    }
    if (fd >= 0)
    {
        close(fd);
    }
    return passed ? 0 : 1;
}
