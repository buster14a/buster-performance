// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin.
// Fresh in-memory first-section-header reader controls. Reuse first-party
// byte constructors only; the renamed old main is never called. These are
// synthetic ELF buffers, never actual images or instructions to execute.
#define main buster_hp_original_elf_control_main
#include "elf_controls.c"
#undef main

typedef enum NullFault
{
    BUSTER_NULL_NONE,
    BUSTER_NULL_FLAGS_ZERO,
    BUSTER_NULL_FLAGS_WRITE,
    BUSTER_NULL_FLAGS_EXEC,
    BUSTER_NULL_FLAGS_UNKNOWN,
    BUSTER_NULL_ADDRESS_ZERO,
    BUSTER_NULL_ADDRESS_CHANGED,
    BUSTER_NULL_ADDRESS_OVERFLOW,
    BUSTER_NULL_NAME,
    BUSTER_NULL_TYPE,
    BUSTER_NULL_OFFSET,
    BUSTER_NULL_SIZE,
    BUSTER_NULL_LINK,
    BUSTER_NULL_INFO,
    BUSTER_NULL_ALIGNMENT,
    BUSTER_NULL_ENTRY_SIZE,
    BUSTER_NULL_CLASS32,
    BUSTER_NULL_BIG_ENDIAN,
    BUSTER_NULL_MACHINE,
    BUSTER_NULL_CORE,
    BUSTER_NULL_EXTENDED_COUNT,
    BUSTER_NULL_RESERVED_COUNT,
    BUSTER_NULL_EXTENDED_STRINGS,
    BUSTER_NULL_OUTSIDE_STRINGS,
    BUSTER_NULL_ZERO_STRINGS,
    BUSTER_NULL_EXTENDED_PROGRAM_COUNT,
    BUSTER_NULL_HEADER_SIZE,
    BUSTER_NULL_SECTION_ENTRY_SIZE,
    BUSTER_NULL_PROGRAM_ENTRY_SIZE,
    BUSTER_NULL_SECTION_TABLE_OVERFLOW,
    BUSTER_NULL_PROGRAM_TABLE_OVERFLOW,
    BUSTER_NULL_TRUNCATED_HEADER,
    BUSTER_NULL_TRUNCATED_TABLE
} NullFault;

typedef struct NullSuite NullSuite;
struct NullSuite
{
    size_t cases;
    size_t failures;
};

static void null_record(NullSuite *suite, const char *name, bool passed, const char *detail)
{
    suite->cases += 1;
    suite->failures += !passed;
    printf("%s %s%s%s\n", passed ? "PASS" : "FAIL", name, !passed ? ": " : "", !passed ? detail : "");
    return;
}

static void null_prepare(ControlFixture *fixture, uint16_t type, bool wild)
{
    control_fixture(fixture, control_options(0, BUSTER_FAULT_NONE));
    Elf64_Ehdr header = control_header(fixture);
    header.e_type = type;
    control_set_header(fixture, header);
    if (wild)
    {
        Elf64_Shdr section = control_section(fixture, BUSTER_SECTION_NULL);
        section.sh_flags = SHF_ALLOC;
        section.sh_addr = UINT64_C(0x400000);
        control_set_section(fixture, BUSTER_SECTION_NULL, section);
    }
    return;
}

