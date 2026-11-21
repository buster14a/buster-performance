int g;
int take(int);
int read(int a) {return a;}
int store(int v) {int a; a=v; return a;}
int update(int a) {a++; return 1;}
int not_used(int a) {(void)a; return 1;}
int shorten(long a) {(void)(char)a; return 1;}
int assignment_used(int a) {return a=3;}
int hidden(int a, int b) {return a= (b++,b);}
int effective(int *p) { *p=1; return *p; }
int address(int a) {return *(int*)&a;}
int ignore(int a) {return 5; a++; }
int multiple(int v) {int a; a=v; a=a+1; return a+a;}
int logical(int a) {return 0 && a;}
int maybe(int a) {return g || a;}
int pred(int a) {return a==2;}
struct Pair { int x,y; };
int member(struct Pair pair) {return pair.x;}
int member_ptr(struct Pair *p) { p->x=2; return p->x;}
int main(int n,char **argv) {return read(n);}
