struct P { long x, y; };
static struct P padd(struct P a, struct P b) { struct P r = { a.x + b.x, a.y + b.y }; return r; }
long k_struct16(const long *p, int n) {
  struct P acc = { 0, 0 };
  for (int i = 0; i + 1 < n; i++) { struct P v = { p[i], p[i + 1] }; acc = padd(acc, v); }
  return acc.x ^ acc.y;
}
