// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin.
// hp_pad_hot performs one inside-hot-section textual insertion. It does not
// claim assembly or layout equivalence: object and final-image gates follow.
// Context-changing macros, conditionals and section stacks are refused rather
// than interpreted; the existing producer emits explicit section selections.
#include "hp_pad.h"

#include <inttypes.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

static bool hp_pad_error(char error[BUSTER_HP_ERROR_CAPACITY], const char *message)
{
    if (error != NULL)
    {
        snprintf(error, BUSTER_HP_ERROR_CAPACITY, "%s", message);
    }
    return false;
}

static bool hp_pad_space(unsigned char value)
{
    return value == ' ' || value == '\t' || value == '\r' || value == '\v' || value == '\f';
}

static HpString hp_pad_trim(HpString text)
{
    while (text.size != 0 && hp_pad_space((unsigned char)text.data[0]))
    {
        text.data += 1;
        text.size -= 1;
    }
    while (text.size != 0 && hp_pad_space((unsigned char)text.data[text.size - 1]))
    {
        text.size -= 1;
    }
    return text;
}

static bool hp_pad_is(HpString text, const char *literal)
{
    size_t length = strlen(literal);
    return text.size == length && memcmp(text.data, literal, length) == 0;
}

static bool hp_pad_starts(HpString text, const char *literal)
{
    size_t length = strlen(literal);
    return text.size >= length && memcmp(text.data, literal, length) == 0;
}

static HpString hp_pad_word(HpString text)
{
    size_t end = 0;
    while (end < text.size && !hp_pad_space((unsigned char)text.data[end]) && text.data[end] != ';')
    {
        end += 1;
    }
    HpString result =
    {
        .data = text.data,
        .size = end
    };
    return result;
}

static bool hp_pad_unsupported(HpString word)
{
    bool result = hp_pad_is(word, ".pushsection") || hp_pad_is(word, ".popsection") || hp_pad_is(word, ".previous") || hp_pad_is(word, ".subsection") || hp_pad_is(word, ".macro") || hp_pad_is(word, ".endm") || hp_pad_is(word, ".else") || hp_pad_is(word, ".elseif") || hp_pad_is(word, ".endif") || hp_pad_is(word, ".rept") || hp_pad_is(word, ".endr") || hp_pad_is(word, ".irp") || hp_pad_is(word, ".irpc") || hp_pad_is(word, ".include") || hp_pad_is(word, ".incbin") || hp_pad_starts(word, ".if");
    return result;
}

static bool hp_pad_context(HpString word)
{
    bool result = hp_pad_unsupported(word) || hp_pad_is(word, ".section") || hp_pad_is(word, ".text") || hp_pad_is(word, ".data") || hp_pad_is(word, ".bss") || hp_pad_is(word, ".p2align");
    return result;
}

static HpString hp_pad_after_labels(HpString statement, bool *labelled)
{
    bool more = true;
    *labelled = false;
    while (more && statement.size != 0)
    {
        size_t index = 0;
        while (index < statement.size)
        {
            unsigned char value = (unsigned char)statement.data[index];
            bool label_char = (value >= 'a' && value <= 'z') || (value >= 'A' && value <= 'Z') || (value >= '0' && value <= '9') || value == '_' || value == '.' || value == '$';
            if (!label_char)
            {
                break;
            }
            index += 1;
        }
        size_t after = index;
        while (after < statement.size && hp_pad_space((unsigned char)statement.data[after]))
        {
            after += 1;
        }
        if (index != 0 && after < statement.size && statement.data[after] == ':')
        {
            statement.data += after + 1;
            statement.size -= after + 1;
            statement = hp_pad_trim(statement);
            *labelled = true;
        }
        else
        {
            more = false;
        }
    }
    return statement;
}

