// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Original target byte/syscall capture for one compiler, with stderr either a file or a drained pipe.
#include <errno.h>
#include <fcntl.h>
#include <limits.h>
#include <stdbool.h>
#include <stdio.h>
#include <string.h>
#include <sys/wait.h>
#include <unistd.h>

int main(int argc, char** argv)
{
    int result = 2;
    if (argc == 5 && (strcmp(argv[4], "file") == 0 || strcmp(argv[4], "pipe") == 0))
    {
        const bool piped = strcmp(argv[4], "pipe") == 0;
        char out[PATH_MAX];
        char errors[PATH_MAX];
        char object[PATH_MAX];
        char trace[PATH_MAX];
        snprintf(out, sizeof(out), "%s.stdout", argv[3]);
        snprintf(errors, sizeof(errors), "%s.stderr", argv[3]);
        snprintf(object, sizeof(object), "%s.o", argv[3]);
        snprintf(trace, sizeof(trace), "%s.strace", argv[3]);
        int descriptors[2] = { -1, -1 };
        const int output = open(out, O_WRONLY | O_CREAT | O_TRUNC, 0600);
        const int error = open(errors, O_WRONLY | O_CREAT | O_TRUNC, 0600);
        result = output < 0 || error < 0 || (piped && pipe(descriptors) != 0);
        const pid_t child = result == 0 ? fork() : -1;
        if (child == 0)
        {
            if (dup2(output, STDOUT_FILENO) < 0 || dup2(piped ? descriptors[1] : error, STDERR_FILENO) < 0)
            {
                _exit(127);
            }
            close(output);
            close(error);
            if (piped)
            {
                close(descriptors[0]);
                close(descriptors[1]);
            }
            execlp("strace", "strace", "-qq", "-f", "-e", "trace=write,writev,pwrite64", "-o", trace,
                   argv[1], "--lanes", "1", "-c", argv[2], "-o", object, (char*)0);
            _exit(127);
        }
        if (piped && descriptors[1] >= 0)
        {
            close(descriptors[1]);
            char bytes[16384];
            ssize_t count;
            do
            {
                count = read(descriptors[0], bytes, sizeof(bytes));
                for (ssize_t done = 0; count > 0 && done < count;)
                {
                    const ssize_t written = write(error, bytes + done, (size_t)(count - done));
                    if (written > 0)
                    {
                        done += written;
                    }
                    else if (written < 0 && errno != EINTR)
                    {
                        result = 1;
                        break;
                    }
                }
            } while (count > 0 || (count < 0 && errno == EINTR));
            result |= count < 0;
            close(descriptors[0]);
        }
        if (output >= 0)
        {
            close(output);
        }
        if (error >= 0)
        {
            close(error);
        }
        int status = 0;
        pid_t waited;
        do
        {
            waited = child > 0 ? waitpid(child, &status, 0) : -1;
        } while (waited < 0 && errno == EINTR);
        result |= waited != child || child <= 0 || !WIFEXITED(status) || WEXITSTATUS(status) != 0;
    }
    if (result != 0)
    {
        fprintf(stderr, "capture: failed (%d, errno %d)\n", result, errno);
    }
    return result;
}
