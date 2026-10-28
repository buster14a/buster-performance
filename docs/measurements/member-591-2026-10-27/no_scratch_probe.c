// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin. See LICENSE.
// Compare the real indexed action helper with the archived pre-#591 helper under the same zero-scratch contract.
#include <stdint.h>
#include <stdbool.h>
#include <stdio.h>
#include <string.h>
typedef struct String8 String8;
struct String8
{
    char* pointer;
    uint64_t length;
};
#define BUSTER_ARRAY_LENGTH(x) (sizeof(x) / sizeof((x)[0]))
#include "buster/compiler/lane.c"
#include "buster/compiler/c_types.c"
#include "buster/compiler/c_check_actions.c"
#define check_action_find_member check_action_find_member_before
#include "before_helper.c"
#undef check_action_find_member

int main(void)
{
    const TypeCapacity capacity = { .types = 4096, .parameters = 8192, .tags = 512, .members = 4096 };
    Arena storage = arena_reserve(type_capacity_bytes(capacity));
    Arena index = arena_reserve(type_index_capacity_bytes(capacity));
    TypeTable table = { 0 };
    bool ready = type_initialize(&table, &storage, &index, capacity);
    const TypeId record = ready ? type_tag(&table, BUSTER_TYPE_KIND_STRUCT, 81) : 0;
    const TypeMember member = { .name = 82, .type = BUSTER_TYPE_INT, .bit_width = BUSTER_TYPE_NOT_BIT_FIELD };
    ready &= record != 0 && type_complete_record(&table, record, &member, 1, (TypeRecordAttributes){ 0 });
    TypeId pointer = record;
    for (uint32_t depth = 0; ready && depth < 512; depth += 1)
    {
        pointer = type_pointer(&table, pointer);
        ready &= pointer != 0;
    }
    Scratch scratch = scratch_begin(NULL);
    const uint64_t saved = scratch.arena->capacity;
    scratch.arena->capacity = scratch.arena->length;
    bool current_passed = ready;
    for (uint32_t scalar = 0; scalar < 2; scalar += 1)
    {
        uint64_t offset = UINT64_MAX;
        uint32_t qualifiers = UINT32_MAX;
        CheckActionResult result = { 0 };
        const uint32_t found = ready ? check_action_find_member(&table, record, 82, &offset, &qualifiers, scalar != 0, &result) : 0;
        current_passed &= found != 0 && result.diagnostic == CHECK_DIAG_NONE && offset == 0 && qualifiers == 0;
        printf("current scalar=%u member=%u diagnostic=%u offset=%llu qualifiers=%u\n", scalar, found, result.diagnostic,
               (unsigned long long)offset, qualifiers);
    }
    uint64_t offset = UINT64_MAX;
    uint32_t qualifiers = UINT32_MAX;
    CheckActionResult before = { 0 };
    const uint32_t old_member = ready ? check_action_find_member_before(&table, record, 82, &offset, &qualifiers, &before) : 0;
    const bool mutation_detected = old_member == 0 && before.diagnostic == CHECK_DIAG_RESOURCE;
    printf("before member=%u diagnostic=%u mutation_detected=%u\n", old_member, before.diagnostic, mutation_detected);
    scratch.arena->capacity = saved;
    scratch_end(scratch);
    arena_release(&index);
    arena_release(&storage);
    return !(current_passed && mutation_detected);
}
