// Original #653 target-qualification driver. Every invocation acquires/releases the shared host lock.
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

#define ROOT "qualification-653-lazy-83cfe3b4"
#define BASE "./" ROOT "/compiler-base"
#define HEAD "./" ROOT "/compiler-head"
#define EXCLUSIVE "/home/david/buster-fast-bench/exclusive.sh"

typedef struct Case Case;
struct Case
{
    const char* name;
    const char* input;
    const char* include;
    bool sqlite;
    unsigned rounds;
    unsigned tasks;
};

static const Case cases[] = {
    { "deflate", ROOT "/inputs/zlib-1.3.1/deflate.c", ROOT "/inputs/zlib-1.3.1", false, 21, 48 },
    { "uncompr", ROOT "/inputs/zlib-1.3.1/uncompr.c", ROOT "/inputs/zlib-1.3.1", false, 21, 48 },
    { "tiny", ROOT "/inputs/tiny.c", 0, false, 11, 64 },
    { "local", ROOT "/inputs/local.c", 0, false, 11, 64 },
    { "positive", ROOT "/inputs/positive/case.c", ROOT "/inputs/positive", false, 11, 32 },
    { "sqlite", "corpus/sqlite/sqlite3.c", "corpus/sqlite", true, 11, 4 },
};

static bool make_positive_directory(void)
{
    const char* directory = ROOT "/inputs/positive";
    bool result = mkdir(directory, 0755) == 0;
    char seed[1024];
    char name[1024];
    snprintf(seed, sizeof(seed), "%s/value.h", directory);
    FILE* file = result ? fopen(seed, "wx") : 0;
    result = file != 0 && fputs("int positive_value;\n", file) >= 0;
    if (file != 0)
    {
        result = fclose(file) == 0 && result;
    }
    for (unsigned n = 0; result && n < 4096; n += 1)
    {
        snprintf(name, sizeof(name), "%s/header-%u.h", directory, n);
        result = link(seed, name) == 0;
    }
    snprintf(name, sizeof(name), "%s/case.c", directory);
    file = result ? fopen(name, "wx") : 0;
    result = file != 0 && fputs("#include <value.h>\n", file) >= 0;
    if (file != 0)
    {
        result = fclose(file) == 0 && result;
    }
    return result;
}

static unsigned append_options(char** command, unsigned n, const Case* input, bool preprocessing, char* output)
{
    if (!preprocessing)
    {
        command[n++] = "--lanes";
        command[n++] = "1";
        command[n++] = "-c";
    }
    if (input->sqlite)
    {
        command[n++] = "-DSQLITE_OMIT_LOAD_EXTENSION";
        command[n++] = "-DSQLITE_THREADSAFE=0";
        command[n++] = "-DSQLITE_ENABLE_MEMSYS5";
        command[n++] = "-DSQLITE_ENABLE_RTREE";
    }
    char* common[] = {
        "-std=gnu17", "--predefines", "corpus/gnu17-pinned-predefines.txt", "--clang-features",
        "--target=x86_64-linux-gnu", "-march=znver5", "-nostdinc",
        "-isystem", "corpus/headers/usr/lib/clang/23/include", "-isystem", "corpus/headers/usr/local/include",
        "-isystem", "corpus/headers/usr/include",
    };
    for (unsigned a = 0; a < sizeof(common) / sizeof(common[0]); a += 1)
    {
        command[n++] = common[a];
    }
    if (input->include != 0)
    {
        command[n++] = "-I";
        command[n++] = (char*)input->include;
    }
    command[n++] = (char*)input->input;
    if (output != 0)
    {
        command[n++] = "-o";
        command[n++] = output;
    }
    command[n] = 0;
    return n;
}

