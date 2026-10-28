// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Original diagnostic adapter: only source-family checks, classifying the concrete control failure predicate.
#include <stdint.h>
static uint64_t diagnostic_walk_failures;
#define main diagnostic_driver_main
#include "main-standalone.c"
#undef main

typedef void (*SourceFamily)(CheckTest*, const char*);
typedef struct Family Family;
struct Family
{
    const char* name;
    SourceFamily run;
};

int main(int argc, char** argv)
{
    const bool epoch = oracle_epoch_begin();
    const Family families[] = {
        { "sources", check_test_sources },
        { "initializer-nesting", check_test_initializer_nesting },
        { "member-scaling", check_test_member_scaling },
        { "source-extensions", check_test_source_extensions },
        { "overloads", check_test_overloads },
        { "overload-sources", check_test_overload_sources },
        { "constants", check_test_constant_sources },
        { "generic", check_test_generic_sources },
        { "enums", check_test_enum_sources },
        { "vlas", check_test_vla_sources },
        { "transparent-types", check_test_transparent_types },
        { "integer-extensions", check_test_integer_extensions },
        { "function-names", check_test_function_names },
        { "pragmas", check_test_pragmas },
        { "attributes", check_test_attributes },
        { "attribute-sources", check_test_attribute_sources },
    };
    uint64_t failures = 0;
    uint64_t walks = 0;
    for (unsigned i = 0; i < BUSTER_ARRAY_LENGTH(families); i += 1)
    {
        if (argc > 1 && strcmp(argv[1], families[i].name) != 0)
        {
            continue;
        }
        CheckTest test = { .random = 678 };
        diagnostic_walk_failures = 0;
        families[i].run(&test, "clang");
        printf("family=%s checks=%llu failures=%llu walk_predicate_failures=%llu unexpected=%llu\n", families[i].name,
               (unsigned long long)test.checks, (unsigned long long)test.failures, (unsigned long long)diagnostic_walk_failures,
               (unsigned long long)(test.failures - diagnostic_walk_failures));
        failures += test.failures;
        walks += diagnostic_walk_failures;
    }
    CheckTestTypes types = { 0 };
    const bool typed = argc == 1 || strcmp(argv[1], "typed-source-families") == 0;
    const bool ready = !typed || check_test_types_open(&types);
    if (ready && typed)
    {
        CheckTest test = { .random = 678 };
        diagnostic_walk_failures = 0;
        check_test_builtin_graph(&test, &types.table, "clang");
        check_test_special_graph(&test, &types.table, "clang");
        check_test_transparent_calls(&test, &types.table, "clang");
        check_test_complex(&test, &types.table, "clang");
        check_test_vectors(&test, &types.table, "clang");
        printf("family=typed-source-families checks=%llu failures=%llu walk_predicate_failures=%llu unexpected=%llu\n",
               (unsigned long long)test.checks, (unsigned long long)test.failures, (unsigned long long)diagnostic_walk_failures,
               (unsigned long long)(test.failures - diagnostic_walk_failures));
        failures += test.failures;
        walks += diagnostic_walk_failures;
        check_test_types_close(&types);
    }
    printf("total_failures=%llu walk_predicate_failures=%llu unexpected=%llu types_ready=%u\n", (unsigned long long)failures,
           (unsigned long long)walks, (unsigned long long)(failures - walks), ready);
    oracle_epoch_end(epoch);
    return !ready || failures != walks;
}
