// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Original focused test entry point; included modules retain their own terms.
#include "buster/compiler/main_unit_frontend.c"
_Thread_local ThreadContext thread_context = { .lane = { .count = 1 } };

int main(int argc, char** argv)
{
    (void)argv;
    char directory[] = "/tmp/buster-615-XXXXXX";
    const bool made = mkdtemp(directory) != 0;
    const bool passed = made && pp_test_many_parameters(directory, argc > 1);
    if (made)
    {
        rmdir(directory);
    }
    return !passed;
}
