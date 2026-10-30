// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Original fault controls for the fixed campaign's textual decoder contract.
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main(int argc, char** argv)
{
    const int mode = argc == 4 ? atoi(argv[1]) : -1;
    FILE* input = argc == 4 ? fopen(argv[2], "rb") : NULL;
    bool valid = input != NULL && fseek(input, 0, SEEK_END) == 0;
    const long length = valid ? ftell(input) : -1;
    valid = valid && length > 0 && length <= 67108864;
    char* bytes = valid ? malloc((size_t)length + 1) : NULL;
    valid = valid && bytes != NULL && fseek(input, 0, SEEK_SET) == 0 && fread(bytes, 1, (size_t)length, input) == (size_t)length;
    if (input != NULL) { valid = fclose(input) == 0 && valid; }
    if (valid) { bytes[length] = 0; }
    size_t start = 0;
    if (valid && mode == 0)
    {
        char* first = strchr(bytes, '\n'); valid = first != NULL;
        if (valid) { start = (size_t)(first + 1 - bytes); }
    }
    else if (valid && mode == 1)
    {
        char* caller = strstr(bytes, "92dc5c "); valid = caller != NULL;
        if (valid) { caller[5] = 'b'; }
    }
    else if (valid && mode == 2)
    {
        char* ip = strstr(bytes, "cycles:u:"); valid = ip != NULL;
        if (valid)
        {
            ip += strlen("cycles:u:"); while (*ip == ' ' || *ip == '\t') { ip += 1; }
            valid = *ip != 0 && *ip != '\n'; if (valid) { *ip = *ip == '0' ? '1' : '0'; }
        }
    }
    else if (mode != 3) { valid = false; }
    FILE* output = valid ? fopen(argv[3], "wb") : NULL;
    valid = valid && output != NULL;
    if (valid)
    {
        valid = fwrite(bytes + start, 1, (size_t)length - start, output) == (size_t)length - start;
        if (valid && mode == 3)
        {
            char* first = strchr(bytes, '\n'); valid = first != NULL;
            if (valid) { valid = fwrite(bytes, 1, (size_t)(first + 1 - bytes), output) == (size_t)(first + 1 - bytes); }
        }
    }
    if (output != NULL) { valid = fclose(output) == 0 && valid; }
    free(bytes);
    return valid ? 0 : 1;
}
