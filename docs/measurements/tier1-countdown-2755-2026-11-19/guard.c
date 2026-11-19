#define _GNU_SOURCE
#include <inttypes.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/mman.h>
#include <unistd.h>

uint32_t reverse_sum(const uint32_t *a, uint32_t n);
uint32_t clang_reverse_sum(const uint32_t *a, uint32_t n);

// Run each array flush against each protected page in turn. Both zero-length pointers are inaccessible.
static int check_edges(const uint32_t *values, uint32_t n, uint32_t *answer)
{
    size_t page = (size_t)sysconf(_SC_PAGESIZE);
    size_t bytes = (size_t)n * sizeof(*values);
    size_t usable = ((bytes + page - 1) / page) * page;
    size_t total = usable + 2 * page;
    uint32_t expected = clang_reverse_sum(values, n);
    int ok = 1;
    for (unsigned side = 0; ok && side < 2; ++side)
    {
        unsigned char *map = mmap(NULL, total, PROT_NONE, MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
        if (map == MAP_FAILED)
            return 0;
        uint32_t *array = (uint32_t *)(map + page + (side ? usable - bytes : 0));
        if (usable)
        {
            if (mprotect(map + page, usable, PROT_READ | PROT_WRITE) != 0)
                return 0;
            memcpy(array, values, bytes);
            if (mprotect(map + page, usable, PROT_READ) != 0)
                return 0;
        }
        uint32_t result = reverse_sum(array, n);
        ok = result == expected;
        if (!ok)
            fprintf(stderr, "n=%" PRIu32 " side=%u got=%08" PRIx32 " expected=%08" PRIx32 "\n", n, side, result, expected);
        munmap(map, total);
    }
    *answer = expected;
    return ok;
}

int main(int argc, char **argv)
{
    uint32_t values[1025];
    uint32_t answer = 0;
    for (uint32_t i = 0; i < 1025; ++i)
        values[i] = (i + UINT32_C(0x9e3779b9)) * (i ^ UINT32_C(0x854f9531));
    for (uint32_t n = 0; n <= 33; ++n)
        if (!check_edges(values, n, &answer))
            return 1;
    for (uint32_t n = 1023; n <= 1025; ++n)
        if (!check_edges(values, n, &answer))
            return 1;
    FILE *source = argc == 2 ? fopen(argv[1], "rb") : NULL;
    if (!source || fseek(source, 0, SEEK_END) != 0)
        return 2;
    long length = ftell(source);
    if (length <= 0 || (uint64_t)length > UINT32_MAX || fseek(source, 0, SEEK_SET) != 0)
        return 2;
    uint32_t count = (uint32_t)(((uint64_t)length + 3) / 4);
    uint32_t *words = calloc(count, sizeof(*words));
    if (!words || fread(words, 1, (size_t)length, source) != (size_t)length)
        return 2;
    fclose(source);
    int ok = check_edges(words, count, &answer);
    free(words);
    if (ok)
        printf("guard/Clang: 76 calls passed; n=0..33,1023..1025; input %ld bytes, %" PRIu32 " words, sum=%08" PRIx32 "\n", length, count, answer);
    return ok ? 0 : 1;
}
