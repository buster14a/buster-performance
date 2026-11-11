// #1444 item 3: maps FILE's executable segment at its own alignment and asks MADV_COLLAPSE for its whole 2 MB pages, so
// that the page cache holds them as huge folios; prints the result and the time it took.
#define _GNU_SOURCE
#include <elf.h>
#include <fcntl.h>
#include <stdint.h>
#include <stdio.h>
#include <sys/mman.h>
#include <sys/stat.h>
#include <time.h>
#include <unistd.h>
#include <errno.h>
#include <string.h>

#ifndef MADV_COLLAPSE
#define MADV_COLLAPSE 25
#endif

int main(int argc, char** argv)
{
    int status = 1;
    int fd = argc > 1 ? open(argv[1], O_RDONLY) : -1;
    Elf64_Ehdr header;
    if (fd >= 0 && pread(fd, &header, sizeof(header), 0) == sizeof(header))
    {
        for (int i = 0; i < header.e_phnum; i++)
        {
            Elf64_Phdr segment;
            pread(fd, &segment, sizeof(segment), header.e_phoff + (uint64_t)i * sizeof(segment));
            if (segment.p_type == PT_LOAD && (segment.p_flags & PF_X))
            {
                const uint64_t huge = 2u << 20;
                const uint64_t begin = (segment.p_offset + huge - 1) & ~(huge - 1);
                const uint64_t end = (segment.p_offset + segment.p_filesz) & ~(huge - 1);
                if (end > begin)
                {
                    uint8_t* space = mmap(0, end - begin + huge, PROT_NONE, MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
                    uint8_t* at = (uint8_t*)(((uintptr_t)space + huge - 1) & ~(uintptr_t)(huge - 1));
                    uint8_t* text = mmap(at, end - begin, PROT_READ | PROT_EXEC, MAP_PRIVATE | MAP_FIXED, fd, begin);
                    struct timespec a;
                    struct timespec b;
                    clock_gettime(CLOCK_MONOTONIC, &a);
                    int r = madvise(text, end - begin, MADV_COLLAPSE);
                    int e = errno;
                    clock_gettime(CLOCK_MONOTONIC, &b);
                    printf("collapse %llu MB at offset 0x%llx: %d (%s), %.1f us\n", (unsigned long long)((end - begin) >> 20), (unsigned long long)begin, r, r ? strerror(e) : "ok", (b.tv_sec - a.tv_sec) * 1e6 + (b.tv_nsec - a.tv_nsec) / 1e3);
                    status = r != 0;
                }
            }
        }
    }
    return status;
}
