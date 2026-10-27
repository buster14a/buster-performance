// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin. Original generated-input syntax/native qualification for #603.
// qualify CAMPAIGN_ROOT. Uses the final compiler and original generate.c inputs, both schedules at all five depths.
#define _GNU_SOURCE
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <sys/wait.h>
#include <unistd.h>

static bool run(char* const* arguments)
{
    fflush(NULL);
    const pid_t child = fork();
    if (child == 0)
    {
        alarm(15);
        execv(arguments[0], arguments);
        _exit(127);
    }
    int status = 0;
    const bool valid = child > 0 && waitpid(child, &status, 0) == child && WIFEXITED(status) && WEXITSTATUS(status) == 0;
    printf("qualification status=%u", valid ? 0u : 1u);
    for (uint32_t argument = 0; arguments[argument] != NULL; argument += 1)
    {
        printf(" %s", arguments[argument]);
    }
    printf("\n");
    return valid;
}

int main(int argc, char** argv)
{
    bool valid = argc == 2;
    char compiler[4096];
    char output[4096];
    snprintf(compiler, sizeof(compiler), "%s/head-final/build/compiler", valid ? argv[1] : "");
    snprintf(output, sizeof(output), "%s/native-final-program", valid ? argv[1] : "");
    const char* shapes[] = { "choose-selected", "choose-unselected", "generic-selected", "generic-unselected" };
    uint32_t runs = 0;
    for (uint32_t context = 0; valid && context < 2; context += 1)
    {
        for (uint32_t shape = 0; valid && shape < 4; shape += 1)
        {
            for (uint32_t depth = 128; valid && depth <= 2048; depth *= 2)
            {
                for (uint32_t scalar = 0; valid && scalar < 2; scalar += 1)
                {
                    char source[4096];
                    snprintf(source, sizeof(source), "%s/inputs-final/%s-%s-%u.c", argv[1], context ? "constant" : "runtime", shapes[shape], depth);
                    char* syntax[] = { compiler, scalar ? "--scalar" : "-fsyntax-only", "-fsyntax-only", source, NULL };
                    valid = run(syntax);
                    runs += 1;
                    if (valid && depth == 2048)
                    {
                        char* compile[] = { compiler, scalar ? "--scalar" : "-std=gnu17", source, "-o", output, NULL };
                        valid = run(compile);
                        runs += 1;
                        char* execute[] = { output, NULL };
                        valid = valid && run(execute);
                        runs += 1;
                    }
                }
            }
        }
    }
    printf("qualification runs=%u passed=%u\n", runs, valid);
    return valid ? 0 : 1;
}
