// #2053 packet 2's extraction: each table below is copied verbatim from buster's tree (the file and line in its
// comment), inside a program that writes each case's source bytes, to its first NUL as the runner writes them
// (parse_test_write(path, source, strlen(source))), to OUT/SUITE/NNNN.c, and its metadata to stdout: suite, number,
// rejected, unsupported, extension, standard, unsigned char, undecided, overload tables, capacity, name. Built by the
// official Clang 23.1.4 (clang -std=gnu17 -O0 -w), so the bytes are clang's decoding of the literals, not Buster's.
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <string.h>
#include <sys/stat.h>
typedef struct CheckSourceFixture CheckSourceFixture;
struct CheckSourceFixture
{
    const char* name;
    const char* source;
    bool rejected;
    bool unsupported;
    bool extension;
    uint32_t standard;
    bool char_unsigned;
    bool undecided;
    const void* capacity;
    uint8_t overload_tables;
};

// c_check_cleanup_test.c, line 64 (fixtures)
static const CheckSourceFixture table_cleanup[] =
{
        { .name = "cleanup on an automatic variable", .source = "void f(int *p);\nvoid g(void) { int a __attribute__((cleanup(f))); }\n" },
        { .name = "cleanup on a register variable", .source = "void f(int *p);\nvoid g(void) { register int a __attribute__((cleanup(f))) = 1; }\n" },
        { .name = "cleanup of a const variable discards its qualifier", .source = "void f(int *p);\nvoid g(void) { const int a __attribute__((cleanup(f))) = 1; }\n" },
        { .name = "cleanup taking a pointer to void", .source = "void f(void *p);\nvoid g(void) { long a __attribute__((cleanup(f))); }\n" },
        { .name = "cleanup taking a qualified pointer", .source = "void f(const volatile int *p);\nvoid g(void) { int a __attribute__((cleanup(f))); }\n" },
        { .name = "variadic cleanup of one named parameter", .source = "void f(int *p, ...);\nvoid g(void) { int a __attribute__((cleanup(f))); }\n" },
        { .name = "cleanup function of a result", .source = "int f(int *p);\nvoid g(void) { int a __attribute__((cleanup(f))); }\n" },
        { .name = "cleanup function through a typedef", .source = "typedef void F(int *);\nF f;\nvoid g(void) { int a __attribute__((cleanup(f))); }\n" },
        { .name = "cleanup of a pointer variable", .source = "void f(char **p);\nvoid g(void) { char *a __attribute__((cleanup(f))) = 0; }\n" },
        { .name = "cleanup of a struct variable", .source = "struct S { int x; };\nvoid f(struct S *p);\nvoid g(void) { struct S s __attribute__((cleanup(f))); }\n" },
        { .name = "cleanup of a variable-length array", .source = "void f(int (*p)[]);\nvoid g(int n) { int a[n] __attribute__((cleanup(f))); }\n" },
        { .name = "cleanup's function named like its variable", .source = "void a(int *p);\nvoid g(void) { int a __attribute__((cleanup(a))); }\n" },
        { .name = "cleanups of a specifier's declarators", .source = "void f(int *p);\nvoid g(void) { __attribute__((cleanup(f))) int a, b; }\n" },
        // A function declarator among them ignores the specifier's cleanups, which the variables still have (#745's
        // review): the argument's type, the argument count and the last of several.
        { .name = "a specifier's cleanup on a function and a variable", .source = "void f(int *p);\nvoid g(void) { __attribute__((cleanup(f))) int h(void), a; }\n" },
        { .name = "a specifier's cleanup of another pointee after a function", .source = "void f(long *p);\nvoid g(void) {\n__attribute__((cleanup(f))) int h(void), a;\n}\n", .rejected = true },
        { .name = "a specifier's cleanup of two arguments after a function", .source = "void f(int *p);\nvoid g(void) {\n__attribute__((cleanup(f, f))) int h(void), a;\n}\n", .rejected = true },
        { .name = "the last of a specifier's cleanups after a function", .source = "void f(int *p);\nvoid k(long *p);\nvoid g(void) {\n__attribute__((cleanup(f), cleanup(k))) int h(void), a;\n}\n", .rejected = true },
        { .name = "the last of two cleanups", .source = "void f(int *p);\nvoid h(long *p);\nvoid g(void) { int a __attribute__((cleanup(h), cleanup(f))); }\n" },
        { .name = "cleanup in a for statement", .source = "void f(int *p);\nvoid g(void) { for (int a __attribute__((cleanup(f))) = 0; a < 3; a++) { } }\n" },
        { .name = "cleanup in a statement expression", .source = "void f(int *p);\nint g(int n) { return ({ int a __attribute__((cleanup(f))) = n; a; }); }\n" },
        { .name = "cleanup ignored on a file-scope variable", .source = "void f(int *p);\nint a __attribute__((cleanup(f)));\n" },
        { .name = "cleanup ignored on a static local", .source = "void f(int *p);\nvoid g(void) { static int a __attribute__((cleanup(f))); }\n" },
        { .name = "cleanup ignored on an extern local", .source = "void f(int *p);\nvoid g(void) { extern int a __attribute__((cleanup(f))); }\n" },
        { .name = "cleanup ignored on a typedef", .source = "void f(int *p);\nvoid g(void) { typedef int T __attribute__((cleanup(f))); }\n" },
        { .name = "cleanup ignored on a function", .source = "void f(int *p);\nvoid g(void) { int h(void) __attribute__((cleanup(f))); }\n" },
        { .name = "cleanup ignored on a parameter", .source = "void f(int *p);\nvoid g(int a __attribute__((cleanup(f)))) { }\n" },
        { .name = "cleanup undeclared on an ignored parameter", .source = "void g(int a __attribute__((cleanup(missing)))) { }\n", .rejected = true },
        { .name = "cleanup undeclared on an ignored field", .source = "struct S { int a __attribute__((cleanup(missing))); };\n", .rejected = true },
        { .name = "an earlier cleanup still resolves its argument", .source = "void f(int *);\nvoid g(void) { int a __attribute__((cleanup(missing), cleanup(f))); }\n", .rejected = true },
        { .name = "an earlier cleanup cannot name a type", .source = "typedef int T;\nvoid f(int *);\nvoid g(void) { int a __attribute__((cleanup(T), cleanup(f))); }\n", .rejected = true },
        { .name = "goto out of a cleanup's scope", .source = "void f(int *p);\nvoid g(int n) { { int a __attribute__((cleanup(f))); if (n) goto out; } out:; }\n" },
        { .name = "goto within a cleanup's scope", .source = "void f(int *p);\nvoid g(int n) { int a __attribute__((cleanup(f))); again: if (n--) goto again; }\n" },
        { .name = "case in a block of a cleanup", .source = "void f(int *p);\nvoid g(int n) { switch (n) { case 1: { int a __attribute__((cleanup(f))); break; } case 2:; } }\n" },
        { .name = "computed goto inside a cleanup's scope", .source = "void f(int *p);\nvoid g(int n) { int a __attribute__((cleanup(f))); void *t[] = { &&l }; goto *t[0]; l:; }\n" },
        { .name = "cleanup of an undeclared function", .source = "void g(void) {\nint a __attribute__((cleanup(missing)));\n}\n", .rejected = true },
        { .name = "cleanup undeclared on a file-scope variable", .source = "int a\n__attribute__((cleanup(missing)));\n", .rejected = true },
        { .name = "cleanup naming its own variable", .source = "void g(void) {\nint a __attribute__((cleanup(a)));\n}\n", .rejected = true },
        { .name = "cleanup of an object", .source = "int f;\nvoid g(void) {\nint a __attribute__((cleanup(f)));\n}\n", .rejected = true },
        { .name = "cleanup of a function pointer", .source = "void f(int *p);\nvoid (*h)(int *) = f;\nvoid g(void) {\nint a __attribute__((cleanup(h)));\n}\n", .rejected = true },
        { .name = "cleanup of a type", .source = "typedef int T;\nvoid g(void) {\nint a __attribute__((cleanup(T)));\n}\n", .rejected = true },
        { .name = "cleanup of a parenthesized function", .source = "void f(int *p);\nvoid g(void) {\nint a __attribute__((cleanup((f))));\n}\n", .rejected = true },
        { .name = "cleanup of a string", .source = "void f(int *p);\nvoid g(void) {\nint a __attribute__((cleanup(\"f\")));\n}\n", .rejected = true },
        { .name = "cleanup without an argument", .source = "void f(int *p);\nvoid g(void) {\nint a __attribute__((cleanup));\n}\n", .rejected = true },
        { .name = "cleanup of two arguments", .source = "void f(int *p);\nvoid g(void) {\nint a __attribute__((cleanup(f, f)));\n}\n", .rejected = true },
        { .name = "cleanup function without a prototype", .source = "void f();\nvoid g(void) {\nint a __attribute__((cleanup(f)));\n}\n", .rejected = true },
        { .name = "cleanup function of two parameters", .source = "void f(int *p, int q);\nvoid g(void) {\nint a __attribute__((cleanup(f)));\n}\n", .rejected = true },
        { .name = "cleanup function of no parameter", .source = "void f(void);\nvoid g(void) {\nint a __attribute__((cleanup(f)));\n}\n", .rejected = true },
        { .name = "cleanup of another pointee", .source = "void f(long *p);\nvoid g(void) {\nint a __attribute__((cleanup(f)));\n}\n", .rejected = true },
        { .name = "cleanup of another signedness", .source = "void f(int *p);\nvoid g(void) {\nunsigned a __attribute__((cleanup(f)));\n}\n", .rejected = true },
        { .name = "cleanup of a character pointer", .source = "void f(char *p);\nvoid g(void) {\nint a __attribute__((cleanup(f)));\n}\n", .rejected = true },
        { .name = "cleanup of a pointer to a pointer to void", .source = "void f(void **p);\nvoid g(void) {\nint *a __attribute__((cleanup(f)));\n}\n", .rejected = true },
        { .name = "cleanup of an integer parameter", .source = "void f(int p);\nvoid g(void) {\nint a __attribute__((cleanup(f)));\n}\n", .rejected = true },
        { .name = "cleanup of an element's pointer", .source = "void f(int *p);\nvoid g(int n) {\nint a[n] __attribute__((cleanup(f)));\n}\n", .rejected = true },
        { .name = "goto into a cleanup's scope", .source = "void f(int *p);\nvoid g(int n) {\ngoto l;\nint a __attribute__((cleanup(f)));\nl:;\n}\n", .rejected = true },
        { .name = "goto into a nested cleanup's scope", .source = "void f(int *p);\nvoid g(int n) {\ngoto l;\n{ int a __attribute__((cleanup(f))); l:; }\n}\n", .rejected = true },
        { .name = "switch into a cleanup's scope", .source = "void f(int *p);\nvoid g(int n) { switch (n) {\nint a __attribute__((cleanup(f)));\ncase 1:;\n} }\n", .rejected = true },
        { .name = "computed goto out of a cleanup's scope", .source = "void f(int *p);\nvoid g(int n) { void *t[] = { &&l };\n{ int a __attribute__((cleanup(f)));\ngoto *t[0]; }\nl:;\n}\n", .rejected = true },
        { .name = "computed goto into a cleanup's scope", .source = "void f(int *p);\nvoid g(int n) { void *t[] = { &&l };\n{ int a __attribute__((cleanup(f)));\nl:; }\ngoto *t[0];\n}\n", .rejected = true },
        // An asm goto's targets are its own labels (#1126's review): it may neither leave a cleanup's scope nor enter a
        // cleanup's or a variable-length array's, as clang's JumpScopeChecker has it, but it may leave an array's.
        { .name = "asm goto out of a cleanup's scope", .source = "void f(int *p);\nint g(void) { { int a __attribute__((cleanup(f))) = 7;\nasm goto(\"jmp %l0\" : : : : out); }\nout: return 1; }\n", .rejected = true },
        { .name = "asm goto's second label out of a cleanup's scope", .source = "void f(int *p);\nint g(void) { { int a __attribute__((cleanup(f))) = 7;\nasm goto(\"\" : : : : in, out); in: a++; }\nout: return 0; }\n", .rejected = true },
        { .name = "asm goto into a cleanup's scope", .source = "void f(int *p);\nint g(void) { asm goto(\"jmp %l0\" : : : : in);\n{ int a __attribute__((cleanup(f))) = 7;\nin: return a; } }\n", .rejected = true },
        { .name = "asm goto into an array's scope", .source = "int g(int n) { asm goto(\"jmp %l0\" : : : : in);\n{ int a[n]; a[0] = 1;\nin: return a[0]; } }\n", .rejected = true },
        { .name = "asm goto out of an array's scope", .source = "int g(int n) { { int a[n]; a[0] = 1; asm goto(\"jmp %l0\" : : : : out); }\nout: return 1; }\n" },
        { .name = "asm goto within a cleanup's scope", .source = "void f(int *p);\nint g(int n) { { int x __attribute__((cleanup(f))) = 7; { int a[n]; a[0] = x;\nasm goto(\"jmp %l0\" : : : : in); } in: return x; } }\n" },
        { .name = "asm goto beside another function label's address", .source = "void f(int *p);\nint g(void) { void *p = &&far; { int x __attribute__((cleanup(f))) = 7;\nasm goto(\"jmp %l0\" : : : : in); in: return x; } far: return 0; }\n" },
        // An __auto_type variable's cleanup is checked against the deduced type, not its placeholder's int (#745's
        // review): a double's, by the specifiers too, a decayed array's and a structure's through void *, and
        // pointers to other types.
        { .name = "cleanup of an __auto_type double", .source = "void f(double *p);\nvoid g(void) {\n__auto_type a __attribute__((cleanup(f))) = 1.0;\n}\n" },
        { .name = "cleanup of an __auto_type double by its specifiers", .source = "void f(double *p);\nvoid g(void) {\n__attribute__((cleanup(f))) __auto_type a = 1.0;\n}\n" },
        { .name = "cleanup of an __auto_type decayed array", .source = "void f(char **p);\nvoid g(void) {\nchar b[4];\n__auto_type a __attribute__((cleanup(f))) = b;\n}\n" },
        { .name = "cleanup of an __auto_type structure through void", .source = "void f(void *p);\nvoid g(void) {\n__auto_type a __attribute__((cleanup(f))) = (struct { int x; }){ 1 };\n}\n" },
        { .name = "cleanup of an __auto_type double by an int pointer", .source = "void f(int *p);\nvoid g(void) {\n__auto_type a __attribute__((cleanup(f))) = 1.0;\n}\n", .rejected = true },
        { .name = "cleanup of an __auto_type int by a double pointer", .source = "void f(double *p);\nvoid g(void) {\n__auto_type a __attribute__((cleanup(f))) = 1;\n}\n", .rejected = true },
    };

