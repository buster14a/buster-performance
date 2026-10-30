// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin.
// One observed assembly spelling is replaced with the original direct-object
// bytes. All inputs stay immutable. This is neither a binary patch nor a waiver
// of the subsequent complete object and whole-image identity gates.
#include "hp_normalize.h"
#include "hp_pad.h"

#include <elf.h>
#include <inttypes.h>
#include <stdlib.h>
#include <string.h>

typedef struct HpNormalizeLine HpNormalizeLine;
struct HpNormalizeLine
{
    HpBytes body;
    size_t offset;
    size_t number;
    size_t start;
    size_t end;
    bool separator;
};

static bool normalize_error(char error[BUSTER_HP_ERROR_CAPACITY], const char *message)
{
    if (error != NULL)
    {
        hp_error(error, "%s", message);
    }
    return false;
}

static bool normalize_digest(const char *value)
{
    bool valid = value != NULL;
    for (size_t index = 0; valid && index < 64; index += 1)
    {
        valid = (value[index] >= '0' && value[index] <= '9') || (value[index] >= 'a' && value[index] <= 'f');
    }
    valid = valid && value[64] == 0;
    return valid;
}

static const char *normalize_profile(const char *source, const char *normal)
{
    const char *profile = NULL;
    if (normalize_digest(source) && normalize_digest(normal))
    {
        if (strcmp(source, BUSTER_HP_NORMALIZE_BASE_SOURCE) == 0 && strcmp(normal, BUSTER_HP_NORMALIZE_BASE_NORMAL) == 0)
        {
            profile = "base";
        }
        else if (strcmp(source, BUSTER_HP_NORMALIZE_CANDIDATE_SOURCE) == 0 && strcmp(normal, BUSTER_HP_NORMALIZE_CANDIDATE_NORMAL) == 0)
        {
            profile = "candidate";
        }
    }
    return profile;
}

bool hp_normalize_pair_supported(const char *source_manifest_sha, const char *qualified_normal_sha)
{
    return normalize_profile(source_manifest_sha, qualified_normal_sha) != NULL;
}

static bool normalize_space(unsigned char byte)
{
    return byte == ' ' || byte == '\t';
}

static bool normalize_line(HpBytes input, size_t *position, size_t number, HpNormalizeLine *line)
{
    line->offset = *position;
    line->number = number;
    size_t end = *position;
    bool valid = true;
    bool quote = false;
    bool escape = false;
    size_t comment = SIZE_MAX;
    while (valid && end < input.size && input.data[end] != '\n')
    {
        unsigned char byte = input.data[end];
        valid = byte == '\t' || (byte >= 32 && byte != 127);
        if (!quote && byte == '#' && comment == SIZE_MAX)
        {
            comment = end;
        }
        if (comment == SIZE_MAX)
        {
            line->separator = line->separator || (!quote && byte == ';');
            if (escape)
            {
                escape = false;
            }
            else if (quote && byte == '\\')
            {
                escape = true;
            }
            else if (byte == '"')
            {
                quote = !quote;
            }
        }
        end += 1;
    }
    valid = valid && !quote && !escape;
    *position = end + (end < input.size);
    size_t start = line->offset;
    end = comment != SIZE_MAX ? comment : end;
    while (start < end && normalize_space(input.data[start]))
    {
        start += 1;
    }
    while (end > start && normalize_space(input.data[end - 1]))
    {
        end -= 1;
    }
    line->start = start;
    line->end = end;
    line->body = (HpBytes){ input.data + start, end - start };
    return valid;
}

static bool normalize_is(HpBytes value, const char *text)
{
    size_t size = strlen(text);
    return value.size == size && memcmp(value.data, text, size) == 0;
}

static bool normalize_prefix(HpBytes value, const char *text)
{
    size_t size = strlen(text);
    return value.size >= size && memcmp(value.data, text, size) == 0;
}

static bool normalize_word(HpBytes value, const char *word)
{
    size_t size = strlen(word);
    return normalize_prefix(value, word) && (value.size == size || normalize_space(value.data[size]));
}

