// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin.
// Original isolated initialization experiment. The copied function is from this repository at 174c435;
// only operand-role computation for non-admitted rows moves. Every output byte, including padding and unused
// entries initialized by memset, must match for all profiles and individual feature removals.
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

typedef struct String8 String8;
struct String8
{
    char* pointer;
    size_t length;
};
#define BUSTER_S8(text) ((String8){ .pointer = (char*)(text), .length = sizeof(text) - 1 })

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused-function"
#include "buster/compiler/x86_64_encoder.c"
#include "buster/compiler/x86_target_forms.c"
#include "buster/compiler/x86_match.c"
#pragma clang diagnostic pop

static __attribute__((noinline, aligned(64))) void delayed_roles_initialize(X86MatchIndex* index, const X86Target* target)
{
    memset(index, 0, sizeof(*index));
    x86_target_forms(target, index->allowed);
    bool admitted[BUSTER_X86_FORM_LEGACY_MODES];
    uint16_t buckets[BUSTER_X86_FORM_LEGACY_MODES];
    for (uint32_t f = 0; f < BUSTER_X86_FORM_LEGACY_MODES; f += 1)
    {
        const X86FormDescription* form = &x86_form_descriptions[f];
        uint8_t roles[4];
        admitted[f] = index->allowed[f] && x86_match_supported(form) && x86_match_roles(form->syntax, roles) <= 4;
        if (admitted[f])
        {
            const String8 name = x86_match_canonical((String8){.pointer = (char*)form->mnemonic, .length = strlen(form->mnemonic)});
            const uint32_t bucket = x86_match_bucket(index, name);
            index->names[bucket] = name;
            buckets[f] = bucket;
            index->begin[bucket + 1] += 1;
        }
    }
    for (uint32_t b = 0; b < BUSTER_X86_MATCH_BUCKETS; b += 1)
    {
        index->begin[b + 1] += index->begin[b];
    }
    uint32_t cursors[BUSTER_X86_MATCH_BUCKETS];
    memcpy(cursors, index->begin, sizeof(cursors));
    for (uint32_t f = 0; f < BUSTER_X86_FORM_LEGACY_MODES; f += 1)
    {
        if (admitted[f])
        {
            const X86FormDescription* form = &x86_form_descriptions[f];
            uint8_t roles[4];
            const uint32_t count = x86_match_roles(form->syntax, roles);
            const uint32_t at = cursors[buckets[f]]++;
            index->forms[at] = f;
            index->counts[at] = count;
            index->broadcast[at] = (form->evex & BUSTER_X86_EVEX_BROADCAST) ? 64 / form->disp8_scale : 0;
            const bool implicit_qword = form->operand_bytes == 0 && (strcmp(form->mnemonic, "call") == 0 || strcmp(form->mnemonic, "jmp") == 0 || strcmp(form->mnemonic, "ret") == 0 || strcmp(form->mnemonic, "leave") == 0);
            index->attributes[at] = (implicit_qword ? 8 : form->operand_bytes) |
                (strcmp(form->mnemonic, "movabs") == 0 ? BUSTER_X86_MATCH_MOVABS : 0) |
                (strcmp(form->mnemonic, "pushw") == 0 ? BUSTER_X86_MATCH_PUSHW_NAME : 0) |
                (form->operand_bytes == 2 && (strcmp(form->mnemonic, "pushw") == 0 || strcmp(form->mnemonic, "push") == 0) ? BUSTER_X86_MATCH_PUSH_WORD : 0) |
                (form->family == BUSTER_X86_FAMILY_EVEX ? BUSTER_X86_MATCH_EVEX : 0) |
                ((form->evex & BUSTER_X86_EVEX_ROUNDING) != 0 ? BUSTER_X86_MATCH_ROUNDING : 0) |
                ((form->evex & (BUSTER_X86_EVEX_SAE | BUSTER_X86_EVEX_ND | BUSTER_X86_EVEX_NF | BUSTER_X86_EVEX_SOURCE_CONDITION)) != 0 ? BUSTER_X86_MATCH_FORBIDDEN : 0);
            const uint32_t bytes = form->immediate_bytes;
            const bool extended = x86_match_sign_extends(form);
            index->immediate_min[at] = bytes != 0 ? (int64_t)(-((__int128)1 << (8 * bytes - 1))) : 0;
            index->immediate_max[at] = bytes != 0 ? (uint64_t)(((__int128)1 << (8 * bytes - (extended ? 1 : 0))) - 1) : 0;
            for (uint32_t operand = 0; operand < count; operand += 1)
            {
                const uint32_t role = roles[operand];
                const uint16_t descriptor = role == X86_MATCH_RM ? form->rm : role == X86_MATCH_REG ? form->reg
                                                                          : role == X86_MATCH_VVVV  ? form->vvvv
                                                                                                    : 0;
                uint32_t kinds = ((descriptor & BUSTER_X86_OPERAND_REGISTER) ? 1u << X86_OPERAND_REGISTER : 0) | ((descriptor & BUSTER_X86_OPERAND_MEMORY) ? 1u << X86_OPERAND_MEMORY : 0);
                uint32_t class = descriptor & BUSTER_X86_OPERAND_CLASS;
                uint32_t fixed = 0;
                if (role == X86_MATCH_IMM || role == X86_MATCH_REL || role == X86_MATCH_ONE)
                {
                    kinds = 1u << X86_OPERAND_IMMEDIATE;
                }
                else if (role == X86_MATCH_ACC || role == X86_MATCH_CL)
                {
                    kinds = 1u << X86_OPERAND_REGISTER;
                    class = role == X86_MATCH_CL ? BUSTER_X86_CLASS_GPR8 : form->operand_bytes == 1 ? BUSTER_X86_CLASS_GPR8
                                                                       : form->operand_bytes == 2   ? BUSTER_X86_CLASS_GPR16
                                                                       : form->operand_bytes == 4   ? BUSTER_X86_CLASS_GPR32
                                                                                                    : BUSTER_X86_CLASS_GPR64;
                    fixed = role == X86_MATCH_CL ? 2 : 1;
                }
                const uint32_t width = (form->evex & BUSTER_X86_EVEX_BROADCAST) && role == X86_MATCH_RM ? form->disp8_scale : form->operand_bytes;
                index->operands[operand][at] = kinds | class << 4 | width << 8 | role << 16 | fixed << 24;
            }
        }
    }
}


