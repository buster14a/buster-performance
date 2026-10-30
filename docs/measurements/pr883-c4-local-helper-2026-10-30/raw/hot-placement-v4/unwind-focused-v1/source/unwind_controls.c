// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin.
// Focused first-party in-memory unwind-section object controls. Reuse only
// byte constructors from the existing suite; its renamed main is not called.
// The opaque synthetic unwind bytes test structural preservation, not CFI
// interpretation or runtime unwinding. No subprocess or real object is used.
#define main buster_hp_original_elf_control_main
#include "elf_controls.c"
#undef main

typedef enum UnwindTarget
{
    BUSTER_UNWIND_HOT_SECTION,
    BUSTER_UNWIND_HOT_FUNCTION,
    BUSTER_UNWIND_ORDINARY_FUNCTION
} UnwindTarget;

typedef enum UnwindFault
{
    BUSTER_UNWIND_NO_FAULT,
    BUSTER_UNWIND_UNKNOWN_TYPE,
    BUSTER_UNWIND_WRONG_NAME,
    BUSTER_UNWIND_NO_ALLOC,
    BUSTER_UNWIND_WRITABLE,
    BUSTER_UNWIND_EXECUTABLE,
    BUSTER_UNWIND_MERGE,
    BUSTER_UNWIND_ALIGNMENT_ONE,
    BUSTER_UNWIND_ALIGNMENT_FOUR,
    BUSTER_UNWIND_ENTRY_SIZE,
    BUSTER_UNWIND_LINK,
    BUSTER_UNWIND_INFO,
    BUSTER_UNWIND_NOBITS,
    BUSTER_UNWIND_PROGBITS_BOTH,
    BUSTER_UNWIND_PROGBITS_CHANGE,
    BUSTER_UNWIND_FIELD_EXACT_END,
    BUSTER_UNWIND_FIELD_OVERRUN,
    BUSTER_UNWIND_FIELD_OVERFLOW,
    BUSTER_UNWIND_FIELD_OVERLAP,
    BUSTER_UNWIND_FIELD_CHANGE,
    BUSTER_UNWIND_UNKNOWN_RELOCATION,
    BUSTER_UNWIND_GOT_RELOCATION,
    BUSTER_UNWIND_PLT32_NONEXEC,
    BUSTER_UNWIND_RELOCATION_TYPE_CHANGE,
    BUSTER_UNWIND_HOT_ADDEND_CHANGE,
    BUSTER_UNWIND_HOT_ADDEND_BEFORE,
    BUSTER_UNWIND_HOT_ADDEND_AFTER,
    BUSTER_UNWIND_HOT_ADDEND_UNDERFLOW,
    BUSTER_UNWIND_ORDINARY_ADDEND_CHANGE,
    BUSTER_UNWIND_ORDINARY_TARGET_CHANGE,
    BUSTER_UNWIND_RAW_BYTE_CHANGE,
    BUSTER_UNWIND_RELOCATION_BYTE_CHANGE,
    BUSTER_UNWIND_SIZE_CHANGE,
    BUSTER_UNWIND_ORDINARY_BYTE_CHANGE
} UnwindFault;

typedef struct UnwindSuite UnwindSuite;
struct UnwindSuite
{
    size_t cases;
    size_t failures;
};

static void unwind_record(UnwindSuite *suite, const char *name, bool passed, const char *detail)
{
    suite->cases += 1;
    suite->failures += !passed;
    printf("%s %s%s%s\n", passed ? "PASS" : "FAIL", name, !passed ? ": " : "", !passed ? detail : "");
    return;
}

static void unwind_rename_section(ControlFixture *fixture, ControlSection id, const char *name)
{
    // Append a new complete string table after the original file. Old names
    // keep their exact offsets; old unclaimed bytes are not parsed as sections.
    Elf64_Shdr strings = control_section(fixture, BUSTER_SECTION_SHSTRTAB);
    assert(strings.sh_offset <= fixture->bytes.size && strings.sh_size <= fixture->bytes.size - strings.sh_offset);
    assert(strings.sh_size <= UINT32_MAX && strlen(name) + 1 <= UINT32_MAX - strings.sh_size);
    size_t start = fixture->bytes.size;
    control_append(&fixture->bytes, fixture->bytes.data + strings.sh_offset, (size_t)strings.sh_size);
    control_append(&fixture->bytes, name, strlen(name) + 1);
    Elf64_Shdr section = control_section(fixture, id);
    section.sh_name = (Elf64_Word)strings.sh_size;
    strings.sh_offset = start;
    strings.sh_size += strlen(name) + 1;
    control_set_section(fixture, BUSTER_SECTION_SHSTRTAB, strings);
    control_set_section(fixture, id, section);
    return;
}