// c_check_const_alias_test.c, line 6 (check_const_alias_fixtures)
static const CheckSourceFixture table_const_alias[] =
{
    {
        .name = "literal bytes retain their actual plain char element type",
        .source = "const char* const p = \"abc\";\nenum { E = p[0] };\n_Static_assert(E == 97, \"a\");\n",
    },
    {
        .name = "literal byte storage cannot supply a typed int alias",
        .source = "const char a[] = \"abc\";\nenum { E = *(const int*)a };\n",
        .rejected = true,
    },
    {
        .name = "signed char pointer casts do not retag literal bytes",
        .source = "const signed char* const p = (const signed char*)\"abc\";\nenum { E = p[0] };\n_Static_assert(E == 97, \"a\");\n",
        .rejected = true,
    },
    {
        .name = "unsigned char arrays cannot be read through plain char casts",
        .source = "const unsigned char a[] = \"abc\";\nenum { E = *(const char*)a };\n_Static_assert(E == 97, \"a\");\n",
        .rejected = true,
    },
    {
        .name = "literal initialization gives an unsigned char array its declared type",
        .source = "const unsigned char a[] = \"abc\";\nenum { E = a[0] };\n_Static_assert(E == 97, \"a\");\n",
    },
    {
        .name = "unsigned char pointer casts do not retag literal bytes",
        .source = "const unsigned char* const p = (const unsigned char*)\"abc\";\nenum { E = p[0] };\n_Static_assert(E == 97, \"a\");\n",
        .rejected = true,
    },
    {
        .name = "implicit union zeroes do not permit a first-member pointer cast",
        .source = "union U { int x; float f; };\nconst union U u = {};\nenum { E = *(const int*)&u };\n",
        .rejected = true,
    },
    {
        .name = "implicit integer zeroes cannot supply a byte alias",
        .source = "struct P { int x; };\nconst struct P p = {};\nenum { E = *(const unsigned char*)&p.x };\n_Static_assert(E == 0, \"zero\");\n",
        .rejected = true,
    },
    {
        .name = "character pointer arithmetic cannot recover a typed member read",
        .source = "struct P { char x; int y; };\nconst struct P p = {};\nenum { E = *(const int*)((const char*)&p + 4) };\n",
        .rejected = true,
    },
    {
        .name = "first-member layout equivalence does not prove a constant read",
        .source = "struct P { int x; };\nconst struct P p = {};\nenum { E = *(const int*)&p };\n_Static_assert(E == 0, \"zero\");\n",
        .rejected = true,
    },
    {
        .name = "a float pointer roundtrip cannot erase a type-changing cast",
        .source = "struct P { int x; };\nconst struct P p = {};\nenum { E = *(const int*)(const float*)&p.x };\n_Static_assert(E == 0, \"zero\");\n",
        .rejected = true,
    },
    {
        .name = "implicit void pointer storage preserves a read-blocking roundtrip",
        .source = "struct P { int x; };\nconst struct P p = {};\nconst void* const v = &p.x;\nconst int* const q = v;\nenum { E = *q };\n",
        .rejected = true,
    },
    {
        .name = "an inactive member cannot borrow active zeroes through a cast",
        .source = "union U { int x; float f; };\nconst union U u = {};\nenum { E = (int)*(const float*)&u.x };\n",
        .rejected = true,
    },
    {
        .name = "implicit zero coverage does not make an inactive union member readable",
        .source = "union U { int x; float f; };\nconst union U u = {};\nenum { E = (int)u.f };\n",
        .rejected = true,
    },
    {
        .name = "a const access type cannot make a mutable defining object constant",
        .source = "struct P { int x; };\nstruct P p = {};\nenum { E = *(const int*)&p.x };\n",
        .rejected = true,
    },
    {
        .name = "zero padding cannot be consumed as an unsigned char constant",
        .source = "struct P { char x; int y; };\nconst struct P p = {};\nenum { E = *((const unsigned char*)&p + 1) };\n",
        .rejected = true,
    },
    {
        .name = "implicit float zero uses the selected member's actual type",
        .source = "struct P { float x; };\nconst struct P p = {};\nenum { E = (int)p.x };\n_Static_assert(E == 0, \"zero\");\n",
    },
    {
        .name = "implicit integer zero uses the selected member's actual type",
        .source = "struct P { int x; };\nconst struct P p = {};\nenum { E = p.x };\n_Static_assert(E == 0, \"zero\");\n",
    },
    {
        .name = "a same-type pointer cast permits the actual const integer member read",
        .source = "struct P { int x; };\nconst struct P p = {};\nenum { E = *(const int*)&p.x };\n_Static_assert(E == 0, \"zero\");\n",
    },
    {
        .name = "pointer qualifier removal does not change the actual member type",
        .source = "struct P { int x; };\nconst struct P p = {};\nenum { E = *(int*)&p.x };\n_Static_assert(E == 0, \"zero\");\n",
    },
    {
        .name = "const pointer-object storage retains a wrong float access type",
        .source = "struct P { int x; };\nconst struct P p = {};\nconst float* const q = (const float*)&p.x;\nenum { E = (int)*q };\n",
        .rejected = true,
    },
    {
        .name = "an explicit void pointer roundtrip cannot erase a type-changing cast",
        .source = "struct P { int x; };\nconst struct P p = {};\nenum { E = *(const int*)(const void*)&p.x };\n_Static_assert(E == 0, \"zero\");\n",
        .rejected = true,
    },
    {
        .name = "casting away a member's volatile qualification cannot permit folding",
        .source = "struct P { volatile int x; };\nconst struct P p = {};\nenum { E = *(const int*)&p.x };\n",
        .rejected = true,
    },
    {
        .name = "implicit integer zero is not a float object representation",
        .source = "struct P { int x; };\nconst struct P p = {};\nenum { E = (int)*(const float*)&p.x };\n_Static_assert(E == 0, \"zero\");\n",
        .rejected = true,
    },
    {
        .name = "implicit integer zero is not a pointer object representation",
        .source = "struct P { long x; };\nconst struct P p = {};\nenum { E = *(int*const*)&p.x == 0 };\n_Static_assert(E == 1, \"null\");\n",
        .rejected = true,
    },
    {
        .name = "implicit integer zero is not a short subobject",
        .source = "struct P { int x; };\nconst struct P p = {};\nenum { E = *(const short*)&p.x };\n_Static_assert(E == 0, \"zero\");\n",
        .rejected = true,
    },
    {
        .name = "implicit signed integer zero is not an unsigned integer subobject",
        .source = "struct P { int x; };\nconst struct P p = {};\nenum { E = *(const unsigned int*)&p.x };\n_Static_assert(E == 0, \"zero\");\n",
        .rejected = true,
    },
    {
        .name = "a typed array value cannot supply a byte alias",
        .source = "const unsigned short a[] = { 0 };\nenum { E = *(const unsigned char*)a };\n",
        .rejected = true,
    },
    {
        .name = "an explicit integer zero cannot supply a byte alias",
        .source = "const int k = 0;\nenum { E = *(const unsigned char*)&k };\n_Static_assert(E == 0, \"zero\");\n",
        .rejected = true,
    },
    {
        .name = "an explicit integer zero is not a float object representation",
        .source = "struct P { int x; };\nconst struct P p = { 0 };\nenum { E = (int)*(const float*)&p.x };\n_Static_assert(E == 0, \"zero\");\n",
        .rejected = true,
    },
    {
        .name = "implicit void roundtrips still publish legal symbolic addresses",
        .source = "const int k=0;\nconst void* const v=&k;\nconst int* const p=v;\nconst int* q=p;\n",
    },
    {
        .name = "explicit void roundtrips still publish legal symbolic addresses",
        .source = "const int k=0;\nconst int* const p=(const int*)(const void*)&k;\nconst int* q=p;\n",
    },
    {
        .name = "wrong access types still publish legal symbolic addresses",
        .source = "const int k=0;\nconst float* const p=(const float*)&k;\nconst float* q=p;\n",
    },
    {
        .name = "type-changing pointer roundtrips still publish legal symbolic addresses",
        .source = "const int k=0;\nconst int* const p=(const int*)(const float*)&k;\nconst int* q=p;\n",
    },
    {
        .name = "first-member pointer casts still publish legal symbolic addresses",
        .source = "struct P{int x;};\nconst struct P p={};\nconst int* const q=(const int*)&p;\nconst int* r=q;\n",
    },
    {
        .name = "pointer arithmetic after a void roundtrip still publishes an address",
        .source = "const int a[2]={0,1};\nconst int* const p=(const int*)(const void*)a;\nconst int* q=p+1;\n",
    },
    {
        .name = "stored pointer arithmetic cannot erase a void-roundtrip read restriction",
        .source = "const int a[2]={0,1};\nconst int* const p=(const int*)(const void*)a;\nconst int* const q=p+1;\nenum{E=*q};\n",
        .rejected = true,
    },
    {
        .name = "implicit void conversion survives repeated pointer storage and arithmetic",
        .source = "const int a[2]={3,4};\nconst void* const v=a;\nconst int* const q=v;\nconst int* const r=q+1;\nenum{E=*r};\n",
        .rejected = true,
    },
    {
        .name = "stored pointer arithmetic cannot erase literal signedness provenance",
        .source = "const unsigned char* const p=(const unsigned char*)\"abc\";\nconst unsigned char* const q=p+1;\nenum{E=*q};\n",
        .rejected = true,
    },
    {
        .name = "same-type pointer storage and arithmetic retain readable array provenance",
        .source = "const int a[2]={7,9};\nconst int* const p=(const int*)a;\nconst int* const q=p+1;\nenum{E=*q};\n_Static_assert(E==9,\"same type\");\n",
    },
    {
        .name = "qualifier-only pointer storage and arithmetic retain readable array provenance",
        .source = "const int a[2]={7,9};\nint* const p=(int*)a;\nint* const q=p+1;\nenum{E=*q};\n_Static_assert(E==9,\"qualification\");\n",
    },
    {
        .name = "a discarded comma operand cannot taint the selected pointer path",
        .source = "const int k=3;\nconst int* const p=((const void*)&k,&k);\nenum{E=*p};\n_Static_assert(E==3,\"pointer path\");\n",
    },
    {
        .name = "a discarded index operand cannot taint the selected array path",
        .source = "const int a[2]={3,4};\nenum{E=a[((const void*)&a,1)]};\n_Static_assert(E==4,\"index path\");\n",
    },
    {
        .name = "tail padding cannot give a flexible member a readable array bound",
        .source = "struct P{_Alignas(16) int x;int a[];};\nconst struct P p={1};\nenum{E=p.a[0]};\n",
        .rejected = true,
    },
    {
        .name = "flexible initializer storage does not give a source member a known array bound",
        .source = "struct P{_Alignas(16) int x;int a[];};\nconst struct P p={1,{2,3}};\nenum{E=p.a[0]};\n",
        .rejected = true,
    },
    {
        .name = "an enclosing tail cannot give a nested flexible member a readable array bound",
        .source = "struct I{int x;int a[];};\nstruct P{struct I i;int tail;};\nconst struct P p={{0},0};\nenum{E=p.i.a[0]};\n",
        .rejected = true,
    },
    {
        .name = "a discarded inactive-member address cannot taint the selected pointer path",
        .source = "union U{int x,y;};const union U u={.x=1};const int k=3;\nconst int* const p=(&u.y,&k);\nenum{E=*p};\n_Static_assert(E==3,\"discarded address\");\n",
    },
    {
        .name = "a discarded inactive-member address cannot taint the selected array path",
        .source = "union U{int x,y;};const union U u={.x=1};const int a[2]={3,4};\nenum{E=a[(&u.y,1)]};\n_Static_assert(E==4,\"discarded index address\");\n",
    },
    {
        .name = "a flexible member's symbolic address remains a static initializer",
        .source = "struct I{int x;int a[];};struct P{struct I i;int tail;};\nconst struct P p={{0},0};\nconst int* const q=&p.i.a[0];\nconst int* r=q;\n",
    },
    {
        .name = "pointer storage cannot erase a flexible member's missing declared bound",
        .source = "struct I{int x;int a[];};struct P{struct I i;int tail;};\nconst struct P p={{0},0};\nconst int* const q=p.i.a;\nenum{E=*q};\n",
        .rejected = true,
    },
    {
        .name = "a discarded flexible decay cannot taint the selected pointer path",
        .source = "struct I{int x;int a[];};struct P{struct I i;int tail;};\nconst struct P p={{0},0};const int k=3;\nconst int* const q=(p.i.a,&k);\nenum{E=*q};\n_Static_assert(E==3,\"discarded flexible decay\");\n",
    },
    {
        .name = "a completed later array declaration supplies its actual bound",
        .source = "extern const int a[];\nconst int a[2]={3,4};\nenum{E=a[1]};\n_Static_assert(E==4,\"completed array\");\n",
    },
    {
        .name = "an earlier symbolic array pointer can read a subsequently completed target",
        .source = "extern const int a[];\nconst int* const p=a;\nconst int a[2]={3,4};\nenum{E=p[1]};\n_Static_assert(E==4,\"completed target\");\n",
    },
};

// c_check_musttail_test.c, line 21 (fixtures)
static const CheckSourceFixture table_musttail[] =
{
        { .name = "musttail: a direct tail call", .source = "int f(int);\nint g(int x)\n{\n__attribute__((musttail)) return f(x);\n}\n" },
        { .name = "musttail: clang's C23 spelling", .source = "int f(int);\nint g(int x)\n{\n[[clang::musttail]] return f(x);\n}\n" },
        { .name = "musttail: GNU's other spelling", .source = "int f(int);\nint g(int x)\n{\n__attribute__((__musttail__)) return f(x);\n}\n" },
        { .name = "musttail: twice", .source = "int f(int);\nint g(int x)\n{\n__attribute__((musttail, musttail)) return f(x);\n}\n" },
        { .name = "musttail: a parenthesized call", .source = "int f(int);\nint g(int x)\n{\n__attribute__((musttail)) return ((f(x)));\n}\n" },
        { .name = "musttail: a selection's call", .source = "int f(int);\nint g(int x)\n{\n__attribute__((musttail)) return __builtin_choose_expr(1, f(x), 0);\n}\n" },
        { .name = "musttail: _Generic's call", .source = "int f(int);\nint g(int x)\n{\n__attribute__((musttail)) return _Generic(x, int: f(x));\n}\n" },
        { .name = "musttail: __extension__'s call", .source = "int f(int);\nint g(int x)\n{\n__attribute__((musttail)) return __extension__ f(x);\n}\n" },
        { .name = "musttail: a call through a dereference", .source = "int f(int);\nint g(int x)\n{\n__attribute__((musttail)) return (*f)(x);\n}\n" },
        { .name = "musttail: a pointer's call", .source = "int (*p)(int);\nint g(int x)\n{\n__attribute__((musttail)) return p(x);\n}\n" },
        { .name = "musttail: a member's call of another signature", .source = "struct S { int (*f)(int); };\nint g(int x, struct S *s);\nint g(int x, struct S *s)\n{\n"
                                                         "__attribute__((musttail)) return s->f(x);\n}\n", .rejected = true },
        { .name = "musttail: a call in a loop, a switch and a nested block", .source = "int f(int);\nint g(int x)\n{\nwhile (x)\n{\nswitch (x)\n{\ncase 1:\n"
                                                                                      "__attribute__((musttail)) return f(x);\n}\n{\n{\n__attribute__((musttail)) return f(x + 1);\n}\n}\n}\nreturn 0;\n}\n" },
        { .name = "musttail: after a label", .source = "int f(int);\nint g(int x)\n{\nl:\n[[clang::musttail]] return f(x);\n}\n" },
        { .name = "musttail: in a statement expression", .source = "int f(int);\nint g(int x)\n{\nreturn x + ({\n__attribute__((musttail)) return f(x);\n0;\n});\n}\n" },
        { .name = "musttail: a cleanup's scope ended before it", .source = "void c(int *);\nint f(int);\nint g(int x)\n{\n{\nint y __attribute__((cleanup(c))) = x;\n}\n"
                                                                           "__attribute__((musttail)) return f(x);\n}\n" },
        { .name = "musttail: a qualified parameter and a pointer's qualifiers", .source = "int f(const int, const char *);\nint g(int x, char *p)\n{\n"
                                                                                           "__attribute__((musttail)) return f(x, p);\n}\n" },
        { .name = "musttail: a K&R definition's promoted parameters", .source = "int f(int);\nint g(x) char x;\n{\n__attribute__((musttail)) return f(x);\n}\n" },
        { .name = "musttail: structs, long double, complex and __int128", .source = "struct S { long a, b, c; };\nstruct S f(struct S, long double, _Complex double, __int128);\n"
                                                                                    "struct S g(struct S s, long double d, _Complex double z, __int128 w)\n{\n"
                                                                                    "__attribute__((musttail)) return f(s, d, z, w);\n}\n" },
        { .name = "musttail: a void function", .source = "void f(int);\nvoid g(int x)\n{\n__attribute__((musttail)) return f(x);\n}\n" },
        { .name = "musttail: GNU's noreturn and C11's _Noreturn callees", .source = "__attribute__((noreturn)) int f(int);\n_Noreturn int h(int);\nint g(int x)\n{\n"
                                                                                      "if (x)\n__attribute__((musttail)) return f(x);\n__attribute__((musttail)) return h(x);\n}\n" },
        { .name = "musttail: an expression statement's", .source = "int f(int);\nint g(int x)\n{\n__attribute__((musttail)) f(x);\nreturn 0;\n}\n", .rejected = true },
        { .name = "musttail: a null statement's", .source = "int g(int x)\n{\n__attribute__((musttail));\nreturn x;\n}\n", .rejected = true },
        { .name = "musttail: an if's", .source = "int f(int);\nint g(int x)\n{\n[[clang::musttail]] if (x) return f(x);\nreturn 0;\n}\n", .rejected = true },
        { .name = "musttail: a declaration's", .source = "int f(int);\nint g(int x)\n{\n__attribute__((musttail)) int y = f(x);\nreturn y;\n}\n", .rejected = true },
        { .name = "musttail: a function's", .source = "__attribute__((musttail)) int f(int);\n", .rejected = true },
        { .name = "musttail: a named label's", .source = "int f(int);\nint g(int x)\n{\nl: __attribute__((musttail));\nreturn f(x);\n}\n", .rejected = true },
        { .name = "musttail: with an argument", .source = "int f(int);\nint g(int x)\n{\n__attribute__((musttail(1))) return f(x);\n}\n", .rejected = true },
        { .name = "musttail: a return without a value", .source = "void g(void)\n{\n__attribute__((musttail)) return;\n}\n", .rejected = true },
        { .name = "musttail: a value that isn't a call", .source = "int g(int x)\n{\n__attribute__((musttail)) return x + 1;\n}\n", .rejected = true },
        { .name = "musttail: a cast of a call", .source = "long f(int);\nlong g(int x)\n{\n__attribute__((musttail)) return (long)f(x);\n}\n", .rejected = true },
        { .name = "musttail: a conditional of calls", .source = "int f(int);\nint g(int x)\n{\n__attribute__((musttail)) return x ? f(x) : f(0);\n}\n", .rejected = true },
        { .name = "musttail: an implicitly converted result", .source = "int f(int);\nlong g(int x)\n{\n__attribute__((musttail)) return f(x);\n}\n", .rejected = true },
        { .name = "musttail: another parameter count", .source = "int f(int, int);\nint g(int x)\n{\n__attribute__((musttail)) return f(x, x);\n}\n", .rejected = true },
        { .name = "musttail: another parameter type", .source = "int f(long);\nint g(int x)\n{\n__attribute__((musttail)) return f(x);\n}\n", .rejected = true },
        { .name = "musttail: another pointee", .source = "int f(char *);\nint g(int *x)\n{\n__attribute__((musttail)) return f((char *)x);\n}\n", .rejected = true },
        { .name = "musttail: another enum", .source = "enum E { A };\nint f(enum E);\nint g(int x)\n{\n__attribute__((musttail)) return f(x);\n}\n", .rejected = true },
        { .name = "musttail: a pointer's other signature", .source = "int (*p)(long);\nint g(int x)\n{\n__attribute__((musttail)) return p(x);\n}\n", .rejected = true },
        { .name = "musttail: a variadic callee", .source = "int f(int, ...);\nint g(int x)\n{\n__attribute__((musttail)) return f(x);\n}\n", .rejected = true },
        { .name = "musttail: a variadic caller", .source = "int f(int);\nint g(int x, ...)\n{\n__attribute__((musttail)) return f(x);\n}\n", .rejected = true },
        { .name = "musttail: a callee without a prototype", .source = "int f();\nint g(int x)\n{\n__attribute__((musttail)) return f(x);\n}\n", .rejected = true },
        { .name = "musttail: a caller without a prototype", .source = "int f(void);\nint g()\n{\n__attribute__((musttail)) return f();\n}\n", .rejected = true },
        { .name = "musttail: another calling convention", .source = "__attribute__((ms_abi)) int f(int);\nint g(int x)\n{\n__attribute__((musttail)) return f(x);\n}\n",
          .rejected = true },
        { .name = "musttail: a [[noreturn]] callee", .source = "[[noreturn]] int f(int);\nint g(int x)\n{\n__attribute__((musttail)) return f(x);\n}\n", .rejected = true },
        // #936's review: a standard noreturn counts where an accepted declaration before the call has it (clang's
        // inheritance), not where clang drops it after the definition, and not where it is declared after the call.
        { .name = "musttail: an earlier declaration's [[noreturn]]", .source = "[[noreturn]] int f(int);\nint f(int);\nint g(int x)\n{\n"
                                                                             "__attribute__((musttail)) return f(x);\n}\n", .rejected = true },
        { .name = "musttail: a [[noreturn]] clang drops after the definition", .source = "int f(int x) { return x; }\n[[noreturn]] int f(int);\nint g(int x)\n{\n"
                                                                                       "__attribute__((musttail)) return f(x);\n}\n" },
        { .name = "musttail: a [[noreturn]] clang drops after the definition, in C23", .source = "int f(int x) { return x; }\n[[noreturn]] int f(int);\nint g(int x)\n{\n"
                                                                                                "__attribute__((musttail)) return f(x);\n}\n", .standard = 2023 },
        { .name = "musttail: a [[noreturn]] declared after the call", .source = "int f(int);\nint g(int x)\n{\n__attribute__((musttail)) return f(x);\n}\n"
                                                                               "[[noreturn]] int f(int);\n" },
        // #936's review: pointers' qualifiers beneath arrays of the same bound, or of none, are similar types too
        // (UnwrapSimilarArrayTypes), and arrays of another bound or another element beneath them aren't.
        { .name = "musttail: pointers' qualifiers beneath arrays of the same bound", .source = "int f(const int *(*p)[3]);\nint g(int *(*p)[3])\n{\n"
                                                                                                "__attribute__((musttail)) return f((const int *(*)[3])p);\n}\n" },
        { .name = "musttail: pointers' qualifiers beneath arrays of no bound", .source = "int f(const int *(*p)[]);\nint g(int *(*p)[])\n{\n"
                                                                                          "__attribute__((musttail)) return f((const int *(*)[])p);\n}\n" },
        { .name = "musttail: arrays of another bound", .source = "int f(const int *(*p)[4]);\nint g(int *(*p)[3])\n{\n"
                                                                  "__attribute__((musttail)) return f((const int *(*)[4])p);\n}\n", .rejected = true },
        { .name = "musttail: another element beneath arrays of the same bound", .source = "int f(const long *(*p)[3]);\nint g(int *(*p)[3])\n{\n"
                                                                                           "__attribute__((musttail)) return f((const long *(*)[3])p);\n}\n",
          .rejected = true },
        // #936's second review: pointers' qualifiers at any depth, 63, 64 and 65 levels, and another leaf at 64.
        { .name = "musttail: a leaf's qualifiers beneath 63 pointers", .source = "#define P8 ********\n#define P63 ******* P8 P8 P8 P8 P8 P8 P8\n"
                                                                              "int f(const int P63 p);\nint g(int P63 p)\n{\n__attribute__((musttail)) return f((const int P63)p);\n}\n" },
        { .name = "musttail: a leaf's qualifiers beneath 64 pointers", .source = "#define P8 ********\n#define P64 P8 P8 P8 P8 P8 P8 P8 P8\n"
                                                                              "int f(const int P64 p);\nint g(int P64 p)\n{\n__attribute__((musttail)) return f((const int P64)p);\n}\n" },
        { .name = "musttail: a leaf's qualifiers beneath 65 pointers", .source = "#define P8 ********\n#define P65 * P8 P8 P8 P8 P8 P8 P8 P8\n"
                                                                              "int f(const int P65 p);\nint g(int P65 p)\n{\n__attribute__((musttail)) return f((const int P65)p);\n}\n" },
        { .name = "musttail: another leaf beneath 64 pointers", .source = "#define P8 ********\n#define P64 P8 P8 P8 P8 P8 P8 P8 P8\n"
                                                                       "int f(const long P64 p);\nint g(int P64 p)\n{\n__attribute__((musttail)) return f((const long P64)p);\n}\n",
          .rejected = true },
        { .name = "musttail: in a cleanup's scope", .source = "void c(int *);\nint f(int);\nint g(int x)\n{\nint y __attribute__((cleanup(c))) = x;\n"
                                                           "__attribute__((musttail)) return f(x);\n}\n", .rejected = true },
        { .name = "musttail: in a nested cleanup's scope", .source = "void c(int *);\nint f(int);\nint g(int x)\n{\n{\nint y __attribute__((cleanup(c))) = x;\n"
                                                                  "[[clang::musttail]] return f(x);\n}\n}\n", .rejected = true },
        { .name = "musttail: in a for statement's cleanup's scope", .source = "void c(int *);\nint f(int);\nint g(int x)\n{\n"
                                                                           "for (int y __attribute__((cleanup(c))) = 0; y < x; y++)\n{\n"
                                                                           "__attribute__((musttail)) return f(x);\n}\nreturn 0;\n}\n", .rejected = true },
        { .name = "musttail: a later return's error", .source = "int f(int);\nint g(int x)\n{\nif (x)\n__attribute__((musttail)) return f(x);\n"
                                                         "__attribute__((musttail)) return x;\n}\n", .rejected = true },
        // __builtin_call_with_static_chain's (#148), of clang's signature R(R, C).
        { .name = "musttail: a static chain's call", .source = "int f(int);\nint g(int x, void *p)\n{\n"
                                                             "__attribute__((musttail)) return __builtin_call_with_static_chain(f(x), p);\n}\n" },
        { .name = "musttail: a static chain's function chain", .source = "int f(int);\nint g(int x, int (*p)(int))\n{\n"
                                                                       "__attribute__((musttail)) return __builtin_call_with_static_chain(f(x), f);\n}\n" },
        { .name = "musttail: a static chain's other signature", .source = "int f(int, int);\nint g(int x, int y, void *p)\n{\n"
                                                                        "__attribute__((musttail)) return __builtin_call_with_static_chain(f(x, y), p);\n}\n", .rejected = true },
        // Refused by name, where clang takes it (its call of the builtin's own signature) and computes the builtin inline.
        { .name = "musttail: a builtin's call", .source = "long g(long a, long b)\n{\n__attribute__((musttail)) return __builtin_expect(a, b);\n}\n", .rejected = true,
          .unsupported = true },
    };

