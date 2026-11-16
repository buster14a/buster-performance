// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md of buster14a/buster.
//
// waitall: runs COMMAND as its child, as a child subreaper, and waits for it and for every process it leaves behind (the
// C driver's exit helper, buster14a/buster#1444, which tears the address space down after its caller has exited), so
// that a `perf record` of `waitall COMMAND` keeps recording until all of it has ended. Exits with COMMAND's status.
//
//   waitall COMMAND [ARGUMENT]...

#define _GNU_SOURCE
#include <errno.h>
#include <stdio.h>
#include <sys/prctl.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <unistd.h>

int main(int argc, char** argv)
{
    int result = 2;
    if (argc >= 2 && prctl(PR_SET_CHILD_SUBREAPER, 1, 0, 0, 0) == 0)
    {
        const pid_t child = fork();
        if (child == 0)
        {
            execvp(argv[1], argv + 1);
            perror("waitall: exec");
            _exit(127);
        }
        int status = 0;
        pid_t reaped = child > 0 ? 0 : -1;
        result = child > 0 ? 1 : 2;
        while (reaped >= 0 || errno == EINTR)
        {
            errno = 0;
            reaped = waitpid(-1, &status, 0);
            if (reaped == child)
            {
                result = WIFEXITED(status) ? WEXITSTATUS(status) : 128 + WTERMSIG(status);
            }
        }
    }
    return result;
}
