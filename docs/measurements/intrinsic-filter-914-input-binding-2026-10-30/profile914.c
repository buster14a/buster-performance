// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin. See LICENSE.
// PREPARATION ONLY: this prospective pin correction is unbuilt/unexecuted. See PLAN.md.
// Original bounded controller. Existing perf/reader programs are external dependencies.
#define _GNU_SOURCE
#include <ctype.h>
#include <dirent.h>
#include <errno.h>
#include <fcntl.h>
#include <limits.h>
#include <sched.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <sys/utsname.h>
#include <sys/wait.h>
#include <time.h>
#include <unistd.h>

#define BUSTER_PROFILE_RUNS 30
#define BUSTER_PROFILE_IDENTITIES 14
#define BUSTER_PROFILE_PREFIX "/home/david/buster-fast-bench/codex-pr914-input-binding-"

typedef struct ProfileIdentity ProfileIdentity;
struct ProfileIdentity
{
    char path[PATH_MAX];
    const char* expected;
    char before[65];
};

static char* const profile_environment[] = {
    (char*)"HOME=/home/david",
    (char*)"PATH=/usr/bin:/bin",
    (char*)"LC_ALL=C",
    (char*)"LANG=C",
    NULL,
};

static bool profile_path(char path[PATH_MAX], const char* root, const char* suffix)
{
    const int size = snprintf(path, PATH_MAX, "%s/%s", root, suffix);
    return size > 0 && size < PATH_MAX;
}

static bool profile_hash_text(const char* text)
{
    bool valid = strlen(text) == 64;
    for (size_t i = 0; valid && i < 64; i += 1)
    {
        valid = (text[i] >= '0' && text[i] <= '9') || (text[i] >= 'a' && text[i] <= 'f');
    }
    return valid;
}

static bool profile_root(const char* root)
{
    char actual[PATH_MAX];
    struct stat status;
    bool valid = strlen(root) < PATH_MAX && strncmp(root, BUSTER_PROFILE_PREFIX, sizeof(BUSTER_PROFILE_PREFIX) - 1) == 0 &&
                 strlen(root) > sizeof(BUSTER_PROFILE_PREFIX) - 1 && realpath(root, actual) != NULL && strcmp(root, actual) == 0 &&
                 lstat(root, &status) == 0 && S_ISDIR(status.st_mode) && status.st_uid == getuid() && (status.st_mode & 0022) == 0;
    for (size_t i = 0; valid && root[i] != 0; i += 1)
    {
        valid = isalnum((unsigned char)root[i]) || root[i] == '/' || root[i] == '-' || root[i] == '_' || root[i] == '.';
    }
    return valid;
}

static void profile_time(FILE* receipt, const char* label)
{
    struct timespec now;
    struct tm utc;
    char text[32] = { 0 };
    if (clock_gettime(CLOCK_REALTIME, &now) == 0 && gmtime_r(&now.tv_sec, &utc) != NULL &&
        strftime(text, sizeof(text), "%Y-%m-%dT%H:%M:%S", &utc) != 0)
    {
        fprintf(receipt, "time\t%s\t%s.%09ldZ\n", label, text, now.tv_nsec);
    }
    else
    {
        fprintf(receipt, "time\t%s\tUNAVAILABLE\n", label);
    }
    fflush(receipt);
}

static bool profile_host(FILE* receipt)
{
    struct utsname system;
    bool valid = uname(&system) == 0 && strcmp(system.sysname, "Linux") == 0 && strcmp(system.machine, "x86_64") == 0;
    if (valid)
    {
        fprintf(receipt, "host_kernel\t%s\t%s\t%s\n", system.sysname, system.release, system.machine);
    }
    FILE* input = fopen("/proc/cpuinfo", "r");
    valid = input != NULL && valid;
    uint32_t models = 0;
    if (input != NULL)
    {
        char line[1024];
        while (fgets(line, sizeof(line), input) != NULL)
        {
            if (strncmp(line, "model name", 10) == 0)
            {
                models += 1;
                valid = strstr(line, "AMD Ryzen 7 9700X") != NULL && valid;
                if (models == 1)
                {
                    fprintf(receipt, "host_cpu\t%s", line);
                }
            }
        }
        valid = !ferror(input) && models != 0 && valid;
        valid = fclose(input) == 0 && valid;
    }
    fprintf(receipt, "host_identity\t%s\n", valid ? "PASS" : "FAIL");
    fflush(receipt);
    return valid;
}

