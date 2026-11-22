__attribute__((noinline)) static int f(int x)
{
    switch (x) { case 0: return 3; case 1: return 7; case 2: return 1; case 3: return 9; case 4: return 2; case 5: return 8; case 6: return 4; case 7: return 6;
                 case 8: return 5; case 9: return 0; case 10: return 11; case 11: return 13; case 12: return 17; case 13: return 19; case 14: return 23; case 15: return 29; default: return -1; }
}
int main(void)
{
    unsigned x = 1;
    int s = 0;
    for (int i = 0; i < 40000000; i += 1)
    {
        x = x * 1664525u + 1013904223u;
        s += f((x >> 16) & 15);
    }
    return s & 255;
}
