// Scratch probe for #117: a preprocessor run's parts timed apart, with their page faults.
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <dirent.h>
#include <fcntl.h>
#include <time.h>
#include <unistd.h>
#include <sys/mman.h>
#include <sys/stat.h>
#include <sys/resource.h>
#include <x86intrin.h>
#define BUSTER_ARRAY_LENGTH(x) (sizeof(x) / sizeof((x)[0]))
#include "buster/compiler/c_lexer.c"
#include "buster/compiler/lane.c"
#include "buster/compiler/c_intern.c"
#include "buster/compiler/c_refine.c"
#include "buster/compiler/c_predefines.c"
#include "buster/compiler/c_preprocessor.c"

static uint64_t system_us;
static uint64_t faults(void)
{
    struct rusage usage;
    getrusage(RUSAGE_SELF, &usage);
    system_us = (uint64_t)usage.ru_stime.tv_sec * 1000000 + (uint64_t)usage.ru_stime.tv_usec;
    return (uint64_t)usage.ru_minflt;
}

static int compare(const void* a, const void* b)
{
    const uint64_t x = *(const uint64_t*)a;
    const uint64_t y = *(const uint64_t*)b;
    return x < y ? -1 : x > y;
}

#define PARTS 7
static const char* names[PARTS] = { "intern_init", "pp_init", "prelude", "lookup", "main_file", "keywords", "release" };

