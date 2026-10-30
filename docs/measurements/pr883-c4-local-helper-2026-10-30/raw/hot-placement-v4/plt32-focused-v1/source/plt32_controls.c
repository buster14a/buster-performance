// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin.
// Focused first-party in-memory PLT32 object-translation controls. Reuse the
// reviewed ELF byte constructors; the renamed original suite is never called.
// No producer, assembler, real object, image, subprocess or timing is involved.
#define main buster_hp_original_elf_control_main
#include "elf_controls.c"
#undef main

typedef enum Plt32Target
{
    BUSTER_PLT32_SECTION,
    BUSTER_PLT32_LOCAL_FUNCTION,
    BUSTER_PLT32_GLOBAL_FUNCTION
} Plt32Target;

typedef enum Plt32Fault
{
    BUSTER_PLT32_NO_FAULT,
    BUSTER_PLT32_NONEXEC_SITE,
    BUSTER_PLT32_GOT_SECTION,
    BUSTER_PLT32_UNKNOWN_TYPE,
    BUSTER_PLT32_TLSDESC_TYPE,
    BUSTER_PLT32_RELOCATION_TYPE_CHANGE,
    BUSTER_PLT32_SYMBOL_TYPE_CHANGE,
    BUSTER_PLT32_SECTION_BINDING,
    BUSTER_PLT32_SECTION_VALUE,
    BUSTER_PLT32_SECTION_SIZE,
    BUSTER_PLT32_SECTION_ABSOLUTE,
    BUSTER_PLT32_TARGET_SECTION_CHANGE,
    BUSTER_PLT32_ADDEND_CHANGE,
    BUSTER_PLT32_ADDEND_BEFORE_FIRST,
    BUSTER_PLT32_ADDEND_AFTER_BOUND,
    BUSTER_PLT32_ADDEND_UNDERFLOW,
    BUSTER_PLT32_FIELD_PAST_END,
    BUSTER_PLT32_FIELD_OVERFLOW,
    BUSTER_PLT32_FIELD_CHANGE,
    BUSTER_PLT32_FIELD_OVERLAP,
    BUSTER_PLT32_FIELD_IN_PREFIX,
    BUSTER_PLT32_HOT_SUFFIX_CHANGE,
    BUSTER_PLT32_PREFIX_CHANGE,
    BUSTER_PLT32_NAMED_ADDEND_CHANGE,
    BUSTER_PLT32_NAMED_BINDING_CHANGE,
    BUSTER_PLT32_UNSUPPORTED_SHIFT
} Plt32Fault;

typedef struct Plt32Suite Plt32Suite;
struct Plt32Suite
{
    size_t cases;
    size_t failures;
};

static void plt32_record(Plt32Suite *suite, const char *name, bool passed, const char *detail)
{
    suite->cases += 1;
    suite->failures += !passed;
    printf("%s %s%s%s\n", passed ? "PASS" : "FAIL", name, !passed ? ": " : "", !passed ? detail : "");
    return;
}

static void plt32_site_executable(ControlFixture *fixture, bool executable)
{
    Elf64_Shdr section = control_section(fixture, BUSTER_SECTION_DATA);
    section.sh_flags = executable ? SHF_ALLOC | SHF_EXECINSTR : SHF_ALLOC | SHF_WRITE;
    control_set_section(fixture, BUSTER_SECTION_DATA, section);
    return;
}

static void plt32_global_function(ControlFixture *fixture)
{
    Elf64_Sym symbol = control_symbol(fixture, BUSTER_SYMBOL_FOO);
    symbol.st_info = ELF64_ST_INFO(STB_GLOBAL, STT_FUNC);
    control_set_symbol(fixture, BUSTER_SYMBOL_FOO, symbol);
    Elf64_Shdr table = control_section(fixture, BUSTER_SECTION_SYMTAB);
    table.sh_info = (Elf64_Word)fixture->symbol_index[BUSTER_SYMBOL_FOO];
    control_set_section(fixture, BUSTER_SECTION_SYMTAB, table);
    return;
}

