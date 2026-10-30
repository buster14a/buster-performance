// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin.
// First-party structural ELF proof, ported from the frozen local Python design
// 7bad351a754cf55d45edbb26d7a346647c01267f9b0f10cd1fcdda5a2f7bebd6.
// Reader: hp_elf_read. Object translation: hp_elf_compare_objects. Metadata owns
// contiguous arrays; names and section contents borrow checked input slices.
// Scalar format validation is cold preparation work, never compiler hot work.
// Refuse unknown semantics rather than claiming linker/execution equivalence.
#include "hp_elf.h"

#include <elf.h>
#include <limits.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define BUSTER_HP_HOT_ALIGN 4096U
#define BUSTER_HP_MAX_SHIFT (UINT64_C(1) << 30)

typedef struct HpRange HpRange;
struct HpRange
{
    uint64_t begin;
    uint64_t end;
    uint32_t section;
};

typedef struct HpIdentity HpIdentity;
struct HpIdentity
{
    HpString name;
    HpString section_name;
    uint64_t value;
    uint64_t size;
    uint8_t special;
    uint8_t bind;
    uint8_t type;
    uint8_t other;
};

typedef struct HpNormalizedRelocation HpNormalizedRelocation;
struct HpNormalizedRelocation
{
    HpString section_name;
    HpString target_name;
    uint64_t offset;
    uint32_t type;
    HpIdentity identity;
    int64_t addend;
};

typedef struct HpNormalized HpNormalized;
struct HpNormalized
{
    HpIdentity *identities;
    HpIdentity *records;
    HpString *files;
    HpNormalizedRelocation *relocations;
    size_t record_count;
    size_t file_count;
    size_t table;
};

static bool hp_require(bool condition, char error[BUSTER_HP_ERROR_CAPACITY], const char *message)
{
    if (!condition && error[0] == 0)
    {
        snprintf(error, BUSTER_HP_ERROR_CAPACITY, "%s", message);
    }
    return condition;
}

static uint16_t hp_u16(const unsigned char *bytes)
{
    return (uint16_t)((uint16_t)bytes[0] | (uint16_t)bytes[1] << 8);
}

static uint32_t hp_u32(const unsigned char *bytes)
{
    return (uint32_t)bytes[0] | (uint32_t)bytes[1] << 8 | (uint32_t)bytes[2] << 16 | (uint32_t)bytes[3] << 24;
}

static uint64_t hp_u64(const unsigned char *bytes)
{
    return (uint64_t)hp_u32(bytes) | (uint64_t)hp_u32(bytes + 4) << 32;
}

static int64_t hp_i64(const unsigned char *bytes)
{
    uint64_t bits = hp_u64(bytes);
    int64_t result;
    memcpy(&result, &bits, sizeof(result));
    return result;
}

static bool hp_span(HpBytes input, uint64_t offset, uint64_t size, HpBytes *result, char error[BUSTER_HP_ERROR_CAPACITY])
{
    bool ok = hp_require(offset <= input.size && size <= input.size - offset, error, "out-of-file ELF span");
    if (ok)
    {
        result->data = input.data + (size_t)offset;
        result->size = (size_t)size;
    }
    return ok;
}

static bool hp_name(HpBytes strings, uint32_t offset, HpString *result, char error[BUSTER_HP_ERROR_CAPACITY])
{
    bool ok = hp_require(offset < strings.size, error, "bad ELF string offset");
    if (ok)
    {
        const unsigned char *end = memchr(strings.data + offset, 0, strings.size - offset);
        ok = hp_require(end != NULL, error, "unterminated ELF string");
        if (ok)
        {
            result->data = (const char *)strings.data + offset;
            result->size = (size_t)(end - strings.data - offset);
        }
    }
    return ok;
}

bool hp_string_equal(HpString a, HpString b)
{
    return a.size == b.size && (a.size == 0 || memcmp(a.data, b.data, a.size) == 0);
}

bool hp_string_is(HpString value, const char *text)
{
    HpString other =
    {
        text,
        strlen(text)
    };
    return hp_string_equal(value, other);
}

static int hp_string_compare(HpString a, HpString b)
{
    size_t shared = a.size < b.size ? a.size : b.size;
    int result = shared != 0 ? memcmp(a.data, b.data, shared) : 0;
    if (result == 0)
    {
        result = (a.size > b.size) - (a.size < b.size);
    }
    return result;
}

static int hp_range_compare(const void *left, const void *right)
{
    const HpRange *a = left;
    const HpRange *b = right;
    int result = (a->section > b->section) - (a->section < b->section);
    if (result == 0)
    {
        result = (a->begin > b->begin) - (a->begin < b->begin);
    }
    if (result == 0)
    {
        result = (a->end > b->end) - (a->end < b->end);
    }
    return result;
}

static bool hp_bytes_equal(HpBytes a, HpBytes b)
{
    return a.size == b.size && (a.size == 0 || memcmp(a.data, b.data, a.size) == 0);
}

static void *hp_array(size_t count, size_t stride, char error[BUSTER_HP_ERROR_CAPACITY])
{
    void *result = NULL;
    if (hp_require(count <= SIZE_MAX / stride, error, "ELF metadata array overflow"))
    {
        result = calloc(count != 0 ? count : 1, stride);
        hp_require(result != NULL, error, "ELF metadata allocation failed");
    }
    return result;
}