static void null_fault(ControlFixture *fixture, NullFault fault)
{
    Elf64_Ehdr header = control_header(fixture);
    Elf64_Shdr section = control_section(fixture, BUSTER_SECTION_NULL);
    switch (fault)
    {
        case BUSTER_NULL_NONE:
        {
        } break;
        case BUSTER_NULL_FLAGS_ZERO: case BUSTER_NULL_FLAGS_WRITE: case BUSTER_NULL_FLAGS_EXEC: case BUSTER_NULL_FLAGS_UNKNOWN:
        {
            section.sh_flags = fault == BUSTER_NULL_FLAGS_ZERO ? 0 : fault == BUSTER_NULL_FLAGS_WRITE ? SHF_ALLOC | SHF_WRITE : fault == BUSTER_NULL_FLAGS_EXEC ? SHF_ALLOC | SHF_EXECINSTR : UINT64_MAX;
        } break;
        case BUSTER_NULL_ADDRESS_ZERO: case BUSTER_NULL_ADDRESS_CHANGED: case BUSTER_NULL_ADDRESS_OVERFLOW:
        {
            section.sh_addr = fault == BUSTER_NULL_ADDRESS_ZERO ? 0 : fault == BUSTER_NULL_ADDRESS_CHANGED ? UINT64_C(0x400001) : UINT64_MAX;
        } break;
        case BUSTER_NULL_NAME:
        {
            section.sh_name = 1;
        } break;
        case BUSTER_NULL_TYPE:
        {
            section.sh_type = SHT_PROGBITS;
        } break;
        case BUSTER_NULL_OFFSET:
        {
            section.sh_offset = 1;
        } break;
        case BUSTER_NULL_SIZE:
        {
            section.sh_size = 1;
        } break;
        case BUSTER_NULL_LINK:
        {
            section.sh_link = 1;
        } break;
        case BUSTER_NULL_INFO:
        {
            section.sh_info = 1;
        } break;
        case BUSTER_NULL_ALIGNMENT:
        {
            section.sh_addralign = 1;
        } break;
        case BUSTER_NULL_ENTRY_SIZE:
        {
            section.sh_entsize = 1;
        } break;
        case BUSTER_NULL_CLASS32:
        {
            header.e_ident[EI_CLASS] = ELFCLASS32;
        } break;
        case BUSTER_NULL_BIG_ENDIAN:
        {
            header.e_ident[EI_DATA] = ELFDATA2MSB;
        } break;
        case BUSTER_NULL_MACHINE:
        {
            header.e_machine = EM_AARCH64;
        } break;
        case BUSTER_NULL_CORE:
        {
            header.e_type = ET_CORE;
        } break;
        case BUSTER_NULL_EXTENDED_COUNT:
        {
            header.e_shnum = 0;
            section.sh_size = fixture->section_count;
        } break;
        case BUSTER_NULL_RESERVED_COUNT:
        {
            header.e_shnum = SHN_LORESERVE;
        } break;
        case BUSTER_NULL_EXTENDED_STRINGS:
        {
            header.e_shstrndx = SHN_XINDEX;
            section.sh_link = (Elf64_Word)fixture->section_index[BUSTER_SECTION_SHSTRTAB];
        } break;
        case BUSTER_NULL_OUTSIDE_STRINGS:
        {
            header.e_shstrndx = (Elf64_Half)fixture->section_count;
        } break;
        case BUSTER_NULL_ZERO_STRINGS:
        {
            header.e_shstrndx = 0;
        } break;
        case BUSTER_NULL_EXTENDED_PROGRAM_COUNT:
        {
            header.e_phnum = PN_XNUM;
            section.sh_info = 1;
        } break;
        case BUSTER_NULL_HEADER_SIZE:
        {
            header.e_ehsize = 63;
        } break;
        case BUSTER_NULL_SECTION_ENTRY_SIZE:
        {
            header.e_shentsize = 63;
        } break;
        case BUSTER_NULL_PROGRAM_ENTRY_SIZE:
        {
            header.e_phnum = 1;
            header.e_phentsize = 55;
        } break;
        case BUSTER_NULL_SECTION_TABLE_OVERFLOW:
        {
            header.e_shoff = UINT64_MAX;
        } break;
        case BUSTER_NULL_PROGRAM_TABLE_OVERFLOW:
        {
            header.e_phoff = UINT64_MAX;
            header.e_phnum = 1;
            header.e_phentsize = 56;
        } break;
        case BUSTER_NULL_TRUNCATED_HEADER:
        {
            fixture->bytes.size = 63;
        } break;
        case BUSTER_NULL_TRUNCATED_TABLE:
        {
            fixture->bytes.size -= 1;
        } break;
    }
    control_set_header(fixture, header);
    control_set_section(fixture, BUSTER_SECTION_NULL, section);
    return;
}

static bool null_empty_reader(const HpElf *elf)
{
    static const unsigned char ident[16] = {0};
    bool zero = elf->input.data == NULL && elf->input.size == 0 && memcmp(elf->ident, ident, sizeof(ident)) == 0 && elf->elf_type == 0 && elf->machine == 0 && elf->version == 0 && elf->entry == 0 && elf->flags == 0 && elf->program_count == 0 && elf->shstr_index == 0 && elf->sections == NULL && elf->section_count == 0 && elf->symbols == NULL && elf->symbol_count == 0 && elf->relocations == NULL && elf->relocation_count == 0;
    return zero;
}

