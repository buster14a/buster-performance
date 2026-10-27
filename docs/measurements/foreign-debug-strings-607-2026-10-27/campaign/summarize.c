// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin.
// Original reader for dwarf607.c's retained rows. Run from the campaign root.
#include <stdint.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <elf.h>

typedef struct Samples Samples;
struct Samples
{
    double values[128];
    uint32_t count;
};

static int compare(const void* a, const void* b)
{
    const double x = *(const double*)a;
    const double y = *(const double*)b;
    return (x > y) - (x < y);
}

static void add(Samples* samples, double value)
{
    if (samples->count >= 128)
    {
        exit(2);
    }
    samples->values[samples->count++] = value;
}

static double median(Samples* samples)
{
    if (samples->count == 0)
    {
        exit(3);
    }
    qsort(samples->values, samples->count, sizeof(double), compare);
    return samples->values[samples->count / 2];
}

static double number(const char* row, const char* key)
{
    const char* at = strstr(row, key);
    return at != 0 ? strtod(at + strlen(key), 0) : -1;
}

static uint64_t string_sizes(const char* path, uint64_t* total)
{
    FILE* file = fopen(path, "rb");
    Elf64_Ehdr elf;
    bool valid = file != 0 && fread(&elf, 1, sizeof(elf), file) == sizeof(elf);
    Elf64_Shdr* sections = valid ? calloc(elf.e_shnum, sizeof(Elf64_Shdr)) : 0;
    valid = valid && sections != 0 && fseek(file, (long)elf.e_shoff, SEEK_SET) == 0 && fread(sections, sizeof(Elf64_Shdr), elf.e_shnum, file) == elf.e_shnum;
    const uint64_t size = valid ? sections[elf.e_shstrndx].sh_size : 0;
    char* names = valid ? malloc(size) : 0;
    valid = valid && names != 0 && fseek(file, (long)sections[elf.e_shstrndx].sh_offset, SEEK_SET) == 0 && fread(names, 1, size, file) == size;
    uint64_t result = 0;
    for (uint32_t i = 1; valid && i < elf.e_shnum; i += 1)
    {
        if (strcmp(names + sections[i].sh_name, ".debug_str") == 0 || strcmp(names + sections[i].sh_name, ".debug_line_str") == 0)
        {
            result += sections[i].sh_size;
        }
    }
    if (!valid)
    {
        fprintf(stderr, "cannot read %s\n", path);
        exit(4);
    }
    fseek(file, 0, SEEK_END);
    *total = (uint64_t)ftell(file);
    fclose(file);
    free(names);
    free(sections);
    return result;
}

