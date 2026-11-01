// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Original wrapper for buster #590 / buster14a/buster#1027: runs a command with transparent huge pages disabled for it
// and its children (PR_SET_THP_DISABLE, which fork and exec keep), standing in for a kernel set to never.
#include <sys/prctl.h>
#include <unistd.h>
#include <stdio.h>
int main(int argc, char** argv)
{
    int result = 1;
    if (argc > 1 && prctl(PR_SET_THP_DISABLE, 1, 0, 0, 0) == 0)
    {
        execv(argv[1], argv + 1);
        perror("execv");
    }
    return result;
}