// c_check_program_align_test.c, line 18 (fixtures)
static const CheckSourceFixture table_align[] =
{
        { .name = "align: result types", .source =
          "#define T(e, t) _Static_assert(_Generic((e), t: 1, default: 0), #e);\n"
          "struct B { unsigned x : 3; };\n"
          "void f(char c, unsigned short s, long l, unsigned __int128 q, _BitInt(37) w, int* p, const char* k, int a[4], struct B r, const int ci)\n"
          "{\n"
          "T(__builtin_align_up(c, 4), char) T(__builtin_align_down(s, 2), unsigned short) T(__builtin_align_up(l, (char)8), long)\n"
          "T(__builtin_align_down(q, (unsigned __int128)16), unsigned __int128) T(__builtin_align_up(w, 4), _BitInt(37))\n"
          "T(__builtin_align_up(p, 64), int*) T(__builtin_align_down(k, 2), const char*) T(__builtin_align_up(a, 8), int*)\n"
          "T(__builtin_align_up(r.x, 2), unsigned int) T(__builtin_is_aligned(p, 8), _Bool) T(__builtin_is_aligned(c, 2), _Bool)\n"
          "T(__builtin_expect_with_probability(c, 1, 0.5), long) T(__builtin_align_up(ci, 4) + 0, int)\n"
          "}\n" },
        { .name = "align: a const source's result is const", .source =
          "int f(const int ci)\n{\n__typeof__(__builtin_align_up(ci, 4)) z = 1;\nz = 2;\nreturn z;\n}\n", .rejected = true },
        { .name = "align: folds in constant contexts", .source =
          "static char buf[64];\nstatic _Alignas(32) char aligned[64];\nstruct S { char a; int b; char c[8]; } s;\n"
          "_Static_assert(__builtin_align_up(5, 4) == 8 && __builtin_align_down(7, 4) == 4 && __builtin_is_aligned(16, 8), \"\");\n"
          "_Static_assert(__builtin_align_up((signed char)127, 2) == -128 && __builtin_align_up(0xffffffffu, 16) == 0, \"\");\n"
          "_Static_assert(__builtin_align_up(-5, 4) == -4 && __builtin_align_down(-5, 4) == -8, \"\");\n"
          "_Static_assert(__builtin_align_up((unsigned __int128)1 << 100 | 1, (unsigned __int128)1 << 64) >> 64 == ((unsigned __int128)1 << 36) + 1, \"\");\n"
          "_Static_assert(__builtin_is_aligned(&buf[16], 16) && !__builtin_is_aligned(&buf[3], 8) && __builtin_is_aligned(&aligned[32], 32), \"\");\n"
          "_Static_assert(!__builtin_is_aligned(&aligned[16], 32) && __builtin_is_aligned(&s.b, 4) && !__builtin_is_aligned(&s.c[1], 2), \"\");\n"
          "_Static_assert(__builtin_is_aligned(\"abc\", 1) && __builtin_is_aligned((char*)&s + 4, 4), \"\");\n"
          "_Static_assert(__builtin_expect_with_probability(3, 1, 0.25) == 3, \"\");\n"
          "static char* up = __builtin_align_up(&buf[3], 8);\nstatic char* down = __builtin_align_down(&buf[13], 8);\n"
          "static char* same = __builtin_align_up(&aligned[32], 32);\nstatic int flag = __builtin_is_aligned(&buf[16], 16);\n"
          "int sizes[__builtin_align_up(3, 4)];\nenum { E = __builtin_align_down(13, 8), F = __builtin_is_aligned(&buf[16], 16) };\n"
          "int g(int x) { switch (x) { case __builtin_align_up(1, 8): return 1; case __builtin_is_aligned(&buf[16], 16): return 2; } return 0; }\n" },
        { .name = "align: an address no declaration aligns enough", .source =
          "static char small[8];\nstatic char* p =\n__builtin_align_up(&small[1], 8);\n", .rejected = true },
        { .name = "align: is_aligned of a pointer variable", .source = "char* q;\n_Static_assert(\n__builtin_is_aligned(q, 1), \"\");\n", .rejected = true },
        { .name = "align: a bool source", .source = "int f(_Bool b)\n{\nreturn __builtin_align_up(b, 4);\n}\n", .rejected = true },
        { .name = "align: an enumeration source", .source = "enum E { A };\nint f(enum E e)\n{\nreturn __builtin_align_up(e, 4);\n}\n", .rejected = true },
        { .name = "align: a float source", .source = "int f(float x)\n{\nreturn __builtin_align_down(x, 4);\n}\n", .rejected = true },
        { .name = "align: a struct source", .source = "struct S { int x; };\nint f(struct S s)\n{\nreturn __builtin_is_aligned(s, 4);\n}\n", .rejected = true },
        { .name = "align: a function pointer source", .source = "void g(void);\nint f(void)\n{\nreturn __builtin_is_aligned(&g, 4);\n}\n", .rejected = true },
        { .name = "align: a function source", .source = "void g(void);\nint f(void)\n{\nreturn __builtin_is_aligned(g, 4);\n}\n", .rejected = true },
        { .name = "align: an _Atomic source", .source = "int f(_Atomic int a)\n{\nreturn __builtin_align_up(a, 4);\n}\n", .rejected = true },
        { .name = "align: a bool alignment", .source = "int f(int x, _Bool a)\n{\nreturn __builtin_align_up(x, a);\n}\n", .rejected = true },
        { .name = "align: an enumeration alignment", .source = "enum E { A = 4 };\nint f(int x)\n{\nreturn __builtin_align_up(x, A);\n}\n" },
        { .name = "align: an enumeration variable's alignment", .source = "enum E { A = 4 };\nint f(int x, enum E e)\n{\nreturn __builtin_align_up(x, e);\n}\n",
          .rejected = true },
        { .name = "align: a double alignment", .source = "int f(int x)\n{\nreturn __builtin_align_up(x, 4.0);\n}\n", .rejected = true },
        { .name = "align: a pointer alignment", .source = "int f(int x, int* p)\n{\nreturn __builtin_align_up(x, p);\n}\n", .rejected = true },
        { .name = "align: an alignment of 0", .source = "int f(int x)\n{\nreturn __builtin_align_up(x, 0);\n}\n", .rejected = true },
        { .name = "align: a negative alignment", .source = "int f(int x)\n{\nreturn __builtin_align_down(x, -4);\n}\n", .rejected = true },
        { .name = "align: an alignment that isn't a power of 2", .source = "int f(int x)\n{\nreturn __builtin_is_aligned(x, 3);\n}\n", .rejected = true },
        { .name = "align: an alignment past a char's", .source = "char f(char x)\n{\nreturn __builtin_align_up(x, 256);\n}\n", .rejected = true },
        { .name = "align: an alignment past an int's", .source = "int f(int x)\n{\nreturn __builtin_align_up(x, 4294967296L);\n}\n", .rejected = true },
        { .name = "align: the largest alignment of an int and of a pointer", .source =
          "int f(int x, char* p)\n{\nreturn __builtin_align_up(x, 2147483648L) + (int)(long)__builtin_align_down(p, 0x8000000000000000ul);\n}\n" },
        // A source past 128 bits (#1447): its constant alignments checked as any source's; an alignment past 128 bits checked
        // by its constant's limbs (zero, negative, past the source's range or no power of 2), at clang's error's line.
        { .name = "align: a wide source's alignment of 0", .source = "unsigned _BitInt(200) f(unsigned _BitInt(200) x)\n{\nreturn __builtin_align_up(x, 0);\n}\n",
          .rejected = true },
        { .name = "align: a wide source's negative alignment", .source = "_BitInt(200) f(_BitInt(200) x)\n{\nreturn __builtin_align_down(x, -8);\n}\n", .rejected = true },
        { .name = "align: a wide source's alignment that isn't a power of 2", .source = "int f(unsigned _BitInt(256) x)\n{\nreturn __builtin_is_aligned(x, 3);\n}\n",
          .rejected = true },
        { .name = "align: a wide source's alignments", .source =
          "unsigned _BitInt(200) f(unsigned _BitInt(200) x, long a)\n{\nreturn __builtin_align_up(x, 16) + __builtin_align_down(x, (unsigned __int128)1 << 127) + __builtin_align_up(x, a);\n}\n" },
        { .name = "align: a wide alignment that isn't a power of 2", .source = "int f(int x)\n{\nreturn __builtin_align_up(x, (unsigned _BitInt(200))3);\n}\n",
          .rejected = true },
        { .name = "align: a wide alignment of 0", .source = "int f(unsigned _BitInt(200) x)\n{\nreturn __builtin_is_aligned(x, (unsigned _BitInt(200))0);\n}\n",
          .rejected = true },
        { .name = "align: a negative wide alignment", .source = "int f(int x)\n{\nreturn __builtin_align_down(x, (_BitInt(200))-8);\n}\n",
          .rejected = true },
        { .name = "align: a wide alignment past an int's", .source = "int f(int x)\n{\nreturn __builtin_align_up(x, (unsigned _BitInt(200))1 << 40);\n}\n",
          .rejected = true },
        // Constant alignments past 128 bits (#1447), and their folds of wide and narrow sources, through const objects too.
        { .name = "align: folds past 128 bits", .source =
          "typedef _BitInt(200) W;\ntypedef unsigned _BitInt(300) U;\nstatic const U k = (U)1 << 250;\n"
          "_Static_assert(__builtin_align_up((W)5, (W)8) == 8 && __builtin_align_down((U)1 << 250 | 7, (U)1 << 200) == (U)1 << 250, \"\");\n"
          "_Static_assert(__builtin_is_aligned((U)1 << 250, (U)1 << 240) && __builtin_align_up(5, (W)16) == 16, \"\");\n"
          "_Static_assert(__builtin_align_up((U)3, 1u << 31) == (U)1 << 31 && __builtin_align_up((U)5, k) == k, \"\");\n"
          "U f(U x)\n{\nreturn __builtin_align_down(x, k) + __builtin_align_up(x, (W)1 << 150);\n}\n" },
        { .name = "align: a wide alignment past a wide source's", .source = "_BitInt(200) f(_BitInt(200) x)\n{\nreturn __builtin_align_up(x, (unsigned _BitInt(300))1 << 200);\n}\n",
          .rejected = true },
        { .name = "align: a const object's wide alignment that isn't a power of 2", .source =
          "static const unsigned _BitInt(300) bad = ((unsigned _BitInt(300))1 << 250) + 1;\nunsigned _BitInt(300) g(unsigned _BitInt(300) x)\n{\nreturn __builtin_align_down(x, bad);\n}\n",
          .rejected = true },
        { .name = "align: an alignment past its side effects", .source = "int g(void);\nint f(int x)\n{\nreturn __builtin_align_up(x, (g(), 3));\n}\n",
          .rejected = true },
        { .name = "align: an unknown alignment", .source = "int f(int x, int a)\n{\nreturn __builtin_align_down(x, a) + __builtin_is_aligned(x, a);\n}\n" },
        { .name = "align: a const object's alignment", .source = "int f(int x)\n{\nconst int a = 3;\nreturn __builtin_align_up(x, a);\n}\n", .rejected = true },
        { .name = "align: a const object's alignment of 0", .source = "int f(int x)\n{\nconst int z = 0;\nreturn __builtin_align_down(x, z);\n}\n",
          .rejected = true },
        { .name = "align: a file-scope const object's alignment", .source = "static const int s = 6;\nint f(int x)\n{\nreturn __builtin_is_aligned(x, s);\n}\n",
          .rejected = true },
        { .name = "align: a const object's alignment past an int's", .source =
          "static const long big = 1L << 40;\nint f(int x)\n{\nreturn __builtin_align_down(x, big);\n}\n", .rejected = true },
        { .name = "align: a const object inside an alignment", .source = "int f(int x)\n{\nconst int c = 3;\nreturn __builtin_align_up(x, c + 0);\n}\n",
          .rejected = true },
        { .name = "align: a const double's alignment", .source = "static const double d = 3.0;\nint f(int x)\n{\nreturn __builtin_align_up(x, (int)d);\n}\n",
          .rejected = true },
        { .name = "align: alignments the evaluator doesn't read", .source =
          "int f(int x, int y)\n{\nconst volatile int v = 3;\nconst int w = y;\nreturn __builtin_align_up(x, v) + __builtin_align_down(x, w);\n}\n" },
        { .name = "align: const objects folded in constant contexts", .source =
          "static const int x = 5;\nstatic const int a = 8;\n"
          "_Static_assert(__builtin_align_up(x, 8) == 8 && __builtin_align_down(13, a) == 8 && __builtin_is_aligned(16, a), \"\");\n"
          "int sizes[__builtin_align_up(x, 8)];\n"
          "int f(void)\n{\nconst int y = 6;\nswitch (0) { case __builtin_align_up(y, 4) - 8: return 1; }\nreturn 0;\n}\n" },
        // Clang's evaluator fails on a modification it must evaluate, past side effects or not, and then checks no value;
        // a comma's discarded modification it goes past.
        { .name = "align: modifications the evaluator doesn't evaluate", .source =
          "static int s;\nlong f(long x)\n{\nint l = 0;\nreturn __builtin_align_up(x, (s = 3)) + __builtin_align_down(x, (s = 3) + 0) +\n"
          "__builtin_is_aligned(x, (l = 3)) + __builtin_align_up(x, (s += 3)) + __builtin_align_up(x, s++) + __builtin_align_up(x, ++l);\n}\n" },
        { .name = "align: a modification's value past a comma", .source = "static int s;\nlong f(long x)\n{\nreturn __builtin_align_up(x, (s = 4, 3));\n}\n",
          .rejected = true },
        { .name = "align: a discarded modification", .source = "static int s;\nlong f(long x)\n{\nreturn __builtin_align_up(x, ((s = 3), 3));\n}\n",
          .rejected = true },
        { .name = "align: a discarded read", .source = "static int s;\nlong f(long x)\n{\nreturn __builtin_align_up(x, (s, 3));\n}\n", .rejected = true },
        { .name = "align: one argument", .source = "int f(int x)\n{\nreturn __builtin_align_up(x);\n}\n", .rejected = true },
        { .name = "align: three arguments", .source = "int f(int x)\n{\nreturn __builtin_align_up(x, 4, 4);\n}\n", .rejected = true },
        { .name = "probability: accepted forms", .source =
          "const double half = 0.5;\nconst int one = 1;\n"
          "long f(long x)\n{\nreturn __builtin_expect_with_probability(x, 1, 0.5) + __builtin_expect_with_probability(x, 0, 1) +\n"
          "__builtin_expect_with_probability(x, 1, half) + __builtin_expect_with_probability(x, 1, -0.0) + __builtin_expect_with_probability(x, 1, 0.25f) +\n"
          "__builtin_expect_with_probability(x, 1, sizeof(int) / 8.0) + __builtin_expect_with_probability(x, 1, one ? 0.5 : 0.25) +\n"
          "__builtin_expect_with_probability(x, 1, (0, 0.5)) + __builtin_expect_with_probability(x, 1, one);\n}\n" },
        { .name = "probability: const objects in its expression", .source =
          "static const double half = 0.5;\nlong f(long x)\n{\nconst int n = 4;\nreturn __builtin_expect_with_probability(x, 1, half / 2 + 1.0 / n);\n}\n" },
        { .name = "probability: a const object's past 1", .source =
          "static const double two = 2.0;\nlong f(long x)\n{\nreturn __builtin_expect_with_probability(x, 1, two / 1.5);\n}\n", .rejected = true },
        { .name = "probability: a variable", .source = "long f(long x, double p)\n{\nreturn __builtin_expect_with_probability(x, 1, p);\n}\n", .rejected = true },
        { .name = "probability: past 1", .source = "long f(long x)\n{\nreturn __builtin_expect_with_probability(x, 1, 1.5);\n}\n", .rejected = true },
        { .name = "probability: below 0", .source = "long f(long x)\n{\nreturn __builtin_expect_with_probability(x, 1, -0.1);\n}\n", .rejected = true },
        { .name = "probability: a NaN", .source = "long f(long x)\n{\nreturn __builtin_expect_with_probability(x, 1, __builtin_nan(\"\"));\n}\n", .rejected = true },
        { .name = "probability: an infinity", .source = "long f(long x)\n{\nreturn __builtin_expect_with_probability(x, 1, __builtin_inf());\n}\n", .rejected = true },
        { .name = "probability: a call's", .source = "double g(void);\nlong f(long x)\n{\nreturn __builtin_expect_with_probability(x, 1, (g(), 0.5));\n}\n",
          .rejected = true },
        // A constant expression's evaluation fails on a discarded operand it can't evaluate, where a fold goes on.
        { .name = "probability: a discarded read", .source = "static double s;\nlong f(long x)\n{\nreturn __builtin_expect_with_probability(x, 1, (s, 0.75));\n}\n",
          .rejected = true },
        { .name = "probability: a discarded read in a condition", .source =
          "static double s;\nlong f(long x)\n{\nreturn __builtin_expect_with_probability(x, 1, (s, 1) ? 0.5 : 0.25);\n}\n", .rejected = true },
        { .name = "probability: a read cast to void", .source =
          "static double s;\nlong f(long x)\n{\nreturn __builtin_expect_with_probability(x, 1, ((void)s, 0.75));\n}\n", .rejected = true },
        { .name = "probability: a discarded modification", .source =
          "static double s;\nlong f(long x)\n{\nreturn __builtin_expect_with_probability(x, 1, ((void)(s = 1), 0.75));\n}\n", .rejected = true },
        { .name = "probability: discarded operands the evaluator evaluates", .source =
          "static double s;\nconst int one = 1;\nlong f(long x)\n{\nreturn __builtin_expect_with_probability(x, 1, ((void)0, 0.75)) +\n"
          "__builtin_expect_with_probability(x, 1, (one, 0.75)) + __builtin_expect_with_probability(x, 1, ((void)one, 0.75)) +\n"
          "__builtin_expect_with_probability(x, 1, (&s, 0.75)) + __builtin_expect_with_probability(x, 1, (sizeof(s), 0.75)) +\n"
          "__builtin_expect_with_probability(x, 1, 0 ? s : 0.75) + __builtin_expect_with_probability(x, 1, ((void)(0, 1), 0.75));\n}\n" },
        { .name = "probability: a pointer", .source = "long f(long x)\n{\nreturn __builtin_expect_with_probability(x, 1, (void*)0);\n}\n", .rejected = true },
        { .name = "probability: two arguments", .source = "long f(long x)\n{\nreturn __builtin_expect_with_probability(x, 1);\n}\n", .rejected = true },
        { .name = "expect: a folded first argument's effects in constant contexts", .source =
          "long g(void);\nextern volatile long v;\n_Static_assert(__builtin_expect(1, g()) && __builtin_expect_with_probability(2, v, 0.5) == 2, \"\");\n"
          "static long s = __builtin_expect_with_probability(4, g(), 0.25);\nint arr[__builtin_expect_with_probability(2, g(), 1.0)];\n" },
    };

