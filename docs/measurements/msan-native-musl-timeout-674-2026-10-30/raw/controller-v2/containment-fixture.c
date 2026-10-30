// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
// Private controller controls only. Never invokes Buster or a corpus command.
#define _GNU_SOURCE
#include <errno.h>
#include <signal.h>
#include <stdbool.h>
#include <stdio.h>
#include <string.h>
#include <sys/types.h>
#include <unistd.h>

static void identity(const char* mode, const char* role)
{
    printf("fixture mode=%s role=%s pid=%ld ppid=%ld pgid=%ld sid=%ld\n", mode, role,
        (long)getpid(), (long)getppid(), (long)getpgrp(), (long)getsid(0));
}

static int failure(const char* operation)
{
    const int saved_errno = errno;
    fprintf(stderr, "fixture failure operation=%s errno=%d reason=%s pid=%ld\n",
        operation, saved_errno, strerror(saved_errno), (long)getpid());
    return 125;
}

static bool send_ready(int descriptor)
{
    ssize_t written;
    do
    {
        written = write(descriptor, "R", 1);
    } while (written < 0 && errno == EINTR);
    return written == 1;
}

static bool receive_ready(int descriptor)
{
    char byte = 0;
    ssize_t received;
    do
    {
        received = read(descriptor, &byte, 1);
    } while (received < 0 && errno == EINTR);
    return received == 1 && byte == 'R';
}

static _Noreturn void hold_until_killed(void)
{
    for (;;)
    {
        pause();
    }
}

// Deliberately do not install PDEATHSIG in the fixture's descendants. They
// must outlive an exiting ancestor so the controller has to adopt and reap
// them. Neither escaping a process group nor creating a session changes their
// ancestry under the controller's PR_SET_CHILD_SUBREAPER containment.
static int escape(const char* mode, bool parent_exits)
{
    int ready[2];
    if (pipe(ready) != 0)
    {
        return failure("parent_pipe");
    }
    const pid_t session_child = fork();
    if (session_child < 0)
    {
        close(ready[0]);
        close(ready[1]);
        return failure("session_fork");
    }
    if (session_child == 0)
    {
        close(ready[0]);
        if (setsid() < 0)
        {
            _exit(failure("setsid"));
        }
        identity(mode, "session_child");
        int nested_ready[2];
        if (pipe(nested_ready) != 0)
        {
            _exit(failure("nested_pipe"));
        }
        const pid_t group_child = fork();
        if (group_child < 0)
        {
            _exit(failure("group_fork"));
        }
        if (group_child == 0)
        {
            close(nested_ready[0]);
            close(ready[1]);
            if (setpgid(0, 0) != 0)
            {
                _exit(failure("setpgid"));
            }
            identity(mode, "separate_group_grandchild");
            if (!send_ready(nested_ready[1]))
            {
                _exit(failure("nested_ready_write"));
            }
            close(nested_ready[1]);
            hold_until_killed();
        }
        close(nested_ready[1]);
        if (!receive_ready(nested_ready[0]))
        {
            _exit(failure("nested_ready_read"));
        }
        close(nested_ready[0]);
        if (!send_ready(ready[1]))
        {
            _exit(failure("parent_ready_write"));
        }
        close(ready[1]);
        hold_until_killed();
    }
    close(ready[1]);
    if (!receive_ready(ready[0]))
    {
        close(ready[0]);
        return failure("parent_ready_read");
    }
    close(ready[0]);
    identity(mode, parent_exits ? "ready_parent_exit7" : "ready_parent_wait");
    if (parent_exits)
    {
        return 7;
    }
    hold_until_killed();
}

int main(int argc, char** argv)
{
    if (setvbuf(stdout, NULL, _IONBF, 0) != 0 || setvbuf(stderr, NULL, _IONBF, 0) != 0)
    {
        return 125;
    }
    if (argc != 2)
    {
        fprintf(stderr, "usage: containment-fixture exit7|exit127|escape|exit-with-escape|signal\n");
        return 2;
    }
    if (strcmp(argv[1], "exit7") == 0)
    {
        identity(argv[1], "direct_exit7");
        return 7;
    }
    if (strcmp(argv[1], "exit127") == 0)
    {
        identity(argv[1], "direct_exit127");
        return 127;
    }
    if (strcmp(argv[1], "signal") == 0)
    {
        struct sigaction action = {0};
        action.sa_handler = SIG_DFL;
        sigemptyset(&action.sa_mask);
        sigset_t unblocked;
        sigemptyset(&unblocked);
        sigaddset(&unblocked, SIGTERM);
        if (sigaction(SIGTERM, &action, NULL) != 0 || sigprocmask(SIG_UNBLOCK, &unblocked, NULL) != 0)
        {
            return failure("signal_setup");
        }
        identity(argv[1], "direct_sigterm");
        if (raise(SIGTERM) != 0)
        {
            return failure("raise_sigterm");
        }
        return 125;
    }
    if (strcmp(argv[1], "escape") == 0 || strcmp(argv[1], "exit-with-escape") == 0)
    {
        return escape(argv[1], strcmp(argv[1], "exit-with-escape") == 0);
    }
    fprintf(stderr, "fixture unknown_mode=%s\n", argv[1]);
    return 2;
}