int main(int argc, char** argv)
{
    PPOptions options;
    Arena arena = arena_reserve(1ull << 30);
    const char* input = 0;
    const char* output = 0;
    bool markers = true;
    int runs = 21;
    if (argc > 2 && strcmp(argv[1], "--runs") == 0)
    {
        runs = atoi(argv[2]);
        argv += 2;
        argc -= 2;
    }
    if (!pp_parse_options(argc - 1, argv + 1, &options, &arena, &input, &output, &markers) || input == 0)
    {
        fprintf(stderr, "bad options\n");
        return 1;
    }
    options.timing = true;
    options.no_history = getenv("PROBE_NO_HISTORY") != 0;
    static uint64_t samples[PARTS + PP_PHASE_COUNT + 1][64];
    static uint64_t fault_samples[PARTS][64];
    static uint64_t system_total[PARTS];
    static InternTable table;
    static Preprocessor pp;
    uint64_t output_tokens = 0;
    for (int run = 0; run < runs + 1; run += 1)
    {
        uint64_t t[PARTS + 1];
        uint64_t f[PARTS + 1];
        uint64_t s[PARTS + 1];
        f[0] = faults();
        s[0] = system_us;
        t[0] = __rdtsc();
        bool ok = intern_initialize(&table);
        f[1] = faults();
        s[1] = system_us;
        t[1] = __rdtsc();
        ok = ok && pp_initialize(&pp, &options, &table);
        f[2] = faults();
        s[2] = system_us;
        t[2] = __rdtsc();
        ok = ok && pp_run_prelude(&pp);
        f[3] = faults();
        s[3] = system_us;
        t[3] = __rdtsc();
        const uint32_t file = ok ? pp_lookup_path(&pp, input, (uint32_t)strlen(input), BUSTER_PP_USER_FILE) : BUSTER_PP_NONE;
        f[4] = faults();
        s[4] = system_us;
        t[4] = __rdtsc();
        if (file != BUSTER_PP_NONE && pp.files[file].data != BUSTER_PP_NONE)
        {
            pp.main_file = file;
            pp.include_depth = 0;
            pp_run_file(&pp, file);
        }
        f[5] = faults();
        s[5] = system_us;
        t[5] = __rdtsc();
        pp_resolve_keywords(&pp);
        f[6] = faults();
        s[6] = system_us;
        t[6] = __rdtsc();
        ok = ok && pp.errors == 0 && !pp.fatal;
        output_tokens = pp.output.count;
        if (getenv("PROBE_SMAPS") != 0 && run == 1)
        {
            // Every mapping's resident and huge-page bytes, before the release.
            // The run's arenas, by name, to label the mappings that hold them.
            struct { const char* name; const void* base; } labels[96];
            uint32_t label_count = 0;
#define PROBE_LABEL(n, b) do { if ((b) != 0 && label_count < 96) { labels[label_count].name = (n); labels[label_count].base = (b); label_count += 1; } } while (0)
            PROBE_LABEL("pp.arena", pp.arena.base);
            PROBE_LABEL("pp.columns[0] kinds", pp.columns[0].base);
            PROBE_LABEL("pp.columns[1] starts", pp.columns[1].base);
            PROBE_LABEL("pp.columns[2] values", pp.columns[2].base);
            PROBE_LABEL("pp.scratch[0]", pp.scratch[0].base);
            PROBE_LABEL("pp.scratch[1]", pp.scratch[1].base);
            PROBE_LABEL("output.kinds", pp.output.kinds);
            PROBE_LABEL("output.flags", pp.output.flags);
            PROBE_LABEL("output.values", pp.output.values);
            PROBE_LABEL("output.locations", pp.output.locations);
            PROBE_LABEL("arguments.kinds", pp.arguments.kinds);
            PROBE_LABEL("arguments.values", pp.arguments.values);
            PROBE_LABEL("captures.kinds", pp.captures.kinds);
            PROBE_LABEL("expansions.kinds", pp.expansions.kinds);
            PROBE_LABEL("expansions.values", pp.expansions.values);
            PROBE_LABEL("expansions.origins", pp.expansions.origins);
            PROBE_LABEL("arguments.origins", pp.arguments.origins);
            PROBE_LABEL("ranges", pp.ranges);
            PROBE_LABEL("datas", pp.datas);
            PROBE_LABEL("files", pp.files);
            PROBE_LABEL("file_slots", pp.file_slots);
            PROBE_LABEL("expansion_starts", pp.expansion_starts);
            PROBE_LABEL("macro_of", pp.macro_of);
            PROBE_LABEL("is_macro", pp.is_macro);
            PROBE_LABEL("poisoned", pp.poisoned);
            PROBE_LABEL("macros", pp.macros);
            PROBE_LABEL("items", pp.items);
            PROBE_LABEL("parameters", pp.parameters);
            PROBE_LABEL("contexts", pp.contexts);
            PROBE_LABEL("conditionals", pp.conditionals);
            PROBE_LABEL("invocations", pp.invocations);
            PROBE_LABEL("argument_records", pp.argument_records);
            PROBE_LABEL("capture_frames", pp.capture_frames);
            PROBE_LABEL("history", pp.history);
            PROBE_LABEL("substitutions", pp.substitutions);
            PROBE_LABEL("generated", pp.generated);
            PROBE_LABEL("history_sources", pp.history_sources);
            PROBE_LABEL("history_runs", pp.history_runs);
            PROBE_LABEL("history_initial", pp.history_initial.base);
            PROBE_LABEL("intern.arena", table.arena.base);
            PROBE_LABEL("intern.record_arena", table.record_arena.base);
            PROBE_LABEL("cache.records", pp.cache->records);
            PROBE_LABEL("cache.paths", pp.cache->paths);
            PROBE_LABEL("cache.path_arena", pp.cache->path_arena.base);
            PROBE_LABEL("cache.lane0.columns0", pp.cache->lanes[0].columns[0].base);
            PROBE_LABEL("cache.lane0.columns1", pp.cache->lanes[0].columns[1].base);
            PROBE_LABEL("cache.lane0.columns2", pp.cache->lanes[0].columns[2].base);
            PROBE_LABEL("cache.lane0.arena", pp.cache->lanes[0].arena.base);
            PROBE_LABEL("cache.lane0.bytes", pp.cache->lanes[0].bytes.base);
            PROBE_LABEL("cache.arrays[0]", pp.cache->arrays[0].base);
            PROBE_LABEL("cache.arrays[1]", pp.cache->arrays[1].base);
            PROBE_LABEL("cache.arrays[2]", pp.cache->arrays[2].base);
            PROBE_LABEL("cache.arrays[3]", pp.cache->arrays[3].base);
            PROBE_LABEL("cache.identity_slots", pp.cache->identity_slots);
            PROBE_LABEL("cache.path_slots", pp.cache->path_slots);
            for (uint32_t a = 0; a < pp.array_count; a += 1)
            {
                static char array_names[BUSTER_PP_ARRAYS][24];
                snprintf(array_names[a], sizeof(array_names[a]), "pp.arrays[%u]", a);
                PROBE_LABEL(array_names[a], pp.arrays[a].base);
            }
            printf("    pp.arena length %llu, intern arena %p length %llu, record_arena length %llu, macros %u (%zu B each), items %u, history %u, runs %u, substitutions %u, generated %u, sources %u, max ident %u\n",
                   (unsigned long long)pp.arena.length, (void*)table.arena.base, (unsigned long long)table.arena.length, (unsigned long long)table.record_arena.length,
                   pp.macro_count, sizeof(PPMacro), pp.item_count, pp.history_count, pp.history_run_count, pp.substitution_count, pp.generated_count, pp.history_source_count,
                   table.count);
#undef PROBE_LABEL
            FILE* smaps = fopen("/proc/self/smaps", "r");
            char line[512];
            char range[128] = { 0 };
            unsigned long rss = 0, huge = 0;
            unsigned long total_rss = 0, total_huge = 0;
            while (smaps != 0 && fgets(line, sizeof(line), smaps) != 0)
            {
                if (line[0] >= '0' && line[0] <= 'f' && strchr(line, '-') != 0 && strstr(line, " rw") != 0 && line[strlen(line) - 2] == ' ')
                {
                    sscanf(line, "%127s", range);
                }
                else if (strncmp(line, "Rss:", 4) == 0)
                {
                    sscanf(line + 4, "%lu", &rss);
                }
                else if (strncmp(line, "AnonHugePages:", 14) == 0)
                {
                    sscanf(line + 14, "%lu", &huge);
                    if (range[0] != 0 && rss != 0)
                    {
                        unsigned long low = 0, high = 0;
                        sscanf(range, "%lx-%lx", &low, &high);
                        char names[512] = { 0 };
                        for (uint32_t l = 0; l < label_count; l += 1)
                        {
                            const unsigned long address = (unsigned long)labels[l].base;
                            if (address >= low && address < high && strlen(names) + strlen(labels[l].name) + 2 < sizeof(names))
                            {
                                strcat(names, labels[l].name);
                                strcat(names, " ");
                            }
                        }
                        printf("    %-34s rss %8lu kB  huge %8lu kB  %s\n", range, rss, huge, names);
                        total_rss += rss;
                        total_huge += huge;
                    }
                    range[0] = 0;
                    rss = 0;
                }
            }
            printf("    anonymous total: rss %lu kB, huge %lu kB\n", total_rss, total_huge);
            if (smaps != 0)
            {
                fclose(smaps);
            }
        }
        if (getenv("PROBE_NAMES") != 0 && run == 1)
        {
            // Expansions by macro name: count, and what the macro is.
            static uint32_t counts[1u << 22];
            static uint32_t last_macro[1u << 22];
            for (uint32_t h = 0; h < pp.history_count; h += 1)
            {
                const IdentId name = pp.history[h].name;
                if (name < (1u << 22))
                {
                    counts[name] += 1;
                }
            }
            // The macro each name has at the end, for its flags.
            for (uint32_t m = 1; m < pp.macro_count; m += 1)
            {
                if (pp.macros[m].name < (1u << 22))
                {
                    last_macro[pp.macros[m].name] = m;
                }
            }
            FILE* out = fopen(getenv("PROBE_NAMES"), "w");
            for (uint32_t name = 0; name < (1u << 22) && out != 0; name += 1)
            {
                if (counts[name] != 0)
                {
                    const PPMacro* macro = &pp.macros[last_macro[name]];
                    fprintf(out, "%u %.*s flags=%x builtin=%u params=%u body=%u items=%u\n", counts[name], (int)intern_length(&table, name), intern_bytes(&table, name),
                            macro->flags, macro->builtin, macro->parameter_count, macro->body_end - macro->body_begin, macro->item_count);
                }
            }
            if (out != 0)
            {
                fclose(out);
            }
        }
        uint64_t phases[PP_PHASE_COUNT];
        memcpy(phases, pp.ticks, sizeof(phases));
        pp_release(&pp);
        intern_release(&table);
        f[7] = faults();
        s[7] = system_us;
        t[7] = __rdtsc();
        if (!ok)
        {
            fprintf(stderr, "run failed\n");
            return 1;
        }
        if (run > 0)
        {
            for (int p = 0; p < PARTS; p += 1)
            {
                samples[p][run - 1] = t[p + 1] - t[p];
                fault_samples[p][run - 1] = f[p + 1] - f[p];
                system_total[p] += s[p + 1] - s[p];
            }
            for (int p = 0; p < PP_PHASE_COUNT; p += 1)
            {
                samples[PARTS + p][run - 1] = phases[p];
            }
            samples[PARTS + PP_PHASE_COUNT][run - 1] = t[6] - t[0];
        }
    }
    // TSC to ms: measure the TSC rate.
    struct timespec a, b;
    clock_gettime(CLOCK_MONOTONIC, &a);
    const uint64_t ta = __rdtsc();
    do { clock_gettime(CLOCK_MONOTONIC, &b); } while ((b.tv_sec - a.tv_sec) * 1000000000ll + (b.tv_nsec - a.tv_nsec) < 2000000);
    const uint64_t tb = __rdtsc();
    const double ms_per_tick = ((b.tv_sec - a.tv_sec) * 1e3 + (b.tv_nsec - a.tv_nsec) / 1e6) / (double)(tb - ta);
    printf("%llu output tokens, %d runs, medians:\n", (unsigned long long)output_tokens, runs);
    for (int p = 0; p < PARTS + PP_PHASE_COUNT + 1; p += 1)
    {
        qsort(samples[p], runs, sizeof(uint64_t), compare);
        const char* name = p < PARTS ? names[p] : p < PARTS + PP_PHASE_COUNT ? (const char*[]){ "[read]", "[lex]", "[refine]", "[directives]" }[p - PARTS] : "whole run";
        if (p < PARTS)
        {
            qsort(fault_samples[p], runs, sizeof(uint64_t), compare);
            printf("  %-12s %8.3f ms  %6llu faults  %8.3f ms system (mean)\n", name, samples[p][runs / 2] * ms_per_tick, (unsigned long long)fault_samples[p][runs / 2], system_total[p] / 1000.0 / runs);
        }
        else
        {
            printf("  %-12s %8.3f ms\n", name, samples[p][runs / 2] * ms_per_tick);
        }
    }
    return 0;
}
