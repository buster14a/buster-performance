// Runs a command with transparent huge pages disabled for it and its children (PR_SET_THP_DISABLE), as on a host
// whose THP setting is madvise: nothp COMMAND ARGUMENTS...
#include <stdio.h>
#include <sys/prctl.h>
#include <unistd.h>
int main(int argc, char** argv)
{
    int status = 2;
    if (argc > 1 && prctl(PR_SET_THP_DISABLE, 1, 0, 0, 0) == 0)
    {
        execvp(argv[1], argv + 1);
        perror("nothp: exec");
    }
    return status;
}
