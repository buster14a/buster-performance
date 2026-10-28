// Original padding-only control transform. The first isolated section anchor must be empty and page-aligned.
#include <errno.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main(int argc, char** argv)
{
    if (argc != 4) return 2;
    errno = 0;
    char* end = NULL;
    const unsigned long bytes = strtoul(argv[3], &end, 10);
    if (errno != 0 || end == argv[3] || *end != 0 || bytes > 4096 || bytes % 64 != 0) return 2;
    FILE* input = fopen(argv[1], "r");
    FILE* output = input != NULL ? fopen(argv[2], "w") : NULL;
    if (output == NULL) return 2;
    char* line = NULL;
    size_t capacity = 0;
    ssize_t length;
    unsigned state = 0;
    bool valid = true;
    while (valid && (length = getline(&line, &capacity, input)) >= 0)
    {
        char directive[64] = { 0 };
        const bool code = sscanf(line, " %63s", directive) == 1 && directive[0] != '#';
        if (state == 0 && code && strcmp(directive, ".section") == 0 && strstr(line, ".text.buster_checker") != NULL)
        {
            state = 1;
        }
        else if (state == 1 && code)
        {
            unsigned alignment = 0;
            valid = strcmp(directive, ".p2align") == 0 && sscanf(line, " %63s %u", directive, &alignment) == 2 && alignment == 12;
            state = 2;
        }
        else if (state == 2 && code)
        {
            valid = strcmp(directive, ".text") == 0;
            if (valid && bytes != 0) fprintf(output, "\t.fill\t%lu, 1, 0x90\n", bytes);
            state = 3;
        }
        if (valid) valid = fwrite(line, 1, (size_t)length, output) == (size_t)length;
    }
    valid = valid && state == 3 && !ferror(input) && !ferror(output);
    free(line);
    const int a = fclose(input), b = fclose(output);
    return !(valid && a == 0 && b == 0);
}