void hp_elf_free(HpElf *elf)
{
    free(elf->sections);
    free(elf->symbols);
    free(elf->relocations);
    memset(elf, 0, sizeof(*elf));
}

const HpSection *hp_elf_section_named(const HpElf *elf, const char *name)
{
    const HpSection *result = NULL;
    for (size_t i = 0; i < elf->section_count; i += 1)
    {
        if (hp_string_is(elf->sections[i].name, name))
        {
            result = &elf->sections[i];
        }
    }
    return result;
}

static bool hp_read_sections(HpElf *elf, uint64_t shoff, uint64_t phoff, uint16_t phnum, uint16_t phsize, char error[BUSTER_HP_ERROR_CAPACITY])
{
    HpBytes raw = {0};
    HpBytes names = {0};
    HpRange *ranges = hp_array(elf->section_count + 3, sizeof(*ranges), error);
    bool ok = ranges != NULL && hp_span(elf->input, shoff, elf->section_count * 64, &raw, error);
    size_t range_count = 0;
    if (ok)
    {
        unsigned char empty[64] = {0};
        ok = hp_require(memcmp(raw.data, empty, 64) == 0, error, "nonempty or extended null section");
    }
    if (ok)
    {
        const unsigned char *row = raw.data + elf->shstr_index * 64;
        ok = hp_require(hp_u32(row + 4) == SHT_STRTAB, error, "section names are not STRTAB") && hp_span(elf->input, hp_u64(row + 24), hp_u64(row + 32), &names, error);
        ranges[range_count++] = (HpRange)
        {
            0,
            64,
            0
        };
        ranges[range_count++] = (HpRange)
        {
            shoff,
            shoff + elf->section_count * 64,
            0
        };
        if (phnum != 0)
        {
            HpBytes unused = {0};
            ok = ok && hp_span(elf->input, phoff, (uint64_t)phnum * phsize, &unused, error);
            ranges[range_count++] = (HpRange)
            {
                phoff,
                phoff + (uint64_t)phnum * phsize,
                0
            };
        }
    }
    for (size_t i = 0; ok && i < elf->section_count; i += 1)
    {
        const unsigned char *row = raw.data + i * 64;
        HpSection *section = &elf->sections[i];
        section->index = (uint32_t)i;
        section->type = hp_u32(row + 4);
        section->flags = hp_u64(row + 8);
        section->addr = hp_u64(row + 16);
        section->offset = hp_u64(row + 24);
        section->size = hp_u64(row + 32);
        section->link = hp_u32(row + 40);
        section->info = hp_u32(row + 44);
        section->align = hp_u64(row + 48);
        section->entsize = hp_u64(row + 56);
        uint64_t align = section->align != 0 ? section->align : 1;
        ok = hp_require((align & (align - 1)) == 0, error, "non-power-of-two section alignment") && hp_require(section->offset % align == 0 || section->type == SHT_NULL || section->type == SHT_NOBITS, error, "misaligned section") && hp_require(section->link < elf->section_count, error, "bad section link") && hp_name(names, hp_u32(row), &section->name, error);
        if (ok && section->type != SHT_NOBITS)
        {
            ok = hp_span(elf->input, section->offset, section->size, &section->bytes, error);
            if (ok && section->size != 0)
            {
                ranges[range_count++] = (HpRange)
                {
                    section->offset,
                    section->offset + section->size,
                    0
                };
            }
        }
        for (size_t j = 0; ok && j < i; j += 1)
        {
            ok = hp_require(!hp_string_equal(section->name, elf->sections[j].name), error, "duplicate section names");
        }
    }
    if (ok)
    {
        qsort(ranges, range_count, sizeof(*ranges), hp_range_compare);
        for (size_t i = 1; ok && i < range_count; i += 1)
        {
            ok = hp_require(ranges[i - 1].end <= ranges[i].begin, error, "overlapping ELF file regions");
        }
    }
    free(ranges);
    return ok;
}