static void normalize_skip_space(HpBytes body, size_t *position)
{
    while (*position < body.size && normalize_space(body.data[*position]))
    {
        *position += 1;
    }
    return;
}

static bool normalize_atom(HpBytes body, size_t *position, const char *atom)
{
    size_t size = strlen(atom);
    bool valid = *position <= body.size && size <= body.size - *position && memcmp(body.data + *position, atom, size) == 0;
    if (valid)
    {
        *position += size;
    }
    return valid;
}

static bool normalize_instruction(HpBytes body, const char *word, const char *compact)
{
    size_t word_size = strlen(word);
    bool valid = normalize_word(body, word) && strlen(compact) >= word_size && strncmp(compact, word, word_size) == 0;
    size_t position = word_size;
    normalize_skip_space(body, &position);
    valid = valid && position > word_size;
    // Operand atoms stay contiguous. Whitespace may separate the opcode and
    // operands, or surround commas; it must not merge split symbols/registers.
    for (size_t expected = word_size; valid && compact[expected] != 0; expected += 1)
    {
        if (compact[expected] == ',')
        {
            normalize_skip_space(body, &position);
        }
        valid = position < body.size && body.data[position] == (unsigned char)compact[expected];
        if (valid)
        {
            position += 1;
            if (compact[expected] == ',')
            {
                normalize_skip_space(body, &position);
            }
        }
    }
    normalize_skip_space(body, &position);
    valid = valid && position == body.size;
    return valid;
}

static bool normalize_number(HpBytes value, size_t *position, uint64_t *output)
{
    size_t start = *position;
    uint64_t number = 0;
    bool valid = true;
    while (valid && *position < value.size && value.data[*position] >= '0' && value.data[*position] <= '9')
    {
        uint64_t digit = value.data[(*position)++] - '0';
        valid = number < UINT64_MAX / 10 || (number == UINT64_MAX / 10 && digit <= UINT64_MAX % 10);
        if (valid)
        {
            number = number * 10 + digit;
        }
    }
    valid = valid && *position > start && (*position - start == 1 || value.data[start] != '0');
    if (valid)
    {
        *output = number;
    }
    return valid;
}

static bool normalize_definition(HpBytes body, HpBytes *name, HpBytes *tail, bool *quoted)
{
    size_t position = 0;
    *quoted = body.size != 0 && body.data[0] == '"';
    if (*quoted)
    {
        position = 1;
        bool escaped = false;
        bool closed = false;
        while (!closed && position < body.size)
        {
            unsigned char byte = body.data[position++];
            closed = byte == '"' && !escaped;
            escaped = byte == '\\' && !escaped;
        }
    }
    else
    {
        while (position < body.size && !normalize_space(body.data[position]) && body.data[position] != ':')
        {
            position += 1;
        }
    }
    *name = (HpBytes){ body.data, position };
    *quoted = *quoted || memchr(name->data, '\\', name->size) != NULL;
    while (position < body.size && normalize_space(body.data[position]))
    {
        position += 1;
    }
    bool valid = name->size != 0 && position < body.size && body.data[position] == ':';
    if (valid)
    {
        position += 1;
        while (position < body.size && normalize_space(body.data[position]))
        {
            position += 1;
        }
        *tail = (HpBytes){ body.data + position, body.size - position };
    }
    return valid;
}

static bool normalize_local_name(HpBytes name, bool block, uint64_t *function, uint64_t *number)
{
    const char *prefix = block ? ".LBB" : ".Lfunc_end";
    size_t position = strlen(prefix);
    bool valid = normalize_prefix(name, prefix) && normalize_number(name, &position, function);
    if (block)
    {
        valid = valid && position < name.size && name.data[position++] == '_' && normalize_number(name, &position, number);
    }
    valid = valid && position == name.size;
    return valid;
}

static bool normalize_local(HpBytes body, bool block, uint64_t *function, uint64_t *number)
{
    HpBytes name = { 0 };
    HpBytes tail = { 0 };
    bool quoted = false;
    bool valid = normalize_definition(body, &name, &tail, &quoted) && !quoted && tail.size == 0 && name.size + 1 == body.size && normalize_local_name(name, block, function, number);
    return valid;
}

