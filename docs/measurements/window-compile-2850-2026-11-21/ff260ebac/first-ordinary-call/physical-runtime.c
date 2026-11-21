typedef int Eight(int,int,int,int,int,int,int,int);
typedef int Pair(int,int);
typedef int *Pointer(int*);
typedef void Touch(int,int);
static int sink;
static Eight eight;
static Pair subtract;
static Pointer identity;
static Touch add;
Eight *kept_eight;
Pair *kept_pair;
Pointer *kept_pointer;
Touch *kept_touch;

static int eight(int a,int b,int c,int d,int e,int f,int g,int h)
{
    return (a + 2*b + 3*c + 4*d + 5*e + 6*f + 7*g + 8*h);
}
static int subtract(int a,int b) { return a-b; }
static int *identity(int *p) { return p; }
static void add(int a,int b) { sink=a*10+b; }
int invoke(int x,int y) { return eight(x,y,3,4,5,6,7,8); }
int *where(int *p) { return identity(p); }
int difference(int a,int b) { return subtract(a,b); }
void toss(int *p,int a,int b) { add(a,b); identity(p); }
int main(void)
{
    int x=0;
    toss(&x,8,3);
    return invoke(1,2)!=204 || difference(14,7)!=7 || where(&x)!=&x || sink!=83;
}