static void unwind_prepare(ControlFixture *fixture, uint64_t shift, UnwindTarget target)
{
    control_fixture(fixture, control_options(shift, BUSTER_FAULT_NONE));
    unwind_rename_section(fixture, BUSTER_SECTION_DATA, ".eh_frame");
    Elf64_Shdr unwind = control_section(fixture, BUSTER_SECTION_DATA);
    unwind.sh_type = SHT_X86_64_UNWIND;
    unwind.sh_flags = SHF_ALLOC;
    unwind.sh_addralign = 8;
    unwind.sh_entsize = 0;
    unwind.sh_link = 0;
    unwind.sh_info = 0;
    control_set_section(fixture, BUSTER_SECTION_DATA, unwind);

    unwind_rename_section(fixture, BUSTER_SECTION_BSS, ".text");
    Elf64_Shdr ordinary = control_section(fixture, BUSTER_SECTION_BSS);
    ordinary.sh_type = SHT_PROGBITS;
    ordinary.sh_flags = SHF_ALLOC | SHF_EXECINSTR;
    control_align(&fixture->bytes, 8);
    ordinary.sh_offset = fixture->bytes.size;
    unsigned char ordinary_bytes[8];
    memset(ordinary_bytes, 0x90, sizeof(ordinary_bytes));
    control_append(&fixture->bytes, ordinary_bytes, sizeof(ordinary_bytes));
    ordinary.sh_size = sizeof(ordinary_bytes);
    control_set_section(fixture, BUSTER_SECTION_BSS, ordinary);
    Elf64_Sym ordinary_symbol = control_symbol(fixture, BUSTER_SYMBOL_DATA);
    ordinary_symbol.st_info = ELF64_ST_INFO(STB_GLOBAL, STT_FUNC);
    ordinary_symbol.st_shndx = (Elf64_Section)fixture->section_index[BUSTER_SECTION_BSS];
    ordinary_symbol.st_size = sizeof(ordinary_bytes);
    control_set_symbol(fixture, BUSTER_SYMBOL_DATA, ordinary_symbol);

    ControlSymbol first_target = target == BUSTER_UNWIND_HOT_SECTION ? BUSTER_SYMBOL_SECTION : target == BUSTER_UNWIND_HOT_FUNCTION ? BUSTER_SYMBOL_FOO : BUSTER_SYMBOL_DATA;
    int64_t first_addend = target == BUSTER_UNWIND_HOT_SECTION ? (int64_t)shift - 4 : -4;
    Elf64_Rela first = control_make_relocation(fixture, 0, R_X86_64_PC32, first_target, first_addend);
    Elf64_Rela second = control_make_relocation(fixture, 8, R_X86_64_PC32, BUSTER_SYMBOL_DATA, -4);
    control_set_relocation(fixture, BUSTER_SECTION_RELA_DATA, 0, first);
    control_set_relocation(fixture, BUSTER_SECTION_RELA_DATA, 1, second);
    return;
}

