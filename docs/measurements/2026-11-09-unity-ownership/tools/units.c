// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin. See LICENSE and README.md.

#define _GNU_SOURCE
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/wait.h>
#include <unistd.h>

static char* read_command(const char* command, size_t* size)
{
    FILE* input = popen(command, "r");
    char* data = malloc(1048576);
    *size = fread(data, 1, 1048575, input);
    data[*size] = 0;
    if (pclose(input) != 0) { exit(2); }
    return data;
}

int main(int argc, char** argv)
{
    if (argc != 4) { return 2; }
    const bool syntax = strcmp(argv[1], "syntax") == 0;
    const char* arch = argv[2];
    const char* directory = argv[3];
    setenv("BUSTER_HOST_ARCH", arch, 1);
    setenv("BUSTER_DEBUG_INFO", "0", 1);
    size_t flags_size;
    char* flags = read_command("./build.sh print-compile-flags --config Debug", &flags_size);
    size_t sources_size;
    char* sources = read_command("./build.sh print-sources", &sources_size);
    const int jobs = getenv("CORES") != 0 ? atoi(getenv("CORES")) : 1;
    int running = 0;
    int failures = 0;
    for (size_t at = 0; at < sources_size;)
    {
        const char* source = sources + at;
        at += strlen(source) + 1;
        const char* name = strrchr(source, '/');
        name = name != 0 ? name + 1 : source;
        if (getenv("ALL_SOURCES") == 0 && strcmp(name, "main.c") != 0 && strncmp(name, "main_unit_", 10) != 0) { continue; }
        if (getenv("UNITS_ONLY") != 0 && strstr(getenv("UNITS_ONLY"), name) == 0) { continue; }
        if (running == jobs)
        {
            int status = 0;
            wait(&status);
            failures += !WIFEXITED(status) || WEXITSTATUS(status) != 0;
            running -= 1;
        }
        const pid_t child = fork();
        if (child == 0)
        {
            char output[4096];
            char dep[4096];
            snprintf(output, sizeof(output), "%s/%s.%s.%s", directory, name, arch, syntax ? "log" : "i");
            snprintf(dep, sizeof(dep), "%s/%s.%s.d", directory, name, arch);
            if (freopen(output, "w", syntax ? stderr : stdout) == 0) { _exit(3); }
            char* arguments[1024];
            int n = 0;
            arguments[n++] = "clang";
            for (size_t offset = 0; offset < flags_size;)
            {
                arguments[n++] = flags + offset;
                offset += strlen(flags + offset) + 1;
            }
            arguments[n++] = syntax ? "-fsyntax-only" : "-E";
            arguments[n++] = "-ferror-limit=0";
            if (!syntax) { arguments[n++] = "-P"; }
            if (syntax)
            {
                arguments[n++] = "-MD";
                arguments[n++] = "-MF";
                arguments[n++] = dep;
            }
            arguments[n++] = (char*)source;
            arguments[n] = 0;
            execvp(arguments[0], arguments);
            _exit(4);
        }
        running += 1;
    }
    while (running != 0)
    {
        int status = 0;
        wait(&status);
        failures += !WIFEXITED(status) || WEXITSTATUS(status) != 0;
        running -= 1;
    }
    printf("%s %s: %d failed unity units\n", argv[1], arch, failures);
    return failures != 0;
}
