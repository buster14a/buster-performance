// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin.
// Fresh first-party C byte fixtures for hp_linked.c. No producer, assembler,
// image instructions, file or subprocess is invoked by this control program.
// Deliberately unequal resolved relocation operands attest the gate's narrow
// boundary: numeric operand semantics require separate proof and output tests.
#include "hp_linked.h"

#include <assert.h>
#include <elf.h>
#include <inttypes.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define BUSTER_LINK_CAPACITY 32768U
#define BUSTER_LINK_SECTIONS 7U
#define BUSTER_LINK_SYMBOLS 12U
#define BUSTER_LINK_BASE UINT64_C(0x400000)
#define BUSTER_LINK_CODE_SIZE 96U
#define BUSTER_ARRAY_COUNT(values) (sizeof(values) / sizeof((values)[0]))

_Static_assert(sizeof(Elf64_Ehdr) == 64, "ELF64 header layout");
_Static_assert(sizeof(Elf64_Shdr) == 64, "ELF64 section layout");
_Static_assert(sizeof(Elf64_Sym) == 24, "ELF64 symbol layout");
_Static_assert(sizeof(Elf64_Rela) == 24, "ELF64 RELA layout");

typedef enum LinkedSection
{
    BUSTER_LINK_NULL,
    BUSTER_LINK_HOT,
    BUSTER_LINK_OTHER,
    BUSTER_LINK_RELA,
    BUSTER_LINK_SYMTAB,
    BUSTER_LINK_STRTAB,
    BUSTER_LINK_SHSTRTAB
} LinkedSection;

typedef enum LinkedFault
{
    BUSTER_LINK_NONE,
    BUSTER_LINK_ABSORBED_SHIFT,
    BUSTER_LINK_WRONG_PREFIX,
    BUSTER_LINK_WRONG_PREFIX_LAST,
    BUSTER_LINK_OPCODE_BEFORE,
    BUSTER_LINK_OPCODE_AFTER,
    BUSTER_LINK_NOP,
    BUSTER_LINK_FINAL_MISSING,
    BUSTER_LINK_FINAL_AMBIGUOUS,
    BUSTER_LINK_FINAL_WRONG_SIZE,
    BUSTER_LINK_NONUNIFORM_DELTA,
    BUSTER_LINK_RANGE_SHORT,
    BUSTER_LINK_FINAL_WRONG_SECTION,
    BUSTER_LINK_NONEXEC_FINAL,
    BUSTER_LINK_OBJECT_ALIGNMENT,
    BUSTER_LINK_OBJECT_WRONG_SECTION,
    BUSTER_LINK_OBJECT_MISSING,
    BUSTER_LINK_UNALIGNED_BASE,
    BUSTER_LINK_OVERFLOW_RANGE,
    BUSTER_LINK_OBJECT_EXTENT,
    BUSTER_LINK_MISSING_EXTRA,
    BUSTER_LINK_ZERO_FIXED,
    BUSTER_LINK_ZERO_MISSING,
    BUSTER_LINK_UNKNOWN_RELOCATION,
    BUSTER_LINK_NONE_RELOCATION,
    BUSTER_LINK_RELOCATION_EXTENT,
    BUSTER_LINK_RELOCATION_OVERLAP,
    BUSTER_LINK_UNNAMED_OWNED,
    BUSTER_LINK_DUPLICATE_OWNED,
    BUSTER_LINK_WRONG_VISIBILITY,
    BUSTER_LINK_WRONG_BINDING,
    BUSTER_LINK_DYN_IMAGE,
    BUSTER_LINK_DYN_TABLE,
    BUSTER_LINK_NOT_FILE_BACKED,
    BUSTER_LINK_OBJECT_NOT_EXEC,
    BUSTER_LINK_FINAL_NOT_EXEC,
    BUSTER_LINK_WRONG_TYPED_DUPLICATE,
    BUSTER_LINK_RELOCATION_8,
    BUSTER_LINK_RELOCATION_2,
    BUSTER_LINK_RELOCATION_1,
    BUSTER_LINK_NORMAL_OPCODE,
    BUSTER_LINK_NORMAL_AMBIGUOUS,
    BUSTER_LINK_CONTRIBUTION_UNDERFLOW,
    BUSTER_LINK_OBJECT_EMPTY,
    BUSTER_LINK_FINAL_OVERLAPPING_SECTION,
    BUSTER_LINK_FINAL_ZERO_SIZE_OVERFLOW,
    BUSTER_LINK_EXACT_ALLOC_RANGE,
    BUSTER_LINK_DECLARED_NOBITS_ALIAS,
    BUSTER_LINK_RELOCATION_DISJOINT,
    BUSTER_LINK_RELOCATION_REVERSED
} LinkedFault;

typedef struct LinkedBuffer LinkedBuffer;
struct LinkedBuffer
{
    unsigned char data[BUSTER_LINK_CAPACITY];
    size_t size;
};