static void plt32_prepare(ControlFixture *fixture, uint64_t shift, bool hot_site, Plt32Target target, bool executable)
{
    control_fixture(fixture, control_options(shift, BUSTER_FAULT_NONE));
    plt32_site_executable(fixture, executable);
    if (target == BUSTER_PLT32_GLOBAL_FUNCTION)
    {
        plt32_global_function(fixture);
    }
    ControlSymbol symbol = target == BUSTER_PLT32_SECTION ? BUSTER_SYMBOL_SECTION : BUSTER_SYMBOL_FOO;
    int64_t addend = target == BUSTER_PLT32_SECTION ? (int64_t)shift - 4 : -4;
    Elf64_Rela relocation = control_make_relocation(fixture, 0, R_X86_64_PLT32, symbol, addend);
    control_set_relocation(fixture, BUSTER_SECTION_RELA_DATA, 0, relocation);
    if (hot_site)
    {
        relocation.r_offset = shift + 8;
        control_set_relocation(fixture, BUSTER_SECTION_RELA_HOT, 0, relocation);
    }
    return;
}

static void plt32_set_type(ControlFixture *fixture, uint32_t type)
{
    Elf64_Rela relocation = control_relocation(fixture, BUSTER_SECTION_RELA_DATA, 0);
    relocation.r_info = ELF64_R_INFO(ELF64_R_SYM(relocation.r_info), type);
    control_set_relocation(fixture, BUSTER_SECTION_RELA_DATA, 0, relocation);
    return;
}

static void plt32_set_addend(ControlFixture *fixture, int64_t addend)
{
    Elf64_Rela relocation = control_relocation(fixture, BUSTER_SECTION_RELA_DATA, 0);
    relocation.r_addend = addend;
    control_set_relocation(fixture, BUSTER_SECTION_RELA_DATA, 0, relocation);
    return;
}