// c_check_program_classify_test.c, line 15 (fixtures)
static const CheckSourceFixture table_classify[] =
{
        { .name = "classify: folds in constant expressions",
          .source = "_Static_assert(__builtin_isnormal(1.0) && !__builtin_isnormal(0x1p-1030) && __builtin_issubnormal(0x1p-1030), \"\");\n"
                    "_Static_assert(__builtin_iszero(-0.0f) && !__builtin_issignaling(__builtin_nanf(\"\")) && __builtin_isfpclass(-1.0, 8), \"\");\n"
                    "_Static_assert(__builtin_isnormal(0x1p-16382L) && __builtin_issubnormal(0x1p-16383L) && __builtin_isfpclass(-0.0L, 32), \"\");\n"
                    "_Static_assert(__builtin_signbitf(-0.0) && !__builtin_signbitl(1) && __builtin_signbitl(-__builtin_infl()), \"\");\n"
                    "int a[__builtin_isfpclass(-2.0, 8) + 1];\nint f(double x)\n{\nswitch (1)\n{\ncase __builtin_isnormal(1.0):\nreturn 1;\n}\n"
                    "return __builtin_issignaling(x);\n}\n" },
        { .name = "classify: result types",
          .source = "_Static_assert(_Generic(__builtin_isfpclass(1.0f, 3), int: 1, default: 0) && _Generic(__builtin_signbitl(1), int: 1, default: 0), \"\");\n"
                    "_Static_assert(_Generic(__builtin_canonicalizef(1), float: 1, default: 0), \"\");\n"
                    "_Static_assert(_Generic(__builtin_canonicalize(1.0f), double: 1, default: 0), \"\");\n"
                    "_Static_assert(_Generic(__builtin_canonicalizel(1.0), long double: 1, default: 0), \"\");\n" },
        { .name = "classify: masks of other integer types",
          .source = "int f(double x)\n{\nreturn __builtin_isfpclass(x, 1023u) + __builtin_isfpclass(x, (char)3) + __builtin_isfpclass(x, (int)3.7) +\n"
                    "__builtin_isfpclass(x, sizeof(int)) + __builtin_isfpclass(x, (_Bool)0) + __builtin_isfpclass(x, (unsigned char)127);\n}\n" },
        { .name = "classify: isfpclass of a vector",
          .source = "typedef float v4 __attribute__((vector_size(16)));\ntypedef int i4 __attribute__((vector_size(16)));\n"
                    "typedef double v2 __attribute__((ext_vector_type(2)));\ni4 f(v4 x)\n{\nreturn __builtin_isfpclass(x, 3);\n}\n"
                    "_Static_assert(_Generic(__builtin_isfpclass((v4){ 0 }, 3), i4: 1, default: 0), \"\");\n" },
        { .name = "classify: a mask that isn't constant", .source = "int f(double x, int m)\n{\nreturn __builtin_isfpclass(x, m);\n}\n", .rejected = true },
        { .name = "classify: a mask past 1023", .source = "int f(double x)\n{\nreturn __builtin_isfpclass(x, 1024);\n}\n", .rejected = true },
        { .name = "classify: a negative mask", .source = "int f(double x)\n{\nreturn __builtin_isfpclass(x, -1);\n}\n", .rejected = true },
        // clang sign-extends the mask from its type's width, whatever its signedness.
        { .name = "classify: a bool mask of 1", .source = "int f(double x)\n{\nreturn __builtin_isfpclass(x, (_Bool)1);\n}\n", .rejected = true },
        { .name = "classify: an unsigned char mask of 200", .source = "int f(double x)\n{\nreturn __builtin_isfpclass(x, (unsigned char)200);\n}\n",
          .rejected = true },
        { .name = "classify: a floating mask", .source = "int f(double x)\n{\nreturn __builtin_isfpclass(x, 1.0);\n}\n", .rejected = true },
        { .name = "classify: a comma's mask", .source = "int f(double x)\n{\nreturn __builtin_isfpclass(x, (1, 2));\n}\n", .rejected = true },
        { .name = "classify: isfpclass of an int", .source = "int f(int x)\n{\nreturn __builtin_isfpclass(x, 3);\n}\n", .rejected = true },
        { .name = "classify: isfpclass of a complex", .source = "int f(_Complex double x)\n{\nreturn __builtin_isfpclass(x, 3);\n}\n", .rejected = true },
        { .name = "classify: isfpclass without its mask", .source = "int f(double x)\n{\nreturn __builtin_isfpclass(x);\n}\n", .rejected = true },
        { .name = "classify: isnormal of an int", .source = "int f(int x)\n{\nreturn __builtin_isnormal(x);\n}\n", .rejected = true },
        { .name = "classify: iszero of two", .source = "int f(double x)\n{\nreturn __builtin_iszero(x, x);\n}\n", .rejected = true },
        { .name = "classify: issubnormal of a struct", .source = "struct S { double d; };\nint f(struct S s)\n{\nreturn __builtin_issubnormal(s);\n}\n",
          .rejected = true },
        { .name = "classify: signbitf of a pointer", .source = "int f(int *p)\n{\nreturn __builtin_signbitf(p);\n}\n", .rejected = true },
        { .name = "classify: canonicalize of a pointer", .source = "double f(int *p)\n{\nreturn __builtin_canonicalize(p);\n}\n", .rejected = true },
        { .name = "classify: canonicalize in a static initializer", .source = "static const double d = __builtin_canonicalize(1.0);\n", .rejected = true },
    };

// c_check_program_constants_test.c, line 13 (fixtures)
static const CheckSourceFixture table_float_constants[] =
{
        { .name = "float constants: folds in constant expressions",
          .source = "_Static_assert(__builtin_issignaling(__builtin_nans(\"\")) && __builtin_issignaling(__builtin_nansf(\"1\")) &&\n"
                    "__builtin_issignaling(__builtin_nansl(\"0x10\")), \"\");\n"
                    "_Static_assert(__builtin_isnan(__builtin_nanf16(\"\")) && __builtin_issignaling(__builtin_nansf16(\"\")) &&\n"
                    "!__builtin_issignaling(__builtin_nanf16(\"3\")) && __builtin_isinf(__builtin_inff16()) && __builtin_isinf(__builtin_huge_valf16()), \"\");\n"
                    "_Static_assert(__builtin_isnan(__builtin_nanf128(\"9\")) && __builtin_issignaling(__builtin_nansf128(\"\")) &&\n"
                    "__builtin_isinf(__builtin_inff128()) && __builtin_isinf(-__builtin_huge_valf128()) && __builtin_signbit(-__builtin_nansf128(\"\")), \"\");\n"
                    "_Static_assert(!__builtin_issignaling((double)__builtin_nansf(\"\")) && !__builtin_issignaling(-(float)__builtin_nans(\"\")) &&\n"
                    "__builtin_issignaling(-__builtin_nans(\"2\")) && __builtin_fpclassify(0, 1, 2, 3, 4, __builtin_nansf16(\"\")) == 0, \"\");\n"
                    "int a[__builtin_isinf(__builtin_inff16()) + __builtin_isfpclass(__builtin_nansf128(\"\"), 1) + 1];\n" },
        { .name = "float constants: result types",
          .source = "_Static_assert(_Generic(__builtin_nans(\"\"), double: 1, default: 0) && _Generic(__builtin_nansf(\"\"), float: 1, default: 0) &&\n"
                    "_Generic(__builtin_nansl(\"\"), long double: 1, default: 0), \"\");\n"
                    "_Static_assert(_Generic(__builtin_nanf16(\"\"), _Float16: 1, default: 0) && _Generic(__builtin_nansf16(\"\"), _Float16: 1, default: 0) &&\n"
                    "_Generic(__builtin_inff16(), _Float16: 1, default: 0) && _Generic(__builtin_huge_valf16(), _Float16: 1, default: 0), \"\");\n"
                    "_Static_assert(_Generic(__builtin_nanf128(\"\"), __float128: 1, default: 0) && _Generic(__builtin_nansf128(\"\"), __float128: 1, default: 0) &&\n"
                    "_Generic(__builtin_inff128(), __float128: 1, default: 0) && _Generic(__builtin_huge_valf128(), __float128: 1, default: 0), \"\");\n" },
        { .name = "float constants: static initializers",
          .source = "static const __float128 q[] = { __builtin_inff128(), -__builtin_nanf128(\"5\"), __builtin_nansf128(\"\") };\n"
                    "static _Float16 h = __builtin_nansf16(\"1\");\nstruct S { double d; __float128 q; _Float16 h; } s = { __builtin_nans(\"\"), "
                    "__builtin_huge_valf128(), __builtin_inff16() };\nconst __float128* p = q;\n" },
        { .name = "float constants: exact __float128 initializers",
          .source = "static __float128 a = 0;\nstatic __float128 b = 1.5;\nstatic __float128 c = 1.5q;\n"
                    "static __float128 d = 0.1;\nstatic __float128 e = 1.5L;\nstatic __float128 f = 18446744073709551615ULL;\n"
                    "static __float128 g = (__int128)1 << 100;\n"
                    "int tested(void){return (int)(a+b+c+d+e+(f!=0)+(g!=0));}\n" },
        { .name = "float constants: an integer's payload", .source = "double f(void)\n{\nreturn __builtin_nans(1);\n}\n", .rejected = true },
        { .name = "float constants: nansf16 without its payload", .source = "_Float16 f(void)\n{\nreturn __builtin_nansf16();\n}\n",
          .rejected = true },
        { .name = "float constants: inff128 of an argument", .source = "__float128 f(void)\n{\nreturn __builtin_inff128(1);\n}\n", .rejected = true },
        { .name = "float constants: nanf128 of two payloads", .source = "__float128 f(void)\n{\nreturn __builtin_nanf128(\"\", \"\");\n}\n",
          .rejected = true },
    };