typedef struct LinkedOptions LinkedOptions;
struct LinkedOptions
{
    uint64_t shift;
    LinkedFault fault;
    bool extra;
    bool zero;
    bool zero_at_end;
    bool original;
};

typedef struct LinkedSymbol LinkedSymbol;
struct LinkedSymbol
{
    const char *name;
    uint16_t section;
    uint64_t value;
    uint64_t size;
    unsigned char type;
    unsigned char bind;
    unsigned char other;
};

typedef struct LinkedCase LinkedCase;
struct LinkedCase
{
    const char *name;
    LinkedOptions object;
    LinkedOptions normal;
    LinkedOptions variant;
    uint64_t shift;
    bool expected;
    bool extra_required;
    bool null_required;
};

static const char *const linked_mandatory[] =
{
    "check_program_emit",
    "check_lower_drain",
    "check_lower_batch_classify"
};

static const char linked_extra[] = "check_lower_fragment";

static void linked_append(LinkedBuffer *buffer, const void *data, size_t size)
{
    assert(buffer->size <= sizeof(buffer->data));
    assert(size <= sizeof(buffer->data) - buffer->size);
    if (size != 0)
    {
        memcpy(buffer->data + buffer->size, data, size);
    }
    buffer->size += size;
    return;
}

static void linked_align(LinkedBuffer *buffer, size_t alignment)
{
    assert(alignment != 0 && (alignment & (alignment - 1)) == 0);
    size_t padding = (alignment - buffer->size % alignment) % alignment;
    assert(buffer->size <= sizeof(buffer->data));
    assert(padding <= sizeof(buffer->data) - buffer->size);
    memset(buffer->data + buffer->size, 0, padding);
    buffer->size += padding;
    return;
}

static uint32_t linked_string(LinkedBuffer *buffer, const char *text)
{
    assert(buffer->size <= UINT32_MAX);
    uint32_t offset = (uint32_t)buffer->size;
    linked_append(buffer, text, strlen(text) + 1);
    return offset;
}

static void linked_symbol_add(LinkedSymbol *symbols, size_t *count, LinkedSymbol symbol)
{
    assert(*count < BUSTER_LINK_SYMBOLS);
    symbols[(*count)++] = symbol;
    return;
}

