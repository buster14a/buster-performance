// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Original focused adapter; the project main.c copy makes foreign module entries static and its unused driver static.
#include "main-standalone.c"
int main(void)
{
    CheckLanesTestTally tally = { 0 };
    char directory[] = "/tmp/buster-backend-startup-XXXXXX";
    const bool ready = mkdtemp(directory) != NULL;
    if (ready)
    {
        check_lanes_test_backend_startup(&tally, directory);
        rmdir(directory);
    }
    printf("backend-startup-parent: %llu checks, %llu failures\n", (unsigned long long)tally.checks, (unsigned long long)tally.failures);
    return !ready || tally.failures != 0;
}
