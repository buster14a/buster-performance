// Original #653 focused memory/semantic adapter. Project-default contribution terms.
#include <stdint.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <limits.h>
#include <sys/mman.h>
#define BUSTER_ARRAY_LENGTH(x) (sizeof(x) / sizeof((x)[0]))
#include "buster/compiler/c_lexer.c"
#include "buster/compiler/lane.c"
#include "buster/compiler/c_intern.c"
#include "buster/compiler/c_refine.c"
#include "buster/compiler/c_predefines.c"
#include "buster/compiler/c_preprocessor.c"

int main(void)
{
    char root[] = "/tmp/buster-directory-check-XXXXXX";
    char path[PATH_MAX];
    unsigned checks = 0;
    unsigned failures = 0;
    bool ready = mkdtemp(root) != 0;
    for (unsigned n = 0; ready && n < 96; n += 1)
    {
        snprintf(path, sizeof(path), "%s/header-%u.h", root, n);
        FILE* file = fopen(path, "w");
        ready = file != 0 && fputs("header\n", file) >= 0;
        ready = file != 0 && fclose(file) == 0 && ready;
    }
    FileCache cache = { 0 };
    if (ready)
    {
        file_cache_list_directory(&cache, root, (uint32_t)strlen(root));
        const bool supported = cache.directories != 0 && cache.directories->slots != 0;
        ready = ready && supported;
        for (unsigned n = 0; n < 512; n += 1)
        {
            snprintf(path, sizeof(path), "%s/header-%u.h", root, n);
            failures += file_cache_directory_absent(&cache, path) != (supported && n >= 96);
            checks += 1;
        }
        for (unsigned capacity = 8; capacity <= 16384; capacity *= 2)
        {
            FileCache tiny = { .directory_arena = arena_reserve_small(capacity, capacity) };
            file_cache_list_directory(&tiny, root, (uint32_t)strlen(root));
            for (unsigned n = 0; n < 96; n += 1)
            {
                snprintf(path, sizeof(path), "%s/header-%u.h", root, n);
                failures += file_cache_directory_absent(&tiny, path);
                checks += 1;
            }
            arena_release(&tiny.directory_arena);
        }
        snprintf(path, sizeof(path), "%s/guarded-missing.h", root);
        const size_t length = strlen(path);
        const size_t page = (size_t)sysconf(_SC_PAGESIZE);
        unsigned char* mapping = mmap(0, 2 * page, PROT_READ | PROT_WRITE, MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
        ready = mapping != MAP_FAILED && mprotect(mapping + page, page, PROT_NONE) == 0;
        if (ready)
        {
            char* guarded = (char*)mapping + page - length - 1;
            memcpy(guarded, path, length + 1);
            failures += file_cache_directory_absent(&cache, guarded) != supported;
            checks += 1;
        }
        if (mapping != MAP_FAILED)
        {
            munmap(mapping, 2 * page);
        }
    }
    arena_release(&cache.directory_arena);
    for (unsigned n = 0; n < 96; n += 1)
    {
        snprintf(path, sizeof(path), "%s/header-%u.h", root, n);
        unlink(path);
    }
    rmdir(root);
    printf("directory memory adapter: %u checks, %u failures, setup=%s\n", checks, failures, ready ? "ok" : "failed");
    return ready && failures == 0 ? 0 : 1;
}
