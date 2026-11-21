#include <stdio.h>
struct Data { unsigned char small; int n; unsigned short count; signed char narrow; char many[130]; long long wide; };
static unsigned sum(const struct Data *p) { return (unsigned)p->small+(unsigned)p->n+p->count+(unsigned)p->narrow+(unsigned)p->wide; }
void fields(struct Data *p) {
  p->small=251; p->n=123456; p->count=65432; p->narrow=126; p->wide=14789;
}
int main(void) { struct Data d={0}; fields(&d); printf("%u\n",sum(&d)); return sum(&d) != 204054; }
