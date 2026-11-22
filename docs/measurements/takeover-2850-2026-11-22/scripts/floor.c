// floor.c SOURCE OUTPUT FRESH_MB OBJECT_BYTES PAGES: the fixed costs of a compile that maps its source, reads every byte of
// it once, touches FRESH_MB megabytes of new anonymous memory and writes OBJECT_BYTES to OUTPUT. PAGES is `huge` (the
// fresh memory advised huge pages), `base` (advised none) or `system` (as the system has them). An experiment for
// buster#2850's redesign: what a streaming compile would still pay the kernel and the process.
#define _GNU_SOURCE
#include <fcntl.h>
#include <immintrin.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/mman.h>
#include <sys/stat.h>
#include <unistd.h>

int main(int argc, char** argv)
{
    int status = 1;
    if (argc == 6)
    {
        const uint64_t fresh = strtoull(argv[3], NULL, 10) << 20;
        const uint64_t object = strtoull(argv[4], NULL, 10);
        const int source = open(argv[1], O_RDONLY);
        struct stat information;
        if (source >= 0 && fstat(source, &information) == 0)
        {
            const uint64_t size = (uint64_t)information.st_size;
            const uint8_t* bytes = mmap(NULL, size, PROT_READ, MAP_PRIVATE, source, 0);
            uint64_t lines = 0;
            if (bytes != MAP_FAILED)
            {
                const __m512i newline = _mm512_set1_epi8('\n');
                uint64_t at = 0;
                for (; at + 64 <= size; at += 64)
                {
                    lines += (uint64_t)__builtin_popcountll(_mm512_cmpeq_epi8_mask(_mm512_loadu_si512(bytes + at), newline));
                }
                for (; at < size; at += 1)
                {
                    lines += bytes[at] == '\n';
                }
            }
            const uint64_t room = fresh > object ? fresh : object;
            uint8_t* memory = room != 0 ? mmap(NULL, room, PROT_READ | PROT_WRITE, MAP_PRIVATE | MAP_ANONYMOUS, -1, 0) : NULL;
            if (memory != MAP_FAILED && memory != NULL)
            {
                if (strcmp(argv[5], "huge") == 0)
                {
                    madvise(memory, room, MADV_HUGEPAGE);
                }
                else if (strcmp(argv[5], "base") == 0)
                {
                    madvise(memory, room, MADV_NOHUGEPAGE);
                }
                // Every page written once, a byte a line of 64: what a compile's columns' first stores cost.
                for (uint64_t at = 0; at < room; at += 64)
                {
                    memory[at] = (uint8_t)(lines + at);
                }
            }
            if (object != 0 && memory != MAP_FAILED && memory != NULL)
            {
                const int output = open(argv[2], O_WRONLY | O_CREAT | O_TRUNC, 0644);
                if (output >= 0)
                {
                    status = write(output, memory, object) == (ssize_t)object ? 0 : 1;
                    close(output);
                }
            }
            else
            {
                status = lines != 0 ? 0 : 1;
            }
        }
    }
    return status;
}
