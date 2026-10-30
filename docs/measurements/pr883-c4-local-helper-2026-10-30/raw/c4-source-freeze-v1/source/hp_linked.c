// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin.
// hp_linked_compare binds every selected-object hot function to unique final
// metadata, proves one translated contribution, and compares all linked bytes
// outside known relocation operands. It never invokes or executes an image.
#include "hp_linked.h"

#include <elf.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct HpLinkedIndex HpLinkedIndex;
struct HpLinkedIndex
{
    const HpSymbol **symbols;
    size_t count;
};

typedef struct HpLinkedBand HpLinkedBand;
struct HpLinkedBand
{
    size_t first;
    size_t count;
};

typedef struct HpLinkedResolution HpLinkedResolution;
struct HpLinkedResolution
{
    HpLinkedBand normal_band;
    HpLinkedBand variant_band;
    const HpSymbol *normal;
    const HpSymbol *variant;
};

static bool hp_linked_error(char error[BUSTER_HP_ERROR_CAPACITY], const char *message)
{
    if (error != NULL)
    {
        snprintf(error, BUSTER_HP_ERROR_CAPACITY, "%s", message);
    }
    return false;
}

static bool hp_linked_address_range(uint64_t address, uint64_t size)
{
    // An interval may end exactly one past UINT64_MAX; subtraction validates
    // its last byte without overflowing the exclusive endpoint.
    return size == 0 || size - 1 <= UINT64_MAX - address;
}

static int hp_linked_name_compare(HpString a, HpString b)
{
    size_t common = a.size < b.size ? a.size : b.size;
    int result = common != 0 ? memcmp(a.data, b.data, common) : 0;
    if (result == 0)
    {
        result = (a.size > b.size) - (a.size < b.size);
    }
    return result;
}

static int hp_linked_symbol_compare(const HpSymbol *a, const HpSymbol *b)
{
    int result = hp_linked_name_compare(a->name, b->name);
    if (result == 0)
    {
        result = (a->type > b->type) - (a->type < b->type);
    }
    if (result == 0)
    {
        result = (a->bind > b->bind) - (a->bind < b->bind);
    }
    if (result == 0)
    {
        result = (a->other > b->other) - (a->other < b->other);
    }
    if (result == 0)
    {
        result = (a->size > b->size) - (a->size < b->size);
    }
    return result;
}

static int hp_linked_index_compare(const void *left, const void *right)
{
    const HpSymbol *const *a = left;
    const HpSymbol *const *b = right;
    return hp_linked_symbol_compare(*a, *b);
}

static bool hp_linked_index(const HpElf *elf, HpLinkedIndex *index, char error[BUSTER_HP_ERROR_CAPACITY])
{
    bool valid = elf->symbol_count <= SIZE_MAX / sizeof(*index->symbols);
    if (valid && elf->symbol_count != 0)
    {
        index->symbols = calloc(elf->symbol_count, sizeof(*index->symbols));
        valid = index->symbols != NULL;
    }
    if (!valid)
    {
        valid = hp_linked_error(error, "final symbol index allocation failed");
    }
    for (size_t item = 0; valid && item < elf->symbol_count; item += 1)
    {
        const HpSymbol *symbol = elf->symbols + item;
        if (symbol->table >= elf->section_count)
        {
            valid = hp_linked_error(error, "final symbol has invalid table ownership");
        }
        else if (elf->sections[symbol->table].type == SHT_SYMTAB)
        {
            index->symbols[index->count++] = symbol;
        }
    }
    if (valid && index->count > 1)
    {
        qsort(index->symbols, index->count, sizeof(*index->symbols), hp_linked_index_compare);
    }
    return valid;
}

static HpLinkedBand hp_linked_band(const HpLinkedIndex *index, const HpSymbol *member)
{
    size_t low = 0;
    size_t high = index->count;
    while (low < high)
    {
        size_t middle = low + (high - low) / 2;
        if (hp_linked_symbol_compare(index->symbols[middle], member) < 0)
        {
            low = middle + 1;
        }
        else
        {
            high = middle;
        }
    }
    HpLinkedBand result =
    {
        .first = low
    };
    while (low < index->count && hp_linked_symbol_compare(index->symbols[low], member) == 0)
    {
        result.count += 1;
        low += 1;
    }
    return result;
}

