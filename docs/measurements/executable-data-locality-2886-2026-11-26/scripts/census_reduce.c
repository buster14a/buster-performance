// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
// Summarize this record's datapages TSVs, retaining pagemap present/exclusive distinctions.
// Usage: census_reduce DIRECTORY OUTPUT.tsv. Reads INPUT-MODE-ROUND.tsv.gz files, including hyphenated INPUT names.
// Page addresses are deduplicated separately for BSS, baked, relocated data, and their sealed union.
#define _GNU_SOURCE
#include <dirent.h>
#include <errno.h>
#include <fcntl.h>
#include <inttypes.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <unistd.h>

#define PAGE_LIMIT 65536

typedef struct Page Page;
struct Page
{
    uint64_t address;
    unsigned file;
    unsigned exclusive;
};

typedef struct Group Group;
struct Group
{
    Page pages[PAGE_LIMIT];
    size_t count;
};

static int page_order(const void* left, const void* right)
{
    const uint64_t a = ((const Page*)left)->address;
    const uint64_t b = ((const Page*)right)->address;
    return a < b ? -1 : a > b;
}

static bool print_group(FILE* output, Group* group)
{
    qsort(group->pages, group->count, sizeof(Page), page_order);
    uint64_t previous = UINT64_MAX;
    uint64_t last_window = UINT64_MAX;
    uint64_t last_range = UINT64_MAX;
    unsigned present = 0, anonymous = 0, exclusive = 0, windows = 0, ranges = 0;
    bool good = true;
    for (size_t index = 0; index < group->count; index += 1)
    {
        const Page page = group->pages[index];
        if (previous == page.address)
        {
            good = good && group->pages[index - 1].file == page.file && group->pages[index - 1].exclusive == page.exclusive;
            continue;
        }
        present += 1;
        anonymous += !page.file;
        exclusive += page.exclusive;
        windows += page.address >> 16 != last_window;
        ranges += page.address >> 21 != last_range;
        previous = page.address;
        last_window = page.address >> 16;
        last_range = page.address >> 21;
    }
    fprintf(output, "\t%u\t%u\t%u\t%u\t%u", present, anonymous, exclusive, windows, ranges);
    return good;
}

