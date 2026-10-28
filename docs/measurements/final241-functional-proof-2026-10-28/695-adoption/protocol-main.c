// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Original standalone adapter for the permanent worker ownership protocol tests.
#define _GNU_SOURCE
#include "worker_budget.c"
#include "worker_budget_test.c"
int main(int argc, char** argv)
{
    const int guardian = worker_budget_guardian_command(argc, argv);
    if (guardian >= 0)
    {
        return guardian;
    }
    alarm(30);
    return !worker_budget_test();
}
