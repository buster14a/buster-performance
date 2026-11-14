#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "tier1-rows.h"
static uint64_t hash = 0xcbf29ce484222325ull;
static void mix(const void* p, unsigned n) { const unsigned char* b = p; for (unsigned i = 0; i < n; i += 1) hash = (hash ^ b[i]) * 0x100000001b3ull; }
int main(int argc, char** argv)
{
    const unsigned rounds = argc > 1 ? (unsigned)strtoul(argv[1], 0, 10) : 1;
    unsigned char in[512];
    unsigned char out[256];
    for (unsigned round = 0; round < rounds; round += 1)
    {
        for (unsigned i = 0; i < sizeof(in); i += 1) in[i] = (unsigned char)(i * 37u + (i >> 3) * 11u + round * 101u + (i % 7 == 0 ? 'a' : 0));
        memset(out, 0, sizeof(out));
        __m512i a = _mm512_loadu_si512(in);
        __m512i b = _mm512_loadu_si512(in + 64);
        __m512i c = _mm512_loadu_si512(in + 128);
        __m512i r = r_bytes(a, b);
        mix(&r, 64);
        uint64_t m = r_compares(a, b) ^ r_compares(b, c);
        mix(&m, 8);
        r = r_masked(a, b, m, (__mmask16)m);
        mix(&r, 64);
        r = r_permutes(a, b, c);
        mix(&r, 64);
        r = r_shifts(a, b, 5 + (int)(round & 3));
        mix(&r, 64);
        r_memory(out, in, m, (__mmask16)(m >> 9));
        mix(out, sizeof(out));
        r = r_lanes(a, _mm256_loadu_si256((const void*)(in + 200)), _mm_loadu_si128((const void*)(in + 300)), 0x123456789abcll * (round + 1), -77 + (int)(round & 3));
        mix(&r, 64);
        long long s = r_reduce(a, c);
        mix(&s, 8);
        __m256i n = r_narrow(_mm256_loadu_si256((const void*)(in + 17)), _mm256_loadu_si256((const void*)(in + 99)), _mm_loadu_si128((const void*)(in + 222)));
        mix(&n, 32);
        int v = r_vex(_mm256_loadu_si256((const void*)(in + 5)), _mm256_loadu_si256((const void*)(in + 41)), _mm256_loadu_si256((const void*)(in + 77)));
        mix(&v, 4);
        uint32_t k = r_loop(in, sizeof(in), out);
        mix(&k, 4);
        mix(out, 64);
    }
    printf("%016llx\n", (unsigned long long)hash);
    return 0;
}
