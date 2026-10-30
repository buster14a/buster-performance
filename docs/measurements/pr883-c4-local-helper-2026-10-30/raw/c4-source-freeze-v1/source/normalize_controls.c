// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin.
// Fresh, synthetic memory-only controls. Assembly is constructed text and ELF
// is constructed ELF64LE ET_REL data; no producer, assembler, target image,
// external process, remote service, file receipt, or timing is involved.
#define _GNU_SOURCE
#include "hp_normalize.h"

#include <assert.h>
#include <elf.h>
#include <inttypes.h>
#include <stdlib.h>
#include <string.h>

#define NORMALIZE_ARRAY_COUNT(values) (sizeof(values) / sizeof((values)[0]))
#define NORMALIZE_SECTION_COUNT 8U
#define NORMALIZE_SYMBOL_COUNT 4U
#define NORMALIZE_TEXT 1U
#define NORMALIZE_DATA 2U
#define NORMALIZE_SYMTAB 3U
#define NORMALIZE_STRTAB 4U
#define NORMALIZE_SHSTRTAB 5U
#define NORMALIZE_RELA 6U
#define NORMALIZE_SPARE 7U
#define NORMALIZE_FUNCTION 1U
#define NORMALIZE_EXTERNAL 2U
#define NORMALIZE_ALIAS 3U
#define NORMALIZE_BASE_VALUE UINT64_C(0xf68a0)
#define NORMALIZE_DIGEST "0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef"
#define NORMALIZE_SIZE_LINE "\t.size\tcheck_test_action_constraints, .Lfunc_end1222-check_test_action_constraints\n"

_Static_assert(sizeof(Elf64_Ehdr) == 64, "ELF64 header layout");
_Static_assert(sizeof(Elf64_Shdr) == 64, "ELF64 section layout");
_Static_assert(sizeof(Elf64_Sym) == 24, "ELF64 symbol layout");
_Static_assert(sizeof(Elf64_Rela) == 24, "ELF64 RELA layout");

typedef struct NormalizeFixture NormalizeFixture;
struct NormalizeFixture
{
    unsigned char *data;
    size_t size;
    size_t capacity;
    size_t headers;
    uint64_t function_value;
};

typedef struct NormalizeSuite NormalizeSuite;
struct NormalizeSuite
{
    size_t count;
    size_t failures;
};

typedef enum NormalizeFault
{
    NORMALIZE_FAULT_NONE,
    NORMALIZE_FAULT_BAD_MAGIC,
    NORMALIZE_FAULT_ELF32,
    NORMALIZE_FAULT_BIG_ENDIAN,
    NORMALIZE_FAULT_EXECUTABLE,
    NORMALIZE_FAULT_WRONG_MACHINE,
    NORMALIZE_FAULT_BAD_HEADER_SIZE,
    NORMALIZE_FAULT_BAD_SECTION_SIZE,
    NORMALIZE_FAULT_SHOFF_OVERFLOW,
    NORMALIZE_FAULT_SHSTR_INDEX,
    NORMALIZE_FAULT_TEXT_MISSING,
    NORMALIZE_FAULT_TEXT_DUPLICATE,
    NORMALIZE_FAULT_TEXT_NOBITS,
    NORMALIZE_FAULT_TEXT_WRITE,
    NORMALIZE_FAULT_TEXT_NO_ALLOC,
    NORMALIZE_FAULT_TEXT_NO_EXEC,
    NORMALIZE_FAULT_TEXT_ADDRESS,
    NORMALIZE_FAULT_TEXT_ALIGN,
    NORMALIZE_FAULT_TEXT_TRUNCATED,
    NORMALIZE_FAULT_TEXT_OFFSET_OVERFLOW,
    NORMALIZE_FAULT_FUNCTION_MISSING,
    NORMALIZE_FAULT_FUNCTION_DUPLICATE,
    NORMALIZE_FAULT_FUNCTION_GLOBAL,
    NORMALIZE_FAULT_FUNCTION_OBJECT,
    NORMALIZE_FAULT_FUNCTION_HIDDEN,
    NORMALIZE_FAULT_FUNCTION_PROTECTED,
    NORMALIZE_FAULT_FUNCTION_OTHER_BITS,
    NORMALIZE_FAULT_FUNCTION_UNDEFINED,
    NORMALIZE_FAULT_FUNCTION_ABSOLUTE,
    NORMALIZE_FAULT_FUNCTION_OTHER_SECTION,
    NORMALIZE_FAULT_FUNCTION_BAD_SECTION,
    NORMALIZE_FAULT_FUNCTION_SIZE,
    NORMALIZE_FAULT_FUNCTION_END,
    NORMALIZE_FAULT_FUNCTION_OVERFLOW,
    NORMALIZE_FAULT_SITE_PREIMAGE,
    NORMALIZE_FAULT_CALL_PREIMAGE,
    NORMALIZE_FAULT_STORE_PREIMAGE,
    NORMALIZE_FAULT_LOAD_PREIMAGE,
    NORMALIZE_FAULT_PREIMAGE_OTHER_OFFSET,
    NORMALIZE_FAULT_RELOCATION_MISSING,
    NORMALIZE_FAULT_RELOCATION_DUPLICATE,
    NORMALIZE_FAULT_RELOCATION_OFFSET,
    NORMALIZE_FAULT_RELOCATION_TYPE,
    NORMALIZE_FAULT_RELOCATION_ADDEND,
    NORMALIZE_FAULT_RELOCATION_OTHER_SYMBOL,
    NORMALIZE_FAULT_RELOCATION_BAD_SYMBOL,
    NORMALIZE_FAULT_RELOCATION_FOREIGN_TABLE,
    NORMALIZE_FAULT_RELOCATION_WRONG_TARGET,
    NORMALIZE_FAULT_RELOCATION_REL,
    NORMALIZE_FAULT_RELOCATION_ENTRY_SIZE,
    NORMALIZE_FAULT_RELOCATION_TRUNCATED,
    NORMALIZE_FAULT_RELOCATION_OVERLAP_LEFT,
    NORMALIZE_FAULT_RELOCATION_OVERLAP_RIGHT,
    NORMALIZE_FAULT_RELOCATION_UNKNOWN_OUTSIDE,
    NORMALIZE_FAULT_RELOCATION_OUTSIDE_BOUNDS,
    NORMALIZE_FAULT_RELOCATION_OFFSET_OVERFLOW,
    NORMALIZE_FAULT_RELOCATION_SAFE_BEFORE,
    NORMALIZE_FAULT_RELOCATION_SAFE_AFTER,
    NORMALIZE_FAULT_EXTERNAL_NAME,
    NORMALIZE_FAULT_EXTERNAL_LOCAL,
    NORMALIZE_FAULT_EXTERNAL_FUNC,
    NORMALIZE_FAULT_EXTERNAL_HIDDEN,
    NORMALIZE_FAULT_EXTERNAL_DEFINED,
    NORMALIZE_FAULT_EXTERNAL_VALUE,
    NORMALIZE_FAULT_EXTERNAL_SIZE,
    NORMALIZE_FAULT_SYMBOL_ENTRY_SIZE,
    NORMALIZE_FAULT_SYMBOL_TABLE_LINK,
    NORMALIZE_FAULT_SYMBOL_NAME_BOUNDS,
    NORMALIZE_FAULT_SECTION_NAME_BOUNDS
} NormalizeFault;

static const char normalize_assembly[] =
    "\t.section\t.text.buster_checker,\"ax\",@progbits\n"
    "\t.p2align\t12\n"
    "synthetic_hot:\n"
    "\tretq\n"
    "\t.text\n"
    "\t.type\tcheck_test_action_constraints,@function\n"
    "check_test_action_constraints:\n"
    "\tpushq\t%rbp\n"
    "\tcallq\t__floatuntixf@PLT\n"
    "\tfadd\t%st, %st(0)\n"
    ".LBB1222_33:\n"
    "\tfstpt\t1264(%rsp)\n"
    "\tfldt\t1072(%rsp)\n"
    "\tretq\n"
    ".Lfunc_end1222:\n"
    NORMALIZE_SIZE_LINE;

static void normalize_record(NormalizeSuite *suite, const char *name, bool passed, const char *error)
{
    suite->count += 1;
    suite->failures += !passed;
    printf("%s %s%s%s\n", passed ? "PASS" : "FAIL", name, passed ? "" : ": ", passed ? "" : error);
    return;
}

static void normalize_append(NormalizeFixture *fixture, const void *data, size_t size)
{
    assert(size <= fixture->capacity - fixture->size);
    if (size != 0)
    {
        memcpy(fixture->data + fixture->size, data, size);
    }
    fixture->size += size;
    return;
}

static void normalize_align(NormalizeFixture *fixture, size_t alignment)
{
    size_t padding = (alignment - fixture->size % alignment) % alignment;
    assert(padding <= fixture->capacity - fixture->size);
    memset(fixture->data + fixture->size, 0, padding);
    fixture->size += padding;
    return;
}

static Elf64_Ehdr normalize_header(const NormalizeFixture *fixture)
{
    Elf64_Ehdr header;
    memcpy(&header, fixture->data, sizeof(header));
    return header;
}

static void normalize_set_header(NormalizeFixture *fixture, Elf64_Ehdr header)
{
    memcpy(fixture->data, &header, sizeof(header));
    return;
}

static Elf64_Shdr normalize_section(const NormalizeFixture *fixture, size_t index)
{
    Elf64_Shdr section;
    assert(index < NORMALIZE_SECTION_COUNT);
    memcpy(&section, fixture->data + fixture->headers + index * sizeof(section), sizeof(section));
    return section;
}

