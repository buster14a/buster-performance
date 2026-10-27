// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin.
// Same standalone driver for both sides; only the pinned experimental patch differs.
#define BUSTER_UNIT 6
#include "buster/compiler/main.c"
_Thread_local ThreadContext thread_context = {
    .lane = {
        .count = 1,
    },
};
int main(int argc, char** argv)
{
    return run_foreign_link(argc - 1, argv + 1);
}
