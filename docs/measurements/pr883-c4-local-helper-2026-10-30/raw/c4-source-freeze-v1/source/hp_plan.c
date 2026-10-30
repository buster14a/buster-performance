// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin.
// First-party in-memory validation and command planning. Every operand remains
// one argv entry. This module never interprets command text or starts a process.
#include "hp_plan.h"

#include <string.h>

static bool hp_plan_error(char error[BUSTER_HP_ERROR_CAPACITY], const char *message)
{
    if (error != NULL)
    {
        hp_error(error, "%s", message);
    }
    return false;
}

static bool hp_plan_text(const char *text, size_t *size)
{
    size_t length = 0;
    bool valid = text != NULL;
    while (valid && length < BUSTER_HP_PATH_CAPACITY && text[length] != 0)
    {
        unsigned char byte = (unsigned char)text[length];
        valid = byte >= 32 && byte != 127;
        length += 1;
    }
    valid = valid && length != 0 && length < BUSTER_HP_PATH_CAPACITY;
    if (size != NULL)
    {
        *size = valid ? length : 0;
    }
    return valid;
}

static bool hp_plan_file(const char *text)
{
    bool valid = hp_plan_text(text, NULL);
    valid = valid && text[0] != '-' && text[0] != '@';
    return valid;
}

static bool hp_plan_source(const char *text)
{
    size_t length = 0;
    bool valid = hp_plan_file(text) && hp_plan_text(text, &length);
    valid = valid && text[0] != '/' && length >= 3 && text[length - 2] == '.' && text[length - 1] == 'c';
    size_t start = 0;
    for (size_t index = 0; valid && index <= length; index += 1)
    {
        if (index == length || text[index] == '/')
        {
            size_t size = index - start;
            valid = size != 0 && !(size == 1 && text[start] == '.') && !(size == 2 && text[start] == '.' && text[start + 1] == '.');
            start = index + 1;
        }
        else
        {
            unsigned char byte = (unsigned char)text[index];
            valid = (byte >= 'a' && byte <= 'z') || (byte >= 'A' && byte <= 'Z') || (byte >= '0' && byte <= '9') || byte == '_' || byte == '-' || byte == '.';
        }
    }
    return valid;
}

static bool hp_plan_array(const HpArguments *arguments, size_t limit)
{
    bool valid = arguments != NULL && arguments->count <= limit && (arguments->count == 0 || arguments->values != NULL);
    for (size_t index = 0; valid && index < arguments->count; index += 1)
    {
        valid = hp_plan_text(arguments->values[index], NULL);
    }
    return valid;
}

bool hp_plan_sources(const HpArguments *sources, HpSourcePlan *output, char error[BUSTER_HP_ERROR_CAPACITY])
{
    HpSourcePlan plan = { 0 };
    if (output != NULL)
    {
        memset(output, 0, sizeof(*output));
    }
    if (error != NULL)
    {
        error[0] = 0;
    }
    bool valid = output != NULL && error != NULL && hp_plan_array(sources, BUSTER_HP_SOURCE_LIMIT) && sources->count != 0;
    size_t checkers = 0;
    for (size_t index = 0; valid && index < sources->count; index += 1)
    {
        const char *source = sources->values[index];
        valid = hp_plan_source(source);
        for (size_t previous = 0; valid && previous < index; previous += 1)
        {
            valid = strcmp(source, plan.values[previous]) != 0;
        }
        if (valid)
        {
            const char *slash = strrchr(source, '/');
            const char *basename = slash != NULL ? slash + 1 : source;
            if (strcmp(basename, "main_unit_checker.c") == 0)
            {
                checkers += 1;
                plan.checker_index = index;
            }
            plan.values[plan.count++] = source;
        }
    }
    valid = valid && checkers == 1;
    if (valid)
    {
        *output = plan;
    }
    else
    {
        hp_plan_error(error, "invalid, duplicate, oversized or unqualified source inventory");
    }
    return valid;
}

bool hp_plan_decimal(const char *text, uint64_t maximum, uint64_t *output, char error[BUSTER_HP_ERROR_CAPACITY])
{
    if (output != NULL)
    {
        *output = 0;
    }
    if (error != NULL)
    {
        error[0] = 0;
    }
    size_t length = 0;
    bool valid = output != NULL && error != NULL && hp_plan_text(text, &length);
    uint64_t value = 0;
    for (size_t index = 0; valid && index < length; index += 1)
    {
        unsigned char byte = (unsigned char)text[index];
        valid = byte >= '0' && byte <= '9';
        if (valid)
        {
            uint64_t digit = byte - '0';
            valid = value < maximum / 10 || (value == maximum / 10 && digit <= maximum % 10);
            if (valid)
            {
                value = value * 10 + digit;
            }
        }
    }
    if (valid)
    {
        *output = value;
    }
    else
    {
        hp_plan_error(error, "invalid, overflowing or out-of-range decimal setting");
    }
    return valid;
}

static bool hp_plan_push(HpPlanArguments *plan, const char *value)
{
    bool valid = plan->count < BUSTER_HP_ARGUMENT_LIMIT && hp_plan_text(value, NULL);
    if (valid)
    {
        plan->values[plan->count++] = value;
        plan->values[plan->count] = NULL;
    }
    return valid;
}

