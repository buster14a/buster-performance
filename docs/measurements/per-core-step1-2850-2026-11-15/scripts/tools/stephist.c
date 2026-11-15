// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
//
// stephist: the exact number of times each instruction of a function's calls runs, counted by single-stepping the
// program under ptrace. It needs no performance counters, so it works where perf doesn't (cloud virtual machines), and
// its counts are exact rather than sampled: the same program and input give the same file.
//
//   stephist --entry OFFSET [--calls N] [--skip N] --output FILE -- PROGRAM ARGUMENT...
//
// OFFSET is the function's address in PROGRAM's file (nm's value, hexadecimal), which the tool adds to the address the
// executable is mapped at. The program runs freely until its --skip'th + 1 call of the function, is then stepped
// through --calls calls of it (1 by default; 0 means every call), callees included, and is killed after the last one.
// FILE gets one line per executed address, `OFFSET COUNT` in hexadecimal and decimal, sorted by offset, for the
// executable's own addresses; instructions run elsewhere (shared libraries, the vDSO) are totalled in a comment line.
#define _GNU_SOURCE
#include <errno.h>
#include <inttypes.h>
#include <limits.h>
#include <signal.h>
#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/personality.h>
#include <sys/ptrace.h>
#include <sys/types.h>
#include <sys/user.h>
#include <sys/wait.h>
#include <unistd.h>

typedef struct StepHistogram StepHistogram;
struct StepHistogram
{
    uint64_t base;
    uint64_t length;
    uint64_t* counts;
    uint64_t inside;
    uint64_t outside;
};

// The executable's first mapping's start and the end of its last, from /proc/PID/maps, by its real path.
static bool stephist_range(pid_t pid, const char* program, uint64_t* base, uint64_t* end)
{
    bool found = false;
    char real[PATH_MAX];
    char maps[64];
    snprintf(maps, sizeof(maps), "/proc/%d/maps", (int)pid);
    FILE* file = realpath(program, real) != NULL ? fopen(maps, "r") : NULL;
    if (file != NULL)
    {
        char line[PATH_MAX + 128];
        while (fgets(line, sizeof(line), file) != NULL)
        {
            uint64_t low = 0;
            uint64_t high = 0;
            int consumed = 0;
            if (sscanf(line, "%" SCNx64 "-%" SCNx64 " %*s %*s %*s %*s %n", &low, &high, &consumed) == 2 && consumed > 0)
            {
                char* path = line + consumed;
                path[strcspn(path, "\n")] = 0;
                if (strcmp(path, real) == 0)
                {
                    if (!found)
                    {
                        *base = low;
                    }
                    *end = high;
                    found = true;
                }
            }
        }
        fclose(file);
    }
    return found;
}

static uint64_t stephist_rip(pid_t pid)
{
    errno = 0;
    return (uint64_t)ptrace(PTRACE_PEEKUSER, pid, (void*)offsetof(struct user, regs.rip), NULL);
}

static uint64_t stephist_rsp(pid_t pid)
{
    errno = 0;
    return (uint64_t)ptrace(PTRACE_PEEKUSER, pid, (void*)offsetof(struct user, regs.rsp), NULL);
}

// Continue (or step) the child, passing on any signal that isn't the tracer's own trap. Returns false once it has exited.
static bool stephist_resume(pid_t pid, enum __ptrace_request request, int* status)
{
    bool alive = true;
    int signal_number = 0;
    bool stopped_by_trap = false;
    while (alive && !stopped_by_trap)
    {
        alive = ptrace(request, pid, NULL, (void*)(intptr_t)signal_number) == 0 && waitpid(pid, status, 0) == pid && WIFSTOPPED(*status);
        if (alive)
        {
            signal_number = WSTOPSIG(*status);
            stopped_by_trap = signal_number == SIGTRAP;
        }
    }
    return alive;
}

