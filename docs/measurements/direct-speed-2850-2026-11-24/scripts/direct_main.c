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

static double stage_ms[8];
static double stage_last;
static void mark(void* context, uint32_t id)
{
    (void)context;
    const double t = now_ms();
    stage_ms[id] += t - stage_last;
    stage_last = t;
}

int main(int argc, char** argv)
{
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
            else if (strcmp(argv[i], "--no-pic") == 0) { pic = false; }
            else if (pass == 0 && argv[i][0] != '-') { input = argv[i]; }
        }
    }
    (void)quote_count;
    int status = 1;
    double best = 1e30;
    for (uint32_t r = 0; r < repeat; r += 1)
    {
        memset(stage_ms, 0, sizeof(stage_ms));
        uint32_t tokens = 0;
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
        };
        const double t0 = now_ms();
        stage_last = t0;
        status = c_direct_try_compile(&req);
        const double t1 = now_ms();
        if (t1 - t0 < best) { best = t1 - t0; }
        if (stages)
        {
            fprintf(stderr, "run %u: status %d, %u tokens, %.3f ms: setup %.3f, preprocess %.3f, codegen %.3f, write %.3f, release %.3f\n", r, status, tokens, t1 - t0,
                    stage_ms[0], stage_ms[1], stage_ms[2], stage_ms[3], t1 - stage_last);
        }
    }
    fprintf(stderr, "status %d, best %.3f ms\n", status, best);
    return status;
}