static void normalize_set_section(NormalizeFixture *fixture, size_t index, Elf64_Shdr section)
{
    assert(index < NORMALIZE_SECTION_COUNT);
    memcpy(fixture->data + fixture->headers + index * sizeof(section), &section, sizeof(section));
    return;
}

static Elf64_Sym normalize_symbol(const NormalizeFixture *fixture, size_t index)
{
    Elf64_Shdr table = normalize_section(fixture, NORMALIZE_SYMTAB);
    Elf64_Sym symbol;
    assert(index < NORMALIZE_SYMBOL_COUNT);
    memcpy(&symbol, fixture->data + (size_t)table.sh_offset + index * sizeof(symbol), sizeof(symbol));
    return symbol;
}

static void normalize_set_symbol(NormalizeFixture *fixture, size_t index, Elf64_Sym symbol)
{
    Elf64_Shdr table = normalize_section(fixture, NORMALIZE_SYMTAB);
    assert(index < NORMALIZE_SYMBOL_COUNT);
    memcpy(fixture->data + (size_t)table.sh_offset + index * sizeof(symbol), &symbol, sizeof(symbol));
    return;
}

static Elf64_Rela normalize_relocation(uint64_t offset, uint32_t type, uint32_t symbol)
{
    Elf64_Rela relocation = {0};
    relocation.r_offset = offset;
    relocation.r_info = ELF64_R_INFO(symbol, type);
    relocation.r_addend = -4;
    return relocation;
}

static void normalize_fixture(NormalizeFixture *fixture, uint64_t function_value)
{
    static const unsigned char preimage[] =
    {
        0xe8, 0, 0, 0, 0, 0xdc, 0xc0, 0xdb, 0xbc, 0x24, 0xf0,
        0x04, 0, 0, 0xdb, 0xac, 0x24, 0x30, 0x04, 0, 0
    };
    static const char symbol_names[] = "\0" BUSTER_HP_NORMALIZE_FUNCTION "\0__floatuntixf\0other_function\0";
    static const char section_names[] = "\0.text\0.data\0.symtab\0.strtab\0.shstrtab\0.rela.text\0.spare\0";
    const uint32_t names[NORMALIZE_SECTION_COUNT] = {0, 1, 7, 13, 21, 29, 39, 50};
    uint64_t text_size = function_value + BUSTER_HP_NORMALIZE_FUNCTION_SIZE + 64;
    assert(text_size < SIZE_MAX - 8192);
    memset(fixture, 0, sizeof(*fixture));
    fixture->capacity = (size_t)text_size + 8192;
    fixture->data = calloc(fixture->capacity, 1);
    assert(fixture->data != NULL);
    fixture->function_value = function_value;
    fixture->size = sizeof(Elf64_Ehdr);
    Elf64_Shdr sections[NORMALIZE_SECTION_COUNT] = {0};
    for (size_t index = 1; index < NORMALIZE_SECTION_COUNT; index += 1)
    {
        sections[index].sh_name = names[index];
        sections[index].sh_type = SHT_PROGBITS;
        sections[index].sh_addralign = 1;
    }
    normalize_align(fixture, 16);
    sections[NORMALIZE_TEXT].sh_offset = fixture->size;
    sections[NORMALIZE_TEXT].sh_size = text_size;
    sections[NORMALIZE_TEXT].sh_flags = SHF_ALLOC | SHF_EXECINSTR;
    sections[NORMALIZE_TEXT].sh_addralign = 16;
    memset(fixture->data + fixture->size, 0x90, (size_t)text_size);
    fixture->size += (size_t)text_size;
    size_t window = (size_t)(sections[NORMALIZE_TEXT].sh_offset + function_value + BUSTER_HP_NORMALIZE_FUNCTION_SITE - 5);
    memcpy(fixture->data + window, preimage, sizeof(preimage));
    sections[NORMALIZE_DATA].sh_offset = fixture->size;
    sections[NORMALIZE_DATA].sh_size = 32;
    sections[NORMALIZE_DATA].sh_flags = SHF_ALLOC | SHF_WRITE;
    memset(fixture->data + fixture->size, 0x5a, 32);
    fixture->size += 32;
    normalize_align(fixture, 8);
    sections[NORMALIZE_SYMTAB].sh_offset = fixture->size;
    sections[NORMALIZE_SYMTAB].sh_type = SHT_SYMTAB;
    sections[NORMALIZE_SYMTAB].sh_size = NORMALIZE_SYMBOL_COUNT * sizeof(Elf64_Sym);
    sections[NORMALIZE_SYMTAB].sh_link = NORMALIZE_STRTAB;
    sections[NORMALIZE_SYMTAB].sh_info = NORMALIZE_EXTERNAL;
    sections[NORMALIZE_SYMTAB].sh_addralign = 8;
    sections[NORMALIZE_SYMTAB].sh_entsize = sizeof(Elf64_Sym);
    Elf64_Sym symbols[NORMALIZE_SYMBOL_COUNT] = {0};
    symbols[NORMALIZE_FUNCTION].st_name = 1;
    symbols[NORMALIZE_FUNCTION].st_info = ELF64_ST_INFO(STB_LOCAL, STT_FUNC);
    symbols[NORMALIZE_FUNCTION].st_shndx = NORMALIZE_TEXT;
    symbols[NORMALIZE_FUNCTION].st_value = function_value;
    symbols[NORMALIZE_FUNCTION].st_size = BUSTER_HP_NORMALIZE_FUNCTION_SIZE;
    symbols[NORMALIZE_EXTERNAL].st_name = (uint32_t)(sizeof(BUSTER_HP_NORMALIZE_FUNCTION) + 1);
    symbols[NORMALIZE_EXTERNAL].st_info = ELF64_ST_INFO(STB_GLOBAL, STT_NOTYPE);
    symbols[NORMALIZE_ALIAS].st_name = (uint32_t)(sizeof(BUSTER_HP_NORMALIZE_FUNCTION) + sizeof("__floatuntixf") + 1);
    symbols[NORMALIZE_ALIAS].st_info = ELF64_ST_INFO(STB_GLOBAL, STT_FUNC);
    symbols[NORMALIZE_ALIAS].st_shndx = NORMALIZE_TEXT;
    symbols[NORMALIZE_ALIAS].st_size = 16;
    normalize_append(fixture, symbols, sizeof(symbols));
    sections[NORMALIZE_STRTAB].sh_offset = fixture->size;
    sections[NORMALIZE_STRTAB].sh_type = SHT_STRTAB;
    sections[NORMALIZE_STRTAB].sh_size = sizeof(symbol_names);
    normalize_append(fixture, symbol_names, sizeof(symbol_names));
    sections[NORMALIZE_SHSTRTAB].sh_offset = fixture->size;
    sections[NORMALIZE_SHSTRTAB].sh_type = SHT_STRTAB;
    sections[NORMALIZE_SHSTRTAB].sh_size = sizeof(section_names);
    normalize_append(fixture, section_names, sizeof(section_names));
    normalize_align(fixture, 8);
    sections[NORMALIZE_RELA].sh_offset = fixture->size;
    sections[NORMALIZE_RELA].sh_type = SHT_RELA;
    sections[NORMALIZE_RELA].sh_size = sizeof(Elf64_Rela);
    sections[NORMALIZE_RELA].sh_link = NORMALIZE_SYMTAB;
    sections[NORMALIZE_RELA].sh_info = NORMALIZE_TEXT;
    sections[NORMALIZE_RELA].sh_addralign = 8;
    sections[NORMALIZE_RELA].sh_entsize = sizeof(Elf64_Rela);
    Elf64_Rela relocations[2] = {0};
    relocations[0] = normalize_relocation(function_value + BUSTER_HP_NORMALIZE_FUNCTION_SITE - 4, R_X86_64_PLT32, NORMALIZE_EXTERNAL);
    normalize_append(fixture, relocations, sizeof(relocations));
    sections[NORMALIZE_SPARE].sh_offset = fixture->size;
    sections[NORMALIZE_SPARE].sh_size = sizeof(symbols);
    normalize_append(fixture, symbols, sizeof(symbols));
    normalize_align(fixture, 8);
    fixture->headers = fixture->size;
    normalize_append(fixture, sections, sizeof(sections));
    Elf64_Ehdr header = {0};
    memcpy(header.e_ident, ELFMAG, SELFMAG);
    header.e_ident[EI_CLASS] = ELFCLASS64;
    header.e_ident[EI_DATA] = ELFDATA2LSB;
    header.e_ident[EI_VERSION] = EV_CURRENT;
    header.e_type = ET_REL;
    header.e_machine = EM_X86_64;
    header.e_version = EV_CURRENT;
    header.e_ehsize = sizeof(header);
    header.e_shoff = fixture->headers;
    header.e_shentsize = sizeof(Elf64_Shdr);
    header.e_shnum = NORMALIZE_SECTION_COUNT;
    header.e_shstrndx = NORMALIZE_SHSTRTAB;
    normalize_set_header(fixture, header);
    return;
}

