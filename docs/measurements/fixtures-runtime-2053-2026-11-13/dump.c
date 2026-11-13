// #2053's extraction: the checker's shared source fixtures (c_checker_test.c, check_test_sources) as clang compiles
// them, each source's bytes (to its first NUL, as the runner writes it: parse_test_write(path, source, strlen(source)))
// to DIRECTORY/NNNN.c and its metadata to stdout, a line each: NNNN, the flags, the name.
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
typedef struct TypeCapacity TypeCapacity;
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
    const TypeCapacity* capacity;
    uint8_t overload_tables;
};
enum
{
    CHECK_TEST_OVERLOAD_TABLES = 1,
    CHECK_TEST_OVERLOAD_NONE = 2,
};
int main(int argc, char** argv)
{
    if (argc != 2)
    {
        return 2;
    }
    const CheckSourceFixture fixtures[] = {
        {
            "empty translation unit",
            "",
            false,
            false
        },
        {
            "global declaration",
            "int x;\n",
            false,
            false
        },
        {
            "return integer arithmetic",
            "int f(void) { return 2 + 3 * 4; }\n",
            false,
            false
        },
        {
            "parameter promotions",
            "int f(unsigned short a, signed char b) { return a + b; }\n",
            false,
            false
        },
        {
            "typedef declaration",
            "typedef unsigned long Size; Size f(Size n) { return n + 1; }\n",
            false,
            false
        },
        {
            "local initialization",
            "int f(int a) { int b = a + 1; return b; }\n",
            false,
            false
        },
        {
            "const initialization",
            "int f(int a) { const int b = a; return b; }\n",
            false,
            false
        },
        {
            "local scope shadowing",
            "int f(int x) { { long x = 7; x = x + 1; } return x; }\n",
            false,
            false
        },
        {
            "pointer read",
            "int f(const int *p) { return *p; }\n",
            false,
            false
        },
        {
            "pointer subscript",
            "int f(int *p) { return p[2]; }\n",
            false,
            false
        },
        {
            "pointer qualification",
            "int f(int *p) { const int *q = p; return *q; }\n",
            false,
            false
        },
        {
            "global address initializer",
            "int g; int *p = &g;\n",
            false,
            false
        },
        {
            "bool of a defined object's address",
            "int s; _Bool b = (_Bool)&s;\n",
            false,
            false
        },
        {
            "bool of a strong external address",
            "extern int e; _Bool b = (_Bool)&e;\n",
            false,
            false
        },
        {
            "bool of a wrapped address",
            "int s; _Bool b = (_Bool)((char *)&s + (1ul << 63));\n",
            false,
            false
        },
        {
            "bool of an automatic address in a static initializer",
            "void f(void) { int x; static _Bool b = (_Bool)&x; }\n",
            false,
            false
        },
        {
            "bool of a weak address",
            "extern int w __attribute__((weak)); _Bool b = (_Bool)&w;\n",
            true,
            false
        },
        {
            "bool of a weak definition's address",
            "int w __attribute__((weak)); _Bool b = (_Bool)&w;\n",
            true,
            false
        },
        {
            "pointer index that wraps in 64 bits",
            "int a[4]; int *r = a + (1ul << 62); char s; char *p = &s + (1ul << 63);\n",
            false,
            false
        },
        {
            "bool of an address named by pragma weak",
            "#pragma weak w\nextern int w;\n_Bool b = (_Bool)&w;\n",
            true,
            false
        },
        {
            "bool of an address an ignored pragma weak names",
            "#pragma weak w extra\nextern int w;\n_Bool b = (_Bool)&w;\n",
            false,
            false
        },
        {
            "bool of an address a pragma weak after it names",
            "extern int w;\n_Bool b = (_Bool)&w;\n#pragma weak w\n",
            false,
            false
        },
        {
            "global array initializer",
            "int a[3]; int *p = a;\n",
            false,
            false
        },
        {
            "address cancels void pointer indirection",
            "void *p; void *f(void) { return &*p; }\n",
            false,
            false
        },
        {
            "address cancels null pointer indirection",
            "void *p = &*(void *)0;\n",
            false,
            false
        },
        {
            "address cancels absolute pointer indirection",
            "int *p = &*(int *)4;\n",
            false,
            false
        },
        {
            "register pointer does not make its pointee register",
            "int *f(register int *p) { return &*p; }\n",
            false,
            false
        },
        {
            "grouped comma expression",
            "int f(void) { return (1, 2); }\n",
            false,
            false
        },
        {
            "comma condition",
            "int f(int x) { if (x = 0, x) { return 1; } return 2; }\n",
            false,
            false
        },
        {
            "comma subscript",
            "int f(int *p) { return p[0, 1]; }\n",
            false,
            false
        },
        {
            "local static address initializer",
            "void f(void) { static int x; static int *p = &x; }\n",
            false,
            false
        },
        {
            "null pointer assignment",
            "int *p = 0;\n",
            false,
            false
        },
        {
            "constant static initializer",
            "unsigned long x = 0xffffffffu + 1u;\n",
            false,
            false
        },
        {
            "floating return conversion",
            "double f(float x) { return x + 2.5; }\n",
            false,
            false
        },
        {
            "sizeof expression",
            "unsigned long f(void) { return sizeof(1 / 0); }\n",
            false,
            false
        },
        {
            "sizeof constant array",
            "unsigned long f(void) { int a[3]; return sizeof a; }\n",
            false,
            false
        },
        {
            "call arguments",
            "int f(int a, long b); int g(void) { return f(1, 2); }\n",
            false,
            false
        },
        {
            "short-circuit constant",
            "_Static_assert(1 || (1 / 0), \"short circuit\");\n",
            false,
            false
        },
        {
            "GNU folded-constant extension",
            "int f(void); _Static_assert(1 || f(), \"unevaluated call\");\n",
            false,
            false
        },
        {
            "conditional constant",
            "_Static_assert((0 ? 1 / 0 : 17) == 17, \"conditional\");\n",
            false,
            false
        },
        {
            "floating immediate ICE cast",
            "_Static_assert((int)3.75 == 3, \"cast\");\n",
            false,
            false
        },
        {
            "C integer literal types",
            "_Static_assert(sizeof(2147483648) == 8 && sizeof(0xffffffff) == 4, \"literal rank\");\n",
            false,
            false
        },
        {
            "undeclared identifier",
            "int f(void)\n{\n return absent;\n}\n",
            true,
            false
        },
        {
            "scope no longer visible",
            "int f(void) { { int x = 1; }\n return x; }\n",
            true,
            false
        },
        {
            "const assignment",
            "int f(void)\n{ const int x = 1;\n x = 2; return x; }\n",
            true,
            false
        },
        {
            "const parameter assignment",
            "int f(const int x) { x = 2; return x; }\n",
            true,
            false
        },
        {
            "register parameter address",
            "int *f(register int x) { return &x; }\n",
            true,
            false
        },
        {
            "register local address",
            "int *f(void) { register int x; return &x; }\n",
            true,
            false
        },
        {
            "register address keeps first failing source line",
            "int f(void) { register int x;\n return\n *\n &x;\n}\n",
            true,
            false
        },
        {
            "discarded register array still decays",
            "int f(void) { register int a[2]; a; return 0; }\n",
            true,
            false
        },
        {
            "GNU discarded void indirection",
            "void f(void *p) { *p; }\n",
            false,
            false
        },
        {
            "floating remainder",
            "int f(void)\n{\n return 1.0 % 2;\n}\n",
            true,
            false
        },
        {
            "address rvalue",
            "int *f(void) { return &1; }\n",
            true,
            false
        },
        {
            "dereference integer",
            "int f(void) { return *1; }\n",
            true,
            false
        },
        {
            "incompatible pointer initialization",
            "int *p = 1;\n",
            true,
            false
        },
        {
            "missing call argument",
            "int f(int); int g(void)\n{ return f(); }\n",
            true,
            false
        },
        {
            "calling nonfunction",
            "int f(void) { int x = 1; return x(); }\n",
            true,
            false
        },
        {
            "false static assertion",
            "_Static_assert(0, \"false\");\n",
            true,
            false
        },
        {
            "division in required ICE",
            "_Static_assert(1 / 0, \"division\");\n",
            true,
            false
        },
        {
            "nonconstant static initializer",
            "int y;\nint x = y;\n",
            true,
            false
        },
        {
            "automatic address static initializer",
            "void f(void) { int x;\n static int *p = &x; }\n",
            true,
            false
        },
        {
            "duplicate global definition",
            "int x = 1;\nint x = 2;\n",
            true,
            false
        },
        {
            "duplicate function definition",
            "int f(void) { return 1; }\nint f(void) { return 2; }\n",
            true,
            false
        },
        {
            "retained prior prototype",
            "int f(int); int f();\nint g(void) { return f(); }\n",
            true,
            false
        },
        {
            "duplicate parameter name",
            "int f(int x, int x);\n",
            true,
            false
        },
        {
            "restrict requires pointer to object",
            "typedef int F(void); F *restrict p;\n",
            true,
            false
        },
        {
            "definition conflicts with prior prototype",
            "int f(int);\nint f() { return 1; }\n",
            true,
            false
        },
        {
            "invalid integer suffix",
            "int x = 1uu;\n",
            true,
            false
        },
        {
            "basic universal character name before C23",
            "_Static_assert('\\u0041' == 65, \"basic UCN\");\n",
            true,
            false
        },
        {
            "record declaration",
            "struct S { int x; }; struct S value;\n",
            false,
            false
        },
        {
            // A GNU extension clang takes (a warning under -pedantic alone), with clang's layouts.
            "struct whose only named member is a flexible array member",
            "struct T { int a[]; }; struct U { int : 0; char c[]; }; struct V { char : 3; long l[]; };\n"
            "struct W { struct T t; int b; }; struct T *p; int n = sizeof(struct T) + sizeof(struct U);\n"
            "_Static_assert(sizeof(struct T) == 0 && _Alignof(struct T) == 4, \"T\");\n"
            "_Static_assert(sizeof(struct U) == 0 && _Alignof(struct U) == 1, \"U\");\n"
            "_Static_assert(sizeof(struct V) == 8 && _Alignof(struct V) == 8 && __builtin_offsetof(struct V, l) == 8, \"V\");\n"
            "_Static_assert(sizeof(struct W) == 4, \"W\");\n",
            false,
            false
        },
        {
            "flexible array member before another member",
            "struct S { int a[]; int b; };\n",
            true,
            false
        },
        {
            // C23's fixed underlying type, which clang takes in every mode: complete at its base (sizeof in its own list),
            // its enumerators of its own type, the base's qualifiers dropped, an attribute before its name applied at the
            // base, packed ignored, its declarations alone (here in a block, a new enum) keeping or making it.
            "enum with a fixed underlying type",
            "enum E : unsigned char { A = 255, B = 0 }; enum E : unsigned char; typedef unsigned int U;\n"
            "_Static_assert(sizeof(enum E) == 1 && _Alignof(enum E) == 1 && _Generic(A, enum E: 1, default: 0) && _Generic(+A, int: 1, default: 0), \"E\");\n"
            "enum F : long long { C = -1, D }; enum G : short; enum G : short { H = sizeof(enum G) }; enum I : const U { J = 4294967295u };\n"
            "_Static_assert(sizeof(enum F) == 8 && D == 0 && H == 2 && J == 4294967295u && sizeof(enum I) == 4, \"F G I\");\n"
            "enum K : _Bool { L, M }; enum N : signed char { O = -128, P = 127 }; enum : unsigned long { Q = 1ul << 63 }; enum R : unsigned { S = -1 };\n"
            "_Static_assert(M == 1 && sizeof(enum K) == 1 && Q == 9223372036854775808ul && S == 4294967295u, \"K Q S\");\n"
            "enum __attribute__((aligned(8))) T : char { V }; enum __attribute__((packed)) W : int { X }; enum Y : short { Z } __attribute__((packed));\n"
            "_Static_assert(_Alignof(enum T) == 8 && sizeof(enum T) == 1 && sizeof(enum W) == 4 && sizeof(enum Y) == 2, \"T W Y\");\n"
            "struct St { enum E e : 4; enum E f : 8; enum F g; }; _Static_assert(sizeof(struct St) == 16, \"St\");\n"
            "int f(enum E e) { switch (e) { case A: return 1; case B: return 2; default: return 3; } }\n"
            "unsigned g(void) { enum E e = A; enum E : unsigned char; return e + 1u; }\n"
            "int h(enum N n) { return n == O ? 1 : n; }\n",
            false,
            false
        },
        {
            // A fixed enum's enumerators are of its base's type in its list, and after it of the enum's in C23 alone, as
            // clang 23 types them (#428's review): before C23, two such enums' enumerators of one base are of one type.
            "fixed enum: enumerators of the base's type before C23",
            "enum E : int { A, B = _Generic(A, int: 2, default: 3) }; enum F : int { C };\n"
            "_Static_assert(B == 2 && _Generic(A, __typeof__(C): 1, default: 0) == 1 && _Generic(A, int: 1, default: 0), \"C17\");\n"
            "enum G : unsigned char { D }; _Static_assert(_Generic(D, unsigned char: 1, default: 0) && _Generic(+D, int: 1, default: 0), \"G\");\n",
            false,
            false
        },
        {
            "fixed enum: enumerators of the enum's type after its list in C23",
            "enum E : int { A, B = _Generic(A, int: 2, default: 3) }; enum F : int { C };\n"
            "_Static_assert(B == 2 && _Generic(A, __typeof__(C): 1, default: 0) == 0 && _Generic(A, enum E: 1, default: 0), \"C23\");\n"
            "enum G : unsigned char { D }; _Static_assert(_Generic(D, enum G: 1, default: 0) && _Generic(+D, int: 1, default: 0), \"G\");\n",
            false,
            false,
            .standard = 2023
        },
        {
            // The same assertion in the other dialect: each must refuse it.
            "fixed enum: C23's enumerator types refused before it",
            "enum E : int { A }; enum F : int { C }; _Static_assert(_Generic(A, __typeof__(C): 1, default: 0) == 0, \"C17\");\n",
            true,
            false
        },
        {
            "fixed enum: earlier enumerator types refused in C23",
            "enum E : int { A }; enum F : int { C }; _Static_assert(_Generic(A, __typeof__(C): 1, default: 0) == 1, \"C23\");\n",
            true,
            false,
            .standard = 2023
        },
        {
            // A negative value's significant bits, its sign not checked (clang's isRepresentableIntegerValue), and a
            // value's active bits, less the sign bit of a signed type.
            "fixed enum: an enumerator past its type",
            "enum E : unsigned char {\n  A = 256\n};\n",
            true,
            false
        },
        {
            "fixed enum: the successor past its type",
            "enum E : signed char {\n  A = 127,\n  B\n};\n",
            true,
            false
        },
        {
            "fixed enum: redeclared with another type",
            "enum E : int;\nenum E : long { A };\n",
            true,
            false
        },
        // (An enum base with a declarator, `enum E : int x;`, is -Welaborated-enum-base's error by default since #2213, a
        // warning event these fixtures don't read: test-checker-driver's default-warning sweep compares it with clang.)
        {
            "fixed enum: an enum without one given one",
            "enum E { A };\nenum E : int;\n",
            true,
            false
        },
        {
            "fixed enum: one with it defined without it",
            "enum E : int;\nenum E { A };\n",
            true,
            false
        },
        {
            "fixed enum: defined twice",
            "enum E : int { A };\nenum E : int { B };\n",
            true,
            false
        },
        {
            "fixed enum: a floating type",
            "int a;\nenum E : float { A };\n",
            true,
            false
        },
        {
            // GNU attributes after a bit-field's width, the member's, as clang (and GCC) lay them out: aligned, packed (a
            // compound width), two groups, an unnamed field's and an empty one; then widths of every form a width takes,
            // which the parser's tree keeps whole apart from the attributes: _Generic alone and in a sum (#430's review),
            // sizeof, a cast of a floating constant, __builtin_offsetof in ?: and __builtin_choose_expr.
            "attributes after a bit-field's width",
            "enum { N = 5 };\n"
            "struct S { int a : 3 __attribute__((aligned(4))), b : 2; char c; };\n"
            "struct T { char x; unsigned long y : 1 + 2 __attribute__((packed)); char z; };\n"
            "struct U { char x; int y : N __attribute__((aligned(16))) __attribute__((unused)); char z : (N - 1) __attribute__(()); };\n"
            "struct V { char x; long : 0 __attribute__((aligned(8))); char y; };\n"
            "struct O { char a; int b; };\n"
            "struct W { char x; unsigned a : _Generic(0, int: 3, default: 1) __attribute__((packed));\n"
            "           unsigned b : _Generic(0L, int: 1, long: 2) + 3 __attribute__((aligned(8))); char y; };\n"
            "struct X { char x; unsigned a : sizeof(short) * 2 __attribute__((aligned(4))), b : (int)2.5 + N __attribute__((packed));\n"
            "           unsigned c : __builtin_offsetof(struct O, b) ? 6 : 1 __attribute__(()); unsigned d : __builtin_choose_expr(1, 7, 1.0) __attribute__((aligned(2))); };\n"
            "_Static_assert(sizeof(struct S) == 4 && _Alignof(struct S) == 4, \"S\");\n"
            "_Static_assert(sizeof(struct T) == 3 && _Alignof(struct T) == 1, \"T\");\n"
            "_Static_assert(sizeof(struct U) == 32 && _Alignof(struct U) == 16, \"U\");\n"
            "_Static_assert(sizeof(struct V) == 9 && _Alignof(struct V) == 1, \"V\");\n"
            "_Static_assert(sizeof(struct W) == 16 && _Alignof(struct W) == 8, \"W\");\n"
            "_Static_assert(sizeof(struct X) == 12 && _Alignof(struct X) == 4, \"X\");\n",
            false,
            false
        },
        {
            // Its alignment applied after its body, which the enum's completion at its base came before (#1447): clang's,
            // where nothing asked the enum's layout first.
            "fixed enum: aligned after its body",
            "enum F : char { B } __attribute__((aligned(8)));\n"
            "_Static_assert(sizeof(enum F) == 1 && _Alignof(enum F) == 8, \"F\");\n",
            false,
            false
        },
        {
            // One whose body asks its layout (sizeof, _Alignof), which clang memoizes before the attribute: the attribute
            // changes nothing (#1447 C3). One whose body names it in a cast only takes it.
            "fixed enum: aligned after a body that asks its layout",
            "enum G : char { C = sizeof(enum G) } __attribute__((aligned(8)));\n"
            "_Static_assert(sizeof(enum G) == 1 && _Alignof(enum G) == 1, \"G\");\n"
            "enum H : char { D = _Alignof(enum H) } __attribute__((aligned(4)));\n"
            "_Static_assert(sizeof(struct { enum H h; char c; }) == 2, \"H\");\n"
            "enum J : int { E = 1, K = (enum J)0 } __attribute__((aligned(8)));\n"
            "_Static_assert(_Alignof(enum J) == 8, \"J\");\n"
            "enum Q : char { R = sizeof(enum Q[2]) } __attribute__((aligned(8)));\n"
            "_Static_assert(_Alignof(enum Q) == 1, \"Q\");\n",
            false,
            false
        },
        {
            // A pointer to it asks nothing; one whose body names it otherwise (an array's element), which this doesn't read:
            // refused.
            "fixed enum: aligned after a body that names a pointer to it",
            "enum L : char { M = sizeof(enum L *) } __attribute__((aligned(8)));\n"
            "_Static_assert(_Alignof(enum L) == 8, \"L\");\n",
            false,
            false
        },
        {
            "fixed enum: aligned after a body that names it otherwise",
            "enum N : char { P = sizeof(struct { enum N n; }) } __attribute__((aligned(8)));\n",
            true,
            true
        },
        {
            // #428's review: GNU attributes among the base's specifiers, which clang takes as the base type's and ignores
            // (the base's own type kept), with a body, without and before a typedef's declarator; and the enum's
            // references (`enum E x`) and declarations alone in another scope, which need no base.
            "fixed enum: attributes in its base, and references without it",
            "enum A : int __attribute__((unused)); enum B : int __attribute__((aligned(8))) { B0 };\n"
            "typedef enum C : __attribute__((unused)) unsigned __attribute__((unused)) char __attribute__((mode(DI))) { C0 } T; T t = C0;\n"
            "_Static_assert(sizeof(enum B) == 4 && _Alignof(enum B) == 4 && sizeof(T) == 1, \"B T\");\n"
            "enum D : short; enum D d; enum D : short; void f(void) { enum D; enum D *p = 0; (void)p; }\n",
            false,
            false
        },
        {
            // Attributes after a tag's name are the declaration's, not the tag's: before a `;` they make it a reference to
            // the visible tag, not a new one in a block's scope, and not a declaration of a fixed enum alone, as clang has it.
            "attributes after a tag's name: a reference",
            "struct S { int a; };\n"
            "void f(void) { struct S __attribute__((unused)); struct S s; s.a = 1; }\n"
            "enum K : int; enum K __attribute__((unused)); void g(void) { enum K __attribute__((unused)); enum K k = 0; (void)k; }\n",
            false,
            false
        },
        {
            // A declaration of it alone without its base, in its scope, before its body or after it: clang's
            // "enumeration previously declared with fixed underlying type", at the name.
            "fixed enum: declared alone without it",
            "enum E : int;\nenum E;\n",
            true,
            false
        },
        {
            "fixed enum: defined, then declared alone without it",
            "enum E : int { A };\nenum E;\n",
            true,
            false
        },
        {
            // restrict needs a pointer; const and volatile are dropped.
            "fixed enum: restrict in its base",
            "int a;\nenum E : restrict int { A };\n",
            true,
            false
        },
        {
            // An attribute that makes the base a vector's: not an integer type.
            "fixed enum: a vector in its base",
            "int a;\nenum E : int __attribute__((vector_size(16))) { A };\n",
            true,
            false
        },
        {
            // GNU C's labels as values (#133, Lua's interpreter): a static table of addresses of labels, a computed goto
            // through it, through a local and through ?:, the addresses compared and stored, and a computed goto out of a
            // variable-length array's block, which leaves its scope as clang lets it.
            "labels as values",
            "int f(int n, const unsigned char *code) {\n"
            "    static const void *const table[] = { &&add, &&twice, &&done };\n"
            "    void *last = &&done;\n"
            "    int acc = n;\n"
            "    goto *table[*code];\n"
            "add:\n"
            "    acc += code[1];\n"
            "    code += 2;\n"
            "    goto *table[*code];\n"
            "twice:\n"
            "    acc += acc;\n"
            "    last = &&twice;\n"
            "    code += 1;\n"
            "    goto *(acc > 100 ? table[2] : table[*code]);\n"
            "done:\n"
            "    return last == &&twice ? acc : -acc;\n"
            "}\n"
            "int g(int n) {\n"
            "    void *out = &&end;\n"
            "    for (int i = 0; i < 3; i++) { int v[(n & 3) + 1]; v[0] = i; if (v[0] == 2) goto *out; }\n"
            "    n = 0;\n"
            "end:\n"
            "    return n;\n"
            "}\n",
            false,
            false
        },
        {
            // An address of a label no function has: clang's "use of undeclared label", at the name.
            "labels as values: an undeclared label",
            "void f(void) {\n"
            "    void *p = &&here;\n"
            "    void *q = &&nowhere;\n"
            "    goto *p;\n"
            "here:\n"
            "    (void)q;\n"
            "}\n",
            true,
            false
        },
        {
            // An address of a label outside a function's body.
            "labels as values: outside a function",
            "void f(void) { x: ; }\n"
            "void *p = &&x;\n",
            true,
            false
        },
        {
            // A computed goto in a function that takes no label's address.
            "labels as values: a computed goto without labels",
            "void f(void *p) {\n"
            "    goto *p;\n"
            "}\n",
            true,
            false
        },
        {
            // A computed goto may go to any of its function's labels: not into a variable-length array's scope, nor into a
            // statement expression.
            "labels as values: into a variable-length array's scope",
            "void f(int n) {\n"
            "    void *p = &&inner;\n"
            "    goto *p;\n"
            "    { int v[n]; inner: v[0] = 1; }\n"
            "}\n",
            true,
            false
        },
        {
            "labels as values: into a statement expression",
            "int f(void) {\n"
            "    void *p = &&inner;\n"
            "    goto *p;\n"
            "    return ({ inner: 1; });\n"
            "}\n",
            true,
            false
        },
        {
            // goto *'s operand converts to const void * as an assignment would: an integer is clang's error.
            "labels as values: a computed goto of an integer",
            "void f(int n) {\n"
            "    void *p = &&here;\n"
            "    goto *n;\n"
            "here:\n"
            "    (void)p;\n"
            "}\n",
            true,
            false
        },
        {
            // goto *'s operand is the whole expression after the `*` (#431's review), not the `*`'s operand: a conditional
            // of an int's condition, one of a void *'s sum, a comma and an assignment, all of them pointers.
            "labels as values: a computed goto's whole expression",
            "int f(int n, void *p, int k) {\n"
            "    void *t[2] = { &&even, &&odd };\n"
            "    goto *(n & 1) ? t[1] : t[0];\n"
            "even:\n"
            "    goto *k ? p + 0 : &&odd;\n"
            "odd:\n"
            "    goto *n++, &&done;\n"
            "done:\n"
            "    goto *p = &&end;\n"
            "end:\n"
            "    return n;\n"
            "}\n",
            false,
            false
        },
        {
            // And a conditional of integers is an integer, clang's error.
            "labels as values: a computed goto of a conditional's integer",
            "void f(void *p) {\n"
            "    void *q = &&here;\n"
            "    goto *p ? 1 : 0;\n"
            "here:\n"
            "    (void)q;\n"
            "}\n",
            true,
            false
        },
        // GNU C's local labels (#147): a `__label__` list's names are labels of its block, which shadow the function's
        // and an outer list's, in a statement expression a macro expands twice too, whose labeled last statement gives
        // its value.
        {
            "local labels: a statement expression's, expanded twice",
            "#define CHECKED(x) ({ __label__ out; int r = 0; if (x) goto out; r = 1; out: r; })\n"
            "int f(int a) {\n"
            "    return CHECKED(a) + CHECKED(a > 1);\n"
            "}\n",
            false,
            false
        },
        {
            "local labels: nested blocks' and the function's",
            "int f(int n) {\n"
            "    int s = 0;\n"
            "    {\n"
            "        __label__ again, done;\n"
            "    again:\n"
            "        if (n-- > 0) { s += 1; goto again; }\n"
            "        {\n"
            "            __label__ again;\n"
            "        again:\n"
            "            if (s > 100) { s -= 1; goto again; }\n"
            "        }\n"
            "        goto done;\n"
            "    done:;\n"
            "    }\n"
            "    if (s == 0) goto again;\n"
            "    return s;\n"
            "again:\n"
            "    return -s;\n"
            "}\n",
            false,
            false
        },
        {
            "local labels: an address of one",
            "int f(int n) {\n"
            "    {\n"
            "        __label__ odd;\n"
            "        void *p = &&odd;\n"
            "        if (n & 1) goto *p;\n"
            "        return 0;\n"
            "    odd:\n"
            "        return 1;\n"
            "    }\n"
            "}\n",
            false,
            false
        },
        {
            // A local label its block doesn't define: clang's "use of undeclared label", at its name in the list.
            "local labels: one its block doesn't define",
            "void f(void) {\n"
            "    {\n"
            "        __label__ missing;\n"
            "        (void)0;\n"
            "    }\n"
            "}\n",
            true,
            false
        },
        {
            // A goto from outside the block reaches no label of the function.
            "local labels: a goto from outside the block",
            "void f(void) {\n"
            "    goto inner;\n"
            "    {\n"
            "        __label__ inner;\n"
            "    inner:;\n"
            "    }\n"
            "}\n",
            true,
            false
        },
        {
            "local labels: one defined twice",
            "void f(void) {\n"
            "    {\n"
            "        __label__ a;\n"
            "    a:;\n"
            "    a:;\n"
            "    }\n"
            "}\n",
            true,
            false
        },
        {
            "local labels: the function's after the block",
            "void f(void) {\n"
            "    {\n"
            "        __label__ a;\n"
            "    a:;\n"
            "    }\n"
            "    goto a;\n"
            "}\n",
            true,
            false
        },
        // GNU C's __auto_type (#147): a variable's type is its initializer's, lvalue-converted and decayed, with the
        // specifiers' qualifiers, as clang deduces it.
        {
            "__auto_type: a statement expression's maximum",
            "#define MAX(a, b) ({ __auto_type a_ = (a); __auto_type b_ = (b); a_ > b_ ? a_ : b_; })\n"
            "long f(int x, long y) {\n"
            "    __auto_type m = MAX(x, y);\n"
            "    _Static_assert(__builtin_types_compatible_p(__typeof__(m), long), \"the conditional's type\");\n"
            "    return m + MAX(MAX(x, 1), 2);\n"
            "}\n",
            false,
            false
        },
        {
            "__auto_type: lvalue conversion and decay",
            "int g(void);\n"
            "const char *h(void) {\n"
            "    const int c = 1;\n"
            "    int a[3] = { 0 };\n"
            "    volatile short v = 2;\n"
            "    _Atomic int t = 3;\n"
            "    __auto_type x = c;\n"
            "    __auto_type p = a;\n"
            "    __auto_type q = g;\n"
            "    __auto_type s = \"abc\";\n"
            "    __auto_type w = v;\n"
            "    __auto_type z = t;\n"
            "    const __auto_type k = 2.0f;\n"
            "    __auto_type volatile u = (char)1 + (char)2;\n"
            "    _Static_assert(__builtin_types_compatible_p(__typeof__(x), int), \"lvalue conversion\");\n"
            "    _Static_assert(__builtin_types_compatible_p(__typeof__(p), int *), \"an array's decay\");\n"
            "    _Static_assert(__builtin_types_compatible_p(__typeof__(q), int (*)(void)), \"a function's decay\");\n"
            "    _Static_assert(__builtin_types_compatible_p(__typeof__(s), char *), \"a string's decay\");\n"
            "    _Static_assert(__builtin_types_compatible_p(__typeof__(w), short), \"volatile dropped\");\n"
            "    _Static_assert(__builtin_types_compatible_p(__typeof__(z), _Atomic int), \"_Atomic kept\");\n"
            "    _Static_assert(__builtin_types_compatible_p(__typeof__(k), const float), \"the specifiers' const\");\n"
            "    _Static_assert(__builtin_types_compatible_p(__typeof__(u), volatile int), \"promoted, and volatile\");\n"
            "    x = 3;\n"
            "    p[0] = x + q() + w + z + (int)k + u;\n"
            "    return s;\n"
            "}\n",
            false,
            false
        },
        {
            "__auto_type: file scope, static, a loop's, structures and compound literals",
            "typedef struct { int a; } S;\n"
            "S make(void);\n"
            "__auto_type g = 1L;\n"
            "static __auto_type h = 'c';\n"
            "int f(void) {\n"
            "    static __auto_type n = sizeof g;\n"
            "    __auto_type s = make();\n"
            "    __auto_type t = (S){ 2 };\n"
            "    __auto_type e = (int[]){ 1, 2, 3 };\n"
            "    __auto_type r = ({ __auto_type r = 4; r + 1; });\n"
            "    int sum = s.a + t.a + h + e[2] + r;\n"
            "    for (__auto_type i = 0u; i < n; i++) sum += (int)i;\n"
            "    _Static_assert(__builtin_types_compatible_p(__typeof__(g), long), \"file scope\");\n"
            "    _Static_assert(__builtin_types_compatible_p(__typeof__(h), int), \"a character constant's int\");\n"
            "    _Static_assert(__builtin_types_compatible_p(__typeof__(n), unsigned long), \"sizeof's size_t\");\n"
            "    _Static_assert(__builtin_types_compatible_p(__typeof__(s), S), \"a structure\");\n"
            "    _Static_assert(__builtin_types_compatible_p(__typeof__(t), S), \"a compound literal\");\n"
            "    _Static_assert(__builtin_types_compatible_p(__typeof__(e), int *), \"an array's compound literal decays\");\n"
            "    __auto_type l = ({ int k = sum; if (k > 3) goto done; k = 5; done: k * 2L; });\n"
            "    _Static_assert(__builtin_types_compatible_p(__typeof__(l), long), \"a labeled last statement's\");\n"
            "    extern long g;\n"
            "    return sum + (int)l + (int)g;\n"
            "}\n",
            false,
            false
        },
        {
            // A use of the variable in its own initializer, though an outer one has its name: at the use.
            "__auto_type: its own initializer names it",
            "void f(void) {\n"
            "    int x = 1;\n"
            "    {\n"
            "        __auto_type x =\n"
            "            x + 1;\n"
            "    }\n"
            "}\n",
            true,
            false
        },
        {
            // A use of it in a type query of its own initializer, which the walk doesn't resolve: the query's binding.
            "__auto_type: its own initializer's type query names it",
            "unsigned long f(void) {\n"
            "    __auto_type x =\n"
            "        sizeof(__typeof__(x));\n"
            "    return x;\n"
            "}\n",
            true,
            false
        },
        {
            "__auto_type: without an initializer",
            "void f(void) {\n"
            "    __auto_type\n"
            "        x;\n"
            "}\n",
            true,
            false
        },
        {
            "__auto_type: a parameter's",
            "void f(int a,\n"
            "       __auto_type b);\n",
            true,
            false
        },
        {
            "__auto_type: a function's result",
            "__auto_type\n"
            "f(void);\n",
            true,
            false
        },
        {
            "__auto_type: a typedef's",
            "typedef\n"
            "    __auto_type T;\n",
            true,
            false
        },
        {
            "__auto_type: a type name's",
            "unsigned long f(void) {\n"
            "    return sizeof(\n"
            "        __auto_type);\n"
            "}\n",
            true,
            false
        },
        {
            "__auto_type: an initializer list",
            "void f(void) {\n"
            "    __auto_type x =\n"
            "        { 1 };\n"
            "}\n",
            true,
            false
        },
        {
            "__auto_type: an array",
            "void f(void) {\n"
            "    __auto_type a[] =\n"
            "        { 1, 2 };\n"
            "}\n",
            true,
            false
        },
        {
            "__auto_type: a bit-field's value",
            "struct B { int b : 3; };\n"
            "void f(struct B s) {\n"
            "    __auto_type x =\n"
            "        s.b;\n"
            "}\n",
            true,
            false
        },
        {
            "__auto_type: a void value",
            "void f(void) {\n"
            "    __auto_type\n"
            "        x = (void)0;\n"
            "}\n",
            true,
            false
        },
        {
            // A signedness, at its keyword wherever it is among the specifiers (DeclSpec::Finish).
            "__auto_type: a signedness",
            "void f(void) {\n"
            "    long\n"
            "        unsigned __auto_type x = 1;\n"
            "}\n",
            true,
            false
        },
        {
            // What clang deduces as C++ deduces a declarator's type, and GCC refuses (#147): pointer and function
            // declarators, qualifiers through them, and a declaration's later declarators, each the same deduction.
            "__auto_type: pointer declarators",
            "int g(void);\n"
            "void f(void) {\n"
            "    int y = 0;\n"
            "    double d = 1;\n"
            "    __auto_type *p = &y;\n"
            "    __auto_type **pp = &p;\n"
            "    __auto_type const *q = &d;\n"
            "    __auto_type (*fp)(void) = g;\n"
            "    _Static_assert(_Generic(p, int *: 1, default: 0), \"\");\n"
            "    _Static_assert(_Generic(pp, int **: 1, default: 0), \"\");\n"
            "    _Static_assert(_Generic(q, const double *: 1, default: 0), \"\");\n"
            "    _Static_assert(_Generic(fp, int (*)(void): 1, default: 0), \"\");\n"
            "}\n",
            false,
            false
        },
        {
            "__auto_type: later declarators",
            "int a[3];\n"
            "void f(void) {\n"
            "    __auto_type x = 1, y = 2;\n"
            "    const __auto_type c = 3, e = 4;\n"
            "    __auto_type r = a, s = &a[1];\n"
            "    _Static_assert(_Generic(y, int: 1, default: 0), \"\");\n"
            "    _Static_assert(_Generic(&e, const int *: 1, default: 0), \"\");\n"
            "    _Static_assert(_Generic(s, int *: 1, default: 0), \"\");\n"
            "    (void)x; (void)c; (void)r;\n"
            "}\n",
            false,
            false
        },
        {
            // Declarators that deduce differently, clang's error at the keyword.
            "__auto_type: later declarators' different deductions",
            "int a[3];\n"
            "void f(void) {\n"
            "    __auto_type r = a, *s = &a[1];\n"
            "}\n",
            true,
            false
        },
        {
            "__auto_type: a pointer declarator of no pointer",
            "int x;\n"
            "void f(void) {\n"
            "    __auto_type *p = x;\n"
            "}\n",
            true,
            false
        },
        {
            // A name with linkage declared before: the deduced type redeclares it, as clang's (#2021).
            "__auto_type: a linked name declared before",
            "extern int e;\n"
            "__auto_type e = 1;\n",
            false,
            false
        },
        {
            // _Alignas against the deduced type, not int, which stands for it until the initializer (#840's review): below
            // int's alignment where the deduced type's is, at file scope, a type's, and GNU's aligned, which can't lower it.
            "__auto_type: an _Alignas the deduced type allows",
            "_Alignas(2) __auto_type g = (short)1;\n"
            "void f(void) {\n"
            "    _Alignas(1) __auto_type c = (char)0;\n"
            "    _Alignas(double) __auto_type d = (char)1;\n"
            "    __auto_type e __attribute__((aligned(1))) = 1.0;\n"
            "    (void)c; (void)d; (void)e;\n"
            "}\n",
            false,
            false
        },
        {
            // Below the deduced type's alignment, though not int's: at the _Alignas.
            "__auto_type: an _Alignas below the deduced type's",
            "void f(void) {\n"
            "    _Alignas(4)\n"
            "        __auto_type x = 1.0;\n"
            "}\n",
            true,
            false
        },
        {
            "__auto_type: an _Alignas below a decayed pointer's",
            "void f(void) {\n"
            "    char a[3];\n"
            "    _Alignas(1)\n"
            "        __auto_type p = a;\n"
            "}\n",
            true,
            false
        },
        {
            // The specifiers' const and volatile on the deduced type, which _Generic of its address sees.
            "__auto_type: the specifiers' qualifiers",
            "void f(void) {\n"
            "    volatile __auto_type y = 1.0;\n"
            "    _Static_assert(_Generic(&y, volatile double *: 1, default: 0), \"volatile\");\n"
            "    const __auto_type x = 1;\n"
            "    _Static_assert(_Generic(&x, const int *: 1, default: 0), \"const\");\n"
            "}\n",
            false,
            false
        },
        {
            "__auto_type: an assignment to a const one",
            "void f(void) {\n"
            "    const __auto_type x = 1;\n"
            "    x = 2;\n"
            "}\n",
            true,
            false
        },
        // C23's `auto` (#793): an initializer's type, lvalue-converted and decayed, through a pointer declarator and
        // for each of a declaration's later declarators too, with an explicit type still the storage class.
        {
            "C23 auto: lvalue conversion, decay, pointer declarators and later declarators",
            "int g(void);\n"
            "const char *h(void) {\n"
            "    const int c = 1;\n"
            "    int a[3] = { 0 };\n"
            "    auto x = c;\n"
            "    auto p = a;\n"
            "    auto q = g;\n"
            "    auto s = \"abc\";\n"
            "    auto *t = &a[0];\n"
            "    auto **u = &t;\n"
            "    auto v = 1, w = 2;\n"
            "    auto *i = &a[0], *j = &a[1];\n"
            "    static auto k = 3;\n"
            "    _Static_assert(__builtin_types_compatible_p(__typeof__(x), int), \"lvalue conversion\");\n"
            "    _Static_assert(__builtin_types_compatible_p(__typeof__(p), int *), \"array decay\");\n"
            "    _Static_assert(__builtin_types_compatible_p(__typeof__(q), int (*)(void)), \"function decay\");\n"
            "    _Static_assert(__builtin_types_compatible_p(__typeof__(s), char *), \"string decay\");\n"
            "    _Static_assert(__builtin_types_compatible_p(__typeof__(t), int *), \"pointer declarator\");\n"
            "    _Static_assert(__builtin_types_compatible_p(__typeof__(u), int **), \"two pointers\");\n"
            "    _Static_assert(__builtin_types_compatible_p(__typeof__(v), int), \"a later declarator\");\n"
            "    _Static_assert(__builtin_types_compatible_p(__typeof__(i), int *), \"each declarator's\");\n"
            "    x = 3;\n"
            "    p[0] = x + q() + w + (int)k + *t + **u;\n"
            "    return s;\n"
            "}\n",
            false,
            false,
            .standard = 2023
        },
        {
            "C23 auto: file scope, a loop's, a parenthesized declarator and the storage class with a type",
            "auto g = 1L;\n"
            "int f(void) {\n"
            "    int sum = 0;\n"
            "    for (auto i = 0u; i < 2; i++) sum += (int)i;\n"
            "    auto (p) = &sum;\n"
            "    auto int n = 3;\n"
            "    auto int o;\n"
            "    o = n;\n"
            "    _Static_assert(__builtin_types_compatible_p(__typeof__(g), long), \"file scope\");\n"
            "    _Static_assert(__builtin_types_compatible_p(__typeof__(p), int *), \"parentheses\");\n"
            "    return *p + o;\n"
            "}\n",
            false,
            false,
            .standard = 2023
        },
        {
            "C23 auto: without an initializer",
            "void f(void) {\n"
            "    auto\n"
            "        x;\n"
            "}\n",
            true,
            false,
            .standard = 2023
        },
        {
            "C23 auto: an initializer list",
            "void f(void) {\n"
            "    auto x =\n"
            "        { 1 };\n"
            "}\n",
            true,
            false,
            .standard = 2023
        },
        {
            "C23 auto: an array",
            "void f(void) {\n"
            "    auto a[] =\n"
            "        { 1, 2 };\n"
            "}\n",
            true,
            false,
            .standard = 2023
        },
        {
            "C23 auto: two declarators of different types",
            "void f(void) {\n"
            "    auto x = 1, y = 2.0;\n"
            "}\n",
            true,
            false,
            .standard = 2023
        },
        // C23's constexpr (#793): an initialized object whose value is a constant expression, const-qualified, and
        // usable where an integer constant expression is required. A pointer's initializer must be null.
        {
            "C23 constexpr: objects in constant expressions",
            "constexpr int n = 2;\n"
            "struct S { int a; };\n"
            "int main(void) {\n"
            "    constexpr int y = 1 + 1;\n"
            "    constexpr double d = 2.5;\n"
            "    constexpr int *p = 0;\n"
            "    constexpr int *q = nullptr;\n"
            "    constexpr char c = 'x';\n"
            "    constexpr auto z = 3;\n"
            "    constexpr struct S s = { 1 };\n"
            "    int a[y];\n"
            "    switch (y) { case n: break; default: break; }\n"
            "    _Static_assert(y == 2, \"an integer constant expression\");\n"
            "    _Static_assert(n == 2, \"file scope\");\n"
            "    _Static_assert(z == 3, \"with auto\");\n"
            "    return (int)sizeof a - 8 + (int)d + (p != 0) + (q != 0) + (c - 'x') + s.a - 1;\n"
            "}\n",
            false,
            false,
            .standard = 2023
        },
        {
            "C23 constexpr: not a constant expression",
            "void g(int x) {\n"
            "    constexpr int y =\n"
            "        x + 1;\n"
            "}\n",
            true,
            false,
            .standard = 2023
        },
        {
            "C23 constexpr: a pointer that isn't null",
            "int x;\n"
            "constexpr int *p =\n"
            "    &x;\n",
            true,
            false,
            .standard = 2023
        },
        {
            "C23 constexpr: an integer not exactly representable",
            "constexpr char c =\n"
            "    300;\n",
            true,
            false,
            .standard = 2023
        },
        {
            "C23 constexpr: a negative value in an unsigned type",
            "constexpr unsigned u =\n"
            "    -1;\n",
            true,
            false,
            .standard = 2023
        },
        {
            "C23 constexpr: a floating value not exactly representable",
            "constexpr float f =\n"
            "    0.1;\n",
            true,
            false,
            .standard = 2023
        },
        {
            "C23 constexpr: an aggregate's initializer isn't constant",
            "struct S { int a; };\n"
            "int f(void);\n"
            "int main(void) {\n"
            "    constexpr struct S s =\n"
            "        { f() };\n"
            "    return s.a;\n"
            "}\n",
            true,
            false,
            .standard = 2023
        },
        // #1000: a comma's discarded operand is still evaluated in a constexpr initializer, which a
        // variable's read fails where a constant would not — a scalar object's and an aggregate
        // element's alike, block scope's automatic storage included.
        {
            "C23 constexpr: a discarded read isn't a constant expression",
            "static int s;\n"
            "void f(void) {\n"
            "    constexpr double d =\n"
            "        (s, 0.75);\n"
            "    (void)d;\n"
            "}\n",
            true,
            false,
            .standard = 2023
        },
        {
            "C23 constexpr: an aggregate's discarded read isn't a constant expression",
            "static int s;\n"
            "void f(void) {\n"
            "    constexpr double a[1] =\n"
            "        { (s, 0.75) };\n"
            "    (void)a;\n"
            "}\n",
            true,
            false,
            .standard = 2023
        },
        {
            "C23 constexpr: a discarded constant still initializes",
            "void f(void) {\n"
            "    constexpr double d =\n"
            "        (1, 0.75);\n"
            "    constexpr double a[1] =\n"
            "        { (1, 0.75) };\n"
            "    (void)d;\n"
            "    (void)a;\n"
            "}\n",
            false,
            false,
            .standard = 2023
        },
        {
            "C23 constexpr: without an initializer",
            "void f(void) {\n"
            "    constexpr int\n"
            "        x;\n"
            "}\n",
            true,
            false,
            .standard = 2023
        },
        {
            "C23 constexpr: a typedef",
            "typedef constexpr int\n"
            "    T;\n",
            true,
            false,
            .standard = 2023
        },
        // A tag first named in a definition's parameter list has the body's scope too (C11 6.2.1p4), and ends with
        // it; a prototype's ends with the prototype (#435).
        {
            "definition's parameter-list tag in its body",
            "int f(struct T *p) { struct T *q = p; return q != 0; }\n",
            false,
            false
        },
        {
            "body's definition completes its parameter-list tag",
            "int f(struct T *p) { struct T { int x; }; return p->x; }\n",
            false,
            false
        },
        {
            "body's forward declaration keeps its parameter-list tag",
            "int f(struct T *p) { struct T; struct T *q = p; return q != 0; }\n",
            false,
            false
        },
        {
            "inner block's forward declaration hides a parameter-list tag",
            "int f(struct T *p) { { struct T;\n struct T *q = p; return q != 0; } }\n",
            true,
            false
        },
        {
            "parameter-list tags of a bound and a typeof in the body",
            "int f(int a[sizeof(struct V *)], typeof(struct W *) b, struct V *c) { struct V *v = c; struct W *w = b; return (v != 0) + (w != 0) + a[0]; }\n",
            false,
            false
        },
        {
            "body's prototype names its parameter-list tag",
            "int f(struct T *p) { int g(struct T *q);\n return g(p); }\n",
            false,
            false
        },
        {
            "definition's parameter-list tag ends with its body",
            "int f(struct T *p) { return p != 0; }\nstruct T *t;\nint g(void) { return f(t); }\n",
            true,
            false
        },
        {
            "prototype's parameter-list tag ends with it",
            "void g(struct S *p);\nint f(void) { struct S *q = 0; g(q); return 0; }\n",
            true,
            false
        },
        {
            "prototype's parameter-list tag isn't the file scope's",
            "void g(struct S *p);\nstruct S { int x; };\nint f(void) { struct S s = { 1 }; g(&s); return s.x; }\n",
            true,
            false
        },
        {
            "nested prototype's tag ends before the body",
            "int f(struct T *p, int (*k)(struct U *)) {\n struct U *v = 0; return k(v) + (p != 0); }\n",
            true,
            false
        },
        {
            "return type's prototype tag ends before the body",
            "int (*f(struct T *p))(struct U *u) {\n struct T *q = p;\n struct U *v = 0;\n int (*k)(struct U *) = f(q);\n return k(v); }\n",
            true,
            false
        },
        // A prototype's tag in a constant expression's type name (a typeof's, a builtin's operand) ends at the
        // prototype's `)` too (#437).
        {
            "typeof's prototype tag in a parameter list ends with the prototype",
            "int f(typeof(int (*)(struct Z *)) g, struct Z *z) { return g(z); }\n",
            true,
            false
        },
        {
            "file-scope typeof's prototype tag ends with the prototype",
            "typeof(int (*)(struct Z *)) g;\nstruct Z *z;\nint f(void) { return g(z); }\n",
            true,
            false
        },
        {
            "block-scope typeof's prototype tag ends with the prototype",
            "int f(void) {\n typeof(int (*)(struct Z *)) h = 0;\n struct Z *z = 0;\n return h(z); }\n",
            true,
            false
        },
        {
            "typeof's prototype tag in a parameter list doesn't reach the body",
            "int f(typeof(int (*)(struct Z *)) g) {\n struct Z *z = 0;\n return g(z); }\n",
            true,
            false
        },
        {
            "typeof's prototype names the visible tag",
            "struct Z;\ntypeof(int (*)(struct Z *)) g;\nstruct Z *z;\nint f(void) { return g(z); }\n",
            false,
            false
        },
        {
            "builtin operands' prototype tags are each their own",
            "_Static_assert(!__builtin_types_compatible_p(int (*)(struct Y *), int (*)(struct Y *)), \"distinct\");\n",
            false,
            false
        },
        {
            "nested prototype's tag in a typeof ends with each prototype",
            "typeof(int (*)(int (*)(struct Z *), struct Z *)) g;\nint h(struct Z *);\nint f(void) { return g(h, 0); }\n",
            true,
            false
        },
        {
            "register parameter's prototype tag ends with the prototype",
            "_Static_assert(!__builtin_types_compatible_p(int (*)(register struct S *), int (*)(struct S *)), \"distinct\");\n",
            false,
            false
        },
        // A C23 attribute's operand is read raw (#437's review): a list whose parameter starts with `register` or an
        // attribute is a prototype there too, its tag ended at its `)`.
        {
            "raw register parameter's prototype tag ends with the prototype",
            "[[gnu::aligned(sizeof(int (*)(register struct Z *)))]] int a;\nint (*g)(struct Z *);\nstruct Z *z;\nint f(void) { return g(z) + a; }\n",
            true,
            false,
            false,
            2023
        },
        {
            "raw attributed parameter's prototype tag ends with the prototype",
            "[[gnu::aligned(sizeof(int (*)(__attribute__((unused)) struct Z *)))]] int a;\nint (*g)(struct Z *);\nstruct Z *z;\nint f(void) { return g(z) + a; }\n",
            true,
            false,
            false,
            2023
        },
        {
            "raw function type of a register parameter",
            "[[gnu::aligned(sizeof(int (register struct Z *)))]] int a;\nint (*g)(struct Z *);\nstruct Z *z;\nint f(void) { return g(z) + a; }\n",
            true,
            false,
            false,
            2023
        },
        // A struct, union or enum defined in a parameter list (#438): read where it is, in source order, its tags and
        // enumeration constants in the list's scope, which is a scope of its own; a definition's are its body's too,
        // and a prototype's end with it.
        {
            "struct defined in a definition's parameter list",
            "int f(struct S { int x; } s) { return s.x; }\n",
            false,
            false
        },
        {
            "enum defined in a definition's parameter list, its constants in the body",
            "int f(enum E { K = 7 } e) { return K + (e == K); }\n",
            false,
            false
        },
        {
            "definition in a sizeof in a parameter's array bound, its tag in later parameters and the body",
            "int f(int a[sizeof(struct V { int x; })], struct V *v) { struct V *w = v; return w->x; }\n",
            false,
            false
        },
        {
            "parameter-list definitions' nested tags and constants in the body",
            "int f(union U { struct S { int x; } s; enum E { A, B } e; } u) { struct S t = u.s; enum E k = B; return t.x + (k == u.e) + A; }\n",
            false,
            false
        },
        {
            "parameter-list constant in a later parameter's bound",
            "int f(enum E { K = 3 } e, char (*p)[K + 1]) { _Static_assert(sizeof(*p) == 4, \"bound\"); return K + e; }\n",
            false,
            false
        },
        {
            "parameter-list constant shadows the file scope's in the body alone",
            "enum { K = 5 };\nint f(enum E { K = 1 } e) { _Static_assert(K == 1, \"body\"); return K + e; }\n_Static_assert(K == 5, \"file\");\n",
            false,
            false
        },
        {
            "prototype's list is a scope of its own",
            "struct S { long z; };\nenum { K };\nvoid g(struct S { int x; } s, enum E { K = 4 } e, struct S *p);\n",
            false,
            false
        },
        {
            "parameter list's redefinition of a tag only warns",
            "int f(struct S { int x; } a, struct S { int y; } b, struct S *c) { return a.x + b.y + c->x; }\n",
            false,
            false
        },
        {
            "definitions in a member's parameters and array bound",
            "struct A { void (*g)(struct B { int y; } b); int a[sizeof(struct C { int z; })]; };\nstruct C c;\nstruct B *q;\n",
            false,
            false
        },
        {
            "definitions in array bounds at file and block scope",
            "int a[sizeof(struct V { int x; })];\nstruct V v;\nint f(void) { int b[sizeof(struct W { int y; })]; struct W w = { 1 }; return w.y + (int)sizeof(b) + v.x; }\n",
            false,
            false
        },
        {
            "definitions in a type name's parameters and a variable bound",
            "int f(int n, int a[n + sizeof(struct V { int x; })]) { struct V v = { n }; return v.x + a[0] + (int)sizeof(void (*)(struct W { int y; })); }\n",
            false,
            false
        },
        {
            "enum of a fixed underlying type defined in a parameter list",
            "int f(enum E : long { K = 7 } e) { _Static_assert(sizeof(K) == sizeof(long), \"C23\"); return K == e; }\n",
            false,
            false,
            .standard = 2023
        },
        {
            "prototype's parameter-list constant ends with it",
            "void g(enum E { K = 7 } e);\nint f(void) { return K; }\n",
            true,
            false
        },
        {
            "prototype's parameter-list definition isn't the file scope's",
            "void g(struct S { int x; } s);\nstruct S { int x; } t;\nint f(void) { g(t);\n return 0; }\n",
            true,
            false
        },
        {
            "definition in a prototype's array bound ends with it",
            "void g(int a[sizeof(struct V { int x; })]);\nstruct V v;\n",
            true,
            false
        },
        {
            "nested prototype's constant ends before the body",
            "int f(int (*k)(enum E { K = 1 } e)) {\n return K; }\n",
            true,
            false
        },
        {
            "return type's prototype constant ends before the body",
            "int (*f(int x))(enum E { K } e) {\n return K + x; }\n",
            true,
            false
        },
        {
            "parameter and later enumeration constant of one list conflict",
            "int f(int K,\n enum E { K = 1 } e);\n",
            true,
            false
        },
        {
            "enumeration constant and later parameter of one list conflict",
            "int f(enum E { K = 1 } e,\n int K);\n",
            true,
            false
        },
        {
            "body's declaration conflicts with its parameter-list constant",
            "int f(enum E { K = 7 } e) {\n int K = 1; return K + e; }\n",
            true,
            false
        },
        {
            "body's definition redefines its parameter-list definition",
            "int f(struct S { int x; } s) {\n struct S { int y; } t; return t.y + s.x; }\n",
            true,
            false
        },
        // A definition in a prototype that a bound's type name holds is that prototype's, a scope a level deeper which
        // ends at its `)`, and a bound's definitions are read beside its statement expressions, before or after them
        // (#460's review).
        {
            "bound's nested prototype's constant ends before the body",
            "int f(int a[sizeof(void (*)(enum E { K = 7 }))]) {\n return K; }\n",
            true,
            false
        },
        {
            "bound's nested prototype's definition isn't the body's",
            "int g(int a[sizeof(void (*)(struct S { int x; }))]) {\n struct S s = { 1 }; return s.x; }\n",
            true,
            false
        },
        {
            "bound's nested prototype's constant doesn't conflict with a parameter",
            "int f(int K, int a[sizeof(void (*)(enum E { K = 7 }))]) { return K; }\n",
            false,
            false
        },
        {
            "bound's nested prototype's definition doesn't complete the list's tag",
            "int g(struct S *p, int a[sizeof(void (*)(struct S { int x; }))]) {\n return p->x; }\n",
            true,
            false
        },
        {
            "bound's nested prototype's definition beside the list's",
            "int g(struct S { int y; } *p, int a[sizeof(void (*)(struct S { int x; }))]) { return p->y; }\n",
            false,
            false
        },
        {
            "enumerator value's nested prototype's constant doesn't conflict",
            "enum X { K = 2, A = sizeof(void (*)(enum E { K = 1 })) };\n_Static_assert(K == 2, \"outer\");\n",
            false,
            false
        },
        {
            "file-scope bound's nested prototype's definition ends with it",
            "int a[sizeof(void (*)(struct S { int x; }))];\nstruct S s;\n",
            true,
            false
        },
        {
            "member bound's nested prototype's definition ends with it",
            "struct T { int a[sizeof(void (*)(struct S { int x; }))]; };\nstruct S s;\n",
            true,
            false
        },
        {
            "nested prototype's constant in its own later bound",
            "int f(int a[sizeof(void (*)(enum E { K = 7 }, int b[K]))]) { return 0; }\n",
            false,
            false
        },
        {
            "bound's definition before a statement expression",
            "int f(void) { int a[sizeof(struct S { int x; }) + ({ 1; })]; struct S s = { 0 }; return s.x + (int)sizeof a; }\n",
            false,
            false
        },
        {
            "bound's definition after a statement expression",
            "int f(void) { int a[({ 1; }) + sizeof(struct S { int x; })]; struct S s = { 0 }; return s.x + (int)sizeof a; }\n",
            false,
            false
        },
        {
            "bound's definition between statement expressions",
            "int f(int m) { int a[({ m; }) + sizeof(struct S { int x; }) + ({ m + 1; })]; struct S s = { 0 }; return s.x + (int)sizeof a; }\n",
            false,
            false
        },
        // #126: the builtins this compiler's own main.c calls, which clang checks as these show.
        {
            "atomic read-modify-write builtins and their result types",
            "typedef unsigned long U64;\nint f(U64* u, int* i, unsigned char* c, _Bool* b, int** p, double* d)\n{\n    _Static_assert(_Generic(__atomic_fetch_add(u, 1, __ATOMIC_RELAXED), U64: 1, default: 0), \"fetch_add\");\n    _Static_assert(_Generic(__atomic_add_fetch(i, 1, __ATOMIC_SEQ_CST), int: 1, default: 0), \"add_fetch\");\n    _Static_assert(_Generic(__atomic_exchange_n(c, 1, __ATOMIC_ACQ_REL), unsigned char: 1, default: 0), \"exchange_n\");\n    _Static_assert(_Generic(__atomic_compare_exchange_n(i, i, 3, 0, __ATOMIC_SEQ_CST, __ATOMIC_RELAXED), _Bool: 1, default: 0), \"cas\");\n    _Static_assert(_Generic(__atomic_fetch_add(p, 4, __ATOMIC_RELAXED), int*: 1, default: 0), \"pointer add\");\n    _Static_assert(_Generic(__atomic_fetch_sub(d, 1, __ATOMIC_RELAXED), double: 1, default: 0), \"fetch_sub double\");\n    _Static_assert(_Generic(__sync_val_compare_and_swap(u, 1, 2), U64: 1, default: 0), \"sync val cas\");\n    _Static_assert(_Generic(__sync_bool_compare_and_swap(u, 1, 2), _Bool: 1, default: 0), \"sync bool cas\");\n    __sync_lock_release(b);\n    (void)__sync_fetch_and_or(u, 1, i, c);\n    (void)__atomic_fetch_nand(u, 1, __ATOMIC_RELAXED);\n    (void)__atomic_xor_fetch(b, 1, __ATOMIC_RELAXED);\n    return __sync_fetch_and_add(i, 1) + __sync_lock_test_and_set(c, 1);\n}\n",
            false,
            false
        },
        {
            "atomic min and max",
            "unsigned f(unsigned* u, int* i, float* x, _Bool* b)\n{\n    _Static_assert(_Generic(__atomic_fetch_min(u, 1, __ATOMIC_RELAXED), unsigned: 1, default: 0), \"fetch_min\");\n    _Static_assert(_Generic(__atomic_max_fetch(x, 1, __ATOMIC_RELAXED), float: 1, default: 0), \"max_fetch\");\n    return __atomic_fetch_max(i, 1, 5) + __atomic_min_fetch(u, 2, 0) + __atomic_fetch_min(b, 1, 5);\n}\n",
            false,
            false
        },
        {
            "an atomic min of a pointer refused",
            "int* f(int** p) { return __atomic_fetch_min(p, 0, 5); }\n",
            true,
            false
        },
        {
            "an atomic and of a float refused",
            "float f(float* p) { return __atomic_fetch_and(p, 1, 5); }\n",
            true,
            false
        },
        {
            "an atomic compare-exchange of a float refused",
            "_Bool f(float* p, float* e) { return __atomic_compare_exchange_n(p, e, 1, 0, 5, 2); }\n",
            true,
            false
        },
        {
            "an atomic exchange of a const object refused",
            "int f(const int* p) { return __atomic_exchange_n(p, 1, 5); }\n",
            true,
            false
        },
        {
            "an atomic read-modify-write of a _BitInt refused",
            "unsigned _BitInt(32) f(unsigned _BitInt(32)* p) { return __atomic_fetch_add(p, 1, 5); }\n",
            true,
            false
        },
        {
            "an atomic fetch with an order too few refused",
            "int f(int* p) { return __atomic_fetch_add(p, 1); }\n",
            true,
            false
        },
        // #148: the atomics clang has past the _n forms, as clang checks them.
        {
            "sized legacy atomics, the legacy minimum and maximum, and their result types",
            "int f(short* s, long* l, int* i, unsigned* u, void* v, _Bool* b)\n{\n    _Static_assert(_Generic(__sync_fetch_and_add_4(s, 1), short: 1, default: 0), \"sized by the object\");\n    _Static_assert(_Generic(__sync_val_compare_and_swap_1(l, 1, 2), long: 1, default: 0), \"val cas\");\n    _Static_assert(_Generic(__sync_bool_compare_and_swap_16(i, 1, 2), _Bool: 1, default: 0), \"bool cas\");\n    _Static_assert(_Generic(__sync_swap(l, 3), long: 1, default: 0), \"swap\");\n    _Static_assert(_Generic(__sync_fetch_and_umax(i, 1), unsigned: 1, default: 0), \"umax\");\n    __sync_lock_release_8(b);\n    return __sync_fetch_and_max(i, 5) + (int)__sync_fetch_and_umin(u, 2) + __sync_fetch_and_min(v, 3) + (int)__sync_swap_2(s, 1);\n}\n",
            false,
            false
        },
        {
            "a legacy maximum of a long refused",
            "long l;\nint f(void) { return __sync_fetch_and_max(&l, 5); }\n",
            true,
            false
        },
        {
            "a legacy minimum with a protected variable refused",
            "int i;\nint f(void) { return __sync_fetch_and_min(&i, 5, i); }\n",
            true,
            false
        },
        {
            "wrapping atomics, the byte flag and the lock-free queries",
            "struct Opaque;\nlong cell;\nenum { E = __atomic_always_lock_free(8, &cell) + __atomic_is_lock_free(2, 0) };\n_Static_assert(!__atomic_always_lock_free(3, 0), \"odd\");\nint f(unsigned char* c, _Bool* b, void* v, struct Opaque* o)\n{\n    _Static_assert(_Generic(__atomic_fetch_uinc(c, 3, __ATOMIC_SEQ_CST), unsigned char: 1, default: 0), \"uinc\");\n    _Static_assert(_Generic(__atomic_test_and_set(v, __ATOMIC_ACQUIRE), _Bool: 1, default: 0), \"tas\");\n    __atomic_clear(o, __ATOMIC_RELEASE);\n    return __atomic_fetch_udec(b, 1, __ATOMIC_RELAXED) + E + __atomic_is_lock_free(16, v);\n}\n",
            false,
            false
        },
        {
            // #932's review: a function's pointee is complete and aligned to 4 bytes, and a tag is complete where the query's
            // constant context reads it, not at the unit's end.
            "the lock-free queries of a function's pointee and of a tag completed after them",
            "struct Late;\nint late(struct Late* p) { _Static_assert(!__atomic_always_lock_free(8, p), \"incomplete here\"); return 0; }\n"
            "struct Late { long x; };\nint early(struct Late* p) { _Static_assert(__atomic_always_lock_free(8, p), \"complete here\"); return 0; }\n"
            "int function(void (*p)(void))\n{\n    _Static_assert(__atomic_always_lock_free(4, p) && __atomic_is_lock_free(4, p), \"function alignment\");\n"
            "    _Static_assert(!__atomic_always_lock_free(8, p), \"past it\");\n    return 0;\n}\n",
            false,
            false
        },
        {
            "an atomic wrapping increment of a float refused",
            "float f(float* p) { return __atomic_fetch_uinc(p, 1, 5); }\n",
            true,
            false
        },
        {
            "the byte flag of a const object refused",
            "void f(const void* p) { __atomic_clear(p, 5); }\n",
            true,
            false
        },
        {
            "generic atomics of records, arrays and long double",
            "struct S { char c[3]; };\nint f(struct S* s, int (*a)[3], long double* d)\n{\n    struct S r, v = { { 1, 2, 3 } };\n    int x[3], y[3] = { 1, 2, 3 };\n    long double e = 1.0L, n = 2.0L;\n    __atomic_load(s, &r, __ATOMIC_SEQ_CST);\n    __atomic_store(a, &y, __ATOMIC_RELEASE);\n    __atomic_exchange(s, &v, &r, __ATOMIC_ACQ_REL);\n    __atomic_load(a, &x, __ATOMIC_ACQUIRE);\n    return __atomic_compare_exchange(d, &e, &n, 1, __ATOMIC_SEQ_CST, __ATOMIC_RELAXED) + r.c[0] + x[1];\n}\n",
            false,
            false
        },
        {
            "a generic atomic load of an _Atomic object refused",
            "_Atomic int x;\nint f(int* r) { __atomic_load(&x, r, 5); return *r; }\n",
            true,
            false
        },
        {
            "a generic atomic store's incompatible value pointer refused",
            "int x;\nvoid f(long* v) { __atomic_store(&x, v, 5); }\n",
            true,
            false
        },
        {
            "scoped, HIP and OpenCL atomics",
            "_Atomic int a;\nint f(int* p, int* e, int s)\n{\n    __scoped_atomic_thread_fence(__ATOMIC_SEQ_CST, 9);\n    __opencl_atomic_init(&a, 1);\n    return __scoped_atomic_fetch_add(p, 1, __ATOMIC_SEQ_CST, s) + __scoped_atomic_compare_exchange_n(p, e, 2, 0, 5, 5, __MEMORY_SCOPE_DEVICE) +\n           __hip_atomic_load(p, 5, 1) + __hip_atomic_compare_exchange_strong(p, e, 3, 5, 5, 6) + __opencl_atomic_fetch_add(&a, 1, 5, 4);\n}\n",
            false,
            false
        },
        {
            "a scoped atomic's invalid scope refused",
            "int f(int* p) { return __scoped_atomic_load_n(p, 5, 6); }\n",
            true,
            false
        },
        {
            "a HIP atomic's invalid scope refused",
            "int f(int* p) { return __hip_atomic_load(p, 5, 0); }\n",
            true,
            false
        },
        {
            "an OpenCL atomic of a plain object refused",
            "int f(int* p) { return __opencl_atomic_load(p, 5, 2); }\n",
            true,
            false
        },
        {
            "a HIP atomic of an _Atomic object refused",
            "_Atomic int a;\nint f(void) { return __hip_atomic_load(&a, 5, 1); }\n",
            true,
            false
        },
        // #148: clang's atomic IEEE maximum and minimum, as clang checks them (of floating objects alone, complex ones
        // too, but not long double's).
        {
            "an atomic IEEE maximum of a _Complex float",
            "_Complex float z; int f(void){ __atomic_fetch_fmaximum(&z, 1.0f, 5); return 0; }\n",
            false,
            false
        },
        {
            "an atomic IEEE maximum of a _Float16",
            "_Float16 h; int f(void){ __atomic_fetch_fmaximum(&h, 1.0f, 5); return 0; }\n",
            false,
            false
        },
        {
            "an atomic IEEE minimum of a __bf16",
            "__bf16 b; int f(void){ __atomic_fetch_fminimum(&b, 1.0f, 5); return 0; }\n",
            false,
            false
        },
        {
            "an atomic IEEE maximum_num of a __float128",
            "__float128 q; int f(void){ __atomic_fetch_fmaximum_num(&q, 1.0, 5); return 0; }\n",
            false,
            false
        },
        {
            "an atomic IEEE maximum of a long double refused",
            "long double l; int f(void){ __atomic_fetch_fmaximum(&l, 1.0, 5); return 0; }\n",
            true,
            false
        },
        {
            "an atomic IEEE maximum of a double by an int",
            "double d; int f(void){ return __atomic_fetch_fmaximum(&d, 1, 5); }\n",
            false,
            false
        },
        {
            "an atomic IEEE maximum with an argument too many refused",
            "float x; int f(void){ return __atomic_fetch_fmaximum(&x, 1.0, 5, 6); }\n",
            true,
            false
        },
        {
            "an atomic IEEE maximum of a const float refused",
            "const float x; int f(void){ return __atomic_fetch_fmaximum(&x, 1.0, 5); }\n",
            true,
            false
        },
        {
            "an atomic IEEE minimum_num with an order past seq_cst",
            "float x; int f(void){ return __atomic_fetch_fminimum_num(&x, 1.0, 7); }\n",
            false,
            false
        },
        {
            "an atomic IEEE maximum of an int refused",
            "int x; int f(void){ return __atomic_fetch_fmaximum(&x, 1, 5); }\n",
            true,
            false
        },
        {
            "an atomic IEEE minimum of a pointer refused",
            "int *p; int f(void){ __atomic_fetch_fminimum(&p, 0, 5); return 0; }\n",
            true,
            false
        },
        {
            "an atomic IEEE maximum_num of a _Bool refused",
            "_Bool b; int f(void){ return __atomic_fetch_fmaximum_num(&b, 1, 5); }\n",
            true,
            false
        },
        {
            "an atomic IEEE maximum of a struct refused",
            "struct S { float f; } s; int f(void){ __atomic_fetch_fmaximum(&s, s, 5); return 0; }\n",
            true,
            false
        },
        {
            "an atomic IEEE maximum of a value, not its address, refused",
            "float x; int f(void){ return __atomic_fetch_fmaximum(x, 1, 5); }\n",
            true,
            false
        },
        {
            "an atomic IEEE maximum of a float by an int",
            "float x; int f(void){ return __atomic_fetch_fmaximum(&x, 1, 5); }\n",
            false,
            false
        },
        {
            "an atomic IEEE maximum by a pointer refused",
            "float x; int f(void){ return __atomic_fetch_fmaximum(&x, &x, 5); }\n",
            true,
            false
        },
        {
            "an atomic IEEE minimum_num with arguments too few refused",
            "float x; int f(void){ return __atomic_fetch_fminimum_num(&x); }\n",
            true,
            false
        },
        {
            "an atomic IEEE maximum of an _Atomic float refused",
            "_Atomic float x; int f(void){ return __atomic_fetch_fmaximum(&x, 1, 5); }\n",
            true,
            false
        },
        {
            "an atomic IEEE minimum of a volatile double by a float",
            "volatile double x; double f(void){ return __atomic_fetch_fminimum(&x, 2.0f, 2); }\n",
            false,
            false
        },
        {
            "an atomic IEEE maximum with its order known at run time",
            "float x; int f(int o){ return __atomic_fetch_fmaximum(&x, 1, o); }\n",
            false,
            false
        },
        {
            "a scoped atomic IEEE maximum's invalid scope refused",
            "float x; int f(void){ return __scoped_atomic_fetch_fmaximum(&x, 1, 5, 7); }\n",
            true,
            false
        },
        {
            "a scoped atomic IEEE minimum_num without its scope refused",
            "float x; int f(void){ return __scoped_atomic_fetch_fminimum_num(&x, 1, 5); }\n",
            true,
            false
        },
        {
            "an atomic minimum of a long double refused",
            "long double l; int f(void){ __atomic_fetch_min(&l, 1.0, 5); return 0; }\n",
            true,
            false
        },
        {
            "an atomic IEEE maximum of an int by a float refused",
            "int x; int f(void){ return __atomic_fetch_fmaximum(&x, 1.0f, 5); }\n",
            true,
            false
        },
        {
            "an atomic IEEE maximum of a _Complex long double",
            "_Complex long double z; int f(void){ __atomic_fetch_fmaximum(&z, 1.0, 5); return 0; }\n",
            false,
            false
        },
        {
            "an atomic IEEE minimum_num of a _Complex double",
            "_Complex double z; int f(void){ __atomic_fetch_fminimum_num(&z, 1.0, 5); return 0; }\n",
            false,
            false
        },
        {
            "an atomic minimum of a _Complex long double",
            "_Complex long double z; int f(void){ __atomic_fetch_min(&z, 1.0, 5); return 0; }\n",
            false,
            false
        },
        {
            "an atomic IEEE maximum of an over-aligned float",
            "typedef float __attribute__((aligned(16))) F; F x; int f(void){ return __atomic_fetch_fmaximum(&x, 1, 5); }\n",
            false,
            false
        },
        {
            "an atomic IEEE maximum of a vector refused",
            "typedef float V __attribute__((vector_size(16))); V v; int f(void){ __atomic_fetch_fmaximum(&v, v, 5); return 0; }\n",
            true,
            false
        },
        {
            "an atomic IEEE maximum of an enum refused",
            "enum E { A } e; int f(void){ return __atomic_fetch_fmaximum(&e, 1, 5); }\n",
            true,
            false
        },
        {
            "an atomic IEEE maximum with two arguments too many refused",
            "float x; void f(void){ (void)__atomic_fetch_fmaximum(&x, 1, 5, 6, 7); }\n",
            true,
            false
        },
        {
            "a scoped atomic IEEE maximum_num",
            "float x; int f(void){ return __scoped_atomic_fetch_fmaximum_num(&x, 1, 5, 3); }\n",
            false,
            false
        },
        {
            "an atomic IEEE minimum of a const volatile float refused",
            "const volatile float x; int f(void){ return __atomic_fetch_fminimum(&x, 1, 5); }\n",
            true,
            false
        },
        {
            "an atomic IEEE minimum by a null pointer refused",
            "float x; int f(void){ return __atomic_fetch_fminimum(&x, (void*)0, 5); }\n",
            true,
            false
        },
        {
            "an atomic IEEE maximum through a void pointer refused",
            "float x; int f(void){ return __atomic_fetch_fmaximum((void*)&x, 1, 5); }\n",
            true,
            false
        },
        {
            "128-bit operands of the overflow builtins",
            "int f(__int128 a, unsigned __int128 b, long c)\n{\n    __int128 r = 0;\n    unsigned __int128 u = 0;\n    return __builtin_mul_overflow(a, b, &r) + __builtin_add_overflow(c, a, &u) + __builtin_sub_overflow(b, c, &r);\n}\n",
            false,
            false
        },
        {
            "the rotates, unpredictable and assume",
            "unsigned long long f(unsigned char a, unsigned short b, unsigned c, unsigned long long d, long x)\n{\n    __builtin_assume(x > 0);\n    return __builtin_rotateleft8(a, 1) + __builtin_rotateright8(a, 9) + __builtin_rotateleft16(b, 3) + __builtin_rotateright16(b, 3) +\n           __builtin_rotateleft32(c, 7) + __builtin_rotateright32(c, 7) + __builtin_rotateleft64(d, 9) + __builtin_rotateright64(d, 9) +\n           (__builtin_unpredictable(x > 2) ? 1 : 0);\n}\n",
            false,
            false
        },
        {
            "a rotate of a struct refused",
            "struct S { int a; } s;\nunsigned f(void) { return __builtin_rotateleft32(s, 1); }\n",
            true,
            false
        },
        {
            "an assumption of a struct refused",
            "void f(void) { struct S { int a; } s = { 0 }; __builtin_assume(s); }\n",
            true,
            false
        },
        {
            "rdtsc, pause and xgetbv",
            "unsigned long long f(void)\n{\n    __builtin_ia32_pause();\n    return __rdtsc() + __builtin_ia32_xgetbv(0);\n}\n",
            false,
            false
        },
        {
            "the build's immediates of the x86 builtins in range",
            "typedef int I16 __attribute__((vector_size(64)));\ntypedef long long L8 __attribute__((vector_size(64)));\ntypedef long long L4 __attribute__((vector_size(32)));\ntypedef long long L2 __attribute__((vector_size(16)));\ntypedef int I8 __attribute__((vector_size(32)));\ntypedef int I4 __attribute__((vector_size(16)));\ntypedef char C16 __attribute__((vector_size(16)));\ntypedef char C32 __attribute__((vector_size(32)));\ntypedef short S32 __attribute__((vector_size(64)));\nunsigned long long f(I16 a, L8 q, L4 h, L2 t, I8 e, I4 i, C16 c, C32 w, S32 s, const void* p, void* o)\n{\n    unsigned long long r = __builtin_ia32_ucmpd512_mask(a, a, 7, 0xffff) + __builtin_ia32_ucmpd256_mask(e, e, 0, 0xff) +\n                           __builtin_ia32_ucmpd128_mask(i, i, 1, 0xff) +\n                           __builtin_ia32_ucmpb128_mask(c, c, 4, 0xffff) + __builtin_ia32_ucmpb256_mask(w, w, 4, ~0u) +\n                           __builtin_ia32_ucmpw512_mask(s, s, 6, ~0u) + __builtin_ia32_kshiftlihi(1, 255) + __builtin_ia32_kshiftlidi(1, 0);\n    I16 g = __builtin_ia32_gathersiv16si(a, p, a, 0xffff, 4) + __builtin_ia32_alignd512(a, a, 255) + __builtin_ia32_shuf_i32x4(a, a, 0) +\n            __builtin_ia32_inserti32x4(a, i, 3) + __builtin_ia32_prold512(a, 31);\n    L8 l = __builtin_ia32_gathersiv8di(q, p, e, 0xff, 8) + __builtin_ia32_gatherdiv8di(q, p, q, 0xff, 1) + __builtin_ia32_alignq512(q, q, 7);\n    __builtin_ia32_scatterdiv16si(o, 0xff, q, e, 2);\n    __builtin_ia32_scatterdiv8di(o, 0xff, q, q, 8);\n    __builtin_ia32_scattersiv16si(o, 0xffff, a, a, 4);\n    L4 x = __builtin_ia32_extracti64x4_mask(q, 1, h, 0xff) + __builtin_ia32_insert128i256(h, t, 1);\n    I4 v = __builtin_ia32_vec_set_v4si(i, 5, 3);\n    return r + (unsigned long long)g[0] + (unsigned long long)l[0] + (unsigned long long)x[0] + (unsigned long long)v[0] +\n           (unsigned)__builtin_ia32_vec_ext_v4si(i, 3) + (unsigned char)__builtin_ia32_vec_ext_v16qi(c, 15);\n}\n",
            false,
            false
        },
        {
            "a gather's scale refused",
            "typedef int I16 __attribute__((vector_size(64)));\nI16 f(I16 a, const void* p) { return __builtin_ia32_gathersiv16si(a, p, a, 0xffff, 3); }\n",
            true,
            false
        },
        {
            "a scatter's scale refused",
            "typedef long long L8 __attribute__((vector_size(64)));\ntypedef int I8 __attribute__((vector_size(32)));\nvoid f(L8 q, I8 e, void* o) { __builtin_ia32_scatterdiv16si(o, 0xff, q, e, 16); }\n",
            true,
            false
        },
        {
            "unsigned one-bit _BitInt",
            "unsigned _BitInt(1) a = 1;\n_BitInt(1) unsigned b;\ntypedef unsigned _BitInt(1) B1;\nB1 c;\nint f(void) { unsigned _BitInt(1) d = 1; return d + (int)sizeof d + (int)sizeof(unsigned _BitInt(1)); }\n",
            false,
            false
        },
        {
            "signed one-bit _BitInt refused",
            "int a;\n_BitInt(1) x;\n",
            true,
            false
        },
        {
            "a typedef of an unsigned _BitInt keeps it unsigned",
            "typedef unsigned _BitInt(8) U8;\nU8 x = 255;\n_Static_assert((U8)-1 > 0, \"unsigned\");\ntypedef _BitInt(8) S8;\n_Static_assert((S8)-1 < 0, \"signed\");\nint f(void) { U8 y = 200; return y > 100; }\n",
            false,
            false
        },
        {
            // C23's bit-precise constants (#768): their types and values, in each radix, with digit separators and in each
            // order and case of their suffixes, past 64 bits too.
            "bit-precise constants",
            "_Static_assert(_Generic(0wb, _BitInt(2): 1, default: 0) && _Generic(1wb, _BitInt(2): 1, default: 0) && _Generic(2WB, _BitInt(3): 1, default: 0), \"s\");\n"
            "_Static_assert(_Generic(0uwb, unsigned _BitInt(1): 1, default: 0) && _Generic(5Uwb, unsigned _BitInt(3): 1, default: 0), \"u\");\n"
            "_Static_assert(_Generic(5wbU, unsigned _BitInt(3): 1, default: 0) && _Generic(5WBu, unsigned _BitInt(3): 1, default: 0) && 5uWB == 5, \"o\");\n"
            "_Static_assert(_Generic(0777wb, _BitInt(10): 1, default: 0) && _Generic(0b1010'1010wb, _BitInt(9): 1, default: 0) && 0777wb == 511, \"r\");\n"
            "_Static_assert(_Generic(0x8000'0000'0000'0000wb, _BitInt(65): 1, default: 0) && _Generic(0xffffffffffffffffuwb, unsigned _BitInt(64): 1, default: 0), \"x\");\n"
            "_Static_assert(_Generic(18446744073709551616wb, _BitInt(66): 1, default: 0) && 18446744073709551616wb == (_BitInt(66))1 << 64, \"w\");\n"
            "_Static_assert(_Generic(0xffffffffffffffffffffffffffffffffuwb, unsigned _BitInt(128): 1, default: 0) &&\n"
            "               0xffffffffffffffffffffffffffffffffuwb == (unsigned _BitInt(128))-1, \"m\");\n"
            "_Static_assert(_Generic(0x7fffffffffffffffffffffffffffffffwb, _BitInt(128): 1, default: 0) && -1wb < 0 && _Generic(-1wb, _BitInt(2): 1, default: 0), \"n\");\n"
            "unsigned _BitInt(100) a = 0xf'ffff'ffff'ffff'ffff'ffff'ffffuwb;\nint f(void) { return (int)(a >> 90) + (int)0x1ffffffffffffffffuwb; }\n",
            false,
            false,
            false,
            2023
        },
        {
            // Their constants past 128 bits (#1447, c_check_wide.c): literals, folds, truth and conversions, and static data.
            "bit-precise constants past 128 bits",
            "int a;\n_BitInt(129) b = 0xffffffffffffffffffffffffffffffffwb;\n"
            "_Static_assert(_Generic(0xffffffffffffffffffffffffffffffffwb, _BitInt(129): 1, default: 0) && _Generic(340282366920938463463374607431768211456uwb, unsigned _BitInt(129): 1, default: 0), \"t\");\n"
            "_Static_assert((_BitInt(200))1 << 150 > 0 && ((unsigned _BitInt(300))1 << 299) >> 297 == 4 && ((_BitInt(256))1 << 255 >> 1) < 0, \"f\");\n"
            "_Static_assert(340282366920938463463374607431768211457wb % 1000 == 457 && (int)(340282366920938463463374607431768211457wb >> 128) == 1, \"d\");\n"
            "int c[(_BitInt(200))3];\nenum { E = (int)((_BitInt(300))-7 * ((_BitInt(300))1 << 200) / ((_BitInt(300))1 << 199)) };\n_Static_assert(E == -14, \"e\");\n"
            "unsigned _BitInt(300) g = ~(unsigned _BitInt(300))0 / 3;\n_BitInt(1000) h = -((_BitInt(1000))1 << 900);\n",
            false,
            false,
            false,
            2023
        },
        {
            "a bit-precise suffix of mixed case",
            "int a;\n_BitInt(8) b = 5wB;\n",
            true,
            false,
            false,
            2023
        },
        {
            "no_builtin on definitions",
            "__attribute__((no_builtin(\"memset\"))) void f(void) {}\n__attribute__((no_builtin)) void g(void) {}\n__attribute__((no_builtin(\"memset\", \"memcpy\"))) void h(void) {}\n__attribute__((no_builtin(\"not_a_builtin\"))) void k(void) {}\nint x __attribute__((no_builtin(\"memset\")));\n",
            false,
            false
        },
        {
            "no_builtin on a declaration refused",
            "int a;\n__attribute__((no_builtin(\"memset\"))) void f(void);\n",
            true,
            false
        },
        {
            "no_builtin with a number refused",
            "int a;\n__attribute__((no_builtin(1))) void f(void) {}\n",
            true,
            false
        },
        {
            "FP_CONTRACT at file scope and a compound's start",
            "#pragma STDC FP_CONTRACT OFF\ndouble f(double a, double b) {\n#pragma STDC FP_CONTRACT ON\n return a * b + 1; }\n#pragma STDC FP_CONTRACT DEFAULT\ndouble g(double a) { if (a) {\n#pragma STDC FP_CONTRACT OFF\n return a; } return 0; }\n#pragma STDC FP_CONTRACT MAYBE\ndouble x;\n",
            false,
            false
        },
        {
            "FP_CONTRACT inside a compound refused",
            "double f(double a, double b) { double c = a * b;\n#pragma STDC FP_CONTRACT ON\n return c + 1; }\n",
            true,
            false
        },
        {
            "loop hints before each kind of loop",
            "int f(int* p, int n) { int s = 0;\n#pragma clang loop vectorize(disable) interleave(disable)\n for (int i = 0; i < n; i += 1) s += p[i];\n#pragma clang loop unroll(disable)\n while (n--) s += 1;\n#pragma clang loop unroll(full)\n do s += 1; while (s < 9);\n if (n)\n#pragma clang loop vectorize(assume_safety) interleave(assume_safety)\n while (n--) s += 1;\n#pragma clang loop vectorize(disable)\n#pragma clang loop interleave(disable)\n for (;;) break;\n return s; }\n",
            false,
            false
        },
        {
            "loop hint counts and widths",
            "int f(int* p, int n) { int s = 0;\n#pragma clang loop vectorize_width(4) unroll_count(8) interleave_count(2)\n while (n--) s += 1;\n#pragma clang loop vectorize_width(4, scalable) pipeline(disable)\n while (n--) s += 1;\n#pragma clang loop vectorize_width(fixed) vectorize_predicate(enable) distribute(enable) pipeline_initiation_interval(3)\n while (n--) s += 1;\n#pragma clang loop unroll_count(0x10) vectorize_predicate(enable) vectorize(disable)\n while (n--) s += 1;\n#pragma clang loop unroll(disable) vectorize(disable),\n while (n--) s += 1; return s; }\n",
            false,
            false
        },
        {
            "the unroll pragmas",
            "int f(int* p, int n) { int s = 0;\n#pragma unroll\n while (n--) s += 1;\n#pragma unroll 4\n while (n--) s += 1;\n#pragma unroll(4)\n while (n--) s += 1;\n#pragma nounroll\n while (n--) s += 1;\n#pragma unroll_and_jam 2\n while (n--) s += 1;\n#pragma nounroll_and_jam\n while (n--) s += 1;\n#pragma GCC unroll 4\n while (n--) s += 1;\n#pragma unroll 0\n while (n--) s += 1;\n#pragma nounroll 4\n while (n--) s += 1; return s; }\n",
            false,
            false
        },
        {
            "a loop hint before another statement refused",
            "int f(int* p, int n) { int s = 0;\n#pragma clang loop vectorize(disable)\n s = 1; return s; }\n",
            true,
            false
        },
        {
            "a loop hint before a block refused",
            "int f(int* p, int n) { int s = 0;\n#pragma clang loop vectorize(disable)\n { for (int i = 0; i < n; i += 1) s += p[i]; } return s; }\n",
            true,
            false
        },
        {
            "a loop hint before a labeled loop refused",
            "int f(int* p, int n) { int s = 0;\n#pragma clang loop unroll(disable)\n L: for (int i = 0; i < n; i += 1) s += p[i]; return s; }\n",
            true,
            false
        },
        {
            "a loop hint after a do-while refused",
            "int f(int* p, int n) { int s = 0;\n#pragma clang loop unroll(disable)\n do s += 1; while (--n);\n#pragma clang loop unroll(disable)\n return s; }\n",
            true,
            false
        },
        {
            "a loop hint before a closing brace refused",
            "int f(int* p, int n) { int s = 0;\n#pragma clang loop unroll(disable)\n}\n",
            true,
            false
        },
        {
            "an unroll pragma before another statement refused",
            "int f(int* p, int n) { int s = 0;\n#pragma unroll\n s = 1; return s; }\n",
            true,
            false
        },
        {
            "a loop hint at file scope refused",
            "#pragma clang loop vectorize(disable)\nint x;\n",
            true,
            false
        },
        {
            "a loop hint's invalid argument refused",
            "int f(int* p, int n) { int s = 0;\n#pragma clang loop vectorize(maybe)\n for (int i = 0; i < n; i += 1) s += p[i]; return s; }\n",
            true,
            false
        },
        {
            "a loop hint's invalid option refused",
            "int f(int* p, int n) { int s = 0;\n#pragma clang loop vectorise(enable)\n for (int i = 0; i < n; i += 1) s += p[i]; return s; }\n",
            true,
            false
        },
        {
            "a loop hint without an option refused",
            "int f(int* p, int n) { int s = 0;\n#pragma clang loop\n for (int i = 0; i < n; i += 1) s += p[i]; return s; }\n",
            true,
            false
        },
        {
            "a loop hint without parentheses refused",
            "int f(int* p, int n) { int s = 0;\n#pragma clang loop vectorize enable\n for (int i = 0; i < n; i += 1) s += p[i]; return s; }\n",
            true,
            false
        },
        {
            "a loop hint left open refused",
            "int f(int* p, int n) { int s = 0;\n#pragma clang loop unroll(disable\n while (n--) s += 1; return s; }\n",
            true,
            false
        },
        {
            "a loop hint's zero count refused",
            "int f(int* p, int n) { int s = 0;\n#pragma clang loop unroll_count(0)\n for (int i = 0; i < n; i += 1) s += p[i]; return s; }\n",
            true,
            false
        },
        {
            "a loop hint's count past int refused",
            "int f(int* p, int n) { int s = 0;\n#pragma clang loop interleave_count(2147483648)\n while (n--) s += 1; return s; }\n",
            true,
            false
        },
        {
            // #830's review: a bit-precise pack value's low 64 bits alone made 0x10000000000000001uwb an alignment of 1, and
            // one past 128 bits wrapped to its low bits. clang ignores both, with its alignment warning, and takes small ones.
            "a pack pragma's bit-precise values: small ones apply, past 64 and past 128 bits ignored",
            "#pragma pack(push, 8uwb)\nstruct A { char c; double d; };\n#pragma pack(pop)\n"
            "#pragma pack(push, 2wb)\nstruct B { char c; int i; };\n#pragma pack(pop)\n"
            "#pragma pack(4)\n#pragma pack(0x10000000000000001uwb)\nstruct C { char c; double d; };\n"
            "#pragma pack(0x1000000000000000000000000000000001uwb)\nstruct D { char c; double d; };\n#pragma pack()\n"
            "_Static_assert(sizeof(struct A) == 16 && sizeof(struct B) == 6, \"small values apply\");\n"
            "_Static_assert(sizeof(struct C) == 12 && sizeof(struct D) == 12, \"wide values leave pack(4)\");\n",
            false,
            false,
            false,
            2023,
        },
        {
            // #830's review: a bit-precise count is its value, accepted where it is an int's and refused past 64 bits and
            // past 128 bits, whatever its low bits.
            "a loop hint's bit-precise counts accepted",
            "int f(int n) { int s = 0;\n#pragma clang loop unroll_count(4uwb) interleave_count(2wb)\n while (n--) s += 1; return s; }\n",
            false,
            false,
            false,
            2023,
        },
        {
            "a loop hint's bit-precise count past 64 bits refused",
            "int f(int n) { int s = 0;\n#pragma clang loop unroll_count(0x10000000000000002uwb)\n while (n--) s += 1; return s; }\n",
            true,
            false,
            false,
            2023,
        },
        {
            "a loop hint's bit-precise count past 128 bits refused",
            "int f(int n) { int s = 0;\n#pragma clang loop interleave_count(0x1000000000000000000000000000000002uwb)\n while (n--) s += 1; return s; }\n",
            true,
            false,
            false,
            2023,
        },
        {
            "a loop hint's floating count refused",
            "int f(int* p, int n) { int s = 0;\n#pragma clang loop interleave_count(1.5)\n while (n--) s += 1; return s; }\n",
            true,
            false
        },
        {
            "duplicate loop hints refused",
            "int f(int* p, int n) { int s = 0;\n#pragma clang loop unroll(disable) unroll(enable)\n for (int i = 0; i < n; i += 1) s += p[i]; return s; }\n",
            true,
            false
        },
        {
            "duplicate loop hints across pragmas refused",
            "int f(int* p, int n) { int s = 0;\n#pragma clang loop distribute(enable)\n#pragma clang loop distribute(disable)\n while (n--) s += 1; return s; }\n",
            true,
            false
        },
        {
            "duplicate loop hint counts refused",
            "int f(int* p, int n) { int s = 0;\n#pragma clang loop vectorize_width(4, fixed) vectorize_width(8)\n while (n--) s += 1; return s; }\n",
            true,
            false
        },
        {
            "an unroll pragma beside a loop hint refused",
            "int f(int* p, int n) { int s = 0;\n#pragma unroll\n#pragma clang loop unroll(disable)\n while (n--) s += 1; return s; }\n",
            true,
            false
        },
        {
            "incompatible loop hints refused",
            "int f(int* p, int n) { int s = 0;\n#pragma clang loop vectorize(disable) vectorize_width(4)\n for (int i = 0; i < n; i += 1) s += p[i]; return s; }\n",
            true,
            false
        },
        {
            "incompatible unroll hints refused",
            "int f(int* p, int n) { int s = 0;\n#pragma clang loop unroll(enable) unroll_count(4)\n while (n--) s += 1; return s; }\n",
            true,
            false
        },
        // #480's review: GCC unroll is clang's unroll, whose count may be left out; a count clang can't read is an error
        // (an empty one, an unclosed one, one no expression starts with), not a constant this doesn't evaluate; and the
        // pragmas clang drops (a count's tokens after nounroll, or after a count's parentheses) are no hint.
        {
            "GCC unroll without a count",
            "int g(int n)\n{\n    int s = 0;\n#pragma GCC unroll\n    for (int i = 0; i < n; i += 1)\n    {\n        s += i;\n    }\n    return s;\n}\n",
            false,
            false
        },
        {
            "an unroll count in empty parentheses refused",
            "int f(int n) { int s = 0;\n#pragma unroll()\n while (n--) s += 1; return s; }\n",
            true,
            false
        },
        {
            "a GCC unroll count in empty parentheses refused",
            "int f(int n) { int s = 0;\n#pragma GCC unroll ( )\n while (n--) s += 1; return s; }\n",
            true,
            false
        },
        {
            "an unroll count no expression starts with refused",
            "int f(int n) { int s = 0;\n#pragma unroll ;\n while (n--) s += 1; return s; }\n",
            true,
            false
        },
        {
            "an unclosed unroll_and_jam count refused",
            "int f(int n) { int s = 0;\n#pragma unroll_and_jam (4\n while (n--) s += 1; return s; }\n",
            true,
            false
        },
        {
            "an unroll count's expression unsupported",
            "int f(int n) { int s = 0;\n#pragma unroll (4 + 4)\n while (n--) s += 1; return s; }\n",
            true,
            true
        },
        {
            "the unroll pragmas clang drops, and one it reads a literal from",
            "int f(int n) { int s = 0;\n#pragma nounroll 4\n#pragma unroll 4\n while (n--) s += 1;\n#pragma unroll (4) x\n#pragma unroll 8\n while (n--) s += 1;\n#pragma unroll 4)\n while (n--) s += 1; return s; }\n",
            false,
            false
        },
        {
            "an unroll count clang reads a literal from, twice, refused",
            "int f(int n) { int s = 0;\n#pragma unroll 4)\n#pragma unroll 8\n while (n--) s += 1; return s; }\n",
            true,
            false
        },
        {
            "GCC unroll beside unroll refused",
            "int f(int n) { int s = 0;\n#pragma unroll\n#pragma GCC unroll\n while (n--) s += 1; return s; }\n",
            true,
            false
        },
        // #480's second review: an empty clang loop count is clang's missing argument, and only an expression's keywords
        // start a count.
        {
            "an empty unroll_count refused",
            "int f(int n) { int s = 0;\n#pragma clang loop unroll_count()\n while (n--) s += 1; return s; }\n",
            true,
            false
        },
        {
            "an empty interleave_count refused",
            "int f(int n) { int s = 0;\n#pragma clang loop interleave_count()\n while (n--) s += 1; return s; }\n",
            true,
            false
        },
        {
            "an empty vectorize_width refused",
            "int f(int n) { int s = 0;\n#pragma clang loop vectorize_width()\n while (n--) s += 1; return s; }\n",
            true,
            false
        },
        {
            "an empty pipeline_initiation_interval refused",
            "int f(int n) { int s = 0;\n#pragma clang loop pipeline_initiation_interval()\n while (n--) s += 1; return s; }\n",
            true,
            false
        },
        {
            "a clang loop count no expression starts with refused",
            "int f(int n) { int s = 0;\n#pragma clang loop unroll_count(;)\n while (n--) s += 1; return s; }\n",
            true,
            false
        },
        {
            "a clang loop count of a statement keyword refused",
            "int f(int n) { int s = 0;\n#pragma clang loop unroll_count(return)\n while (n--) s += 1; return s; }\n",
            true,
            false
        },
        {
            "an unroll count of a statement keyword refused",
            "int f(int n) { int s = 0;\n#pragma unroll return\n while (n--) s += 1; return s; }\n",
            true,
            false
        },
        {
            "an unroll count of a type keyword refused",
            "int f(int n) { int s = 0;\n#pragma unroll int\n while (n--) s += 1; return s; }\n",
            true,
            false
        },
        {
            "an unroll count of typeof refused",
            "int f(int n) { int s = 0;\n#pragma unroll typeof(1)\n while (n--) s += 1; return s; }\n",
            true,
            false
        },
        {
            "an unroll count of sizeof unsupported",
            "int f(int n) { int s = 0;\n#pragma unroll sizeof(int)\n while (n--) s += 1; return s; }\n",
            true,
            true
        },
        {
            "a clang loop count of an enumerator unsupported",
            "enum { N = 4 };\nint f(int n) { int s = 0;\n#pragma clang loop unroll_count(N)\n while (n--) s += 1; return s; }\n",
            true,
            true
        },
        // clang drops a loop pragma with tokens after its options (or a count's parentheses), with a warning: no hint, so
        // nothing to place or to check, at file scope too; it ignores what follows the state or the constant expression an
        // argument starts with, with a warning; licm takes disable and vectorize_predicate assume_safety. Counts this
        // doesn't evaluate stay unsupported: their errors can precede the statement and its Sema conflicts (#503).
        {
            "loop pragmas clang drops, at file scope and before a statement",
            "#pragma clang loop unroll(enable) 4\n#pragma nounroll 4\n#pragma unroll (4) x\nint f(int n) { int s = 0;\n"
            "#pragma clang loop unroll(enable) 4\n#pragma nounroll 4\n#pragma unroll (4) x\n s += 1; return s; }\n",
            false,
            false
        },
        {
            "a dropped clang loop pragma's arguments and hints unchecked",
            "int f(int n) { int s = 0;\n#pragma clang loop unroll_count(0) 4\n#pragma clang loop unroll_count() 4\n"
            "#pragma clang loop unroll_count(4))\n#pragma clang loop unroll(disable)\n while (n--) s += 1; return s; }\n",
            false,
            false
        },
        {
            "what follows a loop hint's argument ignored",
            "int f(int n) { int s = 0;\n#pragma clang loop vectorize(enable x) unroll(enable, x)\n while (n--) s += 1;\n"
            "#pragma clang loop vectorize_width(scalable, 4) interleave_count(4, x)\n while (n--) s += 1;\n"
            "#pragma clang loop vectorize_width(4, scalable x) unroll_count(4 = 5)\n while (n--) s += 1;\n"
            "#pragma clang loop vectorize_width(4 x, scalable)\n while (n--) s += 1;\n"
            "#pragma clang loop vectorize_width(fixed, 4)\n while (n--) s += 1; return s; }\n",
            false,
            false
        },
        {
            "licm and vectorize_predicate's assume_safety",
            "int f(int n) { int s = 0;\n#pragma clang loop licm(disable) vectorize_predicate(assume_safety)\n while (n--) s += 1; return s; }\n",
            false,
            false
        },
        {
            "licm enabled refused",
            "int f(int n) { int s = 0;\n#pragma clang loop licm(enable)\n while (n--) s += 1; return s; }\n",
            true,
            false
        },
        {
            "licm twice refused",
            "int f(int n) { int s = 0;\n#pragma clang loop licm(disable) licm(disable)\n while (n--) s += 1; return s; }\n",
            true,
            false
        },
        {
            "a vectorize_width count without its kind refused",
            "int f(int n) { int s = 0;\n#pragma clang loop vectorize_width(4, x)\n while (n--) s += 1; return s; }\n",
            true,
            false
        },
        {
            "an enumerator count beside unroll(full) unsupported",
            "enum { N = 4 };\nint f(int n) { int s = 0;\n#pragma clang loop unroll_count(N) unroll(full)\n while (n--) s += 1; return s; }\n",
            true,
            true,
            .undecided = true
        },
        {
            "an enumerator width beside vectorize(disable) unsupported",
            "enum { N = 4 };\nint f(int n) { int s = 0;\n#pragma clang loop vectorize(disable) vectorize_width(N)\n while (n--) s += 1; return s; }\n",
            true,
            true,
            .undecided = true
        },
        {
            "an enumerator count before an invalid state refused",
            "enum { N = 4 };\nint f(int n) { int s = 0;\n#pragma clang loop unroll_count(N) vectorize(bogus)\n while (n--) s += 1; return s; }\n",
            true,
            false
        },
        // In a body, clang checks a count before it places the hint: an error at the count's pragma when it is invalid, and
        // at the statement only when it is valid (#480's fourth review).
        {
            "a misplaced enumerator count unsupported",
            "enum { N = 4 };\nint f(int n) { int s = 0;\n#pragma clang loop unroll_count(N)\n s += 1; return s; }\n",
            true,
            true,
            false,
            0,
            false,
            true
        },
        {
            "a misplaced count of a variable unsupported",
            "int N = 4;\nvoid f(int n) {\n#pragma clang loop unroll_count(N)\n    n++;\n}\n",
            true,
            true,
            false,
            0,
            false,
            true
        },
        {
            "a misplaced unroll count of a variable unsupported",
            "int N = 4;\nvoid f(int n) {\n#pragma unroll N\n    n++;\n}\n",
            true,
            true,
            false,
            0,
            false,
            true
        },
        {
            "an enumerator unroll count after unroll(enable) unsupported",
            "enum { N = 4 };\nint f(int n) { int s = 0;\n#pragma clang loop unroll(enable)\n#pragma unroll N\n while (n--) s += 1; return s; }\n",
            true,
            true,
            .undecided = true
        },
        // #480's third and fourth reviews: before one loop, a later pragma's error is clang's first only when an earlier
        // count is valid, and the earlier count's when it isn't (a variable, a division by zero, an enumerator of 0). A
        // count this doesn't evaluate leaves the loop's pragmas unsupported.
        {
            "an enumerator count before unroll(full)'s pragma unsupported",
            "enum { N = 4 };\nint f(int n) {\n#pragma clang loop unroll_count(N)\n#pragma clang loop unroll(full)\n    while (n--) {}\n    return n;\n}\n",
            true,
            true,
            false,
            0,
            false,
            true
        },
        {
            "an enumerator width before vectorize(disable)'s pragma unsupported",
            "enum { N = 4 };\nint f(int n) {\n#pragma clang loop vectorize_width(N)\n#pragma clang loop vectorize(disable)\n    while (n--) {}\n    return n;\n}\n",
            true,
            true,
            false,
            0,
            false,
            true
        },
        {
            "an enumerator unroll count before another unsupported",
            "enum { N = 4 };\nint f(int n) {\n#pragma unroll N\n#pragma GCC diagnostic push\n#pragma unroll 4\n    while (n--) {}\n    return n;\n}\n",
            true,
            true,
            false,
            0,
            false,
            true
        },
        {
            "a variable's count before unroll(full)'s pragma unsupported",
            "int N = 4;\nvoid f(int n) {\n#pragma clang loop unroll_count(N)\n#pragma clang loop unroll(full)\n    while (n--) {}\n}\n",
            true,
            true,
            false,
            0,
            false,
            true
        },
        {
            "a count divided by zero before unroll(full)'s pragma unsupported",
            "void f(int n) {\n#pragma clang loop unroll_count(4 / 0)\n#pragma clang loop unroll(full)\n    while (n--) {}\n}\n",
            true,
            true,
            false,
            0,
            false,
            true
        },
        {
            "an enumerator count of 0 before unroll(full)'s pragma unsupported",
            "enum { N = 0 };\nvoid f(int n) {\n#pragma clang loop unroll_count(N)\n#pragma clang loop unroll(full)\n    while (n--) {}\n}\n",
            true,
            true,
            false,
            0,
            false,
            true
        },
        {
            "an enumerator unroll count at file scope refused",
            "enum { N = 4 };\n#pragma unroll N\nint x;\n",
            true,
            false
        },
        // An inferred array's elements of struct type from subscripts, members and indirections, and compound literals in
        // a block-scope static's initializer, as this compiler's own main.c has them.
        {
            "struct-valued elements of an inferred array",
            "typedef struct { char* pointer; unsigned long length; } S8;\nstruct W { S8 s; S8 t[2]; };\nint f(const S8* x, struct W w, struct W** q)\n{\n    const S8 a[] = { x[1], x[2] };\n    _Static_assert(sizeof a == 2 * sizeof(S8), \"two\");\n    S8 b[] = { x[0], { \"c\", 1 }, x[1] };\n    _Static_assert(sizeof b == 3 * sizeof(S8), \"three\");\n    S8 c[] = { *x, (*x), w.s, w.t[1], q[0]->s, (*q)->t[0] };\n    _Static_assert(sizeof c == 6 * sizeof(S8), \"six\");\n    unsigned long d[] = { x[1].length, w.t[0].length, q[1]->s.length };\n    _Static_assert(sizeof d == 3 * sizeof(unsigned long), \"three scalars\");\n    return (int)(a[1].length + b[2].length + c[5].length + d[2]);\n}\n",
            false,
            false
        },
        // #495's review: a subscript's pointer as either operand, and chains of steps around 16, the walk's old limit.
        {
            "reversed subscripts in an inferred array",
            "typedef struct { int a, b; } S;\nstruct W { S s; S t[2]; };\nint f(S* p, int i, struct W* w, S** q)\n{\n    S a[] = { 0[p], 1[p] };\n    _Static_assert(sizeof a == 2 * sizeof(S), \"two\");\n    S b[] = { p[0], i[p], 1[w->t], 0[q][1], 1[0[q]], (i[q])[i] };\n    _Static_assert(sizeof b == 6 * sizeof(S), \"six\");\n    int c[] = { 0[p].a, i[p].b, (1[w->t]).a };\n    _Static_assert(sizeof c == 3 * sizeof(int), \"three scalars\");\n    return a[1].b + b[5].a + c[2];\n}\n",
            false,
            false
        },
        {
            "chains of 15, 16 and 17 steps in an inferred array",
            "typedef struct { int a, b; } S;\nstruct C { S s[2]; struct C* next; };\nint f(S*************** p, S**************** q, S***************** r, struct C* x)\n{\n    S a[] = { ***************p, ***************p };\n    _Static_assert(sizeof a == 2 * sizeof(S), \"15\");\n    S b[] = { ****************q, ****************q };\n    _Static_assert(sizeof b == 2 * sizeof(S), \"16\");\n    S c[] = { *****************r, *****************r };\n    _Static_assert(sizeof c == 2 * sizeof(S), \"17\");\n    S d[] = { x->next->next->next->next->next->next->next->next->next->next->next->next->next->next->s[1],\n              x->next->next->next->next->next->next->next->next->next->next->next->next->next->next->next->s[0], x->s[1] };\n    _Static_assert(sizeof d == 3 * sizeof(S), \"16 and 17 members and subscripts\");\n    return a[1].a + b[1].a + c[1].a + d[2].b;\n}\n",
            false,
            false
        },
        // Operators' values: pointer arithmetic under an indirection, GNU's vector operators with a cast's or a negated
        // operand, vectors past a difference and compares of pointers, which are scalars (#555's review), and scalars,
        // which brace elision takes into the vector.
        {
            "operators' values in an inferred array",
            "typedef struct { int a, b; } S;\ntypedef short v16hi __attribute__((vector_size(32)));\ntypedef long v4di __attribute__((vector_size(32)));\nint f(S* p, int n, v16hi h, v16hi k, long* l, long* m, v4di d)\n{\n    S a[] = { *(p + 1), *(1 + p), p[0], *(p - n), *(p + (l - m)), p[l == m] };\n    _Static_assert(sizeof a == 6 * sizeof(S), \"six\");\n    v16hi b[] = { h + (short)n, -h, ~k, h * k + (short)1, (short)n * h, -h + (short)n, h << 2 };\n    _Static_assert(sizeof b == 7 * sizeof(v16hi), \"seven\");\n    v16hi c[] = { (short)n + (short)1, 2 };\n    _Static_assert(sizeof c == sizeof(v16hi), \"one\");\n    v4di e[] = { (l - m) * d, d, (l == m) * d, (l < m) + d };\n    _Static_assert(sizeof e == 4 * sizeof(v4di), \"four vectors past pointers' differences and compares\");\n    return a[5].b + b[6][0] + c[0][1] + (int)e[3][0];\n}\n",
            false,
            false
        },
        // Casts' types (the reader's, at their `)`s), on either side; an operand the walk has no type for (a call through a
        // pointer's expression), which leaves a difference with a pointer open, not a pointer (#555's second review); and
        // constants, `sizeof` and `!`, scalars on a difference's right.
        {
            "casts and operands of no type in an inferred array",
            "typedef struct { int a, b; } S;\ntypedef long v4di __attribute__((vector_size(32)));\nint f(S* p, S* q, long* l, long* m, v4di d, long* (*get)(void))\n{\n    S x[] = { *(p + (p - (S*)q)), p[0], *((S*)q + (l - m)), *(p + (l - (*get)())), *((S*)l + 1), *(p - 1), *(p - sizeof(S)), *(p - !m), *(p - 'a') };\n    _Static_assert(sizeof x == 9 * sizeof(S), \"nine\");\n    v4di e[] = { (v4di)d * (l - m), (l - (long*)q) * d, d };\n    _Static_assert(sizeof e == 3 * sizeof(v4di), \"three\");\n    return x[8].a + (int)e[2][0];\n}\n",
            false,
            false
        },
        // A ?:'s value from both of its arms (#555's third review): a vector where either arm is one, a scalar arm
        // converted to it; a scalar where both are; a pointer or a record where either is, a null pointer constant or
        // GNU's `a ?: b` the other.
        {
            "a conditional's arms in an inferred array",
            "typedef struct { int a, b; } S;\ntypedef int v4si __attribute__((vector_size(16)));\nint f(int n, v4si v, v4si w, S* p, S* q, S s, S t)\n{\n    v4si a[] = { n ? v : 0, n ? 0 : v, n ? v : w, n ? (v + w) : 1, v };\n    _Static_assert(sizeof a == 5 * sizeof(v4si), \"five\");\n    v4si b[] = { n ? 1 : 2, 3 };\n    _Static_assert(sizeof b == sizeof(v4si), \"one\");\n    S x[] = { *(n ? p : 0), *(n ? 0 : q), n ? s : t, *(p ?: q), s };\n    _Static_assert(sizeof x == 5 * sizeof(S), \"five\");\n    return a[4][0] + b[0][1] + x[4].a;\n}\n",
            false,
            false
        },
        // A vector's lane, its element type's scalar (#555's fourth review): under a ?: beside a scalar, in a binary
        // operator's operand, through a member and of an operator's value.
        {
            "vector lanes in an inferred array",
            "typedef int v4si __attribute__((vector_size(16)));\ntypedef struct { v4si v; int k; } H;\nint f(int n, v4si v, H h)\n{\n    v4si a[] = { n ? v[0] : 2, 3 };\n    _Static_assert(sizeof a == sizeof(v4si), \"one\");\n    v4si b[] = { v[0] + 1, 2 };\n    _Static_assert(sizeof b == sizeof(v4si), \"one too\");\n    v4si c[] = { h.v[1], (v + v)[2], n ? 1 : v[3], 4, v };\n    _Static_assert(sizeof c == 2 * sizeof(v4si), \"four lanes, then a vector\");\n    return a[0][1] + b[0][0] + c[1][3];\n}\n",
            false,
            false
        },
        // A ?: of an extension vector's condition, element by element a vector whatever its arms (#555's fifth review):
        // the condition a vector, a vector's compare, and a lane of one beside pointer arms.
        {
            "a vector condition's ?: in an inferred array",
            "typedef int e4 __attribute__((ext_vector_type(4)));\ntypedef int g4 __attribute__((vector_size(16)));\ntypedef struct { int a, b; } S;\nint f(int n, e4 mask, g4 x, S* p, S* q)\n{\n    _Static_assert(__builtin_types_compatible_p(__typeof__(mask ? 1 : 2), e4), \"vector-valued conditional\");\n    g4 a[] = { mask ? 1 : 2, x };\n    _Static_assert(sizeof a == 2 * sizeof(g4), \"two elements\");\n    g4 d[] = { (mask < 2) ? 3 : 4, x, n ? 5 : 6, 7 };\n    _Static_assert(sizeof d == 3 * sizeof(g4), \"a compare's mask, a vector, then two scalars braced into one\");\n    S c[] = { *(n ? p : q), *(mask[0] ? p : q) };\n    _Static_assert(sizeof c == 2 * sizeof(S), \"two records\");\n    return a[1][0] + d[2][1] + c[1].a;\n}\n",
            false,
            false
        },
        // An extension vector's !, && and ||, vectors element by element, and its swizzles: one lane a scalar, more a
        // vector, an odd-length vector's halves rounded up, and swizzles of swizzles by their own lanes (#555's sixth to
        // eighth reviews).
        {
            "an extension vector's logic and swizzles in an inferred array",
            "typedef int e4 __attribute__((ext_vector_type(4)));\ntypedef int e2 __attribute__((ext_vector_type(2)));\ntypedef int g4 __attribute__((vector_size(16)));\ntypedef int e3 __attribute__((ext_vector_type(3)));\ntypedef int g2 __attribute__((vector_size(8)));\nint f(int n, e4 v, e4 w, e2 t, g4 x, e3 u, g2 z)\n{\n    _Static_assert(__builtin_types_compatible_p(__typeof__(!v), e4), \"not vector\");\n    _Static_assert(__builtin_types_compatible_p(__typeof__(v && w), e4), \"and vector\");\n    _Static_assert(__builtin_types_compatible_p(__typeof__(v || w), e4), \"or vector\");\n    g4 a[] = { !v, v && w, v || w, x };\n    _Static_assert(sizeof a == 4 * sizeof(g4), \"four\");\n    g4 b[] = { v.x, 2, 3, 4, x, v.s3, t.lo, !v.x, n && v.y };\n    _Static_assert(sizeof b == 3 * sizeof(g4), \"lanes braced into vectors\");\n    g4 c[] = { v.xyzw, v.wzyx, x, !n };\n    _Static_assert(sizeof c == 4 * sizeof(g4), \"two swizzled vectors, a vector, then a scalar\");\n    g2 d[] = { u.lo, u.hi, u.even, u.odd, z };\n    _Static_assert(sizeof d == 5 * sizeof(g2), \"odd lanes' halves round up\");\n    g4 e[] = { v.xy.lo, 2, 3, 4, x, v.xy.hi, v.zw.lo, v.xyz.lo.x, 0 };\n    _Static_assert(sizeof e == 3 * sizeof(g4), \"nested swizzles' lanes braced into vectors\");\n    g2 h[] = { v.xyzw.lo, z, v.wzyx.hi };\n    _Static_assert(sizeof h == 3 * sizeof(g2), \"nested swizzles' vectors whole\");\n    return a[3][0] + b[2][1] + c[3][0] + d[4][0] + e[2][0] + h[2][0];\n}\n",
            false,
            false
        },
        // An extended vector's lanes through a pointer to it (`p->y`, clang's `(*p).y`): read, stored, swizzled, in a
        // segment's space, and typed in a file-scope query; a struct's `->` members in the same unit stay its members.
        {
            "an extended vector's lanes through a pointer",
            "typedef float v4 __attribute__((ext_vector_type(4)));\ntypedef float v2 __attribute__((ext_vector_type(2)));\nstruct s { int x, a; };\n_Static_assert(__builtin_types_compatible_p(__typeof__(((v4*)0)->xy), v2), \"xy\");\nfloat f(v4* p, __seg_gs v4* g, struct s* q, float x)\n{\n    p->w = x;\n    p->xy = p->zw;\n    _Static_assert(__builtin_types_compatible_p(__typeof__(p->wzyx), v4), \"wzyx\");\n    _Static_assert(__builtin_types_compatible_p(__typeof__(g->lo), v2), \"lo\");\n    return p->y + g->s3 + q->x + q->a;\n}\n",
            false,
            false
        },
        // An intrinsic's result, from its prototype, which the reader keeps at the call's `)`, whatever the last operand the
        // call names: a vector after a scalar count, and a scalar after a vector.
        {
            "intrinsics' results in an inferred array",
            "typedef short v8hi __attribute__((vector_size(16)));\ntypedef char v16qi __attribute__((vector_size(16)));\ntypedef int v4si __attribute__((vector_size(16)));\nint f(v8hi h, int n, v16qi c, v4si x)\n{\n    v8hi a[] = { __builtin_ia32_psllwi128(h, n), h, __builtin_ia32_psrawi128(h, n) };\n    _Static_assert(sizeof a == 3 * sizeof(v8hi), \"three vectors\");\n    v4si b[] = { __builtin_ia32_pmovmskb128(c), 2, 3, 4, x };\n    _Static_assert(sizeof b == 2 * sizeof(v4si), \"four scalars braced into a vector, then a vector\");\n    return a[2][0] + b[1][0];\n}\n",
            false,
            false
        },
        {
            "an intrinsic immediate cannot discard side effects",
            "typedef int V __attribute__((vector_size(64)));V f(V a,int*p){return __builtin_ia32_alignd512(a,a,((*p)++,3));}",
            true,
            false
        },
        {
            "compound literals in static initializers",
            "typedef struct { char* pointer; unsigned long length; } S8;\n#define T(text) ((S8){ .pointer = (char*)(text), .length = sizeof(text) - 1, })\nstatic const S8 file_scope[] = { T(\" \"), T(\"/**/\") };\nint f(void)\n{\n    static const S8 gaps[] = { T(\" \"), T(\"/**/\"), T(\" \\\\\\n\") };\n    _Static_assert(sizeof gaps == 3 * sizeof(S8), \"three\");\n    static const S8 one = (S8){ \"a\", 1 };\n    return (int)(gaps[1].length + file_scope[1].length + one.length);\n}\n",
            false,
            false
        },
        {
            "a compound literal of a parameter in a static's initializer refused",
            "typedef struct { char* pointer; unsigned long length; } S8;\nstruct W { S8 s; S8 t[2]; };\nint f(int n)\n{\n    static const S8 g[] = { (S8){ \"a\", n } };\n    return (int)sizeof g;\n}\n",
            true,
            false
        },
        {
            "an automatic compound literal's address in a static's initializer refused",
            "typedef struct { char* pointer; unsigned long length; } S8;\nstruct W { S8 s; S8 t[2]; };\nint f(void)\n{\n    static const S8* g = &(S8){ \"a\", 1 };\n    return g != 0;\n}\n",
            true,
            false
        },
        {
            "a struct where an inferred array's member goes refused",
            "typedef struct { char* pointer; unsigned long length; } S8;\nstruct W { S8 s; S8 t[2]; };\nint f(const S8* x)\n{\n    S8 a[] = { x->pointer, x[1] };\n    return (int)sizeof a;\n}\n",
            true,
            false
        },
        {
            "incompatible loop hints across pragmas refused",
            "int f(int* p, int n) { int s = 0;\n#pragma clang loop unroll(disable)\n#pragma clang loop unroll_count(4)\n while (n--) s += 1; return s; }\n",
            true,
            false
        },
        {
            "incompatible pipeline hints refused",
            "int f(int* p, int n) { int s = 0;\n#pragma clang loop pipeline(disable) pipeline_initiation_interval(3)\n while (n--) s += 1; return s; }\n",
            true,
            false
        },
        {
            "a loop hint's constant expression unsupported",
            "int f(int* p, int n) { int s = 0;\n#pragma clang loop unroll_count(4 + 4)\n while (n--) s += 1; return s; }\n",
            true,
            true
        },
        {
            "an inferred array of compound literals, calls and conditionals",
            "struct L { unsigned i; unsigned t; };\nstruct L g(int);\nunsigned f(int s, unsigned a, struct L x) {\n const struct L r[] = { s ? (struct L){ 0, a } : x, (struct L){ .i = 1, .t = a }, g(s), (x), s ? x : (struct L){ 4, a }, { 2, 3 } };\n _Static_assert(sizeof r == 6 * sizeof(struct L), \"six elements\");\n return r[0].t; }\n",
            false,
            false
        },
        {
            "an inferred array with braces elided",
            "struct L { unsigned i; unsigned t; };\nunsigned f(unsigned a) {\n const struct L r[] = { a, a + 1, 2, 3 };\n _Static_assert(sizeof r == 2 * sizeof(struct L), \"two elements\");\n return r[1].t; }\n",
            false,
            false
        },
        // Plain char unsigned (-funsigned-char): its conversions, promotions, division and shifts, character constants,
        // _Generic (char stays a type of its own), a mode attribute's base, and C23's char-based enum, and the assertions
        // that hold only where it is signed, refused.
        {
            "unsigned plain char: values",
            "_Static_assert((char)-1 == 255, \"conversion\");\n_Static_assert((char)200 > 100, \"comparison\");\n"
            "_Static_assert((int)(char)0x80 == 128, \"widening\");\n_Static_assert((char)256 == 0, \"truncation\");\n"
            "_Static_assert(-(char)1 == -1, \"promotion\");\n_Static_assert((char)-1 / 3 == 85, \"division\");\n"
            "_Static_assert(((char)0x80 >> 1) == 64, \"shift\");\n"
            "_Static_assert(_Generic((char)0, char: 1, unsigned char: 2, signed char: 3) == 1, \"distinct\");\n"
            "typedef char C2 __attribute__((mode(HI)));\n_Static_assert((C2)-1 > 0, \"mode\");\n_Static_assert(__CHAR_UNSIGNED__ == 1, \"macro\");\n",
            false,
            false,
            .char_unsigned = true
        },
        {
            "unsigned plain char: character constants",
            "_Static_assert('\\xff' == 255, \"hexadecimal\");\n_Static_assert('\\200' > 0, \"octal\");\n_Static_assert('a' == 97, \"letter\");\n"
            "_Static_assert(L'\\xff' == 255, \"wide\");\n",
            false,
            false,
            .char_unsigned = true
        },
        {
            "unsigned plain char: a char-based enum and u8 constants in C23",
            "enum E : char { A = 200 };\n_Static_assert(A == 200, \"fixed base\");\n_Static_assert((enum E)-1 > 0, \"unsigned base\");\n"
            "_Static_assert(u8'\\xff' == 255, \"u8\");\n",
            false,
            false,
            .standard = 2023,
            .char_unsigned = true
        },
        {
            "unsigned plain char: a signed conversion refused",
            "_Static_assert((char)-1 < 0, \"signed\");\n",
            true,
            false,
            .char_unsigned = true
        },
        {
            "unsigned plain char: a signed character constant refused",
            "int x = 1;\n_Static_assert('\\xff' == -1, \"signed\");\n",
            true,
            false,
            .char_unsigned = true
        },
        {
            "signed plain char: a char-based enum past its range refused in C23",
            "enum E : char { A = 200 };\n",
            true,
            false,
            .standard = 2023
        },
        {
            // A builtin type's flags don't say its signedness, which a mode attribute once read from them.
            "mode attribute: the base's signedness kept",
            "typedef unsigned int U2 __attribute__((mode(HI)));\n_Static_assert((U2)-1 > 0 && sizeof(U2) == 2, \"unsigned\");\n"
            "typedef unsigned char U4 __attribute__((mode(SI)));\n_Static_assert((U4)-1 > 0 && sizeof(U4) == 4, \"unsigned char\");\n"
            "typedef int S2 __attribute__((mode(HI)));\n_Static_assert((S2)-1 < 0, \"signed\");\n"
            "typedef char C1 __attribute__((mode(QI)));\n_Static_assert((C1)-1 < 0, \"plain char\");\n",
            false,
            false
        },
        // GNU's function multiversioning (#839): target("default") makes a function multiversioned even alone, and
        // clang refuses these declaration attributes beside it, at the function's name.
        {
            "multiversioning: always_inline beside target default",
            "int g(int x) { return x; }\n__attribute__((always_inline, target(\"default\"))) int h(int x) { return x + 1; }\n"
            "int caller(int x) { return h(x); }\n",
            true,
            false
        },
        {
            "multiversioning: noinline beside target default",
            "int g(int x) { return x; }\n__attribute__((noinline, target(\"default\"))) int h(int x) { return x + 1; }\n"
            "int caller(int x) { return h(x); }\n",
            true,
            false
        },
        {
            "multiversioning: flatten beside target default",
            "int g(int x) { return x; }\n__attribute__((flatten, target(\"default\"))) int h(int x) { return x + 1; }\n"
            "int caller(int x) { return h(x); }\n",
            true,
            false
        },
        {
            "multiversioning: cold beside target default",
            "int g(int x) { return x; }\n__attribute__((cold, target(\"default\"))) int h(int x) { return x + 1; }\n"
            "int caller(int x) { return h(x); }\n",
            true,
            false
        },
        {
            "multiversioning: hot beside target default",
            "int g(int x) { return x; }\n__attribute__((hot, target(\"default\"))) int h(int x) { return x + 1; }\n"
            "int caller(int x) { return h(x); }\n",
            true,
            false
        },
        {
            "multiversioning: weak beside target default",
            "int g(int x) { return x; }\n__attribute__((weak, target(\"default\"))) int h(int x) { return x + 1; }\n"
            "int caller(int x) { return h(x); }\n",
            true,
            false
        },
        {
            "multiversioning: const beside target default",
            "int g(int x) { return x; }\n__attribute__((const, target(\"default\"))) int h(int x) { return x + 1; }\n"
            "int caller(int x) { return h(x); }\n",
            true,
            false
        },
        {
            "multiversioning: pure beside target default",
            "int g(int x) { return x; }\n__attribute__((pure, target(\"default\"))) int h(int x) { return x + 1; }\n"
            "int caller(int x) { return h(x); }\n",
            true,
            false
        },
        {
            "multiversioning: naked beside target default",
            "int g(int x) { return x; }\n__attribute__((naked, target(\"default\"))) int h(int x) { return x + 1; }\n"
            "int caller(int x) { return h(x); }\n",
            true,
            false
        },
        {
            "multiversioning: alias beside target default",
            "int g(int x) { return x; }\n__attribute__((alias(\"g\"), target(\"default\"))) int h(int x) { return x + 1; }\n"
            "int caller(int x) { return h(x); }\n",
            true,
            false
        },
        {
            "multiversioning: target_clones beside target",
            "int g(int x) { return x; }\n__attribute__((target_clones(\"avx2\", \"default\"), target(\"default\"))) int h(int x) { return x + 1; }\n"
            "int caller(int x) { return h(x); }\n",
            true,
            false
        },
        {
            "multiversioning: cpu_specific beside target",
            "int g(int x) { return x; }\n__attribute__((cpu_specific(generic), target(\"default\"))) int h(int x) { return x + 1; }\n"
            "int caller(int x) { return h(x); }\n",
            true,
            false
        },
        {
            "multiversioning: used beside target default",
            "int g(int x) { return x; }\n__attribute__((used, target(\"default\"))) int h(int x) { return x + 1; }\n"
            "int caller(int x) { return h(x); }\n",
            false,
            false
        },
        {
            "multiversioning: nothrow beside target default",
            "int g(int x) { return x; }\n__attribute__((nothrow, target(\"default\"))) int h(int x) { return x + 1; }\n"
            "int caller(int x) { return h(x); }\n",
            false,
            false
        },
        {
            "multiversioning: a second target version checks the first declaration",
            "__attribute__((always_inline, target(\"avx2\"))) int h(int x);\n"
            "__attribute__((noinline, target(\"default\"))) int h(int x) { return x + 1; }\n"
            "int caller(int x) { return h(x); }\n",
            true,
            false
        },
        {
            "multiversioning: cpu_dispatch beside target",
            "__attribute__((cpu_dispatch(generic), target(\"default\"))) int h(int x) { return x + 1; }\n",
            true,
            false
        },
        {
            "multiversioning: aligned beside target default",
            "int h(void) __attribute__((aligned(16), target(\"default\")));\n",
            true,
            false
        },
        {
            "multiversioning: may_alias beside target default",
            "int h(void) __attribute__((may_alias, target(\"default\")));\n",
            true,
            false
        },
        {
            "multiversioning: inline nonnull beside target default",
            "inline int h(int *p) __attribute__((nonnull, nothrow, target(\"default\"))) { return 0; }\n",
            false,
            false
        },
        {
            "multiversioning: a block-scope declaration beside target default",
            "int f(void) { int h(void) __attribute__((target(\"default\"), always_inline)); return 0; }\n",
            true,
            false
        },
        {
            "multiversioning: several declarators beside target default",
            "__attribute__((target(\"default\"), always_inline)) int h(void), g(void);\n",
            true,
            false
        },
        {
            "multiversioning: a cpu_specific declaration alone is accepted (#1447)",
            "__attribute__((cpu_specific(generic))) int h(void);\n",
            false,
            false
        },
        {
            "multiversioning: cpu_specific versions and their dispatcher (#1447)",
            "__attribute__((cpu_specific(generic))) int h(void) { return 1; }\n__attribute__((cpu_specific(core_2_duo_ssse3))) int h(void) { return 2; }\n__attribute__((cpu_dispatch(generic, core_2_duo_ssse3))) int h(void);\nint caller(void) { return h(); }\n",
            false,
            false
        },
        {
            "multiversioning: cpu_specific of an unknown CPU (#1447)",
            "__attribute__((cpu_specific(generic, nocpu))) int h(void);\n",
            true,
            false
        },
        {
            "multiversioning: cpu_dispatch of an unknown CPU (#1447)",
            "__attribute__((cpu_dispatch(nocpu))) int h(void);\n",
            true,
            false
        },
        {
            "multiversioning: cpu_specific versions of one CPU (#1447)",
            "__attribute__((cpu_specific(generic))) int h(void);\n__attribute__((cpu_specific(atom, generic))) int h(void);\n",
            true,
            false
        },
        {
            "multiversioning: cpu_dispatch redeclared with other CPUs (#1447)",
            "__attribute__((cpu_dispatch(atom))) int h(void);\n__attribute__((cpu_dispatch(generic))) int h(void);\n",
            true,
            false
        },
        {
            "multiversioning: a plain redeclaration of a cpu_specific function (#1447)",
            "__attribute__((cpu_specific(atom))) int h(void);\nint h(void);\n",
            true,
            false
        },
        {
            "multiversioning: cpu_specific beside a target version (#1447)",
            "__attribute__((target(\"default\"))) int h(void);\n__attribute__((cpu_specific(atom))) int h(void);\n",
            true,
            false
        },
        {
            "multiversioning: a cpu_specific version's other return type (#1447)",
            "__attribute__((cpu_specific(atom))) int h(void);\n__attribute__((cpu_specific(generic))) long h(void);\n",
            true,
            false
        },
        {
            "multiversioning: a cpu_specific version redefined (#1447)",
            "__attribute__((cpu_specific(atom))) int h(void) { return 0; }\n__attribute__((cpu_specific(atom))) int h(void) { return 1; }\n",
            true,
            false
        },
        {
            "multiversioning: a cpu_specific main (#1447)",
            "__attribute__((cpu_specific(atom))) int main(void) { return 0; }\n",
            true,
            false
        },
        {
            "multiversioning: C23-only attributes are ignored in gnu17",
            "int h(void) __attribute__((nodiscard, target(\"default\")));\n",
            false,
            false
        },
        {
            "multiversioning: C23-only attributes are ignored in gnu23",
            "int h(void) __attribute__((nodiscard, maybe_unused, no_sanitize_undefined, target(\"default\")));\n",
            false,
            false,
            .standard = 2023
        },
        {
            "multiversioning: no_builtin on a declaration still reports the conflict",
            "__attribute__((no_builtin(\"printf\"), always_inline, target(\"default\"))) int h(void);\n",
            true,
            false
        },
    };
    const size_t count = sizeof(fixtures) / sizeof(fixtures[0]);
    int status = 0;
    for (size_t i = 0; i < count && status == 0; i += 1)
    {
        const CheckSourceFixture* f = &fixtures[i];
        char path[4096];
        snprintf(path, sizeof(path), "%s/%04zu.c", argv[1], i + 1);
        FILE* file = fopen(path, "wb");
        const size_t length = strlen(f->source);
        status = file == 0 || fwrite(f->source, 1, length, file) != length || fclose(file) != 0;
        if (f->capacity != 0 || strchr(f->name, '\t') != 0 || strchr(f->name, '\n') != 0)
        {
            fprintf(stderr, "fixture %zu: a capacity or a name with a tab or newline\n", i + 1);
            status = 1;
        }
        printf("%04zu\t%d\t%d\t%d\t%u\t%d\t%d\t%u\t%s\n", i + 1, f->rejected, f->unsupported, f->extension, f->standard, f->char_unsigned,
               f->undecided, f->overload_tables, f->name);
    }
    fprintf(stderr, "%zu fixtures\n", count);
    return status;
}
