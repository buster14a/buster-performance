// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
//
// reduce RESULTS UNITS: reads buster#672's experiment (round.sh, stages.sh) and prints
// Markdown tables: per compile (median over rounds) and marginal per token between
// consecutive sizes, at one and eight workers, with the eight-worker inflation.
// UMC bytes are CAS commands (read + write) times 64, minus the round's idle rate
// over the batch's wall time. UNITS holds gen-cluster's units (uN.c), for their sizes.
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define SIZE_COUNT 6
#define ROUND_MAX 16

static const int sizes[SIZE_COUNT] = { 0, 1, 4, 16, 64, 350 };

typedef struct
{
    double user_cycles;
    double kernel_cycles;
    double user_instructions;
    double task_ms;
    double faults;
    double dram_bytes;
    double wall_ms;
    int valid;
} Sample;

// The value of a perf stat -x, CSV's line whose event field starts with `event`, or -1.
static double csv_value(const char* path, const char* event)
{
    double result = -1;
    FILE* file = fopen(path, "r");
    if (file != 0)
    {
        char line[1024];
        while (fgets(line, sizeof(line), file) != 0)
        {
            char* fields[8] = { 0 };
            int count = 0;
            char* cursor = line;
            while (count < 8)
            {
                fields[count] = cursor;
                count += 1;
                char* comma = strchr(cursor, ',');
                if (comma == 0)
                {
                    break;
                }
                *comma = 0;
                cursor = comma + 1;
            }
            if (count >= 3 && strncmp(fields[2], event, strlen(event)) == 0 && strcmp(fields[0], "<not counted>") != 0)
            {
                result = (result < 0 ? 0 : result) + strtod(fields[0], 0);
            }
        }
        fclose(file);
    }
    return result;
}

static double number_file(const char* path)
{
    double result = -1;
    FILE* file = fopen(path, "r");
    if (file != 0)
    {
        if (fscanf(file, "%lf", &result) != 1)
        {
            result = -1;
        }
        fclose(file);
    }
    return result;
}

static double umc_bytes(const char* path)
{
    double read = csv_value(path, "amd_umc/umc_cas_cmd.rd/");
    double write = csv_value(path, "amd_umc/umc_cas_cmd.wr/");
    return read < 0 || write < 0 ? -1 : (read + write) * 64.0;
}

static int compare_double(const void* a, const void* b)
{
    double x = *(const double*)a;
    double y = *(const double*)b;
    return (x > y) - (x < y);
}

static double median(double* values, int count)
{
    double result = 0;
    if (count > 0)
    {
        qsort(values, (size_t)count, sizeof(double), compare_double);
        result = count % 2 ? values[count / 2] : (values[count / 2 - 1] + values[count / 2]) / 2;
    }
    return result;
}

static double tokens_of(const char* results, int copies)
{
    double result = -1;
    char path[4096];
    snprintf(path, sizeof(path), "%s/stages/u%d.txt", results, copies);
    FILE* file = fopen(path, "r");
    if (file != 0)
    {
        char line[1024];
        while (fgets(line, sizeof(line), file) != 0)
        {
            if (strncmp(line, "time-process\ttokens\t", 20) == 0)
            {
                result = strtod(line + 20, 0);
            }
        }
        fclose(file);
    }
    return result;
}

// Reads round `round`'s sample of size `copies` with `workers` workers, per compile.
static Sample read_sample(const char* results, int round, int copies, int workers)
{
    Sample sample = { 0 };
    char base[4096];
    char path[4200];
    snprintf(base, sizeof(base), "%s/r%d", results, round);
    snprintf(path, sizeof(path), "%s/.done", base);
    FILE* done = fopen(path, "r");
    if (done != 0)
    {
        fclose(done);
        snprintf(path, sizeof(path), "%s/u%d.loops", base, copies);
        double loops = number_file(path);
        double compiles = loops * workers;
        snprintf(path, sizeof(path), "%s/u%d.w%d.core.csv", base, copies, workers);
        sample.user_cycles = csv_value(path, "cycles:u") / compiles;
        sample.kernel_cycles = csv_value(path, "cycles:k") / compiles;
        sample.user_instructions = csv_value(path, "instructions:u") / compiles;
        sample.task_ms = csv_value(path, "task-clock") / compiles;
        sample.faults = csv_value(path, "page-faults") / compiles;
        snprintf(path, sizeof(path), "%s/u%d.w%d.core.us", base, copies, workers);
        sample.wall_ms = number_file(path) / 1000.0;
        snprintf(path, sizeof(path), "%s/idle.umc.csv", base);
        double idle_bytes = umc_bytes(path);
        snprintf(path, sizeof(path), "%s/idle.umc.us", base);
        double idle_us = number_file(path);
        snprintf(path, sizeof(path), "%s/u%d.w%d.umc.csv", base, copies, workers);
        double bytes = umc_bytes(path);
        snprintf(path, sizeof(path), "%s/u%d.w%d.umc.us", base, copies, workers);
        double us = number_file(path);
        sample.dram_bytes = (bytes - idle_bytes / idle_us * us) / compiles;
        sample.valid = loops > 0 && bytes >= 0 && idle_bytes >= 0 && sample.user_cycles > 0;
    }
    return sample;
}

typedef struct
{
    Sample per_compile;
    int rounds;
} Median;