static void normalize_fault(NormalizeFixture *fixture, NormalizeFault fault)
{
    Elf64_Ehdr header = normalize_header(fixture);
    Elf64_Shdr text = normalize_section(fixture, NORMALIZE_TEXT);
    Elf64_Shdr table = normalize_section(fixture, NORMALIZE_SYMTAB);
    Elf64_Shdr relocations = normalize_section(fixture, NORMALIZE_RELA);
    Elf64_Shdr spare = normalize_section(fixture, NORMALIZE_SPARE);
    Elf64_Sym function = normalize_symbol(fixture, NORMALIZE_FUNCTION);
    Elf64_Sym external = normalize_symbol(fixture, NORMALIZE_EXTERNAL);
    Elf64_Sym alias = normalize_symbol(fixture, NORMALIZE_ALIAS);
    Elf64_Rela relocation;
    memcpy(&relocation, fixture->data + (size_t)relocations.sh_offset, sizeof(relocation));
    uint64_t site = fixture->function_value + BUSTER_HP_NORMALIZE_FUNCTION_SITE;
    size_t file_site = (size_t)(text.sh_offset + site);
    bool add_relocation = false;
    Elf64_Rela extra = normalize_relocation(0, R_X86_64_PC32, NORMALIZE_EXTERNAL);
    switch (fault)
    {
        case NORMALIZE_FAULT_NONE: break;
        case NORMALIZE_FAULT_BAD_MAGIC: header.e_ident[0] = 0; break;
        case NORMALIZE_FAULT_ELF32: header.e_ident[EI_CLASS] = ELFCLASS32; break;
        case NORMALIZE_FAULT_BIG_ENDIAN: header.e_ident[EI_DATA] = ELFDATA2MSB; break;
        case NORMALIZE_FAULT_EXECUTABLE: header.e_type = ET_EXEC; break;
        case NORMALIZE_FAULT_WRONG_MACHINE: header.e_machine = EM_AARCH64; break;
        case NORMALIZE_FAULT_BAD_HEADER_SIZE: header.e_ehsize -= 1; break;
        case NORMALIZE_FAULT_BAD_SECTION_SIZE: header.e_shentsize -= 1; break;
        case NORMALIZE_FAULT_SHOFF_OVERFLOW: header.e_shoff = UINT64_MAX - 31; break;
        case NORMALIZE_FAULT_SHSTR_INDEX: header.e_shstrndx = NORMALIZE_SECTION_COUNT; break;
        case NORMALIZE_FAULT_TEXT_MISSING: text.sh_name = 2; break;
        case NORMALIZE_FAULT_TEXT_DUPLICATE: spare = text; break;
        case NORMALIZE_FAULT_TEXT_NOBITS: text.sh_type = SHT_NOBITS; break;
        case NORMALIZE_FAULT_TEXT_WRITE: text.sh_flags |= SHF_WRITE; break;
        case NORMALIZE_FAULT_TEXT_NO_ALLOC: text.sh_flags &= ~(uint64_t)SHF_ALLOC; break;
        case NORMALIZE_FAULT_TEXT_NO_EXEC: text.sh_flags &= ~(uint64_t)SHF_EXECINSTR; break;
        case NORMALIZE_FAULT_TEXT_ADDRESS: text.sh_addr = 16; break;
        case NORMALIZE_FAULT_TEXT_ALIGN: text.sh_addralign = 32; break;
        case NORMALIZE_FAULT_TEXT_TRUNCATED: text.sh_size = site + 1; break;
        case NORMALIZE_FAULT_TEXT_OFFSET_OVERFLOW: text.sh_offset = UINT64_MAX - 8; break;
        case NORMALIZE_FAULT_FUNCTION_MISSING: function.st_name = alias.st_name; break;
        case NORMALIZE_FAULT_FUNCTION_DUPLICATE:
            alias = external;
            external = function;
            table.sh_info = NORMALIZE_ALIAS;
            relocation.r_info = ELF64_R_INFO(NORMALIZE_ALIAS, R_X86_64_PLT32);
            break;
        case NORMALIZE_FAULT_FUNCTION_GLOBAL: function.st_info = ELF64_ST_INFO(STB_GLOBAL, STT_FUNC); table.sh_info = NORMALIZE_FUNCTION; break;
        case NORMALIZE_FAULT_FUNCTION_OBJECT: function.st_info = ELF64_ST_INFO(STB_LOCAL, STT_OBJECT); break;
        case NORMALIZE_FAULT_FUNCTION_HIDDEN: function.st_other = STV_HIDDEN; break;
        case NORMALIZE_FAULT_FUNCTION_PROTECTED: function.st_other = STV_PROTECTED; break;
        case NORMALIZE_FAULT_FUNCTION_OTHER_BITS: function.st_other = 4; break;
        case NORMALIZE_FAULT_FUNCTION_UNDEFINED: function.st_shndx = SHN_UNDEF; break;
        case NORMALIZE_FAULT_FUNCTION_ABSOLUTE: function.st_shndx = SHN_ABS; break;
        case NORMALIZE_FAULT_FUNCTION_OTHER_SECTION: function.st_shndx = NORMALIZE_DATA; break;
        case NORMALIZE_FAULT_FUNCTION_BAD_SECTION: function.st_shndx = NORMALIZE_SECTION_COUNT; break;
        case NORMALIZE_FAULT_FUNCTION_SIZE: function.st_size -= 1; break;
        case NORMALIZE_FAULT_FUNCTION_END: function.st_value = text.sh_size - 1; break;
        case NORMALIZE_FAULT_FUNCTION_OVERFLOW: function.st_value = UINT64_MAX - 10; break;
        case NORMALIZE_FAULT_SITE_PREIMAGE: fixture->data[file_site] ^= 1; break;
        case NORMALIZE_FAULT_CALL_PREIMAGE: fixture->data[file_site - 5] = 0xe9; break;
        case NORMALIZE_FAULT_STORE_PREIMAGE: fixture->data[file_site + 5] ^= 1; break;
        case NORMALIZE_FAULT_LOAD_PREIMAGE: fixture->data[file_site + 15] ^= 1; break;
        case NORMALIZE_FAULT_PREIMAGE_OTHER_OFFSET:
            memmove(fixture->data + file_site - 4, fixture->data + file_site - 5, 21);
            fixture->data[file_site - 5] = 0x90;
            break;
        case NORMALIZE_FAULT_RELOCATION_MISSING: relocations.sh_size = 0; break;
        case NORMALIZE_FAULT_RELOCATION_DUPLICATE: extra = relocation; add_relocation = true; break;
        case NORMALIZE_FAULT_RELOCATION_OFFSET: relocation.r_offset += 1; break;
        case NORMALIZE_FAULT_RELOCATION_TYPE: relocation.r_info = ELF64_R_INFO(NORMALIZE_EXTERNAL, R_X86_64_PC32); break;
        case NORMALIZE_FAULT_RELOCATION_ADDEND: relocation.r_addend = -3; break;
        case NORMALIZE_FAULT_RELOCATION_OTHER_SYMBOL: relocation.r_info = ELF64_R_INFO(NORMALIZE_ALIAS, R_X86_64_PLT32); break;
        case NORMALIZE_FAULT_RELOCATION_BAD_SYMBOL: relocation.r_info = ELF64_R_INFO(NORMALIZE_SYMBOL_COUNT, R_X86_64_PLT32); break;
        case NORMALIZE_FAULT_RELOCATION_FOREIGN_TABLE:
        {
            Elf64_Sym empty = {0};
            spare.sh_type = SHT_SYMTAB;
            spare.sh_link = NORMALIZE_STRTAB;
            spare.sh_entsize = sizeof(Elf64_Sym);
            spare.sh_addralign = 8;
            spare.sh_info = NORMALIZE_EXTERNAL;
            relocations.sh_link = NORMALIZE_SPARE;
            memcpy(fixture->data + (size_t)spare.sh_offset + sizeof(Elf64_Sym), &empty, sizeof(empty));
        } break;
        case NORMALIZE_FAULT_RELOCATION_WRONG_TARGET: relocations.sh_info = NORMALIZE_DATA; break;
        case NORMALIZE_FAULT_RELOCATION_REL: relocations.sh_type = SHT_REL; relocations.sh_entsize = sizeof(Elf64_Rel); relocations.sh_size = sizeof(Elf64_Rel); break;
        case NORMALIZE_FAULT_RELOCATION_ENTRY_SIZE: relocations.sh_entsize -= 1; break;
        case NORMALIZE_FAULT_RELOCATION_TRUNCATED: relocations.sh_size -= 1; break;
        case NORMALIZE_FAULT_RELOCATION_OVERLAP_LEFT: extra.r_offset = site - 8; extra.r_info = ELF64_R_INFO(NORMALIZE_EXTERNAL, R_X86_64_64); add_relocation = true; break;
        case NORMALIZE_FAULT_RELOCATION_OVERLAP_RIGHT: extra.r_offset = site + 15; add_relocation = true; break;
        case NORMALIZE_FAULT_RELOCATION_UNKNOWN_OUTSIDE: extra.r_offset = 32; extra.r_info = ELF64_R_INFO(NORMALIZE_EXTERNAL, 255); add_relocation = true; break;
        case NORMALIZE_FAULT_RELOCATION_OUTSIDE_BOUNDS: extra.r_offset = text.sh_size - 1; add_relocation = true; break;
        case NORMALIZE_FAULT_RELOCATION_OFFSET_OVERFLOW: extra.r_offset = UINT64_MAX; add_relocation = true; break;
        case NORMALIZE_FAULT_RELOCATION_SAFE_BEFORE: extra.r_offset = site - 9; add_relocation = true; break;
        case NORMALIZE_FAULT_RELOCATION_SAFE_AFTER: extra.r_offset = site + 16; add_relocation = true; break;
        case NORMALIZE_FAULT_EXTERNAL_NAME: external.st_name = alias.st_name; break;
        case NORMALIZE_FAULT_EXTERNAL_LOCAL: external.st_info = ELF64_ST_INFO(STB_LOCAL, STT_NOTYPE); table.sh_info = NORMALIZE_ALIAS; break;
        case NORMALIZE_FAULT_EXTERNAL_FUNC: external.st_info = ELF64_ST_INFO(STB_GLOBAL, STT_FUNC); break;
        case NORMALIZE_FAULT_EXTERNAL_HIDDEN: external.st_other = STV_HIDDEN; break;
        case NORMALIZE_FAULT_EXTERNAL_DEFINED: external.st_shndx = NORMALIZE_TEXT; break;
        case NORMALIZE_FAULT_EXTERNAL_VALUE: external.st_value = 1; break;
        case NORMALIZE_FAULT_EXTERNAL_SIZE: external.st_size = 1; break;
        case NORMALIZE_FAULT_SYMBOL_ENTRY_SIZE: table.sh_entsize -= 1; break;
        case NORMALIZE_FAULT_SYMBOL_TABLE_LINK: table.sh_link = NORMALIZE_TEXT; break;
        case NORMALIZE_FAULT_SYMBOL_NAME_BOUNDS: function.st_name = UINT32_MAX; break;
        case NORMALIZE_FAULT_SECTION_NAME_BOUNDS: text.sh_name = UINT32_MAX; break;
    }
    memcpy(fixture->data + (size_t)relocations.sh_offset, &relocation, sizeof(relocation));
    if (add_relocation)
    {
        memcpy(fixture->data + (size_t)relocations.sh_offset + sizeof(relocation), &extra, sizeof(extra));
        relocations.sh_size = 2 * sizeof(Elf64_Rela);
    }
    normalize_set_header(fixture, header);
    normalize_set_section(fixture, NORMALIZE_TEXT, text);
    normalize_set_section(fixture, NORMALIZE_SYMTAB, table);
    normalize_set_section(fixture, NORMALIZE_RELA, relocations);
    normalize_set_section(fixture, NORMALIZE_SPARE, spare);
    normalize_set_symbol(fixture, NORMALIZE_FUNCTION, function);
    normalize_set_symbol(fixture, NORMALIZE_EXTERNAL, external);
    normalize_set_symbol(fixture, NORMALIZE_ALIAS, alias);
    return;
}

