// #1444: whole-process wall time of two executables, alternated (A B B A per round), with the parent either asleep in
// wait4 (as time-runs and perf stat wait) or spinning on waitpid(WNOHANG), so that the parent's own wake-up from an idle
// CPU is or isn't part of what is timed. Prints each mode's median and quartiles for each executable, in microseconds.
//   waits ROUNDS EXECUTABLE_A EXECUTABLE_B -- ARGUMENT...
// Each process gets ARGUMENT... after its executable; its standard output and error go to /dev/null.
#define _GNU_SOURCE
#include <fcntl.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/wait.h>
#include <time.h>
#include <unistd.h>

static uint64_t waits_now(void)
{
    struct timespec now;
    clock_gettime(CLOCK_MONOTONIC, &now);
    return (uint64_t)now.tv_sec * 1000000000ull + (uint64_t)now.tv_nsec;
}

// One process of `argv` (argv[0] its executable): its wall time in nanoseconds, from before fork to its reaping, or 0 if
// it couldn't start or didn't exit with status 0.
static uint64_t waits_one(char** argv, int spin)
{
    const uint64_t start = waits_now();
    const pid_t child = fork();
    if (child == 0)
    {
        const int null = open("/dev/null", O_WRONLY);
        dup2(null, 1);
        dup2(null, 2);
        execv(argv[0], argv);
        _exit(127);
    }
    int status = -1;
    pid_t reaped = -1;
    if (child > 0)
    {
        reaped = spin ? 0 : waitpid(child, &status, 0);
        while (spin && reaped == 0)
        {
            reaped = waitpid(child, &status, WNOHANG);
        }
    }
    const uint64_t end = waits_now();
    return reaped == child && WIFEXITED(status) && WEXITSTATUS(status) == 0 ? end - start : 0;
}

static int waits_compare(const void* a, const void* b)
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
        fprintf(stderr, "usage: waits ROUNDS EXECUTABLE_A EXECUTABLE_B -- ARGUMENT...\n");
    }
    const int arguments = argc - separator - 1;
    char** run = result == 0 ? calloc((size_t)arguments + 2, sizeof(char*)) : 0;
    uint64_t* times = result == 0 ? calloc((size_t)rounds * 2 * 2 * 2, sizeof(uint64_t)) : 0;
    for (int i = 0; run != 0 && i < arguments; i += 1)
    {
        run[i + 1] = argv[separator + 1 + i];
    }
    uint64_t failed = 0;
    // times[((mode * 2 + executable) * rounds + round) * 2 + k]: each round's two processes of each executable in each
    // mode, the modes interleaved within the round too.
    for (long round = 0; times != 0 && round < rounds; round += 1)
    {
        for (int mode = 0; mode < 2; mode += 1)
        {
            static const int order[4] = { 0, 1, 1, 0 };
            uint64_t taken[2] = { 0, 0 };
            for (int k = 0; k < 4; k += 1)
            {
                const int executable = order[(k + (int)round) % 4];
                run[0] = argv[2 + executable];
                const uint64_t time = waits_one(run, mode);
                failed += time == 0 ? 1 : 0;
                const uint64_t slot = ((uint64_t)(mode * 2 + executable) * (uint64_t)rounds + (uint64_t)round) * 2 + taken[executable];
                taken[executable] += 1;
                times[slot] = time;
            }
        }
    }
    for (int mode = 0; times != 0 && mode < 2; mode += 1)
    {
        for (int executable = 0; executable < 2; executable += 1)
        {
            uint64_t* values = times + (uint64_t)(mode * 2 + executable) * (uint64_t)rounds * 2;
            const uint64_t count = (uint64_t)rounds * 2;
            qsort(values, count, sizeof(uint64_t), waits_compare);
            printf("%s %s: %llu runs, median %.1f us, quartiles %.1f to %.1f us\n", mode == 0 ? "wait4" : "spin", argv[2 + executable],
                   (unsigned long long)count, (double)values[count / 2] / 1e3, (double)values[count / 4] / 1e3, (double)values[3 * count / 4] / 1e3);
        }
    }
    printf("failed processes: %llu\n", (unsigned long long)failed);
    free(run);
    free(times);
    return result != 0 ? result : failed != 0 ? 1 : 0;
}
