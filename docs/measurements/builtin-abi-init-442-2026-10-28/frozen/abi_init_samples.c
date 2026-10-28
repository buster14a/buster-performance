// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Original isolated initialization control. Include one frozen source tree per build.
#define _GNU_SOURCE
#include <stdint.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
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

static uint64_t now(void)
{
    struct timespec time;
    clock_gettime(CLOCK_MONOTONIC_RAW, &time);
    return (uint64_t)time.tv_sec * UINT64_C(1000000000) + (uint64_t)time.tv_nsec;
}

__attribute__((noinline)) static bool initialize(AbiTable* abi, Arena* arena, const TypeTable* types, uint32_t width, uint32_t capacity)
{
    arena->length = 64;
    const bool result = abi_initialize_types(abi, arena, types, width, capacity);
    // The full result is observable to an unknown consumer on every call.
    __asm__ volatile("" : : "r"(abi), "r"(arena->base) : "memory");
    return result;
}

int main(int argc, char** argv)
{
    bool valid = argc == 5;
    const uint32_t capacity = valid ? (uint32_t)strtoul(argv[1], 0, 10) : 0;
    const uint32_t width = valid ? (uint32_t)strtoul(argv[2], 0, 10) : 0;
    const uint32_t mode = valid ? (uint32_t)strtoul(argv[3], 0, 10) : 0;
    const uint32_t runs = valid ? (uint32_t)strtoul(argv[4], 0, 10) : 0;
    valid = valid && capacity >= 64 && capacity <= 65536 && (width == 16 || width == 32 || width == 64) && mode <= 1 && runs >= 1;
    const TypeCapacity limits = { .types = capacity >= 64 ? capacity - 64 : 0 };
    Arena columns = arena_reserve(type_capacity_bytes(limits));
    Arena index = arena_reserve(type_index_capacity_bytes(limits));
    Arena arena = arena_reserve(abi_capacity_bytes(capacity) + 64);
    TypeTable types = { 0 };
    AbiTable abi = { 0 };
    valid = valid && type_initialize(&types, &columns, &index, limits) && arena.base != 0;
    types.char_unsigned = mode != 0;
    if (valid)
    {
        for (uint32_t warm = 0; valid && warm < 1000; warm += 1)
        {
            valid = initialize(&abi, &arena, &types, width, capacity);
        }
        const uint64_t start = now();
        for (uint32_t run = 0; valid && run < runs; run += 1)
        {
            valid = initialize(&abi, &arena, &types, width, capacity);
        }
        const uint64_t end = now();
        uint64_t checksum = 0;
        for (uint32_t i = 0; i < 64; i += 1)
        {
            checksum += abi.pass[i] + abi.stack_bytes[i] + abi.alignment_log2[i] + abi.storage[i] + abi.layout[i];
            for (uint32_t n = 0; n < BUSTER_ABI_ROW_BYTES; n += 1)
            {
                checksum += abi.rows[(uint64_t)i * BUSTER_ABI_ROW_BYTES + n];
            }
            const uint8_t* result = (const uint8_t*)&abi.results[i];
            for (uint32_t n = 0; n < sizeof(*abi.results); n += 1)
            {
                checksum += result[n];
            }
        }
        printf("%u\t%u\t%u\t%u\t%" PRIu64 "\t%" PRIu64 "\t%d\n", capacity, width, mode, runs, end - start, checksum, valid);
    }
    arena_release(&arena);
    arena_release(&index);
    arena_release(&columns);
    return valid ? 0 : 1;
}
