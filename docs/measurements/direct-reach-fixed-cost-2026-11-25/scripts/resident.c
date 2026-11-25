// resident.c: the ceiling of "no process a unit" for the direct path (buster#3592). One process compiles every unit of
// a list through c_direct_try_compile, as the driver would call it for `-c UNIT -o OUT`, and prints the time by stage.
//   resident [-Idir]... [-isystem dir]... [-Dmacro]... --predefines FILE --list FILE --out DIR [--rounds N]
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
    static const char* dirs[64];
    static uint8_t sys[64];
    uint32_t dir_count = 0;
    static const char* macros[256];
    uint32_t macro_count = 0;
    const char* predefines = NULL;
    const char* list = NULL;
    const char* out = "/dev/shm";
    uint32_t rounds = 1;
    for (int pass = 0; pass < 2; pass += 1)
    {
        for (int i = 1; i < argc; i += 1)
        {
            if (pass == 0 && strncmp(argv[i], "-I", 2) == 0) { dirs[dir_count] = argv[i] + 2; sys[dir_count] = 0; dir_count += 1; }
            else if (strcmp(argv[i], "-isystem") == 0) { if (pass == 1) { dirs[dir_count] = argv[i + 1]; sys[dir_count] = 1; dir_count += 1; } i += 1; }
            else if (pass == 0 && strncmp(argv[i], "-D", 2) == 0) { char* m = malloc(strlen(argv[i]) + 1); m[0] = 'D'; strcpy(m + 1, argv[i] + 2); macros[macro_count++] = m; }
            else if (strcmp(argv[i], "--predefines") == 0) { predefines = argv[i + 1]; i += 1; }
            else if (strcmp(argv[i], "--list") == 0) { list = argv[i + 1]; i += 1; }
            else if (strcmp(argv[i], "--out") == 0) { out = argv[i + 1]; i += 1; }
            else if (strcmp(argv[i], "--rounds") == 0) { if (pass == 0) { rounds = (uint32_t)atoi(argv[i + 1]); } i += 1; }
        }
    }
    static char* units[4096];
    uint32_t unit_count = 0;
    FILE* f = list != NULL ? fopen(list, "r") : NULL;
    if (f == NULL) { fprintf(stderr, "resident: no list\n"); return 2; }
    char line[4096];
    while (unit_count < 4096u && fgets(line, sizeof(line), f) != NULL)
    {
        line[strcspn(line, "\n")] = 0;
        if (line[0] != 0) { units[unit_count++] = strdup(line); }
    }
    fclose(f);
    for (uint32_t r = 0; r < rounds; r += 1)
    {
        memset(stage_ms, 0, sizeof(stage_ms));
        uint32_t taken = 0;
        uint64_t tokens_total = 0;
        double release_ms = 0;
        const double t0 = now_ms();
        for (uint32_t u = 0; u < unit_count; u += 1)
        {
            char output[4096];
            const char* base = strrchr(units[u], '/');
            snprintf(output, sizeof(output), "%s/%s.o", out, base != NULL ? base + 1 : units[u]);
            uint32_t tokens = 0;
            const CDirectRequest req = {
                .input_path = units[u],
                .output_path = output,
                .predefines_path = predefines,
                .directories = dirs,
                .directory_system = sys,
                .directory_count = dir_count,
                .angled_first = 0,
                .macros = macros,
                .macro_count = macro_count,
                .pic = true,
                .unwind_tables = true,
                .release = true,
                .mark_stage = mark,
                .stage_setup = 0,
                .stage_preprocess = 1,
                .stage_codegen = 2,
                .stage_object_write = 3,
                .out_token_count = &tokens,
            };
            stage_last = now_ms();
            const int status = c_direct_try_compile(&req);
            release_ms += now_ms() - stage_last;
            taken += status == 0;
            tokens_total += status == 0 ? tokens : 0;
        }
        const double total = now_ms() - t0;
        printf("round %u: %u units, %u taken, %llu tokens, %.3f ms (%.4f a unit): setup %.3f, preprocess %.3f, codegen %.3f, write %.3f, release and rest %.3f\n", r, unit_count, taken,
               (unsigned long long)tokens_total, total, total / (unit_count != 0 ? unit_count : 1), stage_ms[0], stage_ms[1], stage_ms[2], stage_ms[3], release_ms);
    }
    return 0;
}
