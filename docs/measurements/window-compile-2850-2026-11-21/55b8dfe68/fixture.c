struct Pair { volatile unsigned v : 3; unsigned n : 11; short value; };
struct Row { struct Pair p[2]; unsigned a; };
static struct Row bump(struct Row r) { ++r.p[0].v; r.a += r.p[1].n; return r; }
static int array(const struct Row (*rows)[3], int index) { return (*rows)[index].p[0].v + (*rows)[index].a; }
static unsigned unary(unsigned x) { return x ^ 6u; }
static unsigned call(unsigned (*f)(unsigned), const unsigned (*v)[2]) { return f((*v)[1]); }
int main(void) { struct Row rows[3]={0}; unsigned m[2]={3,6}; rows[1].p[1].n=10; rows[1]=bump(rows[1]); return array(&rows,1)!=11 || call(unary,&m)!=0; }
