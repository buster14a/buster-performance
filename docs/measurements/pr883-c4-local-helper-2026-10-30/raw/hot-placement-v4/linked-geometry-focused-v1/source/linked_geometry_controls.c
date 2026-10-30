// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin.
// New first-party synthetic linked-ownership geometry controls. Original
// constructors are reused, but their renamed main and old suite are not run.
// Every linked input is a successful, unmodified reader output. The one
// deliberately short-file fixture is separately classified as reader refusal.
#define main buster_hp_original_linked_control_main
#include "linked_controls.c"
#undef main

#define BUSTER_GEOMETRY_SECTIONS 16U
#define BUSTER_GEOMETRY_SYMBOLS 128U

typedef struct GeometryFixture GeometryFixture;
struct GeometryFixture
{
    LinkedBuffer bytes;
    Elf64_Ehdr header;
    Elf64_Shdr sections[BUSTER_GEOMETRY_SECTIONS];
    size_t section_count;
    Elf64_Sym symbols[BUSTER_GEOMETRY_SYMBOLS];
    size_t symbol_count;
};

typedef enum GeometryFault
{
    BUSTER_GEOMETRY_NONE,
    BUSTER_GEOMETRY_MISSING_KEY,
    BUSTER_GEOMETRY_NO_ANCHOR,
    BUSTER_GEOMETRY_ONE_IMAGE_ANCHORS,
    BUSTER_GEOMETRY_BASE_ZERO,
    BUSTER_GEOMETRY_LATE_ANCHOR,
    BUSTER_GEOMETRY_WRONG_DELTA,
    BUSTER_GEOMETRY_UNDERFLOW,
    BUSTER_GEOMETRY_EXPECTED_ABSENT,
    BUSTER_GEOMETRY_EXPECTED_OFF_ONE,
    BUSTER_GEOMETRY_KEY_TYPE,
    BUSTER_GEOMETRY_KEY_BINDING,
    BUSTER_GEOMETRY_KEY_VISIBILITY,
    BUSTER_GEOMETRY_KEY_SIZE,
    BUSTER_GEOMETRY_WRONG_SECTION,
    BUSTER_GEOMETRY_SAME_VA_SECTION,
    BUSTER_GEOMETRY_SAME_VA_TABLE,
    BUSTER_GEOMETRY_DYNSYM_IGNORED,
    BUSTER_GEOMETRY_UNDEFINED,
    BUSTER_GEOMETRY_ABSOLUTE,
    BUSTER_GEOMETRY_RESERVED_COMMON,
    BUSTER_GEOMETRY_NONEXEC,
    BUSTER_GEOMETRY_NOBITS,
    BUSTER_GEOMETRY_UNSUPPORTED_SECTION,
    BUSTER_GEOMETRY_EXTENT_OVERRUN,
    BUSTER_GEOMETRY_ADDRESS_OVERFLOW,
    BUSTER_GEOMETRY_SHORT_FILE,
    BUSTER_GEOMETRY_INTERIOR,
    BUSTER_GEOMETRY_STRADDLE_BASE,
    BUSTER_GEOMETRY_PREFIX,
    BUSTER_GEOMETRY_PREDECESSOR_EXACT,
    BUSTER_GEOMETRY_PREDECESSOR_OVERLAP,
    BUSTER_GEOMETRY_SUCCESSOR_EXACT,
    BUSTER_GEOMETRY_ZERO_INTERIOR,
    BUSTER_GEOMETRY_ZERO_END,
    BUSTER_GEOMETRY_ZERO_EXTRA_END,
    BUSTER_GEOMETRY_ZERO_DUPLICATE,
    BUSTER_GEOMETRY_ZERO_MISSING,
    BUSTER_GEOMETRY_ZERO_SOLE_ANCHOR,
    BUSTER_GEOMETRY_ZERO_BASE_SOLE_ANCHOR,
    BUSTER_GEOMETRY_ZERO_OUTSIDE_AFTER,
    BUSTER_GEOMETRY_ZERO_OUTSIDE_BEFORE,
    BUSTER_GEOMETRY_LAST_BYTE,
    BUSTER_GEOMETRY_ZERO_ENDPOINT_OVERFLOW,
    BUSTER_GEOMETRY_OUTSIDE_LAST_BYTE,
    BUSTER_GEOMETRY_DIFFERENT_KEY_ALIAS,
    BUSTER_GEOMETRY_SUFFIX_BYTE,
    BUSTER_GEOMETRY_PREFIX_BYTE,
    BUSTER_GEOMETRY_SHORT_CONTRIBUTION,
    BUSTER_GEOMETRY_BAD_RELOCATION_WIDTH,
    BUSTER_GEOMETRY_RELOCATION_OVERLAP
} GeometryFault;

typedef struct GeometryCase GeometryCase;
struct GeometryCase
{
    const char *name;
    uint64_t shift;
    unsigned sides;
    size_t duplicates;
    bool same_section;
    GeometryFault fault;
    bool expected;
    bool reader_refusal;
};

typedef struct GeometrySuite GeometrySuite;
struct GeometrySuite
{
    size_t cases;
    size_t failures;
    size_t linked_cases;
    size_t reader_cases;
};

static Elf64_Shdr *geometry_section(GeometryFixture *fixture, size_t index)
{
    assert(index < fixture->section_count);
    Elf64_Shdr *section = fixture->sections + index;
    return section;
}

