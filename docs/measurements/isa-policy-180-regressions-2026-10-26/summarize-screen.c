// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin.
// Exact three-round, two-image screen reader. Reject incomplete/failed/duplicate receipts before emitting JSON.
#define _POSIX_C_SOURCE 200809L
#include <stdbool.h>
#include <stdint.h>
#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

enum { ROUNDS = 3, IMAGES = 2, CONFIGS = 3, LISTS = 3, RUNS = 21, METRICS = 25 };
#define BUSTER_SCREEN_ASM "benchmark-assembler --functions 1"
#define BUSTER_SCREEN_SQL "-fsyntax-only -std=gnu17 -march=x86-64 -nostdinc -isystem /var/lib/buster-9700x/corpora/preprocessor-391e729af658/headers/usr/lib/clang/23/include -isystem /var/lib/buster-9700x/corpora/preprocessor-391e729af658/headers/usr/local/include -isystem /var/lib/buster-9700x/corpora/preprocessor-391e729af658/headers/usr/include /var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite/sqlite3.c"
#define BUSTER_SCREEN_C "--verify -march=x86-64 -c /home/david/buster-fast-bench/codex-180-opt-20261026-evidence/runtime.c -o /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/c051-timed-runtime.o"
static const char* config_names[CONFIGS] = {"benchmark-assembler", "benchmark-backend", "time-runs --runs 21 --list " BUSTER_SCREEN_ASM " --list " BUSTER_SCREEN_SQL " --list " BUSTER_SCREEN_C};
static const char* list_names[LISTS] = {BUSTER_SCREEN_ASM, BUSTER_SCREEN_SQL, BUSTER_SCREEN_C};
static const char* metric_names[METRICS] = {
    "init_ms", "asm_scalar_ms", "asm_vector_ms",
    "backend_vector_ns_entry", "backend_scalar_ns_entry", "backend_sizing_ns_entry", "backend_encode_ns_entry",
    "backend_vector_instructions_entry", "backend_scalar_instructions_entry", "backend_sizing_instructions_entry", "backend_encode_instructions_entry",
    "asm1_wall_ms", "asm1_user_ms", "asm1_system_ms", "asm1_RSS_KiB", "asm1_minor", "asm1_major",
    "sqlite_wall_ms", "sqlite_user_ms", "sqlite_system_ms", "sqlite_RSS_KiB", "sqlite_minor", "sqlite_major",
    "C_wall_ms", "C_RSS_KiB"
};
static double values[METRICS][IMAGES][ROUNDS];
static bool value_seen[METRICS][IMAGES][ROUNDS];
static bool header_seen[ROUNDS][IMAGES][CONFIGS];
static double samples[ROUNDS][IMAGES][LISTS][6][RUNS];
static bool sample_seen[ROUNDS][IMAGES][LISTS][RUNS];
static bool summary_seen[ROUNDS][IMAGES][LISTS];
static bool driver_closed[ROUNDS][IMAGES];
static bool workload_seen[ROUNDS][IMAGES][2];
static unsigned short_c_minor[IMAGES][ROUNDS];
static unsigned short_c_major[IMAGES][ROUNDS];

static double median(const double* input, unsigned count)
{
    double sorted[RUNS];
    memcpy(sorted, input, count * sizeof(*input));
    for (unsigned i = 1; i < count; i += 1)
    {
        const double value = sorted[i];
        unsigned j = i;
        while (j != 0 && sorted[j - 1] > value)
        {
            sorted[j] = sorted[j - 1];
            j -= 1;
        }
        sorted[j] = value;
    }
    return sorted[count / 2];
}

static bool put(unsigned metric, unsigned image, unsigned round, double value)
{
    const bool valid = metric < METRICS && !value_seen[metric][image][round] && isfinite(value) && value >= 0;
    if (valid)
    {
        value_seen[metric][image][round] = true;
        values[metric][image][round] = value;
    }
    return valid;
}

