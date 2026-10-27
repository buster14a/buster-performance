// Runs a command with transparent huge pages disabled for it and its children (PR_SET_THP_DISABLE survives fork and
// execve): the control for the hello world's extra .bss huge page.
#include <stdio.h>
#include <sys/prctl.h>
#include <unistd.h>

int main(int argc, char** argv)
{
    int status = 1;
    if (argc < 2)
    {
        fprintf(stderr, "usage: thp-off COMMAND...\n");
    }
    else if (prctl(PR_SET_THP_DISABLE, 1, 0, 0, 0) != 0)
    {
        perror("prctl");
    }
    else
    {
        execvp(argv[1], argv + 1);
        perror("execvp");
    }
    return status;
}
