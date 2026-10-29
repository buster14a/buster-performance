// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin.
// Original orchestration for Buster #764. Input names and hashes are read from the frozen #697 record;
// its existing C generator is executed externally. No corpus source is incorporated into this file.
// prepare GENERATOR C_TESTS CORPUS INPUTS MANIFEST
// run BEFORE AFTER CONTROL CORPUS INPUTS MANIFEST ROUND
// Each benchmark is a fresh process; the caller owns the 9700X lock. Fail closed on any unsuccessful run.
#define _POSIX_C_SOURCE 200809L
#include <errno.h>
#include <fcntl.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <unistd.h>

#define BUSTER_CAMPAIGN_UNITS 43
#define BUSTER_CAMPAIGN_PATH 4096

typedef struct Unit Unit;
struct Unit
{
    char path[128];
    char name[128];
};

static bool join_path(char* out, const char* directory, const char* path)
{
    const int n = snprintf(out, BUSTER_CAMPAIGN_PATH, "%s/%s", directory, path);
    return n > 0 && n < BUSTER_CAMPAIGN_PATH;
}

static int execute(char* const arguments[], const char* output)
{
    int result = -1;
    const int fd = output != NULL ? open(output, O_WRONLY | O_CREAT | O_TRUNC, 0600) : -1;
    if (output == NULL || fd >= 0)
    {
        fflush(NULL);
        const pid_t child = fork();
        if (child == 0)
        {
            if (fd >= 0 && dup2(fd, STDOUT_FILENO) < 0)
            {
                _exit(126);
            }
            if (fd >= 0)
            {
                close(fd);
            }
            execv(arguments[0], arguments);
            perror(arguments[0]);
            _exit(127);
        }
        if (fd >= 0)
        {
            close(fd);
        }
        if (child > 0)
        {
            int status = 0;
            pid_t waited;
            do
            {
                waited = waitpid(child, &status, 0);
            }
            while (waited < 0 && errno == EINTR);
            result = waited == child && WIFEXITED(status) ? WEXITSTATUS(status) : -1;
        }
    }
    return result;
}

static bool load_units(const char* path, Unit* units)
{
    FILE* file = fopen(path, "r");
    bool valid = file != NULL;
    unsigned count = 0;
    char line[512];
    while (valid && fgets(line, sizeof(line), file) != NULL)
    {
        char hash[65];
        char name[128];
        valid = strchr(line, '\n') != NULL;
        if (valid && sscanf(line, "%64s %127s", hash, name) == 2 && strlen(hash) == 64)
        {
            valid = count < BUSTER_CAMPAIGN_UNITS && strspn(hash, "0123456789abcdef") == 64;
            if (valid)
            {
                const char* base = strrchr(name, '/');
                base = base != NULL ? base + 1 : name;
                const size_t length = strlen(base);
                valid = length > 2 && strcmp(base + length - 2, ".c") == 0 && strstr(name, "..") == NULL && name[0] != '/';
                if (valid)
                {
                    strcpy(units[count].path, name);
                    memcpy(units[count].name, base, length - 2);
                    units[count].name[length - 2] = 0;
                    count += 1;
                }
            }
        }
    }
    if (file != NULL)
    {
        valid = !ferror(file) && valid;
        valid = fclose(file) == 0 && valid;
    }
    return valid && count == BUSTER_CAMPAIGN_UNITS;
}

static bool prepare(const Unit* units, char** arguments)
{
    const char* generator = arguments[2];
    const char* tests = arguments[3];
    const char* corpus = arguments[4];
    const char* inputs = arguments[5];
    bool valid = true;
    for (unsigned i = 0; valid && i < BUSTER_CAMPAIGN_UNITS; i += 1)
    {
        const char* name = units[i].path;
        char output[BUSTER_CAMPAIGN_PATH];
        valid = join_path(output, inputs, name);
        if (strcmp(name, "sqlite/sqlite3.c") == 0 || (strlen(name) == 7 && strspn(name, "0123456789") == 5))
        {
            char input[BUSTER_CAMPAIGN_PATH];
            valid = valid && join_path(input, name[0] == 's' ? corpus : tests, name);
            valid = valid && symlink(input, output) == 0;
        }
        else
        {
            char kind = 0;
            unsigned bodies = 0;
            unsigned stanzas = 0;
            unsigned first = 0;
            unsigned second = 0;
            int consumed = 0;
            const int two = sscanf(name, "%c%ux%uf%us%u.c%n", &kind, &bodies, &stanzas, &first, &second, &consumed);
            if (two != 5 || consumed != (int)strlen(name))
            {
                consumed = 0;
                const int one = sscanf(name, "%c%ux%uf%u.c%n", &kind, &bodies, &stanzas, &first, &consumed);
                if (one != 4 || consumed != (int)strlen(name))
                {
                    consumed = 0;
                    const int plain = sscanf(name, "%c%ux%u.c%n", &kind, &bodies, &stanzas, &consumed);
                    valid = valid && plain == 3 && consumed == (int)strlen(name) && (kind == 'h' || kind == 'b' || kind == 'x');
                    first = stanzas;
                }
                else
                {
                    valid = valid && kind == 'l';
                }
                second = stanzas;
            }
            else
            {
                valid = valid && kind == 'd';
            }
            valid = valid && bodies > 0 && bodies <= 64 && stanzas > 0 && stanzas <= 1024 && first > 0 && first <= 1024 && second > 0 && second <= 1024;
            char b[16];
            char s[16];
            char f[16];
            char s2[16];
            snprintf(b, sizeof(b), "%u", bodies);
            snprintf(s, sizeof(s), "%u", stanzas);
            snprintf(f, sizeof(f), "%u", first);
            snprintf(s2, sizeof(s2), "%u", second);
            char* command[] = { (char*)generator, b, s, kind == 'b' ? "bare" : kind == 'x' ? "heavy" : "-", f, s2, NULL };
            valid = valid && execute(command, output) == 0;
        }
        if (!valid)
        {
            fprintf(stderr, "prepare failed for %s: %s\n", name, strerror(errno));
        }
    }
    return valid;
}

