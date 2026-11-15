// Generates kernels.s and kernels.h: an aggregate copy of SIZE bytes in each piece shape, after each way of writing its
// source (#2693). Kernels take rdi = destination, rsi = a cold source, rdx = a value to build from.
//
// Shapes:
//   n8   8-byte general loads and stores (Tier 1's, and Tier 0's up to 32 bytes)
//   w16  16-byte movups loads and stores (Tier 0's past 32 bytes)
//   h16  8-byte loads into an XMM register (movq, movhps), 16-byte movups stores
//   p16  two movq loads, punpcklqdq, a 16-byte store
//   w32  32-byte vmovdqu loads and stores
//   h32  8-byte loads (vmovq, vmovhps) pairs joined by vinserti128, 32-byte stores
// Sources:
//   built   a stack object written by 8-byte stores just before the copy
//   built4  the same written by 4-byte stores
//   copied  a stack object written by a w16 copy from the cold source just before
//   far     built, then a 64-deep imul chain (~192 cycles) that the copy's source address waits for
//   cold    the cold source itself
#include <stdbool.h>
#include <stdio.h>
#include <string.h>

static const char* shapes[] = { "n8", "w16", "h16", "p16", "w32", "h32" };
static const char* sources[] = { "built", "built4", "copied", "far", "cold" };
static const unsigned sizes[] = { 16, 32, 64, 128, 256 };
static const char* gprs[] = { "%rax", "%r8", "%r9", "%r10", "%r11", "%rcx" };

static void copy(FILE* s, const char* shape, unsigned size, const char* from, const char* to)
{
    const unsigned width = strcmp(shape, "n8") == 0 ? 8 : shape[1] == '1' ? 16 : 32;
    for (unsigned o = 0, k = 0; o < size; o += width, k += 1)
    {
        const unsigned r = k % 4;
        if (strcmp(shape, "n8") == 0)
        {
            fprintf(s, "\tmovq %u(%s), %s\n\tmovq %s, %u(%s)\n", o, from, gprs[k % 6], gprs[k % 6], o, to);
        }
        else if (strcmp(shape, "w16") == 0)
        {
            fprintf(s, "\tmovups %u(%s), %%xmm%u\n\tmovups %%xmm%u, %u(%s)\n", o, from, r, r, o, to);
        }
        else if (strcmp(shape, "h16") == 0)
        {
            fprintf(s, "\tmovq %u(%s), %%xmm%u\n\tmovhps %u(%s), %%xmm%u\n\tmovups %%xmm%u, %u(%s)\n", o, from, r, o + 8, from, r, r, o, to);
        }
        else if (strcmp(shape, "p16") == 0)
        {
            fprintf(s, "\tmovq %u(%s), %%xmm%u\n\tmovq %u(%s), %%xmm%u\n\tpunpcklqdq %%xmm%u, %%xmm%u\n\tmovups %%xmm%u, %u(%s)\n", o, from, r, o + 8, from, r + 4, r + 4, r, r, o, to);
        }
        else if (strcmp(shape, "w32") == 0)
        {
            fprintf(s, "\tvmovdqu %u(%s), %%ymm%u\n\tvmovdqu %%ymm%u, %u(%s)\n", o, from, r, r, o, to);
        }
        else
        {
            fprintf(s, "\tvmovq %u(%s), %%xmm%u\n\tvmovhps %u(%s), %%xmm%u, %%xmm%u\n", o, from, r, o + 8, from, r, r);
            fprintf(s, "\tvmovq %u(%s), %%xmm%u\n\tvmovhps %u(%s), %%xmm%u, %%xmm%u\n", o + 16, from, r + 4, o + 24, from, r + 4, r + 4);
            fprintf(s, "\tvinserti128 $1, %%xmm%u, %%ymm%u, %%ymm%u\n\tvmovdqu %%ymm%u, %u(%s)\n", r + 4, r, r, r, o, to);
        }
    }
    if (shape[1] == '3')
    {
        fprintf(s, "\tvzeroupper\n");
    }
}

