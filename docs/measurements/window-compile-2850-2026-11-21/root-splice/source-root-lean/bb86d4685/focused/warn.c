int g; int f(int a){int un; int b=1; g=2; a=b; return un; }
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wuninitialized"
int h(int a){int u; g=a; return u;}
#pragma clang diagnostic pop
int u(void){return 2147483647 + 1;}
