// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Corrected reproduction controller; not the controller used for archived observations.
#define _GNU_SOURCE
#include <errno.h>
#include <fcntl.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>
#include <sys/wait.h>
#include <unistd.h>

#define BUSTER_REPRO_PATH 4096

static int run(char* const* arguments, const char* directory, const char* log)
{
    int result = 125;
    pid_t child = fork();
    if (child == 0)
    {
        int output = open(log, O_WRONLY | O_CREAT | O_TRUNC, 0600);
        if (output < 0 || dup2(output, STDOUT_FILENO) < 0 || dup2(output, STDERR_FILENO) < 0 ||
            (directory != NULL && chdir(directory) != 0))
        {
            _exit(126);
        }
        if (output > STDERR_FILENO)
        {
            close(output);
        }
        if (setenv("BUSTER_DEBUG_INFO", "0", 1) != 0 || setenv("EXCLUSIVE_OWNER", "ci-681-reproduction", 1) != 0 ||
            setenv("EXCLUSIVE_TITLE", "Frozen PR682 build and ordinary-compile reproduction", 1) != 0 ||
            setenv("EXCLUSIVE_LINK", "https://github.com/buster14a/buster/pull/682", 1) != 0)
        {
            _exit(126);
        }
        execvp(arguments[0], arguments);
        _exit(127);
    }
    int status = 0;
    pid_t waited;
    do
    {
        waited = child > 0 ? waitpid(child, &status, 0) : -1;
    }
    while (waited == -1 && child > 0 && errno == EINTR);
    if (child > 0 && waited == child)
    {
        result = WIFEXITED(status) ? WEXITSTATUS(status) : 128;
    }
    return result;
}

static bool path(char* output, const char* directory, const char* name)
{
    int written = snprintf(output, BUSTER_REPRO_PATH, "%s/%s", directory, name);
    return written >= 0 && written < BUSTER_REPRO_PATH;
}

static bool file_equals(const char* name, const char* expected)
{
    char contents[1024];
    FILE* file = fopen(name, "rb");
    size_t length = file != NULL ? fread(contents, 1, sizeof(contents) - 1, file) : 0;
    bool valid = file != NULL && !ferror(file);
    if (file != NULL)
    {
        valid = fclose(file) == 0 && valid;
    }
    contents[length] = 0;
    contents[strcspn(contents, "\r\n")] = 0;
    return valid && strcmp(contents, expected) == 0;
}

static bool source(const char* directory, const char* revision, const char* output, const char* role)
{
    char name[128];
    char log[BUSTER_REPRO_PATH];
    snprintf(name, sizeof(name), "%s-revision.txt", role);
    bool valid = path(log, output, name);
    char* identity[] = { "git", "rev-parse", "HEAD", NULL };
    valid = valid && run(identity, directory, log) == 0 && file_equals(log, revision);
    snprintf(name, sizeof(name), "%s-source-status.txt", role);
    valid = valid && path(log, output, name);
    char* status[] = { "git", "status", "--porcelain", NULL };
    valid = valid && run(status, directory, log) == 0 && file_equals(log, "");
    return valid;
}

static bool copy(const char* source, const char* destination)
{
    FILE* input = fopen(source, "rb");
    FILE* output = input != NULL ? fopen(destination, "wb") : NULL;
    bool valid = input != NULL && output != NULL;
    char bytes[65536];
    while (valid)
    {
        size_t length = fread(bytes, 1, sizeof(bytes), input);
        valid = !ferror(input) && fwrite(bytes, 1, length, output) == length;
        if (length == 0)
        {
            break;
        }
    }
    if (input != NULL)
    {
        valid = fclose(input) == 0 && valid;
    }
    if (output != NULL)
    {
        valid = fclose(output) == 0 && valid;
    }
    valid = valid && chmod(destination, 0755) == 0;
    return valid;
}

static int self_test(const char* executable, const char* output)
{
    char log[BUSTER_REPRO_PATH];
    bool valid = mkdir(output, 0700) == 0 && path(log, output, "failed-build.log");
    char* child[] = { (char*)executable, "--self-test-child", NULL };
    int status = valid ? run(child, NULL, log) : 125;
    valid = valid && status == 7 && file_equals(log, "build.sh: 41 sources compiled in 1.0 s");
    printf("failure propagation: printed compile summary, child status=%d, %s\n", status, valid ? "passed" : "FAILED");
    return valid ? 0 : 1;
}

