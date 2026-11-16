// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md of buster14a/buster.
//
// pagecost: what a fresh page costs on this host, by how it is taken (buster14a/buster#2873, item 3). Each case maps,
// touches, reads, writes or unmaps memory in a fresh mapping or file, and counts what its measured part took: the
// kernel's and the user's core cycles (perf_event_open on this thread, exclude_user and exclude_kernel), page faults,
// and nanoseconds. Its set-up and its clean-up are outside the count, except in the cases that measure a teardown.
//
//   pagecost [--reps N] [--megabytes N] [--case NAME]... FILE DIRECTORY
//
// FILE is a file to map and read (its page-cache pages are made resident first, and its size is the file cases'
// bytes); DIRECTORY is where the write cases create and remove `pagecost.out` (a tmpfs and a disk file system give the
// two rows). --megabytes sets the anonymous cases' bytes (64 by default; a multiple of 2). Every rep is a line, then a
// `median` line a case: case, rep, bytes, 4 KB pages, faults, kernel cycles, user cycles, nanoseconds, and per 4 KB
// page and per MB the kernel's cycles and all cycles.
//
// The cases:
//   anon-4k-write          a fresh anonymous mapping in base pages (MAP_STACK: VM_NOHUGEPAGE on Linux 6.7+, and
//                          MADV_NOHUGEPAGE too), a byte written in each 4 KB page: a first touch per page
//   anon-4k-read           the same, a byte read: each read maps the shared zero page
//   anon-4k-read-write     read first (not counted), then written: a write fault over the zero page
//   anon-4k-populate       mmap with MAP_POPULATE, then a byte written in each page: the populate in the mmap
//   anon-4k-populate-write MADV_POPULATE_WRITE over the fresh mapping, then the writes
//   anon-2m-write          a fresh anonymous mapping advised MADV_HUGEPAGE, 2 MB aligned, a byte written in each 2 MB:
//                          the kernel clears the huge page whole
//   anon-2m-read           the same, a byte read in each 2 MB: the huge zero page
//   anon-2m-populate-write MADV_POPULATE_WRITE over the huge-page mapping, then the writes
//   anon-4k-teardown       munmap of a base-page mapping whose every page was written (not counted)
//   anon-2m-teardown       munmap of a huge-page mapping whose every huge page was written
//   anon-4k-discard        MADV_DONTNEED over a written base-page mapping (what the arena pool's release does)
//   file-map               FILE mapped PROT_READ (not counted) and a byte read in each 4 KB page: fault-around maps
//                          up to 16 pages a fault (the kernel's default fault_around_bytes, 64 KB)
//   file-map-single        each 4 KB page of FILE mapped alone, a byte read, unmapped: a fault that maps one page, as
//                          with no fault-around; less file-map-single-empty, the same mappings with no read
//   file-map-single-empty  the mmap and munmap alone of file-map-single
//   file-populate          FILE mapped with MAP_POPULATE, then a byte read in each page (the compiler's way with a
//                          translation unit's source, c_preprocessor.c's file_cache_probe)
//   file-read-fresh        FILE read with pread into a fresh anonymous buffer (huge pages, as an arena's past 64 KB)
//   file-read-reused       the same into a buffer written before (not counted): the copy alone
//   file-write-new         FILE's bytes written with pwrite to DIRECTORY/pagecost.out, newly created, and closed; the
//                          file is removed after (not counted)
//   file-write-over        the same over the file of the rep before (O_TRUNC), as a compile's -o over its last object

#define _GNU_SOURCE
#include <errno.h>
#include <fcntl.h>
#include <inttypes.h>
#include <linux/perf_event.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/ioctl.h>
#include <sys/mman.h>
#include <sys/stat.h>
#include <sys/syscall.h>
#include <time.h>
#include <unistd.h>

#define PAGECOST_PAGE_BYTES 4096ull
#define PAGECOST_HUGE_BYTES (2ull << 20)
#define PAGECOST_MEGABYTE (1ull << 20)
#define PAGECOST_MAX_REPS 64
#define PAGECOST_COUNTERS 3

