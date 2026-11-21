extern int weakx __attribute__((weak)); extern int ex; int ex; static __thread int tls; extern volatile int device;
int f(int x){ int a; a=x; if(&weakx) ex=2; tls=6; device=ex; return a; }
int g(void){return weakx;} int h(void){return tls;}
