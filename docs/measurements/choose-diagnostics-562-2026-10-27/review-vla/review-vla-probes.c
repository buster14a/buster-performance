#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/wait.h>
int main(int argc, char** argv)
{
    int result = argc != 2;
    const char* sources[] = {
        "unsigned f(V a,int n){(void)__builtin_choose_expr(1,0,0);return sizeof(int[n+BAD]);}",
        "unsigned f(V a,int n){return sizeof(int[n+__builtin_choose_expr(0,BAD,1)]);}",
        "unsigned f(V a,int n){return sizeof(int[n+__builtin_choose_expr(1,BAD,1)]);}",
        "unsigned f(V a,int n){return __builtin_choose_expr(0,sizeof(int[n+BAD]),0);}",
        "unsigned f(V a,int n){(void)__builtin_choose_expr(1,0,0);return sizeof(sizeof(int[n+BAD]));}",
        "unsigned f(V a,int n){(void)__builtin_choose_expr(1,0,0);int x[n+BAD];return sizeof(x);}",
        "unsigned f(V a,int n){(void)__builtin_choose_expr(1,0,0);return BAD;}",
        "unsigned f(V a,int n){(void)__builtin_choose_expr(1,0,0);return sizeof(int[n+__builtin_ia32_cmpb128_mask(a,a,7,65535)]);}",
        "unsigned f(V a,int n){return sizeof(int[n+BAD]);}"
    };
    for (unsigned i = 0; !result && i < sizeof(sources)/sizeof(*sources); i += 1)
    {
        FILE* file = fopen("review-vla-source.c", "w");
        if (file != NULL)
        {
            fprintf(file, "typedef char V __attribute__((vector_size(16)));\n#define BAD __builtin_ia32_cmpb128_mask(a,a,8,65535)\n%s\n", sources[i]);
            fclose(file);
            char command[2048];
            snprintf(command, sizeof(command), "env -u CPATH -u C_INCLUDE_PATH %s -std=gnu17 -fsyntax-only -fno-color-diagnostics review-vla-source.c > review-vla.out 2> review-vla.err", argv[1]);
            int status = system(command);
            unsigned ranges = 0;
            file = fopen("review-vla.err", "r");
            char line[2048];
            while (file != NULL && fgets(line, sizeof(line), file) != NULL)
            {
                ranges += strstr(line, "outside the valid range") != NULL;
            }
            if (file != NULL)
            {
                fclose(file);
            }
            printf("%u status=%d ranges=%u %s\n", i, WEXITSTATUS(status), ranges, sources[i]);
        }
        else
        {
            result = 1;
        }
    }
    return result;
}
