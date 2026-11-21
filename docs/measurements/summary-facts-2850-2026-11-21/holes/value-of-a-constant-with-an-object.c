extern int g;
int f(int a)
{
    int local = 0;
    local = (_Bool)&g;
    return local + a;
}