static __attribute__((noinline, aligned(64))) void original_initialize(X86MatchIndex* index, const X86Target* target)
{
    memset(index, 0, sizeof(*index));
    x86_target_forms(target, index->allowed);
    bool admitted[BUSTER_X86_FORM_LEGACY_MODES];
    uint16_t buckets[BUSTER_X86_FORM_LEGACY_MODES];
    for (uint32_t f = 0; f < BUSTER_X86_FORM_LEGACY_MODES; f += 1)
    {
        const X86FormDescription* form = &x86_form_descriptions[f];
        uint8_t roles[4];
        admitted[f] = index->allowed[f] && x86_match_supported(form) && x86_match_roles(form->syntax, roles) <= 4;
        if (admitted[f])
        {
            const String8 name = x86_match_canonical((String8){.pointer = (char*)form->mnemonic, .length = strlen(form->mnemonic)});
            const uint32_t bucket = x86_match_bucket(index, name);
            index->names[bucket] = name;
            buckets[f] = bucket;
            index->begin[bucket + 1] += 1;
        }
    }
    for (uint32_t b = 0; b < BUSTER_X86_MATCH_BUCKETS; b += 1)
    {
        index->begin[b + 1] += index->begin[b];
    }
    uint32_t cursors[BUSTER_X86_MATCH_BUCKETS];
    memcpy(cursors, index->begin, sizeof(cursors));
    for (uint32_t f = 0; f < BUSTER_X86_FORM_LEGACY_MODES; f += 1)
    {
        const X86FormDescription* form = &x86_form_descriptions[f];
        uint8_t roles[4];
        const uint32_t count = x86_match_roles(form->syntax, roles);
        if (admitted[f])
        {
            const uint32_t at = cursors[buckets[f]]++;
            index->forms[at] = f;
            index->counts[at] = count;
            index->broadcast[at] = (form->evex & BUSTER_X86_EVEX_BROADCAST) ? 64 / form->disp8_scale : 0;
            const bool implicit_qword = form->operand_bytes == 0 && (strcmp(form->mnemonic, "call") == 0 || strcmp(form->mnemonic, "jmp") == 0 || strcmp(form->mnemonic, "ret") == 0 || strcmp(form->mnemonic, "leave") == 0);
            index->attributes[at] = (implicit_qword ? 8 : form->operand_bytes) |
                (strcmp(form->mnemonic, "movabs") == 0 ? BUSTER_X86_MATCH_MOVABS : 0) |
                (strcmp(form->mnemonic, "pushw") == 0 ? BUSTER_X86_MATCH_PUSHW_NAME : 0) |
                (form->operand_bytes == 2 && (strcmp(form->mnemonic, "pushw") == 0 || strcmp(form->mnemonic, "push") == 0) ? BUSTER_X86_MATCH_PUSH_WORD : 0) |
                (form->family == BUSTER_X86_FAMILY_EVEX ? BUSTER_X86_MATCH_EVEX : 0) |
                ((form->evex & BUSTER_X86_EVEX_ROUNDING) != 0 ? BUSTER_X86_MATCH_ROUNDING : 0) |
                ((form->evex & (BUSTER_X86_EVEX_SAE | BUSTER_X86_EVEX_ND | BUSTER_X86_EVEX_NF | BUSTER_X86_EVEX_SOURCE_CONDITION)) != 0 ? BUSTER_X86_MATCH_FORBIDDEN : 0);
            const uint32_t bytes = form->immediate_bytes;
            const bool extended = x86_match_sign_extends(form);
            index->immediate_min[at] = bytes != 0 ? (int64_t)(-((__int128)1 << (8 * bytes - 1))) : 0;
            index->immediate_max[at] = bytes != 0 ? (uint64_t)(((__int128)1 << (8 * bytes - (extended ? 1 : 0))) - 1) : 0;
            for (uint32_t operand = 0; operand < count; operand += 1)
            {
                const uint32_t role = roles[operand];
                const uint16_t descriptor = role == X86_MATCH_RM ? form->rm : role == X86_MATCH_REG ? form->reg
                                                                          : role == X86_MATCH_VVVV  ? form->vvvv
                                                                                                    : 0;
                uint32_t kinds = ((descriptor & BUSTER_X86_OPERAND_REGISTER) ? 1u << X86_OPERAND_REGISTER : 0) | ((descriptor & BUSTER_X86_OPERAND_MEMORY) ? 1u << X86_OPERAND_MEMORY : 0);
                uint32_t class = descriptor & BUSTER_X86_OPERAND_CLASS;
                uint32_t fixed = 0;
                if (role == X86_MATCH_IMM || role == X86_MATCH_REL || role == X86_MATCH_ONE)
                {
                    kinds = 1u << X86_OPERAND_IMMEDIATE;
                }
                else if (role == X86_MATCH_ACC || role == X86_MATCH_CL)
                {
                    kinds = 1u << X86_OPERAND_REGISTER;
                    class = role == X86_MATCH_CL ? BUSTER_X86_CLASS_GPR8 : form->operand_bytes == 1 ? BUSTER_X86_CLASS_GPR8
                                                                       : form->operand_bytes == 2   ? BUSTER_X86_CLASS_GPR16
                                                                       : form->operand_bytes == 4   ? BUSTER_X86_CLASS_GPR32
                                                                                                    : BUSTER_X86_CLASS_GPR64;
                    fixed = role == X86_MATCH_CL ? 2 : 1;
                }
                const uint32_t width = (form->evex & BUSTER_X86_EVEX_BROADCAST) && role == X86_MATCH_RM ? form->disp8_scale : form->operand_bytes;
                index->operands[operand][at] = kinds | class << 4 | width << 8 | role << 16 | fixed << 24;
            }
        }
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
    X86MatchIndex* original = malloc(sizeof(*original));
    X86MatchIndex* delayed = malloc(sizeof(*delayed));
    passed &= original != 0 && delayed != 0;
    static const char* const profiles[] = { "x86-64", "x86-64-v2", "x86-64-v3", "x86-64-v4", "znver5", "native" };
    uint32_t checks = 0;
    for (uint32_t p = 0; passed && p <= BUSTER_ARRAY_LENGTH(profiles); p += 1)
    {
        X86Target sample = { .features = UINT64_MAX };
        if (p < BUSTER_ARRAY_LENGTH(profiles))
        {
            passed &= x86_target_parse(profiles[p], strlen(profiles[p]), &sample);
        }
        const uint64_t original_features = sample.features;
        for (uint32_t f = 0; passed && f <= X86_FEATURE_COUNT; f += 1)
        {
            sample.features = f == X86_FEATURE_COUNT ? original_features : original_features & ~(UINT64_C(1) << f);
            original_initialize(original, &sample);
            delayed_roles_initialize(delayed, &sample);
            passed &= memcmp(original, delayed, sizeof(*original)) == 0;
            checks += 1;
        }
    }
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
                    original_initialize(original, &target);
                }
                else
                {
                    delayed_roles_initialize(delayed, &target);
                }
                __asm__ volatile("" : : "r"(original), "r"(delayed) : "memory");
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
        printf("matcher-delayed-roles prototype: %u full-index comparisons pass, %zu bytes each; 21 rotating passes, %u initializations/sample\n", checks, sizeof(*original), iterations);
        for (uint32_t variant = 0; variant < 2; variant += 1)
        {
            printf("%s: %.4f instructions/init, %.4f ns/init\n", variant == 0 ? "all-rows" : "admitted-rows", median(instructions[variant]), median(times[variant]));
        }
    }
    else
    {
        fprintf(stderr, "matcher experiment failed (arguments, full-index equivalence or unmultiplexed hardware counter unavailable)\n");
    }
    if (fd >= 0)
    {
        close(fd);
    }
    free(original);
    free(delayed);
    return passed ? 0 : 1;
}
