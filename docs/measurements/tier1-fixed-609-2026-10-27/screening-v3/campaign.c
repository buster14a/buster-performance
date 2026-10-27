// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// One bounded qualification benchmark: native preflight, fresh-process samples and scalar-conditioned samples.
// Execute under exclusive.sh. Sequential child processes share its lock; the entire run has a 90-second cap.
#include <stdbool.h>
#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <unistd.h>
#include <fcntl.h>
#include <signal.h>
#include <sys/wait.h>
#include <time.h>

static uint64_t now(void)
{
    struct timespec value;
    clock_gettime(CLOCK_MONOTONIC, &value);
    return (uint64_t)value.tv_sec * 1000000000 + (uint64_t)value.tv_nsec;
}

static bool child(uint32_t kind, const char* output, const char* errors, uint64_t deadline)
{
    const pid_t pid = fork();
    if (pid == 0)
    {
        setpgid(0, 0);
        const int out = open(output, O_WRONLY | O_CREAT | O_TRUNC, 0644);
        const int err = open(errors, O_WRONLY | O_CREAT | O_TRUNC, 0644);
        if (out < 0 || err < 0 || dup2(out, STDOUT_FILENO) < 0 || dup2(err, STDERR_FILENO) < 0)
        {
            _exit(125);
        }
        close(out);
        close(err);
        if (kind == 0)
        {
            execl("./allocation-tests", "allocation-tests", "--seed", "609", "--count", "5000", (char*)0);
        }
        else if (kind == 1)
        {
            execl("./measure", "measure", (char*)0);
        }
        else
        {
            execl("./measure", "measure", "--conditioned", (char*)0);
        }
        _exit(126);
    }
    bool valid = pid > 0;
    int status = 0;
    bool finished = false;
    if (valid)
    {
        setpgid(pid, pid);
        while (!finished && now() < deadline)
        {
            const pid_t waited = waitpid(pid, &status, WNOHANG);
            finished = waited == pid;
            valid &= waited >= 0;
            if (!valid)
            {
                break;
            }
            if (!finished)
            {
                usleep(10000);
            }
        }
        if (!finished)
        {
            kill(-pid, SIGKILL);
            waitpid(pid, &status, 0);
        }
        valid &= finished && WIFEXITED(status) && WEXITSTATUS(status) == 0;
    }
    fprintf(stderr, "%s: %s\n", output, valid ? "passed" : "FAILED; campaign invalid");
    return valid;
}

int main(void)
{
    const uint64_t deadline = now() + UINT64_C(90000000000);
    const bool valid = child(0, "logs/allocation-tests.log", "logs/allocation-tests.err", deadline) && child(1, "logs/process-1.csv", "logs/process-1.log", deadline) && child(1, "logs/process-2.csv", "logs/process-2.log", deadline) && child(2, "logs/conditioned.csv", "logs/conditioned.log", deadline);
    return valid ? 0 : 1;
}