static void linked_fixture(bool object, LinkedOptions options, LinkedBuffer *output)
{
    LinkedBuffer payloads[BUSTER_LINK_SECTIONS] = { 0 };
    Elf64_Shdr sections[BUSTER_LINK_SECTIONS] = { 0 };
    const char *section_names[BUSTER_LINK_SECTIONS] =
    {
        "",
        object ? ".text.buster_checker" : ".text",
        object ? ".text.other" : ".other",
        ".rela.hot",
        ".symtab",
        ".strtab",
        ".shstrtab"
    };
    uint64_t base = object ? 0 : BUSTER_LINK_BASE;
    if (!object && options.fault == BUSTER_LINK_UNALIGNED_BASE)
    {
        base += 16;
    }
    if (!object && options.fault == BUSTER_LINK_OVERFLOW_RANGE)
    {
        base = UINT64_MAX - 4095;
    }
    unsigned char code[BUSTER_LINK_CODE_SIZE] = { 0 };
    for (size_t index = 0; index < sizeof(code); index += 1)
    {
        code[index] = (unsigned char)(index * 7 + 11);
    }
    uint32_t relocation_type = R_X86_64_PC32;
    uint64_t relocation_offset = 12;
    unsigned width = 4;
    if (options.fault == BUSTER_LINK_RELOCATION_8)
    {
        relocation_type = R_X86_64_64;
        relocation_offset = 8;
        width = 8;
    }
    if (options.fault == BUSTER_LINK_RELOCATION_2)
    {
        relocation_type = R_X86_64_16;
        relocation_offset = 14;
        width = 2;
    }
    if (options.fault == BUSTER_LINK_RELOCATION_1)
    {
        relocation_type = R_X86_64_8;
        relocation_offset = 15;
        width = 1;
    }
    if (!object)
    {
        memset(code + (size_t)relocation_offset, options.original ? 0x41 : 0x42, width);
        if (options.fault == BUSTER_LINK_RELOCATION_DISJOINT || options.fault == BUSTER_LINK_RELOCATION_REVERSED)
        {
            memset(code + 32, options.original ? 0x43 : 0x44, 4);
        }
        if (options.fault == BUSTER_LINK_OPCODE_BEFORE || options.fault == BUSTER_LINK_NORMAL_OPCODE)
        {
            code[11] ^= 1;
        }
        if (options.fault == BUSTER_LINK_OPCODE_AFTER)
        {
            code[16] ^= 1;
        }
        if (options.fault == BUSTER_LINK_NOP)
        {
            code[24] = 0x90;
        }
        assert(options.shift <= 2048);
        payloads[BUSTER_LINK_HOT].size = (size_t)options.shift;
        if (options.shift != 0 && options.fault == BUSTER_LINK_WRONG_PREFIX)
        {
            payloads[BUSTER_LINK_HOT].data[0] = 0x90;
        }
        if (options.shift != 0 && options.fault == BUSTER_LINK_WRONG_PREFIX_LAST)
        {
            payloads[BUSTER_LINK_HOT].data[(size_t)options.shift - 1] = 0x90;
        }
    }
    linked_append(payloads + BUSTER_LINK_HOT, code, sizeof(code));
    if (!object && options.fault == BUSTER_LINK_RANGE_SHORT)
    {
        payloads[BUSTER_LINK_HOT].size -= 1;
    }
    if (!object && options.fault == BUSTER_LINK_OVERFLOW_RANGE)
    {
        payloads[BUSTER_LINK_HOT].size = 8192;
    }
    if (object && options.fault == BUSTER_LINK_OBJECT_EMPTY)
    {
        payloads[BUSTER_LINK_HOT].size = 0;
    }
    static const char other[] = "OTHER SECTION DATA";
    linked_append(payloads + BUSTER_LINK_OTHER, other, sizeof(other) - 1);
    sections[BUSTER_LINK_HOT].sh_type = object || options.fault != BUSTER_LINK_NOT_FILE_BACKED ? SHT_PROGBITS : SHT_NOBITS;
    sections[BUSTER_LINK_HOT].sh_flags = SHF_ALLOC | SHF_EXECINSTR;
    sections[BUSTER_LINK_HOT].sh_addr = base;
    sections[BUSTER_LINK_HOT].sh_addralign = object && options.fault == BUSTER_LINK_OBJECT_ALIGNMENT ? 2048 : 4096;
    if ((object && options.fault == BUSTER_LINK_OBJECT_NOT_EXEC) || (!object && options.fault == BUSTER_LINK_FINAL_NOT_EXEC))
    {
        sections[BUSTER_LINK_HOT].sh_flags = SHF_ALLOC;
    }
    sections[BUSTER_LINK_OTHER].sh_type = SHT_PROGBITS;
    sections[BUSTER_LINK_OTHER].sh_flags = SHF_ALLOC | SHF_EXECINSTR;
    sections[BUSTER_LINK_OTHER].sh_addr = object ? 0 : UINT64_C(0x600000);
    sections[BUSTER_LINK_OTHER].sh_addralign = 16;
    if (!object && options.fault == BUSTER_LINK_NONEXEC_FINAL)
    {
        sections[BUSTER_LINK_OTHER].sh_flags = SHF_ALLOC;
    }
    if (!object && options.fault == BUSTER_LINK_FINAL_OVERLAPPING_SECTION)
    {
        sections[BUSTER_LINK_OTHER].sh_addr = base;
        payloads[BUSTER_LINK_OTHER] = payloads[BUSTER_LINK_HOT];
    }
    if (!object && options.fault == BUSTER_LINK_EXACT_ALLOC_RANGE)
    {
        sections[BUSTER_LINK_OTHER].sh_addr = UINT64_MAX - (sizeof(other) - 2);
    }
    if (!object && options.fault == BUSTER_LINK_DECLARED_NOBITS_ALIAS)
    {
        sections[BUSTER_LINK_OTHER].sh_type = SHT_NOBITS;
        sections[BUSTER_LINK_OTHER].sh_addr = base;
        payloads[BUSTER_LINK_OTHER].size = payloads[BUSTER_LINK_HOT].size;
    }
    LinkedSymbol symbols[BUSTER_LINK_SYMBOLS] = { 0 };
    size_t symbol_count = 0;
    for (size_t index = 0; index < BUSTER_ARRAY_COUNT(linked_mandatory); index += 1)
    {
        bool missing = index == 1 && ((object && options.fault == BUSTER_LINK_OBJECT_MISSING) || (!object && options.fault == BUSTER_LINK_FINAL_MISSING));
        if (!missing)
        {
            LinkedSymbol symbol =
            {
                .name = linked_mandatory[index],
                .section = BUSTER_LINK_HOT,
                .value = base + index * 32 + (object ? 0 : options.shift),
                .size = 16,
                .type = STT_FUNC,
                .bind = STB_LOCAL,
                .other = STV_DEFAULT
            };
            if (index == 1 && ((object && options.fault == BUSTER_LINK_OBJECT_WRONG_SECTION) || (!object && (options.fault == BUSTER_LINK_FINAL_WRONG_SECTION || options.fault == BUSTER_LINK_NONEXEC_FINAL || options.fault == BUSTER_LINK_DECLARED_NOBITS_ALIAS))))
            {
                symbol.section = BUSTER_LINK_OTHER;
            }
            if (!object && options.fault == BUSTER_LINK_ABSORBED_SHIFT)
            {
                symbol.value -= options.shift;
            }
            if (!object && options.fault == BUSTER_LINK_NONUNIFORM_DELTA && index == 2)
            {
                symbol.value += 16;
            }
            if (!object && options.fault == BUSTER_LINK_FINAL_WRONG_SIZE && index == 1)
            {
                symbol.size += 1;
            }
            if (!object && options.fault == BUSTER_LINK_WRONG_VISIBILITY && index == 1)
            {
                symbol.other = STV_HIDDEN;
            }
            if (!object && options.fault == BUSTER_LINK_WRONG_BINDING && index == 2)
            {
                symbol.bind = STB_GLOBAL;
            }
            if (object && options.fault == BUSTER_LINK_UNNAMED_OWNED && index == 1)
            {
                symbol.name = "";
            }
            if (!object && options.fault == BUSTER_LINK_CONTRIBUTION_UNDERFLOW)
            {
                symbol.value = index * 16;
                sections[BUSTER_LINK_HOT].sh_addr = 0;
            }
            linked_symbol_add(symbols, &symbol_count, symbol);
        }
    }
    if (options.extra && (object || options.fault != BUSTER_LINK_MISSING_EXTRA))
    {
        LinkedSymbol symbol =
        {
            .name = linked_extra,
            .section = BUSTER_LINK_HOT,
            .value = base + 80 + (object ? 0 : options.shift),
            .size = 8,
            .type = STT_FUNC,
            .bind = STB_LOCAL
        };
        linked_symbol_add(symbols, &symbol_count, symbol);
    }
    if (options.zero && (object || options.fault != BUSTER_LINK_ZERO_MISSING))
    {
        uint64_t offset = options.zero_at_end ? BUSTER_LINK_CODE_SIZE : 88;
        LinkedSymbol symbol =
        {
            .name = "zero_size_owned",
            .section = BUSTER_LINK_HOT,
            .value = base + offset + (object || options.fault == BUSTER_LINK_ZERO_FIXED ? 0 : options.shift),
            .size = 0,
            .type = STT_FUNC,
            .bind = STB_LOCAL
        };
        if (!object && options.fault == BUSTER_LINK_FINAL_ZERO_SIZE_OVERFLOW)
        {
            symbol.value = UINT64_MAX;
        }
        linked_symbol_add(symbols, &symbol_count, symbol);
    }
    if (options.fault == BUSTER_LINK_OBJECT_EXTENT)
    {
        LinkedSymbol symbol =
        {
            .name = "out_of_range_owned",
            .section = BUSTER_LINK_HOT,
            .value = base + 100 + (object ? 0 : options.shift),
            .size = 8,
            .type = STT_FUNC,
            .bind = STB_LOCAL
        };
        linked_symbol_add(symbols, &symbol_count, symbol);
        if (!object)
        {
            payloads[BUSTER_LINK_HOT].size += 32;
        }
    }
    if ((object && options.fault == BUSTER_LINK_DUPLICATE_OWNED) || (!object && (options.fault == BUSTER_LINK_FINAL_AMBIGUOUS || options.fault == BUSTER_LINK_NORMAL_AMBIGUOUS || options.fault == BUSTER_LINK_WRONG_TYPED_DUPLICATE)))
    {
        LinkedSymbol duplicate = symbols[0];
        if (options.fault == BUSTER_LINK_WRONG_TYPED_DUPLICATE)
        {
            duplicate.type = STT_OBJECT;
        }
        linked_symbol_add(symbols, &symbol_count, duplicate);
    }
    unsigned char zero = 0;
    linked_append(payloads + BUSTER_LINK_STRTAB, &zero, 1);
    Elf64_Sym null_symbol = { 0 };
    linked_append(payloads + BUSTER_LINK_SYMTAB, &null_symbol, sizeof(null_symbol));
    uint32_t first_global = (uint32_t)(symbol_count + 1);
    for (size_t index = 0; index < symbol_count; index += 1)
    {
        const LinkedSymbol *input = symbols + index;
        Elf64_Sym symbol =
        {
            .st_name = linked_string(payloads + BUSTER_LINK_STRTAB, input->name),
            .st_info = ELF64_ST_INFO(input->bind, input->type),
            .st_other = input->other,
            .st_shndx = input->section,
            .st_value = input->value,
            .st_size = input->size
        };
        if (input->bind != STB_LOCAL && first_global > index + 1)
        {
            first_global = (uint32_t)(index + 1);
        }
        linked_append(payloads + BUSTER_LINK_SYMTAB, &symbol, sizeof(symbol));
    }
    uint32_t external_index = (uint32_t)(symbol_count + 1);
    Elf64_Sym external =
    {
        .st_name = linked_string(payloads + BUSTER_LINK_STRTAB, "external"),
        .st_info = ELF64_ST_INFO(STB_GLOBAL, STT_NOTYPE),
        .st_shndx = SHN_UNDEF
    };
    linked_append(payloads + BUSTER_LINK_SYMTAB, &external, sizeof(external));
    if (object)
    {
        if (options.fault == BUSTER_LINK_UNKNOWN_RELOCATION)
        {
            relocation_type = UINT32_MAX;
        }
        if (options.fault == BUSTER_LINK_NONE_RELOCATION)
        {
            relocation_type = R_X86_64_NONE;
        }
        if (options.fault == BUSTER_LINK_RELOCATION_EXTENT)
        {
            relocation_offset = BUSTER_LINK_CODE_SIZE - 3;
        }
        Elf64_Rela relocation =
        {
            .r_offset = relocation_offset,
            .r_info = ELF64_R_INFO(external_index, relocation_type),
            .r_addend = -4
        };
        if (options.fault == BUSTER_LINK_RELOCATION_REVERSED)
        {
            relocation.r_offset = 32;
        }
        linked_append(payloads + BUSTER_LINK_RELA, &relocation, sizeof(relocation));
        if (options.fault == BUSTER_LINK_RELOCATION_OVERLAP)
        {
            relocation.r_offset += 2;
            linked_append(payloads + BUSTER_LINK_RELA, &relocation, sizeof(relocation));
        }
        if (options.fault == BUSTER_LINK_RELOCATION_DISJOINT || options.fault == BUSTER_LINK_RELOCATION_REVERSED)
        {
            relocation.r_offset = options.fault == BUSTER_LINK_RELOCATION_REVERSED ? 12 : 32;
            linked_append(payloads + BUSTER_LINK_RELA, &relocation, sizeof(relocation));
        }
    }
    sections[BUSTER_LINK_RELA].sh_type = SHT_RELA;
    sections[BUSTER_LINK_RELA].sh_flags = SHF_INFO_LINK;
    sections[BUSTER_LINK_RELA].sh_link = BUSTER_LINK_SYMTAB;
    sections[BUSTER_LINK_RELA].sh_info = BUSTER_LINK_HOT;
    sections[BUSTER_LINK_RELA].sh_addralign = 8;
    sections[BUSTER_LINK_RELA].sh_entsize = sizeof(Elf64_Rela);
    sections[BUSTER_LINK_SYMTAB].sh_type = !object && options.fault == BUSTER_LINK_DYN_TABLE ? SHT_DYNSYM : SHT_SYMTAB;
    sections[BUSTER_LINK_SYMTAB].sh_link = BUSTER_LINK_STRTAB;
    sections[BUSTER_LINK_SYMTAB].sh_info = first_global;
    sections[BUSTER_LINK_SYMTAB].sh_addralign = 8;
    sections[BUSTER_LINK_SYMTAB].sh_entsize = sizeof(Elf64_Sym);
    sections[BUSTER_LINK_STRTAB].sh_type = SHT_STRTAB;
    sections[BUSTER_LINK_STRTAB].sh_addralign = 1;
    sections[BUSTER_LINK_SHSTRTAB].sh_type = SHT_STRTAB;
    sections[BUSTER_LINK_SHSTRTAB].sh_addralign = 1;
    linked_append(payloads + BUSTER_LINK_SHSTRTAB, &zero, 1);
    for (size_t index = 1; index < BUSTER_LINK_SECTIONS; index += 1)
    {
        sections[index].sh_name = linked_string(payloads + BUSTER_LINK_SHSTRTAB, section_names[index]);
    }
    memset(output, 0, sizeof(*output));
    output->size = sizeof(Elf64_Ehdr);
    for (size_t index = 1; index < BUSTER_LINK_SECTIONS; index += 1)
    {
        linked_align(output, (size_t)sections[index].sh_addralign);
        sections[index].sh_offset = output->size;
        sections[index].sh_size = payloads[index].size;
        if (sections[index].sh_type != SHT_NOBITS)
        {
            linked_append(output, payloads[index].data, payloads[index].size);
        }
    }
    linked_align(output, 8);
    size_t section_offset = output->size;
    linked_append(output, sections, sizeof(sections));
    Elf64_Ehdr header =
    {
        .e_ident =
        {
            ELFMAG0,
            ELFMAG1,
            ELFMAG2,
            ELFMAG3,
            ELFCLASS64,
            ELFDATA2LSB,
            EV_CURRENT
        },
        .e_type = object ? ET_REL : options.fault == BUSTER_LINK_DYN_IMAGE ? ET_DYN : ET_EXEC,
        .e_machine = EM_X86_64,
        .e_version = EV_CURRENT,
        .e_shoff = section_offset,
        .e_ehsize = sizeof(Elf64_Ehdr),
        .e_shentsize = sizeof(Elf64_Shdr),
        .e_shnum = BUSTER_LINK_SECTIONS,
        .e_shstrndx = BUSTER_LINK_SHSTRTAB
    };
    memcpy(output->data, &header, sizeof(header));
    return;
}

