#define _POSIX_C_SOURCE 200809L
#include <stdio.h>
#include <string.h>
int main(int argc, char** argv)
{
    const char* mode = argc > 1 ? argv[1] : "missing";
    int status = 0;
    if (strcmp(mode, "valid") == 0)
    {
        fputs("ordinary diagnostic\nintrinsic_setup_ns=10\nintrinsic_setup_ns=20\n", stderr);
    }
    else if (strcmp(mode, "malformed") == 0)
    {
        fputs("intrinsic_setup_ns=4x\n", stderr);
    }
    else if (strcmp(mode, "overflow") == 0)
    {
        fputs("intrinsic_setup_ns=18446744073709551615\nintrinsic_setup_ns=1\n", stderr);
    }
    else if (strcmp(mode, "failure") == 0)
    {
        fputs("intrinsic_setup_ns=10\n", stderr);
        status = 7;
    }
    else if (strcmp(mode, "cap") == 0)
    {
        char block[4096];
        memset(block, 'x', sizeof(block));
        for (unsigned int i = 0; i < 1025; i += 1)
        {
            fwrite(block, 1, sizeof(block), stderr);
        }
        fputs("\nintrinsic_setup_ns=10\n", stderr);
    }
    return status;
}
