// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Original #653 alternative-mechanism probe; no compiler implementation or external code is copied.
#define _GNU_SOURCE
#include <errno.h>
#include <fcntl.h>
#include <limits.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/resource.h>
#include <sys/stat.h>
#include <sys/wait.h>
#include <time.h>
#include <unistd.h>

static bool path_join(char* output, size_t capacity, const char* directory, const char* name)
{
    const int length = snprintf(output, capacity, "%s/%s", directory, name);
    return length >= 0 && (size_t)length < capacity;
}

static bool write_marker(const char* path, char value)
{
    const int fd = open(path, O_WRONLY | O_CREAT | O_EXCL | O_CLOEXEC, 0600);
    bool result = fd >= 0 && write(fd, &value, 1) == 1;
    if (fd >= 0)
    {
        result = close(fd) == 0 && result;
    }
    return result;
}

static bool namespace_check(const char* root, char* present, size_t capacity)
{
    char parent[PATH_MAX] = { 0 };
    char leaf[PATH_MAX] = { 0 };
    char old_parent[PATH_MAX] = { 0 };
    char old_leaf[PATH_MAX] = { 0 };
    char old_file[PATH_MAX] = { 0 };
    bool result = path_join(parent, sizeof(parent), root, "parent") && path_join(leaf, sizeof(leaf), parent, "leaf") &&
                  path_join(old_parent, sizeof(old_parent), root, "previous") && path_join(old_leaf, sizeof(old_leaf), old_parent, "leaf") &&
                  path_join(old_file, sizeof(old_file), old_leaf, "header.h") && path_join(present, capacity, leaf, "header.h") &&
                  mkdir(parent, 0700) == 0 && mkdir(leaf, 0700) == 0 && write_marker(present, 'A');
    const int directory = result ? open(leaf, O_PATH | O_DIRECTORY | O_CLOEXEC) : -1;
    struct stat before = { 0 };
    struct stat after = { 0 };
    result = result && directory >= 0 && fstat(directory, &before) == 0 && rename(parent, old_parent) == 0 &&
             mkdir(parent, 0700) == 0 && mkdir(leaf, 0700) == 0 && write_marker(present, 'B') && fstat(directory, &after) == 0;
    const int ordinary = result ? open(present, O_RDONLY | O_CLOEXEC | O_NONBLOCK | O_NOCTTY) : -1;
    const int relative = result ? openat(directory, "header.h", O_RDONLY | O_CLOEXEC | O_NONBLOCK | O_NOCTTY) : -1;
    char current = 0;
    char pinned = 0;
    result = result && ordinary >= 0 && relative >= 0 && read(ordinary, &current, 1) == 1 && read(relative, &pinned, 1) == 1;
    const bool stable = before.st_dev == after.st_dev && before.st_ino == after.st_ino &&
                        before.st_ctim.tv_sec == after.st_ctim.tv_sec && before.st_ctim.tv_nsec == after.st_ctim.tv_nsec &&
                        before.st_mtim.tv_sec == after.st_mtim.tv_sec && before.st_mtim.tv_nsec == after.st_mtim.tv_nsec;
    printf("directory-fd counterexample: ordinary=%c pinned=%c pinned_identity_and_times_unchanged=%u\n", current, pinned, stable);
    result = result && current == 'B' && pinned == 'A' && stable;
    if (ordinary >= 0)
    {
        close(ordinary);
    }
    if (relative >= 0)
    {
        close(relative);
    }
    if (directory >= 0)
    {
        close(directory);
    }
    unlink(old_file);
    rmdir(old_leaf);
    rmdir(old_parent);
    return result;
}

static bool descriptor_limit_check(const char* missing)
{
    fflush(stdout);
    const pid_t child = fork();
    if (child == 0)
    {
        struct rlimit limit = { 0 };
        bool ready = getrlimit(RLIMIT_NOFILE, &limit) == 0;
        limit.rlim_cur = ready && limit.rlim_cur > 64 ? 64 : limit.rlim_cur;
        ready = ready && setrlimit(RLIMIT_NOFILE, &limit) == 0;
        unsigned opened = 0;
        int fd = 0;
        while (ready && opened < 128 && fd >= 0)
        {
            fd = open("/dev/null", O_RDONLY | O_CLOEXEC);
            opened += fd >= 0;
        }
        const int ordinary = ready ? open(missing, O_RDONLY | O_CLOEXEC | O_NONBLOCK | O_NOCTTY) : -1;
        const int open_error = errno;
        struct stat status;
        const int stated = ready ? fstatat(AT_FDCWD, missing, &status, 0) : 0;
        const int stat_error = errno;
        dprintf(STDOUT_FILENO, "fd-limit counterexample: opened=%u open_result=%d open_errno=%d stat_result=%d stat_errno=%d\n",
                opened, ordinary, open_error, stated, stat_error);
        _exit(ready && ordinary == -1 && open_error == EMFILE && stated == -1 && stat_error == ENOENT ? 0 : 1);
    }
    int status = 0;
    pid_t waited = -1;
    do
    {
        waited = child > 0 ? waitpid(child, &status, 0) : -1;
    } while (waited < 0 && errno == EINTR);
    return waited == child && child > 0 && WIFEXITED(status) && WEXITSTATUS(status) == 0;
}