static bool linked_proof_valid(const LinkedCase *test, const HpLinkedProof *proof)
{
    size_t expected_count = BUSTER_ARRAY_COUNT(linked_mandatory) + test->object.extra + test->object.zero;
    bool valid = proof->shift == test->shift && proof->hot_input_base == BUSTER_LINK_BASE && proof->hot_bytes == BUSTER_LINK_CODE_SIZE && proof->hot_alignment == 4096 && proof->function_count == expected_count && hp_string_is(proof->normal_output_section, ".text") && hp_string_is(proof->variant_output_section, ".text");
    unsigned expected_width = test->object.fault == BUSTER_LINK_RELOCATION_8 ? 8 : test->object.fault == BUSTER_LINK_RELOCATION_2 ? 2 : test->object.fault == BUSTER_LINK_RELOCATION_1 ? 1 : 4;
    uint64_t expected_offset = expected_width == 8 ? 8 : expected_width == 2 ? 14 : expected_width == 1 ? 15 : 12;
    bool multiple_operands = test->object.fault == BUSTER_LINK_RELOCATION_DISJOINT || test->object.fault == BUSTER_LINK_RELOCATION_REVERSED;
    uint32_t expected_type = expected_width == 8 ? R_X86_64_64 : expected_width == 2 ? R_X86_64_16 : expected_width == 1 ? R_X86_64_8 : R_X86_64_PC32;
    valid = valid && proof->operand_count == (multiple_operands ? 2U : 1U) && proof->masked_operand_bytes == (multiple_operands ? 8U : expected_width);
    if (valid)
    {
        valid = proof->operands[0].offset == expected_offset && proof->operands[0].width == expected_width && proof->operands[0].type == expected_type && proof->operands[0].object_relocation == (test->object.fault == BUSTER_LINK_RELOCATION_REVERSED ? 1U : 0U);
    }
    if (valid && multiple_operands)
    {
        valid = proof->operands[1].offset == 32 && proof->operands[1].width == 4 && proof->operands[1].type == R_X86_64_PC32 && proof->operands[1].object_relocation == (test->object.fault == BUSTER_LINK_RELOCATION_REVERSED ? 0U : 1U);
    }
    for (size_t index = 0; valid && index < proof->function_count; index += 1)
    {
        const HpLinkedFunction *function = proof->functions + index;
        uint64_t offset = index < 3 ? index * 32 : test->object.extra && index == 3 ? 80 : test->object.zero_at_end ? BUSTER_LINK_CODE_SIZE : 88;
        uint64_t size = index < 3 ? 16 : test->object.extra && index == 3 ? 8 : 0;
        const char *name = index < 3 ? linked_mandatory[index] : test->object.extra && index == 3 ? linked_extra : "zero_size_owned";
        valid = hp_string_is(function->name, name) && function->object_symbol == index + 1 && function->object_offset == offset && function->size == size && function->normal_address == BUSTER_LINK_BASE + offset && function->variant_address == BUSTER_LINK_BASE + offset + test->shift && function->delta == test->shift && function->normal_residue_4096 == offset % 4096 && function->variant_residue_4096 == (offset + test->shift) % 4096;
    }
    return valid;
}