static void unwind_both_profile(ControlFixture *base, ControlFixture *variant, UnwindFault fault)
{
    ControlFixture *fixtures[] = {base, variant};
    for (size_t i = 0; i < BUSTER_ARRAY_COUNT(fixtures); i += 1)
    {
        ControlFixture *fixture = fixtures[i];
        Elf64_Shdr section = control_section(fixture, BUSTER_SECTION_DATA);
        switch (fault)
        {
            case BUSTER_UNWIND_UNKNOWN_TYPE:
            {
                section.sh_type = SHT_X86_64_UNWIND + 1;
            } break;
            case BUSTER_UNWIND_WRONG_NAME:
            {
                unwind_rename_section(fixture, BUSTER_SECTION_DATA, ".not_frame");
                section = control_section(fixture, BUSTER_SECTION_DATA);
            } break;
            case BUSTER_UNWIND_NO_ALLOC: case BUSTER_UNWIND_WRITABLE: case BUSTER_UNWIND_EXECUTABLE: case BUSTER_UNWIND_MERGE:
            {
                section.sh_flags = fault == BUSTER_UNWIND_NO_ALLOC ? 0 : SHF_ALLOC | (fault == BUSTER_UNWIND_WRITABLE ? SHF_WRITE : fault == BUSTER_UNWIND_EXECUTABLE ? SHF_EXECINSTR : SHF_MERGE);
            } break;
            case BUSTER_UNWIND_ALIGNMENT_ONE: case BUSTER_UNWIND_ALIGNMENT_FOUR:
            {
                section.sh_addralign = fault == BUSTER_UNWIND_ALIGNMENT_ONE ? 1 : 4;
            } break;
            case BUSTER_UNWIND_ENTRY_SIZE:
            {
                section.sh_entsize = 1;
            } break;
            case BUSTER_UNWIND_LINK:
            {
                section.sh_link = (Elf64_Word)fixture->section_index[BUSTER_SECTION_SYMTAB];
            } break;
            case BUSTER_UNWIND_INFO:
            {
                section.sh_info = 1;
            } break;
            case BUSTER_UNWIND_NOBITS:
            {
                section.sh_type = SHT_NOBITS;
            } break;
            case BUSTER_UNWIND_PROGBITS_BOTH:
            {
                section.sh_type = SHT_PROGBITS;
            } break;
            default:
            {
                assert(false);
            } break;
        }
        control_set_section(fixture, BUSTER_SECTION_DATA, section);
    }
    return;
}

