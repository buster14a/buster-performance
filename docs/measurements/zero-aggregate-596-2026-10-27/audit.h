// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Included immediately before c_check_data.c in a measurement-only source overlay.
// These wrappers count actual successful scratch requests and writes; the reducers count their logical byte reads.
static Arena* audit_scratch;
static uint64_t audit_requested;
static uint64_t audit_peak;
static uint64_t audit_cleared;
static uint64_t audit_copied;
static uint64_t audit_scanned;

static void audit_push(Arena* arena, const void* result, uint64_t size)
{
    if (arena == audit_scratch && result != NULL)
    {
        audit_requested += size;
        audit_peak = arena->length > audit_peak ? arena->length : audit_peak;
    }
}

static void* audit_arena_push(Arena* arena, uint64_t size, uint64_t alignment)
{
    void* result = arena_push(arena, size, alignment);
    audit_push(arena, result, size);
    return result;
}

static void* audit_arena_push_array(Arena* arena, uint64_t count, uint64_t size, uint64_t alignment)
{
    void* result = arena_push_array(arena, count, size, alignment);
    audit_push(arena, result, result != NULL ? count * size : 0);
    return result;
}

static bool audit_destination(const void* destination, uint64_t size)
{
    const uintptr_t offset = audit_scratch != NULL ? (uintptr_t)destination - (uintptr_t)audit_scratch->base : UINTPTR_MAX;
    return audit_scratch != NULL && offset <= audit_scratch->capacity && size <= audit_scratch->capacity - offset;
}

static void* audit_memset(void* destination, int value, size_t size)
{
    if (value == 0 && audit_destination(destination, size))
    {
        audit_cleared += size;
    }
    return memset(destination, value, size);
}

static void* audit_memcpy(void* destination, const void* source, size_t size)
{
    if (audit_destination(destination, size))
    {
        audit_copied += size;
    }
    return memcpy(destination, source, size);
}
