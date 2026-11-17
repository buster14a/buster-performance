// probecost.c: what the include search's file system calls cost on this machine, for buster#2873's files' rows.
// Each row is one call (or a short sequence) repeated REPEATS times after WARM warm-ups, its TSC ticks read around each
// repetition; the row prints the median, the least and the 90th percentile in ticks, and the median in cycles at the
// ratio given (cycles a tick). The dentry cache is warm from the warm-ups, as it is for a compile's later probes of the
// same directories.
//
//   probecost SEARCH_DIRECTORY MISSING_SUBDIRECTORY_PATH MISSING_FILE PRESENT_DIRECTORY PRESENT_FILE [CYCLES_A_TICK]
//
//   SEARCH_DIRECTORY           a large search directory (clang's resource directory)
//   MISSING_SUBDIRECTORY_PATH  a path relative to it whose first component it does not have (bits/types.h)
//   MISSING_FILE               a name it does not have, with no slash (nosuch-buster.h)
//   PRESENT_DIRECTORY          a search directory that has PRESENT_FILE (/usr/include)
//   PRESENT_FILE               a header there (stdio.h)
#define _GNU_SOURCE
#include <errno.h>
#include <fcntl.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>
#include <sys/syscall.h>
#include <unistd.h>
#include <x86intrin.h>

#define REPEATS 4000u
#define WARM 200u

static uint64_t ticks[REPEATS];
static double cycles_a_tick = 1.0;

static int compare_ticks(const void* a, const void* b)
{
    const uint64_t x = *(const uint64_t*)a;
    const uint64_t y = *(const uint64_t*)b;
    return x < y ? -1 : x > y ? 1 : 0;
}

static void report(const char* name, int64_t result)
{
    qsort(ticks, REPEATS, sizeof(ticks[0]), compare_ticks);
    const uint64_t median = ticks[REPEATS / 2];
    printf("%-78s median %6llu ticks (%7.0f cycles), least %6llu, 90th percentile %6llu; last result %lld\n", name, (unsigned long long)median,
           (double)median * cycles_a_tick, (unsigned long long)ticks[0], (unsigned long long)ticks[REPEATS * 9 / 10], (long long)result);
}

// One open of `path` at `directory` with `flags`, closed where it opened: the result of the open (an fd or -errno).
static int64_t open_once(int directory, const char* path, int flags)
{
    const int fd = openat(directory, path, flags);
    const int64_t result = fd < 0 ? -(int64_t)errno : fd;
    if (fd >= 0)
    {
        close(fd);
    }
    return result;
}

static void row_open(const char* name, int directory, const char* path, int flags)
{
    int64_t result = 0;
    for (uint32_t i = 0; i < WARM + REPEATS; i += 1)
    {
        const uint64_t start = __rdtsc();
        result = open_once(directory, path, flags);
        const uint64_t end = __rdtsc();
        if (i >= WARM)
        {
            ticks[i - WARM] = end - start;
        }
    }
    report(name, result);
}

static void row_stat(const char* name, int directory, const char* path)
{
    int64_t result = 0;
    struct stat status;
    for (uint32_t i = 0; i < WARM + REPEATS; i += 1)
    {
        const uint64_t start = __rdtsc();
        result = fstatat(directory, path, &status, 0) != 0 ? -(int64_t)errno : 0;
        const uint64_t end = __rdtsc();
        if (i >= WARM)
        {
            ticks[i - WARM] = end - start;
        }
    }
    report(name, result);
}

