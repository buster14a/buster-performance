// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin.
// Diagnostic-only syntax-prefix experiment derived from the frozen matcher and policy-instructions.c.
// Every form's original/proposed syntax result and target-filtered output must match. No production change yet.
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

static uint8_t eligible[X86_FORM_COUNT];

static bool original_supported(const X86FormDescription* form)
{
    static const char* const integer[] =
        {
            "mov",
            "movabs",
            "lea",
            "movzx",
            "movsx",
            "movsxd",
            "add",
            "adc",
            "sub",
            "sbb",
            "and",
            "or",
            "xor",
            "cmp",
            "test",
            "inc",
            "dec",
            "neg",
            "not",
            "mul",
            "imul",
            "div",
            "idiv",
            "shl",
            "shr",
            "sar",
            "sal",
            "rol",
            "ror",
            "shld",
            "shrd",
            "push",
            "pushw",
            "pop",
            "call",
            "jmp",
            "ret",
            "leave",
            "nop",
            "int3",
            "ud2",
            "syscall",
            "clc",
            "stc",
            "cmc",
            "cld",
            "std",
            "cbw",
            "cwde",
            "cdqe",
            "cwd",
            "cdq",
            "cqo",
            "loop",
            "loope",
            "loopne",
            "jrcxz",
    };
    static const char* const sse[] =
        {
            "movaps",
            "movups",
            "movapd",
            "movupd",
            "movdqa",
            "movdqu",
            "addps",
            "addpd",
            "subps",
            "subpd",
            "mulps",
            "mulpd",
            "divps",
            "divpd",
            "xorps",
            "xorpd",
            "pxor",
            "paddd",
            "psubd",
    };
    static const char* const conditions[] =
        {
            "o",
            "no",
            "b",
            "ae",
            "e",
            "ne",
            "be",
            "a",
            "s",
            "ns",
            "p",
            "np",
            "l",
            "ge",
            "le",
            "g",
    };
    const char* name = form->mnemonic;
    bool allowed = false;
    if (form->family == BUSTER_X86_FAMILY_LEGACY)
    {
        for (uint32_t i = 0; !allowed && i < BUSTER_ARRAY_LENGTH(integer); i += 1)
        {
            allowed = name[0] == integer[i][0] && strcmp(name, integer[i]) == 0;
        }
        for (uint32_t i = 0; !allowed && i < BUSTER_ARRAY_LENGTH(sse); i += 1)
        {
            allowed = name[0] == sse[i][0] && strcmp(name, sse[i]) == 0;
        }
        const char* suffix = strncmp(name, "cmov", 4) == 0 ? name + 4 : strncmp(name, "set", 3) == 0 ? name + 3
                                                                    : name[0] == 'j'                 ? name + 1
                                                                                                     : "";
        for (uint32_t i = 0; !allowed && suffix[0] != 0 && i < BUSTER_ARRAY_LENGTH(conditions); i += 1)
        {
            allowed |= strcmp(suffix, conditions[i]) == 0;
        }
    }
    else if (form->family == BUSTER_X86_FAMILY_VEX && name[0] == 'v')
    {
        for (uint32_t i = 0; i < BUSTER_ARRAY_LENGTH(sse); i += 1)
        {
            allowed |= strcmp(name + 1, sse[i]) == 0;
        }
        allowed |= strcmp(name, "vzeroupper") == 0;
    }
    else if (form->family == BUSTER_X86_FAMILY_EVEX && form->vector_length == 2 && name[0] == 'v')
    {
        // 512-bit floating arithmetic/moves and dword integer arithmetic are AVX-512F. No implicit VL/BW/DQ.
        for (uint32_t i = 0; i < 14; i += 1)
        {
            allowed |= i != 4 && i != 5 && strcmp(name + 1, sse[i]) == 0;
        }
        allowed |= strcmp(name, "vpaddd") == 0 || strcmp(name, "vpsubd") == 0 || strcmp(name, "vpxord") == 0;
        allowed |= strcmp(name, "vmovdqa32") == 0 || strcmp(name, "vmovdqu32") == 0;
    }
    // Near call/jump syntax must never select a far-pointer memory form merely because its memory width fits.
    allowed &= !((strcmp(name, "call") == 0 || strcmp(name, "jmp") == 0) && (form->encoding == BUSTER_X86_ENCODING_D3 || form->encoding == BUSTER_X86_ENCODING_D5));
    return allowed;
}

