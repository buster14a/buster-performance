// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Original observation of the actual tree_only production reader, before the context pass writes its scratch.
#define BUSTER_UNIT 2
#include <stdint.h>
static uint64_t diagnostic_walk_failures;
static void comma_page_probe(void* opaque);
#include "main-pages.c"
_Thread_local ThreadContext thread_context = { .lane = { .count = 1 } };
static unsigned comma_page_probes;
static bool comma_page_valid = true;

static void comma_page_probe(void* opaque)
{
    const CheckInputReader* source = opaque;
    const Parser* parser = source->parser;
    const uint32_t count = parser->tokens.count;
    const uint64_t page = (uint64_t)sysconf(_SC_PAGESIZE);
    const uintptr_t address = (uintptr_t)source->expression_commas;
    const uint64_t offset = address % page;
    const uint64_t pages = (offset + count + page - 1) / page;
    uint8_t* seen = calloc((uint64_t)count + 1, 1);
    uint8_t* old_pages = calloc(pages + 1, 1);
    uint8_t* new_pages = calloc(pages + 1, 1);
    uint8_t* expected = malloc((uint64_t)count + 1);
    uint8_t* actual = malloc((uint64_t)count + 1);
    bool valid = seen != NULL && old_pages != NULL && new_pages != NULL && expected != NULL && actual != NULL;
    uint32_t unique = 0;
    for (uint32_t position = count; valid && position != 0; )
    {
        const uint32_t token = source->postorder[--position];
        valid = token < count && seen[token] == 0;
        if (valid)
        {
            seen[token] = 1;
            unique += 1;
            // The original pass writes one byte at each actual production postorder token.
            old_pages[(offset + token) / page] = 1;
        }
    }
    for (uint32_t end = count; valid && end != 0; )
    {
        const uint32_t first = end > 64 ? end - 64 : 0;
        // The masked native store writes exactly [first,end); sparse corrections cannot add another page.
        for (uint32_t token = first; token < end; token += 1) new_pages[(offset + token) / page] = 1;
        end = first;
    }
    uint64_t old_count = 0, new_count = 0;
    for (uint64_t at = 0; valid && at < pages; at += 1)
    {
        old_count += old_pages[at];
        new_count += new_pages[at];
        valid = old_pages[at] == new_pages[at];
    }
    bool fast = false;
    if (valid)
    {
        memset(expected, 0xa5, (uint64_t)count + 1);
        memset(actual, 0x5a, (uint64_t)count + 1);
        CheckInputReader reader = *source;
        reader.expression_commas = expected;
        check_input_expression_commas_scalar(&reader);
        reader.expression_commas = actual;
        fast = check_input_expression_commas_vector(&reader);
        if (!fast) check_input_expression_commas_scalar(&reader);
        valid = memcmp(expected, actual, count) == 0 && expected[count] == 0xa5 && actual[count] == 0x5a;
    }
    printf("production-page-proof: tree_only=%u derived_postorder=%u tokens=%u unique_postorder=%u output_offset=%llu page_bytes=%llu old_write_pages=%llu new_write_pages=%llu fast=%u bytes_equal=%u\n",
           parser->options.tree_only, source->postorder != parser->postorder, count, unique,
           (unsigned long long)offset, (unsigned long long)page, (unsigned long long)old_count,
           (unsigned long long)new_count, fast, valid);
    comma_page_valid &= valid && unique == count && parser->options.tree_only && source->postorder != parser->postorder;
    comma_page_probes += 1;
    free(actual); free(expected); free(new_pages); free(old_pages); free(seen);
}

int main(int argc, char** argv)
{
    Arena options_arena = arena_reserve(UINT64_C(1) << 28);
    PPOptions options = { 0 };
    const char* file = NULL;
    const char* output_file = NULL;
    bool markers = false;
    static InternTable identifiers;
    static Preprocessor pp;
    static Parser parser;
    bool valid = options_arena.base != NULL && pp_parse_options(argc - 1, argv + 1, &options, &options_arena,
                                                               &file, &output_file, &markers) && file != NULL;
    options.semantic_pragmas = true;
    const ParseOptions parse_options = { .tree_only = true };
    valid = valid && intern_initialize(&identifiers) && pp_initialize(&pp, &options, &identifiers) && pp_run(&pp, file) &&
            parse_initialize(&parser, &parse_options, options.language) && parse_translation_unit(&parser, &pp);
    const uint32_t count = parser.tokens.count;
    valid = valid && count < (1u << 27);
    const TypeCapacity capacity = { .types = count * 4 + 64, .parameters = count + 1, .tags = count + 1, .members = count + 1 };
    Arena types_arena = arena_reserve(type_capacity_bytes(capacity));
    Arena index_arena = arena_reserve(type_index_capacity_bytes(capacity));
    Arena output = arena_reserve(UINT64_C(1) << 36);
    Arena scratch = arena_reserve(UINT64_C(1) << 36);
    TypeTable types;
    CheckInput input;
    valid = valid && type_initialize(&types, &types_arena, &index_arena, capacity) &&
            check_input_compile(&input, &parser, &pp, &types, &output, &scratch, true, count, NULL) &&
            comma_page_valid && comma_page_probes == 1;
    printf("production-page-proof-result: probes=%u valid=%u\n", comma_page_probes, valid);
    arena_release(&scratch); arena_release(&output); arena_release(&index_arena); arena_release(&types_arena);
    parse_release(&parser); pp_release(&pp); intern_release(&identifiers); arena_release(&options_arena);
    return !valid;
}
