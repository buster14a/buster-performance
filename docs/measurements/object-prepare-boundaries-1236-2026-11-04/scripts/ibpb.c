// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
// ibpb COMMAND...: runs COMMAND with indirect branch speculation force-disabled (PR_SPEC_INDIRECT_BRANCH,
// PR_SPEC_FORCE_DISABLE), which its children inherit: with "IBPB: conditional", the kernel then flushes the branch
// predictors when it switches to or from these tasks, so no process inherits another's predictions.
#include <linux/prctl.h>
#include <stdio.h>
#include <sys/prctl.h>
#include <unistd.h>

int main(int argc, char** argv)
{
    int result = 1;
    if (argc >= 2 && prctl(PR_SET_SPECULATION_CTRL, PR_SPEC_INDIRECT_BRANCH, PR_SPEC_FORCE_DISABLE, 0, 0) == 0)
    {
        execvp(argv[1], argv + 1);
        perror("ibpb: execvp");
    }
    else
    {
        perror("ibpb: prctl");
    }
    return result;
}
