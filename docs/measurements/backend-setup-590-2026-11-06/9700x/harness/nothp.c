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
