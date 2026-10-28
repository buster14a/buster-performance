// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Original narrow adapter: actual merged production reader and permanent NONE fixtures.
#include <stddef.h>
#include <stdint.h>
#include <string.h>
static void* observed_memset(void* destination, int byte, size_t bytes);
#define memset observed_memset
#define main buster_unused_main
#include "main-standalone.c"
#undef main
#undef memset
#ifndef EXPECT_HOST_VECTOR
#error EXPECT_HOST_VECTOR must name the expected real header selection
#endif
_Static_assert(BUSTER_HOST_VECTOR == EXPECT_HOST_VECTOR, "actual current host header selects the intended mode");

static CheckInput* observed_input;
static uint32_t fill_calls[13];

static void* observed_memset(void* destination, int byte, size_t bytes)
{
    if (observed_input != NULL && (uint8_t)byte == UINT8_MAX && bytes == ((uint64_t)observed_input->token_count + 1) * sizeof(uint32_t))
    {
        const uint32_t* columns[] =
        {
            observed_input->declarations, observed_input->initializer_nodes, observed_input->initializer_begins,
            observed_input->initializer_ends, observed_input->token_nodes, observed_input->body_declarations,
            observed_input->declaration_bodies, observed_input->parameter_next, observed_input->control_owners,
            observed_input->label_targets, observed_input->case_ranges, observed_input->string_ids, observed_input->parameters,
        };
        for (uint32_t column = 0; column < BUSTER_ARRAY_LENGTH(columns); column += 1)
        {
            fill_calls[column] += destination != NULL && destination == columns[column];
        }
    }
    return memset(destination, byte, bytes);
}

static void reader_contract(CheckTest* test)
{
    const char* const sources[] = { "", "int marker;\n" };
    for (uint32_t fixture = 0; fixture < BUSTER_ARRAY_LENGTH(sources); fixture += 1)
    {
        uint32_t expected[13][16];
        uint32_t expected_count = 0;
        for (uint32_t path = 0; path < 2; path += 1)
        {
            const bool requested_scalar = path == 0;
            InternTable identifiers = { 0 };
            Preprocessor pp = { 0 };
            Parser parser = { 0 };
            CheckTestTypes types = { 0 };
            CheckInput input = { 0 };
            Arena output = arena_reserve(UINT64_C(1) << 26);
            Arena scratch = arena_reserve(UINT64_C(1) << 26);
            const PPOptions preprocessing = { .language = { .standard = 2017, .gnu = true }, .no_standard_includes = true };
            const ParseOptions parsing = { .scalar = requested_scalar };
            bool ready = output.base != NULL && scratch.base != NULL && intern_initialize(&identifiers) &&
                         pp_initialize(&pp, &preprocessing, &identifiers) && parse_initialize(&parser, &parsing, preprocessing.language) &&
                         pp_run_source(&pp, "fill-contract.c", (const uint8_t*)sources[fixture], strlen(sources[fixture])) &&
                         parse_translation_unit(&parser, &pp) && check_test_types_open(&types);
            memset(fill_calls, 0, sizeof(fill_calls));
            observed_input = &input;
            ready = ready && check_input(&input, &parser, &pp, &types.table, &output, &scratch);
            observed_input = NULL;
            check_test_expect(test, ready && parser.options.scalar == requested_scalar,
                              "the real reader preserves the caller's requested scalar policy on each host mode");
            if (ready)
            {
                const uint32_t* columns[] =
                {
                    input.declarations, input.initializer_nodes, input.initializer_begins, input.initializer_ends,
                    input.token_nodes, input.body_declarations, input.declaration_bodies, input.parameter_next,
                    input.control_owners, input.label_targets, input.case_ranges, input.string_ids, input.parameters,
                };
                bool exact = input.token_count < BUSTER_ARRAY_LENGTH(expected[0]) && scratch.length == 0;
                for (uint32_t column = 0; exact && column < BUSTER_ARRAY_LENGTH(columns); column += 1)
                {
                    exact = columns[column] != NULL && fill_calls[column] == (requested_scalar ? 0u : 1u);
                    for (uint32_t token = 0; exact && token <= input.token_count; token += 1)
                    {
                        if (requested_scalar)
                        {
                            expected[column][token] = columns[column][token];
                        }
                        else
                        {
                            exact = input.token_count == expected_count && columns[column][token] == expected[column][token];
                        }
                    }
                }
                expected_count = requested_scalar ? input.token_count : expected_count;
                check_test_expect(test, exact,
                                  "requested scalar executes the original stores; default executes thirteen bounded fills and publishes identical columns");
                printf("host=%u fixture=%u requested_scalar=%u tokens=%u bulk_calls=%u exact=%u\n",
                       BUSTER_HOST_VECTOR, fixture, requested_scalar, input.token_count, fill_calls[0], exact);
            }
            check_test_types_close(&types);
            parse_release(&parser);
            pp_release(&pp);
            intern_release(&identifiers);
            arena_release(&output);
            arena_release(&scratch);
        }
    }
}

int main(void)
{
    CheckTest test = { .random = 628 };
    check_test_output_none(&test);
    reader_contract(&test);
    printf("fill-host-compat: host=%u checks=%llu failures=%llu\n", BUSTER_HOST_VECTOR,
           (unsigned long long)test.checks, (unsigned long long)test.failures);
    return test.failures != 0;
}
