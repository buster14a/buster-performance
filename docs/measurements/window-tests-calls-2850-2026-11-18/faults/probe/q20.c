struct H { int (*fn)(int, int); int (*const cfn)(int, int); };
int k0(int, int);
int (*kp)(int, int);
int (*const kc)(int, int) = k0;
int (*volatile kv)(int, int);
int (*ka[2])(int, int);
int (**kpp)(int, int);
typedef int F(int, int);
F* kt;
int f(int a, struct H* h, struct H s, int (*param)(int, int), F fp)
{
    int x = 0;
    x = (kp)(a, 1000);
    return x;
}
