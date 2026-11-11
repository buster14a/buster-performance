// #1444: where a short process's wall time goes, seen from a parent that spins (never sleeps): from before fork to its
// exec (a close-on-exec pipe's end of file), to the first byte of its standard error (the --time-stages report, which
// the C driver writes once its work is done), to that stream's end of file (the last of its threads has closed its
// descriptors, at exit), and to its reaping. Two executables, alternated (A B B A per round). Prints each phase's
// median for each executable, in microseconds.
//   phases ROUNDS EXECUTABLE_A EXECUTABLE_B -- ARGUMENT...
// Each process gets ARGUMENT... after its executable (which should include --time-stages); its standard output goes to
// /dev/null.
#define _GNU_SOURCE
#include <errno.h>
#include <fcntl.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/wait.h>
#include <time.h>
#include <unistd.h>

#define PHASES_MARKS 5

static uint64_t phases_now(void)
{
    struct timespec now;
    clock_gettime(CLOCK_MONOTONIC, &now);
    return (uint64_t)now.tv_sec * 1000000000ull + (uint64_t)now.tv_nsec;
}

// One process of `argv`: marks[0] before fork, then its exec, the first byte of its standard error, that stream's end
// and its reaping, in nanoseconds. False if it couldn't start or didn't exit with status 0.
static int phases_one(char** argv, uint64_t* marks)
{
    int exec_pipe[2];
    int error_pipe[2];
    int valid = pipe2(exec_pipe, O_CLOEXEC) == 0 && pipe2(error_pipe, O_CLOEXEC) == 0;
    marks[0] = phases_now();
    const pid_t child = valid ? fork() : -1;
    if (child == 0)
    {
        const int null = open("/dev/null", O_WRONLY);
        dup2(null, 1);
        dup2(error_pipe[1], 2);
        close(exec_pipe[0]);
        execv(argv[0], argv);
        _exit(127);
    }
    if (valid)
    {
        close(exec_pipe[1]);
        close(error_pipe[1]);
        fcntl(exec_pipe[0], F_SETFL, O_NONBLOCK);
        fcntl(error_pipe[0], F_SETFL, O_NONBLOCK);
    }
    int status = -1;
    pid_t reaped = 0;
    int exec_open = 1;
    int error_open = 1;
    int error_seen = 0;
    char buffer[4096];
    while (child > 0 && reaped == 0)
    {
        if (exec_open && read(exec_pipe[0], buffer, sizeof(buffer)) == 0)
        {
            marks[1] = phases_now();
            exec_open = 0;
        }
        const ssize_t got = error_open ? read(error_pipe[0], buffer, sizeof(buffer)) : -1;
        if (got > 0 && !error_seen)
        {
            marks[2] = phases_now();
            error_seen = 1;
        }
        if (got == 0)
        {
            marks[3] = phases_now();
            error_open = 0;
        }
        reaped = error_open ? 0 : waitpid(child, &status, WNOHANG);
    }
    marks[4] = phases_now();
    if (valid)
    {
        close(exec_pipe[0]);
        close(error_pipe[0]);
    }
    return child > 0 && reaped == child && WIFEXITED(status) && WEXITSTATUS(status) == 0 && error_seen && !exec_open;
}

static int phases_compare(const void* a, const void* b)
{
    const uint64_t x = *(const uint64_t*)a;
    const uint64_t y = *(const uint64_t*)b;
    return x < y ? -1 : x > y ? 1 : 0;
}

int main(int argc, char** argv)
{
    int separator = 0;
    for (int i = 1; i < argc && separator == 0; i += 1)
    {
        separator = strcmp(argv[i], "--") == 0 ? i : 0;
    }
    const long rounds = argc > 4 ? strtol(argv[1], 0, 10) : 0;
    int result = separator == 4 && rounds > 0 && rounds <= 100000 ? 0 : 2;
    if (result != 0)
    {
        fprintf(stderr, "usage: phases ROUNDS EXECUTABLE_A EXECUTABLE_B -- ARGUMENT...\n");
    }
    const int arguments = argc - separator - 1;
    const uint64_t count = (uint64_t)rounds * 2;
    char** run = result == 0 ? calloc((size_t)arguments + 2, sizeof(char*)) : 0;
    // spans[(executable * PHASES_MARKS + phase) * count + i]: phase 0 the whole, then each mark's interval from the last.
    uint64_t* spans = result == 0 ? calloc(2 * PHASES_MARKS * count, sizeof(uint64_t)) : 0;
    for (int i = 0; run != 0 && i < arguments; i += 1)
    {
        run[i + 1] = argv[separator + 1 + i];
    }
    uint64_t failed = 0;
    uint64_t taken[2] = { 0, 0 };
    for (long round = 0; spans != 0 && round < rounds; round += 1)
    {
        static const int order[4] = { 0, 1, 1, 0 };
        for (int k = 0; k < 4; k += 1)
        {
            const int executable = order[(k + (int)round) % 4];
            run[0] = argv[2 + executable];
            uint64_t marks[PHASES_MARKS] = { 0 };
            const int ran = phases_one(run, marks);
            failed += ran ? 0 : 1;
            const uint64_t i = taken[executable];
            taken[executable] += 1;
            spans[(uint64_t)(executable * PHASES_MARKS) * count + i] = ran ? marks[4] - marks[0] : 0;
            for (int phase = 1; phase < PHASES_MARKS; phase += 1)
            {
                spans[(uint64_t)(executable * PHASES_MARKS + phase) * count + i] = ran ? marks[phase] - marks[phase - 1] : 0;
            }
        }
    }
    static const char* names[PHASES_MARKS] = { "whole", "fork to exec", "exec to report", "report to end of file", "end of file to reaping" };
    for (int executable = 0; spans != 0 && executable < 2; executable += 1)
    {
        printf("%s: %llu runs\n", argv[2 + executable], (unsigned long long)count);
        for (int phase = 0; phase < PHASES_MARKS; phase += 1)
        {
            uint64_t* values = spans + (uint64_t)(executable * PHASES_MARKS + phase) * count;
            qsort(values, count, sizeof(uint64_t), phases_compare);
            printf("  %s: median %.1f us, quartiles %.1f to %.1f us\n", names[phase], (double)values[count / 2] / 1e3, (double)values[count / 4] / 1e3,
                   (double)values[3 * count / 4] / 1e3);
        }
    }
    printf("failed processes: %llu\n", (unsigned long long)failed);
    free(run);
    free(spans);
    return result != 0 ? result : failed != 0 ? 1 : 0;
}
