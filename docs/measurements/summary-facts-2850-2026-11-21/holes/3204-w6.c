long g;
int ga[4];
int f(int a)
{
    if ((char)(long)&g || a)
    {
        return 1;
    }
}
