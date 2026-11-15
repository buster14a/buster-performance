typedef long long V64 __attribute__((vector_size(64)));
typedef int V32 __attribute__((vector_size(32)));
typedef float V16 __attribute__((vector_size(16)));
typedef struct { V64 v; } S64;
typedef struct { V32 v; } S32;
typedef struct { V16 v; } S16;
typedef union { V64 v; unsigned long long q[8]; } U64;
typedef union { unsigned char c[64]; V64 v; } R64;
typedef struct { S64 s; } O64;
typedef struct { V16 v; int tail; } T16;
typedef union { V16 v; unsigned char c[32]; } N16;
__attribute__((noinline)) static void dirty(int n){volatile unsigned char d[4096];for(int i=0;i<4096;i++)d[i]=(unsigned char)(n+i*7+1);}
static unsigned long long mix(const void* p, int bytes){const unsigned char* b=p;unsigned long long t=0;for(int i=0;i<bytes;i++)t=t*131+b[i];return t;}
__attribute__((noinline)) static unsigned long long lit(const V64* p){S64 o;o=(S64){.v=*p};return mix(&o,64);}
__attribute__((noinline)) static unsigned long long decl(const V64* p){S64 r={*p};return mix(&r,64);}
__attribute__((noinline)) static unsigned long long uni(const V64* p){U64 r={.v=*p};return r.q[3]*7+r.q[7];}
__attribute__((noinline)) static unsigned long long later(const V64* p){R64 r={.v=*p};return mix(r.c,64);}
__attribute__((noinline)) static unsigned long long nested(const V64* p){O64 r={{*p}};return mix(&r,64);}
__attribute__((noinline)) static unsigned long long s32(const V32* p){S32 r={*p};return mix(&r,32);}
__attribute__((noinline)) static unsigned long long s16(const V16* p){S16 r=(S16){*p};return mix(&r,16);}
__attribute__((noinline)) static unsigned long long over(const V64* p){U64 r={.v=*p,.q[1]=5};return mix(&r,64);}
__attribute__((noinline)) static unsigned long long vol(const V64* p){volatile S64 r={*p};S64 c;__builtin_memcpy(&c,(const void*)&r,64);return mix(&c,64);}
__attribute__((noinline)) static unsigned long long tail(const V16* p){T16 r={*p};return mix(&r.v,16)*3+r.tail;}
__attribute__((noinline)) static unsigned long long narrow(const V16* p){N16 r={.v=*p};return mix(r.c,32);}
__attribute__((noinline)) static unsigned long long self(const V64* p){V64 r=*p;V64* q=&r;return mix(q,64);}
int main(void){
  V64 a;V32 b;V16 c;for(int i=0;i<8;i++)a[i]=0x0101010101010101LL*(i+3)+i;for(int i=0;i<8;i++)b[i]=i*0x01020304+9;for(int i=0;i<4;i++)c[i]=(float)i*1.5f+0.25f;
  unsigned long long t=0;
  dirty(1);t=t*3+lit(&a);dirty(2);t=t*3+decl(&a);dirty(3);t=t*3+uni(&a);dirty(4);t=t*3+later(&a);dirty(5);t=t*3+nested(&a);
  dirty(6);t=t*3+s32(&b);dirty(7);t=t*3+s16(&c);dirty(8);t=t*3+over(&a);dirty(9);t=t*3+vol(&a);dirty(10);t=t*3+tail(&c);
  dirty(11);t=t*3+narrow(&c);dirty(12);t=t*3+self(&a);
  __builtin_printf("%llu\n",t);return 0;}