// c_check_program_generic_builtins_test.c, line 17 (fixtures)
static const CheckSourceFixture table_generic_builtins[] =
{
        { .name = "generic: classify_type's classes", .source =
          "struct S { int a; }; union U { int a; }; enum E { X }; struct I; extern struct I inc;\n"
          "int arr[3]; void fn(void); int g; _Atomic int ai; _Alignas(16) const volatile char cv;\n"
          "#define C(e, v) _Static_assert(__builtin_classify_type(e) == (v), #e);\n"
          "C(0, 1) C((char)0, 1) C((_Bool)0, 4) C(X, 1) C((enum E)0, 1) C((int*)0, 5) C(1.0, 8) C(1.0f, 8) C(1.0L, 8) C((__float128)1, 8)\n"
          "C((_Float16)1, 8) C((_Complex double)0, 9) C((_Complex int)0, 9) C(fn, 5) C(&fn, 5) C((struct S){0}, 12) C((union U){0}, 13)\n"
          "C(arr, 5) C(\"ab\", 5) C((void)0, 0) C((_BitInt(7))0, 18) C((__attribute__((vector_size(16))) int){0}, 19) C((__int128)0, 1)\n"
          "C(inc, 12) C(g++, 1) C(ai, 1) C(cv, 1) C(0UL, 1)\n"
          "static int sizes[__builtin_classify_type(1.0)];\nenum { K = __builtin_classify_type((struct S){0}) };\n" },
        { .name = "generic: eh_return_data_regno's registers", .source =
          "_Static_assert(__builtin_eh_return_data_regno(0) == 0 && __builtin_eh_return_data_regno(1) == 1, \"\");\n"
          "_Static_assert(__builtin_eh_return_data_regno(2) == -1 && __builtin_eh_return_data_regno(-1) == -1, \"\");\n"
          "_Static_assert(__builtin_eh_return_data_regno(1L << 32) == 0 && __builtin_eh_return_data_regno('\\1') == 1, \"\");\n"
          "int r = __builtin_eh_return_data_regno(sizeof(char));\n" },
        { .name = "generic: launder's and dwarf_cfa's types", .source =
          "#define T(e, t) _Static_assert(_Generic((e), t: 1, default: 0), #e);\n"
          "struct S { int a; }; int g; struct S* sp; const int* cp; int a[4];\n"
          "int* laundered = __builtin_launder(&g);\n"
          "void f(void)\n{\nT(__builtin_launder(&g), int*) T(__builtin_launder(sp), struct S*) T(__builtin_launder(cp), const int*)\n"
          "T(__builtin_launder(a), int*) T(__builtin_dwarf_cfa(), void*)\n}\n" },
        { .name = "generic: the leaves' prototypes", .source =
          "#define T(e, t) _Static_assert(_Generic((e), t: 1, default: 0), #e);\n"
          "void f(char* x, void* p, const void* q, int v)\n{\n"
          "T(__builtin_readcyclecounter(), unsigned long long) T(__builtin_readsteadycounter(), unsigned long long)\n"
          "T(__builtin_thread_pointer(), void*) T(__builtin_stack_address(), void*) T(__builtin_dwarf_sp_column(), unsigned int)\n"
          "__builtin_debugtrap(); __builtin___clear_cache(x, x + 4); __builtin_assume_separate_storage(p, q);\n"
          "__builtin_assume_dereferenceable(q, 8); __builtin_memcpy_inline(p, q, 13); __builtin_memset_inline(p, v, sizeof(int) * 2);\n}\n" },
        { .name = "generic: the unwinder's, the rounding mode's, the pointer's and the trap's leaves", .source =
          "#define T(e, t) _Static_assert(_Generic((e), t: 1, default: 0), #e);\n"
          "void f(void* p, int v)\n{\nT(__builtin_extend_pointer(p), unsigned long long) __builtin_unwind_init(); __builtin_init_dwarf_reg_size_table(p);\n"
          "__builtin_set_flt_rounds(v); __builtin_set_flt_rounds(3.0);\nif (v) __builtin_verbose_trap(\"category\", \"message\");\n"
          "if (v > 1) __builtin_verbose_trap(__func__, ((\"x\" \"y\")));\nif (v > 2) __builtin_verbose_trap((const char*)\"a\", u8\"b\");\n}\n" },
        { .name = "generic: verbose_trap of a variable", .source =
          "void f(const char* p)\n{\n__builtin_verbose_trap(p, \"x\");\n}\n", .rejected = true },
        { .name = "generic: verbose_trap of a null pointer", .source =
          "void f(void)\n{\n__builtin_verbose_trap(\"x\", (const char*)0);\n}\n", .rejected = true },
        { .name = "generic: verbose_trap of a dollar", .source =
          "void f(void)\n{\n__builtin_verbose_trap(\"a$b\", \"x\");\n}\n", .rejected = true },
        // A const array's string (#1917's review): a known one's, an automatic array's, a const record's member array's and a
        // const pointer's pointee's too, with a `$` is clang's error; through a cast to void * clang's evaluator loses the
        // array's designator, its error too, and through casts between pointers to char it reads it (#1843).
        { .name = "generic: verbose_trap of a const array's dollar", .source =
          "static const char m[] = \"a$c\";\nvoid f(void)\n{\n__builtin_verbose_trap(\"x\", m);\n}\n", .rejected = true },
        { .name = "generic: verbose_trap of a const array", .source =
          "static const char m[] = \"abc\";\nvoid f(void)\n{\n__builtin_verbose_trap(\"x\", m + 1);\n}\n" },
        { .name = "generic: verbose_trap of an automatic const array", .source =
          "void f(void)\n{\nconst char m[] = \"abc\";\n__builtin_verbose_trap(\"x\", m);\n}\n" },
        { .name = "generic: verbose_trap of an automatic const array's dollar", .source =
          "void f(void)\n{\nconst char m[] = \"a$c\";\n__builtin_verbose_trap(\"x\", m);\n}\n", .rejected = true },
        { .name = "generic: verbose_trap of a member array", .source =
          "struct S { char a[4]; };\nstatic const struct S s = { \"abc\" };\nvoid f(void)\n{\n__builtin_verbose_trap(\"x\", s.a);\n}\n" },
        { .name = "generic: verbose_trap of a member array's dollar", .source =
          "struct S { char a[4]; };\nstatic const struct S s = { \"ab$\" };\nvoid f(void)\n{\n__builtin_verbose_trap(\"x\", s.a);\n}\n", .rejected = true },
        { .name = "generic: verbose_trap of a const pointer's value", .source =
          "static const char m[] = \"abc\";\nstatic const char* const p = m + 1;\nvoid f(void)\n{\n__builtin_verbose_trap(\"x\", p);\n}\n" },
        { .name = "generic: verbose_trap of a const array through void *", .source =
          "static const char m[] = \"abc\";\nvoid f(void)\n{\n__builtin_verbose_trap(\"x\", (const char*)(const void*)m);\n}\n", .rejected = true },
        { .name = "generic: verbose_trap of a const array through char pointers", .source =
          "static const char m[] = \"abc\";\nvoid f(void)\n{\n__builtin_verbose_trap(\"x\", (const char*)(char*)m + 1);\n}\n" },
        { .name = "generic: verbose_trap of a literal through void *", .source =
          "void f(void)\n{\n__builtin_verbose_trap(\"x\", (const char*)(const void*)\"abc\" + 1);\n}\n" },
        { .name = "generic: verbose_trap of a dollar under a cast", .source =
          "void f(void)\n{\n__builtin_verbose_trap(\"a\", (const char*)(\"x$\"));\n}\n", .rejected = true },
        { .name = "generic: verbose_trap of one argument", .source = "void f(void)\n{\n__builtin_verbose_trap(\"a\");\n}\n", .rejected = true },
        { .name = "generic: set_flt_rounds of nothing", .source = "void f(void)\n{\n__builtin_set_flt_rounds();\n}\n", .rejected = true },
        { .name = "generic: extend_pointer of an integer", .source =
          "unsigned long long f(long v)\n{\nreturn __builtin_extend_pointer(v);\n}\n", .rejected = true },
        { .name = "generic: the alloca variants', checks' and addresses' types", .source =
          "#define T(e, t) _Static_assert(_Generic((e), t: 1, default: 0), #e);\nstruct S { int a; } s; int g; void fn(void); int arr[3];\nint* pg = __builtin_addressof(g); void* ps = __builtin_function_start(fn); int (*pa)[3] = __builtin_addressof(arr);\nstruct S* pss = __builtin_addressof(s); int* pm = __builtin_addressof(s.a); void (*pf)(void) = __builtin_addressof(fn);\nvoid f(unsigned long n, int x, long y)\n{\nT(__builtin_alloca_uninitialized(n), void*) T(__builtin_alloca_with_align(n, 64), void*) T(__builtin_alloca_with_align_uninitialized(n, 8 * 4096), void*)\nT(__builtin_allow_runtime_check(\"x\"), _Bool) T(__builtin_allow_sanitize_check(\"address\"), _Bool) T(__builtin_annotation(y, \"a\"), long)\nT(__builtin_annotation((char)x, \"a\"), char) T(__builtin_addressof(x), int*) T(__builtin_function_start(f), void*)\nint* p = __builtin_addressof(x); (void)p; (void)__builtin_allow_sanitize_check(\"kernel-hwaddress\");\n}\n" },
        { .name = "generic: alloca_with_align of 24 bits", .source =
          "void* f(unsigned long n)\n{\nreturn __builtin_alloca_with_align(n, 24);\n}\n", .rejected = true },
        { .name = "generic: alloca_with_align of 4 bits", .source =
          "void* f(unsigned long n)\n{\nreturn __builtin_alloca_with_align(n, 4);\n}\n", .rejected = true },
        { .name = "generic: alloca_with_align of 0 bits", .source =
          "void* f(unsigned long n)\n{\nreturn __builtin_alloca_with_align(n, 0);\n}\n", .rejected = true },
        { .name = "generic: alloca_with_align of a variable", .source =
          "void* f(unsigned long n, unsigned long a)\n{\nreturn __builtin_alloca_with_align(n, a);\n}\n", .rejected = true },
        { .name = "generic: alloca_with_align past INT32_MAX", .source =
          "void* f(unsigned long n)\n{\nreturn __builtin_alloca_with_align(n, 1UL << 32);\n}\n", .rejected = true },
        { .name = "generic: alloca_with_align of one", .source =
          "void* f(unsigned long n)\n{\nreturn __builtin_alloca_with_align(n);\n}\n", .rejected = true },
        { .name = "generic: allow_runtime_check of a variable", .source =
          "int f(const char* p)\n{\nreturn __builtin_allow_runtime_check(p);\n}\n", .rejected = true },
        { .name = "generic: allow_runtime_check in a constant", .source =
          "int x = __builtin_allow_runtime_check(\"a\");\n", .rejected = true },
        { .name = "generic: allow_sanitize_check of undefined", .source =
          "int f(void)\n{\nreturn __builtin_allow_sanitize_check(\"undefined\");\n}\n", .rejected = true },
        { .name = "generic: annotation of a double", .source =
          "int f(double x)\n{\nreturn __builtin_annotation(x, \"a\");\n}\n", .rejected = true },
        { .name = "generic: annotation of a variable string", .source =
          "int f(int x, const char* p)\n{\nreturn __builtin_annotation(x, p);\n}\n", .rejected = true },
        { .name = "generic: annotation of a wide string", .source =
          "int f(int x)\n{\nreturn __builtin_annotation(x, L\"a\");\n}\n", .rejected = true },
        { .name = "generic: annotation in a constant", .source =
          "_Static_assert(__builtin_annotation(3, \"a\") == 3, \"\");\n", .rejected = true },
        { .name = "generic: function_start of an object", .source =
          "int g;\nvoid* f(void)\n{\nreturn __builtin_function_start(g);\n}\n", .rejected = true },
        { .name = "generic: function_start of a pointer", .source =
          "void* f(void (*q)(void))\n{\nreturn __builtin_function_start(q);\n}\n", .rejected = true },
        // __builtin_function_start's operand evaluates to a function at offset 0, as clang's getAsBuiltinConstantDeclRef reads
        // it: a named function's address and its casts are, a conditional's, a null pointer's and an offset one aren't
        // (#1126's review).
        { .name = "generic: function_start of a function's address", .source =
          "void g(void);\nvoid* a = __builtin_function_start(&g);\nvoid* b = __builtin_function_start((&g));\n"
          "void* c = __builtin_function_start((void (*)(int))g);\nvoid* d = __builtin_function_start((void*)&g);\n"
          "void* f(void)\n{\nreturn __builtin_function_start(*&g) == __builtin_function_start((char*)&g) ? a : b;\n}\n" },
        { .name = "generic: function_start of a conditional", .source =
          "void g(void);\nvoid h(void);\nvoid* f(int y)\n{\nreturn __builtin_function_start(y ? g : h);\n}\n", .rejected = true },
        { .name = "generic: function_start of a null pointer", .source = "void* a = __builtin_function_start(0);\n", .rejected = true },
        { .name = "generic: function_start of an offset", .source =
          "void g(void);\nvoid* a = __builtin_function_start((char*)g + 1);\n", .rejected = true },
        { .name = "generic: function_start of an offset address", .source =
          "void g(void);\nvoid* f(void)\n{\nreturn __builtin_function_start((void*)&g + 1);\n}\n", .rejected = true },
        { .name = "generic: function_start of folded addresses", .source =
          "void g(void);\nvoid k(void);\nvoid* a = __builtin_function_start(1 ? g : g);\nvoid* b = __builtin_function_start(g + 0);\n"
          "void* c = __builtin_function_start(0 ? g : k);\nvoid* d = __builtin_function_start((g, k));\nvoid* e = __builtin_function_start(&g + 1 - 1);\n"
          "void* f(void)\n{\nreturn __builtin_function_start(1 ? (char*)g + 0 : 0);\n}\n" },
        { .name = "generic: function_start of an object's address", .source =
          "int v;\nvoid* a = __builtin_function_start((void (*)(void))&v);\n", .rejected = true },
        { .name = "generic: function_start of a folded object's address", .source =
          "int v;\nvoid g(void);\nvoid* a = __builtin_function_start(1 ? (void (*)(void))&v : g);\n", .rejected = true },
        { .name = "generic: function_start of a folded string", .source =
          "void g(void);\nvoid* a = __builtin_function_start(0 ? g : (void (*)(void))\"abc\");\n", .rejected = true },
        { .name = "generic: function_start of a cast pointer", .source =
          "void* f(void (*q)(void))\n{\nreturn __builtin_function_start((void*)q);\n}\n", .rejected = true },
        { .name = "generic: addressof of an rvalue", .source =
          "int* f(void)\n{\nreturn __builtin_addressof(3);\n}\n", .rejected = true },
        { .name = "generic: addressof of a bit-field", .source =
          "struct S { int b : 3; } s;\nint* f(void)\n{\nreturn __builtin_addressof(s.b);\n}\n", .rejected = true },
        { .name = "generic: addressof of a register", .source =
          "int f(int x)\n{\nregister int r = x;\nreturn *__builtin_addressof(r);\n}\n", .rejected = true },
        { .name = "generic: eh_return_data_regno of a variable", .source = "int f(int n)\n{\nreturn __builtin_eh_return_data_regno(n);\n}\n", .rejected = true },
        { .name = "generic: eh_return_data_regno of a double", .source = "int f(void)\n{\nreturn __builtin_eh_return_data_regno(1.0);\n}\n", .rejected = true },
        { .name = "generic: classify_type of nothing", .source = "int f(void)\n{\nreturn __builtin_classify_type();\n}\n", .rejected = true },
        { .name = "generic: classify_type of two", .source = "int f(void)\n{\nreturn __builtin_classify_type(1, 2);\n}\n", .rejected = true },
        { .name = "generic: launder of a void pointer", .source = "void* f(void* p)\n{\nreturn __builtin_launder(p);\n}\n", .rejected = true },
        { .name = "generic: launder of a function pointer", .source =
          "typedef void F(void);\nF* f(F* p)\n{\nreturn __builtin_launder(p);\n}\n", .rejected = true },
        { .name = "generic: launder of an integer", .source = "long f(long p)\n{\nreturn (long)__builtin_launder(p);\n}\n", .rejected = true },
        { .name = "generic: launder of an incomplete type", .source = "struct I;\nstruct I* f(struct I* p)\n{\nreturn __builtin_launder(p);\n}\n",
          .rejected = true },
        { .name = "generic: launder of two", .source = "int* f(int* p)\n{\nreturn __builtin_launder(p, p);\n}\n", .rejected = true },
        { .name = "generic: dwarf_cfa of a level", .source = "void* f(void)\n{\nreturn __builtin_dwarf_cfa(1);\n}\n", .rejected = true },
        { .name = "generic: memcpy_inline of a variable size", .source =
          "void f(void* p, const void* q, unsigned long n)\n{\n__builtin_memcpy_inline(p, q, n);\n}\n", .rejected = true },
        { .name = "generic: memset_inline of a variable size", .source =
          "void f(void* p, unsigned long n)\n{\n__builtin_memset_inline(p, 0, n);\n}\n", .rejected = true },
        { .name = "generic: assume_dereferenceable of a variable size", .source =
          "void f(const void* p, unsigned long n)\n{\n__builtin_assume_dereferenceable(p, n);\n}\n" },
        { .name = "generic: debugtrap of an argument", .source = "void f(void)\n{\n__builtin_debugtrap(1);\n}\n", .rejected = true },
        { .name = "generic: clear_cache of one", .source = "void f(char* x)\n{\n__builtin___clear_cache(x);\n}\n", .rejected = true },
        { .name = "generic: vectorelements of an integer", .source = "unsigned long f(int n)\n{\nreturn __builtin_vectorelements(n);\n}\n", .rejected = true },
        { .name = "generic: vectorelements of an integer type", .source = "unsigned long f(void)\n{\nreturn __builtin_vectorelements(int);\n}\n", .rejected = true },
        // #1126's review: a comma expression's operand, its last operand's type (both orders of two widths), and a type
        // before a comma, which clang's parser refuses.
        { .name = "generic: vectorelements of a comma expression", .source =
          "typedef int A __attribute__((ext_vector_type(2)));typedef int B __attribute__((ext_vector_type(4)));\n"
          "_Static_assert(__builtin_vectorelements((A){0}, (B){0}) == 4 && __builtin_vectorelements((B){0}, (A){0}) == 2, \"\");\n"
          "unsigned long f(A a, B b)\n{\nreturn __builtin_vectorelements(a, b) * 10 + __builtin_vectorelements(b, a, a);\n}\n" },
        { .name = "generic: vectorelements of a type and an expression", .source =
          "typedef int A __attribute__((ext_vector_type(2)));\nunsigned long f(A a)\n{\nreturn __builtin_vectorelements(int, a);\n}\n", .rejected = true },
        // #1126's review: omp_required_simd_align's operand is alignof's, an array's base element type, which must be a
        // complete object type.
        { .name = "generic: omp_required_simd_align of void", .source = "int f(void)\n{\nreturn __builtin_omp_required_simd_align(void);\n}\n", .rejected = true },
        { .name = "generic: omp_required_simd_align of an incomplete struct", .source =
          "struct S;\nint f(void)\n{\nreturn __builtin_omp_required_simd_align(struct S);\n}\n", .rejected = true },
        { .name = "generic: omp_required_simd_align of a function type", .source = "int f(void)\n{\nreturn __builtin_omp_required_simd_align(int(void));\n}\n",
          .rejected = true },
        { .name = "generic: omp_required_simd_align of an incomplete struct's array", .source =
          "struct S;\nint f(void)\n{\nreturn __builtin_omp_required_simd_align(struct S[]);\n}\n", .rejected = true },
        { .name = "generic: omp_required_simd_align of complete types", .source =
          "struct S;struct T{int x;};\nint f(void)\n{\nreturn __builtin_omp_required_simd_align(int[]) + __builtin_omp_required_simd_align(int[3]) +\n"
          "__builtin_omp_required_simd_align(struct S*) + __builtin_omp_required_simd_align(double[2][3]) + __builtin_omp_required_simd_align(struct T) +\n"
          "__builtin_omp_required_simd_align(int(*)(void));\n}\n" },
        // clang's type traits of C (#148): an int constant in every context, of each kind of type, and an incomplete
        // record's or enumeration's error, the destructible ones' of an array's base element too.
        { .name = "generic: type traits' values and contexts", .source =
          "struct S;struct T{int x;};union U{int y;};enum E{EA};\n"
          "#define D(t, v) _Static_assert(__is_destructible(t) == v && __is_nothrow_destructible(t) == v, #t);\n"
          "#define C(t, v) _Static_assert(__is_bitwise_cloneable(t) == v, #t);\n"
          "D(int, 1) D(struct T, 1) D(union U, 1) D(enum E, 1) D(int[3], 1) D(int*, 1) D(struct S*, 1) D(_Atomic long double, 1) D(const volatile int, 1)\n"
          "D(void, 0) D(const void, 0) D(int[], 0) D(void(void), 0) D(int(*)(void), 1) D(double[2][3], 1)\n"
          "C(int, 1) C(struct T, 1) C(int[], 1) C(void(void), 1) C(void, 0) C(struct T[][2], 1) C(_Atomic int, 1) C(__int128, 1)\n"
          "_Static_assert(_Generic(__is_destructible(int), int: 1, default: 0) && _Generic(__is_bitwise_cloneable(int), int: 1, default: 0), \"\");\n"
          "enum { K = __is_destructible(int) + __is_bitwise_cloneable(void) };\nint a[__is_nothrow_destructible(int) + 1];\n"
          "static int s = __is_bitwise_cloneable(struct T);\n"
          "int f(int n)\n{\nswitch (n) { case __is_destructible(int): return __is_destructible(int[n]) + __is_bitwise_cloneable(int[n]); }\nreturn K;\n}\n" },
        { .name = "generic: is_destructible of an incomplete struct", .source = "struct S;\nint f(void)\n{\nreturn __is_destructible(struct S);\n}\n", .rejected = true },
        { .name = "generic: is_nothrow_destructible of an incomplete union", .source = "union S;\nint x =\n__is_nothrow_destructible(union S);\n",
          .rejected = true },
        { .name = "generic: is_bitwise_cloneable of an incomplete struct", .source = "struct S;\nint f(void)\n{\nreturn __is_bitwise_cloneable(struct S);\n}\n",
          .rejected = true },
        { .name = "generic: is_bitwise_cloneable of an incomplete enum", .source = "enum S;\nint f(void)\n{\nreturn __is_bitwise_cloneable(enum S);\n}\n",
          .rejected = true },
        { .name = "generic: ptrauth_type_discriminator of a type", .source = "unsigned long f(void)\n{\nreturn __builtin_ptrauth_type_discriminator(int);\n}\n",
          .rejected = true },
        { .name = "generic: ptrauth_type_discriminator in a constant", .source = "struct Z;\nenum { E =\n__builtin_ptrauth_type_discriminator(struct Z) };\n", .rejected = true },
        { .name = "generic: is_destructible of an expression", .source = "int f(int n)\n{\nreturn __is_destructible(n);\n}\n", .rejected = true },
        // __builtin_setjmp and __builtin_longjmp (#148): a buffer of five pointers, longjmp's value a constant 1 wherever the
        // call is, and buffers of other types, which clang refuses.
        { .name = "generic: setjmp and longjmp", .source =
          "void *b[5];\nvoid f(void)\n{\n__builtin_longjmp(b, 1);\n}\nint g(void)\n{\nreturn __builtin_setjmp(b);\n}\n"
          "_Static_assert(_Generic(__builtin_setjmp(b), int: 1, default: 0), \"\");\n" },
        { .name = "generic: longjmp of 2", .source = "void *b[5];\nvoid f(int n)\n{\n__builtin_longjmp(b, 2);\n}\n", .rejected = true },
        // A builtin's name in parentheses is its call's callee, which clang's call looks through (#1242's review): in a
        // constant expression and in code.
        { .name = "generic: a builtin's name in parentheses", .source =
          "_Static_assert((__builtin_popcount)(7) == 3, \"\");\n_Static_assert(((__builtin_clz))(1) == 31, \"\");\n"
          "enum { E = (__builtin_ctz)(8) };\nint f(unsigned x)\n{\nreturn (__builtin_popcount)(x) + ((__builtin_ffs))((int)x) + E;\n}\n" },
        { .name = "generic: longjmp of a variable", .source = "void *b[5];\nvoid f(int n)\n{\n__builtin_longjmp(b, n);\n}\n", .rejected = true },
        { .name = "generic: longjmp of 0 where it can't run", .source = "void *b[5];\nvoid f(void)\n{\nif (0) __builtin_longjmp(b, 0);\n}\n",
          .rejected = true },
        { .name = "generic: setjmp of an array of longs", .source = "long b[8];\nint f(void)\n{\nreturn __builtin_setjmp(b);\n}\n", .rejected = true },
        { .name = "generic: setjmp of an array of char pointers", .source = "char *b[5];\nint f(void)\n{\nreturn __builtin_setjmp(b);\n}\n", .rejected = true },
        { .name = "generic: LINE of an argument", .source = "unsigned f(void)\n{\nreturn __builtin_LINE(1);\n}\n", .rejected = true },
        { .name = "generic: complex of an int", .source = "_Complex double f(void)\n{\nreturn __builtin_complex(1, 2.0);\n}\n", .rejected = true },
        { .name = "generic: complex of an int second", .source = "_Complex double f(double x)\n{\nreturn __builtin_complex(x, 2);\n}\n", .rejected = true },
        { .name = "generic: complex of two types", .source = "_Complex double f(void)\n{\nreturn __builtin_complex(1.0f, 2.0);\n}\n", .rejected = true },
        { .name = "generic: complex of a complex", .source =
          "_Complex double f(_Complex double z)\n{\nreturn __builtin_complex(z, z);\n}\n", .rejected = true },
        { .name = "generic: complex of an atomic", .source =
          "_Atomic double a;\n_Complex double f(void)\n{\nreturn __builtin_complex(a, 1.0);\n}\n", .rejected = true },
        { .name = "generic: complex of one", .source = "_Complex double f(void)\n{\nreturn __builtin_complex(1.0);\n}\n", .rejected = true },
        { .name = "generic: complex's address", .source = "void* p = &__builtin_complex(1.0, 2.0);\n", .rejected = true },
        { .name = "generic: complex of variables in static data", .source =
          "double x;\n_Complex double z = __builtin_complex(x, 2.0);\n", .rejected = true },
        { .name = "generic: complex of a const object in static data", .source =
          "static const double c = 1.0;\n_Complex double z = __builtin_complex(c, 2.0);\n" },
        { .name = "generic: complex in a static assertion", .source = "_Static_assert(__builtin_complex(1.0, 2.0) == 1.0 + 2.0i, \"\");\n" },
        { .name = "generic: fence of an int", .source = "int f(int x)\n{\nreturn __arithmetic_fence(x);\n}\n", .rejected = true },
        { .name = "generic: fence of a pointer", .source = "double* f(double* x)\n{\nreturn __arithmetic_fence(x);\n}\n", .rejected = true },
        { .name = "generic: fence of an atomic", .source = "_Atomic double a;\ndouble f(void)\n{\nreturn __arithmetic_fence(a);\n}\n", .rejected = true },
        { .name = "generic: fence of a complex integer", .source = "_Complex int f(_Complex int z)\n{\nreturn __arithmetic_fence(z);\n}\n", .rejected = true },
        { .name = "generic: fence of an integer vector", .source = "typedef int V __attribute__((vector_size(16)));\nV f(V v)\n{\nreturn __arithmetic_fence(v);\n}\n", .rejected = true },
        { .name = "generic: fence of two", .source = "double f(double x)\n{\nreturn __arithmetic_fence(x, x);\n}\n", .rejected = true },
        { .name = "generic: fence in constant contexts", .source = "static const double c = 2.0;\nstatic double e = __arithmetic_fence(c);\n_Static_assert(__arithmetic_fence(1.0) == 1.0, \"\");\n" },
        { .name = "generic: fence of float vectors and complex values", .source = "typedef float V __attribute__((vector_size(16)));\nV f(V v, _Complex float z)\n{\nreturn __arithmetic_fence(v) + __real__ __arithmetic_fence(z);\n}\n" },
        { .name = "generic: xray of an integer for its string", .source = "void f(void)\n{\n__xray_customevent(1, 2);\n}\n", .rejected = true },
        // BPF's preserve_access_index (#148): its operand's value of its type, which clang's Sema takes of any expression, an
        // rvalue and never a constant; and HLSL's resource pointer, void(...) in C, of any arguments but void ones.
        { .name = "generic: preserve_access_index", .source =
          "struct S { int a[4]; short b; };\nvoid g(void);\nint* f(struct S* s, int x)\n{\n__builtin_preserve_access_index(g());\n"
          "_Static_assert(_Generic(__builtin_preserve_access_index(s->b), short: 1, default: 0), \"\");\n"
          "return __builtin_preserve_access_index(s->a) + *__builtin_preserve_access_index(&x);\n}\n" },
        { .name = "generic: preserve_access_index of none", .source = "int f(void)\n{\nreturn __builtin_preserve_access_index();\n}\n", .rejected = true },
        { .name = "generic: preserve_access_index of two", .source = "int f(int x)\n{\nreturn __builtin_preserve_access_index(x, x);\n}\n", .rejected = true },
        { .name = "generic: preserve_access_index's address", .source = "int* f(int x)\n{\nreturn &__builtin_preserve_access_index(x);\n}\n", .rejected = true },
        { .name = "generic: preserve_access_index assigned", .source = "void f(int x)\n{\n__builtin_preserve_access_index(x) = 3;\n}\n", .rejected = true },
        { .name = "generic: preserve_access_index in a constant", .source = "enum { E = __builtin_preserve_access_index(3) };\n", .rejected = true },
        { .name = "generic: hlsl resource pointer", .source =
          "struct S { int a; };\nvoid f(struct S s, int x)\n{\n__builtin_hlsl_resource_getpointer_typed();\n"
          "__builtin_hlsl_resource_getpointer_typed(s, 1.0f, \"x\", x++, f);\n(void)sizeof(__builtin_hlsl_resource_getpointer_typed(1));\n}\n" },
        // clear_padding (#148): a pointer as written to a complete object type that isn't const, volatile and _Atomic ones
        // and a pointer to a variable length array among them.
        { .name = "generic: clear_padding", .source =
          "struct S { char c; int i; };\nvoid f(int n, struct S* p, volatile struct S* v, _Atomic(struct S)* a, int (*q)[n], int (*r)[3])\n{\n"
          "__builtin_clear_padding(p);\n__builtin_clear_padding(v);\n__builtin_clear_padding(a);\n__builtin_clear_padding(q);\n__builtin_clear_padding(r);\n}\n" },
        { .name = "generic: clear_padding of void", .source = "void f(void* p)\n{\n__builtin_clear_padding(p);\n}\n", .rejected = true },
        { .name = "generic: clear_padding of an incomplete struct", .source = "struct S;\nvoid f(struct S* p)\n{\n__builtin_clear_padding(p);\n}\n", .rejected = true },
        { .name = "generic: clear_padding of an int", .source = "void f(int x)\n{\n__builtin_clear_padding(x);\n}\n", .rejected = true },
        { .name = "generic: clear_padding of const", .source = "void f(const int* p)\n{\n__builtin_clear_padding(p);\n}\n", .rejected = true },
        { .name = "generic: clear_padding of a function pointer", .source = "void f(int (*p)(void))\n{\n__builtin_clear_padding(p);\n}\n", .rejected = true },
        { .name = "generic: clear_padding of an array", .source = "int a[3];\nvoid f(void)\n{\n__builtin_clear_padding(a);\n}\n", .rejected = true },
        { .name = "generic: clear_padding of an incomplete array", .source = "void f(int (*q)[])\n{\n__builtin_clear_padding(q);\n}\n", .rejected = true },
        { .name = "generic: clear_padding of two", .source = "void f(int* p)\n{\n__builtin_clear_padding(p, p);\n}\n", .rejected = true },
        { .name = "generic: clear_padding's value", .source = "int f(int* p)\n{\nreturn __builtin_clear_padding(p);\n}\n", .rejected = true },
        // eh_return (#148): void(size_t, void*), which doesn't return. CFString's argument is an ordinary literal past its
        // parentheses and casts, NSString's any const char *, each a const __NSConstantString *, whose record is made
        // where an operand's evaluation reaches it first.
        { .name = "generic: eh_return and constant strings", .source =
          "enum { E = sizeof(*__builtin___NSStringMakeConstantString(\"x\")) };\nconst __NSConstantString* f(const char* s, int x)\n{\n"
          "if (x) __builtin_eh_return(x, &x);\n(void)__builtin___CFStringMakeConstantString(\"x\");\n"
          "(void)__builtin___CFStringMakeConstantString(((const char*)(\"a\" \"b\")));\n(void)sizeof(__builtin___CFStringMakeConstantString(\"\"));\n"
          "long n = __builtin___CFStringMakeConstantString(\"abc\")->length;\n__typeof__(__builtin___CFStringMakeConstantString(\"x\")) p = 0;\n"
          "(void)n;\n(void)p;\nreturn __builtin___NSStringMakeConstantString(s);\n}\n" },
        // A constant CFString of a literal is an address constant (#148): a static initializer of one, cast to long or offset,
        // and NSString's, at file scope and in a function.
        { .name = "generic: constant strings in static initializers", .source =
          "static const void* p = __builtin___CFStringMakeConstantString(\"x\");\nstatic long l = (long)__builtin___CFStringMakeConstantString(\"y\");\n"
          "static const char* q = (const char*)__builtin___CFStringMakeConstantString(\"w\") + 1;\n"
          "const void* f(void)\n{\nstatic const void* s = __builtin___NSStringMakeConstantString(\"v\");\n(void)p;\n(void)l;\n(void)q;\nreturn s;\n}\n" },
        // clang's evaluator takes any NSString call as an address constant, of no literal too (#1785), whose static data -c
        // refuses by name (c_checker_driver_test.c's code generation refusals).
        { .name = "generic: NSString of no literal in static initializers", .source =
          "static const char m[] = \"x\";\nconst char* g(void);\nstatic const void* p = __builtin___NSStringMakeConstantString(m);\n"
          "static long l = (long)__builtin___NSStringMakeConstantString(m + 1) + 2;\nstatic const void* c = __builtin___NSStringMakeConstantString(g());\n"
          "const void* f(const char* s)\n{\nstatic const void* t = __builtin___NSStringMakeConstantString(s);\n(void)p;\n(void)l;\n(void)c;\nreturn t;\n}\n" },
        { .name = "generic: NSStrings compared in a static initializer", .source =
          "static const char m[] = \"x\";\nint d = __builtin___NSStringMakeConstantString(m) == __builtin___NSStringMakeConstantString(m);\n", .rejected = true },
        { .name = "generic: eh_return of one", .source = "void f(void)\n{\n__builtin_eh_return(1);\n}\n", .rejected = true },
        { .name = "generic: eh_return of a pointer offset", .source = "void f(void)\n{\n__builtin_eh_return((void*)0, 0);\n}\n", .rejected = true },
        { .name = "generic: eh_return's value", .source = "int f(void)\n{\nreturn __builtin_eh_return(1, 0);\n}\n", .rejected = true },
        { .name = "generic: CFString of a pointer", .source = "const void* f(const char* s)\n{\nreturn __builtin___CFStringMakeConstantString(s);\n}\n", .rejected = true },
        { .name = "generic: CFString of a wide literal", .source = "const void* f(void)\n{\nreturn __builtin___CFStringMakeConstantString(L\"x\");\n}\n", .rejected = true },
        { .name = "generic: CFString of a UTF-8 literal", .source = "const void* f(void)\n{\nreturn __builtin___CFStringMakeConstantString(\"a\" u8\"x\");\n}\n", .rejected = true },
        { .name = "generic: CFString of __func__", .source = "const void* f(void)\n{\nreturn __builtin___CFStringMakeConstantString(__func__);\n}\n", .rejected = true },
        { .name = "generic: CFString of none", .source = "const void* f(void)\n{\nreturn __builtin___CFStringMakeConstantString();\n}\n", .rejected = true },
        { .name = "generic: CFString as an int", .source = "int f(void)\n{\nreturn __builtin___CFStringMakeConstantString(\"x\");\n}\n", .rejected = true },
        { .name = "generic: NSString of an int", .source = "const void* f(int x)\n{\nreturn __builtin___NSStringMakeConstantString(x);\n}\n", .rejected = true },
        // The Microsoft and z/OS lists (#148): each ms builtin's list an lvalue of exactly char * (clang's char *&), and
        // va_arg's where it is one; ms_va_start in an ms_abi variadic function alone, every other start out of one;
        // z/OS's lists char ** parameters.
        { .name = "generic: Microsoft and z/OS lists", .source =
          "int __attribute__((ms_abi)) f(int n, ...)\n{\n__builtin_ms_va_list a, b;\n__builtin_ms_va_start(a, n);\n__builtin_ms_va_copy(b, a);\n"
          "int x = __builtin_va_arg(b, int);\n__builtin_ms_va_end(b);\n__builtin_ms_va_end(a);\n__builtin_va_list s;\n__builtin_va_copy(s, s);\nreturn x;\n}\n"
          "int g(char* p, char** q, int n, ...)\n{\nchar* c[1];\n__builtin_ms_va_copy(c[0], *q);\n__builtin_ms_va_end(p);\nchar* z;\n"
          "__builtin_zos_va_start(&z, n);\n__builtin_zos_va_copy(q, &z);\n__builtin_zos_va_end(q);\nreturn __builtin_va_arg(p, int) + __builtin_va_arg(*q, int);\n}\n" },
        { .name = "generic: ms_va_start out of ms_abi", .source = "void f(int n, ...)\n{\nchar* a;\n__builtin_ms_va_start(a, n);\n}\n", .rejected = true },
        { .name = "generic: va_start in ms_abi", .source = "void __attribute__((ms_abi)) f(int n, ...)\n{\n__builtin_va_list a;\n__builtin_va_start(a, n);\n}\n", .rejected = true },
        { .name = "generic: zos_va_start in ms_abi", .source = "void __attribute__((ms_abi)) f(int n, ...)\n{\nchar* a;\n__builtin_zos_va_start(&a, n);\n}\n", .rejected = true },
        { .name = "generic: ms_va_start with fixed args", .source = "void __attribute__((ms_abi)) f(int n)\n{\nchar* a;\n__builtin_ms_va_start(a, n);\n}\n", .rejected = true },
        { .name = "generic: ms_va_end of a const list", .source = "void f(char* const a)\n{\n__builtin_ms_va_end(a);\n}\n", .rejected = true },
        { .name = "generic: ms_va_end of an unsigned char pointer", .source = "void f(unsigned char* a)\n{\n__builtin_ms_va_end(a);\n}\n", .rejected = true },
        { .name = "generic: ms_va_copy of a temporary", .source = "void f(char* a)\n{\n__builtin_ms_va_copy(a, a + 1);\n}\n", .rejected = true },
        { .name = "generic: ms_va_copy of a const char pointer", .source = "void f(char* a, const char* b)\n{\n__builtin_ms_va_copy(a, b);\n}\n", .rejected = true },
        { .name = "generic: va_arg of a const char pointer", .source = "int f(const char* a)\n{\nreturn __builtin_va_arg(a, int);\n}\n", .rejected = true },
        { .name = "generic: va_arg of a char pointer temporary", .source = "int f(char* a)\n{\nreturn __builtin_va_arg(a + 0, int);\n}\n", .rejected = true },
        { .name = "generic: zos_va_start of a void list", .source = "void f(int n, ...)\n{\nvoid* a;\n__builtin_zos_va_start(&a, n);\n}\n", .rejected = true },
        { .name = "generic: zos_va_start with fixed args", .source = "void f(int n)\n{\nchar* a;\n__builtin_zos_va_start(&a, n);\n}\n", .rejected = true },
        { .name = "generic: zos_va_copy of one", .source = "void f(char** a)\n{\n__builtin_zos_va_copy(a);\n}\n", .rejected = true },
        { .name = "generic: zos_va_end's value", .source = "int f(char** a)\n{\nreturn __builtin_zos_va_end(a);\n}\n", .rejected = true },
        // infer_alloc_token (#148): a size_t of arguments that never run, an integer constant expression of the type a
        // sizeof among them gives (through groupings and + - * / << >>, or a variable's initializer), LLVM's SipHash of
        // its name without tag keywords, past half the tokens for a type holding a pointer (uintptr_t's typedef chain
        // too, a member's included); no constant where no type is inferred.
        { .name = "generic: infer_alloc_token", .source =
          "typedef unsigned long uintptr_t;\ntypedef uintptr_t handle;\nstruct S { int a; char* p; };\nstruct W { handle h; };\n"
          "struct Q { int a[3]; long b; };\ntypedef struct { short s; } TS;\n"
          "_Static_assert(__builtin_infer_alloc_token(sizeof(int)) == 2689373973731826898u, \"\");\n"
          "_Static_assert(__builtin_infer_alloc_token(sizeof(struct S)) == 9965185003513084084u, \"\");\n"
          "_Static_assert(__builtin_infer_alloc_token(sizeof(char*) * 4) == 11473864704255292954u, \"\");\n"
          "_Static_assert(__builtin_infer_alloc_token(3 + sizeof(TS)) == 2947234827507279461u, \"\");\n"
          "_Static_assert(__builtin_infer_alloc_token(sizeof(struct W)) > 9223372036854775807u, \"\");\n"
          "_Static_assert(__builtin_infer_alloc_token(sizeof(uintptr_t)) > 9223372036854775807u, \"\");\n"
          "_Static_assert(__builtin_infer_alloc_token(sizeof(struct Q)) == 6602487442970685230u, \"\");\n"
          "_Static_assert(sizeof(__builtin_infer_alloc_token(1)) == 8, \"\");\nenum { E = __builtin_infer_alloc_token(sizeof(int[4])) != 0 };\n"
          "unsigned long f(int i)\n{\nunsigned long s = sizeof(struct Q) * 2;\nstatic unsigned long t = __builtin_infer_alloc_token(sizeof(_Bool));\n"
          "return __builtin_infer_alloc_token(i++, sizeof(char)) + __builtin_infer_alloc_token(s) + __builtin_infer_alloc_token(i) + t;\n}\n" },
        // call_with_static_chain (#148): a call as written of no builtin (a catalog one, a header's leaf or a library
        // builtin's external declaration), the call's value, and a pointer chain.
        { .name = "generic: call_with_static_chain", .source =
          "struct S { int a[4]; };\nint f(int);\nstruct S h(void);\nstatic int abs(int x) { return x; }\nvoid v(void);\n"
          "int g(void* p, char* q, int (*k)(int, ...))\n{\nstruct S s = __builtin_call_with_static_chain(h(), q);\n"
          "__builtin_call_with_static_chain(v(), p);\n(void)sizeof(__builtin_call_with_static_chain(f(1), p));\n"
          "return __builtin_call_with_static_chain(f(1), p) + __builtin_call_with_static_chain((*k)(1, 2.0), p++) + s.a[0] +\n"
          "__builtin_call_with_static_chain(abs(2), p);\n}\n" },
        { .name = "generic: call_with_static_chain of a name", .source = "int f(int);\nint g(void* p)\n{\nreturn __builtin_call_with_static_chain(f, p);\n}\n", .rejected = true },
        { .name = "generic: call_with_static_chain of a grouping", .source = "int f(int);\nint g(void* p)\n{\nreturn __builtin_call_with_static_chain((f(1)), p);\n}\n", .rejected = true },
        { .name = "generic: call_with_static_chain of a builtin", .source = "int g(void* p)\n{\nreturn __builtin_call_with_static_chain(__builtin_abs(1), p);\n}\n", .rejected = true },
        { .name = "generic: call_with_static_chain of a library builtin", .source = "unsigned long strlen(const char*);\nunsigned long g(void* p)\n{\nreturn __builtin_call_with_static_chain(strlen(\"x\"), p);\n}\n", .rejected = true },
        { .name = "generic: call_with_static_chain of an int chain", .source = "int f(int);\nint g(int p)\n{\nreturn __builtin_call_with_static_chain(f(1), p);\n}\n", .rejected = true },
        { .name = "generic: call_with_static_chain of a null constant", .source = "int f(int);\nint g(void)\n{\nreturn __builtin_call_with_static_chain(f(1), 0);\n}\n", .rejected = true },
        { .name = "generic: call_with_static_chain of one", .source = "int f(int);\nint g(void)\n{\nreturn __builtin_call_with_static_chain(f(1));\n}\n", .rejected = true },
        // The os_log builtins (#148): a buffer that converts to void *, a format that is an ordinary or UTF-8 literal past its
        // parentheses and casts, data of less than 256 bytes each; the buffer's size a size_t integer constant expression of
        // the layout, whatever its data's types; __builtin_os_log_format's format checks refusing a struct or a complex
        // value a specifier takes and a mask of other than 1 to 8 bytes, one after a %P without its length too (the checks go
        // on past it, as the layout doesn't); escaped percent signs, and specifiers past the format's NUL, of no items (#1329);
        // and a %P without its length whose positional width has no argument, the pointer's item alone (#1335's review).
        { .name = "generic: os_log", .source =
          "struct S { int a; };\n_Static_assert(__builtin_os_log_format_buffer_size(\"%d %s\", 1, \"x\") == 18, \"\");\n"
          "enum { E = __builtin_os_log_format_buffer_size(\"%{mask.ab}d %m\", 1) };\n_Static_assert(E == 20, \"\");\n"
          "_Static_assert(__builtin_os_log_format_buffer_size(\"%Lf %P\", 1.0L, 1) == 26, \"\");\n"
          "_Static_assert(__builtin_os_log_format_buffer_size(\"%2$s %1$d\", 1, \"x\") == 18, \"\");\n"
          "_Static_assert(__builtin_os_log_format_buffer_size(\"%.*s %{public, mask.abcdefghij}d\", 3, \"x\", 1, 2) == 34, \"\");\n"
          "_Static_assert(__builtin_os_log_format_buffer_size(u8\"%d\", (struct S){ 1 }) == 8, \"\");\n"
          "_Static_assert(__builtin_os_log_format_buffer_size(\"%f %f %f\", (_Float16)1, (__bf16)1, (__fp16)1) == 20, \"\");\n"
          "_Static_assert(__builtin_os_log_format_buffer_size(\"%Lf %d %d\", 1.0L, (__int128)1, (_BitInt(72))1) == 56, \"\");\n"
          "void* f(void* b, char* c, int i, struct S s)\n{\nunsigned long n = __builtin_os_log_format_buffer_size(\"%d\", i++);\n"
          "(void)__builtin_os_log_format(c, (\"%d\"), i);\n(void)__builtin_os_log_format(b, (const char*)\"%s %f\", \"x\", 1.5f);\n"
          "(void)__builtin_os_log_format(b, \"%d\", 1, s);\n(void)__builtin_os_log_format(b, \"%P %{mask.ab}d\", n, 1);\n"
          "return __builtin_os_log_format(b, \"%{private}s %%\", \"x\");\n}\n"
          "_Static_assert(__builtin_os_log_format_buffer_size(\"%%%%%% %d\\0%d%s\", 1) == 8, \"\");\n"
          "_Static_assert(__builtin_os_log_format_buffer_size(\"\\0%d%d%d%d\") == 2 && __builtin_os_log_format_buffer_size(\"%% %5% %{public}% %%%%\") == 2, \"\");\n"
          "_Static_assert(__builtin_os_log_format_buffer_size(\"%1$*2$P\", (void*)0) == 12, \"\");\n" },
        { .name = "generic: os_log of an int buffer", .source = "void* f(int b)\n{\nreturn __builtin_os_log_format(b, \"%d\", 1);\n}\n", .rejected = true },
        { .name = "generic: os_log of a pointer format", .source = "void* f(void* b, const char* s)\n{\nreturn __builtin_os_log_format(b, s);\n}\n", .rejected = true },
        { .name = "generic: os_log of a wide format", .source = "unsigned long f(void)\n{\nreturn __builtin_os_log_format_buffer_size(L\"x\");\n}\n", .rejected = true },
        { .name = "generic: os_log of a struct", .source = "struct S { int a; };\nvoid* f(void* b, struct S s)\n{\nreturn __builtin_os_log_format(b, \"%d\", s);\n}\n", .rejected = true },
        { .name = "generic: os_log of a complex width", .source = "void* f(void* b, _Complex double c)\n{\nreturn __builtin_os_log_format(b, \"%*d\", c, 1);\n}\n", .rejected = true },
        { .name = "generic: os_log of a long mask", .source = "void* f(void* b)\n{\nreturn __builtin_os_log_format(b, \"%{mask.abcdefghi}d\", 1);\n}\n", .rejected = true },
        { .name = "generic: os_log of a long mask after an unlengthened pointer", .source = "void* f(void* b)\n{\nreturn __builtin_os_log_format(b, \"%P %{mask.abcdefghi}d\", 4, 1);\n}\n", .rejected = true },
        { .name = "generic: os_log of an empty mask", .source = "void* f(void* b)\n{\nreturn __builtin_os_log_format(b, \"%{mask.}d\", 1);\n}\n", .rejected = true },
        { .name = "generic: os_log of a big argument", .source = "struct T { char c[300]; };\nunsigned long f(struct T t)\n{\nreturn __builtin_os_log_format_buffer_size(\"%d\", t);\n}\n", .rejected = true },
        { .name = "generic: os_log of no buffer", .source = "void* f(void)\n{\nreturn __builtin_os_log_format(\"%d\");\n}\n", .rejected = true },
        { .name = "generic: os_log of no format", .source = "unsigned long f(void)\n{\nreturn __builtin_os_log_format_buffer_size();\n}\n", .rejected = true },
        // Up to 255 data arguments past the operands' 32-bit mask, as clang's BuiltinOSLogFormat takes them, and no more (#1785).
        { .name = "generic: os_log of 255 data arguments", .source =
          "#define A8 1, 2, 3, 4, 5, 6, 7, 8\n#define A64 A8, A8, A8, A8, A8, A8, A8, A8\n#define A255 A64, A64, A64, A8, A8, A8, A8, A8, A8, A8, 1, 2, 3, 4, 5, 6, 7\n"
          "#define F8 \"%d %d %d %d %d %d %d %d \"\n#define F64 F8 F8 F8 F8 F8 F8 F8 F8\n"
          "_Static_assert(__builtin_os_log_format_buffer_size(F64 F64 F64 F8 F8 F8 F8 F8 F8 F8 \"%d %d %d %d %d %d %d\", A255) == 1532, \"\");\n"
          "_Static_assert(__builtin_os_log_format_buffer_size(\"%255$lld %40$d\", A255) == 14, \"\");\n"
          "void* f(void* b, int n)\n{\nreturn __builtin_os_log_format(b, F8 F8 F8 F8 \"%d %d %s\", A8, A8, A8, A8, n, n + 1, \"x\");\n}\n"
          "void* g(void* b)\n{\nreturn __builtin_os_log_format(b, \"%d\", A255);\n}\n" },
        { .name = "generic: os_log of 256 data arguments", .source =
          "#define A8 1, 2, 3, 4, 5, 6, 7, 8\n#define A64 A8, A8, A8, A8, A8, A8, A8, A8\nunsigned long f(void)\n{\n"
          "return __builtin_os_log_format_buffer_size(\"%d\", A64, A64, A64, A64);\n}\n", .rejected = true },
        { .name = "generic: os_log_format of 256 data arguments", .source =
          "#define A8 1, 2, 3, 4, 5, 6, 7, 8\n#define A64 A8, A8, A8, A8, A8, A8, A8, A8\nvoid* f(void* b)\n{\n"
          "return __builtin_os_log_format(b, \"%d\", A64, A64, A64, A64);\n}\n", .rejected = true },
        // dump_struct (#148): a pointer to a complete struct or union and a function or a function pointer that takes clang's
        // generated calls (variadic past the rest of the arguments and the format, or without a prototype).
        { .name = "generic: dump_struct", .source =
          "int printf(const char*, ...);\nint pf(void* ctx, const char* f, ...);\nint kr();\nstruct S { int a; unsigned b : 2; struct { char c; } in; int arr[2]; };\n"
          "union U { int a; };\nvoid f(struct S* s, const union U* u, int (*p)(const char*, ...))\n{\n__builtin_dump_struct(s, printf);\n"
          "__builtin_dump_struct(u, p);\n__builtin_dump_struct((s), (printf));\n__builtin_dump_struct(s, pf, (void*)0);\n__builtin_dump_struct(s, pf, s);\n"
          "__builtin_dump_struct(s, kr, 1, 2.0);\n}\n" },
        { .name = "generic: dump_struct of a struct", .source = "int printf(const char*, ...);\nstruct S { int a; };\nvoid f(struct S s)\n{\n__builtin_dump_struct(s, printf);\n}\n", .rejected = true },
        { .name = "generic: dump_struct of an int pointer", .source = "int printf(const char*, ...);\nvoid f(int* p)\n{\n__builtin_dump_struct(p, printf);\n}\n", .rejected = true },
        { .name = "generic: dump_struct of an incomplete struct", .source = "int printf(const char*, ...);\nstruct I;\nvoid f(struct I* p)\n{\n__builtin_dump_struct(p, printf);\n}\n", .rejected = true },
        { .name = "generic: dump_struct of no callable", .source = "struct S { int a; };\nvoid f(struct S* s)\n{\n__builtin_dump_struct(s, 1);\n}\n", .rejected = true },
        { .name = "generic: dump_struct of a fixed printer", .source = "int bad(const char*);\nstruct S { int a; };\nvoid f(struct S* s)\n{\n__builtin_dump_struct(s, bad);\n}\n", .rejected = true },
        { .name = "generic: dump_struct of a missing context", .source = "int pf(void* ctx, const char* f, ...);\nstruct S { int a; };\nvoid f(struct S* s)\n{\n__builtin_dump_struct(s, pf);\n}\n", .rejected = true },
        { .name = "generic: dump_struct of a wrong context", .source = "int pf(int* ctx, const char* f, ...);\nstruct S { int a; };\nvoid f(struct S* s, long* l)\n{\n__builtin_dump_struct(s, pf, l);\n}\n", .rejected = true },
        { .name = "generic: dump_struct of an int format", .source = "int pf(void* ctx, int f, ...);\nstruct S { int a; };\nvoid f(struct S* s)\n{\n__builtin_dump_struct(s, pf, s);\n}\n", .rejected = true },
        { .name = "generic: dump_struct of a _BitInt bit-field", .source = "int printf(const char*, ...);\nstruct S { _BitInt(12) b : 9; };\nvoid f(struct S* s)\n{\n__builtin_dump_struct(s, printf);\n}\n", .rejected = true },
        { .name = "generic: dump_struct of a nested __int128 bit-field", .source = "int printf(const char*, ...);\nstruct S { struct { __int128 w : 70; } in; };\nvoid f(struct S* s)\n{\n__builtin_dump_struct(s, printf);\n}\n", .rejected = true },
        // The bit-field after more sibling records than the walk's 64 levels of nesting (#1405's review).
        { .name = "generic: dump_struct of a bit-field after 65 sibling records", .source = "int printf(const char*, ...);\nstruct S { struct { int x; } f0; struct { int x; } f1; struct { int x; } f2; struct { int x; } f3; struct { int x; } f4; struct { int x; } f5; struct { int x; } f6; struct { int x; } f7; struct { int x; } f8; struct { int x; } f9; struct { int x; } f10; struct { int x; } f11; struct { int x; } f12; struct { int x; } f13; struct { int x; } f14; struct { int x; } f15; struct { int x; } f16; struct { int x; } f17; struct { int x; } f18; struct { int x; } f19; struct { int x; } f20; struct { int x; } f21; struct { int x; } f22; struct { int x; } f23; struct { int x; } f24; struct { int x; } f25; struct { int x; } f26; struct { int x; } f27; struct { int x; } f28; struct { int x; } f29; struct { int x; } f30; struct { int x; } f31; struct { int x; } f32; struct { int x; } f33; struct { int x; } f34; struct { int x; } f35; struct { int x; } f36; struct { int x; } f37; struct { int x; } f38; struct { int x; } f39; struct { int x; } f40; struct { int x; } f41; struct { int x; } f42; struct { int x; } f43; struct { int x; } f44; struct { int x; } f45; struct { int x; } f46; struct { int x; } f47; struct { int x; } f48; struct { int x; } f49; struct { int x; } f50; struct { int x; } f51; struct { int x; } f52; struct { int x; } f53; struct { int x; } f54; struct { int x; } f55; struct { int x; } f56; struct { int x; } f57; struct { int x; } f58; struct { int x; } f59; struct { int x; } f60; struct { int x; } f61; struct { int x; } f62; struct { int x; } f63; struct { int x; } f64; "
          "struct { _BitInt(12) bad : 9; } last; };\nvoid f(struct S* s)\n{\n__builtin_dump_struct(s, printf);\n}\n", .rejected = true },
        { .name = "generic: dump_struct's value", .source = "int printf(const char*, ...);\nstruct S { int a; };\nint f(struct S* s)\n{\nreturn __builtin_dump_struct(s, printf);\n}\n", .rejected = true },
        // clang's counted_by family (#148): on flexible array members and pointers, wherever written, its count a member
        // declared before it (an enclosing record's through an anonymous one); __builtin_counted_by_ref a pointer to it,
        // or a void * of a member of none, in sizeof, typeof and _Generic too, and its value stored through.
        { .name = "generic: counted_by", .source =
          "struct S { long n; int fam[] __attribute__((counted_by(n))); };\n"
          "struct P { int k; char *p __attribute__((sized_by(k))); int * __attribute__((counted_by(k))) q; void *v __attribute__((counted_by_or_null(k))); };\n"
          "struct N { int k; struct { int x; char fam[] __attribute__((counted_by(k))); }; };\n"
          "struct Q { int n; int fam[]; };\n"
          "_Static_assert(_Generic(__builtin_counted_by_ref(((struct S *)0)->fam), long *: 1, default: 0), \"\");\n"
          "int f(struct S *s, struct P *p, struct N *m, struct Q *q)\n{\n"
          "*__builtin_counted_by_ref(s->fam) = 3;\n*__builtin_counted_by_ref(p->q) = 4;\n*__builtin_counted_by_ref(m->fam) = 5;\n"
          "typeof(__builtin_counted_by_ref(p->p)) v = (void *)__builtin_counted_by_ref(q->fam);\n(void)v;\n"
          "return (int)sizeof(*__builtin_counted_by_ref((s)->fam)) + (int)__builtin_dynamic_object_size(s->fam, 0);\n}\n" },
        { .name = "generic: counted_by of a later member", .source = "struct S { int fam[] __attribute__((counted_by(n))); int n; };\n", .rejected = true },
        { .name = "generic: counted_by of a bool", .source = "struct S { _Bool n; int fam[] __attribute__((counted_by(n))); };\n", .rejected = true },
        { .name = "generic: counted_by on an int", .source = "struct S { int n; int x __attribute__((counted_by(n))); };\n", .rejected = true },
        { .name = "generic: counted_by in a union", .source = "union U { int n; int *p __attribute__((counted_by(n))); };\n", .rejected = true },
        { .name = "generic: sized_by on an array", .source = "struct S { int n; char fam[] __attribute__((sized_by(n))); };\n", .rejected = true },
        { .name = "generic: counted_by_ref returned", .source = "struct S { int n; int fam[] __attribute__((counted_by(n))); };\nint *f(struct S *s)\n{\nreturn __builtin_counted_by_ref(s->fam);\n}\n", .rejected = true },
        { .name = "generic: counted_by_ref of no member", .source = "void f(int *p)\n{\n(void)__builtin_counted_by_ref(p);\n}\n", .rejected = true },
        // __builtin_available (#148): a _Bool of no constant expression, its specs names and numbers of nothing of the
        // unit's, a typedef's name among them; a spec's error and the list's, at file scope and in a function.
        { .name = "generic: available", .source =
          "typedef int macos;\nint s = sizeof(__builtin_available(*));\ntypeof(__builtin_available(ios 10, *)) t;\n"
          "_Static_assert(_Generic(__builtin_available(*), _Bool: 1, default: 0), \"\");\nint f(int x)\n{\n"
          "if (__builtin_available(macos 10.12, iOS 10_3, watchOS 3.1.2, *)) x += 1;\nif (!__builtin_available(*)) x += 2;\n"
          "_Bool b = __builtin_available(android 21, *);\nint a[__builtin_available(*) + 1];\n"
          "return x + b + (int)sizeof a + __builtin_available(anyAppleOS 26.1, *);\n}\n" },
        { .name = "generic: available of no version", .source = "int f(void)\n{\nreturn __builtin_available(macos x, *);\n}\n", .rejected = true },
        { .name = "generic: available of an unknown platform", .source = "int f(void)\n{\nreturn __builtin_available(linuxos 1, *);\n}\n", .rejected = true },
        { .name = "generic: available of a zero version", .source = "int f(void)\n{\nreturn __builtin_available(macos 0.0, *);\n}\n", .rejected = true },
        { .name = "generic: available without a star", .source = "int f(void)\n{\nreturn __builtin_available(macos 1);\n}\n", .rejected = true },
        { .name = "generic: available of a repeated platform", .source = "int f(void)\n{\nreturn __builtin_available(macos 1, macosx 2, *);\n}\n", .rejected = true },
        { .name = "generic: available of an old anyAppleOS", .source = "int f(void)\n{\nreturn __builtin_available(anyAppleOS 25, *);\n}\n", .rejected = true },
        { .name = "generic: available as a constant", .source = "enum { E = __builtin_available(*) };\n", .rejected = true },
        { .name = "generic: available's static", .source = "static int v = __builtin_available(*);\n", .rejected = true },
        { .name = "generic: infer_alloc_token of none", .source = "unsigned long f(void)\n{\nreturn __builtin_infer_alloc_token();\n}\n", .rejected = true },
        { .name = "generic: infer_alloc_token of void", .source = "unsigned long f(void)\n{\nreturn __builtin_infer_alloc_token((void)0);\n}\n", .rejected = true },
        { .name = "generic: infer_alloc_token of no type", .source = "_Static_assert(__builtin_infer_alloc_token(1) == 0, \"\");\n", .rejected = true },
        { .name = "generic: infer_alloc_token of a cast", .source = "_Static_assert(__builtin_infer_alloc_token((unsigned long)sizeof(int)) != 1, \"\");\n", .rejected = true },
        { .name = "generic: infer_alloc_token's static", .source = "void f(void)\n{\nstatic unsigned long t = __builtin_infer_alloc_token(3);\n}\n", .rejected = true },
        // __builtin_invoke(f, a...) is the call f(a...) in C (#148): of a function, a pointer to one and a member of one,
        // with a prototype's conversions and a variadic one's promotions; its errors are the call's.
        { .name = "generic: invoke", .source =
          "int g(int);\nint v(int, ...);\nint (*p)(int) = g;\nstruct S { int (*fn)(int); };\nlong f(struct S s)\n{\n"
          "_Static_assert(_Generic(__builtin_invoke(g, 1), int: 1, default: 0), \"\");\n"
          "return __builtin_invoke(g, 1.5) + __builtin_invoke(p, 2) + __builtin_invoke(*p, 3) + __builtin_invoke(s.fn, 4) + __builtin_invoke(&g, 5) + __builtin_invoke(v, 1, 2.0f, \"x\");\n}\n" },
        { .name = "generic: invoke of none", .source = "int f(void)\n{\nreturn __builtin_invoke();\n}\n", .rejected = true },
        { .name = "generic: invoke of too many", .source = "int g(int);\nint f(void)\n{\nreturn __builtin_invoke(g, 1, 2);\n}\n", .rejected = true },
        { .name = "generic: invoke of too few", .source = "int g(int);\nint f(void)\n{\nreturn __builtin_invoke(g);\n}\n", .rejected = true },
        { .name = "generic: invoke of an int", .source = "int f(int x)\n{\nreturn __builtin_invoke(x, 1);\n}\n", .rejected = true },
        { .name = "generic: invoke's address", .source = "void* h = __builtin_invoke;\n", .rejected = true },
        // Any builtin's name that no call takes is clang's "builtin functions must be directly called".
        { .name = "generic: a builtin's address", .source = "int (*p)(unsigned) = &__builtin_popcount;\n", .rejected = true },
        { .name = "generic: a builtin's value", .source = "void f(void)\n{\n(void)__builtin_trap;\n}\n", .rejected = true },
        { .name = "generic: invoke in a constant", .source = "int g(int);\nenum { E = __builtin_invoke(g, 1) };\n", .rejected = true },
        { .name = "generic: hlsl resource pointer of void", .source = "void g(void);\nvoid f(void)\n{\n__builtin_hlsl_resource_getpointer_typed(g());\n}\n", .rejected = true },
        { .name = "generic: hlsl resource pointer's value", .source = "int* f(void)\n{\nreturn __builtin_hlsl_resource_getpointer_typed();\n}\n", .rejected = true },
        { .name = "generic: xray typed event of two", .source = "void f(void)\n{\n__xray_typedevent(1, \"x\");\n}\n", .rejected = true },
        { .name = "generic: warn_memset_zero_len of one", .source = "void f(void)\n{\n__warn_memset_zero_len(1);\n}\n", .rejected = true },
        { .name = "generic: relocate of const", .source = "void f(const int* a, const int* b)\n{\n__builtin_trivially_relocate(a, b, 1);\n}\n", .rejected = true },
        { .name = "generic: relocate of a struct", .source = "struct S { int x; };\nvoid f(struct S* a, struct S* b)\n{\n__builtin_trivially_relocate(a, b, 1);\n}\n", .rejected = true },
        { .name = "generic: relocate of an atomic", .source = "void f(_Atomic int* a, _Atomic int* b)\n{\n__builtin_trivially_relocate(a, b, 1);\n}\n", .rejected = true },
        { .name = "generic: relocate of an array", .source = "int x[4], y[4];\nvoid f(void)\n{\n__builtin_trivially_relocate(x, y, 1);\n}\n", .rejected = true },
        { .name = "generic: relocate of two types", .source = "void f(int* a, long* b)\n{\n__builtin_trivially_relocate(a, b, 1);\n}\n", .rejected = true },
        { .name = "generic: relocate of a pointer and an array", .source = "void f(int* a)\n{\nint c[2];\n__builtin_trivially_relocate(a, c, 1);\n}\n", .rejected = true },
        { .name = "generic: relocate of void", .source = "void f(void* a, void* b)\n{\n__builtin_trivially_relocate(a, b, 1);\n}\n", .rejected = true },
        { .name = "generic: relocate of a pointer size", .source = "void f(int* a, int* b)\n{\n__builtin_trivially_relocate(a, b, (void*)0);\n}\n", .rejected = true },
        { .name = "generic: relocate of enums, arrays and vectors", .source = "enum E { X };\ntypedef int V __attribute__((vector_size(16)));\nvoid f(enum E* a, enum E* b, int (*c)[3], int (*d)[3], V* v, V* w)\n{\n__builtin_trivially_relocate(a, b, 1.5);\n__builtin_trivially_relocate(c, d, 1);\n__builtin_trivially_relocate(v, w, 1);\n}\n" },
        { .name = "generic: operator_new in C", .source = "void* f(void)\n{\nreturn __builtin_operator_new(4);\n}\n", .rejected = true },
        { .name = "generic: operator_delete in C", .source = "void f(void* p)\n{\n__builtin_operator_delete(p);\n}\n", .rejected = true },
        // More arguments than the operands' 32-bit mask has bits: refused before the mask is made (#1126's review).
        { .name = "generic: operator_new of 33 arguments", .source = "void* f(void)\n{\nreturn __builtin_operator_new(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);\n}\n", .rejected = true },
        { .name = "generic: operator_delete of 33 arguments", .source = "void f(void)\n{\n__builtin_operator_delete(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);\n}\n", .rejected = true },
        { .name = "generic: ptrauth_auth", .source = "void* f(void* p)\n{\nreturn __builtin_ptrauth_auth(p, 0, 0);\n}\n", .rejected = true },
        { .name = "generic: ptrauth_auth_and_resign", .source = "void* f(void* p)\n{\nreturn __builtin_ptrauth_auth_and_resign(p, 0, 0, 0, 0);\n}\n", .rejected = true },
        { .name = "generic: ptrauth_auth_load_relative_and_sign", .source = "void* f(void* p)\n{\nreturn __builtin_ptrauth_auth_load_relative_and_sign(p, 0, 0, 0, 0, 0);\n}\n", .rejected = true },
        { .name = "generic: ptrauth_auth_with_pc_and_resign", .source = "void* f(void* p)\n{\nreturn __builtin_ptrauth_auth_with_pc_and_resign(p, 0, 0, 0, 0, 0);\n}\n", .rejected = true },
        { .name = "generic: ptrauth_blend_discriminator", .source = "long f(void* p)\n{\nreturn __builtin_ptrauth_blend_discriminator(p, 0);\n}\n", .rejected = true },
        { .name = "generic: ptrauth_sign_constant", .source = "void g(void);\nvoid* f(void)\n{\nreturn __builtin_ptrauth_sign_constant(&g, 0, 0);\n}\n", .rejected = true },
        { .name = "generic: ptrauth_sign_generic_data", .source = "long f(void* p)\n{\nreturn __builtin_ptrauth_sign_generic_data(p, 0);\n}\n", .rejected = true },
        { .name = "generic: ptrauth_sign_unauthenticated", .source = "void* f(void* p)\n{\nreturn __builtin_ptrauth_sign_unauthenticated(p, 0, 0);\n}\n", .rejected = true },
        { .name = "generic: ptrauth_string_discriminator", .source = "static unsigned long x = __builtin_ptrauth_string_discriminator(\"abc\");\n", .rejected = true },
        { .name = "generic: ptrauth_strip", .source = "void* f(void* p)\n{\nreturn __builtin_ptrauth_strip(p, 0);\n}\n", .rejected = true },
        { .name = "generic: cpu_is of an unknown name", .source = "int f(void)\n{\nreturn __builtin_cpu_is(\"bogus\");\n}\n", .rejected = true },
        { .name = "generic: cpu_is of a vendor's two", .source = "int f(void)\n{\nreturn __builtin_cpu_is(\"intel\", 1);\n}\n", .rejected = true },
        { .name = "generic: cpu_is of a wide string", .source = "int f(void)\n{\nreturn __builtin_cpu_is(L\"intel\");\n}\n", .rejected = true },
        { .name = "generic: cpu_supports of a variable", .source = "int f(const char* p)\n{\nreturn __builtin_cpu_supports(p);\n}\n", .rejected = true },
        { .name = "generic: cpu_supports in static data", .source = "static int x = __builtin_cpu_supports(\"avx\");\n", .rejected = true },
        { .name = "generic: cpu_supports in a static assertion", .source = "_Static_assert(__builtin_cpu_supports(\"avx\") || 1, \"\");\n", .rejected = true },
        { .name = "generic: cpu_supports of an unknown feature", .source = "int f(void)\n{\nreturn __builtin_cpu_supports(\"not-a-feature\") + __builtin_cpu_supports((\"avx\"));\n}\n" },
        // The literal-only arguments refuse an explicit cast, which annotation's string takes, and accept parentheses (#1126's review).
        { .name = "generic: allow_sanitize_check of a cast literal", .source =
          "int f(void)\n{\nreturn __builtin_allow_sanitize_check((const char*)\"address\");\n}\n", .rejected = true },
        { .name = "generic: allow_runtime_check of a cast literal", .source =
          "int f(void)\n{\nreturn __builtin_allow_runtime_check(((const char*)\"feature\"));\n}\n", .rejected = true },
        { .name = "generic: cpu_supports of a cast literal", .source =
          "int f(void)\n{\nreturn __builtin_cpu_supports((const char*)\"sse2\");\n}\n", .rejected = true },
        { .name = "generic: cpu_supports of a void pointer literal", .source =
          "int f(void)\n{\nreturn __builtin_cpu_supports((void*)\"sse2\");\n}\n", .rejected = true },
        { .name = "generic: cpu_is of a cast literal", .source = "int f(void)\n{\nreturn __builtin_cpu_is((char*)\"amd\");\n}\n", .rejected = true },
        { .name = "generic: cpu_is of a cast parenthesized literal", .source =
          "int f(void)\n{\nreturn __builtin_cpu_is((const char*)(\"amd\"));\n}\n", .rejected = true },
        { .name = "generic: literal-only arguments in parentheses", .source =
          "long f(void)\n{\nreturn __builtin_cpu_is((\"amd\")) + __builtin_cpu_supports(((\"sse2\"))) + __builtin_allow_sanitize_check((\"address\")) +\n"
          "__builtin_allow_runtime_check((\"x\")) + __builtin_annotation(3L, (const char*)\"note\") + __builtin_annotation(4L, (\"note\"));\n}\n" },
        { .name = "generic: cpu_init of an argument", .source = "void f(void)\n{\n__builtin_cpu_init(1);\n}\n", .rejected = true },
        { .name = "generic: cpu_init's value", .source = "int f(void)\n{\nreturn __builtin_cpu_init();\n}\n", .rejected = true },
        { .name = "generic: complex of qualified and aligned operands", .source =
          "typedef double D __attribute__((aligned(16)));\nvolatile D v;\nconst double c;\n_Complex double f(void)\n{\nreturn __builtin_complex(v, c);\n}\n" },
    };

