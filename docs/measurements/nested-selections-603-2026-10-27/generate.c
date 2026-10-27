// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin. Original #603 inputs and command lists.
// generate OUTPUT_DIRECTORY BASE_COMPILER HEAD_COMPILER [REMOTE_INPUT_DIRECTORY]. The directory must exist.
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <string.h>
#include <sys/stat.h>

int main(int argc, char** argv)
{
    bool valid = argc == 4 || argc == 5;
    const char* shapes[] = { "choose-selected", "choose-unselected", "generic-selected", "generic-unselected" };
    const char* openings[] = { "__builtin_choose_expr(1,", "__builtin_choose_expr(0,", "_Generic(0,int:", "_Generic(0,default:" };
    const char* closings[] = { ",0)", ",0)", ",default:0)", ",int:0)" };
    for (uint32_t context = 0; valid && context < 2; context += 1)
    {
        char cycles_path[4096];
        snprintf(cycles_path, sizeof(cycles_path), "%s/%s-check-input.list", argv[1], context ? "constant" : "runtime");
        FILE* cycles = fopen(cycles_path, "w");
        valid = cycles != NULL;
        for (uint32_t scalar = 0; valid && scalar < 2; scalar += 1)
        {
            char list_path[4096];
            snprintf(list_path, sizeof(list_path), "%s/%s-%s.list", argv[1], context ? "constant" : "runtime", scalar ? "scalar" : "vector");
            FILE* list = fopen(list_path, "w");
            valid = list != NULL;
            for (uint32_t shape = 0; valid && shape < 4; shape += 1)
            {
                for (uint32_t depth = 128; valid && depth <= 2048; depth *= 2)
                {
                    char path[4096];
                    snprintf(path, sizeof(path), "%s/%s-%s-%u.c", argv[1], context ? "constant" : "runtime", shapes[shape], depth);
                    if (scalar == 0)
                    {
                        FILE* source = fopen(path, "w");
                        valid = source != NULL;
                        if (valid)
                        {
                            fputs(context ? "enum { value=" : "int f(void){return ", source);
                            for (uint32_t level = 0; level < depth; level += 1)
                            {
                                fputs(openings[shape], source);
                            }
                            fputs("7", source);
                            for (uint32_t level = 0; level < depth; level += 1)
                            {
                                fputs(closings[shape], source);
                            }
                            const uint32_t expected = shape % 2 == 0 ? 7 : 0;
                            if (context)
                            {
                                fprintf(source, "}; _Static_assert(value==%u,\"selected value\"); int main(void){return value!=%u;}\n", expected, expected);
                            }
                            else
                            {
                                fprintf(source, ";} int main(void){return f()!=%u;}\n", expected);
                            }
                            valid &= fclose(source) == 0;
                        }
                    }
                    for (uint32_t variant = 0; valid && variant < 2; variant += 1)
                    {
                        char command_path[4096];
                        snprintf(command_path, sizeof(command_path), "%s/%s-%s-%u.c", argc == 5 ? argv[4] : argv[1], context ? "constant" : "runtime", shapes[shape], depth);
                        fprintf(list, "%s-%s-%u|runs=3,warmups=1,cpu=2,capture,events=cycles:instructions|%s %s-fsyntax-only --time-stages %s\n",
                                variant ? "head" : "base", shapes[shape], depth, argv[variant + 2], scalar ? "--scalar " : "", command_path);
                        if (scalar == 0)
                        {
                            fprintf(cycles, "%s-%s-%u|runs=3,warmups=0,cpu=2,capture|%s benchmark-checker-bindings --only direct --passes 7 %s\n",
                                    variant ? "head" : "base", shapes[shape], depth, argv[variant + 2], command_path);
                        }
                    }
                }
            }
            if (list != NULL)
            {
                valid &= fclose(list) == 0;
            }
        }
        if (cycles != NULL)
        {
            valid &= fclose(cycles) == 0;
        }
    }
    if (valid)
    {
        char path[4096];
        snprintf(path, sizeof(path), "%s/representative.list", argv[1]);
        FILE* list = fopen(path, "w");
        valid = list != NULL;
        const char* corpus = "/var/lib/buster-9700x/corpora/preprocessor-391e729af658";
        const char* labels[] = { "base-a", "head", "base-b" };
        for (uint32_t compile = 0; valid && compile < 2; compile += 1)
        {
            for (uint32_t variant = 0; variant < 3; variant += 1)
            {
                fprintf(list, "%s-%s|runs=5,warmups=1,cpu=2,capture,events=cycles:instructions|%s %s --time-stages -std=gnu17 -nostdinc -isystem %s/headers/usr/lib/clang/23/include -isystem %s/headers/usr/local/include -isystem %s/headers/usr/include ",
                        labels[variant], compile ? "compile" : "syntax", argv[variant == 1 ? 3 : 2], compile ? "-c" : "-fsyntax-only", corpus, corpus, corpus);
                if (compile)
                {
                    fprintf(list, "-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -o %s/%s.o ",
                            argc == 5 ? argv[4] : argv[1], labels[variant]);
                }
                fprintf(list, "-I %s/sqlite %s/sqlite/sqlite3.c\n", corpus, corpus);
            }
        }
        if (list != NULL)
        {
            valid &= fclose(list) == 0;
        }
    }
    return valid ? 0 : 1;
}
