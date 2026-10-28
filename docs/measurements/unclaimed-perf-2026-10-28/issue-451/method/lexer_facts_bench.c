// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Original paired screen of the producer's optional line facts. Both paths are in the same executable.
#define _GNU_SOURCE
#include <errno.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/mman.h>
#include <sys/stat.h>
#include <time.h>
#include <unistd.h>
#include "c_lexer.c"

static uint64_t nanoseconds(void)
{
    struct timespec now;
    clock_gettime(CLOCK_MONOTONIC_RAW, &now);
    return (uint64_t)now.tv_sec * 1000000000ull + (uint64_t)now.tv_nsec;
}

int main(int argc, char** argv)
{
    int result = argc != 2 && argc != 3;
    const unsigned after_scalar_ms = argc == 3 ? (unsigned)strtoul(argv[2], NULL, 10) : 0;
    result |= after_scalar_ms > 1000;
    const int file = result == 0 ? open(argv[1], O_RDONLY) : -1;
    struct stat information;
    result |= file < 0 || fstat(file, &information) != 0;
    const uint64_t length = result == 0 ? (uint64_t)information.st_size : 0;
    const uint8_t* bytes = result == 0 ? mmap(NULL, length, PROT_READ, MAP_PRIVATE, file, 0) : MAP_FAILED;
    result |= bytes == MAP_FAILED || length == 0;
    const uint64_t capacity = BUSTER_C_TOKENIZER_CAPACITY(length);
    uint8_t* kinds[2] = { malloc(capacity), malloc(capacity) };
    uint32_t* starts[2] = { malloc(capacity * sizeof(uint32_t)), malloc(capacity * sizeof(uint32_t)) };
    uint32_t* ends[2] = { malloc(capacity * sizeof(uint32_t)), malloc(capacity * sizeof(uint32_t)) };
    uint8_t* facts = malloc((length + 63) / 64);
    result |= kinds[0] == NULL || kinds[1] == NULL || starts[0] == NULL || starts[1] == NULL || ends[0] == NULL || ends[1] == NULL || facts == NULL;
    const uint32_t flags = C_TOKENIZER_NO_DIGIT_SEPARATORS;
    int64_t expected = 0;
    if (result == 0)
    {
        expected = c_tokenize_lines(bytes, length, 0, kinds[0], starts[0], ends[0], flags);
        const int64_t counted = c_tokenize_lines_counted(bytes, length, 0, kinds[1], starts[1], ends[1], flags, facts);
        result = expected < 0 || counted != expected || memcmp(kinds[0], kinds[1], (size_t)expected) != 0 ||
                 memcmp(starts[0], starts[1], (size_t)expected * sizeof(uint32_t)) != 0 || memcmp(ends[0], ends[1], (size_t)expected * sizeof(uint32_t)) != 0;
    }
    uint64_t digest = 0;
    // Each round uses all six role permutations in turn. The two plain roles expose a same-source screen floor.
    const unsigned permutations[6][3] = { {0, 1, 2}, {2, 1, 0}, {1, 0, 2}, {2, 0, 1}, {0, 2, 1}, {1, 2, 0} };
    uint64_t samples[3][24] = { 0 };
    for (unsigned round = 0; result == 0 && round < 24; round += 1)
    {
        for (unsigned slot = 0; slot < 3; slot += 1)
        {
            const unsigned role = permutations[round % 6][slot];
            const uint64_t until = nanoseconds() + (uint64_t)after_scalar_ms * 1000000ull;
            uint64_t light = digest + 1;
            while (after_scalar_ms != 0 && nanoseconds() < until)
            {
                for (unsigned i = 0; i < 4096; i += 1)
                {
                    light = (light ^ (light >> 13)) * 0x9e3779b97f4a7c15ull;
                }
            }
            digest += light;
            const uint64_t begin = nanoseconds();
            for (unsigned loop = 0; loop < 8; loop += 1)
            {
                const int64_t count = role == 1 ? c_tokenize_lines_counted(bytes, length, 0, kinds[0], starts[0], ends[0], flags, facts) :
                                                  c_tokenize_lines(bytes, length, 0, kinds[0], starts[0], ends[0], flags);
                digest += (uint64_t)count;
                result |= count != expected;
            }
            const uint64_t elapsed = nanoseconds() - begin;
            samples[role][round] = elapsed;
            printf("round=%u slot=%u role=%u bytes=%llu loops=8 ns=%llu failures=%u\n", round, slot, role,
                   (unsigned long long)length, (unsigned long long)elapsed, result != 0);
        }
    }
    double medians[3] = { 0 };
    for (unsigned role = 0; result == 0 && role < 3; role += 1)
    {
        for (unsigned i = 1; i < 24; i += 1)
        {
            const uint64_t value = samples[role][i];
            unsigned at = i;
            while (at != 0 && samples[role][at - 1] > value)
            {
                samples[role][at] = samples[role][at - 1];
                at -= 1;
            }
            samples[role][at] = value;
        }
        medians[role] = ((double)samples[role][11] + (double)samples[role][12]) / 16.0;
        printf("role=%u median_ns_per_call=%.3f change_against_plain=%+.4f%%\n", role, medians[role], 100.0 * (medians[role] / medians[0] - 1.0));
    }
    printf("tokens=%lld after_scalar_ms=%u digest=%llu result=%d\n", (long long)expected, after_scalar_ms, (unsigned long long)digest, result);
    for (unsigned path = 0; path < 2; path += 1)
    {
        free(kinds[path]);
        free(starts[path]);
        free(ends[path]);
    }
    free(facts);
    if (bytes != MAP_FAILED)
    {
        munmap((void*)bytes, length);
    }
    if (file >= 0)
    {
        close(file);
    }
    return result;
}
