typedef int FF(int,int);
extern FF consume;
FF *type_only;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wuninitialized"
int f(void){int x, y;return consume(x,y);}
#pragma clang diagnostic pop
#pragma clang diagnostic push
#pragma clang diagnostic error "-Wuninitialized"
int g(void){int x, y;return consume(x,y);}
#pragma clang diagnostic pop