static void geometry_prepare(GeometryFixture *fixture, bool object, uint64_t shift, bool zero, bool zero_end)
{
    memset(fixture, 0, sizeof(*fixture));
    LinkedOptions options = {.shift = shift, .zero = zero, .zero_at_end = zero_end, .original = object || shift == 0};
    linked_fixture(object, options, &fixture->bytes);
    memcpy(&fixture->header, fixture->bytes.data, sizeof(fixture->header));
    fixture->section_count = fixture->header.e_shnum;
    assert(fixture->section_count <= BUSTER_GEOMETRY_SECTIONS);
    memcpy(fixture->sections, fixture->bytes.data + fixture->header.e_shoff, fixture->section_count * sizeof(fixture->sections[0]));
    const Elf64_Shdr *table = fixture->sections + BUSTER_LINK_SYMTAB;
    fixture->symbol_count = (size_t)table->sh_size / sizeof(Elf64_Sym);
    assert(fixture->symbol_count <= BUSTER_GEOMETRY_SYMBOLS);
    memcpy(fixture->symbols, fixture->bytes.data + table->sh_offset, (size_t)table->sh_size);
    return;
}

static const char *geometry_name(const GeometryFixture *fixture, const Elf64_Sym *symbol)
{
    const Elf64_Shdr *strings = fixture->sections + BUSTER_LINK_STRTAB;
    assert(symbol->st_name < strings->sh_size);
    const char *name = (const char *)fixture->bytes.data + strings->sh_offset + symbol->st_name;
    return name;
}

static Elf64_Sym *geometry_named(GeometryFixture *fixture, const char *name)
{
    Elf64_Sym *found = NULL;
    for (size_t i = 1; found == NULL && i < fixture->symbol_count; i += 1)
    {
        if (strcmp(geometry_name(fixture, fixture->symbols + i), name) == 0)
        {
            found = fixture->symbols + i;
        }
    }
    assert(found != NULL);
    return found;
}

static void geometry_add_symbol(GeometryFixture *fixture, Elf64_Sym symbol)
{
    assert(fixture->symbol_count < BUSTER_GEOMETRY_SYMBOLS);
    fixture->symbols[fixture->symbol_count++] = symbol;
    return;
}

static void geometry_remove_named(GeometryFixture *fixture, const char *name)
{
    size_t used = 1;
    for (size_t i = 1; i < fixture->symbol_count; i += 1)
    {
        if (strcmp(geometry_name(fixture, fixture->symbols + i), name) != 0)
        {
            fixture->symbols[used++] = fixture->symbols[i];
        }
    }
    fixture->symbol_count = used;
    return;
}

static void geometry_payload(GeometryFixture *fixture, size_t index, const void *data, size_t size)
{
    Elf64_Shdr *section = geometry_section(fixture, index);
    linked_align(&fixture->bytes, (size_t)(section->sh_addralign != 0 ? section->sh_addralign : 1));
    section->sh_offset = fixture->bytes.size;
    section->sh_size = size;
    linked_append(&fixture->bytes, data, size);
    return;
}

static void geometry_resize_hot(GeometryFixture *fixture, size_t size)
{
    const Elf64_Shdr old = *geometry_section(fixture, BUSTER_LINK_HOT);
    unsigned char bytes[8192] = {0};
    assert(size <= sizeof(bytes));
    size_t retained = old.sh_size < size ? (size_t)old.sh_size : size;
    memcpy(bytes, fixture->bytes.data + old.sh_offset, retained);
    geometry_payload(fixture, BUSTER_LINK_HOT, bytes, size);
    return;
}

static void geometry_outside(GeometryFixture *fixture, uint64_t address, size_t size)
{
    unsigned char bytes[512];
    assert(size <= sizeof(bytes));
    memset(bytes, 0xA5, size);
    Elf64_Shdr *section = geometry_section(fixture, BUSTER_LINK_OTHER);
    section->sh_type = SHT_PROGBITS;
    section->sh_flags = SHF_ALLOC | SHF_EXECINSTR;
    section->sh_addr = address;
    section->sh_addralign = 1;
    geometry_payload(fixture, BUSTER_LINK_OTHER, bytes, size);
    return;
}

static void geometry_duplicate(GeometryFixture *fixture, const char *name, uint16_t section, uint64_t value)
{
    Elf64_Sym duplicate = *geometry_named(fixture, name);
    duplicate.st_shndx = section;
    duplicate.st_value = value;
    geometry_add_symbol(fixture, duplicate);
    return;
}

static void geometry_duplicates(GeometryFixture *fixture, const char *name, size_t count, bool same_section)
{
    uint64_t end = fixture->sections[BUSTER_LINK_HOT].sh_addr + fixture->sections[BUSTER_LINK_HOT].sh_size;
    if (same_section)
    {
        geometry_resize_hot(fixture, (size_t)fixture->sections[BUSTER_LINK_HOT].sh_size + 160);
    }
    else
    {
        geometry_outside(fixture, UINT64_C(0x600000), 256);
    }
    for (size_t i = 0; i < count; i += 1)
    {
        geometry_duplicate(fixture, name, same_section ? BUSTER_LINK_HOT : BUSTER_LINK_OTHER, (same_section ? end + 32 : UINT64_C(0x600000)) + i * 32);
    }
    return;
}

static void geometry_all_ambiguous(GeometryFixture *fixture)
{
    geometry_outside(fixture, UINT64_C(0x600000), 256);
    for (size_t i = 0; i < BUSTER_ARRAY_COUNT(linked_mandatory); i += 1)
    {
        geometry_duplicate(fixture, linked_mandatory[i], BUSTER_LINK_OTHER, UINT64_C(0x600000) + i * 32);
    }
    return;
}

