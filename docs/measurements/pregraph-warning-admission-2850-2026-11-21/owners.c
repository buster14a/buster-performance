int tracked(int x)
{
    (void)({ int y = x; y; });
    return 42;
}
int untracked(int x)
{
    return 123;
}