// c_check_program_library_test.c, line 218 (check_library_source_fixtures)
static const CheckSourceFixture table_library[] =
{
    {
        .name = "library folds: comparisons and lengths in constant contexts",
        .source = "static const unsigned long a = __builtin_strlen(\"abcd\");static const int b = __builtin_strcmp(\"a\", \"b\");\n"
                  "_Static_assert(__builtin_strcmp(\"a\", \"b\") < 0 && __builtin_strcmp(\"b\", \"b\") == 0, \"strcmp\");\n"
                  "_Static_assert(__builtin_strncmp(\"abc\", \"abd\", 2) == 0 && __builtin_strncmp(\"ab\", \"abc\", 5) == -1, \"strncmp\");\n"
                  "_Static_assert(__builtin_memcmp(\"ab\\0c\", \"ab\\0d\", 4) == -1 && __builtin_bcmp(\"ab\", \"ab\", 2) == 0, \"memcmp\");\n"
                  "_Static_assert(__builtin_strcmp(\"\\x80\", \"\\x01\") == 1, \"unsigned bytes\");\n"
                  "_Static_assert(__builtin_wcslen(L\"wide\") == 4 && __builtin_wcscmp(L\"\\x80000000\", L\"\\x01\") == -1, \"wide\");\n"
                  "_Static_assert(__builtin_wcsncmp(L\"ab\", L\"ac\", 1) == 0 && __builtin_wmemcmp(L\"ab\", L\"ac\", 2) == -1, \"wide bounded\");\n"
                  "int c[__builtin_strlen(\"abc\")];enum { E = __builtin_strlen(\"xy\") };\n"
                  "int f(int x){switch(x){case __builtin_strlen(\"ab\"):return 1;case __builtin_wcslen(L\"abc\"):return 2;}return 0;}\n",
        .rejected = false,
    },
    {
        .name = "library folds: strings at offsets and in const arrays",
        .source = "static const char s[] = \"abc\";static const unsigned long n = __builtin_strlen(s);\n"
                  "_Static_assert(__builtin_strlen(\"abc\" + 1) == 2 && __builtin_strcmp(&\"abc\"[1], \"bc\") == 0, \"offsets\");\n"
                  "int f(void){static const char t[] = \"xyz\";return (int)__builtin_strlen(t);}\n",
        .rejected = false,
    },
    {
        .name = "library folds: integers and floating values",
        .source = "static int a = __builtin_abs(-3);static long b = __builtin_labs(-4L);static long long c = __builtin_llabs(-5LL);\n"
                  "_Static_assert(__builtin_abs(-7) == 7, \"abs\");\n"
                  "static const double d = __builtin_fmax(1.0, 2.0);static const float e = __builtin_fminf(1.0f, -2.0f);\n"
                  "static const long double f = __builtin_fmaxl(1.0L, __builtin_nanl(\"\"));static const double g = __builtin_fmaximum_num(-0.0, 0.0);\n"
                  "static const long double h = __builtin_copysignl(2.0L, -1.0L);\n",
        .rejected = false,
    },
    {
        .name = "library folds: plain declarations of the builtins",
        .source = "unsigned long strlen(const char*);int strcmp(const char*, const char*);int memcmp(const void*, const void*, unsigned long);\n"
                  "static const unsigned long n = strlen(\"abcd\");_Static_assert(strcmp(\"a\", \"b\") < 0 && memcmp(\"ab\", \"ac\", 2) == -1, \"plain\");\n",
        .rejected = false,
    },
    {
        .name = "library folds: ordinary declarations beside overloads in constant contexts",
        .source = "int ov(int) __attribute__((overloadable));double ov(double) __attribute__((overloadable));\n"
                  "unsigned long strlen(const char*);int strcmp(const char*, const char*);int memcmp(const void*, const void*, unsigned long);\n"
                  "static const unsigned long n = strlen(\"abcd\");_Static_assert(strcmp(\"a\", \"c\") == -1, \"ordinary\");\n"
                  "enum { length = strlen(\"abc\") };int a[strlen(\"abc\")];\n"
                  "int f(int x){switch(x){case memcmp(\"ab\", \"ad\", 2):return length;}return 0;}\n",
        .rejected = false,
    },
    {
        .name = "library folds: the selected ordinary declaration precedes its overload",
        .source = "unsigned long strlen(const char*);unsigned long strlen(int) __attribute__((overloadable));\n"
                  "static const unsigned long n = strlen(\"abcd\");_Static_assert(strlen(\"abc\") == 3, \"ordinary first\");\n",
        .rejected = false,
    },
    {
        .name = "library folds: the selected ordinary declaration follows its overload",
        .source = "unsigned long strlen(int) __attribute__((overloadable));unsigned long strlen(const char*);\n"
                  "static const unsigned long n = strlen(\"abcd\");_Static_assert(strlen(\"abc\") == 3, \"ordinary last\");\n",
        .rejected = false,
    },
    {
        .name = "library folds: an overloadable declaration of the same prototype is no builtin",
        .source = "unsigned long strlen(const char*) __attribute__((overloadable));\n"
                  "static const unsigned long n = strlen(\"abcd\");\n",
        .rejected = true,
    },
    {
        .name = "library folds: another prototype beside overloads is no builtin",
        .source = "int ov(int) __attribute__((overloadable));int strlen(const char*);\n"
                  "static const int n = strlen(\"abcd\");\n",
        .rejected = true,
    },
    {
        .name = "library folds: a static declaration beside overloads is no builtin",
        .source = "int ov(int) __attribute__((overloadable));static unsigned long strlen(const char* s){return 0;}\n"
                  "static const unsigned long n = strlen(\"abcd\");\n",
        .rejected = true,
    },
    {
        .name = "library folds: an argument's side effect beside overloads is no constant",
        .source = "int ov(int) __attribute__((overloadable));unsigned long strlen(const char*);int calls;\n"
                  "static const unsigned long n = strlen((++calls, \"abcd\"));\n",
        .rejected = true,
    },
    {
        .name = "library folds: a builtin clang doesn't fold is no constant",
        .source = "static const double d = __builtin_sin(0.0);\n",
        .rejected = true,
    },
    {
        .name = "library folds: a mutable array's string is no constant",
        .source = "static char m[] = \"abc\";static const unsigned long n = __builtin_strlen(m);\n",
        .rejected = true,
    },
    {
        .name = "library folds: a declaration of another prototype isn't the builtin",
        .source = "int strlen(const char*);static const int n = strlen(\"abcd\");\n",
        .rejected = true,
    },
    {
        .name = "library folds: a static declaration isn't the builtin",
        .source = "static unsigned long strlen(const char* s){return 0;}static const unsigned long n = strlen(\"abcd\");\n",
        .rejected = true,
    },
    {
        .name = "FILE builtins: the unit's FILE at file scope",
        .source = "typedef struct F FILE;\nint f(FILE* p, __builtin_va_list a){return __builtin_fprintf(p, \"%d\", 1) + __builtin_vfscanf(p, \"x\", a) + "
                  "__builtin___fprintf_chk(p, 1, \"x\") + __builtin___vfprintf_chk(p, 1, \"x\", a);}\n",
        .rejected = false,
    },
    {
        .name = "FILE builtins: a local object named FILE leaves the file scope's",
        .source = "typedef int FILE;\nint f(FILE* p){int FILE = 3;return __builtin_fprintf(p, \"%d\", FILE);}\n",
        .rejected = false,
    },
    {
        .name = "FILE builtins: no FILE",
        .source = "int f(void* p){return __builtin_fprintf(p, \"x\");}\n",
        .rejected = true,
    },
    {
        .name = "FILE builtins: a FILE of block scope alone",
        .source = "void g(void){typedef int FILE;}\nint f(void* p){return __builtin_fscanf(p, \"x\");}\n",
        .rejected = true,
    },
    {
        .name = "FILE builtins: FILE declared after the call",
        .source = "int f(void* p){return __builtin_vfprintf(p, \"x\", 0);}\ntypedef struct F FILE;\n",
        .rejected = true,
    },
    {
        .name = "FILE builtins: a FILE of the wrong type",
        .source = "typedef int FILE;\nint f(long* p){return __builtin_fprintf(p, \"x\");}\n",
        .rejected = true,
    },
};

