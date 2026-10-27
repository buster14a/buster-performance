#include <stdio.h>
#include <stdlib.h>

int main(int argc, char** argv)
{
    const unsigned blocks = argc > 1 ? (unsigned)strtoul(argv[1], NULL, 10) : 40000;
    const int signed_values = argc > 2 && argv[2][0] == 'i';
    const char* type = signed_values ? "int" : "unsigned";
    printf("%s f(%s x)\n{\n", type, type);
    for (unsigned b = 0; b < blocks; b += 1)
    {
        printf("{ %s x_%u=x+%u; %s v=x_%u*3; x^=v; }\n", type, b % 64, b, type, b % 64);
    }
    printf("return x;\n}\nint main(void)\n{\n"
           "unsigned inputs[4]={0,1,12345,0x7fffffff};\n"
           "for(unsigned k=0;k<4;k++){unsigned x=inputs[k];\n"
           "for(unsigned i=0;i<%uu;i++){x^=(x+i)*3u;}\n"
           "if((unsigned)f((%s)inputs[k])!=x)return 1;}\nreturn 0;\n}\n", blocks, type);
    return ferror(stdout) != 0;
}
