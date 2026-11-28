// Standalone harness around c_direct_try_compile for profiling: the request the driver builds for
// `-c sqlite3.c` with --predefines FILE, -isystem/-I directories and -D macros.
#define _GNU_SOURCE
#include "buster/compiler/c_direct.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>

static double now_ms(void)
{
    struct timespec ts;
    clock_gettime(CLOCK_MONOTONIC, &ts);
    return (double)ts.tv_sec * 1e3 + (double)ts.tv_nsec / 1e6;
}

// Hardware counters a stage (--counters): this thread's, user mode only, read at each mark.
#include <linux/perf_event.h>
#include <sys/syscall.h>
#include <unistd.h>
#define COUNTERS 6
static const char* const counter_names[COUNTERS] = { "cycles", "instructions", "branch-misses", "l1d-read-misses", "stalled-frontend", "stalled-backend" };
static int counter_fds[COUNTERS] = { -1, -1, -1, -1, -1, -1 };
static bool counters_on;
static uint64_t stage_counts[8][COUNTERS];
static uint64_t counter_last[COUNTERS];
static void counters_open(void)
{
    static const uint32_t types[COUNTERS] = { PERF_TYPE_HARDWARE, PERF_TYPE_HARDWARE, PERF_TYPE_HARDWARE, PERF_TYPE_HW_CACHE, PERF_TYPE_HARDWARE, PERF_TYPE_HARDWARE };
    static const uint64_t configs[COUNTERS] = { PERF_COUNT_HW_CPU_CYCLES, PERF_COUNT_HW_INSTRUCTIONS, PERF_COUNT_HW_BRANCH_MISSES,
                                                PERF_COUNT_HW_CACHE_L1D | (PERF_COUNT_HW_CACHE_OP_READ << 8) | (PERF_COUNT_HW_CACHE_RESULT_MISS << 16),
                                                PERF_COUNT_HW_STALLED_CYCLES_FRONTEND, PERF_COUNT_HW_STALLED_CYCLES_BACKEND };
    for (uint32_t i = 0; i < COUNTERS; i += 1)
    {
        struct perf_event_attr attr;
        memset(&attr, 0, sizeof(attr));
        attr.type = types[i];
        attr.size = sizeof(attr);
        attr.config = configs[i];
        attr.exclude_kernel = 1;
        attr.exclude_hv = 1;
        counter_fds[i] = (int)syscall(SYS_perf_event_open, &attr, 0, -1, -1, 0);
    }
    counters_on = true;
}
static void counters_read(uint64_t* values)
{
    for (uint32_t i = 0; i < COUNTERS; i += 1)
    {
        values[i] = 0;
        if (counter_fds[i] >= 0 && read(counter_fds[i], &values[i], 8) != 8) { values[i] = 0; }
    }
}

static double stage_ms[8];
static double stage_last;
static void mark(void* context, uint32_t id)
{
    (void)context;
    if (counters_on)
    {
        uint64_t now[COUNTERS];
        counters_read(now);
        for (uint32_t i = 0; i < COUNTERS; i += 1) { stage_counts[id][i] += now[i] - counter_last[i]; counter_last[i] = now[i]; }
    }
    const double t = now_ms();
    stage_ms[id] += t - stage_last;
    stage_last = t;
}

// The driver's answers (pp_feature), from a table made of the product's own: FEATURES names a file of lines
// "QUERY NAME VALUE"; a query it lacks is logged and answered 0.
static struct { uint32_t query; char name[64]; uint32_t value; } feature_rows[512];
static uint32_t feature_count;
static bool feature_log;
static uint32_t feature_query(void* context, uint32_t query, const uint8_t* name, uint32_t length)
{
    (void)context;
    for (uint32_t i = 0; i < feature_count; i += 1)
    {
        if (feature_rows[i].query == query && strlen(feature_rows[i].name) == length && memcmp(feature_rows[i].name, name, length) == 0) { return feature_rows[i].value; }
    }
    if (feature_log) { fprintf(stderr, "feature-query %u %.*s\n", query, (int)length, (const char*)name); }
    if (feature_count < 512u && length < 64u)
    {
        feature_rows[feature_count].query = query; memcpy(feature_rows[feature_count].name, name, length); feature_rows[feature_count].name[length] = 0;
        feature_rows[feature_count].value = 0; feature_count += 1;
    }
    return 0;
}

