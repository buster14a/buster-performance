#include <limits.h>
#include <stdio.h>
int truth_eq(int, int), ref_eq(int, int);
int truth_ne(unsigned, unsigned), ref_ne(unsigned, unsigned);
int main(void) {
    const int inputs[] = { INT_MIN, INT_MIN + 1, -2, -1, 0, 1, 2, INT_MAX - 1, INT_MAX };
    for (unsigned i = 0; i < 9; i++)
        for (unsigned j = 0; j < 9; j++)
            if (truth_eq(inputs[i], inputs[j]) != ref_eq(inputs[i], inputs[j]) ||
                truth_ne((unsigned)inputs[i], (unsigned)inputs[j]) != ref_ne((unsigned)inputs[i], (unsigned)inputs[j]))
                return 1;
    puts("Clang agrees on 162 signed/unsigned return values.");
    return 0;
}
