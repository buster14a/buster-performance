#!/bin/bash
# Writes asm.c (N functions of 4 asm statements: registers with a modifier, a barrier, cpuid's fixed registers and a
# memory output) and plain.c, the same functions with C in their place, for the per-statement cost of -c.
n=${1:-1000}
{
    for ((i = 0; i < n; i += 1)); do
        cat <<C
unsigned long f$i(unsigned long a, unsigned long b)
{
    unsigned long r;
    unsigned int eax, ebx, ecx, edx;
    unsigned short cw;
    __asm__("leaq (%1,%2), %0" : "=r"(r) : "r"(a), "r"(b));
    __asm__ volatile("" : : "r"(r) : "memory");
    __asm__ volatile("cpuid" : "=a"(eax), "=b"(ebx), "=c"(ecx), "=d"(edx) : "a"((unsigned int)a), "c"(0));
    __asm__ volatile("fnstcw %0" : "=m"(cw));
    return r + eax + ebx + ecx + edx + cw;
}
C
    done
} > asm.c
{
    for ((i = 0; i < n; i += 1)); do
        cat <<C
unsigned long f$i(unsigned long a, unsigned long b)
{
    unsigned long r;
    unsigned int eax, ebx, ecx, edx;
    unsigned short cw;
    r = a + b;
    eax = (unsigned int)a;
    ebx = 1;
    ecx = 2;
    edx = 3;
    cw = 0x37f;
    return r + eax + ebx + ecx + edx + cw;
}
C
    done
} > plain.c
