/* SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
 * Copyright (c) 2026 David Gonzalez Martin.
 * Private placement control only: insert padding after the source's existing
 * .text.buster_checker page alignment. No compiler C statement changes.
 */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main(int argc, char** argv)
{
    int result = 1;
    FILE* input = argc == 3 ? fopen(argv[1], "rb") : NULL;
    const char* needle = "\\t.p2align 12\\n\\t.text";
    char* data = NULL;
    long bytes = 0;
    if (input != NULL && fseek(input, 0, SEEK_END) == 0)
    {
        bytes = ftell(input);
        if (bytes > 0 && fseek(input, 0, SEEK_SET) == 0)
        {
            data = malloc((size_t)bytes + 1);
        }
    }
    if (data != NULL && fread(data, 1, (size_t)bytes, input) == (size_t)bytes)
    {
        data[bytes] = 0;
        char* found = strstr(data, needle);
        const int shift = strcmp(argv[2], "0") == 0 ? 0 : strcmp(argv[2], "64") == 0 ? 64 : strcmp(argv[2], "512") == 0 ? 512 : -1;
        if (found != NULL && strstr(found + strlen(needle), needle) == NULL && shift >= 0)
        {
            *found = 0;
            const int a = fputs(data, stdout);
            const int b = shift == 0 ? fprintf(stdout, "\\t.p2align 12\\n\\t.skip 0\\n\\t.text") :
                          fprintf(stdout, "\\t.p2align 12\\n\"\n#if BUSTER_IN_UNIT(BUSTER_UNIT_CHECKER)\n        \"\\t.skip %d\\n\"\n#endif\n        \"\\t.text", shift);
            const int c = fputs(found + strlen(needle), stdout);
            result = a >= 0 && b >= 0 && c >= 0 && fflush(stdout) == 0 ? 0 : 1;
        }
    }
    if (input != NULL)
    {
        fclose(input);
    }
    free(data);
    return result;
}
