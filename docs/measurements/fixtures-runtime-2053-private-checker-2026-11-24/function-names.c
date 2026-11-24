#include <stdio.h>
#include <assert.h>
#include <string.h>
typedef struct CheckFunctionNameFixture CheckFunctionNameFixture;
struct CheckFunctionNameFixture
{
    const char* label;
    const char* source;
    const char* name;
    const char* pretty;
};


int main(void){
    const CheckFunctionNameFixture fixtures[] =
    {
        {
            .label = "plain prototype",
            .source = "int f(void){NAMES;return 0;}\n",
            .name = "f",
            .pretty = "int f(void)",
        },
        {
            .label = "typedef return and parameter spelling",
            .source = "typedef int I; I f(I x){NAMES;return x;}\n",
            .name = "f",
            .pretty = "I f(I)",
        },
        {
            .label = "canonical scalar spelling and parameter qualifiers",
            .source = "static inline unsigned long int f(signed int x, volatile const int y){NAMES;return x+y;}\n",
            .name = "f",
            .pretty = "unsigned long f(int, const volatile int)",
        },
        {
            .label = "qualified pointer typedef and explicit pointers",
            .source = "typedef int I; typedef int *P; P f(const P p,I *q,const I *r,I *const s){NAMES;return p;}\n",
            .name = "f",
            .pretty = "P f(const P, I *, const I *, I *const)",
        },
        {
            .label = "array parameter adjustment drops outer alias",
            .source = "typedef int A[4]; int f(A a,int b[const static 4],const int c[3]){NAMES;return 0;}\n",
            .name = "f",
            .pretty = "int f(int *, int *const, const int *)",
        },
        {
            .label = "nested callbacks retain occurrence-specific aliases",
            .source = "typedef int I; typedef int F(int); int f(F a,F *b,I (*c)(I),I (*(*d)(I))(I)){NAMES;return 0;}\n",
            .name = "f",
            .pretty = "int f(F *, F *, I (*)(I), I (*(*)(I))(I))",
        },
        {
            .label = "callback unnamed qualifiers and pointer to array alias",
            .source = "typedef int I; typedef int A[4]; typedef int *P; void f(int (*cb)(const int,const I,I *const,const P),A *p,const A *q){NAMES;}\n",
            .name = "f",
            .pretty = "void f(int (*)(const int, const I, I *const, const P), A *, const A *)",
        },
        {
            .label = "function returning function pointer",
            .source = "int (*f(void))(int){NAMES;return 0;}\n",
            .name = "f",
            .pretty = "int (*f(void))(int)",
        },
        {
            .label = "function returning array pointer",
            .source = "int (*f(void))[4]{NAMES;return 0;}\n",
            .name = "f",
            .pretty = "int (*f(void))[4]",
        },
        {
            .label = "distinct return and nested parameter typedef occurrences",
            .source = "typedef int I; typedef int J; I (*f(J (*x)(I)))(J){NAMES;return 0;}\n",
            .name = "f",
            .pretty = "I (*f(J (*)(I)))(J)",
        },
        {
            .label = "variadic alias",
            .source = "typedef int I; int f(I x,...){NAMES;return x;}\n",
            .name = "f",
            .pretty = "int f(I, ...)",
        },
        {
            .label = "unprototyped definition",
            .source = "void f(){NAMES;}\n",
            .name = "f",
            .pretty = "void f()",
        },
        {
            .label = "record tag names",
            .source = "struct S{int x;}; void f(struct S s){NAMES;}\n",
            .name = "f",
            .pretty = "void f(struct S)",
        },
        {
            .label = "typedef already contains const",
            .source = "typedef const int CI; CI f(CI x,volatile CI y){NAMES;return x;}\n",
            .name = "f",
            .pretty = "CI f(CI, volatile CI)",
        },
        {
            .label = "typeof type and expression source spelling",
            .source = "typedef int I; typeof(I) f(typeof(I) x,typeof(1) y){NAMES;return x;}\n",
            .name = "f",
            .pretty = "typeof(I) f(typeof(I), typeof (1))",
        },
        {
            .label = "atomic types",
            .source = "_Atomic(int) f(_Atomic(int) x){NAMES;return 0;}\n",
            .name = "f",
            .pretty = "_Atomic(int) f(_Atomic(int))",
        },
        {
            .label = "typeof expression operator formatting",
            .source = "int x; typeof(sizeof x) f(typeof(1?2:3) y){NAMES;return y;}\n",
            .name = "f",
            .pretty = "typeof (sizeof x) f(typeof (1 ? 2 : 3))",
        },
        {
            .label = "attributes do not become signature suffixes",
            .source = "__attribute__((visibility(\"hidden\"))) int f(int x) __attribute__((nonnull)){NAMES;return x;}\n",
            .name = "f",
            .pretty = "int f(int)",
        },
        {
            .label = "macro-produced function identifier",
            .source = "#define JOIN(a,b) a##b\nint JOIN(macro_,function)(void){NAMES;return 0;}\n",
            .name = "macro_function",
            .pretty = "int macro_function(void)",
        },
        {
            .label = "body typedef shadow does not alter header spelling",
            .source = "typedef int I; I f(I x){typedef long I;NAMES;return x;}\n",
            .name = "f",
            .pretty = "I f(I)",
        },
    };
assert(sizeof("plain prototype")-1==strlen("plain prototype"));
assert(sizeof("int f(void){NAMES;return 0;}\n")-1==strlen("int f(void){NAMES;return 0;}\n"));
assert(sizeof("f")-1==strlen("f"));
assert(sizeof("int f(void)")-1==strlen("int f(void)"));
assert(sizeof("typedef return and parameter spelling")-1==strlen("typedef return and parameter spelling"));
assert(sizeof("typedef int I; I f(I x){NAMES;return x;}\n")-1==strlen("typedef int I; I f(I x){NAMES;return x;}\n"));
assert(sizeof("f")-1==strlen("f"));
assert(sizeof("I f(I)")-1==strlen("I f(I)"));
assert(sizeof("canonical scalar spelling and parameter qualifiers")-1==strlen("canonical scalar spelling and parameter qualifiers"));
assert(sizeof("static inline unsigned long int f(signed int x, volatile const int y){NAMES;return x+y;}\n")-1==strlen("static inline unsigned long int f(signed int x, volatile const int y){NAMES;return x+y;}\n"));
assert(sizeof("f")-1==strlen("f"));
assert(sizeof("unsigned long f(int, const volatile int)")-1==strlen("unsigned long f(int, const volatile int)"));
assert(sizeof("qualified pointer typedef and explicit pointers")-1==strlen("qualified pointer typedef and explicit pointers"));
assert(sizeof("typedef int I; typedef int *P; P f(const P p,I *q,const I *r,I *const s){NAMES;return p;}\n")-1==strlen("typedef int I; typedef int *P; P f(const P p,I *q,const I *r,I *const s){NAMES;return p;}\n"));
assert(sizeof("f")-1==strlen("f"));
assert(sizeof("P f(const P, I *, const I *, I *const)")-1==strlen("P f(const P, I *, const I *, I *const)"));
assert(sizeof("array parameter adjustment drops outer alias")-1==strlen("array parameter adjustment drops outer alias"));
assert(sizeof("typedef int A[4]; int f(A a,int b[const static 4],const int c[3]){NAMES;return 0;}\n")-1==strlen("typedef int A[4]; int f(A a,int b[const static 4],const int c[3]){NAMES;return 0;}\n"));
assert(sizeof("f")-1==strlen("f"));
assert(sizeof("int f(int *, int *const, const int *)")-1==strlen("int f(int *, int *const, const int *)"));
assert(sizeof("nested callbacks retain occurrence-specific aliases")-1==strlen("nested callbacks retain occurrence-specific aliases"));
assert(sizeof("typedef int I; typedef int F(int); int f(F a,F *b,I (*c)(I),I (*(*d)(I))(I)){NAMES;return 0;}\n")-1==strlen("typedef int I; typedef int F(int); int f(F a,F *b,I (*c)(I),I (*(*d)(I))(I)){NAMES;return 0;}\n"));
assert(sizeof("f")-1==strlen("f"));
assert(sizeof("int f(F *, F *, I (*)(I), I (*(*)(I))(I))")-1==strlen("int f(F *, F *, I (*)(I), I (*(*)(I))(I))"));
assert(sizeof("callback unnamed qualifiers and pointer to array alias")-1==strlen("callback unnamed qualifiers and pointer to array alias"));
assert(sizeof("typedef int I; typedef int A[4]; typedef int *P; void f(int (*cb)(const int,const I,I *const,const P),A *p,const A *q){NAMES;}\n")-1==strlen("typedef int I; typedef int A[4]; typedef int *P; void f(int (*cb)(const int,const I,I *const,const P),A *p,const A *q){NAMES;}\n"));
assert(sizeof("f")-1==strlen("f"));
assert(sizeof("void f(int (*)(const int, const I, I *const, const P), A *, const A *)")-1==strlen("void f(int (*)(const int, const I, I *const, const P), A *, const A *)"));
assert(sizeof("function returning function pointer")-1==strlen("function returning function pointer"));
assert(sizeof("int (*f(void))(int){NAMES;return 0;}\n")-1==strlen("int (*f(void))(int){NAMES;return 0;}\n"));
assert(sizeof("f")-1==strlen("f"));
assert(sizeof("int (*f(void))(int)")-1==strlen("int (*f(void))(int)"));
assert(sizeof("function returning array pointer")-1==strlen("function returning array pointer"));
assert(sizeof("int (*f(void))[4]{NAMES;return 0;}\n")-1==strlen("int (*f(void))[4]{NAMES;return 0;}\n"));
assert(sizeof("f")-1==strlen("f"));
assert(sizeof("int (*f(void))[4]")-1==strlen("int (*f(void))[4]"));
assert(sizeof("distinct return and nested parameter typedef occurrences")-1==strlen("distinct return and nested parameter typedef occurrences"));
assert(sizeof("typedef int I; typedef int J; I (*f(J (*x)(I)))(J){NAMES;return 0;}\n")-1==strlen("typedef int I; typedef int J; I (*f(J (*x)(I)))(J){NAMES;return 0;}\n"));
assert(sizeof("f")-1==strlen("f"));
assert(sizeof("I (*f(J (*)(I)))(J)")-1==strlen("I (*f(J (*)(I)))(J)"));
assert(sizeof("variadic alias")-1==strlen("variadic alias"));
assert(sizeof("typedef int I; int f(I x,...){NAMES;return x;}\n")-1==strlen("typedef int I; int f(I x,...){NAMES;return x;}\n"));
assert(sizeof("f")-1==strlen("f"));
assert(sizeof("int f(I, ...)")-1==strlen("int f(I, ...)"));
assert(sizeof("unprototyped definition")-1==strlen("unprototyped definition"));
assert(sizeof("void f(){NAMES;}\n")-1==strlen("void f(){NAMES;}\n"));
assert(sizeof("f")-1==strlen("f"));
assert(sizeof("void f()")-1==strlen("void f()"));
assert(sizeof("record tag names")-1==strlen("record tag names"));
assert(sizeof("struct S{int x;}; void f(struct S s){NAMES;}\n")-1==strlen("struct S{int x;}; void f(struct S s){NAMES;}\n"));
assert(sizeof("f")-1==strlen("f"));
assert(sizeof("void f(struct S)")-1==strlen("void f(struct S)"));
assert(sizeof("typedef already contains const")-1==strlen("typedef already contains const"));
assert(sizeof("typedef const int CI; CI f(CI x,volatile CI y){NAMES;return x;}\n")-1==strlen("typedef const int CI; CI f(CI x,volatile CI y){NAMES;return x;}\n"));
assert(sizeof("f")-1==strlen("f"));
assert(sizeof("CI f(CI, volatile CI)")-1==strlen("CI f(CI, volatile CI)"));
assert(sizeof("typeof type and expression source spelling")-1==strlen("typeof type and expression source spelling"));
assert(sizeof("typedef int I; typeof(I) f(typeof(I) x,typeof(1) y){NAMES;return x;}\n")-1==strlen("typedef int I; typeof(I) f(typeof(I) x,typeof(1) y){NAMES;return x;}\n"));
assert(sizeof("f")-1==strlen("f"));
assert(sizeof("typeof(I) f(typeof(I), typeof (1))")-1==strlen("typeof(I) f(typeof(I), typeof (1))"));
assert(sizeof("atomic types")-1==strlen("atomic types"));
assert(sizeof("_Atomic(int) f(_Atomic(int) x){NAMES;return 0;}\n")-1==strlen("_Atomic(int) f(_Atomic(int) x){NAMES;return 0;}\n"));
assert(sizeof("f")-1==strlen("f"));
assert(sizeof("_Atomic(int) f(_Atomic(int))")-1==strlen("_Atomic(int) f(_Atomic(int))"));
assert(sizeof("typeof expression operator formatting")-1==strlen("typeof expression operator formatting"));
assert(sizeof("int x; typeof(sizeof x) f(typeof(1?2:3) y){NAMES;return y;}\n")-1==strlen("int x; typeof(sizeof x) f(typeof(1?2:3) y){NAMES;return y;}\n"));
assert(sizeof("f")-1==strlen("f"));
assert(sizeof("typeof (sizeof x) f(typeof (1 ? 2 : 3))")-1==strlen("typeof (sizeof x) f(typeof (1 ? 2 : 3))"));
assert(sizeof("attributes do not become signature suffixes")-1==strlen("attributes do not become signature suffixes"));
assert(sizeof("__attribute__((visibility(\"hidden\"))) int f(int x) __attribute__((nonnull)){NAMES;return x;}\n")-1==strlen("__attribute__((visibility(\"hidden\"))) int f(int x) __attribute__((nonnull)){NAMES;return x;}\n"));
assert(sizeof("f")-1==strlen("f"));
assert(sizeof("int f(int)")-1==strlen("int f(int)"));
assert(sizeof("macro-produced function identifier")-1==strlen("macro-produced function identifier"));
assert(sizeof("#define JOIN(a,b) a##b\nint JOIN(macro_,function)(void){NAMES;return 0;}\n")-1==strlen("#define JOIN(a,b) a##b\nint JOIN(macro_,function)(void){NAMES;return 0;}\n"));
assert(sizeof("macro_function")-1==strlen("macro_function"));
assert(sizeof("int macro_function(void)")-1==strlen("int macro_function(void)"));
assert(sizeof("body typedef shadow does not alter header spelling")-1==strlen("body typedef shadow does not alter header spelling"));
assert(sizeof("typedef int I; I f(I x){typedef long I;NAMES;return x;}\n")-1==strlen("typedef int I; I f(I x){typedef long I;NAMES;return x;}\n"));
assert(sizeof("f")-1==strlen("f"));
assert(sizeof("I f(I)")-1==strlen("I f(I)"));
for(size_t i=0;i<sizeof fixtures/sizeof *fixtures;i++){const CheckFunctionNameFixture*f=fixtures+i;const char*fields[]={f->label,f->source,f->name,f->pretty};for(int k=0;k<4;k++){unsigned n=strlen(fields[k]);assert(fwrite(&n,4,1,stdout)==1);assert(fwrite(fields[k],1,n,stdout)==n);}}}