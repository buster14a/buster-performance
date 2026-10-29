// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Original offline body-cost experiment. Profiles one lane's walk, outside its
// copy/position/merge phases; histogram collection is outside the timed region.
#define main buster_unused_main
#include "main-profile-copy.c"
#undef main

int main(int argc, char** argv)
{
    Arena option_arena = arena_reserve(UINT64_C(1) << 24);
    PPOptions options = { 0 };
    const char* file = NULL;
    const char* output = NULL;
    bool markers = false;
    const uint32_t passes = 9;
    bool valid = pp_parse_options(argc - 1, argv + 1, &options, &option_arena, &file, &output, &markers) && file != NULL && output == NULL;
    options.semantic_pragmas = true;
    InternTable identifiers = { 0 };
    Preprocessor pp = { 0 };
    Parser parser = { 0 };
    const ParseOptions parsing = { 0 };
    valid = valid && intern_initialize(&identifiers) && pp_initialize(&pp, &options, &identifiers) && pp_run(&pp, file) &&
            parse_initialize(&parser, &parsing, options.language) && parse_translation_unit(&parser, &pp) && parser.errors == 0;
    Arena arenas[4] = { arena_reserve(UINT64_C(1) << 36), arena_reserve(UINT64_C(1) << 34), arena_reserve(UINT64_C(1) << 36), arena_reserve(UINT64_C(1) << 36) };
    CheckDeferred deferred = { 0 };
    uint64_t* samples = NULL;
    uint32_t bodies = 0;
    for (uint32_t pass = 0; valid && pass < passes; pass += 1)
    {
        uint64_t whole = 0;
        valid = check_deferred_benchmark_run(&parser, &pp, arenas, 1, NULL, true, &deferred, &whole) && !deferred.unsupported;
        if (valid && pass == 0)
        {
            bodies = deferred.body_count;
            samples = calloc((size_t)bodies * passes + 1, sizeof(uint64_t));
            valid = samples != NULL;
        }
        valid = valid && deferred.body_count == bodies;
        for (uint32_t body = 0; valid && body < bodies; body += 1)
        {
            samples[(uint64_t)body * passes + pass] = deferred.results[body].offline_walk_ns;
            fprintf(stderr, "body-sample: file=%s body=%u pass=%u walk_ns=%" PRIu64 "\n", file, body, pass, deferred.results[body].offline_walk_ns);
        }
        // The nine passes are the first reading of nine fresh states. Keep only
        // the last for its body ranges, then release it after writing rows.
        if (pass + 1 < passes) check_deferred_release(&deferred);
    }
    if (valid)
    {
        printf("file\tbody\ttokens\twalk_ns");
        for (uint32_t kind = 0; kind < PARSE_KIND_COUNT; kind += 1) printf("\t%s", parse_kind_names[kind]);
        putchar('\n');
        for (uint32_t body = 0; body < bodies; body += 1)
        {
            const CheckDeferredCut* cut = deferred.cuts + body;
            uint32_t counts[PARSE_KIND_COUNT] = { 0 };
            for (uint32_t token = cut->opening; token <= cut->closing; token += 1)
            {
                valid = valid && parser.tokens.kinds[token] < PARSE_KIND_COUNT;
                if (valid) counts[parser.tokens.kinds[token]] += 1;
            }
            uint64_t sum = 0;
            for (uint32_t kind = 0; kind < PARSE_KIND_COUNT; kind += 1) sum += counts[kind];
            valid = valid && sum == cut->closing - cut->opening + 1;
            printf("%s\t%u\t%u\t%" PRIu64, file, body, cut->closing - cut->opening + 1, check_source_median(samples + (uint64_t)body * passes, passes));
            for (uint32_t kind = 0; kind < PARSE_KIND_COUNT; kind += 1) printf("\t%u", counts[kind]);
            putchar('\n');
        }
        fprintf(stderr, "profile: kinds=%u bodies=%u passes=%u merged=yes first_read_state=yes\n", PARSE_KIND_COUNT, bodies, passes);
    }
    else fprintf(stderr, "profile: failed or unsupported, reason=%s\n", deferred.reason != NULL ? deferred.reason : "preprocess/parse/setup");
    free(samples);
    check_deferred_release(&deferred);
    for (uint32_t arena = 0; arena < 4; arena += 1) arena_release(arenas + arena);
    parse_release(&parser);
    pp_release(&pp);
    intern_release(&identifiers);
    arena_release(&option_arena);
    return valid ? 0 : 1;
}
