struct P { int x; int y; };
int a(void) { int x = { sizeof(x) + x }; return x; }
int b(void) { int x = { (int)sizeof x }; return x; }
int c(void) { struct P p = { 1, 2 }; int x = { p.x }; return x; }
int d(struct P *q) { int x = { q->x }; return x; }
int e(void) { int x = { ({ int y = { x }; y; }) }; return x; }
int f(void) { int x = { __alignof__(x) + x }; return x; }
int g(void) { int x = { sizeof(int[sizeof(x)]) + 0 }; return x; }
int h(void) { int x = { sizeof(({ int y = { x }; y; })) }; return x; }
int i(void) { int x = { 0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+x }; return x; }
int j(void) { int x = { 0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+x }; return x; }
int k(void) { int x = { (0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+x) }; return x; }
int l(void) { struct P p = { 1, 2 }; int x = { (0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+p.x) }; return x; }
int m(void) { struct P p = { 1, 2 }; int x = { (0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+p.x+x) }; return x; }
int n(void) { int x = { 0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+x+x }; return x; }
int o(void) { int x = { sizeof(0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+x) + x }; return x; }
int p(void) { struct P x = { .x = 1, .y = x.x }; return x.y; }
int q(void) { int *x = { &x[0] }; return x != 0; }
int r(void) { int x = { 0 }, y = { x }; return x + y; }
int s(void) { int y = { y + sizeof(y) }; return y; }
