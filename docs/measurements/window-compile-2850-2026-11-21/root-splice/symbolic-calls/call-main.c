extern int invoke(int, int);
extern void discarded(int);
extern long narrow_zero(void);
static int seen;
int accept(int a,int b) {seen += a+b; return a+b;}
void touch(int *x) { *x=7; }
long produce(void) { return 31; }
int main(void) {
    if (invoke(3,8) != 11) return 1;
    discarded(5);
    return seen != 27 || narrow_zero()!=31;
}
