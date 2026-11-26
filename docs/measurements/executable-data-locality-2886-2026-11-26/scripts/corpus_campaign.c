// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
// Original #2886 extended-corpus page-residency campaign, adapted from this record's census_campaign.c.
// Census instrumentation only, never a timing benchmark. No third-party implementation is embedded here.
// Usage: corpus_campaign COMPILER OUTPUT_DIRECTORY ROOT CORPUS [--input NAME] [--mode direct|legacy]
// ROOT holds evidence/datapages. CORPUS is the verified frozen CI corpus. All four paths must be absolute.
// SQLite flags: buster .github/workflows/hosted-correctness.yml, frozen object comparison step.
// This container lacks Clang's default resource headers; SQLite additionally uses the frozen snapshot's complete
// system include order with -nostdinc. Both binary revisions receive the same explicit paths and original defines.
// Musl flags: executable-pages-2873-2026-11-16/scripts/musl-common.sh in buster-performance.
#define _GNU_SOURCE
#include <errno.h>
#include <fcntl.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <unistd.h>

static bool object_hash(const char* path, FILE* hashes, const char* input, const char* mode, unsigned round)
{
    int channel[2];
    bool good = pipe2(channel, O_CLOEXEC) == 0;
    pid_t child = good ? fork() : -1;
    if (child == 0)
    {
        dup2(channel[1], STDOUT_FILENO);
        execlp("sha256sum", "sha256sum", path, (char*)NULL);
        _exit(125);
    }
    char result[65] = { 0 };
    size_t used = 0;
    if (good)
    {
        close(channel[1]);
        while (child > 0 && used < 64)
        {
            const ssize_t count = read(channel[0], result + used, 64 - used);
            if (count > 0) used += (size_t)count;
            else if (count < 0 && errno == EINTR) continue;
            else break;
        }
        close(channel[0]);
    }
    int status = 125 << 8;
    pid_t waited = -1;
    if (child > 0)
    {
        do { waited = waitpid(child, &status, 0); } while (waited < 0 && errno == EINTR);
    }
    struct stat object;
    good = good && child > 0 && waited == child && WIFEXITED(status) && WEXITSTATUS(status) == 0 && used == 64 && stat(path, &object) == 0;
    for (unsigned index = 0; good && index < 64; index += 1)
    {
        good = (result[index] >= '0' && result[index] <= '9') || (result[index] >= 'a' && result[index] <= 'f');
    }
    if (good)
    {
        fprintf(hashes, "%s\t%s\t%u\t%s\t%llu\n", input, mode, round, result, (unsigned long long)object.st_size);
        good = fflush(hashes) == 0;
    }
    return good;
}

static int wait_for(pid_t child)
{
    int status = 125 << 8;
    pid_t waited;
    do
    {
        waited = waitpid(child, &status, 0);
    } while (waited < 0 && errno == EINTR);
    return waited == child && WIFEXITED(status) ? WEXITSTATUS(status) : 125;
}

static bool warm_file(const char* path)
{
    const int file = open(path, O_RDONLY | O_CLOEXEC);
    char buffer[65536];
    ssize_t length = 1;
    while (file >= 0 && length > 0)
    {
        length = read(file, buffer, sizeof(buffer));
    }
    const bool good = file >= 0 && length == 0;
    if (file >= 0)
    {
        close(file);
    }
    return good;
}

static bool fresh_copy(const char* source, const char* path, FILE* commands)
{
    const int input = open(source, O_RDONLY | O_CLOEXEC);
    // Always a new inode, copied with ordinary read/write: no reflink and no reused page-cache mapping.
    unlink(path);
    const int output = input >= 0 ? open(path, O_WRONLY | O_CREAT | O_EXCL | O_CLOEXEC, 0755) : -1;
    bool good = input >= 0 && output >= 0;
    char buffer[65536];
    ssize_t length = 1;
    uint64_t total = 0;
    while (good && length > 0)
    {
        length = read(input, buffer, sizeof(buffer));
        good = length >= 0;
        ssize_t written = 0;
        while (good && written < length)
        {
            const ssize_t count = write(output, buffer + written, (size_t)(length - written));
            good = count > 0;
            written += count > 0 ? count : 0;
        }
        total += length > 0 ? (uint64_t)length : 0;
    }
    struct stat status;
    good = good && !fstat(output, &status) && (uint64_t)status.st_size == total;
    if (good)
    {
        fprintf(commands, "copy-source\t%s\ncopy-destination\t%s\ncopy-bytes\t%llu\ncopy-device\t%llu\ncopy-inode\t%llu\n",
                source, path, (unsigned long long)total, (unsigned long long)status.st_dev, (unsigned long long)status.st_ino);
    }
    if (input >= 0) close(input);
    if (output >= 0) good = close(output) == 0 && good;
    return good && warm_file(path);
}