static bool normalize_size(HpBytes body, uint64_t *function)
{
    size_t position = sizeof(".size") - 1;
    bool valid = normalize_word(body, ".size");
    normalize_skip_space(body, &position);
    valid = valid && position > sizeof(".size") - 1 && normalize_atom(body, &position, BUSTER_HP_NORMALIZE_FUNCTION);
    normalize_skip_space(body, &position);
    valid = valid && normalize_atom(body, &position, ",");
    normalize_skip_space(body, &position);
    valid = valid && normalize_atom(body, &position, ".Lfunc_end") && normalize_number(body, &position, function);
    normalize_skip_space(body, &position);
    valid = valid && normalize_atom(body, &position, "-");
    normalize_skip_space(body, &position);
    valid = valid && normalize_atom(body, &position, BUSTER_HP_NORMALIZE_FUNCTION);
    normalize_skip_space(body, &position);
    valid = valid && position == body.size;
    return valid;
}

static bool normalize_target(HpBytes body, const char *directive)
{
    size_t position = strlen(directive);
    bool valid = normalize_word(body, directive);
    while (valid && position < body.size && normalize_space(body.data[position]))
    {
        position += 1;
    }
    size_t size = sizeof(BUSTER_HP_NORMALIZE_FUNCTION) - 1;
    valid = valid && size <= body.size - position && memcmp(body.data + position, BUSTER_HP_NORMALIZE_FUNCTION, size) == 0;
    position += valid ? size : 0;
    valid = valid && (position == body.size || body.data[position] == ',' || normalize_space(body.data[position]));
    return valid;
}

static bool normalize_metadata_plain(HpBytes body)
{
    bool metadata = normalize_word(body, ".type") || normalize_word(body, ".size");
    bool valid = true;
    if (metadata)
    {
        size_t position = sizeof(".type") - 1;
        normalize_skip_space(body, &position);
        size_t start = position;
        while (valid && position < body.size && !normalize_space(body.data[position]) && body.data[position] != ',')
        {
            unsigned char byte = body.data[position++];
            valid = byte != '"' && byte != '\'' && byte != '\\';
        }
        valid = valid && position > start;
    }
    return valid;
}