int main(int argc, char** argv)
{
    int result = 1;
    if (argc == 2 && strcmp(argv[1], "--self-test-child") == 0)
    {
        puts("build.sh: 41 sources compiled in 1.0 s");
        result = 7;
    }
    else if (argc == 3 && strcmp(argv[1], "--self-test") == 0)
    {
        result = self_test(argv[0], argv[2]);
    }
    else
    {
        bool valid = argc == 6;
        for (int i = 1; valid && i < argc; i += 1)
        {
            valid = argv[i][0] == '/';
        }
        if (valid)
        {
            const char* directories[] = { argv[1], argv[2] };
            const char* roles[] = { "main", "head" };
            const char* revisions[] = {
                "716c980dca3bf5f8aad9c58db712a0ed6b7d12b2",
                "4ce693adbb960ee46e43628033598d6ee65c4c4b",
            };
            const char* output = argv[4];
            valid = mkdir(output, 0700) == 0;
            char snapshots[2][BUSTER_REPRO_PATH];
            for (unsigned role = 0; valid && role < 2; role += 1)
            {
                valid = source(directories[role], revisions[role], output, roles[role]);
                char name[128];
                snprintf(name, sizeof(name), "compiler-%s", roles[role]);
                valid = valid && path(snapshots[role], output, name);
            }
            for (unsigned round = 1; valid && round <= 2; round += 1)
            {
                for (unsigned role = 0; valid && role < 2; role += 1)
                {
                    char name[128];
                    char log[BUSTER_REPRO_PATH];
                    char compiler[BUSTER_REPRO_PATH];
                    snprintf(name, sizeof(name), "build-%u-%s.log", round, roles[role]);
                    valid = path(log, output, name) && path(compiler, directories[role], "build/compiler");
                    char* build[] = { argv[5], "taskset", "-c", "0-7", "./build.sh", NULL };
                    // No output-filtering pipeline: a failed compiler/linker stops before copying or measuring.
                    int status = valid ? run(build, directories[role], log) : 125;
                    printf("round=%u role=%s build_status=%d\n", round, roles[role], status);
                    valid = valid && status == 0 && copy(compiler, snapshots[role]);
                }
            }
            char input[BUSTER_REPRO_PATH];
            char object[BUSTER_REPRO_PATH];
            char include[BUSTER_REPRO_PATH + 3];
            char log[BUSTER_REPRO_PATH];
            valid = valid && path(input, argv[3], "sqlite3.c") && path(object, output, "sqlite3.o") && path(log, output, "identities.sha256");
            snprintf(include, sizeof(include), "-I%s", argv[3]);
            char* identities[] = { "sha256sum", snapshots[0], snapshots[1], input, NULL };
            valid = valid && run(identities, NULL, log) == 0 && path(log, output, "sqlite-time-runs.log");
            char* measure[] = {
                argv[5], "taskset", "-c", "2", snapshots[0], "time-runs", "--runs", "21", "--warmups", "3",
                "--build", "main", snapshots[0], "--build", "head", snapshots[1], "--list", "-c",
                "-DSQLITE_OMIT_LOAD_EXTENSION", "-DSQLITE_THREADSAFE=0", "-DSQLITE_ENABLE_MEMSYS5", "-DSQLITE_ENABLE_RTREE",
                include, input, "-o", object, NULL,
            };
            valid = valid && run(measure, output, log) == 0;
            result = valid ? 0 : 1;
        }
        else
        {
            fprintf(stderr, "usage: reproduce-681 BASE_TREE HEAD_TREE SQLITE_DIRECTORY NEW_OUTPUT_DIRECTORY LOCK\n"
                            "All five arguments must be absolute paths; source trees must be clean and at the pinned revisions.\n"
                            "       reproduce-681 --self-test NEW_OUTPUT_DIRECTORY\n");
        }
    }
    return result;
}
