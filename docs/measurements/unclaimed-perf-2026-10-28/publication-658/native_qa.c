// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Original #658 exact-object and native runtime qualification controller.
#define _GNU_SOURCE
#include <errno.h>
#include <fcntl.h>
#include <sched.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>
#include <sys/wait.h>
#include <unistd.h>

typedef struct
{
    const char* mode;
    const char* count;
    const char* operation;
} Case;

static int execute(char* const command[], const char* log)
{
    fflush(NULL);
    const pid_t child = fork();
    int result = 127;
    if (child == 0)
    {
        const int output = open(log, O_CREAT | O_WRONLY | O_TRUNC, 0644);
        if (output < 0 || dup2(output, 1) < 0 || dup2(output, 2) < 0)
        {
            _exit(126);
        }
        close(output);
        execvp(command[0], command);
        _exit(127);
    }
    int status = 0;
    pid_t waited = -1;
    if (child > 0)
    {
        do
        {
            waited = waitpid(child, &status, 0);
        } while (waited < 0 && errno == EINTR);
    }
    if (waited == child && WIFEXITED(status))
    {
        result = WEXITSTATUS(status);
    }
    return result;
}

static bool equal_files(const char* left, const char* right)
{
    FILE* first = fopen(left, "rb");
    FILE* second = fopen(right, "rb");
    bool equal = first != NULL && second != NULL;
    unsigned char a[16384];
    unsigned char b[16384];
    while (equal)
    {
        const size_t ac = fread(a, 1, sizeof(a), first);
        const size_t bc = fread(b, 1, sizeof(b), second);
        equal = ac == bc && memcmp(a, b, ac) == 0;
        if (ac != sizeof(a) || bc != sizeof(b))
        {
            equal &= !ferror(first) && !ferror(second);
            break;
        }
    }
    if (first != NULL)
    {
        fclose(first);
    }
    if (second != NULL)
    {
        fclose(second);
    }
    return equal;
}

int main(void)
{
    // Local correctness inherits the per-run cores grant; no CPU affinity override.
    unsigned failures = 0;
    const Case cases[] =
    {
        { "uchar", "100000", "0" },
        { "uchar", "200000", "0" },
        { "uchar", "400000", "0" },
        { "uchar", "800000", "0" },
        { "int", "320000", "1" },
        { "zero", "100000", "2" },
        { "volatile", "100000", "0" },
        { "float", "100000", "0" },
        { "ulongneg", "129", "3" },
        { "invalid", "129", NULL },
    };
    for (unsigned i = 0; i < sizeof(cases) / sizeof(cases[0]); i += 1)
    {
        char source[256];
        char base_object[256];
        char head_object[256];
        char base_log[256];
        char head_log[256];
        char generate_log[256];
        char link_log[256];
        char run_log[256];
        char executable[256];
        char count[64];
        char operation[64];
        snprintf(source, sizeof(source), "../evidence-658/pub-658-321/%s%s.c", cases[i].mode, cases[i].count);
        snprintf(base_object, sizeof(base_object), "../evidence-658/pub-658-321/%s%s.base.o", cases[i].mode, cases[i].count);
        snprintf(head_object, sizeof(head_object), "../evidence-658/pub-658-321/%s%s.head.o", cases[i].mode, cases[i].count);
        snprintf(base_log, sizeof(base_log), "../evidence-658/pub-658-321/%s%s.base.log", cases[i].mode, cases[i].count);
        snprintf(head_log, sizeof(head_log), "../evidence-658/pub-658-321/%s%s.head.log", cases[i].mode, cases[i].count);
        snprintf(generate_log, sizeof(generate_log), "../evidence-658/pub-658-321/%s%s.generate.log", cases[i].mode, cases[i].count);
        snprintf(link_log, sizeof(link_log), "../evidence-658/pub-658-321/%s%s.link.log", cases[i].mode, cases[i].count);
        snprintf(run_log, sizeof(run_log), "../evidence-658/pub-658-321/%s%s.run.log", cases[i].mode, cases[i].count);
        snprintf(executable, sizeof(executable), "../evidence-658/pub-658-321/%s%s.run", cases[i].mode, cases[i].count);
        snprintf(count, sizeof(count), "-DCOUNT=%s", cases[i].count);
        snprintf(operation, sizeof(operation), "-DOP=%s", cases[i].operation == NULL ? "0" : cases[i].operation);
        char* generate[] = { "../evidence-658/pub-658-321/generate_table", (char*)cases[i].mode, (char*)cases[i].count, source, NULL };
        char* base[] = { "../baseline-321f5976/build/compiler", "--lanes", "1", "-c", source, "-o", base_object, NULL };
        char* head[] = { "./build/compiler", "--lanes", "1", "-c", source, "-o", head_object, NULL };
        const int generated = execute(generate, generate_log);
        const int base_status = execute(base, base_log);
        const int head_status = execute(head, head_log);
        bool okay = generated == 0 && base_status == head_status && equal_files(base_log, head_log);
        if (cases[i].operation == NULL)
        {
            struct stat output;
            okay &= base_status != 0 && stat(base_object, &output) != 0 && stat(head_object, &output) != 0;
        }
        else
        {
            okay &= base_status == 0 && equal_files(base_object, head_object);
            char* link[] = { "clang", "-std=gnu17", "-O2", "-Wall", "-Wextra", "-Werror", count, operation, "../evidence-658/pub-658-321/run_table.c", head_object, "-o", executable, NULL };
            char* run[] = { executable, NULL };
            okay &= execute(link, link_log) == 0;
            okay &= execute(run, run_log) == 0;
        }
        printf("native658 %s%s: base_status=%d head_status=%d %s\n", cases[i].mode, cases[i].count, base_status, head_status, okay ? "PASS" : "FAIL");
        failures += !okay;
    }
    printf("native658: %u failures\n", failures);
    return failures != 0;
}