static int profile_wait(pid_t child)
{
    int status = 0;
    pid_t waited = -1;
    if (child > 0)
    {
        do
        {
            waited = waitpid(child, &status, 0);
        }
        while (waited < 0 && errno == EINTR);
    }
    return child > 0 && waited == child && WIFEXITED(status) ? WEXITSTATUS(status) : 125;
}

static int profile_command(char* const arguments[], const char* directory, int output, pid_t* actual_child, FILE* receipt)
{
    if (receipt != NULL)
    {
        for (size_t i = 0; arguments[i] != NULL; i += 1)
        {
            fprintf(receipt, "argv\t%zu\t%s\n", i, arguments[i]);
        }
        fflush(receipt);
    }
    const pid_t child = fork();
    if (child == 0)
    {
        const bool ready = (directory == NULL || chdir(directory) == 0) &&
                           (output < 0 || (dup2(output, STDOUT_FILENO) == STDOUT_FILENO && dup2(output, STDERR_FILENO) == STDERR_FILENO));
        if (ready)
        {
            execve(arguments[0], arguments, profile_environment);
        }
        _exit(127);
    }
    if (actual_child != NULL)
    {
        *actual_child = child;
    }
    const int result = profile_wait(child);
    if (receipt != NULL)
    {
        fprintf(receipt, "command_status\t%d\n", result);
        fflush(receipt);
    }
    return result;
}

static bool profile_digest(const char* path, char digest[65])
{
    int channels[2] = { -1, -1 };
    bool valid = pipe2(channels, O_CLOEXEC) == 0;
    pid_t child = -1;
    if (valid)
    {
        child = fork();
        if (child == 0)
        {
            if (dup2(channels[1], STDOUT_FILENO) == STDOUT_FILENO)
            {
                char* const arguments[] = { (char*)"/usr/bin/sha256sum", (char*)"--", (char*)path, NULL };
                execve(arguments[0], arguments, profile_environment);
            }
            _exit(127);
        }
        close(channels[1]);
        channels[1] = -1;
        FILE* output = fdopen(channels[0], "r");
        valid = output != NULL;
        if (output != NULL)
        {
            char line[PATH_MAX + 128];
            valid = fgets(line, sizeof(line), output) != NULL && strlen(line) >= 67 && line[64] == ' ';
            if (valid)
            {
                memcpy(digest, line, 64);
                digest[64] = 0;
                valid = profile_hash_text(digest) && fgetc(output) == EOF && !ferror(output);
            }
            valid = fclose(output) == 0 && valid;
            channels[0] = -1;
        }
        valid = profile_wait(child) == 0 && valid;
    }
    if (channels[0] >= 0)
    {
        close(channels[0]);
    }
    if (channels[1] >= 0)
    {
        close(channels[1]);
    }
    return valid;
}

static bool profile_checked_hash(const char* path, const char* expected, FILE* receipt)
{
    char actual[65] = { 0 };
    const bool valid = profile_digest(path, actual) && strcmp(actual, expected) == 0;
    fprintf(receipt, "checked_sha256\t%s\t%s\t%s\t%s\n", path, expected, actual, valid ? "PASS" : "FAIL");
    fflush(receipt);
    return valid;
}

static bool profile_relative_name(const char* path)
{
    bool valid = path[0] != 0 && path[0] != '/' && strlen(path) < PATH_MAX;
    const char* segment = path;
    for (const char* p = path; valid; p += 1)
    {
        const unsigned char c = (unsigned char)*p;
        valid = c == 0 || (c >= 32 && c < 127 && c != '\\');
        if (valid && (c == '/' || c == 0))
        {
            const size_t size = (size_t)(p - segment);
            valid = size != 0 && !(size == 1 && segment[0] == '.') && !(size == 2 && segment[0] == '.' && segment[1] == '.');
            segment = p + 1;
        }
        if (c == 0)
        {
            break;
        }
    }
    return valid;
}

