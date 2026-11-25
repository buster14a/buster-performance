extern inline __attribute__((gnu_inline)) int f(void){return 7;}
int f(void){return 8;}
int g(void){return f();}