static void unwind_fault(ControlFixture *base, ControlFixture *variant, uint64_t shift, UnwindFault fault)
{
    Elf64_Rela first = control_relocation(variant, BUSTER_SECTION_RELA_DATA, 0);
    Elf64_Rela second = control_relocation(variant, BUSTER_SECTION_RELA_DATA, 1);
    Elf64_Shdr section = control_section(variant, BUSTER_SECTION_DATA);
    bool replace_first = false;
    bool replace_second = false;
    switch (fault)
    {
        case BUSTER_UNWIND_NO_FAULT:
        {
        } break;
        case BUSTER_UNWIND_UNKNOWN_TYPE: case BUSTER_UNWIND_WRONG_NAME: case BUSTER_UNWIND_NO_ALLOC: case BUSTER_UNWIND_WRITABLE: case BUSTER_UNWIND_EXECUTABLE: case BUSTER_UNWIND_MERGE: case BUSTER_UNWIND_ALIGNMENT_ONE: case BUSTER_UNWIND_ALIGNMENT_FOUR: case BUSTER_UNWIND_ENTRY_SIZE: case BUSTER_UNWIND_LINK: case BUSTER_UNWIND_INFO: case BUSTER_UNWIND_NOBITS: case BUSTER_UNWIND_PROGBITS_BOTH:
        {
            unwind_both_profile(base, variant, fault);
        } break;
        case BUSTER_UNWIND_PROGBITS_CHANGE:
        {
            section.sh_type = SHT_PROGBITS;
            control_set_section(variant, BUSTER_SECTION_DATA, section);
        } break;
        case BUSTER_UNWIND_FIELD_EXACT_END:
        {
            Elf64_Rela base_first = control_relocation(base, BUSTER_SECTION_RELA_DATA, 0);
            base_first.r_offset = 12;
            control_set_relocation(base, BUSTER_SECTION_RELA_DATA, 0, base_first);
            first.r_offset = 12;
            replace_first = true;
        } break;
        case BUSTER_UNWIND_FIELD_OVERRUN: case BUSTER_UNWIND_FIELD_OVERFLOW: case BUSTER_UNWIND_FIELD_OVERLAP: case BUSTER_UNWIND_FIELD_CHANGE:
        {
            first.r_offset = fault == BUSTER_UNWIND_FIELD_OVERRUN ? 13 : fault == BUSTER_UNWIND_FIELD_OVERFLOW ? UINT64_MAX : fault == BUSTER_UNWIND_FIELD_OVERLAP ? 7 : 4;
            replace_first = true;
        } break;
        case BUSTER_UNWIND_UNKNOWN_RELOCATION: case BUSTER_UNWIND_GOT_RELOCATION: case BUSTER_UNWIND_PLT32_NONEXEC:
        {
            uint32_t type = fault == BUSTER_UNWIND_UNKNOWN_RELOCATION ? 43 : fault == BUSTER_UNWIND_GOT_RELOCATION ? R_X86_64_GOTPCREL : R_X86_64_PLT32;
            Elf64_Rela base_first = control_relocation(base, BUSTER_SECTION_RELA_DATA, 0);
            base_first.r_info = ELF64_R_INFO(ELF64_R_SYM(base_first.r_info), type);
            control_set_relocation(base, BUSTER_SECTION_RELA_DATA, 0, base_first);
            first.r_info = ELF64_R_INFO(ELF64_R_SYM(first.r_info), type);
            replace_first = true;
        } break;
        case BUSTER_UNWIND_RELOCATION_TYPE_CHANGE:
        {
            first.r_info = ELF64_R_INFO(ELF64_R_SYM(first.r_info), R_X86_64_PC64);
            replace_first = true;
        } break;
        case BUSTER_UNWIND_HOT_ADDEND_CHANGE: case BUSTER_UNWIND_HOT_ADDEND_BEFORE: case BUSTER_UNWIND_HOT_ADDEND_AFTER: case BUSTER_UNWIND_HOT_ADDEND_UNDERFLOW:
        {
            if (fault == BUSTER_UNWIND_HOT_ADDEND_BEFORE || fault == BUSTER_UNWIND_HOT_ADDEND_AFTER)
            {
                int64_t addend = fault == BUSTER_UNWIND_HOT_ADDEND_BEFORE ? -5 : 33;
                Elf64_Rela base_first = control_relocation(base, BUSTER_SECTION_RELA_DATA, 0);
                base_first.r_addend = addend;
                control_set_relocation(base, BUSTER_SECTION_RELA_DATA, 0, base_first);
                first.r_addend = (int64_t)shift + addend;
            }
            else
            {
                first.r_addend = fault == BUSTER_UNWIND_HOT_ADDEND_CHANGE ? (int64_t)shift - 3 : INT64_MIN;
            }
            replace_first = true;
        } break;
        case BUSTER_UNWIND_ORDINARY_ADDEND_CHANGE:
        {
            second.r_addend = -3;
            replace_second = true;
        } break;
        case BUSTER_UNWIND_ORDINARY_TARGET_CHANGE:
        {
            second.r_info = ELF64_R_INFO(variant->symbol_index[BUSTER_SYMBOL_FOO], R_X86_64_PC32);
            replace_second = true;
        } break;
        case BUSTER_UNWIND_RAW_BYTE_CHANGE: case BUSTER_UNWIND_RELOCATION_BYTE_CHANGE:
        {
            size_t relative = fault == BUSTER_UNWIND_RAW_BYTE_CHANGE ? 15 : 0;
            assert(relative < section.sh_size);
            variant->bytes.data[(size_t)section.sh_offset + relative] ^= 1;
        } break;
        case BUSTER_UNWIND_SIZE_CHANGE:
        {
            section.sh_size -= 1;
            control_set_section(variant, BUSTER_SECTION_DATA, section);
        } break;
        case BUSTER_UNWIND_ORDINARY_BYTE_CHANGE:
        {
            Elf64_Shdr ordinary = control_section(variant, BUSTER_SECTION_BSS);
            variant->bytes.data[(size_t)ordinary.sh_offset] ^= 1;
        } break;
    }
    if (replace_first)
    {
        control_set_relocation(variant, BUSTER_SECTION_RELA_DATA, 0, first);
    }
    if (replace_second)
    {
        control_set_relocation(variant, BUSTER_SECTION_RELA_DATA, 1, second);
    }
    return;
}

static bool unwind_empty_proof(const HpObjectProof *proof)
{
    bool empty = proof->disclosures == NULL && proof->disclosure_count == 0 && proof->shift == 0 && proof->hot_bytes_before == 0 && proof->hot_alignment == 0 && proof->symbols_compared == 0 && proof->relocations_compared == 0;
    return empty;
}