static bool hp_linked_symbol_extent(const HpElf *elf, const HpSymbol *symbol)
{
    bool valid = symbol->section > 0 && symbol->section < elf->section_count;
    if (valid)
    {
        const HpSection *section = elf->sections + symbol->section;
        valid = section->type == SHT_PROGBITS && (section->flags & (SHF_ALLOC | SHF_EXECINSTR)) == (SHF_ALLOC | SHF_EXECINSTR) && section->bytes.data != NULL && symbol->value >= section->addr;
        if (valid)
        {
            uint64_t offset = symbol->value - section->addr;
            valid = offset <= section->size && symbol->size <= section->size - offset && offset <= section->bytes.size && symbol->size <= section->bytes.size - (size_t)offset && hp_linked_address_range(symbol->value, symbol->size);
        }
    }
    return valid;
}

static bool hp_linked_band_valid(const HpElf *elf, const HpLinkedIndex *index, HpLinkedBand band)
{
    bool valid = band.count != 0;
    for (size_t item = 0; valid && item < band.count; item += 1)
    {
        valid = hp_linked_symbol_extent(elf, index->symbols[band.first + item]);
    }
    return valid;
}

static bool hp_linked_overlaps(uint64_t address, uint64_t size, uint64_t base, uint64_t length)
{
    // Extra zero-size functions are points, including a representable upper
    // endpoint. Nonempty extents use half-open overlap without adding ends.
    bool overlap = size == 0 ? address >= base && address - base <= length : (address >= base ? address - base < length : size > base - address);
    return overlap;
}

static const HpSymbol *hp_linked_resolve(const HpLinkedIndex *index, HpLinkedBand band, uint64_t address, uint64_t base, uint64_t length)
{
    const HpSymbol *result = NULL;
    size_t matches = 0;
    bool valid = true;
    for (size_t item = 0; item < band.count; item += 1)
    {
        const HpSymbol *symbol = index->symbols[band.first + item];
        if (symbol->value == address)
        {
            matches += 1;
            result = symbol;
        }
        else if (hp_linked_overlaps(symbol->value, symbol->size, base, length))
        {
            valid = false;
        }
    }
    if (!valid || matches != 1)
    {
        result = NULL;
    }
    return result;
}

static const HpSection *hp_linked_image_range(const HpElf *elf, uint64_t address, uint64_t size, HpBytes *bytes)
{
    const HpSection *result = NULL;
    size_t count = 0;
    for (size_t index = 0; index < elf->section_count; index += 1)
    {
        const HpSection *section = elf->sections + index;
        if (section->type == SHT_PROGBITS && (section->flags & (SHF_ALLOC | SHF_EXECINSTR)) == (SHF_ALLOC | SHF_EXECINSTR) && section->bytes.data != NULL && section->addr <= address)
        {
            uint64_t offset = address - section->addr;
            if (offset <= section->size && size <= section->size - offset && offset <= section->bytes.size && size <= section->bytes.size - (size_t)offset)
            {
                count += 1;
                result = section;
                bytes->data = section->bytes.data + (size_t)offset;
                bytes->size = (size_t)size;
            }
        }
    }
    if (count != 1)
    {
        result = NULL;
        memset(bytes, 0, sizeof(*bytes));
    }
    return result;
}

static int hp_linked_operand_compare(const void *left, const void *right)
{
    const HpLinkedOperand *a = left;
    const HpLinkedOperand *b = right;
    int result = (a->offset > b->offset) - (a->offset < b->offset);
    if (result == 0)
    {
        result = (a->type > b->type) - (a->type < b->type);
    }
    return result;
}

void hp_linked_proof_free(HpLinkedProof *proof)
{
    if (proof != NULL)
    {
        free(proof->functions);
        free(proof->operands);
        memset(proof, 0, sizeof(*proof));
    }
    return;
}

