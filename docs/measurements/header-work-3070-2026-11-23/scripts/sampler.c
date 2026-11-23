// A flat RIP sampler by ptrace: sampler INTERVAL_US OUT -- COMMAND...   (one thread; writes one hex RIP a line)
#define _GNU_SOURCE
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <signal.h>
#include <time.h>
#include <sys/ptrace.h>
#include <sys/wait.h>
#include <sys/user.h>

int main(int argc, char** argv)
{
    const long interval = atol(argv[1]);
    FILE* out = fopen(argv[2], "w");
    pid_t pid = fork();
    if (pid == 0)
    {
        raise(SIGSTOP);
        execvp(argv[4], argv + 4);
        _exit(127);
    }
    int status;
    waitpid(pid, &status, WUNTRACED);
    ptrace(PTRACE_SEIZE, pid, 0, PTRACE_O_TRACEEXEC);
    kill(pid, SIGCONT);
    struct timespec nap = { .tv_sec = 0, .tv_nsec = interval * 1000 };
    long samples = 0;
    for (;;)
    {
        nanosleep(&nap, 0);
        if (ptrace(PTRACE_INTERRUPT, pid, 0, 0) != 0)
        {
            break;
        }
        if (waitpid(pid, &status, 0) != pid || WIFEXITED(status) || WIFSIGNALED(status))
        {
            break;
        }
        struct user_regs_struct regs;
        if (ptrace(PTRACE_GETREGS, pid, 0, &regs) == 0)
        {
            fprintf(out, "%llx\n", (unsigned long long)regs.rip);
            samples += 1;
        }
        int sig = 0;
        if (WIFSTOPPED(status) && (status >> 16) == 0 && WSTOPSIG(status) != SIGTRAP && WSTOPSIG(status) != SIGSTOP && WSTOPSIG(status) != SIGCONT)
        {
            sig = WSTOPSIG(status);
        }
        ptrace(PTRACE_CONT, pid, 0, sig);
    }
    fclose(out);
    fprintf(stderr, "%ld samples\n", samples);
    return 0;
}
