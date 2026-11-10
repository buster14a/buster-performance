// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin. See LICENSE and README.md.

#define main original_regression_main
#include "tools/ci/build_regression.c"
#undef main
int main(void)
{
    check_ownership_fixtures();
    return 0;
}