#ifndef MADV_POPULATE_WRITE
#define MADV_POPULATE_WRITE 23
#endif

typedef struct Counters Counters;
struct Counters
{
    uint64_t kernel_cycles;
    uint64_t user_cycles;
    uint64_t faults;
    uint64_t nanoseconds;
};

typedef struct Meter Meter;
struct Meter
{
    int group;
    Counters start;
};

typedef struct Context Context;
struct Context
{
    Meter meter;
    const char* file;
    const char* directory;
    uint64_t file_bytes;
    uint64_t anonymous_bytes;
    // A resident buffer of FILE's bytes, the write cases' source.
    uint8_t* source;
};

typedef struct Result Result;
struct Result
{
    uint64_t bytes;
    Counters counters;
    bool ok;
};

static volatile uint8_t pagecost_sink;

static int counter_open(uint32_t type, uint64_t config, bool kernel, int group)
{
    struct perf_event_attr attributes;
    memset(&attributes, 0, sizeof(attributes));
    attributes.size = sizeof(attributes);
    attributes.type = type;
    attributes.config = config;
    attributes.disabled = group < 0;
    attributes.exclude_user = kernel;
    attributes.exclude_kernel = !kernel;
    attributes.exclude_hv = 1;
    attributes.read_format = PERF_FORMAT_GROUP;
    const int fd = (int)syscall(SYS_perf_event_open, &attributes, 0, -1, group, 0);
    return fd;
}

static bool meter_open(Meter* meter)
{
    meter->group = counter_open(PERF_TYPE_HARDWARE, PERF_COUNT_HW_CPU_CYCLES, true, -1);
    const int user = meter->group >= 0 ? counter_open(PERF_TYPE_HARDWARE, PERF_COUNT_HW_CPU_CYCLES, false, meter->group) : -1;
    // Faults in either mode: a fault the kernel takes for a copy to or from the user (pread, pwrite) counts too.
    const int faults = user >= 0 ? counter_open(PERF_TYPE_SOFTWARE, PERF_COUNT_SW_PAGE_FAULTS, false, meter->group) : -1;
    const bool ok = faults >= 0 && ioctl(meter->group, PERF_EVENT_IOC_ENABLE, PERF_IOC_FLAG_GROUP) == 0;
    return ok;
}

static Counters meter_read(const Meter* meter)
{
    uint64_t values[1 + PAGECOST_COUNTERS];
    memset(values, 0, sizeof(values));
    struct timespec now;
    clock_gettime(CLOCK_MONOTONIC, &now);
    const ssize_t got = read(meter->group, values, sizeof(values));
    Counters counters = {
        .kernel_cycles = got == (ssize_t)sizeof(values) ? values[1] : 0,
        .user_cycles = got == (ssize_t)sizeof(values) ? values[2] : 0,
        .faults = got == (ssize_t)sizeof(values) ? values[3] : 0,
        .nanoseconds = (uint64_t)now.tv_sec * 1000000000ull + (uint64_t)now.tv_nsec,
    };
    return counters;
}

static void meter_start(Meter* meter)
{
    meter->start = meter_read(meter);
}

static Counters meter_stop(const Meter* meter)
{
    const Counters end = meter_read(meter);
    Counters counters = {
        .kernel_cycles = end.kernel_cycles - meter->start.kernel_cycles,
        .user_cycles = end.user_cycles - meter->start.user_cycles,
        .faults = end.faults - meter->start.faults,
        .nanoseconds = end.nanoseconds - meter->start.nanoseconds,
    };
    return counters;
}

