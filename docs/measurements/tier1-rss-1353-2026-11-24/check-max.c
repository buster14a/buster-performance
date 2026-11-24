// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception

#include <stdlib.h>

extern int f(const int *);

int main(int argc, char **argv)
{
    if (argc != 3)
        return 2;
    int n = atoi(argv[1]), depth = atoi(argv[2]);
    int *p = malloc((n + depth) * sizeof(*p));
    if (!p)
        return 2;
    for (int i = 0; i < n + depth; ++i)
        p[i] = (i * 13 % 17) - 8;
    int sum = 0;
    for (int i = 0; i < n; ++i) {
        int best = p[i];
        for (int j = 1; j <= depth; ++j)
            if (best < p[i + j])
                best = p[i + j];
        sum += best;
    }
    int result = f(p) != sum;
    free(p);
    return result;
}
