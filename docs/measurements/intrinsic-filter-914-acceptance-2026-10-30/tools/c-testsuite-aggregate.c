// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
// Sum each measured time-runs round over its complete predetermined unit set.
// Require exactly one successful base/head/copy1 record per unit and round,
// with actual user-cycle/instruction counts. Wall values have the source
// report's 1us precision; they are not reconstructed higher-resolution times.
#define _POSIX_C_SOURCE 200809L
#include <errno.h>
#include <inttypes.h>
#include <math.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct CorpusTotals CorpusTotals;
struct CorpusTotals
{
    uint64_t wall_ns;
    uint64_t cycles;
    uint64_t instructions;
};

static bool corpus_count(const char* text, uint32_t maximum, uint32_t* output)
{
    errno = 0;
    char* end = NULL;
    const unsigned long value = strtoul(text, &end, 10);
    const bool valid = text[0] != '\0' && end != NULL && *end == '\0' && errno == 0 && value >= 1 && value <= maximum;
    if (valid)
    {
        *output = (uint32_t)value;
    }
    return valid;
}

int main(int argc, char** argv)
{
    uint32_t rounds = 0;
    uint32_t units = 0;
    bool valid = argc == 4 && corpus_count(argv[1], 1000, &rounds) && corpus_count(argv[2], 220, &units);
    FILE* input = valid ? fopen(argv[3], "r") : NULL;
    bool* seen = valid ? calloc((size_t)rounds * units * 2, sizeof(*seen)) : NULL;
    CorpusTotals* totals = valid ? calloc((size_t)rounds * 2, sizeof(*totals)) : NULL;
    valid = valid && input != NULL && seen != NULL && totals != NULL;
    char* line = NULL;
    size_t capacity = 0;
    ssize_t length;
    uint64_t records = 0;
    while (valid && (length = getline(&line, &capacity, input)) >= 0)
    {
        valid = length <= 4096;
        if (valid && strncmp(line, "run ", 4) == 0)
        {
            unsigned int round = 0;
            unsigned int unit = 0;
            unsigned int copy = 0;
            char build[16];
            double wall = 0;
            double user = 0;
            double system = 0;
            uint64_t peak = 0;
            uint64_t minor = 0;
            uint64_t major = 0;
            uint64_t cycles = 0;
            uint64_t instructions = 0;
            int status = -1;
            int end = 0;
            errno = 0;
            const int fields = sscanf(line, "run %u list %u %15s copy %u: %lf ms wall, %lf ms user, %lf ms system, %" SCNu64 " KiB wait4 peak, %" SCNu64 " minor faults, %" SCNu64 " major, %" SCNu64 " user cycles, %" SCNu64 " instructions, status %d%n",
                                      &round, &unit, build, &copy, &wall, &user, &system, &peak, &minor, &major, &cycles, &instructions, &status, &end);
            const bool base = fields == 13 && strcmp(build, "base") == 0;
            const bool head = fields == 13 && strcmp(build, "head") == 0;
            valid = fields == 13 && errno == 0 && strchr(line, '-') == NULL && strchr(line, '+') == NULL &&
                    (base || head) && round >= 1 && round <= rounds && unit >= 1 && unit <= units && copy == 1 &&
                    isfinite(wall) && isfinite(user) && isfinite(system) && wall >= 0 && wall <= 3600000 && user >= 0 && system >= 0 &&
                    cycles != 0 && instructions != 0 && status == 0 && (line[end] == '\n' || line[end] == '\0');
            if (valid)
            {
                const uint32_t version = head ? 1 : 0;
                const size_t slot = ((size_t)(round - 1) * units + unit - 1) * 2 + version;
                CorpusTotals* total = totals + (size_t)(round - 1) * 2 + version;
                const uint64_t wall_ns = (uint64_t)(wall * 1000000.0 + 0.5);
                valid = !seen[slot] && total->wall_ns <= UINT64_MAX - wall_ns && total->cycles <= UINT64_MAX - cycles && total->instructions <= UINT64_MAX - instructions;
                if (valid)
                {
                    seen[slot] = true;
                    total->wall_ns += wall_ns;
                    total->cycles += cycles;
                    total->instructions += instructions;
                    records += 1;
                }
            }
        }
    }
    valid = valid && records == (uint64_t)rounds * units * 2;
    if (input != NULL)
    {
        const bool input_ok = !ferror(input);
        valid = fclose(input) == 0 && input_ok && valid;
    }
    if (valid)
    {
        printf("build,round,units,wall_ns_from_printed_1us_values,user_cycles,instructions\n");
        for (uint32_t round = 0; round < rounds; round += 1)
        {
            for (uint32_t version = 0; version < 2; version += 1)
            {
                const CorpusTotals* total = totals + (size_t)round * 2 + version;
                printf("%s,%u,%u,%" PRIu64 ",%" PRIu64 ",%" PRIu64 "\n", version == 0 ? "base" : "head", round + 1, units, total->wall_ns, total->cycles, total->instructions);
            }
        }
    }
    else
    {
        fprintf(stderr, "c-testsuite aggregation refused: incomplete, malformed, failed, duplicated, uncounted or overflowing records; usage: aggregate ROUNDS UNITS LOG\n");
    }
    free(line);
    free(seen);
    free(totals);
    return valid ? 0 : 1;
}
