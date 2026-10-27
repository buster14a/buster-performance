// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Original malformed/late-invalid list generator and exact baseline/head diagnostic comparator.
#include <errno.h>
#include <fcntl.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>
#include <sys/wait.h>
#include <unistd.h>

static bool same(const char* a, const char* b)
{
    FILE* x = fopen(a, "rb");
    FILE* y = fopen(b, "rb");
    bool equal = x != NULL && y != NULL;
    int left = 0;
    while (equal && left != EOF)
    {
        left = fgetc(x);
        equal = left == fgetc(y);
    }
    if (x != NULL) { fclose(x); }
    if (y != NULL) { fclose(y); }
    return equal;
}

int main(int argc, char** argv)
{
    const char* prefixes[] =
    {
        "void f(void*) __attribute__((nonnull(\n",
        "void f(void*) __attribute__((nonnull(\n",
        "int n; void f(void*) __attribute__((nonnull(\n",
        "void f(void*) __attribute__((nonnull(\n",
        "void f(void*) __attribute__((nonnull(\n",
        "void f(void*) __attribute__((nonnull(\n",
        "void f(void*) __attribute__((no_sanitize(\n",
    };
    const char* tails[] = { ",\n0)));\n", ",\n2)));\n", ",\nn)));\n", ",\n((0)) )));\n", ",)));\n", ",,1)));\n", ",\n3)));\n" };
    bool valid = argc == 4 && (mkdir(argv[3], 0755) == 0 || errno == EEXIST);
    unsigned pairs = 0;
    for (unsigned c = 0; valid && c < sizeof(prefixes) / sizeof(prefixes[0]); c += 1)
    {
        char source[1024];
        snprintf(source, sizeof(source), "%s/case-%u.c", argv[3], c);
        FILE* output = fopen(source, "w");
        valid = output != NULL;
        if (valid)
        {
            fputs(prefixes[c], output);
            for (unsigned a = 0; a < 1024; a += 1)
            {
                fprintf(output, "%s%s", a != 0 ? "," : "", c == 6 ? "\"address\"" : "1");
            }
            fputs(tails[c], output);
            valid = fclose(output) == 0;
        }
        for (unsigned scalar = 0; valid && scalar < 2; scalar += 1)
        {
            for (unsigned object = 0; valid && object < 2; object += 1)
            {
                char paths[2][1024];
                for (unsigned tree = 0; valid && tree < 2; tree += 1)
                {
                    snprintf(paths[tree], sizeof(paths[tree]), "%s/case-%u-%u-%u-%s.stderr", argv[3], c, scalar, object, tree ? "head" : "base");
                    char destination[1024];
                    snprintf(destination, sizeof(destination), "%s/rejected.o", argv[3]);
                    unlink(destination);
                    const pid_t child = fork();
                    if (child == 0)
                    {
                        const int report = open(paths[tree], O_WRONLY | O_CREAT | O_TRUNC, 0644);
                        const int null = open("/dev/null", O_RDWR);
                        if (report != -1 && null != -1 && dup2(null, 0) != -1 && dup2(null, 1) != -1 && dup2(report, 2) != -1)
                        {
                            char* arguments[] = { argv[tree + 1], scalar ? "--scalar" : (object ? "-c" : "-fsyntax-only"),
                                scalar ? (object ? "-c" : "-fsyntax-only") : source, scalar ? source : "-o",
                                scalar ? "-o" : destination, scalar ? destination : NULL, NULL };
                            execv(arguments[0], arguments);
                        }
                        _exit(127);
                    }
                    int status = -1;
                    valid = child > 0 && waitpid(child, &status, 0) == child && WIFEXITED(status) && WEXITSTATUS(status) == 1 &&
                            access(destination, F_OK) != 0;
                }
                valid = valid && same(paths[0], paths[1]);
                printf("case=%u scalar=%u object=%u identical=%u\n", c, scalar, object, valid);
                pairs += valid;
            }
        }
    }
    printf("diagnostics: %u matched rejection pairs, result=%s\n", pairs, valid ? "pass" : "fail");
    return valid ? 0 : 1;
}