int main(void)
{
    FILE* s = fopen("kernels.s", "w");
    FILE* h = fopen("kernels.h", "w");
    fprintf(s, "\t.text\n");
    fprintf(h, "typedef void Kernel(void* out, const void* in, long x);\n");
    unsigned count = 0;
    for (unsigned a = 0; a < sizeof(sources) / sizeof(sources[0]); a += 1)
    {
        for (unsigned z = 0; z < sizeof(sizes) / sizeof(sizes[0]); z += 1)
        {
            for (unsigned b = 0; b < sizeof(shapes) / sizeof(shapes[0]); b += 1)
            {
                const unsigned size = sizes[z];
                const char* source = sources[a];
                const char* shape = shapes[b];
                if (shape[1] == '3' && size < 32)
                {
                    continue;
                }
                fprintf(s, "\t.globl k_%s_%s_%u\n\t.p2align 6\nk_%s_%s_%u:\n", source, shape, size, source, shape, size);
                const bool cold = strcmp(source, "cold") == 0;
                if (cold)
                {
                    copy(s, shape, size, "%rsi", "%rdi");
                }
                else
                {
                    fprintf(s, "\tsubq $%u, %%rsp\n", size + 8);
                    if (strcmp(source, "copied") == 0)
                    {
                        copy(s, "w16", size, "%rsi", "%rsp");
                    }
                    else
                    {
                        const unsigned step = strcmp(source, "built4") == 0 ? 4 : 8;
                        for (unsigned o = 0; o < size; o += step)
                        {
                            fprintf(s, "\tleaq %u(%%rdx), %%rax\n", o);
                            fprintf(s, step == 8 ? "\tmovq %%rax, %u(%%rsp)\n" : "\tmovl %%eax, %u(%%rsp)\n", o);
                        }
                    }
                    if (strcmp(source, "far") == 0)
                    {
                        fprintf(s, "\tmovq %%rdx, %%rax\n");
                        for (unsigned k = 0; k < 64; k += 1)
                        {
                            fprintf(s, "\timulq $3, %%rax, %%rax\n");
                        }
                        fprintf(s, "\tmovq %%rax, %%rcx\n\tsubq %%rdx, %%rcx\n\tsubq %%rax, %%rcx\n\taddq %%rdx, %%rcx\n");
                        fprintf(s, "\tleaq (%%rsp,%%rcx), %%rsi\n");
                        copy(s, shape, size, "%rsi", "%rdi");
                    }
                    else
                    {
                        copy(s, shape, size, "%rsp", "%rdi");
                    }
                    fprintf(s, "\taddq $%u, %%rsp\n", size + 8);
                }
                fprintf(s, "\tret\n");
                fprintf(h, "Kernel k_%s_%s_%u;\n", source, shape, size);
                count += 1;
            }
        }
    }
    fprintf(h, "static const struct { const char* source; const char* shape; unsigned size; Kernel* run; } kernels[] = {\n");
    for (unsigned a = 0; a < sizeof(sources) / sizeof(sources[0]); a += 1)
    {
        for (unsigned z = 0; z < sizeof(sizes) / sizeof(sizes[0]); z += 1)
        {
            for (unsigned b = 0; b < sizeof(shapes) / sizeof(shapes[0]); b += 1)
            {
                if (shapes[b][1] == '3' && sizes[z] < 32)
                {
                    continue;
                }
                fprintf(h, "    { \"%s\", \"%s\", %u, k_%s_%s_%u },\n", sources[a], shapes[b], sizes[z], sources[a], shapes[b], sizes[z]);
            }
        }
    }
    fprintf(h, "};\n");
    fprintf(s, "\t.section .note.GNU-stack,\"\",@progbits\n");
    fclose(s);
    fclose(h);
    printf("%u kernels\n", count);
    return 0;
}