// Private snapshot only: no writable nodes, hardlinked files, symlinks, sockets or devices.
static bool profile_tree(const char* path, uint32_t depth, uint64_t* files)
{
    struct stat status;
    bool valid = depth < 64 && lstat(path, &status) == 0 && (status.st_mode & 0222) == 0;
    if (valid && S_ISREG(status.st_mode))
    {
        valid = status.st_nlink == 1;
        *files += valid;
    }
    else if (valid && S_ISDIR(status.st_mode))
    {
        DIR* directory = opendir(path);
        valid = directory != NULL;
        if (directory != NULL)
        {
            struct dirent* entry;
            errno = 0;
            while (valid && (entry = readdir(directory)) != NULL)
            {
                if (strcmp(entry->d_name, ".") != 0 && strcmp(entry->d_name, "..") != 0)
                {
                    char child[PATH_MAX];
                    valid = profile_path(child, path, entry->d_name) && profile_tree(child, depth + 1, files);
                }
                errno = 0;
            }
            valid = errno == 0 && valid;
            valid = closedir(directory) == 0 && valid;
        }
    }
    else
    {
        valid = false;
    }
    return valid;
}

static bool profile_manifest(const char* root, const char* directory_name, const char* manifest_name, const char* expected, FILE* receipt)
{
    char directory[PATH_MAX];
    char manifest[PATH_MAX];
    bool valid = profile_path(directory, root, directory_name) && profile_path(manifest, root, manifest_name) &&
                 profile_checked_hash(manifest, expected, receipt);
    FILE* input = valid ? fopen(manifest, "r") : NULL;
    valid = input != NULL && valid;
    uint64_t listed = 0;
    if (input != NULL)
    {
        char* line = NULL;
        size_t capacity = 0;
        ssize_t size;
        while (valid && (size = getline(&line, &capacity, input)) >= 0)
        {
            valid = size > 67 && size < PATH_MAX + 68 && line[size - 1] == '\n' && line[64] == ' ' && line[65] == ' ';
            if (valid)
            {
                line[size - 1] = 0;
                char hash[65];
                memcpy(hash, line, 64);
                hash[64] = 0;
                valid = profile_hash_text(hash) && profile_relative_name(line + 66);
                listed += valid;
            }
        }
        valid = !ferror(input) && listed != 0 && valid;
        free(line);
        valid = fclose(input) == 0 && valid;
    }
    uint64_t actual = 0;
    valid = valid && profile_tree(directory, 0, &actual) && actual == listed;
    if (valid)
    {
        char* const arguments[] = { (char*)"/usr/bin/sha256sum", (char*)"--check", (char*)"--strict", (char*)"--status", manifest, NULL };
        valid = profile_command(arguments, directory, -1, NULL, receipt) == 0;
    }
    fprintf(receipt, "manifest\t%s\tlisted=%llu\tactual=%llu\t%s\n", directory, (unsigned long long)listed, (unsigned long long)actual, valid ? "PASS" : "FAIL");
    fflush(receipt);
    return valid;
}

