// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Original linkage-only adapter generator. All frozen source text and notices are retained.
#include <stdio.h>
#include <string.h>

int main(int argc, char** argv)
{
    FILE* input = argc == 3 ? fopen(argv[1], "r") : NULL;
    FILE* output = input != NULL ? fopen(argv[2], "w") : NULL;
    char line[16384];
    unsigned replaced = 0;
    int result = output == NULL;
    while (result == 0 && fgets(line, sizeof(line), input) != NULL)
    {
        const char* text = line;
        if (strcmp(line, "#define BUSTER_ELSEWHERE inline __attribute__((noinline))\n") == 0)
        {
            text = "#define BUSTER_ELSEWHERE\n";
            replaced += 1;
        }
        result = fputs(text, output) < 0;
    }
    if (input != NULL)
    {
        result |= ferror(input) != 0;
        result |= fclose(input) != 0;
    }
    if (output != NULL)
    {
        result |= fclose(output) != 0;
    }
    result |= replaced != 1;
    return result;
}
