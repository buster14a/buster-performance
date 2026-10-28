// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Original standalone adapter for the permanent worker ownership protocol tests.
#define _GNU_SOURCE
#include "../issue-673/src/buster/compiler/worker_budget.c"
#include "../issue-673/src/buster/compiler/worker_budget_test.c"
int main(void)
{
    alarm(30);
    return !worker_budget_test();
}
