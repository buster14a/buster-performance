static int twice(int value)
{
    return value * 2;
}

int main(void)
{
    int sum = 0;
    for (int i = 0; i < 5; i += 1)
    {
        if (i != 2)
        {
            sum += twice(i);
        }
    }
    return sum == 16 ? 0 : 1;
}
