long g;
int ga[4];
int f(int a)
{
    if ((int)(long)&g)
    {
        return 1;
    }
}
