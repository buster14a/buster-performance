// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Original standalone adapter for the permanent worker ownership protocol tests.
#include "../issue-673-spawn/src/buster/compiler/worker_budget.c"
#include "../issue-673-spawn/src/buster/compiler/worker_budget_test.c"
int main(int argc, char** argv)
{
    const int guardian = worker_budget_guardian_command(argc, argv);
    alarm(30);
    return guardian >= 0 ? guardian : !worker_budget_test();
}
