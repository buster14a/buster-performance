// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin. See LICENSE.
// Original footprint screen. Each compile independently holds the shared 9700X lock; stages report peak RSS.
#define _POSIX_C_SOURCE 200809L
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/stat.h>
#include <sys/wait.h>
#include <unistd.h>

int main(void)
{
    const char* trees[] = { "main-92c0", "head-7a05" };
    const char* units[] = { "no-member", "anonymous-64", "members-40000", "records-8000" };
    int failures = chdir("/home/david/buster-fast-bench/member-591-claude") != 0;
    mkdir("cost-review", 0755);
    setenv("EXCLUSIVE_OWNER", "codex-checker-review", 1);
    setenv("EXCLUSIVE_TITLE", "PR648 member-index footprint review", 1);
    setenv("EXCLUSIVE_LINK", "https://github.com/buster14a/buster/pull/648", 1);
    for (unsigned round = 0; round < 3 && failures == 0; round += 1)
    {
        for (unsigned unit = 0; unit < 4; unit += 1)
        {
            for (unsigned order = 0; order < 2; order += 1)
            {
                const unsigned tree = (order + round) % 2;
                char compiler[256];
                char source[256];
                char report[256];
                snprintf(compiler, sizeof(compiler), "%s/build/compiler", trees[tree]);
                snprintf(source, sizeof(source), "units/%s.c", units[unit]);
                snprintf(report, sizeof(report), "cost-review/r%u-%s-%s.txt", round + 1, trees[tree], units[unit]);
                char* args[] = {
                    "/home/david/buster-fast-bench/exclusive.sh", "taskset", "-c", unit == 3 ? "0-7" : "2", compiler,
                    "--time-stages", "--lanes", unit == 3 ? "4" : "1", "-c", source, "-o", "cost-review/output.o", NULL,
                };
                fflush(NULL);
                const pid_t pid = fork();
                if (pid == 0)
                {
                    const int file = open(report, O_WRONLY | O_CREAT | O_TRUNC, 0644);
                    if (file < 0 || dup2(file, STDERR_FILENO) < 0)
                    {
                        _exit(126);
                    }
                    close(file);
                    execv(args[0], args);
                    _exit(127);
                }
                int status = 0;
                const int failed = pid < 0 || waitpid(pid, &status, 0) != pid || !WIFEXITED(status) || WEXITSTATUS(status) != 0;
                failures += failed;
                printf("%s %s round %u: %s\n", trees[tree], units[unit], round + 1, failed ? "failed" : "passed");
            }
        }
    }
    return failures != 0;
}
