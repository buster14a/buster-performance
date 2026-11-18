typedef int F(int);
extern const F cf;
extern volatile F vf;
typedef const F CF;
extern CF ccf;
int g(int a)
{
    int x = 0;
    x = (*cf)(a);
    x = (**cf)(a) + cf(a);
    x = (*vf)(a);
    x = (*ccf)(a);
    return x;
}
