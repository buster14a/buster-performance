// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
// Linkage-only single-unit adapter: exact compiler bodies come from the selected frozen source snapshot.
#define BUSTER_UNIT BUSTER_UNIT_FRONTEND
#include "focused-main.c"

_Thread_local ThreadContext thread_context = { .lane = { .index = 0, .count = 1, .group = 0 } };

int main(int argc, char** argv)
{
    const bool epoch = oracle_epoch_begin();
    CheckTest test = { .random = 1 };
    int result = 0;
    if (argc > 1)
    {
        result = run_check_command(argc - 1, argv + 1, true);
    }
    else
    {
        check_test_const_values(&test);
        check_test_const_sources(&test, "/usr/bin/clang");
        check_test_const_alias_sources(&test, "/usr/bin/clang");
        check_test_const_programs(&test, "/usr/bin/clang");
        char directory[] = "/tmp/buster-const-focused-XXXXXX";
        const bool ready = mkdtemp(directory) != NULL;
        check_test_expect(&test, ready, "const driver family directory");
        if (ready)
        {
            check_test_driver_const(&test, "/usr/bin/clang", argv[0], directory);
            check_test_driver_recovery(&test, "/usr/bin/clang", argv[0], directory);
            rmdir(directory);
        }
        printf("const source, driver and recovery sanitizer adapter: %" PRIu64 " checks, %" PRIu64 " failures\n", test.checks, test.failures);
        result = test.failures != 0;
    }
    oracle_epoch_end(epoch);
    scratch_release();
    return result;
}
