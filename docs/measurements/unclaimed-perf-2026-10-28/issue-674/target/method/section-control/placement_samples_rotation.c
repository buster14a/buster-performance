// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Original placement/copy cohort controller. Every binary and output argument has the same path length.
#define _GNU_SOURCE
#include <errno.h>
#include <fcntl.h>
#include <limits.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>
#include <sys/wait.h>
#include <unistd.h>

#define CASES 36u

static bool copy_binary(const char* source, const char* destination)
{
    const int input = open(source, O_RDONLY);
    const int output = input >= 0 ? open(destination, O_WRONLY | O_CREAT | O_EXCL, 0700) : -1;
    bool result = input >= 0 && output >= 0;
    uint8_t buffer[65536];
    ssize_t length = 1;
    while (result && length != 0)
    {
        do { length = read(input, buffer, sizeof(buffer)); } while (length < 0 && errno == EINTR);
        result = length >= 0;
        ssize_t written = 0;
        while (result && written < length)
        {
            ssize_t part;
            do { part = write(output, buffer + written, (size_t)(length - written)); } while (part < 0 && errno == EINTR);
            result = part > 0;
            written += result ? part : 0;
        }
    }
    if (input >= 0)
    {
        result &= close(input) == 0;
    }
    if (output >= 0)
    {
        result &= close(output) == 0;
    }
    return result;
}

static bool same_file(const char* left, const char* right)
{
    const int a = open(left, O_RDONLY);
    const int b = open(right, O_RDONLY);
    bool result = a >= 0 && b >= 0;
    uint8_t x[65536];
    uint8_t y[65536];
    ssize_t count = 1;
    while (result && count != 0)
    {
        ssize_t other;
        do { count = read(a, x, sizeof(x)); } while (count < 0 && errno == EINTR);
        do { other = read(b, y, sizeof(y)); } while (other < 0 && errno == EINTR);
        result = count >= 0 && other == count && (count == 0 || memcmp(x, y, (size_t)count) == 0);
    }
    if (a >= 0)
    {
        result &= close(a) == 0;
    }
    if (b >= 0)
    {
        result &= close(b) == 0;
    }
    return result;
}

static int run(char* const arguments[])
{
    const pid_t child = fork();
    if (child == 0)
    {
        execv(arguments[0], arguments);
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
    int result = argc < 12;
    const unsigned pass = argc >= 12 ? (unsigned)strtoul(argv[1], NULL, 10) : 0;
    const unsigned jobs = argc >= 12 ? (unsigned)strtoul(argv[2], NULL, 10) : 0;
    const unsigned tasks = argc >= 12 ? (unsigned)strtoul(argv[3], NULL, 10) : 0;
    result |= pass >= 100 || jobs == 0 || jobs > 8 || tasks < jobs || tasks > 128;
    char temporary[] = "/tmp/buster674-qa-XXXXXX";
    char (*copies)[PATH_MAX] = result == 0 ? calloc(CASES, PATH_MAX) : NULL;
    char** command = result == 0 ? calloc((size_t)argc + 8, sizeof(char*)) : NULL;
    result |= copies == NULL || command == NULL;
    result |= result == 0 && mkdtemp(temporary) == NULL;
    if (result == 0)
    {
        result = mkdir(argv[5], 0755) != 0 && errno != EEXIST;
    }
    char directory[PATH_MAX];
    const int parent_size = argc >= 12 ? snprintf(directory, sizeof(directory), "%s/r%03u", argv[5], pass) : -1;
    result |= parent_size < 0 || parent_size >= PATH_MAX;
    if (result == 0)
    {
        result = mkdir(directory, 0755) != 0;
    }
    const unsigned shifts[6] = { 0, 688, 1376, 2064, 2752, 3440 };
    for (unsigned index = 0; result == 0 && index < CASES; index += 1)
    {
        char source[PATH_MAX];
        const unsigned role = index % 3;
        const unsigned placement = index / 6;
        const int source_size = snprintf(source, sizeof(source), "%s/compiler-%u", argv[role == 1 ? 8 : 7], shifts[placement]);
        const int copy_size = snprintf(copies[index], PATH_MAX, "%s/exe-%03u", temporary, index);
        result = source_size < 0 || source_size >= PATH_MAX || copy_size < 0 || copy_size >= PATH_MAX || !copy_binary(source, copies[index]);
        if (result == 0)
        {
            result = !same_file(source, copies[index]);
        }
        printf("copy pass=%u case=%u role=%u shift=%u copy=%u source=%s binary=%s verified=%u\n",
               pass, index, role, shifts[placement], index / 3 % 2, source, copies[index], result == 0);
    }
    for (unsigned phase = 0; result == 0 && phase < 2; phase += 1)
    {
        for (unsigned turn = 0; result == 0 && turn < CASES; turn += 1)
        {
            const unsigned index = (turn + pass) % CASES;
            const unsigned role = index % 3;
            const unsigned placement = index / 6;
            char output[PATH_MAX];
            const int size = snprintf(output, sizeof(output), "%s/%s%03u", directory, phase == 0 ? "warm" : "case", index);
            result = size < 0 || size >= PATH_MAX;
            if (result == 0)
            {
                command[0] = argv[6];
                command[1] = phase == 0 ? "1" : argv[2];
                command[2] = phase == 0 ? "1" : argv[3];
                command[3] = argv[4];
                command[4] = output;
                command[5] = copies[index];
                unsigned next = 6;
                if (phase == 0)
                {
                    command[next++] = "--verify";
                }
                for (int a = 11; a < argc; a += 1)
                {
                    command[next++] = argv[a];
                }
                command[next] = NULL;
                printf("%s pass=%u case=%u role=%u shift=%u copy=%u jobs=%u binary=%s\n",
                       phase == 0 ? "warmup" : "matrix", pass, index, role, shifts[placement], index / 3 % 2,
                       phase == 0 ? 1 : jobs, copies[index]);
                fflush(stdout);
                result = run(command);
                if (result == 0 && phase == 0)
                {
                    char object[PATH_MAX];
                    const int object_size = snprintf(object, sizeof(object), "%s/output-0000.o", output);
                    result = object_size < 0 || object_size >= PATH_MAX || !same_file(argv[9], object);
                    printf("verified object case=%u equal=%u\n", index, result == 0);
                }
            }
        }
    }
    for (unsigned index = 0; copies != NULL && index < CASES; index += 1)
    {
        if (copies[index][0] != 0)
        {
            unlink(copies[index]);
        }
    }
    rmdir(temporary);
    free(command);
    free(copies);
    if (result != 0)
    {
        fprintf(stderr, "placement sampling failed; usage: PASS JOBS TASKS INPUT OUTROOT COHORT BASEDIR HEADDIR REFERENCE -- FLAGS...\n");
    }
    return result;
}
