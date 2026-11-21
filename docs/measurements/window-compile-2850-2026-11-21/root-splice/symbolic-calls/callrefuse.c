int add(int a, int b) {return a+b;}
extern int __attribute__((ms_abi)) foreign(int);
extern int variable(int,...);
extern int reports(int) __attribute__((returns_twice));
extern int chain(int);
extern float reals(float);
int use_ms(int x) {return foreign(x);}
int use_variadic(int x) {return variable(x,1);}
int use_twice(int x) {return reports(x);}
float use_real(float x){return reals(x);}
int use_nested(int x) {return chain(chain(x));}
int use_indirect(int(*target)(int),int x){return target(x);}
