#include <stdio.h>
#include <stdbool.h>

static int f2(bool b, int c) { return (b ? 10 : 20) + c; }
static int f3(bool b, long w, int c) { return (b ? 100 : 200) + (int)w + c; }
static int f4(int i, bool b, int c) { return i * 1000 + (b ? 10 : 20) + c; }
static int fd(int i, int c) { return i * 2 + c; }

int g2(int x, int a, int b) { return f2(x, a < b); }
int g3(int x, int y, int a, int b) { return f3(x, y, a == b); }
int g4(int i, int x, int a, int b) { return f4(i, x, a >= b); }
int gd(double d, int a, int b) { return fd(d, a != b); }
int gn(int x, int a, int b) { return f2(x, !(a < b)); }

int main(void)
{
    int sum = 0;
    for (int x = -2; x <= 2; x += 1)
    {
        for (int a = 0; a < 3; a += 1)
        {
            for (int b = 0; b < 3; b += 1)
            {
                printf("%d %d %d %d %d ", g2(x, a, b), g3(x, x * 7, a, b), g4(x, x, a, b), gd(x * 0.75, a, b), gn(x, a, b));
                sum += g2(x, a, b) + g3(x, a, a, b);
            }
        }
        printf("\n");
    }
    printf("%d %d\n", sum, printf("%d %d\n", 1 < 2, sum > 0));
    return 0;
}
