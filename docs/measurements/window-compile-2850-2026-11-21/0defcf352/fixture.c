extern int consume(int);
extern int unreachable(void);
extern int global;
static int helper(int x) { return x + 3; }
int immediate(void) { return 19; }
int simple(int x) { consume(x); return helper(x - 1); }
int conditional(int x) { if (x < 4) return helper(x); return consume(x + global); }
int alternative(int x) { if (x) consume(x); else consume(global); return x; }
int folded(int x) { if (0) return unreachable(); return helper(x); }
int iteration(int x) { while (x > 10) { if (x == 12) break; --x; } return x; }
int repeated(int x) { do { --x; if (x > 16) continue; consume(x); } while (x > 0); return x; }
int indices(int x) { for (; x > 0; --x) consume(x); return x; }
int local_init(int x) { int n = x + 1; return n; }
int cases(int x) { switch (x) { case 0: return 7; default: return x; } }
struct pair { int value; int *pointer; };
int take_pair(int x) { struct pair p = {.pointer = &global, .value = x}; return *p.pointer + p.value; }
int multi(int x) { int y = x + 1, z = y + 3; while (z--) y += x; return y; }
int automatic_array(int x) { int a[3] = {global, x, consume(x)}; return a[x & 1]; }
int read_static(int x) { static const int k[] = {3, 7, 11, 13}; return k[x & 3]; }
int compound_literal(int x) { return ((struct pair){x, &global}).value; }
int indexed(int x) { for (int n = x; n > 0; --n) x = consume(n); return x; }
int ranges(unsigned x) { switch (x) { case 0: case 3 ... 7: return global; case 42: return 1; default: return x; } }
int nested(int x, int y) { switch (x) { case 1: switch(y) { case 2: return consume(y); } break; default: return x; } return 5; }
int folded_cases(int x) { switch(3) { case 0: return unreachable(); case 3: return consume(x); } return 0; }
int multiple_labels(int x) { if (x > 3) goto later; do { if (x == 2) goto early; later: x--; } while (x > 0); early: return x; }
int wide_switch(unsigned _BitInt(150) x) { switch(x){case ((unsigned _BitInt(150))1 << 131): return 8;case 2 ... 11: return consume(3);default:return 7;} }
int bit_fields(int x) { struct bits { unsigned x:7; signed y:5; } v = {.y=-3,.x=(unsigned)x}; return v.x + v.y; }
