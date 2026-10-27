// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin.
// Original review cost-screen inputs, including live compound literals with range diagnostics ignored.
#include <stdio.h>
#include <stdint.h>
#include <stdbool.h>

int main(int argc, char** argv)
{
    bool valid = argc == 2;
    const char* names[] = { "small", "valid", "dead", "compound" };
    for (uint32_t variant = 0; valid && variant < 4; variant += 1)
    {
        char path[4096];
        const int length = snprintf(path, sizeof(path), "%s/%s.c", argv[1], names[variant]);
        valid = length > 0 && (size_t)length < sizeof(path);
        FILE* file = valid ? fopen(path, "w") : NULL;
        valid &= file != NULL;
        if (valid)
        {
            valid = fprintf(file, "typedef char V __attribute__((vector_size(16)));\n") > 0;
            if (variant == 3)
            {
                valid &= fprintf(file, "#pragma clang diagnostic ignored \"-Wargument-outside-range\"\n") > 0;
            }
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
                else if (variant == 2)
                {
                    valid &= fprintf(file, "if(0)return __builtin_ia32_cmpb128_mask(a,a,8,65535);return n;") > 0;
                }
                else
                {
                    valid &= fprintf(file, "return (unsigned){__builtin_ia32_cmpb128_mask(a,a,8,65535)}+n;") > 0;
                }
                valid &= fprintf(file, "}\n") > 0;
            }
            valid &= fclose(file) == 0;
        }
    }
    const int result = valid ? 0 : 1;
    return result;
}