static bool normalize_assembly(HpBytes raw, HpNormalizationProof *proof, char error[BUSTER_HP_ERROR_CAPACITY])
{
    // Reuse the reviewed envelope's fail-closed handling of macro/conditional/
    // section-stack/subsection/include syntax and hidden section directives.
    unsigned char *envelope = NULL;
    size_t envelope_size = 0;
    size_t anchor = 0;
    bool valid = hp_pad_hot(raw, 0, &envelope, &envelope_size, &anchor, error);
    free(envelope);
    bool text = false;
    bool typed = false;
    bool labelled = false;
    bool sized = false;
    bool ended = false;
    size_t matches = 0;
    unsigned context = 0;
    uint64_t stem = 0;
    bool have_stem = false;
    uint64_t blocks[4096] = { 0 };
    size_t block_count = 0;
    HpBytes previous = { 0 };
    size_t position = 0;
    size_t number = 0;
    while (valid && position < raw.size)
    {
        HpNormalizeLine line = { 0 };
        valid = normalize_line(raw, &position, ++number, &line);
        HpBytes body = line.body;
        HpBytes label_name = { 0 };
        HpBytes label_tail = { 0 };
        bool quoted_label = false;
        bool definition = normalize_definition(body, &label_name, &label_tail, &quoted_label);
        bool inside = labelled && !sized;
        bool target_size = normalize_target(body, ".size");
        if (!valid || body.size == 0)
        {
            continue;
        }
        // Multiple assembler statements are outside this narrow profile. A
        // later statement must not hide a second relevant label definition.
        valid = valid && !line.separator;
        // Quoted/escaped symbol definitions are outside this generated-assembly
        // profile; do not silently miss an alternate spelling of a target.
        valid = valid && (!definition || !quoted_label);
        // The selected generated function uses separate pure label lines.
        // Refuse chains/trailing statements there instead of letting a later
        // BB definition evade its function-stem and duplicate checks.
        valid = valid && (!inside || !definition || label_tail.size == 0);
        HpBytes instruction = body;
        HpBytes leading_name = { 0 };
        HpBytes leading_tail = { 0 };
        bool leading_quoted = false;
        bool leading_labels = false;
        while (valid && normalize_definition(instruction, &leading_name, &leading_tail, &leading_quoted))
        {
            valid = !leading_quoted;
            leading_labels = true;
            instruction = leading_tail;
        }
        // Quoted/escaped metadata operands can name the same symbol through an
        // alternate spelling. They are outside this plain-symbol profile too.
        valid = valid && normalize_metadata_plain(instruction);
        // A self-FADD after any leading definitions is an additional candidate,
        // not an unrelated label line. Its inline form is unsupported globally.
        if (valid && leading_labels && (normalize_instruction(instruction, "fadd", "fadd%st,%st(0)") || normalize_target(instruction, ".type") || normalize_target(instruction, ".size")))
        {
            valid = false;
        }
        if (inside && ended && !target_size)
        {
            valid = false;
        }
        if (valid && context > 0 && context < 4)
        {
            if (context == 1)
            {
                valid = inside && normalize_local(body, true, &proof->function_label_id, &proof->basic_block_id);
            }
            else
            {
                valid = normalize_instruction(body, context == 2 ? "fstpt" : "fldt", context == 2 ? "fstpt1264(%rsp)" : "fldt1072(%rsp)");
            }
            context += valid;
        }
        if (valid && (normalize_word(body, ".text") || normalize_word(body, ".section") || normalize_word(body, ".data") || normalize_word(body, ".bss")))
        {
            text = normalize_is(body, ".text");
            valid = !inside;
        }
        if (valid && normalize_target(body, ".type"))
        {
            valid = text && !typed && !labelled && normalize_instruction(body, ".type", ".type" BUSTER_HP_NORMALIZE_FUNCTION ",@function");
            typed = valid;
        }
        else if (valid && inside && normalize_word(body, ".type"))
        {
            valid = false;
        }
        if (valid && definition && normalize_is(label_name, BUSTER_HP_NORMALIZE_FUNCTION))
        {
            valid = text && typed && !labelled && normalize_is(body, BUSTER_HP_NORMALIZE_FUNCTION ":");
            labelled = valid;
        }
        else if (valid && inside && definition && label_name.data[0] != '.')
        {
            valid = false;
        }
        if (valid && inside)
        {
            HpBytes remaining = body;
            HpBytes name = { 0 };
            HpBytes tail = { 0 };
            bool quoted = false;
            while (valid && normalize_definition(remaining, &name, &tail, &quoted))
            {
                valid = !quoted && name.data[0] == '.';
                remaining = tail;
            }
        }
        if (valid && inside && normalize_prefix(body, ".LBB"))
        {
            uint64_t function = 0;
            uint64_t block = 0;
            valid = normalize_local(body, true, &function, &block) && block_count < sizeof(blocks) / sizeof(blocks[0]) && (!have_stem || function == stem);
            for (size_t index = 0; valid && index < block_count; index += 1)
            {
                valid = blocks[index] != block;
            }
            if (valid)
            {
                stem = function;
                have_stem = true;
                blocks[block_count++] = block;
            }
        }
        if (valid && normalize_instruction(body, "fadd", "fadd%st,%st(0)"))
        {
            matches += 1;
            valid = inside && text && !ended && matches == 1 && context == 0 && normalize_instruction(previous, "callq", "callq__floatuntixf@PLT");
            if (valid)
            {
                proof->assembly_line = line.number;
                proof->assembly_line_offset = line.offset;
                proof->instruction_offset = line.start;
                proof->instruction_size = line.end - line.start;
                context = 1;
            }
        }
        if (valid && inside && normalize_prefix(body, ".Lfunc_end"))
        {
            uint64_t function = 0;
            uint64_t unused = 0;
            valid = !ended && context == 4 && normalize_local(body, false, &function, &unused) && have_stem && function == stem && function == proof->function_label_id;
            ended = valid;
        }
        if (valid && target_size)
        {
            uint64_t function = 0;
            valid = text && inside && ended && !sized && normalize_size(body, &function) && function == stem;
            sized = valid;
        }
        previous = body;
    }
    valid = valid && typed && labelled && sized && ended && matches == 1 && context == 4;
    // The selected local labels must be globally unique too, rather than being
    // rebound by a duplicate definition outside the selected function scope.
    size_t selected_blocks = 0;
    size_t selected_ends = 0;
    size_t selected_functions = 0;
    position = 0;
    number = 0;
    while (valid && position < raw.size)
    {
        HpNormalizeLine line = { 0 };
        valid = normalize_line(raw, &position, ++number, &line);
        HpBytes remaining = line.body;
        HpBytes name = { 0 };
        HpBytes tail = { 0 };
        bool quoted = false;
        // Definition recognition accepts whitespace before ':' and visits
        // chained labels too. Primary context remains strict, but duplicate
        // definitions must not hide behind an alternate assembler spelling.
        while (valid && normalize_definition(remaining, &name, &tail, &quoted))
        {
            valid = !quoted;
            uint64_t function = 0;
            uint64_t block = 0;
            selected_functions += normalize_is(name, BUSTER_HP_NORMALIZE_FUNCTION);
            if (normalize_local_name(name, true, &function, &block))
            {
                selected_blocks += function == proof->function_label_id && block == proof->basic_block_id;
            }
            if (normalize_local_name(name, false, &function, &block))
            {
                selected_ends += function == proof->function_label_id;
            }
            remaining = tail;
        }
    }
    valid = valid && selected_functions == 1 && selected_blocks == 1 && selected_ends == 1;
    if (!valid)
    {
        normalize_error(error, "unsupported or ambiguous scoped assembly normalization context");
    }
    return valid;
}