static bool linked_case_run(const LinkedCase *test)
{
    LinkedBuffer inputs[3] = { 0 };
    HpElf elves[3] = { 0 };
    HpLinkedProof proof = { 0 };
    char error[BUSTER_HP_ERROR_CAPACITY] = { 0 };
    linked_fixture(true, test->object, inputs + 0);
    linked_fixture(false, test->normal, inputs + 1);
    linked_fixture(false, test->variant, inputs + 2);
    bool parsed = true;
    for (size_t index = 0; parsed && index < BUSTER_ARRAY_COUNT(inputs); index += 1)
    {
        HpBytes bytes =
        {
            .data = inputs[index].data,
            .size = inputs[index].size
        };
        parsed = hp_elf_read(bytes, elves + index, error);
    }
    const char *const required[] =
    {
        linked_extra
    };
    bool accepted = parsed && hp_linked_compare(elves + 0, elves + 1, elves + 2, test->shift, test->null_required ? NULL : required, test->extra_required || test->null_required, &proof, error);
    bool passed = parsed && accepted == test->expected;
    if (accepted)
    {
        passed = passed && linked_proof_valid(test, &proof);
    }
    else
    {
        unsigned char zero[sizeof(proof)] = { 0 };
        passed = passed && memcmp(&proof, zero, sizeof(proof)) == 0 && error[0] != 0;
    }
    printf("%s %s", passed ? "PASS" : "FAIL", test->name);
    if (!accepted)
    {
        printf(" [%s: %s]", parsed ? "gate" : "reader", error);
    }
    printf("\n");
    hp_linked_proof_free(&proof);
    for (size_t index = 0; index < BUSTER_ARRAY_COUNT(elves); index += 1)
    {
        hp_elf_free(elves + index);
    }
    return passed;
}

