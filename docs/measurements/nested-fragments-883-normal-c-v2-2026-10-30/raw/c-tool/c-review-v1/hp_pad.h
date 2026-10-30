// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin.
#ifndef BUSTER_HP_PAD_H
#define BUSTER_HP_PAD_H

#include "hp_elf.h"

// Parse only the supported generated-assembly context. The caller owns input
// and receives a separately allocated output, freed with free(). On failure,
// output, size and anchor are cleared. Shift zero is byte-identical input.
// No source, assembler, compiler or executable is invoked by this function.
bool hp_pad_hot(HpBytes input, uint64_t shift, unsigned char **output, size_t *output_size, size_t *anchor_line, char error[BUSTER_HP_ERROR_CAPACITY]);

#endif