static void summarize(const char* case_name, const char* compression)
{
    char key[256];
    char path[4096];
    char row[4096];
    snprintf(key, sizeof(key), "%s-%s", case_name, compression);
    Samples wall[4] = { 0 };
    Samples user[4] = { 0 };
    Samples system[4] = { 0 };
    Samples rss[4] = { 0 };
    Samples write[4] = { 0 };
    const char* labels[4] = { "buster", "lld", "driver-base", "driver-merge" };
    snprintf(path, sizeof(path), "results/%s/process.tsv", key);
    FILE* file = fopen(path, "r");
    if (file == 0)
    {
        fprintf(stderr, "missing %s\n", path);
        exit(5);
    }
    while (fgets(row, sizeof(row), file) != 0)
    {
        const uint32_t way = strstr(row, "label=lld") != 0 ? 1 : strstr(row, "label=driver-base") != 0 ? 2 : strstr(row, "label=driver-merge") != 0 ? 3 : 0;
        const int run = (int)number(row, "run=");
        if (run != 0)
        {
            if (number(row, "valid=") != 1)
            {
                exit(6);
            }
            add(&wall[way], number(row, "wall_ns=") / 1e6);
            add(&user[way], number(row, "user_us=") / 1000);
            add(&system[way], number(row, "system_us=") / 1000);
            add(&rss[way], number(row, "rss_kib="));
            if (way != 1)
            {
                char stage[32];
                double ms = 0;
                char stage_row[4096];
                snprintf(path, sizeof(path), "results/%s/%s-%d.stderr", key, labels[way], run);
                FILE* stages = fopen(path, "r");
                while (stages != 0 && fgets(stage_row, sizeof(stage_row), stages) != 0)
                {
                    if (sscanf(stage_row, " %31s %lf ms", stage, &ms) == 2 && strcmp(stage, "write") == 0)
                    {
                        add(&write[way], ms);
                    }
                }
                if (stages != 0)
                {
                    fclose(stages);
                }
            }
        }
    }
    fclose(file);
    Samples pool[2][2] = { 0 };
    uint64_t retained[2] = { 0 };
    uint64_t output[2] = { 0 };
    uint64_t entries[2] = { 0 };
    uint64_t input = 0;
    uint64_t relocations = 0;
    snprintf(path, sizeof(path), "results/%s/pool.tsv", key);
    file = fopen(path, "r");
    if (file == 0)
    {
        exit(7);
    }
    while (fgets(row, sizeof(row), file) != 0)
    {
        if (strncmp(row, "input\t", 6) == 0)
        {
            input = (uint64_t)(number(row, "\tstr_bytes=") + number(row, "\tline_str_bytes="));
            relocations = (uint64_t)number(row, "debug_relocations=");
        }
        if (strncmp(row, "pool\t", 5) == 0)
        {
            const uint32_t kind = (uint32_t)number(row, "kind=");
            const uint32_t way = strstr(row, "path=exact") != 0 ? 1 : 0;
            add(&pool[way][kind], number(row, "ns=") / 1e6);
            retained[kind] = (uint64_t)number(row, "retained_arena=");
            output[kind] = (uint64_t)number(row, "output=");
            entries[kind] = (uint64_t)number(row, "entries=");
        }
    }
    fclose(file);
    uint64_t total[4] = { 0 };
    uint64_t sizes[4] = { 0 };
    for (uint32_t way = 0; way < 4; way += 1)
    {
        snprintf(path, sizeof(path), "outputs/%s-%s", key, labels[way]);
        sizes[way] = string_sizes(path, &total[way]);
    }
    if (sizes[3] != output[0] + output[1] || sizes[2] != sizes[0])
    {
        fprintf(stderr, "unexpected prototype section sizes for %s\n", key);
        exit(8);
    }
    printf("%s\t%llu\t%llu\t%llu\t%llu\t%llu\t%llu\t%.3f\t%.3f\t%.3f\t%.0f\t%.3f\t%.3f\t%.3f\t%.0f\t%.3f\t%.3f\t%.3f\t%llu\t%llu\t%llu", key,
           (unsigned long long)input, (unsigned long long)(entries[0] + entries[1]), (unsigned long long)(output[0] + output[1]),
           (unsigned long long)sizes[0], (unsigned long long)sizes[1], (unsigned long long)relocations,
           median(&wall[0]), median(&user[0]), median(&system[0]), median(&rss[0]),
           median(&wall[1]), median(&user[1]), median(&system[1]), median(&rss[1]),
           median(&write[0]), median(&pool[0][0]) + median(&pool[0][1]), median(&pool[1][0]) + median(&pool[1][1]),
           (unsigned long long)(retained[0] + retained[1]), (unsigned long long)total[0], (unsigned long long)total[1]);
    for (uint32_t way = 2; way < 4; way += 1)
    {
        printf("\t%.3f\t%.3f\t%.3f\t%.0f\t%.3f\t%llu", median(&wall[way]), median(&user[way]), median(&system[way]), median(&rss[way]), median(&write[way]), (unsigned long long)total[way]);
    }
    printf("\n");
}

int main(void)
{
    const char* cases[] = { "duplicate-10", "duplicate-100", "duplicate-1000", "unique-10", "unique-100", "unique-1000", "dwarf64-10", "real" };
    const char* compressions[] = { "plain", "zlib" };
    printf("case\tinput_string_bytes\tcomplete_strings\texact_pool_bytes\tbuster_string_bytes\tlld_string_bytes\tdebug_relocations\tbuster_wall_ms\tbuster_user_ms\tbuster_system_ms\tbuster_rss_kib\tlld_wall_ms\tlld_user_ms\tlld_system_ms\tlld_rss_kib\tbuster_whole_write_ms\tproducer_vector_ms\tproducer_exact_ms\tproducer_retained_arena_bytes\tbuster_file_bytes\tlld_file_bytes\tdriver_base_wall_ms\tdriver_base_user_ms\tdriver_base_system_ms\tdriver_base_rss_kib\tdriver_base_write_ms\tdriver_base_file_bytes\tdriver_merge_wall_ms\tdriver_merge_user_ms\tdriver_merge_system_ms\tdriver_merge_rss_kib\tdriver_merge_write_ms\tdriver_merge_file_bytes\n");
    for (uint32_t i = 0; i < sizeof(cases) / sizeof(cases[0]); i += 1)
    {
        for (uint32_t j = 0; j < 2; j += 1)
        {
            summarize(cases[i], compressions[j]);
        }
    }
    return 0;
}
