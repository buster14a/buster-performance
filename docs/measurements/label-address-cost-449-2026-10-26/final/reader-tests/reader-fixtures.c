// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
// Synthetic final-receipt mutation tests. These files are temporary test data, never benchmark evidence.
// Build: clang -O2 -Wall -Wextra -Werror reader-fixtures.c -o reader-fixtures
// Usage: reader-fixtures FINAL_READER PROTOTYPE_READER PROTOTYPE_RAW LUA_SOURCE_MANIFEST
#define _GNU_SOURCE
#include <dirent.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>
#include <sys/wait.h>
#include <unistd.h>

static const char* fake_hash = "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa";
static const char* binary = "f20ac86eeb71787112c4e26ce290dc62223c7ac703f924d0919472b8e2c0b6f2";
static const char* corpus = "/var/lib/buster-9700x/corpora/preprocessor-391e729af658";
static const char* hashes[7] =
{
    "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa",
    "afbf05f18d99176033a23261ce0cbc0e2e716a66c9c65bfc1de7b829108986a6",
    "a5faaad818d33f1ea44a31be5550f9988db009d323ef09a13f7def702c782de5",
    "f20ac86eeb71787112c4e26ce290dc62223c7ac703f924d0919472b8e2c0b6f2",
    "b6d81b2fefd5bffa8ee5607589f959a1dbcfd520ea8ca7eba2b8555858821dc6",
    "0a409f1633283fa31a9126b11fbfd64a1991c5d30defad07e5745d4667f5e23d",
    "a39036d8215977b5a205f7fd3c4e7dfe6576b58eaa76a7bb0b0e214a164e8d33",
};

static void require(bool valid)
{
    if (!valid)
    {
        perror("reader-fixtures");
        exit(2);
    }
}

static void path_of(char output[4096], const char* directory, const char* name)
{
    const int length = snprintf(output, 4096, "%s/%s", directory, name);
    require(length > 0 && length < 4096);
}

static FILE* write_file(const char* directory, const char* name)
{
    char path[4096];
    path_of(path, directory, name);
    FILE* file = fopen(path, "w");
    require(file != NULL);
    return file;
}

static void finish(FILE* file)
{
    const bool written = !ferror(file);
    require(fclose(file) == 0 && written);
}

static void receipt(const char* directory, const char* name, const char* command, int status)
{
    FILE* file = write_file(directory, name);
    fprintf(file, "SYNTHETIC FINAL-READER TEST DATA\ncommand:%s\nexit=%d end: synthetic\n", command, status);
    finish(file);
}

static void copy_metric(const char* old_dir, const char* old_name, const char* directory, const char* name, unsigned mutation)
{
    char path[4096];
    path_of(path, old_dir, old_name);
    FILE* input = fopen(path, "r");
    require(input != NULL);
    FILE* output = write_file(directory, name);
    char* line = NULL;
    size_t capacity = 0;
    while (getline(&line, &capacity, input) >= 0)
    {
        const char* alias = strncmp(line, "command:", 8) == 0 ? strstr(line, " head449\n") : NULL;
        if (alias != NULL && mutation != 9)
        {
            fprintf(output, "%.*s head449-final\n", (int)(alias - line), line);
        }
        else if (mutation == 10 && strncmp(line, "exit=", 5) == 0)
        {
            fputs("exit=1 end: synthetic\n", output);
        }
        else
        {
            fputs(line, output);
        }
    }
    if (mutation == 16)
    {
        fputs("1024,,branches:u,0.01%\n", output);
    }
    const bool read = !ferror(input);
    require(fclose(input) == 0 && read);
    finish(output);
    free(line);
}

