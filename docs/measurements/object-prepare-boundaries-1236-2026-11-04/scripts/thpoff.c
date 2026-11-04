// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
// thpoff COMMAND...: runs COMMAND with transparent huge pages disabled (PR_SET_THP_DISABLE), which its children inherit
// across fork and exec.
#include <stdio.h>
#include <sys/prctl.h>
#include <unistd.h>

int main(int argc, char** argv)
{
    int result = 1;
    if (argc >= 2 && prctl(PR_SET_THP_DISABLE, 1, 0, 0, 0) == 0)
    {
        execvp(argv[1], argv + 1);
        perror("thpoff: execvp");
    }
    return result;
}