static char *normalize_replace(const char *input, const char *needle, const char *replacement)
{
    const char *found = strstr(input, needle);
    assert(found != NULL && strstr(found + strlen(needle), needle) == NULL);
    size_t prefix = (size_t)(found - input);
    size_t suffix = strlen(found + strlen(needle));
    size_t replacement_size = strlen(replacement);
    char *output = malloc(prefix + replacement_size + suffix + 1);
    assert(output != NULL);
    memcpy(output, input, prefix);
    memcpy(output + prefix, replacement, replacement_size);
    memcpy(output + prefix + replacement_size, found + strlen(needle), suffix + 1);
    return output;
}

static bool normalize_proof_matches(const HpNormalizationProof *proof, const NormalizeFixture *fixture, const char *assembly, const char *source, const char *normal)
{
    const char *instruction = strstr(assembly, "fadd\t%st, %st(0)");
    assert(instruction != NULL);
    size_t offset = (size_t)(instruction - assembly);
    size_t line = 1;
    size_t line_offset = 0;
    for (size_t index = 0; index < offset; index += 1)
    {
        if (assembly[index] == '\n')
        {
            line += 1;
            line_offset = index + 1;
        }
    }
    Elf64_Shdr text = normalize_section(fixture, NORMALIZE_TEXT);
    uint64_t site = fixture->function_value + BUSTER_HP_NORMALIZE_FUNCTION_SITE;
    uint64_t function_label_id = 0;
    uint64_t basic_block_id = 0;
    const char *next_line = strchr(instruction, '\n');
    assert(next_line != NULL);
    int parsed = sscanf(next_line + 1, ".LBB%" SCNu64 "_%" SCNu64 ":", &function_label_id, &basic_block_id);
    assert(parsed == 2);
    bool valid = proof->profile != NULL && proof->profile[0] != 0;
    valid = valid && strcmp(proof->source_manifest_sha256, source) == 0 && strcmp(proof->qualified_normal_sha256, normal) == 0;
    valid = valid && proof->edits == 1 && proof->assembly_line == line && proof->assembly_line_offset == line_offset;
    valid = valid && proof->instruction_offset == offset && proof->instruction_size == strlen("fadd\t%st, %st(0)");
    valid = valid && proof->function_label_id == function_label_id && proof->basic_block_id == basic_block_id;
    valid = valid && proof->object_symbol == NORMALIZE_FUNCTION && proof->object_section == NORMALIZE_TEXT;
    valid = valid && proof->function_value == fixture->function_value && proof->function_size == BUSTER_HP_NORMALIZE_FUNCTION_SIZE;
    valid = valid && proof->function_site == BUSTER_HP_NORMALIZE_FUNCTION_SITE && proof->section_site == site;
    valid = valid && proof->object_file_site == text.sh_offset + site && proof->call_relocation == 0;
    valid = valid && proof->call_relocation_offset == site - 4 && proof->call_relocation_type == R_X86_64_PLT32 && proof->call_relocation_addend == -4;
    valid = valid && proof->preimage[0] == 0xdc && proof->preimage[1] == 0xc0;
    return valid;
}

static void normalize_exercise(NormalizeSuite *suite, const char *name, const char *assembly, size_t assembly_size, NormalizeFixture *fixture, size_t object_size, const char *source, const char *normal, bool expected, HpNormalizationProof *retained)
{
    unsigned char *assembly_copy = malloc(assembly_size == 0 ? 1 : assembly_size);
    unsigned char *object_copy = malloc(fixture->size);
    assert(assembly_copy != NULL && object_copy != NULL);
    if (assembly_size != 0)
    {
        memcpy(assembly_copy, assembly, assembly_size);
    }
    memcpy(object_copy, fixture->data, fixture->size);
    HpBuffer output = {0};
    HpNormalizationProof proof = {0};
    HpNormalizationProof empty = {0};
    char error[BUSTER_HP_ERROR_CAPACITY] = {0};
    HpBytes raw = {.data = (const unsigned char *)assembly, .size = assembly_size};
    HpBytes object = {.data = fixture->data, .size = object_size};
    bool accepted = hp_normalize_checker(raw, object, source, normal, &output, &proof, error);
    bool passed = accepted == expected;
    passed = passed && (assembly_size == 0 || memcmp(assembly_copy, assembly, assembly_size) == 0);
    passed = passed && memcmp(object_copy, fixture->data, fixture->size) == 0;
    if (accepted && expected)
    {
        char *wanted = normalize_replace(assembly, "fadd\t%st, %st(0)", ".byte\t0xdc, 0xc0");
        passed = passed && output.data != NULL && output.data != raw.data && output.data != object.data;
        passed = passed && output.size == strlen(wanted) && memcmp(output.data, wanted, output.size) == 0;
        passed = passed && normalize_proof_matches(&proof, fixture, assembly, source, normal);
        if (retained != NULL)
        {
            *retained = proof;
        }
        free(wanted);
    }
    else if (!accepted)
    {
        passed = passed && output.data == NULL && output.size == 0 && memcmp(&proof, &empty, sizeof(proof)) == 0 && error[0] != 0;
    }
    if (accepted && !expected)
    {
        snprintf(error, sizeof(error), "unexpectedly accepted guarded input");
    }
    normalize_record(suite, name, passed, error);
    hp_buffer_free(&output);
    free(assembly_copy);
    free(object_copy);
    return;
}

