struct Data { unsigned char small; int n; unsigned count; unsigned bits:3; volatile int visible; };
void fields(struct Data *p, int flag) {
  p->small = 9; p->n = 10; p->count = 7; p->bits = 8; p->visible = 1;
  p->small = 512;
  if (flag) p->n = 5;
  int inside = ({ p->n = 7; });
  (void)inside;
}
void first_read(void) { struct Data *q; q->n = 11; q->small = 2; }
void unused(struct Data *p) { if (0) { p->small = 2; } }
void uninit_only_if(int cond) { struct Data *p; struct Data local; if (cond) p=&local; p->n=9; }
int loop_member(struct Data *p, int i) { for (; i < 4;) { p->n=7; } return i; }
#define GET(x) x
void from_macro(struct Data *p) { p->n=GET(3); }
