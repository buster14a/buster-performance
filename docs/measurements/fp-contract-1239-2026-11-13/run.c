// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin. See the repository LICENSE.
// Original, serial correctness runner for buster14a/buster#1239. See README.md.
#define _POSIX_C_SOURCE 200809L
#include <errno.h>
#include <fcntl.h>
#include <inttypes.h>
#include <limits.h>
#include <stdbool.h>
#include <stdarg.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <unistd.h>

static void path(char* output, const char* format, ...)
{
    va_list arguments;
    va_start(arguments, format);
    const int size = vsnprintf(output, PATH_MAX, format, arguments);
    va_end(arguments);
    if (size < 0 || size >= PATH_MAX)
    {
        fputs("path is too long\n", stderr);
        exit(2);
    }
}

static void quote(FILE* file, const char* value)
{
    fputc('\'', file);
    for (; *value != 0; value += 1)
    {
        if (*value == '\'')
        {
            fputs("'\\''", file);
        }
        else
        {
            fputc(*value, file);
        }
    }
    fputc('\'', file);
}

// Execute the argv directly; quoting is only for the reproducible command log.
static bool run(FILE* log, const char* const* arguments, const char* output)
{
    fputs("$", log);
    for (uint32_t i = 0; arguments[i] != NULL; i += 1)
    {
        fputc(' ', log);
        quote(log, arguments[i]);
    }
    if (output != NULL)
    {
        fputs(" > ", log);
        quote(log, output);
    }
    fputc('\n', log);
    bool valid = fflush(log) == 0;
    const int descriptor = valid && output != NULL ? open(output, O_WRONLY | O_CREAT | O_EXCL, 0644) : -1;
    valid = valid && (output == NULL || descriptor >= 0);
    const pid_t child = valid ? fork() : -1;
    if (child == 0)
    {
        if (dup2(output != NULL ? descriptor : fileno(log), STDOUT_FILENO) < 0 || dup2(fileno(log), STDERR_FILENO) < 0)
        {
            _exit(126);
        }
        if (descriptor >= 0)
        {
            close(descriptor);
        }
        execvp(arguments[0], (char* const*)arguments);
        perror(arguments[0]);
        _exit(127);
    }
    if (descriptor >= 0)
    {
        close(descriptor);
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
    valid = child > 0 && waited == child && WIFEXITED(status) && WEXITSTATUS(status) == 0;
    fprintf(log, "exit: %d\n", child > 0 && waited == child && WIFEXITED(status) ? WEXITSTATUS(status) : -1);
    fflush(log);
    return valid;
}

// -1 is an I/O error, 0 is a byte difference, and 1 is equality. Empty results fail.
static int compare(const char* a, const char* b, uint64_t* bytes)
{
    FILE* first = fopen(a, "rb");
    FILE* second = fopen(b, "rb");
    int result = first != NULL && second != NULL ? 1 : -1;
    uint64_t count = 0;
    bool done = false;
    while (result == 1 && !done)
    {
        uint8_t left[16384];
        uint8_t right[16384];
        const size_t left_count = fread(left, 1, sizeof(left), first);
        const size_t right_count = fread(right, 1, sizeof(right), second);
        result = ferror(first) || ferror(second) ? -1 :
                 left_count != right_count || memcmp(left, right, left_count) != 0 ? 0 : 1;
        count += left_count;
        done = left_count == 0 && right_count == 0;
    }
    if (first != NULL)
    {
        result = fclose(first) == 0 ? result : -1;
    }
    if (second != NULL)
    {
        result = fclose(second) == 0 ? result : -1;
    }
    *bytes = count;
    return result == 1 && count <= 3 * sizeof(uint64_t) ? -1 : result;
}

static int campaign(const char* const* arguments)
{
    const char* repository = arguments[1];
    const char* compiler = arguments[2];
    const char* clang = arguments[3];
    const char* resource = arguments[4];
    const char* corpus = arguments[5];
    const char* work = arguments[6];
    const char* evidence = arguments[7];
    char name[PATH_MAX];
    bool ready = mkdir(work, 0755) == 0 && chdir(corpus) == 0 && setenv("BUSTER_CLANG_RESOURCE_DIR", resource, 1) == 0;
    path(name, "%s/run.log", evidence);
    FILE* log = ready ? fopen(name, "wx") : NULL;
    path(name, "%s/results.tsv", evidence);
    FILE* results = log != NULL ? fopen(name, "wx") : NULL;
    ready = ready && log != NULL && results != NULL;
    if (!ready)
    {
        perror("create fresh work/log/results");
    }
    const char* decoders[] = { "dr_mp3", "minimp3" };
    const char* targets[] = { "x86-64-v3", "znver5" };
    const char* modes[] = { "default", "on", "off" };
    const char* inputs[] = { "tone128.mp3", "mixed128.mp3", "minimp3/vectors/M2L3_bitrate_16_all.bit" };
    const char* labels[] = { "tone", "mixed", "vector" };
    char oracles[2][2][2][3][PATH_MAX];
    uint32_t passed = 0;
    uint32_t failed = 0;
    uint32_t sensitive = 0;
    if (ready)
    {
        fprintf(log, "BUSTER_CLANG_RESOURCE_DIR=%s\nworking directory: %s\n", resource, corpus);
        fputs("decoder\ttarget\tmode\troute\tinput\toracle_mode\tbytes\tresult\n", results);
        ready = run(log, (const char* const[]){ "date", "-u", "+%Y-%m-%dT%H:%M:%SZ", NULL }, NULL) &&
                run(log, (const char* const[]){ "uname", "-srmo", NULL }, NULL) &&
                (run(log, (const char* const[]){ "lscpu", NULL }, NULL) ||
                 run(log, (const char* const[]){ "head", "-n", "32", "/proc/cpuinfo", NULL }, NULL)) &&
                run(log, (const char* const[]){ clang, "--version", NULL }, NULL) &&
                run(log, (const char* const[]){ "git", "-C", repository, "rev-parse", "HEAD", NULL }, NULL) &&
                run(log, (const char* const[]){ "git", "-C", repository, "rev-parse", "HEAD^{tree}", NULL }, NULL) &&
                run(log, (const char* const[]){ "git", "-C", repository, "status", "--short", NULL }, NULL) &&
                run(log, (const char* const[]){ "git", "-C", "dr_libs", "rev-parse", "HEAD", NULL }, NULL) &&
                run(log, (const char* const[]){ "git", "-C", "minimp3", "rev-parse", "HEAD", NULL }, NULL) &&
                run(log, (const char* const[]){ "sha256sum", compiler, clang, NULL }, NULL);
        path(name, "%s/inputs.sha256", evidence);
        ready = ready && run(log, (const char* const[]){ "sha256sum", "--check", name, NULL }, NULL);
    }
    for (uint32_t decoder = 0; ready && decoder < 2; decoder += 1)
    {
        char source[PATH_MAX];
        path(source, "%s/%s_decode.c", corpus, decoders[decoder]);
        for (uint32_t target = 0; ready && target < 2; target += 1)
        {
            char march[PATH_MAX];
            path(march, "-march=%s", targets[target]);
            for (uint32_t mode = 0; ready && mode < 2; mode += 1)
            {
                char executable[PATH_MAX];
                path(executable, "%s/oracle-%s-%s-%s", work, decoders[decoder], targets[target], modes[mode + 1]);
                const char* contract = mode == 0 ? "-ffp-contract=on" : "-ffp-contract=off";
                ready = run(log, (const char* const[]){ clang, "-O0", march, contract, source, "-o", executable, "-lm", NULL }, NULL);
                for (uint32_t input = 0; ready && input < 3; input += 1)
                {
                    path(oracles[decoder][target][mode][input], "%s-%s.pcm", executable, labels[input]);
                    ready = run(log, (const char* const[]){ executable, inputs[input], NULL }, oracles[decoder][target][mode][input]) &&
                            run(log, (const char* const[]){ "sha256sum", oracles[decoder][target][mode][input], NULL }, NULL);
                }
            }
            for (uint32_t input = 0; ready && input < 3; input += 1)
            {
                uint64_t bytes = 0;
                const bool different = compare(oracles[decoder][target][0][input], oracles[decoder][target][1][input], &bytes) == 0;
                fprintf(log, "sensitivity: %s %s %s %s\n", decoders[decoder], targets[target], labels[input], different ? "PASS" : "FAIL");
                sensitive += different;
                failed += !different;
            }
        }
    }
    for (uint32_t decoder = 0; ready && decoder < 2; decoder += 1)
    {
        char source[PATH_MAX];
        path(source, "%s/%s_decode.c", corpus, decoders[decoder]);
        for (uint32_t target = 0; target < 2; target += 1)
        {
            char march[PATH_MAX];
            char include[PATH_MAX];
            path(march, "-march=%s", targets[target]);
            path(include, "%s/include", resource);
            for (uint32_t mode = 0; mode < 3; mode += 1)
            {
                for (uint32_t route = 0; route < 2; route += 1)
                {
                    const char* route_name = route == 0 ? "object" : "direct";
                    char executable[PATH_MAX];
                    char object[PATH_MAX];
                    path(executable, "%s/buster-%s-%s-%s-%s", work, decoders[decoder], targets[target], modes[mode], route_name);
                    path(object, "%s.o", executable);
                    const char* command[16] = { compiler, "-isystem", include, march };
                    uint32_t count = 4;
                    if (mode != 0)
                    {
                        command[count++] = mode == 1 ? "-ffp-contract=on" : "-ffp-contract=off";
                    }
                    if (route == 0)
                    {
                        command[count++] = "-c";
                    }
                    command[count++] = source;
                    command[count++] = "-o";
                    command[count++] = route == 0 ? object : executable;
                    if (route != 0)
                    {
                        command[count++] = "-lm";
                    }
                    command[count] = NULL;
                    bool built = run(log, command, NULL);
                    if (built && route == 0)
                    {
                        built = run(log, (const char* const[]){ clang, object, "-o", executable, "-lm", NULL }, NULL);
                    }
                    for (uint32_t input = 0; input < 3; input += 1)
                    {
                        char output[PATH_MAX];
                        path(output, "%s-%s.pcm", executable, labels[input]);
                        const uint32_t oracle_mode = mode == 2 ? 1 : 0;
                        const bool ran = built && run(log, (const char* const[]){ executable, inputs[input], NULL }, output);
                        uint64_t bytes = 0;
                        const int comparison = ran ? compare(output, oracles[decoder][target][oracle_mode][input], &bytes) : -1;
                        const bool equal = ran && comparison == 1;
                        const char* outcome = !built ? "BUILD_FAILED" : !ran ? "DECODE_FAILED" : comparison < 0 ? "READ_FAILED" : equal ? "PASS" : "MISMATCH";
                        fprintf(results, "%s\t%s\t%s\t%s\t%s\t%s\t%" PRIu64 "\t%s\n", decoders[decoder], targets[target], modes[mode],
                                route_name, labels[input], modes[oracle_mode + 1], bytes, outcome);
                        fprintf(log, "compare: %s %s %s %s %s %s bytes=%" PRIu64 "\n", decoders[decoder], targets[target], modes[mode],
                                route_name, labels[input], outcome, bytes);
                        printf("%s %s %s %s %s %s\n", decoders[decoder], targets[target], modes[mode], route_name, labels[input], outcome);
                        passed += equal;
                        failed += !equal;
                        if (ran)
                        {
                            failed += !run(log, (const char* const[]){ "sha256sum", output, NULL }, NULL);
                        }
                        fflush(results);
                        fflush(stdout);
                    }
                }
            }
        }
    }
    const bool complete = ready && passed == 72 && failed == 0 && sensitive == 12;
    if (log != NULL)
    {
        fprintf(log, "summary: comparisons=%u/72 failures=%u sensitivity=%u/12 complete=%s\n", passed, failed, sensitive, complete ? "yes" : "no");
        ready = fclose(log) == 0 && ready;
    }
    if (results != NULL)
    {
        ready = fclose(results) == 0 && ready;
    }
    printf("summary: comparisons=%u/72 failures=%u sensitivity=%u/12\n", passed, failed, sensitive);
    return complete && ready ? 0 : 1;
}

int main(int argc, char** argv)
{
    bool valid = argc == 8;
    for (int i = 1; valid && i < argc; i += 1)
    {
        valid = argv[i][0] == '/';
    }
    if (!valid)
    {
        fputs("usage: run BUSTER_REPO BUSTER_BINARY CLANG CLANG_RESOURCE CORPUS FRESH_WORK EXISTING_EVIDENCE\nall paths must be absolute\n", stderr);
    }
    return valid ? campaign((const char* const*)argv) : 2;
}
