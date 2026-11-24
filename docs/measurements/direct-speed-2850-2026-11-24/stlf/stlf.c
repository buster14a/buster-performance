// stlf STORE_BYTES LOAD_BYTES OFFSET [ITERATIONS]: a loop whose value goes through a store of STORE_BYTES at a buffer's
// start and a load of LOAD_BYTES at OFFSET, to read the forwarding latency and whether it fails on this CPU.
// A STORE_BYTES of 0 stores the struct's fields one at a time (4, 1, 1, 1, 1, 8, 4, 4 bytes) instead.
#define _GNU_SOURCE
#include <immintrin.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

static uint8_t buffer[256] __attribute__((aligned(64)));

int main(int argc, char** argv)
{
    const int store_bytes = argc > 1 ? atoi(argv[1]) : 64;
    const int load_bytes = argc > 2 ? atoi(argv[2]) : 4;
    const int offset = argc > 3 ? atoi(argv[3]) : 0;
    const uint64_t iterations = argc > 4 ? strtoull(argv[4], 0, 0) : 20000000u;
    const int misalign = argc > 5 ? atoi(argv[5]) : 0;
    uint8_t* const b = buffer + 64 + misalign;
    uint64_t x = 1;
    for (uint64_t i = 0; i < iterations; i += 1)
    {
        switch (store_bytes)
        {
            case 64: { __m512i v = _mm512_set1_epi64((long long)x); __asm__ volatile("vmovdqu64 %0, (%1)" : : "v"(v), "r"(b) : "memory"); } break;
            case 32: { __m256i v = _mm256_set1_epi64x((long long)x); __asm__ volatile("vmovdqu %0, (%1)" : : "x"(v), "r"(b) : "memory"); } break;
            case 16: { __m128i v = _mm_set1_epi64x((long long)x); __asm__ volatile("vmovdqu %0, (%1)" : : "x"(v), "r"(b) : "memory"); } break;
            case 8: __asm__ volatile("movq %0, (%1)" : : "r"(x), "r"(b) : "memory"); break;
            case 4: __asm__ volatile("movl %k0, (%1)" : : "r"(x), "r"(b) : "memory"); break;
            case 1: __asm__ volatile("movb %b0, (%1)" : : "q"(x), "r"(b) : "memory"); break;
            default:
                __asm__ volatile("movl %k0, (%1)\n\tmovb %b0, 4(%1)\n\tmovb %b0, 5(%1)\n\tmovb %b0, 6(%1)\n\tmovb %b0, 7(%1)\n\tmovq %0, 8(%1)\n\tmovl %k0, 16(%1)\n\tmovl %k0, 20(%1)\n\tmovq %0, 24(%1)\n\tmovq %0, 32(%1)"
                                 : : "q"(x), "r"(b) : "memory");
                break;
        }
        uint64_t y = 0;
        switch (load_bytes)
        {
            case 64: { __m512i v; __asm__ volatile("vmovdqu64 (%1), %0" : "=v"(v) : "r"(b + offset) : "memory"); y = (uint64_t)_mm_cvtsi128_si64(_mm512_castsi512_si128(v)); } break;
            case 32: { __m256i v; __asm__ volatile("vmovdqu (%1), %0" : "=x"(v) : "r"(b + offset) : "memory"); y = (uint64_t)_mm_cvtsi128_si64(_mm256_castsi256_si128(v)); } break;
            case 16: { __m128i v; __asm__ volatile("vmovdqu (%1), %0" : "=x"(v) : "r"(b + offset) : "memory"); y = (uint64_t)_mm_cvtsi128_si64(v); } break;
            case 8: __asm__ volatile("movq (%1), %0" : "=r"(y) : "r"(b + offset) : "memory"); break;
            case 4: __asm__ volatile("movl (%1), %k0" : "=r"(y) : "r"(b + offset) : "memory"); break;
            default: __asm__ volatile("movzbl (%1), %k0" : "=r"(y) : "r"(b + offset) : "memory"); break;
        }
        x = (y & 0xff) + 1;
    }
    printf("%llu\n", (unsigned long long)x);
    return 0;
}
