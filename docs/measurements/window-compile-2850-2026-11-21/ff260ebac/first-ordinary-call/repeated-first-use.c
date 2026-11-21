extern int narrow(int);
extern long wide(long);

long result(int value)
{
    narrow(value);
    narrow(value);
    return wide((long)value) + 1;
}
