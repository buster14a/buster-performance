#include "buster/compiler/host_isa.h"
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/mman.h>
#include "buster/compiler/lane.c"
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused-function"
#include "buster/compiler/x86_64_encoder.c"
#include "buster/compiler/branch_sizing.c"
#pragma clang diagnostic pop
BranchSizingCheck wrapped_validate_branches(const X86Instruction* r, uint64_t c, const uint32_t* b, const uint32_t* t, uint64_t n) { return branch_sizing_validate_branches(r, c, b, t, n); }