static void normalize_assembly_controls(NormalizeSuite *suite)
{
    typedef struct AssemblyCase AssemblyCase;
    struct AssemblyCase
    {
        const char *name;
        const char *needle;
        const char *replacement;
        bool accepted;
    };
    static const AssemblyCase cases[] =
    {
        {"instruction-comment-preserved", "\tfadd\t%st, %st(0)\n", "\tfadd\t%st, %st(0) # synthetic tail retained\n", true},
        {"surrounding-comment-decoys-preserved", "\tpushq\t%rbp\n", "# fadd %st, %st(0)\n\tpushq\t%rbp\n", true},
        {"other-same-id-basic-block-accepted", "\tpushq\t%rbp\n", ".LBB1222_1:\n\tpushq\t%rbp\n", true},
        {"quoted-semicolon-and-hash-preserved", "\tpushq\t%rbp\n", "\t.ascii\t\"synthetic;#text\"\n\tpushq\t%rbp\n", true},
        {"out-of-scope-distinct-name-prefix-accepted", NORMALIZE_SIZE_LINE, NORMALIZE_SIZE_LINE "check_test_action_constraints_extra : nop\n", true},
        {"out-of-scope-distinct-bb-id-accepted", NORMALIZE_SIZE_LINE, NORMALIZE_SIZE_LINE ".LBB1222_330 : nop\n", true},
        {"out-of-scope-distinct-end-id-accepted", NORMALIZE_SIZE_LINE, NORMALIZE_SIZE_LINE ".Lfunc_end12220 : nop\n", true},
        {"out-of-scope-quoted-self-fadd-text-preserved", NORMALIZE_SIZE_LINE, NORMALIZE_SIZE_LINE "\t.asciz\t\"fadd %st, %st(0)\"\n", true},
        {"out-of-scope-other-plain-function-metadata-preserved", NORMALIZE_SIZE_LINE, NORMALIZE_SIZE_LINE "\t.type\tother_function,@function\nother_function:\n\tretq\n.Lfunc_end999:\n\t.size\tother_function,.Lfunc_end999-other_function\n", true},
        {"zero-fadd-refused", "\tfadd\t%st, %st(0)\n", "\tnop\n", false},
        {"multiple-fadd-in-function-refused", "\tretq\n.Lfunc_end1222:", "\tfadd\t%st, %st(0)\n\tretq\n.Lfunc_end1222:", false},
        {"fadd-outside-function-refused", "synthetic_hot:\n\tretq\n", "synthetic_hot:\n\tfadd\t%st, %st(0)\n\tretq\n", false},
        {"labeled-self-fadd-before-function-refused", "synthetic_hot:\n\tretq\n", "synthetic_hot:\nother_label: fadd\t%st, %st(0)\n\tretq\n", false},
        {"labeled-self-fadd-after-function-refused", NORMALIZE_SIZE_LINE, NORMALIZE_SIZE_LINE "other_label: fadd\t%st, %st(0)\n", false},
        {"chained-labeled-self-fadd-after-function-refused", NORMALIZE_SIZE_LINE, NORMALIZE_SIZE_LINE "other_label: .Ltmp: fadd\t%st, %st(0)\n", false},
        {"labeled-extra-self-fadd-in-function-refused", "\tpushq\t%rbp\n", ".Ltmp: fadd\t%st, %st(0)\n\tpushq\t%rbp\n", false},
        {"chained-labeled-self-fadd-in-function-refused", "\tpushq\t%rbp\n", ".Ltmp: .Lother: fadd\t%st, %st(0)\n\tpushq\t%rbp\n", false},
        {"primary-self-fadd-labeled-spelling-refused", "\tfadd\t%st, %st(0)\n", ".Ltmp: fadd\t%st, %st(0)\n", false},
        {"fadd-after-function-refused", ".Lfunc_end1222:\n", ".Lfunc_end1222:\n\tfadd\t%st, %st(0)\n", false},
        {"wrong-fadd-operands-refused", "fadd\t%st, %st(0)", "fadd\t%st(1), %st(0)", false},
        {"fadd-split-register-token-refused", "fadd\t%st, %st(0)", "fadd\t%s t, %st(0)", false},
        {"faddp-not-substituted", "fadd\t%st, %st(0)", "faddp\t%st, %st(0)", false},
        {"uppercase-fadd-not-guessed", "fadd\t%st, %st(0)", "FADD\t%st, %st(0)", false},
        {"missing-function-type-refused", "\t.type\tcheck_test_action_constraints,@function\n", "", false},
        {"wrong-function-type-refused", "\t.type\tcheck_test_action_constraints,@function", "\t.type\tcheck_test_action_constraints,@object", false},
        {"split-function-type-token-refused", "\t.type\tcheck_test_action_constraints,@function", "\t.type\tcheck_test_action_constraints,@func tion", false},
        {"duplicate-function-type-refused", "\t.type\tcheck_test_action_constraints,@function\n", "\t.type\tcheck_test_action_constraints,@function\n\t.type\tcheck_test_action_constraints,@function\n", false},
        {"out-of-scope-labeled-duplicate-function-type", NORMALIZE_SIZE_LINE, NORMALIZE_SIZE_LINE "other: .type check_test_action_constraints,@function\n", false},
        {"out-of-scope-chained-duplicate-function-type", NORMALIZE_SIZE_LINE, NORMALIZE_SIZE_LINE "other: .Ltmp: .type check_test_action_constraints,@function\n", false},
        {"out-of-scope-quoted-type-symbol-refused", NORMALIZE_SIZE_LINE, NORMALIZE_SIZE_LINE "\t.type\t\"check_test_action_constraints\",@function\n", false},
        {"out-of-scope-escaped-type-symbol-refused", NORMALIZE_SIZE_LINE, NORMALIZE_SIZE_LINE "\t.type\tcheck_test_action_constr\\aints,@function\n", false},
        {"out-of-scope-labeled-quoted-type-symbol-refused", NORMALIZE_SIZE_LINE, NORMALIZE_SIZE_LINE "other: .type \"check_test_action_constraints\",@function\n", false},
        {"out-of-scope-labeled-escaped-type-symbol-refused", NORMALIZE_SIZE_LINE, NORMALIZE_SIZE_LINE "other: .type check_test_action_constr\\aints,@function\n", false},
        {"missing-function-label-refused", "check_test_action_constraints:\n", "another_function:\n", false},
        {"duplicate-function-label-refused", "check_test_action_constraints:\n", "check_test_action_constraints:\ncheck_test_action_constraints:\n", false},
        {"out-of-scope-duplicate-function-space-colon", NORMALIZE_SIZE_LINE, NORMALIZE_SIZE_LINE "check_test_action_constraints :\n", false},
        {"out-of-scope-duplicate-function-tab-colon", NORMALIZE_SIZE_LINE, NORMALIZE_SIZE_LINE "check_test_action_constraints\t:\n", false},
        {"out-of-scope-duplicate-function-inline-content", NORMALIZE_SIZE_LINE, NORMALIZE_SIZE_LINE "check_test_action_constraints: nop\n", false},
        {"out-of-scope-duplicate-function-tab-inline-content", NORMALIZE_SIZE_LINE, NORMALIZE_SIZE_LINE "check_test_action_constraints\t: nop\n", false},
        {"out-of-scope-chained-duplicate-function", NORMALIZE_SIZE_LINE, NORMALIZE_SIZE_LINE "other: check_test_action_constraints : nop\n", false},
        {"out-of-scope-quoted-duplicate-function", NORMALIZE_SIZE_LINE, NORMALIZE_SIZE_LINE "\"check_test_action_constraints\" : nop\n", false},
        {"out-of-scope-semicolon-duplicate-function", NORMALIZE_SIZE_LINE, NORMALIZE_SIZE_LINE "nop; check_test_action_constraints :\n", false},
        {"out-of-scope-bare-backslash-definition-refused", NORMALIZE_SIZE_LINE, NORMALIZE_SIZE_LINE "escaped\\label:\n", false},
        {"wrong-active-function-refused", "\tpushq\t%rbp\n", "\t.type\tother_function,@function\nother_function:\n\tpushq\t%rbp\n", false},
        {"nested-other-function-type-refused", "\tpushq\t%rbp\n", "\t.type\tother_function,@function\n\tpushq\t%rbp\n", false},
        {"nonlocal-label-in-function-refused", "\tpushq\t%rbp\n", "other_function:\n\tpushq\t%rbp\n", false},
        {"nonlocal-label-with-inline-instruction-refused", "\tpushq\t%rbp\n", "other_function: nop\n\tpushq\t%rbp\n", false},
        {"local-then-nonlocal-chained-label-in-scope-refused", "\tpushq\t%rbp\n", ".Ldistinct: other_function: nop\n\tpushq\t%rbp\n", false},
        {"chained-foreign-bb-in-scope-refused", "\tpushq\t%rbp\n", ".Ltmp: .LBB999_1:\n\tpushq\t%rbp\n", false},
        {"chained-duplicate-bb-in-scope-refused", "\tpushq\t%rbp\n", ".Ltmp: .LBB1222_33:\n\tpushq\t%rbp\n", false},
        {"chained-same-id-new-bb-in-scope-refused", "\tpushq\t%rbp\n", ".Ltmp: .LBB1222_1:\n\tpushq\t%rbp\n", false},
        {"chained-local-labels-in-scope-refused", "\tpushq\t%rbp\n", ".Ltmp: .Lother:\n\tpushq\t%rbp\n", false},
        {"local-label-trailing-code-in-scope-refused", "\tpushq\t%rbp\n", ".Ltmp: nop\n\tpushq\t%rbp\n", false},
        {"missing-function-size-refused", "\t.size\tcheck_test_action_constraints, .Lfunc_end1222-check_test_action_constraints\n", "", false},
        {"duplicate-function-size-refused", "\t.size\tcheck_test_action_constraints, .Lfunc_end1222-check_test_action_constraints\n", "\t.size\tcheck_test_action_constraints, .Lfunc_end1222-check_test_action_constraints\n\t.size\tcheck_test_action_constraints, .Lfunc_end1222-check_test_action_constraints\n", false},
        {"out-of-scope-labeled-duplicate-function-size", NORMALIZE_SIZE_LINE, NORMALIZE_SIZE_LINE "other: .size check_test_action_constraints, .Lfunc_end1222-check_test_action_constraints\n", false},
        {"out-of-scope-chained-duplicate-function-size", NORMALIZE_SIZE_LINE, NORMALIZE_SIZE_LINE "other: .Ltmp: .size check_test_action_constraints, .Lfunc_end1222-check_test_action_constraints\n", false},
        {"out-of-scope-quoted-size-symbol-refused", NORMALIZE_SIZE_LINE, NORMALIZE_SIZE_LINE "\t.size\t\"check_test_action_constraints\",.Lfunc_end1222-check_test_action_constraints\n", false},
        {"out-of-scope-escaped-size-symbol-refused", NORMALIZE_SIZE_LINE, NORMALIZE_SIZE_LINE "\t.size\tcheck_test_action_constr\\aints,.Lfunc_end1222-check_test_action_constraints\n", false},
        {"out-of-scope-labeled-quoted-size-symbol-refused", NORMALIZE_SIZE_LINE, NORMALIZE_SIZE_LINE "other: .size \"check_test_action_constraints\",.Lfunc_end1222-check_test_action_constraints\n", false},
        {"out-of-scope-labeled-escaped-size-symbol-refused", NORMALIZE_SIZE_LINE, NORMALIZE_SIZE_LINE "other: .size check_test_action_constr\\aints,.Lfunc_end1222-check_test_action_constraints\n", false},
        {"wrong-size-function-refused", ".Lfunc_end1222-check_test_action_constraints", ".Lfunc_end1222-another_function", false},
        {"split-size-end-id-token-refused", ".Lfunc_end1222-check_test_action_constraints", ".Lfunc_end1 222-check_test_action_constraints", false},
        {"split-size-function-name-token-refused", ".Lfunc_end1222-check_test_action_constraints", ".Lfunc_end1222-check_test_action_con straints", false},
        {"numeric-size-not-guessed", ".Lfunc_end1222-check_test_action_constraints", "15709", false},
        {"missing-end-label-refused", ".Lfunc_end1222:\n", "", false},
        {"duplicate-end-label-refused", ".Lfunc_end1222:\n", ".Lfunc_end1222:\n.Lfunc_end1222:\n", false},
        {"out-of-scope-duplicate-end-space-colon", NORMALIZE_SIZE_LINE, NORMALIZE_SIZE_LINE ".Lfunc_end1222 :\n", false},
        {"out-of-scope-duplicate-end-tab-colon", NORMALIZE_SIZE_LINE, NORMALIZE_SIZE_LINE ".Lfunc_end1222\t:\n", false},
        {"out-of-scope-duplicate-end-inline-content", NORMALIZE_SIZE_LINE, NORMALIZE_SIZE_LINE ".Lfunc_end1222: nop\n", false},
        {"out-of-scope-duplicate-end-tab-inline-content", NORMALIZE_SIZE_LINE, NORMALIZE_SIZE_LINE ".Lfunc_end1222\t: nop\n", false},
        {"out-of-scope-chained-duplicate-end", NORMALIZE_SIZE_LINE, NORMALIZE_SIZE_LINE "other: .Lfunc_end1222 : nop\n", false},
        {"out-of-scope-quoted-duplicate-end", NORMALIZE_SIZE_LINE, NORMALIZE_SIZE_LINE "\".Lfunc_end1222\" : nop\n", false},
        {"out-of-scope-semicolon-duplicate-end", NORMALIZE_SIZE_LINE, NORMALIZE_SIZE_LINE "nop; .Lfunc_end1222 :\n", false},
        {"wrong-end-id-refused", ".Lfunc_end1222:\n", ".Lfunc_end999:\n", false},
        {"malformed-end-id-refused", ".Lfunc_end1222:\n", ".Lfunc_end12x2:\n", false},
        {"missing-bb-label-refused", ".LBB1222_33:\n", "", false},
        {"wrong-bb-id-refused", ".LBB1222_33:\n", ".LBB1223_33:\n", false},
        {"malformed-bb-id-refused", ".LBB1222_33:\n", ".LBB1222_x3:\n", false},
        {"duplicate-bb-label-refused", ".LBB1222_33:\n", ".LBB1222_33:\n.LBB1222_33:\n", false},
        {"out-of-scope-duplicate-bb-space-colon", NORMALIZE_SIZE_LINE, NORMALIZE_SIZE_LINE ".LBB1222_33 :\n", false},
        {"out-of-scope-duplicate-bb-tab-colon", NORMALIZE_SIZE_LINE, NORMALIZE_SIZE_LINE ".LBB1222_33\t:\n", false},
        {"out-of-scope-duplicate-bb-inline-content", NORMALIZE_SIZE_LINE, NORMALIZE_SIZE_LINE ".LBB1222_33: nop\n", false},
        {"out-of-scope-duplicate-bb-tab-inline-content", NORMALIZE_SIZE_LINE, NORMALIZE_SIZE_LINE ".LBB1222_33\t: nop\n", false},
        {"out-of-scope-chained-duplicate-bb", NORMALIZE_SIZE_LINE, NORMALIZE_SIZE_LINE "other: .LBB1222_33 : nop\n", false},
        {"out-of-scope-quoted-duplicate-bb", NORMALIZE_SIZE_LINE, NORMALIZE_SIZE_LINE "\".LBB1222_33\" : nop\n", false},
        {"out-of-scope-semicolon-duplicate-bb", NORMALIZE_SIZE_LINE, NORMALIZE_SIZE_LINE "nop; .LBB1222_33 :\n", false},
        {"duplicate-bb-elsewhere-refused", "\tpushq\t%rbp\n", ".LBB1222_33:\n\tpushq\t%rbp\n", false},
        {"other-bb-function-id-in-scope-refused", "\tpushq\t%rbp\n", ".LBB999_1:\n\tpushq\t%rbp\n", false},
        {"instruction-before-bb-refused", ".LBB1222_33:\n", "\tnop\n.LBB1222_33:\n", false},
        {"missing-call-refused", "\tcallq\t__floatuntixf@PLT\n", "", false},
        {"wrong-call-target-refused", "__floatuntixf@PLT", "__floatundixf@PLT", false},
        {"split-call-target-token-refused", "__floatuntixf@PLT", "__float un tixf@PLT", false},
        {"call-without-plt-refused", "__floatuntixf@PLT", "__floatuntixf", false},
        {"instruction-between-call-and-fadd-refused", "\tcallq\t__floatuntixf@PLT\n", "\tcallq\t__floatuntixf@PLT\n\tnop\n", false},
        {"wrong-store-offset-refused", "fstpt\t1264(%rsp)", "fstpt\t1263(%rsp)", false},
        {"wrong-store-register-refused", "fstpt\t1264(%rsp)", "fstpt\t1264(%rbp)", false},
        {"split-store-register-token-refused", "fstpt\t1264(%rsp)", "fstpt\t1264(%r sp)", false},
        {"split-store-offset-token-refused", "fstpt\t1264(%rsp)", "fstpt\t12 64(%rsp)", false},
        {"wrong-load-offset-refused", "fldt\t1072(%rsp)", "fldt\t1073(%rsp)", false},
        {"split-load-register-token-refused", "fldt\t1072(%rsp)", "fldt\t1072(%r sp)", false},
        {"split-load-offset-token-refused", "fldt\t1072(%rsp)", "fldt\t10 72(%rsp)", false},
        {"missing-store-refused", "\tfstpt\t1264(%rsp)\n", "", false},
        {"missing-load-refused", "\tfldt\t1072(%rsp)\n", "", false},
        {"wrong-ordinary-text-context-refused", "\t.text\n", "\t.section\t.data\n", false},
        {"section-switch-inside-function-refused", "\tpushq\t%rbp\n", "\t.section\t.text.buster_checker,\"ax\",@progbits\n\tpushq\t%rbp\n", false},
        {"section-switch-and-return-inside-function-refused", "\tpushq\t%rbp\n", "\t.section\t.data\n\t.text\n\tpushq\t%rbp\n", false},
        {"missing-hot-envelope-refused", "\t.section\t.text.buster_checker,\"ax\",@progbits\n", "\t.section\t.text.other,\"ax\",@progbits\n", false},
        {"wrong-hot-alignment-refused", "\t.p2align\t12\n", "\t.p2align\t11\n", false},
        {"hot-content-before-alignment-refused", "\t.p2align\t12\n", "\tnop\n\t.p2align\t12\n", false},
        {"unsupported-conditional-refused", "\tpushq\t%rbp\n", "\t.if 1\n\tpushq\t%rbp\n\t.endif\n", false},
        {"semicolon-elsewhere-in-function-refused", "\tpushq\t%rbp\n", "\tpushq\t%rbp; nop\n", false},
        {"unbalanced-string-in-function-refused", "\tpushq\t%rbp\n", "\t.ascii\t\"unterminated\n\tpushq\t%rbp\n", false},
        {"embedded-semicolon-not-guessed", "\tfadd\t%st, %st(0)\n", "\tnop; fadd\t%st, %st(0)\n", false}
    };
    for (size_t index = 0; index < NORMALIZE_ARRAY_COUNT(cases); index += 1)
    {
        NormalizeFixture fixture;
        normalize_fixture(&fixture, NORMALIZE_BASE_VALUE);
        char *assembly = normalize_replace(normalize_assembly, cases[index].needle, cases[index].replacement);
        normalize_exercise(suite, cases[index].name, assembly, strlen(assembly), &fixture, fixture.size, BUSTER_HP_NORMALIZE_BASE_SOURCE, BUSTER_HP_NORMALIZE_BASE_NORMAL, cases[index].accepted, NULL);
        free(assembly);
        free(fixture.data);
    }
    return;
}

