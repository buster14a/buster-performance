// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Original receipt reader for this fixed 3-round, 3-build, 6-placement, 3-copy campaign.
// Reject missing/duplicate rows, nonzero child statuses and absent counters before reporting medians.
#include <stdbool.h>
#include <stdio.h>
#include <string.h>

static double median(double* values)
{
    for (unsigned i = 1; i < 54; i += 1)
    {
        const double value = values[i];
        unsigned j = i;
        while (j != 0 && values[j - 1] > value)
        {
            values[j] = values[j - 1];
            j -= 1;
        }
        values[j] = value;
    }
    return values[27];
}

int main(int argc, char** argv)
{
    const char* names[3] = { "base", "head", "base-again" };
    static double samples[3][3][8][54];
    static bool seen[3][3][3][6][3];
    unsigned counts[3][3] = { 0 };
    unsigned finished[3] = { 0 };
    unsigned round = 0;
    FILE* input = argc == 2 ? fopen(argv[1], "r") : NULL;
    bool valid = input != NULL;
    char line[8192];
    while (valid && fgets(line, sizeof(line), input) != NULL)
    {
        valid = strchr(line, '\n') != NULL || feof(input);
        if (strncmp(line, "== round ", 9) == 0)
        {
            valid = valid && sscanf(line, "== round %u", &round) == 1 && round >= 1 && round <= 3;
        }
        else if (strncmp(line, "time-runs: done,", 16) == 0)
        {
            valid = valid && round >= 1 && round <= 3 && strcmp(line, "time-runs: done, 0 failed processes\n") == 0;
            if (valid)
            {
                finished[round - 1] += 1;
            }
        }
        else if (strncmp(line, "run ", 4) == 0)
        {
            unsigned run = 0, list = 0, placement = 0, copy = 0;
            char name[32];
            double wall = 0, user = 0, system = 0;
            unsigned long long peak = 0, minor = 0, major = 0, cycles = 0, instructions = 0;
            int status = -1, end = 0;
            const int fields = sscanf(line, "run %u list %u %31s placement %u copy %u: %lf ms wall, %lf ms user, %lf ms system, %llu KB peak, %llu minor faults, %llu major, %llu user cycles, %llu instructions, status %d%n",
                                      &run, &list, name, &placement, &copy, &wall, &user, &system, &peak, &minor, &major, &cycles, &instructions, &status, &end);
            unsigned build = 0;
            while (build < 3 && fields == 14 && strcmp(name, names[build]) != 0)
            {
                build += 1;
            }
            valid = valid && fields == 14 && strcmp(line + end, "\n") == 0 && round >= 1 && round <= 3 && build < 3 &&
                    run >= 1 && run <= 3 && list == 1 && placement >= 1 && placement <= 6 && copy >= 1 && copy <= 3 &&
                    status == 0 && cycles != 0 && instructions != 0 && wall > 0 && user >= 0 && system >= 0 && peak != 0 && major == 0;
            if (valid)
            {
                bool* slot = &seen[round - 1][build][run - 1][placement - 1][copy - 1];
                const unsigned row = counts[round - 1][build];
                valid = !*slot && row < 54;
                if (valid)
                {
                    const double values[8] = { wall, user, system, (double)peak, (double)minor, (double)major, (double)cycles, (double)instructions };
                    for (unsigned field = 0; field < 8; field += 1)
                    {
                        samples[round - 1][build][field][row] = values[field];
                    }
                    counts[round - 1][build] += 1;
                    *slot = true;
                }
            }
        }
    }
    if (input != NULL)
    {
        valid = !ferror(input) && valid;
        valid = fclose(input) == 0 && valid;
    }
    for (unsigned r = 0; r < 3; r += 1)
    {
        valid = valid && finished[r] == 1;
        for (unsigned b = 0; b < 3; b += 1)
        {
            valid = valid && counts[r][b] == 54;
        }
    }
    if (valid)
    {
        puts("round,build,runs,wall_ms,user_ms,system_ms,peak_kb,minor_faults,major_faults,user_cycles,instructions");
        for (unsigned r = 0; r < 3; r += 1)
        {
            for (unsigned b = 0; b < 3; b += 1)
            {
                double values[8];
                for (unsigned field = 0; field < 8; field += 1)
                {
                    values[field] = median(samples[r][b][field]);
                }
                printf("%u,%s,54,%.3f,%.3f,%.3f,%.0f,%.0f,%.0f,%.0f,%.0f\n", r + 1, names[b], values[0], values[1], values[2], values[3], values[4], values[5], values[6], values[7]);
            }
        }
        valid = fflush(stdout) == 0 && !ferror(stdout);
    }
    else
    {
        fputs("incomplete or invalid campaign: expected 486 successful, uniquely identified, counted rows and three completed rounds\n", stderr);
    }
    return valid ? 0 : 1;
}
