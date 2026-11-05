#include <x86intrin.h>
#include <stdio.h>
int main(void) { _mm_sfence(); _mm_lfence(); _m_prefetch((void*)"x"); unsigned c = _mm_getcsr(); _mm_setcsr(c); printf("%x\n", c & 0x1f80); return 0; }
