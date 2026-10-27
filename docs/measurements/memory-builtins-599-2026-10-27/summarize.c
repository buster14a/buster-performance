// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Original #599 CSV summarizer. Each key collects independent process medians across alignments and rounds.
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
typedef struct Samples Samples;
struct Samples { double ns[32]; double instructions[32]; unsigned count; };
static Samples samples[4][5][2][9][4];
static const unsigned long sizes[] = { 0, 1, 8, 16, 32, 64, 256, 4096, 1048576 };
static const char *names[] = { "copy", "move", "set", "compare", "length" };
static int order(const void *a, const void *b)
{
    double x = *(const double *)a, y = *(const double *)b;
    return (x > y) - (x < y);
}
static double median(double *values, unsigned count)
{
    qsort(values, count, sizeof(*values), order);
    return count ? values[count / 2] : 0;
}
int main(int argc, char **argv)
{
    char line[1024], variant[64];
    for (int f = 1; f < argc; f++)
    {
        FILE *in = fopen(argv[f], "r");
        if (!in) { perror(argv[f]); return 1; }
        while (fgets(line, sizeof(line), in))
        {
            unsigned op, known, alignment, shape;
            unsigned long n;
            double ns, instructions;
            if (sscanf(line, "%63[^,],%u,%u,%lu,%u,%u,%lf,%lf", variant, &op, &known, &n, &alignment, &shape, &ns, &instructions) != 8) continue;
            unsigned v = !strcmp(variant, "base") ? 0 : !strcmp(variant, "head") ? 1 : !strcmp(variant, "clang") ? 2 : !strcmp(variant, "libc") ? 3 : 4;
            unsigned s = 0;
            while (s < 9 && sizes[s] != n) s++;
            if (v == 4 || op >= 5 || known >= 2 || s >= 9 || shape >= 4) continue;
            Samples *to = &samples[v][op][known][s][shape];
            if (to->count == 32) { fputs("too many samples\n", stderr); return 1; }
            to->ns[to->count] = ns;
            to->instructions[to->count] = instructions;
            to->count++;
        }
        fclose(in);
    }
    puts("operation,constant,n,shape,base_ns,head_ns,speedup,clang_ns,libc_ns,base_instructions_per_byte,head_instructions_per_byte");
    for (unsigned op = 0; op < 5; op++)
    for (unsigned known = 0; known < (op == 4 ? 1u : 2u); known++)
    for (unsigned s = 0; s < 9; s++)
    for (unsigned shape = 0; shape < (op == 1 ? 3u : op == 3 ? 4u : 1u); shape++)
    {
        double ns[4], instructions[4];
        for (unsigned v = 0; v < 4; v++)
        {
            Samples *from = &samples[v][op][known][s][shape];
            ns[v] = median(from->ns, from->count);
            instructions[v] = median(from->instructions, from->count);
        }
        printf("%s,%u,%lu,%u,%.3f,%.3f,%.3f,%.3f,%.3f,%.6f,%.6f\n", names[op], known, sizes[s], shape, ns[0], ns[1], ns[1] ? ns[0]/ns[1] : 0, ns[2], ns[3], instructions[0], instructions[1]);
    }
    return 0;
}
