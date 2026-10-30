// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin.
// First-party parser for saved, quoted Clang driver receipts. It never invokes
// a producer or evaluates shell syntax. hp_driver_isa owns decoded features;
// hp_driver_equal deliberately compares the ordered vector without attempting
// to infer target-feature defaults or collapse repeated options. The selected
// executable's canonical identity and all process statuses are caller gates.
#include "hp_driver.h"

#include <stdlib.h>
#include <string.h>

static bool hp_driver_space(unsigned char byte)
{
    return byte == ' ' || byte == '\t';
}

static bool hp_driver_prefix(HpBytes line, const char *prefix)
{
    size_t size = strlen(prefix);
    return line.size >= size && memcmp(line.data, prefix, size) == 0;
}

static bool hp_driver_line_is(HpBytes line, const char *text)
{
    size_t size = strlen(text);
    return line.size == size && memcmp(line.data, text, size) == 0;
}

static bool hp_driver_header(HpBytes line, char error[BUSTER_HP_ERROR_CAPACITY])
{
    static const char version[] = "clang version 23.1.4";
    static const char *const prefixes[] =
    {
        "InstalledDir: ",
        "Build config: ",
        "Found candidate GCC installation: ",
        "Selected GCC installation: ",
        "Candidate multilib: ",
        "Selected multilib: "
    };
    bool valid = hp_driver_line_is(line, "Target: " BUSTER_HP_DRIVER_TARGET) || hp_driver_line_is(line, "Thread model: posix") || hp_driver_line_is(line, "(in-process)");
    if (hp_driver_prefix(line, version))
    {
        valid = line.size == sizeof(version) - 1 || line.data[sizeof(version) - 1] == ' ' || line.data[sizeof(version) - 1] == '(';
    }
    for (size_t i = 0; !valid && i < sizeof(prefixes) / sizeof(prefixes[0]); i += 1)
    {
        size_t prefix_size = strlen(prefixes[i]);
        valid = line.size > prefix_size && hp_driver_prefix(line, prefixes[i]);
    }
    if (!valid)
    {
        hp_error(error, "unknown or mismatched Clang receipt header");
    }
    return valid;
}

static bool hp_driver_command(HpBytes line, HpArguments *output, char error[BUSTER_HP_ERROR_CAPACITY])
{
    HpArguments command = {0};
    command.storage = malloc(line.size + 1);
    command.values = calloc(BUSTER_HP_ARGUMENT_LIMIT + 1, sizeof(*command.values));
    bool valid = command.storage != NULL && command.values != NULL;
    size_t position = 0;
    size_t used = 0;
    while (valid && position < line.size)
    {
        while (position < line.size && hp_driver_space(line.data[position]))
        {
            position += 1;
        }
        if (position < line.size)
        {
            valid = line.data[position] == '"' && command.count < BUSTER_HP_ARGUMENT_LIMIT;
            if (valid)
            {
                position += 1;
                size_t start = used;
                command.values[command.count++] = command.storage + used;
                bool closed = false;
                while (valid && !closed)
                {
                    valid = position < line.size;
                    if (valid)
                    {
                        unsigned char byte = line.data[position++];
                        if (byte == '"')
                        {
                            closed = true;
                        }
                        else
                        {
                            if (byte == '\\')
                            {
                                valid = position < line.size && (line.data[position] == '\\' || line.data[position] == '"');
                                if (valid)
                                {
                                    byte = line.data[position++];
                                }
                            }
                            valid = valid && byte >= 32 && byte != 127 && used - start < BUSTER_HP_PATH_CAPACITY - 1;
                            if (valid)
                            {
                                command.storage[used++] = (char)byte;
                            }
                        }
                    }
                }
                if (valid)
                {
                    command.storage[used++] = 0;
                    valid = position == line.size || hp_driver_space(line.data[position]);
                }
            }
        }
    }
    valid = valid && command.count >= 2;
    if (valid)
    {
        *output = command;
    }
    else
    {
        hp_arguments_free(&command);
        hp_error(error, "malformed, unsupported or oversized quoted driver command");
    }
    return valid;
}

static bool hp_driver_feature(const char *value)
{
    bool valid = (value[0] == '+' || value[0] == '-') && value[1] != 0;
    for (size_t i = 1; valid && value[i] != 0; i += 1)
    {
        unsigned char byte = (unsigned char)value[i];
        valid = (byte >= 'a' && byte <= 'z') || (byte >= 'A' && byte <= 'Z') || (byte >= '0' && byte <= '9') || byte == '_' || byte == '-' || byte == '.';
    }
    valid = valid && strcmp(value, "-target-feature") != 0 && strcmp(value, "-target-cpu") != 0 && strcmp(value, "-triple") != 0 && strcmp(value, "-cc1") != 0 && strcmp(value, "-cc1as") != 0;
    return valid;
}

