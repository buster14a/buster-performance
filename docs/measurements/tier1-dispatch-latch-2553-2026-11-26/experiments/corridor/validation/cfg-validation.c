// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin. See the buster repository's LICENSE and LICENSING.md.
//
// Standalone driver for the existing Tier 1 CFG tests at the source revision in README.md. It includes the project's
// implementation and independent tests directly; no copied implementation or replacement oracle lives here.
// BUSTER_CFG_SOURCE may name a temporary mutated tier1_cfg.c. BUSTER_CFG_FOCUSED_ONLY omits the full-suite entry point
// for the focused sanitizer build. The ordinary executable runs the full suite, or --focused for the #2553 fixtures.

#include <stdint.h>
#include <stdbool.h>
#include <inttypes.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define BUSTER_ARRAY_LENGTH(x) (sizeof(x) / sizeof((x)[0]))

#include "buster/compiler/lane.c"
#include "buster/compiler/dataflow.c"
#include "buster/compiler/dominators.c"
#include "buster/compiler/dominators_export.c"
#include "buster/compiler/dominators_test.c"
#include "buster/compiler/tier1_allocate.c"
#include "buster/compiler/tier1_certificate.c"
#include "buster/compiler/tier1_certificate_interval.c"
#include "buster/compiler/tier1_certificate_oracle.c"

#ifndef BUSTER_CFG_SOURCE
#define BUSTER_CFG_SOURCE "buster/compiler/tier1_cfg.c"
#endif
#include BUSTER_CFG_SOURCE

#include "buster/compiler/tier1_certificate_cfg.c"
#include "buster/compiler/tier1_cfg_test.c"

static int cfg_validation_focused(void)
{
    Arena output = arena_reserve(BUSTER_TIER1_CFG_TEST_ARENA);
    Arena scratch = arena_reserve(BUSTER_TIER1_CFG_TEST_ARENA);
    Tier1CfgTestTally tally = { 0 };
    const bool ready = output.base != 0 && scratch.base != 0;
    if (ready)
    {
        tally.oracle = true;
        tally.oracle_mutants = true;
        tier1_cfg_test_carried_predecessors(&tally);
        for (uint32_t variant = 0; variant < 4; variant += 1)
        {
            tier1_cfg_test_dispatch_latch(&tally, &output, &scratch, (variant & 1) != 0, (variant & 2) != 0);
        }
        printf("checks=%" PRIu64 " failures=%" PRIu64 "\n", tally.checks, tally.failures);
    }
    else
    {
        fprintf(stderr, "cfg-validation: cannot reserve test arenas\n");
    }
    arena_release(&scratch);
    arena_release(&output);
    return !ready || tally.failures != 0;
}

#ifdef BUSTER_CFG_FOCUSED_ONLY
int main(void)
{
    return cfg_validation_focused();
}
#else
int main(int argc, char** argv)
{
    const bool focused = argc == 2 && strcmp(argv[1], "--focused") == 0;
    const int result = focused ? cfg_validation_focused() : run_tier1_cfg_tests(argc - 1, argv + 1);
    return result;
}
#endif
