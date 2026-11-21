enum Color { RED, BLUE, WHITE };
extern void take_signed(char);
extern void take_pointer(void *);
extern void take_enum(enum Color);
int test(unsigned u, char c, int x, int *p) {
  int result = u < (1-2);
  result += u == -1;
  result += c < (128+127);
  result += p == (2-2);
  result += x < (1-1);
  result += (u & (1|2)) == (1<<3);
  result += (x & (1<<2)) == (1<<1);
  result += x << -(1+2);
  result += x << (16+16);
  result += x / (1-1);
  result += x % (1-1);
  result += x ? (1+2) : -1;
  result += (1+2) ? x : (2-2);
  result += (1+3) && u;
  result += u && (1+3);
  result += (1+3) || u;
  result += u || (1+3);
  result += (2 < 4) + (2 < 4);
  take_signed(256+2);
  take_enum(10+12);
  take_pointer(3-3);
  switch (u) { case 1-3: break; case 2-2: break; }
  return result;
}