static bool hp_read_symbols(HpElf *elf, size_t *table_starts, char error[BUSTER_HP_ERROR_CAPACITY])
{
    bool ok = true;
    size_t count = 0;
    for (size_t i = 0; ok && i < elf->section_count; i += 1)
    {
        const HpSection *section = &elf->sections[i];
        table_starts[i] = SIZE_MAX;
        if (section->type == SHT_SYMTAB || section->type == SHT_DYNSYM)
        {
            ok = hp_require(section->entsize == 24 && section->size % 24 == 0 && elf->sections[section->link].type == SHT_STRTAB, error, "bad symbol table");
            size_t additional = (size_t)(section->size / 24);
            ok = ok && hp_require(additional != 0 && additional <= UINT32_MAX && additional <= SIZE_MAX - count, error, "empty or overflowing symbol table");
            if (ok)
            {
                table_starts[i] = count;
                count += additional;
            }
        }
    }
    if (ok)
    {
        elf->symbols = hp_array(count, sizeof(*elf->symbols), error);
        ok = elf->symbols != NULL;
        elf->symbol_count = count;
    }
    for (size_t i = 0; ok && i < elf->section_count; i += 1)
    {
        const HpSection *section = &elf->sections[i];
        if (table_starts[i] != SIZE_MAX)
        {
            size_t entries = (size_t)(section->size / 24);
            ok = hp_require(section->info <= entries, error, "bad local-symbol boundary");
            for (size_t j = 0; ok && j < entries; j += 1)
            {
                const unsigned char *row = section->bytes.data + j * 24;
                HpSymbol *symbol = &elf->symbols[table_starts[i] + j];
                symbol->table = (uint32_t)i;
                symbol->index = (uint32_t)j;
                symbol->bind = row[4] >> 4;
                symbol->type = row[4] & 15;
                symbol->other = row[5];
                symbol->section = hp_u16(row + 6);
                symbol->value = hp_u64(row + 8);
                symbol->size = hp_u64(row + 16);
                ok = hp_require(symbol->section < elf->section_count || symbol->section == SHN_ABS || symbol->section == SHN_COMMON, error, "unsupported symbol section index") && hp_name(elf->sections[section->link].bytes, hp_u32(row), &symbol->name, error);
                if (j == 0)
                {
                    ok = ok && hp_require(symbol->name.size == 0 && symbol->bind == 0 && symbol->type == 0 && symbol->other == 0 && symbol->section == 0 && symbol->value == 0 && symbol->size == 0, error, "bad null symbol");
                }
                else
                {
                    ok = ok && hp_require((symbol->bind == STB_LOCAL) == (j < section->info), error, "bad local-symbol ordering");
                }
            }
        }
    }
    return ok;
}

static bool hp_read_relocations(HpElf *elf, const size_t *table_starts, char error[BUSTER_HP_ERROR_CAPACITY])
{
    bool ok = true;
    size_t count = 0;
    for (size_t i = 0; ok && i < elf->section_count; i += 1)
    {
        const HpSection *section = &elf->sections[i];
        ok = hp_require(section->type != SHT_REL, error, "SHT_REL implicit addends unsupported");
        if (ok && section->type == SHT_RELA)
        {
            ok = hp_require(table_starts[section->link] != SIZE_MAX && section->info < elf->section_count && (elf->elf_type != ET_REL || section->info != 0) && section->entsize == 24 && section->size % 24 == 0, error, "bad RELA table");
            size_t additional = (size_t)(section->size / 24);
            ok = ok && hp_require(additional <= SIZE_MAX - count, error, "relocation count overflow");
            if (ok)
            {
                count += additional;
            }
        }
    }
    if (ok)
    {
        elf->relocations = hp_array(count, sizeof(*elf->relocations), error);
        ok = elf->relocations != NULL;
        elf->relocation_count = count;
    }
    size_t at = 0;
    for (size_t i = 0; ok && i < elf->section_count; i += 1)
    {
        const HpSection *section = &elf->sections[i];
        if (section->type == SHT_RELA)
        {
            size_t entries = (size_t)(section->size / 24);
            uint64_t symbols = elf->sections[section->link].size / 24;
            for (size_t j = 0; ok && j < entries; j += 1)
            {
                const unsigned char *row = section->bytes.data + j * 24;
                uint64_t info = hp_u64(row + 8);
                uint64_t symbol = info >> 32;
                ok = hp_require(symbol < symbols, error, "bad relocation symbol index");
                if (ok)
                {
                    elf->relocations[at++] = (HpRelocation)
                    {
                        (uint32_t)i,
                        section->info,
                        hp_u64(row),
                        (uint32_t)info,
                        table_starts[section->link] + (size_t)symbol,
                        hp_i64(row + 16)
                    };
                }
            }
        }
    }
    return ok;
}

bool hp_elf_read(HpBytes input, HpElf *output, char error[BUSTER_HP_ERROR_CAPACITY])
{
    error[0] = 0;
    HpElf elf = {0};
    size_t *table_starts = NULL;
    bool ok = hp_require(input.data != NULL && input.size >= 64 && input.size <= PTRDIFF_MAX, error, "short or oversized ELF input");
    uint64_t phoff = 0;
    uint64_t shoff = 0;
    uint16_t phsize = 0;
    if (ok)
    {
        const unsigned char *h = input.data;
        static const unsigned char prefix[7] =
        {
            0x7f,
            'E',
            'L',
            'F',
            2,
            1,
            1
        };
        elf.input = input;
        memcpy(elf.ident, h, 16);
        elf.elf_type = hp_u16(h + 16);
        elf.machine = hp_u16(h + 18);
        elf.version = hp_u32(h + 20);
        elf.entry = hp_u64(h + 24);
        phoff = hp_u64(h + 32);
        shoff = hp_u64(h + 40);
        elf.flags = hp_u32(h + 48);
        phsize = hp_u16(h + 54);
        elf.program_count = hp_u16(h + 56);
        elf.section_count = hp_u16(h + 60);
        elf.shstr_index = hp_u16(h + 62);
        ok = hp_require(memcmp(h, prefix, 7) == 0, error, "requires ELF64 little-endian version 1") && hp_require((elf.elf_type == ET_REL || elf.elf_type == ET_EXEC || elf.elf_type == ET_DYN) && elf.machine == EM_X86_64 && elf.version == 1, error, "requires x86-64 ELF REL/EXEC/DYN") && hp_require(hp_u16(h + 52) == 64 && hp_u16(h + 58) == 64 && elf.section_count > 0 && elf.section_count < SHN_LORESERVE && elf.shstr_index < elf.section_count && elf.program_count != PN_XNUM, error, "unsupported ELF header or extended indices") && hp_require(elf.program_count == 0 || phsize == 56, error, "invalid program-header size");
    }
    if (ok)
    {
        HpBytes unused = {0};
        ok = hp_span(input, phoff, (uint64_t)elf.program_count * phsize, &unused, error);
    }
    if (ok)
    {
        elf.sections = hp_array(elf.section_count, sizeof(*elf.sections), error);
        table_starts = hp_array(elf.section_count, sizeof(*table_starts), error);
        ok = elf.sections != NULL && table_starts != NULL;
    }
    if (ok)
    {
        ok = hp_read_sections(&elf, shoff, phoff, elf.program_count, phsize, error) && hp_read_symbols(&elf, table_starts, error) && hp_read_relocations(&elf, table_starts, error);
    }
    free(table_starts);
    if (ok)
    {
        *output = elf;
    }
    else
    {
        hp_elf_free(&elf);
        memset(output, 0, sizeof(*output));
    }
    return ok;
}