static bool profile_inputs(const char* root, const char* phase, FILE* receipt)
{
    profile_time(receipt, phase);
    char path[PATH_MAX];
    static const char* const parents[] = { "inputs", "inputs/manifests", "inputs/provenance" };
    bool valid = true;
    for (size_t i = 0; i < sizeof(parents) / sizeof(parents[0]); i += 1)
    {
        struct stat status;
        valid = profile_path(path, root, parents[i]) && lstat(path, &status) == 0 && S_ISDIR(status.st_mode) && (status.st_mode & 0222) == 0 && valid;
    }
    uint64_t snapshot_files = 0;
    valid = profile_path(path, root, "inputs") && profile_tree(path, 0, &snapshot_files) && valid;
    fprintf(receipt, "private_readonly_snapshot_files\t%llu\t%s\n", (unsigned long long)snapshot_files, valid ? "PASS" : "FAIL");
    valid = profile_path(path, root, "dependencies/preprocessor-391e729af658-ci.tar.zst") &&
            profile_checked_hash(path, "ceb39bf938cd7a7469bbb53646c3318d0cbfdac4d37b6d05b183c4fd0b9898c2", receipt) && valid;
    valid = profile_manifest(root, "inputs/headers", "inputs/manifests/headers-bundle.sha256", "e307b836448ef20e603a617a4b5023831c72ff5f307f614c50f4f8833088717c", receipt) && valid;
    valid = profile_manifest(root, "inputs/sqlite", "inputs/manifests/sqlite.sha256", "9179b7ad7db7366d12a214b562e478ac703e7ec0376f38f4516756bcf7ee0047", receipt) && valid;
    uint64_t predefines_count = 0;
    valid = profile_path(path, root, "inputs/provenance/gnu17-pinned-predefines.txt") && profile_tree(path, 0, &predefines_count) && predefines_count == 1 &&
            profile_checked_hash(path, "a39036d8215977b5a205f7fd3c4e7dfe6576b58eaa76a7bb0b0e214a164e8d33", receipt) && valid;
    valid = profile_path(path, root, "inputs/sqlite/sqlite3.c") &&
            profile_checked_hash(path, "0a409f1633283fa31a9126b11fbfd64a1991c5d30defad07e5745d4667f5e23d", receipt) && valid;
    fprintf(receipt, "input_verification\t%s\t%s\n", phase, valid ? "PASS" : "FAIL");
    fflush(receipt);
    return valid;
}

static bool profile_identities(const char* root, const char* self_hash, bool after, ProfileIdentity identities[BUSTER_PROFILE_IDENTITIES], FILE* receipt)
{
    static const char* const relative[] = { "bin/base/compiler", "bin/head/compiler", "tools/profile914", "tools/attribution914", "tools/reuse_exec.so" };
    static const char* const expected[] = {
        "e0bbf2ced14fc4bb38c2073887b0fac5f8bf694789f8c9d71b726db8f292f7bf",
        "67d5039a94d367f1d8f9b61ace82fb0b9b0ad699d5360bb4979367c247d85c75",
        NULL,
        "e1bc2b42ee0668ff5077f46bd4e13acbf0f2428913e07da8fbb39f42c88e8038",
        "534d7636ea4ae41142c535b5646e2b8d864e2615b53a99a9548e4b7485b4fbc2",
    };
    static const char* const external[] = {
        "/usr/bin/perf", "/usr/lib/libc.so.6", "/usr/lib/ld-linux-x86-64.so.2", "/usr/lib/libdw.so.1", "/usr/lib/libelf.so.1",
        "/usr/bin/taskset", "/usr/bin/sha256sum", "/usr/bin/timeout", "/home/david/buster-fast-bench/exclusive.sh",
    };
    // Recording-host identities from the authorized 2026-10-30 read-only preflight.
    // Historical offline-analysis identities remain separately named in DEPENDENCIES.tsv.
    static const char* const external_expected[] = {
        "a6da58ffc54b3c9bfe8d0d046ade1dbc70e8f5121932e35de916ad39162f7d4f",
        "02c8c3d06180beee9c7d0392aa85736c7d19f274a81e7f8f0b3d9e28e0641524",
        "f5e11cc62f8f2c24dff532982559f4303dba3b17e7450551372a88c8e7ea8757",
        "14a4563f6fce1ce85c449ee79f0d877984ecb16c71b18103b72b2b4f57dc8786",
        "13d3e3cb54d6120d87a0569ac67be05c029f8cd2e4bf44e75936b2721c8e08af",
        NULL, NULL, NULL, NULL,
    };
    bool valid = profile_hash_text(self_hash);
    for (size_t i = 0; i < BUSTER_PROFILE_IDENTITIES; i += 1)
    {
        if (!after)
        {
            if (i < sizeof(relative) / sizeof(relative[0]))
            {
                valid = profile_path(identities[i].path, root, relative[i]) && valid;
                identities[i].expected = i == 2 ? self_hash : expected[i];
            }
            else
            {
                const size_t n = i - sizeof(relative) / sizeof(relative[0]);
                snprintf(identities[i].path, sizeof(identities[i].path), "%s", external[n]);
                identities[i].expected = external_expected[n];
            }
        }
        char digest[65] = { 0 };
        const bool read = profile_digest(identities[i].path, digest);
        const bool correct = read && (identities[i].expected == NULL || strcmp(digest, identities[i].expected) == 0) &&
                             (!after || strcmp(digest, identities[i].before) == 0);
        if (!after && read)
        {
            memcpy(identities[i].before, digest, sizeof(digest));
        }
        fprintf(receipt, "identity\t%s\t%s\t%s\t%s\n", after ? "after" : "before", identities[i].path, digest, correct ? "PASS" : "FAIL");
        valid = correct && valid;
    }
    fflush(receipt);
    return valid;
}