int main(int argc, char** argv)
{
    bool valid = argc == 2;
    FILE* file = valid ? fopen(argv[1], "r") : 0;
    valid &= file != 0;
    char* line = 0;
    size_t capacity = 0;
    unsigned round = 0, image = 0, config = 0, headers = 0, children = 0, drivers = 0, footers = 0;
    while (valid && getline(&line, &capacity, file) >= 0)
    {
        if (footers != 0)
        {
            valid &= strspn(line, " \t\r\n") == strlen(line);
            continue;
        }
        unsigned parsed_round = 0;
        char tree[4096];
        if (sscanf(line, "== round %u tree %4095s", &parsed_round, tree) == 2)
        {
            valid &= headers == 0 || config != 2 || driver_closed[round][image];
            const char* leaf = strrchr(tree, '/');
            valid &= leaf != 0 && parsed_round >= 1 && parsed_round <= ROUNDS;
            if (valid)
            {
                image = strcmp(leaf + 1, "codex-180-fix-20261026-main") == 0 ? 0 : 1;
                valid &= image == 0 || strcmp(leaf + 1, "codex-180-fix-20261026-caller-fixed") == 0;
                config = strstr(line, "config [benchmark-assembler]") ? 0 : strstr(line, "config [benchmark-backend]") ? 1 : 2;
                const char* start = strstr(line, " config [");
                const size_t name_length = strlen(config_names[config]);
                valid &= start != 0 && strncmp(start + 9, config_names[config], name_length) == 0 && strcmp(start + 9 + name_length, "]\n") == 0;
                round = parsed_round - 1;
                valid &= !header_seen[round][image][config];
                valid &= round == headers / (IMAGES * CONFIGS) && config == (headers / IMAGES) % CONFIGS;
                valid &= image == ((headers % IMAGES) ^ (round & 1));
                header_seen[round][image][config] = true;
                headers += 1;
            }
        }
        else if (headers != 0)
        {
            double init = 0;
            char label[16];
            double a, b, c, d, e, f, g;
            unsigned run, list, rss, minor, major;
            int status;
            if (config == 0 && strncmp(line, "assembler mixed:", 16) == 0)
            {
                valid &= !workload_seen[round][image][0] && strcmp(line, "assembler mixed: 256 functions, 9984 instructions, 153295 source bytes; 21 interleaved passes\n") == 0;
                workload_seen[round][image][0] = true;
            }
            else if (config == 1 && strncmp(line, "benchmark-backend:", 18) == 0)
            {
                valid &= !workload_seen[round][image][1] && strcmp(line, "benchmark-backend: 2008 functions, 262874 typed entries, 303116 records (1.153 per entry), 1171371 bytes; 9414 entries deferred (3.58%)\n") == 0;
                workload_seen[round][image][1] = true;
            }
            else if (config == 0 && sscanf(line, "init: %lf ms;", &init) == 1)
            {
                valid &= put(0, image, round, init);
            }
            else if (sscanf(line, "%15s %lf %lf %lf %lf %lf %lf %lf", label, &a, &b, &c, &d, &e, &f, &g) == 8)
            {
                valid &= isfinite(a) && isfinite(b) && isfinite(c) && isfinite(d) && isfinite(e) && isfinite(f) && isfinite(g);
                valid &= a >= 0 && b >= 0 && c >= 0 && d >= 0 && e >= 0 && f >= 0 && g >= 0;
                const unsigned variant = strcmp(label, "vector") == 0 ? 0 : strcmp(label, "scalar") == 0 ? 1 : strcmp(label, "sizing") == 0 ? 2 : strcmp(label, "encode") == 0 ? 3 : 4;
                if (variant < 4 && config == 1)
                {
                    valid &= b > 0 && c > 0;
                    valid &= put(3 + variant, image, round, a) && put(7 + variant, image, round, c);
                }
                else if (variant < 2 && config == 0)
                {
                    valid &= put(variant == 0 ? 2 : 1, image, round, g);
                }
            }
            else if (sscanf(line, "run %u list %u: %lf ms wall, %lf ms user, %lf ms system, %u KB peak, %u minor faults, %u major, status %d", &run, &list, &a, &b, &c, &rss, &minor, &major, &status) == 9)
            {
                valid &= config == 2 && status == 0 && run >= 1 && run <= RUNS && list >= 1 && list <= LISTS;
                if (valid)
                {
                    const unsigned at = children % (LISTS * RUNS);
                    valid &= run == at / LISTS + 1 && list == (at % LISTS + run - 1) % LISTS + 1;
                    valid &= !sample_seen[round][image][list - 1][run - 1];
                    sample_seen[round][image][list - 1][run - 1] = true;
                    const double observed[6] = {a, b, c, rss, minor, major};
                    for (unsigned m = 0; m < 6; m += 1)
                    {
                        valid &= isfinite(observed[m]) && observed[m] >= 0;
                        samples[round][image][list - 1][m][run - 1] = observed[m];
                    }
                    children += 1;
                }
            }
            else if (sscanf(line, "list %u [", &list) == 1 && strstr(line, "]: 21 runs, median ") != 0)
            {
                valid &= config == 2 && list >= 1 && list <= LISTS;
                const char* summary = strstr(line, "]: 21 runs, median ");
                double low, high;
                valid &= sscanf(summary, "]: 21 runs, median %lf ms wall (%lf to %lf), %lf ms user, %lf ms system, %u KB peak, %u minor faults, %u major", &a, &low, &high, &b, &c, &rss, &minor, &major) == 8;
                if (valid)
                {
                    valid &= isfinite(low) && isfinite(high) && low >= 0 && high >= low;
                    const char* start = strchr(line, '[');
                    const size_t name_length = strlen(list_names[list - 1]);
                    valid &= start != 0 && strncmp(start + 1, list_names[list - 1], name_length) == 0 && start[1 + name_length] == ']';
                    valid &= !summary_seen[round][image][list - 1];
                    summary_seen[round][image][list - 1] = true;
                    const double reported[6] = {a, b, c, rss, minor, major};
                    for (unsigned n = 0; n < RUNS; n += 1)
                    {
                        valid &= sample_seen[round][image][list - 1][n];
                    }
                    double actual_low = samples[round][image][list - 1][0][0];
                    double actual_high = actual_low;
                    for (unsigned n = 1; n < RUNS; n += 1)
                    {
                        const double value = samples[round][image][list - 1][0][n];
                        actual_low = value < actual_low ? value : actual_low;
                        actual_high = value > actual_high ? value : actual_high;
                    }
                    valid &= low == actual_low && high == actual_high;
                    for (unsigned m = 0; m < 6; m += 1)
                    {
                        const double actual = median(samples[round][image][list - 1][m], RUNS);
                        valid &= isfinite(reported[m]) && actual == reported[m];
                        if (list < 3)
                        {
                            valid &= put(11 + (list - 1) * 6 + m, image, round, actual);
                        }
                    }
                    if (list == 3)
                    {
                        valid &= put(23, image, round, a) && put(24, image, round, rss);
                        short_c_minor[image][round] = minor;
                        short_c_major[image][round] = major;
                    }
                }
            }
            else if (strncmp(line, "time-runs: done,", 16) == 0)
            {
                valid &= config == 2 && !driver_closed[round][image] && strcmp(line, "time-runs: done, 0 failed processes\n") == 0;
                for (unsigned l = 0; l < LISTS; l += 1)
                {
                    valid &= summary_seen[round][image][l];
                }
                driver_closed[round][image] = true;
                drivers += 1;
            }
            else if (strncmp(line, "ab: done,", 9) == 0)
            {
                valid &= headers == ROUNDS * IMAGES * CONFIGS && drivers == ROUNDS * IMAGES && driver_closed[round][image] && strcmp(line, "ab: done, 0 failed runs\n") == 0;
                footers += 1;
            }
        }
    }
    valid &= file != 0 && !ferror(file);
    if (file != 0)
    {
        valid &= fclose(file) == 0;
    }
    free(line);
    valid &= headers == ROUNDS * IMAGES * CONFIGS && children == ROUNDS * IMAGES * LISTS * RUNS && drivers == ROUNDS * IMAGES && footers == 1;
    for (unsigned r = 0; r < ROUNDS; r += 1)
    {
        for (unsigned i = 0; i < IMAGES; i += 1)
        {
            valid &= workload_seen[r][i][0] && workload_seen[r][i][1];
        }
    }
    for (unsigned m = 0; m < METRICS; m += 1)
    {
        for (unsigned i = 0; i < IMAGES; i += 1)
        {
            for (unsigned r = 0; r < ROUNDS; r += 1)
            {
                valid &= value_seen[m][i][r];
            }
        }
    }
    if (valid)
    {
        printf("{\n  \"headers\": %u, \"timedChildren\": %u, \"drivers\": %u, \"ABSuccessFooters\": %u,\n  \"metrics\": {\n", headers, children, drivers, footers);
        for (unsigned m = 0; m < METRICS; m += 1)
        {
            const double base = median(values[m][0], ROUNDS), head = median(values[m][1], ROUNDS);
            unsigned lower = 0, higher = 0;
            for (unsigned r = 0; r < ROUNDS; r += 1)
            {
                lower += values[m][1][r] < values[m][0][r];
                higher += values[m][1][r] > values[m][0][r];
            }
            char percentage[64] = "null";
            if (base != 0 || head == 0)
            {
                snprintf(percentage, sizeof(percentage), "%.9g", base != 0 ? 100 * (head / base - 1) : 0);
            }
            printf("    \"%s\": {\"main\": [%.9g, %.9g, %.9g], \"head\": [%.9g, %.9g, %.9g], \"mainMedian\": %.9g, \"headMedian\": %.9g, \"changePercent\": %s, \"lower\": %u, \"higher\": %u, \"equal\": %u}%s\n", metric_names[m], values[m][0][0], values[m][0][1], values[m][0][2], values[m][1][0], values[m][1][1], values[m][1][2], base, head, percentage, lower, higher, ROUNDS - lower - higher, m + 1 < METRICS ? "," : "");
        }
        printf("  },\n  \"C_minor\": {\"main\": [%u, %u, %u], \"head\": [%u, %u, %u]},\n  \"C_major\": {\"main\": [%u, %u, %u], \"head\": [%u, %u, %u]}\n}\n", short_c_minor[0][0], short_c_minor[0][1], short_c_minor[0][2], short_c_minor[1][0], short_c_minor[1][1], short_c_minor[1][2], short_c_major[0][0], short_c_major[0][1], short_c_major[0][2], short_c_major[1][0], short_c_major[1][1], short_c_major[1][2]);
        valid &= fflush(stdout) == 0 && !ferror(stdout);
    }
    fprintf(stderr, "screen receipt: %s (%u headers, %u timed children, %u drivers, %u AB footers)\n", valid ? "pass" : "INCOMPLETE OR INVALID", headers, children, drivers, footers);
    return valid ? 0 : 1;
}