// c_check_transparent_test.c, line 73 (fixtures)
static const CheckSourceFixture table_transparent[] =
{
        { .name = "transparent pointer and null arguments", .source = "typedef union __attribute__((transparent_union)){void*p;int*q;}U;void f(U);void g(int*p){f(p);f(0);f((void*)0);}\n" },
        { .name = "transparent qualifier discard remains incompatible", .source = "typedef union __attribute__((transparent_union)){void*p;int*q;}U;void f(U);void g(const int*p){f(p);}\n", .rejected = true },
        { .name = "transparent object-function extension remains incompatible", .source = "typedef union __attribute__((transparent_union)){void*p;int*q;}U;void f(U);void g(void){f(g);}\n", .rejected = true },
        { .name = "transparent arithmetic member uses assignment conversions", .source = "typedef union __attribute__((transparent_union)){int i;unsigned u;}U;void f(U);void g(short s,long l,float x){f(s);f(l);f(x);}\n" },
        { .name = "transparent atomic member uses value conversion", .source = "typedef union __attribute__((transparent_union)){_Atomic(float) x;int i;}U;void f(U);void g(float x){f(x);}\n" },
        { .name = "transparent conversion is limited to parameters", .source = "typedef union __attribute__((transparent_union)){int i;unsigned u;}U;U x=1;\n", .rejected = true },
        { .name = "transparent attribute source activation rejects earlier call", .source = "union U{int a;unsigned b;};void f(union U);\nvoid before(void){f(1);}\ntypedef union U T __attribute__((transparent_union));\nvoid after(void){f(1);}\n", .rejected = true },
        { .name = "transparent attribute source activation permits later call", .source = "union U{int a;unsigned b;};void f(union U);typedef union U T __attribute__((transparent_union));void after(void){f(1);}\n" },
    };

