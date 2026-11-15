#include <stdio.h>
typedef int Tier1Vector __attribute__((vector_size(16)));
__attribute__((noinline)) int tier1_vector_passes(Tier1Vector a, int n)
{
    Tier1Vector total = { 0, 0, 0, 0 };
    for (int i = 0; i < n; i += 1)
    {
        Tier1Vector x = a + a;
        Tier1Vector y = a + a;
        total += x + y;
    }
    return total[0] + total[1] + total[2] + total[3];
}
int main(void)
{
    Tier1Vector a = { 1, 2, 3, 4 };
    printf("%d\n", tier1_vector_passes(a, 7));
    return 0;
}
