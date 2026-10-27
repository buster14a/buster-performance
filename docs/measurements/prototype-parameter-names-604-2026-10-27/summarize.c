// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin.
// Read time-runs' own per-copy medians without combining different process rounds or conditioning states.
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main(int argc, char** argv)
{
    bool valid = argc > 1;
    puts("log,list,kind,parameters,build,copy,wall_ms,peak_kb,user_cycles,instructions");
    for (int f = 1; valid && f < argc; f += 1)
    {
        FILE* input = fopen(argv[f], "r");
        valid = input != NULL;
        char line[16384];
        uint32_t summaries = 0;
        bool complete = false;
        while (valid && fgets(line, sizeof(line), input) != NULL)
        {
            const char* status = strstr(line, ", status ");
            if (strncmp(line, "run ", 4) == 0 && status != NULL)
            {
                valid = strtol(status + strlen(", status "), NULL, 10) == 0;
            }
            complete |= strstr(line, "time-runs: done, 0 failed processes") != NULL;
            uint32_t list = 0;
            uint32_t copy = 0;
            char build[16];
            const char* metrics = strstr(line, "]: ");
            if (sscanf(line, "list %u %15s copy %u", &list, build, &copy) == 3 && metrics != NULL)
            {
                unsigned long long runs, peak, faults, major, cycles, instructions;
                double wall, minimum, maximum, user, system;
                const int fields = sscanf(metrics + 3, "%llu runs, median %lf ms wall (%lf to %lf), %lf ms user, %lf ms system, %llu KB peak, %llu minor faults, %llu major, %llu user cycles, %llu instructions",
                                          &runs, &wall, &minimum, &maximum, &user, &system, &peak, &faults, &major, &cycles, &instructions);
                valid = valid && fields == 11 && runs == 17 && list >= 1 && list <= 12 && cycles != 0 && instructions != 0;
                if (valid)
                {
                    const char* kind = list <= 10 ? list & 1 ? "named" : "unnamed" : list == 11 ? "small" : "sqlite";
                    const uint32_t parameters = list <= 10 ? 256u << ((list - 1) / 2) : 0;
                    printf("%s,%u,%s,%u,%s,%u,%.3f,%llu,%llu,%llu\n", argv[f], list, kind, parameters, build, copy, wall, peak, cycles, instructions);
                    summaries += 1;
                }
            }
        }
        valid = valid && complete && (summaries == 24 || summaries == 48);
        if (input != NULL)
        {
            fclose(input);
        }
    }
    return valid ? 0 : 1;
}
