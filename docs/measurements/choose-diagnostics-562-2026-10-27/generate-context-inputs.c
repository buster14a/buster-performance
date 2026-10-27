#include <stdio.h>
#include <stdlib.h>
int main(int argc, char** argv)
{
    int result = 1;
    if (argc == 5)
    {
        FILE* file = fopen(argv[1], "w");
        if (file != NULL)
        {
            const unsigned count = (unsigned)strtoul(argv[2], NULL, 10);
            const unsigned immediate = (unsigned)strtoul(argv[3], NULL, 10);
            const int choose = atoi(argv[4]);
            fputs("typedef char V __attribute__((vector_size(16)));\n#pragma clang diagnostic ignored \"-Wargument-outside-range\"\n", file);
            for (unsigned i = 0; i < count; i += 1)
            {
                fprintf(file, "unsigned f%u(V a){return %s__builtin_ia32_cmpb128_mask(a,a,%u,65535)%s;}\n", i,
                        choose ? "__builtin_choose_expr(0," : "", immediate, choose ? ",0)" : "");
            }
            result = fclose(file) != 0;
        }
    }
    return result;
}
