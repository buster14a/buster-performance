// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin.
#ifndef BUSTER_HP_LINKED_H
#define BUSTER_HP_LINKED_H

#include "hp_elf.h"

typedef struct HpLinkedFunction HpLinkedFunction;
struct HpLinkedFunction
{
    HpString name;
    size_t object_symbol;
    uint64_t object_offset;
    uint64_t size;
    uint64_t normal_address;
    uint64_t variant_address;
    uint64_t delta;
    uint64_t normal_residue_4096;
    uint64_t variant_residue_4096;
};

typedef struct HpLinkedOperand HpLinkedOperand;
struct HpLinkedOperand
{
    size_t object_relocation;
    uint64_t offset;
    uint32_t type;
    unsigned width;
};

typedef struct HpLinkedProof HpLinkedProof;
struct HpLinkedProof
{
    uint64_t shift;
    uint64_t hot_input_base;
    uint64_t hot_bytes;
    uint64_t hot_alignment;
    HpString normal_output_section;
    HpString variant_output_section;
    HpLinkedFunction *functions;
    size_t function_count;
    HpLinkedOperand *operands;
    size_t operand_count;
    uint64_t masked_operand_bytes;
};

// All inputs must be successful, unmodified hp_elf_read outputs. Input buffers
// must outlive the borrowed names in proof. Output must be zero initialized.
// Failure clears output; free only its owned arrays with hp_linked_proof_free.
// Every equal-key final SYMTAB candidate must have a valid file-backed code
// extent. All unique-in-both owned keys establish one base; each member then
// resolves uniquely at its expected address. Other equal-key candidates must
// be disjoint from that contribution. This does not use STT_FILE heuristics.
// This attests section-header geometry and linked nonrelocation bytes, NOT
// PT_LOAD/runtime semantics or numeric resolved operand values. Separate object
// relocation proof, pinned linker/input order, normal/zero full SHA identity
// and per-image output preservation controls remain required before timing.
bool hp_linked_compare(const HpElf *original_object, const HpElf *normal, const HpElf *variant, uint64_t shift, const char *const *required, size_t required_count, HpLinkedProof *proof, char error[BUSTER_HP_ERROR_CAPACITY]);
void hp_linked_proof_free(HpLinkedProof *proof);

#endif