static void geometry_rebase(GeometryFixture *fixture, uint64_t base)
{
    uint64_t old = fixture->sections[BUSTER_LINK_HOT].sh_addr;
    fixture->sections[BUSTER_LINK_HOT].sh_addr = base;
    for (size_t i = 1; i < fixture->symbol_count; i += 1)
    {
        if (fixture->symbols[i].st_shndx == BUSTER_LINK_HOT)
        {
            assert(fixture->symbols[i].st_value >= old);
            uint64_t offset = fixture->symbols[i].st_value - old;
            assert(offset <= UINT64_MAX - base);
            fixture->symbols[i].st_value = base + offset;
        }
    }
    return;
}

static uint32_t geometry_section_name(GeometryFixture *fixture, const char *name)
{
    Elf64_Shdr *strings = geometry_section(fixture, BUSTER_LINK_SHSTRTAB);
    assert(strings->sh_size <= UINT32_MAX && strlen(name) + 1 <= UINT32_MAX - strings->sh_size);
    uint32_t at = (uint32_t)strings->sh_size;
    size_t start = fixture->bytes.size;
    linked_append(&fixture->bytes, fixture->bytes.data + strings->sh_offset, (size_t)strings->sh_size);
    linked_append(&fixture->bytes, name, strlen(name) + 1);
    strings->sh_offset = start;
    strings->sh_size += strlen(name) + 1;
    return at;
}

static void geometry_extra_table(GeometryFixture *fixture, bool dynamic)
{
    assert(fixture->section_count < BUSTER_GEOMETRY_SECTIONS);
    Elf64_Sym rows[2] = {0};
    rows[1] = *geometry_named(fixture, linked_mandatory[0]);
    if (dynamic)
    {
        rows[1].st_shndx = SHN_UNDEF;
    }
    Elf64_Shdr table = {0};
    table.sh_name = geometry_section_name(fixture, dynamic ? ".dynsym.extra" : ".symtab.extra");
    table.sh_type = dynamic ? SHT_DYNSYM : SHT_SYMTAB;
    table.sh_link = BUSTER_LINK_STRTAB;
    table.sh_info = 2;
    table.sh_addralign = 8;
    table.sh_entsize = sizeof(rows[0]);
    size_t index = fixture->section_count++;
    fixture->sections[index] = table;
    geometry_payload(fixture, index, rows, sizeof(rows));
    return;
}

static void geometry_flush(GeometryFixture *fixture)
{
    Elf64_Sym ordered[BUSTER_GEOMETRY_SYMBOLS] = {0};
    size_t used = 1;
    // Reverse locals to exercise index-order independence, then retain valid
    // ELF local/global boundaries for every rebuilt ordinary symbol table.
    for (size_t i = fixture->symbol_count; i > 1; i -= 1)
    {
        if (ELF64_ST_BIND(fixture->symbols[i - 1].st_info) == STB_LOCAL)
        {
            ordered[used++] = fixture->symbols[i - 1];
        }
    }
    size_t first_global = used;
    for (size_t i = 1; i < fixture->symbol_count; i += 1)
    {
        if (ELF64_ST_BIND(fixture->symbols[i].st_info) != STB_LOCAL)
        {
            ordered[used++] = fixture->symbols[i];
        }
    }
    assert(used == fixture->symbol_count);
    fixture->sections[BUSTER_LINK_SYMTAB].sh_info = (Elf64_Word)first_global;
    geometry_payload(fixture, BUSTER_LINK_SYMTAB, ordered, used * sizeof(ordered[0]));
    linked_align(&fixture->bytes, 8);
    fixture->header.e_shoff = fixture->bytes.size;
    fixture->header.e_shnum = (Elf64_Half)fixture->section_count;
    linked_append(&fixture->bytes, fixture->sections, fixture->section_count * sizeof(fixture->sections[0]));
    memcpy(fixture->bytes.data, &fixture->header, sizeof(fixture->header));
    return;
}

static void geometry_bad_outside(GeometryFixture *fixture, GeometryFault fault)
{
    geometry_duplicates(fixture, linked_mandatory[0], 1, false);
    Elf64_Sym *extra = fixture->symbols + fixture->symbol_count - 1;
    Elf64_Shdr *outside = geometry_section(fixture, BUSTER_LINK_OTHER);
    if (fault == BUSTER_GEOMETRY_UNDEFINED || fault == BUSTER_GEOMETRY_ABSOLUTE || fault == BUSTER_GEOMETRY_RESERVED_COMMON)
    {
        extra->st_shndx = fault == BUSTER_GEOMETRY_UNDEFINED ? SHN_UNDEF : fault == BUSTER_GEOMETRY_ABSOLUTE ? SHN_ABS : SHN_COMMON;
    }
    else if (fault == BUSTER_GEOMETRY_NONEXEC)
    {
        outside->sh_flags = SHF_ALLOC;
    }
    else if (fault == BUSTER_GEOMETRY_NOBITS)
    {
        outside->sh_type = SHT_NOBITS;
    }
    else if (fault == BUSTER_GEOMETRY_UNSUPPORTED_SECTION)
    {
        outside->sh_type = SHT_NOTE;
    }
    else if (fault == BUSTER_GEOMETRY_EXTENT_OVERRUN)
    {
        extra->st_value = outside->sh_addr + outside->sh_size - 8;
    }
    else if (fault == BUSTER_GEOMETRY_ADDRESS_OVERFLOW)
    {
        outside->sh_addr = UINT64_MAX - 7;
        outside->sh_size = 16;
        extra->st_value = outside->sh_addr;
    }
    return;
}

