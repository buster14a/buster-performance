// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
//
// refuse: runs a command with PROT_NONE mmaps of 8 GiB to 64 GiB refused with EINVAL (seccomp), as Valgrind's address
// manager may refuse a valid mapping, so that the preprocessor's shared tables' reservation, and no other, is refused.
#define _GNU_SOURCE
#include <errno.h>
#include <linux/filter.h>
#include <linux/seccomp.h>
#include <stddef.h>
#include <stdio.h>
#include <sys/mman.h>
#include <sys/prctl.h>
#include <sys/syscall.h>
#include <unistd.h>

int main(int count, char** arguments)
{
    const struct sock_filter instructions[] = {
        BPF_STMT(BPF_LD | BPF_W | BPF_ABS, offsetof(struct seccomp_data, nr)),
        BPF_JUMP(BPF_JMP | BPF_JEQ | BPF_K, __NR_mmap, 0, 6),
        BPF_STMT(BPF_LD | BPF_W | BPF_ABS, offsetof(struct seccomp_data, args[2])),
        BPF_JUMP(BPF_JMP | BPF_JEQ | BPF_K, PROT_NONE, 0, 4),
        BPF_STMT(BPF_LD | BPF_W | BPF_ABS, offsetof(struct seccomp_data, args[1]) + 4),
        BPF_JUMP(BPF_JMP | BPF_JGE | BPF_K, 2, 0, 2),
        BPF_JUMP(BPF_JMP | BPF_JGE | BPF_K, 16, 1, 0),
        BPF_STMT(BPF_RET | BPF_K, SECCOMP_RET_ERRNO | EINVAL),
        BPF_STMT(BPF_RET | BPF_K, SECCOMP_RET_ALLOW),
    };
    const struct sock_fprog filter = { .len = sizeof(instructions) / sizeof(instructions[0]), .filter = (struct sock_filter*)instructions };
    int result = 1;
    if (count > 1 && prctl(PR_SET_NO_NEW_PRIVS, 1, 0, 0, 0) == 0 && prctl(PR_SET_SECCOMP, SECCOMP_MODE_FILTER, &filter) == 0)
    {
        execv(arguments[1], arguments + 1);
        perror("execv");
    }
    return result;
}