bool hp_linked_compare(const HpElf *original_object, const HpElf *normal, const HpElf *variant, uint64_t shift, const char *const *required, size_t required_count, HpLinkedProof *proof, char error[BUSTER_HP_ERROR_CAPACITY])
{
    bool valid = original_object != NULL && normal != NULL && variant != NULL && proof != NULL && error != NULL && (required_count == 0 || required != NULL);
    HpLinkedProof result = { 0 };
    HpLinkedIndex normal_index = { 0 };
    HpLinkedIndex variant_index = { 0 };
    HpLinkedResolution *resolutions = NULL;
    if (proof != NULL)
    {
        memset(proof, 0, sizeof(*proof));
    }
    if (error != NULL)
    {
        error[0] = 0;
    }
    if (!valid)
    {
        valid = hp_linked_error(error, "missing ELF, required-name or proof storage");
    }
    if (valid && (original_object->elf_type != ET_REL || normal->elf_type != ET_EXEC || variant->elf_type != ET_EXEC))
    {
        valid = hp_linked_error(error, "requires REL input and non-PIE EXEC images");
    }
    if (valid && shift != 0 && shift != 16 && shift != 64 && shift != 256 && shift != 1024 && shift != 2048)
    {
        valid = hp_linked_error(error, "unapproved hot shift");
    }
    const HpElf *images[2] =
    {
        normal,
        variant
    };
    for (size_t image = 0; valid && image < 2; image += 1)
    {
        for (size_t index = 0; valid && index < images[image]->section_count; index += 1)
        {
            const HpSection *section = images[image]->sections + index;
            if ((section->flags & SHF_ALLOC) != 0 && !hp_linked_address_range(section->addr, section->size))
            {
                valid = hp_linked_error(error, "allocated section exceeds ELF64 address range");
            }
        }
    }
    const HpSection *hot = valid ? hp_elf_section_named(original_object, ".text.buster_checker") : NULL;
    if (valid && (hot == NULL || hot->type != SHT_PROGBITS || hot->align != 4096 || (hot->flags & (SHF_ALLOC | SHF_EXECINSTR)) != (SHF_ALLOC | SHF_EXECINSTR) || hot->size == 0 || hot->size > UINT64_MAX - shift))
    {
        valid = hp_linked_error(error, "hot object section is missing or not file-backed executable/page-aligned content");
    }
    size_t member_count = 0;
    for (size_t index = 0; valid && index < original_object->symbol_count; index += 1)
    {
        const HpSymbol *symbol = original_object->symbols + index;
        if (symbol->section == hot->index && symbol->type == STT_FUNC)
        {
            if (symbol->name.size == 0 || symbol->value > hot->size || symbol->size > hot->size - symbol->value)
            {
                valid = hp_linked_error(error, "unnamed or out-of-range owned hot function");
            }
            member_count += 1;
        }
    }
    if (valid && (member_count == 0 || member_count > SIZE_MAX / sizeof(*result.functions) || member_count > SIZE_MAX / sizeof(*resolutions)))
    {
        valid = hp_linked_error(error, "missing or excessive owned hot membership");
    }
    if (valid)
    {
        result.functions = calloc(member_count, sizeof(*result.functions));
        resolutions = calloc(member_count, sizeof(*resolutions));
        valid = result.functions != NULL && resolutions != NULL;
        if (!valid)
        {
            valid = hp_linked_error(error, "owned function allocation failed");
        }
    }
    const char *mandatory[] =
    {
        "check_program_emit",
        "check_lower_drain",
        "check_lower_batch_classify"
    };
    for (size_t set = 0; valid && set < 2; set += 1)
    {
        const char *const *names = set == 0 ? mandatory : required;
        size_t name_count = set == 0 ? sizeof(mandatory) / sizeof(mandatory[0]) : required_count;
        for (size_t name = 0; valid && name < name_count; name += 1)
        {
            bool found = false;
            for (size_t index = 0; names[name] != NULL && index < original_object->symbol_count; index += 1)
            {
                const HpSymbol *symbol = original_object->symbols + index;
                found = found || (symbol->section == hot->index && symbol->type == STT_FUNC && hp_string_is(symbol->name, names[name]));
            }
            if (!found)
            {
                valid = hp_linked_error(error, "required function is not owned by selected hot section");
            }
        }
    }
    if (valid)
    {
        valid = hp_linked_index(normal, &normal_index, error) && hp_linked_index(variant, &variant_index, error);
    }
    uint64_t base = 0;
    bool has_anchor = false;
    for (size_t index = 0; valid && index < original_object->symbol_count; index += 1)
    {
        const HpSymbol *member = original_object->symbols + index;
        if (member->section == hot->index && member->type == STT_FUNC)
        {
            for (size_t previous = 0; valid && previous < result.function_count; previous += 1)
            {
                if (hp_string_equal(result.functions[previous].name, member->name))
                {
                    valid = hp_linked_error(error, "ambiguous owned hot function name");
                }
            }
            HpLinkedBand a_band = valid ? hp_linked_band(&normal_index, member) : (HpLinkedBand){ 0 };
            HpLinkedBand b_band = valid ? hp_linked_band(&variant_index, member) : (HpLinkedBand){ 0 };
            if (valid && (!hp_linked_band_valid(normal, &normal_index, a_band) || !hp_linked_band_valid(variant, &variant_index, b_band)))
            {
                valid = hp_linked_error(error, "missing or invalid final hot function candidate extent");
            }
            if (valid && a_band.count == 1 && b_band.count == 1)
            {
                const HpSymbol *a = normal_index.symbols[a_band.first];
                const HpSymbol *b = variant_index.symbols[b_band.first];
                if (b->value < a->value || b->value - a->value != shift || a->value < member->value || b->value < member->value || b->value - member->value < shift)
                {
                    valid = hp_linked_error(error, "wrong anchor delta or contribution underflow");
                }
                if (valid)
                {
                    uint64_t normal_base = a->value - member->value;
                    uint64_t variant_base = b->value - member->value - shift;
                    if (!has_anchor)
                    {
                        base = normal_base;
                        has_anchor = true;
                    }
                    if (base != normal_base || base != variant_base)
                    {
                        valid = hp_linked_error(error, "unique anchors are not one translated contribution");
                    }
                }
            }
            if (valid)
            {
                resolutions[result.function_count].normal_band = a_band;
                resolutions[result.function_count].variant_band = b_band;
                HpLinkedFunction record =
                {
                    .name = member->name,
                    .object_symbol = index,
                    .object_offset = member->value,
                    .size = member->size
                };
                result.functions[result.function_count++] = record;
            }
        }
    }
    if (valid && (!has_anchor || base % 4096 != 0 || !hp_linked_address_range(base, hot->size + shift)))
    {
        valid = hp_linked_error(error, "linked hot contribution lost page alignment or address bounds");
    }
    HpBytes normal_bytes = { 0 };
    HpBytes variant_bytes = { 0 };
    const HpSection *normal_section = valid ? hp_linked_image_range(normal, base, hot->size, &normal_bytes) : NULL;
    const HpSection *variant_section = valid ? hp_linked_image_range(variant, base, hot->size + shift, &variant_bytes) : NULL;
    if (valid && (normal_section == NULL || variant_section == NULL))
    {
        valid = hp_linked_error(error, "hot contribution is not one file-backed executable range");
    }
    for (size_t index = 0; valid && index < result.function_count; index += 1)
    {
        HpLinkedFunction *record = result.functions + index;
        HpLinkedResolution *resolution = resolutions + index;
        if (record->object_offset > UINT64_MAX - base || shift > UINT64_MAX - (base + record->object_offset))
        {
            valid = hp_linked_error(error, "expected hot function address overflows");
        }
        if (valid)
        {
            uint64_t a_address = base + record->object_offset;
            uint64_t b_address = a_address + shift;
            resolution->normal = hp_linked_resolve(&normal_index, resolution->normal_band, a_address, base, hot->size);
            resolution->variant = hp_linked_resolve(&variant_index, resolution->variant_band, b_address, base, hot->size + shift);
            if (resolution->normal == NULL || resolution->variant == NULL)
            {
                valid = hp_linked_error(error, "missing or overlapping qualified hot function candidate");
            }
        }
        if (valid && (resolution->normal->section != normal_section->index || resolution->variant->section != variant_section->index))
        {
            valid = hp_linked_error(error, "owned function belongs to a different final contribution section");
        }
        if (valid)
        {
            record->normal_address = resolution->normal->value;
            record->variant_address = resolution->variant->value;
            record->delta = record->variant_address - record->normal_address;
            record->normal_residue_4096 = record->normal_address % 4096;
            record->variant_residue_4096 = record->variant_address % 4096;
        }
    }
    for (uint64_t index = 0; valid && index < shift; index += 1)
    {
        if (variant_bytes.data[(size_t)index] != 0)
        {
            valid = hp_linked_error(error, "inside padding was dropped or changed in final image");
        }
    }
    size_t operand_count = 0;
    for (size_t index = 0; valid && index < original_object->relocation_count; index += 1)
    {
        operand_count += original_object->relocations[index].target_section == hot->index;
    }
    if (valid && operand_count > SIZE_MAX / sizeof(*result.operands))
    {
        valid = hp_linked_error(error, "excessive hot relocation operands");
    }
    if (valid && operand_count != 0)
    {
        result.operands = calloc(operand_count, sizeof(*result.operands));
        if (result.operands == NULL)
        {
            valid = hp_linked_error(error, "hot operand allocation failed");
        }
    }
    for (size_t index = 0; valid && index < original_object->relocation_count; index += 1)
    {
        const HpRelocation *relocation = original_object->relocations + index;
        if (relocation->target_section == hot->index)
        {
            unsigned width = hp_elf_relocation_width(relocation->type);
            if (width == 0 || relocation->offset > hot->size || width > hot->size - relocation->offset)
            {
                valid = hp_linked_error(error, "unknown or out-of-range hot relocation operand");
            }
            else
            {
                HpLinkedOperand operand =
                {
                    .object_relocation = index,
                    .offset = relocation->offset,
                    .type = relocation->type,
                    .width = width
                };
                result.operands[result.operand_count++] = operand;
            }
        }
    }
    if (valid && result.operand_count > 1)
    {
        qsort(result.operands, result.operand_count, sizeof(*result.operands), hp_linked_operand_compare);
    }
    uint64_t cursor = 0;
    for (size_t index = 0; valid && index < result.operand_count; index += 1)
    {
        const HpLinkedOperand *operand = result.operands + index;
        if (operand->offset < cursor)
        {
            valid = hp_linked_error(error, "overlapping hot relocation operands");
        }
        else
        {
            size_t size = (size_t)(operand->offset - cursor);
            valid = memcmp(normal_bytes.data + (size_t)cursor, variant_bytes.data + (size_t)(shift + cursor), size) == 0;
            cursor = operand->offset + operand->width;
            result.masked_operand_bytes += operand->width;
            if (!valid)
            {
                valid = hp_linked_error(error, "linked hot bytes changed outside relocation operands");
            }
        }
    }
    if (valid && memcmp(normal_bytes.data + (size_t)cursor, variant_bytes.data + (size_t)(shift + cursor), (size_t)(hot->size - cursor)) != 0)
    {
        valid = hp_linked_error(error, "linked hot suffix changed outside relocation operands");
    }
    if (valid)
    {
        result.shift = shift;
        result.hot_input_base = base;
        result.hot_bytes = hot->size;
        result.hot_alignment = hot->align;
        result.normal_output_section = normal_section->name;
        result.variant_output_section = variant_section->name;
        *proof = result;
    }
    else
    {
        hp_linked_proof_free(&result);
    }
    free(normal_index.symbols);
    free(variant_index.symbols);
    free(resolutions);
    return valid;
}