static void geometry_apply(GeometryFixture fixtures[3], const GeometryCase *test)
{
    GeometryFixture *object = fixtures;
    GeometryFixture *normal = fixtures + 1;
    GeometryFixture *variant = fixtures + 2;
    GeometryFixture *images[] = {normal, variant};
    if (test->duplicates != 0)
    {
        for (size_t image = 0; image < 2; image += 1)
        {
            if ((test->sides & (1U << image)) != 0)
            {
                geometry_duplicates(images[image], linked_mandatory[0], test->duplicates, test->same_section);
            }
        }
    }
    GeometryFault fault = test->fault;
    if (fault >= BUSTER_GEOMETRY_UNDEFINED && fault <= BUSTER_GEOMETRY_ADDRESS_OVERFLOW)
    {
        for (size_t image = 0; image < 2; image += 1)
        {
            if ((test->sides & (1U << image)) != 0)
            {
                geometry_bad_outside(images[image], fault);
            }
        }
    }
    else if (fault == BUSTER_GEOMETRY_MISSING_KEY)
    {
        geometry_remove_named(normal, linked_mandatory[0]);
    }
    else if (fault == BUSTER_GEOMETRY_NO_ANCHOR || fault == BUSTER_GEOMETRY_ONE_IMAGE_ANCHORS || fault == BUSTER_GEOMETRY_ZERO_SOLE_ANCHOR || fault == BUSTER_GEOMETRY_ZERO_BASE_SOLE_ANCHOR)
    {
        if (fault == BUSTER_GEOMETRY_ONE_IMAGE_ANCHORS)
        {
            geometry_all_ambiguous(images[test->sides == 1 ? 0 : 1]);
        }
        else
        {
            geometry_all_ambiguous(variant);
            geometry_all_ambiguous(normal);
        }
        if (fault == BUSTER_GEOMETRY_ZERO_BASE_SOLE_ANCHOR)
        {
            geometry_rebase(normal, 0);
            geometry_rebase(variant, 0);
        }
    }
    else if (fault == BUSTER_GEOMETRY_BASE_ZERO || fault == BUSTER_GEOMETRY_UNDERFLOW)
    {
        geometry_rebase(normal, 0);
        geometry_rebase(variant, 0);
        if (fault == BUSTER_GEOMETRY_UNDERFLOW)
        {
            geometry_named(normal, linked_mandatory[1])->st_value = 16;
            geometry_named(variant, linked_mandatory[1])->st_value = 16 + test->shift;
        }
    }
    else if (fault == BUSTER_GEOMETRY_LATE_ANCHOR)
    {
        geometry_named(normal, linked_mandatory[1])->st_value += 16;
        geometry_named(variant, linked_mandatory[1])->st_value += 16;
    }
    else if (fault == BUSTER_GEOMETRY_WRONG_DELTA)
    {
        geometry_named(variant, linked_mandatory[2])->st_value += 1;
    }
    else if (fault == BUSTER_GEOMETRY_EXPECTED_ABSENT || fault == BUSTER_GEOMETRY_EXPECTED_OFF_ONE)
    {
        for (size_t i = 0; i < 2; i += 1)
        {
            Elf64_Sym selected = *geometry_named(images[i], linked_mandatory[0]);
            geometry_remove_named(images[i], linked_mandatory[0]);
            geometry_add_symbol(images[i], selected);
            geometry_duplicates(images[i], linked_mandatory[0], 2, false);
            if (fault == BUSTER_GEOMETRY_EXPECTED_ABSENT)
            {
                images[i]->symbols[images[i]->symbol_count - 3].st_shndx = BUSTER_LINK_OTHER;
                images[i]->symbols[images[i]->symbol_count - 3].st_value = UINT64_C(0x600080);
            }
            else
            {
                images[i]->symbols[images[i]->symbol_count - 3].st_value += 1;
            }
        }
    }
    else if (fault >= BUSTER_GEOMETRY_KEY_TYPE && fault <= BUSTER_GEOMETRY_KEY_SIZE)
    {
        Elf64_Sym *selected = geometry_named(variant, linked_mandatory[0]);
        if (fault == BUSTER_GEOMETRY_KEY_TYPE)
        {
            selected->st_info = ELF64_ST_INFO(STB_LOCAL, STT_OBJECT);
        }
        else if (fault == BUSTER_GEOMETRY_KEY_BINDING)
        {
            selected->st_info = ELF64_ST_INFO(STB_GLOBAL, STT_FUNC);
        }
        else if (fault == BUSTER_GEOMETRY_KEY_VISIBILITY)
        {
            selected->st_other = STV_HIDDEN;
        }
        else
        {
            selected->st_size += 1;
        }
    }
    else if (fault == BUSTER_GEOMETRY_WRONG_SECTION || fault == BUSTER_GEOMETRY_SAME_VA_SECTION)
    {
        uint64_t expected = BUSTER_LINK_BASE + test->shift;
        geometry_outside(variant, expected, 16);
        if (fault == BUSTER_GEOMETRY_SAME_VA_SECTION)
        {
            geometry_duplicate(variant, linked_mandatory[0], BUSTER_LINK_OTHER, expected);
        }
        else
        {
            geometry_named(variant, linked_mandatory[0])->st_shndx = BUSTER_LINK_OTHER;
        }
    }
    else if (fault == BUSTER_GEOMETRY_SAME_VA_TABLE || fault == BUSTER_GEOMETRY_DYNSYM_IGNORED)
    {
        geometry_extra_table(variant, fault == BUSTER_GEOMETRY_DYNSYM_IGNORED);
    }
    else if (fault == BUSTER_GEOMETRY_INTERIOR || fault == BUSTER_GEOMETRY_PREFIX)
    {
        geometry_duplicate(variant, linked_mandatory[0], BUSTER_LINK_HOT, BUSTER_LINK_BASE + (fault == BUSTER_GEOMETRY_INTERIOR ? test->shift + 48 : 0));
    }
    else if (fault == BUSTER_GEOMETRY_STRADDLE_BASE || fault == BUSTER_GEOMETRY_PREDECESSOR_EXACT || fault == BUSTER_GEOMETRY_PREDECESSOR_OVERLAP || fault == BUSTER_GEOMETRY_SUCCESSOR_EXACT)
    {
        for (size_t i = 0; i < 2; i += 1)
        {
            uint64_t address = BUSTER_LINK_BASE + images[i]->sections[BUSTER_LINK_HOT].sh_size;
            if (fault != BUSTER_GEOMETRY_SUCCESSOR_EXACT)
            {
                address = BUSTER_LINK_BASE - (fault == BUSTER_GEOMETRY_PREDECESSOR_EXACT ? 16 : fault == BUSTER_GEOMETRY_PREDECESSOR_OVERLAP ? 15 : 8);
            }
            geometry_outside(images[i], address, 16);
            geometry_duplicate(images[i], linked_mandatory[0], BUSTER_LINK_OTHER, address);
        }
    }
    else if (fault == BUSTER_GEOMETRY_ZERO_EXTRA_END || fault == BUSTER_GEOMETRY_ZERO_DUPLICATE || fault == BUSTER_GEOMETRY_ZERO_OUTSIDE_AFTER || fault == BUSTER_GEOMETRY_ZERO_OUTSIDE_BEFORE)
    {
        for (size_t i = 0; i < 2; i += 1)
        {
            uint64_t end = BUSTER_LINK_BASE + images[i]->sections[BUSTER_LINK_HOT].sh_size;
            uint64_t address = fault == BUSTER_GEOMETRY_ZERO_DUPLICATE ? geometry_named(images[i], "zero_size_owned")->st_value : end;
            uint16_t section = BUSTER_LINK_HOT;
            if (fault == BUSTER_GEOMETRY_ZERO_OUTSIDE_AFTER || fault == BUSTER_GEOMETRY_ZERO_OUTSIDE_BEFORE)
            {
                address = fault == BUSTER_GEOMETRY_ZERO_OUTSIDE_AFTER ? end + 1 : BUSTER_LINK_BASE - 1;
                geometry_outside(images[i], address, 1);
                section = BUSTER_LINK_OTHER;
            }
            geometry_duplicate(images[i], "zero_size_owned", section, address);
        }
    }
    else if (fault == BUSTER_GEOMETRY_ZERO_MISSING)
    {
        Elf64_Sym point = *geometry_named(variant, "zero_size_owned");
        geometry_remove_named(variant, "zero_size_owned");
        geometry_outside(normal, UINT64_C(0x600000), 16);
        geometry_outside(variant, UINT64_C(0x600000), 16);
        geometry_duplicate(normal, "zero_size_owned", BUSTER_LINK_OTHER, UINT64_C(0x600000));
        point.st_shndx = BUSTER_LINK_OTHER;
        point.st_value = UINT64_C(0x600000);
        geometry_add_symbol(variant, point);
        point.st_value += 1;
        geometry_add_symbol(variant, point);
    }
    else if (fault == BUSTER_GEOMETRY_LAST_BYTE || fault == BUSTER_GEOMETRY_ZERO_ENDPOINT_OVERFLOW)
    {
        geometry_resize_hot(object, 4096);
        if (fault == BUSTER_GEOMETRY_ZERO_ENDPOINT_OVERFLOW)
        {
            geometry_named(object, "zero_size_owned")->st_value = 4096;
        }
        for (size_t i = 0; i < 2; i += 1)
        {
            geometry_resize_hot(images[i], 4096);
            geometry_rebase(images[i], UINT64_MAX - 4095);
            if (fault == BUSTER_GEOMETRY_ZERO_ENDPOINT_OVERFLOW)
            {
                geometry_named(images[i], "zero_size_owned")->st_value = UINT64_MAX;
                geometry_outside(images[i], 0, 16);
                geometry_duplicate(images[i], "zero_size_owned", BUSTER_LINK_OTHER, 0);
            }
        }
    }
    else if (fault == BUSTER_GEOMETRY_OUTSIDE_LAST_BYTE)
    {
        for (size_t i = 0; i < 2; i += 1)
        {
            geometry_outside(images[i], UINT64_MAX - 15, 16);
            geometry_duplicate(images[i], linked_mandatory[0], BUSTER_LINK_OTHER, UINT64_MAX - 15);
        }
    }
    else if (fault == BUSTER_GEOMETRY_DIFFERENT_KEY_ALIAS)
    {
        Elf64_Sym alias = *geometry_named(variant, linked_mandatory[0]);
        alias.st_info = ELF64_ST_INFO(STB_LOCAL, STT_OBJECT);
        geometry_add_symbol(variant, alias);
    }
    else if (fault == BUSTER_GEOMETRY_SUFFIX_BYTE || fault == BUSTER_GEOMETRY_PREFIX_BYTE)
    {
        Elf64_Shdr *hot = geometry_section(variant, BUSTER_LINK_HOT);
        size_t offset = fault == BUSTER_GEOMETRY_SUFFIX_BYTE ? (size_t)test->shift + 24 : 0;
        variant->bytes.data[(size_t)hot->sh_offset + offset] ^= 1;
    }
    else if (fault == BUSTER_GEOMETRY_SHORT_CONTRIBUTION)
    {
        variant->sections[BUSTER_LINK_HOT].sh_size -= 1;
    }
    else if (fault == BUSTER_GEOMETRY_BAD_RELOCATION_WIDTH || fault == BUSTER_GEOMETRY_RELOCATION_OVERLAP)
    {
        const Elf64_Shdr *rela = object->sections + BUSTER_LINK_RELA;
        Elf64_Rela rows[2];
        memcpy(rows, object->bytes.data + rela->sh_offset, sizeof(rows[0]));
        if (fault == BUSTER_GEOMETRY_BAD_RELOCATION_WIDTH)
        {
            rows[0].r_info = ELF64_R_INFO(ELF64_R_SYM(rows[0].r_info), UINT32_MAX);
            geometry_payload(object, BUSTER_LINK_RELA, rows, sizeof(rows[0]));
        }
        else
        {
            rows[1] = rows[0];
            rows[1].r_offset += 2;
            geometry_payload(object, BUSTER_LINK_RELA, rows, sizeof(rows));
        }
    }
    else if (fault == BUSTER_GEOMETRY_SHORT_FILE)
    {
        geometry_duplicates(variant, linked_mandatory[0], 1, false);
    }
    return;
}

