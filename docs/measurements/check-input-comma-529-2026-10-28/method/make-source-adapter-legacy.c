// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Original read-only-control adapter generator. Project source extracts retain their own notices.
#define _GNU_SOURCE
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main(int argc, char** argv)
{
    int result = argc != 5;
    for (unsigned kind = 0; result == 0 && kind < 2; kind += 1)
    {
        FILE* input = fopen(argv[1 + kind * 2], "r");
        FILE* output = fopen(argv[2 + kind * 2], "w");
        result = input == NULL || output == NULL;
        char* line = NULL;
        size_t capacity = 0;
        while (result == 0 && getline(&line, &capacity, input) >= 0)
        {
            if (kind == 0 && strstr(line, "#define BUSTER_ELSEWHERE inline __attribute__((noinline))") != NULL)
            {
                fputs("#define BUSTER_ELSEWHERE\n", output);
            }
            else if (kind == 0 && strstr(line, "#include \"buster/compiler/c_checker_test.c\"") != NULL)
            {
                fputs("#include \"checker-test-diagnostic.c\"\n", output);
            }
            else if (kind == 1 && strstr(line, "if (test->failures <= 24)") != NULL)
            {
                fputs("        if (strstr(description, \": the selected walks visit \") == NULL)\n", output);
            }
            else
            {
                fputs(line, output);
                if (kind == 1 && strstr(line, "test->failures += 1;") != NULL)
                {
                    fputs("        diagnostic_walk_failures += strstr(description, \": the selected walks visit \") != NULL;\n", output);
                }
            }
            result |= ferror(output) != 0;
        }
        if (input != NULL)
        {
            result |= ferror(input) != 0;
            fclose(input);
        }
        if (output != NULL)
        {
            result |= fclose(output) != 0;
        }
        free(line);
    }
    return result;
}
