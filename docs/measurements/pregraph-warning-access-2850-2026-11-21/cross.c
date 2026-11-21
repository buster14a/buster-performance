extern void take(int*);
extern void consume(int);
int loop_step(int a) { for (; a ;) { a++; } return 0; }
int loop_unchanged(int a) { for (; a ;) { consume(a); } return 0; }
int loop_addr(int a) { for (; a ;) { take(&a); } return 0; }
int cmp(int a, int b) { return a == b; }
int *own_address(int a) { return &a; }
int *decayed(void) { int v[2]; return v; }
int *static_address(void) { static int a; return &a; }
int comparison_use(int a) { consume(a<2); return a; }
