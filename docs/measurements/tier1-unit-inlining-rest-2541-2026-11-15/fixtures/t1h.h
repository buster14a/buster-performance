static int t1h_inner(int y)
{
    t1h_mark(y);
    return y;
}
static int t1h_square(int x)
{
    int y = x * x;
    return t1h_inner(y) + 1;
}