static bool normalize_object(HpBytes bytes, HpNormalizationProof *proof, char error[BUSTER_HP_ERROR_CAPACITY])
{
    HpElf object = { 0 };
    bool valid = hp_elf_read(bytes, &object, error) && object.elf_type == ET_REL && object.program_count == 0 && object.entry == 0;
    const HpSection *text = valid ? hp_elf_section_named(&object, ".text") : NULL;
    valid = valid && text != NULL && text->type == SHT_PROGBITS && text->flags == (SHF_ALLOC | SHF_EXECINSTR) && text->addr == 0 && text->align == 16 && text->size == text->bytes.size;
    const HpSymbol *member = NULL;
    size_t members = 0;
    size_t tables = 0;
    for (size_t index = 0; valid && index < object.section_count; index += 1)
    {
        tables += object.sections[index].type == SHT_SYMTAB;
        valid = object.sections[index].type != SHT_DYNSYM;
    }
    for (size_t index = 0; valid && index < object.symbol_count; index += 1)
    {
        if (hp_string_is(object.symbols[index].name, BUSTER_HP_NORMALIZE_FUNCTION))
        {
            members += 1;
            member = object.symbols + index;
            proof->object_symbol = index;
        }
    }
    valid = valid && tables == 1 && members == 1 && member->type == STT_FUNC && member->bind == STB_LOCAL && member->other == STV_DEFAULT && member->section == text->index && object.sections[member->table].type == SHT_SYMTAB && member->size == BUSTER_HP_NORMALIZE_FUNCTION_SIZE && member->value <= text->size && member->size <= text->size - member->value;
    uint64_t site = valid ? member->value + BUSTER_HP_NORMALIZE_FUNCTION_SITE : 0;
    static const unsigned char context[] =
    {
        0xe8, 0x00, 0x00, 0x00, 0x00,
        0xdc, 0xc0,
        0xdb, 0xbc, 0x24, 0xf0, 0x04, 0x00, 0x00,
        0xdb, 0xac, 0x24, 0x30, 0x04, 0x00, 0x00
    };
    valid = valid && site >= 5 && site - 5 <= text->bytes.size && sizeof(context) <= text->bytes.size - (size_t)(site - 5) && memcmp(text->bytes.data + (size_t)(site - 5), context, sizeof(context)) == 0;
    size_t calls = 0;
    for (size_t index = 0; valid && index < object.relocation_count; index += 1)
    {
        const HpRelocation *relocation = object.relocations + index;
        if (relocation->target_section == text->index)
        {
            unsigned width = hp_elf_relocation_width(relocation->type);
            valid = width != 0 && relocation->offset <= text->size && width <= text->size - relocation->offset;
            bool overlap = valid && relocation->offset < site + 16 && relocation->offset + width > site - 5;
            if (overlap)
            {
                const HpSymbol *target = object.symbols + relocation->symbol;
                valid = relocation->offset == site - 4 && relocation->type == R_X86_64_PLT32 && width == 4 && relocation->addend == -4 && target->table == member->table && target->bind == STB_GLOBAL && target->type == STT_NOTYPE && target->other == STV_DEFAULT && target->section == SHN_UNDEF && target->value == 0 && target->size == 0 && hp_string_is(target->name, "__floatuntixf");
                if (valid)
                {
                    calls += 1;
                    proof->call_relocation = index;
                    proof->call_relocation_offset = relocation->offset;
                    proof->call_relocation_type = relocation->type;
                    proof->call_relocation_addend = relocation->addend;
                }
            }
        }
    }
    valid = valid && calls == 1 && text->offset <= UINT64_MAX - site;
    if (valid)
    {
        proof->object_section = text->index;
        proof->function_value = member->value;
        proof->function_size = member->size;
        proof->function_site = BUSTER_HP_NORMALIZE_FUNCTION_SITE;
        proof->section_site = site;
        proof->object_file_site = text->offset + site;
        proof->preimage[0] = 0xdc;
        proof->preimage[1] = 0xc0;
    }
    else
    {
        normalize_error(error, "unsupported direct-object normalization symbol, bytes or relocation context");
    }
    hp_elf_free(&object);
    return valid;
}