unsigned hp_elf_relocation_width(uint32_t type)
{
    unsigned width = 0;
    switch (type)
    {
        case 1: case 16: case 17: case 18: case 24: case 25: case 27: case 28: case 29: case 30: case 31: case 33:
        {
            width = 8;
        } break;
        case 2: case 3: case 4: case 9: case 10: case 11: case 19: case 20: case 21: case 22: case 23: case 26: case 32: case 39: case 40: case 41: case 42:
        {
            width = 4;
        } break;
        case 12: case 13:
        {
            width = 2;
        } break;
        case 14: case 15:
        {
            width = 1;
        } break;
        default:
        {
            // Unknown, dynamic-only, TLSDESC marker/descriptor types are refused.
        } break;
    }
    return width;
}

static int hp_identity_compare(const void *left, const void *right)
{
    const HpIdentity *a = left;
    const HpIdentity *b = right;
    int result = hp_string_compare(a->name, b->name);
    if (result == 0)
    {
        result = (a->bind > b->bind) - (a->bind < b->bind);
    }
    if (result == 0)
    {
        result = (a->type > b->type) - (a->type < b->type);
    }
    if (result == 0)
    {
        result = (a->other > b->other) - (a->other < b->other);
    }
    if (result == 0)
    {
        result = (a->special > b->special) - (a->special < b->special);
    }
    if (result == 0)
    {
        result = hp_string_compare(a->section_name, b->section_name);
    }
    if (result == 0)
    {
        result = (a->value > b->value) - (a->value < b->value);
    }
    if (result == 0)
    {
        result = (a->size > b->size) - (a->size < b->size);
    }
    return result;
}

static int hp_name_compare(const void *left, const void *right)
{
    const HpString *a = left;
    const HpString *b = right;
    return hp_string_compare(*a, *b);
}

static int hp_relocation_compare(const void *left, const void *right)
{
    const HpNormalizedRelocation *a = left;
    const HpNormalizedRelocation *b = right;
    int result = hp_string_compare(a->section_name, b->section_name);
    if (result == 0)
    {
        result = hp_string_compare(a->target_name, b->target_name);
    }
    if (result == 0)
    {
        result = (a->offset > b->offset) - (a->offset < b->offset);
    }
    if (result == 0)
    {
        result = (a->type > b->type) - (a->type < b->type);
    }
    if (result == 0)
    {
        result = hp_identity_compare(&a->identity, &b->identity);
    }
    if (result == 0)
    {
        result = (a->addend > b->addend) - (a->addend < b->addend);
    }
    return result;
}

static bool hp_validate_object(const HpElf *elf, size_t *table, char error[BUSTER_HP_ERROR_CAPACITY])
{
    bool ok = hp_require(elf->elf_type == ET_REL && elf->entry == 0 && elf->program_count == 0, error, "object comparison requires ET_REL without program headers");
    size_t tables = 0;
    for (size_t i = 0; ok && i < elf->section_count; i += 1)
    {
        const HpSection *section = &elf->sections[i];
        if (section->type == SHT_SYMTAB)
        {
            *table = i;
            tables += 1;
        }
        ok = hp_require(section->type != SHT_DYNSYM && section->addr == 0, error, "dynamic symbols or nonzero ET_REL address") && hp_require(section->type != SHT_GROUP && section->type != SHT_SYMTAB_SHNDX && (section->flags & (SHF_GROUP | SHF_COMPRESSED)) == 0, error, "group, extended or compressed sections unsupported");
        if (ok && section->type != SHT_SYMTAB && section->type != SHT_RELA && section->type != BUSTER_HP_ADDRSIG)
        {
            ok = hp_require(section->link == 0, error, "unmodeled linked section metadata");
        }
    }
    ok = ok && hp_require(tables == 1, error, "requires exactly one SYMTAB");
    for (size_t i = 0; ok && i < elf->section_count; i += 1)
    {
        const HpSection *section = &elf->sections[i];
        if (section->type == SHT_SYMTAB || section->type == SHT_RELA || i == elf->shstr_index || i == elf->sections[*table].link)
        {
            ok = hp_require((section->flags & SHF_ALLOC) == 0, error, "allocatable symbol, string or relocation metadata unsupported");
        }
    }
    return ok;
}