static void plt32_fault(ControlFixture *base, ControlFixture *variant, uint64_t shift, Plt32Fault fault)
{
    Elf64_Sym left_symbol = control_symbol(base, BUSTER_SYMBOL_SECTION);
    Elf64_Sym right_symbol = control_symbol(variant, BUSTER_SYMBOL_SECTION);
    Elf64_Rela relocation = control_relocation(variant, BUSTER_SECTION_RELA_DATA, 0);
    bool replace_symbols = false;
    switch (fault)
    {
        case BUSTER_PLT32_NO_FAULT: case BUSTER_PLT32_UNSUPPORTED_SHIFT:
        {
        } break;
        case BUSTER_PLT32_NONEXEC_SITE:
        {
            plt32_site_executable(base, false);
            plt32_site_executable(variant, false);
        } break;
        case BUSTER_PLT32_GOT_SECTION: case BUSTER_PLT32_UNKNOWN_TYPE: case BUSTER_PLT32_TLSDESC_TYPE:
        {
            uint32_t type = fault == BUSTER_PLT32_GOT_SECTION ? R_X86_64_GOTPCREL : fault == BUSTER_PLT32_UNKNOWN_TYPE ? 43 : R_X86_64_TLSDESC_CALL;
            plt32_set_type(base, type);
            plt32_set_type(variant, type);
        } break;
        case BUSTER_PLT32_RELOCATION_TYPE_CHANGE:
        {
            plt32_set_type(variant, R_X86_64_PC32);
        } break;
        case BUSTER_PLT32_SYMBOL_TYPE_CHANGE:
        {
            right_symbol.st_info = ELF64_ST_INFO(STB_LOCAL, STT_OBJECT);
            right_symbol.st_value = shift;
            replace_symbols = true;
        } break;
        case BUSTER_PLT32_SECTION_BINDING:
        {
            plt32_global_function(base);
            plt32_global_function(variant);
            left_symbol.st_info = ELF64_ST_INFO(STB_GLOBAL, STT_SECTION);
            right_symbol.st_info = ELF64_ST_INFO(STB_GLOBAL, STT_SECTION);
            Elf64_Shdr left_table = control_section(base, BUSTER_SECTION_SYMTAB);
            Elf64_Shdr right_table = control_section(variant, BUSTER_SECTION_SYMTAB);
            left_table.sh_info = (Elf64_Word)base->symbol_index[BUSTER_SYMBOL_SECTION];
            right_table.sh_info = (Elf64_Word)variant->symbol_index[BUSTER_SYMBOL_SECTION];
            control_set_section(base, BUSTER_SECTION_SYMTAB, left_table);
            control_set_section(variant, BUSTER_SECTION_SYMTAB, right_table);
            replace_symbols = true;
        } break;
        case BUSTER_PLT32_SECTION_VALUE: case BUSTER_PLT32_SECTION_SIZE: case BUSTER_PLT32_SECTION_ABSOLUTE:
        {
            if (fault == BUSTER_PLT32_SECTION_VALUE)
            {
                left_symbol.st_value = 1;
                right_symbol.st_value = 1;
            }
            else if (fault == BUSTER_PLT32_SECTION_SIZE)
            {
                left_symbol.st_size = 1;
                right_symbol.st_size = 1;
            }
            else
            {
                left_symbol.st_shndx = SHN_ABS;
                right_symbol.st_shndx = SHN_ABS;
            }
            replace_symbols = true;
        } break;
        case BUSTER_PLT32_TARGET_SECTION_CHANGE:
        {
            right_symbol.st_shndx = (Elf64_Section)variant->section_index[BUSTER_SECTION_DATA];
            replace_symbols = true;
        } break;
        case BUSTER_PLT32_ADDEND_CHANGE:
        {
            plt32_set_addend(variant, (int64_t)shift - 3);
        } break;
        case BUSTER_PLT32_ADDEND_BEFORE_FIRST:
        {
            plt32_set_addend(base, -5);
            plt32_set_addend(variant, (int64_t)shift - 5);
        } break;
        case BUSTER_PLT32_ADDEND_AFTER_BOUND:
        {
            plt32_set_addend(base, 33);
            plt32_set_addend(variant, (int64_t)shift + 33);
        } break;
        case BUSTER_PLT32_ADDEND_UNDERFLOW:
        {
            plt32_set_addend(variant, INT64_MIN);
        } break;
        case BUSTER_PLT32_FIELD_PAST_END:
        {
            relocation.r_offset = 13;
            control_set_relocation(variant, BUSTER_SECTION_RELA_DATA, 0, relocation);
        } break;
        case BUSTER_PLT32_FIELD_OVERFLOW:
        {
            relocation.r_offset = UINT64_MAX;
            control_set_relocation(variant, BUSTER_SECTION_RELA_DATA, 0, relocation);
        } break;
        case BUSTER_PLT32_FIELD_CHANGE:
        {
            relocation.r_offset = 4;
            control_set_relocation(variant, BUSTER_SECTION_RELA_DATA, 0, relocation);
        } break;
        case BUSTER_PLT32_FIELD_OVERLAP:
        {
            relocation.r_offset = 7;
            control_set_relocation(variant, BUSTER_SECTION_RELA_DATA, 0, relocation);
        } break;
        case BUSTER_PLT32_FIELD_IN_PREFIX:
        {
            assert(shift != 0);
            relocation = control_make_relocation(variant, shift - 1, R_X86_64_PLT32, BUSTER_SYMBOL_SECTION, (int64_t)shift - 4);
            control_set_relocation(variant, BUSTER_SECTION_RELA_HOT, 0, relocation);
        } break;
        case BUSTER_PLT32_HOT_SUFFIX_CHANGE: case BUSTER_PLT32_PREFIX_CHANGE:
        {
            Elf64_Shdr hot = control_section(variant, BUSTER_SECTION_HOT);
            assert(fault != BUSTER_PLT32_PREFIX_CHANGE || shift != 0);
            size_t at = (size_t)hot.sh_offset + (fault == BUSTER_PLT32_PREFIX_CHANGE ? 0 : (size_t)shift);
            variant->bytes.data[at] ^= 1;
        } break;
        case BUSTER_PLT32_NAMED_ADDEND_CHANGE:
        {
            plt32_set_addend(variant, -3);
        } break;
        case BUSTER_PLT32_NAMED_BINDING_CHANGE:
        {
            plt32_global_function(variant);
        } break;
    }
    if (replace_symbols)
    {
        control_set_symbol(base, BUSTER_SYMBOL_SECTION, left_symbol);
        control_set_symbol(variant, BUSTER_SYMBOL_SECTION, right_symbol);
    }
    return;
}

static bool plt32_empty_proof(const HpObjectProof *proof)
{
    bool empty = proof->disclosures == NULL && proof->disclosure_count == 0 && proof->shift == 0 && proof->hot_bytes_before == 0 && proof->hot_alignment == 0 && proof->symbols_compared == 0 && proof->relocations_compared == 0;
    return empty;
}

