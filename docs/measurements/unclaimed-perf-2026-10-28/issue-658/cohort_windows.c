// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Original conservative contamination screen using target children.tsv modification timestamps.
#define _GNU_SOURCE
#include <stdbool.h>
#include <stdio.h>
#include <string.h>
#include <time.h>

typedef struct
{
    char name[256];
    double first;
    double last;
    unsigned records;
} Range;

static double epoch(const char* text)
{
    struct tm parsed = {0};
    const char* end = strptime(text, "%Y-%m-%dT%H:%M:%S", &parsed);
    return end != NULL && *end == 0 ? (double)timegm(&parsed) : 0;
}

static void format(double value, char text[64])
{
    const time_t seconds = (time_t)value;
    struct tm utc;
    gmtime_r(&seconds, &utc);
    strftime(text, 64, "%Y-%m-%dT%H:%M:%S", &utc);
}

int main(int argc, char** argv)
{
    FILE* file = argc == 2 ? fopen(argv[1], "r") : NULL;
    Range ranges[32] = {0};
    unsigned count = 0;
    char path[1024];
    double when = 0;
    while (file != NULL && fscanf(file, "%1023s %lf", path, &when) == 2)
    {
        const size_t end = strcspn(path, "/");
        path[end] = 0;
        unsigned at = 0;
        while (at < count && strcmp(ranges[at].name, path) != 0)
        {
            at += 1;
        }
        if (at == count && count < 32)
        {
            snprintf(ranges[at].name, sizeof(ranges[at].name), "%s", path);
            ranges[at].first = when;
            ranges[at].last = when;
            count += 1;
        }
        if (at < count)
        {
            ranges[at].first = when < ranges[at].first ? when : ranges[at].first;
            ranges[at].last = when > ranges[at].last ? when : ranges[at].last;
            ranges[at].records += 1;
        }
    }
    int result = file == NULL;
    if (file != NULL)
    {
        result |= ferror(file) != 0;
        fclose(file);
    }
    const char* windows[][2] =
    {
        { "2026-10-28T11:46:01", "2026-10-28T11:46:10" },
        { "2026-10-28T11:51:35", "2026-10-28T11:51:44" },
        { "2026-10-28T12:06:56", "2026-10-28T12:07:12" },
        { "2026-10-28T12:08:16", "2026-10-28T12:08:24" },
        { "2026-10-28T12:27:34", "2026-10-28T12:27:44" },
    };
    printf("Conservative campaign bounds: first children.tsv mtime -1 second through last mtime +1 second.\n");
    printf("All cohort wall durations are below 0.3 seconds; one-second margins cover duration and metadata-close latency.\n");
    result |= count != 9;
    for (unsigned i = 0; i < count; i += 1)
    {
        char first[64];
        char last[64];
        format(ranges[i].first - 1, first);
        format(ranges[i].last + 1, last);
        unsigned overlaps = 0;
        for (unsigned w = 0; w < sizeof(windows) / sizeof(windows[0]); w += 1)
        {
            const bool overlap = ranges[i].first - 1 <= epoch(windows[w][1]) && ranges[i].last + 1 >= epoch(windows[w][0]);
            overlaps += overlap;
        }
        printf("%s records=%u %sZ through %sZ overlaps=%u\n", ranges[i].name, ranges[i].records, first, last, overlaps);
        result |= ranges[i].records != 42 || overlaps != 0;
    }
    return result;
}