bool hp_normalize_checker(HpBytes raw_s, HpBytes direct_object, const char *source_manifest_sha, const char *qualified_normal_sha, HpBuffer *canonical, HpNormalizationProof *proof, char error[BUSTER_HP_ERROR_CAPACITY])
{
    HpNormalizationProof result = { 0 };
    if (error != NULL)
    {
        error[0] = 0;
    }
    bool valid = canonical != NULL && proof != NULL && error != NULL && canonical->data == NULL && canonical->size == 0 && raw_s.data != NULL && raw_s.size != 0 && raw_s.size <= BUSTER_HP_FILE_LIMIT && direct_object.data != NULL && direct_object.size != 0 && direct_object.size <= BUSTER_HP_FILE_LIMIT;
    if (proof != NULL)
    {
        memset(proof, 0, sizeof(*proof));
    }
    const char *profile = normalize_profile(source_manifest_sha, qualified_normal_sha);
    valid = valid && profile != NULL;
    if (valid)
    {
        valid = normalize_assembly(raw_s, &result, error) && normalize_object(direct_object, &result, error);
    }
    static const char directive[] = ".byte\t0xdc, 0xc0";
    size_t size = 0;
    unsigned char *output = NULL;
    if (valid)
    {
        valid = result.instruction_offset <= raw_s.size && result.instruction_size <= raw_s.size - result.instruction_offset && raw_s.size - result.instruction_size <= SIZE_MAX - sizeof(directive);
        if (valid)
        {
            size = raw_s.size - result.instruction_size + sizeof(directive) - 1;
            output = malloc(size + 1);
            valid = output != NULL;
        }
    }
    if (valid)
    {
        memcpy(output, raw_s.data, result.instruction_offset);
        memcpy(output + result.instruction_offset, directive, sizeof(directive) - 1);
        memcpy(output + result.instruction_offset + sizeof(directive) - 1, raw_s.data + result.instruction_offset + result.instruction_size, raw_s.size - result.instruction_offset - result.instruction_size);
        output[size] = 0;
        result.profile = profile;
        memcpy(result.source_manifest_sha256, source_manifest_sha, 65);
        memcpy(result.qualified_normal_sha256, qualified_normal_sha, 65);
        result.edits = 1;
        *canonical = (HpBuffer){ output, size };
        *proof = result;
    }
    else
    {
        free(output);
        if (error != NULL && error[0] == 0)
        {
            normalize_error(error, "unsupported normalization pair, storage, input or splice bounds");
        }
    }
    return valid;
}