// Quoted # and ; are data, not comments or statement separators. A section or
// alignment directive sharing a physical line is refused, since insertion at
// the line boundary could otherwise put .skip in a different section.
static bool hp_pad_code(HpBytes line, HpString *code, char error[BUSTER_HP_ERROR_CAPACITY])
{
    bool valid = true;
    bool quoted = false;
    bool escaped = false;
    bool semicolon = false;
    size_t size = line.size;
    for (size_t index = 0; valid && index < size; index += 1)
    {
        unsigned char value = line.data[index];
        if (value == 0)
        {
            valid = hp_pad_error(error, "embedded NUL in generated assembly");
        }
        else if (escaped)
        {
            escaped = false;
        }
        else if (quoted && value == '\\')
        {
            escaped = true;
        }
        else if (value == '"')
        {
            quoted = !quoted;
        }
        else if (!quoted && value == '#')
        {
            size = index;
        }
        else if (!quoted && index + 1 < size && ((value == '/' && line.data[index + 1] == '*') || (value == '*' && line.data[index + 1] == '/')))
        {
            valid = hp_pad_error(error, "unsupported block-comment syntax in generated assembly");
        }
        else if (!quoted && value == ';')
        {
            semicolon = true;
        }
    }
    if (valid && quoted)
    {
        valid = hp_pad_error(error, "unterminated quoted assembly line");
    }
    HpString result =
    {
        .data = (const char *)line.data,
        .size = size
    };
    result = hp_pad_trim(result);
    if (valid && semicolon)
    {
        quoted = false;
        escaped = false;
        size_t begin = 0;
        for (size_t index = 0; valid && index <= result.size; index += 1)
        {
            unsigned char value = index < result.size ? (unsigned char)result.data[index] : ';';
            if (escaped)
            {
                escaped = false;
            }
            else if (quoted && value == '\\')
            {
                escaped = true;
            }
            else if (value == '"')
            {
                quoted = !quoted;
            }
            else if (!quoted && value == ';')
            {
                HpString statement =
                {
                    .data = result.data + begin,
                    .size = index - begin
                };
                statement = hp_pad_trim(statement);
                bool labelled = false;
                statement = hp_pad_after_labels(statement, &labelled);
                if (hp_pad_context(hp_pad_word(statement)))
                {
                    valid = hp_pad_error(error, "section, alignment or macro directive shares a physical line");
                }
                begin = index + 1;
            }
        }
    }
    *code = result;
    return valid;
}

static bool hp_pad_section_char(unsigned char value)
{
    bool result = (value >= 'a' && value <= 'z') || (value >= 'A' && value <= 'Z') || (value >= '0' && value <= '9') || value == '_' || value == '.' || value == '$' || value == '-';
    return result;
}

static bool hp_pad_section(HpString code, bool *hot, char error[BUSTER_HP_ERROR_CAPACITY])
{
    bool valid = true;
    code.data += sizeof(".section") - 1;
    code.size -= sizeof(".section") - 1;
    if (code.size == 0 || !hp_pad_space((unsigned char)code.data[0]))
    {
        valid = hp_pad_error(error, "section directive requires a separated section name");
    }
    code = hp_pad_trim(code);
    HpString name =
    {
        .data = code.data,
        .size = 0
    };
    size_t used = 0;
    if (valid && code.size != 0 && code.data[0] == '"')
    {
        used = 1;
        while (used < code.size && code.data[used] != '"' && code.data[used] != '\\')
        {
            used += 1;
        }
        valid = used < code.size && code.data[used] == '"' && used > 1;
        if (valid)
        {
            name.data = code.data + 1;
            name.size = used - 1;
            used += 1;
        }
    }
    else if (valid)
    {
        while (used < code.size && hp_pad_section_char((unsigned char)code.data[used]))
        {
            used += 1;
        }
        name.size = used;
        valid = used != 0;
    }
    if (valid)
    {
        code.data += used;
        code.size -= used;
        code = hp_pad_trim(code);
        valid = code.size == 0 || code.data[0] == ',';
    }
    if (!valid)
    {
        valid = hp_pad_error(error, "unrecognized section-selection syntax");
    }
    else
    {
        *hot = hp_pad_is(name, ".text.buster_checker");
    }
    return valid;
}

static bool hp_pad_simple_section(HpString code, HpString word, char error[BUSTER_HP_ERROR_CAPACITY])
{
    code.data += word.size;
    code.size -= word.size;
    code = hp_pad_trim(code);
    bool valid = code.size == 0 || hp_pad_is(code, "0");
    if (!valid)
    {
        valid = hp_pad_error(error, "unsupported nonzero or malformed ordinary subsection");
    }
    return valid;
}

static bool hp_pad_alignment(HpString code)
{
    code.data += sizeof(".p2align") - 1;
    code.size -= sizeof(".p2align") - 1;
    code = hp_pad_trim(code);
    return hp_pad_is(code, "12");
}

