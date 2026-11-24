#define _GNU_SOURCE
#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h>
#include <unistd.h>
#include <sys/mman.h>
#include <sys/stat.h>
int main(int argc, char** argv)
{
    int fd = open(argv[1], O_RDONLY);
    if (fd < 0) { perror("open"); return 1; }
    for (int slot = 0; slot < 8; slot += 1)
    {
        off_t base = (off_t)slot << 40;
        off_t end = base + ((off_t)1 << 40);
        off_t at = base;
        unsigned long long allocated = 0, touched = 0, last = 0;
        while (at < end)
        {
            off_t data = lseek(fd, at, SEEK_DATA);
            if (data < 0 || data >= end) break;
            off_t hole = lseek(fd, data, SEEK_HOLE);
            if (hole > end) hole = end;
            allocated += (unsigned long long)(hole - data);
            size_t length = (size_t)(hole - data);
            unsigned char* map = mmap(0, length, PROT_READ, MAP_SHARED, fd, data);
            unsigned char* vec = malloc(length / 4096 + 1);
            if (map != MAP_FAILED && mincore(map, length, vec) == 0)
            {
                for (size_t i = 0; i < length / 4096; i += 1) { if (vec[i] & 1) { touched += 4096; last = (unsigned long long)(data - base) + i * 4096 + 4096; } }
            }
            munmap(map, length); free(vec);
            at = hole;
        }
        if (allocated) printf("slot %d: allocated %.1f MB, uptodate %.1f MB, last uptodate byte at %.1f MB\n", slot, allocated / 1048576.0, touched / 1048576.0, last / 1048576.0);
    }
    return 0;
}