bool hp_normalization_write(FILE *output, const HpNormalizationProof *proof, const char *raw_sha, const char *canonical_sha, const char *object_sha, char error[BUSTER_HP_ERROR_CAPACITY])
{
    if (error != NULL)
    {
        error[0] = 0;
    }
    bool valid = output != NULL && proof != NULL && error != NULL && normalize_digest(raw_sha) && normalize_digest(canonical_sha) && normalize_digest(object_sha);
    const char *profile = valid ? normalize_profile(proof->source_manifest_sha256, proof->qualified_normal_sha256) : NULL;
    valid = valid && profile != NULL && proof->profile != NULL && strcmp(proof->profile, profile) == 0 && proof->edits == 1 && proof->assembly_line > 0 && proof->instruction_size > 0 && proof->instruction_offset >= proof->assembly_line_offset && proof->function_size == BUSTER_HP_NORMALIZE_FUNCTION_SIZE && proof->function_site == BUSTER_HP_NORMALIZE_FUNCTION_SITE && proof->function_value <= UINT64_MAX - proof->function_size && proof->section_site == proof->function_value + proof->function_site && proof->object_file_site >= proof->section_site && proof->section_site >= 5 && proof->call_relocation_offset == proof->section_site - 4 && proof->call_relocation_type == R_X86_64_PLT32 && proof->call_relocation_addend == -4 && proof->preimage[0] == 0xdc && proof->preimage[1] == 0xc0;
    if (valid)
    {
        fprintf(output, "{\n  \"kind\": \"one guarded checker assembly encoding\",\n  \"profile\": \"%s\",\n  \"source_manifest_sha256\": \"%s\",\n  \"qualified_normal_sha256\": \"%s\",\n  \"raw_assembly_sha256\": \"%s\",\n  \"canonical_assembly_sha256\": \"%s\",\n  \"direct_object_sha256\": \"%s\",\n", profile, proof->source_manifest_sha256, proof->qualified_normal_sha256, raw_sha, canonical_sha, object_sha);
        fprintf(output, "  \"function\": \"%s\",\n  \"section\": \".text\",\n  \"edits\": %zu,\n  \"assembly_line\": %zu,\n  \"assembly_line_offset\": %zu,\n  \"instruction_offset\": %zu,\n  \"instruction_size\": %zu,\n  \"function_label_id\": %" PRIu64 ",\n  \"basic_block_id\": %" PRIu64 ",\n", BUSTER_HP_NORMALIZE_FUNCTION, proof->edits, proof->assembly_line, proof->assembly_line_offset, proof->instruction_offset, proof->instruction_size, proof->function_label_id, proof->basic_block_id);
        fprintf(output, "  \"object_symbol\": %zu,\n  \"object_section\": %u,\n  \"function_value\": %" PRIu64 ",\n  \"function_size\": %" PRIu64 ",\n  \"function_site\": %" PRIu64 ",\n  \"section_site\": %" PRIu64 ",\n  \"object_file_site\": %" PRIu64 ",\n  \"call_relocation\": %zu,\n  \"call_relocation_offset\": %" PRIu64 ",\n  \"call_relocation_type\": %u,\n  \"call_relocation_addend\": %" PRId64 ",\n", proof->object_symbol, proof->object_section, proof->function_value, proof->function_size, proof->function_site, proof->section_site, proof->object_file_site, proof->call_relocation, proof->call_relocation_offset, proof->call_relocation_type, proof->call_relocation_addend);
        fputs("  \"direct_preimage\": \"dc c0\",\n  \"canonical_directive\": \".byte 0xdc, 0xc0\",\n  \"scope\": \"caller verifies exact digests; full object and strict zero-image SHA gates remain required; no binary patch or producer execution\"\n}\n", output);
        valid = ferror(output) == 0;
    }
    if (!valid)
    {
        normalize_error(error, "invalid normalization receipt binding or stream failure");
    }
    return valid;
}
