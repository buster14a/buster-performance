// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Original reader for the retained procbench TSV samples of Buster #612.
#define _GNU_SOURCE
#include <dirent.h>
#include <inttypes.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct Group Group;
struct Group
{
    char label[64];
    uint64_t wall[32];
    uint64_t instructions[32];
    uint64_t cycles[32];
    uint64_t rss[32];
    unsigned count;
};

static void sort(uint64_t* values, unsigned count)
{
    for (unsigned i = 1; i < count; i += 1)
    {
        const uint64_t value = values[i];
        unsigned j = i;
        while (j != 0 && values[j - 1] > value)
        {
            values[j] = values[j - 1];
            j -= 1;
        }
        values[j] = value;
    }
}

int main(int argc, char** argv)
{
    Group groups[16] = { 0 };
    unsigned group_count = 0;
    bool valid = argc == 2;
    DIR* directory = valid ? opendir(argv[1]) : NULL;
    valid &= directory != NULL;
    struct dirent* entry = NULL;
    unsigned warmups = 0;
    unsigned timed = 0;
    unsigned majors = 0;
    while (directory != NULL && (entry = readdir(directory)) != NULL)
    {
        const char* name = entry->d_name;
        const size_t length = strlen(name);
        if ((strncmp(name, "overload-", 9) == 0 || strncmp(name, "sqlite-", 7) == 0) && length > 4 && strcmp(name + length - 4, ".tsv") == 0)
        {
            char path[1024];
            snprintf(path, sizeof(path), "%s/%s", argv[1], name);
            FILE* file = fopen(path, "r");
            valid &= file != NULL;
            char* line = NULL;
            size_t capacity = 0;
            while (file != NULL && getline(&line, &capacity, file) >= 0)
            {
                if (strncmp(line, "round\t", 6) != 0)
                {
                    char* fields[32];
                    unsigned count = 0;
                    char* saved = NULL;
                    for (char* field = strtok_r(line, "\t\r\n", &saved); field != NULL && count < 32; field = strtok_r(NULL, "\t\r\n", &saved))
                    {
                        fields[count++] = field;
                    }
                    bool row = count == 19 && strcmp(fields[5], "0") == 0;
                    uint64_t cycles = 0;
                    uint64_t instructions = 0;
                    if (row)
                    {
                        row = strncmp(fields[17], "cycles=", strlen("cycles=")) == 0 &&
                              strncmp(fields[18], "instructions=", strlen("instructions=")) == 0;
                    }
                    if (row)
                    {
                        char* end = NULL;
                        cycles = strtoull(fields[17] + strlen("cycles="), &end, 10);
                        row &= strncmp(fields[17], "cycles=", strlen("cycles=")) == 0 && *end == 0 && cycles != 0;
                        instructions = strtoull(fields[18] + strlen("instructions="), &end, 10);
                        row &= strncmp(fields[18], "instructions=", strlen("instructions=")) == 0 && *end == 0 && instructions != 0;
                    }
                    valid &= row;
                    if (row)
                    {
                        if (strcmp(fields[4], "1") == 0)
                        {
                            warmups += 1;
                        }
                        else
                        {
                            unsigned group = 0;
                            while (group < group_count && strcmp(groups[group].label, fields[2]) != 0)
                            {
                                group += 1;
                            }
                            if (group == group_count && group_count < 16)
                            {
                                snprintf(groups[group].label, sizeof(groups[group].label), "%s", fields[2]);
                                group_count += 1;
                            }
                            if (group < 16 && groups[group].count < 32)
                            {
                                Group* g = groups + group;
                                const unsigned n = g->count++;
                                g->wall[n] = strtoull(fields[6], NULL, 10);
                                g->rss[n] = strtoull(fields[13], NULL, 10);
                                g->cycles[n] = cycles;
                                g->instructions[n] = instructions;
                                majors += (unsigned)strtoul(fields[10], NULL, 10);
                                timed += 1;
                            }
                            else
                            {
                                valid = false;
                            }
                        }
                    }
                }
            }
            free(line);
            if (file != NULL)
            {
                valid &= !ferror(file);
                fclose(file);
            }
        }
    }
    if (directory != NULL)
    {
        closedir(directory);
    }
    printf("label\tsamples\tmedian_ms\tmin_ms\tmax_ms\tuser_instructions\tuser_cycles\tpeak_rss_kb\n");
    for (unsigned i = 0; i < group_count; i += 1)
    {
        Group* g = groups + i;
        sort(g->wall, g->count);
        sort(g->instructions, g->count);
        sort(g->cycles, g->count);
        sort(g->rss, g->count);
        const unsigned middle = g->count / 2;
        printf("%s\t%u\t%.6f\t%.6f\t%.6f\t%" PRIu64 "\t%" PRIu64 "\t%" PRIu64 "\n", g->label, g->count,
               (double)g->wall[middle] / 1e6, (double)g->wall[0] / 1e6, (double)g->wall[g->count - 1] / 1e6,
               g->instructions[middle], g->cycles[middle], g->rss[middle]);
        valid &= g->count == 5;
    }
    valid &= group_count == 8 && timed == 40 && warmups == 40 && majors == 0 && !ferror(stdout);
    fprintf(stderr, "timed=%u warmups=%u major_faults=%u valid=%u\n", timed, warmups, majors, valid);
    return valid ? 0 : 1;
}