static bool geometry_empty_proof(const HpLinkedProof *proof)
{
    bool empty = proof->shift == 0 && proof->hot_input_base == 0 && proof->hot_bytes == 0 && proof->hot_alignment == 0 && proof->normal_output_section.data == NULL && proof->normal_output_section.size == 0 && proof->variant_output_section.data == NULL && proof->variant_output_section.size == 0 && proof->functions == NULL && proof->function_count == 0 && proof->operands == NULL && proof->operand_count == 0 && proof->masked_operand_bytes == 0;
    return empty;
}

static bool geometry_proof_valid(const HpElf *object, const HpLinkedProof *proof, const GeometryCase *test)
{
    const HpSection *hot = hp_elf_section_named(object, ".text.buster_checker");
    uint64_t base = test->fault == BUSTER_GEOMETRY_BASE_ZERO || test->fault == BUSTER_GEOMETRY_ZERO_BASE_SOLE_ANCHOR ? 0 : test->fault == BUSTER_GEOMETRY_LAST_BYTE ? UINT64_MAX - 4095 : BUSTER_LINK_BASE;
    bool valid = hot != NULL && proof->shift == test->shift && proof->hot_input_base == base && proof->hot_bytes == hot->size && proof->hot_alignment == 4096 && proof->operand_count == 1 && proof->masked_operand_bytes == 4 && hp_string_is(proof->normal_output_section, ".text") && hp_string_is(proof->variant_output_section, ".text");
    if (valid)
    {
        valid = proof->operands != NULL && proof->operands[0].object_relocation == 0 && proof->operands[0].offset == 12 && proof->operands[0].type == R_X86_64_PC32 && proof->operands[0].width == 4;
    }
    size_t owned = 0;
    for (size_t i = 0; valid && i < object->symbol_count; i += 1)
    {
        const HpSymbol *member = object->symbols + i;
        if (member->section == hot->index && member->type == STT_FUNC)
        {
            const HpLinkedFunction *found = NULL;
            for (size_t j = 0; j < proof->function_count; j += 1)
            {
                if (proof->functions[j].object_symbol == i)
                {
                    valid = valid && found == NULL;
                    found = proof->functions + j;
                }
            }
            valid = valid && found != NULL && hp_string_equal(found->name, member->name) && found->object_offset == member->value && found->size == member->size && member->value <= UINT64_MAX - base;
            if (valid)
            {
                uint64_t expected = base + member->value;
                valid = test->shift <= UINT64_MAX - expected && found->normal_address == expected && found->variant_address == expected + test->shift && found->delta == test->shift && found->normal_residue_4096 == expected % 4096 && found->variant_residue_4096 == (expected + test->shift) % 4096;
            }
            owned += 1;
        }
    }
    valid = valid && proof->function_count == owned;
    return valid;
}

