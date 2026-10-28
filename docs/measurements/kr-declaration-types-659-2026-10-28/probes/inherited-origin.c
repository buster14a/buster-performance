#pragma clang diagnostic ignored "-Wdeprecated-non-prototype"
int f(a)int a;{return a;}
#pragma clang diagnostic error "-Wdeprecated-non-prototype"
struct S{long a,b;};struct S g(void){int(*p)()=f;p(1);}