static uint64_t now_ns(void)
{
    struct timespec value;
    clock_gettime(CLOCK_MONOTONIC, &value);
    return (uint64_t)value.tv_sec * 1000000000ull + (uint64_t)value.tv_nsec;
}

static bool lookup(const char* path, bool preflight, bool present)
{
    struct stat status;
    const int stated = preflight ? fstatat(AT_FDCWD, path, &status, 0) : 0;
    const int stat_error = errno;
    const bool absent = preflight && stated < 0 && stat_error == ENOENT;
    const int fd = absent ? -1 : open(path, O_RDONLY | O_CLOEXEC | O_NONBLOCK | O_NOCTTY);
    const int error = absent ? ENOENT : errno;
    bool result = present ? fd >= 0 && fstat(fd, &status) == 0 && S_ISREG(status.st_mode) : fd < 0 && error == ENOENT;
    if (fd >= 0)
    {
        result = close(fd) == 0 && result;
    }
    return result;
}

static int compare_double(const void* a, const void* b)
{
    const double left = *(const double*)a;
    const double right = *(const double*)b;
    return (left > right) - (left < right);
}

static bool cost_screen(const char* missing, const char* present)
{
    double times[2][2][21];
    bool result = true;
    const unsigned iterations = 4000;
    for (unsigned kind = 0; kind < 2; kind += 1)
    {
        const char* path = kind == 0 ? missing : present;
        for (unsigned round = 0; round < 21; round += 1)
        {
            for (unsigned order = 0; order < 2; order += 1)
            {
                const unsigned role = order ^ (round & 1);
                const uint64_t begin = now_ns();
                for (unsigned sample = 0; sample < iterations; sample += 1)
                {
                    result = lookup(path, role != 0, kind != 0) && result;
                }
                const uint64_t elapsed = now_ns() - begin;
                times[kind][role][round] = (double)elapsed / iterations;
                printf("sample kind=%s round=%u role=%s ns_per_probe=%.3f\n", kind == 0 ? "missing" : "present", round,
                       role == 0 ? "open" : "stat_then_open", times[kind][role][round]);
            }
        }
    }
    for (unsigned kind = 0; kind < 2; kind += 1)
    {
        for (unsigned role = 0; role < 2; role += 1)
        {
            qsort(times[kind][role], 21, sizeof(double), compare_double);
        }
        printf("median kind=%s open_ns=%.3f stat_then_open_ns=%.3f\n", kind == 0 ? "missing" : "present",
               times[kind][0][10], times[kind][1][10]);
    }
    const double saved = times[0][0][10] - times[0][1][10];
    const double penalty = times[1][1][10] - times[1][0][10];
    printf("local synthetic break-even: saved_missing_ns=%.3f extra_present_ns=%.3f required_missing_fraction=%.6f\n",
           saved, penalty, saved > 0 && penalty > 0 ? penalty / (saved + penalty) : -1);
    return result;
}

int main(void)
{
    char root[] = "/tmp/buster-653-mechanism-XXXXXX";
    char present[PATH_MAX] = { 0 };
    char missing[PATH_MAX] = { 0 };
    char leaf[PATH_MAX] = { 0 };
    char parent[PATH_MAX] = { 0 };
    bool ready = mkdtemp(root) != 0 && namespace_check(root, present, sizeof(present)) &&
                 path_join(missing, sizeof(missing), root, "missing.h");
    const bool resource = ready && descriptor_limit_check(missing);
    const bool costs = ready && cost_screen(missing, present);
    unlink(present);
    if (path_join(parent, sizeof(parent), root, "parent") && path_join(leaf, sizeof(leaf), parent, "leaf"))
    {
        rmdir(leaf);
        rmdir(parent);
    }
    rmdir(root);
    printf("design probes: setup_and_namespace_counterexample=%u resource_counterexample=%u ordinary_cost_checks=%u\n", ready, resource, costs);
    return ready && resource && costs ? 0 : 1;
}
