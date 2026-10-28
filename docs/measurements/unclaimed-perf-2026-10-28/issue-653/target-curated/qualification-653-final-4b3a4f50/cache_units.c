// Original #653 qualification adapter. Project-default contribution terms.
#define _GNU_SOURCE
#include <stdint.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <limits.h>
#include <time.h>
#include <sys/mman.h>
#define BUSTER_ARRAY_LENGTH(x) (sizeof(x) / sizeof((x)[0]))
#include "buster/compiler/c_lexer.c"
#include "buster/compiler/lane.c"
#include "buster/compiler/c_intern.c"
#include "buster/compiler/c_refine.c"
#include "buster/compiler/c_predefines.c"
#include "buster/compiler/c_preprocessor.c"

static uint64_t now_ns(void)
{
    struct timespec value;
    clock_gettime(CLOCK_MONOTONIC, &value);
    return (uint64_t)value.tv_sec * 1000000000ull + (uint64_t)value.tv_nsec;
}

int main(int argc, char** argv)
{
    int result = 2;
    if (argc >= 4)
    {
        const bool shared = strcmp(argv[1], "shared") == 0;
        const bool fresh = strcmp(argv[1], "fresh") == 0;
        const uint32_t count = (uint32_t)strtoul(argv[2], 0, 10);
        Arena options_arena = arena_reserve_small(16ull << 20, 16ull << 20);
        PPOptions options = { 0 };
        const char* input = 0;
        const char* output = 0;
        bool markers = false;
        bool ready = (shared || fresh) && count > 0 && count <= 1000 && options_arena.base != 0 &&
                     pp_parse_options(argc - 3, argv + 3, &options, &options_arena, &input, &output, &markers) && input != 0;
        static InternTable table;
        static FileCache cache;
        static Preprocessor pp;
        uint64_t previous_opens = 0;
        uint64_t previous_entries = 0;
        for (uint32_t unit = 0; ready && unit < count; unit += 1)
        {
            char* diagnostic = 0;
            size_t diagnostic_bytes = 0;
            FILE* stream = open_memstream(&diagnostic, &diagnostic_bytes);
            options.diagnostics = stream;
            const uint64_t begin = now_ns();
            if (fresh || unit == 0)
            {
                ready = intern_initialize(&table) && file_cache_initialize(&cache, &table, pp_prepare_options(&options));
            }
            options.files = &cache;
            ready = ready && stream != 0 && pp_initialize(&pp, &options, &table) && pp_run(&pp, input);
            const uint64_t work = now_ns() - begin;
            if (stream != 0)
            {
                ready = fclose(stream) == 0 && ready;
            }
            uint64_t digest = intern_hash_bytes(pp.output.kinds, pp.output.count);
            digest ^= intern_hash_bytes(pp.output.flags, pp.output.count);
            digest ^= intern_hash_bytes((const uint8_t*)pp.output.values, (uint64_t)pp.output.count * sizeof(uint32_t));
            digest ^= intern_hash_bytes((const uint8_t*)pp.output.locations, (uint64_t)pp.output.count * sizeof(uint32_t));
            const uint64_t diagnostic_digest = intern_hash_bytes((const uint8_t*)diagnostic, diagnostic_bytes);
            uint64_t listing_opens = 0;
            uint64_t listing_entries = 0;
            uint64_t directory_skips = 0;
#ifdef ISSUE653
            listing_opens = cache.directory_opens;
            listing_entries = cache.directory_entries;
            directory_skips = pp.probes.directory_skips;
#endif
            const uint64_t opens = pp.probes.opens;
            const uint64_t fstats = pp.probes.fstats;
            const uint32_t tokens = pp.output.count;
            const uint64_t release_begin = now_ns();
            pp_release(&pp);
            if (fresh)
            {
                file_cache_release(&cache);
                intern_release(&table);
            }
            const uint64_t released = now_ns() - release_begin;
            printf("{\"mode\":\"%s\",\"unit\":%u,\"ok\":%u,\"work_ns\":%llu,\"release_ns\":%llu,\"total_ns\":%llu,\"tokens\":%u,\"digest\":\"%016llx\",\"diagnostic_bytes\":%zu,\"diagnostic_digest\":\"%016llx\",\"file_opens\":%llu,\"fstats\":%llu,\"listing_opens\":%llu,\"listing_entries\":%llu,\"directory_skips\":%llu}\n",
                   argv[1], unit, ready, (unsigned long long)work, (unsigned long long)released, (unsigned long long)(work + released), tokens,
                   (unsigned long long)digest, diagnostic_bytes, (unsigned long long)diagnostic_digest, (unsigned long long)opens, (unsigned long long)fstats,
                   (unsigned long long)(listing_opens - previous_opens), (unsigned long long)(listing_entries - previous_entries), (unsigned long long)directory_skips);
            previous_opens = shared ? listing_opens : 0;
            previous_entries = shared ? listing_entries : 0;
            if (!ready && diagnostic != 0)
            {
                fputs(diagnostic, stderr);
            }
            free(diagnostic);
        }
        if (shared)
        {
            const uint64_t released = now_ns();
            file_cache_release(&cache);
            intern_release(&table);
            printf("{\"shared_cache_release_ns\":%llu}\n", (unsigned long long)(now_ns() - released));
        }
        arena_release(&options_arena);
        result = ready ? 0 : 1;
    }
    return result;
}
