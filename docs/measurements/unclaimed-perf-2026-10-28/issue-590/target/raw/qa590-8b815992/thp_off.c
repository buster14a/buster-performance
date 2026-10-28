// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Original per-process base-page control. Does not change the host's THP policy.
#include <errno.h>
#include <stdio.h>
#include <string.h>
#include <sys/prctl.h>
#include <unistd.h>

int main(int argc, char** argv)
{
    int status = 1;
    if (argc > 1 && prctl(PR_SET_THP_DISABLE, 1, 0, 0, 0) == 0 && prctl(PR_GET_THP_DISABLE, 0, 0, 0, 0) == 1)
    {
        execvp(argv[1], argv + 1);
        fprintf(stderr, "exec %s: %s\n", argv[1], strerror(errno));
    }
    else
    {
        fprintf(stderr, "can't disable process THP or missing command: %s\n", strerror(errno));
    }
    return status;
}