static bool hp_symbol_identity(const HpElf *elf, const HpSymbol *symbol, HpString hot, uint64_t shift, HpIdentity *identity, char error[BUSTER_HP_ERROR_CAPACITY])
{
    bool ok = true;
    memset(identity, 0, sizeof(*identity));
    identity->name = symbol->name;
    identity->bind = symbol->bind;
    identity->type = symbol->type;
    identity->other = symbol->other;
    identity->value = symbol->value;
    identity->size = symbol->size;
    if (symbol->section == SHN_UNDEF)
    {
        identity->special = 1;
    }
    else if (symbol->section == SHN_ABS)
    {
        identity->special = 2;
    }
    else if (symbol->section == SHN_COMMON)
    {
        identity->special = 3;
    }
    else
    {
        identity->section_name = elf->sections[symbol->section].name;
    }
    if (symbol->type == STT_SECTION)
    {
        ok = hp_require(symbol->bind == STB_LOCAL && symbol->value == 0 && symbol->size == 0 && symbol->section > 0 && symbol->section < elf->section_count, error, "unsupported section symbol");
    }
    else if (identity->special == 0 && hp_string_equal(identity->section_name, hot))
    {
        ok = hp_require(symbol->value >= shift, error, "hot symbol is in inserted prefix");
        if (ok)
        {
            identity->value -= shift;
        }
    }
    bool type_ok = symbol->type == STT_NOTYPE || symbol->type == STT_OBJECT || symbol->type == STT_FUNC || symbol->type == STT_SECTION || symbol->type == STT_FILE || symbol->type == STT_COMMON || symbol->type == STT_TLS || symbol->type == STT_GNU_IFUNC;
    bool bind_ok = symbol->bind == STB_LOCAL || symbol->bind == STB_GLOBAL || symbol->bind == STB_WEAK || symbol->bind == STB_GNU_UNIQUE;
    ok = ok && hp_require(type_ok && bind_ok && (symbol->other & ~3U) == 0, error, "unknown symbol type, binding or visibility bits");
    if (ok && symbol->section > 0 && symbol->section < elf->section_count && symbol->type != STT_SECTION)
    {
        uint64_t size = elf->sections[symbol->section].size;
        ok = hp_require(symbol->value <= size && symbol->size <= size - symbol->value, error, "defined symbol extends past its section");
    }
    return ok;
}

static void hp_normalized_free(HpNormalized *normalized)
{
    free(normalized->identities);
    free(normalized->records);
    free(normalized->files);
    free(normalized->relocations);
    memset(normalized, 0, sizeof(*normalized));
}

static bool hp_normalize_symbols(const HpElf *elf, HpString hot, uint64_t shift, HpNormalized *normalized, char error[BUSTER_HP_ERROR_CAPACITY])
{
    normalized->identities = hp_array(elf->symbol_count, sizeof(*normalized->identities), error);
    normalized->records = hp_array(elf->symbol_count, sizeof(*normalized->records), error);
    normalized->files = hp_array(elf->symbol_count, sizeof(*normalized->files), error);
    HpString *names = hp_array(elf->symbol_count, sizeof(*names), error);
    size_t name_count = 0;
    bool ok = normalized->identities != NULL && normalized->records != NULL && normalized->files != NULL && names != NULL;
    for (size_t i = 0; ok && i < elf->symbol_count; i += 1)
    {
        const HpSymbol *symbol = &elf->symbols[i];
        ok = hp_require(symbol->table == normalized->table, error, "symbol uses unexpected table") && hp_symbol_identity(elf, symbol, hot, shift, &normalized->identities[i], error);
        if (ok && symbol->type == STT_FILE)
        {
            ok = hp_require(symbol->bind == STB_LOCAL && symbol->section == SHN_ABS && symbol->value == 0 && symbol->size == 0, error, "unexpected STT_FILE semantics");
            normalized->files[normalized->file_count++] = symbol->name;
        }
        else if (ok)
        {
            normalized->records[normalized->record_count++] = normalized->identities[i];
            if (symbol->name.size != 0)
            {
                names[name_count++] = symbol->name;
            }
        }
    }
    if (ok)
    {
        qsort(normalized->records, normalized->record_count, sizeof(*normalized->records), hp_identity_compare);
        qsort(normalized->files, normalized->file_count, sizeof(*normalized->files), hp_name_compare);
        qsort(names, name_count, sizeof(*names), hp_name_compare);
        for (size_t i = 1; ok && i < normalized->record_count; i += 1)
        {
            ok = hp_require(hp_identity_compare(&normalized->records[i - 1], &normalized->records[i]) != 0, error, "duplicate or ambiguous symbol identity");
        }
        for (size_t i = 1; ok && i < name_count; i += 1)
        {
            ok = hp_require(!hp_string_equal(names[i - 1], names[i]), error, "ambiguous named symbols");
        }
    }
    free(names);
    return ok;
}

static bool hp_direct_section_type(uint32_t type)
{
    return type == 1 || type == 2 || type == 4 || type == 10 || type == 11 || type == 12 || type == 13 || type == 14 || type == 15 || type == 24;
}

static bool hp_pc_type(uint32_t type)
{
    return type == 2 || type == 4 || type == 13 || type == 15 || type == 24;
}

