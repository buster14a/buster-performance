// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin.
// Includes the extracted implementation, then forces both a first allocation and a later growth to fail.
#define main files_reuse_controls_main
#include "harness.c"
#undef main

static bool fail_realloc;
void* __real_realloc(void* pointer, size_t bytes);

void* __wrap_realloc(void* pointer, size_t bytes)
{
    return fail_realloc ? NULL : __real_realloc(pointer, bytes);
}

int main(void)
{
    bool result = files_reuse_controls_main() == 0;
    const PPFileData first[] = {
        {
            .record = 0,
            .prepared = true,
        },
        {
            .record = 1,
            .prepared = true,
        },
    };
    const PPFileData later[] = {
        {
            .record = 3,
            .prepared = true,
        },
        {
            .record = 4,
            .prepared = true,
        },
    };
    uint8_t* used = NULL;
    uint32_t count = 0;
    fail_realloc = true;
    result = !files_test_mark_used(first, BUSTER_ARRAY_LENGTH(first), 3, &used, &count) && used == NULL && count == 0 && result;
    fail_realloc = false;
    if (result)
    {
        result = files_test_mark_used(first, BUSTER_ARRAY_LENGTH(first), 3, &used, &count) && count == 3 && used[0] == 1 && used[1] == 1 && used[2] == 0;
    }
    uint8_t* kept = used;
    uint8_t snapshot[3] = { 0 };
    if (result)
    {
        memcpy(snapshot, used, sizeof(snapshot));
        fail_realloc = true;
        result = !files_test_mark_used(later, BUSTER_ARRAY_LENGTH(later), 5, &used, &count) && used == kept && count == 3 && memcmp(used, snapshot, sizeof(snapshot)) == 0;
    }
    fail_realloc = false;
    if (result)
    {
        result = files_test_mark_used(later, BUSTER_ARRAY_LENGTH(later), 5, &used, &count) && count == 5 && memcmp(used, snapshot, sizeof(snapshot)) == 0 &&
                 used[3] == 1 && used[4] == 1;
    }
    free(used);
    puts(result ? "allocation failures: first allocation and growth fail closed; retry preserves marks" : "allocation failures: FAILED");
    return result ? 0 : 1;
}