static int profile_compiles(const char* root, const char* arm)
{
    char executable[PATH_MAX], predefines[PATH_MAX], clang_headers[PATH_MAX], local_headers[PATH_MAX], system_headers[PATH_MAX];
    char sqlite[PATH_MAX], includes[PATH_MAX], output[PATH_MAX], receipt_path[PATH_MAX], suffix[128];
    snprintf(suffix, sizeof(suffix), "bin/%s/compiler", arm);
    bool valid = profile_path(executable, root, suffix) && profile_path(predefines, root, "inputs/provenance/gnu17-pinned-predefines.txt") &&
                 profile_path(clang_headers, root, "inputs/headers/usr/lib/clang/23/include") && profile_path(local_headers, root, "inputs/headers/usr/local/include") &&
                 profile_path(system_headers, root, "inputs/headers/usr/include") && profile_path(sqlite, root, "inputs/sqlite/sqlite3.c") &&
                 profile_path(includes, root, "inputs/sqlite");
    snprintf(suffix, sizeof(suffix), "results/%s/sqlite.o", arm);
    valid = profile_path(output, root, suffix) && valid;
    snprintf(suffix, sizeof(suffix), "results/%s/processes.tsv", arm);
    valid = profile_path(receipt_path, root, suffix) && valid;
    char* const arguments[] = {
        executable, (char*)"-c", (char*)"-DSQLITE_OMIT_LOAD_EXTENSION", (char*)"-DSQLITE_THREADSAFE=0", (char*)"-DSQLITE_ENABLE_MEMSYS5",
        (char*)"-DSQLITE_ENABLE_RTREE", (char*)"--predefines", predefines, (char*)"--clang-features", (char*)"-march=znver5", (char*)"-std=gnu17",
        (char*)"-nostdinc", (char*)"-isystem", clang_headers, (char*)"-isystem", local_headers, (char*)"-isystem", system_headers,
        (char*)"-I", includes, sqlite, (char*)"-o", output, NULL,
    };
    char argv_path[PATH_MAX];
    snprintf(suffix, sizeof(suffix), "results/%s/compiler-argv.txt", arm);
    FILE* argv_receipt = valid && profile_path(argv_path, root, suffix) ? fopen(argv_path, "wx") : NULL;
    valid = argv_receipt != NULL && valid;
    if (argv_receipt != NULL)
    {
        for (size_t i = 0; arguments[i] != NULL; i += 1)
        {
            valid = fprintf(argv_receipt, "%zu\t%s\n", i, arguments[i]) > 0 && valid;
        }
        valid = fclose(argv_receipt) == 0 && valid;
    }
    FILE* receipt = valid ? fopen(receipt_path, "wx") : NULL;
    valid = receipt != NULL && fcntl(fileno(receipt), F_SETFD, FD_CLOEXEC) == 0 && valid;
    for (uint32_t run = 0; valid && run < BUSTER_PROFILE_RUNS; run += 1)
    {
        fflush(receipt);
        const pid_t child = fork();
        if (child == 0)
        {
            cpu_set_t mask;
            CPU_ZERO(&mask);
            CPU_SET(2, &mask);
            if (sched_setaffinity(0, sizeof(mask), &mask) == 0)
            {
                execve(executable, arguments, profile_environment);
            }
            _exit(127);
        }
        const int status = profile_wait(child);
        fprintf(receipt, "%u\t%ld\t%d\n", run, (long)child, status);
        fflush(receipt);
        valid = child > 0 && status == 0;
    }
    if (receipt != NULL)
    {
        valid = fclose(receipt) == 0 && valid;
    }
    return valid ? 0 : 1;
}