static void geometry_run(GeometrySuite *suite, const GeometryCase *test)
{
    GeometryFixture fixtures[3];
    bool zero = test->fault >= BUSTER_GEOMETRY_ZERO_INTERIOR && test->fault <= BUSTER_GEOMETRY_ZERO_ENDPOINT_OVERFLOW && test->fault != BUSTER_GEOMETRY_LAST_BYTE;
    bool zero_end = test->fault == BUSTER_GEOMETRY_ZERO_END;
    geometry_prepare(fixtures, true, 0, zero, zero_end);
    geometry_prepare(fixtures + 1, false, 0, zero, zero_end);
    geometry_prepare(fixtures + 2, false, test->shift, zero, zero_end);
    geometry_apply(fixtures, test);
    LinkedBuffer before[3];
    for (size_t i = 0; i < 3; i += 1)
    {
        geometry_flush(fixtures + i);
    }
    if (test->reader_refusal)
    {
        // An insufficient PROGBITS file span cannot be an unmodified successful
        // reader output. Exercise that boundary as a reader refusal only.
        Elf64_Shdr outside = fixtures[2].sections[BUSTER_LINK_OTHER];
        outside.sh_offset = fixtures[2].bytes.size - 4;
        outside.sh_size = 16;
        size_t at = (size_t)fixtures[2].header.e_shoff + BUSTER_LINK_OTHER * sizeof(outside);
        memcpy(fixtures[2].bytes.data + at, &outside, sizeof(outside));
    }
    for (size_t i = 0; i < 3; i += 1)
    {
        before[i] = fixtures[i].bytes;
    }
    HpElf elves[3] = {0};
    HpLinkedProof proof = {0};
    char error[BUSTER_HP_ERROR_CAPACITY] = {0};
    bool parsed = true;
    size_t failed_reader = 3;
    for (size_t i = 0; parsed && i < 3; i += 1)
    {
        HpBytes bytes = {fixtures[i].bytes.data, fixtures[i].bytes.size};
        parsed = hp_elf_read(bytes, elves + i, error);
        if (!parsed)
        {
            failed_reader = i;
        }
    }
    bool accepted = parsed && !test->reader_refusal && hp_linked_compare(elves, elves + 1, elves + 2, test->shift, NULL, 0, &proof, error);
    bool passed = test->reader_refusal ? !parsed && failed_reader == 2 && elves[2].input.data == NULL && elves[2].input.size == 0 && elves[2].sections == NULL && elves[2].section_count == 0 && elves[2].symbols == NULL && elves[2].symbol_count == 0 && elves[2].relocations == NULL && elves[2].relocation_count == 0 : parsed && accepted == test->expected;
    if (accepted)
    {
        passed = passed && error[0] == 0 && geometry_proof_valid(elves, &proof, test);
    }
    else
    {
        passed = passed && error[0] != 0 && geometry_empty_proof(&proof);
    }
    for (size_t i = 0; i < 3; i += 1)
    {
        passed = passed && before[i].size == fixtures[i].bytes.size && memcmp(before[i].data, fixtures[i].bytes.data, sizeof(before[i].data)) == 0;
    }
    suite->cases += 1;
    suite->failures += !passed;
    suite->reader_cases += test->reader_refusal;
    suite->linked_cases += !test->reader_refusal;
    printf("%s %s [%s%s%s]\n", passed ? "PASS" : "FAIL", test->name, test->reader_refusal ? "reader boundary" : "linked gate", error[0] != 0 ? ": " : "", error);
    hp_linked_proof_free(&proof);
    for (size_t i = 0; i < 3; i += 1)
    {
        hp_elf_free(elves + i);
    }
    return;
}

