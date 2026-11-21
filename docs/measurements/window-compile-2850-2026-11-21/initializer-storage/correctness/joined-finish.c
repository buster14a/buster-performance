typedef int A[];
static const int x = (const int){4};
static const int a[] = (const int[]){1,2,3};
static const int *p = (const int[]){4,5,6};
int f(void)
{
    const int a = (const int){1};
    const int b = (const int){(const int){2}};
    __auto_type c = (const int){3};
    A d = (int[]){4,5};
    return a+b+c+d[0]+x+p[1];
}
int main(void) { return f()!=19; }
