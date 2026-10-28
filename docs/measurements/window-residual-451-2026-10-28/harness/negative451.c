// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Original protocol fault injection for the #451 evidence readers.
#define _GNU_SOURCE
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main(int argc, char** argv)
{
    FILE* input = argc == 4 ? fopen(argv[1], "r") : NULL;
    FILE* output = argc == 4 ? fopen(argv[2], "w") : NULL;
    bool valid = input != NULL && output != NULL;
    char* line = NULL;
    size_t capacity = 0;
    unsigned changed = 0;
    while (valid && getline(&line, &capacity, input) >= 0)
    {
        bool emit = true;
        if (changed == 0 && strcmp(argv[3], "footer") == 0 && strncmp(line, "time-runs: done,", 16) == 0)
        {
            emit = false;
            changed += 1;
        }
        if (changed == 0 && strcmp(argv[3], "duplicate") == 0 && strncmp(line, "run ", 4) == 0)
        {
            valid = fputs(line, output) >= 0;
            changed += 1;
        }
        if (changed == 0 && strcmp(argv[3], "status") == 0 && strncmp(line, "run ", 4) == 0)
        {
            char* status = strstr(line, ", status 0");
            valid = status != NULL;
            if (valid)
            {
                status[9] = '1';
                changed += 1;
            }
        }
        if (changed == 0 && strcmp(argv[3], "list") == 0 && strncmp(line, "run ", 4) == 0)
        {
            char* list = strstr(line, " list ");
            valid = list != NULL;
            if (valid)
            {
                list[6] = '3';
                changed += 1;
            }
        }
        if (changed == 0 && strcmp(argv[3], "release") == 0 && strstr(line, "then the release") != NULL)
        {
            emit = false;
            changed += 1;
        }
        if (changed == 0 && strcmp(argv[3], "tokens") == 0)
        {
            unsigned files = 0;
            unsigned passes = 0;
            unsigned long long tokens = 0;
            unsigned long long result = 0;
            if (sscanf(line, "%u files, %llu input tokens, %llu output tokens; %u passes, medians:", &files, &tokens, &result, &passes) == 4)
            {
                valid = fprintf(output, "%u files, %llu input tokens, %llu output tokens; %u passes, medians:\n", files, tokens + 1, result, passes) > 0;
                emit = false;
                changed += 1;
            }
        }
        if (valid && emit)
        {
            valid = fputs(line, output) >= 0;
        }
    }
    if (valid && strcmp(argv[3], "pmu") == 0)
    {
        valid = fputs("time-runs: user cycles weren't counted for every process\n", output) >= 0;
        changed += 1;
    }
    if (input != NULL)
    {
        valid = ferror(input) == 0 && valid;
        valid = fclose(input) == 0 && valid;
    }
    if (output != NULL)
    {
        valid = fclose(output) == 0 && valid;
    }
    free(line);
    return argc != 4 ? 2 : !(valid && changed == 1);
}
