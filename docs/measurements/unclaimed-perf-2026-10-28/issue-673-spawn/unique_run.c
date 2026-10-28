// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Original #673 evidence adapter: keep every make cohort's outputs and command in a fresh directory.
#define _GNU_SOURCE
#include <errno.h>
#include <fcntl.h>
#include <limits.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

int main(int argc, char** argv)
{
    int result = 2;
    bool valid = argc >= 4 && mkdtemp(argv[1]) != NULL;
    char path[PATH_MAX];
    char directory[PATH_MAX + 16];
    const int length = valid ? snprintf(directory, sizeof(directory), "DIRECTORY=%s", argv[1]) : -1;
    valid = valid && length > 0 && (size_t)length < sizeof(directory);
    const int written = valid ? snprintf(path, sizeof(path), "%s/argv.txt", argv[1]) : -1;
    FILE* receipt = written > 0 && (size_t)written < sizeof(path) ? fopen(path, "w") : NULL;
    valid = receipt != NULL && valid;
    for (int index = 2; valid && index < argc; index += 1)
    {
        argv[index] = strcmp(argv[index], "DIRECTORY=@DIRECTORY@") == 0 ? directory : argv[index];
        valid = fprintf(receipt, "%s\n", argv[index]) > 0;
    }
    if (receipt != NULL)
    {
        valid = fclose(receipt) == 0 && valid;
    }
    for (unsigned stream = 1; valid && stream <= 2; stream += 1)
    {
        const int bytes = snprintf(path, sizeof(path), "%s/make.%s", argv[1], stream == 1 ? "stdout" : "stderr");
        const int fd = bytes > 0 && (size_t)bytes < sizeof(path) ? open(path, O_WRONLY | O_CREAT | O_TRUNC | O_CLOEXEC, 0644) : -1;
        valid = fd >= 0 && dup2(fd, (int)stream) >= 0;
        if (fd >= 0 && fd != (int)stream)
        {
            close(fd);
        }
    }
    if (valid)
    {
        execv(argv[2], argv + 2);
        result = errno == ENOENT ? 127 : 126;
    }
    return result;
}
