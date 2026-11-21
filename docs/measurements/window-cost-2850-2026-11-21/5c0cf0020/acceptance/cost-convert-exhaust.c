#include <immintrin.h>
#include <stdint.h>
#include <stdio.h>
#define BIT(to, from) ((uint64_t)(from) << (8u * (7u - (uint32_t)__builtin_ctz((uint32_t)(to)))))
int main(void) {
    _Alignas(64) uint8_t a[64], b[64], c[64], d[64];
    unsigned checked=0;
    for (unsigned classes=0; classes<=255; ++classes) {
        for(unsigned o=0;o<256;o+=64) {
            for (unsigned i=0;i<64;i++) a[i]=(uint8_t)(i+o);
            __m512i own = _mm512_load_si512(a);
            __m512i types = _mm512_gf2p8affine_epi64_epi8(own, _mm512_set1_epi64(BIT(2,8)|BIT(16,32|128)|BIT(8,64)|BIT(4,128)), 0);
            __m512i copy = _mm512_and_si512(own,_mm512_set1_epi8((char)(classes|~4)));
            __m512i ts = _mm512_gf2p8affine_epi64_epi8(copy,_mm512_set1_epi64(BIT(4,2)|BIT(8,4)|BIT(32,128)),0);
            __m512i vs = _mm512_gf2p8affine_epi64_epi8(own,_mm512_set1_epi64(BIT(16,2)|BIT(64,4)),0);
            _mm512_store_si512(b,types); _mm512_store_si512(c,ts); _mm512_store_si512(d,vs);
            for(unsigned i=0;i<64;i++){
                unsigned x=i+o;
                if((x&160)==160) continue;
                if (b[i]!=((x>>2&2)|((x&160)?16:0)|(x>>5&4)|(x>>3&8))||c[i]!=((x<<1&4)|((classes&x)<<1&8)|(x>>2&32))||d[i]!=((x<<3&16)|(x<<4&64)))return 1;
                checked++;
            }
        }
    }
    printf("%u legal input and class byte pairs passed\n",checked);
}
