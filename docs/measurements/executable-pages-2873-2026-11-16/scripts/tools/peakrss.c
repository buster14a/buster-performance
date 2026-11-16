// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md of buster14a/buster.
//
// peakrss: runs COMMAND and appends its peak resident set (wait4's ru_maxrss, KB: the largest of the process and the
// children it waited for) and its exit status to OUT as one line, LABEL first (buster14a/buster#1167).
//
//   peakrss OUT LABEL COMMAND [ARGUMENT...]

#define _GNU_SOURCE
#include <stdio.h>
#include <stdlib.h>
#include <sys/resource.h>
#include <sys/wait.h>
#include <unistd.h>

int main(int argc, char** argv)
{
    int result = 2;
    if (argc >= 4)
    {
        const pid_t child = fork();
        if (child == 0)
        {
            execvp(argv[3], argv + 3);
            _exit(127);
        }
        int status = 0;
        struct rusage usage = { 0 };
        const pid_t waited = child > 0 ? wait4(child, &status, 0, &usage) : -1;
        FILE* out = fopen(argv[1], "a");
        if (out != NULL && waited == child)
        {
            fprintf(out, "%s %ld %d\n", argv[2], usage.ru_maxrss, WIFEXITED(status) ? WEXITSTATUS(status) : -1);
            result = WIFEXITED(status) && WEXITSTATUS(status) == 0 ? 0 : 1;
        }
        if (out != NULL)
        {
            fclose(out);
        }
    }
    return result;
}