static bool null_expected_section(const HpSection *section, bool wild)
{
    bool valid = section->index == 0 && section->name.size == 0 && section->type == SHT_NULL && section->flags == (wild ? SHF_ALLOC : 0) && section->addr == (wild ? UINT64_C(0x400000) : 0) && section->offset == 0 && section->size == 0 && section->link == 0 && section->info == 0 && section->align == 0 && section->entsize == 0 && section->bytes.size == 0;
    return valid;
}

static void null_reader_case(NullSuite *suite, const char *name, uint16_t type, bool wild, NullFault fault, bool expected, const char *diagnostic)
{
    ControlFixture fixture;
    null_prepare(&fixture, type, wild);
    null_fault(&fixture, fault);
    ControlBuffer before = fixture.bytes;
    HpBytes input = {fixture.bytes.data, fixture.bytes.size};
    HpElf elf = {0};
    char error[BUSTER_HP_ERROR_CAPACITY] = {0};
    bool accepted = hp_elf_read(input, &elf, error);
    bool passed = accepted == expected && fixture.bytes.size == before.size && memcmp(fixture.bytes.data, before.data, sizeof(before.data)) == 0;
    if (expected)
    {
        passed = passed && error[0] == 0 && elf.input.data == input.data && elf.input.size == input.size && elf.elf_type == type && elf.section_count == fixture.section_count && elf.sections != NULL && null_expected_section(&elf.sections[0], wild) && elf.symbol_count == 6 && elf.relocation_count == 3;
    }
    else
    {
        passed = passed && error[0] != 0 && null_empty_reader(&elf) && (diagnostic == NULL || strstr(error, diagnostic) != NULL);
    }
    null_record(suite, name, passed, error[0] != 0 ? error : "unexpected acceptance or lost header/input metadata");
    hp_elf_free(&elf);
    return;
}

static void null_object_boundary(NullSuite *suite, const char *name, uint16_t type, bool wild)
{
    ControlFixture fixture;
    null_prepare(&fixture, type, wild);
    HpBytes input = {fixture.bytes.data, fixture.bytes.size};
    HpElf elf = {0};
    HpObjectProof proof = {0};
    char error[BUSTER_HP_ERROR_CAPACITY] = {0};
    bool read = hp_elf_read(input, &elf, error);
    bool accepted = read && hp_elf_compare_objects(&elf, &elf, BUSTER_CONTROL_HOT, 0, &proof, error);
    bool empty = proof.disclosures == NULL && proof.disclosure_count == 0 && proof.shift == 0 && proof.hot_bytes_before == 0 && proof.hot_alignment == 0 && proof.symbols_compared == 0 && proof.relocations_compared == 0;
    bool passed = read && !accepted && empty && strstr(error, "requires ET_REL") != NULL;
    null_record(suite, name, passed, error[0] != 0 ? error : "unexpected object-proof authority");
    hp_object_proof_free(&proof);
    hp_elf_free(&elf);
    return;
}

static void null_positive_controls(NullSuite *suite)
{
    null_reader_case(suite, "legacy zero NULL header REL", ET_REL, false, BUSTER_NULL_NONE, true, NULL);
    null_reader_case(suite, "legacy zero NULL header EXEC", ET_EXEC, false, BUSTER_NULL_NONE, true, NULL);
    null_reader_case(suite, "legacy zero NULL header DYN", ET_DYN, false, BUSTER_NULL_NONE, true, NULL);
    null_reader_case(suite, "exact Wild EXEC NULL flags/address preserved", ET_EXEC, true, BUSTER_NULL_NONE, true, NULL);
    null_object_boundary(suite, "zero NULL EXEC reader does not authorize object proof", ET_EXEC, false);
    null_object_boundary(suite, "zero NULL DYN reader does not authorize object proof", ET_DYN, false);
    null_object_boundary(suite, "Wild EXEC NULL reader does not authorize object proof", ET_EXEC, true);
    return;
}