static void plt32_pair(Plt32Suite *suite, const char *name, uint64_t shift, bool hot_site, Plt32Target target, bool executable, Plt32Fault fault, bool expected, const char *diagnostic)
{
    ControlFixture base;
    ControlFixture variant;
    plt32_prepare(&base, 0, hot_site, target, executable);
    plt32_prepare(&variant, shift, hot_site, target, executable);
    plt32_fault(&base, &variant, shift, fault);
    HpElf left = {0};
    HpElf right = {0};
    HpObjectProof proof = {0};
    char error[BUSTER_HP_ERROR_CAPACITY] = {0};
    HpBytes base_bytes = {base.bytes.data, base.bytes.size};
    HpBytes variant_bytes = {variant.bytes.data, variant.bytes.size};
    bool parsed = hp_elf_read(base_bytes, &left, error) && hp_elf_read(variant_bytes, &right, error);
    uint64_t compared_shift = fault == BUSTER_PLT32_UNSUPPORTED_SHIFT ? (UINT64_C(1) << 30) + UINT64_C(1) : shift;
    bool accepted = parsed && hp_elf_compare_objects(&left, &right, BUSTER_CONTROL_HOT, compared_shift, &proof, error);
    bool passed = parsed && accepted == expected;
    if (expected)
    {
        passed = passed && error[0] == 0 && proof.shift == shift && proof.hot_bytes_before == 32 && proof.hot_alignment == 4096 && proof.symbols_compared == 5 && proof.relocations_compared == 3;
    }
    else
    {
        passed = passed && error[0] != 0 && plt32_empty_proof(&proof) && (diagnostic == NULL || strstr(error, diagnostic) != NULL);
    }
    plt32_record(suite, name, passed, error[0] != 0 ? error : "unexpected acceptance or proof metadata");
    hp_object_proof_free(&proof);
    hp_elf_free(&left);
    hp_elf_free(&right);
    return;
}

static void plt32_positive_controls(Plt32Suite *suite)
{
    static const uint64_t shifts[] = {0, 16, 64, 256, 1024, 2048};
    for (size_t i = 0; i < BUSTER_ARRAY_COUNT(shifts); i += 1)
    {
        char name[128];
        snprintf(name, sizeof(name), "PLT32 executable auxiliary-site first-hot-byte shift %" PRIu64, shifts[i]);
        plt32_pair(suite, name, shifts[i], false, BUSTER_PLT32_SECTION, true, BUSTER_PLT32_NO_FAULT, true, NULL);
        snprintf(name, sizeof(name), "PLT32 executable hot-site field-and-first-byte shift %" PRIu64, shifts[i]);
        plt32_pair(suite, name, shifts[i], true, BUSTER_PLT32_SECTION, true, BUSTER_PLT32_NO_FAULT, true, NULL);
        snprintf(name, sizeof(name), "PLT32 local named-function retains addend shift %" PRIu64, shifts[i]);
        plt32_pair(suite, name, shifts[i], true, BUSTER_PLT32_LOCAL_FUNCTION, true, BUSTER_PLT32_NO_FAULT, true, NULL);
        snprintf(name, sizeof(name), "PLT32 global named-function retains addend shift %" PRIu64, shifts[i]);
        plt32_pair(suite, name, shifts[i], true, BUSTER_PLT32_GLOBAL_FUNCTION, true, BUSTER_PLT32_NO_FAULT, true, NULL);
    }
    plt32_pair(suite, "PLT32 named local in nonexec site remains supported", 16, false, BUSTER_PLT32_LOCAL_FUNCTION, false, BUSTER_PLT32_NO_FAULT, true, NULL);
    plt32_pair(suite, "PLT32 named global in nonexec site remains supported", 16, false, BUSTER_PLT32_GLOBAL_FUNCTION, false, BUSTER_PLT32_NO_FAULT, true, NULL);
    return;
}

