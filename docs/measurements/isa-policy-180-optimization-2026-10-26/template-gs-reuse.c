// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin.
// Original isolated GS-template reuse experiment. Include the unchanged frozen174c435 encoder.
// Compare every storage byte, including poisoned gap/padding and fixup copies, in all five modes.
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
#pragma clang diagnostic pop

static __attribute__((noinline, aligned(64))) bool reused_gs_templates(X86EncoderMode encoder, X86TemplateEntry* templates)
{
    bool result = true;
    const uint32_t built_forms = encoder == X86_ENCODER_MODE_64 ? BUSTER_X86_FORM_GS : BUSTER_X86_FORM_TEMPLATES;
    for (uint32_t form = 0; form < built_forms; form += 1)
    {
        result = build_mode_template(form, encoder, &templates[form].template) && result;
        memcpy(templates[form].layout, templates[form].template.layout, sizeof(templates[form].layout));
        memcpy(templates[form].bytes, templates[form].template.bytes, sizeof(templates[form].bytes));
    }
    if (encoder == X86_ENCODER_MODE_64)
    {
        memcpy(templates + BUSTER_X86_FORM_GS, templates + BUSTER_X86_FORM_FS, X86_FORM_COUNT * sizeof(*templates));
        for (uint32_t row = 0; row < X86_FORM_COUNT; row += 1)
        {
            const X86FormDescription* form = &x86_form_descriptions[row];
            X86TemplateEntry* entry = &templates[BUSTER_X86_FORM_GS + row];
            uint32_t flags;
            memcpy(&flags, &entry->template.bytes[BUSTER_X86_TEMPLATE_FLAGS_OFFSET], sizeof(flags));
            if ((form->rm & BUSTER_X86_OPERAND_MEMORY) && !(flags & BUSTER_X86_TEMPLATE_NO_MEMORY))
            {
                const uint32_t prefix = form->family == BUSTER_X86_FAMILY_LEGACY && (form->prefixes & 0xff) == 0x9b;
                entry->template.bytes[prefix] = 0x65;
                entry->bytes[prefix] = 0x65;
            }
        }
    }
    memcpy(&templates[BUSTER_X86_FORM_FIXUP], &templates[0], BUSTER_X86_FORM_TEMPLATES * sizeof(X86TemplateEntry));
    return result;
}

static __attribute__((noinline, aligned(64))) bool original_templates(X86EncoderMode encoder, X86TemplateEntry* templates)
{
    return build_mode_templates(encoder, templates);
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



int main(void)
{
    const size_t entries = BUSTER_X86_TEMPLATE_PADDING + BUSTER_X86_FORM_FIXUP + BUSTER_X86_FORM_TEMPLATES + BUSTER_X86_TEMPLATE_PADDING;
    const size_t bytes = entries * sizeof(X86TemplateEntry);
    X86TemplateEntry* original = aligned_alloc(64, bytes);
    X86TemplateEntry* delayed = aligned_alloc(64, bytes);
    bool passed = original != 0 && delayed != 0;
    uint32_t checks = 0;
    build_legacy_properties();
    const X86EncoderMode modes[] = { X86_ENCODER_MODE_64, X86_ENCODER_MODE_ADDRESS32, X86_ENCODER_MODE_APX, X86_ENCODER_MODE_32, X86_ENCODER_MODE_16 };
    for (uint32_t mode = 0; passed && mode < BUSTER_ARRAY_LENGTH(modes); mode += 1)
    {
        memset(original, 0xa5, bytes);
        memset(delayed, 0xa5, bytes);
        const bool before = original_templates(modes[mode], original + 1);
        const bool after = reused_gs_templates(modes[mode], delayed + 1);
        passed &= before && after && memcmp(original, delayed, bytes) == 0;
        checks += 1;
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
    const uint32_t iterations = 25;
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
                    passed &= original_templates(X86_ENCODER_MODE_64, original + 1);
                }
                else
                {
                    passed &= reused_gs_templates(X86_ENCODER_MODE_64, delayed + 1);
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
        printf("GS reuse prototype: %u complete table comparisons pass, %zu bytes each; 21 rotating passes, %u initializations/sample\n", checks, bytes, iterations);
        for (uint32_t variant = 0; variant < 2; variant += 1)
        {
            printf("%s: %.4f instructions/init, %.4f ns/init\n", variant == 0 ? "original" : "GS-reuse", median(instructions[variant]), median(times[variant]));
        }
    }
    else
    {
        fprintf(stderr, "GS experiment failed (full-table equivalence or unmultiplexed hardware counter unavailable)\n");
    }
    if (fd >= 0)
    {
        close(fd);
    }
    passed &= fflush(stdout) == 0 && !ferror(stdout);
    free(original);
    free(delayed);
    return passed ? 0 : 1;
}
