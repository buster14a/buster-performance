typedef int FF(int,int);
extern FF consume;
FF *known;
int two(void){ int x, y; return consume(x,y); }
int again(void){ int x; return consume(x,x); }
int mixed(int f) {
    int x, y;
    if (f) x=3;
    if (f) y=1;
    consume(y,x);
    return x;
}
int out(int f) { int x; for (int i=0; i<f; ++i) {consume(x,i); x=1;} return f; }