// A fresh anonymous mapping of `bytes`: base pages (MAP_STACK, which Linux 6.7 and later map VM_NOHUGEPAGE, and
// MADV_NOHUGEPAGE besides), or huge pages (2 MB aligned within a larger mapping, MADV_HUGEPAGE). `*mapping` and
// `*mapping_bytes` are what to unmap.
static uint8_t* anonymous_map(uint64_t bytes, bool huge, int extra_flags, void** mapping, uint64_t* mapping_bytes)
{
    const uint64_t length = huge ? bytes + PAGECOST_HUGE_BYTES : bytes;
    const int flags = MAP_PRIVATE | MAP_ANONYMOUS | (huge ? 0 : MAP_STACK) | extra_flags;
    void* base = mmap(0, length, PROT_READ | PROT_WRITE, flags, -1, 0);
    uint8_t* region = 0;
    if (base != MAP_FAILED)
    {
        const uintptr_t start = huge ? (((uintptr_t)base + PAGECOST_HUGE_BYTES - 1) & ~(uintptr_t)(PAGECOST_HUGE_BYTES - 1)) : (uintptr_t)base;
        region = (uint8_t*)start;
        madvise(region, bytes, huge ? MADV_HUGEPAGE : MADV_NOHUGEPAGE);
        *mapping = base;
        *mapping_bytes = length;
    }
    return region;
}

static void touch_write(uint8_t* region, uint64_t bytes, uint64_t stride)
{
    for (uint64_t at = 0; at < bytes; at += stride)
    {
        region[at] = 1;
    }
}

static void touch_read(const uint8_t* region, uint64_t bytes, uint64_t stride)
{
    uint8_t sum = 0;
    for (uint64_t at = 0; at < bytes; at += stride)
    {
        sum += ((const volatile uint8_t*)region)[at];
    }
    pagecost_sink = sum;
}

static Result case_anonymous(Context* context, const char* name)
{
    const uint64_t bytes = context->anonymous_bytes;
    const bool huge = strstr(name, "-2m-") != 0;
    const uint64_t stride = huge ? PAGECOST_HUGE_BYTES : PAGECOST_PAGE_BYTES;
    const bool populate_map = strcmp(name, "anon-4k-populate") == 0;
    const bool populate_write = strstr(name, "populate-write") != 0;
    const bool read_only = strcmp(name, "anon-4k-read") == 0 || strcmp(name, "anon-2m-read") == 0;
    const bool read_first = strcmp(name, "anon-4k-read-write") == 0;
    const bool teardown = strstr(name, "teardown") != 0;
    const bool discard = strstr(name, "discard") != 0;
    void* mapping = 0;
    uint64_t mapping_bytes = 0;
    Result result = { .bytes = bytes };
    if (populate_map)
    {
        meter_start(&context->meter);
        uint8_t* region = anonymous_map(bytes, false, MAP_POPULATE, &mapping, &mapping_bytes);
        if (region != 0)
        {
            touch_write(region, bytes, stride);
        }
        result.counters = meter_stop(&context->meter);
        result.ok = region != 0;
    }
    else
    {
        uint8_t* region = anonymous_map(bytes, huge, 0, &mapping, &mapping_bytes);
        result.ok = region != 0;
        if (region != 0 && (teardown || discard))
        {
            touch_write(region, bytes, PAGECOST_PAGE_BYTES);
        }
        if (region != 0 && read_first)
        {
            touch_read(region, bytes, stride);
        }
        if (region != 0)
        {
            meter_start(&context->meter);
            if (teardown)
            {
                munmap(mapping, mapping_bytes);
                mapping = 0;
            }
            else if (discard)
            {
                madvise(region, bytes, MADV_DONTNEED);
            }
            else if (read_only)
            {
                touch_read(region, bytes, stride);
            }
            else
            {
                if (populate_write)
                {
                    result.ok = madvise(region, bytes, MADV_POPULATE_WRITE) == 0;
                }
                touch_write(region, bytes, stride);
            }
            result.counters = meter_stop(&context->meter);
        }
    }
    if (mapping != 0)
    {
        munmap(mapping, mapping_bytes);
    }
    return result;
}

