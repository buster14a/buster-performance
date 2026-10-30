// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin.
#ifndef BUSTER_HP_ELF_H
#define BUSTER_HP_ELF_H

#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>

#define BUSTER_HP_ERROR_CAPACITY 512
#define BUSTER_HP_ADDRSIG 0x6fff4c03U

typedef struct HpBytes HpBytes;
struct HpBytes
{
    const unsigned char *data;
    size_t size;
};

typedef struct HpString HpString;
struct HpString
{
    const char *data;
    size_t size;
};

typedef struct HpSection HpSection;
struct HpSection
{
    uint32_t index;
    HpString name;
    uint32_t type;
    uint64_t flags;
    uint64_t addr;
    uint64_t offset;
    uint64_t size;
    uint32_t link;
    uint32_t info;
    uint64_t align;
    uint64_t entsize;
    HpBytes bytes;
};

typedef struct HpSymbol HpSymbol;
struct HpSymbol
{
    uint32_t table;
    uint32_t index;
    HpString name;
    uint8_t bind;
    uint8_t type;
    uint8_t other;
    uint16_t section;
    uint64_t value;
    uint64_t size;
};

typedef struct HpRelocation HpRelocation;
struct HpRelocation
{
    uint32_t section;
    uint32_t target_section;
    uint64_t offset;
    uint32_t type;
    size_t symbol;
    int64_t addend;
};

typedef struct HpElf HpElf;
struct HpElf
{
    HpBytes input;
    unsigned char ident[16];
    uint16_t elf_type;
    uint16_t machine;
    uint32_t version;
    uint64_t entry;
    uint32_t flags;
    uint16_t program_count;
    uint32_t shstr_index;
    HpSection *sections;
    size_t section_count;
    HpSymbol *symbols;
    size_t symbol_count;
    HpRelocation *relocations;
    size_t relocation_count;
};

typedef enum HpDisclosureKind
{
    BUSTER_HP_DISCLOSURE_COMMENT,
    BUSTER_HP_DISCLOSURE_FILE_RECORDS,
    BUSTER_HP_DISCLOSURE_NORMALIZED_ENCODING
} HpDisclosureKind;

typedef struct HpDisclosure HpDisclosure;
struct HpDisclosure
{
    HpDisclosureKind kind;
    // SIZE_MAX denotes presence differences without an owning base section.
    size_t section;
};

typedef struct HpObjectProof HpObjectProof;
struct HpObjectProof
{
    uint64_t shift;
    uint64_t hot_bytes_before;
    uint64_t hot_alignment;
    size_t symbols_compared;
    size_t relocations_compared;
    HpDisclosure *disclosures;
    size_t disclosure_count;
};

// Input bytes remain caller owned and must outlive the reader and proof records.
// Output must be zero initialized. Failures leave it empty and set error.
// Free metadata with hp_elf_free, and proof disclosures with hp_object_proof_free.
// No executable instructions or external tools are invoked by this module.
// The reader accepts file-backed metadata for REL/EXEC/DYN; comparison requires
// successful, unmodified reader outputs and supports ET_REL only. Final-image
// address ranges, program loading and resolved relocation values are separate
// gates. Unknown/group/compressed/REL/TLSDESC semantics fail object comparison.
bool hp_elf_read(HpBytes input, HpElf *output, char error[BUSTER_HP_ERROR_CAPACITY]);
void hp_elf_free(HpElf *elf);
const HpSection *hp_elf_section_named(const HpElf *elf, const char *name);
bool hp_string_equal(HpString a, HpString b);
bool hp_string_is(HpString value, const char *text);
unsigned hp_elf_relocation_width(uint32_t type);
bool hp_elf_compare_objects(const HpElf *base, const HpElf *variant, const char *hot_name, uint64_t shift, HpObjectProof *proof, char error[BUSTER_HP_ERROR_CAPACITY]);
void hp_object_proof_free(HpObjectProof *proof);

#endif
