int f(int a, int b)
{
    int r = a;
    r += __extension__ (a + b);
    r += -(a + b) + ~a + +b + !a;
    r += (a, b);
    r += sizeof(a + b) + _Alignof(int);
    return r;
}
