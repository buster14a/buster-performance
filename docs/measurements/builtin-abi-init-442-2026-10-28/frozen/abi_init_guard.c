// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Original guarded output/allocation-failure and scalar recomputation fixture.
#define _GNU_SOURCE
#include <stdint.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <inttypes.h>
typedef struct String8 String8;
struct String8
{
    char* pointer;
    uint64_t length;
};
#include "buster/compiler/lane.c"
#include "buster/compiler/c_types.c"
#include "buster/compiler/calling_convention.c"

static uint64_t needed(uint32_t count)
{
    const uint64_t sizes[] = { (uint64_t)count * 16, (uint64_t)count * 4, (uint64_t)count * 4, count, count,
                               (uint64_t)count * 8, (uint64_t)count * sizeof(AbiReturn) };
    uint64_t bytes = 0;
    for (uint32_t i = 0; i < 7; i += 1)
    {
        bytes = ((bytes + 63) & ~UINT64_C(63)) + sizes[i];
    }
    return bytes;
}

static void recompute(AbiTable* abi, const TypeTable* types)
{
    const uint32_t prefix = types->types.count < 64 ? types->types.count : 64;
    memset(abi->rows, 0, (uint64_t)prefix * 16);
    memset(abi->pass, 0, (uint64_t)abi->capacity * 4);
    memset(abi->stack_bytes, 0, (uint64_t)prefix * 4);
    memset(abi->alignment_log2, 0, prefix);
    memset(abi->storage, 0, abi->capacity);
    memset(abi->layout, 0, (uint64_t)abi->capacity * 8);
    memset(abi->results, 0, (uint64_t)prefix * sizeof(AbiReturn));
    abi->larger = 0;
    abi->rare = 0;
    for (uint32_t a = 0; a < BUSTER_ABI_CLASS_COUNT; a += 1)
    {
        for (uint32_t b = 0; b < BUSTER_ABI_CLASS_COUNT; b += 1)
        {
            abi->merge[a * BUSTER_ABI_CLASS_COUNT + b] = abi_merge_class((uint8_t)a, (uint8_t)b);
        }
    }
    for (uint32_t i = 1; i < prefix; i += 1)
    {
        if (types->types.kind[i] != BUSTER_TYPE_KIND_NONE)
        {
            for (uint32_t offset = 0; offset < 16; offset += 1)
            {
                abi->rows[(uint64_t)i * 16 + offset] = abi_row_entry(abi, types, i, offset);
            }
            abi_finish(abi, types, i);
        }
    }
}

int main(void)
{
    const TypeCapacity capacities = { .types = 2 };
    Arena columns = arena_reserve(type_capacity_bytes(capacities));
    Arena index = arena_reserve(type_index_capacity_bytes(capacities));
    Arena reference = arena_reserve(abi_capacity_bytes(66));
    TypeTable types = { 0 };
    bool valid = type_initialize(&types, &columns, &index, capacities) && reference.base != 0;
    const TypeId pointer = valid ? type_pointer(&types, BUSTER_TYPE_CHAR) : 0;
    const uint64_t page = (uint64_t)sysconf(_SC_PAGESIZE);
    uint8_t* mapping = mmap(0, page * 3, PROT_NONE, MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
    uint8_t* expected = malloc(page);
    valid = valid && pointer != 0 && mapping != MAP_FAILED && expected != 0 && mprotect(mapping + page, page, PROT_READ | PROT_WRITE) == 0;
    const uint32_t counts[] = { 0, 1, 2, 3, 4, 31, 32, 35, 36, 54, 55, 63, 64, 65 };
    const uint32_t widths[] = { 0, 15, 16, 32, 64, 128 };
    uint64_t checks = 0;
    for (uint32_t c = 0; valid && c < sizeof(counts) / sizeof(*counts); c += 1)
    {
        for (uint32_t requested = 0; valid && requested <= 66; requested += 1)
        {
            const uint64_t full = needed(requested);
            const uint64_t limits[] = { 0, 64, 256, full != 0 ? full - 1 : 0, full, full + 64 };
            for (uint32_t l = 0; valid && l < 6; l += 1)
            {
                const uint64_t limit = limits[l];
                const uint64_t rounded = (limit + 63) & ~UINT64_C(63);
                for (uint32_t w = 0; valid && w < 6; w += 1)
                {
                    for (uint32_t mode = 0; valid && mode < 2; mode += 1)
                    {
                        memset(mapping + page, 0xa5, page);
                        memset(expected, 0xa5, page);
                        memset(reference.base, 0xa5, reference.capacity);
                        TypeTable view = types;
                        view.types.count = counts[c];
                        view.types.capacity = 65;
                        view.char_unsigned = mode != 0;
                        Arena actual = { .base = mapping + 2 * page - rounded, .capacity = limit };
                        AbiTable got = { 0 };
                        AbiTable oracle = { 0 };
                        reference.length = 0;
                        const bool accepted = abi_initialize_types(&got, &actual, &view, widths[w], requested);
                        const bool expected_accept = requested >= counts[c] && requested <= 65 &&
                            (widths[w] == 16 || widths[w] == 32 || widths[w] == 64) && full <= limit;
                        valid = accepted == expected_accept;
                        checks += 1;
                        if (accepted)
                        {
                            valid = valid && abi_initialize_types(&oracle, &reference, &view, widths[w], requested);
                            if (valid)
                            {
                                recompute(&oracle, &view);
                                const uint32_t prefix = counts[c] < 64 ? counts[c] : 64;
#define COMPARE(field, bytes) \
                                valid = valid && memcmp(got.field, oracle.field, bytes) == 0; \
                                if (valid) memcpy(expected + ((uint8_t*)got.field - (mapping + page)), oracle.field, bytes)
                                COMPARE(rows, (uint64_t)prefix * 16);
                                COMPARE(pass, (uint64_t)requested * 4);
                                COMPARE(stack_bytes, (uint64_t)prefix * 4);
                                COMPARE(alignment_log2, prefix);
                                COMPARE(storage, requested);
                                COMPARE(layout, (uint64_t)requested * 8);
                                COMPARE(results, (uint64_t)prefix * sizeof(AbiReturn));
#undef COMPARE
                                valid = valid && actual.length == full && memcmp(got.merge, oracle.merge, sizeof(got.merge)) == 0 && got.larger == 0 && got.rare == 0;
                            }
                        }
                        else
                        {
                            valid = valid && actual.length == 0;
                        }
                        valid = valid && memcmp(mapping + page, expected, page) == 0;
                        if (!valid)
                        {
                            fprintf(stderr, "failure count=%u requested=%u limit=%" PRIu64 " width=%u char=%u\n", counts[c], requested, limit, widths[w], mode);
                        }
                    }
                }
            }
        }
    }
    printf("guarded initialization: %" PRIu64 " cases, %s\n", checks, valid ? "passed" : "FAILED");
    if (mapping != MAP_FAILED) munmap(mapping, page * 3);
    free(expected);
    arena_release(&reference);
    arena_release(&index);
    arena_release(&columns);
    return valid ? 0 : 1;
}