static bool run_one(const char* name, char** command, bool pin)
{
    char directory[1024];
    snprintf(directory, sizeof(directory), ROOT "/results/%s", name);
    bool result = mkdir(directory, 0755) == 0 || errno == EEXIST;
    char path[1200];
    snprintf(path, sizeof(path), "%s/arguments.txt", directory);
    FILE* arguments = result ? fopen(path, "w") : 0;
    result = arguments != 0;
    for (unsigned a = 0; result && command[a] != 0; a += 1)
    {
        fprintf(arguments, "%s\n", command[a]);
    }
    if (arguments != 0)
    {
        fclose(arguments);
    }
    snprintf(path, sizeof(path), "%s/run.log", directory);
    const int fd = result ? open(path, O_WRONLY | O_CREAT | O_TRUNC, 0644) : -1;
    result = fd >= 0;
    printf("start %s\n", name);
    fflush(stdout);
    const pid_t child = result ? fork() : -1;
    if (child == 0)
    {
        dup2(fd, STDOUT_FILENO);
        dup2(fd, STDERR_FILENO);
        close(fd);
        setenv("EXCLUSIVE_OWNER", "codex-unclaimed-perf-653", 1);
        setenv("EXCLUSIVE_TITLE", name, 1);
        setenv("EXCLUSIVE_LINK", "https://github.com/buster14a/buster/issues/653", 1);
        char* wrapped[160];
        unsigned n = 0;
        wrapped[n++] = EXCLUSIVE;
        if (pin)
        {
            wrapped[n++] = "/usr/bin/taskset";
            wrapped[n++] = "-c";
            wrapped[n++] = "2";
        }
        for (unsigned a = 0; command[a] != 0; a += 1)
        {
            wrapped[n++] = command[a];
        }
        wrapped[n] = 0;
        execv(wrapped[0], wrapped);
        _exit(127);
    }
    if (fd >= 0)
    {
        close(fd);
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
    result = result && waited == child && WIFEXITED(status) && WEXITSTATUS(status) == 0;
    printf("end %s success=%u status=%d\n", name, result, status);
    fflush(stdout);
    return result;
}

int main(int argc, char** argv)
{
    bool result = argc == 2 || argc == 3;
    if (result && strcmp(argv[1], "setup") == 0)
    {
        result = make_positive_directory();
    }
    for (unsigned c = 0; result && strcmp(argv[1], "setup") != 0 && c < sizeof(cases) / sizeof(cases[0]); c += 1)
    {
        const Case* input = &cases[c];
        if (argc == 3 && strcmp(input->name, argv[2]) != 0)
        {
            continue;
        }
        char name[128];
        char output[1024];
        char rounds[16];
        char tasks[16];
        char* command[128];
        if (strcmp(argv[1], "ab") == 0 || strcmp(argv[1], "aa") == 0)
        {
            const bool control = strcmp(argv[1], "aa") == 0;
            snprintf(name, sizeof(name), "653-%s-%s", input->name, argv[1]);
            snprintf(output, sizeof(output), ROOT "/results/%s/samples", name);
            snprintf(rounds, sizeof(rounds), "%u", control ? 11 : input->rounds);
            snprintf(tasks, sizeof(tasks), "%u", input->tasks);
            unsigned n = 0;
            command[n++] = "./samples";
            command[n++] = rounds;
            command[n++] = "1";
            command[n++] = tasks;
            command[n++] = (char*)input->input;
            command[n++] = output;
            command[n++] = "./cohort";
            command[n++] = BASE;
            command[n++] = control ? BASE : HEAD;
            append_options(command, n, input, false, "@OUTPUT@");
            result = run_one(name, command, true);
        }
        else if (strcmp(argv[1], "first") == 0 || strcmp(argv[1], "syscalls") == 0)
        {
            for (unsigned role = 0; result && role < 2; role += 1)
            {
                snprintf(name, sizeof(name), "653-%s-%s-%u", input->name, argv[1], role);
                snprintf(output, sizeof(output), ROOT "/results/%s/output.o", name);
                unsigned n = 0;
                char trace[1024];
                if (strcmp(argv[1], "syscalls") == 0)
                {
                    snprintf(trace, sizeof(trace), ROOT "/results/%s/strace.txt", name);
                    command[n++] = "/usr/bin/strace";
                    command[n++] = "-f";
                    command[n++] = "-c";
                    command[n++] = "-e";
                    command[n++] = "trace=openat,newfstatat,fstat,statx,close,getdents64,faccessat2,fstatfs,ioctl";
                    command[n++] = "-o";
                    command[n++] = trace;
                    command[n++] = role == 0 ? BASE : HEAD;
                }
                else
                {
                    snprintf(output, sizeof(output), ROOT "/results/%s/cohort", name);
                    command[n++] = "./cohort";
                    command[n++] = "1";
                    command[n++] = "1";
                    command[n++] = (char*)input->input;
                    command[n++] = output;
                    command[n++] = role == 0 ? BASE : HEAD;
                }
                append_options(command, n, input, false, strcmp(argv[1], "first") == 0 ? "@OUTPUT@" : output);
                result = run_one(name, command, true);
            }
        }
        else if (strcmp(argv[1], "cache") == 0)
        {
            if (c < 2)
            {
                for (unsigned mode = 0; result && mode < 2; mode += 1)
                {
                    for (unsigned role = 0; result && role < 2; role += 1)
                    {
                        snprintf(name, sizeof(name), "653-%s-cache-%s-%u", input->name, mode == 0 ? "fresh" : "shared", role);
                        command[0] = role == 0 ? "./" ROOT "/cache-units-base" : "./" ROOT "/cache-units-head";
                        command[1] = mode == 0 ? "fresh" : "shared";
                        command[2] = "31";
                        append_options(command, 3, input, true, 0);
                        result = run_one(name, command, true);
                    }
                }
            }
        }
        else if (strcmp(argv[1], "tests") == 0)
        {
            if (c == 0)
            {
                char* pp[] = { HEAD, "test-preprocessor", "--clang", "--fuzz", "64", "--jobs", "8", 0 };
                char* files[] = { HEAD, "test-files", "--lanes", "1,2,3,8", 0 };
                result = run_one("653-target-preprocessor", pp, false) && run_one("653-target-files", files, false);
            }
        }
        else
        {
            result = false;
        }
    }
    return result ? 0 : 1;
}
