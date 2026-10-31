// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Independent fresh-process time sanity control, never a replacement denominator.
#define _POSIX_C_SOURCE 200809L
#include <errno.h>
#include <stdio.h>
#include <string.h>
#include <sys/wait.h>
#include <time.h>
#include <unistd.h>

int main(int argc, char **argv)
{
    int result = 1;
    if (argc < 4 || strcmp(argv[2], "--") != 0)
    {
        fprintf(stderr, "usage: metric-time-control NEW_RECEIPT -- PROGRAM ARG...\n");
    }
    else
    {
        FILE *output = fopen(argv[1], "wx");
        if (!output)
        {
            perror("create time receipt");
        }
        else
        {
            struct timespec start;
            struct timespec end;
            if (clock_gettime(CLOCK_MONOTONIC, &start) == 0)
            {
                pid_t child = fork();
                if (child == 0)
                {
                    fclose(output);
                    execvp(argv[3], argv + 3);
                    perror("exec workload");
                    _exit(127);
                }
                else if (child > 0)
                {
                    int status = 0;
                    pid_t waited;
                    do
                    {
                        waited = waitpid(child, &status, 0);
                    } while (waited < 0 && errno == EINTR);
                    if (waited == child && clock_gettime(CLOCK_MONOTONIC, &end) == 0)
                    {
                        int code = WIFEXITED(status) ? WEXITSTATUS(status) : 128 + WTERMSIG(status);
                        double seconds = (double)(end.tv_sec - start.tv_sec) + (double)(end.tv_nsec - start.tv_nsec) / 1000000000.0;
                        if (fprintf(output, "{\"status\":%d,\"elapsed_seconds\":%.9f,\"method\":\"CLOCK_MONOTONIC fork-to-waitpid\"}\n", code, seconds) > 0)
                        {
                            result = code;
                        }
                    }
                }
            }
            if (fclose(output) != 0)
            {
                result = 1;
            }
        }
    }
    return result;
}
