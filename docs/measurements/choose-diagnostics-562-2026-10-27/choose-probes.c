#include <stdio.h>
#include <stdlib.h>
#include <sys/wait.h>
int main(int argc, char** argv)
{
    const char* compiler = argc > 1 ? argv[1] : "clang";
    const char* expressions[] = {
        "__builtin_choose_expr(0,BAD,0)",
        "__builtin_choose_expr(1,0,BAD)",
        "__builtin_choose_expr(1,BAD,0)",
        "__builtin_choose_expr(0,0,BAD)",
        "sizeof(__builtin_choose_expr(0,BAD,0))",
        "__builtin_choose_expr(0,sizeof(BAD),0)",
        "__builtin_choose_expr(0,0&&BAD,0)",
        "__builtin_choose_expr(0,1?0:BAD,0)",
        "__builtin_choose_expr(0,(unsigned){BAD},0)",
        "_Generic(0,int:0,default:BAD)",
        "__builtin_choose_expr(1,0,__builtin_choose_expr(1,BAD,0))",
        "__builtin_choose_expr(0,__builtin_choose_expr(0,BAD,0),0)",
        "__builtin_choose_expr(1,sizeof(BAD),0)"
    };
    const char* forms[] = {
        "unsigned f(V a){return %s;}\n",
        "unsigned f(V a){if(0)return %s;return 0;}\n",
        "unsigned f(V a){return 0;return %s;}\n",
        "unsigned f(V a){return 0&&(%s);}\n",
        "unsigned f(V a){return sizeof(%s);}\n"
    };
    for (unsigned i = 0; i < sizeof(expressions)/sizeof(*expressions); i += 1)
    {
        for (unsigned j = 0; j < sizeof(forms)/sizeof(*forms); j += 1)
        {
            FILE* source = fopen("work/choose-probe.c", "w");
            fputs("typedef char V __attribute__((vector_size(16)));\n#define BAD __builtin_ia32_cmpb128_mask(a,a,8,65535)\n", source);
            fprintf(source, forms[j], expressions[i]);
            fclose(source);
            char command[2048];
            snprintf(command, sizeof(command), "env -u CPATH %s -std=gnu17 -fsyntax-only work/choose-probe.c > work/choose-probe.out 2> work/choose-probe.err", compiler);
            int status = system(command);
            printf("%u %u status=%d %s\n", i, j, WEXITSTATUS(status), expressions[i]);
        }
    }
    return 0;
}
