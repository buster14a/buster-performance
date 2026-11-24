// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception

#include <stdlib.h>

extern int g(int);

int main(int argc, char **argv)
{
    if (argc != 2)
        return 2;
    int n = atoi(argv[1]);
    long long coefficients = (long long)n * (n - 1) / 2;
    for (int a = -1; a <= 5; ++a) {
        long long sum = a > 0 ? coefficients * a * (a - 1) / 2 : 0;
        if (g(a) != sum)
            return 1;
    }
    return 0;
}