static void geometry_matrix(GeometrySuite *suite)
{
    static const uint64_t shifts[] = {0, 16, 64, 256, 1024, 2048};
    for (size_t shift = 0; shift < BUSTER_ARRAY_COUNT(shifts); shift += 1)
    {
        for (unsigned sides = 1; sides <= 3; sides += 1)
        {
            for (size_t duplicates = 2; duplicates <= 3; duplicates += 1)
            {
                for (unsigned same = 0; same < 2; same += 1)
                {
                    char name[160];
                    snprintf(name, sizeof(name), "%zu disjoint %s duplicates sides%u shift%" PRIu64 " shuffled", duplicates, same ? "same-section" : "other-section", sides, shifts[shift]);
                    GeometryCase test = {.name = name, .shift = shifts[shift], .sides = sides, .duplicates = duplicates, .same_section = same != 0, .expected = true};
                    geometry_run(suite, &test);
                }
            }
        }
    }
    return;
}

static void geometry_edges(GeometrySuite *suite)
{
    static const struct
    {
        const char *name;
        GeometryFault fault;
        bool expected;
        bool duplicate_controls;
    } cases[] =
    {
        {"missing complete key band refuses", BUSTER_GEOMETRY_MISSING_KEY, false, false},
        {"no unique-in-both anchor refuses", BUSTER_GEOMETRY_NO_ANCHOR, false, false},
        {"unique in one image only is not an anchor", BUSTER_GEOMETRY_ONE_IMAGE_ANCHORS, false, false},
        {"page-aligned base zero is not an unset sentinel", BUSTER_GEOMETRY_BASE_ZERO, true, false},
        {"later inconsistent unique anchor refuses", BUSTER_GEOMETRY_LATE_ANCHOR, false, false},
        {"wrong unique-anchor delta refuses", BUSTER_GEOMETRY_WRONG_DELTA, false, false},
        {"anchor object-offset underflow refuses", BUSTER_GEOMETRY_UNDERFLOW, false, false},
        {"band exists but expected address absent refuses", BUSTER_GEOMETRY_EXPECTED_ABSENT, false, false},
        {"ambiguous-key expected address off by one refuses", BUSTER_GEOMETRY_EXPECTED_OFF_ONE, false, false},
        {"selected key type mutation refuses", BUSTER_GEOMETRY_KEY_TYPE, false, true},
        {"selected key binding mutation refuses", BUSTER_GEOMETRY_KEY_BINDING, false, true},
        {"selected key visibility mutation refuses", BUSTER_GEOMETRY_KEY_VISIBILITY, false, true},
        {"selected key size mutation refuses", BUSTER_GEOMETRY_KEY_SIZE, false, true},
        {"expected address in wrong declared section refuses", BUSTER_GEOMETRY_WRONG_SECTION, false, false},
        {"duplicate exact VA across sections refuses", BUSTER_GEOMETRY_SAME_VA_SECTION, false, false},
        {"duplicate exact VA across ordinary SYMTABs refuses", BUSTER_GEOMETRY_SAME_VA_TABLE, false, false},
        {"DYNSYM is excluded from ordinary candidate bands", BUSTER_GEOMETRY_DYNSYM_IGNORED, true, false},
        {"extra interior function refuses", BUSTER_GEOMETRY_INTERIOR, false, false},
        {"extra function straddling base refuses", BUSTER_GEOMETRY_STRADDLE_BASE, false, false},
        {"extra function in variant prefix refuses", BUSTER_GEOMETRY_PREFIX, false, false},
        {"predecessor ending exactly at base is disjoint", BUSTER_GEOMETRY_PREDECESSOR_EXACT, true, false},
        {"predecessor overlapping by one byte refuses", BUSTER_GEOMETRY_PREDECESSOR_OVERLAP, false, false},
        {"nonzero successor starting exactly at end is disjoint", BUSTER_GEOMETRY_SUCCESSOR_EXACT, true, false},
        {"zero-size owned interior point is retained", BUSTER_GEOMETRY_ZERO_INTERIOR, true, false},
        {"sole selected zero at endpoint is retained", BUSTER_GEOMETRY_ZERO_END, true, false},
        {"extra zero at complete contribution endpoint refuses", BUSTER_GEOMETRY_ZERO_EXTRA_END, false, false},
        {"duplicate exact expected zero point refuses", BUSTER_GEOMETRY_ZERO_DUPLICATE, false, false},
        {"missing expected zero point refuses", BUSTER_GEOMETRY_ZERO_MISSING, false, false},
        {"sole unique zero anchor qualifies ambiguous functions", BUSTER_GEOMETRY_ZERO_SOLE_ANCHOR, true, false},
        {"sole unique zero anchor qualifies contribution base zero", BUSTER_GEOMETRY_ZERO_BASE_SOLE_ANCHOR, true, false},
        {"extra zero just after complete contribution is disjoint", BUSTER_GEOMETRY_ZERO_OUTSIDE_AFTER, true, false},
        {"extra zero just before base is disjoint", BUSTER_GEOMETRY_ZERO_OUTSIDE_BEFORE, true, false},
        {"contribution last byte may be UINT64_MAX", BUSTER_GEOMETRY_LAST_BYTE, true, false},
        {"unrepresentable expected zero endpoint refuses", BUSTER_GEOMETRY_ZERO_ENDPOINT_OVERFLOW, false, false},
        {"outside duplicate last byte may be UINT64_MAX", BUSTER_GEOMETRY_OUTSIDE_LAST_BYTE, true, false},
        {"different-full-key alias at same VA remains admissible", BUSTER_GEOMETRY_DIFFERENT_KEY_ALIAS, true, false},
        {"duplicates cannot bypass nonoperand byte check", BUSTER_GEOMETRY_SUFFIX_BYTE, false, true},
        {"duplicates cannot bypass prefix byte check", BUSTER_GEOMETRY_PREFIX_BYTE, false, true},
        {"duplicates cannot bypass complete contribution range", BUSTER_GEOMETRY_SHORT_CONTRIBUTION, false, true},
        {"duplicates cannot bypass relocation width", BUSTER_GEOMETRY_BAD_RELOCATION_WIDTH, false, true},
        {"duplicates cannot bypass relocation overlap", BUSTER_GEOMETRY_RELOCATION_OVERLAP, false, true}
    };
    for (size_t i = 0; i < BUSTER_ARRAY_COUNT(cases); i += 1)
    {
        uint64_t shift = cases[i].fault == BUSTER_GEOMETRY_LAST_BYTE || cases[i].fault == BUSTER_GEOMETRY_ZERO_ENDPOINT_OVERFLOW ? 0 : 16;
        GeometryCase test = {.name = cases[i].name, .shift = shift, .sides = 3, .duplicates = cases[i].duplicate_controls ? 2 : 0, .fault = cases[i].fault, .expected = cases[i].expected};
        geometry_run(suite, &test);
    }
    GeometryCase reverse_anchor = {.name = "unique in variant only is not an anchor", .shift = 16, .sides = 1, .fault = BUSTER_GEOMETRY_ONE_IMAGE_ANCHORS, .expected = false};
    geometry_run(suite, &reverse_anchor);
    static const struct
    {
        const char *name;
        GeometryFault fault;
    } bad[] =
    {
        {"undefined equal-key candidate", BUSTER_GEOMETRY_UNDEFINED},
        {"ABS equal-key candidate", BUSTER_GEOMETRY_ABSOLUTE},
        {"reserved COMMON equal-key candidate", BUSTER_GEOMETRY_RESERVED_COMMON},
        {"nonexec equal-key outside candidate", BUSTER_GEOMETRY_NONEXEC},
        {"NOBITS equal-key outside candidate", BUSTER_GEOMETRY_NOBITS},
        {"unsupported-section equal-key outside candidate", BUSTER_GEOMETRY_UNSUPPORTED_SECTION},
        {"extent-overrun equal-key outside candidate", BUSTER_GEOMETRY_EXTENT_OVERRUN},
        {"address-overflow equal-key outside candidate", BUSTER_GEOMETRY_ADDRESS_OVERFLOW}
    };
    for (size_t i = 0; i < BUSTER_ARRAY_COUNT(bad); i += 1)
    {
        for (unsigned sides = 1; sides <= 3; sides += 1)
        {
            char name[160];
            snprintf(name, sizeof(name), "%s sides%u refuses", bad[i].name, sides);
            GeometryCase test = {.name = name, .shift = 16, .sides = sides, .fault = bad[i].fault, .expected = false};
            geometry_run(suite, &test);
        }
    }
    GeometryCase short_file = {.name = "short PROGBITS backing is explicit reader refusal", .shift = 16, .fault = BUSTER_GEOMETRY_SHORT_FILE, .reader_refusal = true};
    geometry_run(suite, &short_file);
    return;
}

int main(void)
{
    const uint16_t endian = 1;
    bool little = *(const unsigned char *)&endian == 1;
    GeometrySuite suite = {0};
    if (little)
    {
        geometry_matrix(&suite);
        geometry_edges(&suite);
    }
    else
    {
        suite.failures = 1;
        fputs("FAIL unsupported fixture host byte order\n", stderr);
    }
    printf("Focused synthetic linked geometry controls: %zu cases (%zu linked, %zu reader), %zu failures; no actual artifact/helper/producer/image execution.\n", suite.cases, suite.linked_cases, suite.reader_cases, suite.failures);
    int status = suite.failures == 0 ? 0 : 1;
    return status;
}
