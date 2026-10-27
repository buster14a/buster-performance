__attribute__((naked)) void raw(void){__asm__("ret" : : "r"(1));}int tested(int n){return n;}