static void provenance(const char* directory, const char* manifest, unsigned mutation, bool after)
{
    FILE* file = write_file(directory, after ? "provenance-after.log" : "provenance-before.log");
    fputs("SYNTHETIC FINAL-READER TEST DATA\ncommand: bash provenance449-final.sh\n", file);
    fputs("base commit: 9de3d30ba437b381394095d7a77635a2e877435d\n", file);
    fprintf(file, "head commit: %s\n", mutation == 17 ? "wrong" : "f7af14f10cfb38fcbc384dcb2584ed846fe33860");
    const char* paths[7] = { "base.tar", "head449-final.tar", "base/build/compiler", "head449-final/build/compiler", "label-dispatch-128.c", "sqlite/sqlite3.c", "provenance/gnu17-pinned-predefines.txt" };
    for (unsigned row = 0; row < 7; row += 1)
    {
        if (!(mutation == 13 && row == 0))
        {
            const char* hash = hashes[row];
            if ((mutation == 1 && after && row == 0) || (mutation == 3 && row == 1))
            {
                hash = binary;
            }
            fprintf(file, "%s  %s%s%s\n", hash, row >= 5 ? corpus : "", row >= 5 ? "/" : "", paths[row]);
        }
    }
    FILE* input = fopen(manifest, "r");
    require(input != NULL);
    char* line = NULL;
    size_t capacity = 0;
    unsigned rows = 0;
    while (getline(&line, &capacity, input) >= 0)
    {
        require(strlen(line) > 69 && strncmp(line + 66, "./", 2) == 0);
        fprintf(file, "%.64s  /home/david/buster-fast-bench/x87-136/lua/%s", mutation == 12 && rows == 0 ? fake_hash : line, line + 68);
        rows += 1;
    }
    require(rows == 61);
    const bool read = !ferror(input);
    require(fclose(input) == 0 && read);
    free(line);
    if (mutation == 14 || mutation == 15)
    {
        fprintf(file, "%s  %s\n", fake_hash, mutation == 14 ? "extra-file.c" : "base.tar");
    }
    fprintf(file, "online CPUs: synthetic\nclang version synthetic\nTarget: synthetic\nThread model: synthetic\nInstalledDir: synthetic\nscaling_driver: synthetic\nscaling_governor: %s\nscaling_min_freq: synthetic\nscaling_max_freq: synthetic\n",
            mutation == 2 && after ? "changed" : "synthetic");
    fputs("exit=0 end: synthetic\n", file);
    finish(file);
}

static void fixtures(const char* directory, const char* raw, const char* manifest, unsigned mutation)
{
    provenance(directory, manifest, mutation, false);
    provenance(directory, manifest, mutation, true);
    FILE* build = write_file(directory, "build.log");
    fprintf(build, "SYNTHETIC FINAL-READER TEST DATA\ncommand: bash /home/david/buster-fast-bench/codex-449-450-451-20261026/build449-final.sh\n%s  build/compiler\nexit=%u end: synthetic\n", mutation == 4 ? fake_hash : binary, mutation == 5 ? 1 : 0);
    finish(build);
    receipt(directory, "label-dispatch-acceptance.log", " taskset -c 2 bash acceptance449-final.sh", 0);
    receipt(directory, "group-preflight.log", " timeout --signal=TERM --kill-after=1s 55s bash group449-final.sh preflight", 0);
    char name[128];
    char command[256];
    for (unsigned round = 1; round <= 5; round += 1)
    {
        snprintf(name, sizeof(name), "group-%u.log", round);
        snprintf(command, sizeof(command), " timeout --signal=TERM --kill-after=1s 55s bash group449-final.sh %u", round);
        if (!(mutation == 7 && round == 5))
        {
            receipt(directory, name, command, mutation == 6 && round == 3 ? 124 : 0);
        }
    }
    const char* trees[2] = { "base", "head449" };
    const char* actual[2] = { "base", "head449-final" };
    const char* units[4] = { "sqlite", "lstrlib", "lparser", "labels" };
    const char* metrics[3] = { "perf", "labels-perf", "process" };
    char old_name[128];
    for (unsigned tree = 0; tree < 2; tree += 1)
    {
        for (unsigned unit = 0; unit < 4; unit += 1)
        {
            snprintf(old_name, sizeof(old_name), "preflight-%s-%s.log", trees[tree], units[unit]);
            snprintf(name, sizeof(name), "preflight-%s-%s.log", units[unit], actual[tree]);
            copy_metric(raw, old_name, directory, name, mutation == 11 && tree == 0 && unit == 0 ? 10 : 0);
        }
        for (unsigned round = 1; round <= 5; round += 1)
        {
            for (unsigned metric = 0; metric < 3; metric += 1)
            {
                snprintf(name, sizeof(name), "%s-%u-%s.log", metrics[metric], round, trees[tree]);
                const unsigned edit = tree == 1 && round == 1 && metric == 2 && (mutation == 9 || mutation == 10) ? mutation :
                                      tree == 0 && round == 1 && metric == 0 && mutation == 16 ? 16 : 0;
                copy_metric(raw, name, directory, name, edit);
            }
        }
    }
    if (mutation == 8)
    {
        receipt(directory, "perf-6-base.log", " synthetic", 0);
    }
}

