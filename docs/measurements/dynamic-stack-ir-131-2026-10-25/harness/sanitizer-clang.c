// Original test-build adapter: the existing build.sh remains unchanged. Run this as clang in a private PATH.
#include <stdio.h>
#include <string.h>
#include <unistd.h>

int main(int argc, char** argv)
{
    int result = 2;
    if (argc < 500)
    {
        char* arguments[512];
        arguments[0] = "/usr/bin/clang";
        arguments[1] = "-fsanitize=address,undefined";
        arguments[2] = "-fno-omit-frame-pointer";
        // JIT entries do not have Clang's eight-byte function-sanitizer prefix. Keep all other undefined checks.
        arguments[3] = "-fno-sanitize=function";
        for (int i = 1; i < argc; i += 1)
        {
            arguments[i + 3] = strcmp(argv[i], "-O3") == 0 ? "-O1" : argv[i];
        }
        arguments[argc + 3] = 0;
        execv(arguments[0], arguments);
        perror("sanitizer clang exec");
    }
    return result;
}