bool hp_pad_hot(HpBytes input, uint64_t shift, unsigned char **output, size_t *output_size, size_t *anchor_line, char error[BUSTER_HP_ERROR_CAPACITY])
{
    bool valid = output != NULL && output_size != NULL && anchor_line != NULL && error != NULL;
    if (output != NULL)
    {
        *output = NULL;
    }
    if (output_size != NULL)
    {
        *output_size = 0;
    }
    if (anchor_line != NULL)
    {
        *anchor_line = 0;
    }
    if (error != NULL)
    {
        error[0] = 0;
    }
    if (!valid)
    {
        valid = hp_pad_error(error, "missing output or error storage");
    }
    if (valid && shift != 0 && shift != 16 && shift != 64 && shift != 256 && shift != 1024 && shift != 2048)
    {
        valid = hp_pad_error(error, "unapproved inside shift");
    }
    char insertion[64];
    int inserted = valid && shift != 0 ? snprintf(insertion, sizeof(insertion), "\t.skip\t%" PRIu64 "\n", shift) : 0;
    if (valid && (inserted < 0 || (size_t)inserted >= sizeof(insertion) || input.size > SIZE_MAX - (size_t)inserted - 1 || (input.size != 0 && input.data == NULL)))
    {
        valid = hp_pad_error(error, "input or insertion size is invalid");
    }
    if (valid && input.size != 0 && memchr(input.data, 0, input.size) != NULL)
    {
        valid = hp_pad_error(error, "embedded NUL in generated assembly");
    }
    bool hot = false;
    bool seen_content = false;
    size_t anchors = 0;
    size_t anchor_after = 0;
    size_t anchor_number = 0;
    size_t number = 0;
    for (size_t begin = 0; valid && begin < input.size; )
    {
        size_t end = begin;
        while (end < input.size && input.data[end] != '\n')
        {
            end += 1;
        }
        bool newline = end < input.size;
        size_t next = end + (newline ? 1 : 0);
        number += 1;
        HpBytes line =
        {
            .data = input.data + begin,
            .size = end - begin
        };
        HpString code = { 0 };
        valid = hp_pad_code(line, &code, error);
        HpString word = hp_pad_word(code);
        bool labelled = false;
        HpString after_labels = hp_pad_after_labels(code, &labelled);
        if (valid && code.size != 0)
        {
            if (labelled && hp_pad_context(hp_pad_word(after_labels)))
            {
                valid = hp_pad_error(error, "section, alignment or macro directive follows a label");
            }
            else if (hp_pad_unsupported(word))
            {
                valid = hp_pad_error(error, "unsupported section stack, macro, conditional or include directive");
            }
            else if (hp_pad_is(word, ".section"))
            {
                valid = hp_pad_section(code, &hot, error);
            }
            else if (hp_pad_is(word, ".text") || hp_pad_is(word, ".data") || hp_pad_is(word, ".bss"))
            {
                valid = hp_pad_simple_section(code, word, error);
                hot = false;
            }
            else if (hp_pad_starts(word, ".section"))
            {
                valid = hp_pad_error(error, "unrecognized section-selection directive");
            }
            else if (hot)
            {
                if (hp_pad_is(word, ".p2align") && hp_pad_alignment(code))
                {
                    if (seen_content || !newline)
                    {
                        valid = hp_pad_error(error, "hot page alignment follows content or lacks newline");
                    }
                    else
                    {
                        anchors += 1;
                        anchor_after = next;
                        anchor_number = number;
                    }
                }
                else
                {
                    seen_content = true;
                }
            }
        }
        begin = next;
    }
    if (valid && anchors != 1)
    {
        valid = hp_pad_error(error, "requires exactly one initial hot page-alignment anchor");
    }
    unsigned char *result = NULL;
    size_t result_size = input.size + (size_t)inserted;
    if (valid)
    {
        result = malloc(result_size + 1);
        if (result == NULL)
        {
            valid = hp_pad_error(error, "output allocation failed");
        }
    }
    if (valid)
    {
        memcpy(result, input.data, anchor_after);
        if (inserted != 0)
        {
            memcpy(result + anchor_after, insertion, (size_t)inserted);
        }
        memcpy(result + anchor_after + (size_t)inserted, input.data + anchor_after, input.size - anchor_after);
        result[result_size] = 0;
        *output = result;
        *output_size = result_size;
        *anchor_line = anchor_number;
    }
    return valid;
}
