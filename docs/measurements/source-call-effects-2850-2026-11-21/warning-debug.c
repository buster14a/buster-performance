typedef int arg;
extern int call(arg);
int uninit(void) { int x; return call(x); }
int set_use(int x) { x=1; return call(x); }
int shadow(int x) { { int y; return call(y); } }
int hidden(int x) { if (0) return call(x); return x+1; }
int quick(void) { static int y; return call(y); }
struct item { int member; };
extern struct item outside;
extern int ext(int);
int file(void) { extern int external; return call(external); }
int attr(int v __attribute__((unused))) { return call(v); }
int macro(int x) { return call(x); }