static Result case_file_map(Context* context, const char* name)
{
    const uint64_t bytes = context->file_bytes;
    const bool populate = strcmp(name, "file-populate") == 0;
    Result result = { .bytes = bytes };
    const int fd = open(context->file, O_RDONLY | O_CLOEXEC);
    if (fd >= 0 && populate)
    {
        meter_start(&context->meter);
        void* mapped = mmap(0, bytes, PROT_READ, MAP_PRIVATE | MAP_POPULATE, fd, 0);
        if (mapped != MAP_FAILED)
        {
            touch_read(mapped, bytes, PAGECOST_PAGE_BYTES);
        }
        result.counters = meter_stop(&context->meter);
        result.ok = mapped != MAP_FAILED;
        if (mapped != MAP_FAILED)
        {
            munmap(mapped, bytes);
        }
    }
    else if (fd >= 0)
    {
        void* mapped = mmap(0, bytes, PROT_READ, MAP_PRIVATE, fd, 0);
        if (mapped != MAP_FAILED)
        {
            meter_start(&context->meter);
            touch_read(mapped, bytes, PAGECOST_PAGE_BYTES);
            result.counters = meter_stop(&context->meter);
            munmap(mapped, bytes);
        }
        result.ok = mapped != MAP_FAILED;
    }
    if (fd >= 0)
    {
        close(fd);
    }
    return result;
}

static Result case_file_single(Context* context, const char* name)
{
    const uint64_t bytes = context->file_bytes & ~(PAGECOST_PAGE_BYTES - 1);
    const bool read = strcmp(name, "file-map-single") == 0;
    Result result = { .bytes = bytes, .ok = true };
    const int fd = open(context->file, O_RDONLY | O_CLOEXEC);
    result.ok = fd >= 0;
    if (fd >= 0)
    {
        meter_start(&context->meter);
        for (uint64_t at = 0; at < bytes && result.ok; at += PAGECOST_PAGE_BYTES)
        {
            void* mapped = mmap(0, PAGECOST_PAGE_BYTES, PROT_READ, MAP_PRIVATE, fd, (off_t)at);
            result.ok = mapped != MAP_FAILED;
            if (result.ok && read)
            {
                pagecost_sink = *(const volatile uint8_t*)mapped;
            }
            if (result.ok)
            {
                munmap(mapped, PAGECOST_PAGE_BYTES);
            }
        }
        result.counters = meter_stop(&context->meter);
        close(fd);
    }
    return result;
}

static Result case_file_read(Context* context, const char* name)
{
    const uint64_t bytes = context->file_bytes;
    const bool reused = strcmp(name, "file-read-reused") == 0;
    void* mapping = 0;
    uint64_t mapping_bytes = 0;
    Result result = { .bytes = bytes };
    uint8_t* buffer = anonymous_map((bytes + PAGECOST_HUGE_BYTES - 1) & ~(PAGECOST_HUGE_BYTES - 1), true, 0, &mapping, &mapping_bytes);
    const int fd = open(context->file, O_RDONLY | O_CLOEXEC);
    result.ok = buffer != 0 && fd >= 0;
    if (result.ok)
    {
        if (reused)
        {
            touch_write(buffer, bytes, PAGECOST_PAGE_BYTES);
        }
        meter_start(&context->meter);
        uint64_t done = 0;
        ssize_t got = 1;
        while (done < bytes && got > 0)
        {
            got = pread(fd, buffer + done, bytes - done, (off_t)done);
            done += got > 0 ? (uint64_t)got : 0;
        }
        result.counters = meter_stop(&context->meter);
        result.ok = done == bytes;
    }
    if (fd >= 0)
    {
        close(fd);
    }
    if (mapping != 0)
    {
        munmap(mapping, mapping_bytes);
    }
    return result;
}

