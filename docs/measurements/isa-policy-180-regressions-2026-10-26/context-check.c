// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Original invocation-context fixture. This is not a benchmark launcher.
#define _GNU_SOURCE
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/auxv.h>
#include <unistd.h>

int main(int argc, char** argv)
{
    int result = 1;
    if (argc == 5)
    {
        const char* execution_name = (const char*)getauxval(AT_EXECFN);
        const char* environment_directory = getenv("PWD");
        char directory[4096];
        const bool passed = execution_name != NULL && environment_directory != NULL && getcwd(directory, sizeof(directory)) != NULL
                         && strcmp(argv[0], argv[1]) == 0 && strcmp(execution_name, argv[2]) == 0
                         && strcmp(environment_directory, argv[3]) == 0 && strcmp(directory, argv[4]) == 0;
        if (passed)
        {
            printf("argv0=%s\nAT_EXECFN=%s\nPWD=%s\ncwd=%s\n", argv[0], execution_name, environment_directory, directory);
            result = ferror(stdout) || fflush(stdout) != 0 ? 1 : 0;
        }
    }
    return result;
}