static bool hp_plan_arguments(const char *const *prefix, size_t prefix_count, const HpArguments *flags, HpPlanArguments *output, char error[BUSTER_HP_ERROR_CAPACITY])
{
    HpPlanArguments plan = { 0 };
    bool valid = output != NULL && error != NULL && prefix_count <= BUSTER_HP_ARGUMENT_LIMIT && hp_plan_array(flags, BUSTER_HP_ARGUMENT_LIMIT - prefix_count);
    for (size_t index = 0; valid && index < prefix_count; index += 1)
    {
        valid = hp_plan_push(&plan, prefix[index]);
    }
    for (size_t index = 0; valid && index < flags->count; index += 1)
    {
        valid = hp_plan_push(&plan, flags->values[index]);
    }
    if (valid)
    {
        *output = plan;
    }
    else
    {
        hp_plan_error(error, "invalid or oversized command argument plan");
    }
    return valid;
}

static bool hp_plan_prepare(HpPlanArguments *output, char error[BUSTER_HP_ERROR_CAPACITY])
{
    if (output != NULL)
    {
        memset(output, 0, sizeof(*output));
    }
    if (error != NULL)
    {
        error[0] = 0;
    }
    return output != NULL && error != NULL;
}

bool hp_plan_compile(const char *cc, const char *source, const char *object, const char *json, const HpArguments *flags, HpPlanArguments *output, char error[BUSTER_HP_ERROR_CAPACITY])
{
    bool valid = hp_plan_prepare(output, error) && hp_plan_file(cc) && cc[0] == '/' && hp_plan_source(source) && hp_plan_file(object) && hp_plan_file(json);
    const char *prefix[] =
    {
        cc,
        "-c",
        source,
        "-o",
        object,
        "-MJ",
        json
    };
    if (valid)
    {
        valid = hp_plan_arguments(prefix, sizeof(prefix) / sizeof(prefix[0]), flags, output, error);
    }
    if (!valid && error != NULL && error[0] == 0)
    {
        hp_plan_error(error, "invalid direct-compile file operand");
    }
    return valid;
}

bool hp_plan_assembly(const char *cc, const char *source, const char *assembly, const HpArguments *flags, HpPlanArguments *output, char error[BUSTER_HP_ERROR_CAPACITY])
{
    bool valid = hp_plan_prepare(output, error) && hp_plan_file(cc) && cc[0] == '/' && hp_plan_source(source) && hp_plan_file(assembly);
    const char *prefix[] =
    {
        cc,
        "-S",
        source,
        "-o",
        assembly
    };
    if (valid)
    {
        valid = hp_plan_arguments(prefix, sizeof(prefix) / sizeof(prefix[0]), flags, output, error);
    }
    if (!valid && error != NULL && error[0] == 0)
    {
        hp_plan_error(error, "invalid assembly-emission file operand");
    }
    return valid;
}

bool hp_plan_assemble(const char *cc, const char *assembly, const char *object, HpPlanArguments *output, char error[BUSTER_HP_ERROR_CAPACITY])
{
    bool valid = hp_plan_prepare(output, error) && hp_plan_file(cc) && cc[0] == '/' && hp_plan_file(assembly) && hp_plan_file(object);
    const char *prefix[] =
    {
        cc,
        "-c",
        "-x",
        "assembler",
        "--target=x86_64-unknown-linux-gnu",
        "-march=znver5",
        assembly,
        "-o",
        object
    };
    HpArguments no_flags = { 0 };
    if (valid)
    {
        valid = hp_plan_arguments(prefix, sizeof(prefix) / sizeof(prefix[0]), &no_flags, output, error);
    }
    if (!valid && error != NULL && error[0] == 0)
    {
        hp_plan_error(error, "invalid assembler file operand");
    }
    return valid;
}

bool hp_plan_link(const char *cc, const HpArguments *objects, size_t checker_index, const char *replacement, const char *image, HpPlanArguments *output, char error[BUSTER_HP_ERROR_CAPACITY])
{
    bool valid = hp_plan_prepare(output, error) && hp_plan_file(cc) && cc[0] == '/' && hp_plan_array(objects, BUSTER_HP_SOURCE_LIMIT) && objects->count != 0 && checker_index < objects->count && (replacement == NULL || hp_plan_file(replacement)) && hp_plan_file(image);
    HpPlanArguments plan = { 0 };
    const char *prefix[] =
    {
        cc,
        "-no-pie",
        "--ld-path=/usr/bin/wild"
    };
    for (size_t index = 0; valid && index < sizeof(prefix) / sizeof(prefix[0]); index += 1)
    {
        valid = hp_plan_push(&plan, prefix[index]);
    }
    for (size_t index = 0; valid && index < objects->count; index += 1)
    {
        const char *object = replacement != NULL && index == checker_index ? replacement : objects->values[index];
        valid = hp_plan_file(objects->values[index]) && hp_plan_push(&plan, object);
    }
    const char *suffix[] =
    {
        "-lm",
        "-ldl",
        "-o",
        image
    };
    for (size_t index = 0; valid && index < sizeof(suffix) / sizeof(suffix[0]); index += 1)
    {
        valid = hp_plan_push(&plan, suffix[index]);
    }
    if (valid)
    {
        *output = plan;
    }
    else
    {
        hp_plan_error(error, "invalid link inventory, checker slot or file operand");
    }
    return valid;
}
