int global;
extern int ext(int);
int callex(int x) { return ext(x); }
int lit(void) {return 1;}
int local(int x){return x;}
int globalread(void){return global;}
int arith(int x,int y){return x+y;}
int constant(int x){return x+3;}
int cond(int x,int y){if(x<y){return y;}return x;}
void store(int *p,int v){*p=v;global=v;}
int ptr(int*p){return *p;}
int address_once(void) {
    int leaf = 37;
    int *p;
    p =
        &leaf;
    return *p;
}
int arithmetic_lines(int m, int k) {
    int x;
    x =
        m;
    return
        x
        +
        k;
}
