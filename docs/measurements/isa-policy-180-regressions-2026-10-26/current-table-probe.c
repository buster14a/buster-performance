// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin.
// Reproduce current-main table initialization under ASan; no timing.
#include "buster/compiler/tier0_benchmark.c"
int main(void)
{
    Tier0Tables tables;
    bool passed = x86_encoder_initialize() && x86_semantics_initialize() && tier0_initialize() && tier0_tables_open(&tables);
    if (passed)
    {
        tier0_tables_close(&tables);
    }
    return passed ? 0 : 1;
}