static bool hp_relocation_content_type(const HpSection *target)
{
    // The pinned x86-64 producer emits this standard file-backed unwind profile.
    // Its bytes and metadata still undergo the complete section comparison.
    bool unwind = target->type == SHT_X86_64_UNWIND && hp_string_is(target->name, ".eh_frame") && target->flags == SHF_ALLOC && target->align == 8 && target->entsize == 0 && target->link == 0 && target->info == 0;
    return target->type == SHT_PROGBITS || target->type == SHT_INIT_ARRAY || target->type == SHT_FINI_ARRAY || target->type == SHT_PREINIT_ARRAY || unwind;
}

static bool hp_normalize_relocations(const HpElf *elf, HpString hot, uint64_t shift, uint64_t original_hot_size, HpNormalized *normalized, char error[BUSTER_HP_ERROR_CAPACITY])
{
    normalized->relocations = hp_array(elf->relocation_count, sizeof(*normalized->relocations), error);
    HpRange *fields = hp_array(elf->relocation_count, sizeof(*fields), error);
    bool ok = normalized->relocations != NULL && fields != NULL;
    for (size_t i = 0; ok && i < elf->relocation_count; i += 1)
    {
        const HpRelocation *relocation = &elf->relocations[i];
        const HpSymbol *symbol = &elf->symbols[relocation->symbol];
        const HpSection *target = &elf->sections[relocation->target_section];
        unsigned width = hp_elf_relocation_width(relocation->type);
        ok = hp_require(width != 0, error, "unsupported relocation type") && hp_require(symbol->table == normalized->table && symbol->type != STT_FILE, error, "relocation uses unexpected symbol table or STT_FILE") && hp_require(!hp_string_is(target->name, ".comment") && !(symbol->section > 0 && symbol->section < elf->section_count && hp_string_is(elf->sections[symbol->section].name, ".comment")), error, "relocation involves ignored producer bytes") && hp_require(hp_relocation_content_type(target) && relocation->offset <= target->size && width <= target->size - relocation->offset, error, "relocation field outside supported file-backed content");
        if (ok)
        {
            HpNormalizedRelocation *result = &normalized->relocations[i];
            result->section_name = elf->sections[relocation->section].name;
            result->target_name = target->name;
            result->offset = relocation->offset;
            result->type = relocation->type;
            result->identity = normalized->identities[relocation->symbol];
            result->addend = relocation->addend;
            fields[i] = (HpRange)
            {
                relocation->offset,
                relocation->offset + width,
                target->index
            };
            if (hp_string_equal(target->name, hot))
            {
                ok = hp_require(result->offset >= shift, error, "relocation in inserted hot prefix");
                if (ok)
                {
                    result->offset -= shift;
                }
            }
            if (ok && symbol->type == STT_SECTION && hp_string_equal(result->identity.section_name, hot) && result->identity.special == 0)
            {
                // Pinned Wild 0.10's default relaxation resolves non-interposable
                // PLT32 as PC32 only at executable sites. Section-symbol identity
                // already requires a local, defined, zero-value/zero-size symbol.
                ok = hp_require(relocation->type != 4 || (target->flags & SHF_EXECINSTR) != 0, error, "non-executable PLT32 relocation to hot section symbol") && hp_require(hp_direct_section_type(relocation->type), error, "non-direct relocation to hot section symbol") && hp_require(result->addend >= INT64_MIN + (int64_t)shift, error, "normalized relocation addend underflow");
                if (ok)
                {
                    result->addend -= (int64_t)shift;
                    int64_t bias = hp_pc_type(relocation->type) ? (int64_t)width : 0;
                    ok = hp_require(result->addend >= -bias && (result->addend < 0 || (uint64_t)result->addend <= original_hot_size), error, "hot section-symbol addend outside bounded direct target");
                }
            }
        }
    }
    if (ok)
    {
        qsort(fields, elf->relocation_count, sizeof(*fields), hp_range_compare);
        for (size_t i = 1; ok && i < elf->relocation_count; i += 1)
        {
            ok = hp_require(fields[i - 1].section != fields[i].section || fields[i - 1].end <= fields[i].begin, error, "overlapping relocation fields");
        }
        qsort(normalized->relocations, elf->relocation_count, sizeof(*normalized->relocations), hp_relocation_compare);
    }
    free(fields);
    return ok;
}

static bool hp_addrsig(const HpElf *elf, const HpSection *section, const HpNormalized *normalized, HpIdentity **identities, size_t *count, char error[BUSTER_HP_ERROR_CAPACITY])
{
    HpIdentity *result = hp_array(section->bytes.size, sizeof(*result), error);
    bool ok = result != NULL;
    size_t position = 0;
    size_t used = 0;
    while (ok && position < section->bytes.size)
    {
        uint64_t value = 0;
        unsigned bits = 0;
        size_t start = position;
        bool finished = false;
        while (ok && !finished)
        {
            ok = hp_require(position < section->bytes.size && bits < 64, error, "malformed .llvm_addrsig ULEB128");
            if (ok)
            {
                unsigned byte = section->bytes.data[position++];
                ok = hp_require(bits != 63 || (byte & 127U) <= 1, error, "overflowing .llvm_addrsig ULEB128");
                if (ok)
                {
                    value |= (uint64_t)(byte & 127U) << bits;
                    if (byte < 128)
                    {
                        ok = hp_require(position - start == 1 || byte != 0, error, "noncanonical .llvm_addrsig ULEB128");
                        finished = true;
                    }
                    else
                    {
                        bits += 7;
                    }
                }
            }
        }
        if (ok)
        {
            ok = hp_require(value < elf->symbol_count && elf->symbols[value].type != STT_FILE, error, "bad .llvm_addrsig symbol");
            if (ok)
            {
                result[used++] = normalized->identities[value];
            }
        }
    }
    if (ok)
    {
        qsort(result, used, sizeof(*result), hp_identity_compare);
        *identities = result;
        *count = used;
    }
    else
    {
        free(result);
    }
    return ok;
}

