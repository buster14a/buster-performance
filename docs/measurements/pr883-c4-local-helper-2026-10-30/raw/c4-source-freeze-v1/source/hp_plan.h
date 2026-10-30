// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin.
#ifndef BUSTER_HP_PLAN_H
#define BUSTER_HP_PLAN_H

#include "hp_common.h"

#define BUSTER_HP_SOURCE_LIMIT 256U

typedef struct HpSourcePlan HpSourcePlan;
struct HpSourcePlan
{
    const char *values[BUSTER_HP_SOURCE_LIMIT];
    size_t count;
    size_t checker_index;
};

typedef struct HpPlanArguments HpPlanArguments;
struct HpPlanArguments
{
    const char *values[BUSTER_HP_ARGUMENT_LIMIT + 1];
    size_t count;
};

// Plans own their pointer arrays and borrow all strings. No shell, producer or
// filesystem is invoked. Use separate input/output storage. Successful argv
// always has values[count] == NULL; failure clears the entire output plan.
// Source paths are lexical project-relative ASCII .c paths with no empty,
// dot or dotdot component and exactly one main_unit_checker.c basename.
// Canonical filesystem ownership and source/flag identities are caller gates.
bool hp_plan_sources(const HpArguments *sources, HpSourcePlan *output, char error[BUSTER_HP_ERROR_CAPACITY]);
// Read base10 digits only (leading zeroes allowed), bounded by maximum.
// Failure clears *output. Signs, whitespace and overlong strings are refused.
bool hp_plan_decimal(const char *text, uint64_t maximum, uint64_t *output, char error[BUSTER_HP_ERROR_CAPACITY]);
// These preserve the supplied C flag vector exactly. The independent exact
// hp_validate_flags allowlist must pass before a producer uses the plan.
bool hp_plan_compile(const char *cc, const char *source, const char *object, const char *json, const HpArguments *flags, HpPlanArguments *output, char error[BUSTER_HP_ERROR_CAPACITY]);
bool hp_plan_assembly(const char *cc, const char *source, const char *assembly, const HpArguments *flags, HpPlanArguments *output, char error[BUSTER_HP_ERROR_CAPACITY]);
// The assembler receives only this method's explicit pinned target/CPU flags.
bool hp_plan_assemble(const char *cc, const char *assembly, const char *object, HpPlanArguments *output, char error[BUSTER_HP_ERROR_CAPACITY]);
// Objects stay in source order; replacement, if non-NULL, occupies exactly the
// checker_index slot. A valid checker_index is required even without replacing.
bool hp_plan_link(const char *cc, const HpArguments *objects, size_t checker_index, const char *replacement, const char *image, HpPlanArguments *output, char error[BUSTER_HP_ERROR_CAPACITY]);

#endif