static bool reduce_file(const char* directory, const char* filename, FILE* output)
{
    char identity[512];
    char path[4096];
    snprintf(identity, sizeof(identity), "%s", filename);
    identity[strlen(identity) - 7] = 0;
    char* round = strrchr(identity, '-');
    bool good = round && round[1];
    if (good) *round++ = 0;
    char* mode = good ? strrchr(identity, '-') : NULL;
    good = good && mode && mode[1];
    if (good) *mode++ = 0;
    const int length = snprintf(path, sizeof(path), "%s/%s", directory, filename);
    good = good && length > 0 && (size_t)length < sizeof(path);
    int channel[2];
    good = good && pipe2(channel, O_CLOEXEC) == 0;
    pid_t child = good ? fork() : -1;
    if (child == 0)
    {
        dup2(channel[1], STDOUT_FILENO);
        execlp("gzip", "gzip", "-cd", "--", path, (char*)NULL);
        _exit(125);
    }
    FILE* input = NULL;
    if (good)
    {
        close(channel[1]);
        input = fdopen(channel[0], "r");
        if (!input) close(channel[0]);
    }
    Group* groups = good ? calloc(4, sizeof(Group)) : NULL;
    good = good && child > 0 && input && groups;
    int base = -1, thp = -1, census = -1, status = -1, reaped = -1, descendant = -1;
    long minor = -1, major = -1, descendant_minor = -1;
    size_t pages_seen = 0;
    char* line = NULL;
    size_t capacity = 0;
    while (good && getline(&line, &capacity, input) >= 0)
    {
        char section[128];
        uint64_t address;
        unsigned present, file, exclusive, dirty, swapped;
        if (sscanf(line, "PAGE\t%127s\t%" SCNx64 "\t%u\t%u\t%u\t%u\t%u", section, &address, &present, &file, &exclusive, &dirty, &swapped) == 7)
        {
            pages_seen += 1;
            const int group = !strncmp(section, ".bss", 4) ? 0 : !strcmp(section, "buster_baked") ? 1 :
                              !strcmp(section, ".data.rel.ro.buster") ? 2 : -1;
            if (present && group >= 0)
            {
                good = groups[group].count < PAGE_LIMIT;
                if (good) groups[group].pages[groups[group].count++] = (Page){ address, file, exclusive };
                if (group > 0)
                {
                    good = good && groups[3].count < PAGE_LIMIT;
                    if (good) groups[3].pages[groups[3].count++] = (Page){ address, file, exclusive };
                }
            }
        }
        else if (sscanf(line, "BASE_PAGES_CONTROL\t%d", &base) == 1) { }
        else if (sscanf(line, "THP_DISABLE_BEFORE_EXEC\t%d", &thp) == 1) { }
        else if (sscanf(line, "CENSUS_OK\t%d", &census) == 1) { }
        else if (sscanf(line, "EXIT_STATUS\t%d", &status) == 1) { }
        else if (sscanf(line, "REAPED_DESCENDANTS\t%d", &reaped) == 1) { }
        else if (sscanf(line, "DESCENDANT_STATUS\t%d", &descendant) == 1) { }
        else if (sscanf(line, "RUSAGE_MINOR_FAULTS\t%ld", &minor) == 1) { }
        else if (sscanf(line, "RUSAGE_MAJOR_FAULTS\t%ld", &major) == 1) { }
        else if (sscanf(line, "DESCENDANT_MINOR_FAULTS\t%ld", &descendant_minor) == 1) { }
    }
    good = good && !ferror(input);
    if (input) fclose(input);
    int gzip_status = 125 << 8;
    pid_t waited = -1;
    if (child > 0)
    {
        do { waited = waitpid(child, &gzip_status, 0); } while (waited < 0 && errno == EINTR);
    }
    good = good && waited == child && WIFEXITED(gzip_status) && WEXITSTATUS(gzip_status) == 0;
    if (good)
    {
        fprintf(output, "%s\t%s\t%s", identity, mode, round);
        for (unsigned group = 0; group < 4; group += 1)
        {
            good = print_group(output, groups + group) && good;
        }
        fprintf(output, "\t%d\t%d\t%d\t%d\t%d\t%d\t%ld\t%ld\t%ld\n", base, thp, census, status, reaped, descendant, minor, major, descendant_minor);
    }
    good = good && pages_seen > 0 && base == 1 && thp == 1 && census == 1 && status == 0 && reaped == 1 && descendant == 137 && minor >= 0 && major >= 0 && descendant_minor >= 0;
    if (!good) fprintf(stderr, "invalid or incomplete census: %s\n", path);
    free(line);
    free(groups);
    return good;
}

static int census_file(const struct dirent* entry)
{
    const size_t length = strlen(entry->d_name);
    return length > 7 && length < 512 && !strcmp(entry->d_name + length - 7, ".tsv.gz");
}

int main(int argc, char** argv)
{
    struct dirent** entries = NULL;
    const int count = argc == 3 ? scandir(argv[1], &entries, census_file, alphasort) : -1;
    FILE* output = count > 0 ? fopen(argv[2], "w") : NULL;
    bool good = count > 0 && output;
    if (good)
    {
        fprintf(output, "input\tmode\tround");
        const char* names[] = { "bss", "baked", "relro", "sealed" };
        for (unsigned group = 0; group < 4; group += 1)
        {
            fprintf(output, "\t%s_present\t%s_anonymous\t%s_exclusive\t%s_windows_64K\t%s_ranges_2M", names[group], names[group], names[group], names[group], names[group]);
        }
        fprintf(output, "\tbase_pages_control\tthp_disable_before_exec\tcensus_ok\texit_status\treaped_descendants\tdescendant_status\tchild_minor_faults\tchild_major_faults\tdescendant_minor_faults\n");
    }
    for (int index = 0; index < count; index += 1)
    {
        if (output) good = reduce_file(argv[1], entries[index]->d_name, output) && good;
        free(entries[index]);
    }
    free(entries);
    if (output) good = fclose(output) == 0 && good;
    if (!good) fprintf(stderr, "usage: census_reduce DIRECTORY OUTPUT.tsv; at least one valid controlled census is required\n");
    return good ? 0 : 1;
}