int main(int argc, char** argv)
{
    uint64_t entry = 0;
    uint64_t calls = 1;
    uint64_t skip = 0;
    const char* output = NULL;
    int first = 0;
    bool ok = true;
    for (int i = 1; ok && first == 0 && i < argc; i += 1)
    {
        const bool pair = i + 1 < argc;
        if (strcmp(argv[i], "--entry") == 0 && pair)
        {
            entry = strtoull(argv[i + 1], NULL, 16);
            i += 1;
        }
        else if (strcmp(argv[i], "--calls") == 0 && pair)
        {
            calls = strtoull(argv[i + 1], NULL, 10);
            i += 1;
        }
        else if (strcmp(argv[i], "--skip") == 0 && pair)
        {
            skip = strtoull(argv[i + 1], NULL, 10);
            i += 1;
        }
        else if (strcmp(argv[i], "--output") == 0 && pair)
        {
            output = argv[i + 1];
            i += 1;
        }
        else if (strcmp(argv[i], "--") == 0 && pair)
        {
            first = i + 1;
        }
        else
        {
            ok = false;
        }
    }
    int result = 1;
    if (!ok || first == 0 || entry == 0 || output == NULL)
    {
        fprintf(stderr, "usage: stephist --entry OFFSET [--calls N] [--skip N] --output FILE -- PROGRAM ARGUMENT...\n");
        result = 2;
    }
    else
    {
        const pid_t pid = fork();
        if (pid == 0)
        {
            personality(ADDR_NO_RANDOMIZE);
            ptrace(PTRACE_TRACEME, 0, NULL, NULL);
            execvp(argv[first], argv + first);
            _exit(127);
        }
        int status = 0;
        StepHistogram h = { 0 };
        uint64_t end = 0;
        bool alive = pid > 0 && waitpid(pid, &status, 0) == pid && WIFSTOPPED(status);
        alive = alive && ptrace(PTRACE_SETOPTIONS, pid, NULL, (void*)(intptr_t)PTRACE_O_EXITKILL) == 0;
        alive = alive && stephist_range(pid, argv[first], &h.base, &end);
        if (alive)
        {
            h.length = end - h.base;
            h.counts = calloc(h.length, sizeof(*h.counts));
            alive = h.counts != NULL && entry < h.length;
        }
        const uint64_t address = h.base + entry;
        uint64_t stepped_calls = 0;
        uint64_t seen_calls = 0;
        bool done = !alive;
        while (!done)
        {
            // The breakpoint at the entry, until the function is called.
            errno = 0;
            const long word = ptrace(PTRACE_PEEKTEXT, pid, (void*)address, NULL);
            alive = errno == 0 && ptrace(PTRACE_POKETEXT, pid, (void*)address, (void*)((word & ~0xffl) | 0xcc)) == 0;
            alive = alive && stephist_resume(pid, PTRACE_CONT, &status) && stephist_rip(pid) == address + 1;
            alive = alive && ptrace(PTRACE_POKETEXT, pid, (void*)address, (void*)word) == 0;
            alive = alive && ptrace(PTRACE_POKEUSER, pid, (void*)offsetof(struct user, regs.rip), (void*)address) == 0;
            if (alive)
            {
                const uint64_t rsp = stephist_rsp(pid);
                errno = 0;
                const uint64_t return_address = (uint64_t)ptrace(PTRACE_PEEKDATA, pid, (void*)rsp, NULL);
                const bool counted = seen_calls >= skip;
                seen_calls += 1;
                if (counted)
                {
                    uint64_t rip = address;
                    bool returned = false;
                    while (alive && !returned)
                    {
                        const uint64_t offset = rip - h.base;
                        if (offset < h.length)
                        {
                            h.counts[offset] += 1;
                            h.inside += 1;
                        }
                        else
                        {
                            h.outside += 1;
                        }
                        alive = stephist_resume(pid, PTRACE_SINGLESTEP, &status);
                        rip = alive ? stephist_rip(pid) : 0;
                        returned = alive && rip == return_address && stephist_rsp(pid) > rsp;
                    }
                    stepped_calls += 1;
                }
                else
                {
                    // An uncounted call: step over the entry's instruction, so that the breakpoint can go back.
                    alive = stephist_resume(pid, PTRACE_SINGLESTEP, &status);
                }
            }
            done = !alive || (calls != 0 && stepped_calls == calls);
        }
        if (pid > 0)
        {
            kill(pid, SIGKILL);
            waitpid(pid, &status, 0);
        }
        FILE* file = stepped_calls != 0 ? fopen(output, "w") : NULL;
        if (file != NULL)
        {
            fprintf(file, "# calls %" PRIu64 " inside %" PRIu64 " outside %" PRIu64 "\n", stepped_calls, h.inside, h.outside);
            for (uint64_t offset = 0; offset < h.length; offset += 1)
            {
                if (h.counts[offset] != 0)
                {
                    fprintf(file, "%" PRIx64 " %" PRIu64 "\n", offset, h.counts[offset]);
                }
            }
            result = fclose(file) == 0 ? 0 : 1;
            fprintf(stderr, "stephist: %" PRIu64 " calls, %" PRIu64 " instructions in the executable, %" PRIu64 " outside\n", stepped_calls, h.inside, h.outside);
        }
        else
        {
            fprintf(stderr, "stephist: no call of the function was stepped (entry %" PRIx64 ")\n", entry);
        }
        free(h.counts);
    }
    return result;
}