static LinkedCase linked_case(const char *name, LinkedFault fault, bool expected)
{
    LinkedCase test =
    {
        .name = name,
        .normal =
        {
            .original = true
        },
        .variant =
        {
            .shift = 16,
            .fault = fault
        },
        .shift = 16,
        .expected = expected
    };
    return test;
}

int main(void)
{
    // The native control executable only constructs x86-64 little-endian data.
    // Refuse a host representation incompatible with the explicit fixture ABI.
    const uint16_t endian = 1;
    bool host_valid = *(const unsigned char *)&endian == 1;
    LinkedCase tests[96] = { 0 };
    size_t count = 0;
    const uint64_t shifts[] =
    {
        0,
        16,
        64,
        256,
        1024,
        2048
    };
    const char *shift_names[] =
    {
        "valid-zero-with-distinct-resolved-operands",
        "valid-16",
        "valid-64",
        "valid-256",
        "valid-1024",
        "valid-2048"
    };
    for (size_t index = 0; index < BUSTER_ARRAY_COUNT(shifts); index += 1)
    {
        LinkedCase test = linked_case(shift_names[index], BUSTER_LINK_NONE, true);
        test.shift = shifts[index];
        test.variant.shift = shifts[index];
        tests[count++] = test;
    }
    const struct
    {
        const char *name;
        LinkedFault fault;
    } final_faults[] =
    {
        { "absorbed-shift", BUSTER_LINK_ABSORBED_SHIFT },
        { "wrong-first-prefix-byte", BUSTER_LINK_WRONG_PREFIX },
        { "wrong-last-prefix-byte", BUSTER_LINK_WRONG_PREFIX_LAST },
        { "opcode-before-relocation", BUSTER_LINK_OPCODE_BEFORE },
        { "opcode-after-relocation", BUSTER_LINK_OPCODE_AFTER },
        { "changed-alignment-nop", BUSTER_LINK_NOP },
        { "final-missing-mandatory", BUSTER_LINK_FINAL_MISSING },
        { "ambiguous-final-identity", BUSTER_LINK_FINAL_AMBIGUOUS },
        { "wrong-final-size", BUSTER_LINK_FINAL_WRONG_SIZE },
        { "nonuniform-delta", BUSTER_LINK_NONUNIFORM_DELTA },
        { "truncated-contribution", BUSTER_LINK_RANGE_SHORT },
        { "wrong-final-declared-section", BUSTER_LINK_FINAL_WRONG_SECTION },
        { "nonexec-declared-section", BUSTER_LINK_NONEXEC_FINAL },
        { "wrong-final-visibility", BUSTER_LINK_WRONG_VISIBILITY },
        { "wrong-final-binding", BUSTER_LINK_WRONG_BINDING },
        { "dyn-image-refused", BUSTER_LINK_DYN_IMAGE },
        { "dynamic-table-only-refused", BUSTER_LINK_DYN_TABLE },
        { "non-file-backed-final-refused", BUSTER_LINK_NOT_FILE_BACKED },
        { "nonexec-contribution", BUSTER_LINK_FINAL_NOT_EXEC },
        { "base-underflow-refused", BUSTER_LINK_CONTRIBUTION_UNDERFLOW },
        { "ambiguous-overlapping-image-ranges", BUSTER_LINK_FINAL_OVERLAPPING_SECTION }
    };
    for (size_t index = 0; index < BUSTER_ARRAY_COUNT(final_faults); index += 1)
    {
        tests[count++] = linked_case(final_faults[index].name, final_faults[index].fault, false);
    }
    tests[count++] = linked_case("valid-extent-wrong-declared-contribution", BUSTER_LINK_DECLARED_NOBITS_ALIAS, false);
    const struct
    {
        const char *name;
        LinkedFault fault;
    } object_faults[] =
    {
        { "object-not-page-aligned", BUSTER_LINK_OBJECT_ALIGNMENT },
        { "object-mandatory-wrong-section", BUSTER_LINK_OBJECT_WRONG_SECTION },
        { "object-missing-mandatory", BUSTER_LINK_OBJECT_MISSING },
        { "object-owned-function-outside-hot", BUSTER_LINK_OBJECT_EXTENT },
        { "unknown-relocation-width", BUSTER_LINK_UNKNOWN_RELOCATION },
        { "none-relocation-cannot-mask", BUSTER_LINK_NONE_RELOCATION },
        { "out-of-range-relocation-field", BUSTER_LINK_RELOCATION_EXTENT },
        { "overlapping-relocation-fields", BUSTER_LINK_RELOCATION_OVERLAP },
        { "unnamed-owned-function", BUSTER_LINK_UNNAMED_OWNED },
        { "ambiguous-owned-name", BUSTER_LINK_DUPLICATE_OWNED },
        { "nonexec-object-hot", BUSTER_LINK_OBJECT_NOT_EXEC },
        { "empty-object-hot", BUSTER_LINK_OBJECT_EMPTY }
    };
    for (size_t index = 0; index < BUSTER_ARRAY_COUNT(object_faults); index += 1)
    {
        LinkedCase test = linked_case(object_faults[index].name, BUSTER_LINK_NONE, false);
        test.object.fault = object_faults[index].fault;
        tests[count++] = test;
    }
    const LinkedFault symmetric_faults[] =
    {
        BUSTER_LINK_UNALIGNED_BASE,
        BUSTER_LINK_OVERFLOW_RANGE,
        BUSTER_LINK_EXACT_ALLOC_RANGE
    };
    const char *symmetric_names[] =
    {
        "unaligned-contribution-base",
        "overflowing-final-section-range",
        "allocated-section-may-end-at-address-limit"
    };
    for (size_t index = 0; index < BUSTER_ARRAY_COUNT(symmetric_faults); index += 1)
    {
        LinkedCase test = linked_case(symmetric_names[index], symmetric_faults[index], symmetric_faults[index] == BUSTER_LINK_EXACT_ALLOC_RANGE);
        test.normal.fault = symmetric_faults[index];
        tests[count++] = test;
    }
    const LinkedFault widths[] =
    {
        BUSTER_LINK_RELOCATION_8,
        BUSTER_LINK_RELOCATION_2,
        BUSTER_LINK_RELOCATION_1,
        BUSTER_LINK_RELOCATION_DISJOINT,
        BUSTER_LINK_RELOCATION_REVERSED
    };
    const char *width_names[] =
    {
        "exact-eight-byte-operand-mask",
        "exact-two-byte-operand-mask",
        "exact-one-byte-operand-mask",
        "disjoint-operand-masks",
        "operand-mask-order-independent"
    };
    for (size_t index = 0; index < BUSTER_ARRAY_COUNT(widths); index += 1)
    {
        LinkedCase test = linked_case(width_names[index], widths[index], true);
        test.object.fault = widths[index];
        test.normal.fault = widths[index];
        tests[count++] = test;
    }
    LinkedCase extra = linked_case("caller-extra-owned-helper", BUSTER_LINK_NONE, true);
    extra.object.extra = true;
    extra.normal.extra = true;
    extra.variant.extra = true;
    extra.extra_required = true;
    tests[count++] = extra;
    extra.name = "caller-extra-final-missing";
    extra.expected = false;
    extra.variant.fault = BUSTER_LINK_MISSING_EXTRA;
    tests[count++] = extra;
    LinkedCase zero = linked_case("zero-size-owned-positive", BUSTER_LINK_NONE, true);
    zero.object.zero = true;
    zero.normal.zero = true;
    zero.variant.zero = true;
    tests[count++] = zero;
    zero.name = "zero-size-at-section-end-positive";
    zero.object.zero_at_end = true;
    zero.normal.zero_at_end = true;
    zero.variant.zero_at_end = true;
    tests[count++] = zero;
    zero.name = "zero-size-fixed-refused";
    zero.expected = false;
    zero.variant.fault = BUSTER_LINK_ZERO_FIXED;
    tests[count++] = zero;
    zero.name = "zero-size-missing-refused";
    zero.variant.fault = BUSTER_LINK_ZERO_MISSING;
    tests[count++] = zero;
    zero.name = "zero-size-unbounded-value-refused";
    zero.variant.fault = BUSTER_LINK_FINAL_ZERO_SIZE_OVERFLOW;
    tests[count++] = zero;
    LinkedCase wrong_duplicate = linked_case("wrong-typed-duplicate-does-not-shadow-exact-identity", BUSTER_LINK_WRONG_TYPED_DUPLICATE, true);
    tests[count++] = wrong_duplicate;
    LinkedCase normal_bad = linked_case("normal-image-opcode-change-refused", BUSTER_LINK_NONE, false);
    normal_bad.normal.fault = BUSTER_LINK_NORMAL_OPCODE;
    tests[count++] = normal_bad;
    normal_bad.name = "normal-image-ambiguous-identity-refused";
    normal_bad.normal.fault = BUSTER_LINK_NORMAL_AMBIGUOUS;
    tests[count++] = normal_bad;
    LinkedCase shift_bad = linked_case("unapproved-shift-refused", BUSTER_LINK_NONE, false);
    shift_bad.shift = 32;
    tests[count++] = shift_bad;
    LinkedCase required_bad = linked_case("missing-caller-required-owned-name", BUSTER_LINK_NONE, false);
    required_bad.extra_required = true;
    tests[count++] = required_bad;
    required_bad.name = "null-required-array-refused";
    required_bad.null_required = true;
    tests[count++] = required_bad;
    assert(count <= BUSTER_ARRAY_COUNT(tests));
    size_t failures = host_valid ? 0 : 1;
    if (!host_valid)
    {
        fprintf(stderr, "FAIL unsupported control host representation\n");
    }
    for (size_t index = 0; host_valid && index < count; index += 1)
    {
        failures += !linked_case_run(tests + index);
    }
    printf("Pure-C linked controls: %zu cases, %zu failures; synthetic bytes only, no producer/assembler/image execution.\n", count, failures);
    return failures != 0;
}