static void null_negative_controls(NullSuite *suite)
{
    static const struct
    {
        const char *name;
        NullFault fault;
        const char *diagnostic;
    } cases[] =
    {
        {"Wild NULL missing ALLOC refuses", BUSTER_NULL_FLAGS_ZERO, "null section"},
        {"Wild NULL writable flags refuse", BUSTER_NULL_FLAGS_WRITE, "null section"},
        {"Wild NULL executable flags refuse", BUSTER_NULL_FLAGS_EXEC, "null section"},
        {"Wild NULL unknown flag bits refuse", BUSTER_NULL_FLAGS_UNKNOWN, "null section"},
        {"Wild NULL missing address refuses", BUSTER_NULL_ADDRESS_ZERO, "null section"},
        {"Wild NULL another address refuses", BUSTER_NULL_ADDRESS_CHANGED, "null section"},
        {"Wild NULL UINT64 address refuses", BUSTER_NULL_ADDRESS_OVERFLOW, "null section"},
        {"Wild NULL nonzero name refuses", BUSTER_NULL_NAME, "null section"},
        {"Wild NULL non-NULL type refuses", BUSTER_NULL_TYPE, "null section"},
        {"Wild NULL nonzero offset refuses", BUSTER_NULL_OFFSET, "null section"},
        {"Wild NULL nonzero size refuses", BUSTER_NULL_SIZE, "null section"},
        {"Wild NULL nonzero link refuses", BUSTER_NULL_LINK, "null section"},
        {"Wild NULL nonzero info refuses", BUSTER_NULL_INFO, "null section"},
        {"Wild NULL nonzero alignment refuses", BUSTER_NULL_ALIGNMENT, "null section"},
        {"Wild NULL nonzero entry size refuses", BUSTER_NULL_ENTRY_SIZE, "null section"},
        {"Wild NULL ELF32 refuses", BUSTER_NULL_CLASS32, "ELF64 little-endian"},
        {"Wild NULL big endian refuses", BUSTER_NULL_BIG_ENDIAN, "ELF64 little-endian"},
        {"Wild NULL non-x86 machine refuses", BUSTER_NULL_MACHINE, "x86-64 ELF"},
        {"Wild NULL ET_CORE refuses", BUSTER_NULL_CORE, "x86-64 ELF"},
        {"extended section count remains refused", BUSTER_NULL_EXTENDED_COUNT, "extended indices"},
        {"reserved section count remains refused", BUSTER_NULL_RESERVED_COUNT, "extended indices"},
        {"extended section-string index remains refused", BUSTER_NULL_EXTENDED_STRINGS, "extended indices"},
        {"outside section-string index remains refused", BUSTER_NULL_OUTSIDE_STRINGS, "extended indices"},
        {"NULL section cannot own section-name strings", BUSTER_NULL_ZERO_STRINGS, "section names are not STRTAB"},
        {"extended program count remains refused", BUSTER_NULL_EXTENDED_PROGRAM_COUNT, "extended indices"},
        {"wrong ELF header size remains refused", BUSTER_NULL_HEADER_SIZE, "extended indices"},
        {"wrong section-entry size remains refused", BUSTER_NULL_SECTION_ENTRY_SIZE, "extended indices"},
        {"wrong program-entry size remains refused", BUSTER_NULL_PROGRAM_ENTRY_SIZE, "program-header size"},
        {"UINT64 section-table offset remains refused", BUSTER_NULL_SECTION_TABLE_OVERFLOW, NULL},
        {"UINT64 program-table offset remains refused", BUSTER_NULL_PROGRAM_TABLE_OVERFLOW, NULL},
        {"truncated ELF header remains refused", BUSTER_NULL_TRUNCATED_HEADER, "short or oversized"},
        {"truncated section table remains refused", BUSTER_NULL_TRUNCATED_TABLE, NULL}
    };
    for (size_t i = 0; i < BUSTER_ARRAY_COUNT(cases); i += 1)
    {
        null_reader_case(suite, cases[i].name, ET_EXEC, true, cases[i].fault, false, cases[i].diagnostic);
    }
    null_reader_case(suite, "Wild NULL profile in REL refuses", ET_REL, true, BUSTER_NULL_NONE, false, "null section");
    null_reader_case(suite, "Wild NULL profile in DYN refuses", ET_DYN, true, BUSTER_NULL_NONE, false, "null section");
    return;
}

int main(void)
{
    const uint16_t endian = 1;
    NullSuite suite = {0};
    bool little = *(const unsigned char *)&endian == 1;
    null_record(&suite, "synthetic ELF fixture host byte order", little, "fixtures require little-endian host");
    if (little)
    {
        null_positive_controls(&suite);
        null_negative_controls(&suite);
    }
    printf("Focused synthetic C NULL-header controls: %zu cases, %zu failures; no actual artifacts, helpers, images, producers or subprocesses executed.\n", suite.cases, suite.failures);
    int status = suite.failures == 0 ? 0 : 1;
    return status;
}
