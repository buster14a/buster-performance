// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
// Private adaptation of the kill/reap protocol in Buster differential.c at
// 674ae159503b4b51f2c54865d9cfdd225e9d27a0. No compiler source is modified.
#define _GNU_SOURCE
#include <errno.h>
#include <fcntl.h>
#include <limits.h>
#include <poll.h>
#include <signal.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/prctl.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <time.h>
#include <unistd.h>

static volatile sig_atomic_t stop_signal;

static void note_signal(int signal_number)
{
    stop_signal = signal_number;
}

static uint64_t milliseconds(void)
{
    struct timespec now = {0};
    const bool valid = clock_gettime(CLOCK_MONOTONIC, &now) == 0;
    return valid ? (uint64_t)now.tv_sec * 1000 + (uint64_t)now.tv_nsec / 1000000 : 0;
}

// This file contains only this private subreaper's direct children. An exiting
// adopted parent exposes its surviving children on a later pass, even across
// setsid/setpgid. No unrelated processes are searched or signaled.
static bool reap_tree(pid_t command, uint64_t deadline, FILE* receipt)
{
    bool complete = false;
    kill(-command, SIGKILL);
    kill(command, SIGKILL);
    uint64_t now = milliseconds();
    while (!complete && now != 0 && now < deadline)
    {
        int status = 0;
        pid_t child = waitpid(-1, &status, WNOHANG);
        while (child > 0)
        {
            fprintf(receipt, "reaped=%ld raw_status=%d\n", (long)child, status);
            child = waitpid(-1, &status, WNOHANG);
        }
        complete = child < 0 && errno == ECHILD;
        if (!complete)
        {
            char path[128];
            const int length = snprintf(path, sizeof(path), "/proc/self/task/%ld/children", (long)getpid());
            FILE* file = length > 0 && (size_t)length < sizeof(path) ? fopen(path, "r") : NULL;
            if (file)
            {
                long adopted = 0;
                while (fscanf(file, "%ld", &adopted) == 1)
                {
                    if (adopted > 0 && adopted <= INT_MAX)
                    {
                        fprintf(receipt, "kill_owned_child=%ld\n", adopted);
                        kill((pid_t)adopted, SIGKILL);
                    }
                }
                fclose(file);
            }
            poll(NULL, 0, 2);
        }
        now = milliseconds();
    }
    return complete;
}

int main(int argc, char** argv)
{
    int result = 125;
    FILE* receipt = argc >= 4 ? fopen(argv[2], "wx") : NULL;
    if (receipt)
    {
        setvbuf(receipt, NULL, _IONBF, 0);
        char* end = NULL;
        errno = 0;
        const unsigned long seconds = strtoul(argv[1], &end, 10);
        bool valid = errno == 0 && end && *end == 0 && seconds > 0 && seconds <= 240;
        valid = valid && fcntl(fileno(receipt), F_SETFD, FD_CLOEXEC) == 0;
        const pid_t parent = getppid();
        const uint64_t start = milliseconds();
        struct sigaction action = {0};
        action.sa_handler = note_signal;
        sigemptyset(&action.sa_mask);
        valid = valid && start != 0 && prctl(PR_SET_CHILD_SUBREAPER, 1) == 0;
        valid = valid && sigaction(SIGTERM, &action, NULL) == 0 && sigaction(SIGINT, &action, NULL) == 0 && sigaction(SIGHUP, &action, NULL) == 0;
        valid = valid && prctl(PR_SET_PDEATHSIG, SIGTERM) == 0;
        if (getppid() != parent || parent == 1)
        {
            stop_signal = SIGTERM;
        }
        struct sigaction child_action = {0};
        child_action.sa_handler = SIG_DFL;
        sigemptyset(&child_action.sa_mask);
        valid = valid && sigaction(SIGCHLD, &child_action, NULL) == 0;
        sigset_t empty;
        sigemptyset(&empty);
        valid = valid && sigprocmask(SIG_SETMASK, &empty, NULL) == 0;
        fprintf(receipt, "supervisor=%ld parent=%ld seconds=%lu setup=%d\n", (long)getpid(), (long)parent, seconds, valid);
        pid_t command = valid ? fork() : -1;
        if (command == 0)
        {
            sigaction(SIGTERM, &child_action, NULL);
            sigaction(SIGINT, &child_action, NULL);
            sigaction(SIGHUP, &child_action, NULL);
            if (setpgid(0, 0) != 0)
            {
                _exit(126);
            }
            execvp(argv[3], argv + 3);
            _exit(127);
        }
        if (command > 0)
        {
            fprintf(receipt, "command=%ld\n", (long)command);
            const uint64_t deadline = start + (uint64_t)seconds * 1000;
            siginfo_t information = {0};
            int observed = 0;
            bool timed_out = false;
            bool clock_failed = false;
            while (observed == 0 && stop_signal == 0 && !timed_out && !clock_failed)
            {
                information = (siginfo_t){0};
                const int inspected = waitid(P_PID, (id_t)command, &information, WEXITED | WNOHANG | WNOWAIT);
                if (inspected == 0 && information.si_pid == command)
                {
                    observed = 1;
                }
                else if (inspected != 0 && errno != EINTR)
                {
                    observed = -1;
                }
                const uint64_t now = milliseconds();
                clock_failed = now == 0;
                timed_out = !clock_failed && now >= deadline;
                if (observed == 0 && stop_signal == 0 && !timed_out && !clock_failed)
                {
                    poll(NULL, 0, 20);
                }
            }
            fprintf(receipt, "observed=%d command_status=%d command_code=%d timed_out=%d signal=%d clock_failed=%d\n", observed, information.si_status, information.si_code, timed_out, stop_signal, clock_failed);
            const uint64_t cleanup_start = milliseconds();
            const bool clean = reap_tree(command, cleanup_start != 0 ? cleanup_start + 10000 : 0, receipt);
            fprintf(receipt, "cleanup=%s\n", clean ? "ECHILD" : "INCOMPLETE");
            if (clean && !clock_failed && timed_out)
            {
                result = 124;
            }
            else if (clean && !clock_failed && stop_signal != 0)
            {
                result = 128 + stop_signal;
            }
            else if (clean && !clock_failed && observed == 1)
            {
                result = information.si_code == CLD_EXITED ? information.si_status :
                    information.si_code == CLD_KILLED || information.si_code == CLD_DUMPED ? 128 + information.si_status : 125;
            }
        }
        fprintf(receipt, "supervisor_exit=%d\n", result);
        fclose(receipt);
    }
    return result;
}
