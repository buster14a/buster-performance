// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin.
// Read-only diagnostic invoked by GDB's shell command while its unique matching inferior is stopped.
// It observes actual mappings; debugger timings are never performance evidence.
#include <stdbool.h>
#include <stdint.h>
#include <limits.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

static long snapshot_parent(long pid)
{
    char path[128];
    snprintf(path, sizeof(path), "/proc/%ld/status", pid);
    FILE* file = fopen(path, "r");
    long result = 0;
    if (file != 0)
    {
        char line[1024];
        while (fgets(line, sizeof(line), file) != 0)
        {
            long parent = 0;
            if (sscanf(line, "PPid: %ld", &parent) == 1)
            {
                result = parent;
            }
        }
        fclose(file);
    }
    return result;
}

static bool snapshot_print(long pid, const char* name)
{
    char path[128];
    snprintf(path, sizeof(path), "/proc/%ld/%s", pid, name);
    FILE* file = fopen(path, "r");
    bool passed = file != 0;
    if (file != 0)
    {
        printf("== %s\n", path);
        char bytes[4096];
        size_t count;
        while ((count = fread(bytes, 1, sizeof(bytes), file)) != 0)
        {
            passed &= fwrite(bytes, 1, count, stdout) == count;
        }
        passed &= !ferror(file);
        passed &= fclose(file) == 0;
    }
    return passed;
}

int main(int argc, char** argv)
{
    long ancestor = getppid();
    long debugger = 0;
    for (uint32_t i = 0; i < 8 && ancestor > 1 && debugger == 0; i += 1)
    {
        char path[128];
        snprintf(path, sizeof(path), "/proc/%ld/comm", ancestor);
        FILE* file = fopen(path, "r");
        char name[128] = {0};
        if (file != 0)
        {
            if (fgets(name, sizeof(name), file) != 0 && strcmp(name, "gdb\n") == 0)
            {
                debugger = ancestor;
            }
            fclose(file);
        }
        ancestor = snapshot_parent(ancestor);
    }
    long inferior = 0;
    uint32_t matches = 0;
    bool passed = argc == 2 && debugger != 0;
    if (passed)
    {
        char path[128];
        snprintf(path, sizeof(path), "/proc/%ld/task/%ld/children", debugger, debugger);
        FILE* file = fopen(path, "r");
        passed = file != 0;
        if (file != 0)
        {
            long child = 0;
            while (fscanf(file, "%ld", &child) == 1)
            {
                char executable[PATH_MAX];
                snprintf(path, sizeof(path), "/proc/%ld/exe", child);
                const ssize_t length = readlink(path, executable, sizeof(executable) - 1);
                if (length > 0 && length < (ssize_t)sizeof(executable) - 1)
                {
                    executable[length] = 0;
                    if (strcmp(executable, argv[1]) == 0)
                    {
                        inferior = child;
                        matches += 1;
                    }
                }
            }
            passed &= !ferror(file) && feof(file);
            passed &= fclose(file) == 0;
        }
    }
    passed &= matches == 1;
    if (passed)
    {
        printf("debugger=%ld inferior=%ld executable=%s\n", debugger, inferior, argv[1]);
        passed &= snapshot_print(inferior, "status");
        passed &= snapshot_print(inferior, "smaps");
    }
    passed &= fflush(stdout) == 0 && !ferror(stdout);
    fprintf(stderr, "inferior snapshot: %s (%u matches)\n", passed ? "pass" : "FAIL", matches);
    return passed ? 0 : 1;
}
