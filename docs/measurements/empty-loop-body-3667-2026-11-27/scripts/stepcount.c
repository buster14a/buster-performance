// stepcount ADDRESS PROGRAM ARGS...: runs PROGRAM; at each entry of the function at ADDRESS (non-PIE), single-steps
// until it returns and prints the instructions stepped, and their sum. Instruction pointers stepped, by address, go to
// steps.txt for attribution.
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <unistd.h>
#include <sys/ptrace.h>
#include <sys/wait.h>
#include <sys/user.h>
int main(int argc, char** argv)
{
    uintptr_t target = strtoull(argv[1], NULL, 16);
    pid_t pid = fork();
    if (pid == 0) { ptrace(PTRACE_TRACEME, 0, 0, 0); execv(argv[2], argv + 2); _exit(127); }
    int st; waitpid(pid, &st, 0);
    long orig = ptrace(PTRACE_PEEKTEXT, pid, (void*)target, 0);
    ptrace(PTRACE_POKETEXT, pid, (void*)target, (void*)((orig & ~0xffL) | 0xcc));
    FILE* out = fopen("steps.txt", "w");
    unsigned long long total = 0; unsigned calls = 0;
    for (;;)
    {
        ptrace(PTRACE_CONT, pid, 0, 0);
        waitpid(pid, &st, 0);
        if (WIFEXITED(st) || WIFSIGNALED(st)) break;
        struct user_regs_struct r; ptrace(PTRACE_GETREGS, pid, 0, &r);
        if (r.rip - 1 != target) { continue; }
        r.rip = target; ptrace(PTRACE_SETREGS, pid, 0, &r);
        ptrace(PTRACE_POKETEXT, pid, (void*)target, (void*)orig);
        uintptr_t ret = ptrace(PTRACE_PEEKDATA, pid, (void*)r.rsp, 0);
        uintptr_t sp0 = r.rsp;
        unsigned long long n = 0;
        for (;;)
        {
            ptrace(PTRACE_SINGLESTEP, pid, 0, 0); waitpid(pid, &st, 0); n += 1;
            ptrace(PTRACE_GETREGS, pid, 0, &r);
            fprintf(out, "%llx\n", (unsigned long long)r.rip);
            if (r.rip == ret && r.rsp > sp0) break;
        }
        total += n; calls += 1;
        printf("call %u: %llu instructions\n", calls, n);
        ptrace(PTRACE_POKETEXT, pid, (void*)target, (void*)((orig & ~0xffL) | 0xcc));
    }
    printf("calls %u total %llu\n", calls, total);
    fclose(out);
    return 0;
}
