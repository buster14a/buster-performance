// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin.
#ifndef BUSTER_HP_NORMALIZE_H
#define BUSTER_HP_NORMALIZE_H

#include "hp_common.h"

#define BUSTER_HP_NORMALIZE_BASE_SOURCE "2c8613c36e4b0a2ed178c6f660eccc0da5f0e1c9a3bc1ff49172bf1906655455"
#define BUSTER_HP_NORMALIZE_BASE_NORMAL "db8cbb4409be4ac4e0244c9aed773dcfcb733464d9022160365dc2f386dcb6ea"
#define BUSTER_HP_NORMALIZE_CANDIDATE_SOURCE "b35a6550d598851fa761404d6ce720eaa3da40073df666ccdc8f872b6b6323d6"
#define BUSTER_HP_NORMALIZE_CANDIDATE_NORMAL "0b26071d237b416195b75dfb6a89fd5c1861705d432ad628b1c6dd5344e82edb"
#define BUSTER_HP_NORMALIZE_FUNCTION "check_test_action_constraints"
#define BUSTER_HP_NORMALIZE_FUNCTION_SIZE UINT64_C(15709)
#define BUSTER_HP_NORMALIZE_FUNCTION_SITE UINT64_C(0xcf1)

typedef struct HpNormalizationProof HpNormalizationProof;
struct HpNormalizationProof
{
    const char *profile;
    char source_manifest_sha256[65];
    char qualified_normal_sha256[65];
    size_t edits;
    size_t assembly_line;
    size_t assembly_line_offset;
    size_t instruction_offset;
    size_t instruction_size;
    uint64_t function_label_id;
    uint64_t basic_block_id;
    size_t object_symbol;
    uint32_t object_section;
    uint64_t function_value;
    uint64_t function_size;
    uint64_t function_site;
    uint64_t section_site;
    uint64_t object_file_site;
    size_t call_relocation;
    uint64_t call_relocation_offset;
    uint32_t call_relocation_type;
    int64_t call_relocation_addend;
    unsigned char preimage[2];
};

// Pure memory only. Raw assembly and direct object stay immutable; successful
// output owns a new buffer, freed with hp_buffer_free. Output/proof must be
// zero initialized and separate from input storage. Failure leaves both empty.
// Only the exact authorized source/normal tuples and observed function/object
// profile are supported. Candidate input must satisfy all guards independently;
// this API makes no claim that an unseen candidate does so. No binary is patched.
// Full reassembled-object proof and strict normal/zero image SHA remain gates.
bool hp_normalize_pair_supported(const char *source_manifest_sha, const char *qualified_normal_sha);
bool hp_normalize_checker(HpBytes raw_s, HpBytes direct_object, const char *source_manifest_sha, const char *qualified_normal_sha, HpBuffer *canonical, HpNormalizationProof *proof, char error[BUSTER_HP_ERROR_CAPACITY]);
// Caller supplies SHA256 digests verified over the exact immutable input and
// returned output buffers. No hashing, file opening or process execution here.
// The caller owns the stream and its exclusive creation/flush/close checks.
bool hp_normalization_write(FILE *output, const HpNormalizationProof *proof, const char *raw_sha, const char *canonical_sha, const char *object_sha, char error[BUSTER_HP_ERROR_CAPACITY]);

#endif
