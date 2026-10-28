// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin. See LICENSE.
// Exact pre-#591 helper/record excerpt from buster92c025e71856d13eb34247477c5294d2cead139e,
// src/buster/compiler/c_check_actions.c. The probe renames only the function through a macro.
typedef struct CheckMemberFrame CheckMemberFrame;
struct CheckMemberFrame
{
    uint32_t next;
    uint32_t end;
    uint32_t qualifiers;
    uint64_t offset;
};

// The member of a record that a name finds, through its anonymous members, with its bit offset and the qualifiers it
// inherits. Every member access runs it, inlined into check_action_member; the atomic alignment walk calls its copy
// (check_action_member_lookup), so that a second caller doesn't take it out of check_action_member's code.
static inline __attribute__((always_inline)) uint32_t check_action_find_member(const TypeTable* table, TypeId record, uint32_t name, uint64_t* offset,
                                                                                uint32_t* qualifiers, CheckActionResult* result)
{
    Scratch scratch = scratch_begin(NULL);
    const uint32_t count = table->types.count;
    CheckMemberFrame* stack = BUSTER_ARENA_PUSH_ARRAY(scratch.arena, CheckMemberFrame, count);
    uint8_t* visited = BUSTER_ARENA_PUSH_ARRAY(scratch.arena, uint8_t, count);
    uint32_t member = 0;
    uint32_t depth = 0;
    if (stack == NULL || visited == NULL)
    {
        check_action_diagnose(result, CHECK_DIAG_RESOURCE, 0);
    }
    else
    {
        memset(visited, 0, count);
        const uint32_t index = type_index(record);
        const uint32_t tag = table->types.index[index];
        visited[index] = 1;
        stack[depth++] = (CheckMemberFrame){
            .next = table->tags.member_begin[tag],
            .end = table->tags.member_begin[tag] + table->tags.member_count[tag],
            .qualifiers = type_qualifiers(record),
            .offset = 0,
        };
    }
    while (member == 0 && depth != 0)
    {
        CheckMemberFrame* top = &stack[depth - 1];
        if (top->next == top->end)
        {
            depth -= 1;
        }
        else
        {
            const uint32_t candidate = top->next++;
            const uint64_t member_offset = top->offset + table->members.offset[candidate];
            if (table->members.name[candidate] == name && name != 0)
            {
                member = candidate;
                *offset = member_offset;
                *qualifiers = top->qualifiers;
            }
            else if (table->members.name[candidate] == 0 && (table->members.flags[candidate] & BUSTER_TYPE_MEMBER_BIT_FIELD) == 0)
            {
                const TypeId inner = type_strip_aligned(table, table->members.type[candidate]);
                const uint32_t index = type_index(inner);
                const uint8_t kind = type_kind(table, inner);
                if (!visited[index] && (kind == BUSTER_TYPE_KIND_STRUCT || kind == BUSTER_TYPE_KIND_UNION))
                {
                    const uint32_t tag = table->types.index[index];
                    const uint32_t inherited = top->qualifiers | type_qualifiers(inner);
                    visited[index] = 1;
                    stack[depth++] = (CheckMemberFrame){
                        .next = table->tags.member_begin[tag],
                        .end = table->tags.member_begin[tag] + table->tags.member_count[tag],
                        .qualifiers = inherited,
                        .offset = member_offset,
                    };
                }
            }
        }
    }
    scratch_end(scratch);
    return member;
}

