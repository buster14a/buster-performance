#define STEP (2 + 3)
#define CT(x,y) ((x) - (y))
extern int probe(int, int*);
static int a[2 + 3] = { [1 + 1] = 5 + 7 };
enum { f = 2 * (3 + 4), g = (1 << 3) | 2 };
_Static_assert(2 + 3 == 5, "");
static int *p = 1 - 1;
int interior(int n) {
  int x = STEP * 4;
  x += a[2 - 1] + n * (2 + 4);
  if (1 - 1) x = n / 0;
  if (n && 4 - 2) x += 1;
  x += probe(2 + 8, CT(1,1));
  switch(n) { case 1+2: x += 3; break; case -3: x -= 7; }
  return x + (6 / 2 + 3) + (1 < 2) + (9 ^ 3) + (1 << 2);
}
