// Original section-prefix method smoke: both a function call and its return must survive relocation.
#include <stdio.h>
#include <string.h>
__asm__(".section .text.buster_checker,\"ax\",@progbits\n.p2align 12\n.text");
#pragma clang section text = ".text.buster_checker"
__attribute__((noinline)) int shifted(int value)
{
    return value + 7;
}
#pragma clang section text = ""
volatile int input = 1;
int main(int argc, char** argv)
{
    int result = shifted(input) != 8;
    for (int i = 1; result == 0 && i + 1 < argc; i += 1)
    {
        if (strcmp(argv[i], "-o") == 0)
        {
            FILE* file = fopen(argv[++i], "wb");
            result = file == NULL;
            if (file != NULL)
            {
                result |= fwrite("qa-test", 1, 7, file) != 7;
                result |= fclose(file) != 0;
            }
        }
    }
    return result;
}
