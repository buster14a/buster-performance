#include <immintrin.h>
#include <stdint.h>
__m512i r_bytes(__m512i a, __m512i b);
uint64_t r_compares(__m512i a, __m512i b);
__m512i r_masked(__m512i a, __m512i b, __mmask64 k, __mmask16 k16);
__m512i r_permutes(__m512i a, __m512i b, __m512i idx);
__m512i r_shifts(__m512i a, __m512i b, int n);
void r_memory(unsigned char* out, const unsigned char* in, __mmask64 k, __mmask16 k16);
__m512i r_lanes(__m512i a, __m256i h, __m128i l, long long g, int i);
long long r_reduce(__m512i a, __m512i b);
__m256i r_narrow(__m256i a, __m256i b, __m128i c);
uint32_t r_loop(const unsigned char* p, unsigned n, unsigned char* out);
int r_vex(__m256i a, __m256i b, __m256i m);
