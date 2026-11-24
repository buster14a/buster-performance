#define BUSTER_CHECK_TEST_STDC_DECLARATIONS \
    "unsigned int stdc_leading_zeros_uc(unsigned char);\nunsigned int stdc_count_ones_us(unsigned short);\n" \
    "unsigned int stdc_bit_width_ui(unsigned int);\nunsigned long stdc_bit_floor_ul(unsigned long);\n" \
    "_Bool stdc_has_single_bit_ull(unsigned long long);\nunsigned char stdc_bit_ceil_uc(unsigned char);\n" \
    "unsigned int stdc_trailing_zeros_ull(unsigned long long);\nunsigned int stdc_first_leading_one_ul(unsigned long);\n"
#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <assert.h>
#include <string.h>
#include <stdbool.h>
typedef void TypeCapacity;
typedef struct CheckSourceFixture CheckSourceFixture;
struct CheckSourceFixture
{
    const char* name;
    const char* source;
    bool rejected;
    bool unsupported;
    bool extension;
    // The C standard both sides check it in, GNU's dialect of it: 0 for gnu17, or 2023 for gnu23.
    uint32_t standard;
    // Whether both sides check it with plain char unsigned (-funsigned-char).
    bool char_unsigned;
    // An unsupported fixture that clang rejects, as what this can't decide: an error, or valid code whose own error comes
    // later. Its refusal is no later than clang's first error.
    bool undecided;
    // The type table's room, for a fixture larger than check_test_types_open's; null for that.
    const TypeCapacity* capacity;
    // Whether the reader must make the unit overload tables (CHECK_TEST_OVERLOAD_TABLES) or none (CHECK_TEST_OVERLOAD_NONE),
    // on both paths: a name of the overloadable attribute's counts only inside an attribute list (#1038). 0 checks neither.
    uint8_t overload_tables;
};

enum
{
    CHECK_TEST_OVERLOAD_TABLES = 1,
    CHECK_TEST_OVERLOAD_NONE = 2,
};


void put(const char*p){uint32_t n=strlen(p);assert(fwrite(&n,4,1,stdout)==1);assert(fwrite(p,1,n,stdout)==n);}
int main(void){
{ const CheckSourceFixture rows[]={
        {
            .name = "half arithmetic in required constant expressions",
            .source = "_Float16 h=(_Float16)1+(_Float16)2; __bf16 b=(__bf16)1+(__bf16)2;"
                      "_Static_assert((_Float16)1+(_Float16)2==3,\"half sum\");"
                      "_Static_assert((__bf16)1+(__bf16)2==3,\"bf16 sum\");"
                      "_Static_assert((_Float16)7-(_Float16)2==5,\"half difference\");"
                      "_Static_assert((__bf16)7-(__bf16)2==5,\"bf16 difference\");"
                      "_Static_assert((_Float16)3*(_Float16)2==6,\"half product\");"
                      "_Static_assert((__bf16)3*(__bf16)2==6,\"bf16 product\");"
                      "_Static_assert((_Float16)1/(_Float16)3==(_Float16)0x1.554p-2,\"half quotient\");"
                      "_Static_assert((__bf16)1/(__bf16)3==(__bf16)0x1.56p-2,\"bf16 quotient\");\n",
        },
        {
            .name = "half constants round each operation before the next",
            .source = "_Static_assert(((_Float16)2048+(_Float16)1)-(_Float16)2048==0,\"half midpoint\");"
                      "_Static_assert(((__bf16)256+(__bf16)1)-(__bf16)256==0,\"bf16 midpoint\");"
                      "_Static_assert((_Float16)0x1p-24+(_Float16)0x1p-24==(_Float16)0x1p-23,\"half subnormal\");"
                      "_Static_assert((__bf16)0x1p-133+(__bf16)0x1p-133==(__bf16)0x1p-132,\"bf16 subnormal\");\n",
        },
        {
            .name = "half invalid constant arithmetic has Clang NaN signs",
            // Declaration-time bit casts currently certify integer sources only. Classifiers observe the
            // floating result here; action and native-program tests independently check its exact raw bits.
            .source = "_Static_assert(__builtin_isnan((_Float16)__builtin_inf()+(_Float16)-__builtin_inf()) && "
                      "!__builtin_signbit((_Float16)__builtin_inf()+(_Float16)-__builtin_inf()),\"half NaN\");"
                      "_Static_assert(__builtin_isnan((__bf16)__builtin_inf()+(__bf16)-__builtin_inf()) && "
                      "!__builtin_signbit((__bf16)__builtin_inf()+(__bf16)-__builtin_inf()),\"bf16 NaN\");\n",
        },
        {
            // The host's SSE and x87 give a negative NaN for each of these and may take either NaN operand (#1473).
            .name = "real invalid constant arithmetic has Clang NaN signs",
            .source = "_Static_assert(__builtin_isnan(__builtin_inff()+-__builtin_inff()) && "
                      "!__builtin_signbit(__builtin_inff()+-__builtin_inff()),\"float sum NaN\");"
                      "_Static_assert(!__builtin_signbit(0.0f*__builtin_inff()) && !__builtin_signbit(0.0f/0.0f),\"float NaN\");"
                      "_Static_assert(!__builtin_signbit(__builtin_inf()-__builtin_inf()) && !__builtin_signbit(0.0*-__builtin_inf()),\"double NaN\");"
                      "_Static_assert(!__builtin_signbit(0.0/-0.0) && !__builtin_signbit(-__builtin_inf()/__builtin_inf()),\"double quotient NaN\");"
                      "_Static_assert(!__builtin_signbit(__builtin_infl()+-__builtin_infl()) && !__builtin_signbit(0.0L/0.0L),\"long double NaN\");"
                      "_Static_assert(__builtin_signbit(-(__builtin_inf()-__builtin_inf())) && __builtin_signbit(1.0-(-__builtin_nan(\"\"))),\"NaN signs\");"
                      "_Static_assert(__builtin_signbit(-__builtin_nan(\"\")+__builtin_nan(\"\")) && "
                      "!__builtin_signbit(__builtin_nanl(\"\")*-__builtin_nanl(\"\")),\"first NaN operand\");\n",
        },
        { .name = "deep selected choose expressions", .source = "@nested-selections-0" },
        { .name = "deep unselected choose expressions", .source = "@nested-selections-1" },
        { .name = "deep selected generic expressions", .source = "@nested-selections-2" },
        { .name = "deep unselected generic expressions", .source = "@nested-selections-3" },
        {
            .name = "nested selections retain prefix, infix and comma roots",
            .source = "enum { A=__builtin_choose_expr(1,-(2+3),0), B=_Generic(0,int:2*3+1,default:0), C=__builtin_choose_expr(0,0,_Generic(0,int:(2,7),default:0)) }; _Static_assert(A==-5 && B==7 && C==7,\"selection roots\");\n",
        },
        {
            .name = "nested selections retain vector values and lvalues",
            .source = "typedef int V __attribute__((vector_size(16))); V a,b; V f(void){return _Generic(0,int:__builtin_choose_expr(1,a,b),default:b);} int g(void){_Generic(0,int:__builtin_choose_expr(0,b,a),default:b)[0]=9; return a[0];}\n",
        },
        {
            .name = "unselected nested operands remain type checked in source order",
            .source = "int f(void){return __builtin_choose_expr(1,7,_Generic(0,int:missing,default:0));}\n",
            .rejected = true,
        },
        { .name = "bitcast declaration integer representation", .source = "enum { N=__builtin_bit_cast(int,0xffffffffu), P=__builtin_bit_cast(unsigned, -1) }; _Static_assert(N==-1 && P==0xffffffffu,\"integer representation\");\n" },
        { .name = "bitcast raw attribute is not an integer constant expression", .source = "typedef int T [[gnu::aligned(__builtin_bit_cast(unsigned,16))]];\n", .rejected = true },
        { .name = "bitcast half operand is not promoted", .source = "__fp16 x; enum { N=sizeof(__builtin_bit_cast(unsigned short,x)), M=sizeof(__builtin_bit_cast(__fp16,(unsigned short)0x3c00)) }; _Static_assert(N==2 && M==2,\"half representation\");\n" },
        { .name = "bitcast raw array operand is not decayed", .source = "int a[2]; enum { N=sizeof(__builtin_bit_cast(int[2],a)) }; _Static_assert(N==8,\"array representation\");\n" },
        { .name = "bitcast rejects mismatched raw sizes", .source = "enum { N=sizeof(__builtin_bit_cast(long,1)) };\n", .rejected = true },
        { .name = "bitcast rejects atomic source storage", .source = "_Atomic(int) x; enum { N=sizeof(__builtin_bit_cast(int,x)) };\n", .rejected = true },
        { .name = "bitcast rejects evaluated invalid bool representation", .source = "enum { N=__builtin_bit_cast(_Bool,(unsigned char)2) };\n", .rejected = true },
        { .name = "bitcast destination nested type job", .source = "enum { N=__builtin_bit_cast(__typeof__(__builtin_bit_cast(unsigned,1)),16) }; _Static_assert(N==16,\"nested bitcast\");\n" },
        { .name = "abstract function ABI prefix and grouped attributes", .source = "typedef int (__attribute__((ms_abi)) *M)(int); _Static_assert(__builtin_types_compatible_p(M,int __attribute__((ms_abi)) (*)(int)),\"prefix\"); typedef int (*N)(int) __attribute__((ms_abi)); _Static_assert(__builtin_types_compatible_p(M,N),\"suffix\"); _Static_assert(!__builtin_types_compatible_p(M,int(*)(int)),\"distinct ABI\");\n" },
        { .name = "abstract function ABI raw cast context", .source = "#define O __attribute__((overloadable))\nint f(int) O __attribute__((ms_abi)); double f(double) O; typedef int T [[gnu::aligned(sizeof((int (__attribute__((ms_abi)) *)(int))f))]]; _Static_assert(_Alignof(T)==8,\"raw ABI target\");\n" },
        { .name = "abstract function ABI preserves explicit typedef conflict", .source = "typedef int F(int) __attribute__((sysv_abi)); enum { N=sizeof(F __attribute__((ms_abi)) *) };\n", .rejected = true },
        { .name = "half storage type in declaration query", .source = "enum { N=sizeof(__fp16) }; _Static_assert(N==2,\"half storage\"); typedef int T [[gnu::aligned(sizeof(__fp16))]]; _Static_assert(_Alignof(T)==2,\"raw half\");\n" },
        { .name = "raw abstract function pointer query", .source = "typedef int T [[gnu::aligned(sizeof(int(*)(int)))]]; _Static_assert(_Alignof(T)==8,\"raw function pointer\");\n" },
        { .name = "raw abstract function query", .source = "typedef int T [[gnu::aligned(sizeof(int(int)))]]; _Static_assert(_Alignof(T)==1,\"raw function\");\n" },
        { .name = "constant query saturates floating casts only in proof", .source = "enum { A=__builtin_constant_p((int)1.0e100), B=__builtin_constant_p((int)1.0e100+1), C=__builtin_constant_p((unsigned)-1.0e100), D=__builtin_constant_p((int)__builtin_nan(\"\")), E=__builtin_constant_p(__builtin_popcount((int)1.0e100)), F=__builtin_constant_p(1?(int)1.0e100:0), G=__builtin_constant_p(_Generic(0,int:(int)1.0e100,default:0)), H=__builtin_constant_p((__int128)1.0e100+1) }; _Static_assert(A&&B&&C&&D&&E&&F&&G&&H,\"proof\"); int g(int x){_Static_assert(!__builtin_constant_p(x+++(int)1.0e100),\"effects\");return x;}\n" },
        { .name = "raw constant query proof propagates saturated conversion", .source = "typedef int T [[gnu::aligned(__builtin_constant_p((int)1.0e100+1)*16)]]; _Static_assert(_Alignof(T)==16,\"raw proof\");\n" },
        { .name = "overloaded argument cannot hide inside folded query", .source = "#define O __attribute__((overloadable))\nint f(int) O; double f(double) O;\n_Static_assert(__builtin_types_compatible_p(__typeof__(__builtin_constant_p(f)),int),\"ambiguous\");\n", .rejected = true },
        { .name = "earlier incomplete query precedes later missing name", .source = "struct S { char bytes[sizeof(struct Missing) -\nsizeof(missing)]; };\n", .rejected = true },
        { .name = "earlier missing name precedes later incomplete query", .source = "struct S { char bytes[sizeof(missing) -\nsizeof(struct Missing)]; };\n", .rejected = true },
        { .name = "raw earlier incomplete query precedes later missing name", .source = "typedef int T [[gnu::aligned(sizeof(struct Missing) +\nsizeof(missing))]];\n", .rejected = true },
        {
            .name = "declaration vector builtin exact type queries",
            .source = "typedef int I4 __attribute__((vector_size(16))); typedef float F4 __attribute__((vector_size(16))); I4 a; __typeof__(__builtin_convertvector(a,F4)) b; enum { N=sizeof(__builtin_elementwise_abs(a)), R=sizeof(__builtin_reduce_add(a)), C=sizeof(__builtin_convertvector(a,F4)) }; _Static_assert(N==16 && R==4 && C==16 && __builtin_types_compatible_p(__typeof__(b),F4), \"vector builtin types\");\n",
        },
        {
            .name = "declaration vector conversion nested destination query",
            .source = "typedef int I4 __attribute__((vector_size(16))); typedef float F4 __attribute__((vector_size(16))); I4 a; enum { N=sizeof(__builtin_convertvector(a,__typeof__(__builtin_convertvector(a,F4)))) }; _Static_assert(N==16, \"nested destination type job\");\n",
        },
        {
            .name = "declaration vector conversion attributed abstract destination",
            .source = "typedef int V __attribute__((vector_size(16))); V a; enum { N=sizeof(__builtin_convertvector(a,float __attribute__((vector_size(16))))) }; typedef int T [[gnu::aligned(sizeof(__builtin_convertvector(a,float __attribute__((vector_size(16))))))]]; _Static_assert(N==16 && _Alignof(T)==16, \"abstract vector destination\");\n",
        },
        {
            .name = "declaration vector builtin arbitrary argument slice",
            .source = "@long-shuffle",
        },
        {
            .name = "declaration vector shuffle GNU lexical index",
            .source = "typedef int V __attribute__((vector_size(16))); V a; enum { N=sizeof(__builtin_shufflevector(a,a,(2147483647+1)<0,1,2,3)) }; typedef int T [[gnu::aligned(sizeof(__builtin_shufflevector(a,a,(2147483647+1)<0,1,2,3)))]]; _Static_assert(N==16 && _Alignof(T)==16,\"GNU lexical shuffle index\");\n",
        },
        {
            .name = "raw attribute vector builtin arbitrary argument slice",
            .source = "@raw-shuffle",
        },
        {
            .name = "raw attribute vector builtin destination type",
            .source = "typedef int I4 __attribute__((vector_size(16))); typedef float F4 __attribute__((vector_size(16))); I4 a; typedef int T [[gnu::aligned(sizeof(__builtin_convertvector(a,F4)))]]; _Static_assert(_Alignof(T)==16, \"raw convert destination\");\n",
        },
        {
            .name = "raw attribute nested vector builtin destination type",
            .source = "typedef int I4 __attribute__((vector_size(16))); typedef float F4 __attribute__((vector_size(16))); I4 a; typedef int T [[gnu::aligned(sizeof(__builtin_convertvector(a,__typeof__(__builtin_convertvector(a,F4)))))]]; _Static_assert(_Alignof(T)==16, \"raw nested destination\");\n",
        },
        {
            .name = "declaration vector memory builtin type query",
            .source = "typedef int V __attribute__((vector_size(16))); V a; int n; enum { A=sizeof(__builtin_nontemporal_load(&a)), B=sizeof(__builtin_nontemporal_store(a,&a)), C=sizeof(__builtin_nondeterministic_value(++n)) }; _Static_assert(A==16 && B==1 && C==4, \"vector memory types\");\n",
        },
        {
            .name = "declaration vector conversion rejects lane count mismatch",
            .source = "typedef int V __attribute__((vector_size(16))); typedef double D __attribute__((vector_size(16))); V a; enum { N=sizeof(__builtin_convertvector(a,D)) };\n",
            .rejected = true,
        },
        {
            .name = "declaration vector conversion rejects scalar destination",
            .source = "typedef int V __attribute__((vector_size(16))); V a; enum { N=sizeof(__builtin_convertvector(a,int)) };\n",
            .rejected = true,
        },
        {
            .name = "declaration vector shuffle rejects out of range lane",
            .source = "typedef int V __attribute__((vector_size(16))); V a; enum { N=sizeof(__builtin_shufflevector(a,a,0,1,2,8)) };\n",
            .rejected = true,
        },
        {
            .name = "declaration vector shuffle rejects nonconstant lane",
            .source = "typedef int V __attribute__((vector_size(16))); V a; int i; enum { N=sizeof(__builtin_shufflevector(a,a,0,1,2,i)) };\n",
            .rejected = true,
        },
        {
            .name = "declaration sizeof arithmetic",
            .source = "struct Buffer { char spare[12 * sizeof(int) - 5 * sizeof(void *)]; }; _Static_assert(sizeof(struct Buffer)==8, \"bound\");\n",
        },
        {
            .name = "deeply nested tag attribute queries",
            .source = "@nested-attributes",
        },
        {
            .name = "tag attribute source ordered identity",
            .source = "enum { A=8, N=sizeof(struct __attribute__((aligned(A))) S*) }; _Static_assert(N==8, \"tag activation after attribute use\");\n",
        },
        {
            .name = "tag attribute nested new identity",
            .source = "enum { N=sizeof(struct __attribute__((aligned(sizeof(struct S*)))) S*) }; _Static_assert(N==8, \"nested tag identity\");\n",
        },
        {
            .name = "tag attribute invalid alignment",
            .source = "struct S { int x; }; enum { N=sizeof(struct __attribute__((aligned(3))) S) };\n",
            .rejected = true,
        },
        {
            .name = "tag attribute evaluated fault",
            .source = "struct S { int x; }; enum { N=sizeof(struct __attribute__((aligned(1/0))) S) };\n",
            .rejected = true,
        },
        {
            .name = "raw attribute nested tag query jobs",
            .source = "struct S { long x; }; typedef int T [[gnu::aligned(sizeof(struct __attribute__((aligned(sizeof(struct S)))) S))]]; _Static_assert(_Alignof(T)==8, \"raw nested tag attributes\");\n",
        },
        {
            .name = "nested type array bound",
            .source = "enum { N=sizeof(int[2+sizeof(char[3])]) }; _Static_assert(N==20, \"nested\");\n",
        },
        {
            .name = "integer rank and cast in array bound",
            .source = "int a[(unsigned char)258]; _Static_assert(sizeof a==8, \"cast\");\n",
        },
        {
            .name = "real literal immediate integer cast",
            .source = "enum { N=(int)3.75 }; int a[N]; _Static_assert(sizeof a==12, \"real cast\");\n",
        },
        {
            .name = "constant type names retain repeated modifier semantics",
            .source = "enum { A=(unsigned unsigned)3, B=sizeof(short short), C=sizeof(_Complex _Complex double), D=sizeof(_Atomic _Atomic int) }; _Static_assert(A==3 && B==2 && C==16 && D==4, \"duplicate modifiers\");\n",
        },
        {
            .name = "GNU real expression folds in integer constant context",
            .source = "enum { N=(int)(1.5+2.5) };\n",
        },
        {
            .name = "declaration conditional",
            .source = "enum { N=1?7:1/0 }; int a[N]; _Static_assert(sizeof a==28, \"conditional\");\n",
        },
        {
            .name = "declaration GNU omitted conditional",
            .source = "enum { N=7?:1/0 }; int a[N]; _Static_assert(sizeof a==28, \"conditional\");\n",
        },
        {
            .name = "declaration short circuit",
            .source = "enum { N=(0 && (1/0)) + (1 || (1/0)) }; int a[N]; _Static_assert(sizeof a==4, \"short circuit\");\n",
        },
        {
            .name = "declaration evaluated fault",
            .source = "enum { N=0?7:1/0 };\n",
            .rejected = true,
        },
        {
            .name = "declaration typedef and object source order",
            .source = "typedef short T; T object; enum { N=sizeof(T)+sizeof object }; int a[N]; _Static_assert(sizeof a==16, \"bindings\");\n",
        },
        {
            .name = "declaration prior enumerator",
            .source = "enum { A=3, B=sizeof(int[A]), C=(unsigned char)B }; _Static_assert(C==12, \"enumerator\");\n",
        },
        {
            .name = "declaration future enumerator rejected",
            .source = "enum { A=sizeof(int[B]), B=3 };\n",
            .rejected = true,
        },
        {
            .name = "declaration object shadow",
            .source = "int x; void f(void) { char x; enum { N=sizeof x }; _Static_assert(N==1, \"inner\"); } enum { N=sizeof x }; _Static_assert(N==4, \"outer\");\n",
        },
        {
            .name = "declaration const object folds as a GNU enumerator value",
            .source = "const int x=2; enum { N=x };\n",
        },
        {
            .name = "declaration alignof callback array",
            .source = "enum { A=_Alignof(double), B=sizeof(int (*[2])(int)) }; _Static_assert(A==8 && B==16, \"types\");\n",
        },
        {
            .name = "declaration sizeof object expressions",
            .source = "struct S { int a[3]; }; struct S s; int f(int); enum { A=sizeof s.a[1], B=sizeof f(3), C=sizeof(1/0) }; _Static_assert(A+B+C==12, \"unevaluated\");\n",
        },
        {
            .name = "declaration GNU void and function queries",
            .source = "int f(void); enum { A=sizeof(void), B=sizeof f, C=__alignof__(void), D=__alignof__(f) }; _Static_assert(A==1 && B==1 && C==1 && D==4, \"GNU queries\");\n",
        },
        {
            .name = "declaration sizeof pointer member",
            .source = "struct S { int a[3]; }; enum { A=sizeof(((struct S*)0)->a) }; _Static_assert(A==12, \"member\");\n",
        },
        {
            .name = "declaration sizeof comma expression",
            .source = "enum { A=sizeof((1,2.0)) }; _Static_assert(A==8, \"comma\");\n",
        },
        {
            .name = "declaration unknown sizeof object",
            .source = "enum { A=sizeof missing };\n",
            .rejected = true,
        },
        {
            .name = "declaration string query",
            .source = "enum { A=sizeof(\"ab\" \"cd\"), B=sizeof(L\"hi\"), C=sizeof(u\"hi\") }; _Static_assert(A==5 && B==12 && C==6, \"strings\");\n",
        },
        {
            .name = "declaration bit field sizeof rejected",
            .source = "struct S { int x:3; }; struct S s; enum { A=sizeof s.x };\n",
            .rejected = true,
        },
        {
            .name = "declaration object alignment",
            .source = "int x __attribute__((aligned(32))); enum { A=__alignof__(x), B=__alignof__((x)) }; _Static_assert(A==32 && B==32, \"object alignment\");\n",
        },
        {
            .name = "declaration bit field alignof rejected",
            .source = "struct S { int x:3; }; struct S s; enum { A=__alignof__(s.x) };\n",
            .rejected = true,
        },
        {
            .name = "declaration incomplete sizeof rejected",
            .source = "struct S; enum { A=sizeof(struct S) };\n",
            .rejected = true,
        },
        {
            .name = "declaration type compatibility",
            .source = "typedef int I; enum { A=__builtin_types_compatible_p(const I,int), B=__builtin_types_compatible_p(int*,const int*) }; _Static_assert(A==1 && B==0, \"compatibility\");\n",
        },
        {
            .name = "declaration nested typeof",
            .source = "int x; enum { A=sizeof(__typeof__(x)), B=sizeof(__typeof__(int[3])), C=sizeof(__typeof__((x+1))) }; _Static_assert(A==4 && B==12 && C==4, \"typeof\");\n",
        },
        {
            .name = "declaration typeof preserves array",
            .source = "int a[3]; enum { N=sizeof(__typeof__(a)) }; _Static_assert(N==12, \"typeof array\");\n",
        },
        {
            .name = "declaration typeof compound literal immediate queries",
            .source = "typedef float vf __attribute__((vector_size(16)));\n"
                      "_Static_assert(__builtin_types_compatible_p(__typeof__((vf){0}), vf), \"vector\");\n"
                      "struct S { int x; };\n"
                      "_Static_assert(__builtin_types_compatible_p(typeof((struct S){0}), struct S), \"record\");\n"
                      "enum { N=sizeof(__typeof__((int[2]){0})) }; _Static_assert(N==2*sizeof(int), \"array\");\n",
        },
        {
            .name = "declaration typeof nested in a compound literal type",
            .source = "struct S { int x; };\n"
                      "int f(void) { __typeof__((__typeof__((struct S){0})){1}) s = {2}; return s.x; }\n"
                      "int g(void) { __typeof__((__typeof__((int){0})){1}) x = 1; return x; }\n",
        },
        {
            .name = "declaration typeof compound literal member query",
            .source = "struct S { long x; };\n"
                      "enum { N=sizeof(__typeof__(((struct S){0}).x)) }; _Static_assert(N==sizeof(long), \"compound member\");\n",
        },
        {
            .name = "declaration typeof compound literal function type rejected",
            .source = "enum { N=sizeof(__typeof__((int(void)){0})) };\n",
            .rejected = true,
        },
        {
            .name = "declaration typeof compound literal variable array rejected",
            .source = "int f(int n) { return sizeof(__typeof__((int[n]){0})); }\n",
            .rejected = true,
        },
        {
            .name = "typeof statement expression effects are unevaluated",
            .source = "int f(int n) { int x=0; __typeof__(({x+=50;n;})) t=1; _Static_assert(sizeof t==sizeof n, \"statement result\"); return x+t; }\n",
        },
        {
            .name = "nested statement expression type query",
            .source = "int f(int n) { __typeof__(({({n;});})) t=1; _Static_assert(sizeof t==sizeof n, \"nested statement result\"); return t; }\n",
        },
        {
            .name = "statement expression local declaration type query",
            .source = "int f(int n) { __typeof__(({int x=n; x;})) t=1; _Static_assert(sizeof t==sizeof n, \"local result\"); return t; }\n",
        },
        {
            .name = "statement expression multiple declarator type query",
            .source = "int f(int n) { __typeof__(({int x=n,y=x+1; y;})) t=1; return t; }\n",
        },
        {
            .name = "statement expression nested declaration type query",
            .source = "int f(int n) { __typeof__(({int x=n; __typeof__(({long y=x; y;})) z=1; z;})) t=1; _Static_assert(sizeof t==sizeof(long), \"nested local result\"); return t; }\n",
        },
        {
            .name = "statement expression aggregate declaration type query",
            .source = "int f(int n) { __typeof__(({int x[2]={n,n+1}; x[0];})) t=1; return t; }\n",
        },
        {
            .name = "statement expression control type query",
            .source = "int f(int n) { __typeof__(({int x=n; if(x){x++;} else x--; while(x)x--; x;})) t=1; return t; }\n",
        },
        {
            .name = "statement expression loop type query",
            .source = "int f(int n) { __typeof__(({int x=n; for(int i=0;i<2;i++)x++; do { x--; } while(x); x;})) t=1; return t; }\n",
        },
        {
            .name = "statement expression nested block type query",
            .source = "int f(int n) { __typeof__(({int x=n; {int y=x; x=y;} x;})) t=1; return t; }\n",
        },
        {
            .name = "statement expression control constraints remain checked",
            .source = "struct S{int x;}; int f(void) { __typeof__(({struct S s; if(s){} 1;})) t=1; return t; }\n",
            .rejected = true,
        },
        {
            .name = "statement expression final declaration has void type",
            .source = "int f(int n) { __typeof__(({int x=n;})) t; return 0; }\n",
            .rejected = true,
        },
        {
            .name = "statement expression initializer constraints remain checked",
            .source = "int f(void) { __typeof__(({int *x=1; x;})) t=0; return 0; }\n",
            .rejected = true,
        },
        {
            .name = "statement expression initializer reports its actual line",
            .source = "int f(void) {\n __typeof__(({\n int *x=1;\n x;\n })) t=0;\n return 0;\n}\n",
            .rejected = true,
        },
        {
            .name = "statement expression size is constant",
            .source = "void f(int n) { enum { N=sizeof(({n++;n;})) }; _Static_assert(N==sizeof n, \"unevaluated statement size\"); }\n",
        },
        {
            .name = "GNU statement expression folds in integer constant context",
            .source = "void f(void) { enum { N=({3;}) }; }\n",
        },
        {
            .name = "declaration atomic type names",
            .source = "enum { A=sizeof(_Atomic(int)), B=sizeof(_Atomic int), C=sizeof(const _Atomic(int)), D=sizeof(int * _Atomic) }; _Static_assert(A==4 && B==4 && C==4 && D==8, \"atomic\");\n",
        },
        {
            .name = "declaration invalid atomic type",
            .source = "enum { A=sizeof(_Atomic(const int)) };\n",
            .rejected = true,
        },
        {
            .name = "declaration complex type names",
            .source = "enum { A=sizeof(double _Complex), B=sizeof(_Complex), C=sizeof(long double _Complex), D=sizeof(_Complex long) }; _Static_assert(A==16 && B==16 && C==32 && D==16, \"complex\");\n",
        },
        {
            .name = "declaration bit integer type name",
            .source = "enum { A=sizeof(unsigned _BitInt(17)), B=sizeof(_BitInt(1+16)), C=sizeof(unsigned _BitInt(1)) }; _Static_assert(A==4 && B==4 && C==1, \"bit int\");\n",
        },
        {
            .name = "declaration named callback type",
            .source = "enum { A=sizeof(int (*)(register int x,int y)) }; _Static_assert(A==8, \"callback\");\n",
        },
        {
            .name = "declaration duplicate callback parameter",
            .source = "enum { A=sizeof(int (*)(int x,int x)) };\n",
            .rejected = true,
        },
        {
            .name = "type name duplicate separated by unnamed parameters",
            .source = "enum { A=sizeof(int (*)(int x,int,int,int x)) };\n",
            .rejected = true,
        },
        {
            .name = "type name nested prototypes reuse outer names",
            .source = "enum { A=sizeof(int (*)(int x,int (*cb)(int x,int y),int y)) }; _Static_assert(A==8,\"nested scopes\");\n",
        },
        {
            .name = "type name sibling prototypes reuse names",
            .source = "enum { A=sizeof(int (*)(int (*a)(int x,int y),int (*b)(int x,int y))) }; _Static_assert(A==8,\"sibling scopes\");\n",
        },
        {
            .name = "type name outer duplicate survives nested prototype",
            .source = "enum { A=sizeof(int (*)(int x,int (*cb)(int x),int x)) };\n",
            .rejected = true,
        },
        {
            .name = "type name nested prototype duplicate",
            .source = "enum { A=sizeof(int (*)(int x,int (*cb)(int y,int y),int z)) };\n",
            .rejected = true,
        },
        {
            .name = "separate type names reuse prototype names",
            .source = "enum { A=sizeof(int (*)(int x,int y))+sizeof(int (*)(int x,int y)) }; _Static_assert(A==16,\"separate prototypes\");\n",
        },
        {
            .name = "nested type name parameter does not hide outer typedef",
            .source = "typedef int T; enum { A=sizeof(int (*)(int (*cb)(int T),T x)) }; _Static_assert(A==8,\"typedef restored\");\n",
        },
        {
            .name = "type name unnamed parameters do not collide",
            .source = "enum { A=sizeof(int (*)(int,int,int,int)) }; _Static_assert(A==8,\"unnamed parameters\");\n",
        },
        {
            .name = "type name duplicate precedes later invalid declaration",
            .source = "enum { A=sizeof(int (*)(int x,int x)) };\nint f(void){return missing;}\n",
            .rejected = true,
        },
        {
            .name = "type name invalid parameter precedes later duplicate",
            .source = "enum { A=sizeof(int (*)(void bad,\nint x,int x)) };\n",
            .rejected = true,
        },
        {
            .name = "body expression named callback type",
            .source = "unsigned long f(void){return sizeof(int (*)(int p0,int p1,int p2,int p3));}\n",
        },
        {
            .name = "declaration member offset",
            .source = "struct S { char c; int a[3]; }; enum { A=__builtin_offsetof(struct S,a[2]) }; _Static_assert(A==12, \"offset\");\n",
        },
        {
            .name = "declaration nested member offset",
            .source = "struct I { char c; int x; }; struct S { int n; struct I a[2]; }; enum { A=__builtin_offsetof(struct S,a[1].x) }; _Static_assert(A==16, \"offset\");\n",
        },
        {
            .name = "declaration bit field offsetof rejected",
            .source = "struct S { unsigned x:3; }; enum { A=__builtin_offsetof(struct S,x) };\n",
            .rejected = true,
        },
        {
            .name = "declaration missing offsetof member",
            .source = "struct S { int x; }; enum { A=__builtin_offsetof(struct S,missing) };\n",
            .rejected = true,
        },
        {
            .name = "source type compatibility builtin",
            .source = "typedef int I; _Static_assert(__builtin_types_compatible_p(const I,int), \"same\"); _Static_assert(!__builtin_types_compatible_p(int*,const int*), \"different\");\n",
        },
        {
            .name = "source member offset builtin",
            .source = "struct S { char c; int a[3]; }; _Static_assert(__builtin_offsetof(struct S,a[2])==12, \"offset\");\n",
        },
        {
            .name = "source member offset binding identity",
            .source = "enum { N=1 }; struct S { int a[3]; }; int f(void) { enum { N=2 }; return __builtin_offsetof(struct S,a[N]); } _Static_assert(__builtin_offsetof(struct S,a[N])==4, \"outer enum\");\n",
        },
        {
            .name = "source anonymous record offset retains member typedef identity",
            .source = "typedef long Time; int f(int select) { return select ? sizeof(Time) : __builtin_offsetof(struct { char c; Time value; },value); } _Static_assert(__builtin_offsetof(struct {char c; Time value;},value)==8, \"anonymous offset\");\n",
        },
        {
            .name = "source anonymous record offset retains nested layout",
            .source = "typedef short Element; enum { N=3 }; _Static_assert(__builtin_offsetof(struct {char c; struct {Element a[N]; long x;} inner;},inner.x)==16, \"nested offset\");\n",
        },
        {
            .name = "initializer designator bindings remain source ordered",
            .source = "enum { A=1, B=3, V=7 }; int values[]={[A]=V,[B]=V+1}; _Static_assert(sizeof values==16, \"inferred after initializer\"); int f(void){enum {A=2,B=4}; int local[]={[A]=V,[B]=V}; return sizeof local==20;}\n",
        },
        {
            .name = "incomplete array remains incomplete inside its own initializer",
            .source = "int values[]={1,\nsizeof values};\n",
            .rejected = true,
        },
        {
            .name = "declaration iterative nested type queries",
            .source = "@nested-source",
        },
        {
            .name = "declaration generic selection",
            .source = "enum { N=_Generic(1,int:7,default:1/0) }; _Static_assert(N==7, \"generic\");\n",
        },
        {
            .name = "generic aligned nominal duplicate",
            .source = "struct S{int x;}; typedef struct S T __attribute__((aligned(16))); int f(struct S x){return _Generic(x,struct S:1,T:2);}\n",
            .rejected = true,
        },
        {
            .name = "generic enum underlying duplicate",
            .source = "enum E{E0}; enum{N=_Generic(0,enum E:1,unsigned int:2,default:0)};\n",
            .rejected = true,
        },
        {
            .name = "generic compatible record array pointers",
            .source = "struct S{int x;}; int f(void){return _Generic(0,struct S(*)[]:1,struct S(*)[3]:2,default:0);}\n",
            .rejected = true,
        },
        {
            .name = "generic compatible function pointers",
            .source = "enum{N=_Generic(0,int(*)():1,int(*)(double):2,default:0)};\n",
            .rejected = true,
        },
        {
            .name = "generic nominal qualifiers retain exact checks",
            .source = "struct S; typedef struct S *P; enum{N=_Generic((P)0,const struct S*:1,P:7)}; _Static_assert(N==7,\"selected\"); int f(P x){return _Generic(x,const struct S*:1,P:7);}\n",
        },
        {
            .name = "generic distinct pointer shapes share a nominal key",
            .source = "struct S{int x;}; int f(struct S*x){return _Generic(x,struct S*:7,struct S**:2,struct S(*)[3]:3);}\n",
        },
        {
            .name = "generic transparent function parameter duplicate",
            .source = "struct S; union U{struct S*p;void*q;} __attribute__((transparent_union)); int f(void){return _Generic(0,int(*)(union U):1,int(*)(struct S*):2,default:0);}\n",
            .rejected = true,
        },
        {
            .name = "generic later transparent attribute is inactive",
            .source = "struct S; union U{struct S*p;void*q;}; enum{N=_Generic(0,int(*)(union U):1,int(*)(struct S*):2,default:7)}; typedef union U TU __attribute__((transparent_union)); _Static_assert(N==7,\"source time\");\n",
        },
        {
            .name = "declaration nested generic selection",
            .source = "typedef short T; enum { N=_Generic((T)0,T:_Generic(1.0,double:3,default:8),default:9) }; _Static_assert(N==3, \"nested generic\");\n",
        },
        {
            .name = "declaration generic duplicate association",
            .source = "typedef int I; enum { N=_Generic(1,int:2,I:3) };\n",
            .rejected = true,
        },
        {
            .name = "declaration generic duplicate default",
            .source = "enum { N=_Generic(1,default:2,default:3) };\n",
            .rejected = true,
        },
        {
            .name = "declaration generic no match",
            .source = "enum { N=_Generic(1,double:2) };\n",
            .rejected = true,
        },
        {
            // C2y's extension, which clang takes (-Wc2y-extensions): it matches no control.
            .name = "declaration generic incomplete association",
            .source = "struct S; enum { N=_Generic(1,int:1,struct S:2,void:3) }; _Static_assert(N==1, \"int\"); struct S { int x; };\n",
        },
        {
            .name = "declaration GNU choose expression",
            .source = "enum { N=__builtin_choose_expr(1,7,1/0) }; _Static_assert(N==7, \"choose\");\n",
        },
        {
            .name = "declaration GNU choose retains wrapped ICE form",
            .source = "enum { A=__builtin_choose_expr(1<<32,7,0), B=__builtin_choose_expr(1<<-1,0,7), C=__builtin_choose_expr(2147483647+1,7,0) }; _Static_assert(A==7 && B==7 && C==7, \"wrapped ICE\");\n",
        },
        {
            .name = "declaration GNU choose rejects computed floating cast",
            .source = "enum { N=__builtin_choose_expr((int)(1.5+2.5),7,0) };\n",
            .rejected = true,
        },
        {
            .name = "declaration GNU choose rejects comma with wrapped integer",
            .source = "enum { N=__builtin_choose_expr((0,1<<32),7,0) };\n",
            .rejected = true,
        },
        {
            .name = "declaration GNU choose rejects statement with wrapped integer",
            .source = "void f(void) { enum { N=__builtin_choose_expr(({1<<32;}),7,0) }; }\n",
            .rejected = true,
        },
        {
            .name = "declaration GNU choose wide integer condition",
            .source = "enum { N=__builtin_choose_expr(((__int128)1<<100)|1,7,0) }; _Static_assert(N==7, \"wide condition\");\n",
        },
        {
            .name = "declaration GNU choose full-width truth oracle divergence",
            .source = "@wide-truth-source",
            .extension = true,
        },
        {
            .name = "declaration GNU choose nonconstant condition",
            .source = "int x; enum { N=__builtin_choose_expr(x,7,2) };\n",
            .rejected = true,
        },
        {
            .name = "generic exact selected lvalue",
            .source = "int x; int f(void) { _Generic(1,int:x,default:0)=3; return x; }\n",
        },
        {
            .name = "generic array and function conversion",
            .source = "int a[2]; int f(void); _Static_assert(_Generic(a,int*:1,default:0), \"array\"); _Static_assert(_Generic(f,int(*)(void):1,default:0), \"function\");\n",
        },
        {
            .name = "generic qualifier conversion",
            .source = "const int x=1; _Atomic(int) a; _Static_assert(_Generic(x,int:1,default:0), \"const\"); _Static_assert(_Generic(a,int:1,default:0), \"atomic\");\n",
        },
        {
            .name = "generic exact binding after scopes close",
            .source = "int x; int f(void) { double x; _Static_assert(_Generic(x,double:1,default:0), \"inner identity\"); return 1; } _Static_assert(_Generic(x,int:1,default:0), \"outer identity\");\n",
        },
        {
            .name = "generic source type compatibility duplicate",
            .source = "typedef int I; int f(void) { return _Generic(1,int:1,I:2); }\n",
            .rejected = true,
        },
        {
            .name = "generic source incomplete association",
            .source = "struct S; int f(void) { return _Generic(1,int:1,struct S:2,int[]:3); } struct S { int x; };\n",
        },
        {
            .name = "generic rejects invalid unselected expression",
            .source = "int f(void) { return _Generic(1,int:1,default:missing); }\n",
            .rejected = true,
        },
        {
            .name = "GNU choose exact selected array",
            .source = "int a[3]; _Static_assert(sizeof(__builtin_choose_expr(1,a,0))==12, \"array\");\n",
        },
        {
            .name = "GNU choose exact selected lvalue",
            .source = "int x; int f(void) { __builtin_choose_expr(1,x,0)=3; return x; }\n",
        },
        {
            .name = "GNU choose rejected nonconstant source condition",
            .source = "int f(int x) { return __builtin_choose_expr(x,1,2); }\n",
            .rejected = true,
        },
        {
            .name = "generic selected fault",
            .source = "_Static_assert(_Generic(1,int:1/0,default:1), \"fault\");\n",
            .rejected = true,
        },
        {
            .name = "generic unselected fault",
            .source = "_Static_assert(_Generic(1,int:1,default:1/0), \"selected\");\n",
        },
        {
            .name = "declaration integer builtin constant",
            .source = "enum { A=__builtin_popcount(7), B=__builtin_clz(1), C=__builtin_ctz(8), D=__builtin_parity(7), E=__builtin_ffs(8) }; _Static_assert(A==3 && B==31 && C==3 && D==1 && E==4, \"integer builtins\");\n",
        },
        {
            .name = "declaration builtin array bound",
            .source = "int a[__builtin_ctz(8)]; _Static_assert(sizeof a==12, \"builtin bound\");\n",
        },
        {
            .name = "declaration nested builtin constant",
            .source = "enum { A=__builtin_popcount(__builtin_bswap32(0x10203040)), B=__builtin_bswap16(0x1234) }; _Static_assert(A==5 && B==0x3412, \"nested builtin\");\n",
        },
        {
            .name = "declaration builtin converted constants",
            .source = "enum { A=__builtin_popcount(1.5), B=__builtin_popcount((1,7)) }; _Static_assert(A==1 && B==3, \"builtin conversions\");\n",
        },
        {
            .name = "declaration builtin invalid zero evaluated",
            .source = "enum { A=__builtin_ctz(0) };\n",
            .rejected = true,
        },
        {
            .name = "declaration builtin invalid zero unevaluated",
            .source = "enum { A=sizeof(__builtin_ctz(0)), B=1?3:__builtin_clz(0) }; _Static_assert(A==4 && B==3, \"builtin faults\");\n",
        },
        {
            .name = "declaration builtin incorrect arity",
            .source = "enum { A=__builtin_popcount(1,2) };\n",
            .rejected = true,
        },
        {
            .name = "declaration overflow builtin sizeof",
            .source = "int x; enum { A=sizeof(__builtin_add_overflow(1,2,&x)) }; _Static_assert(A==1, \"overflow type\");\n",
        },
        {
            .name = "declaration overflow builtin is not ICE",
            .source = "int x; enum { A=__builtin_add_overflow(1,2,&x) };\n",
            .rejected = true,
        },
        {
            // #990: clang's evaluator reads a const object's constant initializer inside a builtin call, so the folded
            // call is an integer constant expression in every context.
            .name = "declaration builtin calls of a const integer object",
            .source = "static const int x=5; _Static_assert(__builtin_popcount(x)==2, \"const object\"); static int s=__builtin_popcount(x); int bound[__builtin_popcount(x)]; enum { F=__builtin_ffs(x) }; struct W { int field:__builtin_popcount(x); }; int f(void) { const int y=6; switch (0) { case __builtin_popcount(y)-2: return 1; } return bound[0]+s; }\n",
        },
        {
            // #990: the same const-object read at block scope, for the generic bit and floating builtin families and a
            // static local's initializer.
            .name = "block-scope builtin calls of const objects in other families",
            .source = "int g(void) { const unsigned u=7u; const unsigned short h=0x1234; const double d=4.0; _Static_assert(__builtin_popcountg(u)==3 && __builtin_bswapg(h)==0x3412, \"generic bits\"); _Static_assert(__builtin_signbit(d)==0 && __builtin_ctz((int)d)==2, \"floating object\"); enum { G=__builtin_stdc_bit_width(u) }; struct V { unsigned field:__builtin_stdc_bit_floor(u); }; static int t=__builtin_stdc_count_ones(u); switch (0) { case __builtin_clzg(u,99)-29: return t+G+(int)sizeof(struct V); } return 0; }\n",
        },
        {
            .name = "declaration builtin calls of const integer objects across families",
            .source = "static const unsigned u=0xf0u; static const unsigned long ul=0x100000001ul; static const unsigned long long ull=0x8000000000000001ull; static const signed char c=-1; static const _Bool b=1; enum E { EA=7 }; static const enum E e=EA; static const unsigned short s=0x1234; _Static_assert(__builtin_clz(u)==24 && __builtin_ctz(u)==4 && __builtin_parity(u)==0, \"\"); _Static_assert(__builtin_popcountl(ul)==2 && __builtin_clzll(ull)==0 && __builtin_bswap16(s)==0x3412, \"\"); _Static_assert(__builtin_ffs(c)==1 && __builtin_clrsb(c)==31 && __builtin_popcount(e)==3 && __builtin_popcount(b)==1, \"\"); _Static_assert(__builtin_abs(-7)==7 && __builtin_expect(u,0xf0u)==0xf0u && __builtin_expect_with_probability(u,0xf0u,0.5)==0xf0u, \"\");\n",
        },
        {
            .name = "declaration builtin calls of const member, element and floating objects",
            .source = "static const int x=5; static const int pair[2]={5,6}; struct P { int v; }; static const struct P p={11}; static const double d=3.0; _Static_assert(__builtin_popcount(__builtin_bswap32(x))==2 && __builtin_popcount(x+0)==2, \"\"); _Static_assert(__builtin_popcount(x?x:0)==2 && __builtin_popcount((x))==2, \"\"); _Static_assert(__builtin_constant_p(__builtin_popcount(x))==1, \"\"); _Static_assert(__builtin_popcount(pair[0])==2 && __builtin_popcount(p.v)==3, \"\"); _Static_assert(__builtin_ctz((int)d)==0 && __builtin_signbit(d)==0, \"\"); int bound[__builtin_popcount((int)d)];\n",
        },
        {
            .name = "declaration builtin call of a volatile object",
            .source = "static const volatile int v=5; int bound[__builtin_popcount(v)];\n",
            .rejected = true,
        },
        {
            .name = "declaration builtin call of a mutable object",
            .source = "static int n=5; _Static_assert(__builtin_popcount(n)==2, \"\");\n",
            .rejected = true,
        },
        {
            .name = "declaration builtin call of a runtime-initialized const object",
            .source = "int f(int p) { const int w=p; switch (0) { case __builtin_popcount(w): return 1; } return 0; }\n",
            .rejected = true,
        },
        {
            .name = "declaration overflow builtin of a const object is not ICE",
            .source = "static const int k=5; int sink; enum { E=__builtin_add_overflow(k,1,&sink) };\n",
            .rejected = true,
        },
        {
            // #990: the atomic action's operand conversions read const objects in constant contexts too, so clang's
            // folded lock-free query of a const size object is an integer constant expression. Its answer 1 is a
            // lock-free size the pointee's alignment covers; no fixture value or memory is executed.
            .name = "declaration atomic lock-free query of const objects",
            .source = "static const int x=5; static const int *const p=&x; static const unsigned long size=sizeof x; enum { E=__atomic_always_lock_free(size,p) }; _Static_assert(E==1 && __atomic_always_lock_free(size,p), \"atomic const objects\");\n",
        },
        {
            .name = "C23 raw attribute arithmetic",
            .source = "typedef int T [[gnu::aligned(1 << 4)]]; _Static_assert(_Alignof(T)==16, \"raw arithmetic\");\n",
        },
        {
            .name = "C23 raw attribute enum binding",
            .source = "enum { A=4 }; typedef int T [[gnu::aligned(A << 2)]]; _Static_assert(_Alignof(T)==16, \"raw binding\");\n",
        },
        {
            .name = "C23 raw attribute cast and conditional",
            .source = "typedef int T [[gnu::aligned((unsigned)(1?16:1/0))]]; _Static_assert(_Alignof(T)==16, \"raw conditional\");\n",
        },
        {
            .name = "C23 raw attribute nested query",
            .source = "typedef int T [[gnu::aligned(sizeof(int[2+sizeof(char[2])]))]]; _Static_assert(_Alignof(T)==16, \"raw type\");\n",
        },
        {
            .name = "C23 raw attribute typedef query",
            .source = "typedef long double T; typedef int I [[gnu::aligned(sizeof(T))]]; _Static_assert(_Alignof(I)==16, \"raw typedef\");\n",
        },
        {
            .name = "C23 raw attribute typeof query",
            .source = "typedef int T [[gnu::aligned(sizeof(__typeof__(long double)))]]; _Static_assert(_Alignof(T)==16, \"raw typeof\");\n",
        },
        {
            .name = "C23 raw attribute object alignment",
            .source = "int x __attribute__((aligned(32))); typedef int T [[gnu::aligned(__alignof__((x)))]]; _Static_assert(_Alignof(T)==32, \"raw object\");\n",
        },
        {
            .name = "C23 raw attribute integer builtin",
            .source = "typedef int T [[gnu::aligned(1 << __builtin_ctz(16))]]; _Static_assert(_Alignof(T)==16, \"raw builtin\");\n",
        },
        {
            .name = "C23 raw attribute invalid alignment",
            .source = "int x [[gnu::aligned(1+2)]];\n",
            .rejected = true,
        },
        {
            .name = "C23 raw attribute evaluated fault",
            .source = "int x [[gnu::aligned(0?16:1/0)]];\n",
            .rejected = true,
        },
    };
assert(sizeof("initializer designator bindings remain source ordered")-1==strlen("initializer designator bindings remain source ordered"));
assert(sizeof("earlier incomplete query precedes later missing name")-1==strlen("earlier incomplete query precedes later missing name"));
assert(sizeof("@nested-selections-1")-1==strlen("@nested-selections-1"));
assert(sizeof("int a[2]; int f(void); _Static_assert(_Generic(a,int*:1,default:0), \"array\"); _Static_assert(_Generic(f,int(*)(void):1,default:0), \"function\");\n")-1==strlen("int a[2]; int f(void); _Static_assert(_Generic(a,int*:1,default:0), \"array\"); _Static_assert(_Generic(f,int(*)(void):1,default:0), \"function\");\n"));
assert(sizeof("generic source type compatibility duplicate")-1==strlen("generic source type compatibility duplicate"));
assert(sizeof("unselected nested operands remain type checked in source order")-1==strlen("unselected nested operands remain type checked in source order"));
assert(sizeof("declaration GNU choose rejects comma with wrapped integer")-1==strlen("declaration GNU choose rejects comma with wrapped integer"));
assert(sizeof("typedef int I; enum { N=_Generic(1,int:2,I:3) };\n")-1==strlen("typedef int I; enum { N=_Generic(1,int:2,I:3) };\n"));
assert(sizeof("typedef int (__attribute__((ms_abi)) *M)(int); _Static_assert(__builtin_types_compatible_p(M,int __attribute__((ms_abi)) (*)(int)),\"prefix\"); typedef int (*N)(int) __attribute__((ms_abi)); _Static_assert(__builtin_types_compatible_p(M,N),\"suffix\"); _Static_assert(!__builtin_types_compatible_p(M,int(*)(int)),\"distinct ABI\");\n")-1==strlen("typedef int (__attribute__((ms_abi)) *M)(int); _Static_assert(__builtin_types_compatible_p(M,int __attribute__((ms_abi)) (*)(int)),\"prefix\"); typedef int (*N)(int) __attribute__((ms_abi)); _Static_assert(__builtin_types_compatible_p(M,N),\"suffix\"); _Static_assert(!__builtin_types_compatible_p(M,int(*)(int)),\"distinct ABI\");\n"));
assert(sizeof("static const int x=5; static const int pair[2]={5,6}; struct P { int v; }; static const struct P p={11}; static const double d=3.0; _Static_assert(__builtin_popcount(__builtin_bswap32(x))==2 && __builtin_popcount(x+0)==2, \"\"); _Static_assert(__builtin_popcount(x?x:0)==2 && __builtin_popcount((x))==2, \"\"); _Static_assert(__builtin_constant_p(__builtin_popcount(x))==1, \"\"); _Static_assert(__builtin_popcount(pair[0])==2 && __builtin_popcount(p.v)==3, \"\"); _Static_assert(__builtin_ctz((int)d)==0 && __builtin_signbit(d)==0, \"\"); int bound[__builtin_popcount((int)d)];\n")-1==strlen("static const int x=5; static const int pair[2]={5,6}; struct P { int v; }; static const struct P p={11}; static const double d=3.0; _Static_assert(__builtin_popcount(__builtin_bswap32(x))==2 && __builtin_popcount(x+0)==2, \"\"); _Static_assert(__builtin_popcount(x?x:0)==2 && __builtin_popcount((x))==2, \"\"); _Static_assert(__builtin_constant_p(__builtin_popcount(x))==1, \"\"); _Static_assert(__builtin_popcount(pair[0])==2 && __builtin_popcount(p.v)==3, \"\"); _Static_assert(__builtin_ctz((int)d)==0 && __builtin_signbit(d)==0, \"\"); int bound[__builtin_popcount((int)d)];\n"));
assert(sizeof("@nested-selections-3")-1==strlen("@nested-selections-3"));
assert(sizeof("declaration GNU choose retains wrapped ICE form")-1==strlen("declaration GNU choose retains wrapped ICE form"));
assert(sizeof("tag attribute source ordered identity")-1==strlen("tag attribute source ordered identity"));
assert(sizeof("struct S { char bytes[sizeof(missing) -\nsizeof(struct Missing)]; };\n")-1==strlen("struct S { char bytes[sizeof(missing) -\nsizeof(struct Missing)]; };\n"));
assert(sizeof("enum { A=_Alignof(double), B=sizeof(int (*[2])(int)) }; _Static_assert(A==8 && B==16, \"types\");\n")-1==strlen("enum { A=_Alignof(double), B=sizeof(int (*[2])(int)) }; _Static_assert(A==8 && B==16, \"types\");\n"));
assert(sizeof("declaration atomic lock-free query of const objects")-1==strlen("declaration atomic lock-free query of const objects"));
assert(sizeof("half arithmetic in required constant expressions")-1==strlen("half arithmetic in required constant expressions"));
assert(sizeof("declaration sizeof comma expression")-1==strlen("declaration sizeof comma expression"));
assert(sizeof("enum { N=_Generic(1,double:2) };\n")-1==strlen("enum { N=_Generic(1,double:2) };\n"));
assert(sizeof("_Static_assert((__bf16)0x1p-133+(__bf16)0x1p-133==(__bf16)0x1p-132,\"bf16 subnormal\");\n")-1==strlen("_Static_assert((__bf16)0x1p-133+(__bf16)0x1p-133==(__bf16)0x1p-132,\"bf16 subnormal\");\n"));
assert(sizeof("struct Buffer { char spare[12 * sizeof(int) - 5 * sizeof(void *)]; }; _Static_assert(sizeof(struct Buffer)==8, \"bound\");\n")-1==strlen("struct Buffer { char spare[12 * sizeof(int) - 5 * sizeof(void *)]; }; _Static_assert(sizeof(struct Buffer)==8, \"bound\");\n"));
assert(sizeof("declaration builtin incorrect arity")-1==strlen("declaration builtin incorrect arity"));
assert(sizeof("_Static_assert((_Float16)1/(_Float16)3==(_Float16)0x1.554p-2,\"half quotient\");")-1==strlen("_Static_assert((_Float16)1/(_Float16)3==(_Float16)0x1.554p-2,\"half quotient\");"));
assert(sizeof("int x; enum { A=sizeof(__builtin_add_overflow(1,2,&x)) }; _Static_assert(A==1, \"overflow type\");\n")-1==strlen("int x; enum { A=sizeof(__builtin_add_overflow(1,2,&x)) }; _Static_assert(A==1, \"overflow type\");\n"));
assert(sizeof("declaration vector shuffle GNU lexical index")-1==strlen("declaration vector shuffle GNU lexical index"));
assert(sizeof("declaration generic no match")-1==strlen("declaration generic no match"));
assert(sizeof("source anonymous record offset retains nested layout")-1==strlen("source anonymous record offset retains nested layout"));
assert(sizeof("typedef int I; _Static_assert(__builtin_types_compatible_p(const I,int), \"same\"); _Static_assert(!__builtin_types_compatible_p(int*,const int*), \"different\");\n")-1==strlen("typedef int I; _Static_assert(__builtin_types_compatible_p(const I,int), \"same\"); _Static_assert(!__builtin_types_compatible_p(int*,const int*), \"different\");\n"));
assert(sizeof("struct S { int x; }; enum { N=sizeof(struct __attribute__((aligned(1/0))) S) };\n")-1==strlen("struct S { int x; }; enum { N=sizeof(struct __attribute__((aligned(1/0))) S) };\n"));
assert(sizeof("declaration type compatibility")-1==strlen("declaration type compatibility"));
assert(sizeof("declaration complex type names")-1==strlen("declaration complex type names"));
assert(sizeof("generic aligned nominal duplicate")-1==strlen("generic aligned nominal duplicate"));
assert(sizeof("enum { A=__builtin_choose_expr(1<<32,7,0), B=__builtin_choose_expr(1<<-1,0,7), C=__builtin_choose_expr(2147483647+1,7,0) }; _Static_assert(A==7 && B==7 && C==7, \"wrapped ICE\");\n")-1==strlen("enum { A=__builtin_choose_expr(1<<32,7,0), B=__builtin_choose_expr(1<<-1,0,7), C=__builtin_choose_expr(2147483647+1,7,0) }; _Static_assert(A==7 && B==7 && C==7, \"wrapped ICE\");\n"));
assert(sizeof("typedef int V __attribute__((vector_size(16))); V a; enum { N=sizeof(__builtin_convertvector(a,float __attribute__((vector_size(16))))) }; typedef int T [[gnu::aligned(sizeof(__builtin_convertvector(a,float __attribute__((vector_size(16))))))]]; _Static_assert(N==16 && _Alignof(T)==16, \"abstract vector destination\");\n")-1==strlen("typedef int V __attribute__((vector_size(16))); V a; enum { N=sizeof(__builtin_convertvector(a,float __attribute__((vector_size(16))))) }; typedef int T [[gnu::aligned(sizeof(__builtin_convertvector(a,float __attribute__((vector_size(16))))))]]; _Static_assert(N==16 && _Alignof(T)==16, \"abstract vector destination\");\n"));
assert(sizeof("@nested-selections-0")-1==strlen("@nested-selections-0"));
assert(sizeof("enum { N=sizeof(__builtin_bit_cast(long,1)) };\n")-1==strlen("enum { N=sizeof(__builtin_bit_cast(long,1)) };\n"));
assert(sizeof("declaration incomplete sizeof rejected")-1==strlen("declaration incomplete sizeof rejected"));
assert(sizeof("_Static_assert((__bf16)7-(__bf16)2==5,\"bf16 difference\");")-1==strlen("_Static_assert((__bf16)7-(__bf16)2==5,\"bf16 difference\");"));
assert(sizeof("generic selected fault")-1==strlen("generic selected fault"));
assert(sizeof("declaration builtin call of a mutable object")-1==strlen("declaration builtin call of a mutable object"));
assert(sizeof("generic transparent function parameter duplicate")-1==strlen("generic transparent function parameter duplicate"));
assert(sizeof("enum { A=sizeof(__builtin_ctz(0)), B=1?3:__builtin_clz(0) }; _Static_assert(A==4 && B==3, \"builtin faults\");\n")-1==strlen("enum { A=sizeof(__builtin_ctz(0)), B=1?3:__builtin_clz(0) }; _Static_assert(A==4 && B==3, \"builtin faults\");\n"));
assert(sizeof("constant query saturates floating casts only in proof")-1==strlen("constant query saturates floating casts only in proof"));
assert(sizeof("declaration builtin converted constants")-1==strlen("declaration builtin converted constants"));
assert(sizeof("!__builtin_signbit(__builtin_nanl(\"\")*-__builtin_nanl(\"\")),\"first NaN operand\");\n")-1==strlen("!__builtin_signbit(__builtin_nanl(\"\")*-__builtin_nanl(\"\")),\"first NaN operand\");\n"));
assert(sizeof("source member offset builtin")-1==strlen("source member offset builtin"));
assert(sizeof("typedef int T [[gnu::aligned(__builtin_bit_cast(unsigned,16))]];\n")-1==strlen("typedef int T [[gnu::aligned(__builtin_bit_cast(unsigned,16))]];\n"));
assert(sizeof("int a[2]; enum { N=sizeof(__builtin_bit_cast(int[2],a)) }; _Static_assert(N==8,\"array representation\");\n")-1==strlen("int a[2]; enum { N=sizeof(__builtin_bit_cast(int[2],a)) }; _Static_assert(N==8,\"array representation\");\n"));
assert(sizeof("declaration iterative nested type queries")-1==strlen("declaration iterative nested type queries"));
assert(sizeof("C23 raw attribute invalid alignment")-1==strlen("C23 raw attribute invalid alignment"));
assert(sizeof("declaration vector builtin exact type queries")-1==strlen("declaration vector builtin exact type queries"));
assert(sizeof("declaration vector shuffle rejects nonconstant lane")-1==strlen("declaration vector shuffle rejects nonconstant lane"));
assert(sizeof("typedef int I; enum { A=__builtin_types_compatible_p(const I,int), B=__builtin_types_compatible_p(int*,const int*) }; _Static_assert(A==1 && B==0, \"compatibility\");\n")-1==strlen("typedef int I; enum { A=__builtin_types_compatible_p(const I,int), B=__builtin_types_compatible_p(int*,const int*) }; _Static_assert(A==1 && B==0, \"compatibility\");\n"));
assert(sizeof("declaration typeof compound literal member query")-1==strlen("declaration typeof compound literal member query"));
assert(sizeof("type name invalid parameter precedes later duplicate")-1==strlen("type name invalid parameter precedes later duplicate"));
assert(sizeof("bitcast rejects evaluated invalid bool representation")-1==strlen("bitcast rejects evaluated invalid bool representation"));
assert(sizeof("statement expression aggregate declaration type query")-1==strlen("statement expression aggregate declaration type query"));
assert(sizeof("raw attribute nested vector builtin destination type")-1==strlen("raw attribute nested vector builtin destination type"));
assert(sizeof("declaration nested member offset")-1==strlen("declaration nested member offset"));
assert(sizeof("struct S { int x:3; }; struct S s; enum { A=sizeof s.x };\n")-1==strlen("struct S { int x:3; }; struct S s; enum { A=sizeof s.x };\n"));
assert(sizeof("declaration nested builtin constant")-1==strlen("declaration nested builtin constant"));
assert(sizeof("enum { N=__builtin_choose_expr((0,1<<32),7,0) };\n")-1==strlen("enum { N=__builtin_choose_expr((0,1<<32),7,0) };\n"));
assert(sizeof("int f(void); enum { A=sizeof(void), B=sizeof f, C=__alignof__(void), D=__alignof__(f) }; _Static_assert(A==1 && B==1 && C==1 && D==4, \"GNU queries\");\n")-1==strlen("int f(void); enum { A=sizeof(void), B=sizeof f, C=__alignof__(void), D=__alignof__(f) }; _Static_assert(A==1 && B==1 && C==1 && D==4, \"GNU queries\");\n"));
assert(sizeof("enum { A=__builtin_popcount(7), B=__builtin_clz(1), C=__builtin_ctz(8), D=__builtin_parity(7), E=__builtin_ffs(8) }; _Static_assert(A==3 && B==31 && C==3 && D==1 && E==4, \"integer builtins\");\n")-1==strlen("enum { A=__builtin_popcount(7), B=__builtin_clz(1), C=__builtin_ctz(8), D=__builtin_parity(7), E=__builtin_ffs(8) }; _Static_assert(A==3 && B==31 && C==3 && D==1 && E==4, \"integer builtins\");\n"));
assert(sizeof("_Static_assert(((_Float16)2048+(_Float16)1)-(_Float16)2048==0,\"half midpoint\");")-1==strlen("_Static_assert(((_Float16)2048+(_Float16)1)-(_Float16)2048==0,\"half midpoint\");"));
assert(sizeof("overloaded argument cannot hide inside folded query")-1==strlen("overloaded argument cannot hide inside folded query"));
assert(sizeof("type name nested prototype duplicate")-1==strlen("type name nested prototype duplicate"));
assert(sizeof("typedef int I4 __attribute__((vector_size(16))); typedef float F4 __attribute__((vector_size(16))); I4 a; __typeof__(__builtin_convertvector(a,F4)) b; enum { N=sizeof(__builtin_elementwise_abs(a)), R=sizeof(__builtin_reduce_add(a)), C=sizeof(__builtin_convertvector(a,F4)) }; _Static_assert(N==16 && R==4 && C==16 && __builtin_types_compatible_p(__typeof__(b),F4), \"vector builtin types\");\n")-1==strlen("typedef int I4 __attribute__((vector_size(16))); typedef float F4 __attribute__((vector_size(16))); I4 a; __typeof__(__builtin_convertvector(a,F4)) b; enum { N=sizeof(__builtin_elementwise_abs(a)), R=sizeof(__builtin_reduce_add(a)), C=sizeof(__builtin_convertvector(a,F4)) }; _Static_assert(N==16 && R==4 && C==16 && __builtin_types_compatible_p(__typeof__(b),F4), \"vector builtin types\");\n"));
assert(sizeof("enum { N=sizeof(int[2+sizeof(char[3])]) }; _Static_assert(N==20, \"nested\");\n")-1==strlen("enum { N=sizeof(int[2+sizeof(char[3])]) }; _Static_assert(N==20, \"nested\");\n"));
assert(sizeof("declaration generic duplicate association")-1==strlen("declaration generic duplicate association"));
assert(sizeof("enum { A=sizeof(\"ab\" \"cd\"), B=sizeof(L\"hi\"), C=sizeof(u\"hi\") }; _Static_assert(A==5 && B==12 && C==6, \"strings\");\n")-1==strlen("enum { A=sizeof(\"ab\" \"cd\"), B=sizeof(L\"hi\"), C=sizeof(u\"hi\") }; _Static_assert(A==5 && B==12 && C==6, \"strings\");\n"));
assert(sizeof("declaration vector conversion rejects lane count mismatch")-1==strlen("declaration vector conversion rejects lane count mismatch"));
assert(sizeof("real literal immediate integer cast")-1==strlen("real literal immediate integer cast"));
assert(sizeof("_Static_assert((__bf16)1/(__bf16)3==(__bf16)0x1.56p-2,\"bf16 quotient\");\n")-1==strlen("_Static_assert((__bf16)1/(__bf16)3==(__bf16)0x1.56p-2,\"bf16 quotient\");\n"));
assert(sizeof("enum { N=_Generic(1,int:7,default:1/0) }; _Static_assert(N==7, \"generic\");\n")-1==strlen("enum { N=_Generic(1,int:7,default:1/0) }; _Static_assert(N==7, \"generic\");\n"));
assert(sizeof("struct S { char c; int a[3]; }; enum { A=__builtin_offsetof(struct S,a[2]) }; _Static_assert(A==12, \"offset\");\n")-1==strlen("struct S { char c; int a[3]; }; enum { A=__builtin_offsetof(struct S,a[2]) }; _Static_assert(A==12, \"offset\");\n"));
assert(sizeof("generic source incomplete association")-1==strlen("generic source incomplete association"));
assert(sizeof("half storage type in declaration query")-1==strlen("half storage type in declaration query"));
assert(sizeof("int f(int n) { __typeof__(({int x=n; {int y=x; x=y;} x;})) t=1; return t; }\n")-1==strlen("int f(int n) { __typeof__(({int x=n; {int y=x; x=y;} x;})) t=1; return t; }\n"));
assert(sizeof("const int x=1; _Atomic(int) a; _Static_assert(_Generic(x,int:1,default:0), \"const\"); _Static_assert(_Generic(a,int:1,default:0), \"atomic\");\n")-1==strlen("const int x=1; _Atomic(int) a; _Static_assert(_Generic(x,int:1,default:0), \"const\"); _Static_assert(_Generic(a,int:1,default:0), \"atomic\");\n"));
assert(sizeof("statement expression multiple declarator type query")-1==strlen("statement expression multiple declarator type query"));
assert(sizeof("enum { A=__builtin_popcount(1.5), B=__builtin_popcount((1,7)) }; _Static_assert(A==1 && B==3, \"builtin conversions\");\n")-1==strlen("enum { A=__builtin_popcount(1.5), B=__builtin_popcount((1,7)) }; _Static_assert(A==1 && B==3, \"builtin conversions\");\n"));
assert(sizeof("C23 raw attribute enum binding")-1==strlen("C23 raw attribute enum binding"));
assert(sizeof("struct S { long x; };\n")-1==strlen("struct S { long x; };\n"));
assert(sizeof("_Static_assert(_Generic(1,int:1,default:1/0), \"selected\");\n")-1==strlen("_Static_assert(_Generic(1,int:1,default:1/0), \"selected\");\n"));
assert(sizeof("bitcast raw array operand is not decayed")-1==strlen("bitcast raw array operand is not decayed"));
assert(sizeof("tag attribute invalid alignment")-1==strlen("tag attribute invalid alignment"));
assert(sizeof("declaration vector builtin arbitrary argument slice")-1==strlen("declaration vector builtin arbitrary argument slice"));
assert(sizeof("type name outer duplicate survives nested prototype")-1==strlen("type name outer duplicate survives nested prototype"));
assert(sizeof("declaration generic duplicate default")-1==strlen("declaration generic duplicate default"));
assert(sizeof("int f(int n) { __typeof__(({int x=n; for(int i=0;i<2;i++)x++; do { x--; } while(x); x;})) t=1; return t; }\n")-1==strlen("int f(int n) { __typeof__(({int x=n; for(int i=0;i<2;i++)x++; do { x--; } while(x); x;})) t=1; return t; }\n"));
assert(sizeof("enum { A=sizeof(int (*)(int,int,int,int)) }; _Static_assert(A==8,\"unnamed parameters\");\n")-1==strlen("enum { A=sizeof(int (*)(int,int,int,int)) }; _Static_assert(A==8,\"unnamed parameters\");\n"));
assert(sizeof("statement expression initializer reports its actual line")-1==strlen("statement expression initializer reports its actual line"));
assert(sizeof("declaration builtin array bound")-1==strlen("declaration builtin array bound"));
assert(sizeof("declaration nested typeof")-1==strlen("declaration nested typeof"));
assert(sizeof("declaration builtin calls of const integer objects across families")-1==strlen("declaration builtin calls of const integer objects across families"));
assert(sizeof("int f(void){return __builtin_choose_expr(1,7,_Generic(0,int:missing,default:0));}\n")-1==strlen("int f(void){return __builtin_choose_expr(1,7,_Generic(0,int:missing,default:0));}\n"));
assert(sizeof("enum { A=sizeof(int (*)(int x,int,int,int x)) };\n")-1==strlen("enum { A=sizeof(int (*)(int x,int,int,int x)) };\n"));
assert(sizeof("generic exact selected lvalue")-1==strlen("generic exact selected lvalue"));
assert(sizeof("_Static_assert(_Generic(1,int:1/0,default:1), \"fault\");\n")-1==strlen("_Static_assert(_Generic(1,int:1/0,default:1), \"fault\");\n"));
assert(sizeof("deep selected generic expressions")-1==strlen("deep selected generic expressions"));
assert(sizeof("int g(void) { __typeof__((__typeof__((int){0})){1}) x = 1; return x; }\n")-1==strlen("int g(void) { __typeof__((__typeof__((int){0})){1}) x = 1; return x; }\n"));
assert(sizeof("void f(void) { enum { N=__builtin_choose_expr(({1<<32;}),7,0) }; }\n")-1==strlen("void f(void) { enum { N=__builtin_choose_expr(({1<<32;}),7,0) }; }\n"));
assert(sizeof("enum { A=sizeof(int (*)(int (*a)(int x,int y),int (*b)(int x,int y))) }; _Static_assert(A==8,\"sibling scopes\");\n")-1==strlen("enum { A=sizeof(int (*)(int (*a)(int x,int y),int (*b)(int x,int y))) }; _Static_assert(A==8,\"sibling scopes\");\n"));
assert(sizeof("declaration evaluated fault")-1==strlen("declaration evaluated fault"));
assert(sizeof("C23 raw attribute typedef query")-1==strlen("C23 raw attribute typedef query"));
assert(sizeof("generic nominal qualifiers retain exact checks")-1==strlen("generic nominal qualifiers retain exact checks"));
assert(sizeof("typedef int V __attribute__((vector_size(16))); V a,b; V f(void){return _Generic(0,int:__builtin_choose_expr(1,a,b),default:b);} int g(void){_Generic(0,int:__builtin_choose_expr(0,b,a),default:b)[0]=9; return a[0];}\n")-1==strlen("typedef int V __attribute__((vector_size(16))); V a,b; V f(void){return _Generic(0,int:__builtin_choose_expr(1,a,b),default:b);} int g(void){_Generic(0,int:__builtin_choose_expr(0,b,a),default:b)[0]=9; return a[0];}\n"));
assert(sizeof("declaration typedef and object source order")-1==strlen("declaration typedef and object source order"));
assert(sizeof("typedef int T [[gnu::aligned(sizeof(int[2+sizeof(char[2])]))]]; _Static_assert(_Alignof(T)==16, \"raw type\");\n")-1==strlen("typedef int T [[gnu::aligned(sizeof(int[2+sizeof(char[2])]))]]; _Static_assert(_Alignof(T)==16, \"raw type\");\n"));
assert(sizeof("typedef int V __attribute__((vector_size(16))); V a; int n; enum { A=sizeof(__builtin_nontemporal_load(&a)), B=sizeof(__builtin_nontemporal_store(a,&a)), C=sizeof(__builtin_nondeterministic_value(++n)) }; _Static_assert(A==16 && B==1 && C==4, \"vector memory types\");\n")-1==strlen("typedef int V __attribute__((vector_size(16))); V a; int n; enum { A=sizeof(__builtin_nontemporal_load(&a)), B=sizeof(__builtin_nontemporal_store(a,&a)), C=sizeof(__builtin_nondeterministic_value(++n)) }; _Static_assert(A==16 && B==1 && C==4, \"vector memory types\");\n"));
assert(sizeof("enum { A=sizeof(int (*)(int x,int (*cb)(int x),int x)) };\n")-1==strlen("enum { A=sizeof(int (*)(int x,int (*cb)(int x),int x)) };\n"));
assert(sizeof("declaration GNU choose full-width truth oracle divergence")-1==strlen("declaration GNU choose full-width truth oracle divergence"));
assert(sizeof("typedef int T [[gnu::aligned(sizeof(__typeof__(long double)))]]; _Static_assert(_Alignof(T)==16, \"raw typeof\");\n")-1==strlen("typedef int T [[gnu::aligned(sizeof(__typeof__(long double)))]]; _Static_assert(_Alignof(T)==16, \"raw typeof\");\n"));
assert(sizeof("raw attribute vector builtin destination type")-1==strlen("raw attribute vector builtin destination type"));
assert(sizeof("declaration builtin call of a runtime-initialized const object")-1==strlen("declaration builtin call of a runtime-initialized const object"));
assert(sizeof("enum { A=__builtin_popcount(1,2) };\n")-1==strlen("enum { A=__builtin_popcount(1,2) };\n"));
assert(sizeof("declaration vector shuffle rejects out of range lane")-1==strlen("declaration vector shuffle rejects out of range lane"));
assert(sizeof("nested selections retain prefix, infix and comma roots")-1==strlen("nested selections retain prefix, infix and comma roots"));
assert(sizeof("struct S { int a[3]; }; struct S s; int f(int); enum { A=sizeof s.a[1], B=sizeof f(3), C=sizeof(1/0) }; _Static_assert(A+B+C==12, \"unevaluated\");\n")-1==strlen("struct S { int a[3]; }; struct S s; int f(int); enum { A=sizeof s.a[1], B=sizeof f(3), C=sizeof(1/0) }; _Static_assert(A+B+C==12, \"unevaluated\");\n"));
assert(sizeof("const int x=2; enum { N=x };\n")-1==strlen("const int x=2; enum { N=x };\n"));
assert(sizeof("source type compatibility builtin")-1==strlen("source type compatibility builtin"));
assert(sizeof("typedef int T [[gnu::aligned(1 << __builtin_ctz(16))]]; _Static_assert(_Alignof(T)==16, \"raw builtin\");\n")-1==strlen("typedef int T [[gnu::aligned(1 << __builtin_ctz(16))]]; _Static_assert(_Alignof(T)==16, \"raw builtin\");\n"));
assert(sizeof("int a[(unsigned char)258]; _Static_assert(sizeof a==8, \"cast\");\n")-1==strlen("int a[(unsigned char)258]; _Static_assert(sizeof a==8, \"cast\");\n"));
assert(sizeof("typedef int V __attribute__((vector_size(16))); V a; enum { N=sizeof(__builtin_shufflevector(a,a,(2147483647+1)<0,1,2,3)) }; typedef int T [[gnu::aligned(sizeof(__builtin_shufflevector(a,a,(2147483647+1)<0,1,2,3)))]]; _Static_assert(N==16 && _Alignof(T)==16,\"GNU lexical shuffle index\");\n")-1==strlen("typedef int V __attribute__((vector_size(16))); V a; enum { N=sizeof(__builtin_shufflevector(a,a,(2147483647+1)<0,1,2,3)) }; typedef int T [[gnu::aligned(sizeof(__builtin_shufflevector(a,a,(2147483647+1)<0,1,2,3)))]]; _Static_assert(N==16 && _Alignof(T)==16,\"GNU lexical shuffle index\");\n"));
assert(sizeof("raw attribute nested tag query jobs")-1==strlen("raw attribute nested tag query jobs"));
assert(sizeof("typedef int T [[gnu::aligned(__builtin_constant_p((int)1.0e100+1)*16)]]; _Static_assert(_Alignof(T)==16,\"raw proof\");\n")-1==strlen("typedef int T [[gnu::aligned(__builtin_constant_p((int)1.0e100+1)*16)]]; _Static_assert(_Alignof(T)==16,\"raw proof\");\n"));
assert(sizeof("GNU statement expression folds in integer constant context")-1==strlen("GNU statement expression folds in integer constant context"));
assert(sizeof("declaration future enumerator rejected")-1==strlen("declaration future enumerator rejected"));
assert(sizeof("declaration string query")-1==strlen("declaration string query"));
assert(sizeof("enum { N=__builtin_bit_cast(int,0xffffffffu), P=__builtin_bit_cast(unsigned, -1) }; _Static_assert(N==-1 && P==0xffffffffu,\"integer representation\");\n")-1==strlen("enum { N=__builtin_bit_cast(int,0xffffffffu), P=__builtin_bit_cast(unsigned, -1) }; _Static_assert(N==-1 && P==0xffffffffu,\"integer representation\");\n"));
assert(sizeof("enum { A=sizeof(double _Complex), B=sizeof(_Complex), C=sizeof(long double _Complex), D=sizeof(_Complex long) }; _Static_assert(A==16 && B==16 && C==32 && D==16, \"complex\");\n")-1==strlen("enum { A=sizeof(double _Complex), B=sizeof(_Complex), C=sizeof(long double _Complex), D=sizeof(_Complex long) }; _Static_assert(A==16 && B==16 && C==32 && D==16, \"complex\");\n"));
assert(sizeof("int x; enum { A=__builtin_add_overflow(1,2,&x) };\n")-1==strlen("int x; enum { A=__builtin_add_overflow(1,2,&x) };\n"));
assert(sizeof("typedef short T; enum { N=_Generic((T)0,T:_Generic(1.0,double:3,default:8),default:9) }; _Static_assert(N==3, \"nested generic\");\n")-1==strlen("typedef short T; enum { N=_Generic((T)0,T:_Generic(1.0,double:3,default:8),default:9) }; _Static_assert(N==3, \"nested generic\");\n"));
assert(sizeof("@raw-shuffle")-1==strlen("@raw-shuffle"));
assert(sizeof("struct S{int x;}; int f(void){return _Generic(0,struct S(*)[]:1,struct S(*)[3]:2,default:0);}\n")-1==strlen("struct S{int x;}; int f(void){return _Generic(0,struct S(*)[]:1,struct S(*)[3]:2,default:0);}\n"));
assert(sizeof("enum { A=sizeof(int (*)(int x,int (*cb)(int y,int y),int z)) };\n")-1==strlen("enum { A=sizeof(int (*)(int x,int (*cb)(int y,int y),int z)) };\n"));
assert(sizeof("typedef int V __attribute__((vector_size(16))); V a; enum { N=sizeof(__builtin_shufflevector(a,a,0,1,2,8)) };\n")-1==strlen("typedef int V __attribute__((vector_size(16))); V a; enum { N=sizeof(__builtin_shufflevector(a,a,0,1,2,8)) };\n"));
assert(sizeof("enum { N=sizeof(__fp16) }; _Static_assert(N==2,\"half storage\"); typedef int T [[gnu::aligned(sizeof(__fp16))]]; _Static_assert(_Alignof(T)==2,\"raw half\");\n")-1==strlen("enum { N=sizeof(__fp16) }; _Static_assert(N==2,\"half storage\"); typedef int T [[gnu::aligned(sizeof(__fp16))]]; _Static_assert(_Alignof(T)==2,\"raw half\");\n"));
assert(sizeof("int f(int n) { __typeof__(({({n;});})) t=1; _Static_assert(sizeof t==sizeof n, \"nested statement result\"); return t; }\n")-1==strlen("int f(int n) { __typeof__(({({n;});})) t=1; _Static_assert(sizeof t==sizeof n, \"nested statement result\"); return t; }\n"));
assert(sizeof("int g(void) { const unsigned u=7u; const unsigned short h=0x1234; const double d=4.0; _Static_assert(__builtin_popcountg(u)==3 && __builtin_bswapg(h)==0x3412, \"generic bits\"); _Static_assert(__builtin_signbit(d)==0 && __builtin_ctz((int)d)==2, \"floating object\"); enum { G=__builtin_stdc_bit_width(u) }; struct V { unsigned field:__builtin_stdc_bit_floor(u); }; static int t=__builtin_stdc_count_ones(u); switch (0) { case __builtin_clzg(u,99)-29: return t+G+(int)sizeof(struct V); } return 0; }\n")-1==strlen("int g(void) { const unsigned u=7u; const unsigned short h=0x1234; const double d=4.0; _Static_assert(__builtin_popcountg(u)==3 && __builtin_bswapg(h)==0x3412, \"generic bits\"); _Static_assert(__builtin_signbit(d)==0 && __builtin_ctz((int)d)==2, \"floating object\"); enum { G=__builtin_stdc_bit_width(u) }; struct V { unsigned field:__builtin_stdc_bit_floor(u); }; static int t=__builtin_stdc_count_ones(u); switch (0) { case __builtin_clzg(u,99)-29: return t+G+(int)sizeof(struct V); } return 0; }\n"));
assert(sizeof("_Static_assert((_Float16)0x1p-24+(_Float16)0x1p-24==(_Float16)0x1p-23,\"half subnormal\");")-1==strlen("_Static_assert((_Float16)0x1p-24+(_Float16)0x1p-24==(_Float16)0x1p-23,\"half subnormal\");"));
assert(sizeof("type name duplicate separated by unnamed parameters")-1==strlen("type name duplicate separated by unnamed parameters"));
assert(sizeof("statement expression control constraints remain checked")-1==strlen("statement expression control constraints remain checked"));
assert(sizeof("type name unnamed parameters do not collide")-1==strlen("type name unnamed parameters do not collide"));
assert(sizeof("declaration bit field sizeof rejected")-1==strlen("declaration bit field sizeof rejected"));
assert(sizeof("declaration bit field offsetof rejected")-1==strlen("declaration bit field offsetof rejected"));
assert(sizeof("void f(void) { enum { N=({3;}) }; }\n")-1==strlen("void f(void) { enum { N=({3;}) }; }\n"));
assert(sizeof("enum { N=(0 && (1/0)) + (1 || (1/0)) }; int a[N]; _Static_assert(sizeof a==4, \"short circuit\");\n")-1==strlen("enum { N=(0 && (1/0)) + (1 || (1/0)) }; int a[N]; _Static_assert(sizeof a==4, \"short circuit\");\n"));
assert(sizeof("enum { A=3, B=sizeof(int[A]), C=(unsigned char)B }; _Static_assert(C==12, \"enumerator\");\n")-1==strlen("enum { A=3, B=sizeof(int[A]), C=(unsigned char)B }; _Static_assert(C==12, \"enumerator\");\n"));
assert(sizeof("declaration bit field alignof rejected")-1==strlen("declaration bit field alignof rejected"));
assert(sizeof("int x; enum { A=sizeof(__typeof__(x)), B=sizeof(__typeof__(int[3])), C=sizeof(__typeof__((x+1))) }; _Static_assert(A==4 && B==12 && C==4, \"typeof\");\n")-1==strlen("int x; enum { A=sizeof(__typeof__(x)), B=sizeof(__typeof__(int[3])), C=sizeof(__typeof__((x+1))) }; _Static_assert(A==4 && B==12 && C==4, \"typeof\");\n"));
assert(sizeof("C23 raw attribute arithmetic")-1==strlen("C23 raw attribute arithmetic"));
assert(sizeof("enum { N=sizeof(__typeof__(((struct S){0}).x)) }; _Static_assert(N==sizeof(long), \"compound member\");\n")-1==strlen("enum { N=sizeof(__typeof__(((struct S){0}).x)) }; _Static_assert(N==sizeof(long), \"compound member\");\n"));
assert(sizeof("generic enum underlying duplicate")-1==strlen("generic enum underlying duplicate"));
assert(sizeof("declaration integer builtin constant")-1==strlen("declaration integer builtin constant"));
assert(sizeof("_Static_assert(__builtin_isnan(__builtin_inff()+-__builtin_inff()) && ")-1==strlen("_Static_assert(__builtin_isnan(__builtin_inff()+-__builtin_inff()) && "));
assert(sizeof("enum { A=(unsigned unsigned)3, B=sizeof(short short), C=sizeof(_Complex _Complex double), D=sizeof(_Atomic _Atomic int) }; _Static_assert(A==3 && B==2 && C==16 && D==4, \"duplicate modifiers\");\n")-1==strlen("enum { A=(unsigned unsigned)3, B=sizeof(short short), C=sizeof(_Complex _Complex double), D=sizeof(_Atomic _Atomic int) }; _Static_assert(A==3 && B==2 && C==16 && D==4, \"duplicate modifiers\");\n"));
assert(sizeof("type name duplicate precedes later invalid declaration")-1==strlen("type name duplicate precedes later invalid declaration"));
assert(sizeof("generic later transparent attribute is inactive")-1==strlen("generic later transparent attribute is inactive"));
assert(sizeof("declaration overflow builtin is not ICE")-1==strlen("declaration overflow builtin is not ICE"));
assert(sizeof("declaration GNU choose wide integer condition")-1==strlen("declaration GNU choose wide integer condition"));
assert(sizeof("abstract function ABI raw cast context")-1==strlen("abstract function ABI raw cast context"));
assert(sizeof("declaration GNU omitted conditional")-1==strlen("declaration GNU omitted conditional"));
assert(sizeof("int f(int n) { __typeof__(({int x=n; x;})) t=1; _Static_assert(sizeof t==sizeof n, \"local result\"); return t; }\n")-1==strlen("int f(int n) { __typeof__(({int x=n; x;})) t=1; _Static_assert(sizeof t==sizeof n, \"local result\"); return t; }\n"));
assert(sizeof("int x; enum { N=__builtin_choose_expr(x,7,2) };\n")-1==strlen("int x; enum { N=__builtin_choose_expr(x,7,2) };\n"));
assert(sizeof("static const unsigned u=0xf0u; static const unsigned long ul=0x100000001ul; static const unsigned long long ull=0x8000000000000001ull; static const signed char c=-1; static const _Bool b=1; enum E { EA=7 }; static const enum E e=EA; static const unsigned short s=0x1234; _Static_assert(__builtin_clz(u)==24 && __builtin_ctz(u)==4 && __builtin_parity(u)==0, \"\"); _Static_assert(__builtin_popcountl(ul)==2 && __builtin_clzll(ull)==0 && __builtin_bswap16(s)==0x3412, \"\"); _Static_assert(__builtin_ffs(c)==1 && __builtin_clrsb(c)==31 && __builtin_popcount(e)==3 && __builtin_popcount(b)==1, \"\"); _Static_assert(__builtin_abs(-7)==7 && __builtin_expect(u,0xf0u)==0xf0u && __builtin_expect_with_probability(u,0xf0u,0.5)==0xf0u, \"\");\n")-1==strlen("static const unsigned u=0xf0u; static const unsigned long ul=0x100000001ul; static const unsigned long long ull=0x8000000000000001ull; static const signed char c=-1; static const _Bool b=1; enum E { EA=7 }; static const enum E e=EA; static const unsigned short s=0x1234; _Static_assert(__builtin_clz(u)==24 && __builtin_ctz(u)==4 && __builtin_parity(u)==0, \"\"); _Static_assert(__builtin_popcountl(ul)==2 && __builtin_clzll(ull)==0 && __builtin_bswap16(s)==0x3412, \"\"); _Static_assert(__builtin_ffs(c)==1 && __builtin_clrsb(c)==31 && __builtin_popcount(e)==3 && __builtin_popcount(b)==1, \"\"); _Static_assert(__builtin_abs(-7)==7 && __builtin_expect(u,0xf0u)==0xf0u && __builtin_expect_with_probability(u,0xf0u,0.5)==0xf0u, \"\");\n"));
assert(sizeof("int x; int f(void) { _Generic(1,int:x,default:0)=3; return x; }\n")-1==strlen("int x; int f(void) { _Generic(1,int:x,default:0)=3; return x; }\n"));
assert(sizeof("!__builtin_signbit(__builtin_inff()+-__builtin_inff()),\"float sum NaN\");")-1==strlen("!__builtin_signbit(__builtin_inff()+-__builtin_inff()),\"float sum NaN\");"));
assert(sizeof("_Float16 h=(_Float16)1+(_Float16)2; __bf16 b=(__bf16)1+(__bf16)2;")-1==strlen("_Float16 h=(_Float16)1+(_Float16)2; __bf16 b=(__bf16)1+(__bf16)2;"));
assert(sizeof("struct S; typedef struct S *P; enum{N=_Generic((P)0,const struct S*:1,P:7)}; _Static_assert(N==7,\"selected\"); int f(P x){return _Generic(x,const struct S*:1,P:7);}\n")-1==strlen("struct S; typedef struct S *P; enum{N=_Generic((P)0,const struct S*:1,P:7)}; _Static_assert(N==7,\"selected\"); int f(P x){return _Generic(x,const struct S*:1,P:7);}\n"));
assert(sizeof("declaration conditional")-1==strlen("declaration conditional"));
assert(sizeof("declaration unknown sizeof object")-1==strlen("declaration unknown sizeof object"));
assert(sizeof("struct S; union U{struct S*p;void*q;}; enum{N=_Generic(0,int(*)(union U):1,int(*)(struct S*):2,default:7)}; typedef union U TU __attribute__((transparent_union)); _Static_assert(N==7,\"source time\");\n")-1==strlen("struct S; union U{struct S*p;void*q;}; enum{N=_Generic(0,int(*)(union U):1,int(*)(struct S*):2,default:7)}; typedef union U TU __attribute__((transparent_union)); _Static_assert(N==7,\"source time\");\n"));
assert(sizeof("int f(int n) { __typeof__(({int x=n,y=x+1; y;})) t=1; return t; }\n")-1==strlen("int f(int n) { __typeof__(({int x=n,y=x+1; y;})) t=1; return t; }\n"));
assert(sizeof("C23 raw attribute nested query")-1==strlen("C23 raw attribute nested query"));
assert(sizeof("statement expression nested block type query")-1==strlen("statement expression nested block type query"));
assert(sizeof("enum { N=(int)3.75 }; int a[N]; _Static_assert(sizeof a==12, \"real cast\");\n")-1==strlen("enum { N=(int)3.75 }; int a[N]; _Static_assert(sizeof a==12, \"real cast\");\n"));
assert(sizeof("declaration builtin calls of a const integer object")-1==strlen("declaration builtin calls of a const integer object"));
assert(sizeof("declaration const object folds as a GNU enumerator value")-1==strlen("declaration const object folds as a GNU enumerator value"));
assert(sizeof("abstract function ABI preserves explicit typedef conflict")-1==strlen("abstract function ABI preserves explicit typedef conflict"));
assert(sizeof("declaration vector conversion nested destination query")-1==strlen("declaration vector conversion nested destination query"));
assert(sizeof("enum { N=__builtin_choose_expr(1,7,1/0) }; _Static_assert(N==7, \"choose\");\n")-1==strlen("enum { N=__builtin_choose_expr(1,7,1/0) }; _Static_assert(N==7, \"choose\");\n"));
assert(sizeof("#define O __attribute__((overloadable))\nint f(int) O __attribute__((ms_abi)); double f(double) O; typedef int T [[gnu::aligned(sizeof((int (__attribute__((ms_abi)) *)(int))f))]]; _Static_assert(_Alignof(T)==8,\"raw ABI target\");\n")-1==strlen("#define O __attribute__((overloadable))\nint f(int) O __attribute__((ms_abi)); double f(double) O; typedef int T [[gnu::aligned(sizeof((int (__attribute__((ms_abi)) *)(int))f))]]; _Static_assert(_Alignof(T)==8,\"raw ABI target\");\n"));
assert(sizeof("@nested-selections-2")-1==strlen("@nested-selections-2"));
assert(sizeof("C23 raw attribute object alignment")-1==strlen("C23 raw attribute object alignment"));
assert(sizeof("typedef int T [[gnu::aligned((unsigned)(1?16:1/0))]]; _Static_assert(_Alignof(T)==16, \"raw conditional\");\n")-1==strlen("typedef int T [[gnu::aligned((unsigned)(1?16:1/0))]]; _Static_assert(_Alignof(T)==16, \"raw conditional\");\n"));
assert(sizeof("int f(int n) { __typeof__(({int x=n; if(x){x++;} else x--; while(x)x--; x;})) t=1; return t; }\n")-1==strlen("int f(int n) { __typeof__(({int x=n; if(x){x++;} else x--; while(x)x--; x;})) t=1; return t; }\n"));
assert(sizeof("generic array and function conversion")-1==strlen("generic array and function conversion"));
assert(sizeof("int x; void f(void) { char x; enum { N=sizeof x }; _Static_assert(N==1, \"inner\"); } enum { N=sizeof x }; _Static_assert(N==4, \"outer\");\n")-1==strlen("int x; void f(void) { char x; enum { N=sizeof x }; _Static_assert(N==1, \"inner\"); } enum { N=sizeof x }; _Static_assert(N==4, \"outer\");\n"));
assert(sizeof("declaration sizeof object expressions")-1==strlen("declaration sizeof object expressions"));
assert(sizeof("enum { A=sizeof(_Atomic(const int)) };\n")-1==strlen("enum { A=sizeof(_Atomic(const int)) };\n"));
assert(sizeof("block-scope builtin calls of const objects in other families")-1==strlen("block-scope builtin calls of const objects in other families"));
assert(sizeof("int a[3]; _Static_assert(sizeof(__builtin_choose_expr(1,a,0))==12, \"array\");\n")-1==strlen("int a[3]; _Static_assert(sizeof(__builtin_choose_expr(1,a,0))==12, \"array\");\n"));
assert(sizeof("struct I { char c; int x; }; struct S { int n; struct I a[2]; }; enum { A=__builtin_offsetof(struct S,a[1].x) }; _Static_assert(A==16, \"offset\");\n")-1==strlen("struct I { char c; int x; }; struct S { int n; struct I a[2]; }; enum { A=__builtin_offsetof(struct S,a[1].x) }; _Static_assert(A==16, \"offset\");\n"));
assert(sizeof("bitcast declaration integer representation")-1==strlen("bitcast declaration integer representation"));
assert(sizeof("bitcast destination nested type job")-1==strlen("bitcast destination nested type job"));
assert(sizeof("_Static_assert((__bf16)3*(__bf16)2==6,\"bf16 product\");")-1==strlen("_Static_assert((__bf16)3*(__bf16)2==6,\"bf16 product\");"));
assert(sizeof("declaration typeof compound literal immediate queries")-1==strlen("declaration typeof compound literal immediate queries"));
assert(sizeof("struct S { int x:3; }; struct S s; enum { A=__alignof__(s.x) };\n")-1==strlen("struct S { int x:3; }; struct S s; enum { A=__alignof__(s.x) };\n"));
assert(sizeof("typedef int V __attribute__((vector_size(16))); typedef double D __attribute__((vector_size(16))); V a; enum { N=sizeof(__builtin_convertvector(a,D)) };\n")-1==strlen("typedef int V __attribute__((vector_size(16))); typedef double D __attribute__((vector_size(16))); V a; enum { N=sizeof(__builtin_convertvector(a,D)) };\n"));
assert(sizeof("_Static_assert(__builtin_types_compatible_p(__typeof__((vf){0}), vf), \"vector\");\n")-1==strlen("_Static_assert(__builtin_types_compatible_p(__typeof__((vf){0}), vf), \"vector\");\n"));
assert(sizeof("static const int x=5; static const int *const p=&x; static const unsigned long size=sizeof x; enum { E=__atomic_always_lock_free(size,p) }; _Static_assert(E==1 && __atomic_always_lock_free(size,p), \"atomic const objects\");\n")-1==strlen("static const int x=5; static const int *const p=&x; static const unsigned long size=sizeof x; enum { E=__atomic_always_lock_free(size,p) }; _Static_assert(E==1 && __atomic_always_lock_free(size,p), \"atomic const objects\");\n"));
assert(sizeof("typedef int I4 __attribute__((vector_size(16))); typedef float F4 __attribute__((vector_size(16))); I4 a; typedef int T [[gnu::aligned(sizeof(__builtin_convertvector(a,__typeof__(__builtin_convertvector(a,F4)))))]]; _Static_assert(_Alignof(T)==16, \"raw nested destination\");\n")-1==strlen("typedef int I4 __attribute__((vector_size(16))); typedef float F4 __attribute__((vector_size(16))); I4 a; typedef int T [[gnu::aligned(sizeof(__builtin_convertvector(a,__typeof__(__builtin_convertvector(a,F4)))))]]; _Static_assert(_Alignof(T)==16, \"raw nested destination\");\n"));
assert(sizeof("generic exact binding after scopes close")-1==strlen("generic exact binding after scopes close"));
assert(sizeof("typedef int T [[gnu::aligned(sizeof(int(int)))]]; _Static_assert(_Alignof(T)==1,\"raw function\");\n")-1==strlen("typedef int T [[gnu::aligned(sizeof(int(int)))]]; _Static_assert(_Alignof(T)==1,\"raw function\");\n"));
assert(sizeof("GNU choose exact selected array")-1==strlen("GNU choose exact selected array"));
assert(sizeof("enum { A=sizeof(int (*)(int x,int x)) };\n")-1==strlen("enum { A=sizeof(int (*)(int x,int x)) };\n"));
assert(sizeof("deeply nested tag attribute queries")-1==strlen("deeply nested tag attribute queries"));
assert(sizeof("enum { N=__builtin_choose_expr(((__int128)1<<100)|1,7,0) }; _Static_assert(N==7, \"wide condition\");\n")-1==strlen("enum { N=__builtin_choose_expr(((__int128)1<<100)|1,7,0) }; _Static_assert(N==7, \"wide condition\");\n"));
assert(sizeof("enum { A=4 }; typedef int T [[gnu::aligned(A << 2)]]; _Static_assert(_Alignof(T)==16, \"raw binding\");\n")-1==strlen("enum { A=4 }; typedef int T [[gnu::aligned(A << 2)]]; _Static_assert(_Alignof(T)==16, \"raw binding\");\n"));
assert(sizeof("_Static_assert(!__builtin_signbit(0.0f*__builtin_inff()) && !__builtin_signbit(0.0f/0.0f),\"float NaN\");")-1==strlen("_Static_assert(!__builtin_signbit(0.0f*__builtin_inff()) && !__builtin_signbit(0.0f/0.0f),\"float NaN\");"));
assert(sizeof("type name sibling prototypes reuse names")-1==strlen("type name sibling prototypes reuse names"));
assert(sizeof("tag attribute evaluated fault")-1==strlen("tag attribute evaluated fault"));
assert(sizeof("int x [[gnu::aligned(1+2)]];\n")-1==strlen("int x [[gnu::aligned(1+2)]];\n"));
assert(sizeof("enum { N=sizeof(__typeof__((int(void)){0})) };\n")-1==strlen("enum { N=sizeof(__typeof__((int(void)){0})) };\n"));
assert(sizeof("struct S { int x; }; enum { A=__builtin_offsetof(struct S,missing) };\n")-1==strlen("struct S { int x; }; enum { A=__builtin_offsetof(struct S,missing) };\n"));
assert(sizeof("typedef int I; int f(void) { return _Generic(1,int:1,I:2); }\n")-1==strlen("typedef int I; int f(void) { return _Generic(1,int:1,I:2); }\n"));
assert(sizeof("bitcast rejects atomic source storage")-1==strlen("bitcast rejects atomic source storage"));
assert(sizeof("declaration bit integer type name")-1==strlen("declaration bit integer type name"));
assert(sizeof("declaration builtin call of a volatile object")-1==strlen("declaration builtin call of a volatile object"));
assert(sizeof("typedef int T; enum { A=sizeof(int (*)(int (*cb)(int T),T x)) }; _Static_assert(A==8,\"typedef restored\");\n")-1==strlen("typedef int T; enum { A=sizeof(int (*)(int (*cb)(int T),T x)) }; _Static_assert(A==8,\"typedef restored\");\n"));
assert(sizeof("C23 raw attribute evaluated fault")-1==strlen("C23 raw attribute evaluated fault"));
assert(sizeof("struct S{int x;}; int f(void) { __typeof__(({struct S s; if(s){} 1;})) t=1; return t; }\n")-1==strlen("struct S{int x;}; int f(void) { __typeof__(({struct S s; if(s){} 1;})) t=1; return t; }\n"));
assert(sizeof("declaration builtin invalid zero evaluated")-1==strlen("declaration builtin invalid zero evaluated"));
assert(sizeof("statement expression size is constant")-1==strlen("statement expression size is constant"));
assert(sizeof("typedef int T [[gnu::aligned(1 << 4)]]; _Static_assert(_Alignof(T)==16, \"raw arithmetic\");\n")-1==strlen("typedef int T [[gnu::aligned(1 << 4)]]; _Static_assert(_Alignof(T)==16, \"raw arithmetic\");\n"));
assert(sizeof("enum { N=1?7:1/0 }; int a[N]; _Static_assert(sizeof a==28, \"conditional\");\n")-1==strlen("enum { N=1?7:1/0 }; int a[N]; _Static_assert(sizeof a==28, \"conditional\");\n"));
assert(sizeof("int f(int n) { __typeof__(({int x=n; __typeof__(({long y=x; y;})) z=1; z;})) t=1; _Static_assert(sizeof t==sizeof(long), \"nested local result\"); return t; }\n")-1==strlen("int f(int n) { __typeof__(({int x=n; __typeof__(({long y=x; y;})) z=1; z;})) t=1; _Static_assert(sizeof t==sizeof(long), \"nested local result\"); return t; }\n"));
assert(sizeof("struct S; union U{struct S*p;void*q;} __attribute__((transparent_union)); int f(void){return _Generic(0,int(*)(union U):1,int(*)(struct S*):2,default:0);}\n")-1==strlen("struct S; union U{struct S*p;void*q;} __attribute__((transparent_union)); int f(void){return _Generic(0,int(*)(union U):1,int(*)(struct S*):2,default:0);}\n"));
assert(sizeof("enum { A=sizeof(int (*)(int x,int (*cb)(int x,int y),int y)) }; _Static_assert(A==8,\"nested scopes\");\n")-1==strlen("enum { A=sizeof(int (*)(int x,int (*cb)(int x,int y),int y)) }; _Static_assert(A==8,\"nested scopes\");\n"));
assert(sizeof("declaration typeof preserves array")-1==strlen("declaration typeof preserves array"));
assert(sizeof("int f(void) { __typeof__(({int *x=1; x;})) t=0; return 0; }\n")-1==strlen("int f(void) { __typeof__(({int *x=1; x;})) t=0; return 0; }\n"));
assert(sizeof("_Static_assert(__builtin_signbit(-(__builtin_inf()-__builtin_inf())) && __builtin_signbit(1.0-(-__builtin_nan(\"\"))),\"NaN signs\");")-1==strlen("_Static_assert(__builtin_signbit(-(__builtin_inf()-__builtin_inf())) && __builtin_signbit(1.0-(-__builtin_nan(\"\"))),\"NaN signs\");"));
assert(sizeof("int x; int f(void) { double x; _Static_assert(_Generic(x,double:1,default:0), \"inner identity\"); return 1; } _Static_assert(_Generic(x,int:1,default:0), \"outer identity\");\n")-1==strlen("int x; int f(void) { double x; _Static_assert(_Generic(x,double:1,default:0), \"inner identity\"); return 1; } _Static_assert(_Generic(x,int:1,default:0), \"outer identity\");\n"));
assert(sizeof("generic distinct pointer shapes share a nominal key")-1==strlen("generic distinct pointer shapes share a nominal key"));
assert(sizeof("int x __attribute__((aligned(32))); typedef int T [[gnu::aligned(__alignof__((x)))]]; _Static_assert(_Alignof(T)==32, \"raw object\");\n")-1==strlen("int x __attribute__((aligned(32))); typedef int T [[gnu::aligned(__alignof__((x)))]]; _Static_assert(_Alignof(T)==32, \"raw object\");\n"));
assert(sizeof("C23 raw attribute cast and conditional")-1==strlen("C23 raw attribute cast and conditional"));
assert(sizeof("tag attribute nested new identity")-1==strlen("tag attribute nested new identity"));
assert(sizeof("typedef float vf __attribute__((vector_size(16)));\n")-1==strlen("typedef float vf __attribute__((vector_size(16)));\n"));
assert(sizeof("raw earlier incomplete query precedes later missing name")-1==strlen("raw earlier incomplete query precedes later missing name"));
assert(sizeof("declaration builtin calls of const member, element and floating objects")-1==strlen("declaration builtin calls of const member, element and floating objects"));
assert(sizeof("statement expression local declaration type query")-1==strlen("statement expression local declaration type query"));
assert(sizeof("bitcast half operand is not promoted")-1==strlen("bitcast half operand is not promoted"));
assert(sizeof("statement expression loop type query")-1==strlen("statement expression loop type query"));
assert(sizeof("typedef int V __attribute__((vector_size(16))); V a; int i; enum { N=sizeof(__builtin_shufflevector(a,a,0,1,2,i)) };\n")-1==strlen("typedef int V __attribute__((vector_size(16))); V a; int i; enum { N=sizeof(__builtin_shufflevector(a,a,0,1,2,i)) };\n"));
assert(sizeof("raw constant query proof propagates saturated conversion")-1==strlen("raw constant query proof propagates saturated conversion"));
assert(sizeof("enum { A=sizeof(int[B]), B=3 };\n")-1==strlen("enum { A=sizeof(int[B]), B=3 };\n"));
assert(sizeof("declaration GNU choose rejects statement with wrapped integer")-1==strlen("declaration GNU choose rejects statement with wrapped integer"));
assert(sizeof("!__builtin_signbit((__bf16)__builtin_inf()+(__bf16)-__builtin_inf()),\"bf16 NaN\");\n")-1==strlen("!__builtin_signbit((__bf16)__builtin_inf()+(__bf16)-__builtin_inf()),\"bf16 NaN\");\n"));
assert(sizeof("_Static_assert(!__builtin_signbit(__builtin_inf()-__builtin_inf()) && !__builtin_signbit(0.0*-__builtin_inf()),\"double NaN\");")-1==strlen("_Static_assert(!__builtin_signbit(__builtin_inf()-__builtin_inf()) && !__builtin_signbit(0.0*-__builtin_inf()),\"double NaN\");"));
assert(sizeof("statement expression initializer constraints remain checked")-1==strlen("statement expression initializer constraints remain checked"));
assert(sizeof("int f(int n) { int x=0; __typeof__(({x+=50;n;})) t=1; _Static_assert(sizeof t==sizeof n, \"statement result\"); return x+t; }\n")-1==strlen("int f(int n) { int x=0; __typeof__(({x+=50;n;})) t=1; _Static_assert(sizeof t==sizeof n, \"statement result\"); return x+t; }\n"));
assert(sizeof("struct S { char bytes[sizeof(struct Missing) -\nsizeof(missing)]; };\n")-1==strlen("struct S { char bytes[sizeof(struct Missing) -\nsizeof(missing)]; };\n"));
assert(sizeof("bitcast rejects mismatched raw sizes")-1==strlen("bitcast rejects mismatched raw sizes"));
assert(sizeof("_Static_assert(!__builtin_signbit(__builtin_infl()+-__builtin_infl()) && !__builtin_signbit(0.0L/0.0L),\"long double NaN\");")-1==strlen("_Static_assert(!__builtin_signbit(__builtin_infl()+-__builtin_infl()) && !__builtin_signbit(0.0L/0.0L),\"long double NaN\");"));
assert(sizeof("declaration object alignment")-1==strlen("declaration object alignment"));
assert(sizeof("enum { A=sizeof(int (*)(int x,int y))+sizeof(int (*)(int x,int y)) }; _Static_assert(A==16,\"separate prototypes\");\n")-1==strlen("enum { A=sizeof(int (*)(int x,int y))+sizeof(int (*)(int x,int y)) }; _Static_assert(A==16,\"separate prototypes\");\n"));
assert(sizeof("bitcast raw attribute is not an integer constant expression")-1==strlen("bitcast raw attribute is not an integer constant expression"));
assert(sizeof("static const int k=5; int sink; enum { E=__builtin_add_overflow(k,1,&sink) };\n")-1==strlen("static const int k=5; int sink; enum { E=__builtin_add_overflow(k,1,&sink) };\n"));
assert(sizeof("nested statement expression type query")-1==strlen("nested statement expression type query"));
assert(sizeof("_Static_assert((__bf16)1+(__bf16)2==3,\"bf16 sum\");")-1==strlen("_Static_assert((__bf16)1+(__bf16)2==3,\"bf16 sum\");"));
assert(sizeof("raw abstract function query")-1==strlen("raw abstract function query"));
assert(sizeof("nested selections retain vector values and lvalues")-1==strlen("nested selections retain vector values and lvalues"));
assert(sizeof("struct S { int x; }; enum { N=sizeof(struct __attribute__((aligned(3))) S) };\n")-1==strlen("struct S { int x; }; enum { N=sizeof(struct __attribute__((aligned(3))) S) };\n"));
assert(sizeof("struct S { int x; };\n")-1==strlen("struct S { int x; };\n"));
assert(sizeof("declaration nested generic selection")-1==strlen("declaration nested generic selection"));
assert(sizeof("struct S; enum { N=_Generic(1,int:1,struct S:2,void:3) }; _Static_assert(N==1, \"int\"); struct S { int x; };\n")-1==strlen("struct S; enum { N=_Generic(1,int:1,struct S:2,void:3) }; _Static_assert(N==1, \"int\"); struct S { int x; };\n"));
assert(sizeof("declaration vector conversion attributed abstract destination")-1==strlen("declaration vector conversion attributed abstract destination"));
assert(sizeof("declaration missing offsetof member")-1==strlen("declaration missing offsetof member"));
assert(sizeof("C23 raw attribute integer builtin")-1==strlen("C23 raw attribute integer builtin"));
assert(sizeof("deep selected choose expressions")-1==strlen("deep selected choose expressions"));
assert(sizeof("constant type names retain repeated modifier semantics")-1==strlen("constant type names retain repeated modifier semantics"));
assert(sizeof("enum{N=_Generic(0,int(*)():1,int(*)(double):2,default:0)};\n")-1==strlen("enum{N=_Generic(0,int(*)():1,int(*)(double):2,default:0)};\n"));
assert(sizeof("enum { A=sizeof((1,2.0)) }; _Static_assert(A==8, \"comma\");\n")-1==strlen("enum { A=sizeof((1,2.0)) }; _Static_assert(A==8, \"comma\");\n"));
assert(sizeof("C23 raw attribute typeof query")-1==strlen("C23 raw attribute typeof query"));
assert(sizeof("typeof statement expression effects are unevaluated")-1==strlen("typeof statement expression effects are unevaluated"));
assert(sizeof("GNU choose exact selected lvalue")-1==strlen("GNU choose exact selected lvalue"));
assert(sizeof("declaration duplicate callback parameter")-1==strlen("declaration duplicate callback parameter"));
assert(sizeof("enum { A=sizeof(_Atomic(int)), B=sizeof(_Atomic int), C=sizeof(const _Atomic(int)), D=sizeof(int * _Atomic) }; _Static_assert(A==4 && B==4 && C==4 && D==8, \"atomic\");\n")-1==strlen("enum { A=sizeof(_Atomic(int)), B=sizeof(_Atomic int), C=sizeof(const _Atomic(int)), D=sizeof(int * _Atomic) }; _Static_assert(A==4 && B==4 && C==4 && D==8, \"atomic\");\n"));
assert(sizeof("_Static_assert(__builtin_types_compatible_p(typeof((struct S){0}), struct S), \"record\");\n")-1==strlen("_Static_assert(__builtin_types_compatible_p(typeof((struct S){0}), struct S), \"record\");\n"));
assert(sizeof("typedef short T; T object; enum { N=sizeof(T)+sizeof object }; int a[N]; _Static_assert(sizeof a==16, \"bindings\");\n")-1==strlen("typedef short T; T object; enum { N=sizeof(T)+sizeof object }; int a[N]; _Static_assert(sizeof a==16, \"bindings\");\n"));
assert(sizeof("int f(int p) { const int w=p; switch (0) { case __builtin_popcount(w): return 1; } return 0; }\n")-1==strlen("int f(int p) { const int w=p; switch (0) { case __builtin_popcount(w): return 1; } return 0; }\n"));
assert(sizeof("half invalid constant arithmetic has Clang NaN signs")-1==strlen("half invalid constant arithmetic has Clang NaN signs"));
assert(sizeof("declaration named callback type")-1==strlen("declaration named callback type"));
assert(sizeof("half constants round each operation before the next")-1==strlen("half constants round each operation before the next"));
assert(sizeof("typedef long double T; typedef int I [[gnu::aligned(sizeof(T))]]; _Static_assert(_Alignof(I)==16, \"raw typedef\");\n")-1==strlen("typedef long double T; typedef int I [[gnu::aligned(sizeof(T))]]; _Static_assert(_Alignof(I)==16, \"raw typedef\");\n"));
assert(sizeof("real invalid constant arithmetic has Clang NaN signs")-1==strlen("real invalid constant arithmetic has Clang NaN signs"));
assert(sizeof("enum { N=sizeof(__typeof__((int[2]){0})) }; _Static_assert(N==2*sizeof(int), \"array\");\n")-1==strlen("enum { N=sizeof(__typeof__((int[2]){0})) }; _Static_assert(N==2*sizeof(int), \"array\");\n"));
assert(sizeof("enum { N=1 }; struct S { int a[3]; }; int f(void) { enum { N=2 }; return __builtin_offsetof(struct S,a[N]); } _Static_assert(__builtin_offsetof(struct S,a[N])==4, \"outer enum\");\n")-1==strlen("enum { N=1 }; struct S { int a[3]; }; int f(void) { enum { N=2 }; return __builtin_offsetof(struct S,a[N]); } _Static_assert(__builtin_offsetof(struct S,a[N])==4, \"outer enum\");\n"));
assert(sizeof("int f(void) { return _Generic(1,int:1,default:missing); }\n")-1==strlen("int f(void) { return _Generic(1,int:1,default:missing); }\n"));
assert(sizeof("declaration vector conversion rejects scalar destination")-1==strlen("declaration vector conversion rejects scalar destination"));
assert(sizeof("enum { N=__builtin_choose_expr((int)(1.5+2.5),7,0) };\n")-1==strlen("enum { N=__builtin_choose_expr((int)(1.5+2.5),7,0) };\n"));
assert(sizeof("int x __attribute__((aligned(32))); enum { A=__alignof__(x), B=__alignof__((x)) }; _Static_assert(A==32 && B==32, \"object alignment\");\n")-1==strlen("int x __attribute__((aligned(32))); enum { A=__alignof__(x), B=__alignof__((x)) }; _Static_assert(A==32 && B==32, \"object alignment\");\n"));
assert(sizeof("declaration generic selection")-1==strlen("declaration generic selection"));
assert(sizeof("struct S{int x;}; typedef struct S T __attribute__((aligned(16))); int f(struct S x){return _Generic(x,struct S:1,T:2);}\n")-1==strlen("struct S{int x;}; typedef struct S T __attribute__((aligned(16))); int f(struct S x){return _Generic(x,struct S:1,T:2);}\n"));
assert(sizeof("declaration member offset")-1==strlen("declaration member offset"));
assert(sizeof("int x; int f(void) { __builtin_choose_expr(1,x,0)=3; return x; }\n")-1==strlen("int x; int f(void) { __builtin_choose_expr(1,x,0)=3; return x; }\n"));
assert(sizeof("enum { N=_Generic(1,default:2,default:3) };\n")-1==strlen("enum { N=_Generic(1,default:2,default:3) };\n"));
assert(sizeof("generic compatible function pointers")-1==strlen("generic compatible function pointers"));
assert(sizeof("enum { A=1, B=3, V=7 }; int values[]={[A]=V,[B]=V+1}; _Static_assert(sizeof values==16, \"inferred after initializer\"); int f(void){enum {A=2,B=4}; int local[]={[A]=V,[B]=V}; return sizeof local==20;}\n")-1==strlen("enum { A=1, B=3, V=7 }; int values[]={[A]=V,[B]=V+1}; _Static_assert(sizeof values==16, \"inferred after initializer\"); int f(void){enum {A=2,B=4}; int local[]={[A]=V,[B]=V}; return sizeof local==20;}\n"));
assert(sizeof("GNU choose rejected nonconstant source condition")-1==strlen("GNU choose rejected nonconstant source condition"));
assert(sizeof("separate type names reuse prototype names")-1==strlen("separate type names reuse prototype names"));
assert(sizeof("_Static_assert(__builtin_isnan((__bf16)__builtin_inf()+(__bf16)-__builtin_inf()) && ")-1==strlen("_Static_assert(__builtin_isnan((__bf16)__builtin_inf()+(__bf16)-__builtin_inf()) && "));
assert(sizeof("typedef int T [[gnu::aligned(sizeof(struct Missing) +\nsizeof(missing))]];\n")-1==strlen("typedef int T [[gnu::aligned(sizeof(struct Missing) +\nsizeof(missing))]];\n"));
assert(sizeof("struct S { int a[3]; }; enum { A=sizeof(((struct S*)0)->a) }; _Static_assert(A==12, \"member\");\n")-1==strlen("struct S { int a[3]; }; enum { A=sizeof(((struct S*)0)->a) }; _Static_assert(A==12, \"member\");\n"));
assert(sizeof("!__builtin_signbit((_Float16)__builtin_inf()+(_Float16)-__builtin_inf()),\"half NaN\");")-1==strlen("!__builtin_signbit((_Float16)__builtin_inf()+(_Float16)-__builtin_inf()),\"half NaN\");"));
assert(sizeof("enum { A=8, N=sizeof(struct __attribute__((aligned(A))) S*) }; _Static_assert(N==8, \"tag activation after attribute use\");\n")-1==strlen("enum { A=8, N=sizeof(struct __attribute__((aligned(A))) S*) }; _Static_assert(N==8, \"tag activation after attribute use\");\n"));
assert(sizeof("struct S { unsigned x:3; }; enum { A=__builtin_offsetof(struct S,x) };\n")-1==strlen("struct S { unsigned x:3; }; enum { A=__builtin_offsetof(struct S,x) };\n"));
assert(sizeof("typedef int V __attribute__((vector_size(16))); V a; enum { N=sizeof(__builtin_convertvector(a,int)) };\n")-1==strlen("typedef int V __attribute__((vector_size(16))); V a; enum { N=sizeof(__builtin_convertvector(a,int)) };\n"));
assert(sizeof("int x [[gnu::aligned(0?16:1/0)]];\n")-1==strlen("int x [[gnu::aligned(0?16:1/0)]];\n"));
assert(sizeof("#define O __attribute__((overloadable))\nint f(int) O; double f(double) O;\n_Static_assert(__builtin_types_compatible_p(__typeof__(__builtin_constant_p(f)),int),\"ambiguous\");\n")-1==strlen("#define O __attribute__((overloadable))\nint f(int) O; double f(double) O;\n_Static_assert(__builtin_types_compatible_p(__typeof__(__builtin_constant_p(f)),int),\"ambiguous\");\n"));
assert(sizeof("generic unselected fault")-1==strlen("generic unselected fault"));
assert(sizeof("declaration GNU choose rejects computed floating cast")-1==strlen("declaration GNU choose rejects computed floating cast"));
assert(sizeof("enum { A=__builtin_constant_p((int)1.0e100), B=__builtin_constant_p((int)1.0e100+1), C=__builtin_constant_p((unsigned)-1.0e100), D=__builtin_constant_p((int)__builtin_nan(\"\")), E=__builtin_constant_p(__builtin_popcount((int)1.0e100)), F=__builtin_constant_p(1?(int)1.0e100:0), G=__builtin_constant_p(_Generic(0,int:(int)1.0e100,default:0)), H=__builtin_constant_p((__int128)1.0e100+1) }; _Static_assert(A&&B&&C&&D&&E&&F&&G&&H,\"proof\"); int g(int x){_Static_assert(!__builtin_constant_p(x+++(int)1.0e100),\"effects\");return x;}\n")-1==strlen("enum { A=__builtin_constant_p((int)1.0e100), B=__builtin_constant_p((int)1.0e100+1), C=__builtin_constant_p((unsigned)-1.0e100), D=__builtin_constant_p((int)__builtin_nan(\"\")), E=__builtin_constant_p(__builtin_popcount((int)1.0e100)), F=__builtin_constant_p(1?(int)1.0e100:0), G=__builtin_constant_p(_Generic(0,int:(int)1.0e100,default:0)), H=__builtin_constant_p((__int128)1.0e100+1) }; _Static_assert(A&&B&&C&&D&&E&&F&&G&&H,\"proof\"); int g(int x){_Static_assert(!__builtin_constant_p(x+++(int)1.0e100),\"effects\");return x;}\n"));
assert(sizeof("typedef int I4 __attribute__((vector_size(16))); typedef float F4 __attribute__((vector_size(16))); I4 a; enum { N=sizeof(__builtin_convertvector(a,__typeof__(__builtin_convertvector(a,F4)))) }; _Static_assert(N==16, \"nested destination type job\");\n")-1==strlen("typedef int I4 __attribute__((vector_size(16))); typedef float F4 __attribute__((vector_size(16))); I4 a; enum { N=sizeof(__builtin_convertvector(a,__typeof__(__builtin_convertvector(a,F4)))) }; _Static_assert(N==16, \"nested destination type job\");\n"));
assert(sizeof("enum { N=0?7:1/0 };\n")-1==strlen("enum { N=0?7:1/0 };\n"));
assert(sizeof("_Static_assert((_Float16)3*(_Float16)2==6,\"half product\");")-1==strlen("_Static_assert((_Float16)3*(_Float16)2==6,\"half product\");"));
assert(sizeof("enum E{E0}; enum{N=_Generic(0,enum E:1,unsigned int:2,default:0)};\n")-1==strlen("enum E{E0}; enum{N=_Generic(0,enum E:1,unsigned int:2,default:0)};\n"));
assert(sizeof("int f(int n) { return sizeof(__typeof__((int[n]){0})); }\n")-1==strlen("int f(int n) { return sizeof(__typeof__((int[n]){0})); }\n"));
assert(sizeof("@nested-attributes")-1==strlen("@nested-attributes"));
assert(sizeof("declaration prior enumerator")-1==strlen("declaration prior enumerator"));
assert(sizeof("source anonymous record offset retains member typedef identity")-1==strlen("source anonymous record offset retains member typedef identity"));
assert(sizeof("generic qualifier conversion")-1==strlen("generic qualifier conversion"));
assert(sizeof("raw abstract function pointer query")-1==strlen("raw abstract function pointer query"));
assert(sizeof("void f(int n) { enum { N=sizeof(({n++;n;})) }; _Static_assert(N==sizeof n, \"unevaluated statement size\"); }\n")-1==strlen("void f(int n) { enum { N=sizeof(({n++;n;})) }; _Static_assert(N==sizeof n, \"unevaluated statement size\"); }\n"));
assert(sizeof("enum { A=sizeof(unsigned _BitInt(17)), B=sizeof(_BitInt(1+16)), C=sizeof(unsigned _BitInt(1)) }; _Static_assert(A==4 && B==4 && C==1, \"bit int\");\n")-1==strlen("enum { A=sizeof(unsigned _BitInt(17)), B=sizeof(_BitInt(1+16)), C=sizeof(unsigned _BitInt(1)) }; _Static_assert(A==4 && B==4 && C==1, \"bit int\");\n"));
assert(sizeof("source member offset binding identity")-1==strlen("source member offset binding identity"));
assert(sizeof("deep unselected choose expressions")-1==strlen("deep unselected choose expressions"));
assert(sizeof("earlier missing name precedes later incomplete query")-1==strlen("earlier missing name precedes later incomplete query"));
assert(sizeof("enum { N=__builtin_bit_cast(_Bool,(unsigned char)2) };\n")-1==strlen("enum { N=__builtin_bit_cast(_Bool,(unsigned char)2) };\n"));
assert(sizeof("int a[__builtin_ctz(8)]; _Static_assert(sizeof a==12, \"builtin bound\");\n")-1==strlen("int a[__builtin_ctz(8)]; _Static_assert(sizeof a==12, \"builtin bound\");\n"));
assert(sizeof("enum { A=sizeof missing };\n")-1==strlen("enum { A=sizeof missing };\n"));
assert(sizeof("abstract function ABI prefix and grouped attributes")-1==strlen("abstract function ABI prefix and grouped attributes"));
assert(sizeof("declaration GNU choose expression")-1==strlen("declaration GNU choose expression"));
assert(sizeof("struct S; int f(void) { return _Generic(1,int:1,struct S:2,int[]:3); } struct S { int x; };\n")-1==strlen("struct S; int f(void) { return _Generic(1,int:1,struct S:2,int[]:3); } struct S { int x; };\n"));
assert(sizeof("declaration invalid atomic type")-1==strlen("declaration invalid atomic type"));
assert(sizeof("typedef int I4 __attribute__((vector_size(16))); typedef float F4 __attribute__((vector_size(16))); I4 a; typedef int T [[gnu::aligned(sizeof(__builtin_convertvector(a,F4)))]]; _Static_assert(_Alignof(T)==16, \"raw convert destination\");\n")-1==strlen("typedef int I4 __attribute__((vector_size(16))); typedef float F4 __attribute__((vector_size(16))); I4 a; typedef int T [[gnu::aligned(sizeof(__builtin_convertvector(a,F4)))]]; _Static_assert(_Alignof(T)==16, \"raw convert destination\");\n"));
assert(sizeof("declaration sizeof pointer member")-1==strlen("declaration sizeof pointer member"));
assert(sizeof("int values[]={1,\nsizeof values};\n")-1==strlen("int values[]={1,\nsizeof values};\n"));
assert(sizeof("nested type array bound")-1==strlen("nested type array bound"));
assert(sizeof("typedef int F(int) __attribute__((sysv_abi)); enum { N=sizeof(F __attribute__((ms_abi)) *) };\n")-1==strlen("typedef int F(int) __attribute__((sysv_abi)); enum { N=sizeof(F __attribute__((ms_abi)) *) };\n"));
assert(sizeof("int f(int n) { __typeof__(({int x[2]={n,n+1}; x[0];})) t=1; return t; }\n")-1==strlen("int f(int n) { __typeof__(({int x[2]={n,n+1}; x[0];})) t=1; return t; }\n"));
assert(sizeof("deep unselected generic expressions")-1==strlen("deep unselected generic expressions"));
assert(sizeof("struct S { char c; int a[3]; }; _Static_assert(__builtin_offsetof(struct S,a[2])==12, \"offset\");\n")-1==strlen("struct S { char c; int a[3]; }; _Static_assert(__builtin_offsetof(struct S,a[2])==12, \"offset\");\n"));
assert(sizeof("enum { A=__builtin_ctz(0) };\n")-1==strlen("enum { A=__builtin_ctz(0) };\n"));
assert(sizeof("_Static_assert(!__builtin_signbit(0.0/-0.0) && !__builtin_signbit(-__builtin_inf()/__builtin_inf()),\"double quotient NaN\");")-1==strlen("_Static_assert(!__builtin_signbit(0.0/-0.0) && !__builtin_signbit(-__builtin_inf()/__builtin_inf()),\"double quotient NaN\");"));
assert(sizeof("statement expression control type query")-1==strlen("statement expression control type query"));
assert(sizeof("declaration vector memory builtin type query")-1==strlen("declaration vector memory builtin type query"));
assert(sizeof("enum { A=sizeof(int (*)(register int x,int y)) }; _Static_assert(A==8, \"callback\");\n")-1==strlen("enum { A=sizeof(int (*)(register int x,int y)) }; _Static_assert(A==8, \"callback\");\n"));
assert(sizeof("enum { A=sizeof(int (*)(void bad,\nint x,int x)) };\n")-1==strlen("enum { A=sizeof(int (*)(void bad,\nint x,int x)) };\n"));
assert(sizeof("enum { N=__builtin_bit_cast(__typeof__(__builtin_bit_cast(unsigned,1)),16) }; _Static_assert(N==16,\"nested bitcast\");\n")-1==strlen("enum { N=__builtin_bit_cast(__typeof__(__builtin_bit_cast(unsigned,1)),16) }; _Static_assert(N==16,\"nested bitcast\");\n"));
assert(sizeof("enum { N=sizeof(struct __attribute__((aligned(sizeof(struct S*)))) S*) }; _Static_assert(N==8, \"nested tag identity\");\n")-1==strlen("enum { N=sizeof(struct __attribute__((aligned(sizeof(struct S*)))) S*) }; _Static_assert(N==8, \"nested tag identity\");\n"));
assert(sizeof("declaration atomic type names")-1==strlen("declaration atomic type names"));
assert(sizeof("GNU real expression folds in integer constant context")-1==strlen("GNU real expression folds in integer constant context"));
assert(sizeof("typedef short Element; enum { N=3 }; _Static_assert(__builtin_offsetof(struct {char c; struct {Element a[N]; long x;} inner;},inner.x)==16, \"nested offset\");\n")-1==strlen("typedef short Element; enum { N=3 }; _Static_assert(__builtin_offsetof(struct {char c; struct {Element a[N]; long x;} inner;},inner.x)==16, \"nested offset\");\n"));
assert(sizeof("_Static_assert(__builtin_isnan((_Float16)__builtin_inf()+(_Float16)-__builtin_inf()) && ")-1==strlen("_Static_assert(__builtin_isnan((_Float16)__builtin_inf()+(_Float16)-__builtin_inf()) && "));
assert(sizeof("_Static_assert((_Float16)1+(_Float16)2==3,\"half sum\");")-1==strlen("_Static_assert((_Float16)1+(_Float16)2==3,\"half sum\");"));
assert(sizeof("int f(void) { __typeof__((__typeof__((struct S){0})){1}) s = {2}; return s.x; }\n")-1==strlen("int f(void) { __typeof__((__typeof__((struct S){0})){1}) s = {2}; return s.x; }\n"));
assert(sizeof("integer rank and cast in array bound")-1==strlen("integer rank and cast in array bound"));
assert(sizeof("declaration object shadow")-1==strlen("declaration object shadow"));
assert(sizeof("declaration alignof callback array")-1==strlen("declaration alignof callback array"));
assert(sizeof("statement expression nested declaration type query")-1==strlen("statement expression nested declaration type query"));
assert(sizeof("raw attribute vector builtin arbitrary argument slice")-1==strlen("raw attribute vector builtin arbitrary argument slice"));
assert(sizeof("typedef int T [[gnu::aligned(sizeof(int(*)(int)))]]; _Static_assert(_Alignof(T)==8,\"raw function pointer\");\n")-1==strlen("typedef int T [[gnu::aligned(sizeof(int(*)(int)))]]; _Static_assert(_Alignof(T)==8,\"raw function pointer\");\n"));
assert(sizeof("_Static_assert(__builtin_signbit(-__builtin_nan(\"\")+__builtin_nan(\"\")) && ")-1==strlen("_Static_assert(__builtin_signbit(-__builtin_nan(\"\")+__builtin_nan(\"\")) && "));
assert(sizeof("@long-shuffle")-1==strlen("@long-shuffle"));
assert(sizeof("_Static_assert(((__bf16)256+(__bf16)1)-(__bf16)256==0,\"bf16 midpoint\");")-1==strlen("_Static_assert(((__bf16)256+(__bf16)1)-(__bf16)256==0,\"bf16 midpoint\");"));
assert(sizeof("static int n=5; _Static_assert(__builtin_popcount(n)==2, \"\");\n")-1==strlen("static int n=5; _Static_assert(__builtin_popcount(n)==2, \"\");\n"));
assert(sizeof("declaration typeof compound literal variable array rejected")-1==strlen("declaration typeof compound literal variable array rejected"));
assert(sizeof("statement expression final declaration has void type")-1==strlen("statement expression final declaration has void type"));
assert(sizeof("enum { A=__builtin_choose_expr(1,-(2+3),0), B=_Generic(0,int:2*3+1,default:0), C=__builtin_choose_expr(0,0,_Generic(0,int:(2,7),default:0)) }; _Static_assert(A==-5 && B==7 && C==7,\"selection roots\");\n")-1==strlen("enum { A=__builtin_choose_expr(1,-(2+3),0), B=_Generic(0,int:2*3+1,default:0), C=__builtin_choose_expr(0,0,_Generic(0,int:(2,7),default:0)) }; _Static_assert(A==-5 && B==7 && C==7,\"selection roots\");\n"));
assert(sizeof("declaration short circuit")-1==strlen("declaration short circuit"));
assert(sizeof("enum { A=sizeof(int (*)(int x,int x)) };\nint f(void){return missing;}\n")-1==strlen("enum { A=sizeof(int (*)(int x,int x)) };\nint f(void){return missing;}\n"));
assert(sizeof("int f(void) {\n __typeof__(({\n int *x=1;\n x;\n })) t=0;\n return 0;\n}\n")-1==strlen("int f(void) {\n __typeof__(({\n int *x=1;\n x;\n })) t=0;\n return 0;\n}\n"));
assert(sizeof("nested type name parameter does not hide outer typedef")-1==strlen("nested type name parameter does not hide outer typedef"));
assert(sizeof("declaration overflow builtin sizeof")-1==strlen("declaration overflow builtin sizeof"));
assert(sizeof("enum { N=(int)(1.5+2.5) };\n")-1==strlen("enum { N=(int)(1.5+2.5) };\n"));
assert(sizeof("incomplete array remains incomplete inside its own initializer")-1==strlen("incomplete array remains incomplete inside its own initializer"));
assert(sizeof("declaration builtin invalid zero unevaluated")-1==strlen("declaration builtin invalid zero unevaluated"));
assert(sizeof("declaration sizeof arithmetic")-1==strlen("declaration sizeof arithmetic"));
assert(sizeof("static const int x=5; _Static_assert(__builtin_popcount(x)==2, \"const object\"); static int s=__builtin_popcount(x); int bound[__builtin_popcount(x)]; enum { F=__builtin_ffs(x) }; struct W { int field:__builtin_popcount(x); }; int f(void) { const int y=6; switch (0) { case __builtin_popcount(y)-2: return 1; } return bound[0]+s; }\n")-1==strlen("static const int x=5; _Static_assert(__builtin_popcount(x)==2, \"const object\"); static int s=__builtin_popcount(x); int bound[__builtin_popcount(x)]; enum { F=__builtin_ffs(x) }; struct W { int field:__builtin_popcount(x); }; int f(void) { const int y=6; switch (0) { case __builtin_popcount(y)-2: return 1; } return bound[0]+s; }\n"));
assert(sizeof("@wide-truth-source")-1==strlen("@wide-truth-source"));
assert(sizeof("enum { A=__builtin_popcount(__builtin_bswap32(0x10203040)), B=__builtin_bswap16(0x1234) }; _Static_assert(A==5 && B==0x3412, \"nested builtin\");\n")-1==strlen("enum { A=__builtin_popcount(__builtin_bswap32(0x10203040)), B=__builtin_bswap16(0x1234) }; _Static_assert(A==5 && B==0x3412, \"nested builtin\");\n"));
assert(sizeof("declaration typeof compound literal function type rejected")-1==strlen("declaration typeof compound literal function type rejected"));
assert(sizeof("@nested-source")-1==strlen("@nested-source"));
assert(sizeof("declaration generic incomplete association")-1==strlen("declaration generic incomplete association"));
assert(sizeof("declaration typeof nested in a compound literal type")-1==strlen("declaration typeof nested in a compound literal type"));
assert(sizeof("enum { N=7?:1/0 }; int a[N]; _Static_assert(sizeof a==28, \"conditional\");\n")-1==strlen("enum { N=7?:1/0 }; int a[N]; _Static_assert(sizeof a==28, \"conditional\");\n"));
assert(sizeof("generic rejects invalid unselected expression")-1==strlen("generic rejects invalid unselected expression"));
assert(sizeof("struct S { long x; }; typedef int T [[gnu::aligned(sizeof(struct __attribute__((aligned(sizeof(struct S)))) S))]]; _Static_assert(_Alignof(T)==8, \"raw nested tag attributes\");\n")-1==strlen("struct S { long x; }; typedef int T [[gnu::aligned(sizeof(struct __attribute__((aligned(sizeof(struct S)))) S))]]; _Static_assert(_Alignof(T)==8, \"raw nested tag attributes\");\n"));
assert(sizeof("int f(int n) { __typeof__(({int x=n;})) t; return 0; }\n")-1==strlen("int f(int n) { __typeof__(({int x=n;})) t; return 0; }\n"));
assert(sizeof("unsigned long f(void){return sizeof(int (*)(int p0,int p1,int p2,int p3));}\n")-1==strlen("unsigned long f(void){return sizeof(int (*)(int p0,int p1,int p2,int p3));}\n"));
assert(sizeof("static const volatile int v=5; int bound[__builtin_popcount(v)];\n")-1==strlen("static const volatile int v=5; int bound[__builtin_popcount(v)];\n"));
assert(sizeof("_Atomic(int) x; enum { N=sizeof(__builtin_bit_cast(int,x)) };\n")-1==strlen("_Atomic(int) x; enum { N=sizeof(__builtin_bit_cast(int,x)) };\n"));
assert(sizeof("declaration overflow builtin of a const object is not ICE")-1==strlen("declaration overflow builtin of a const object is not ICE"));
assert(sizeof("__fp16 x; enum { N=sizeof(__builtin_bit_cast(unsigned short,x)), M=sizeof(__builtin_bit_cast(__fp16,(unsigned short)0x3c00)) }; _Static_assert(N==2 && M==2,\"half representation\");\n")-1==strlen("__fp16 x; enum { N=sizeof(__builtin_bit_cast(unsigned short,x)), M=sizeof(__builtin_bit_cast(__fp16,(unsigned short)0x3c00)) }; _Static_assert(N==2 && M==2,\"half representation\");\n"));
assert(sizeof("typedef long Time; int f(int select) { return select ? sizeof(Time) : __builtin_offsetof(struct { char c; Time value; },value); } _Static_assert(__builtin_offsetof(struct {char c; Time value;},value)==8, \"anonymous offset\");\n")-1==strlen("typedef long Time; int f(int select) { return select ? sizeof(Time) : __builtin_offsetof(struct { char c; Time value; },value); } _Static_assert(__builtin_offsetof(struct {char c; Time value;},value)==8, \"anonymous offset\");\n"));
assert(sizeof("declaration GNU void and function queries")-1==strlen("declaration GNU void and function queries"));
assert(sizeof("declaration GNU choose nonconstant condition")-1==strlen("declaration GNU choose nonconstant condition"));
assert(sizeof("type name nested prototypes reuse outer names")-1==strlen("type name nested prototypes reuse outer names"));
assert(sizeof("_Static_assert((_Float16)7-(_Float16)2==5,\"half difference\");")-1==strlen("_Static_assert((_Float16)7-(_Float16)2==5,\"half difference\");"));
assert(sizeof("body expression named callback type")-1==strlen("body expression named callback type"));
assert(sizeof("generic compatible record array pointers")-1==strlen("generic compatible record array pointers"));
assert(sizeof("struct S{int x;}; int f(struct S*x){return _Generic(x,struct S*:7,struct S**:2,struct S(*)[3]:3);}\n")-1==strlen("struct S{int x;}; int f(struct S*x){return _Generic(x,struct S*:7,struct S**:2,struct S(*)[3]:3);}\n"));
assert(sizeof("int f(int x) { return __builtin_choose_expr(x,1,2); }\n")-1==strlen("int f(int x) { return __builtin_choose_expr(x,1,2); }\n"));
assert(sizeof("struct S; enum { A=sizeof(struct S) };\n")-1==strlen("struct S; enum { A=sizeof(struct S) };\n"));
assert(sizeof("int a[3]; enum { N=sizeof(__typeof__(a)) }; _Static_assert(N==12, \"typeof array\");\n")-1==strlen("int a[3]; enum { N=sizeof(__typeof__(a)) }; _Static_assert(N==12, \"typeof array\");\n"));
for(size_t i=0;i<sizeof rows/sizeof *rows;i++){const CheckSourceFixture*r=rows+i;put(r->name);put(r->source);uint32_t f[]={r->rejected,r->unsupported,r->extension,r->standard,r->char_unsigned,r->undecided,r->overload_tables};assert(!r->capacity);assert(fwrite(f,4,7,stdout)==7);}}
{ const CheckSourceFixture rows[]={
        {
            .name = "enum expression completes anonymous record",
            .source = "enum { N=sizeof(struct { char x; int y; }) }; _Static_assert(N==8,\"record query\");\n",
        },
        {
            .name = "enum inline record keeps earlier operand event order",
            .source = "enum { P=4, N=P+__builtin_offsetof(struct { char p[P]; int y; },y) }; _Static_assert(N==8,\"ordered enum record uses\");\n",
        },
        {
            .name = "enum inline tag identity survives subsequent expression use",
            .source = "enum { P=4, N=P+sizeof(struct S { char a[P]; })+sizeof(struct S) }; _Static_assert(N==12 && sizeof(struct S)==4,\"tag completion identity\");\n",
        },
        {
            .name = "enum inline nested enumerator visible after its declaration",
            .source = "enum { N=sizeof(struct { enum { A=3 } e; int x[A]; })+A }; _Static_assert(N==19 && A==3,\"nested ordinary declaration\");\n",
        },
        {
            .name = "enum inline record resolves header attributes before body",
            .source = "enum { A=8, N=A+sizeof(struct __attribute__((aligned(A))) S { int x; }) }; _Static_assert(N==16 && _Alignof(struct S)==8,\"header attributes\");\n",
        },
        {
            .name = "enum inline record nested inside outer tag attribute",
            .source = "enum { N=sizeof(struct __attribute__((aligned(sizeof(struct { long x; })))) S { int x; }) }; _Static_assert(N==8,\"nested header record job\");\n",
        },
        {
            .name = "deep enum and record source jobs use explicit frames",
            .source = "@nested-records",
        },
        {
            .name = "enum inline record diagnoses missing member bound at use",
            .source = "enum { N=sizeof(struct {\nchar a[\nMISSING];\n}) };\n",
            .rejected = true,
        },
        {
            .name = "long provisional enum chain retains exact high bits until completion",
            .source = "@many-values",
        },
        {
            .name = "wide unsigned enumerator used after completion",
            .source = "enum E { A=0x80000000, B }; _Static_assert(A==2147483648U && B==2147483649U,\"values\"); "
                      "_Static_assert(_Generic(A,unsigned:1,default:0),\"common type\"); unsigned f(void){return B;}\n",
        },
        {
            .name = "all completed enumerators share signed common type",
            .source = "enum E { A=0x80000000, B, C=-1 }; _Static_assert(A==2147483648L && B==2147483649L && C==-1,\"values\"); "
                      "_Static_assert(_Generic(A,long:1,default:0) && _Generic(C,long:1,default:0),\"common type\");\n",
        },
        {
            .name = "signed int successor has provisional long and completed unsigned int",
            .source = "enum E { A=2147483647, B, C=_Generic(B,long:2,default:9) }; _Static_assert(C==2,\"provisional\"); "
                      "_Static_assert(_Generic(A,unsigned:1,default:0) && _Generic(B,unsigned:1,default:0),\"completed\");\n",
        },
        {
            .name = "unsigned int successor widens to unsigned long",
            .source = "enum E { A=0xffffffff, B, C=_Generic(B,unsigned long:2,default:9) }; _Static_assert(B==4294967296UL && C==2,\"successor\"); "
                      "_Static_assert(_Generic(A,unsigned long:1,default:0) && _Generic(C,unsigned long:1,default:0),\"completed\");\n",
        },
        {
            .name = "explicit wide expression retains its provisional type",
            .source = "enum E { A=2147483648LL, B=_Generic(A,long long:1,default:9) }; _Static_assert(B==1,\"provisional\"); "
                      "_Static_assert(_Generic(A,unsigned:1,default:0),\"completed\");\n",
        },
        {
            .name = "small explicit expression enumerators all become int",
            .source = "enum E { A=7ULL, B=(unsigned _BitInt(33))8, C=_Generic(A,int:1,default:9)+_Generic(B,int:2,default:9) }; "
                      "_Static_assert(C==3 && _Generic(A,int:1,default:0) && _Generic(B,int:1,default:0),\"small values\");\n",
        },
        {
            .name = "negative provisional successor keeps wide expression type",
            .source = "enum E { A=-2147483649LL, B, C=_Generic(B,long long:1,default:9) }; "
                      "_Static_assert(B==(-2147483647-1) && C==1 && _Generic(C,long:1,default:0),\"negative\");\n",
        },
        {
            .name = "signed bit precise successor widens by value width",
            .source = "enum E { A=(signed _BitInt(33))4294967295LL, B, C=_Generic(B,long:1,default:9) }; "
                      "_Static_assert(B==4294967296UL && C==1 && _Generic(A,unsigned long:1,default:0),\"bit precise\");\n",
        },
        {
            .name = "unsigned bit precise successor widens by value width",
            .source = "enum E { A=(unsigned _BitInt(33))8589934591ULL, B, C=_Generic(B,unsigned long:1,default:9) }; "
                      "_Static_assert(B==8589934592UL && C==1,\"bit precise\");\n",
        },
        {
            .name = "unsigned largest successor wraps without host overflow",
            .source = "enum E { A=0xffffffffffffffffULL, B, C=_Generic(B,unsigned long long:1,default:9) }; "
                      "_Static_assert(A==0xffffffffffffffffUL && B==0 && C==1 && _Generic(A,unsigned long:1,default:0),\"largest\");\n",
        },
        {
            .name = "signed largest successor wraps without host overflow",
            .source = "enum E { A=9223372036854775807LL, B, C=_Generic(B,long long:1,default:9) }; "
                      "_Static_assert(B==(-9223372036854775807LL-1) && C==1 && _Generic(A,long:1,default:0),\"largest signed\");\n",
        },
        {
            .name = "mixed unsigned maximum and negative enum values",
            .source = "enum E { A=0xffffffffffffffffULL, B=-1 }; _Static_assert(A==-1 && B==-1 && "
                      "_Generic(A,long long:1,default:0),\"common signed representation\");\n",
        },
        {
            .name = "128 bit provisional positive values retain upper bits",
            .source = "enum E { A=(unsigned __int128)1<<100, B=A>>100, C=_Generic(A,unsigned __int128:7,default:9) }; "
                      "_Static_assert(A==0 && B==1 && C==7 && _Generic(A,unsigned long long:1,default:0),\"wide exact\");\n",
        },
        {
            .name = "128 bit provisional negative values retain sign",
            .source = "enum E { A=-((__int128)1<<100), B=(A>>100)==-1, C=_Generic(A,__int128:7,default:9) }; "
                      "_Static_assert(A==0 && B==1 && C==7 && _Generic(A,long long:1,default:0),\"negative exact\");\n",
        },
        {
            .name = "128 bit unsigned successor retains provisional width",
            .source = "enum E { A=~(unsigned __int128)0, B, C=_Generic(B,unsigned __int128:7,default:9) }; "
                      "_Static_assert(A==0xffffffffffffffffULL && B==0 && C==7,\"wide successor\");\n",
        },
        {
            .name = "packed enum layout preserves int enumerator types",
            .source = "enum __attribute__((packed)) E { A=0, B=255 }; "
                      "_Static_assert(sizeof(enum E)==1 && _Alignof(enum E)==1 && _Generic(A,int:1,default:0),\"packed\");\n",
        },
        {
            .name = "aligned enum layout and wide constant types",
            .source = "enum __attribute__((aligned(16))) E { A=0x80000000 }; "
                      "_Static_assert(sizeof(enum E)==4 && _Alignof(enum E)==16 && _Generic(A,unsigned:1,default:0),\"aligned\");\n",
        },
        {
            // #1447: clang applies a fixed enum's aligned attribute after its body, which nothing asked its layout before.
            .name = "fixed enum aligned after its body",
            .source = "enum E : char { A, B } __attribute__((aligned(8))); enum __attribute__((aligned(2))) I : char { I0 } __attribute__((aligned(8))); "
                      "enum H : int { H0 } __attribute__((aligned(2))); struct S { char c; enum E e; }; "
                      "enum : short { K0 } __attribute__((aligned(4))) k; "
                      "_Static_assert(sizeof(enum E)==1 && _Alignof(enum E)==8 && _Alignof(enum I)==8 && _Alignof(enum H)==2 && sizeof(struct S)==16 && "
                      "__alignof__(k)==4,\"late alignment\");\n",
        },
        {
            .name = "nested record enum chains remain separate",
            .source = "struct S { enum E { A=0x80000000, B } x; enum F { C=-1, D } y; }; "
                      "_Static_assert(B==2147483649U && D==0 && sizeof(struct S)==8,\"nested chains\");\n",
        },
        {
            .name = "enumerator attributes preserve declaration identity",
            .source = "enum E { A __attribute__((deprecated))=0x80000000, B=A+1 }; _Static_assert(B==2147483649U,\"attribute\");\n",
        },
        {
            .name = "enumerator ignored layout attributes preserve scalar type",
            .source = "enum E { A __attribute__((packed,noreturn,vector_size(16)))=0x80000000 }; "
                      "_Static_assert(_Generic(A,unsigned:1,default:0),\"ignored attributes\");\n",
        },
        {
            .name = "enumerator aligned attribute preserves declared alignment",
            .source = "enum E { A __attribute__((aligned(8)))=0x80000000 }; "
                      "_Static_assert(__alignof__(A)==8 && _Generic(A,unsigned:1,default:0),\"alignment\");\n",
        },
        {
            .name = "enumerator mode attribute has an invalid subject",
            .source = "enum E { A __attribute__((mode(QI)))=1 };\n",
            .rejected = true,
        },
        {
            .name = "enumerator ext vector attribute is ignored",
            .source = "enum E { A __attribute__((ext_vector_type(4)))=1 }; _Static_assert(_Generic(A,int:1,default:0),\"scalar type\");\n",
        },
        {
            .name = "enum completion distinguishes small value in a wide set",
            .source = "enum E { A=1ULL<<63, B=3 }; _Static_assert(_Generic(B,unsigned long:1,default:0) && B==3,\"whole set\");\n",
        },
        {
            .name = "later enum can use completed earlier common type",
            .source = "enum E { A=0x80000000 }; enum F { B=_Generic(A,unsigned:7,default:9) }; "
                      "_Static_assert(B==7 && _Generic(B,int:1,default:0),\"source order\");\n",
        },
        {
            .name = "enumerator shadowing restores completed outer value",
            .source = "enum { A=0x80000000 }; int f(void){ { enum { A=7 }; _Static_assert(A==7,\"inner\"); } "
                      "_Static_assert(A==2147483648U,\"outer\"); return 0;}\n",
        },
        {
            .name = "enumerator still rejects noninteger floating value",
            .source = "enum E { A=1.5 };\n",
            .rejected = true,
        },
        {
            .name = "enumerator still rejects evaluated division by zero",
            .source = "enum E {\n A=\n 1/0\n};\n",
            .rejected = true,
        },
        {
            .name = "enumerator still rejects runtime object value",
            .source = "int n;\nenum E {\n A=n\n};\n",
            .rejected = true,
        },
        {
            .name = "enumerator still rejects same scope duplicate",
            .source = "enum E { A=0x80000000, A=1 };\n",
            .rejected = true,
        },
        {
            .name = "enumerator still rejects incomplete enum size",
            .source = "enum E { A=sizeof(enum E) };\n",
            .rejected = true,
        },
    };
assert(sizeof("enum E { A=9223372036854775807LL, B, C=_Generic(B,long long:1,default:9) }; ")-1==strlen("enum E { A=9223372036854775807LL, B, C=_Generic(B,long long:1,default:9) }; "));
assert(sizeof("unsigned bit precise successor widens by value width")-1==strlen("unsigned bit precise successor widens by value width"));
assert(sizeof("signed largest successor wraps without host overflow")-1==strlen("signed largest successor wraps without host overflow"));
assert(sizeof("enumerator attributes preserve declaration identity")-1==strlen("enumerator attributes preserve declaration identity"));
assert(sizeof("enum inline nested enumerator visible after its declaration")-1==strlen("enum inline nested enumerator visible after its declaration"));
assert(sizeof("int n;\nenum E {\n A=n\n};\n")-1==strlen("int n;\nenum E {\n A=n\n};\n"));
assert(sizeof("128 bit provisional negative values retain sign")-1==strlen("128 bit provisional negative values retain sign"));
assert(sizeof("negative provisional successor keeps wide expression type")-1==strlen("negative provisional successor keeps wide expression type"));
assert(sizeof("enum E : char { A, B } __attribute__((aligned(8))); enum __attribute__((aligned(2))) I : char { I0 } __attribute__((aligned(8))); ")-1==strlen("enum E : char { A, B } __attribute__((aligned(8))); enum __attribute__((aligned(2))) I : char { I0 } __attribute__((aligned(8))); "));
assert(sizeof("_Static_assert(B==8589934592UL && C==1,\"bit precise\");\n")-1==strlen("_Static_assert(B==8589934592UL && C==1,\"bit precise\");\n"));
assert(sizeof("mixed unsigned maximum and negative enum values")-1==strlen("mixed unsigned maximum and negative enum values"));
assert(sizeof("_Static_assert(_Generic(A,unsigned:1,default:0) && _Generic(B,unsigned:1,default:0),\"completed\");\n")-1==strlen("_Static_assert(_Generic(A,unsigned:1,default:0) && _Generic(B,unsigned:1,default:0),\"completed\");\n"));
assert(sizeof("_Static_assert(B==(-2147483647-1) && C==1 && _Generic(C,long:1,default:0),\"negative\");\n")-1==strlen("_Static_assert(B==(-2147483647-1) && C==1 && _Generic(C,long:1,default:0),\"negative\");\n"));
assert(sizeof("unsigned largest successor wraps without host overflow")-1==strlen("unsigned largest successor wraps without host overflow"));
assert(sizeof("enum { A=0x80000000 }; int f(void){ { enum { A=7 }; _Static_assert(A==7,\"inner\"); } ")-1==strlen("enum { A=0x80000000 }; int f(void){ { enum { A=7 }; _Static_assert(A==7,\"inner\"); } "));
assert(sizeof("enum E { A=2147483647, B, C=_Generic(B,long:2,default:9) }; _Static_assert(C==2,\"provisional\"); ")-1==strlen("enum E { A=2147483647, B, C=_Generic(B,long:2,default:9) }; _Static_assert(C==2,\"provisional\"); "));
assert(sizeof("signed int successor has provisional long and completed unsigned int")-1==strlen("signed int successor has provisional long and completed unsigned int"));
assert(sizeof("enumerator mode attribute has an invalid subject")-1==strlen("enumerator mode attribute has an invalid subject"));
assert(sizeof("enum E { A=0x80000000 }; enum F { B=_Generic(A,unsigned:7,default:9) }; ")-1==strlen("enum E { A=0x80000000 }; enum F { B=_Generic(A,unsigned:7,default:9) }; "));
assert(sizeof("enum : short { K0 } __attribute__((aligned(4))) k; ")-1==strlen("enum : short { K0 } __attribute__((aligned(4))) k; "));
assert(sizeof("_Static_assert(_Generic(A,long:1,default:0) && _Generic(C,long:1,default:0),\"common type\");\n")-1==strlen("_Static_assert(_Generic(A,long:1,default:0) && _Generic(C,long:1,default:0),\"common type\");\n"));
assert(sizeof("_Static_assert(sizeof(enum E)==4 && _Alignof(enum E)==16 && _Generic(A,unsigned:1,default:0),\"aligned\");\n")-1==strlen("_Static_assert(sizeof(enum E)==4 && _Alignof(enum E)==16 && _Generic(A,unsigned:1,default:0),\"aligned\");\n"));
assert(sizeof("@nested-records")-1==strlen("@nested-records"));
assert(sizeof("128 bit provisional positive values retain upper bits")-1==strlen("128 bit provisional positive values retain upper bits"));
assert(sizeof("enum E { A __attribute__((mode(QI)))=1 };\n")-1==strlen("enum E { A __attribute__((mode(QI)))=1 };\n"));
assert(sizeof("signed bit precise successor widens by value width")-1==strlen("signed bit precise successor widens by value width"));
assert(sizeof("aligned enum layout and wide constant types")-1==strlen("aligned enum layout and wide constant types"));
assert(sizeof("unsigned int successor widens to unsigned long")-1==strlen("unsigned int successor widens to unsigned long"));
assert(sizeof("enumerator still rejects evaluated division by zero")-1==strlen("enumerator still rejects evaluated division by zero"));
assert(sizeof("enum E { A __attribute__((packed,noreturn,vector_size(16)))=0x80000000 }; ")-1==strlen("enum E { A __attribute__((packed,noreturn,vector_size(16)))=0x80000000 }; "));
assert(sizeof("enum E {\n A=\n 1/0\n};\n")-1==strlen("enum E {\n A=\n 1/0\n};\n"));
assert(sizeof("enum { P=4, N=P+__builtin_offsetof(struct { char p[P]; int y; },y) }; _Static_assert(N==8,\"ordered enum record uses\");\n")-1==strlen("enum { P=4, N=P+__builtin_offsetof(struct { char p[P]; int y; },y) }; _Static_assert(N==8,\"ordered enum record uses\");\n"));
assert(sizeof("enumerator still rejects same scope duplicate")-1==strlen("enumerator still rejects same scope duplicate"));
assert(sizeof("enum H : int { H0 } __attribute__((aligned(2))); struct S { char c; enum E e; }; ")-1==strlen("enum H : int { H0 } __attribute__((aligned(2))); struct S { char c; enum E e; }; "));
assert(sizeof("enum inline tag identity survives subsequent expression use")-1==strlen("enum inline tag identity survives subsequent expression use"));
assert(sizeof("enumerator still rejects incomplete enum size")-1==strlen("enumerator still rejects incomplete enum size"));
assert(sizeof("enum E { A=sizeof(enum E) };\n")-1==strlen("enum E { A=sizeof(enum E) };\n"));
assert(sizeof("wide unsigned enumerator used after completion")-1==strlen("wide unsigned enumerator used after completion"));
assert(sizeof("enum expression completes anonymous record")-1==strlen("enum expression completes anonymous record"));
assert(sizeof("_Static_assert(_Generic(A,unsigned:1,default:0),\"completed\");\n")-1==strlen("_Static_assert(_Generic(A,unsigned:1,default:0),\"completed\");\n"));
assert(sizeof("later enum can use completed earlier common type")-1==strlen("later enum can use completed earlier common type"));
assert(sizeof("enum E { A=0x80000000, B, C=-1 }; _Static_assert(A==2147483648L && B==2147483649L && C==-1,\"values\"); ")-1==strlen("enum E { A=0x80000000, B, C=-1 }; _Static_assert(A==2147483648L && B==2147483649L && C==-1,\"values\"); "));
assert(sizeof("_Static_assert(A==0xffffffffffffffffULL && B==0 && C==7,\"wide successor\");\n")-1==strlen("_Static_assert(A==0xffffffffffffffffULL && B==0 && C==7,\"wide successor\");\n"));
assert(sizeof("enum __attribute__((packed)) E { A=0, B=255 }; ")-1==strlen("enum __attribute__((packed)) E { A=0, B=255 }; "));
assert(sizeof("_Static_assert(B==7 && _Generic(B,int:1,default:0),\"source order\");\n")-1==strlen("_Static_assert(B==7 && _Generic(B,int:1,default:0),\"source order\");\n"));
assert(sizeof("explicit wide expression retains its provisional type")-1==strlen("explicit wide expression retains its provisional type"));
assert(sizeof("enum completion distinguishes small value in a wide set")-1==strlen("enum completion distinguishes small value in a wide set"));
assert(sizeof("enum inline record diagnoses missing member bound at use")-1==strlen("enum inline record diagnoses missing member bound at use"));
assert(sizeof("__alignof__(k)==4,\"late alignment\");\n")-1==strlen("__alignof__(k)==4,\"late alignment\");\n"));
assert(sizeof("enum { N=sizeof(struct { enum { A=3 } e; int x[A]; })+A }; _Static_assert(N==19 && A==3,\"nested ordinary declaration\");\n")-1==strlen("enum { N=sizeof(struct { enum { A=3 } e; int x[A]; })+A }; _Static_assert(N==19 && A==3,\"nested ordinary declaration\");\n"));
assert(sizeof("nested record enum chains remain separate")-1==strlen("nested record enum chains remain separate"));
assert(sizeof("enum E { A=~(unsigned __int128)0, B, C=_Generic(B,unsigned __int128:7,default:9) }; ")-1==strlen("enum E { A=~(unsigned __int128)0, B, C=_Generic(B,unsigned __int128:7,default:9) }; "));
assert(sizeof("enumerator ext vector attribute is ignored")-1==strlen("enumerator ext vector attribute is ignored"));
assert(sizeof("enum inline record nested inside outer tag attribute")-1==strlen("enum inline record nested inside outer tag attribute"));
assert(sizeof("_Static_assert(A==0 && B==1 && C==7 && _Generic(A,long long:1,default:0),\"negative exact\");\n")-1==strlen("_Static_assert(A==0 && B==1 && C==7 && _Generic(A,long long:1,default:0),\"negative exact\");\n"));
assert(sizeof("enum E { A=(signed _BitInt(33))4294967295LL, B, C=_Generic(B,long:1,default:9) }; ")-1==strlen("enum E { A=(signed _BitInt(33))4294967295LL, B, C=_Generic(B,long:1,default:9) }; "));
assert(sizeof("_Static_assert(sizeof(enum E)==1 && _Alignof(enum E)==1 && _Generic(A,int:1,default:0),\"packed\");\n")-1==strlen("_Static_assert(sizeof(enum E)==1 && _Alignof(enum E)==1 && _Generic(A,int:1,default:0),\"packed\");\n"));
assert(sizeof("enum E { A=-((__int128)1<<100), B=(A>>100)==-1, C=_Generic(A,__int128:7,default:9) }; ")-1==strlen("enum E { A=-((__int128)1<<100), B=(A>>100)==-1, C=_Generic(A,__int128:7,default:9) }; "));
assert(sizeof("_Static_assert(__alignof__(A)==8 && _Generic(A,unsigned:1,default:0),\"alignment\");\n")-1==strlen("_Static_assert(__alignof__(A)==8 && _Generic(A,unsigned:1,default:0),\"alignment\");\n"));
assert(sizeof("enum E { A=1ULL<<63, B=3 }; _Static_assert(_Generic(B,unsigned long:1,default:0) && B==3,\"whole set\");\n")-1==strlen("enum E { A=1ULL<<63, B=3 }; _Static_assert(_Generic(B,unsigned long:1,default:0) && B==3,\"whole set\");\n"));
assert(sizeof("enumerator ignored layout attributes preserve scalar type")-1==strlen("enumerator ignored layout attributes preserve scalar type"));
assert(sizeof("enum { A=8, N=A+sizeof(struct __attribute__((aligned(A))) S { int x; }) }; _Static_assert(N==16 && _Alignof(struct S)==8,\"header attributes\");\n")-1==strlen("enum { A=8, N=A+sizeof(struct __attribute__((aligned(A))) S { int x; }) }; _Static_assert(N==16 && _Alignof(struct S)==8,\"header attributes\");\n"));
assert(sizeof("_Static_assert(A==0 && B==1 && C==7 && _Generic(A,unsigned long long:1,default:0),\"wide exact\");\n")-1==strlen("_Static_assert(A==0 && B==1 && C==7 && _Generic(A,unsigned long long:1,default:0),\"wide exact\");\n"));
assert(sizeof("enum E { A=0x80000000, A=1 };\n")-1==strlen("enum E { A=0x80000000, A=1 };\n"));
assert(sizeof("enum E { A=-2147483649LL, B, C=_Generic(B,long long:1,default:9) }; ")-1==strlen("enum E { A=-2147483649LL, B, C=_Generic(B,long long:1,default:9) }; "));
assert(sizeof("enum E { A __attribute__((ext_vector_type(4)))=1 }; _Static_assert(_Generic(A,int:1,default:0),\"scalar type\");\n")-1==strlen("enum E { A __attribute__((ext_vector_type(4)))=1 }; _Static_assert(_Generic(A,int:1,default:0),\"scalar type\");\n"));
assert(sizeof("enumerator still rejects noninteger floating value")-1==strlen("enumerator still rejects noninteger floating value"));
assert(sizeof("enumerator still rejects runtime object value")-1==strlen("enumerator still rejects runtime object value"));
assert(sizeof("_Static_assert(_Generic(A,unsigned:1,default:0),\"common type\"); unsigned f(void){return B;}\n")-1==strlen("_Static_assert(_Generic(A,unsigned:1,default:0),\"common type\"); unsigned f(void){return B;}\n"));
assert(sizeof("enum { P=4, N=P+sizeof(struct S { char a[P]; })+sizeof(struct S) }; _Static_assert(N==12 && sizeof(struct S)==4,\"tag completion identity\");\n")-1==strlen("enum { P=4, N=P+sizeof(struct S { char a[P]; })+sizeof(struct S) }; _Static_assert(N==12 && sizeof(struct S)==4,\"tag completion identity\");\n"));
assert(sizeof("enum E { A __attribute__((deprecated))=0x80000000, B=A+1 }; _Static_assert(B==2147483649U,\"attribute\");\n")-1==strlen("enum E { A __attribute__((deprecated))=0x80000000, B=A+1 }; _Static_assert(B==2147483649U,\"attribute\");\n"));
assert(sizeof("enumerator shadowing restores completed outer value")-1==strlen("enumerator shadowing restores completed outer value"));
assert(sizeof("enum E { A=0x80000000, B }; _Static_assert(A==2147483648U && B==2147483649U,\"values\"); ")-1==strlen("enum E { A=0x80000000, B }; _Static_assert(A==2147483648U && B==2147483649U,\"values\"); "));
assert(sizeof("enum { N=sizeof(struct __attribute__((aligned(sizeof(struct { long x; })))) S { int x; }) }; _Static_assert(N==8,\"nested header record job\");\n")-1==strlen("enum { N=sizeof(struct __attribute__((aligned(sizeof(struct { long x; })))) S { int x; }) }; _Static_assert(N==8,\"nested header record job\");\n"));
assert(sizeof("enum inline record resolves header attributes before body")-1==strlen("enum inline record resolves header attributes before body"));
assert(sizeof("small explicit expression enumerators all become int")-1==strlen("small explicit expression enumerators all become int"));
assert(sizeof("_Static_assert(B==2147483649U && D==0 && sizeof(struct S)==8,\"nested chains\");\n")-1==strlen("_Static_assert(B==2147483649U && D==0 && sizeof(struct S)==8,\"nested chains\");\n"));
assert(sizeof("enum E { A __attribute__((aligned(8)))=0x80000000 }; ")-1==strlen("enum E { A __attribute__((aligned(8)))=0x80000000 }; "));
assert(sizeof("128 bit unsigned successor retains provisional width")-1==strlen("128 bit unsigned successor retains provisional width"));
assert(sizeof("enum E { A=2147483648LL, B=_Generic(A,long long:1,default:9) }; _Static_assert(B==1,\"provisional\"); ")-1==strlen("enum E { A=2147483648LL, B=_Generic(A,long long:1,default:9) }; _Static_assert(B==1,\"provisional\"); "));
assert(sizeof("deep enum and record source jobs use explicit frames")-1==strlen("deep enum and record source jobs use explicit frames"));
assert(sizeof("packed enum layout preserves int enumerator types")-1==strlen("packed enum layout preserves int enumerator types"));
assert(sizeof("enum E { A=0xffffffff, B, C=_Generic(B,unsigned long:2,default:9) }; _Static_assert(B==4294967296UL && C==2,\"successor\"); ")-1==strlen("enum E { A=0xffffffff, B, C=_Generic(B,unsigned long:2,default:9) }; _Static_assert(B==4294967296UL && C==2,\"successor\"); "));
assert(sizeof("_Static_assert(B==4294967296UL && C==1 && _Generic(A,unsigned long:1,default:0),\"bit precise\");\n")-1==strlen("_Static_assert(B==4294967296UL && C==1 && _Generic(A,unsigned long:1,default:0),\"bit precise\");\n"));
assert(sizeof("@many-values")-1==strlen("@many-values"));
assert(sizeof("_Static_assert(C==3 && _Generic(A,int:1,default:0) && _Generic(B,int:1,default:0),\"small values\");\n")-1==strlen("_Static_assert(C==3 && _Generic(A,int:1,default:0) && _Generic(B,int:1,default:0),\"small values\");\n"));
assert(sizeof("enum E { A=0xffffffffffffffffULL, B=-1 }; _Static_assert(A==-1 && B==-1 && ")-1==strlen("enum E { A=0xffffffffffffffffULL, B=-1 }; _Static_assert(A==-1 && B==-1 && "));
assert(sizeof("_Static_assert(A==2147483648U,\"outer\"); return 0;}\n")-1==strlen("_Static_assert(A==2147483648U,\"outer\"); return 0;}\n"));
assert(sizeof("enum E { A=(unsigned _BitInt(33))8589934591ULL, B, C=_Generic(B,unsigned long:1,default:9) }; ")-1==strlen("enum E { A=(unsigned _BitInt(33))8589934591ULL, B, C=_Generic(B,unsigned long:1,default:9) }; "));
assert(sizeof("_Static_assert(A==0xffffffffffffffffUL && B==0 && C==1 && _Generic(A,unsigned long:1,default:0),\"largest\");\n")-1==strlen("_Static_assert(A==0xffffffffffffffffUL && B==0 && C==1 && _Generic(A,unsigned long:1,default:0),\"largest\");\n"));
assert(sizeof("enum { N=sizeof(struct { char x; int y; }) }; _Static_assert(N==8,\"record query\");\n")-1==strlen("enum { N=sizeof(struct { char x; int y; }) }; _Static_assert(N==8,\"record query\");\n"));
assert(sizeof("_Static_assert(_Generic(A,unsigned long:1,default:0) && _Generic(C,unsigned long:1,default:0),\"completed\");\n")-1==strlen("_Static_assert(_Generic(A,unsigned long:1,default:0) && _Generic(C,unsigned long:1,default:0),\"completed\");\n"));
assert(sizeof("struct S { enum E { A=0x80000000, B } x; enum F { C=-1, D } y; }; ")-1==strlen("struct S { enum E { A=0x80000000, B } x; enum F { C=-1, D } y; }; "));
assert(sizeof("fixed enum aligned after its body")-1==strlen("fixed enum aligned after its body"));
assert(sizeof("enum inline record keeps earlier operand event order")-1==strlen("enum inline record keeps earlier operand event order"));
assert(sizeof("enumerator aligned attribute preserves declared alignment")-1==strlen("enumerator aligned attribute preserves declared alignment"));
assert(sizeof("long provisional enum chain retains exact high bits until completion")-1==strlen("long provisional enum chain retains exact high bits until completion"));
assert(sizeof("_Static_assert(sizeof(enum E)==1 && _Alignof(enum E)==8 && _Alignof(enum I)==8 && _Alignof(enum H)==2 && sizeof(struct S)==16 && ")-1==strlen("_Static_assert(sizeof(enum E)==1 && _Alignof(enum E)==8 && _Alignof(enum I)==8 && _Alignof(enum H)==2 && sizeof(struct S)==16 && "));
assert(sizeof("enum E { A=(unsigned __int128)1<<100, B=A>>100, C=_Generic(A,unsigned __int128:7,default:9) }; ")-1==strlen("enum E { A=(unsigned __int128)1<<100, B=A>>100, C=_Generic(A,unsigned __int128:7,default:9) }; "));
assert(sizeof("enum E { A=7ULL, B=(unsigned _BitInt(33))8, C=_Generic(A,int:1,default:9)+_Generic(B,int:2,default:9) }; ")-1==strlen("enum E { A=7ULL, B=(unsigned _BitInt(33))8, C=_Generic(A,int:1,default:9)+_Generic(B,int:2,default:9) }; "));
assert(sizeof("enum { N=sizeof(struct {\nchar a[\nMISSING];\n}) };\n")-1==strlen("enum { N=sizeof(struct {\nchar a[\nMISSING];\n}) };\n"));
assert(sizeof("_Static_assert(_Generic(A,unsigned:1,default:0),\"ignored attributes\");\n")-1==strlen("_Static_assert(_Generic(A,unsigned:1,default:0),\"ignored attributes\");\n"));
assert(sizeof("enum E { A=0xffffffffffffffffULL, B, C=_Generic(B,unsigned long long:1,default:9) }; ")-1==strlen("enum E { A=0xffffffffffffffffULL, B, C=_Generic(B,unsigned long long:1,default:9) }; "));
assert(sizeof("_Generic(A,long long:1,default:0),\"common signed representation\");\n")-1==strlen("_Generic(A,long long:1,default:0),\"common signed representation\");\n"));
assert(sizeof("enum __attribute__((aligned(16))) E { A=0x80000000 }; ")-1==strlen("enum __attribute__((aligned(16))) E { A=0x80000000 }; "));
assert(sizeof("_Static_assert(B==(-9223372036854775807LL-1) && C==1 && _Generic(A,long:1,default:0),\"largest signed\");\n")-1==strlen("_Static_assert(B==(-9223372036854775807LL-1) && C==1 && _Generic(A,long:1,default:0),\"largest signed\");\n"));
assert(sizeof("enum E { A=1.5 };\n")-1==strlen("enum E { A=1.5 };\n"));
assert(sizeof("all completed enumerators share signed common type")-1==strlen("all completed enumerators share signed common type"));
for(size_t i=0;i<sizeof rows/sizeof *rows;i++){const CheckSourceFixture*r=rows+i;put(r->name);put(r->source);uint32_t f[]={r->rejected,r->unsupported,r->extension,r->standard,r->char_unsigned,r->undecided,r->overload_tables};assert(!r->capacity);assert(fwrite(f,4,7,stdout)==7);}}
{ const CheckSourceFixture rows[]={
        {
            .name = "repeated deep variable array size queries",
            .source = "@repeated-size",
        },
        {
            .name = "automatic variable array",
            .source = "int f(int n) { char a[n]; a[0]=1; return a[0]; }\n",
        },
        {
            .name = "variable array runtime sizeof",
            .source = "unsigned long f(int n) { int a[n]; return sizeof a; }\n",
        },
        {
            .name = "typeof variable array runtime sizeof",
            .source = "unsigned long f(int n) { __typeof__(int[n++]) a; return sizeof a; }\n",
        },
        {
            .name = "typeof pointer to variable array runtime sizeof",
            .source = "unsigned long f(int n) { __typeof__(int[n++])*p; return sizeof *p; }\n",
        },
        {
            .name = "typeof variable typedef retains original extent",
            .source = "unsigned long f(int n) { typedef int A[n++]; __typeof__(A) a; __typeof__(int[n++]) b; return sizeof a+sizeof b; }\n",
        },
        {
            .name = "suspended typeof retains nested VLA owner",
            .source = "unsigned long f(int n) { __typeof__(({ int (*p)[n]; p; })) q; return sizeof *q; }\n",
        },
        {
            .name = "typeof variable type preserves later asm diagnostic",
            .source = "int x;\nint f(void){__typeof__(int[x]) a;return sizeof(a);}\nextern int x asm(\"b\");\n",
            .rejected = true,
        },
        {
            .name = "goto into typeof variable scope rejected",
            .source = "void f(int n) { goto target; __typeof__(int[n]) a; target:; }\n",
            .rejected = true,
        },
        {
            .name = "multidimensional runtime sizeof",
            .source = "unsigned long f(int n,int m) { int a[n][m]; return sizeof a; }\n",
        },
        {
            .name = "fixed outer variable inner dimension",
            .source = "unsigned long f(int n) { int a[3][n]; return sizeof a; }\n",
        },
        {
            .name = "inline variable array sizeof",
            .source = "unsigned long f(int n) { return sizeof(int[n++]); }\n",
        },
        {
            .name = "file sizeof pointer to variable array is constant",
            .source = "int n; unsigned long c=sizeof(int(*)[n]); unsigned long a=sizeof(int(*)[(3,2)]);\n"
                      "enum { P=sizeof(int(*)[n]), PP=sizeof(int(**)[n]), A=sizeof(int(*[3])[n]), M=sizeof(int(*)[n][n+1]) };\n"
                      "_Static_assert(P==8 && PP==8 && A==24 && M==8, \"fixed pointer layout\");\n",
        },
        {
            .name = "file sizeof variable array remains nonconstant",
            .source = "int n; unsigned long c=sizeof(int[n]);\n",
            .rejected = true,
        },
        {
            .name = "file sizeof nested variable array remains nonconstant",
            .source = "int n; unsigned long c=sizeof(int[3][n]);\n",
            .rejected = true,
        },
        {
            .name = "file sizeof array of pointers with variable outer bound remains nonconstant",
            .source = "int n; unsigned long c=sizeof(int(*[n])[n]);\n",
            .rejected = true,
        },
        {
            .name = "file alignof variable array and pointer remains constant",
            .source = "int n; enum { A=_Alignof(int[n]), P=_Alignof(int(*)[n]) }; _Static_assert(A==4 && P==8, \"fixed alignment\");\n",
        },
        {
            .name = "file sizeof and alignof leave nested runtime array queries unevaluated",
            .source = "int n; unsigned long p=sizeof(int(*)[sizeof(int[n])]); unsigned long a=_Alignof(int[sizeof(int[n])]);\n"
                      "unsigned long s=sizeof(sizeof(int[n])); unsigned long side=sizeof(sizeof(int[++n]));\n"
                      "enum { P=sizeof(int(*)[sizeof(int[n])]), A=_Alignof(int[sizeof(int[n])]), S=sizeof(sizeof(int[n])) };\n"
                      "_Static_assert(P==8 && A==4 && S==8, \"nested unevaluated array size\");\n",
        },
        {
            .name = "file evaluated nested runtime array query remains nonconstant",
            .source = "int n; unsigned long x=sizeof(int[sizeof(int[n])]);\n",
            .rejected = true,
        },
        {
            .name = "file nested unevaluated query still checks array bound type",
            .source = "unsigned long x=sizeof(sizeof(int[1.5]));\n",
            .rejected = true,
        },
        {
            .name = "variable array sizeof bound",
            .source = "unsigned long f(int n) { int a[n]; char b[sizeof a]; return sizeof b; }\n",
        },
        {
            .name = "inline sizeof variable array bound",
            .source = "unsigned long f(int n) { char a[sizeof(int[n])]; return sizeof a; }\n",
        },
        {
            .name = "variable array typedef reuse",
            .source = "unsigned long f(int n) { typedef int A[n]; A a,b; return sizeof a+sizeof b; }\n",
        },
        {
            .name = "static pointer to variable array",
            .source = "unsigned long f(int n) { static int (*p)[n]; return sizeof p+sizeof *p; }\n",
        },
        {
            .name = "thread local pointer to variable array",
            .source = "unsigned long f(int n) { static _Thread_local int (*p)[n]; return sizeof p; }\n",
        },
        {
            .name = "sizeof evaluated variable array operand",
            .source = "unsigned long f(int n,int (*p)[n]) { return sizeof *(p++); }\n",
        },
        {
            .name = "prototype variable bound",
            .source = "void f(int n,int a[n]);\n",
        },
        {
            .name = "prototype star bound",
            .source = "void f(int n,int a[*]);\n",
        },
        {
            .name = "definition variable parameter bound",
            .source = "int f(int n,int a[n]) { return a[0]; }\n",
        },
        {
            .name = "definition static qualified bound",
            .source = "int f(int n,int a[static restrict n]) { return a[0]; }\n",
        },
        {
            .name = "definition star bound rejected",
            .source = "int f(int a[*]) { return a[0]; }\n",
            .rejected = true,
        },
        {
            .name = "file variable array rejected",
            .source = "int n; int a[n];\n",
            .rejected = true,
        },
        {
            .name = "file pointer to variable array rejected",
            .source = "int n; int (*p)[n];\n",
            .rejected = true,
        },
        {
            .name = "static variable array rejected",
            .source = "void f(int n) { static int a[n]; }\n",
            .rejected = true,
        },
        {
            .name = "extern variable type rejected",
            .source = "void f(int n) { extern int (*p)[n]; }\n",
            .rejected = true,
        },
        {
            .name = "variable array nonempty initializer rejected",
            .source = "void f(int n) { int a[n]={1}; }\n",
            .rejected = true,
        },
        {
            .name = "noninteger array bound rejected",
            .source = "void f(double n) { int a[n]; }\n",
            .rejected = true,
        },
        {
            .name = "runtime sizeof is not ICE",
            .source = "void f(int n) { int a[n]; _Static_assert(sizeof a>0,\"runtime\"); }\n",
            .rejected = true,
        },
        {
            .name = "known computed real local bound remains variable",
            .source = "void f(void) { int a[(int)(1.0+2.0)]; _Static_assert(sizeof a==12,\"still variable\"); }\n",
            .rejected = true,
        },
        {
            .name = "known comma local bound remains variable",
            .source = "void f(void) { int a[(1,3)]; _Static_assert(sizeof a==12,\"still variable\"); }\n",
            .rejected = true,
        },
        {
            .name = "known type-name bound remains variable at file scope",
            .source = "enum { N=sizeof(int[(int)(1.0+2.0)]) };\n",
            .rejected = true,
        },
        {
            .name = "file and record computed bounds fold with GNU array policy",
            .source = "int a[(int)(1.0+2.0)]; struct S {int a[(1,3)];}; void f(void){struct T {int a[(int)(1.0+2.0)];}; _Static_assert(sizeof(struct T)==12,\"member fold\");} _Static_assert(sizeof a==12 && sizeof(struct S)==12,\"array folds\");\n",
        },
        {
            .name = "overflowing division cannot fold a file array",
            .source = "int a[((-2147483647-1)/-1)<0];\n",
            .rejected = true,
        },
        {
            .name = "record array unknown bound retains inner source line",
            .source = "struct S {\nchar a[\nMISSING];\n};\n",
            .rejected = true,
        },
        {
            .name = "goto within variable scope",
            .source = "void f(int n) { int a[n]; again: if(n--) goto again; }\n",
        },
        {
            .name = "goto out of variable scope",
            .source = "void f(int n) { { int a[n]; goto done; } done:; }\n",
        },
        {
            .name = "goto into variable scope rejected",
            .source = "void f(int n) { goto target; int a[n]; target:; }\n",
            .rejected = true,
        },
        {
            .name = "goto into variable pointer scope rejected",
            .source = "void f(int n) { goto target; int (*p)[n]; target:; }\n",
            .rejected = true,
        },
        {
            .name = "goto into reused variable typedef rejected",
            .source = "void f(int n) { typedef int A[n]; goto target; { A a; target:; } }\n",
            .rejected = true,
        },
        {
            .name = "switch enters variable scope rejected",
            .source = "void f(int n) { switch(n) { int a[n]; case 1:; } }\n",
            .rejected = true,
        },
        {
            .name = "goto past constant logical bounds",
            .source = "void f(void) { goto target; { int a[1&&1],b[1||0],c[1?1:2]; target: a[0]=b[0]=c[0]=0; } }\n",
        },
    };
assert(sizeof("sizeof evaluated variable array operand")-1==strlen("sizeof evaluated variable array operand"));
assert(sizeof("void f(int n,int a[*]);\n")-1==strlen("void f(int n,int a[*]);\n"));
assert(sizeof("void f(void) { goto target; { int a[1&&1],b[1||0],c[1?1:2]; target: a[0]=b[0]=c[0]=0; } }\n")-1==strlen("void f(void) { goto target; { int a[1&&1],b[1||0],c[1?1:2]; target: a[0]=b[0]=c[0]=0; } }\n"));
assert(sizeof("inline sizeof variable array bound")-1==strlen("inline sizeof variable array bound"));
assert(sizeof("extern variable type rejected")-1==strlen("extern variable type rejected"));
assert(sizeof("void f(int n) { { int a[n]; goto done; } done:; }\n")-1==strlen("void f(int n) { { int a[n]; goto done; } done:; }\n"));
assert(sizeof("int n; enum { A=_Alignof(int[n]), P=_Alignof(int(*)[n]) }; _Static_assert(A==4 && P==8, \"fixed alignment\");\n")-1==strlen("int n; enum { A=_Alignof(int[n]), P=_Alignof(int(*)[n]) }; _Static_assert(A==4 && P==8, \"fixed alignment\");\n"));
assert(sizeof("noninteger array bound rejected")-1==strlen("noninteger array bound rejected"));
assert(sizeof("static variable array rejected")-1==strlen("static variable array rejected"));
assert(sizeof("_Static_assert(P==8 && A==4 && S==8, \"nested unevaluated array size\");\n")-1==strlen("_Static_assert(P==8 && A==4 && S==8, \"nested unevaluated array size\");\n"));
assert(sizeof("file sizeof and alignof leave nested runtime array queries unevaluated")-1==strlen("file sizeof and alignof leave nested runtime array queries unevaluated"));
assert(sizeof("struct S {\nchar a[\nMISSING];\n};\n")-1==strlen("struct S {\nchar a[\nMISSING];\n};\n"));
assert(sizeof("file variable array rejected")-1==strlen("file variable array rejected"));
assert(sizeof("unsigned long f(int n) { __typeof__(int[n++])*p; return sizeof *p; }\n")-1==strlen("unsigned long f(int n) { __typeof__(int[n++])*p; return sizeof *p; }\n"));
assert(sizeof("definition variable parameter bound")-1==strlen("definition variable parameter bound"));
assert(sizeof("int n; unsigned long c=sizeof(int(*[n])[n]);\n")-1==strlen("int n; unsigned long c=sizeof(int(*[n])[n]);\n"));
assert(sizeof("file alignof variable array and pointer remains constant")-1==strlen("file alignof variable array and pointer remains constant"));
assert(sizeof("file nested unevaluated query still checks array bound type")-1==strlen("file nested unevaluated query still checks array bound type"));
assert(sizeof("void f(int n) { goto target; int a[n]; target:; }\n")-1==strlen("void f(int n) { goto target; int a[n]; target:; }\n"));
assert(sizeof("void f(int n) { goto target; __typeof__(int[n]) a; target:; }\n")-1==strlen("void f(int n) { goto target; __typeof__(int[n]) a; target:; }\n"));
assert(sizeof("automatic variable array")-1==strlen("automatic variable array"));
assert(sizeof("unsigned long f(int n) { char a[sizeof(int[n])]; return sizeof a; }\n")-1==strlen("unsigned long f(int n) { char a[sizeof(int[n])]; return sizeof a; }\n"));
assert(sizeof("prototype star bound")-1==strlen("prototype star bound"));
assert(sizeof("typeof variable typedef retains original extent")-1==strlen("typeof variable typedef retains original extent"));
assert(sizeof("void f(int n) { static int a[n]; }\n")-1==strlen("void f(int n) { static int a[n]; }\n"));
assert(sizeof("runtime sizeof is not ICE")-1==strlen("runtime sizeof is not ICE"));
assert(sizeof("unsigned long f(int n) { typedef int A[n]; A a,b; return sizeof a+sizeof b; }\n")-1==strlen("unsigned long f(int n) { typedef int A[n]; A a,b; return sizeof a+sizeof b; }\n"));
assert(sizeof("unsigned long f(int n) { typedef int A[n++]; __typeof__(A) a; __typeof__(int[n++]) b; return sizeof a+sizeof b; }\n")-1==strlen("unsigned long f(int n) { typedef int A[n++]; __typeof__(A) a; __typeof__(int[n++]) b; return sizeof a+sizeof b; }\n"));
assert(sizeof("switch enters variable scope rejected")-1==strlen("switch enters variable scope rejected"));
assert(sizeof("definition static qualified bound")-1==strlen("definition static qualified bound"));
assert(sizeof("definition star bound rejected")-1==strlen("definition star bound rejected"));
assert(sizeof("int a[((-2147483647-1)/-1)<0];\n")-1==strlen("int a[((-2147483647-1)/-1)<0];\n"));
assert(sizeof("variable array sizeof bound")-1==strlen("variable array sizeof bound"));
assert(sizeof("unsigned long f(int n) { __typeof__(int[n++]) a; return sizeof a; }\n")-1==strlen("unsigned long f(int n) { __typeof__(int[n++]) a; return sizeof a; }\n"));
assert(sizeof("file pointer to variable array rejected")-1==strlen("file pointer to variable array rejected"));
assert(sizeof("enum { P=sizeof(int(*)[sizeof(int[n])]), A=_Alignof(int[sizeof(int[n])]), S=sizeof(sizeof(int[n])) };\n")-1==strlen("enum { P=sizeof(int(*)[sizeof(int[n])]), A=_Alignof(int[sizeof(int[n])]), S=sizeof(sizeof(int[n])) };\n"));
assert(sizeof("int f(int n,int a[n]) { return a[0]; }\n")-1==strlen("int f(int n,int a[n]) { return a[0]; }\n"));
assert(sizeof("enum { N=sizeof(int[(int)(1.0+2.0)]) };\n")-1==strlen("enum { N=sizeof(int[(int)(1.0+2.0)]) };\n"));
assert(sizeof("repeated deep variable array size queries")-1==strlen("repeated deep variable array size queries"));
assert(sizeof("void f(int n) { typedef int A[n]; goto target; { A a; target:; } }\n")-1==strlen("void f(int n) { typedef int A[n]; goto target; { A a; target:; } }\n"));
assert(sizeof("typeof variable type preserves later asm diagnostic")-1==strlen("typeof variable type preserves later asm diagnostic"));
assert(sizeof("int n; unsigned long c=sizeof(int[3][n]);\n")-1==strlen("int n; unsigned long c=sizeof(int[3][n]);\n"));
assert(sizeof("typeof pointer to variable array runtime sizeof")-1==strlen("typeof pointer to variable array runtime sizeof"));
assert(sizeof("int x;\nint f(void){__typeof__(int[x]) a;return sizeof(a);}\nextern int x asm(\"b\");\n")-1==strlen("int x;\nint f(void){__typeof__(int[x]) a;return sizeof(a);}\nextern int x asm(\"b\");\n"));
assert(sizeof("unsigned long f(int n) { int a[3][n]; return sizeof a; }\n")-1==strlen("unsigned long f(int n) { int a[3][n]; return sizeof a; }\n"));
assert(sizeof("@repeated-size")-1==strlen("@repeated-size"));
assert(sizeof("int n; unsigned long c=sizeof(int[n]);\n")-1==strlen("int n; unsigned long c=sizeof(int[n]);\n"));
assert(sizeof("_Static_assert(P==8 && PP==8 && A==24 && M==8, \"fixed pointer layout\");\n")-1==strlen("_Static_assert(P==8 && PP==8 && A==24 && M==8, \"fixed pointer layout\");\n"));
assert(sizeof("unsigned long f(int n) { return sizeof(int[n++]); }\n")-1==strlen("unsigned long f(int n) { return sizeof(int[n++]); }\n"));
assert(sizeof("record array unknown bound retains inner source line")-1==strlen("record array unknown bound retains inner source line"));
assert(sizeof("int n; unsigned long x=sizeof(int[sizeof(int[n])]);\n")-1==strlen("int n; unsigned long x=sizeof(int[sizeof(int[n])]);\n"));
assert(sizeof("goto into typeof variable scope rejected")-1==strlen("goto into typeof variable scope rejected"));
assert(sizeof("file evaluated nested runtime array query remains nonconstant")-1==strlen("file evaluated nested runtime array query remains nonconstant"));
assert(sizeof("int f(int n) { char a[n]; a[0]=1; return a[0]; }\n")-1==strlen("int f(int n) { char a[n]; a[0]=1; return a[0]; }\n"));
assert(sizeof("goto within variable scope")-1==strlen("goto within variable scope"));
assert(sizeof("file sizeof array of pointers with variable outer bound remains nonconstant")-1==strlen("file sizeof array of pointers with variable outer bound remains nonconstant"));
assert(sizeof("int n; unsigned long p=sizeof(int(*)[sizeof(int[n])]); unsigned long a=_Alignof(int[sizeof(int[n])]);\n")-1==strlen("int n; unsigned long p=sizeof(int(*)[sizeof(int[n])]); unsigned long a=_Alignof(int[sizeof(int[n])]);\n"));
assert(sizeof("unsigned long x=sizeof(sizeof(int[1.5]));\n")-1==strlen("unsigned long x=sizeof(sizeof(int[1.5]));\n"));
assert(sizeof("void f(void) { int a[(1,3)]; _Static_assert(sizeof a==12,\"still variable\"); }\n")-1==strlen("void f(void) { int a[(1,3)]; _Static_assert(sizeof a==12,\"still variable\"); }\n"));
assert(sizeof("suspended typeof retains nested VLA owner")-1==strlen("suspended typeof retains nested VLA owner"));
assert(sizeof("file sizeof pointer to variable array is constant")-1==strlen("file sizeof pointer to variable array is constant"));
assert(sizeof("unsigned long f(int n) { static _Thread_local int (*p)[n]; return sizeof p; }\n")-1==strlen("unsigned long f(int n) { static _Thread_local int (*p)[n]; return sizeof p; }\n"));
assert(sizeof("variable array nonempty initializer rejected")-1==strlen("variable array nonempty initializer rejected"));
assert(sizeof("overflowing division cannot fold a file array")-1==strlen("overflowing division cannot fold a file array"));
assert(sizeof("inline variable array sizeof")-1==strlen("inline variable array sizeof"));
assert(sizeof("enum { P=sizeof(int(*)[n]), PP=sizeof(int(**)[n]), A=sizeof(int(*[3])[n]), M=sizeof(int(*)[n][n+1]) };\n")-1==strlen("enum { P=sizeof(int(*)[n]), PP=sizeof(int(**)[n]), A=sizeof(int(*[3])[n]), M=sizeof(int(*)[n][n+1]) };\n"));
assert(sizeof("int f(int n,int a[static restrict n]) { return a[0]; }\n")-1==strlen("int f(int n,int a[static restrict n]) { return a[0]; }\n"));
assert(sizeof("goto into reused variable typedef rejected")-1==strlen("goto into reused variable typedef rejected"));
assert(sizeof("unsigned long f(int n) { __typeof__(({ int (*p)[n]; p; })) q; return sizeof *q; }\n")-1==strlen("unsigned long f(int n) { __typeof__(({ int (*p)[n]; p; })) q; return sizeof *q; }\n"));
assert(sizeof("file sizeof nested variable array remains nonconstant")-1==strlen("file sizeof nested variable array remains nonconstant"));
assert(sizeof("void f(int n) { goto target; int (*p)[n]; target:; }\n")-1==strlen("void f(int n) { goto target; int (*p)[n]; target:; }\n"));
assert(sizeof("prototype variable bound")-1==strlen("prototype variable bound"));
assert(sizeof("void f(int n) { int a[n]; again: if(n--) goto again; }\n")-1==strlen("void f(int n) { int a[n]; again: if(n--) goto again; }\n"));
assert(sizeof("int a[(int)(1.0+2.0)]; struct S {int a[(1,3)];}; void f(void){struct T {int a[(int)(1.0+2.0)];}; _Static_assert(sizeof(struct T)==12,\"member fold\");} _Static_assert(sizeof a==12 && sizeof(struct S)==12,\"array folds\");\n")-1==strlen("int a[(int)(1.0+2.0)]; struct S {int a[(1,3)];}; void f(void){struct T {int a[(int)(1.0+2.0)];}; _Static_assert(sizeof(struct T)==12,\"member fold\");} _Static_assert(sizeof a==12 && sizeof(struct S)==12,\"array folds\");\n"));
assert(sizeof("multidimensional runtime sizeof")-1==strlen("multidimensional runtime sizeof"));
assert(sizeof("unsigned long f(int n) { int a[n]; char b[sizeof a]; return sizeof b; }\n")-1==strlen("unsigned long f(int n) { int a[n]; char b[sizeof a]; return sizeof b; }\n"));
assert(sizeof("unsigned long f(int n) { int a[n]; return sizeof a; }\n")-1==strlen("unsigned long f(int n) { int a[n]; return sizeof a; }\n"));
assert(sizeof("unsigned long f(int n) { static int (*p)[n]; return sizeof p+sizeof *p; }\n")-1==strlen("unsigned long f(int n) { static int (*p)[n]; return sizeof p+sizeof *p; }\n"));
assert(sizeof("file and record computed bounds fold with GNU array policy")-1==strlen("file and record computed bounds fold with GNU array policy"));
assert(sizeof("fixed outer variable inner dimension")-1==strlen("fixed outer variable inner dimension"));
assert(sizeof("goto out of variable scope")-1==strlen("goto out of variable scope"));
assert(sizeof("static pointer to variable array")-1==strlen("static pointer to variable array"));
assert(sizeof("unsigned long f(int n,int (*p)[n]) { return sizeof *(p++); }\n")-1==strlen("unsigned long f(int n,int (*p)[n]) { return sizeof *(p++); }\n"));
assert(sizeof("known comma local bound remains variable")-1==strlen("known comma local bound remains variable"));
assert(sizeof("typeof variable array runtime sizeof")-1==strlen("typeof variable array runtime sizeof"));
assert(sizeof("unsigned long f(int n,int m) { int a[n][m]; return sizeof a; }\n")-1==strlen("unsigned long f(int n,int m) { int a[n][m]; return sizeof a; }\n"));
assert(sizeof("goto into variable scope rejected")-1==strlen("goto into variable scope rejected"));
assert(sizeof("int n; int a[n];\n")-1==strlen("int n; int a[n];\n"));
assert(sizeof("thread local pointer to variable array")-1==strlen("thread local pointer to variable array"));
assert(sizeof("goto into variable pointer scope rejected")-1==strlen("goto into variable pointer scope rejected"));
assert(sizeof("void f(double n) { int a[n]; }\n")-1==strlen("void f(double n) { int a[n]; }\n"));
assert(sizeof("void f(int n) { switch(n) { int a[n]; case 1:; } }\n")-1==strlen("void f(int n) { switch(n) { int a[n]; case 1:; } }\n"));
assert(sizeof("void f(void) { int a[(int)(1.0+2.0)]; _Static_assert(sizeof a==12,\"still variable\"); }\n")-1==strlen("void f(void) { int a[(int)(1.0+2.0)]; _Static_assert(sizeof a==12,\"still variable\"); }\n"));
assert(sizeof("goto past constant logical bounds")-1==strlen("goto past constant logical bounds"));
assert(sizeof("file sizeof variable array remains nonconstant")-1==strlen("file sizeof variable array remains nonconstant"));
assert(sizeof("void f(int n,int a[n]);\n")-1==strlen("void f(int n,int a[n]);\n"));
assert(sizeof("int n; int (*p)[n];\n")-1==strlen("int n; int (*p)[n];\n"));
assert(sizeof("void f(int n) { extern int (*p)[n]; }\n")-1==strlen("void f(int n) { extern int (*p)[n]; }\n"));
assert(sizeof("int n; unsigned long c=sizeof(int(*)[n]); unsigned long a=sizeof(int(*)[(3,2)]);\n")-1==strlen("int n; unsigned long c=sizeof(int(*)[n]); unsigned long a=sizeof(int(*)[(3,2)]);\n"));
assert(sizeof("known type-name bound remains variable at file scope")-1==strlen("known type-name bound remains variable at file scope"));
assert(sizeof("variable array runtime sizeof")-1==strlen("variable array runtime sizeof"));
assert(sizeof("variable array typedef reuse")-1==strlen("variable array typedef reuse"));
assert(sizeof("int f(int a[*]) { return a[0]; }\n")-1==strlen("int f(int a[*]) { return a[0]; }\n"));
assert(sizeof("unsigned long s=sizeof(sizeof(int[n])); unsigned long side=sizeof(sizeof(int[++n]));\n")-1==strlen("unsigned long s=sizeof(sizeof(int[n])); unsigned long side=sizeof(sizeof(int[++n]));\n"));
assert(sizeof("known computed real local bound remains variable")-1==strlen("known computed real local bound remains variable"));
assert(sizeof("void f(int n) { int a[n]={1}; }\n")-1==strlen("void f(int n) { int a[n]={1}; }\n"));
assert(sizeof("void f(int n) { int a[n]; _Static_assert(sizeof a>0,\"runtime\"); }\n")-1==strlen("void f(int n) { int a[n]; _Static_assert(sizeof a>0,\"runtime\"); }\n"));
for(size_t i=0;i<sizeof rows/sizeof *rows;i++){const CheckSourceFixture*r=rows+i;put(r->name);put(r->source);uint32_t f[]={r->rejected,r->unsupported,r->extension,r->standard,r->char_unsigned,r->undecided,r->overload_tables};assert(!r->capacity);assert(fwrite(f,4,7,stdout)==7);}}
{ const CheckSourceFixture rows[]={
    {
        .name = "a whole replacement discards an effectful aggregate rvalue retaining an object ID",
        .source = "struct S{int x,y;};struct P{struct S s;};const struct S base={8,9};int touch(void);int f(void){const struct P p={.s=(touch(),base),.s={1,2}};enum{E=p.s.x};_Static_assert(E==1,\"rvalue replacement\");return E;}\n",
    },
    {
        .name = "a whole aggregate replacement makes an earlier aggregate call dead",
        .source = "struct S{int x,y;};struct P{struct S s;};struct S make(void);int f(void){const struct P p={.s=make(),.s={1,2}};enum{E=p.s.x};_Static_assert(E==1,\"whole replacement\");return E;}\n",
    },
    {
        .name = "sizeof a VLA type does not make a later const object constant",
        .source = "int f(void){const int k=3;const int n=sizeof(int[k]);enum{E=n};return E;}\n",
        .rejected = true,
    },
    {
        .name = "a const bound in a sizeof type-name keeps its variable array type",
        .source = "const int k=3;enum{E=sizeof(int[k])};\n",
        .rejected = true,
    },
    {
        .name = "static initialization cannot consume sizeof a variable array type",
        .source = "const int k=3;const int n=sizeof(int[k]);enum{E=n};\n",
        .rejected = true,
    },
    {
        .name = "overridden file-scope nonconstant writes do not poison final const value",
        .source = "int get(void);struct P{int x;};const struct P p={.x=get(),.x=3};enum{E=p.x};_Static_assert(E==3,\"file override\");\n",
    },
    {
        .name = "scalar field coverage does not kill an aggregate-copy base expression",
        .source = "struct S{int x,y;};struct P{struct S s;};struct S make(void);void f(void){const struct P p={.s=make(),.s.x=1,.s.y=2};enum{E=p.s.x};}\n",
        .rejected = true,
    },
    {
        .name = "an equal-sized nested child is not a whole replacement of its parent",
        .source = "struct I{int x;};struct O{struct I i;};struct P{struct O o;};struct O make(void);void f(void){const struct P p={.o=make(),.o.i={1}};enum{E=p.o.i.x};}\n",
        .rejected = true,
    },
    {
        .name = "fully overridden scalar GNU range expressions are dead",
        .source = "int get(void);int f(void){const int a[3]={[0 ... 2]=get(),[0]=1,[1]=2,[2]=3};enum{E=a[0]};_Static_assert(E==1,\"range\");return E;}\n",
    },
    {
        .name = "an automatic address can be consumed by a direct constant read",
        .source = "int f(void){const int k=3;enum{E=*(&k)};_Static_assert(E==3,\"direct address\");return E;}\n",
    },
    {
        .name = "automatic array addresses can be consumed without publishing a pointer value",
        .source = "int f(void){const int a[2]={2,5};enum{E=(&a[0])[1]};_Static_assert(E==5,\"array address\");return E;}\n",
    },
    {
        .name = "a const pointer initialized by automatic array decay is not constant evidence",
        .source = "int f(void){const int a[2]={2,5};const int* const p=a;enum{E=p[1]};_Static_assert(E==5,\"array pointer\");return E;}\n",
        .rejected = true,
    },
    {
        .name = "overridden effectful initializer is absent from the final value",
        .source = "int get(void);struct P{int x;};int f(void){const struct P p={.x=get(),.x=3};enum{E=p.x};_Static_assert(E==3,\"override\");return E;}\n",
    },
    {
        .name = "overridden effects do not poison another surviving aggregate member",
        .source = "int get(void);struct P{int x,y;};int f(void){const struct P p={.x=get(),.y=4,.x=3};enum{E=p.y};_Static_assert(E==4,\"other member\");return E;}\n",
    },
    {
        .name = "aggregate subobject copies clip implicit zero coverage",
        .source = "struct I{int x,y;};struct O{struct I a,b;};const struct O p={{1},{2}};const struct I q=p.b;_Static_assert(q.x==2 && q.y==0,\"copy\");\n",
    },
    {
        .name = "sparse const arrays do not materialize their declared extent",
        .source = "@check-const-sparse-source",
    },
    {
        .name = "automatic const array retains a source-only address path",
        .source = "int f(void){const int a[2]={2,5};enum{E=a[1]};_Static_assert(E==5,\"local array\");return E;}\n",
    },
    {
        .name = "automatic object addresses do not make a const pointer initializer constant",
        .source = "int f(void){const int k=3;const int* const p=&k;enum{E=*p};_Static_assert(E==3,\"local pointer\");return E;}\n",
        .rejected = true,
    },
    {
        .name = "builtin expect retains its own ICE contract after a const read",
        .source = "const int k=3;enum{E=__builtin_expect(k,0)};_Static_assert(E==3,\"expect\");\n",
    },
    {
        .name = "floating comparison builtin inherits GNU const-read evidence",
        .source = "const double k=3.5;enum{E=__builtin_isgreater(k,0.0)};_Static_assert(E==1,\"compare\");\n",
    },
    {
        .name = "choose expression retains its stricter ICE requirement",
        .source = "const int k=3;enum{E=__builtin_choose_expr(k,4,5)};\n",
        .rejected = true,
    },
    {
        .name = "const scalar becomes a GNU enumerator value",
        .source = "const int k=3;\nenum { E=k };\n_Static_assert(E==3,\"enumerator value\");\n",
    },
    {
        .name = "const scalar folds a file-scope array bound",
        .source = "const int k=3;\nint a[k];\n_Static_assert(sizeof(a)==3*sizeof(int),\"folded array extent\");\n",
    },
    {
        .name = "automatic const scalar folds a case label",
        .source = "int f(int n){const int k=3;switch(n){case k:return 1;default:return 0;}}\n",
    },
    {
        .name = "const unsigned scalar folds a bit-field width",
        .source = "const unsigned k=3;\nstruct S{unsigned b:k;};\n_Static_assert(sizeof(struct S)==sizeof(unsigned),\"bit-field storage\");\n",
    },
    {
        .name = "const scalar folds a static assertion",
        .source = "const int k=3;\n_Static_assert(k==3,\"value\");\n",
    },
    {
        .name = "const scalar supplies a static initializer",
        .source = "const int k=3;\nint g=k;\n",
    },
    {
        .name = "const record member folds an enumerator",
        .source = "struct P{int x;};const struct P p={4};\nenum { F=p.x };\n_Static_assert(F==4,\"record member value\");\n",
    },
    {
        .name = "completed const initializer chains retain converted values",
        .source = "const int a=3;const int b=a+2;\nenum { E=b };\n_Static_assert(E==5,\"initializer chain\");\n",
    },
    {
        .name = "const nested array member folds a selected element",
        .source = "struct P{int a[2];};const struct P p={{2,5}};\nenum { E=p.a[1] };\n_Static_assert(E==5,\"nested array element\");\n",
    },
    {
        .name = "const union folds its active member",
        .source = "union U{int x;float f;};const union U u={.x=7};\nenum { E=u.x };\n_Static_assert(E==7,\"active union value\");\n",
    },
    {
        .name = "const union inactive member cannot borrow active bytes",
        .source = "union U{int x;float f;};const union U u={.f=1.0f};\nenum { E=u.x };\n",
        .rejected = true,
    },
    {
        .name = "const floating object converts in a static initializer",
        .source = "const double k=3.5;\nint g=(int)k;\n",
    },
    {
        .name = "const pointer object retains a symbolic target in a static initializer",
        .source = "int object;int* const p=&object;\nint* q=p;\n",
    },
    {
        .name = "const pointer object can designate another completed const object",
        .source = "const int k=3;const int* const p=&k;\nenum { E=*p };\n_Static_assert(E==3,\"const pointer dereference\");\n",
    },
    {
        .name = "const pointer retains string-literal bytes for a constant element read",
        .source = "const char* const p=\"abc\";\nenum { E=p[1] };\n_Static_assert(E=='b',\"literal string element\");\n",
    },
    {
        .name = "a folded const-object zero is not an ICE-form null pointer constant",
        .source = "const int z=0;\nint* p=z;\n",
        .rejected = true,
    },
    {
        .name = "mutable scalar initialization is not const-object evidence",
        .source = "int k=3;\nenum { E=k };\n",
        .rejected = true,
    },
    {
        .name = "volatile const scalar cannot supply a constant value",
        .source = "const volatile int k=3;\nenum { E=k };\n",
        .rejected = true,
    },
    {
        .name = "a future initializer cannot satisfy an earlier const-object read",
        .source = "extern const int k;\nenum { E=k };const int k=3;\n",
        .rejected = true,
    },
    {
        .name = "const initializer cycles remain nonconstant",
        .source = "extern const int a,b;const int a=b;\nconst int b=a;enum { E=a };\n",
        .rejected = true,
    },
    {
        .name = "a mutable local shadow does not reuse the outer const receipt",
        .source = "const int k=3;\nint f(void){int k=2;enum { E=k };return E;}\n",
        .rejected = true,
    },
    {
        .name = "uninitialized automatic const object has no retained value",
        .source = "int f(void){const int k;enum { E=k };return E;}\n",
        .rejected = true,
    },
    {
        .name = "an evaluated side effect prevents folding a const-object expression",
        .source = "int n;const int k=3;\nenum { E=(++n,k) };\n",
        .rejected = true,
    },
    {
        .name = "a runtime const initializer does not become a constant receipt",
        .source = "int get(void);int f(void){const int k=get();enum { E=k };return E;}\n",
        .rejected = true,
    },
    {
        .name = "a mutable array index cannot select a constant element",
        .source = "const int a[2]={1,2};int n;\nenum { E=a[n] };\n",
        .rejected = true,
    },
    {
        .name = "a one-past const array element is not a readable constant subobject",
        .source = "const int a[2]={1,2};\nenum { E=a[2] };\n",
        .rejected = true,
    },
    {
        .name = "another effectful aggregate member prevents a partial constant receipt",
        .source = "int get(void);struct P{int a,b;};\nint f(void){const struct P p={3,get()};enum { E=p.a };return E;}\n",
        .rejected = true,
    },
    {
        .name = "a mutable pointer object cannot supply a constant dereference",
        .source = "const int k=3;const int* p=&k;\nenum { E=*p };\n",
        .rejected = true,
    },
    {
        .name = "const atomic scalar may be read during explicit constant evaluation",
        .source = "const _Atomic(int) az=0;\nenum { E=az };\n_Static_assert(E==0,\"const atomic value\");\n",
    },
    {
        .name = "const record atomic member may be read during explicit constant evaluation",
        .source = "struct P{_Atomic(int) x;};const struct P p={0};\nenum { E=p.x };\n_Static_assert(E==0,\"const atomic member value\");\n",
    },
    {
        .name = "an enumerator resets const-object provenance to an ordinary ICE zero",
        .source = "const int z=0;enum { G=z };\nint* q=G;\n_Static_assert(G==0,\"enumerator zero\");\n",
    },
    {
        .name = "a const member does not make its mutable defining record constant",
        .source = "struct P{const int x;int y;};struct P p={3,4};\nenum { E=p.x };\n",
        .rejected = true,
    },
    {
        .name = "a const member does not make its mutable defining union constant",
        .source = "union U{const int x;int y;};union U u={.x=3};\nenum { E=u.x };\n",
        .rejected = true,
    },
    {
        .name = "const atomic scalar supplies a static initializer without becoming a runtime load",
        .source = "const _Atomic(int) az=3;\nint g=az;\n",
    },
    {
        .name = "implicit const record members retain initialization zeros",
        .source = "struct P{int x,y;};const struct P p={4};\n_Static_assert(p.y==0,\"zero\");\n",
    },
    {
        .name = "implicit const array elements retain initialization zeros",
        .source = "const int a[2]={1};\n_Static_assert(a[1]==0,\"zero\");\n",
    },
    {
        .name = "const record value copy preserves explicit and implicit subobjects",
        .source = "struct P{int x,y;};const struct P p={4};const struct P q=p;\n_Static_assert(q.x==4 && q.y==0,\"copy\");\n",
    },
    {
        .name = "an inactive union member's address remains a valid symbolic pointer",
        .source = "union U{int x,y;};const union U u={.x=3};const int* const p=&u.y;\nconst int* q=p;\n",
    },
    {
        .name = "dereferencing a pointer to an inactive union member remains nonconstant",
        .source = "union U{int x,y;};const union U u={.x=3};const int* const p=&u.y;\nenum{E=*p};\n",
        .rejected = true,
    },
    {
        .name = "same-type inactive union members cannot share constant-read proof",
        .source = "union U{int x,y;};const union U u={.x=3};\nenum{E=u.y};\n",
        .rejected = true,
    },
    {
        .name = "const nonbyte bit-field values retain their stored bits",
        .source = "struct P{unsigned a:3,b:3;};const struct P p={1,5};\n_Static_assert(p.b==5,\"bits\");\n",
    },
    {
        .name = "a block-scope const bound remains a variable-length array type",
        .source = "int f(void){const int k=3;int a[k];_Static_assert(sizeof a==3*sizeof(int),\"bound\");return sizeof a;}\n",
        .rejected = true,
    },
};
assert(sizeof("sparse const arrays do not materialize their declared extent")-1==strlen("sparse const arrays do not materialize their declared extent"));
assert(sizeof("const double k=3.5;enum{E=__builtin_isgreater(k,0.0)};_Static_assert(E==1,\"compare\");\n")-1==strlen("const double k=3.5;enum{E=__builtin_isgreater(k,0.0)};_Static_assert(E==1,\"compare\");\n"));
assert(sizeof("const nested array member folds a selected element")-1==strlen("const nested array member folds a selected element"));
assert(sizeof("struct P{unsigned a:3,b:3;};const struct P p={1,5};\n_Static_assert(p.b==5,\"bits\");\n")-1==strlen("struct P{unsigned a:3,b:3;};const struct P p={1,5};\n_Static_assert(p.b==5,\"bits\");\n"));
assert(sizeof("union U{int x;float f;};const union U u={.x=7};\nenum { E=u.x };\n_Static_assert(E==7,\"active union value\");\n")-1==strlen("union U{int x;float f;};const union U u={.x=7};\nenum { E=u.x };\n_Static_assert(E==7,\"active union value\");\n"));
assert(sizeof("int get(void);struct P{int x;};int f(void){const struct P p={.x=get(),.x=3};enum{E=p.x};_Static_assert(E==3,\"override\");return E;}\n")-1==strlen("int get(void);struct P{int x;};int f(void){const struct P p={.x=get(),.x=3};enum{E=p.x};_Static_assert(E==3,\"override\");return E;}\n"));
assert(sizeof("a folded const-object zero is not an ICE-form null pointer constant")-1==strlen("a folded const-object zero is not an ICE-form null pointer constant"));
assert(sizeof("an automatic address can be consumed by a direct constant read")-1==strlen("an automatic address can be consumed by a direct constant read"));
assert(sizeof("int n;const int k=3;\nenum { E=(++n,k) };\n")-1==strlen("int n;const int k=3;\nenum { E=(++n,k) };\n"));
assert(sizeof("automatic object addresses do not make a const pointer initializer constant")-1==strlen("automatic object addresses do not make a const pointer initializer constant"));
assert(sizeof("an inactive union member's address remains a valid symbolic pointer")-1==strlen("an inactive union member's address remains a valid symbolic pointer"));
assert(sizeof("const nonbyte bit-field values retain their stored bits")-1==strlen("const nonbyte bit-field values retain their stored bits"));
assert(sizeof("dereferencing a pointer to an inactive union member remains nonconstant")-1==strlen("dereferencing a pointer to an inactive union member remains nonconstant"));
assert(sizeof("const int k=3;\nint g=k;\n")-1==strlen("const int k=3;\nint g=k;\n"));
assert(sizeof("an equal-sized nested child is not a whole replacement of its parent")-1==strlen("an equal-sized nested child is not a whole replacement of its parent"));
assert(sizeof("const int k=3;enum{E=__builtin_expect(k,0)};_Static_assert(E==3,\"expect\");\n")-1==strlen("const int k=3;enum{E=__builtin_expect(k,0)};_Static_assert(E==3,\"expect\");\n"));
assert(sizeof("int get(void);struct P{int x;};const struct P p={.x=get(),.x=3};enum{E=p.x};_Static_assert(E==3,\"file override\");\n")-1==strlen("int get(void);struct P{int x;};const struct P p={.x=get(),.x=3};enum{E=p.x};_Static_assert(E==3,\"file override\");\n"));
assert(sizeof("a const member does not make its mutable defining union constant")-1==strlen("a const member does not make its mutable defining union constant"));
assert(sizeof("a one-past const array element is not a readable constant subobject")-1==strlen("a one-past const array element is not a readable constant subobject"));
assert(sizeof("struct S{int x,y;};struct P{struct S s;};struct S make(void);int f(void){const struct P p={.s=make(),.s={1,2}};enum{E=p.s.x};_Static_assert(E==1,\"whole replacement\");return E;}\n")-1==strlen("struct S{int x,y;};struct P{struct S s;};struct S make(void);int f(void){const struct P p={.s=make(),.s={1,2}};enum{E=p.s.x};_Static_assert(E==1,\"whole replacement\");return E;}\n"));
assert(sizeof("automatic const scalar folds a case label")-1==strlen("automatic const scalar folds a case label"));
assert(sizeof("int f(void){const int k=3;const int n=sizeof(int[k]);enum{E=n};return E;}\n")-1==strlen("int f(void){const int k=3;const int n=sizeof(int[k]);enum{E=n};return E;}\n"));
assert(sizeof("const record atomic member may be read during explicit constant evaluation")-1==strlen("const record atomic member may be read during explicit constant evaluation"));
assert(sizeof("struct P{int a[2];};const struct P p={{2,5}};\nenum { E=p.a[1] };\n_Static_assert(E==5,\"nested array element\");\n")-1==strlen("struct P{int a[2];};const struct P p={{2,5}};\nenum { E=p.a[1] };\n_Static_assert(E==5,\"nested array element\");\n"));
assert(sizeof("int object;int* const p=&object;\nint* q=p;\n")-1==strlen("int object;int* const p=&object;\nint* q=p;\n"));
assert(sizeof("const int k=3;\nenum { E=k };\n_Static_assert(E==3,\"enumerator value\");\n")-1==strlen("const int k=3;\nenum { E=k };\n_Static_assert(E==3,\"enumerator value\");\n"));
assert(sizeof("uninitialized automatic const object has no retained value")-1==strlen("uninitialized automatic const object has no retained value"));
assert(sizeof("struct S{int x,y;};struct P{struct S s;};const struct S base={8,9};int touch(void);int f(void){const struct P p={.s=(touch(),base),.s={1,2}};enum{E=p.s.x};_Static_assert(E==1,\"rvalue replacement\");return E;}\n")-1==strlen("struct S{int x,y;};struct P{struct S s;};const struct S base={8,9};int touch(void);int f(void){const struct P p={.s=(touch(),base),.s={1,2}};enum{E=p.s.x};_Static_assert(E==1,\"rvalue replacement\");return E;}\n"));
assert(sizeof("const int k=3;enum{E=__builtin_choose_expr(k,4,5)};\n")-1==strlen("const int k=3;enum{E=__builtin_choose_expr(k,4,5)};\n"));
assert(sizeof("a whole replacement discards an effectful aggregate rvalue retaining an object ID")-1==strlen("a whole replacement discards an effectful aggregate rvalue retaining an object ID"));
assert(sizeof("const scalar becomes a GNU enumerator value")-1==strlen("const scalar becomes a GNU enumerator value"));
assert(sizeof("int f(void){const int k=3;int a[k];_Static_assert(sizeof a==3*sizeof(int),\"bound\");return sizeof a;}\n")-1==strlen("int f(void){const int k=3;int a[k];_Static_assert(sizeof a==3*sizeof(int),\"bound\");return sizeof a;}\n"));
assert(sizeof("union U{int x,y;};const union U u={.x=3};const int* const p=&u.y;\nenum{E=*p};\n")-1==strlen("union U{int x,y;};const union U u={.x=3};const int* const p=&u.y;\nenum{E=*p};\n"));
assert(sizeof("int f(void){const int k=3;const int* const p=&k;enum{E=*p};_Static_assert(E==3,\"local pointer\");return E;}\n")-1==strlen("int f(void){const int k=3;const int* const p=&k;enum{E=*p};_Static_assert(E==3,\"local pointer\");return E;}\n"));
assert(sizeof("const int a[2]={1};\n_Static_assert(a[1]==0,\"zero\");\n")-1==strlen("const int a[2]={1};\n_Static_assert(a[1]==0,\"zero\");\n"));
assert(sizeof("const union folds its active member")-1==strlen("const union folds its active member"));
assert(sizeof("int k=3;\nenum { E=k };\n")-1==strlen("int k=3;\nenum { E=k };\n"));
assert(sizeof("a mutable local shadow does not reuse the outer const receipt")-1==strlen("a mutable local shadow does not reuse the outer const receipt"));
assert(sizeof("sizeof a VLA type does not make a later const object constant")-1==strlen("sizeof a VLA type does not make a later const object constant"));
assert(sizeof("const pointer object can designate another completed const object")-1==strlen("const pointer object can designate another completed const object"));
assert(sizeof("const int a=3;const int b=a+2;\nenum { E=b };\n_Static_assert(E==5,\"initializer chain\");\n")-1==strlen("const int a=3;const int b=a+2;\nenum { E=b };\n_Static_assert(E==5,\"initializer chain\");\n"));
assert(sizeof("a whole aggregate replacement makes an earlier aggregate call dead")-1==strlen("a whole aggregate replacement makes an earlier aggregate call dead"));
assert(sizeof("const int a[2]={1,2};\nenum { E=a[2] };\n")-1==strlen("const int a[2]={1,2};\nenum { E=a[2] };\n"));
assert(sizeof("a mutable array index cannot select a constant element")-1==strlen("a mutable array index cannot select a constant element"));
assert(sizeof("int f(int n){const int k=3;switch(n){case k:return 1;default:return 0;}}\n")-1==strlen("int f(int n){const int k=3;switch(n){case k:return 1;default:return 0;}}\n"));
assert(sizeof("const unsigned k=3;\nstruct S{unsigned b:k;};\n_Static_assert(sizeof(struct S)==sizeof(unsigned),\"bit-field storage\");\n")-1==strlen("const unsigned k=3;\nstruct S{unsigned b:k;};\n_Static_assert(sizeof(struct S)==sizeof(unsigned),\"bit-field storage\");\n"));
assert(sizeof("const int k=3;\nint f(void){int k=2;enum { E=k };return E;}\n")-1==strlen("const int k=3;\nint f(void){int k=2;enum { E=k };return E;}\n"));
assert(sizeof("a const bound in a sizeof type-name keeps its variable array type")-1==strlen("a const bound in a sizeof type-name keeps its variable array type"));
assert(sizeof("int get(void);int f(void){const int k=get();enum { E=k };return E;}\n")-1==strlen("int get(void);int f(void){const int k=get();enum { E=k };return E;}\n"));
assert(sizeof("struct I{int x,y;};struct O{struct I a,b;};const struct O p={{1},{2}};const struct I q=p.b;_Static_assert(q.x==2 && q.y==0,\"copy\");\n")-1==strlen("struct I{int x,y;};struct O{struct I a,b;};const struct O p={{1},{2}};const struct I q=p.b;_Static_assert(q.x==2 && q.y==0,\"copy\");\n"));
assert(sizeof("struct P{_Atomic(int) x;};const struct P p={0};\nenum { E=p.x };\n_Static_assert(E==0,\"const atomic member value\");\n")-1==strlen("struct P{_Atomic(int) x;};const struct P p={0};\nenum { E=p.x };\n_Static_assert(E==0,\"const atomic member value\");\n"));
assert(sizeof("fully overridden scalar GNU range expressions are dead")-1==strlen("fully overridden scalar GNU range expressions are dead"));
assert(sizeof("int get(void);struct P{int a,b;};\nint f(void){const struct P p={3,get()};enum { E=p.a };return E;}\n")-1==strlen("int get(void);struct P{int a,b;};\nint f(void){const struct P p={3,get()};enum { E=p.a };return E;}\n"));
assert(sizeof("builtin expect retains its own ICE contract after a const read")-1==strlen("builtin expect retains its own ICE contract after a const read"));
assert(sizeof("int f(void){const int a[2]={2,5};enum{E=(&a[0])[1]};_Static_assert(E==5,\"array address\");return E;}\n")-1==strlen("int f(void){const int a[2]={2,5};enum{E=(&a[0])[1]};_Static_assert(E==5,\"array address\");return E;}\n"));
assert(sizeof("overridden file-scope nonconstant writes do not poison final const value")-1==strlen("overridden file-scope nonconstant writes do not poison final const value"));
assert(sizeof("const int k=3;const int* const p=&k;\nenum { E=*p };\n_Static_assert(E==3,\"const pointer dereference\");\n")-1==strlen("const int k=3;const int* const p=&k;\nenum { E=*p };\n_Static_assert(E==3,\"const pointer dereference\");\n"));
assert(sizeof("extern const int k;\nenum { E=k };const int k=3;\n")-1==strlen("extern const int k;\nenum { E=k };const int k=3;\n"));
assert(sizeof("struct P{int x,y;};const struct P p={4};\n_Static_assert(p.y==0,\"zero\");\n")-1==strlen("struct P{int x,y;};const struct P p={4};\n_Static_assert(p.y==0,\"zero\");\n"));
assert(sizeof("const _Atomic(int) az=0;\nenum { E=az };\n_Static_assert(E==0,\"const atomic value\");\n")-1==strlen("const _Atomic(int) az=0;\nenum { E=az };\n_Static_assert(E==0,\"const atomic value\");\n"));
assert(sizeof("union U{const int x;int y;};union U u={.x=3};\nenum { E=u.x };\n")-1==strlen("union U{const int x;int y;};union U u={.x=3};\nenum { E=u.x };\n"));
assert(sizeof("overridden effectful initializer is absent from the final value")-1==strlen("overridden effectful initializer is absent from the final value"));
assert(sizeof("const double k=3.5;\nint g=(int)k;\n")-1==strlen("const double k=3.5;\nint g=(int)k;\n"));
assert(sizeof("union U{int x,y;};const union U u={.x=3};const int* const p=&u.y;\nconst int* q=p;\n")-1==strlen("union U{int x,y;};const union U u={.x=3};const int* const p=&u.y;\nconst int* q=p;\n"));
assert(sizeof("overridden effects do not poison another surviving aggregate member")-1==strlen("overridden effects do not poison another surviving aggregate member"));
assert(sizeof("a mutable pointer object cannot supply a constant dereference")-1==strlen("a mutable pointer object cannot supply a constant dereference"));
assert(sizeof("const int k=3;\nint a[k];\n_Static_assert(sizeof(a)==3*sizeof(int),\"folded array extent\");\n")-1==strlen("const int k=3;\nint a[k];\n_Static_assert(sizeof(a)==3*sizeof(int),\"folded array extent\");\n"));
assert(sizeof("const scalar folds a file-scope array bound")-1==strlen("const scalar folds a file-scope array bound"));
assert(sizeof("const pointer retains string-literal bytes for a constant element read")-1==strlen("const pointer retains string-literal bytes for a constant element read"));
assert(sizeof("const int z=0;\nint* p=z;\n")-1==strlen("const int z=0;\nint* p=z;\n"));
assert(sizeof("const atomic scalar may be read during explicit constant evaluation")-1==strlen("const atomic scalar may be read during explicit constant evaluation"));
assert(sizeof("struct I{int x;};struct O{struct I i;};struct P{struct O o;};struct O make(void);void f(void){const struct P p={.o=make(),.o.i={1}};enum{E=p.o.i.x};}\n")-1==strlen("struct I{int x;};struct O{struct I i;};struct P{struct O o;};struct O make(void);void f(void){const struct P p={.o=make(),.o.i={1}};enum{E=p.o.i.x};}\n"));
assert(sizeof("extern const int a,b;const int a=b;\nconst int b=a;enum { E=a };\n")-1==strlen("extern const int a,b;const int a=b;\nconst int b=a;enum { E=a };\n"));
assert(sizeof("int f(void){const int k=3;enum{E=*(&k)};_Static_assert(E==3,\"direct address\");return E;}\n")-1==strlen("int f(void){const int k=3;enum{E=*(&k)};_Static_assert(E==3,\"direct address\");return E;}\n"));
assert(sizeof("const int k=3;const int n=sizeof(int[k]);enum{E=n};\n")-1==strlen("const int k=3;const int n=sizeof(int[k]);enum{E=n};\n"));
assert(sizeof("const scalar folds a static assertion")-1==strlen("const scalar folds a static assertion"));
assert(sizeof("union U{int x;float f;};const union U u={.f=1.0f};\nenum { E=u.x };\n")-1==strlen("union U{int x;float f;};const union U u={.f=1.0f};\nenum { E=u.x };\n"));
assert(sizeof("automatic const array retains a source-only address path")-1==strlen("automatic const array retains a source-only address path"));
assert(sizeof("int f(void){const int k;enum { E=k };return E;}\n")-1==strlen("int f(void){const int k;enum { E=k };return E;}\n"));
assert(sizeof("automatic array addresses can be consumed without publishing a pointer value")-1==strlen("automatic array addresses can be consumed without publishing a pointer value"));
assert(sizeof("an enumerator resets const-object provenance to an ordinary ICE zero")-1==strlen("an enumerator resets const-object provenance to an ordinary ICE zero"));
assert(sizeof("int f(void){const int a[2]={2,5};enum{E=a[1]};_Static_assert(E==5,\"local array\");return E;}\n")-1==strlen("int f(void){const int a[2]={2,5};enum{E=a[1]};_Static_assert(E==5,\"local array\");return E;}\n"));
assert(sizeof("completed const initializer chains retain converted values")-1==strlen("completed const initializer chains retain converted values"));
assert(sizeof("a const pointer initialized by automatic array decay is not constant evidence")-1==strlen("a const pointer initialized by automatic array decay is not constant evidence"));
assert(sizeof("const _Atomic(int) az=3;\nint g=az;\n")-1==strlen("const _Atomic(int) az=3;\nint g=az;\n"));
assert(sizeof("const initializer cycles remain nonconstant")-1==strlen("const initializer cycles remain nonconstant"));
assert(sizeof("scalar field coverage does not kill an aggregate-copy base expression")-1==strlen("scalar field coverage does not kill an aggregate-copy base expression"));
assert(sizeof("const int k=3;enum{E=sizeof(int[k])};\n")-1==strlen("const int k=3;enum{E=sizeof(int[k])};\n"));
assert(sizeof("const unsigned scalar folds a bit-field width")-1==strlen("const unsigned scalar folds a bit-field width"));
assert(sizeof("const int k=3;\n_Static_assert(k==3,\"value\");\n")-1==strlen("const int k=3;\n_Static_assert(k==3,\"value\");\n"));
assert(sizeof("volatile const scalar cannot supply a constant value")-1==strlen("volatile const scalar cannot supply a constant value"));
assert(sizeof("static initialization cannot consume sizeof a variable array type")-1==strlen("static initialization cannot consume sizeof a variable array type"));
assert(sizeof("const floating object converts in a static initializer")-1==strlen("const floating object converts in a static initializer"));
assert(sizeof("implicit const array elements retain initialization zeros")-1==strlen("implicit const array elements retain initialization zeros"));
assert(sizeof("aggregate subobject copies clip implicit zero coverage")-1==strlen("aggregate subobject copies clip implicit zero coverage"));
assert(sizeof("another effectful aggregate member prevents a partial constant receipt")-1==strlen("another effectful aggregate member prevents a partial constant receipt"));
assert(sizeof("struct P{int x;};const struct P p={4};\nenum { F=p.x };\n_Static_assert(F==4,\"record member value\");\n")-1==strlen("struct P{int x;};const struct P p={4};\nenum { F=p.x };\n_Static_assert(F==4,\"record member value\");\n"));
assert(sizeof("const volatile int k=3;\nenum { E=k };\n")-1==strlen("const volatile int k=3;\nenum { E=k };\n"));
assert(sizeof("const atomic scalar supplies a static initializer without becoming a runtime load")-1==strlen("const atomic scalar supplies a static initializer without becoming a runtime load"));
assert(sizeof("struct P{int x,y;};const struct P p={4};const struct P q=p;\n_Static_assert(q.x==4 && q.y==0,\"copy\");\n")-1==strlen("struct P{int x,y;};const struct P p={4};const struct P q=p;\n_Static_assert(q.x==4 && q.y==0,\"copy\");\n"));
assert(sizeof("const scalar supplies a static initializer")-1==strlen("const scalar supplies a static initializer"));
assert(sizeof("const int k=3;const int* p=&k;\nenum { E=*p };\n")-1==strlen("const int k=3;const int* p=&k;\nenum { E=*p };\n"));
assert(sizeof("const pointer object retains a symbolic target in a static initializer")-1==strlen("const pointer object retains a symbolic target in a static initializer"));
assert(sizeof("implicit const record members retain initialization zeros")-1==strlen("implicit const record members retain initialization zeros"));
assert(sizeof("floating comparison builtin inherits GNU const-read evidence")-1==strlen("floating comparison builtin inherits GNU const-read evidence"));
assert(sizeof("const record member folds an enumerator")-1==strlen("const record member folds an enumerator"));
assert(sizeof("a future initializer cannot satisfy an earlier const-object read")-1==strlen("a future initializer cannot satisfy an earlier const-object read"));
assert(sizeof("struct S{int x,y;};struct P{struct S s;};struct S make(void);void f(void){const struct P p={.s=make(),.s.x=1,.s.y=2};enum{E=p.s.x};}\n")-1==strlen("struct S{int x,y;};struct P{struct S s;};struct S make(void);void f(void){const struct P p={.s=make(),.s.x=1,.s.y=2};enum{E=p.s.x};}\n"));
assert(sizeof("same-type inactive union members cannot share constant-read proof")-1==strlen("same-type inactive union members cannot share constant-read proof"));
assert(sizeof("struct P{const int x;int y;};struct P p={3,4};\nenum { E=p.x };\n")-1==strlen("struct P{const int x;int y;};struct P p={3,4};\nenum { E=p.x };\n"));
assert(sizeof("union U{int x,y;};const union U u={.x=3};\nenum{E=u.y};\n")-1==strlen("union U{int x,y;};const union U u={.x=3};\nenum{E=u.y};\n"));
assert(sizeof("const record value copy preserves explicit and implicit subobjects")-1==strlen("const record value copy preserves explicit and implicit subobjects"));
assert(sizeof("choose expression retains its stricter ICE requirement")-1==strlen("choose expression retains its stricter ICE requirement"));
assert(sizeof("const char* const p=\"abc\";\nenum { E=p[1] };\n_Static_assert(E=='b',\"literal string element\");\n")-1==strlen("const char* const p=\"abc\";\nenum { E=p[1] };\n_Static_assert(E=='b',\"literal string element\");\n"));
assert(sizeof("mutable scalar initialization is not const-object evidence")-1==strlen("mutable scalar initialization is not const-object evidence"));
assert(sizeof("a const member does not make its mutable defining record constant")-1==strlen("a const member does not make its mutable defining record constant"));
assert(sizeof("a runtime const initializer does not become a constant receipt")-1==strlen("a runtime const initializer does not become a constant receipt"));
assert(sizeof("const union inactive member cannot borrow active bytes")-1==strlen("const union inactive member cannot borrow active bytes"));
assert(sizeof("const int a[2]={1,2};int n;\nenum { E=a[n] };\n")-1==strlen("const int a[2]={1,2};int n;\nenum { E=a[n] };\n"));
assert(sizeof("const int z=0;enum { G=z };\nint* q=G;\n_Static_assert(G==0,\"enumerator zero\");\n")-1==strlen("const int z=0;enum { G=z };\nint* q=G;\n_Static_assert(G==0,\"enumerator zero\");\n"));
assert(sizeof("a block-scope const bound remains a variable-length array type")-1==strlen("a block-scope const bound remains a variable-length array type"));
assert(sizeof("int get(void);struct P{int x,y;};int f(void){const struct P p={.x=get(),.y=4,.x=3};enum{E=p.y};_Static_assert(E==4,\"other member\");return E;}\n")-1==strlen("int get(void);struct P{int x,y;};int f(void){const struct P p={.x=get(),.y=4,.x=3};enum{E=p.y};_Static_assert(E==4,\"other member\");return E;}\n"));
assert(sizeof("int get(void);int f(void){const int a[3]={[0 ... 2]=get(),[0]=1,[1]=2,[2]=3};enum{E=a[0]};_Static_assert(E==1,\"range\");return E;}\n")-1==strlen("int get(void);int f(void){const int a[3]={[0 ... 2]=get(),[0]=1,[1]=2,[2]=3};enum{E=a[0]};_Static_assert(E==1,\"range\");return E;}\n"));
assert(sizeof("@check-const-sparse-source")-1==strlen("@check-const-sparse-source"));
assert(sizeof("int f(void){const int a[2]={2,5};const int* const p=a;enum{E=p[1]};_Static_assert(E==5,\"array pointer\");return E;}\n")-1==strlen("int f(void){const int a[2]={2,5};const int* const p=a;enum{E=p[1]};_Static_assert(E==5,\"array pointer\");return E;}\n"));
assert(sizeof("an evaluated side effect prevents folding a const-object expression")-1==strlen("an evaluated side effect prevents folding a const-object expression"));
for(size_t i=0;i<sizeof rows/sizeof *rows;i++){const CheckSourceFixture*r=rows+i;put(r->name);put(r->source);uint32_t f[]={r->rejected,r->unsupported,r->extension,r->standard,r->char_unsigned,r->undecided,r->overload_tables};assert(!r->capacity);assert(fwrite(f,4,7,stdout)==7);}}
{ const CheckSourceFixture rows[]={
        { .name = "stdc library: result types and folds", .standard = 2023, .source =
          BUSTER_CHECK_TEST_STDC_DECLARATIONS
          "#define T(e, t) _Static_assert(_Generic((e), t: 1, default: 0), #e);\n"
          "void f(unsigned char c, int i)\n{\nT(stdc_leading_zeros_uc(c), unsigned int) T(stdc_bit_floor_ul(i), unsigned long)\n"
          "T(stdc_has_single_bit_ull(i), _Bool) T(stdc_bit_ceil_uc(i), unsigned char)\n}\n"
          "_Static_assert(stdc_leading_zeros_uc(1) == 7 && stdc_count_ones_us(-1) == 16 && stdc_bit_width_ui(5) == 3 && stdc_bit_floor_ul(100) == 64, \"\");\n"
          "_Static_assert(stdc_has_single_bit_ull(1ull << 63) && !stdc_has_single_bit_ull(3) && stdc_bit_ceil_uc(200) == 0 && stdc_bit_ceil_uc(0) == 1, \"\");\n"
          "_Static_assert(stdc_leading_zeros_uc(-1) == 0 && stdc_count_ones_us(0x10000) == 0 && stdc_leading_zeros_uc(256) == 8, \"\");\n"
          "enum { E = stdc_trailing_zeros_ull(1ull << 40) };\n"
          "static int s = stdc_first_leading_one_ul(1);\n"
          "int a[stdc_bit_ceil_uc(3)];\n"
          "_Static_assert(E == 40 && sizeof a == 4 * sizeof(int), \"\");\n" },
        { .name = "stdc library: a block's declaration and a const parameter", .standard = 2023, .source =
          "unsigned stdc_leading_zeros_ui(const unsigned);\n_Static_assert(stdc_leading_zeros_ui(1) == 31, \"\");\n"
          "unsigned f(double d)\n{\nextern unsigned stdc_count_ones_ui(unsigned);\nreturn stdc_leading_zeros_ui(d) + stdc_count_ones_ui(1.5);\n}\n" },
        { .name = "stdc library: a pointer's argument", .standard = 2023, .rejected = true, .source =
          BUSTER_CHECK_TEST_STDC_DECLARATIONS "unsigned f(int *p)\n{\nreturn stdc_bit_width_ui(p);\n}\n" },
        { .name = "stdc library: a struct's argument", .standard = 2023, .rejected = true, .source =
          BUSTER_CHECK_TEST_STDC_DECLARATIONS "struct S { int x; };\nunsigned f(struct S s)\n{\nreturn stdc_bit_width_ui(s);\n}\n" },
        { .name = "stdc library: two arguments", .standard = 2023, .rejected = true, .source =
          BUSTER_CHECK_TEST_STDC_DECLARATIONS "unsigned f(unsigned x)\n{\nreturn stdc_bit_width_ui(x, 1);\n}\n" },
        { .name = "stdc library: another prototype's declaration is no constant", .standard = 2023, .rejected = true, .source =
          "int stdc_leading_zeros_ui(int);\n_Static_assert(stdc_leading_zeros_ui(1) == 31, \"\");\n" },
        { .name = "stdc library: another prototype's declaration is called", .standard = 2023, .source =
          "int stdc_leading_zeros_ui(int);\nint f(int x)\n{\nreturn stdc_leading_zeros_ui(x);\n}\n" },
        { .name = "stdc library: a static function is no constant", .standard = 2023, .rejected = true, .source =
          "static unsigned stdc_leading_zeros_ui(unsigned x)\n{\nreturn x;\n}\n_Static_assert(stdc_leading_zeros_ui(1) == 31, \"\");\n" },
        { .name = "stdc library: C17's declaration is no constant", .rejected = true, .source =
          "unsigned stdc_leading_zeros_ui(unsigned);\n_Static_assert(stdc_leading_zeros_ui(1) == 31, \"\");\n" },
        { .name = "stdc library: C17's declaration is called", .source =
          BUSTER_CHECK_TEST_STDC_DECLARATIONS "unsigned f(unsigned x)\n{\nreturn stdc_bit_width_ui(x) + stdc_bit_ceil_uc(x);\n}\n" },
    };
assert(sizeof("stdc library: another prototype's declaration is called")-1==strlen("stdc library: another prototype's declaration is called"));
assert(sizeof("unsigned stdc_leading_zeros_ui(unsigned);\n_Static_assert(stdc_leading_zeros_ui(1) == 31, \"\");\n")-1==strlen("unsigned stdc_leading_zeros_ui(unsigned);\n_Static_assert(stdc_leading_zeros_ui(1) == 31, \"\");\n"));
assert(sizeof("_Static_assert(stdc_has_single_bit_ull(1ull << 63) && !stdc_has_single_bit_ull(3) && stdc_bit_ceil_uc(200) == 0 && stdc_bit_ceil_uc(0) == 1, \"\");\n")-1==strlen("_Static_assert(stdc_has_single_bit_ull(1ull << 63) && !stdc_has_single_bit_ull(3) && stdc_bit_ceil_uc(200) == 0 && stdc_bit_ceil_uc(0) == 1, \"\");\n"));
assert(sizeof("stdc library: two arguments")-1==strlen("stdc library: two arguments"));
assert(sizeof("struct S { int x; };\nunsigned f(struct S s)\n{\nreturn stdc_bit_width_ui(s);\n}\n")-1==strlen("struct S { int x; };\nunsigned f(struct S s)\n{\nreturn stdc_bit_width_ui(s);\n}\n"));
assert(sizeof("stdc library: a struct's argument")-1==strlen("stdc library: a struct's argument"));
assert(sizeof("stdc library: C17's declaration is no constant")-1==strlen("stdc library: C17's declaration is no constant"));
assert(sizeof("unsigned f(int *p)\n{\nreturn stdc_bit_width_ui(p);\n}\n")-1==strlen("unsigned f(int *p)\n{\nreturn stdc_bit_width_ui(p);\n}\n"));
assert(sizeof("static unsigned stdc_leading_zeros_ui(unsigned x)\n{\nreturn x;\n}\n_Static_assert(stdc_leading_zeros_ui(1) == 31, \"\");\n")-1==strlen("static unsigned stdc_leading_zeros_ui(unsigned x)\n{\nreturn x;\n}\n_Static_assert(stdc_leading_zeros_ui(1) == 31, \"\");\n"));
assert(sizeof("int stdc_leading_zeros_ui(int);\n_Static_assert(stdc_leading_zeros_ui(1) == 31, \"\");\n")-1==strlen("int stdc_leading_zeros_ui(int);\n_Static_assert(stdc_leading_zeros_ui(1) == 31, \"\");\n"));
assert(sizeof("stdc library: a pointer's argument")-1==strlen("stdc library: a pointer's argument"));
assert(sizeof("void f(unsigned char c, int i)\n{\nT(stdc_leading_zeros_uc(c), unsigned int) T(stdc_bit_floor_ul(i), unsigned long)\n")-1==strlen("void f(unsigned char c, int i)\n{\nT(stdc_leading_zeros_uc(c), unsigned int) T(stdc_bit_floor_ul(i), unsigned long)\n"));
assert(sizeof("stdc library: a block's declaration and a const parameter")-1==strlen("stdc library: a block's declaration and a const parameter"));
assert(sizeof("int stdc_leading_zeros_ui(int);\nint f(int x)\n{\nreturn stdc_leading_zeros_ui(x);\n}\n")-1==strlen("int stdc_leading_zeros_ui(int);\nint f(int x)\n{\nreturn stdc_leading_zeros_ui(x);\n}\n"));
assert(sizeof("unsigned f(double d)\n{\nextern unsigned stdc_count_ones_ui(unsigned);\nreturn stdc_leading_zeros_ui(d) + stdc_count_ones_ui(1.5);\n}\n")-1==strlen("unsigned f(double d)\n{\nextern unsigned stdc_count_ones_ui(unsigned);\nreturn stdc_leading_zeros_ui(d) + stdc_count_ones_ui(1.5);\n}\n"));
assert(sizeof("stdc library: result types and folds")-1==strlen("stdc library: result types and folds"));
assert(sizeof("_Static_assert(E == 40 && sizeof a == 4 * sizeof(int), \"\");\n")-1==strlen("_Static_assert(E == 40 && sizeof a == 4 * sizeof(int), \"\");\n"));
assert(sizeof("_Static_assert(stdc_leading_zeros_uc(-1) == 0 && stdc_count_ones_us(0x10000) == 0 && stdc_leading_zeros_uc(256) == 8, \"\");\n")-1==strlen("_Static_assert(stdc_leading_zeros_uc(-1) == 0 && stdc_count_ones_us(0x10000) == 0 && stdc_leading_zeros_uc(256) == 8, \"\");\n"));
assert(sizeof("stdc library: a static function is no constant")-1==strlen("stdc library: a static function is no constant"));
assert(sizeof("int a[stdc_bit_ceil_uc(3)];\n")-1==strlen("int a[stdc_bit_ceil_uc(3)];\n"));
assert(sizeof("unsigned f(unsigned x)\n{\nreturn stdc_bit_width_ui(x, 1);\n}\n")-1==strlen("unsigned f(unsigned x)\n{\nreturn stdc_bit_width_ui(x, 1);\n}\n"));
assert(sizeof("T(stdc_has_single_bit_ull(i), _Bool) T(stdc_bit_ceil_uc(i), unsigned char)\n}\n")-1==strlen("T(stdc_has_single_bit_ull(i), _Bool) T(stdc_bit_ceil_uc(i), unsigned char)\n}\n"));
assert(sizeof("static int s = stdc_first_leading_one_ul(1);\n")-1==strlen("static int s = stdc_first_leading_one_ul(1);\n"));
assert(sizeof("stdc library: another prototype's declaration is no constant")-1==strlen("stdc library: another prototype's declaration is no constant"));
assert(sizeof("#define T(e, t) _Static_assert(_Generic((e), t: 1, default: 0), #e);\n")-1==strlen("#define T(e, t) _Static_assert(_Generic((e), t: 1, default: 0), #e);\n"));
assert(sizeof("stdc library: C17's declaration is called")-1==strlen("stdc library: C17's declaration is called"));
assert(sizeof("unsigned f(unsigned x)\n{\nreturn stdc_bit_width_ui(x) + stdc_bit_ceil_uc(x);\n}\n")-1==strlen("unsigned f(unsigned x)\n{\nreturn stdc_bit_width_ui(x) + stdc_bit_ceil_uc(x);\n}\n"));
assert(sizeof("_Static_assert(stdc_leading_zeros_uc(1) == 7 && stdc_count_ones_us(-1) == 16 && stdc_bit_width_ui(5) == 3 && stdc_bit_floor_ul(100) == 64, \"\");\n")-1==strlen("_Static_assert(stdc_leading_zeros_uc(1) == 7 && stdc_count_ones_us(-1) == 16 && stdc_bit_width_ui(5) == 3 && stdc_bit_floor_ul(100) == 64, \"\");\n"));
assert(sizeof("enum { E = stdc_trailing_zeros_ull(1ull << 40) };\n")-1==strlen("enum { E = stdc_trailing_zeros_ull(1ull << 40) };\n"));
assert(sizeof("unsigned stdc_leading_zeros_ui(const unsigned);\n_Static_assert(stdc_leading_zeros_ui(1) == 31, \"\");\n")-1==strlen("unsigned stdc_leading_zeros_ui(const unsigned);\n_Static_assert(stdc_leading_zeros_ui(1) == 31, \"\");\n"));
for(size_t i=0;i<sizeof rows/sizeof *rows;i++){const CheckSourceFixture*r=rows+i;put(r->name);put(r->source);uint32_t f[]={r->rejected,r->unsupported,r->extension,r->standard,r->char_unsigned,r->undecided,r->overload_tables};assert(!r->capacity);assert(fwrite(f,4,7,stdout)==7);}}
{ const CheckSourceFixture rows[]={
        { .name = "bits: result types", .source =
          "#define T(e, t) _Static_assert(_Generic((e), t: 1, default: 0), #e);\n"
          "enum U { UA = 1 };\n"
          "struct B { unsigned x : 3; int z : 5; };\n"
          "void f(unsigned char c, unsigned short s, _Bool b, enum U e, unsigned _BitInt(37) w, _BitInt(48) v, const unsigned k, struct B r)\n"
          "{\n"
          "T(__builtin_bitreverse8(c), unsigned char) T(__builtin_bitreverse64(1), unsigned long) T(__builtin_clrsbl(1), int) T(__builtin_ctzs(s), int)\n"
          "T(__builtin_popcountg(b), int) T(__builtin_popcountg(e), int) T(__builtin_clzg(w, (short)1), int) T(__builtin_ctzg(r.x, r.z), int)\n"
          "T(__builtin_bitreverseg(v), _BitInt(48)) T(__builtin_bitreverseg(k), unsigned int) T(__builtin_bswapg(e), enum U) T(__builtin_bitreverseg(r.z), int)\n"
          "T(__builtin_stdc_leading_zeros(c), unsigned int) T(__builtin_stdc_has_single_bit(w), _Bool) T(__builtin_stdc_bit_floor(s), unsigned short)\n"
          "T(__builtin_stdc_bit_ceil(w), unsigned _BitInt(37)) T(__builtin_stdc_rotate_left(b, -1), _Bool) T(__builtin_stdc_rotate_right(e, v), enum U)\n"
          "T(__builtin_addcb(c, c, c, &c), unsigned char) T(__builtin_subcll(1, 2, 0, (unsigned long long *)0), unsigned long long)\n"
          "}\n" },
        { .name = "bits: folds in constant contexts", .source =
          "_Static_assert(__builtin_popcountg(7u) == 3 && __builtin_clzg(1u, 5) == 31 && __builtin_clzg(0u, 5) == 5, \"\");\n"
          "_Static_assert(__builtin_ctzg((unsigned char)0, -1) == -1 && __builtin_stdc_bit_ceil(0x80000001u) == 0 && __builtin_stdc_bit_ceil(0u) == 1, \"\");\n"
          "_Static_assert(__builtin_stdc_rotate_left((unsigned char)1, -1) == 0x80 && __builtin_stdc_rotate_right(1u, 33) == 0x80000000u, \"\");\n"
          "_Static_assert(__builtin_bitreverse8(1) == 0x80 && __builtin_clrsb(-1) == 31 && __builtin_clrsbll(0) == 63, \"\");\n"
          "_Static_assert(__builtin_bswapg((unsigned short)0x1234) == 0x3412 && __builtin_bitreverseg((signed char)1) == -128, \"\");\n"
          "_Static_assert(__builtin_stdc_first_leading_zero((unsigned char)0xff) == 0 && __builtin_stdc_leading_ones((unsigned char)0xf0) == 4, \"\");\n"
          "_Static_assert(__builtin_popcountg((unsigned __int128)-1) == 128 && __builtin_clzg((unsigned _BitInt(100))1) == 99, \"\");\n"
          "int a[__builtin_clzs(1)];\n"
          "enum { E1 = __builtin_ctzs(8), E2 = __builtin_stdc_bit_width(5u) };\n"
          "static int s = __builtin_stdc_count_zeros((unsigned short)0x0f0f) + __builtin_ctzg(0u, 9);\n" },
        // Past 128 bits (#1447): the generic and C23 builtins of constants of a _BitInt past 128 bits fold by its limbs
        // (c_check_wide.c), rotations by narrow and wide counts, and a narrow value's rotation by a wide count.
        { .name = "bits: folds past 128 bits", .standard = 2023, .source =
          "typedef unsigned _BitInt(200) U;\ntypedef unsigned _BitInt(256) V;\n"
          "_Static_assert(__builtin_popcountg((U)-1) == 200 && __builtin_clzg((U)1) == 199 && __builtin_ctzg((U)1 << 150) == 150, \"\");\n"
          "_Static_assert(__builtin_clzg((U)0, 7) == 7 && __builtin_ctzg((U)0, -1) == -1 && __builtin_bitreverseg((U)1) == (U)1 << 199, \"\");\n"
          "_Static_assert(__builtin_bswapg((V)0xff) == (V)0xff << 248 && __builtin_stdc_rotate_left((U)1, 201) == 2, \"\");\n"
          "_Static_assert(__builtin_stdc_rotate_right((U)1, 1) == (U)1 << 199 && __builtin_stdc_rotate_left((U)3, (_BitInt(300))-1) == ((U)1 << 199 | 1), \"\");\n"
          "_Static_assert(__builtin_stdc_rotate_left((unsigned)1, (_BitInt(300))33) == 2, \"\");\n"
          "_Static_assert(__builtin_stdc_bit_floor((U)1 << 170 | 5) == (U)1 << 170 && __builtin_stdc_bit_ceil((U)1 << 170 | 5) == (U)1 << 171, \"\");\n"
          "_Static_assert(__builtin_stdc_bit_ceil((U)1 << 199 | 1) == 0 && __builtin_stdc_bit_ceil((U)0) == 1 && __builtin_stdc_bit_ceil((U)1 << 150) == (U)1 << 150, \"\");\n"
          "_Static_assert(__builtin_stdc_bit_width((U)1 << 150) == 151 && __builtin_stdc_has_single_bit((U)1 << 150), \"\");\n"
          "_Static_assert(__builtin_stdc_leading_ones(~(U)0 >> 3 ^ ~(U)0) == 3 && __builtin_stdc_trailing_ones((U)0x7f) == 7, \"\");\n"
          "_Static_assert(__builtin_stdc_first_leading_zero(~(U)0 >> 3 ^ ~(U)0) == 4 && __builtin_stdc_first_trailing_one((U)1 << 150) == 151, \"\");\n"
          "_Static_assert(__builtin_stdc_count_zeros((U)7) == 197 && __builtin_stdc_first_leading_one((U)0) == 0, \"\");\n"
          "int a[__builtin_popcountg((V)-1)];\nstatic U s = __builtin_bitreverseg((U)0xf0);\n" },
        { .name = "bits: clzg of a zero past 128 bits without a fallback is no constant", .standard = 2023,
          .source = "int z =\n__builtin_clzg((unsigned _BitInt(200))0);\n", .rejected = true },
        { .name = "bits: folds through const objects (#990)", .source =
          "static const unsigned ku=7u;\n"
          "static const unsigned _BitInt(37) kw=37;\n"
          "static const unsigned _BitInt(16) kw16=0x1234;\n"
          "static const unsigned short ks=0x1234;\n"
          "static const unsigned char kc=0xf0;\n"
          "_Static_assert(__builtin_popcountg(ku)==3 && __builtin_clzg(ku,99)==29 && __builtin_ctzg(ku,99)==0, \"\");\n"
          "_Static_assert(__builtin_bswapg(ks)==0x3412 && __builtin_bitreverseg((unsigned char)ku)==0xe0, \"\");\n"
          "_Static_assert(__builtin_stdc_count_ones(ku)==3 && __builtin_stdc_bit_width(ku)==3 && __builtin_stdc_bit_ceil(ku)==8, \"\");\n"
          "_Static_assert(__builtin_popcountg(kw)==3 && __builtin_bswapg(kw16)==0x3412 && __builtin_stdc_rotate_left(kc,4)==0x0f, \"\");\n"
          "static int gs = __builtin_popcountg(ku);\n"
          "int ga[__builtin_popcountg(ku)];\n"
          "enum { GE=__builtin_stdc_bit_floor(ku) };\n"
          "struct GF { unsigned field:__builtin_stdc_bit_width(ku); };\n"
          "unsigned f(unsigned n) { switch (n) { case __builtin_stdc_count_ones(ku): return gs; } return 0; }\n" },
        { .name = "bits: fold of a volatile object is no constant", .source =
          "static const volatile unsigned kv=7u;\n"
          "int gv[__builtin_popcountg(kv)];\n", .rejected = true },
        { .name = "bits: fold of a mutable object is no constant", .source =
          "static unsigned kn=7u;\n"
          "_Static_assert(__builtin_clzg(kn,0)==29, \"\");\n", .rejected = true },
        { .name = "bits: clzg of zero without a fallback is no constant", .source = "int z =\n__builtin_clzg(0u);\n", .rejected = true },
        { .name = "bits: popcountg of an int", .source = "int f(int i)\n{\nreturn __builtin_popcountg(i);\n}\n", .rejected = true },
        { .name = "bits: popcountg of plain char where it is signed", .source = "int f(char c)\n{\nreturn __builtin_popcountg(c);\n}\n", .rejected = true },
        { .name = "bits: popcountg of plain char where it is unsigned", .source = "int f(char c)\n{\nreturn __builtin_popcountg(c);\n}\n", .char_unsigned = true },
        { .name = "bits: a stdc builtin of a bool", .source = "unsigned f(_Bool b)\n{\nreturn __builtin_stdc_count_ones(b);\n}\n", .rejected = true },
        { .name = "bits: a stdc builtin of an enumeration", .source = "enum U { UA = 1 };\nunsigned f(enum U e)\n{\nreturn __builtin_stdc_leading_zeros(e);\n}\n",
          .rejected = true },
        { .name = "bits: clzg's fallback of a long", .source = "int f(unsigned u, long l)\n{\nreturn __builtin_clzg(u, l);\n}\n", .rejected = true },
        { .name = "bits: ctzg's fallback of an unsigned int", .source = "int f(unsigned u, unsigned v)\n{\nreturn __builtin_ctzg(u, v);\n}\n", .rejected = true },
        { .name = "bits: clzg's fallback of a 31-bit unsigned bit-field", .source = "struct B { unsigned x : 31; };\nint f(unsigned u, struct B b)\n{\nreturn __builtin_clzg(u, b.x);\n}\n" },
        { .name = "bits: clzg's fallback of a 32-bit unsigned bit-field", .source = "struct B { unsigned x : 32; };\nint f(unsigned u, struct B b)\n{\nreturn __builtin_clzg(u, b.x);\n}\n",
          .rejected = true },
        { .name = "bits: clzg's fallback of an enumeration of int", .source = "enum S { SA = -1 };\nint f(unsigned u, enum S e)\n{\nreturn __builtin_clzg(u, e);\n}\n" },
        { .name = "bits: a rotation of an int", .source = "unsigned f(int u)\n{\nreturn __builtin_stdc_rotate_left(u, 1);\n}\n", .rejected = true },
        { .name = "bits: a rotation by a float", .source = "unsigned f(unsigned u, float c)\n{\nreturn __builtin_stdc_rotate_right(u, c);\n}\n", .rejected = true },
        { .name = "bits: bswapg of a 24-bit _BitInt", .source = "_BitInt(24) f(_BitInt(24) x)\n{\nreturn __builtin_bswapg(x);\n}\n", .rejected = true },
        { .name = "bits: bitreverseg of a float", .source = "float f(float x)\n{\nreturn __builtin_bitreverseg(x);\n}\n", .rejected = true },
        { .name = "bits: a carry of the other signedness", .source = "unsigned f(unsigned u, int *q)\n{\nreturn __builtin_addc(u, u, 0, q);\n}\n" },
        { .name = "bits: a carry of a const pointee", .source = "unsigned f(unsigned u, const unsigned *p)\n{\nreturn __builtin_subc(u, u, 1, p);\n}\n" },
        { .name = "bits: a carry of another width", .source = "unsigned f(unsigned u, unsigned long *p)\n{\nreturn __builtin_addc(u, u, 0, p);\n}\n", .rejected = true },
        { .name = "bits: a carry of an int", .source = "unsigned f(unsigned u, int x)\n{\nreturn __builtin_addc(u, u, 0, x);\n}\n", .rejected = true },
        { .name = "bits: a carry chain of three arguments", .source = "unsigned f(unsigned u)\n{\nreturn __builtin_addcl(u, u, 0);\n}\n", .rejected = true },
        { .name = "bits: bitreverse32 of a pointer", .source = "unsigned f(int *p)\n{\nreturn __builtin_bitreverse32(p);\n}\n", .rejected = true },
        { .name = "bits: bitreverse32 of a double", .source = "unsigned f(double d)\n{\nreturn __builtin_bitreverse32(d);\n}\n" },
        { .name = "bits: clzg of three arguments", .source = "int f(unsigned u)\n{\nreturn __builtin_clzg(u, 1, 2);\n}\n", .rejected = true },
    };
assert(sizeof("bits: clzg's fallback of a 32-bit unsigned bit-field")-1==strlen("bits: clzg's fallback of a 32-bit unsigned bit-field"));
assert(sizeof("bits: fold of a volatile object is no constant")-1==strlen("bits: fold of a volatile object is no constant"));
assert(sizeof("unsigned f(_Bool b)\n{\nreturn __builtin_stdc_count_ones(b);\n}\n")-1==strlen("unsigned f(_Bool b)\n{\nreturn __builtin_stdc_count_ones(b);\n}\n"));
assert(sizeof("bits: clzg's fallback of an enumeration of int")-1==strlen("bits: clzg's fallback of an enumeration of int"));
assert(sizeof("unsigned f(unsigned u, float c)\n{\nreturn __builtin_stdc_rotate_right(u, c);\n}\n")-1==strlen("unsigned f(unsigned u, float c)\n{\nreturn __builtin_stdc_rotate_right(u, c);\n}\n"));
assert(sizeof("_Static_assert(__builtin_popcountg(ku)==3 && __builtin_clzg(ku,99)==29 && __builtin_ctzg(ku,99)==0, \"\");\n")-1==strlen("_Static_assert(__builtin_popcountg(ku)==3 && __builtin_clzg(ku,99)==29 && __builtin_ctzg(ku,99)==0, \"\");\n"));
assert(sizeof("T(__builtin_popcountg(b), int) T(__builtin_popcountg(e), int) T(__builtin_clzg(w, (short)1), int) T(__builtin_ctzg(r.x, r.z), int)\n")-1==strlen("T(__builtin_popcountg(b), int) T(__builtin_popcountg(e), int) T(__builtin_clzg(w, (short)1), int) T(__builtin_ctzg(r.x, r.z), int)\n"));
assert(sizeof("static const volatile unsigned kv=7u;\n")-1==strlen("static const volatile unsigned kv=7u;\n"));
assert(sizeof("_Static_assert(__builtin_clzg(kn,0)==29, \"\");\n")-1==strlen("_Static_assert(__builtin_clzg(kn,0)==29, \"\");\n"));
assert(sizeof("_Static_assert(__builtin_bswapg(ks)==0x3412 && __builtin_bitreverseg((unsigned char)ku)==0xe0, \"\");\n")-1==strlen("_Static_assert(__builtin_bswapg(ks)==0x3412 && __builtin_bitreverseg((unsigned char)ku)==0xe0, \"\");\n"));
assert(sizeof("bits: popcountg of plain char where it is unsigned")-1==strlen("bits: popcountg of plain char where it is unsigned"));
assert(sizeof("bits: a carry chain of three arguments")-1==strlen("bits: a carry chain of three arguments"));
assert(sizeof("}\n")-1==strlen("}\n"));
assert(sizeof("bits: a carry of another width")-1==strlen("bits: a carry of another width"));
assert(sizeof("bits: bswapg of a 24-bit _BitInt")-1==strlen("bits: bswapg of a 24-bit _BitInt"));
assert(sizeof("bits: clzg's fallback of a 31-bit unsigned bit-field")-1==strlen("bits: clzg's fallback of a 31-bit unsigned bit-field"));
assert(sizeof("enum U { UA = 1 };\n")-1==strlen("enum U { UA = 1 };\n"));
assert(sizeof("bits: bitreverse32 of a pointer")-1==strlen("bits: bitreverse32 of a pointer"));
assert(sizeof("bits: folds through const objects (#990)")-1==strlen("bits: folds through const objects (#990)"));
assert(sizeof("struct B { unsigned x : 3; int z : 5; };\n")-1==strlen("struct B { unsigned x : 3; int z : 5; };\n"));
assert(sizeof("static const unsigned char kc=0xf0;\n")-1==strlen("static const unsigned char kc=0xf0;\n"));
assert(sizeof("int gv[__builtin_popcountg(kv)];\n")-1==strlen("int gv[__builtin_popcountg(kv)];\n"));
assert(sizeof("bits: bitreverseg of a float")-1==strlen("bits: bitreverseg of a float"));
assert(sizeof("int f(unsigned u)\n{\nreturn __builtin_clzg(u, 1, 2);\n}\n")-1==strlen("int f(unsigned u)\n{\nreturn __builtin_clzg(u, 1, 2);\n}\n"));
assert(sizeof("T(__builtin_bitreverseg(v), _BitInt(48)) T(__builtin_bitreverseg(k), unsigned int) T(__builtin_bswapg(e), enum U) T(__builtin_bitreverseg(r.z), int)\n")-1==strlen("T(__builtin_bitreverseg(v), _BitInt(48)) T(__builtin_bitreverseg(k), unsigned int) T(__builtin_bswapg(e), enum U) T(__builtin_bitreverseg(r.z), int)\n"));
assert(sizeof("static const unsigned _BitInt(16) kw16=0x1234;\n")-1==strlen("static const unsigned _BitInt(16) kw16=0x1234;\n"));
assert(sizeof("bits: popcountg of plain char where it is signed")-1==strlen("bits: popcountg of plain char where it is signed"));
assert(sizeof("_Static_assert(__builtin_stdc_bit_floor((U)1 << 170 | 5) == (U)1 << 170 && __builtin_stdc_bit_ceil((U)1 << 170 | 5) == (U)1 << 171, \"\");\n")-1==strlen("_Static_assert(__builtin_stdc_bit_floor((U)1 << 170 | 5) == (U)1 << 170 && __builtin_stdc_bit_ceil((U)1 << 170 | 5) == (U)1 << 171, \"\");\n"));
assert(sizeof("struct B { unsigned x : 31; };\nint f(unsigned u, struct B b)\n{\nreturn __builtin_clzg(u, b.x);\n}\n")-1==strlen("struct B { unsigned x : 31; };\nint f(unsigned u, struct B b)\n{\nreturn __builtin_clzg(u, b.x);\n}\n"));
assert(sizeof("T(__builtin_stdc_leading_zeros(c), unsigned int) T(__builtin_stdc_has_single_bit(w), _Bool) T(__builtin_stdc_bit_floor(s), unsigned short)\n")-1==strlen("T(__builtin_stdc_leading_zeros(c), unsigned int) T(__builtin_stdc_has_single_bit(w), _Bool) T(__builtin_stdc_bit_floor(s), unsigned short)\n"));
assert(sizeof("T(__builtin_bitreverse8(c), unsigned char) T(__builtin_bitreverse64(1), unsigned long) T(__builtin_clrsbl(1), int) T(__builtin_ctzs(s), int)\n")-1==strlen("T(__builtin_bitreverse8(c), unsigned char) T(__builtin_bitreverse64(1), unsigned long) T(__builtin_clrsbl(1), int) T(__builtin_ctzs(s), int)\n"));
assert(sizeof("bits: ctzg's fallback of an unsigned int")-1==strlen("bits: ctzg's fallback of an unsigned int"));
assert(sizeof("int f(int i)\n{\nreturn __builtin_popcountg(i);\n}\n")-1==strlen("int f(int i)\n{\nreturn __builtin_popcountg(i);\n}\n"));
assert(sizeof("bits: clzg of zero without a fallback is no constant")-1==strlen("bits: clzg of zero without a fallback is no constant"));
assert(sizeof("static int s = __builtin_stdc_count_zeros((unsigned short)0x0f0f) + __builtin_ctzg(0u, 9);\n")-1==strlen("static int s = __builtin_stdc_count_zeros((unsigned short)0x0f0f) + __builtin_ctzg(0u, 9);\n"));
assert(sizeof("static unsigned kn=7u;\n")-1==strlen("static unsigned kn=7u;\n"));
assert(sizeof("static const unsigned _BitInt(37) kw=37;\n")-1==strlen("static const unsigned _BitInt(37) kw=37;\n"));
assert(sizeof("unsigned f(int *p)\n{\nreturn __builtin_bitreverse32(p);\n}\n")-1==strlen("unsigned f(int *p)\n{\nreturn __builtin_bitreverse32(p);\n}\n"));
assert(sizeof("bits: a stdc builtin of a bool")-1==strlen("bits: a stdc builtin of a bool"));
assert(sizeof("int ga[__builtin_popcountg(ku)];\n")-1==strlen("int ga[__builtin_popcountg(ku)];\n"));
assert(sizeof("T(__builtin_addcb(c, c, c, &c), unsigned char) T(__builtin_subcll(1, 2, 0, (unsigned long long *)0), unsigned long long)\n")-1==strlen("T(__builtin_addcb(c, c, c, &c), unsigned char) T(__builtin_subcll(1, 2, 0, (unsigned long long *)0), unsigned long long)\n"));
assert(sizeof("_Static_assert(__builtin_bswapg((V)0xff) == (V)0xff << 248 && __builtin_stdc_rotate_left((U)1, 201) == 2, \"\");\n")-1==strlen("_Static_assert(__builtin_bswapg((V)0xff) == (V)0xff << 248 && __builtin_stdc_rotate_left((U)1, 201) == 2, \"\");\n"));
assert(sizeof("unsigned f(unsigned u)\n{\nreturn __builtin_addcl(u, u, 0);\n}\n")-1==strlen("unsigned f(unsigned u)\n{\nreturn __builtin_addcl(u, u, 0);\n}\n"));
assert(sizeof("_Static_assert(__builtin_stdc_leading_ones(~(U)0 >> 3 ^ ~(U)0) == 3 && __builtin_stdc_trailing_ones((U)0x7f) == 7, \"\");\n")-1==strlen("_Static_assert(__builtin_stdc_leading_ones(~(U)0 >> 3 ^ ~(U)0) == 3 && __builtin_stdc_trailing_ones((U)0x7f) == 7, \"\");\n"));
assert(sizeof("bits: fold of a mutable object is no constant")-1==strlen("bits: fold of a mutable object is no constant"));
assert(sizeof("bits: a rotation of an int")-1==strlen("bits: a rotation of an int"));
assert(sizeof("_Static_assert(__builtin_stdc_first_leading_zero((unsigned char)0xff) == 0 && __builtin_stdc_leading_ones((unsigned char)0xf0) == 4, \"\");\n")-1==strlen("_Static_assert(__builtin_stdc_first_leading_zero((unsigned char)0xff) == 0 && __builtin_stdc_leading_ones((unsigned char)0xf0) == 4, \"\");\n"));
assert(sizeof("unsigned f(unsigned u, const unsigned *p)\n{\nreturn __builtin_subc(u, u, 1, p);\n}\n")-1==strlen("unsigned f(unsigned u, const unsigned *p)\n{\nreturn __builtin_subc(u, u, 1, p);\n}\n"));
assert(sizeof("_Static_assert(__builtin_bswapg((unsigned short)0x1234) == 0x3412 && __builtin_bitreverseg((signed char)1) == -128, \"\");\n")-1==strlen("_Static_assert(__builtin_bswapg((unsigned short)0x1234) == 0x3412 && __builtin_bitreverseg((signed char)1) == -128, \"\");\n"));
assert(sizeof("int f(unsigned u, long l)\n{\nreturn __builtin_clzg(u, l);\n}\n")-1==strlen("int f(unsigned u, long l)\n{\nreturn __builtin_clzg(u, l);\n}\n"));
assert(sizeof("bits: a carry of the other signedness")-1==strlen("bits: a carry of the other signedness"));
assert(sizeof("static int gs = __builtin_popcountg(ku);\n")-1==strlen("static int gs = __builtin_popcountg(ku);\n"));
assert(sizeof("_Static_assert(__builtin_stdc_first_leading_zero(~(U)0 >> 3 ^ ~(U)0) == 4 && __builtin_stdc_first_trailing_one((U)1 << 150) == 151, \"\");\n")-1==strlen("_Static_assert(__builtin_stdc_first_leading_zero(~(U)0 >> 3 ^ ~(U)0) == 4 && __builtin_stdc_first_trailing_one((U)1 << 150) == 151, \"\");\n"));
assert(sizeof("unsigned f(unsigned n) { switch (n) { case __builtin_stdc_count_ones(ku): return gs; } return 0; }\n")-1==strlen("unsigned f(unsigned n) { switch (n) { case __builtin_stdc_count_ones(ku): return gs; } return 0; }\n"));
assert(sizeof("typedef unsigned _BitInt(200) U;\ntypedef unsigned _BitInt(256) V;\n")-1==strlen("typedef unsigned _BitInt(200) U;\ntypedef unsigned _BitInt(256) V;\n"));
assert(sizeof("_Static_assert(__builtin_stdc_count_ones(ku)==3 && __builtin_stdc_bit_width(ku)==3 && __builtin_stdc_bit_ceil(ku)==8, \"\");\n")-1==strlen("_Static_assert(__builtin_stdc_count_ones(ku)==3 && __builtin_stdc_bit_width(ku)==3 && __builtin_stdc_bit_ceil(ku)==8, \"\");\n"));
assert(sizeof("bits: popcountg of an int")-1==strlen("bits: popcountg of an int"));
assert(sizeof("float f(float x)\n{\nreturn __builtin_bitreverseg(x);\n}\n")-1==strlen("float f(float x)\n{\nreturn __builtin_bitreverseg(x);\n}\n"));
assert(sizeof("enum U { UA = 1 };\nunsigned f(enum U e)\n{\nreturn __builtin_stdc_leading_zeros(e);\n}\n")-1==strlen("enum U { UA = 1 };\nunsigned f(enum U e)\n{\nreturn __builtin_stdc_leading_zeros(e);\n}\n"));
assert(sizeof("unsigned f(unsigned u, int x)\n{\nreturn __builtin_addc(u, u, 0, x);\n}\n")-1==strlen("unsigned f(unsigned u, int x)\n{\nreturn __builtin_addc(u, u, 0, x);\n}\n"));
assert(sizeof("_Static_assert(__builtin_popcountg((unsigned __int128)-1) == 128 && __builtin_clzg((unsigned _BitInt(100))1) == 99, \"\");\n")-1==strlen("_Static_assert(__builtin_popcountg((unsigned __int128)-1) == 128 && __builtin_clzg((unsigned _BitInt(100))1) == 99, \"\");\n"));
assert(sizeof("int a[__builtin_popcountg((V)-1)];\nstatic U s = __builtin_bitreverseg((U)0xf0);\n")-1==strlen("int a[__builtin_popcountg((V)-1)];\nstatic U s = __builtin_bitreverseg((U)0xf0);\n"));
assert(sizeof("unsigned f(unsigned u, unsigned long *p)\n{\nreturn __builtin_addc(u, u, 0, p);\n}\n")-1==strlen("unsigned f(unsigned u, unsigned long *p)\n{\nreturn __builtin_addc(u, u, 0, p);\n}\n"));
assert(sizeof("bits: bitreverse32 of a double")-1==strlen("bits: bitreverse32 of a double"));
assert(sizeof("unsigned f(double d)\n{\nreturn __builtin_bitreverse32(d);\n}\n")-1==strlen("unsigned f(double d)\n{\nreturn __builtin_bitreverse32(d);\n}\n"));
assert(sizeof("_Static_assert(__builtin_stdc_rotate_right((U)1, 1) == (U)1 << 199 && __builtin_stdc_rotate_left((U)3, (_BitInt(300))-1) == ((U)1 << 199 | 1), \"\");\n")-1==strlen("_Static_assert(__builtin_stdc_rotate_right((U)1, 1) == (U)1 << 199 && __builtin_stdc_rotate_left((U)3, (_BitInt(300))-1) == ((U)1 << 199 | 1), \"\");\n"));
assert(sizeof("static const unsigned ku=7u;\n")-1==strlen("static const unsigned ku=7u;\n"));
assert(sizeof("int a[__builtin_clzs(1)];\n")-1==strlen("int a[__builtin_clzs(1)];\n"));
assert(sizeof("_Static_assert(__builtin_popcountg((U)-1) == 200 && __builtin_clzg((U)1) == 199 && __builtin_ctzg((U)1 << 150) == 150, \"\");\n")-1==strlen("_Static_assert(__builtin_popcountg((U)-1) == 200 && __builtin_clzg((U)1) == 199 && __builtin_ctzg((U)1 << 150) == 150, \"\");\n"));
assert(sizeof("int z =\n__builtin_clzg((unsigned _BitInt(200))0);\n")-1==strlen("int z =\n__builtin_clzg((unsigned _BitInt(200))0);\n"));
assert(sizeof("enum { E1 = __builtin_ctzs(8), E2 = __builtin_stdc_bit_width(5u) };\n")-1==strlen("enum { E1 = __builtin_ctzs(8), E2 = __builtin_stdc_bit_width(5u) };\n"));
assert(sizeof("unsigned f(int u)\n{\nreturn __builtin_stdc_rotate_left(u, 1);\n}\n")-1==strlen("unsigned f(int u)\n{\nreturn __builtin_stdc_rotate_left(u, 1);\n}\n"));
assert(sizeof("bits: a carry of a const pointee")-1==strlen("bits: a carry of a const pointee"));
assert(sizeof("bits: folds in constant contexts")-1==strlen("bits: folds in constant contexts"));
assert(sizeof("static const unsigned short ks=0x1234;\n")-1==strlen("static const unsigned short ks=0x1234;\n"));
assert(sizeof("_Static_assert(__builtin_ctzg((unsigned char)0, -1) == -1 && __builtin_stdc_bit_ceil(0x80000001u) == 0 && __builtin_stdc_bit_ceil(0u) == 1, \"\");\n")-1==strlen("_Static_assert(__builtin_ctzg((unsigned char)0, -1) == -1 && __builtin_stdc_bit_ceil(0x80000001u) == 0 && __builtin_stdc_bit_ceil(0u) == 1, \"\");\n"));
assert(sizeof("_Static_assert(__builtin_popcountg(7u) == 3 && __builtin_clzg(1u, 5) == 31 && __builtin_clzg(0u, 5) == 5, \"\");\n")-1==strlen("_Static_assert(__builtin_popcountg(7u) == 3 && __builtin_clzg(1u, 5) == 31 && __builtin_clzg(0u, 5) == 5, \"\");\n"));
assert(sizeof("_Static_assert(__builtin_bitreverse8(1) == 0x80 && __builtin_clrsb(-1) == 31 && __builtin_clrsbll(0) == 63, \"\");\n")-1==strlen("_Static_assert(__builtin_bitreverse8(1) == 0x80 && __builtin_clrsb(-1) == 31 && __builtin_clrsbll(0) == 63, \"\");\n"));
assert(sizeof("{\n")-1==strlen("{\n"));
assert(sizeof("bits: a stdc builtin of an enumeration")-1==strlen("bits: a stdc builtin of an enumeration"));
assert(sizeof("bits: folds past 128 bits")-1==strlen("bits: folds past 128 bits"));
assert(sizeof("bits: a rotation by a float")-1==strlen("bits: a rotation by a float"));
assert(sizeof("_Static_assert(__builtin_stdc_rotate_left((unsigned char)1, -1) == 0x80 && __builtin_stdc_rotate_right(1u, 33) == 0x80000000u, \"\");\n")-1==strlen("_Static_assert(__builtin_stdc_rotate_left((unsigned char)1, -1) == 0x80 && __builtin_stdc_rotate_right(1u, 33) == 0x80000000u, \"\");\n"));
assert(sizeof("_Static_assert(__builtin_popcountg(kw)==3 && __builtin_bswapg(kw16)==0x3412 && __builtin_stdc_rotate_left(kc,4)==0x0f, \"\");\n")-1==strlen("_Static_assert(__builtin_popcountg(kw)==3 && __builtin_bswapg(kw16)==0x3412 && __builtin_stdc_rotate_left(kc,4)==0x0f, \"\");\n"));
assert(sizeof("bits: a carry of an int")-1==strlen("bits: a carry of an int"));
assert(sizeof("_Static_assert(__builtin_stdc_count_zeros((U)7) == 197 && __builtin_stdc_first_leading_one((U)0) == 0, \"\");\n")-1==strlen("_Static_assert(__builtin_stdc_count_zeros((U)7) == 197 && __builtin_stdc_first_leading_one((U)0) == 0, \"\");\n"));
assert(sizeof("_BitInt(24) f(_BitInt(24) x)\n{\nreturn __builtin_bswapg(x);\n}\n")-1==strlen("_BitInt(24) f(_BitInt(24) x)\n{\nreturn __builtin_bswapg(x);\n}\n"));
assert(sizeof("unsigned f(unsigned u, int *q)\n{\nreturn __builtin_addc(u, u, 0, q);\n}\n")-1==strlen("unsigned f(unsigned u, int *q)\n{\nreturn __builtin_addc(u, u, 0, q);\n}\n"));
assert(sizeof("enum S { SA = -1 };\nint f(unsigned u, enum S e)\n{\nreturn __builtin_clzg(u, e);\n}\n")-1==strlen("enum S { SA = -1 };\nint f(unsigned u, enum S e)\n{\nreturn __builtin_clzg(u, e);\n}\n"));
assert(sizeof("T(__builtin_stdc_bit_ceil(w), unsigned _BitInt(37)) T(__builtin_stdc_rotate_left(b, -1), _Bool) T(__builtin_stdc_rotate_right(e, v), enum U)\n")-1==strlen("T(__builtin_stdc_bit_ceil(w), unsigned _BitInt(37)) T(__builtin_stdc_rotate_left(b, -1), _Bool) T(__builtin_stdc_rotate_right(e, v), enum U)\n"));
assert(sizeof("enum { GE=__builtin_stdc_bit_floor(ku) };\n")-1==strlen("enum { GE=__builtin_stdc_bit_floor(ku) };\n"));
assert(sizeof("struct B { unsigned x : 32; };\nint f(unsigned u, struct B b)\n{\nreturn __builtin_clzg(u, b.x);\n}\n")-1==strlen("struct B { unsigned x : 32; };\nint f(unsigned u, struct B b)\n{\nreturn __builtin_clzg(u, b.x);\n}\n"));
assert(sizeof("int f(unsigned u, unsigned v)\n{\nreturn __builtin_ctzg(u, v);\n}\n")-1==strlen("int f(unsigned u, unsigned v)\n{\nreturn __builtin_ctzg(u, v);\n}\n"));
assert(sizeof("bits: clzg of a zero past 128 bits without a fallback is no constant")-1==strlen("bits: clzg of a zero past 128 bits without a fallback is no constant"));
assert(sizeof("int z =\n__builtin_clzg(0u);\n")-1==strlen("int z =\n__builtin_clzg(0u);\n"));
assert(sizeof("bits: clzg of three arguments")-1==strlen("bits: clzg of three arguments"));
assert(sizeof("_Static_assert(__builtin_stdc_rotate_left((unsigned)1, (_BitInt(300))33) == 2, \"\");\n")-1==strlen("_Static_assert(__builtin_stdc_rotate_left((unsigned)1, (_BitInt(300))33) == 2, \"\");\n"));
assert(sizeof("_Static_assert(__builtin_clzg((U)0, 7) == 7 && __builtin_ctzg((U)0, -1) == -1 && __builtin_bitreverseg((U)1) == (U)1 << 199, \"\");\n")-1==strlen("_Static_assert(__builtin_clzg((U)0, 7) == 7 && __builtin_ctzg((U)0, -1) == -1 && __builtin_bitreverseg((U)1) == (U)1 << 199, \"\");\n"));
assert(sizeof("void f(unsigned char c, unsigned short s, _Bool b, enum U e, unsigned _BitInt(37) w, _BitInt(48) v, const unsigned k, struct B r)\n")-1==strlen("void f(unsigned char c, unsigned short s, _Bool b, enum U e, unsigned _BitInt(37) w, _BitInt(48) v, const unsigned k, struct B r)\n"));
assert(sizeof("#define T(e, t) _Static_assert(_Generic((e), t: 1, default: 0), #e);\n")-1==strlen("#define T(e, t) _Static_assert(_Generic((e), t: 1, default: 0), #e);\n"));
assert(sizeof("_Static_assert(__builtin_stdc_bit_ceil((U)1 << 199 | 1) == 0 && __builtin_stdc_bit_ceil((U)0) == 1 && __builtin_stdc_bit_ceil((U)1 << 150) == (U)1 << 150, \"\");\n")-1==strlen("_Static_assert(__builtin_stdc_bit_ceil((U)1 << 199 | 1) == 0 && __builtin_stdc_bit_ceil((U)0) == 1 && __builtin_stdc_bit_ceil((U)1 << 150) == (U)1 << 150, \"\");\n"));
assert(sizeof("_Static_assert(__builtin_stdc_bit_width((U)1 << 150) == 151 && __builtin_stdc_has_single_bit((U)1 << 150), \"\");\n")-1==strlen("_Static_assert(__builtin_stdc_bit_width((U)1 << 150) == 151 && __builtin_stdc_has_single_bit((U)1 << 150), \"\");\n"));
assert(sizeof("bits: clzg's fallback of a long")-1==strlen("bits: clzg's fallback of a long"));
assert(sizeof("int f(char c)\n{\nreturn __builtin_popcountg(c);\n}\n")-1==strlen("int f(char c)\n{\nreturn __builtin_popcountg(c);\n}\n"));
assert(sizeof("struct GF { unsigned field:__builtin_stdc_bit_width(ku); };\n")-1==strlen("struct GF { unsigned field:__builtin_stdc_bit_width(ku); };\n"));
assert(sizeof("bits: result types")-1==strlen("bits: result types"));
for(size_t i=0;i<sizeof rows/sizeof *rows;i++){const CheckSourceFixture*r=rows+i;put(r->name);put(r->source);uint32_t f[]={r->rejected,r->unsupported,r->extension,r->standard,r->char_unsigned,r->undecided,r->overload_tables};assert(!r->capacity);assert(fwrite(f,4,7,stdout)==7);}}
{ const CheckSourceFixture rows[]={
        {
            .name = "scalar compound literal in a typeof declaration",
            .source = "int f(void) { __typeof__((int){0}) x = 1; return x; }\n",
        },
        {
            .name = "file-scope scalar compound literal in typeof",
            .source = "__typeof__((int){1}) x; _Static_assert(sizeof x == sizeof(int), \"scalar\");\n",
        },
        {
            .name = "record compound literal in a typeof declaration",
            .source = "struct S { int x; }; int f(void) { __typeof__((struct S){0}) s = {1}; return s.x; }\n",
        },
        {
            .name = "array compound literal keeps its array type",
            .source = "int f(void) { __typeof__((int[2]){0}) a = {1}; _Static_assert(sizeof a == 2 * sizeof(int), \"array\"); return a[0]; }\n",
        },
        {
            .name = "inferred compound array bound is complete before typeof resumes",
            .source = "int f(void) { __typeof__((int[]){1,2,3}) a = {1}; _Static_assert(sizeof a == 3 * sizeof(int), \"bound\"); return a[0]; }\n",
        },
        {
            .name = "designated compound array bound is complete before typeof resumes",
            .source = "int f(void) { __typeof__((int[]){[3]=1}) a = {1}; _Static_assert(sizeof a == 4 * sizeof(int), \"designated bound\"); return a[0]; }\n",
        },
        {
            .name = "vector compound literal preserves its typedef type",
            .source = "typedef float V __attribute__((vector_size(16))); __typeof__((V){0}) v; _Static_assert(__builtin_types_compatible_p(__typeof__(v), V), \"vector\");\n",
        },
        {
            .name = "member of a compound literal supplies its own type",
            .source = "struct S { long x; }; int f(void) { __typeof__(((struct S){0}).x) x = 0; _Static_assert(sizeof x == sizeof(long), \"member\"); return x; }\n",
        },
        {
            .name = "multiple compound literals participate in operand conversions",
            .source = "int f(void) { __typeof__((int){0} + (long){1}) x = 1; _Static_assert(sizeof x == sizeof(long), \"conversion\"); return x; }\n",
        },
        {
            .name = "typeof retains compound literal const qualification",
            .source = "int f(void) { __typeof__((const int){0}) x = 1;\n x = 2; return x; }\n",
            .rejected = true,
        },
        {
            .name = "typeof does not decay a compound array into an assignable pointer",
            .source = "int f(void) { __typeof__((int[2]){0}) a = {1}; int *p = 0;\n a = p; return 0; }\n",
            .rejected = true,
        },
        {
            .name = "typeof still checks scalar compound designators",
            .source = "int f(void) {\n __typeof__((int){.x=1}) x = 0; return x; }\n",
            .rejected = true,
        },
        {
            .name = "typeof still checks out-of-bounds compound designators",
            .source = "int f(void) {\n __typeof__((int[2]){[3]=1}) a = {0}; return a[0]; }\n",
            .rejected = true,
        },
        {
            .name = "typeof still checks record compound designators",
            .source = "struct S { int x; }; int f(void) {\n __typeof__((struct S){.y=1}) s = {0}; return s.x; }\n",
            .rejected = true,
        },
        {
            .name = "typeof still binds compound initializer operands",
            .source = "int f(void) {\n __typeof__((int){missing}) x = 0; return x; }\n",
            .rejected = true,
        },
        {
            .name = "typeof rejects a compound literal bit-field operand",
            .source = "struct S { int x:1; }; int f(void) {\n __typeof__(((struct S){0}).x) x = 0; return x; }\n",
            .rejected = true,
        },
        {
            .name = "C23 typeof accepts compound arrays",
            .source = "int f(void) { typeof((int[2]){0}) a = {1}; _Static_assert(sizeof a == 2 * sizeof(int), \"C23 array\"); return a[0]; }\n",
            .standard = 2023,
        },
        {
            .name = "C23 typeof_unqual removes compound scalar const",
            .source = "int f(void) { typeof_unqual((const int){0}) x = 1; x = 2; return x; }\n",
            .standard = 2023,
        },
        {
            .name = "C23 typeof retains compound scalar const",
            .source = "int f(void) { typeof((const int){0}) x = 1;\n x = 2; return x; }\n",
            .rejected = true,
            .standard = 2023,
        },
        {
            .name = "C23 typeof_unqual also rejects a compound bit-field operand",
            .source = "struct S { int x:1; }; int f(void) {\n typeof_unqual(((struct S){0}).x) x = 0; return x; }\n",
            .rejected = true,
            .standard = 2023,
        },
    };
assert(sizeof("array compound literal keeps its array type")-1==strlen("array compound literal keeps its array type"));
assert(sizeof("typeof retains compound literal const qualification")-1==strlen("typeof retains compound literal const qualification"));
assert(sizeof("__typeof__((int){1}) x; _Static_assert(sizeof x == sizeof(int), \"scalar\");\n")-1==strlen("__typeof__((int){1}) x; _Static_assert(sizeof x == sizeof(int), \"scalar\");\n"));
assert(sizeof("int f(void) { typeof((int[2]){0}) a = {1}; _Static_assert(sizeof a == 2 * sizeof(int), \"C23 array\"); return a[0]; }\n")-1==strlen("int f(void) { typeof((int[2]){0}) a = {1}; _Static_assert(sizeof a == 2 * sizeof(int), \"C23 array\"); return a[0]; }\n"));
assert(sizeof("int f(void) { __typeof__((int[]){1,2,3}) a = {1}; _Static_assert(sizeof a == 3 * sizeof(int), \"bound\"); return a[0]; }\n")-1==strlen("int f(void) { __typeof__((int[]){1,2,3}) a = {1}; _Static_assert(sizeof a == 3 * sizeof(int), \"bound\"); return a[0]; }\n"));
assert(sizeof("int f(void) { __typeof__((int[2]){0}) a = {1}; int *p = 0;\n a = p; return 0; }\n")-1==strlen("int f(void) { __typeof__((int[2]){0}) a = {1}; int *p = 0;\n a = p; return 0; }\n"));
assert(sizeof("typeof still binds compound initializer operands")-1==strlen("typeof still binds compound initializer operands"));
assert(sizeof("struct S { int x; }; int f(void) { __typeof__((struct S){0}) s = {1}; return s.x; }\n")-1==strlen("struct S { int x; }; int f(void) { __typeof__((struct S){0}) s = {1}; return s.x; }\n"));
assert(sizeof("struct S { int x; }; int f(void) {\n __typeof__((struct S){.y=1}) s = {0}; return s.x; }\n")-1==strlen("struct S { int x; }; int f(void) {\n __typeof__((struct S){.y=1}) s = {0}; return s.x; }\n"));
assert(sizeof("struct S { int x:1; }; int f(void) {\n __typeof__(((struct S){0}).x) x = 0; return x; }\n")-1==strlen("struct S { int x:1; }; int f(void) {\n __typeof__(((struct S){0}).x) x = 0; return x; }\n"));
assert(sizeof("struct S { int x:1; }; int f(void) {\n typeof_unqual(((struct S){0}).x) x = 0; return x; }\n")-1==strlen("struct S { int x:1; }; int f(void) {\n typeof_unqual(((struct S){0}).x) x = 0; return x; }\n"));
assert(sizeof("int f(void) {\n __typeof__((int){missing}) x = 0; return x; }\n")-1==strlen("int f(void) {\n __typeof__((int){missing}) x = 0; return x; }\n"));
assert(sizeof("C23 typeof accepts compound arrays")-1==strlen("C23 typeof accepts compound arrays"));
assert(sizeof("int f(void) { typeof((const int){0}) x = 1;\n x = 2; return x; }\n")-1==strlen("int f(void) { typeof((const int){0}) x = 1;\n x = 2; return x; }\n"));
assert(sizeof("member of a compound literal supplies its own type")-1==strlen("member of a compound literal supplies its own type"));
assert(sizeof("typeof still checks record compound designators")-1==strlen("typeof still checks record compound designators"));
assert(sizeof("file-scope scalar compound literal in typeof")-1==strlen("file-scope scalar compound literal in typeof"));
assert(sizeof("designated compound array bound is complete before typeof resumes")-1==strlen("designated compound array bound is complete before typeof resumes"));
assert(sizeof("int f(void) { __typeof__((int){0}) x = 1; return x; }\n")-1==strlen("int f(void) { __typeof__((int){0}) x = 1; return x; }\n"));
assert(sizeof("scalar compound literal in a typeof declaration")-1==strlen("scalar compound literal in a typeof declaration"));
assert(sizeof("inferred compound array bound is complete before typeof resumes")-1==strlen("inferred compound array bound is complete before typeof resumes"));
assert(sizeof("int f(void) { __typeof__((const int){0}) x = 1;\n x = 2; return x; }\n")-1==strlen("int f(void) { __typeof__((const int){0}) x = 1;\n x = 2; return x; }\n"));
assert(sizeof("C23 typeof_unqual also rejects a compound bit-field operand")-1==strlen("C23 typeof_unqual also rejects a compound bit-field operand"));
assert(sizeof("record compound literal in a typeof declaration")-1==strlen("record compound literal in a typeof declaration"));
assert(sizeof("typeof still checks scalar compound designators")-1==strlen("typeof still checks scalar compound designators"));
assert(sizeof("multiple compound literals participate in operand conversions")-1==strlen("multiple compound literals participate in operand conversions"));
assert(sizeof("typeof still checks out-of-bounds compound designators")-1==strlen("typeof still checks out-of-bounds compound designators"));
assert(sizeof("C23 typeof retains compound scalar const")-1==strlen("C23 typeof retains compound scalar const"));
assert(sizeof("C23 typeof_unqual removes compound scalar const")-1==strlen("C23 typeof_unqual removes compound scalar const"));
assert(sizeof("struct S { long x; }; int f(void) { __typeof__(((struct S){0}).x) x = 0; _Static_assert(sizeof x == sizeof(long), \"member\"); return x; }\n")-1==strlen("struct S { long x; }; int f(void) { __typeof__(((struct S){0}).x) x = 0; _Static_assert(sizeof x == sizeof(long), \"member\"); return x; }\n"));
assert(sizeof("typedef float V __attribute__((vector_size(16))); __typeof__((V){0}) v; _Static_assert(__builtin_types_compatible_p(__typeof__(v), V), \"vector\");\n")-1==strlen("typedef float V __attribute__((vector_size(16))); __typeof__((V){0}) v; _Static_assert(__builtin_types_compatible_p(__typeof__(v), V), \"vector\");\n"));
assert(sizeof("int f(void) { __typeof__((int[2]){0}) a = {1}; _Static_assert(sizeof a == 2 * sizeof(int), \"array\"); return a[0]; }\n")-1==strlen("int f(void) { __typeof__((int[2]){0}) a = {1}; _Static_assert(sizeof a == 2 * sizeof(int), \"array\"); return a[0]; }\n"));
assert(sizeof("int f(void) { __typeof__((int){0} + (long){1}) x = 1; _Static_assert(sizeof x == sizeof(long), \"conversion\"); return x; }\n")-1==strlen("int f(void) { __typeof__((int){0} + (long){1}) x = 1; _Static_assert(sizeof x == sizeof(long), \"conversion\"); return x; }\n"));
assert(sizeof("vector compound literal preserves its typedef type")-1==strlen("vector compound literal preserves its typedef type"));
assert(sizeof("int f(void) { __typeof__((int[]){[3]=1}) a = {1}; _Static_assert(sizeof a == 4 * sizeof(int), \"designated bound\"); return a[0]; }\n")-1==strlen("int f(void) { __typeof__((int[]){[3]=1}) a = {1}; _Static_assert(sizeof a == 4 * sizeof(int), \"designated bound\"); return a[0]; }\n"));
assert(sizeof("int f(void) { typeof_unqual((const int){0}) x = 1; x = 2; return x; }\n")-1==strlen("int f(void) { typeof_unqual((const int){0}) x = 1; x = 2; return x; }\n"));
assert(sizeof("typeof does not decay a compound array into an assignable pointer")-1==strlen("typeof does not decay a compound array into an assignable pointer"));
assert(sizeof("int f(void) {\n __typeof__((int){.x=1}) x = 0; return x; }\n")-1==strlen("int f(void) {\n __typeof__((int){.x=1}) x = 0; return x; }\n"));
assert(sizeof("typeof rejects a compound literal bit-field operand")-1==strlen("typeof rejects a compound literal bit-field operand"));
assert(sizeof("int f(void) {\n __typeof__((int[2]){[3]=1}) a = {0}; return a[0]; }\n")-1==strlen("int f(void) {\n __typeof__((int[2]){[3]=1}) a = {0}; return a[0]; }\n"));
for(size_t i=0;i<sizeof rows/sizeof *rows;i++){const CheckSourceFixture*r=rows+i;put(r->name);put(r->source);uint32_t f[]={r->rejected,r->unsupported,r->extension,r->standard,r->char_unsigned,r->undecided,r->overload_tables};assert(!r->capacity);assert(fwrite(f,4,7,stdout)==7);}}
{ const CheckSourceFixture rows[]={
        {
            .name = "predefined arrays participate in sizeof and typeof queries",
            .source = "int f(void){_Static_assert(sizeof __func__==2,\"func\");_Static_assert(sizeof __FUNCTION__==2,\"function\");_Static_assert(sizeof __PRETTY_FUNCTION__==12,\"pretty\");_Static_assert(__builtin_types_compatible_p(__typeof__(__func__),const char[2]),\"type\");return 0;}\n",
        },
        {
            .name = "pretty alias size is evaluated at declaration position",
            .source = "typedef int I; I f(I x){_Static_assert(sizeof __PRETTY_FUNCTION__==7,\"pretty\");return x;}\n",
        },
        {
            .name = "file scope predefined array lengths",
            .source = "_Static_assert(sizeof __func__==1,\"func\");_Static_assert(sizeof __FUNCTION__==1,\"function\");_Static_assert(sizeof __PRETTY_FUNCTION__==10,\"pretty\");\n",
        },
        {
            .name = "file scope cache survives intervening function",
            .source = "const char *before=__PRETTY_FUNCTION__; int f(void){return sizeof __PRETTY_FUNCTION__;} const char *after=__PRETTY_FUNCTION__; _Static_assert(sizeof __func__==1,\"file\");\n",
        },
        {
            .name = "predefined static array addresses initialize static pointers",
            .source = "const char *f(void){static const char *p=__func__;return p;}\n",
        },
        {
            .name = "address of predefined array retains array extent",
            .source = "int f(void){const char (*p)[2]=&__func__;return (*p)[0];}\n",
        },
        {
            .name = "predefined array characters are const",
            .source = "int f(void){\n__func__[0]='x';\nreturn 0;}\n",
            .rejected = true,
        },
        {
            .name = "pretty array characters are const",
            .source = "int f(void){\n__PRETTY_FUNCTION__[0]='x';\nreturn 0;}\n",
            .rejected = true,
        },
        {
            .name = "predefined arrays are not assignable",
            .source = "int f(void){\n__func__=0;\nreturn 0;}\n",
            .rejected = true,
        },
        {
            .name = "predefined array declaration names cannot be replaced",
            .source = "int f(void){\nint __func__;\nreturn 0;}\n",
            .rejected = true,
        },
    };
assert(sizeof("predefined arrays participate in sizeof and typeof queries")-1==strlen("predefined arrays participate in sizeof and typeof queries"));
assert(sizeof("pretty alias size is evaluated at declaration position")-1==strlen("pretty alias size is evaluated at declaration position"));
assert(sizeof("_Static_assert(sizeof __func__==1,\"func\");_Static_assert(sizeof __FUNCTION__==1,\"function\");_Static_assert(sizeof __PRETTY_FUNCTION__==10,\"pretty\");\n")-1==strlen("_Static_assert(sizeof __func__==1,\"func\");_Static_assert(sizeof __FUNCTION__==1,\"function\");_Static_assert(sizeof __PRETTY_FUNCTION__==10,\"pretty\");\n"));
assert(sizeof("const char *f(void){static const char *p=__func__;return p;}\n")-1==strlen("const char *f(void){static const char *p=__func__;return p;}\n"));
assert(sizeof("address of predefined array retains array extent")-1==strlen("address of predefined array retains array extent"));
assert(sizeof("predefined array declaration names cannot be replaced")-1==strlen("predefined array declaration names cannot be replaced"));
assert(sizeof("int f(void){_Static_assert(sizeof __func__==2,\"func\");_Static_assert(sizeof __FUNCTION__==2,\"function\");_Static_assert(sizeof __PRETTY_FUNCTION__==12,\"pretty\");_Static_assert(__builtin_types_compatible_p(__typeof__(__func__),const char[2]),\"type\");return 0;}\n")-1==strlen("int f(void){_Static_assert(sizeof __func__==2,\"func\");_Static_assert(sizeof __FUNCTION__==2,\"function\");_Static_assert(sizeof __PRETTY_FUNCTION__==12,\"pretty\");_Static_assert(__builtin_types_compatible_p(__typeof__(__func__),const char[2]),\"type\");return 0;}\n"));
assert(sizeof("int f(void){\n__func__=0;\nreturn 0;}\n")-1==strlen("int f(void){\n__func__=0;\nreturn 0;}\n"));
assert(sizeof("int f(void){\n__func__[0]='x';\nreturn 0;}\n")-1==strlen("int f(void){\n__func__[0]='x';\nreturn 0;}\n"));
assert(sizeof("pretty array characters are const")-1==strlen("pretty array characters are const"));
assert(sizeof("int f(void){\n__PRETTY_FUNCTION__[0]='x';\nreturn 0;}\n")-1==strlen("int f(void){\n__PRETTY_FUNCTION__[0]='x';\nreturn 0;}\n"));
assert(sizeof("file scope predefined array lengths")-1==strlen("file scope predefined array lengths"));
assert(sizeof("predefined static array addresses initialize static pointers")-1==strlen("predefined static array addresses initialize static pointers"));
assert(sizeof("predefined arrays are not assignable")-1==strlen("predefined arrays are not assignable"));
assert(sizeof("const char *before=__PRETTY_FUNCTION__; int f(void){return sizeof __PRETTY_FUNCTION__;} const char *after=__PRETTY_FUNCTION__; _Static_assert(sizeof __func__==1,\"file\");\n")-1==strlen("const char *before=__PRETTY_FUNCTION__; int f(void){return sizeof __PRETTY_FUNCTION__;} const char *after=__PRETTY_FUNCTION__; _Static_assert(sizeof __func__==1,\"file\");\n"));
assert(sizeof("int f(void){const char (*p)[2]=&__func__;return (*p)[0];}\n")-1==strlen("int f(void){const char (*p)[2]=&__func__;return (*p)[0];}\n"));
assert(sizeof("file scope cache survives intervening function")-1==strlen("file scope cache survives intervening function"));
assert(sizeof("predefined array characters are const")-1==strlen("predefined array characters are const"));
assert(sizeof("int f(void){\nint __func__;\nreturn 0;}\n")-1==strlen("int f(void){\nint __func__;\nreturn 0;}\n"));
assert(sizeof("typedef int I; I f(I x){_Static_assert(sizeof __PRETTY_FUNCTION__==7,\"pretty\");return x;}\n")-1==strlen("typedef int I; I f(I x){_Static_assert(sizeof __PRETTY_FUNCTION__==7,\"pretty\");return x;}\n"));
for(size_t i=0;i<sizeof rows/sizeof *rows;i++){const CheckSourceFixture*r=rows+i;put(r->name);put(r->source);uint32_t f[]={r->rejected,r->unsupported,r->extension,r->standard,r->char_unsigned,r->undecided,r->overload_tables};assert(!r->capacity);assert(fwrite(f,4,7,stdout)==7);}}
{ const CheckSourceFixture rows[]={
        {
            .name = "GNU overflow enumeration retains target arithmetic",
            .source = "enum { A=2147483647+1, B=(-2147483647-1)/-1, C=(-2147483647-1)%-1, D=-(-2147483647-1), E=-8<<1 }; _Static_assert(A==B && B==D && C==0 && E==-16,\"wrapped integers\");\n",
        },
        {
            .name = "GNU constant array bound and raw attribute",
            .source = "int a[((1<<32)==(-2147483647-1))*3]; typedef int I [[gnu::aligned(((1<<33)==(-2147483647-1))*16)]]; _Static_assert(sizeof a==12 && _Alignof(I)==16,\"folded bound and attribute\");\n",
        },
        {
            .name = "GNU negative shifts and bit-precise type width",
            .source = "typedef _BitInt((8>>-1)+1) I; enum { A=1<<-1, B=8>>32, C=-8<<-1 }; _Static_assert(sizeof(I)==4 && A==0 && B==0 && C==-4,\"reversed shifts\");\n",
        },
        {
            .name = "GNU full-width overflow and shift constants",
            .source = "_Static_assert((((__int128)1<<126)*2)==((__int128)1<<127),\"wide multiply\"); _Static_assert((-((__int128)1<<127))==((__int128)1<<127),\"wide negate\"); _Static_assert((((__int128)1<<127)/-1)==((__int128)1<<127),\"wide divide\"); _Static_assert((((__int128)1<<127)%-1)==0,\"wide remainder\"); _Static_assert(((unsigned __int128)1<<128)==((unsigned __int128)1<<127),\"wide saturation\");\n",
        },
        {
            .name = "GNU complex integer product wraps its components",
            .source = "static _Complex int value=(50000+0i)*(50000+0i); _Static_assert(__real__ ((50000+0i)*(50000+0i))==-1794967296,\"wrapped real component\"); _Static_assert(__imag__ ((50000+0i)*(50000+0i))==0,\"imaginary component\");\n",
        },
        {
            .name = "GNU wrapped ICE zero remains a null pointer constant",
            .source = "int *p=(1<<-1); int *q=(1<<-1)==0 ? (1<<-1) : (2<<-2); int f(void){int *r=(int)(1<<-1); return p==q && q==r;}\n",
        },
        {
            .name = "GNU folded comma zero is not a null pointer constant",
            .source = "int *p=(0,0);\n",
            .rejected = true,
        },
        {
            .name = "GNU computed floating zero is not a null pointer constant",
            .source = "int *p=(int)(0.5-0.5);\n",
            .rejected = true,
        },
        {
            .name = "GNU statement expression zero is not a null pointer constant",
            .source = "int f(void){int *p=({0;});return p==0;}\n",
            .rejected = true,
        },
        {
            .name = "sizeof retains invalid arithmetic operand constraints",
            .source = "int f(void){return (int)sizeof(1+(void)0); }\n",
            .rejected = true,
        },
        {
            .name = "sizeof retains a selected builtin argument constraint",
            .source = "int f(void){return (int)sizeof(__builtin_choose_expr(1,__builtin_add_overflow(1,2,1),0)); }\n",
            .rejected = true,
        },
        {
            .name = "sizeof retains an unselected builtin argument constraint",
            .source = "int f(void){return (int)sizeof(__builtin_choose_expr(1,0,__builtin_add_overflow(1,2,1))); }\n",
            .rejected = true,
        },
        {
            .name = "GNU folding still rejects an evaluated zero divisor",
            .source = "enum { A=1/0 };\n",
            .rejected = true,
        },
    };
assert(sizeof("GNU overflow enumeration retains target arithmetic")-1==strlen("GNU overflow enumeration retains target arithmetic"));
assert(sizeof("int f(void){return (int)sizeof(1+(void)0); }\n")-1==strlen("int f(void){return (int)sizeof(1+(void)0); }\n"));
assert(sizeof("static _Complex int value=(50000+0i)*(50000+0i); _Static_assert(__real__ ((50000+0i)*(50000+0i))==-1794967296,\"wrapped real component\"); _Static_assert(__imag__ ((50000+0i)*(50000+0i))==0,\"imaginary component\");\n")-1==strlen("static _Complex int value=(50000+0i)*(50000+0i); _Static_assert(__real__ ((50000+0i)*(50000+0i))==-1794967296,\"wrapped real component\"); _Static_assert(__imag__ ((50000+0i)*(50000+0i))==0,\"imaginary component\");\n"));
assert(sizeof("sizeof retains an unselected builtin argument constraint")-1==strlen("sizeof retains an unselected builtin argument constraint"));
assert(sizeof("int f(void){return (int)sizeof(__builtin_choose_expr(1,0,__builtin_add_overflow(1,2,1))); }\n")-1==strlen("int f(void){return (int)sizeof(__builtin_choose_expr(1,0,__builtin_add_overflow(1,2,1))); }\n"));
assert(sizeof("int f(void){return (int)sizeof(__builtin_choose_expr(1,__builtin_add_overflow(1,2,1),0)); }\n")-1==strlen("int f(void){return (int)sizeof(__builtin_choose_expr(1,__builtin_add_overflow(1,2,1),0)); }\n"));
assert(sizeof("sizeof retains invalid arithmetic operand constraints")-1==strlen("sizeof retains invalid arithmetic operand constraints"));
assert(sizeof("int *p=(int)(0.5-0.5);\n")-1==strlen("int *p=(int)(0.5-0.5);\n"));
assert(sizeof("enum { A=1/0 };\n")-1==strlen("enum { A=1/0 };\n"));
assert(sizeof("GNU computed floating zero is not a null pointer constant")-1==strlen("GNU computed floating zero is not a null pointer constant"));
assert(sizeof("int f(void){int *p=({0;});return p==0;}\n")-1==strlen("int f(void){int *p=({0;});return p==0;}\n"));
assert(sizeof("GNU folding still rejects an evaluated zero divisor")-1==strlen("GNU folding still rejects an evaluated zero divisor"));
assert(sizeof("int *p=(1<<-1); int *q=(1<<-1)==0 ? (1<<-1) : (2<<-2); int f(void){int *r=(int)(1<<-1); return p==q && q==r;}\n")-1==strlen("int *p=(1<<-1); int *q=(1<<-1)==0 ? (1<<-1) : (2<<-2); int f(void){int *r=(int)(1<<-1); return p==q && q==r;}\n"));
assert(sizeof("_Static_assert((((__int128)1<<126)*2)==((__int128)1<<127),\"wide multiply\"); _Static_assert((-((__int128)1<<127))==((__int128)1<<127),\"wide negate\"); _Static_assert((((__int128)1<<127)/-1)==((__int128)1<<127),\"wide divide\"); _Static_assert((((__int128)1<<127)%-1)==0,\"wide remainder\"); _Static_assert(((unsigned __int128)1<<128)==((unsigned __int128)1<<127),\"wide saturation\");\n")-1==strlen("_Static_assert((((__int128)1<<126)*2)==((__int128)1<<127),\"wide multiply\"); _Static_assert((-((__int128)1<<127))==((__int128)1<<127),\"wide negate\"); _Static_assert((((__int128)1<<127)/-1)==((__int128)1<<127),\"wide divide\"); _Static_assert((((__int128)1<<127)%-1)==0,\"wide remainder\"); _Static_assert(((unsigned __int128)1<<128)==((unsigned __int128)1<<127),\"wide saturation\");\n"));
assert(sizeof("GNU folded comma zero is not a null pointer constant")-1==strlen("GNU folded comma zero is not a null pointer constant"));
assert(sizeof("sizeof retains a selected builtin argument constraint")-1==strlen("sizeof retains a selected builtin argument constraint"));
assert(sizeof("int *p=(0,0);\n")-1==strlen("int *p=(0,0);\n"));
assert(sizeof("GNU full-width overflow and shift constants")-1==strlen("GNU full-width overflow and shift constants"));
assert(sizeof("GNU constant array bound and raw attribute")-1==strlen("GNU constant array bound and raw attribute"));
assert(sizeof("enum { A=2147483647+1, B=(-2147483647-1)/-1, C=(-2147483647-1)%-1, D=-(-2147483647-1), E=-8<<1 }; _Static_assert(A==B && B==D && C==0 && E==-16,\"wrapped integers\");\n")-1==strlen("enum { A=2147483647+1, B=(-2147483647-1)/-1, C=(-2147483647-1)%-1, D=-(-2147483647-1), E=-8<<1 }; _Static_assert(A==B && B==D && C==0 && E==-16,\"wrapped integers\");\n"));
assert(sizeof("int a[((1<<32)==(-2147483647-1))*3]; typedef int I [[gnu::aligned(((1<<33)==(-2147483647-1))*16)]]; _Static_assert(sizeof a==12 && _Alignof(I)==16,\"folded bound and attribute\");\n")-1==strlen("int a[((1<<32)==(-2147483647-1))*3]; typedef int I [[gnu::aligned(((1<<33)==(-2147483647-1))*16)]]; _Static_assert(sizeof a==12 && _Alignof(I)==16,\"folded bound and attribute\");\n"));
assert(sizeof("GNU statement expression zero is not a null pointer constant")-1==strlen("GNU statement expression zero is not a null pointer constant"));
assert(sizeof("typedef _BitInt((8>>-1)+1) I; enum { A=1<<-1, B=8>>32, C=-8<<-1 }; _Static_assert(sizeof(I)==4 && A==0 && B==0 && C==-4,\"reversed shifts\");\n")-1==strlen("typedef _BitInt((8>>-1)+1) I; enum { A=1<<-1, B=8>>32, C=-8<<-1 }; _Static_assert(sizeof(I)==4 && A==0 && B==0 && C==-4,\"reversed shifts\");\n"));
assert(sizeof("GNU wrapped ICE zero remains a null pointer constant")-1==strlen("GNU wrapped ICE zero remains a null pointer constant"));
assert(sizeof("GNU negative shifts and bit-precise type width")-1==strlen("GNU negative shifts and bit-precise type width"));
assert(sizeof("GNU complex integer product wraps its components")-1==strlen("GNU complex integer product wraps its components"));
for(size_t i=0;i<sizeof rows/sizeof *rows;i++){const CheckSourceFixture*r=rows+i;put(r->name);put(r->source);uint32_t f[]={r->rejected,r->unsupported,r->extension,r->standard,r->char_unsigned,r->undecided,r->overload_tables};assert(!r->capacity);assert(fwrite(f,4,7,stdout)==7);}}
{ const CheckSourceFixture rows[]={
        {
            .name = "context: unselected discarded read is not evaluated",
            .source = "int m; static const int k=7; enum { E=1 ? __builtin_popcount(k) : (m,3) }; _Static_assert(E==3, \"\");\n",
        },
        {
            .name = "context: selected discarded read is unevaluable",
            .source = "int m; static int x=(m,3);\n",
            .rejected = true,
        },
        {
            .name = "context: unselected arithmetic fault is deferred",
            .source = "static const int k=7; enum { E=1 ? __builtin_popcount(k) : 1/0 }; _Static_assert(E==3, \"\");\n",
        },
        {
            .name = "context: selected arithmetic fault is diagnosed",
            .source = "enum { E=0 ? 3 : 1/0 };\n",
            .rejected = true,
        },
        {
            .name = "context: inactive union address is not a read",
            .source = "union U { int i; unsigned u; }; static const union U v={.i=7}; static const unsigned *p=&v.u;\n",
        },
        {
            .name = "context: inactive union member cannot supply a receipt",
            .source = "union U { int i; unsigned u; }; static const union U v={.i=7}; enum { E=__builtin_popcount(v.u) };\n",
            .rejected = true,
        },
        {
            .name = "context: qualifier-only pointer path retains receipt evidence",
            .source = "static const int k=7; enum { E=__builtin_popcount(*(const int *)&k) }; _Static_assert(E==3, \"\");\n",
        },
        {
            .name = "context: void round trip cannot recreate receipt evidence",
            .source = "static const int k=7; enum { E=__builtin_popcount(*(const int *)(const void *)&k) };\n",
            .rejected = true,
        },
    };
assert(sizeof("enum { E=0 ? 3 : 1/0 };\n")-1==strlen("enum { E=0 ? 3 : 1/0 };\n"));
assert(sizeof("static const int k=7; enum { E=__builtin_popcount(*(const int *)&k) }; _Static_assert(E==3, \"\");\n")-1==strlen("static const int k=7; enum { E=__builtin_popcount(*(const int *)&k) }; _Static_assert(E==3, \"\");\n"));
assert(sizeof("context: unselected arithmetic fault is deferred")-1==strlen("context: unselected arithmetic fault is deferred"));
assert(sizeof("context: unselected discarded read is not evaluated")-1==strlen("context: unselected discarded read is not evaluated"));
assert(sizeof("context: selected arithmetic fault is diagnosed")-1==strlen("context: selected arithmetic fault is diagnosed"));
assert(sizeof("context: void round trip cannot recreate receipt evidence")-1==strlen("context: void round trip cannot recreate receipt evidence"));
assert(sizeof("context: inactive union member cannot supply a receipt")-1==strlen("context: inactive union member cannot supply a receipt"));
assert(sizeof("union U { int i; unsigned u; }; static const union U v={.i=7}; enum { E=__builtin_popcount(v.u) };\n")-1==strlen("union U { int i; unsigned u; }; static const union U v={.i=7}; enum { E=__builtin_popcount(v.u) };\n"));
assert(sizeof("context: selected discarded read is unevaluable")-1==strlen("context: selected discarded read is unevaluable"));
assert(sizeof("int m; static const int k=7; enum { E=1 ? __builtin_popcount(k) : (m,3) }; _Static_assert(E==3, \"\");\n")-1==strlen("int m; static const int k=7; enum { E=1 ? __builtin_popcount(k) : (m,3) }; _Static_assert(E==3, \"\");\n"));
assert(sizeof("static const int k=7; enum { E=__builtin_popcount(*(const int *)(const void *)&k) };\n")-1==strlen("static const int k=7; enum { E=__builtin_popcount(*(const int *)(const void *)&k) };\n"));
assert(sizeof("context: inactive union address is not a read")-1==strlen("context: inactive union address is not a read"));
assert(sizeof("context: qualifier-only pointer path retains receipt evidence")-1==strlen("context: qualifier-only pointer path retains receipt evidence"));
assert(sizeof("union U { int i; unsigned u; }; static const union U v={.i=7}; static const unsigned *p=&v.u;\n")-1==strlen("union U { int i; unsigned u; }; static const union U v={.i=7}; static const unsigned *p=&v.u;\n"));
assert(sizeof("int m; static int x=(m,3);\n")-1==strlen("int m; static int x=(m,3);\n"));
assert(sizeof("static const int k=7; enum { E=1 ? __builtin_popcount(k) : 1/0 }; _Static_assert(E==3, \"\");\n")-1==strlen("static const int k=7; enum { E=1 ? __builtin_popcount(k) : 1/0 }; _Static_assert(E==3, \"\");\n"));
for(size_t i=0;i<sizeof rows/sizeof *rows;i++){const CheckSourceFixture*r=rows+i;put(r->name);put(r->source);uint32_t f[]={r->rejected,r->unsupported,r->extension,r->standard,r->char_unsigned,r->undecided,r->overload_tables};assert(!r->capacity);assert(fwrite(f,4,7,stdout)==7);}}
{ const CheckSourceFixture rows[]={
        {
            "atomic vector initializers keep the declared destination",
            "typedef int V __attribute__((vector_size(16)));_Atomic(V) make(V);"
            "int f(void){_Atomic(V) a=(V){1,2,3,4};V b=a;_Atomic(V) c=make(b);V d=c;return b[0]+d[0];}",
            false,
            false,
        },
        {
            "atomic vector rvalues do not initialize plain vectors",
            "typedef int V __attribute__((vector_size(16)));_Atomic(V) make(V);"
            "V f(void){V x=make((V){1,2,3,4});return x;}",
            true,
            false,
        },
    };
assert(sizeof("int f(void){_Atomic(V) a=(V){1,2,3,4};V b=a;_Atomic(V) c=make(b);V d=c;return b[0]+d[0];}")-1==strlen("int f(void){_Atomic(V) a=(V){1,2,3,4};V b=a;_Atomic(V) c=make(b);V d=c;return b[0]+d[0];}"));
assert(sizeof("atomic vector initializers keep the declared destination")-1==strlen("atomic vector initializers keep the declared destination"));
assert(sizeof("typedef int V __attribute__((vector_size(16)));_Atomic(V) make(V);")-1==strlen("typedef int V __attribute__((vector_size(16)));_Atomic(V) make(V);"));
assert(sizeof("atomic vector rvalues do not initialize plain vectors")-1==strlen("atomic vector rvalues do not initialize plain vectors"));
assert(sizeof("V f(void){V x=make((V){1,2,3,4});return x;}")-1==strlen("V f(void){V x=make((V){1,2,3,4});return x;}"));
for(size_t i=0;i<sizeof rows/sizeof *rows;i++){const CheckSourceFixture*r=rows+i;put(r->name);put(r->source);uint32_t f[]={r->rejected,r->unsupported,r->extension,r->standard,r->char_unsigned,r->undecided,r->overload_tables};assert(!r->capacity);assert(fwrite(f,4,7,stdout)==7);}}
}