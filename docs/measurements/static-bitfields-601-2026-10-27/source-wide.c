struct __attribute__((packed)) W{unsigned char a:3;unsigned __int128 b:128;unsigned char c:5;};
struct W wide={5,(unsigned __int128)-1,19};
struct W overwritten={.a=5,.b=(unsigned __int128)-1,.c=19,.b=3};
struct W cleared={.a=5,.b=(unsigned __int128)-1,.c=19,.b={}};
extern int target;union U{int*p;struct W w;} switched={.p=&target,.w={5,3,19}};
struct B{unsigned long x:31;} absolute={(unsigned long)(void*)0x1234};