static Result case_file_write(Context* context, const char* name, bool* exists)
{
    const uint64_t bytes = context->file_bytes;
    const bool over = strcmp(name, "file-write-over") == 0;
    char path[4096];
    snprintf(path, sizeof(path), "%s/pagecost.out", context->directory);
    Result result = { .bytes = bytes };
    if (!over && *exists)
    {
        unlink(path);
        *exists = false;
    }
    if (over && !*exists)
    {
        // The rep before's file, for the first rep: written and closed, not counted.
        const int fd = open(path, O_WRONLY | O_CREAT | O_TRUNC | O_CLOEXEC, 0644);
        const ssize_t wrote = fd >= 0 ? pwrite(fd, context->source, bytes, 0) : -1;
        *exists = fd >= 0 && wrote == (ssize_t)bytes;
        if (fd >= 0)
        {
            close(fd);
        }
    }
    meter_start(&context->meter);
    const int fd = open(path, O_WRONLY | O_CREAT | O_TRUNC | O_CLOEXEC, 0644);
    uint64_t done = 0;
    ssize_t wrote = 1;
    while (fd >= 0 && done < bytes && wrote > 0)
    {
        wrote = pwrite(fd, context->source + done, bytes - done, (off_t)done);
        done += wrote > 0 ? (uint64_t)wrote : 0;
    }
    if (fd >= 0)
    {
        close(fd);
    }
    result.counters = meter_stop(&context->meter);
    result.ok = fd >= 0 && done == bytes;
    *exists = fd >= 0;
    if (!over && fd >= 0)
    {
        unlink(path);
        *exists = false;
    }
    return result;
}

static int compare_u64(const void* a, const void* b)
{
    const uint64_t x = *(const uint64_t*)a;
    const uint64_t y = *(const uint64_t*)b;
    return (x > y) - (x < y);
}

static uint64_t median_u64(uint64_t* values, uint32_t count)
{
    qsort(values, count, sizeof(values[0]), compare_u64);
    return count == 0 ? 0 : values[count / 2];
}

static void print_line(const char* name, const char* rep, uint64_t bytes, Counters counters)
{
    const double pages = (double)bytes / (double)PAGECOST_PAGE_BYTES;
    const double megabytes = (double)bytes / (double)PAGECOST_MEGABYTE;
    const double all = (double)(counters.kernel_cycles + counters.user_cycles);
    printf("%s\t%s\t%" PRIu64 "\t%.0f\t%" PRIu64 "\t%" PRIu64 "\t%" PRIu64 "\t%" PRIu64 "\t%.1f\t%.1f\t%.0f\t%.0f\n", name, rep, bytes, pages,
           counters.faults, counters.kernel_cycles, counters.user_cycles, counters.nanoseconds, (double)counters.kernel_cycles / pages, all / pages,
           (double)counters.kernel_cycles / megabytes, all / megabytes);
}

static const char* const pagecost_cases[] = {
    "anon-4k-write",
    "anon-4k-read",
    "anon-4k-read-write",
    "anon-4k-populate",
    "anon-4k-populate-write",
    "anon-2m-write",
    "anon-2m-read",
    "anon-2m-populate-write",
    "anon-4k-teardown",
    "anon-2m-teardown",
    "anon-4k-discard",
    "file-map",
    "file-map-single",
    "file-map-single-empty",
    "file-populate",
    "file-read-fresh",
    "file-read-reused",
    "file-write-new",
    "file-write-over",
};

#define PAGECOST_CASES (sizeof(pagecost_cases) / sizeof(pagecost_cases[0]))

