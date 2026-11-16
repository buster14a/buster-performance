// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md of buster14a/buster.
//
// mapnames: each mapping a compile makes, named by the code that made it (buster14a/buster#2873, item 2), from maps.sh's
// `strace -f -k` of the compile. It writes a line a successful mmap of the compiler's process, in their order:
//
//   ORDINAL ADDRESS LENGTH FLAGS OWNER NAME
//
// ADDRESS and LENGTH are what mmap returned and was asked (hexadecimal), FLAGS mmap's protection and flags as strace
// spelled them, OWNER the return address in NAME's frame (hexadecimal, for addr2line), and NAME the first frame of the stack that is no allocator's (no mmap wrapper, arena reservation or
// malloc), as `function+0xOFFSET`, then `<` and its caller's function. kcensus pairs the Nth line with the Nth mmap record
// of a recorded compile: the compiles run without address-space randomization and map in the same order, and pairing by
// order holds where adjacent reservations merge into one area in perf's records.
//
//   mapnames STRACE

#define _GNU_SOURCE
#include <inttypes.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MAPNAMES_LINE 8192
#define MAPNAMES_FRAMES 64
#define MAPNAMES_NAME 256

// The allocators' frames, which name no owner: the owner is the first frame past them.
static const char* const mapnames_allocators[] = {
    "__mmap64",
    "mmap64",
    "__mmap",
    "mmap",
    "arena_",
    "sysmalloc",
    "sysmalloc_mmap",
    "_int_malloc",
    "__libc_malloc",
    "__libc_malloc2",
    "malloc",
    "__libc_calloc",
    "calloc",
    "_int_realloc",
    "__libc_realloc",
    "realloc",
    "_int_memalign",
    "_mid_memalign",
    "__libc_memalign",
    "aligned_alloc",
    "__posix_memalign",
    "posix_memalign",
    "scratch_begin",
    "allocate_stack",
    "pthread_create",
    "__pthread_create",
    "_IO_file_doallocate",
    "_IO_doallocbuf",
};

static bool is_allocator(const char* function)
{
    bool found = false;
    for (uint32_t i = 0; i < sizeof(mapnames_allocators) / sizeof(mapnames_allocators[0]) && !found; i += 1)
    {
        const size_t length = strlen(mapnames_allocators[i]);
        const bool prefix = mapnames_allocators[i][length - 1] == '_';
        found = prefix ? strncmp(function, mapnames_allocators[i], length) == 0 : strcmp(function, mapnames_allocators[i]) == 0;
    }
    return found;
}

typedef struct Call Call;
struct Call
{
    bool active;
    unsigned long pid;
    unsigned long long address;
    unsigned long long length;
    char flags[2 * MAPNAMES_NAME + 2];
    uint32_t frames;
    char frame[MAPNAMES_FRAMES][MAPNAMES_NAME];
    unsigned long long frame_address[MAPNAMES_FRAMES];
};

static void call_finish(Call* call, uint32_t* ordinal, unsigned long compiler)
{
    if (call->active && call->pid == compiler)
    {
        // The owner: the first frame that is no allocator's, and its caller.
        uint32_t owner = 0;
        while (owner < call->frames)
        {
            char function[MAPNAMES_NAME];
            snprintf(function, sizeof(function), "%s", call->frame[owner]);
            function[strcspn(function, "+")] = 0;
            if (!is_allocator(function))
            {
                break;
            }
            owner += 1;
        }
        char caller[MAPNAMES_NAME] = "";
        if (owner + 1 < call->frames)
        {
            snprintf(caller, sizeof(caller), "%s", call->frame[owner + 1]);
            caller[strcspn(caller, "+")] = 0;
        }
        printf("%u %llx %llx %s %llx %s%s%s\n", *ordinal, call->address, call->length, call->flags, owner < call->frames ? call->frame_address[owner] : 0,
               owner < call->frames ? call->frame[owner] : "(no frame)", caller[0] != 0 ? " < " : "", caller);
        *ordinal += 1;
    }
    call->active = false;
    call->frames = 0;
}

int main(int argc, char** argv)
{
    FILE* file = argc == 2 ? fopen(argv[1], "r") : NULL;
    char line[MAPNAMES_LINE];
    Call call = { 0 };
    uint32_t ordinal = 0;
    // The compiler's process: the first whose stack frames are in an executable named `compiler`.
    unsigned long compiler = 0;
    unsigned long pid = 0;
    while (file != NULL && fgets(line, sizeof(line), file) != NULL)
    {
        if (strncmp(line, " > ", 3) == 0)
        {
            // ` > /path/compiler(function+0x2c) [0x11daeec]`
            const char* open = strstr(line, "/compiler(");
            if (open != NULL && compiler == 0)
            {
                compiler = pid;
            }
            if (open != NULL && call.active && call.frames < MAPNAMES_FRAMES)
            {
                const char* start = open + 10;
                const char* end = strchr(start, ')');
                const size_t length = end != NULL ? (size_t)(end - start) : 0;
                snprintf(call.frame[call.frames], MAPNAMES_NAME, "%.*s", (int)length, start);
                const char* bracket = end != NULL ? strstr(end, "[0x") : NULL;
                call.frame_address[call.frames] = bracket != NULL ? strtoull(bracket + 1, NULL, 16) : 0;
                call.frames += 1;
            }
            continue;
        }
        call_finish(&call, &ordinal, compiler);
        char* end = NULL;
        pid = strtoul(line, &end, 10);
        const char* text = end;
        while (*text == ' ')
        {
            text += 1;
        }
        unsigned long long address = 0;
        unsigned long long length = 0;
        unsigned long long result = 0;
        char protection[MAPNAMES_NAME];
        char flags[MAPNAMES_NAME];
        const char* equals = strstr(text, ") = 0x");
        // `mmap(NULL, 1052672, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7ffff7ef6000`
        if (strncmp(text, "mmap(", 5) == 0 && equals != NULL && (compiler == 0 || pid == compiler))
        {
            char first[64];
            if (sscanf(text + 5, "%63[^,], %llu, %255[^,], %255[^,],", first, &length, protection, flags) == 4 &&
                sscanf(equals + 4, "%llx", &result) == 1)
            {
                address = result;
                call.active = true;
                call.pid = pid;
                call.address = address;
                call.length = length;
                snprintf(call.flags, sizeof(call.flags), "%s,%s", protection, flags);
                call.frames = 0;
            }
        }
    }
    call_finish(&call, &ordinal, compiler);
    if (file != NULL)
    {
        fclose(file);
    }
    return file != NULL ? 0 : 2;
}
