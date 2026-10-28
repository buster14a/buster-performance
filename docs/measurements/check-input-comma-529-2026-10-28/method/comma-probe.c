// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Original local attribution probe. Preprocessing/traversal and allocations are outside kernel timing.
#define BUSTER_UNIT 2
#include <stdint.h>
static uint64_t diagnostic_walk_failures;
#include "main-standalone.c"
_Thread_local ThreadContext thread_context = { .lane = { .count = 1 } };

static uint64_t comma_probe_now(void)
{
    struct timespec value;
    clock_gettime(CLOCK_PROCESS_CPUTIME_ID, &value);
    return (uint64_t)value.tv_sec * UINT64_C(1000000000) + (uint64_t)value.tv_nsec;
}

int main(int argc, char** argv)
{
    thread_context.lane.count = 1;
    Arena arena = arena_reserve(UINT64_C(1) << 28);
    PPOptions options = { 0 };
    const char* file = NULL;
    const char* output = NULL;
    bool markers = false;
    static InternTable identifiers;
    static Preprocessor pp;
    static Parser parser;
    bool valid = arena.base != NULL && pp_parse_options(argc - 1, argv + 1, &options, &arena, &file, &output, &markers) && file != NULL;
    options.semantic_pragmas = true;
    const ParseOptions parse_options = { 0 };
    valid = valid && intern_initialize(&identifiers) && pp_initialize(&pp, &options, &identifiers) && pp_run(&pp, file) &&
            parse_initialize(&parser, &parse_options, options.language) && parse_translation_unit(&parser, &pp);
    const uint32_t count = valid ? parser.tokens.count : 0;
    uint8_t* expected = valid ? malloc((uint64_t)count + 1) : NULL;
    uint8_t* actual = valid ? malloc((uint64_t)count + 1) : NULL;
    valid = valid && expected != NULL && actual != NULL;
    CheckInputReader reader = { .parser = &parser, .postorder = parser.postorder, .expression_commas = expected };
    uint32_t separators = 0;
    uint32_t terminators = 0;
    uint32_t backward = 0;
    for (uint32_t token = 0; valid && token < count; token += 1)
    {
        const uint8_t role = parser.tree.roles[token];
        const uint32_t parent = parser.tree.parents[token];
        separators += role == PARSE_ROLE_SEPARATOR;
        terminators += role == PARSE_ROLE_TERMINATOR;
        backward += role == PARSE_ROLE_SEPARATOR && parent < count && parent <= token && parser.tree.roles[parent] == PARSE_ROLE_SEPARATOR;
    }
    uint64_t times[2] = { 0 };
    bool fast = true;
    const uint32_t rounds = 1000;
    for (uint32_t round = 0; valid && round < rounds; round += 1)
    {
        for (uint32_t order = 0; order < 2; order += 1)
        {
            const uint32_t path = order ^ (round & 1);
            reader.expression_commas = path == 0 ? expected : actual;
            const uint64_t begin = comma_probe_now();
            if (path == 0)
            {
                check_input_expression_commas_scalar(&reader);
            }
            else
            {
                fast &= check_input_expression_commas_vector(&reader);
                if (!fast) check_input_expression_commas_scalar(&reader);
            }
            times[path] += comma_probe_now() - begin;
        }
        valid = memcmp(expected, actual, count) == 0;
    }
    printf("comma probe: valid=%u tokens=%u separators=%u terminators=%u backward=%u fast=%u rounds=%u scalar_ns=%.3f vector_ns=%.3f\n",
           valid, count, separators, terminators, backward, fast, rounds, (double)times[0] / rounds, (double)times[1] / rounds);
    free(actual);
    free(expected);
    if (valid) parse_release(&parser);
    pp_release(&pp);
    intern_release(&identifiers);
    arena_release(&arena);
    return !valid;
}
