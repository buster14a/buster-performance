// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin.
// Exercise the production projection's real compile-time guard through its actual row source.
#include_next "buster/compiler/x86_target_rows.c"
BUSTER_X86_TARGET_REQUIREMENT(NONE, BUSTER_X86_TARGET_KNOWN | BUSTER_X86_FEATURE(AVX512BF16))