static void unwind_pair(UnwindSuite *suite, const char *name, uint64_t shift, UnwindTarget target, UnwindFault fault, bool expected, const char *diagnostic)
{
    ControlFixture base;
    ControlFixture variant;
    unwind_prepare(&base, 0, target);
    unwind_prepare(&variant, shift, target);
    unwind_fault(&base, &variant, shift, fault);
    HpElf left = {0};
    HpElf right = {0};
    HpObjectProof proof = {0};
    HpBytes base_bytes = {base.bytes.data, base.bytes.size};
    HpBytes variant_bytes = {variant.bytes.data, variant.bytes.size};
    char error[BUSTER_HP_ERROR_CAPACITY] = {0};
    bool parsed = hp_elf_read(base_bytes, &left, error) && hp_elf_read(variant_bytes, &right, error);
    bool accepted = parsed && hp_elf_compare_objects(&left, &right, BUSTER_CONTROL_HOT, shift, &proof, error);
    bool passed = parsed && accepted == expected;
    if (expected)
    {
        const HpSection *unwind = hp_elf_section_named(&left, ".eh_frame");
        const HpSection *ordinary = hp_elf_section_named(&left, ".text");
        passed = passed && error[0] == 0 && unwind != NULL && ordinary != NULL && unwind->bytes.size == 16 && ordinary->bytes.size == 8 && proof.shift == shift && proof.hot_bytes_before == 32 && proof.hot_alignment == 4096 && proof.symbols_compared == 5 && proof.relocations_compared == 3;
    }
    else
    {
        passed = passed && error[0] != 0 && unwind_empty_proof(&proof) && (diagnostic == NULL || strstr(error, diagnostic) != NULL);
    }
    unwind_record(suite, name, passed, error[0] != 0 ? error : "unexpected acceptance or proof metadata");
    hp_object_proof_free(&proof);
    hp_elf_free(&left);
    hp_elf_free(&right);
    return;
}

static void unwind_positive_controls(UnwindSuite *suite)
{
    static const uint64_t shifts[] = {0, 16, 64, 256, 1024, 2048};
    for (size_t i = 0; i < BUSTER_ARRAY_COUNT(shifts); i += 1)
    {
        char name[128];
        snprintf(name, sizeof(name), "UNWIND PC32 hot-section and ordinary-function shift %" PRIu64, shifts[i]);
        unwind_pair(suite, name, shifts[i], BUSTER_UNWIND_HOT_SECTION, BUSTER_UNWIND_NO_FAULT, true, NULL);
        snprintf(name, sizeof(name), "UNWIND PC32 named hot and ordinary functions shift %" PRIu64, shifts[i]);
        unwind_pair(suite, name, shifts[i], BUSTER_UNWIND_HOT_FUNCTION, BUSTER_UNWIND_NO_FAULT, true, NULL);
        snprintf(name, sizeof(name), "UNWIND PC32 ordinary-only references shift %" PRIu64, shifts[i]);
        unwind_pair(suite, name, shifts[i], BUSTER_UNWIND_ORDINARY_FUNCTION, BUSTER_UNWIND_NO_FAULT, true, NULL);
    }
    unwind_pair(suite, "existing PROGBITS .eh_frame support is retained", 16, BUSTER_UNWIND_HOT_SECTION, BUSTER_UNWIND_PROGBITS_BOTH, true, NULL);
    unwind_pair(suite, "UNWIND field ending exactly at section end is valid", 16, BUSTER_UNWIND_HOT_SECTION, BUSTER_UNWIND_FIELD_EXACT_END, true, NULL);
    return;
}

