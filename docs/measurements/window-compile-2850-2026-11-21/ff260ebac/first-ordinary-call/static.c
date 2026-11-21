typedef int *F(int *);
static F hidden;
F *only_type;
static int side;
void use(int *p) { hidden(p); }
static int *hidden(int *p){ side=31; return p; }
int main(void) { int x=0; use(&x); return side!=31; }