static bool hp_driver_extract(const HpArguments *command, const char *mode, HpDriverIsa *isa, char error[BUSTER_HP_ERROR_CAPACITY])
{
    bool valid = command->count >= 2 && command->values[0][0] == '/' && strcmp(command->values[1], mode) == 0;
    size_t modes = 0;
    size_t triples = 0;
    size_t cpus = 0;
    size_t features = 0;
    size_t feature_bytes = 0;
    for (size_t i = 1; valid && i < command->count; i += 1)
    {
        const char *value = command->values[i];
        modes += strcmp(value, "-cc1") == 0 || strcmp(value, "-cc1as") == 0;
        if (strcmp(value, "-triple") == 0)
        {
            triples += 1;
            valid = i + 1 < command->count && strcmp(command->values[i + 1], BUSTER_HP_DRIVER_TARGET) == 0;
        }
        else if (strcmp(value, "-target-cpu") == 0)
        {
            cpus += 1;
            valid = i + 1 < command->count && strcmp(command->values[i + 1], BUSTER_HP_DRIVER_CPU) == 0;
        }
        else if (strcmp(value, "-target-feature") == 0)
        {
            valid = i + 1 < command->count && hp_driver_feature(command->values[i + 1]);
            if (valid)
            {
                size_t size = strlen(command->values[i + 1]) + 1;
                valid = size <= BUSTER_HP_DRIVER_LOG_LIMIT - feature_bytes;
                if (valid)
                {
                    features += 1;
                    feature_bytes += size;
                }
            }
        }
    }
    valid = valid && modes == 1 && triples == 1 && cpus == 1;
    if (valid)
    {
        isa->features.storage = malloc(feature_bytes != 0 ? feature_bytes : 1);
        isa->features.values = calloc(features + 1, sizeof(*isa->features.values));
        valid = isa->features.storage != NULL && isa->features.values != NULL;
    }
    if (valid)
    {
        size_t used = 0;
        for (size_t i = 1; i < command->count; i += 1)
        {
            if (strcmp(command->values[i], "-target-feature") == 0)
            {
                size_t size = strlen(command->values[i + 1]) + 1;
                isa->features.values[isa->features.count++] = isa->features.storage + used;
                memcpy(isa->features.storage + used, command->values[i + 1], size);
                used += size;
            }
        }
        isa->features.storage[used != 0 ? used - 1 : 0] = 0;
        memcpy(isa->executable, command->values[0], strlen(command->values[0]) + 1);
        memcpy(isa->triple, BUSTER_HP_DRIVER_TARGET, sizeof(BUSTER_HP_DRIVER_TARGET));
        memcpy(isa->cpu, BUSTER_HP_DRIVER_CPU, sizeof(BUSTER_HP_DRIVER_CPU));
    }
    else
    {
        hp_error(error, "missing, ambiguous or unqualified effective driver ISA");
    }
    return valid;
}

void hp_driver_free(HpDriverIsa *isa)
{
    if (isa != NULL)
    {
        hp_arguments_free(&isa->features);
        memset(isa, 0, sizeof(*isa));
    }
    return;
}

bool hp_driver_isa(HpBytes log, const char *mode, HpDriverIsa *output, char error[BUSTER_HP_ERROR_CAPACITY])
{
    error[0] = 0;
    HpDriverIsa isa = {0};
    HpArguments command = {0};
    bool valid = output != NULL && mode != NULL && (strcmp(mode, "-cc1") == 0 || strcmp(mode, "-cc1as") == 0) && log.data != NULL && log.size > 0 && log.size <= BUSTER_HP_DRIVER_LOG_LIMIT;
    valid = valid && output->features.storage == NULL && output->features.values == NULL && output->features.count == 0 && output->executable[0] == 0 && output->triple[0] == 0 && output->cpu[0] == 0;
    size_t commands = 0;
    size_t position = 0;
    while (valid && position < log.size)
    {
        size_t start = position;
        while (valid && position < log.size && log.data[position] != '\n')
        {
            unsigned char byte = log.data[position];
            valid = byte == '\t' || (byte >= 32 && byte != 127);
            position += 1;
        }
        HpBytes line =
        {
            log.data + start,
            position - start
        };
        if (position < log.size)
        {
            position += 1;
        }
        while (line.size > 0 && hp_driver_space(line.data[0]))
        {
            line.data += 1;
            line.size -= 1;
        }
        while (line.size > 0 && hp_driver_space(line.data[line.size - 1]))
        {
            line.size -= 1;
        }
        if (valid && line.size > 0 && line.data[0] == '"')
        {
            commands += 1;
            valid = commands == 1 && hp_driver_command(line, &command, error);
        }
        else if (valid && line.size > 0)
        {
            valid = hp_driver_header(line, error);
        }
    }
    valid = valid && commands == 1;
    if (valid)
    {
        valid = hp_driver_extract(&command, mode, &isa, error);
    }
    hp_arguments_free(&command);
    if (valid)
    {
        *output = isa;
    }
    else
    {
        hp_driver_free(&isa);
        if (error[0] == 0)
        {
            hp_error(error, "invalid, missing or ambiguous effective driver receipt");
        }
    }
    return valid;
}

bool hp_driver_equal(const HpDriverIsa *a, const HpDriverIsa *b)
{
    bool equal = a != NULL && b != NULL && strcmp(a->triple, b->triple) == 0 && strcmp(a->cpu, b->cpu) == 0 && a->features.count == b->features.count;
    for (size_t i = 0; equal && i < a->features.count; i += 1)
    {
        equal = strcmp(a->features.values[i], b->features.values[i]) == 0;
    }
    return equal;
}

bool hp_driver_default_target(HpBytes output, char error[BUSTER_HP_ERROR_CAPACITY])
{
    error[0] = 0;
    size_t size = sizeof(BUSTER_HP_DRIVER_TARGET) - 1;
    bool valid = output.data != NULL && (output.size == size || output.size == size + 1) && memcmp(output.data, BUSTER_HP_DRIVER_TARGET, size) == 0 && (output.size == size || output.data[size] == '\n');
    if (!valid)
    {
        hp_error(error, "default driver target differs from exact pin");
    }
    return valid;
}
