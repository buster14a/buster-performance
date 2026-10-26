// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
// Expands this project's labels-as-values-dispatch fixture from c_check_program_test.c into independent functions.
// Compile this generator, then run it with a function count (128 by default); no external source or headers are inputs.
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>

int main(int argc, char** argv)
{
    unsigned long units = 128;
    bool valid = argc <= 2;
    if (argc == 2)
    {
        char* end = 0;
        units = strtoul(argv[1], &end, 10);
        valid = end != argv[1] && *end == 0 && units != 0 && units <= 256;
    }
    if (valid)
    {
        puts("/* Original Buster labels-as-values fixture expansion: static dispatch tables, conditional operands and VLA exits. */");
        for (unsigned long unit = 0; unit < units; unit += 1)
        {
            printf("static int run%lu(const unsigned char*c,int n){static const void*const t[]={&&add,&&mul,&&jump,&&end,&&dup};"
                   "int acc=n;int pc=0;void*last=&&end;goto*t[c[pc]];"
                   "add:acc+=c[pc+1];pc+=2;goto*t[c[pc]];"
                   "mul:acc*=c[pc+1];pc+=2;goto*t[c[pc]];"
                   "jump:pc=c[pc+1];goto*(pc>8?&&end:t[c[pc]]);"
                   "dup:acc+=acc;pc+=1;last=&&dup;goto*t[c[pc]];"
                   "end:return last==&&dup?acc+1000:acc;}\n"
                   "int tested%lu(int n){static const unsigned char p[]={0,3,1,5,4,2,9,0,100,3};static const unsigned char q[]={1,2,0,7,3};"
                   "void*out=&&done;int r=run%lu(p,n)*31+run%lu(q,n);"
                   "for(int i=0;i<3;i++){int v[(n&3)+1];v[0]=i;r+=v[0];if(i==1)goto*out;}r=-1;done:return r;}\n",
                   unit, unit, unit, unit);
        }
        puts("int main(void){int result=0;");
        for (unsigned long unit = 0; unit < units; unit += 1)
        {
            printf("result+=tested%lu(7);\n", unit);
        }
        printf("return result!=%lu;}\n", units * 34122);
    }
    else
    {
        fputs("usage: label-dispatch-gen [1..256]\n", stderr);
    }
    return valid && !ferror(stdout) ? 0 : 1;
}
