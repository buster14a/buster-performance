static int a; int f(int x){int z; asm volatile ("" : "=r"(z) : "0"(x)); a=1;return z;}
extern int __attribute__((address_space(256))) *t; int g(void){return *t;}
