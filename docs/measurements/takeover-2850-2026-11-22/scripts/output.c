// output.c OUTPUT BYTES MODE: what writing an object of BYTES costs a fresh process. MODE is `write` (a buffer of new
// anonymous memory filled and written with one write), `mapped` (the file sized and mapped shared, filled in place) or
// `none` (the buffer filled and not written). An experiment for buster#2850's redesign.
#define _GNU_SOURCE
#include <fcntl.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>
#include <sys/mman.h>
#include <unistd.h>

int main(int argc, char** argv)
{
    int status = 1;
    if (argc == 4)
    {
        const uint64_t bytes = strtoull(argv[2], NULL, 10);
        if (strcmp(argv[3], "mapped") == 0)
        {
            const int output = open(argv[1], O_RDWR | O_CREAT | O_TRUNC, 0644);
            if (output >= 0 && ftruncate(output, (off_t)bytes) == 0)
            {
                uint8_t* memory = mmap(NULL, bytes, PROT_READ | PROT_WRITE, MAP_SHARED, output, 0);
                if (memory != MAP_FAILED)
                {
                    memset(memory, 0x5a, bytes);
                    status = 0;
                }
                close(output);
            }
        }
        else
        {
            uint8_t* memory = mmap(NULL, bytes, PROT_READ | PROT_WRITE, MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
            if (memory != MAP_FAILED)
            {
                memset(memory, 0x5a, bytes);
                status = 0;
                if (strcmp(argv[3], "write") == 0)
                {
                    const int output = open(argv[1], O_WRONLY | O_CREAT | O_TRUNC, 0644);
                    status = output >= 0 && write(output, memory, bytes) == (ssize_t)bytes ? 0 : 1;
                    if (output >= 0)
                    {
                        close(output);
                    }
                }
            }
        }
    }
    return status;
}