static bool profile_successes(const char* path, FILE* receipt)
{
    FILE* input = fopen(path, "r");
    bool valid = input != NULL;
    long pids[BUSTER_PROFILE_RUNS] = { 0 };
    uint32_t count = 0;
    if (input != NULL)
    {
        char line[128];
        while (valid && fgets(line, sizeof(line), input) != NULL)
        {
            unsigned index = 0;
            long pid = 0;
            int status = -1;
            int used = 0;
            valid = count < BUSTER_PROFILE_RUNS && sscanf(line, "%u\t%ld\t%d%n", &index, &pid, &status, &used) == 3 &&
                    line[used] == '\n' && line[used + 1] == 0 && index == count && pid > 0 && status == 0;
            for (uint32_t i = 0; valid && i < count; i += 1)
            {
                valid = pids[i] != pid;
            }
            if (valid)
            {
                pids[count++] = pid;
            }
        }
        valid = !ferror(input) && count == BUSTER_PROFILE_RUNS && valid;
        valid = fclose(input) == 0 && valid;
    }
    fprintf(receipt, "successful_fresh_compiler_processes\t%u\t%s\n", count, valid ? "PASS" : "FAIL");
    fflush(receipt);
    return valid;
}

static int profile_arm(const char* root, const char* arm, const char* self_hash)
{
    char results[PATH_MAX], directory[PATH_MAX], suffix[128], receipt_path[PATH_MAX], log_path[PATH_MAX], capture[PATH_MAX], self[PATH_MAX];
    char predecessor[PATH_MAX];
    struct stat status;
    bool valid = strcmp(arm, "base") == 0 || (profile_path(predecessor, root, "results/base/collection.complete") &&
                 lstat(predecessor, &status) == 0 && S_ISREG(status.st_mode) && status.st_nlink == 1);
    snprintf(suffix, sizeof(suffix), "results/%s", arm);
    valid = profile_path(results, root, "results") && profile_path(directory, root, suffix) &&
            (mkdir(results, 0700) == 0 || errno == EEXIST) && lstat(results, &status) == 0 && S_ISDIR(status.st_mode) && status.st_uid == getuid() &&
            (status.st_mode & 0022) == 0 && valid;
    valid = valid && mkdir(directory, 0700) == 0 && profile_path(receipt_path, directory, "arm.tsv") && profile_path(log_path, directory, "profile.log") &&
            profile_path(capture, directory, "profile.perf.data") && profile_path(self, root, "tools/profile914");
    FILE* receipt = valid ? fopen(receipt_path, "wx") : NULL;
    valid = receipt != NULL && fcntl(fileno(receipt), F_SETFD, FD_CLOEXEC) == 0 && valid;
    if (receipt != NULL)
    {
        profile_time(receipt, "arm_begin");
        fprintf(receipt, "arm\t%s\nsource\t%s\ninput_root\t%s/inputs\nsource_order\tbase,head\nenvironment\tHOME=/home/david PATH=/usr/bin:/bin LC_ALL=C LANG=C\n",
                arm, strcmp(arm, "base") == 0 ? "d12fd5831f9c73bb7b30505da2ce9616e915143e" : "58b1191558fbef0b542cbe92b1e2da329f16d7b6", root);
        cpu_set_t allowed;
        CPU_ZERO(&allowed);
        valid = sched_getaffinity(0, sizeof(allowed), &allowed) == 0 && CPU_ISSET(2, &allowed) && CPU_ISSET(3, &allowed) &&
                getenv("BUSTER_9700X_HELD") != NULL && getenv("EXCLUSIVE_OWNER") != NULL &&
                strcmp(getenv("EXCLUSIVE_OWNER"), "codex-reviewer-914-input-binding") == 0 && valid;
        fprintf(receipt, "allowed_cpus");
        for (uint32_t cpu = 0; cpu < CPU_SETSIZE; cpu += 1)
        {
            if (CPU_ISSET(cpu, &allowed))
            {
                fprintf(receipt, "\t%u", cpu);
            }
        }
        fprintf(receipt, "\nfixed_recording\tcycles:u period=250003 stack=4096 writer=1M compiler_cpu=2 recorder_cpu=3 runs=30\n");
        ProfileIdentity identities[BUSTER_PROFILE_IDENTITIES] = { 0 };
        valid = valid && profile_host(receipt) && profile_identities(root, self_hash, false, identities, receipt) && profile_inputs(root, "before", receipt);
        const int output = valid ? open(log_path, O_CREAT | O_EXCL | O_WRONLY | O_CLOEXEC, 0600) : -1;
        valid = output >= 0 && valid;
        if (valid)
        {
            char* const arguments[] = {
                (char*)"/usr/bin/taskset", (char*)"-c", (char*)"3", (char*)"/usr/bin/perf", (char*)"record", (char*)"-m", (char*)"1M",
                (char*)"--no-buildid-cache", (char*)"-T", (char*)"-e", (char*)"cycles:u", (char*)"-c", (char*)"250003", (char*)"--call-graph",
                (char*)"dwarf,4096", (char*)"--sample-cpu", (char*)"--period", (char*)"-o", capture, (char*)"--", self, (char*)"--compile30", (char*)arm,
                (char*)root, NULL,
            };
            profile_time(receipt, "profile_begin");
            const int status = profile_command(arguments, root, output, NULL, receipt);
            profile_time(receipt, "profile_end");
            close(output);
            char processes[PATH_MAX];
            const bool statuses = profile_path(processes, directory, "processes.tsv") && profile_successes(processes, receipt);
            // Always check consumed bytes and dependencies after an attempted profile, including failure.
            const bool inputs_after = profile_inputs(root, "after", receipt);
            const bool tools_after = profile_identities(root, self_hash, true, identities, receipt);
            char object[PATH_MAX];
            char digest[65] = { 0 };
            const bool saved = profile_path(object, directory, "sqlite.o") && profile_digest(object, digest);
            fprintf(receipt, "output_sha256\t%s\t%s\n", saved ? digest : "UNAVAILABLE", saved ? "RECORDED" : "FAIL");
            char capture_digest[65] = { 0 };
            const bool captured = profile_digest(capture, capture_digest);
            fprintf(receipt, "capture_sha256\t%s\t%s\n", capture_digest, captured ? "RECORDED" : "FAIL");
            valid = status == 0 && statuses && inputs_after && tools_after && saved && captured;
        }
        fprintf(receipt, "collection_status\t%s\noffline_loss_cfi_caller_and_pair_acceptance\tNOT_PERFORMED\n",
                valid ? "COMPLETE_PENDING_OFFLINE_GATES" : "FAILED_OR_INCOMPLETE");
        profile_time(receipt, "arm_end");
        valid = fclose(receipt) == 0 && valid;
    }
    if (valid)
    {
        char completed[PATH_MAX];
        FILE* marker = profile_path(completed, directory, "collection.complete") ? fopen(completed, "wx") : NULL;
        valid = marker != NULL;
        if (marker != NULL)
        {
            valid = fprintf(marker, "%s\n", arm) > 0 && valid;
            valid = fclose(marker) == 0 && valid;
        }
    }
    return valid ? 0 : 1;
}

int main(int argument_count, char** arguments)
{
    int result = 2;
    const bool mode = argument_count >= 4 && (strcmp(arguments[1], "--arm") == 0 || strcmp(arguments[1], "--compile30") == 0);
    const bool arm = mode && (strcmp(arguments[2], "base") == 0 || strcmp(arguments[2], "head") == 0);
    const bool root = arm && profile_root(arguments[3]);
    if (root && argument_count == 5 && strcmp(arguments[1], "--arm") == 0 && profile_hash_text(arguments[4]))
    {
        result = profile_arm(arguments[3], arguments[2], arguments[4]);
    }
    else if (root && argument_count == 4 && strcmp(arguments[1], "--compile30") == 0)
    {
        result = profile_compiles(arguments[3], arguments[2]);
    }
    else
    {
        fprintf(stderr, "usage: profile914 --arm base|head NEW_PRIVATE_ROOT APPROVED_WRAPPER_SHA256\n");
    }
    return result;
}