int main(int argc, char** argv)
{
    {
        const char* path = getenv("FEATURES");
        feature_log = getenv("FEATURE_LOG") != NULL;
        FILE* f = path != NULL ? fopen(path, "r") : NULL;
        if (f != NULL)
        {
            while (feature_count < 512u && fscanf(f, "%u %63s %u", &feature_rows[feature_count].query, feature_rows[feature_count].name, &feature_rows[feature_count].value) == 3) { feature_count += 1; }
            fclose(f);
        }
    }
    const char* dirs[64];
    uint8_t sys[64];
    uint32_t dir_count = 0;
    const char* macros[256];
    uint32_t macro_count = 0;
    const char* input = NULL;
    const char* output = "/dev/null";
    const char* predefines = NULL;
    uint32_t repeat = 1;
    bool stages = false;
    bool summary = false;
    bool pic = true;
    uint32_t quote_count = 0;
    // -I directories first (quote and angled), then -isystem, as the driver's search order has them.
    for (int pass = 0; pass < 2; pass += 1)
    {
        for (int i = 1; i < argc; i += 1)
        {
            if (pass == 0 && strncmp(argv[i], "-I", 2) == 0) { dirs[dir_count] = argv[i] + 2; sys[dir_count] = 0; dir_count += 1; }
            else if (strcmp(argv[i], "-isystem") == 0) { if (pass == 1) { dirs[dir_count] = argv[i + 1]; sys[dir_count] = 1; dir_count += 1; } i += 1; }
            else if (pass == 0 && strncmp(argv[i], "-D", 2) == 0) { char* m = malloc(strlen(argv[i]) + 1); m[0] = 'D'; strcpy(m + 1, argv[i] + 2); macros[macro_count++] = m; }
            else if (strcmp(argv[i], "--predefines") == 0) { predefines = argv[i + 1]; i += 1; }
            else if (strcmp(argv[i], "-o") == 0) { output = argv[i + 1]; i += 1; }
            else if (strcmp(argv[i], "--repeat") == 0) { if (pass == 0) { repeat = (uint32_t)atoi(argv[i + 1]); } i += 1; }
            else if (strcmp(argv[i], "--stages") == 0) { stages = true; }
            else if (strcmp(argv[i], "--summary") == 0) { summary = true; }
            else if (strcmp(argv[i], "--counters") == 0) { if (pass == 0) { counters_open(); } }
            else if (strcmp(argv[i], "--no-pic") == 0) { pic = false; }
            else if (pass == 0 && argv[i][0] != '-') { input = argv[i]; }
        }
    }
    (void)quote_count;
    int status = 1;
    double best = 1e30;
    static double totals[4096], pre[4096], gen[4096], wr[4096];
    static uint64_t counts[4][COUNTERS][4096];
    uint32_t kept = 0;
    for (uint32_t r = 0; r < repeat; r += 1)
    {
        memset(stage_ms, 0, sizeof(stage_ms));
        memset(stage_counts, 0, sizeof(stage_counts));
        uint32_t tokens = 0;
        const char* bail = NULL;
        const CDirectRequest req = {
            .input_path = input,
            .output_path = output,
            .predefines_path = predefines,
            .directories = dirs,
            .directory_system = sys,
            .directory_count = dir_count,
            .angled_first = 0,
            .macros = macros,
            .macro_count = macro_count,
            .pic = pic,
            .unwind_tables = true,
            .unsigned_char = false,
            .c23 = false,
            .quiet = false,
            .release = true,
            .avoid_huge_pages = false,
            .mark_stage = mark,
            .stage_setup = 0,
            .stage_preprocess = 1,
            .stage_codegen = 2,
            .stage_object_write = 3,
            .out_token_count = &tokens,
            .out_bail_reason = &bail,
            .feature_query = feature_query,
        };
        if (counters_on) { counters_read(counter_last); }
        const double t0 = now_ms();
        stage_last = t0;
        status = c_direct_try_compile(&req);
        const double t1 = now_ms();
        if (status == 1 && r == 0) { fprintf(stderr, "bail: %s\n", bail != NULL ? bail : "(none)"); }
        if (t1 - t0 < best) { best = t1 - t0; }
        if (kept < 4096u)
        {
            for (uint32_t st = 0; st < 4; st += 1) { for (uint32_t c = 0; c < COUNTERS; c += 1) { counts[st][c][kept] = stage_counts[st][c]; } }
            totals[kept] = t1 - t0; pre[kept] = stage_ms[1]; gen[kept] = stage_ms[2]; wr[kept] = stage_ms[3]; kept += 1;
        }
        if (stages)
        {
            fprintf(stderr, "run %u: status %d, %u tokens, %.3f ms: setup %.3f, preprocess %.3f, codegen %.3f, write %.3f, release %.3f\n", r, status, tokens, t1 - t0,
                    stage_ms[0], stage_ms[1], stage_ms[2], stage_ms[3], t1 - stage_last);
        }
    }
    fprintf(stderr, "status %d, best %.3f ms\n", status, best);
    if (summary && kept != 0)
    {
        double* arrays[4] = { totals, pre, gen, wr };
        double medians[4];
        for (uint32_t a = 0; a < 4; a += 1)
        {
            double* v = arrays[a];
            for (uint32_t i = 1; i < kept; i += 1) { const double x = v[i]; uint32_t j = i; while (j > 0 && v[j - 1] > x) { v[j] = v[j - 1]; j -= 1; } v[j] = x; }
            medians[a] = v[kept / 2];
        }
        printf("median-ms total %.3f preprocess %.3f codegen %.3f write %.3f runs %u\n", medians[0], medians[1], medians[2], medians[3], kept);
        if (counters_on)
        {
            static const char* const stage_names[4] = { "setup", "preprocess", "codegen", "write" };
            for (uint32_t st = 0; st < 4; st += 1)
            {
                printf("median-counters %s", stage_names[st]);
                for (uint32_t c = 0; c < COUNTERS; c += 1)
                {
                    uint64_t* v = counts[st][c];
                    for (uint32_t i = 1; i < kept; i += 1) { const uint64_t x = v[i]; uint32_t j = i; while (j > 0 && v[j - 1] > x) { v[j] = v[j - 1]; j -= 1; } v[j] = x; }
                    printf(" %s %llu", counter_names[c], (unsigned long long)v[kept / 2]);
                }
                printf("\n");
            }
        }
    }
    return status;
}