// c_check_transparent_type_test.c, line 235 (fixtures)
static const CheckSourceFixture table_transparent_types[] =
{
        { .name = "transparent function first member both declaration orders", .source = "typedef union __attribute__((transparent_union)){int*i;double*d;}U;int f(U);int f(int*p){return p!=0;}int g(int*);int g(U p){return p.d!=0;}\n" },
        { .name = "transparent function second member both declaration orders", .source = "typedef union __attribute__((transparent_union)){int*i;double*d;}U;int f(U);int f(double*p){return p!=0;}int g(double*);int g(U p){return p.d!=0;}\n" },
        { .name = "transparent function pointer and ordinary nominal identity", .source = "typedef union __attribute__((transparent_union)){int*i;double*d;}U;typedef void F(U);typedef void I(int*);typedef void D(double*);_Static_assert(__builtin_types_compatible_p(F,I),\"first\");_Static_assert(__builtin_types_compatible_p(F*,D*),\"second\");_Static_assert(!__builtin_types_compatible_p(U,int*),\"nominal\");\n" },
        { .name = "transparent unrelated union parameters remain incompatible", .source = "typedef union __attribute__((transparent_union)){int*i;double*d;}U;typedef union __attribute__((transparent_union)){int*i;float*f;}V;typedef void F(U);typedef void G(V);_Static_assert(!__builtin_types_compatible_p(F,G),\"distinct\");\n" },
        { .name = "transparent top qualifier matching", .source = "typedef union __attribute__((transparent_union)){const int i;unsigned u;}U;typedef void F(U);typedef void I(int);_Static_assert(__builtin_types_compatible_p(F,I),\"top const\");\n" },
        { .name = "transparent atomic candidate remains distinct", .source = "typedef union __attribute__((transparent_union)){_Atomic(int)i;unsigned u;}U;typedef void F(U);typedef void I(int);typedef void A(_Atomic(int));_Static_assert(!__builtin_types_compatible_p(F,I),\"atomic\");_Static_assert(__builtin_types_compatible_p(F,A),\"atomic match\");\n" },
        { .name = "transparent array candidate does not decay", .source = "typedef union __attribute__((transparent_union)){int a[2];}U;typedef void F(U);typedef void I(int*);_Static_assert(!__builtin_types_compatible_p(F,I),\"no decay\");\n" },
        { .name = "transparent first floating member is ignored", .source = "typedef union __attribute__((transparent_union)){float f;int i;}U;void f(U);void g(void){f(1);}\n", .rejected = true },
        { .name = "transparent later floating member is allowed", .source = "typedef union __attribute__((transparent_union)){int i;float f;}U;void f(U);void f(float);\n" },
        { .name = "transparent first atomic floating member is allowed", .source = "typedef union __attribute__((transparent_union)){_Atomic(float)f;int i;}U;void f(U);void f(_Atomic(float));\n" },
        { .name = "transparent member declaration alignment does not change validation", .source = "typedef union __attribute__((transparent_union)){int i;int j __attribute__((aligned(8)));}U;void f(U);void f(int);\n" },
        { .name = "transparent incomplete forward annotation stays ignored", .source = "union __attribute__((transparent_union)) U;union U{int i;unsigned u;};void f(union U);void g(void){f(1);}\n", .rejected = true },
        { .name = "transparent composite first order constrains later calls", .source = "typedef union __attribute__((transparent_union)){int*i;double*d;}U;void f(U);void f(int*);void g(double*p){f(p);}\n", .rejected = true },
        { .name = "transparent composite reverse order constrains later calls", .source = "typedef union __attribute__((transparent_union)){int*i;double*d;}U;void f(int*);void f(U);void g(double*p){f(p);}\n", .rejected = true },
        { .name = "transparent function pointer before activation stays incompatible", .source = "union U{int*i;double*d;};void f(union U);\nvoid(*p)(int*)=f;\ntypedef union U T __attribute__((transparent_union));\n", .rejected = true },
        { .name = "transparent function pointer after activation is compatible", .source = "union U{int*i;double*d;};void f(union U);typedef union U T __attribute__((transparent_union));void(*p)(int*)=f;\n" },
        { .name = "transparent recursive callback relation terminates", .source = "union U;typedef void(*P)(union U);union __attribute__((transparent_union)) U{P p;};typedef void(*Q)(P);typedef void F(union U);typedef void G(Q);_Static_assert(__builtin_types_compatible_p(F,G),\"callback\");\n" },
    };


static int dump(const char* out, const char* suite, const CheckSourceFixture* table, unsigned count)
{
    int status = 0;
    char directory[4096];
    snprintf(directory, sizeof(directory), "%s/%s", out, suite);
    mkdir(directory, 0755);
    for (unsigned i = 0; i < count; i += 1)
    {
        char path[4200];
        snprintf(path, sizeof(path), "%s/%04u.c", directory, i + 1);
        FILE* file = fopen(path, "wb");
        const size_t length = strlen(table[i].source);
        status |= file == 0 || fwrite(table[i].source, 1, length, file) != length;
        if (file != 0)
        {
            status |= fclose(file) != 0;
        }
        printf("%s\t%04u\t%d\t%d\t%d\t%u\t%d\t%d\t%u\t%d\t%s\n", suite, i + 1, table[i].rejected, table[i].unsupported, table[i].extension, table[i].standard,
               table[i].char_unsigned, table[i].undecided, table[i].overload_tables, table[i].capacity != 0, table[i].name);
    }
    return status;
}

int main(int argc, char** argv)
{
    int status = argc != 2;
    status |= dump(argv[1], "cleanup", table_cleanup, sizeof(table_cleanup) / sizeof(table_cleanup[0]));
    status |= dump(argv[1], "const-alias", table_const_alias, sizeof(table_const_alias) / sizeof(table_const_alias[0]));
    status |= dump(argv[1], "musttail", table_musttail, sizeof(table_musttail) / sizeof(table_musttail[0]));
    status |= dump(argv[1], "align", table_align, sizeof(table_align) / sizeof(table_align[0]));
    status |= dump(argv[1], "classify", table_classify, sizeof(table_classify) / sizeof(table_classify[0]));
    status |= dump(argv[1], "float-constants", table_float_constants, sizeof(table_float_constants) / sizeof(table_float_constants[0]));
    status |= dump(argv[1], "generic-builtins", table_generic_builtins, sizeof(table_generic_builtins) / sizeof(table_generic_builtins[0]));
    status |= dump(argv[1], "library", table_library, sizeof(table_library) / sizeof(table_library[0]));
    status |= dump(argv[1], "transparent", table_transparent, sizeof(table_transparent) / sizeof(table_transparent[0]));
    status |= dump(argv[1], "transparent-types", table_transparent_types, sizeof(table_transparent_types) / sizeof(table_transparent_types[0]));
    return status;
}