static const HpSection *hp_section_by_name(const HpElf *elf, HpString name)
{
    const HpSection *result = NULL;
    for (size_t i = 0; i < elf->section_count; i += 1)
    {
        if (hp_string_equal(elf->sections[i].name, name))
        {
            result = &elf->sections[i];
        }
    }
    return result;
}

static bool hp_is_comment(const HpSection *section)
{
    return section != NULL && hp_string_is(section->name, ".comment");
}

static bool hp_validate_comment(const HpSection *section, char error[BUSTER_HP_ERROR_CAPACITY])
{
    bool ok = true;
    if (section != NULL)
    {
        ok = hp_require((section->flags & ~UINT64_C(0x30)) == 0 && section->type == SHT_PROGBITS && section->link == 0 && section->info == 0 && section->align <= 1 && section->entsize <= 1, error, "semantic .comment section");
    }
    return ok;
}

void hp_object_proof_free(HpObjectProof *proof)
{
    free(proof->disclosures);
    memset(proof, 0, sizeof(*proof));
}

static void hp_disclose(HpObjectProof *proof, HpDisclosureKind kind, size_t section)
{
    // The caller allocates section_count + 2: at most one per common section,
    // plus one .comment disclosure and one STT_FILE-record disclosure.
    proof->disclosures[proof->disclosure_count].kind = kind;
    proof->disclosures[proof->disclosure_count].section = section;
    proof->disclosure_count += 1;
}

static bool hp_compare_sections(const HpElf *a, const HpElf *b, const HpSection *hot_a, const HpNormalized *na, const HpNormalized *nb, HpObjectProof *proof, char error[BUSTER_HP_ERROR_CAPACITY])
{
    bool ok = hp_string_equal(a->sections[a->shstr_index].name, b->sections[b->shstr_index].name) && hp_string_equal(a->sections[a->sections[na->table].link].name, b->sections[b->sections[nb->table].link].name);
    // The two ownership roles are deliberately retained, which is stricter than
    // treating their section names as an unordered set.
    ok = hp_require(ok, error, "string-table ownership changed");
    for (size_t i = 0; ok && i < a->section_count; i += 1)
    {
        const HpSection *x = &a->sections[i];
        const HpSection *y = hp_section_by_name(b, x->name);
        if (!hp_is_comment(x))
        {
            ok = hp_require(y != NULL, error, "section inventory changed");
            if (ok)
            {
                ok = hp_require(x->type == y->type && x->flags == y->flags && x->align == y->align && x->entsize == y->entsize, error, "section attributes changed") && hp_require(hp_string_equal(a->sections[x->link].name, b->sections[y->link].name), error, "section link ownership changed");
            }
            if (ok && x->type == SHT_RELA)
            {
                ok = hp_require(hp_string_equal(a->sections[x->info].name, b->sections[y->info].name), error, "relocation section target changed");
            }
            else if (ok && x->type != SHT_SYMTAB)
            {
                ok = hp_require(x->info == y->info, error, "section info changed");
            }
            if (ok && (x->type == SHT_SYMTAB || x->type == SHT_RELA || i == a->shstr_index || i == a->sections[na->table].link))
            {
                if (!hp_bytes_equal(x->bytes, y->bytes))
                {
                    hp_disclose(proof, BUSTER_HP_DISCLOSURE_NORMALIZED_ENCODING, i);
                }
            }
            else if (ok && x->type == BUSTER_HP_ADDRSIG)
            {
                HpIdentity *left = NULL;
                HpIdentity *right = NULL;
                size_t left_count = 0;
                size_t right_count = 0;
                ok = hp_require(x->link == na->table && y->link == nb->table && ((x->flags | y->flags) & SHF_ALLOC) == 0, error, "unsupported .llvm_addrsig ownership") && hp_addrsig(a, x, na, &left, &left_count, error) && hp_addrsig(b, y, nb, &right, &right_count, error);
                ok = ok && hp_require(left_count == right_count, error, ".llvm_addrsig target count changed");
                for (size_t j = 0; ok && j < left_count; j += 1)
                {
                    ok = hp_require(hp_identity_compare(&left[j], &right[j]) == 0, error, ".llvm_addrsig target identities changed");
                }
                free(left);
                free(right);
            }
            else if (ok && x != hot_a)
            {
                ok = hp_require(x->size == y->size && hp_bytes_equal(x->bytes, y->bytes), error, "section bytes or size changed");
            }
        }
    }
    for (size_t i = 0; ok && i < b->section_count; i += 1)
    {
        if (!hp_is_comment(&b->sections[i]))
        {
            ok = hp_require(hp_section_by_name(a, b->sections[i].name) != NULL, error, "section inventory changed");
        }
    }
    return ok;
}