static Median median_of(const char* results, int copies, int workers)
{
    Median result = { 0 };
    double user[ROUND_MAX], kernel[ROUND_MAX], instructions[ROUND_MAX], task[ROUND_MAX], faults[ROUND_MAX], dram[ROUND_MAX], wall[ROUND_MAX];
    int count = 0;
    for (int round = 0; round < ROUND_MAX; round += 1)
    {
        Sample sample = read_sample(results, round, copies, workers);
        if (sample.valid)
        {
            user[count] = sample.user_cycles;
            kernel[count] = sample.kernel_cycles;
            instructions[count] = sample.user_instructions;
            task[count] = sample.task_ms;
            faults[count] = sample.faults;
            dram[count] = sample.dram_bytes;
            wall[count] = sample.wall_ms;
            count += 1;
        }
    }
    result.per_compile.user_cycles = median(user, count);
    result.per_compile.kernel_cycles = median(kernel, count);
    result.per_compile.user_instructions = median(instructions, count);
    result.per_compile.task_ms = median(task, count);
    result.per_compile.faults = median(faults, count);
    result.per_compile.dram_bytes = median(dram, count);
    result.per_compile.wall_ms = median(wall, count);
    result.rounds = count;
    return result;
}

int main(int argc, char** argv)
{
    int status = 0;
    if (argc != 3)
    {
        fprintf(stderr, "usage: reduce RESULTS UNITS\n");
        status = 2;
    }
    else
    {
        const char* results = argv[1];
        Median one[SIZE_COUNT];
        Median eight[SIZE_COUNT];
        double tokens[SIZE_COUNT];
        double source_bytes[SIZE_COUNT];
        for (int s = 0; s < SIZE_COUNT; s += 1)
        {
            one[s] = median_of(results, sizes[s], 1);
            eight[s] = median_of(results, sizes[s], 8);
            tokens[s] = tokens_of(results, sizes[s]);
            char path[4096];
            snprintf(path, sizeof(path), "%s/u%d.c", argv[2], sizes[s]);
            FILE* file = fopen(path, "r");
            source_bytes[s] = -1;
            if (file != 0)
            {
                fseek(file, 0, SEEK_END);
                source_bytes[s] = (double)ftell(file);
                fclose(file);
            }
            if (one[s].rounds == 0 || eight[s].rounds == 0 || tokens[s] < 0)
            {
                status = 1;
            }
        }
        printf("### Per compile (median of rounds)\n\n");
        printf("| copies | tokens | source bytes | rounds | user Mcycles 1w | user Mcycles 8w | user 8w/1w | kernel Mcycles 1w | kernel Mcycles 8w | kernel 8w/1w | user Minstr | DRAM MB 1w | DRAM MB 8w | DRAM bytes/source byte 1w | 8w |\n");
        printf("| ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |\n");
        for (int s = 0; s < SIZE_COUNT; s += 1)
        {
            Sample a = one[s].per_compile;
            Sample b = eight[s].per_compile;
            printf("| %d | %.0f | %.0f | %d/%d | %.3f | %.3f | %.3f | %.3f | %.3f | %.3f | %.3f | %.3f | %.3f | %.1f | %.1f |\n", sizes[s], tokens[s], source_bytes[s],
                   one[s].rounds, eight[s].rounds, a.user_cycles / 1e6, b.user_cycles / 1e6, b.user_cycles / a.user_cycles, a.kernel_cycles / 1e6,
                   b.kernel_cycles / 1e6, b.kernel_cycles / a.kernel_cycles, a.user_instructions / 1e6, a.dram_bytes / 1e6, b.dram_bytes / 1e6,
                   a.dram_bytes / source_bytes[s], b.dram_bytes / source_bytes[s]);
        }
        printf("\n### Marginal per token between consecutive sizes\n\n");
        printf("| copies | Δ tokens | user cycles/token 1w | 8w | 8w/1w | kernel cycles/token 1w | 8w | 8w/1w | user instr/token | DRAM bytes/token 1w | 8w | 8w/1w |\n");
        printf("| ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |\n");
        for (int s = 1; s < SIZE_COUNT; s += 1)
        {
            double dt = tokens[s] - tokens[s - 1];
            Sample a0 = one[s - 1].per_compile, a1 = one[s].per_compile, b0 = eight[s - 1].per_compile, b1 = eight[s].per_compile;
            double u1 = (a1.user_cycles - a0.user_cycles) / dt, u8 = (b1.user_cycles - b0.user_cycles) / dt;
            double k1 = (a1.kernel_cycles - a0.kernel_cycles) / dt, k8 = (b1.kernel_cycles - b0.kernel_cycles) / dt;
            double i1 = (a1.user_instructions - a0.user_instructions) / dt;
            double d1 = (a1.dram_bytes - a0.dram_bytes) / dt, d8 = (b1.dram_bytes - b0.dram_bytes) / dt;
            printf("| %d→%d | %.0f | %.1f | %.1f | %.3f | %.1f | %.1f | %.3f | %.1f | %.1f | %.1f | %.3f |\n", sizes[s - 1], sizes[s], dt, u1, u8, u8 / u1, k1, k8,
                   k8 / k1, i1, d1, d8, d8 / d1);
        }
        printf("\n### Wall time per batch (median ms) and throughput\n\n");
        printf("| copies | 1w batch ms | 8w batch ms | 1w MB/s | 8w MB/s | 8w/1w |\n| ---: | ---: | ---: | ---: | ---: | ---: |\n");
        for (int s = 0; s < SIZE_COUNT; s += 1)
        {
            char path[4096];
            snprintf(path, sizeof(path), "%s/r0/u%d.loops", results, sizes[s]);
            double loops = number_file(path);
            double w1 = one[s].per_compile.wall_ms;
            double w8 = eight[s].per_compile.wall_ms;
            double mb1 = source_bytes[s] * loops / (w1 / 1000.0) / 1e6;
            double mb8 = source_bytes[s] * loops * 8 / (w8 / 1000.0) / 1e6;
            printf("| %d | %.1f | %.1f | %.2f | %.2f | %.2f |\n", sizes[s], w1, w8, mb1, mb8, mb8 / mb1);
        }
    }
    return status;
}
