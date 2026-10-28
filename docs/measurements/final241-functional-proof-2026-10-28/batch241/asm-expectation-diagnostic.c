// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Original focused diagnostic for the requested-versus-selected parser contract in #628/#678.
// main-standalone.c preserves the exact frozen main.c, with only BUSTER_ELSEWHERE emptied for single-unit linkage.
#define main buster_unused_main
#include "main-standalone.c"
#undef main

int main(int argc, char** argv)
{
    static const char* const sources[] =
    {
        "int f(int x){return x+1;}",
        "extern int f(int) __asm__(\"alias\");int g(int x){return f(x);}",
        "int f(int x){__asm__(\"\" : \"+r\"(x));return x;}",
    };
    const PPOptions options = { .language = { .standard = 2017, .gnu = true }, .no_standard_includes = true };
    uint32_t original_failures = 0;
    uint32_t corrected_failures = 0;
    uint32_t cases = 0;
    for (uint32_t source = 0; source < BUSTER_ARRAY_LENGTH(sources); source += 1)
    {
        for (uint32_t requested = 0; requested < 2; requested += 1)
        {
            static InternTable identifiers;
            static Preprocessor pp;
            static Parser parser;
            CheckCorpusPath path = { 0 };
            const bool ready = intern_initialize(&identifiers) && pp_initialize(&pp, &options, &identifiers) &&
                               pp_run_source(&pp, "asm-expectation.c", (const uint8_t*)sources[source], strlen(sources[source])) &&
                               check_corpus_check(&path, &parser, &pp, requested != 0);
            const bool statements = source == 2;
            uint32_t marked = 0;
            for (uint32_t token = 0; ready && token <= parser.tokens.count; token += 1)
            {
                marked += check_input_asm_id(&path.input, token) != 0;
            }
            const bool counts = ready && path.input.asm_count == (uint32_t)statements &&
                                path.input.asm_capacity == (uint32_t)(source != 0) && (marked != 0) == statements;
            const bool present = path.input.asm_ids != NULL;
            const bool original = counts && present == (requested != 0 || statements);
            const bool corrected = counts && present == (parser.options.scalar || statements);
            printf("host_vector=%u source=%u requested_scalar=%u parser_scalar=%u asm_column=%u count=%u capacity=%u marked=%u original=%u corrected=%u\n",
                   (uint32_t)BUSTER_HOST_VECTOR, source, requested, (uint32_t)parser.options.scalar, (uint32_t)present,
                   path.input.asm_count, path.input.asm_capacity, marked, (uint32_t)original, (uint32_t)corrected);
            original_failures += !original;
            corrected_failures += !corrected;
            cases += 1;
            check_corpus_close(&path);
            parse_release(&parser);
            pp_release(&pp);
            intern_release(&identifiers);
        }
    }
    printf("asm expectation diagnostic: %u cases, original failures=%u, corrected failures=%u\n", cases, original_failures, corrected_failures);
    int result = corrected_failures != 0;
    if (argc == 2 && strcmp(argv[1], "--full") == 0)
    {
        char* args[] = { "--clang", "clang" };
        result |= run_checker_asm_tests(2, args);
    }
    return result;
}
