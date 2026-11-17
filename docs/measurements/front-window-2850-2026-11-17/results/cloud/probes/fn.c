int s1(const char*);
int ff(int a)
{
    int x = a;
    x += s1(__func__);
    x += s1("abc" "defgh");
    x += s1(__FUNCTION__);
    return x;
}
int gg(int a)
{
    int x = a;
    x += s1(__func__);
    return x;
}
