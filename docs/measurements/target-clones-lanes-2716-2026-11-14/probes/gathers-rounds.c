#include <immintrin.h>
#include <stdio.h>
#define M(v) do{for(unsigned k_=0;k_<sizeof(v);k_++)h=(h^((unsigned char*)&(v))[k_])*16777619u;}while(0)
static int table[256];static long long qtable[256];static float ftable[256];static double dtable[256];
__attribute__((target_clones("avx10.2","default"))) static unsigned probe(const unsigned char* in){unsigned h=2166136261u;
__m128i s4,i4,m4,q2,mq;__builtin_memcpy(&s4,in,16);__builtin_memcpy(&i4,in+16,16);__builtin_memcpy(&m4,in+32,16);__builtin_memcpy(&q2,in+48,16);__builtin_memcpy(&mq,in+64,16);
/* indices into the tables, masked-off ones far away */
i4=_mm_and_si128(i4,_mm_set1_epi32(63));q2=_mm_and_si128(q2,_mm_set1_epi64x(31));
__m128i far=_mm_set1_epi32(0x40000000);i4=_mm_or_si128(i4,_mm_andnot_si128(_mm_srai_epi32(m4,31),far));
__m128i i4q=_mm_or_si128(_mm_and_si128(i4,_mm_set1_epi32(63)),_mm_andnot_si128(_mm_srai_epi32(_mm_shuffle_epi32(mq,0xfd),31),far));__m128i farq=_mm_set1_epi64x(0x4000000000ll);q2=_mm_or_si128(q2,_mm_andnot_si128(_mm_cmpgt_epi32(_mm_setzero_si128(),_mm_shuffle_epi32(mq,0xf5)),farq));
#ifndef V3
{__auto_type r=_mm_mask_i32gather_epi32(s4,table,i4,m4,4);M(r);r=_mm_mask_i32gather_epi32(s4,table,_mm_srli_epi32(_mm_and_si128(i4,_mm_set1_epi32(62)),0),m4,2);M(r);}
{__auto_type r=_mm_mask_i32gather_epi64(s4,qtable,i4q,mq,8);M(r);__auto_type f=_mm_mask_i32gather_ps(_mm_castsi128_ps(s4),ftable,i4,_mm_castsi128_ps(m4),4);M(f);__auto_type d=_mm_mask_i32gather_pd(_mm_castsi128_pd(s4),dtable,i4q,_mm_castsi128_pd(mq),8);M(d);}
{__m128i mqd=_mm_shuffle_epi32(mq,0xfd);__auto_type r=_mm_mask_i64gather_epi32(s4,table,q2,mqd,4);M(r);r=_mm_mask_i64gather_epi64(s4,qtable,q2,mq,8);M(r);__auto_type f=_mm_mask_i64gather_ps(_mm_castsi128_ps(s4),ftable,q2,_mm_castsi128_ps(mqd),4);M(f);__auto_type d=_mm_mask_i64gather_pd(_mm_castsi128_pd(s4),dtable,q2,_mm_castsi128_pd(mq),8);M(d);r=_mm_mask_i64gather_epi64(s4,qtable,q2,mq,1);M(r);}
#endif
#ifdef ROUND
__m128 fa,fb,fw;__m128d da,db,dw;__m256 fy,fz;__builtin_memcpy(&fa,in+80,16);__builtin_memcpy(&fb,in+96,16);__builtin_memcpy(&fw,in+112,16);__builtin_memcpy(&da,in+80,16);__builtin_memcpy(&db,in+96,16);__builtin_memcpy(&dw,in+112,16);__builtin_memcpy(&fy,in+80,32);__builtin_memcpy(&fz,in+112,32);
{__auto_type r=_mm_mask_roundscale_ss(fw,1,fa,fb,0x01);M(r);r=_mm_mask_roundscale_ss(fw,0,fa,fb,0x02);M(r);r=_mm_mask_roundscale_ss(fw,3,fa,fb,0x13);M(r);r=_mm_mask_roundscale_ss(fw,1,fa,fb,0x24);M(r);r=_mm_mask_roundscale_ss(fw,1,fa,fb,0x08);M(r);}
{__auto_type r=_mm_mask_roundscale_sd(dw,1,da,db,0x01);M(r);r=_mm_mask_roundscale_sd(dw,0,da,db,0x02);M(r);r=_mm_mask_roundscale_sd(dw,1,da,db,0xf3);M(r);r=_mm_mask_roundscale_sd(dw,1,da,db,0x0c);M(r);}
#ifdef V3
{__auto_type r=_mm256_mask_roundscale_ps(fz,1,fy,1);M(r);r=_mm256_mask_roundscale_ps(fz,0x5a,fy,0x12);M(r);r=_mm256_mask_roundscale_ps(fz,0xff,fy,0x03);M(r);r=_mm256_mask_roundscale_ps(fz,0x81,fy,0x0e);M(r);}
#endif
#endif
return h;}
int main(void){for(int i=0;i<256;i++){table[i]=i*2654435761u;qtable[i]=(long long)i*0x9e3779b97f4a7c15ll;ftable[i]=(float)i*1.25f-7.0f;dtable[i]=(double)i*-0.75+3.0;}
unsigned char in[160];unsigned s=4242;unsigned t=0;for(int r=0;r<64;r++){for(int i=0;i<160;i++){s=s*1103515245u+12345u;in[i]=(unsigned char)(s>>16);}
for(int i=0;i<12;i++){float x=((float)((int)in[80+i]-128))/(float)(1+in[i]%9);__builtin_memcpy(in+80+4*i,&x,4);}
t=t*31u+probe(in);}printf("%08x\n",t);return 0;}
