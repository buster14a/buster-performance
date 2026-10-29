// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
//
// main.c compiled as the unit of the x86-64 encoder's, disassembler's and branch sizing's tests and the Zen 5 model's
// commands: main.c, at its top, says how its units divide the build.
#define BUSTER_UNIT BUSTER_UNIT_X86
#include "buster/compiler/main.c"

// abZ5: base's code placed where the head's is (not part of any commit).
__attribute__((used, retain)) static const unsigned char buster_rodata_padding[31308] = { 1 };
