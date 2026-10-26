// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin.
// Positive control: compile with only the candidate's src include directory. Negative control: put
// negative-overlay first. It appends an unrepresentable canonical row and must fail the actual production guard.
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#pragma clang diagnostic ignored "-Wunused-function"
#include "buster/compiler/x86_64_encoder.c"
#include "buster/compiler/x86_target_forms.c"

int main(void)
{
    return 0;
}