static void plt32_negative_controls(Plt32Suite *suite)
{
    static const struct
    {
        const char *name;
        Plt32Fault fault;
        const char *diagnostic;
    } cases[] =
    {
        {"PLT32 hot-section target refuses nonexec site", BUSTER_PLT32_NONEXEC_SITE, "executable"},
        {"GOTPCREL hot-section target remains refused", BUSTER_PLT32_GOT_SECTION, "non-direct"},
        {"unknown relocation type remains refused", BUSTER_PLT32_UNKNOWN_TYPE, "unsupported relocation type"},
        {"TLSDESC marker remains refused", BUSTER_PLT32_TLSDESC_TYPE, "unsupported relocation type"},
        {"PLT32-to-PC32 type mismatch refuses", BUSTER_PLT32_RELOCATION_TYPE_CHANGE, "normalized relocations changed"},
        {"section-to-object symbol type mismatch refuses", BUSTER_PLT32_SYMBOL_TYPE_CHANGE, "symbol identity"},
        {"PLT32 section symbol global binding refuses", BUSTER_PLT32_SECTION_BINDING, "unsupported section symbol"},
        {"PLT32 section symbol nonzero value refuses", BUSTER_PLT32_SECTION_VALUE, "unsupported section symbol"},
        {"PLT32 section symbol nonzero size refuses", BUSTER_PLT32_SECTION_SIZE, "unsupported section symbol"},
        {"PLT32 section symbol absolute section refuses", BUSTER_PLT32_SECTION_ABSOLUTE, "unsupported section symbol"},
        {"PLT32 target section identity change refuses", BUSTER_PLT32_TARGET_SECTION_CHANGE, "symbol identity"},
        {"PLT32 translated addend mismatch refuses", BUSTER_PLT32_ADDEND_CHANGE, "normalized relocations changed"},
        {"PLT32 addend below minus-four refuses", BUSTER_PLT32_ADDEND_BEFORE_FIRST, "outside bounded direct target"},
        {"PLT32 addend above bounded target refuses", BUSTER_PLT32_ADDEND_AFTER_BOUND, "outside bounded direct target"},
        {"PLT32 normalized addend underflow refuses", BUSTER_PLT32_ADDEND_UNDERFLOW, "addend underflow"},
        {"PLT32 field extending past file-backed section refuses", BUSTER_PLT32_FIELD_PAST_END, "field outside"},
        {"PLT32 field UINT64 offset overflow refuses", BUSTER_PLT32_FIELD_OVERFLOW, "field outside"},
        {"PLT32 field offset mismatch refuses", BUSTER_PLT32_FIELD_CHANGE, "normalized relocations changed"},
        {"PLT32 field overlap refuses", BUSTER_PLT32_FIELD_OVERLAP, "overlapping relocation fields"},
        {"PLT32 field inside inserted prefix refuses", BUSTER_PLT32_FIELD_IN_PREFIX, "inserted hot prefix"},
        {"PLT32 does not excuse changed hot suffix bytes", BUSTER_PLT32_HOT_SUFFIX_CHANGE, "hot section bytes changed"},
        {"PLT32 does not excuse changed prefix bytes", BUSTER_PLT32_PREFIX_CHANGE, "nonzero inserted hot prefix"},
        {"PLT32 does not relax maximum shift", BUSTER_PLT32_UNSUPPORTED_SHIFT, "invalid shift"}
    };
    for (size_t i = 0; i < BUSTER_ARRAY_COUNT(cases); i += 1)
    {
        plt32_pair(suite, cases[i].name, 16, false, BUSTER_PLT32_SECTION, true, cases[i].fault, false, cases[i].diagnostic);
    }
    plt32_pair(suite, "named PLT32 addend remains unchanged", 16, false, BUSTER_PLT32_LOCAL_FUNCTION, true, BUSTER_PLT32_NAMED_ADDEND_CHANGE, false, "normalized relocations changed");
    plt32_pair(suite, "named PLT32 binding identity remains checked", 16, false, BUSTER_PLT32_LOCAL_FUNCTION, true, BUSTER_PLT32_NAMED_BINDING_CHANGE, false, "symbol identity");
    return;
}

int main(void)
{
    const uint16_t endian = 1;
    Plt32Suite suite = {0};
    bool little = *(const unsigned char *)&endian == 1;
    plt32_record(&suite, "synthetic ELF fixture host byte order", little, "fixtures require little-endian host");
    if (little)
    {
        plt32_record(&suite, "PLT32 width remains exactly four", hp_elf_relocation_width(R_X86_64_PLT32) == 4, "PLT32 field width changed");
        plt32_positive_controls(&suite);
        plt32_negative_controls(&suite);
    }
    printf("Focused synthetic C PLT32 controls: %zu cases, %zu failures; no real objects, producers, assemblers, images or subprocesses executed.\n", suite.cases, suite.failures);
    int status = suite.failures == 0 ? 0 : 1;
    return status;
}