bool hp_elf_compare_objects(const HpElf *base, const HpElf *variant, const char *hot_name, uint64_t shift, HpObjectProof *proof, char error[BUSTER_HP_ERROR_CAPACITY])
{
    error[0] = 0;
    HpNormalized a = {0};
    HpNormalized b = {0};
    HpObjectProof result = {0};
    const HpSection *hot_a = NULL;
    const HpSection *hot_b = NULL;
    bool ok = hp_require(shift <= BUSTER_HP_MAX_SHIFT, error, "invalid shift") && hp_validate_object(base, &a.table, error) && hp_validate_object(variant, &b.table, error);
    if (ok)
    {
        hot_a = hp_elf_section_named(base, hot_name);
        hot_b = hp_elf_section_named(variant, hot_name);
        ok = hp_require(memcmp(base->ident, variant->ident, 16) == 0 && base->machine == variant->machine && base->version == variant->version && base->flags == variant->flags, error, "ELF identity changed") && hp_require(hot_a != NULL && hot_b != NULL, error, "missing hot section");
    }
    if (ok)
    {
        ok = hp_require(hot_a->type == SHT_PROGBITS && hot_b->type == SHT_PROGBITS && (hot_a->flags & 6) == 6 && (hot_b->flags & 6) == 6 && hot_a->align == BUSTER_HP_HOT_ALIGN && hot_b->align == BUSTER_HP_HOT_ALIGN, error, "hot section requires executable allocatable PROGBITS aligned 4096") && hp_require(hot_a->size <= UINT64_MAX - shift && hot_b->size == hot_a->size + shift, error, "hot section size is not translated");
    }
    if (ok)
    {
        for (uint64_t i = 0; ok && i < shift; i += 1)
        {
            ok = hp_require(hot_b->bytes.data[i] == 0, error, "nonzero inserted hot prefix");
        }
        HpBytes suffix =
        {
            hot_b->bytes.data + shift,
            hot_b->bytes.size - (size_t)shift
        };
        ok = ok && hp_require(hp_bytes_equal(hot_a->bytes, suffix), error, "hot section bytes changed after prefix removal");
    }
    if (ok)
    {
        result.disclosures = hp_array(base->section_count + 2, sizeof(*result.disclosures), error);
        const HpSection *comment_a = hp_elf_section_named(base, ".comment");
        const HpSection *comment_b = hp_elf_section_named(variant, ".comment");
        ok = result.disclosures != NULL && hp_validate_comment(comment_a, error) && hp_validate_comment(comment_b, error);
        if (ok && ((comment_a == NULL) != (comment_b == NULL) || (comment_a != NULL && comment_b != NULL && !hp_bytes_equal(comment_a->bytes, comment_b->bytes))))
        {
            hp_disclose(&result, BUSTER_HP_DISCLOSURE_COMMENT, comment_a != NULL ? comment_a->index : SIZE_MAX);
        }
    }
    if (ok)
    {
        ok = hp_normalize_symbols(base, hot_a->name, 0, &a, error) && hp_normalize_symbols(variant, hot_a->name, shift, &b, error) && hp_require(a.record_count == b.record_count, error, "symbol inventory changed");
        for (size_t i = 0; ok && i < a.record_count; i += 1)
        {
            ok = hp_require(hp_identity_compare(&a.records[i], &b.records[i]) == 0, error, "symbol identity, value, size or binding changed");
        }
        bool same_files = a.file_count == b.file_count;
        for (size_t i = 0; same_files && i < a.file_count; i += 1)
        {
            same_files = hp_string_equal(a.files[i], b.files[i]);
        }
        if (ok && !same_files)
        {
            hp_disclose(&result, BUSTER_HP_DISCLOSURE_FILE_RECORDS, SIZE_MAX);
        }
    }
    if (ok)
    {
        ok = hp_normalize_relocations(base, hot_a->name, 0, hot_a->size, &a, error) && hp_normalize_relocations(variant, hot_a->name, shift, hot_a->size, &b, error) && hp_require(base->relocation_count == variant->relocation_count, error, "relocation inventory changed");
        for (size_t i = 0; ok && i < base->relocation_count; i += 1)
        {
            ok = hp_require(hp_relocation_compare(&a.relocations[i], &b.relocations[i]) == 0, error, "normalized relocations changed");
        }
    }
    if (ok)
    {
        ok = hp_compare_sections(base, variant, hot_a, &a, &b, &result, error);
    }
    hp_normalized_free(&a);
    hp_normalized_free(&b);
    if (ok)
    {
        result.shift = shift;
        result.hot_bytes_before = hot_a->size;
        result.hot_alignment = hot_a->align;
        result.symbols_compared = base->symbol_count;
        for (size_t i = 0; i < base->symbol_count; i += 1)
        {
            result.symbols_compared -= base->symbols[i].type == STT_FILE;
        }
        result.relocations_compared = base->relocation_count;
        *proof = result;
    }
    else
    {
        hp_object_proof_free(&result);
        memset(proof, 0, sizeof(*proof));
    }
    return ok;
}
