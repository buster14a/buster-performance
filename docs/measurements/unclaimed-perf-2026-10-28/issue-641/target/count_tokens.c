// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Original source-token classifier; preprocessing options are exactly the options used for compilation.
#define BUSTER_UNIT 99
#include "main-count.c"
_Thread_local ThreadContext thread_context = {
    .lane = {
        .index = 0,
        .count = 1,
        .group = NULL,
    },
};
int main(int argc, char** argv)
{
    int split = 1;
    while (split < argc && strcmp(argv[split], "--") != 0) split += 1;
    int result = split < argc ? 0 : 2;
    char** options = calloc((size_t)argc + 1, sizeof(char*));
    result = options != NULL ? result : 2;
    for (int i = 1; result == 0 && i < split; i += 1) options[i - 1] = argv[i];
    for (int file = split + 1; result == 0 && file < argc; file += 1)
    {
        Arena arena = arena_reserve(UINT64_C(1) << 26);
        PPOptions preprocessing;
        const char* input = NULL;
        const char* output = NULL;
        bool markers = false;
        options[split - 1] = argv[file];
        bool ready = arena.base != NULL && pp_parse_options(split, options, &preprocessing, &arena, &input, &output, &markers) && output == NULL;
        static InternTable identifiers;
        static Preprocessor pp;
        static Parser parser;
        const ParseOptions parsing = { .tree_only = true };
        ready = ready && intern_initialize(&identifiers) && pp_initialize(&pp, &preprocessing, &identifiers) &&
                parse_initialize(&parser, &parsing, preprocessing.language) && pp_run(&pp, input) && parse_translation_unit(&parser, &pp) && parser.errors == 0;
        if (ready)
        {
            printf("%u\t%s\t%s\n", parser.tokens.count, parser.tokens.count < 300 ? "under300" : parser.tokens.count >= 3000 ? "atleast3000" : "middle", argv[file]);
        }
        else
        {
            fprintf(stderr, "token classification failed: %s\n", argv[file]);
            result = 1;
        }
        parse_release(&parser);
        pp_release(&pp);
        intern_release(&identifiers);
        arena_release(&arena);
    }
    free(options);
    return result;
}
