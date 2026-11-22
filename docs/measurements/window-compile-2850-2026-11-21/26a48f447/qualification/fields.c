extern int printf(const char *, ...);
extern int external_add(int, int);
extern volatile int foreign;
extern _Thread_local int foreign_tls;
static volatile int local = 5;
static _Thread_local int saved;
struct Offset { int a, b, c; };
static struct Offset values[4] = {{1,2,3},{4,5,6},{7,8,9},{10,11,12}};
int *const interior = &values[2].c;
static int inline_pick(int x){return x > 2 ? x + saved : x - local;}
static int (* volatile indirect)(int) = inline_pick;
static int switcher(int x) {
    switch (x) {
    case 0: return external_add(x, local);
    case 1: return foreign - inline_pick(x);
    case 2: return external_add(foreign_tls, *interior);
    case 3: return indirect(x + saved);
    case 4: return local - foreign;
    default: return 10;
    }
}
static int labels(int x){
    if (x < 2) goto out;
    asm volatile ("addl %1, %0" : "+r"(x) : "r"(foreign));
out:
    return x + saved;
}
int main(void) {
    int sum = 0;
    saved=3;
    for (int i=0; i<20; ++i) sum += labels(switcher(i%6));
    printf("%d %d %d\n", sum, foreign, foreign_tls);
    return 0;
}
