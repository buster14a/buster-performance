// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Instrumented source driver only: copy main.c to main-probe.c, replacing BUSTER_ELSEWHERE's
// inline/noinline definition by static, and instrument c_check_attribute.c with instrument.c.
// This folds module homes into one translation unit; no timing from this executable is evidence.
#define BUSTER_UNIT 99
#include "main-probe.c"

_Thread_local ThreadContext thread_context = { .lane = { .count = 1 } };

int main(int argc, char** argv)
{
    return run_check_command(argc - 1, argv + 1, true);
}
