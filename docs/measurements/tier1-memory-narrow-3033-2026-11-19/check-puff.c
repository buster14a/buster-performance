#include <stdio.h>
#include <string.h>
#include "puff.h"

int main(int argc, char **argv)
{
    static unsigned char input[65536], output[131072];
    if (argc != 2)
        return 1;
    FILE *stream = fopen(argv[1], "rb");
    if (!stream)
        return 2;
    size_t bytes = fread(input, 1, sizeof(input), stream);
    if (ferror(stream) || !feof(stream) || fclose(stream) || bytes < 19 || input[0] != 31 || input[1] != 139 || input[3] != 0)
        return 3;
    unsigned long in = bytes - 18, out = sizeof(output);
    if (puff(output, &out, input + 10, &in) != 0 || in != bytes - 18 || fwrite(output, 1, out, stdout) != out)
        return 4;
    fprintf(stderr, "puff: block type %u, %lu deflate bytes, %lu output bytes\n", (input[10] >> 1) & 3, in, out);
    return 0;
}
