// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Diagnostic-only counters, injected solely into c_check_data.c by instrument.c.
static Arena* data_byte_arena;
static Arena* data_scratch_arena;
static uint64_t data_byte_peak;
static uint64_t data_scratch_peak;
static uint64_t data_cleared;
static uint64_t data_copied;
static uint64_t data_scanned;

static void data_observe(Arena* arena)
{
    if (arena == data_byte_arena && arena->length > data_byte_peak)
    {
        data_byte_peak = arena->length;
    }
    if (arena == data_scratch_arena && arena->length > data_scratch_peak)
    {
        data_scratch_peak = arena->length;
    }
}

static void* data_push(Arena* arena, uint64_t size, uint64_t alignment)
{
    void* result = arena_push(arena, size, alignment);
    data_observe(arena);
    return result;
}

static void* data_push_array(Arena* arena, uint64_t count, uint64_t size, uint64_t alignment)
{
    void* result = arena_push_array(arena, count, size, alignment);
    data_observe(arena);
    return result;
}

#define DATA_PUSH_ARRAY(arena, Type, count) ((Type*)data_push_array((arena), (count), sizeof(Type), _Alignof(Type)))

static void data_pop(Arena* arena, uint64_t length)
{
    data_observe(arena);
    arena_pop_to(arena, length);
}

static void* data_clear(void* destination, int value, size_t size)
{
    data_cleared += size;
    return memset(destination, value, size);
}

static void* data_copy(void* destination, const void* source, size_t size)
{
    data_copied += size;
    return memcpy(destination, source, size);
}
