extern int g, h;
int initial(int x, int y) { return (x^y)+3; }
int first_uninit(void) { int x; return (x ^ 3)+1; }
int multi_uninit(void) { int a,b; return (a+b)^(a+b); }
int order(void) { int a; a=2; return a+1; }
int read_write(void) { int a,b; a=b; return a*3; }
int dead(int a) { return a+1; a=2; }
int set_only(int a) { a=2; return 0; }
int used_after_set(int a) { a=3; return a+2; }
int parameter_read(int a, int b) { a=3; return b+a; }
int loop(int a) { for(;a;) {a=2;} return a; }
int fallback(int a) { return a==g; }
int many(int a) {int x; if(a) x=2; return x+g;}
