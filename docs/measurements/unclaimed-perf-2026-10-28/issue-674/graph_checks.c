// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Original focused adapter for the project's retained-metadata and graph oracles.
#define BUSTER_UNIT 99
#include "buster/compiler/main.c"
_Thread_local ThreadContext thread_context = { .lane = { .count = 1 } };

int main(void)
{
    CheckTest test = { .random = 674 };
    CheckTestTypes types = { 0 };
    Arena storage = arena_reserve(UINT64_C(1) << 27);
    Arena output = arena_reserve(UINT64_C(1) << 28);
    Arena scratch = arena_reserve(UINT64_C(1) << 27);
    const bool ready = check_test_types_open(&types) && storage.base != NULL && output.base != NULL && scratch.base != NULL;
    check_test_expect(&test, ready, "focused graph adapter allocation");
    if (ready)
    {
        check_test_graph_recorded(&test, &types.table, &storage, &output, &scratch);
        check_test_graph_fixtures(&test, &types.table, &storage, &output, &scratch);
        check_test_graph_random(&test, &types.table, &storage, &output, &scratch);
        check_test_graph_guarded(&test, &types.table, &output, &scratch);
        check_test_graph_validation(&test, &storage);
    }
    arena_release(&scratch);
    arena_release(&output);
    arena_release(&storage);
    check_test_types_close(&types);
    scratch_release();
    fprintf(stderr, "focused graph: %" PRIu64 " checks, %" PRIu64 " failures\n", test.checks, test.failures);
    return test.failures != 0;
}