// A look at a directory's names: opened, read with a buffer of `buffer_bytes` either once (`whole` false, the first look)
// or to its end, and closed. The result is the names read.
static void row_list(const char* name, const char* path, uint32_t buffer_bytes, int whole)
{
    static char buffer[1u << 16];
    int64_t names = 0;
    for (uint32_t i = 0; i < WARM + REPEATS; i += 1)
    {
        const uint64_t start = __rdtsc();
        const int fd = openat(AT_FDCWD, path, O_RDONLY | O_NOCTTY | O_NONBLOCK | O_CLOEXEC | O_DIRECTORY);
        names = 0;
        if (fd >= 0)
        {
            long bytes = 0;
            do
            {
                bytes = syscall(SYS_getdents64, fd, buffer, buffer_bytes);
                for (long at = 0; at < bytes;)
                {
                    const unsigned short length = *(const unsigned short*)(const void*)(buffer + at + 16);
                    names += 1;
                    at += length;
                }
            } while (whole && bytes > 0);
            close(fd);
        }
        else
        {
            names = -(int64_t)errno;
        }
        const uint64_t end = __rdtsc();
        if (i >= WARM)
        {
            ticks[i - WARM] = end - start;
        }
    }
    report(name, names);
}

int main(int argc, char** argv)
{
    int status = 1;
    if (argc >= 6)
    {
        const char* search = argv[1];
        const char* missing_path = argv[2];
        const char* missing_file = argv[3];
        const char* present_directory = argv[4];
        const char* present_file = argv[5];
        cycles_a_tick = argc >= 7 ? atof(argv[6]) : 1.0;
        char path[4096];
        char component[4096];
        const int flags = O_RDONLY | O_NOCTTY | O_CLOEXEC;
        const int search_fd = openat(AT_FDCWD, search, O_PATH | O_DIRECTORY | O_CLOEXEC);
        const int present_fd = openat(AT_FDCWD, present_directory, O_PATH | O_DIRECTORY | O_CLOEXEC);
        const char* slash = strchr(missing_path, '/');
        snprintf(component, sizeof(component), "%.*s", slash != NULL ? (int)(slash - missing_path) : (int)strlen(missing_path), missing_path);
        if (search_fd >= 0 && present_fd >= 0)
        {
            snprintf(path, sizeof(path), "%s/%s", search, missing_path);
            row_open("a failed open: a whole path, under a subdirectory the search directory lacks", AT_FDCWD, path, flags);
            row_open("a failed open: the same path from the search directory's descriptor", search_fd, missing_path, flags);
            snprintf(path, sizeof(path), "%s/%s", search, missing_file);
            row_open("a failed open: a whole path, a name the search directory lacks", AT_FDCWD, path, flags);
            row_open("a failed open: the same name from the search directory's descriptor", search_fd, missing_file, flags);
            snprintf(path, sizeof(path), "%s/%s", search, component);
            row_open("a failed open of the lacking subdirectory itself (O_PATH | O_DIRECTORY), a whole path", AT_FDCWD, path, O_PATH | O_DIRECTORY | O_CLOEXEC);
            row_open("a failed open of the lacking subdirectory itself, from the descriptor", search_fd, component, O_PATH | O_DIRECTORY | O_CLOEXEC);
            snprintf(path, sizeof(path), "%s/%s", search, missing_path);
            row_stat("a failed stat: a whole path, under a subdirectory the search directory lacks", AT_FDCWD, path);
            snprintf(path, sizeof(path), "%s/%s", present_directory, present_file);
            row_open("an open and close of a header: a whole path", AT_FDCWD, path, flags);
            row_open("an open and close of a header: from its directory's descriptor", present_fd, present_file, flags);
            row_stat("a stat of a header: a whole path", AT_FDCWD, path);
            row_list("a first look at the search directory's names (1 KB, one read)", search, 1024, 0);
            row_list("the search directory's names read whole (8 KB a read)", search, 8192, 1);
            row_list("a first look at /usr/local/include's names (1 KB, one read)", "/usr/local/include", 1024, 0);
            row_list("the header's directory's names read whole (8 KB a read)", present_directory, 8192, 1);
            status = 0;
        }
        else
        {
            fprintf(stderr, "probecost: cannot open %s or %s\n", search, present_directory);
        }
    }
    else
    {
        fprintf(stderr, "usage: probecost SEARCH_DIRECTORY MISSING_SUBDIRECTORY_PATH MISSING_FILE PRESENT_DIRECTORY PRESENT_FILE [CYCLES_A_TICK]\n");
    }
    return status;
}
