// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Original bounded reader for Clang -M's escaped dependency names. Emits NUL-separated paths for hashing.
#include <ctype.h>
#include <limits.h>
#include <stdbool.h>
#include <stdio.h>

int main(int argc, char** argv)
{
    FILE* input = argc == 2 ? fopen(argv[1], "r") : NULL;
    bool valid = input != NULL;
    bool dependencies = false;
    bool escaped = false;
    char path[PATH_MAX];
    unsigned length = 0;
    unsigned count = 0;
    int byte = 0;
    while (valid && (byte = fgetc(input)) != EOF)
    {
        bool append = false;
        if (!dependencies)
        {
            dependencies = byte == ':';
        }
        else if (escaped)
        {
            append = byte != '\n';
            escaped = false;
        }
        else if (byte == '\\')
        {
            escaped = true;
        }
        else if (isspace((unsigned char)byte))
        {
            if (length != 0)
            {
                valid = fwrite(path, 1, length, stdout) == length && putchar(0) != EOF;
                count += 1;
                length = 0;
            }
        }
        else
        {
            append = true;
        }
        if (append)
        {
            valid = length < sizeof(path);
            if (valid)
            {
                path[length++] = (char)byte;
            }
        }
    }
    if (valid && length != 0)
    {
        valid = fwrite(path, 1, length, stdout) == length && putchar(0) != EOF;
        count += 1;
    }
    if (input != NULL)
    {
        valid = ferror(input) == 0 && valid;
        valid = fclose(input) == 0 && valid;
    }
    valid = valid && dependencies && !escaped && count != 0 && fflush(stdout) == 0;
    return !valid;
}