int main(int argc, char** argv)
{
    const char* root = argc >= 4 ? argv[3] : "";
    const bool fresh = true;
    const bool base_pages = true;
    const char* corpus = argc >= 5 ? argv[4] : "";
    const char* only_input = NULL;
    const char* only_mode = NULL;
    bool options = true;
    for (int index = 5; options && index < argc; index += 1)
    {
        if (!strcmp(argv[index], "--input") && index + 1 < argc) only_input = argv[++index];
        else if (!strcmp(argv[index], "--mode") && index + 1 < argc) only_mode = argv[++index];
        else options = false;
    }
    const struct Input
    {
        const char* name;
        const char* path;
        bool sqlite;
    } inputs[] = {
        { "sqlite3", "sqlite/sqlite3.c", true },
        { "musl-vfprintf", "libc/musl/src/stdio/vfprintf.c", false },
        { "musl-strtol", "libc/musl/src/stdlib/strtol.c", false },
        { "musl-lite_malloc", "libc/musl/src/malloc/lite_malloc.c", false },
    };
    bool input_known = only_input == NULL;
    for (unsigned input = 0; input < sizeof(inputs) / sizeof(inputs[0]); input += 1)
    {
        input_known |= only_input && !strcmp(only_input, inputs[input].name);
    }
    const bool mode_known = !only_mode || !strcmp(only_mode, "direct") || !strcmp(only_mode, "legacy");
    bool good = argc >= 5 && options && input_known && mode_known && root[0] == '/' && corpus[0] == '/' && argv[1][0] == '/' && argv[2][0] == '/';
    if (!good)
    {
        fprintf(stderr, "usage: corpus_campaign /absolute/COMPILER /absolute/OUTPUT_DIRECTORY /absolute/ROOT /absolute/CORPUS [--input NAME] [--mode direct|legacy]\n");
    }
    if (good)
    {
        good = (mkdir(argv[2], 0777) == 0 || errno == EEXIST) && chdir(root) == 0 &&
               setenv("BUSTER_HUGE_PAGES", "0", 1) == 0 && setenv("BUSTER_EXECUTABLE_HUGE_PAGES", "0", 1) == 0 &&
               unsetenv("BUSTER_NO_DIRECT") == 0 && unsetenv("SOURCE_DATE_EPOCH") == 0;
    }
    char receipt[4096];
    snprintf(receipt, sizeof(receipt), "%s/commands.txt", good ? argv[2] : ".");
    FILE* commands = good ? fopen(receipt, "w") : NULL;
    snprintf(receipt, sizeof(receipt), "%s/object-hashes.tsv", good ? argv[2] : ".");
    FILE* hashes = good ? fopen(receipt, "w") : NULL;
    good = good && commands && hashes;
    if (good)
    {
        fprintf(commands, "cwd\t%s\nenvironment\tBUSTER_HUGE_PAGES=0\nenvironment\tBUSTER_EXECUTABLE_HUGE_PAGES=0\n"
                "unset\tBUSTER_NO_DIRECT\nunset\tSOURCE_DATE_EPOCH\nhelper-environment\tBUSTER_EXIT_HELPER=1\n"
                "helper-environment\tBUSTER_TEST_EXIT_HELPER_PAUSE=2000\n", root);
        fprintf(commands, "warming\t%s\n", fresh ? "fresh read/write executable copy per input/mode; read entire copy; same inode for three runs; remove after runs" :
                "read entire compiler once before census runs");
        fprintf(commands, "base-pages-control\t%d\n", base_pages);
        fprintf(commands, "corpus\t%s\n", corpus);
        fprintf(hashes, "input\tmode\tround\tsha256\tbytes\n");
        good = fresh || warm_file(argv[1]);
    }
    unsigned failed = 0;
    for (unsigned input = 0; good && input < sizeof(inputs) / sizeof(inputs[0]); input += 1)
    {
        if (only_input && strcmp(only_input, inputs[input].name)) continue;
        for (unsigned mode = 0; good && mode < 2; mode += 1)
        {
            if (only_mode && strcmp(only_mode, mode ? "legacy" : "direct")) continue;
            char copied[4096];
            snprintf(copied, sizeof(copied), "%s/compiler-%s-%s", argv[2], inputs[input].name, mode ? "legacy" : "direct");
            good = !fresh || fresh_copy(argv[1], copied, commands);
            for (unsigned round = 1; good && round <= 3; round += 1)
            {
                char source[4096], object[4096], report[4096], log[4096], helper[4096], includes[7][4096];
                const char* mode_name = mode ? "legacy" : "direct";
                snprintf(source, sizeof(source), "%s/%s", corpus, inputs[input].path);
                snprintf(object, sizeof(object), "%s/%s-%s.o", argv[2], inputs[input].name, mode_name);
                snprintf(report, sizeof(report), "%s/%s-%s-%u.tsv.gz", argv[2], inputs[input].name, mode_name, round);
                snprintf(log, sizeof(log), "%s/%s-%s-%u.log", argv[2], inputs[input].name, mode_name, round);
                snprintf(helper, sizeof(helper), "%s/evidence/datapages", root);
                char* arguments[48] = { helper, "--pause" };
                unsigned count = 2;
                if (base_pages)
                {
                    arguments[count++] = "--base-pages";
                }
                if (round == 1)
                {
                    arguments[count++] = "--all-pages";
                }
                arguments[count++] = "/dev/stdout";
                arguments[count++] = fresh ? copied : argv[1];
                arguments[count++] = "--lanes";
                arguments[count++] = "1";
                arguments[count++] = "-c";
                if (mode)
                {
                    arguments[count++] = "--no-direct";
                }
                if (inputs[input].sqlite)
                {
                    arguments[count++] = "-DSQLITE_OMIT_LOAD_EXTENSION";
                    arguments[count++] = "-DSQLITE_THREADSAFE=0";
                    arguments[count++] = "-DSQLITE_ENABLE_MEMSYS5";
                    arguments[count++] = "-DSQLITE_ENABLE_RTREE";
                    snprintf(includes[0], sizeof(includes[0]), "-I%s/sqlite", corpus);
                    arguments[count++] = includes[0];
                    arguments[count++] = "-nostdinc";
                    const char* paths[] = {
                        "headers/usr/lib/clang/23/include",
                        "headers/usr/local/include",
                        "headers/usr/include",
                    };
                    for (unsigned include = 0; include < 3; include += 1)
                    {
                        snprintf(includes[include + 1], sizeof(includes[include + 1]), "%s/%s", corpus, paths[include]);
                        arguments[count++] = "-isystem";
                        arguments[count++] = includes[include + 1];
                    }
                }
                else
                {
                    arguments[count++] = "-std=c99";
                    arguments[count++] = "-nostdinc";
                    arguments[count++] = "-ffreestanding";
                    arguments[count++] = "-D_XOPEN_SOURCE=700";
                    const char* paths[] = {
                        "libc/musl/arch/x86_64",
                        "libc/musl/arch/generic",
                        "musl-generated/obj/src/internal",
                        "libc/musl/src/include",
                        "libc/musl/src/internal",
                        "musl-generated/obj/include",
                        "libc/musl/include",
                    };
                    for (unsigned include = 0; include < 7; include += 1)
                    {
                        snprintf(includes[include], sizeof(includes[include]), "%s/%s", corpus, paths[include]);
                        arguments[count++] = "-I";
                        arguments[count++] = includes[include];
                    }
                }
                arguments[count++] = source;
                arguments[count++] = "-o";
                arguments[count++] = object;
                arguments[count] = NULL;
                fprintf(commands, "\nrun\t%s\t%s\t%u\nreport\t%s\nstderr\t%s\n", inputs[input].name, mode_name, round, report, log);
                for (unsigned index = 0; index < count; index += 1)
                {
                    fprintf(commands, "argv\t%u\t%s\n", index, arguments[index]);
                }
                fflush(commands);
                int channel[2];
                const int output = open(report, O_WRONLY | O_CREAT | O_TRUNC | O_CLOEXEC, 0666);
                const int errors = open(log, O_WRONLY | O_CREAT | O_TRUNC | O_CLOEXEC, 0666);
                good = output >= 0 && errors >= 0 && pipe2(channel, O_CLOEXEC) == 0;
                pid_t compressor = good ? fork() : -1;
                if (!compressor)
                {
                    dup2(channel[0], STDIN_FILENO);
                    dup2(output, STDOUT_FILENO);
                    execlp("gzip", "gzip", "-1c", (char*)NULL);
                    _exit(125);
                }
                pid_t census = good && compressor > 0 ? fork() : -1;
                if (!census)
                {
                    dup2(channel[1], STDOUT_FILENO);
                    dup2(errors, STDERR_FILENO);
                    execv(helper, arguments);
                    _exit(125);
                }
                if (good)
                {
                    close(channel[0]);
                    close(channel[1]);
                }
                if (output >= 0) close(output);
                if (errors >= 0) close(errors);
                const int census_status = census > 0 ? wait_for(census) : 125;
                const int compressor_status = compressor > 0 ? wait_for(compressor) : 125;
                good = good && census > 0 && compressor > 0;
                const bool hash_good = census_status == 0 && object_hash(object, hashes, inputs[input].name, mode_name, round);
                failed += census_status || compressor_status || !hash_good;
                fprintf(commands, "census-status\t%d\ncompressor-status\t%d\nobject-hash-status\t%d\n", census_status, compressor_status, hash_good ? 0 : 125);
                printf("%s %s round %u: census=%d compression=%d object-hash=%d\n", inputs[input].name, mode_name, round, census_status, compressor_status, hash_good ? 0 : 125);
                unlink(object);
                fflush(stdout);
            }
            if (fresh)
            {
                unlink(copied);
            }
        }
    }
    if (commands)
    {
        good = fclose(commands) == 0 && good;
    }
    if (hashes)
    {
        good = fclose(hashes) == 0 && good;
    }
    return good && !failed ? 0 : 1;
}
