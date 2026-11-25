extern inline __attribute__((gnu_inline)) int f(void){return 7;}
inline int f(void);
int g(void){return f();}
