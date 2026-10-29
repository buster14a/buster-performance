// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Original converter for the published B2 summary. These are derived from
// rounded ns/token fields, not newly measured or exact absolute medians.
#define _POSIX_C_SOURCE 200809L
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main(int argc, char** argv)
{
    FILE* input = argc == 2 ? fopen(argv[1], "r") : NULL;
    bool valid = input != NULL;
    char* line = NULL;
    size_t capacity = 0;
    uint32_t rows = 0;
    if (valid) valid = getline(&line, &capacity, input) >= 0 && strncmp(line, "run\tunit\tlanes\trounds\ttokens\t", strlen("run\tunit\tlanes\trounds\ttokens\t")) == 0;
    if (valid) puts("run\tunit\ttokens\trequested\tactive\tone_derived_ns\tmany_derived_ns\trounding_bound_ns");
    while (valid && getline(&line, &capacity, input) >= 0)
    {
        char* fields[32] = { 0 };
        char* cursor = NULL;
        uint32_t count = 0;
        for (char* field = strtok_r(line, "\t\n", &cursor); field != NULL && count < 32; field = strtok_r(NULL, "\t\n", &cursor)) fields[count++] = field;
        valid = count == 24;
        if (valid)
        {
            const unsigned long tokens = strtoul(fields[4], NULL, 10);
            printf("%s\t%s\t%lu\t%s\t%s\t%.3f\t%.3f\t%.3f\n", fields[0], fields[1], tokens, fields[2], fields[15],
                   tokens * strtod(fields[12], NULL), tokens * strtod(fields[13], NULL), tokens * 0.005);
            rows += 1;
        }
    }
    if (input != NULL) fclose(input);
    free(line);
    fprintf(stderr, "absolute-reconstruction: rows=%u valid=%s rounded-inputs=yes\n", rows, valid ? "yes" : "no");
    return valid && rows != 0 ? 0 : 1;
}
