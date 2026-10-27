// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin.
// Extracted from the #604 candidate; only the visits counter is added.
typedef struct CheckConstantPart CheckConstantPart;
struct CheckConstantPart
{
    uint64_t extent;
    uint32_t next;
    uint32_t token;
    uint32_t qualifiers;
    uint32_t parameter_first;
    uint32_t parameter_last;
    uint32_t parameter_count;
    uint32_t parameter_names;
    uint8_t kind;
    uint8_t flags;
};

typedef struct CheckConstantParameter CheckConstantParameter;
struct CheckConstantParameter
{
    TypeId type;
    uint32_t next;
    uint32_t name;
    uint32_t name_children[2];
};

// Each prototype owns a digital search tree in its existing parameter records. Links are index + 1, with zero
// empty. Low bits first distribute consecutive interned names without hashing or clearing an identifier table.
// Every edge fixes another name bit: at most 32 unequal records can precede an empty link or an equal name.
// Insert only when the old scan ran, after parameter adjustment, preserving source-order failure and activation.
static bool check_constant_parameter_unique(CheckConstantPart* function, CheckConstantParameter* parameters, uint32_t parameter)
{
    const uint32_t name = parameters[parameter].name;
    bool unique = true;
    if (name != 0)
    {
        uint32_t* link = &function->parameter_names;
        uint32_t bits = name;
        while (unique && *link != 0)
        {
            visits += 1;
            CheckConstantParameter* previous = &parameters[*link - 1];
            unique = previous->name != name;
            link = &previous->name_children[bits & 1];
            bits >>= 1;
        }
        if (unique)
        {
            *link = parameter + 1;
        }
    }
    return unique;
}

