__attribute__((naked)) void raw(int n){register int x[n] asm("rax");__asm__("ret");}int tested(int n){return n;}
