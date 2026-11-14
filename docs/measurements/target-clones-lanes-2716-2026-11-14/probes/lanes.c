#include <immintrin.h>
#include <stdio.h>
#define M(v) do{for(unsigned k_=0;k_<sizeof(v);k_++)h=(h^((unsigned char*)&(v))[k_])*16777619u;}while(0)
__attribute__((target_clones("avx10.2","default"))) static unsigned probe(const unsigned char* in){unsigned h=2166136261u;
__m512i a,b,c;__builtin_memcpy(&a,in,64);__builtin_memcpy(&b,in+64,64);__builtin_memcpy(&c,in+128,64);__m256i a2,b2,c2;__builtin_memcpy(&a2,in+8,32);__builtin_memcpy(&b2,in+72,32);__builtin_memcpy(&c2,in+136,32);__m128i a1,b1,c1;__builtin_memcpy(&a1,in+16,16);__builtin_memcpy(&b1,in+80,16);__builtin_memcpy(&c1,in+144,16);
__m512 f,g;__builtin_memcpy(&f,in,64);__builtin_memcpy(&g,in+64,64);__m512d d,e;__builtin_memcpy(&d,in+32,64);__builtin_memcpy(&e,in+96,64);__m256 f2;__builtin_memcpy(&f2,in+40,32);__m256d d2;__builtin_memcpy(&d2,in+48,32);__m128 f1;__builtin_memcpy(&f1,in+56,16);__m128d d1;__builtin_memcpy(&d1,in+60,16);__m256 g2;__builtin_memcpy(&g2,in+100,32);__m256d e2;__builtin_memcpy(&e2,in+104,32);
unsigned long long k=0;__builtin_memcpy(&k,in+192,8);
{__auto_type r=_mm512_rol_epi32(a,0);M(r);r=_mm512_ror_epi32(a,0);M(r);}
{__auto_type r=_mm512_rol_epi32(a,1);M(r);r=_mm512_ror_epi32(a,1);M(r);}
{__auto_type r=_mm512_rol_epi32(a,7);M(r);r=_mm512_ror_epi32(a,7);M(r);}
{__auto_type r=_mm512_rol_epi32(a,31);M(r);r=_mm512_ror_epi32(a,31);M(r);}
{__auto_type r=_mm512_rol_epi32(a,33);M(r);r=_mm512_ror_epi32(a,33);M(r);}
{__auto_type r=_mm512_rol_epi32(a,63);M(r);r=_mm512_ror_epi32(a,63);M(r);}
{__auto_type r=_mm512_rol_epi64(a,0);M(r);r=_mm512_ror_epi64(a,0);M(r);}
{__auto_type r=_mm512_rol_epi64(a,1);M(r);r=_mm512_ror_epi64(a,1);M(r);}
{__auto_type r=_mm512_rol_epi64(a,7);M(r);r=_mm512_ror_epi64(a,7);M(r);}
{__auto_type r=_mm512_rol_epi64(a,31);M(r);r=_mm512_ror_epi64(a,31);M(r);}
{__auto_type r=_mm512_rol_epi64(a,33);M(r);r=_mm512_ror_epi64(a,33);M(r);}
{__auto_type r=_mm512_rol_epi64(a,63);M(r);r=_mm512_ror_epi64(a,63);M(r);}
{__auto_type r=_mm512_shldi_epi16(a,b,0);M(r);r=_mm512_shrdi_epi16(a,b,0);M(r);}
{__auto_type r=_mm512_shldi_epi16(a,b,1);M(r);r=_mm512_shrdi_epi16(a,b,1);M(r);}
{__auto_type r=_mm512_shldi_epi16(a,b,5);M(r);r=_mm512_shrdi_epi16(a,b,5);M(r);}
{__auto_type r=_mm512_shldi_epi16(a,b,15);M(r);r=_mm512_shrdi_epi16(a,b,15);M(r);}
{__auto_type r=_mm512_shldi_epi16(a,b,16);M(r);r=_mm512_shrdi_epi16(a,b,16);M(r);}
{__auto_type r=_mm512_shldi_epi16(a,b,17);M(r);r=_mm512_shrdi_epi16(a,b,17);M(r);}
{__auto_type r=_mm512_shldi_epi16(a,b,31);M(r);r=_mm512_shrdi_epi16(a,b,31);M(r);}
{__auto_type r=_mm512_shldi_epi16(a,b,32);M(r);r=_mm512_shrdi_epi16(a,b,32);M(r);}
{__auto_type r=_mm512_shldi_epi16(a,b,63);M(r);r=_mm512_shrdi_epi16(a,b,63);M(r);}
{__auto_type r=_mm512_shldi_epi16(a,b,127);M(r);r=_mm512_shrdi_epi16(a,b,127);M(r);}
{__auto_type r=_mm512_shldi_epi32(a,b,0);M(r);r=_mm512_shrdi_epi32(a,b,0);M(r);}
{__auto_type r=_mm512_shldi_epi32(a,b,1);M(r);r=_mm512_shrdi_epi32(a,b,1);M(r);}
{__auto_type r=_mm512_shldi_epi32(a,b,5);M(r);r=_mm512_shrdi_epi32(a,b,5);M(r);}
{__auto_type r=_mm512_shldi_epi32(a,b,15);M(r);r=_mm512_shrdi_epi32(a,b,15);M(r);}
{__auto_type r=_mm512_shldi_epi32(a,b,16);M(r);r=_mm512_shrdi_epi32(a,b,16);M(r);}
{__auto_type r=_mm512_shldi_epi32(a,b,17);M(r);r=_mm512_shrdi_epi32(a,b,17);M(r);}
{__auto_type r=_mm512_shldi_epi32(a,b,31);M(r);r=_mm512_shrdi_epi32(a,b,31);M(r);}
{__auto_type r=_mm512_shldi_epi32(a,b,32);M(r);r=_mm512_shrdi_epi32(a,b,32);M(r);}
{__auto_type r=_mm512_shldi_epi32(a,b,63);M(r);r=_mm512_shrdi_epi32(a,b,63);M(r);}
{__auto_type r=_mm512_shldi_epi32(a,b,127);M(r);r=_mm512_shrdi_epi32(a,b,127);M(r);}
{__auto_type r=_mm512_shldi_epi64(a,b,0);M(r);r=_mm512_shrdi_epi64(a,b,0);M(r);}
{__auto_type r=_mm512_shldi_epi64(a,b,1);M(r);r=_mm512_shrdi_epi64(a,b,1);M(r);}
{__auto_type r=_mm512_shldi_epi64(a,b,5);M(r);r=_mm512_shrdi_epi64(a,b,5);M(r);}
{__auto_type r=_mm512_shldi_epi64(a,b,15);M(r);r=_mm512_shrdi_epi64(a,b,15);M(r);}
{__auto_type r=_mm512_shldi_epi64(a,b,16);M(r);r=_mm512_shrdi_epi64(a,b,16);M(r);}
{__auto_type r=_mm512_shldi_epi64(a,b,17);M(r);r=_mm512_shrdi_epi64(a,b,17);M(r);}
{__auto_type r=_mm512_shldi_epi64(a,b,31);M(r);r=_mm512_shrdi_epi64(a,b,31);M(r);}
{__auto_type r=_mm512_shldi_epi64(a,b,32);M(r);r=_mm512_shrdi_epi64(a,b,32);M(r);}
{__auto_type r=_mm512_shldi_epi64(a,b,63);M(r);r=_mm512_shrdi_epi64(a,b,63);M(r);}
{__auto_type r=_mm512_shldi_epi64(a,b,127);M(r);r=_mm512_shrdi_epi64(a,b,127);M(r);}
{__auto_type r=_mm512_alignr_epi32(a,b,0);M(r);}
{__auto_type r=_mm512_alignr_epi32(a,b,1);M(r);}
{__auto_type r=_mm512_alignr_epi32(a,b,2);M(r);}
{__auto_type r=_mm512_alignr_epi32(a,b,3);M(r);}
{__auto_type r=_mm512_alignr_epi32(a,b,4);M(r);}
{__auto_type r=_mm512_alignr_epi32(a,b,5);M(r);}
{__auto_type r=_mm512_alignr_epi32(a,b,7);M(r);}
{__auto_type r=_mm512_alignr_epi32(a,b,8);M(r);}
{__auto_type r=_mm512_alignr_epi32(a,b,9);M(r);}
{__auto_type r=_mm512_alignr_epi32(a,b,15);M(r);}
{__auto_type r=_mm512_alignr_epi32(a,b,16);M(r);}
{__auto_type r=_mm512_alignr_epi32(a,b,31);M(r);}
{__auto_type r=_mm512_alignr_epi64(a,b,0);M(r);}
{__auto_type r=_mm512_alignr_epi64(a,b,1);M(r);}
{__auto_type r=_mm512_alignr_epi64(a,b,2);M(r);}
{__auto_type r=_mm512_alignr_epi64(a,b,3);M(r);}
{__auto_type r=_mm512_alignr_epi64(a,b,4);M(r);}
{__auto_type r=_mm512_alignr_epi64(a,b,5);M(r);}
{__auto_type r=_mm512_alignr_epi64(a,b,7);M(r);}
{__auto_type r=_mm512_alignr_epi64(a,b,8);M(r);}
{__auto_type r=_mm512_alignr_epi64(a,b,9);M(r);}
{__auto_type r=_mm512_alignr_epi64(a,b,15);M(r);}
{__auto_type r=_mm512_alignr_epi64(a,b,16);M(r);}
{__auto_type r=_mm512_alignr_epi64(a,b,31);M(r);}
{__auto_type r=_mm256_rol_epi32(a2,0);M(r);r=_mm256_ror_epi32(a2,0);M(r);}
{__auto_type r=_mm256_rol_epi32(a2,1);M(r);r=_mm256_ror_epi32(a2,1);M(r);}
{__auto_type r=_mm256_rol_epi32(a2,7);M(r);r=_mm256_ror_epi32(a2,7);M(r);}
{__auto_type r=_mm256_rol_epi32(a2,31);M(r);r=_mm256_ror_epi32(a2,31);M(r);}
{__auto_type r=_mm256_rol_epi32(a2,33);M(r);r=_mm256_ror_epi32(a2,33);M(r);}
{__auto_type r=_mm256_rol_epi32(a2,63);M(r);r=_mm256_ror_epi32(a2,63);M(r);}
{__auto_type r=_mm256_rol_epi64(a2,0);M(r);r=_mm256_ror_epi64(a2,0);M(r);}
{__auto_type r=_mm256_rol_epi64(a2,1);M(r);r=_mm256_ror_epi64(a2,1);M(r);}
{__auto_type r=_mm256_rol_epi64(a2,7);M(r);r=_mm256_ror_epi64(a2,7);M(r);}
{__auto_type r=_mm256_rol_epi64(a2,31);M(r);r=_mm256_ror_epi64(a2,31);M(r);}
{__auto_type r=_mm256_rol_epi64(a2,33);M(r);r=_mm256_ror_epi64(a2,33);M(r);}
{__auto_type r=_mm256_rol_epi64(a2,63);M(r);r=_mm256_ror_epi64(a2,63);M(r);}
{__auto_type r=_mm256_shldi_epi16(a2,b2,0);M(r);r=_mm256_shrdi_epi16(a2,b2,0);M(r);}
{__auto_type r=_mm256_shldi_epi16(a2,b2,1);M(r);r=_mm256_shrdi_epi16(a2,b2,1);M(r);}
{__auto_type r=_mm256_shldi_epi16(a2,b2,5);M(r);r=_mm256_shrdi_epi16(a2,b2,5);M(r);}
{__auto_type r=_mm256_shldi_epi16(a2,b2,15);M(r);r=_mm256_shrdi_epi16(a2,b2,15);M(r);}
{__auto_type r=_mm256_shldi_epi16(a2,b2,16);M(r);r=_mm256_shrdi_epi16(a2,b2,16);M(r);}
{__auto_type r=_mm256_shldi_epi16(a2,b2,17);M(r);r=_mm256_shrdi_epi16(a2,b2,17);M(r);}
{__auto_type r=_mm256_shldi_epi16(a2,b2,31);M(r);r=_mm256_shrdi_epi16(a2,b2,31);M(r);}
{__auto_type r=_mm256_shldi_epi16(a2,b2,32);M(r);r=_mm256_shrdi_epi16(a2,b2,32);M(r);}
{__auto_type r=_mm256_shldi_epi16(a2,b2,63);M(r);r=_mm256_shrdi_epi16(a2,b2,63);M(r);}
{__auto_type r=_mm256_shldi_epi16(a2,b2,127);M(r);r=_mm256_shrdi_epi16(a2,b2,127);M(r);}
{__auto_type r=_mm256_shldi_epi32(a2,b2,0);M(r);r=_mm256_shrdi_epi32(a2,b2,0);M(r);}
{__auto_type r=_mm256_shldi_epi32(a2,b2,1);M(r);r=_mm256_shrdi_epi32(a2,b2,1);M(r);}
{__auto_type r=_mm256_shldi_epi32(a2,b2,5);M(r);r=_mm256_shrdi_epi32(a2,b2,5);M(r);}
{__auto_type r=_mm256_shldi_epi32(a2,b2,15);M(r);r=_mm256_shrdi_epi32(a2,b2,15);M(r);}
{__auto_type r=_mm256_shldi_epi32(a2,b2,16);M(r);r=_mm256_shrdi_epi32(a2,b2,16);M(r);}
{__auto_type r=_mm256_shldi_epi32(a2,b2,17);M(r);r=_mm256_shrdi_epi32(a2,b2,17);M(r);}
{__auto_type r=_mm256_shldi_epi32(a2,b2,31);M(r);r=_mm256_shrdi_epi32(a2,b2,31);M(r);}
{__auto_type r=_mm256_shldi_epi32(a2,b2,32);M(r);r=_mm256_shrdi_epi32(a2,b2,32);M(r);}
{__auto_type r=_mm256_shldi_epi32(a2,b2,63);M(r);r=_mm256_shrdi_epi32(a2,b2,63);M(r);}
{__auto_type r=_mm256_shldi_epi32(a2,b2,127);M(r);r=_mm256_shrdi_epi32(a2,b2,127);M(r);}
{__auto_type r=_mm256_shldi_epi64(a2,b2,0);M(r);r=_mm256_shrdi_epi64(a2,b2,0);M(r);}
{__auto_type r=_mm256_shldi_epi64(a2,b2,1);M(r);r=_mm256_shrdi_epi64(a2,b2,1);M(r);}
{__auto_type r=_mm256_shldi_epi64(a2,b2,5);M(r);r=_mm256_shrdi_epi64(a2,b2,5);M(r);}
{__auto_type r=_mm256_shldi_epi64(a2,b2,15);M(r);r=_mm256_shrdi_epi64(a2,b2,15);M(r);}
{__auto_type r=_mm256_shldi_epi64(a2,b2,16);M(r);r=_mm256_shrdi_epi64(a2,b2,16);M(r);}
{__auto_type r=_mm256_shldi_epi64(a2,b2,17);M(r);r=_mm256_shrdi_epi64(a2,b2,17);M(r);}
{__auto_type r=_mm256_shldi_epi64(a2,b2,31);M(r);r=_mm256_shrdi_epi64(a2,b2,31);M(r);}
{__auto_type r=_mm256_shldi_epi64(a2,b2,32);M(r);r=_mm256_shrdi_epi64(a2,b2,32);M(r);}
{__auto_type r=_mm256_shldi_epi64(a2,b2,63);M(r);r=_mm256_shrdi_epi64(a2,b2,63);M(r);}
{__auto_type r=_mm256_shldi_epi64(a2,b2,127);M(r);r=_mm256_shrdi_epi64(a2,b2,127);M(r);}
{__auto_type r=_mm256_alignr_epi32(a2,b2,0);M(r);}
{__auto_type r=_mm256_alignr_epi32(a2,b2,1);M(r);}
{__auto_type r=_mm256_alignr_epi32(a2,b2,2);M(r);}
{__auto_type r=_mm256_alignr_epi32(a2,b2,3);M(r);}
{__auto_type r=_mm256_alignr_epi32(a2,b2,4);M(r);}
{__auto_type r=_mm256_alignr_epi32(a2,b2,5);M(r);}
{__auto_type r=_mm256_alignr_epi32(a2,b2,7);M(r);}
{__auto_type r=_mm256_alignr_epi32(a2,b2,8);M(r);}
{__auto_type r=_mm256_alignr_epi32(a2,b2,9);M(r);}
{__auto_type r=_mm256_alignr_epi32(a2,b2,15);M(r);}
{__auto_type r=_mm256_alignr_epi32(a2,b2,16);M(r);}
{__auto_type r=_mm256_alignr_epi32(a2,b2,31);M(r);}
{__auto_type r=_mm256_alignr_epi64(a2,b2,0);M(r);}
{__auto_type r=_mm256_alignr_epi64(a2,b2,1);M(r);}
{__auto_type r=_mm256_alignr_epi64(a2,b2,2);M(r);}
{__auto_type r=_mm256_alignr_epi64(a2,b2,3);M(r);}
{__auto_type r=_mm256_alignr_epi64(a2,b2,4);M(r);}
{__auto_type r=_mm256_alignr_epi64(a2,b2,5);M(r);}
{__auto_type r=_mm256_alignr_epi64(a2,b2,7);M(r);}
{__auto_type r=_mm256_alignr_epi64(a2,b2,8);M(r);}
{__auto_type r=_mm256_alignr_epi64(a2,b2,9);M(r);}
{__auto_type r=_mm256_alignr_epi64(a2,b2,15);M(r);}
{__auto_type r=_mm256_alignr_epi64(a2,b2,16);M(r);}
{__auto_type r=_mm256_alignr_epi64(a2,b2,31);M(r);}
{__auto_type r=_mm_rol_epi32(a1,0);M(r);r=_mm_ror_epi32(a1,0);M(r);}
{__auto_type r=_mm_rol_epi32(a1,1);M(r);r=_mm_ror_epi32(a1,1);M(r);}
{__auto_type r=_mm_rol_epi32(a1,7);M(r);r=_mm_ror_epi32(a1,7);M(r);}
{__auto_type r=_mm_rol_epi32(a1,31);M(r);r=_mm_ror_epi32(a1,31);M(r);}
{__auto_type r=_mm_rol_epi32(a1,33);M(r);r=_mm_ror_epi32(a1,33);M(r);}
{__auto_type r=_mm_rol_epi32(a1,63);M(r);r=_mm_ror_epi32(a1,63);M(r);}
{__auto_type r=_mm_rol_epi64(a1,0);M(r);r=_mm_ror_epi64(a1,0);M(r);}
{__auto_type r=_mm_rol_epi64(a1,1);M(r);r=_mm_ror_epi64(a1,1);M(r);}
{__auto_type r=_mm_rol_epi64(a1,7);M(r);r=_mm_ror_epi64(a1,7);M(r);}
{__auto_type r=_mm_rol_epi64(a1,31);M(r);r=_mm_ror_epi64(a1,31);M(r);}
{__auto_type r=_mm_rol_epi64(a1,33);M(r);r=_mm_ror_epi64(a1,33);M(r);}
{__auto_type r=_mm_rol_epi64(a1,63);M(r);r=_mm_ror_epi64(a1,63);M(r);}
{__auto_type r=_mm_shldi_epi16(a1,b1,0);M(r);r=_mm_shrdi_epi16(a1,b1,0);M(r);}
{__auto_type r=_mm_shldi_epi16(a1,b1,1);M(r);r=_mm_shrdi_epi16(a1,b1,1);M(r);}
{__auto_type r=_mm_shldi_epi16(a1,b1,5);M(r);r=_mm_shrdi_epi16(a1,b1,5);M(r);}
{__auto_type r=_mm_shldi_epi16(a1,b1,15);M(r);r=_mm_shrdi_epi16(a1,b1,15);M(r);}
{__auto_type r=_mm_shldi_epi16(a1,b1,16);M(r);r=_mm_shrdi_epi16(a1,b1,16);M(r);}
{__auto_type r=_mm_shldi_epi16(a1,b1,17);M(r);r=_mm_shrdi_epi16(a1,b1,17);M(r);}
{__auto_type r=_mm_shldi_epi16(a1,b1,31);M(r);r=_mm_shrdi_epi16(a1,b1,31);M(r);}
{__auto_type r=_mm_shldi_epi16(a1,b1,32);M(r);r=_mm_shrdi_epi16(a1,b1,32);M(r);}
{__auto_type r=_mm_shldi_epi16(a1,b1,63);M(r);r=_mm_shrdi_epi16(a1,b1,63);M(r);}
{__auto_type r=_mm_shldi_epi16(a1,b1,127);M(r);r=_mm_shrdi_epi16(a1,b1,127);M(r);}
{__auto_type r=_mm_shldi_epi32(a1,b1,0);M(r);r=_mm_shrdi_epi32(a1,b1,0);M(r);}
{__auto_type r=_mm_shldi_epi32(a1,b1,1);M(r);r=_mm_shrdi_epi32(a1,b1,1);M(r);}
{__auto_type r=_mm_shldi_epi32(a1,b1,5);M(r);r=_mm_shrdi_epi32(a1,b1,5);M(r);}
{__auto_type r=_mm_shldi_epi32(a1,b1,15);M(r);r=_mm_shrdi_epi32(a1,b1,15);M(r);}
{__auto_type r=_mm_shldi_epi32(a1,b1,16);M(r);r=_mm_shrdi_epi32(a1,b1,16);M(r);}
{__auto_type r=_mm_shldi_epi32(a1,b1,17);M(r);r=_mm_shrdi_epi32(a1,b1,17);M(r);}
{__auto_type r=_mm_shldi_epi32(a1,b1,31);M(r);r=_mm_shrdi_epi32(a1,b1,31);M(r);}
{__auto_type r=_mm_shldi_epi32(a1,b1,32);M(r);r=_mm_shrdi_epi32(a1,b1,32);M(r);}
{__auto_type r=_mm_shldi_epi32(a1,b1,63);M(r);r=_mm_shrdi_epi32(a1,b1,63);M(r);}
{__auto_type r=_mm_shldi_epi32(a1,b1,127);M(r);r=_mm_shrdi_epi32(a1,b1,127);M(r);}
{__auto_type r=_mm_shldi_epi64(a1,b1,0);M(r);r=_mm_shrdi_epi64(a1,b1,0);M(r);}
{__auto_type r=_mm_shldi_epi64(a1,b1,1);M(r);r=_mm_shrdi_epi64(a1,b1,1);M(r);}
{__auto_type r=_mm_shldi_epi64(a1,b1,5);M(r);r=_mm_shrdi_epi64(a1,b1,5);M(r);}
{__auto_type r=_mm_shldi_epi64(a1,b1,15);M(r);r=_mm_shrdi_epi64(a1,b1,15);M(r);}
{__auto_type r=_mm_shldi_epi64(a1,b1,16);M(r);r=_mm_shrdi_epi64(a1,b1,16);M(r);}
{__auto_type r=_mm_shldi_epi64(a1,b1,17);M(r);r=_mm_shrdi_epi64(a1,b1,17);M(r);}
{__auto_type r=_mm_shldi_epi64(a1,b1,31);M(r);r=_mm_shrdi_epi64(a1,b1,31);M(r);}
{__auto_type r=_mm_shldi_epi64(a1,b1,32);M(r);r=_mm_shrdi_epi64(a1,b1,32);M(r);}
{__auto_type r=_mm_shldi_epi64(a1,b1,63);M(r);r=_mm_shrdi_epi64(a1,b1,63);M(r);}
{__auto_type r=_mm_shldi_epi64(a1,b1,127);M(r);r=_mm_shrdi_epi64(a1,b1,127);M(r);}
{__auto_type r=_mm_alignr_epi32(a1,b1,0);M(r);}
{__auto_type r=_mm_alignr_epi32(a1,b1,1);M(r);}
{__auto_type r=_mm_alignr_epi32(a1,b1,2);M(r);}
{__auto_type r=_mm_alignr_epi32(a1,b1,3);M(r);}
{__auto_type r=_mm_alignr_epi32(a1,b1,4);M(r);}
{__auto_type r=_mm_alignr_epi32(a1,b1,5);M(r);}
{__auto_type r=_mm_alignr_epi32(a1,b1,7);M(r);}
{__auto_type r=_mm_alignr_epi32(a1,b1,8);M(r);}
{__auto_type r=_mm_alignr_epi32(a1,b1,9);M(r);}
{__auto_type r=_mm_alignr_epi32(a1,b1,15);M(r);}
{__auto_type r=_mm_alignr_epi32(a1,b1,16);M(r);}
{__auto_type r=_mm_alignr_epi32(a1,b1,31);M(r);}
{__auto_type r=_mm_alignr_epi64(a1,b1,0);M(r);}
{__auto_type r=_mm_alignr_epi64(a1,b1,1);M(r);}
{__auto_type r=_mm_alignr_epi64(a1,b1,2);M(r);}
{__auto_type r=_mm_alignr_epi64(a1,b1,3);M(r);}
{__auto_type r=_mm_alignr_epi64(a1,b1,4);M(r);}
{__auto_type r=_mm_alignr_epi64(a1,b1,5);M(r);}
{__auto_type r=_mm_alignr_epi64(a1,b1,7);M(r);}
{__auto_type r=_mm_alignr_epi64(a1,b1,8);M(r);}
{__auto_type r=_mm_alignr_epi64(a1,b1,9);M(r);}
{__auto_type r=_mm_alignr_epi64(a1,b1,15);M(r);}
{__auto_type r=_mm_alignr_epi64(a1,b1,16);M(r);}
{__auto_type r=_mm_alignr_epi64(a1,b1,31);M(r);}
#ifdef V3
{__auto_type r=_mm256_ternarylogic_epi32(a2,b2,c2,0);M(r);r=_mm256_mask_ternarylogic_epi32(a2,(__mmask8)k,b2,c2,0);M(r);r=_mm256_maskz_ternarylogic_epi32((__mmask8)(k>>8),a2,b2,c2,0);M(r);}
#endif
#ifdef V3
{__auto_type r=_mm256_ternarylogic_epi32(a2,b2,c2,1);M(r);r=_mm256_mask_ternarylogic_epi32(a2,(__mmask8)k,b2,c2,1);M(r);r=_mm256_maskz_ternarylogic_epi32((__mmask8)(k>>8),a2,b2,c2,1);M(r);}
#endif
#ifdef V3
{__auto_type r=_mm256_ternarylogic_epi32(a2,b2,c2,150);M(r);r=_mm256_mask_ternarylogic_epi32(a2,(__mmask8)k,b2,c2,150);M(r);r=_mm256_maskz_ternarylogic_epi32((__mmask8)(k>>8),a2,b2,c2,150);M(r);}
#endif
#ifdef V3
{__auto_type r=_mm256_ternarylogic_epi32(a2,b2,c2,202);M(r);r=_mm256_mask_ternarylogic_epi32(a2,(__mmask8)k,b2,c2,202);M(r);r=_mm256_maskz_ternarylogic_epi32((__mmask8)(k>>8),a2,b2,c2,202);M(r);}
#endif
#ifdef V3
{__auto_type r=_mm256_ternarylogic_epi32(a2,b2,c2,232);M(r);r=_mm256_mask_ternarylogic_epi32(a2,(__mmask8)k,b2,c2,232);M(r);r=_mm256_maskz_ternarylogic_epi32((__mmask8)(k>>8),a2,b2,c2,232);M(r);}
#endif
#ifdef V3
{__auto_type r=_mm256_ternarylogic_epi32(a2,b2,c2,255);M(r);r=_mm256_mask_ternarylogic_epi32(a2,(__mmask8)k,b2,c2,255);M(r);r=_mm256_maskz_ternarylogic_epi32((__mmask8)(k>>8),a2,b2,c2,255);M(r);}
#endif
#ifdef V3
{__auto_type r=_mm256_ternarylogic_epi32(a2,b2,c2,60);M(r);r=_mm256_mask_ternarylogic_epi32(a2,(__mmask8)k,b2,c2,60);M(r);r=_mm256_maskz_ternarylogic_epi32((__mmask8)(k>>8),a2,b2,c2,60);M(r);}
#endif
#ifdef V3
{__auto_type r=_mm256_ternarylogic_epi32(a2,b2,c2,128);M(r);r=_mm256_mask_ternarylogic_epi32(a2,(__mmask8)k,b2,c2,128);M(r);r=_mm256_maskz_ternarylogic_epi32((__mmask8)(k>>8),a2,b2,c2,128);M(r);}
#endif
#ifdef V3
{__auto_type r=_mm256_ternarylogic_epi32(a2,b2,c2,127);M(r);r=_mm256_mask_ternarylogic_epi32(a2,(__mmask8)k,b2,c2,127);M(r);r=_mm256_maskz_ternarylogic_epi32((__mmask8)(k>>8),a2,b2,c2,127);M(r);}
#endif
#ifdef V3
{__auto_type r=_mm256_ternarylogic_epi32(a2,b2,c2,15);M(r);r=_mm256_mask_ternarylogic_epi32(a2,(__mmask8)k,b2,c2,15);M(r);r=_mm256_maskz_ternarylogic_epi32((__mmask8)(k>>8),a2,b2,c2,15);M(r);}
#endif
#ifdef V3
{__auto_type r=_mm256_ternarylogic_epi32(a2,b2,c2,240);M(r);r=_mm256_mask_ternarylogic_epi32(a2,(__mmask8)k,b2,c2,240);M(r);r=_mm256_maskz_ternarylogic_epi32((__mmask8)(k>>8),a2,b2,c2,240);M(r);}
#endif
#ifdef V3
{__auto_type r=_mm256_ternarylogic_epi32(a2,b2,c2,85);M(r);r=_mm256_mask_ternarylogic_epi32(a2,(__mmask8)k,b2,c2,85);M(r);r=_mm256_maskz_ternarylogic_epi32((__mmask8)(k>>8),a2,b2,c2,85);M(r);}
#endif
#ifdef V3
{__auto_type r=_mm256_ternarylogic_epi64(a2,b2,c2,0);M(r);r=_mm256_mask_ternarylogic_epi64(a2,(__mmask8)k,b2,c2,0);M(r);r=_mm256_maskz_ternarylogic_epi64((__mmask8)(k>>8),a2,b2,c2,0);M(r);}
#endif
#ifdef V3
{__auto_type r=_mm256_ternarylogic_epi64(a2,b2,c2,1);M(r);r=_mm256_mask_ternarylogic_epi64(a2,(__mmask8)k,b2,c2,1);M(r);r=_mm256_maskz_ternarylogic_epi64((__mmask8)(k>>8),a2,b2,c2,1);M(r);}
#endif
#ifdef V3
{__auto_type r=_mm256_ternarylogic_epi64(a2,b2,c2,150);M(r);r=_mm256_mask_ternarylogic_epi64(a2,(__mmask8)k,b2,c2,150);M(r);r=_mm256_maskz_ternarylogic_epi64((__mmask8)(k>>8),a2,b2,c2,150);M(r);}
#endif
#ifdef V3
{__auto_type r=_mm256_ternarylogic_epi64(a2,b2,c2,202);M(r);r=_mm256_mask_ternarylogic_epi64(a2,(__mmask8)k,b2,c2,202);M(r);r=_mm256_maskz_ternarylogic_epi64((__mmask8)(k>>8),a2,b2,c2,202);M(r);}
#endif
#ifdef V3
{__auto_type r=_mm256_ternarylogic_epi64(a2,b2,c2,232);M(r);r=_mm256_mask_ternarylogic_epi64(a2,(__mmask8)k,b2,c2,232);M(r);r=_mm256_maskz_ternarylogic_epi64((__mmask8)(k>>8),a2,b2,c2,232);M(r);}
#endif
#ifdef V3
{__auto_type r=_mm256_ternarylogic_epi64(a2,b2,c2,255);M(r);r=_mm256_mask_ternarylogic_epi64(a2,(__mmask8)k,b2,c2,255);M(r);r=_mm256_maskz_ternarylogic_epi64((__mmask8)(k>>8),a2,b2,c2,255);M(r);}
#endif
#ifdef V3
{__auto_type r=_mm256_ternarylogic_epi64(a2,b2,c2,60);M(r);r=_mm256_mask_ternarylogic_epi64(a2,(__mmask8)k,b2,c2,60);M(r);r=_mm256_maskz_ternarylogic_epi64((__mmask8)(k>>8),a2,b2,c2,60);M(r);}
#endif
#ifdef V3
{__auto_type r=_mm256_ternarylogic_epi64(a2,b2,c2,128);M(r);r=_mm256_mask_ternarylogic_epi64(a2,(__mmask8)k,b2,c2,128);M(r);r=_mm256_maskz_ternarylogic_epi64((__mmask8)(k>>8),a2,b2,c2,128);M(r);}
#endif
#ifdef V3
{__auto_type r=_mm256_ternarylogic_epi64(a2,b2,c2,127);M(r);r=_mm256_mask_ternarylogic_epi64(a2,(__mmask8)k,b2,c2,127);M(r);r=_mm256_maskz_ternarylogic_epi64((__mmask8)(k>>8),a2,b2,c2,127);M(r);}
#endif
#ifdef V3
{__auto_type r=_mm256_ternarylogic_epi64(a2,b2,c2,15);M(r);r=_mm256_mask_ternarylogic_epi64(a2,(__mmask8)k,b2,c2,15);M(r);r=_mm256_maskz_ternarylogic_epi64((__mmask8)(k>>8),a2,b2,c2,15);M(r);}
#endif
#ifdef V3
{__auto_type r=_mm256_ternarylogic_epi64(a2,b2,c2,240);M(r);r=_mm256_mask_ternarylogic_epi64(a2,(__mmask8)k,b2,c2,240);M(r);r=_mm256_maskz_ternarylogic_epi64((__mmask8)(k>>8),a2,b2,c2,240);M(r);}
#endif
#ifdef V3
{__auto_type r=_mm256_ternarylogic_epi64(a2,b2,c2,85);M(r);r=_mm256_mask_ternarylogic_epi64(a2,(__mmask8)k,b2,c2,85);M(r);r=_mm256_maskz_ternarylogic_epi64((__mmask8)(k>>8),a2,b2,c2,85);M(r);}
#endif
{__auto_type r=_mm_ternarylogic_epi32(a1,b1,c1,0);M(r);r=_mm_mask_ternarylogic_epi32(a1,(__mmask8)k,b1,c1,0);M(r);r=_mm_maskz_ternarylogic_epi32((__mmask8)(k>>8),a1,b1,c1,0);M(r);}
{__auto_type r=_mm_ternarylogic_epi32(a1,b1,c1,1);M(r);r=_mm_mask_ternarylogic_epi32(a1,(__mmask8)k,b1,c1,1);M(r);r=_mm_maskz_ternarylogic_epi32((__mmask8)(k>>8),a1,b1,c1,1);M(r);}
{__auto_type r=_mm_ternarylogic_epi32(a1,b1,c1,150);M(r);r=_mm_mask_ternarylogic_epi32(a1,(__mmask8)k,b1,c1,150);M(r);r=_mm_maskz_ternarylogic_epi32((__mmask8)(k>>8),a1,b1,c1,150);M(r);}
{__auto_type r=_mm_ternarylogic_epi32(a1,b1,c1,202);M(r);r=_mm_mask_ternarylogic_epi32(a1,(__mmask8)k,b1,c1,202);M(r);r=_mm_maskz_ternarylogic_epi32((__mmask8)(k>>8),a1,b1,c1,202);M(r);}
{__auto_type r=_mm_ternarylogic_epi32(a1,b1,c1,232);M(r);r=_mm_mask_ternarylogic_epi32(a1,(__mmask8)k,b1,c1,232);M(r);r=_mm_maskz_ternarylogic_epi32((__mmask8)(k>>8),a1,b1,c1,232);M(r);}
{__auto_type r=_mm_ternarylogic_epi32(a1,b1,c1,255);M(r);r=_mm_mask_ternarylogic_epi32(a1,(__mmask8)k,b1,c1,255);M(r);r=_mm_maskz_ternarylogic_epi32((__mmask8)(k>>8),a1,b1,c1,255);M(r);}
{__auto_type r=_mm_ternarylogic_epi32(a1,b1,c1,60);M(r);r=_mm_mask_ternarylogic_epi32(a1,(__mmask8)k,b1,c1,60);M(r);r=_mm_maskz_ternarylogic_epi32((__mmask8)(k>>8),a1,b1,c1,60);M(r);}
{__auto_type r=_mm_ternarylogic_epi32(a1,b1,c1,128);M(r);r=_mm_mask_ternarylogic_epi32(a1,(__mmask8)k,b1,c1,128);M(r);r=_mm_maskz_ternarylogic_epi32((__mmask8)(k>>8),a1,b1,c1,128);M(r);}
{__auto_type r=_mm_ternarylogic_epi32(a1,b1,c1,127);M(r);r=_mm_mask_ternarylogic_epi32(a1,(__mmask8)k,b1,c1,127);M(r);r=_mm_maskz_ternarylogic_epi32((__mmask8)(k>>8),a1,b1,c1,127);M(r);}
{__auto_type r=_mm_ternarylogic_epi32(a1,b1,c1,15);M(r);r=_mm_mask_ternarylogic_epi32(a1,(__mmask8)k,b1,c1,15);M(r);r=_mm_maskz_ternarylogic_epi32((__mmask8)(k>>8),a1,b1,c1,15);M(r);}
{__auto_type r=_mm_ternarylogic_epi32(a1,b1,c1,240);M(r);r=_mm_mask_ternarylogic_epi32(a1,(__mmask8)k,b1,c1,240);M(r);r=_mm_maskz_ternarylogic_epi32((__mmask8)(k>>8),a1,b1,c1,240);M(r);}
{__auto_type r=_mm_ternarylogic_epi32(a1,b1,c1,85);M(r);r=_mm_mask_ternarylogic_epi32(a1,(__mmask8)k,b1,c1,85);M(r);r=_mm_maskz_ternarylogic_epi32((__mmask8)(k>>8),a1,b1,c1,85);M(r);}
{__auto_type r=_mm_ternarylogic_epi64(a1,b1,c1,0);M(r);r=_mm_mask_ternarylogic_epi64(a1,(__mmask8)k,b1,c1,0);M(r);r=_mm_maskz_ternarylogic_epi64((__mmask8)(k>>8),a1,b1,c1,0);M(r);}
{__auto_type r=_mm_ternarylogic_epi64(a1,b1,c1,1);M(r);r=_mm_mask_ternarylogic_epi64(a1,(__mmask8)k,b1,c1,1);M(r);r=_mm_maskz_ternarylogic_epi64((__mmask8)(k>>8),a1,b1,c1,1);M(r);}
{__auto_type r=_mm_ternarylogic_epi64(a1,b1,c1,150);M(r);r=_mm_mask_ternarylogic_epi64(a1,(__mmask8)k,b1,c1,150);M(r);r=_mm_maskz_ternarylogic_epi64((__mmask8)(k>>8),a1,b1,c1,150);M(r);}
{__auto_type r=_mm_ternarylogic_epi64(a1,b1,c1,202);M(r);r=_mm_mask_ternarylogic_epi64(a1,(__mmask8)k,b1,c1,202);M(r);r=_mm_maskz_ternarylogic_epi64((__mmask8)(k>>8),a1,b1,c1,202);M(r);}
{__auto_type r=_mm_ternarylogic_epi64(a1,b1,c1,232);M(r);r=_mm_mask_ternarylogic_epi64(a1,(__mmask8)k,b1,c1,232);M(r);r=_mm_maskz_ternarylogic_epi64((__mmask8)(k>>8),a1,b1,c1,232);M(r);}
{__auto_type r=_mm_ternarylogic_epi64(a1,b1,c1,255);M(r);r=_mm_mask_ternarylogic_epi64(a1,(__mmask8)k,b1,c1,255);M(r);r=_mm_maskz_ternarylogic_epi64((__mmask8)(k>>8),a1,b1,c1,255);M(r);}
{__auto_type r=_mm_ternarylogic_epi64(a1,b1,c1,60);M(r);r=_mm_mask_ternarylogic_epi64(a1,(__mmask8)k,b1,c1,60);M(r);r=_mm_maskz_ternarylogic_epi64((__mmask8)(k>>8),a1,b1,c1,60);M(r);}
{__auto_type r=_mm_ternarylogic_epi64(a1,b1,c1,128);M(r);r=_mm_mask_ternarylogic_epi64(a1,(__mmask8)k,b1,c1,128);M(r);r=_mm_maskz_ternarylogic_epi64((__mmask8)(k>>8),a1,b1,c1,128);M(r);}
{__auto_type r=_mm_ternarylogic_epi64(a1,b1,c1,127);M(r);r=_mm_mask_ternarylogic_epi64(a1,(__mmask8)k,b1,c1,127);M(r);r=_mm_maskz_ternarylogic_epi64((__mmask8)(k>>8),a1,b1,c1,127);M(r);}
{__auto_type r=_mm_ternarylogic_epi64(a1,b1,c1,15);M(r);r=_mm_mask_ternarylogic_epi64(a1,(__mmask8)k,b1,c1,15);M(r);r=_mm_maskz_ternarylogic_epi64((__mmask8)(k>>8),a1,b1,c1,15);M(r);}
{__auto_type r=_mm_ternarylogic_epi64(a1,b1,c1,240);M(r);r=_mm_mask_ternarylogic_epi64(a1,(__mmask8)k,b1,c1,240);M(r);r=_mm_maskz_ternarylogic_epi64((__mmask8)(k>>8),a1,b1,c1,240);M(r);}
{__auto_type r=_mm_ternarylogic_epi64(a1,b1,c1,85);M(r);r=_mm_mask_ternarylogic_epi64(a1,(__mmask8)k,b1,c1,85);M(r);r=_mm_maskz_ternarylogic_epi64((__mmask8)(k>>8),a1,b1,c1,85);M(r);}
{__auto_type r=_mm512_alignr_epi8(a,b,0);M(r);r=_mm512_bslli_epi128(a,0);M(r);r=_mm512_bsrli_epi128(a,0);M(r);}
{__auto_type r=_mm512_alignr_epi8(a,b,1);M(r);r=_mm512_bslli_epi128(a,1);M(r);r=_mm512_bsrli_epi128(a,1);M(r);}
{__auto_type r=_mm512_alignr_epi8(a,b,5);M(r);r=_mm512_bslli_epi128(a,5);M(r);r=_mm512_bsrli_epi128(a,5);M(r);}
{__auto_type r=_mm512_alignr_epi8(a,b,15);M(r);r=_mm512_bslli_epi128(a,15);M(r);r=_mm512_bsrli_epi128(a,15);M(r);}
{__auto_type r=_mm512_alignr_epi8(a,b,16);M(r);r=_mm512_bslli_epi128(a,16);M(r);r=_mm512_bsrli_epi128(a,16);M(r);}
{__auto_type r=_mm512_alignr_epi8(a,b,17);M(r);r=_mm512_bslli_epi128(a,17);M(r);r=_mm512_bsrli_epi128(a,17);M(r);}
{__auto_type r=_mm512_alignr_epi8(a,b,31);M(r);r=_mm512_bslli_epi128(a,31);M(r);r=_mm512_bsrli_epi128(a,31);M(r);}
{__auto_type r=_mm512_alignr_epi8(a,b,32);M(r);r=_mm512_bslli_epi128(a,32);M(r);r=_mm512_bsrli_epi128(a,32);M(r);}
{__auto_type r=_mm512_alignr_epi8(a,b,40);M(r);r=_mm512_bslli_epi128(a,40);M(r);r=_mm512_bsrli_epi128(a,40);M(r);}
{__auto_type r=_mm512_alignr_epi8(a,b,255);M(r);r=_mm512_bslli_epi128(a,255);M(r);r=_mm512_bsrli_epi128(a,255);M(r);}
{__auto_type r=_mm512_shuffle_i32x4(a,b,0);M(r);__auto_type s=_mm512_shuffle_f64x2(d,e,0);M(s);__auto_type t=_mm512_shuffle_f32x4(f,g,0);M(t);r=_mm512_shuffle_i64x2(a,b,0);M(r);}
{__auto_type r=_mm256_shuffle_i32x4(a2,b2,0&3);M(r);r=_mm256_shuffle_i64x2(a2,b2,0);M(r);__auto_type s=_mm256_shuffle_f32x4(f2,g2,0);M(s);__auto_type t=_mm256_shuffle_f64x2(d2,e2,0);M(t);}
{__auto_type r=_mm512_shuffle_ps(f,g,0);M(r);__auto_type s=_mm512_shuffle_pd(d,e,0);M(s);r=_mm512_permute_ps(f,0);M(r);s=_mm512_permute_pd(d,0);M(s);}
{__auto_type r=_mm512_shuffle_epi32(a,0);M(r);r=_mm512_shufflehi_epi16(a,0);M(r);r=_mm512_shufflelo_epi16(a,0);M(r);r=_mm512_permutex_epi64(a,0);M(r);__auto_type s=_mm512_permutex_pd(d,0);M(s);}
{__auto_type r=_mm512_shuffle_i32x4(a,b,1);M(r);__auto_type s=_mm512_shuffle_f64x2(d,e,1);M(s);__auto_type t=_mm512_shuffle_f32x4(f,g,1);M(t);r=_mm512_shuffle_i64x2(a,b,1);M(r);}
{__auto_type r=_mm256_shuffle_i32x4(a2,b2,1&3);M(r);r=_mm256_shuffle_i64x2(a2,b2,1);M(r);__auto_type s=_mm256_shuffle_f32x4(f2,g2,1);M(s);__auto_type t=_mm256_shuffle_f64x2(d2,e2,1);M(t);}
{__auto_type r=_mm512_shuffle_ps(f,g,1);M(r);__auto_type s=_mm512_shuffle_pd(d,e,1);M(s);r=_mm512_permute_ps(f,1);M(r);s=_mm512_permute_pd(d,1);M(s);}
{__auto_type r=_mm512_shuffle_epi32(a,1);M(r);r=_mm512_shufflehi_epi16(a,1);M(r);r=_mm512_shufflelo_epi16(a,1);M(r);r=_mm512_permutex_epi64(a,1);M(r);__auto_type s=_mm512_permutex_pd(d,1);M(s);}
{__auto_type r=_mm512_shuffle_i32x4(a,b,27);M(r);__auto_type s=_mm512_shuffle_f64x2(d,e,27);M(s);__auto_type t=_mm512_shuffle_f32x4(f,g,27);M(t);r=_mm512_shuffle_i64x2(a,b,27);M(r);}
{__auto_type r=_mm256_shuffle_i32x4(a2,b2,27&3);M(r);r=_mm256_shuffle_i64x2(a2,b2,27);M(r);__auto_type s=_mm256_shuffle_f32x4(f2,g2,27);M(s);__auto_type t=_mm256_shuffle_f64x2(d2,e2,27);M(t);}
{__auto_type r=_mm512_shuffle_ps(f,g,27);M(r);__auto_type s=_mm512_shuffle_pd(d,e,27);M(s);r=_mm512_permute_ps(f,27);M(r);s=_mm512_permute_pd(d,27);M(s);}
{__auto_type r=_mm512_shuffle_epi32(a,27);M(r);r=_mm512_shufflehi_epi16(a,27);M(r);r=_mm512_shufflelo_epi16(a,27);M(r);r=_mm512_permutex_epi64(a,27);M(r);__auto_type s=_mm512_permutex_pd(d,27);M(s);}
{__auto_type r=_mm512_shuffle_i32x4(a,b,78);M(r);__auto_type s=_mm512_shuffle_f64x2(d,e,78);M(s);__auto_type t=_mm512_shuffle_f32x4(f,g,78);M(t);r=_mm512_shuffle_i64x2(a,b,78);M(r);}
{__auto_type r=_mm256_shuffle_i32x4(a2,b2,78&3);M(r);r=_mm256_shuffle_i64x2(a2,b2,78);M(r);__auto_type s=_mm256_shuffle_f32x4(f2,g2,78);M(s);__auto_type t=_mm256_shuffle_f64x2(d2,e2,78);M(t);}
{__auto_type r=_mm512_shuffle_ps(f,g,78);M(r);__auto_type s=_mm512_shuffle_pd(d,e,78);M(s);r=_mm512_permute_ps(f,78);M(r);s=_mm512_permute_pd(d,78);M(s);}
{__auto_type r=_mm512_shuffle_epi32(a,78);M(r);r=_mm512_shufflehi_epi16(a,78);M(r);r=_mm512_shufflelo_epi16(a,78);M(r);r=_mm512_permutex_epi64(a,78);M(r);__auto_type s=_mm512_permutex_pd(d,78);M(s);}
{__auto_type r=_mm512_shuffle_i32x4(a,b,147);M(r);__auto_type s=_mm512_shuffle_f64x2(d,e,147);M(s);__auto_type t=_mm512_shuffle_f32x4(f,g,147);M(t);r=_mm512_shuffle_i64x2(a,b,147);M(r);}
{__auto_type r=_mm256_shuffle_i32x4(a2,b2,147&3);M(r);r=_mm256_shuffle_i64x2(a2,b2,147);M(r);__auto_type s=_mm256_shuffle_f32x4(f2,g2,147);M(s);__auto_type t=_mm256_shuffle_f64x2(d2,e2,147);M(t);}
{__auto_type r=_mm512_shuffle_ps(f,g,147);M(r);__auto_type s=_mm512_shuffle_pd(d,e,147);M(s);r=_mm512_permute_ps(f,147);M(r);s=_mm512_permute_pd(d,147);M(s);}
{__auto_type r=_mm512_shuffle_epi32(a,147);M(r);r=_mm512_shufflehi_epi16(a,147);M(r);r=_mm512_shufflelo_epi16(a,147);M(r);r=_mm512_permutex_epi64(a,147);M(r);__auto_type s=_mm512_permutex_pd(d,147);M(s);}
{__auto_type r=_mm512_shuffle_i32x4(a,b,228);M(r);__auto_type s=_mm512_shuffle_f64x2(d,e,228);M(s);__auto_type t=_mm512_shuffle_f32x4(f,g,228);M(t);r=_mm512_shuffle_i64x2(a,b,228);M(r);}
{__auto_type r=_mm256_shuffle_i32x4(a2,b2,228&3);M(r);r=_mm256_shuffle_i64x2(a2,b2,228);M(r);__auto_type s=_mm256_shuffle_f32x4(f2,g2,228);M(s);__auto_type t=_mm256_shuffle_f64x2(d2,e2,228);M(t);}
{__auto_type r=_mm512_shuffle_ps(f,g,228);M(r);__auto_type s=_mm512_shuffle_pd(d,e,228);M(s);r=_mm512_permute_ps(f,228);M(r);s=_mm512_permute_pd(d,228);M(s);}
{__auto_type r=_mm512_shuffle_epi32(a,228);M(r);r=_mm512_shufflehi_epi16(a,228);M(r);r=_mm512_shufflelo_epi16(a,228);M(r);r=_mm512_permutex_epi64(a,228);M(r);__auto_type s=_mm512_permutex_pd(d,228);M(s);}
{__auto_type r=_mm512_shuffle_i32x4(a,b,255);M(r);__auto_type s=_mm512_shuffle_f64x2(d,e,255);M(s);__auto_type t=_mm512_shuffle_f32x4(f,g,255);M(t);r=_mm512_shuffle_i64x2(a,b,255);M(r);}
{__auto_type r=_mm256_shuffle_i32x4(a2,b2,255&3);M(r);r=_mm256_shuffle_i64x2(a2,b2,255);M(r);__auto_type s=_mm256_shuffle_f32x4(f2,g2,255);M(s);__auto_type t=_mm256_shuffle_f64x2(d2,e2,255);M(t);}
{__auto_type r=_mm512_shuffle_ps(f,g,255);M(r);__auto_type s=_mm512_shuffle_pd(d,e,255);M(s);r=_mm512_permute_ps(f,255);M(r);s=_mm512_permute_pd(d,255);M(s);}
{__auto_type r=_mm512_shuffle_epi32(a,255);M(r);r=_mm512_shufflehi_epi16(a,255);M(r);r=_mm512_shufflelo_epi16(a,255);M(r);r=_mm512_permutex_epi64(a,255);M(r);__auto_type s=_mm512_permutex_pd(d,255);M(s);}
{__auto_type r=_mm512_shuffle_i32x4(a,b,90);M(r);__auto_type s=_mm512_shuffle_f64x2(d,e,90);M(s);__auto_type t=_mm512_shuffle_f32x4(f,g,90);M(t);r=_mm512_shuffle_i64x2(a,b,90);M(r);}
{__auto_type r=_mm256_shuffle_i32x4(a2,b2,90&3);M(r);r=_mm256_shuffle_i64x2(a2,b2,90);M(r);__auto_type s=_mm256_shuffle_f32x4(f2,g2,90);M(s);__auto_type t=_mm256_shuffle_f64x2(d2,e2,90);M(t);}
{__auto_type r=_mm512_shuffle_ps(f,g,90);M(r);__auto_type s=_mm512_shuffle_pd(d,e,90);M(s);r=_mm512_permute_ps(f,90);M(r);s=_mm512_permute_pd(d,90);M(s);}
{__auto_type r=_mm512_shuffle_epi32(a,90);M(r);r=_mm512_shufflehi_epi16(a,90);M(r);r=_mm512_shufflelo_epi16(a,90);M(r);r=_mm512_permutex_epi64(a,90);M(r);__auto_type s=_mm512_permutex_pd(d,90);M(s);}
{__auto_type r=_mm512_shuffle_i32x4(a,b,165);M(r);__auto_type s=_mm512_shuffle_f64x2(d,e,165);M(s);__auto_type t=_mm512_shuffle_f32x4(f,g,165);M(t);r=_mm512_shuffle_i64x2(a,b,165);M(r);}
{__auto_type r=_mm256_shuffle_i32x4(a2,b2,165&3);M(r);r=_mm256_shuffle_i64x2(a2,b2,165);M(r);__auto_type s=_mm256_shuffle_f32x4(f2,g2,165);M(s);__auto_type t=_mm256_shuffle_f64x2(d2,e2,165);M(t);}
{__auto_type r=_mm512_shuffle_ps(f,g,165);M(r);__auto_type s=_mm512_shuffle_pd(d,e,165);M(s);r=_mm512_permute_ps(f,165);M(r);s=_mm512_permute_pd(d,165);M(s);}
{__auto_type r=_mm512_shuffle_epi32(a,165);M(r);r=_mm512_shufflehi_epi16(a,165);M(r);r=_mm512_shufflelo_epi16(a,165);M(r);r=_mm512_permutex_epi64(a,165);M(r);__auto_type s=_mm512_permutex_pd(d,165);M(s);}
{__auto_type r=_mm512_shuffle_i32x4(a,b,54);M(r);__auto_type s=_mm512_shuffle_f64x2(d,e,54);M(s);__auto_type t=_mm512_shuffle_f32x4(f,g,54);M(t);r=_mm512_shuffle_i64x2(a,b,54);M(r);}
{__auto_type r=_mm256_shuffle_i32x4(a2,b2,54&3);M(r);r=_mm256_shuffle_i64x2(a2,b2,54);M(r);__auto_type s=_mm256_shuffle_f32x4(f2,g2,54);M(s);__auto_type t=_mm256_shuffle_f64x2(d2,e2,54);M(t);}
{__auto_type r=_mm512_shuffle_ps(f,g,54);M(r);__auto_type s=_mm512_shuffle_pd(d,e,54);M(s);r=_mm512_permute_ps(f,54);M(r);s=_mm512_permute_pd(d,54);M(s);}
{__auto_type r=_mm512_shuffle_epi32(a,54);M(r);r=_mm512_shufflehi_epi16(a,54);M(r);r=_mm512_shufflelo_epi16(a,54);M(r);r=_mm512_permutex_epi64(a,54);M(r);__auto_type s=_mm512_permutex_pd(d,54);M(s);}
{__auto_type r=_mm512_inserti32x4(a,a1,0);M(r);r=_mm512_inserti64x2(a,b1,0);M(r);r=_mm512_inserti32x8(a,a2,0);M(r);r=_mm512_inserti64x4(a,b2,0);M(r);}
{__auto_type r=_mm512_insertf32x4(f,f1,0);M(r);__auto_type s=_mm512_insertf64x2(d,d1,0);M(s);r=_mm512_insertf32x8(f,f2,0);M(r);s=_mm512_insertf64x4(d,d2,0);M(s);}
{__auto_type r=_mm256_inserti32x4(a2,a1,0);M(r);r=_mm256_inserti64x2(a2,b1,0);M(r);__auto_type s=_mm256_insertf32x4(f2,f1,0);M(s);__auto_type t=_mm256_insertf64x2(d2,d1,0);M(t);}
{__auto_type r=_mm512_mask_extracti32x4_epi32(b1,(__mmask8)k,a,0);M(r);r=_mm512_mask_extracti64x2_epi64(a1,(__mmask8)(k>>3),a,0);M(r);__auto_type q=_mm512_mask_extracti32x8_epi32(b2,(__mmask8)(k>>5),a,0);M(q);q=_mm512_mask_extracti64x4_epi64(a2,(__mmask8)(k>>7),a,0);M(q);}
{__auto_type r=_mm512_mask_extractf32x4_ps(f1,(__mmask8)k,f,0);M(r);__auto_type s=_mm512_mask_extractf64x2_pd(d1,(__mmask8)(k>>2),d,0);M(s);__auto_type q=_mm512_mask_extractf32x8_ps(f2,(__mmask8)(k>>4),f,0);M(q);__auto_type u=_mm512_mask_extractf64x4_pd(d2,(__mmask8)(k>>6),d,0);M(u);}
{__auto_type r=_mm256_mask_extracti32x4_epi32(b1,(__mmask8)k,a2,0);M(r);r=_mm256_mask_extracti64x2_epi64(a1,(__mmask8)(k>>9),a2,0);M(r);__auto_type s=_mm256_mask_extractf32x4_ps(f1,(__mmask8)(k>>1),f2,0);M(s);__auto_type t=_mm256_mask_extractf64x2_pd(d1,(__mmask8)(k>>11),d2,0);M(t);}
{__auto_type r=_mm512_inserti32x4(a,a1,1);M(r);r=_mm512_inserti64x2(a,b1,1);M(r);r=_mm512_inserti32x8(a,a2,1);M(r);r=_mm512_inserti64x4(a,b2,1);M(r);}
{__auto_type r=_mm512_insertf32x4(f,f1,1);M(r);__auto_type s=_mm512_insertf64x2(d,d1,1);M(s);r=_mm512_insertf32x8(f,f2,1);M(r);s=_mm512_insertf64x4(d,d2,1);M(s);}
{__auto_type r=_mm256_inserti32x4(a2,a1,1);M(r);r=_mm256_inserti64x2(a2,b1,1);M(r);__auto_type s=_mm256_insertf32x4(f2,f1,1);M(s);__auto_type t=_mm256_insertf64x2(d2,d1,1);M(t);}
{__auto_type r=_mm512_mask_extracti32x4_epi32(b1,(__mmask8)k,a,1);M(r);r=_mm512_mask_extracti64x2_epi64(a1,(__mmask8)(k>>3),a,1);M(r);__auto_type q=_mm512_mask_extracti32x8_epi32(b2,(__mmask8)(k>>5),a,1);M(q);q=_mm512_mask_extracti64x4_epi64(a2,(__mmask8)(k>>7),a,1);M(q);}
{__auto_type r=_mm512_mask_extractf32x4_ps(f1,(__mmask8)k,f,1);M(r);__auto_type s=_mm512_mask_extractf64x2_pd(d1,(__mmask8)(k>>2),d,1);M(s);__auto_type q=_mm512_mask_extractf32x8_ps(f2,(__mmask8)(k>>4),f,1);M(q);__auto_type u=_mm512_mask_extractf64x4_pd(d2,(__mmask8)(k>>6),d,1);M(u);}
{__auto_type r=_mm256_mask_extracti32x4_epi32(b1,(__mmask8)k,a2,1);M(r);r=_mm256_mask_extracti64x2_epi64(a1,(__mmask8)(k>>9),a2,1);M(r);__auto_type s=_mm256_mask_extractf32x4_ps(f1,(__mmask8)(k>>1),f2,1);M(s);__auto_type t=_mm256_mask_extractf64x2_pd(d1,(__mmask8)(k>>11),d2,1);M(t);}
{__auto_type r=_mm512_inserti32x4(a,a1,2);M(r);r=_mm512_inserti64x2(a,b1,2);M(r);r=_mm512_inserti32x8(a,a2,2);M(r);r=_mm512_inserti64x4(a,b2,2);M(r);}
{__auto_type r=_mm512_insertf32x4(f,f1,2);M(r);__auto_type s=_mm512_insertf64x2(d,d1,2);M(s);r=_mm512_insertf32x8(f,f2,2);M(r);s=_mm512_insertf64x4(d,d2,2);M(s);}
{__auto_type r=_mm256_inserti32x4(a2,a1,2);M(r);r=_mm256_inserti64x2(a2,b1,2);M(r);__auto_type s=_mm256_insertf32x4(f2,f1,2);M(s);__auto_type t=_mm256_insertf64x2(d2,d1,2);M(t);}
{__auto_type r=_mm512_mask_extracti32x4_epi32(b1,(__mmask8)k,a,2);M(r);r=_mm512_mask_extracti64x2_epi64(a1,(__mmask8)(k>>3),a,2);M(r);__auto_type q=_mm512_mask_extracti32x8_epi32(b2,(__mmask8)(k>>5),a,2);M(q);q=_mm512_mask_extracti64x4_epi64(a2,(__mmask8)(k>>7),a,2);M(q);}
{__auto_type r=_mm512_mask_extractf32x4_ps(f1,(__mmask8)k,f,2);M(r);__auto_type s=_mm512_mask_extractf64x2_pd(d1,(__mmask8)(k>>2),d,2);M(s);__auto_type q=_mm512_mask_extractf32x8_ps(f2,(__mmask8)(k>>4),f,2);M(q);__auto_type u=_mm512_mask_extractf64x4_pd(d2,(__mmask8)(k>>6),d,2);M(u);}
{__auto_type r=_mm256_mask_extracti32x4_epi32(b1,(__mmask8)k,a2,2);M(r);r=_mm256_mask_extracti64x2_epi64(a1,(__mmask8)(k>>9),a2,2);M(r);__auto_type s=_mm256_mask_extractf32x4_ps(f1,(__mmask8)(k>>1),f2,2);M(s);__auto_type t=_mm256_mask_extractf64x2_pd(d1,(__mmask8)(k>>11),d2,2);M(t);}
{__auto_type r=_mm512_inserti32x4(a,a1,3);M(r);r=_mm512_inserti64x2(a,b1,3);M(r);r=_mm512_inserti32x8(a,a2,3);M(r);r=_mm512_inserti64x4(a,b2,3);M(r);}
{__auto_type r=_mm512_insertf32x4(f,f1,3);M(r);__auto_type s=_mm512_insertf64x2(d,d1,3);M(s);r=_mm512_insertf32x8(f,f2,3);M(r);s=_mm512_insertf64x4(d,d2,3);M(s);}
{__auto_type r=_mm256_inserti32x4(a2,a1,3);M(r);r=_mm256_inserti64x2(a2,b1,3);M(r);__auto_type s=_mm256_insertf32x4(f2,f1,3);M(s);__auto_type t=_mm256_insertf64x2(d2,d1,3);M(t);}
{__auto_type r=_mm512_mask_extracti32x4_epi32(b1,(__mmask8)k,a,3);M(r);r=_mm512_mask_extracti64x2_epi64(a1,(__mmask8)(k>>3),a,3);M(r);__auto_type q=_mm512_mask_extracti32x8_epi32(b2,(__mmask8)(k>>5),a,3);M(q);q=_mm512_mask_extracti64x4_epi64(a2,(__mmask8)(k>>7),a,3);M(q);}
{__auto_type r=_mm512_mask_extractf32x4_ps(f1,(__mmask8)k,f,3);M(r);__auto_type s=_mm512_mask_extractf64x2_pd(d1,(__mmask8)(k>>2),d,3);M(s);__auto_type q=_mm512_mask_extractf32x8_ps(f2,(__mmask8)(k>>4),f,3);M(q);__auto_type u=_mm512_mask_extractf64x4_pd(d2,(__mmask8)(k>>6),d,3);M(u);}
{__auto_type r=_mm256_mask_extracti32x4_epi32(b1,(__mmask8)k,a2,3);M(r);r=_mm256_mask_extracti64x2_epi64(a1,(__mmask8)(k>>9),a2,3);M(r);__auto_type s=_mm256_mask_extractf32x4_ps(f1,(__mmask8)(k>>1),f2,3);M(s);__auto_type t=_mm256_mask_extractf64x2_pd(d1,(__mmask8)(k>>11),d2,3);M(t);}
{__auto_type r=_mm512_inserti32x4(a,a1,5);M(r);r=_mm512_inserti64x2(a,b1,5);M(r);r=_mm512_inserti32x8(a,a2,5);M(r);r=_mm512_inserti64x4(a,b2,5);M(r);}
{__auto_type r=_mm512_insertf32x4(f,f1,5);M(r);__auto_type s=_mm512_insertf64x2(d,d1,5);M(s);r=_mm512_insertf32x8(f,f2,5);M(r);s=_mm512_insertf64x4(d,d2,5);M(s);}
{__auto_type r=_mm256_inserti32x4(a2,a1,5);M(r);r=_mm256_inserti64x2(a2,b1,5);M(r);__auto_type s=_mm256_insertf32x4(f2,f1,5);M(s);__auto_type t=_mm256_insertf64x2(d2,d1,5);M(t);}
{__auto_type r=_mm512_mask_extracti32x4_epi32(b1,(__mmask8)k,a,5);M(r);r=_mm512_mask_extracti64x2_epi64(a1,(__mmask8)(k>>3),a,5);M(r);__auto_type q=_mm512_mask_extracti32x8_epi32(b2,(__mmask8)(k>>5),a,5);M(q);q=_mm512_mask_extracti64x4_epi64(a2,(__mmask8)(k>>7),a,5);M(q);}
{__auto_type r=_mm512_mask_extractf32x4_ps(f1,(__mmask8)k,f,5);M(r);__auto_type s=_mm512_mask_extractf64x2_pd(d1,(__mmask8)(k>>2),d,5);M(s);__auto_type q=_mm512_mask_extractf32x8_ps(f2,(__mmask8)(k>>4),f,5);M(q);__auto_type u=_mm512_mask_extractf64x4_pd(d2,(__mmask8)(k>>6),d,5);M(u);}
{__auto_type r=_mm256_mask_extracti32x4_epi32(b1,(__mmask8)k,a2,5);M(r);r=_mm256_mask_extracti64x2_epi64(a1,(__mmask8)(k>>9),a2,5);M(r);__auto_type s=_mm256_mask_extractf32x4_ps(f1,(__mmask8)(k>>1),f2,5);M(s);__auto_type t=_mm256_mask_extractf64x2_pd(d1,(__mmask8)(k>>11),d2,5);M(t);}
{__auto_type r=_mm512_inserti32x4(a,a1,7);M(r);r=_mm512_inserti64x2(a,b1,7);M(r);r=_mm512_inserti32x8(a,a2,7);M(r);r=_mm512_inserti64x4(a,b2,7);M(r);}
{__auto_type r=_mm512_insertf32x4(f,f1,7);M(r);__auto_type s=_mm512_insertf64x2(d,d1,7);M(s);r=_mm512_insertf32x8(f,f2,7);M(r);s=_mm512_insertf64x4(d,d2,7);M(s);}
{__auto_type r=_mm256_inserti32x4(a2,a1,7);M(r);r=_mm256_inserti64x2(a2,b1,7);M(r);__auto_type s=_mm256_insertf32x4(f2,f1,7);M(s);__auto_type t=_mm256_insertf64x2(d2,d1,7);M(t);}
{__auto_type r=_mm512_mask_extracti32x4_epi32(b1,(__mmask8)k,a,7);M(r);r=_mm512_mask_extracti64x2_epi64(a1,(__mmask8)(k>>3),a,7);M(r);__auto_type q=_mm512_mask_extracti32x8_epi32(b2,(__mmask8)(k>>5),a,7);M(q);q=_mm512_mask_extracti64x4_epi64(a2,(__mmask8)(k>>7),a,7);M(q);}
{__auto_type r=_mm512_mask_extractf32x4_ps(f1,(__mmask8)k,f,7);M(r);__auto_type s=_mm512_mask_extractf64x2_pd(d1,(__mmask8)(k>>2),d,7);M(s);__auto_type q=_mm512_mask_extractf32x8_ps(f2,(__mmask8)(k>>4),f,7);M(q);__auto_type u=_mm512_mask_extractf64x4_pd(d2,(__mmask8)(k>>6),d,7);M(u);}
{__auto_type r=_mm256_mask_extracti32x4_epi32(b1,(__mmask8)k,a2,7);M(r);r=_mm256_mask_extracti64x2_epi64(a1,(__mmask8)(k>>9),a2,7);M(r);__auto_type s=_mm256_mask_extractf32x4_ps(f1,(__mmask8)(k>>1),f2,7);M(s);__auto_type t=_mm256_mask_extractf64x2_pd(d1,(__mmask8)(k>>11),d2,7);M(t);}
return h;}
int main(void){unsigned char in[200];unsigned s=777;unsigned t=0;for(int r=0;r<48;r++){for(int i=0;i<200;i++){s=s*1103515245u+12345u;in[i]=(unsigned char)(s>>16);}t=t*31u+probe(in);}printf("%08x\n",t);return 0;}