static void unwind_negative_controls(UnwindSuite *suite)
{
    static const struct
    {
        const char *name;
        UnwindFault fault;
        const char *diagnostic;
    } cases[] =
    {
        {"unknown processor section type remains refused", BUSTER_UNWIND_UNKNOWN_TYPE, "field outside"},
        {"UNWIND type under another name is refused", BUSTER_UNWIND_WRONG_NAME, "field outside"},
        {"UNWIND without ALLOC is refused", BUSTER_UNWIND_NO_ALLOC, "field outside"},
        {"writable UNWIND profile is refused", BUSTER_UNWIND_WRITABLE, "field outside"},
        {"executable UNWIND profile is refused", BUSTER_UNWIND_EXECUTABLE, "field outside"},
        {"merged UNWIND profile is refused", BUSTER_UNWIND_MERGE, "field outside"},
        {"UNWIND alignment one is refused", BUSTER_UNWIND_ALIGNMENT_ONE, "field outside"},
        {"UNWIND alignment four is refused", BUSTER_UNWIND_ALIGNMENT_FOUR, "field outside"},
        {"UNWIND nonzero entry size is refused", BUSTER_UNWIND_ENTRY_SIZE, "field outside"},
        {"UNWIND nonzero link is refused", BUSTER_UNWIND_LINK, "unmodeled linked section metadata"},
        {"UNWIND nonzero info is refused", BUSTER_UNWIND_INFO, "field outside"},
        {"UNWIND does not admit NOBITS relocation content", BUSTER_UNWIND_NOBITS, "field outside"},
        {"UNWIND-to-PROGBITS type change is still checked", BUSTER_UNWIND_PROGBITS_CHANGE, "section attributes changed"},
        {"UNWIND relocation field overrun is refused", BUSTER_UNWIND_FIELD_OVERRUN, "field outside"},
        {"UNWIND relocation UINT64 offset overflow is refused", BUSTER_UNWIND_FIELD_OVERFLOW, "field outside"},
        {"UNWIND overlapping relocation fields are refused", BUSTER_UNWIND_FIELD_OVERLAP, "overlapping relocation fields"},
        {"UNWIND changed field location is refused", BUSTER_UNWIND_FIELD_CHANGE, "normalized relocations changed"},
        {"UNWIND does not admit unknown relocation type", BUSTER_UNWIND_UNKNOWN_RELOCATION, "unsupported relocation type"},
        {"UNWIND does not admit GOT hot-section reference", BUSTER_UNWIND_GOT_RELOCATION, "non-direct"},
        {"UNWIND does not admit nonexec PLT32 hot-section reference", BUSTER_UNWIND_PLT32_NONEXEC, "non-executable PLT32"},
        {"UNWIND relocation type mutation is refused", BUSTER_UNWIND_RELOCATION_TYPE_CHANGE, "normalized relocations changed"},
        {"UNWIND translated hot addend mutation is refused", BUSTER_UNWIND_HOT_ADDEND_CHANGE, "normalized relocations changed"},
        {"UNWIND hot addend below PC bias is refused", BUSTER_UNWIND_HOT_ADDEND_BEFORE, "outside bounded direct target"},
        {"UNWIND hot addend beyond bound is refused", BUSTER_UNWIND_HOT_ADDEND_AFTER, "outside bounded direct target"},
        {"UNWIND normalized hot addend underflow is refused", BUSTER_UNWIND_HOT_ADDEND_UNDERFLOW, "addend underflow"},
        {"UNWIND ordinary addend mutation is refused", BUSTER_UNWIND_ORDINARY_ADDEND_CHANGE, "normalized relocations changed"},
        {"UNWIND ordinary target mutation is refused", BUSTER_UNWIND_ORDINARY_TARGET_CHANGE, "normalized relocations changed"},
        {"UNWIND raw non-field byte mutation is refused", BUSTER_UNWIND_RAW_BYTE_CHANGE, "section bytes or size changed"},
        {"UNWIND raw relocation-field byte mutation is refused", BUSTER_UNWIND_RELOCATION_BYTE_CHANGE, "section bytes or size changed"},
        {"UNWIND size mutation is refused", BUSTER_UNWIND_SIZE_CHANGE, "section bytes or size changed"},
        {"ordinary section bytes remain checked", BUSTER_UNWIND_ORDINARY_BYTE_CHANGE, "section bytes or size changed"}
    };
    for (size_t i = 0; i < BUSTER_ARRAY_COUNT(cases); i += 1)
    {
        unwind_pair(suite, cases[i].name, 16, BUSTER_UNWIND_HOT_SECTION, cases[i].fault, false, cases[i].diagnostic);
    }
    return;
}

int main(void)
{
    const uint16_t endian = 1;
    UnwindSuite suite = {0};
    bool little = *(const unsigned char *)&endian == 1;
    unwind_record(&suite, "synthetic ELF fixture host byte order", little, "fixtures require little-endian host");
    if (little)
    {
        unwind_positive_controls(&suite);
        unwind_negative_controls(&suite);
    }
    printf("Focused synthetic C UNWIND controls: %zu cases, %zu failures; no real objects, producers, assemblers, images or subprocesses executed.\n", suite.cases, suite.failures);
    int status = suite.failures == 0 ? 0 : 1;
    return status;
}