static void normalize_object_controls(NormalizeSuite *suite)
{
    typedef struct ObjectCase ObjectCase;
    struct ObjectCase
    {
        const char *name;
        NormalizeFault fault;
        bool accepted;
    };
    static const ObjectCase cases[] =
    {
        {"elf-bad-magic", NORMALIZE_FAULT_BAD_MAGIC, false},
        {"elf32-refused", NORMALIZE_FAULT_ELF32, false},
        {"elf-big-endian-refused", NORMALIZE_FAULT_BIG_ENDIAN, false},
        {"elf-executable-refused", NORMALIZE_FAULT_EXECUTABLE, false},
        {"elf-other-machine-refused", NORMALIZE_FAULT_WRONG_MACHINE, false},
        {"elf-header-size-refused", NORMALIZE_FAULT_BAD_HEADER_SIZE, false},
        {"elf-section-size-refused", NORMALIZE_FAULT_BAD_SECTION_SIZE, false},
        {"elf-section-offset-overflow", NORMALIZE_FAULT_SHOFF_OVERFLOW, false},
        {"elf-section-name-table-bounds", NORMALIZE_FAULT_SHSTR_INDEX, false},
        {"object-text-missing", NORMALIZE_FAULT_TEXT_MISSING, false},
        {"object-text-duplicate", NORMALIZE_FAULT_TEXT_DUPLICATE, false},
        {"object-text-nobits", NORMALIZE_FAULT_TEXT_NOBITS, false},
        {"object-text-writable", NORMALIZE_FAULT_TEXT_WRITE, false},
        {"object-text-not-allocated", NORMALIZE_FAULT_TEXT_NO_ALLOC, false},
        {"object-text-not-executable", NORMALIZE_FAULT_TEXT_NO_EXEC, false},
        {"object-text-address", NORMALIZE_FAULT_TEXT_ADDRESS, false},
        {"object-text-alignment", NORMALIZE_FAULT_TEXT_ALIGN, false},
        {"object-text-window-bounds", NORMALIZE_FAULT_TEXT_TRUNCATED, false},
        {"object-text-offset-overflow", NORMALIZE_FAULT_TEXT_OFFSET_OVERFLOW, false},
        {"object-function-missing", NORMALIZE_FAULT_FUNCTION_MISSING, false},
        {"object-function-duplicate", NORMALIZE_FAULT_FUNCTION_DUPLICATE, false},
        {"object-function-global", NORMALIZE_FAULT_FUNCTION_GLOBAL, false},
        {"object-function-object-type", NORMALIZE_FAULT_FUNCTION_OBJECT, false},
        {"object-function-hidden", NORMALIZE_FAULT_FUNCTION_HIDDEN, false},
        {"object-function-protected", NORMALIZE_FAULT_FUNCTION_PROTECTED, false},
        {"object-function-other-bits", NORMALIZE_FAULT_FUNCTION_OTHER_BITS, false},
        {"object-function-undefined", NORMALIZE_FAULT_FUNCTION_UNDEFINED, false},
        {"object-function-absolute", NORMALIZE_FAULT_FUNCTION_ABSOLUTE, false},
        {"object-function-other-section", NORMALIZE_FAULT_FUNCTION_OTHER_SECTION, false},
        {"object-function-section-bounds", NORMALIZE_FAULT_FUNCTION_BAD_SECTION, false},
        {"object-function-wrong-size", NORMALIZE_FAULT_FUNCTION_SIZE, false},
        {"object-function-extent-bounds", NORMALIZE_FAULT_FUNCTION_END, false},
        {"object-function-extent-overflow", NORMALIZE_FAULT_FUNCTION_OVERFLOW, false},
        {"object-fadd-preimage", NORMALIZE_FAULT_SITE_PREIMAGE, false},
        {"object-call-preimage", NORMALIZE_FAULT_CALL_PREIMAGE, false},
        {"object-store-preimage", NORMALIZE_FAULT_STORE_PREIMAGE, false},
        {"object-load-preimage", NORMALIZE_FAULT_LOAD_PREIMAGE, false},
        {"object-relative-site-mismatch", NORMALIZE_FAULT_PREIMAGE_OTHER_OFFSET, false},
        {"call-relocation-missing", NORMALIZE_FAULT_RELOCATION_MISSING, false},
        {"call-relocation-duplicate", NORMALIZE_FAULT_RELOCATION_DUPLICATE, false},
        {"call-relocation-offset", NORMALIZE_FAULT_RELOCATION_OFFSET, false},
        {"call-relocation-type", NORMALIZE_FAULT_RELOCATION_TYPE, false},
        {"call-relocation-addend", NORMALIZE_FAULT_RELOCATION_ADDEND, false},
        {"call-relocation-other-symbol", NORMALIZE_FAULT_RELOCATION_OTHER_SYMBOL, false},
        {"call-relocation-symbol-bounds", NORMALIZE_FAULT_RELOCATION_BAD_SYMBOL, false},
        {"call-relocation-foreign-symtab", NORMALIZE_FAULT_RELOCATION_FOREIGN_TABLE, false},
        {"call-relocation-other-section", NORMALIZE_FAULT_RELOCATION_WRONG_TARGET, false},
        {"call-relocation-rel-format", NORMALIZE_FAULT_RELOCATION_REL, false},
        {"call-relocation-entry-size", NORMALIZE_FAULT_RELOCATION_ENTRY_SIZE, false},
        {"call-relocation-partial-entry", NORMALIZE_FAULT_RELOCATION_TRUNCATED, false},
        {"other-relocation-overlap-call", NORMALIZE_FAULT_RELOCATION_OVERLAP_LEFT, false},
        {"other-relocation-overlap-load", NORMALIZE_FAULT_RELOCATION_OVERLAP_RIGHT, false},
        {"other-relocation-unknown-width-outside", NORMALIZE_FAULT_RELOCATION_UNKNOWN_OUTSIDE, false},
        {"other-relocation-bounds-outside", NORMALIZE_FAULT_RELOCATION_OUTSIDE_BOUNDS, false},
        {"other-relocation-offset-overflow", NORMALIZE_FAULT_RELOCATION_OFFSET_OVERFLOW, false},
        {"other-relocation-adjacent-before", NORMALIZE_FAULT_RELOCATION_SAFE_BEFORE, true},
        {"other-relocation-adjacent-after", NORMALIZE_FAULT_RELOCATION_SAFE_AFTER, true},
        {"external-symbol-wrong-name", NORMALIZE_FAULT_EXTERNAL_NAME, false},
        {"external-symbol-local", NORMALIZE_FAULT_EXTERNAL_LOCAL, false},
        {"external-symbol-function", NORMALIZE_FAULT_EXTERNAL_FUNC, false},
        {"external-symbol-hidden", NORMALIZE_FAULT_EXTERNAL_HIDDEN, false},
        {"external-symbol-defined", NORMALIZE_FAULT_EXTERNAL_DEFINED, false},
        {"external-symbol-nonzero-value", NORMALIZE_FAULT_EXTERNAL_VALUE, false},
        {"external-symbol-nonzero-size", NORMALIZE_FAULT_EXTERNAL_SIZE, false},
        {"symbol-table-entry-size", NORMALIZE_FAULT_SYMBOL_ENTRY_SIZE, false},
        {"symbol-table-string-link", NORMALIZE_FAULT_SYMBOL_TABLE_LINK, false},
        {"symbol-name-bounds", NORMALIZE_FAULT_SYMBOL_NAME_BOUNDS, false},
        {"section-name-bounds", NORMALIZE_FAULT_SECTION_NAME_BOUNDS, false}
    };
    for (size_t index = 0; index < NORMALIZE_ARRAY_COUNT(cases); index += 1)
    {
        NormalizeFixture fixture;
        normalize_fixture(&fixture, NORMALIZE_BASE_VALUE);
        normalize_fault(&fixture, cases[index].fault);
        normalize_exercise(suite, cases[index].name, normalize_assembly, sizeof(normalize_assembly) - 1, &fixture, fixture.size, BUSTER_HP_NORMALIZE_BASE_SOURCE, BUSTER_HP_NORMALIZE_BASE_NORMAL, cases[index].accepted, NULL);
        free(fixture.data);
    }
    return;
}