static int invoke(const char* executable, char* const args[], const char* output, const char* errors)
{
    const pid_t process = fork();
    require(process >= 0);
    if (process == 0)
    {
        require(freopen(output, "w", stdout) != NULL);
        require(freopen(errors, "w", stderr) != NULL);
        execv(executable, args);
        _exit(127);
    }
    int status = 0;
    require(waitpid(process, &status, 0) == process);
    return WIFEXITED(status) ? WEXITSTATUS(status) : 128;
}

static bool equal_files(const char* left, const char* right)
{
    FILE* a = fopen(left, "r");
    FILE* b = fopen(right, "r");
    require(a != NULL && b != NULL);
    bool equal = true;
    int x = 0;
    int y = 0;
    do
    {
        x = getc(a);
        y = getc(b);
        equal = x == y && equal;
    }
    while (x != EOF || y != EOF);
    const bool read = !ferror(a) && !ferror(b);
    require(fclose(a) == 0);
    require(fclose(b) == 0 && read);
    return equal;
}

static void remove_files(const char* directory)
{
    DIR* dir = opendir(directory);
    require(dir != NULL);
    struct dirent* entry = NULL;
    while ((entry = readdir(dir)) != NULL)
    {
        if (strcmp(entry->d_name, ".") != 0 && strcmp(entry->d_name, "..") != 0)
        {
            char path[4096];
            path_of(path, directory, entry->d_name);
            require(unlink(path) == 0);
        }
    }
    require(closedir(dir) == 0);
}

int main(int argc, char** argv)
{
    require(argc == 5);
    char directory[] = "work-logs/final-reader/synthetic-fixtures-XXXXXX";
    require(mkdtemp(directory) != NULL);
    bool valid = true;
    unsigned checks = 0;
    for (unsigned mutation = 0; mutation < 18; mutation += 1)
    {
        fixtures(directory, argv[3], argv[4], mutation);
        char output[4096], errors[4096], reference[4096];
        path_of(output, directory, "output.tsv");
        path_of(errors, directory, "errors.txt");
        path_of(reference, directory, "reference.tsv");
        char* args[4] = { argv[1], directory, argv[4], NULL };
        const int status = invoke(argv[1], args, output, errors);
        struct stat info;
        require(stat(output, &info) == 0);
        bool one = mutation == 0 ? status == 0 && info.st_size > 0 : status != 0 && info.st_size == 0;
        if (mutation == 0)
        {
            char* original[3] = { argv[2], argv[3], NULL };
            one = invoke(argv[2], original, reference, errors) == 0 && equal_files(output, reference) && one;
        }
        if (!one)
        {
            fprintf(stderr, "reader-fixtures: mutation %u FAILED (status %d, output %lld bytes)\n", mutation, status, (long long)info.st_size);
        }
        checks += 1;
        valid = one && valid;
        remove_files(directory);
    }
    require(rmdir(directory) == 0);
    fprintf(stderr, "reader-fixtures: %u synthetic end-to-end cases %s; valid arithmetic matches unchanged prototype byte-for-byte\n", checks, valid ? "passed" : "FAILED");
    return valid ? 0 : 1;
}
