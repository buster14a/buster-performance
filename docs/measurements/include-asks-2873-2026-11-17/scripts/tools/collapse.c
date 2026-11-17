// collapse FILE collapse|check [BEGIN END]: maps FILE read-only at a 2 MB boundary and asks the kernel to collapse each
// whole 2 MB range of it (of its bytes from BEGIN to END, hexadecimal or decimal file offsets, where given) into a huge
// page of the page cache (MADV_COLLAPSE, Linux 6.1; a file's pages need CONFIG_READ_ONLY_THP_FOR_FS), then prints how
// much of the mapping is mapped by huge pages (FilePmdMapped in /proc/self/smaps). With `check`, it only reads a byte of
// each range and prints that count: what a process that maps the file finds in the page cache.
#define _GNU_SOURCE
#include <errno.h>
#include <fcntl.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/mman.h>
#include <sys/stat.h>
#include <unistd.h>

#ifndef MADV_COLLAPSE
#define MADV_COLLAPSE 25
#endif
#define HUGE (2ull << 20)

static uint64_t pmd_mapped_kb(uintptr_t begin, uintptr_t end)
{
    FILE* smaps = fopen("/proc/self/smaps", "r");
    char line[512];
    uint64_t total = 0;
    int inside = 0;
    while (smaps != 0 && fgets(line, sizeof(line), smaps) != 0)
    {
        unsigned long long from = 0;
        unsigned long long to = 0;
        unsigned long long kb = 0;
        if (sscanf(line, "%llx-%llx ", &from, &to) == 2 && strchr(line, '-') < strchr(line, ' '))
        {
            inside = from >= begin && to <= end;
        }
        else if (inside && sscanf(line, "FilePmdMapped: %llu kB", &kb) == 1)
        {
            total += kb;
        }
    }
    if (smaps != 0)
    {
        fclose(smaps);
    }
    return total;
}

int main(int argc, char** argv)
{
    int status = 1;
    const int check = argc >= 3 && strcmp(argv[2], "check") == 0;
    const int valid = argc == 3 || argc == 5;
    const int file = valid ? open(argv[1], O_RDONLY | O_CLOEXEC) : -1;
    struct stat info;
    if (file >= 0 && fstat(file, &info) == 0)
    {
        const uint64_t bytes = (uint64_t)info.st_size;
        const uint64_t limit = argc == 5 ? strtoull(argv[4], 0, 0) : bytes;
        const uint64_t first = argc == 5 ? (strtoull(argv[3], 0, 0) + HUGE - 1) & ~(HUGE - 1) : 0;
        const uint64_t whole = (limit < bytes ? limit : bytes) & ~(HUGE - 1);
        uint8_t* reserved = mmap(0, whole + HUGE, PROT_NONE, MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
        uint8_t* at = (uint8_t*)(((uintptr_t)reserved + HUGE - 1) & ~(uintptr_t)(HUGE - 1));
        uint8_t* mapping = reserved != MAP_FAILED && whole != 0 ? mmap(at, whole, PROT_READ, MAP_PRIVATE | MAP_FIXED, file, 0) : MAP_FAILED;
        if (mapping != MAP_FAILED)
        {
            uint64_t collapsed = 0;
            uint64_t refused = 0;
            int error = 0;
            volatile uint8_t sink = 0;
            for (uint64_t offset = first; offset < whole; offset += HUGE)
            {
                if (check)
                {
                    sink = mapping[offset];
                }
                else if (madvise(mapping + offset, HUGE, MADV_COLLAPSE) == 0)
                {
                    collapsed += 1;
                }
                else
                {
                    refused += 1;
                    error = errno;
                }
            }
            (void)sink;
            printf("%s: %llu ranges of 2 MB from 0x%llx", argv[1], (unsigned long long)(whole > first ? (whole - first) / HUGE : 0), (unsigned long long)first);
            if (!check)
            {
                printf(", %llu collapsed, %llu refused%s%s", (unsigned long long)collapsed, (unsigned long long)refused, refused != 0 ? ": " : "", refused != 0 ? strerror(error) : "");
            }
            printf(", %llu KB mapped by huge pages\n", (unsigned long long)pmd_mapped_kb((uintptr_t)mapping, (uintptr_t)mapping + whole));
            status = 0;
        }
        else
        {
            perror("mmap");
        }
    }
    else
    {
        fprintf(stderr, "usage: collapse FILE collapse|check [BEGIN END]\n");
    }
    return status;
}