static bool normalize_receipt_string(const char *text, const char *field, const char *value)
{
    char needle[256];
    int count = snprintf(needle, sizeof(needle), "\"%s\": \"%s\"", field, value);
    assert(count > 0 && (size_t)count < sizeof(needle));
    const char *found = strstr(text, needle);
    bool valid = found != NULL && strstr(found + (size_t)count, needle) == NULL;
    return valid;
}

static bool normalize_receipt_number(const char *text, const char *field, uint64_t value)
{
    char needle[128];
    int count = snprintf(needle, sizeof(needle), "\"%s\": %" PRIu64 ",", field, value);
    assert(count > 0 && (size_t)count < sizeof(needle));
    const char *found = strstr(text, needle);
    bool valid = found != NULL && strstr(found + (size_t)count, needle) == NULL;
    return valid;
}

static void normalize_receipt_case(NormalizeSuite *suite, const char *name, const HpNormalizationProof *proof, const char *raw_sha, const char *canonical_sha, const char *object_sha, bool expected)
{
    char *text = NULL;
    size_t size = 0;
    FILE *stream = open_memstream(&text, &size);
    assert(stream != NULL);
    HpNormalizationProof saved = *proof;
    char error[BUSTER_HP_ERROR_CAPACITY] = {0};
    bool accepted = hp_normalization_write(stream, proof, raw_sha, canonical_sha, object_sha, error);
    bool passed = accepted == expected && memcmp(&saved, proof, sizeof(saved)) == 0;
    passed = fflush(stream) == 0 && passed;
    passed = fclose(stream) == 0 && passed;
    if (accepted)
    {
        passed = passed && text != NULL && size > 2 && text[0] == '{' && text[size - 1] == '\n';
        passed = passed && normalize_receipt_string(text, "raw_assembly_sha256", raw_sha) && normalize_receipt_string(text, "canonical_assembly_sha256", canonical_sha) && normalize_receipt_string(text, "direct_object_sha256", object_sha);
        passed = passed && normalize_receipt_string(text, "source_manifest_sha256", proof->source_manifest_sha256) && normalize_receipt_string(text, "qualified_normal_sha256", proof->qualified_normal_sha256);
        passed = passed && normalize_receipt_string(text, "profile", proof->profile) && normalize_receipt_string(text, "function", BUSTER_HP_NORMALIZE_FUNCTION);
        passed = passed && normalize_receipt_string(text, "section", ".text") && normalize_receipt_string(text, "direct_preimage", "dc c0") && normalize_receipt_string(text, "canonical_directive", ".byte 0xdc, 0xc0");
        passed = passed && normalize_receipt_number(text, "edits", 1) && normalize_receipt_number(text, "assembly_line", proof->assembly_line);
        passed = passed && normalize_receipt_number(text, "assembly_line_offset", proof->assembly_line_offset) && normalize_receipt_number(text, "instruction_offset", proof->instruction_offset) && normalize_receipt_number(text, "instruction_size", proof->instruction_size);
        passed = passed && normalize_receipt_number(text, "function_label_id", proof->function_label_id) && normalize_receipt_number(text, "basic_block_id", proof->basic_block_id);
        passed = passed && normalize_receipt_number(text, "function_value", proof->function_value) && normalize_receipt_number(text, "function_size", proof->function_size);
        passed = passed && normalize_receipt_number(text, "function_site", proof->function_site) && normalize_receipt_number(text, "section_site", proof->section_site) && normalize_receipt_number(text, "object_file_site", proof->object_file_site);
        passed = passed && normalize_receipt_number(text, "call_relocation_offset", proof->call_relocation_offset) && normalize_receipt_number(text, "call_relocation_type", R_X86_64_PLT32) && strstr(text, "\"call_relocation_addend\": -4,") != NULL;
    }
    else
    {
        passed = passed && size == 0 && error[0] != 0;
    }
    normalize_record(suite, name, passed, error);
    free(text);
    return;
}

