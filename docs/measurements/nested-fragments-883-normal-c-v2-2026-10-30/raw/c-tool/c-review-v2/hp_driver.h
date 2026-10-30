// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin.
#ifndef BUSTER_HP_DRIVER_H
#define BUSTER_HP_DRIVER_H

#include "hp_common.h"

#define BUSTER_HP_DRIVER_LOG_LIMIT ((size_t)1024 * 1024)
#define BUSTER_HP_DRIVER_TARGET "x86_64-unknown-linux-gnu"
#define BUSTER_HP_DRIVER_CPU "znver5"
#define BUSTER_HP_DRIVER_NAME_CAPACITY 64

typedef struct HpDriverIsa HpDriverIsa;
struct HpDriverIsa
{
    char executable[BUSTER_HP_PATH_CAPACITY];
    char triple[BUSTER_HP_DRIVER_NAME_CAPACITY];
    char cpu[BUSTER_HP_DRIVER_NAME_CAPACITY];
    HpArguments features;
};

// Parse a saved Linux Clang 23.1.4 -### receipt. mode is exactly -cc1/-cc1as.
// The receipt is immutable, output is zero initialized, features are owned.
// Only quoted argv is parsed; no shell evaluation or producer execution occurs.
// Exactly one command is accepted; executable canonical identity is a separate
// caller gate. Features preserve order and multiplicity without interpretation.
bool hp_driver_isa(HpBytes log, const char *mode, HpDriverIsa *output, char error[BUSTER_HP_ERROR_CAPACITY]);
void hp_driver_free(HpDriverIsa *isa);
// Compare the effective target, CPU and complete ordered feature vector.
// Executable strings are excluded: caller realpath-verifies against pinned CC.
bool hp_driver_equal(const HpDriverIsa *a, const HpDriverIsa *b);
// Accept exactly the pinned target bytes with zero or one trailing LF.
bool hp_driver_default_target(HpBytes output, char error[BUSTER_HP_ERROR_CAPACITY]);

#endif