static bool run_round(const Unit* units, char** arguments)
{
    char* end = NULL;
    const unsigned long round = strtoul(arguments[8], &end, 10);
    bool valid = end != arguments[8] && *end == 0 && round >= 1 && round <= 5;
    const char* before = arguments[2];
    const char* after = arguments[3];
    const char* control = arguments[4];
    const char* corpus = arguments[5];
    const char* inputs = arguments[6];
    char predefines[BUSTER_CAMPAIGN_PATH];
    char clang_headers[BUSTER_CAMPAIGN_PATH];
    char local_headers[BUSTER_CAMPAIGN_PATH];
    char system_headers[BUSTER_CAMPAIGN_PATH];
    valid = valid && join_path(predefines, corpus, "provenance/gnu17-pinned-predefines.txt") &&
            join_path(clang_headers, corpus, "headers/usr/lib/clang/23/include") &&
            join_path(local_headers, corpus, "headers/usr/local/include") && join_path(system_headers, corpus, "headers/usr/include");
    // Rotate both the units and six runs within each unit. Eight lanes compares all three policies;
    // after's 2/3/4/8 grid refits the existing cold rule using the pinned analysis, not a new scoring rule.
    const char* names[] = { "before-every", "after-every", "control-every", "after-every", "after-every", "after-every" };
    const char* binaries[] = { before, after, control, after, after, after };
    const char* lanes[] = { "8", "8", "8", "2", "3", "4" };
    for (unsigned u = 0; valid && u < BUSTER_CAMPAIGN_UNITS; u += 1)
    {
        const unsigned index = (u + (unsigned)round * 7) % BUSTER_CAMPAIGN_UNITS;
        const Unit* unit = units + index;
        char input[BUSTER_CAMPAIGN_PATH];
        valid = join_path(input, inputs, unit->path);
        for (unsigned r = 0; valid && r < 6; r += 1)
        {
            const unsigned run = (r + u + (unsigned)round) % 6;
            char* command[] =
            {
                (char*)binaries[run], "benchmark-checker-deferred", "--passes", strcmp(unit->name, "sqlite3") == 0 ? "12" : "24",
                "--lanes", (char*)lanes[run], "--cpus", "2,0,1,3,4,5,6,7", "--every-lane", "--predefines", predefines,
                "--clang-features", "--no-default-config", "--target=x86_64-linux-gnu", "-march=znver5", "-std=gnu17", "-nostdinc",
                "-isystem", clang_headers, "-isystem", local_headers, "-isystem", system_headers, input, NULL,
            };
            printf("== round %lu %s %s lanes %s\n", round, names[run], unit->name, lanes[run]);
            const int status = execute(command, NULL);
            printf("exit=%d\n", status);
            valid = status == 0;
        }
    }
    return valid;
}

int main(int count, char** arguments)
{
    Unit units[BUSTER_CAMPAIGN_UNITS] = { 0 };
    const bool preparing = count == 7 && strcmp(arguments[1], "prepare") == 0;
    const bool running = count == 9 && strcmp(arguments[1], "run") == 0;
    bool valid = (preparing || running) && load_units(arguments[preparing ? 6 : 7], units);
    if (valid)
    {
        valid = preparing ? prepare(units, arguments) : run_round(units, arguments);
    }
    if (!valid)
    {
        fprintf(stderr, "campaign: invalid inputs or failed subprocess; no complete qualification may be claimed\n");
    }
    return valid ? 0 : 1;
}
