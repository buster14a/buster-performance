// Generates a valid reducer input. Changing any live constant makes the divisor zero.
#include <stdint.h>
#include <stdio.h>

int main(void)
{
    unsigned int row = 0;
    unsigned int sum = row++;
    unsigned int expected = 0;
    puts("function (i64) -> i64 {\nb0:\n  %0 = param.i64 0");
    for (unsigned int i = 0; i < 128; i += 1)
    {
        const unsigned int value = i < 64 ? 2 + i % 2 : i + 2;
        const unsigned int constant = row++;
        const unsigned int add = row++;
        printf("  %%%u = const.i64 0x%032x\n", constant, value);
        printf("  %%%u = add.i64 %%%u, %%%u\n", add, sum, constant);
        expected += value;
        sum = add;
    }
    const unsigned int target = row++;
    const unsigned int same = row++;
    const unsigned int divisor = row++;
    const unsigned int quotient = row++;
    const unsigned int address = row++;
    printf("  %%%u = const.i64 0x%032x\n", target, expected);
    printf("  %%%u = icmp.i1 %%%u, %%%u eq\n", same, sum, target);
    printf("  %%%u = zext.i64 %%%u\n", divisor, same);
    printf("  %%%u = udiv.i64 %%%u, %%%u\n", quotient, target, divisor);
    printf("  %%%u = symbol_addr.ptr @2\n", address);
    printf("  %%%u = store.void %%%u, %%%u align=8 volatile\n", row++, address, quotient);
    printf("  %%%u = not.i64 %%%u\n", row++, sum);
    printf("  %%%u = br.void b1\nb1:\n", row++);
    const unsigned int phi = row++;
    printf("  %%%u = phi.i64 [%%%u, b0]\n", phi, quotient);
    printf("  %%%u = ret.void %%%u\n}\n", row, phi);
    return ferror(stdout) != 0;
}
