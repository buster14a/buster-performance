// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Original synthetic inputs for Buster #600; no external source material.
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main(int argc, char** argv)
{
    int status = argc == 4 ? 0 : 1;
    if (status == 0)
    {
        const char* mode = argv[1];
        const unsigned long long size = strtoull(argv[2], 0, 10);
        const unsigned count = (unsigned)strtoul(argv[3], 0, 10);
        status = size == 0 || count == 0;
        if (strcmp(mode, "relocation") == 0)
        {
            puts("extern int target;");
        }
        for (unsigned i = 0; status == 0 && i < count; i += 1)
        {
            if (strcmp(mode, "writable") == 0 || strcmp(mode, "readonly") == 0)
            {
                printf("%sunsigned char object_%u[%llu] = {1};\n", strcmp(mode, "readonly") == 0 ? "const " : "", i, size);
            }
            else if (strcmp(mode, "relocation") == 0)
            {
                printf("int *object_%u[%llu] = { &target };\n", i, size / 8);
            }
            else if (strcmp(mode, "literal") == 0)
            {
                printf("const char *get_%u(void) { return \"", i);
                char block[4096];
                memset(block, 'x', sizeof(block));
                for (unsigned long long done = 1; done < size;)
                {
                    const unsigned long long left = size - done;
                    const size_t chunk = left < sizeof(block) ? (size_t)left : sizeof(block);
                    status = fwrite(block, 1, chunk, stdout) != chunk;
                    done += chunk;
                }
                puts("\"; }");
            }
            else
            {
                status = 1;
            }
        }
    }
    return status != 0 || ferror(stdout) ? 1 : 0;
}