static void normalize_receipt_controls(NormalizeSuite *suite, const HpNormalizationProof *proof)
{
    const char *digests[] = {NORMALIZE_DIGEST, BUSTER_HP_NORMALIZE_BASE_SOURCE, BUSTER_HP_NORMALIZE_BASE_NORMAL};
    normalize_receipt_case(suite, "receipt-memory-stream-valid-lowercase-digests", proof, digests[0], digests[1], digests[2], true);
    char uppercase[65];
    memcpy(uppercase, NORMALIZE_DIGEST, sizeof(uppercase));
    uppercase[10] = 'A';
    char nonhex[65];
    memcpy(nonhex, NORMALIZE_DIGEST, sizeof(nonhex));
    nonhex[63] = 'g';
    char long_digest[66];
    memcpy(long_digest, NORMALIZE_DIGEST, 64);
    long_digest[64] = '0';
    long_digest[65] = 0;
    const char *invalid[] = {NULL, "", "0123456789abcdef", uppercase, nonhex, long_digest};
    const char *positions[] = {"raw", "canonical", "object"};
    for (size_t position = 0; position < NORMALIZE_ARRAY_COUNT(positions); position += 1)
    {
        for (size_t index = 0; index < NORMALIZE_ARRAY_COUNT(invalid); index += 1)
        {
            const char *values[] = {digests[0], digests[1], digests[2]};
            values[position] = invalid[index];
            char name[96];
            int count = snprintf(name, sizeof(name), "receipt-%s-invalid-digest-%zu", positions[position], index);
            assert(count > 0 && (size_t)count < sizeof(name));
            normalize_receipt_case(suite, name, proof, values[0], values[1], values[2], false);
        }
    }
    HpNormalizationProof empty = {0};
    normalize_receipt_case(suite, "receipt-empty-proof-refused", &empty, digests[0], digests[1], digests[2], false);
    return;
}

static void normalize_pair_controls(NormalizeSuite *suite)
{
    typedef struct PairCase PairCase;
    struct PairCase
    {
        const char *name;
        const char *source;
        const char *normal;
        bool accepted;
    };
    static const PairCase cases[] =
    {
        {"pair-gate-base-exact", BUSTER_HP_NORMALIZE_BASE_SOURCE, BUSTER_HP_NORMALIZE_BASE_NORMAL, true},
        {"pair-gate-candidate-exact", BUSTER_HP_NORMALIZE_CANDIDATE_SOURCE, BUSTER_HP_NORMALIZE_CANDIDATE_NORMAL, true},
        {"pair-gate-base-source-candidate-normal", BUSTER_HP_NORMALIZE_BASE_SOURCE, BUSTER_HP_NORMALIZE_CANDIDATE_NORMAL, false},
        {"pair-gate-candidate-source-base-normal", BUSTER_HP_NORMALIZE_CANDIDATE_SOURCE, BUSTER_HP_NORMALIZE_BASE_NORMAL, false},
        {"pair-gate-unknown-source", NORMALIZE_DIGEST, BUSTER_HP_NORMALIZE_BASE_NORMAL, false},
        {"pair-gate-unknown-normal", BUSTER_HP_NORMALIZE_BASE_SOURCE, NORMALIZE_DIGEST, false},
        {"pair-gate-null-source", NULL, BUSTER_HP_NORMALIZE_BASE_NORMAL, false},
        {"pair-gate-null-normal", BUSTER_HP_NORMALIZE_BASE_SOURCE, NULL, false},
        {"pair-gate-empty-source", "", BUSTER_HP_NORMALIZE_BASE_NORMAL, false},
        {"pair-gate-empty-normal", BUSTER_HP_NORMALIZE_BASE_SOURCE, "", false},
        {"pair-gate-short-source", "2c8613c36e4b0a2e", BUSTER_HP_NORMALIZE_BASE_NORMAL, false},
        {"pair-gate-short-normal", BUSTER_HP_NORMALIZE_BASE_SOURCE, "db8cbb4409be4ac4", false}
    };
    for (size_t index = 0; index < NORMALIZE_ARRAY_COUNT(cases); index += 1)
    {
        bool accepted = hp_normalize_pair_supported(cases[index].source, cases[index].normal);
        normalize_record(suite, cases[index].name, accepted == cases[index].accepted, "source/normal qualification pair mismatch");
    }
    return;
}

int main(void)
{
    NormalizeSuite suite = {0};
    normalize_pair_controls(&suite);
    HpNormalizationProof receipt_proof = {0};
    NormalizeFixture fixture;
    normalize_fixture(&fixture, NORMALIZE_BASE_VALUE);
    normalize_exercise(&suite, "base-authorized-pair-synthetic-accepted", normalize_assembly, sizeof(normalize_assembly) - 1, &fixture, fixture.size, BUSTER_HP_NORMALIZE_BASE_SOURCE, BUSTER_HP_NORMALIZE_BASE_NORMAL, true, &receipt_proof);
    normalize_exercise(&suite, "candidate-authorized-pair-independent-synthetic-guards", normalize_assembly, sizeof(normalize_assembly) - 1, &fixture, fixture.size, BUSTER_HP_NORMALIZE_CANDIDATE_SOURCE, BUSTER_HP_NORMALIZE_CANDIDATE_NORMAL, true, NULL);
    normalize_exercise(&suite, "crossed-source-normal-pair-refused", normalize_assembly, sizeof(normalize_assembly) - 1, &fixture, fixture.size, BUSTER_HP_NORMALIZE_BASE_SOURCE, BUSTER_HP_NORMALIZE_CANDIDATE_NORMAL, false, NULL);
    normalize_exercise(&suite, "unknown-source-pair-refused", normalize_assembly, sizeof(normalize_assembly) - 1, &fixture, fixture.size, NORMALIZE_DIGEST, BUSTER_HP_NORMALIZE_BASE_NORMAL, false, NULL);
    normalize_exercise(&suite, "unknown-normal-pair-refused", normalize_assembly, sizeof(normalize_assembly) - 1, &fixture, fixture.size, BUSTER_HP_NORMALIZE_BASE_SOURCE, NORMALIZE_DIGEST, false, NULL);
    normalize_exercise(&suite, "null-source-refused", normalize_assembly, sizeof(normalize_assembly) - 1, &fixture, fixture.size, NULL, BUSTER_HP_NORMALIZE_BASE_NORMAL, false, NULL);
    normalize_exercise(&suite, "null-normal-refused", normalize_assembly, sizeof(normalize_assembly) - 1, &fixture, fixture.size, BUSTER_HP_NORMALIZE_BASE_SOURCE, NULL, false, NULL);
    normalize_exercise(&suite, "empty-assembly-refused", "", 0, &fixture, fixture.size, BUSTER_HP_NORMALIZE_BASE_SOURCE, BUSTER_HP_NORMALIZE_BASE_NORMAL, false, NULL);
    normalize_exercise(&suite, "truncated-elf-header-refused", normalize_assembly, sizeof(normalize_assembly) - 1, &fixture, sizeof(Elf64_Ehdr) - 1, BUSTER_HP_NORMALIZE_BASE_SOURCE, BUSTER_HP_NORMALIZE_BASE_NORMAL, false, NULL);
    normalize_exercise(&suite, "truncated-elf-section-table-refused", normalize_assembly, sizeof(normalize_assembly) - 1, &fixture, fixture.size - 1, BUSTER_HP_NORMALIZE_BASE_SOURCE, BUSTER_HP_NORMALIZE_BASE_NORMAL, false, NULL);
    char *nul_assembly = strdup(normalize_assembly);
    assert(nul_assembly != NULL);
    nul_assembly[10] = 0;
    normalize_exercise(&suite, "embedded-nul-assembly-refused", nul_assembly, sizeof(normalize_assembly) - 1, &fixture, fixture.size, BUSTER_HP_NORMALIZE_BASE_SOURCE, BUSTER_HP_NORMALIZE_BASE_NORMAL, false, NULL);
    free(nul_assembly);
    free(fixture.data);
    normalize_fixture(&fixture, UINT64_C(0x1000));
    char *alternate = normalize_replace(normalize_assembly, ".LBB1222_33:\n", ".LBB77_8:\n");
    char *next = normalize_replace(alternate, ".Lfunc_end1222:\n", ".Lfunc_end77:\n");
    free(alternate);
    alternate = normalize_replace(next, ".Lfunc_end1222-check_test_action_constraints", ".Lfunc_end77-check_test_action_constraints");
    free(next);
    normalize_exercise(&suite, "alternate-function-value-and-decimal-labels-derived", alternate, strlen(alternate), &fixture, fixture.size, BUSTER_HP_NORMALIZE_CANDIDATE_SOURCE, BUSTER_HP_NORMALIZE_CANDIDATE_NORMAL, true, NULL);
    free(alternate);
    normalize_fault(&fixture, NORMALIZE_FAULT_SITE_PREIMAGE);
    normalize_exercise(&suite, "candidate-pair-does-not-bypass-object-guards", normalize_assembly, sizeof(normalize_assembly) - 1, &fixture, fixture.size, BUSTER_HP_NORMALIZE_CANDIDATE_SOURCE, BUSTER_HP_NORMALIZE_CANDIDATE_NORMAL, false, NULL);
    free(fixture.data);
    normalize_assembly_controls(&suite);
    normalize_object_controls(&suite);
    normalize_receipt_controls(&suite, &receipt_proof);
    printf("normalize controls: %zu/%zu passed\n", suite.count - suite.failures, suite.count);
    return suite.failures == 0 ? EXIT_SUCCESS : EXIT_FAILURE;
}
