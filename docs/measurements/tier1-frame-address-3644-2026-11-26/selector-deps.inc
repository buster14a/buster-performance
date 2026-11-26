// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
//
// Original frozen synthetic IR -> selection -> effective uses -> liveness -> allocation -> frame/fragments -> encoder.
// Separate selection and complete-pipeline rows include verification and arena resets. No source/corpus or generated
// run-time performance is inferred. Timing uses elapsed nanoseconds and invariant TSC ticks, explicitly not core cycles.
// The 9700X invocation takes its shared per-run lock and CPU 2 pin.

#include "host_isa.h"
#include <stdint.h>
#include <stdbool.h>
#include <stddef.h>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <inttypes.h>
#include <time.h>
#include <assert.h>

#ifndef BUSTER_ARRAY_LENGTH
#define BUSTER_ARRAY_LENGTH(x) (sizeof(x) / sizeof((x)[0]))
#endif

typedef struct String8 String8;
struct String8
{
    char* pointer;
    uint64_t length;
};

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused-function"
#include "buster/compiler/x86_64_encoder.c"
#include "buster/compiler/lane.c"
#include "buster/compiler/link.c"
#include "buster/compiler/x86_semantics.c"
#include "buster/compiler/x86_target.c"
#include "buster/compiler/x86_target_forms.c"
#include "buster/compiler/x86_zen5.c"
#include "buster/compiler/dataflow.c"
#include "buster/compiler/dominators.c"
#include "buster/compiler/c_types.c"
#include "buster/compiler/calling_convention.c"
// Tier 0's machine rows are the IR's row calls' (#141, IrFunction.rows), which Tier 1 places as Tier 0 does.
#include "buster/compiler/branch_sizing.c"
#include "buster/compiler/tier0.c"
#include "buster/compiler/ir.c"
#include "buster/compiler/tier1_select.c"
#include "buster/compiler/tier1_allocate.c"
#include "buster/compiler/tier1_rematerialize.c"
#include "buster/compiler/tier1_certificate.c"
#include "buster/compiler/tier1_certificate_interval.c"
#include "buster/compiler/tier1_cfg.c"
#include "buster/compiler/tier1_certificate_cfg.c"
#include "buster/compiler/tier1_liveness.c"
#include "buster/compiler/emission_metadata.c"
#include "buster/compiler/tier1_frame.c"
#include "buster/compiler/tier1_frame_emit.c"
#include "buster/compiler/tier1_emit.c"
#pragma clang diagnostic pop