static bool proposed_supported(const X86FormDescription* form)
{
    static const char* const integer[] =
        {
            "mov",
            "movabs",
            "lea",
            "movzx",
            "movsx",
            "movsxd",
            "add",
            "adc",
            "sub",
            "sbb",
            "and",
            "or",
            "xor",
            "cmp",
            "test",
            "inc",
            "dec",
            "neg",
            "not",
            "mul",
            "imul",
            "div",
            "idiv",
            "shl",
            "shr",
            "sar",
            "sal",
            "rol",
            "ror",
            "shld",
            "shrd",
            "push",
            "pushw",
            "pop",
            "call",
            "jmp",
            "ret",
            "leave",
            "nop",
            "int3",
            "ud2",
            "syscall",
            "clc",
            "stc",
            "cmc",
            "cld",
            "std",
            "cbw",
            "cwde",
            "cdqe",
            "cwd",
            "cdq",
            "cqo",
            "loop",
            "loope",
            "loopne",
            "jrcxz",
    };
    static const char* const sse[] =
        {
            "movaps",
            "movups",
            "movapd",
            "movupd",
            "movdqa",
            "movdqu",
            "addps",
            "addpd",
            "subps",
            "subpd",
            "mulps",
            "mulpd",
            "divps",
            "divpd",
            "xorps",
            "xorpd",
            "pxor",
            "paddd",
            "psubd",
    };
    static const char* const conditions[] =
        {
            "o",
            "no",
            "b",
            "ae",
            "e",
            "ne",
            "be",
            "a",
            "s",
            "ns",
            "p",
            "np",
            "l",
            "ge",
            "le",
            "g",
    };
    const char* name = form->mnemonic;
    bool allowed = false;
    if (form->family == BUSTER_X86_FAMILY_LEGACY)
    {
        for (uint32_t i = 0; !allowed && i < BUSTER_ARRAY_LENGTH(integer); i += 1)
        {
            allowed = name[0] == integer[i][0] && strcmp(name, integer[i]) == 0;
        }
        for (uint32_t i = 0; !allowed && i < BUSTER_ARRAY_LENGTH(sse); i += 1)
        {
            allowed = name[0] == sse[i][0] && strcmp(name, sse[i]) == 0;
        }
        const char* suffix = strncmp(name, "cmov", 4) == 0 ? name + 4 : strncmp(name, "set", 3) == 0 ? name + 3
                                                                    : name[0] == 'j'                 ? name + 1
                                                                                                     : "";
        for (uint32_t i = 0; !allowed && suffix[0] != 0 && i < BUSTER_ARRAY_LENGTH(conditions); i += 1)
        {
            allowed |= strcmp(suffix, conditions[i]) == 0;
        }
    }
    else if (form->family == BUSTER_X86_FAMILY_VEX && name[0] == 'v')
    {
        for (uint32_t i = 0; i < BUSTER_ARRAY_LENGTH(sse); i += 1)
        {
            allowed |= name[1] == sse[i][0] && strcmp(name + 1, sse[i]) == 0;
        }
        allowed |= strcmp(name, "vzeroupper") == 0;
    }
    else if (form->family == BUSTER_X86_FAMILY_EVEX && form->vector_length == 2 && name[0] == 'v')
    {
        // 512-bit floating arithmetic/moves and dword integer arithmetic are AVX-512F. No implicit VL/BW/DQ.
        for (uint32_t i = 0; i < 14; i += 1)
        {
            allowed |= i != 4 && i != 5 && name[1] == sse[i][0] && strcmp(name + 1, sse[i]) == 0;
        }
        allowed |= strcmp(name, "vpaddd") == 0 || strcmp(name, "vpsubd") == 0 || strcmp(name, "vpxord") == 0;
        allowed |= strcmp(name, "vmovdqa32") == 0 || strcmp(name, "vmovdqu32") == 0;
    }
    // Near call/jump syntax must never select a far-pointer memory form merely because its memory width fits.
    allowed &= !((strcmp(name, "call") == 0 || strcmp(name, "jmp") == 0) && (form->encoding == BUSTER_X86_ENCODING_D3 || form->encoding == BUSTER_X86_ENCODING_D5));
    return allowed;
}

static __attribute__((noinline, aligned(64))) void scalar_table(const X86Target* target, uint8_t* allowed)
{
    (void)target;
    for (uint32_t f = 0; f < X86_FORM_COUNT; f += 1)
    {
        allowed[f] = eligible[f] && original_supported(&x86_form_descriptions[f]);
    }
}

static __attribute__((noinline, aligned(64))) void vector_table(const X86Target* target, uint8_t* allowed)
{
    (void)target;
    for (uint32_t f = 0; f < X86_FORM_COUNT; f += 1)
    {
        allowed[f] = eligible[f] && proposed_supported(&x86_form_descriptions[f]);
    }
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
    x86_target_forms(&target, eligible);
    for (uint32_t f = 0; f < X86_FORM_COUNT; f += 1)
    {
        passed &= original_supported(&x86_form_descriptions[f]) == proposed_supported(&x86_form_descriptions[f]);
    }
    scalar_table(&target, scalar);
    vector_table(&target, vector);
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
    const uint32_t iterations = 100;
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
    passed &= memcmp(scalar, vector, sizeof(scalar)) == 0;
    if (passed)
    {
        printf("syntax-prefix prototype: forms=%u requirements=%zu bytes allowed=%zu bytes; 21 rotating passes, %u tables/sample\n", X86_FORM_COUNT, sizeof(x86_target_requirements), sizeof(scalar), iterations);
        for (uint32_t variant = 0; variant < 2; variant += 1)
        {
            printf("%s: %.4f instructions/table, %.4f ns/table\n", variant == 0 ? "original" : "prefix", median(instructions[variant]), median(times[variant]));
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