int main(int argc, char** argv)
{
    uint32_t reps = 7;
    uint64_t megabytes = 64;
    bool selected[PAGECOST_CASES];
    bool any_selected = false;
    memset(selected, 0, sizeof(selected));
    int status = 0;
    int at = 1;
    while (at + 1 < argc && strncmp(argv[at], "--", 2) == 0)
    {
        if (strcmp(argv[at], "--reps") == 0)
        {
            reps = (uint32_t)strtoul(argv[at + 1], 0, 10);
        }
        else if (strcmp(argv[at], "--megabytes") == 0)
        {
            megabytes = strtoull(argv[at + 1], 0, 10);
        }
        else if (strcmp(argv[at], "--case") == 0)
        {
            for (uint32_t c = 0; c < PAGECOST_CASES; c += 1)
            {
                selected[c] |= strcmp(argv[at + 1], pagecost_cases[c]) == 0;
            }
            any_selected = true;
        }
        at += 2;
    }
    Context context = {
        .file = at < argc ? argv[at] : 0,
        .directory = at + 1 < argc ? argv[at + 1] : 0,
        .anonymous_bytes = megabytes * PAGECOST_MEGABYTE,
    };
    struct stat stats;
    const bool usable = context.file != 0 && context.directory != 0 && stat(context.file, &stats) == 0 && reps >= 1 && reps <= PAGECOST_MAX_REPS &&
                        megabytes >= 2 && megabytes % 2 == 0 && meter_open(&context.meter);
    if (!usable)
    {
        fprintf(stderr, "usage: pagecost [--reps N (1-%d)] [--megabytes N (even)] [--case NAME]... FILE DIRECTORY; perf_event_open must be "
                        "allowed\n",
                PAGECOST_MAX_REPS);
        status = 2;
    }
    if (usable)
    {
        context.file_bytes = (uint64_t)stats.st_size;
        context.source = malloc(context.file_bytes);
        const int fd = open(context.file, O_RDONLY | O_CLOEXEC);
        uint64_t done = 0;
        ssize_t got = 1;
        while (fd >= 0 && context.source != 0 && done < context.file_bytes && got > 0)
        {
            got = pread(fd, context.source + done, context.file_bytes - done, (off_t)done);
            done += got > 0 ? (uint64_t)got : 0;
        }
        if (fd >= 0)
        {
            close(fd);
        }
        status = done == context.file_bytes ? 0 : 1;
        printf("case\trep\tbytes\tpages\tfaults\tkernel-cycles\tuser-cycles\tns\tkernel-cycles-a-page\tcycles-a-page\tkernel-cycles-a-mb\tcycles-a-mb\n");
        bool exists = false;
        for (uint32_t c = 0; c < PAGECOST_CASES && status == 0; c += 1)
        {
            const char* name = pagecost_cases[c];
            const bool run = !any_selected || selected[c];
            uint64_t kernel[PAGECOST_MAX_REPS];
            uint64_t user[PAGECOST_MAX_REPS];
            uint64_t faults[PAGECOST_MAX_REPS];
            uint64_t nanoseconds[PAGECOST_MAX_REPS];
            uint64_t bytes = 0;
            for (uint32_t r = 0; r < reps && run && status == 0; r += 1)
            {
                Result result;
                if (strncmp(name, "anon-", 5) == 0)
                {
                    result = case_anonymous(&context, name);
                }
                else if (strcmp(name, "file-map") == 0 || strcmp(name, "file-populate") == 0)
                {
                    result = case_file_map(&context, name);
                }
                else if (strncmp(name, "file-map-single", 15) == 0)
                {
                    result = case_file_single(&context, name);
                }
                else if (strncmp(name, "file-read", 9) == 0)
                {
                    result = case_file_read(&context, name);
                }
                else
                {
                    result = case_file_write(&context, name, &exists);
                }
                status = result.ok ? 0 : 1;
                char rep[16];
                snprintf(rep, sizeof(rep), "%u", r);
                print_line(name, rep, result.bytes, result.counters);
                kernel[r] = result.counters.kernel_cycles;
                user[r] = result.counters.user_cycles;
                faults[r] = result.counters.faults;
                nanoseconds[r] = result.counters.nanoseconds;
                bytes = result.bytes;
            }
            if (run && status == 0)
            {
                const Counters median = {
                    .kernel_cycles = median_u64(kernel, reps),
                    .user_cycles = median_u64(user, reps),
                    .faults = median_u64(faults, reps),
                    .nanoseconds = median_u64(nanoseconds, reps),
                };
                print_line(name, "median", bytes, median);
            }
            if (status != 0)
            {
                fprintf(stderr, "pagecost: %s failed: %s\n", name, strerror(errno));
            }
        }
        if (exists)
        {
            char path[4096];
            snprintf(path, sizeof(path), "%s/pagecost.out", context.directory);
            unlink(path);
        }
        free(context.source);
    }
    return status;
}
