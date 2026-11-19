// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Generate a complete assembly input. N counts .file directives, including file zero in DWARF 5.
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

static void write_input(const char* shape, int count)
{
    const bool repeated = strcmp(shape, "repeated") == 0;
    const bool mixed = strcmp(shape, "mixed") == 0;
    const bool dwarf3 = strcmp(shape, "dwarf3") == 0;
    const bool bare = strcmp(shape, "bare") == 0;
    const char* md5 = mixed ? " md5 0x0123456789abcdef0123456789abcdef" : "";
    puts(".text");
    for (int i = dwarf3; i < count + dwarf3; ++i)
    {
        if (i == 0)
        {
            printf(".file 0 \"/src0\" \"main.c\"%s\n", md5);
        }
        else
        {
            int directory = i;
            if (repeated)
            {
                directory = 1;
            }
            else if (mixed && i % 4 != 0)
            {
                directory = (i / 4) % 17 + 1;
            }
            if (bare)
            {
                printf(".file %d \"f%04d.c\"\n", i, i);
            }
            else if (!dwarf3 && i % 2 == 0)
            {
                printf(".file %d \"d%04d/\" \"f%04d.c\"%s\n", i, directory, i, md5);
            }
            else
            {
                printf(".file %d \"d%04d/f%04d.c\"%s\n", i, directory, i, md5);
            }
        }
    }
    printf(".loc %d 7 2\nnop\n", dwarf3);
    if (count > 1)
    {
        printf(".loc %d 17 4\nret\n", count - 1 + dwarf3);
    }
    puts(".section .debug_abbrev,\"\",@progbits\n.byte 1,17,0,16,23,0,0,0");
    puts(".section .debug_info,\"\",@progbits\n.long 13\n.short 5\n.byte 1,8\n.long 0\n.byte 1\n.long 0");
    puts(".section .note.GNU-stack,\"\",@progbits");
}

int main(int argc, char** argv)
{
    int status = 2;
    if (argc == 3)
    {
        char* end = 0;
        const long count = strtol(argv[2], &end, 10);
        if (*argv[2] != 0 && *end == 0 && count >= 1 && count <= 2048)
        {
            write_input(argv[1], (int)count);
            status = ferror(stdout) != 0;
        }
    }
    return status;
}
