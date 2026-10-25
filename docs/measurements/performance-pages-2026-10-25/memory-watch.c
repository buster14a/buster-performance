/* Original read-only Linux process-memory observer. It never controls the
 * browser. The caller identifies the observed process independently.
 * SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception */
#define _POSIX_C_SOURCE 200809L
#include <errno.h>
#include <inttypes.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>

static bool watch_number(const char *text, uint64_t *number)
{
    errno = 0;
    char *end = NULL;
    unsigned long long value = strtoull(text, &end, 10);
    bool result = text[0] >= '0' && text[0] <= '9' && end != text && *end == 0 && errno == 0;
    *number = (uint64_t)value;
    return result;
}

static uint64_t watch_now(void)
{
    struct timespec value = {0};
    bool valid = clock_gettime(CLOCK_MONOTONIC, &value) == 0 && value.tv_sec >= 0;
    uint64_t result = valid ? (uint64_t)value.tv_sec * UINT64_C(1000000000) + (uint64_t)value.tv_nsec : 0;
    return result;
}

static bool watch_status(uint64_t pid, uint64_t *resident, uint64_t *highwater)
{
    char path[80];
    snprintf(path, sizeof(path), "/proc/%" PRIu64 "/status", pid);
    FILE *input = fopen(path, "r");
    bool rss = false;
    bool hwm = false;
    char line[512];
    size_t lines = 0;
    while (input != NULL && fgets(line, sizeof(line), input) != NULL && ++lines < 256)
    {
        rss = rss || sscanf(line, "VmRSS: %" SCNu64 " kB", resident) == 1;
        hwm = hwm || sscanf(line, "VmHWM: %" SCNu64 " kB", highwater) == 1;
    }
    bool result = input != NULL && !ferror(input) && rss && hwm;
    if (input != NULL)
    {
        result = fclose(input) == 0 && result;
    }
    return result;
}

static bool watch_identity(uint64_t pid, uint64_t *start_ticks)
{
    char path[80];
    snprintf(path, sizeof(path), "/proc/%" PRIu64 "/stat", pid);
    FILE *input = fopen(path, "r");
    char line[4096];
    bool result = input != NULL && fgets(line, sizeof(line), input) != NULL;
    char *cursor = result ? strrchr(line, ')') : NULL;
    result = result && cursor != NULL && cursor[1] == ' ';
    if (result)
    {
        cursor += 2;
        for (unsigned int field = 3; field < 22 && result; ++field)
        {
            cursor = strchr(cursor, ' ');
            result = cursor != NULL;
            cursor = result ? cursor + 1 : NULL;
        }
        if (result)
        {
            char *end = strchr(cursor, ' ');
            result = end != NULL;
            if (result)
            {
                *end = 0;
                result = watch_number(cursor, start_ticks);
            }
        }
    }
    if (input != NULL)
    {
        result = fclose(input) == 0 && result;
    }
    return result;
}

int main(int argc, char **argv)
{
    uint64_t pid = 0;
    uint64_t seconds = 0;
    uint64_t identity = 0;
    uint64_t rss = 0;
    uint64_t hwm = 0;
    bool valid = argc == 4 && watch_number(argv[1], &pid) && pid > 0 && pid <= INT32_MAX && watch_number(argv[2], &seconds) && seconds > 0 && seconds <= 60 && watch_identity(pid, &identity) && watch_status(pid, &rss, &hwm);
    uint64_t initial_rss = rss;
    uint64_t initial_hwm = hwm;
    uint64_t peak = rss;
    uint64_t samples = 0;
    uint64_t start = valid ? watch_now() : 0;
    valid = valid && start != 0;
    uint64_t now = start;
    while (valid && now - start < seconds * UINT64_C(1000000000) && samples < 6000)
    {
        valid = watch_status(pid, &rss, &hwm);
        peak = peak > rss ? peak : rss;
        ++samples;
        struct timespec pause = {.tv_sec = 0, .tv_nsec = 20000000};
        while (nanosleep(&pause, &pause) < 0 && errno == EINTR)
        {
        }
        now = watch_now();
        valid = valid && now >= start && now != 0;
    }
    uint64_t final_identity = 0;
    valid = valid && watch_identity(pid, &final_identity) && final_identity == identity;
    FILE *output = valid ? fopen(argv[3], "wx") : NULL;
    valid = valid && output != NULL;
    if (output != NULL)
    {
        valid = fprintf(output, "{\"first_party\":true,\"observed_pid\":\"%" PRIu64 "\",\"process_start_ticks\":\"%" PRIu64 "\",\"clock\":\"CLOCK_MONOTONIC\",\"start_ns\":\"%" PRIu64 "\",\"end_ns\":\"%" PRIu64 "\",\"sample_period_ms\":20,\"samples\":\"%" PRIu64 "\",\"initial_rss_kib\":\"%" PRIu64 "\",\"initial_process_highwater_kib\":\"%" PRIu64 "\",\"observed_peak_rss_kib\":\"%" PRIu64 "\",\"final_process_highwater_kib\":\"%" PRIu64 "\",\"final_rss_kib\":\"%" PRIu64 "\",\"scope\":\"Whole caller-identified process. Process identity is checked against PID reuse; page and worker attribution must be established separately. Excludes other browser, GPU and network service processes. Linux VmHWM includes lifetime before this interval; RSS sampling can miss shorter spikes. Not a per-table or arbitrary-capture memory cap.\"}\n", pid, identity, start, now, samples, initial_rss, initial_hwm, peak, hwm, rss) > 0;
        valid = fclose(output) == 0 && valid;
    }
    if (!valid)
    {
        fputs("memory-watch: missing/reused process or invalid read; no accepted memory receipt\nusage: memory-watch PID SECONDS NEW_OUTPUT.json\n", stderr);
    }
    return valid ? 0 : 1;
}
