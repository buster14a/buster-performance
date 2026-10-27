// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin.
// Original cost-screen inputs: ordinary code, valid x86 immediates, and suppressed dead calls.
#include <stdio.h>
#include <stdint.h>
#include <stdbool.h>

int main(int argc, char** argv)
{
    bool valid = argc == 2;
    const char* names[] = { "small", "valid", "dead" };
    for (uint32_t variant = 0; valid && variant < 3; variant += 1)
    {
        char path[4096];
        const int length = snprintf(path, sizeof(path), "%s/%s.c", argv[1], names[variant]);
        valid = length > 0 && (size_t)length < sizeof(path);
        FILE* file = valid ? fopen(path, "w") : NULL;
        valid &= file != NULL;
        if (valid)
        {
            valid = fprintf(file, "typedef char V __attribute__((vector_size(16)));\n") > 0;
            const uint32_t count = variant == 0 ? 1 : 1000;
            for (uint32_t i = 0; valid && i < count; i += 1)
            {
                valid = fprintf(file, "unsigned f%u(V a,unsigned n){", i) > 0;
                if (variant == 0)
                {
                    valid &= fprintf(file, "return n*3+1;") > 0;
                }
                else if (variant == 1)
                {
                    valid &= fprintf(file, "if(n)return __builtin_ia32_cmpb128_mask(a,a,7,65535);return 0;") > 0;
                }
                else
                {
                    valid &= fprintf(file, "if(0)return __builtin_ia32_cmpb128_mask(a,a,8,65535);return n;") > 0;
                }
                valid &= fprintf(file, "}\n") > 0;
            }
            valid &= fclose(file) == 0;
        }
    }
    const int result = valid ? 0 : 1;
    return result;
}
