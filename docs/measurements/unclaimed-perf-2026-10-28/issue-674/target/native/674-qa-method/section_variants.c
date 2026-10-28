// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Original measurement-only relinker. Prefix the actual page-aligned checker section, not ordinary .text.
#define _GNU_SOURCE
#include <errno.h>
#include <limits.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/stat.h>
#include <sys/wait.h>
#include <unistd.h>

static int run(char* const arguments[])
{
    const pid_t child = fork();
    if (child == 0)
    {
        execvp(arguments[0], arguments);
        _exit(127);
    }
    int status = 0;
    pid_t waited = -1;
    if (child > 0)
    {
        do { waited = waitpid(child, &status, 0); } while (waited < 0 && errno == EINTR);
    }
    const int result = child < 0 || waited != child || !WIFEXITED(status) ? 1 : WEXITSTATUS(status);
    return result;
}

int main(int argc, char** argv)
{
    int result = argc < 6;
    const unsigned unit = argc >= 6 ? (unsigned)strtoul(argv[2], NULL, 10) : 0;
    const unsigned count = argc >= 6 ? (unsigned)strtoul(argv[3], NULL, 10) : 0;
    result |= count == 0 || count > 128 || unit >= count;
    if (result == 0)
    {
        result = mkdir(argv[4], 0755) != 0 && errno != EEXIST;
    }
    char (*objects)[PATH_MAX] = result == 0 ? calloc(count, PATH_MAX) : NULL;
    result |= objects == NULL;
    for (unsigned i = 0; result == 0 && i < count; i += 1)
    {
        const int size = snprintf(objects[i], PATH_MAX, "%s/%u.o", argv[1], i);
        result = size < 0 || size >= PATH_MAX;
    }
    for (int s = 5; result == 0 && s < argc; s += 1)
    {
        char* end = NULL;
        const unsigned long shift = strtoul(argv[s], &end, 10);
        result = *argv[s] == 0 || *end != 0 || shift > 65536 || shift % 16 != 0;
        char script[PATH_MAX];
        char object[PATH_MAX];
        char executable[PATH_MAX];
        int sizes[3] =
        {
            snprintf(script, sizeof(script), "%s/shift-%lu.ld", argv[4], shift),
            snprintf(object, sizeof(object), "%s/checker-%lu.o", argv[4], shift),
            snprintf(executable, sizeof(executable), "%s/compiler-%lu", argv[4], shift),
        };
        for (unsigned i = 0; i < 3; i += 1)
        {
            result |= sizes[i] < 0 || sizes[i] >= PATH_MAX;
        }
        FILE* file = result == 0 ? fopen(script, "w") : NULL;
        result |= file == NULL;
        if (file != NULL)
        {
            result |= fprintf(file, "SECTIONS { .text.buster_checker : ALIGN(4096) SUBALIGN(16) { . += %lu; *(.text.buster_checker) } }\n", shift) < 0;
            result |= fclose(file) != 0;
        }
        if (result == 0)
        {
            char* relocate[] = { "ld", "-r", "-T", script, "-o", object, objects[unit], NULL };
            result = run(relocate);
        }
        if (result == 0)
        {
            char* link[136] = { "clang", "-no-pie", "--ld-path=/usr/bin/wild" };
            for (unsigned i = 0; i < count; i += 1)
            {
                link[3 + i] = i == unit ? object : objects[i];
            }
            link[3 + count] = "-lm";
            link[4 + count] = "-ldl";
            link[5 + count] = "-o";
            link[6 + count] = executable;
            link[7 + count] = NULL;
            result = run(link);
            if (result == 0)
            {
                printf("checker section prefix %lu bytes: %s\n", shift, executable);
                fflush(stdout);
            }
        }
    }
    free(objects);
    if (result != 0)
    {
        fprintf(stderr, "section variants failed; usage: OBJECT_DIR UNIT_INDEX OBJECT_COUNT OUTPUT_DIR SHIFT...\n");
    }
    return result;
}
