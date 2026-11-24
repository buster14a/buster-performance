#include <stdint.h>
#include <stdbool.h>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <assert.h>
typedef struct CheckDriverWarningSpelling CheckDriverWarningSpelling;
struct CheckDriverWarningSpelling
{
    const char* clang;
    const char* baseline;
};

typedef struct CheckDriverDefaultWarningFixture CheckDriverDefaultWarningFixture;
struct CheckDriverDefaultWarningFixture
{
    const char* name;
    const char* source;
    const char* options[4];
    uint32_t warnings;
    uint32_t errors;
    uint32_t notes;
    bool c23;
    bool compare_warning_text;
    bool compare_node_window;
    bool syntax_only;
    // An opt-in, NULL-terminated list of exact primary diagnostic spellings retained by a separate existing gap.
    // Every location, warning, note and diagnostic order still compares byte for byte. No ordinary fixture uses it.
    const CheckDriverWarningSpelling* baseline_spellings;
};

static const CheckDriverDefaultWarningFixture fixture_0[] =
{
    {
        // GNU's and OpenCL's address spaces on file-scope objects, typedefs, pointers and arrays, and their spellings in clang's
        // diagnostics: a target's as its attribute, OpenCL's by keyword, a typedef's name after the space; opencl_global_device's
        // and opencl_global_host's deprecation; a second attribute of the same space.
        .name = "address spaces of declarations",
        .source = "#define AS1 __attribute__((address_space(1)))\n"
                  "AS1 int a;\n"
                  "int b __attribute__((address_space(2)));\n"
                  "int * __attribute__((address_space(3))) c;\n"
                  "__attribute__((opencl_global)) int g;\n"
                  "__attribute__((opencl_global_device)) int gd;\n"
                  "__attribute__((opencl_global_host)) int gh;\n"
                  "__attribute__((opencl_local)) const int *l;\n"
                  "typedef __attribute__((address_space(4))) int T4;\n"
                  "T4 t4[3];\n"
                  "int __attribute__((address_space(5))) __attribute__((address_space(5))) twice;\n"
                  "__seg_gs int *gs;\n"
                  "__seg_fs int *fs;\n"
                  "__attribute__((address_space(0))) int zero;\n"
                  "__attribute__((address_space(8388580))) int highest;\n"
                  "AS1 int *f(void) { return &a; }\n"
                  "AS1 int (*h(void))[3];\n",
        .warnings = 3,
    },
    {
        // A typedef's name under an address space, and one whose type has one, in an error's types (its aka); a source's
        // own qualifiers, the pointer's space among them, as clang names a conversion's source.
        .name = "typedef names and qualifiers in an address space's error",
        .source = "typedef int T;\n"
                  "typedef __attribute__((address_space(3))) int U;\n"
                  "__attribute__((address_space(1))) T *a;\n"
                  "const U *d;\n"
                  "__attribute__((address_space(1))) int * __attribute__((address_space(2))) const c;\n"
                  "int *q;\n"
                  "void f(int n) { if (n) q = a; else if (n > 1) q = d; else q = c; }\n",
        .errors = 3,
    },
    {
        // clang's CheckVariableDeclarationType: a block's variable, not a static or extern one.
        .name = "an automatic variable with an address space",
        .source = "void f(void) {\n"
                  "  static __attribute__((address_space(1))) int s;\n"
                  "  extern __attribute__((address_space(1))) int e;\n"
                  "  __attribute__((address_space(1))) int local;\n"
                  "}\n",
        .errors = 1,
    },
    {
        // The array's element's space.
        .name = "an automatic array of an address space",
        .source = "void f(void) { __attribute__((address_space(1))) int a[2]; }\n",
        .errors = 1,
    },
    {
        // A second space on one type.
        .name = "multiple address spaces",
        .source = "int __attribute__((address_space(1))) __attribute__((address_space(2))) two;\n",
        .errors = 1,
    },
    {
        // OpenCL's keyword spaces against address_space's.
        .name = "an OpenCL space after a target's",
        .source = "__attribute__((opencl_global)) int __attribute__((address_space(1))) both;\n",
        .errors = 1,
    },
    {
        // address_space's argument's bounds.
        .name = "a negative address space",
        .source = "int __attribute__((address_space(-1))) negative;\n",
        .errors = 1,
    },
    {
        // clang's largest, 2^23 less its own address spaces.
        .name = "an address space past the largest",
        .source = "int __attribute__((address_space(8388581))) large;\n",
        .errors = 1,
    },
    {
        // address_space's argument is an integer constant.
        .name = "an address space of no integer constant",
        .source = "int n;\n"
                  "int __attribute__((address_space(n))) a;\n",
        .errors = 1,
    },
    {
        // address_space's argument is an integer constant.
        .name = "an address space of a floating constant",
        .source = "int __attribute__((address_space(1.0))) a;\n",
        .errors = 1,
    },
    {
        // address_space's count.
        .name = "address_space without its argument",
        .source = "int __attribute__((address_space)) a;\n",
        .errors = 1,
    },
    {
        // OpenCL's spaces take none.
        .name = "an OpenCL space with an argument",
        .source = "int __attribute__((opencl_local(1))) a;\n",
        .errors = 1,
    },
    {
        // clang's CheckFieldDecl.
        .name = "a member with an address space",
        .source = "struct S { int x; __attribute__((address_space(1))) int m; };\n",
        .errors = 1,
    },
    {
        // clang's CheckParameter, through a typedef.
        .name = "a parameter with an address space",
        .source = "typedef __attribute__((address_space(1))) int T;\n"
                  "void f(T x);\n",
        .errors = 1,
    },
    {
        // An address space after a function's declarator qualifies its type.
        .name = "a function type with an address space",
        .source = "int f(void) __attribute__((address_space(1)));\n",
        .errors = 1,
    },
    {
        // The specifiers' function type.
        .name = "a typedef's function type with an address space",
        .source = "typedef void F(void);\n"
                  "__attribute__((address_space(1))) F f;\n",
        .errors = 1,
    },
    {
        // A function's compound literal.
        .name = "a compound literal with an address space",
        .source = "int *f(void) { return (__attribute__((address_space(1))) int[]){ 1 }; }\n",
        .errors = 1,
    },
    {
        // clang's checkPointerTypesForAssignment, the error's operands in clang's order.
        .name = "assigning a pointer to another address space",
        .source = "__attribute__((address_space(1))) int *p;\n"
                  "int *q;\n"
                  "void f(void) { q = p; }\n",
        .errors = 1,
    },
    {
        // At the declarator's name.
        .name = "initializing a pointer of another address space",
        .source = "__attribute__((address_space(1))) int a[3];\n"
                  "int (*p)[3] = &a;\n",
        .errors = 1,
    },
    {
        // At the returned expression's first token.
        .name = "returning a pointer to another address space",
        .source = "__attribute__((address_space(1))) int a;\n"
                  "int *f(void) { return &a; }\n",
        .errors = 1,
    },
    {
        // The note at the parameter's name.
        .name = "passing a pointer to another address space",
        .source = "void take(int n, int *to);\n"
                  "void f(__attribute__((address_space(2))) int *p) { take(0, p); }\n",
        .errors = 1,
        .notes = 1,
    },
    {
        // The note just past an unnamed parameter.
        .name = "passing a pointer to an unnamed parameter",
        .source = "void take(int *);\n"
                  "void f(__seg_gs int *p) { take(p); }\n",
        .errors = 1,
        .notes = 1,
    },
    {
        // Neither space includes the other.
        .name = "assigning between two target spaces",
        .source = "__attribute__((address_space(1))) int *p;\n"
                  "__attribute__((address_space(2))) int *r;\n"
                  "void f(void) { r = p; }\n",
        .errors = 1,
    },
    {
        // A void pointee's space too.
        .name = "assigning to a void pointer of another space",
        .source = "__attribute__((address_space(1))) void *v;\n"
                  "int *q;\n"
                  "void f(void) { v = q; }\n",
        .errors = 1,
    },
    {
        // clang's err_typecheck_op_on_nonoverlapping_address_space_pointers.
        .name = "subtracting pointers to non-overlapping spaces",
        .source = "__attribute__((opencl_global)) int *g;\n"
                  "__attribute__((opencl_local)) int *l;\n"
                  "long f(void) { return g - l; }\n",
        .errors = 1,
    },
    {
        // At the conditional's `?`.
        .name = "a conditional of non-overlapping spaces",
        .source = "__attribute__((address_space(1))) int *p;\n"
                  "int *q;\n"
                  "void f(int c) { void *v = c ? p : q; }\n",
        .errors = 1,
    },
    {
        // clang's "changes address space of nested pointer": a level's space differing under pointers is an error,
        // where a level's const only warns.
        .name = "nested pointer address spaces",
        .source = "__attribute__((address_space(1))) int **pp;\n"
                  "__attribute__((address_space(2))) int **qq;\n"
                  "__attribute__((address_space(1))) int **pp2;\n"
                  "const int **cp;\n"
                  "int **plain;\n"
                  "void f(void) {\n"
                  "  pp = qq;\n"
                  "  plain = pp;\n"
                  "  pp = plain;\n"
                  "  pp = pp2;\n"
                  "  cp = plain;\n"
                  "}\n",
        .errors = 3,
        .warnings = 1,
    },
    {
        // The nested space error reaches levels the walk compares: a depth mismatch below it stays clang's
        // incompatible-pointer-types, a base-type one under a reached space still names the space, and the
        // argument's note names the parameter, not an attribute's argument.
        .name = "nested pointer address spaces at mismatched depths",
        .source = "__attribute__((address_space(1))) int ***deep;\n"
                  "__attribute__((address_space(1))) int **mid;\n"
                  "__attribute__((address_space(1))) int **ai;\n"
                  "double **dp;\n"
                  "struct S { int x; } **sp;\n"
                  "int **ip;\n"
                  "void take(__attribute__((address_space(2))) int **p);\n"
                  "void f(void) {\n"
                  "  deep = mid;\n"
                  "  ai = dp;\n"
                  "  ai = sp;\n"
                  "  deep = ip;\n"
                  "  take(ai);\n"
                  "}\n",
        .errors = 5,
        .notes = 1,
    },
    {
        // A value has no address space: a deduced type drops the initializer's, while a pointer's keeps its pointee's.
        .name = "a deduced type has no address space",
        .source = "__attribute__((address_space(1))) int a;\n"
                  "void f(void) {\n"
                  "  __auto_type b = a;\n"
                  "  int *p = &b;\n"
                  "  __auto_type c = &a;\n"
                  "  __attribute__((address_space(1))) int *q = c;\n"
                  "}\n",
    },
    {
        // String literals initialize arrays of an address space's character, sized and unsized, braced too.
        .name = "string literals into address-space arrays",
        .source = "__attribute__((address_space(1))) char a[] = \"hi\";\n"
                  "__attribute__((address_space(1))) char b[4] = \"hi\";\n"
                  "__attribute__((address_space(1))) char c[] = {\"hi\"};\n"
                  "__attribute__((address_space(1))) char d[2][3] = {\"ab\", \"cd\"};\n",
    },
    {
        // OpenCL's generic includes every space but constant, global its device and host parts; a
        // conditional's result drops its operands' spaces unless they are one type (its type in a later error's words);
        // comparisons and casts of any spaces.
        .name = "conversions within an address space",
        .source = "__attribute__((opencl_global)) int *gl;\n"
                  "__attribute__((opencl_generic)) int *ge;\n"
                  "__attribute__((opencl_global_device)) int *gd;\n"
                  "__attribute__((address_space(1))) int *p;\n"
                  "const __attribute__((address_space(1))) int *cp;\n"
                  "int *q;\n"
                  "void f(int c) {\n"
                  "  ge = gl; gl = gd; ge = gd;\n"
                  "  q = (int *)p; p = (__attribute__((address_space(1))) int *)q;\n"
                  "  (void)(p == q); (void)(p < q); (void)(gl == ge);\n"
                  "  (void)(c ? gl : gl); (void)(c ? ge : gl); (void)(c ? p : 0);\n"
                  "  long d = ge - gl;\n"
                  "}\n",
        .warnings = 1,
    },
    {
        // A conditional's type, as _Generic selects it: pointers of two overlapping spaces make one of none (clang's C),
        // one type keeps its space, a void pointee takes the other's; a value has no space, and __builtin_types_compatible_p
        // compares types without theirs.
        .name = "a conditional's result drops its spaces",
        .source = "__attribute__((opencl_global)) int *gl;\n"
                  "__attribute__((opencl_generic)) int *ge;\n"
                  "__attribute__((address_space(1))) int *p;\n"
                  "__attribute__((address_space(1))) void *v;\n"
                  "const __attribute__((address_space(1))) int *cp;\n"
                  "_Static_assert(_Generic(0 ? ge : gl, int *: 1, default: 0), \"overlapping spaces drop\");\n"
                  "_Static_assert(_Generic(0 ? gl : gl, __attribute__((opencl_global)) int *: 1, default: 0), \"one type keeps\");\n"
                  "_Static_assert(_Generic(0 ? p : v, __attribute__((address_space(1))) void *: 1, default: 0), \"void takes the space\");\n"
                  "_Static_assert(_Generic(0 ? p : cp, const int *: 1, default: 0), \"qualifiers merge, space dropped\");\n"
                  "_Static_assert(_Generic(0 ? p : 0, __attribute__((address_space(1))) int *: 1, default: 0), \"null pointer\");\n"
                  "_Static_assert(_Generic(p, int *: 0, __attribute__((address_space(1))) int *: 1), \"distinct association types\");\n"
                  "_Static_assert(__builtin_types_compatible_p(__typeof__(*p), int) == 1, \"qualifiers dropped\");\n"
                  "_Static_assert(sizeof(*p) == 4 && _Alignof(__attribute__((address_space(1))) long) == 8, \"size and alignment\");\n"
                  "_Static_assert(_Generic(*p, int: 1, default: 0), \"a value has no space\");\n"
                  "_Static_assert(_Generic(cp, const __attribute__((address_space(1))) int *: 1, default: 0), \"qualified pointee\");\n"
                  "int x = _Generic(*cp, int: 1);\n",
    },
    {
        // A member's lvalue takes its record's space.
        .name = "members through an address space",
        .source = "struct S { int m; };\n"
                  "__attribute__((address_space(1))) struct S s;\n"
                  "int *f(void) { return &s.m; }\n",
        .errors = 1,
    },
    {
        // objc_gc's weak and strong on pointers, an inner pointer's and an array's element's too; a local's and a
        // member's weak warnings; the qualifier dropped or added by an assignment.
        .name = "garbage collection qualifiers",
        .source = "int * __attribute__((objc_gc(weak))) w;\n"
                  "int * __attribute__((objc_gc(strong))) s;\n"
                  "__attribute__((objc_gc(weak))) int *moved;\n"
                  "int * __attribute__((objc_gc(weak))) *inner;\n"
                  "int * __attribute__((objc_gc(weak))) array[2];\n"
                  "struct M { int * __attribute__((objc_gc(weak))) m; };\n"
                  "int **plain;\n"
                  "void f(void) {\n"
                  "  int * __attribute__((objc_gc(weak))) local;\n"
                  "  int * __attribute__((objc_gc(strong))) kept;\n"
                  "  plain = &w; inner = plain;\n"
                  "}\n",
        .warnings = 2,
    },
    {
        // Two on one pointer.
        .name = "multiple garbage collection qualifiers",
        .source = "int * __attribute__((objc_gc(weak))) __attribute__((objc_gc(strong))) w;\n",
        .errors = 1,
    },
    {
        // __seg_gs's and __seg_fs's loads and stores, which take the segment's override (#1447), at -c too.
        .name = "segment accesses",
        .source = "struct S { int a, b; };\n"
                  "int f(__seg_gs int *p) { return *p + p[1]; }\n"
                  "void g(__seg_fs struct S *s, int v) { s->b = v; }\n",
    },
    {
        // A generic atomic builtin's pointers that take the object's pointer type (a store's value, an exchange's result,
        // a compare-exchange's desired) in another address space than the object's (#2233): clang's "changes address
        // space of pointer". The others take a pointer to the object's value type, which drops the space, as clang's do.
        .name = "generic atomic builtins' pointers in another address space",
        .source = "void a(int __seg_gs *p, int *v, int *o) { __atomic_exchange(p, v, o, 5); }\n"
                  "void b(int __seg_gs *p, int *r) { __atomic_load(p, r, 5); }\n"
                  "void c(int __seg_gs *p, int *v) { __atomic_store(p, v, 5); }\n"
                  "_Bool d(int __seg_gs *p, int *e, int *w) { return __atomic_compare_exchange(p, e, w, 0, 5, 5); }\n"
                  "void a2(int __seg_gs *p, int __seg_gs *v, int *o) { __atomic_exchange(p, v, o, 5); }\n"
                  "void a3(int *p, int __seg_gs *v, int *o) { __atomic_exchange(p, v, o, 5); }\n"
                  "void b3(int *p, int __seg_gs *r) { __atomic_load(p, r, 5); }\n"
                  "void c3(int *p, int __seg_gs *v) { __atomic_store(p, v, 5); }\n"
                  "_Bool d3(int *p, int __seg_gs *e, int __seg_gs *w) { return __atomic_compare_exchange(p, e, w, 0, 5, 5); }\n",
        .errors = 6,
    },
};
static const size_t fixture_0_lengths[] = {
sizeof("#define AS1 __attribute__((address_space(1)))\n"
                  "AS1 int a;\n"
                  "int b __attribute__((address_space(2)));\n"
                  "int * __attribute__((address_space(3))) c;\n"
                  "__attribute__((opencl_global)) int g;\n"
                  "__attribute__((opencl_global_device)) int gd;\n"
                  "__attribute__((opencl_global_host)) int gh;\n"
                  "__attribute__((opencl_local)) const int *l;\n"
                  "typedef __attribute__((address_space(4))) int T4;\n"
                  "T4 t4[3];\n"
                  "int __attribute__((address_space(5))) __attribute__((address_space(5))) twice;\n"
                  "__seg_gs int *gs;\n"
                  "__seg_fs int *fs;\n"
                  "__attribute__((address_space(0))) int zero;\n"
                  "__attribute__((address_space(8388580))) int highest;\n"
                  "AS1 int *f(void) { return &a; }\n"
                  "AS1 int (*h(void))[3];\n")-1,
sizeof("typedef int T;\n"
                  "typedef __attribute__((address_space(3))) int U;\n"
                  "__attribute__((address_space(1))) T *a;\n"
                  "const U *d;\n"
                  "__attribute__((address_space(1))) int * __attribute__((address_space(2))) const c;\n"
                  "int *q;\n"
                  "void f(int n) { if (n) q = a; else if (n > 1) q = d; else q = c; }\n")-1,
sizeof("void f(void) {\n"
                  "  static __attribute__((address_space(1))) int s;\n"
                  "  extern __attribute__((address_space(1))) int e;\n"
                  "  __attribute__((address_space(1))) int local;\n"
                  "}\n")-1,
sizeof("void f(void) { __attribute__((address_space(1))) int a[2]; }\n")-1,
sizeof("int __attribute__((address_space(1))) __attribute__((address_space(2))) two;\n")-1,
sizeof("__attribute__((opencl_global)) int __attribute__((address_space(1))) both;\n")-1,
sizeof("int __attribute__((address_space(-1))) negative;\n")-1,
sizeof("int __attribute__((address_space(8388581))) large;\n")-1,
sizeof("int n;\n"
                  "int __attribute__((address_space(n))) a;\n")-1,
sizeof("int __attribute__((address_space(1.0))) a;\n")-1,
sizeof("int __attribute__((address_space)) a;\n")-1,
sizeof("int __attribute__((opencl_local(1))) a;\n")-1,
sizeof("struct S { int x; __attribute__((address_space(1))) int m; };\n")-1,
sizeof("typedef __attribute__((address_space(1))) int T;\n"
                  "void f(T x);\n")-1,
sizeof("int f(void) __attribute__((address_space(1)));\n")-1,
sizeof("typedef void F(void);\n"
                  "__attribute__((address_space(1))) F f;\n")-1,
sizeof("int *f(void) { return (__attribute__((address_space(1))) int[]){ 1 }; }\n")-1,
sizeof("__attribute__((address_space(1))) int *p;\n"
                  "int *q;\n"
                  "void f(void) { q = p; }\n")-1,
sizeof("__attribute__((address_space(1))) int a[3];\n"
                  "int (*p)[3] = &a;\n")-1,
sizeof("__attribute__((address_space(1))) int a;\n"
                  "int *f(void) { return &a; }\n")-1,
sizeof("void take(int n, int *to);\n"
                  "void f(__attribute__((address_space(2))) int *p) { take(0, p); }\n")-1,
sizeof("void take(int *);\n"
                  "void f(__seg_gs int *p) { take(p); }\n")-1,
sizeof("__attribute__((address_space(1))) int *p;\n"
                  "__attribute__((address_space(2))) int *r;\n"
                  "void f(void) { r = p; }\n")-1,
sizeof("__attribute__((address_space(1))) void *v;\n"
                  "int *q;\n"
                  "void f(void) { v = q; }\n")-1,
sizeof("__attribute__((opencl_global)) int *g;\n"
                  "__attribute__((opencl_local)) int *l;\n"
                  "long f(void) { return g - l; }\n")-1,
sizeof("__attribute__((address_space(1))) int *p;\n"
                  "int *q;\n"
                  "void f(int c) { void *v = c ? p : q; }\n")-1,
sizeof("__attribute__((address_space(1))) int **pp;\n"
                  "__attribute__((address_space(2))) int **qq;\n"
                  "__attribute__((address_space(1))) int **pp2;\n"
                  "const int **cp;\n"
                  "int **plain;\n"
                  "void f(void) {\n"
                  "  pp = qq;\n"
                  "  plain = pp;\n"
                  "  pp = plain;\n"
                  "  pp = pp2;\n"
                  "  cp = plain;\n"
                  "}\n")-1,
sizeof("__attribute__((address_space(1))) int ***deep;\n"
                  "__attribute__((address_space(1))) int **mid;\n"
                  "__attribute__((address_space(1))) int **ai;\n"
                  "double **dp;\n"
                  "struct S { int x; } **sp;\n"
                  "int **ip;\n"
                  "void take(__attribute__((address_space(2))) int **p);\n"
                  "void f(void) {\n"
                  "  deep = mid;\n"
                  "  ai = dp;\n"
                  "  ai = sp;\n"
                  "  deep = ip;\n"
                  "  take(ai);\n"
                  "}\n")-1,
sizeof("__attribute__((address_space(1))) int a;\n"
                  "void f(void) {\n"
                  "  __auto_type b = a;\n"
                  "  int *p = &b;\n"
                  "  __auto_type c = &a;\n"
                  "  __attribute__((address_space(1))) int *q = c;\n"
                  "}\n")-1,
sizeof("__attribute__((address_space(1))) char a[] = \"hi\";\n"
                  "__attribute__((address_space(1))) char b[4] = \"hi\";\n"
                  "__attribute__((address_space(1))) char c[] = {\"hi\"};\n"
                  "__attribute__((address_space(1))) char d[2][3] = {\"ab\", \"cd\"};\n")-1,
sizeof("__attribute__((opencl_global)) int *gl;\n"
                  "__attribute__((opencl_generic)) int *ge;\n"
                  "__attribute__((opencl_global_device)) int *gd;\n"
                  "__attribute__((address_space(1))) int *p;\n"
                  "const __attribute__((address_space(1))) int *cp;\n"
                  "int *q;\n"
                  "void f(int c) {\n"
                  "  ge = gl; gl = gd; ge = gd;\n"
                  "  q = (int *)p; p = (__attribute__((address_space(1))) int *)q;\n"
                  "  (void)(p == q); (void)(p < q); (void)(gl == ge);\n"
                  "  (void)(c ? gl : gl); (void)(c ? ge : gl); (void)(c ? p : 0);\n"
                  "  long d = ge - gl;\n"
                  "}\n")-1,
sizeof("__attribute__((opencl_global)) int *gl;\n"
                  "__attribute__((opencl_generic)) int *ge;\n"
                  "__attribute__((address_space(1))) int *p;\n"
                  "__attribute__((address_space(1))) void *v;\n"
                  "const __attribute__((address_space(1))) int *cp;\n"
                  "_Static_assert(_Generic(0 ? ge : gl, int *: 1, default: 0), \"overlapping spaces drop\");\n"
                  "_Static_assert(_Generic(0 ? gl : gl, __attribute__((opencl_global)) int *: 1, default: 0), \"one type keeps\");\n"
                  "_Static_assert(_Generic(0 ? p : v, __attribute__((address_space(1))) void *: 1, default: 0), \"void takes the space\");\n"
                  "_Static_assert(_Generic(0 ? p : cp, const int *: 1, default: 0), \"qualifiers merge, space dropped\");\n"
                  "_Static_assert(_Generic(0 ? p : 0, __attribute__((address_space(1))) int *: 1, default: 0), \"null pointer\");\n"
                  "_Static_assert(_Generic(p, int *: 0, __attribute__((address_space(1))) int *: 1), \"distinct association types\");\n"
                  "_Static_assert(__builtin_types_compatible_p(__typeof__(*p), int) == 1, \"qualifiers dropped\");\n"
                  "_Static_assert(sizeof(*p) == 4 && _Alignof(__attribute__((address_space(1))) long) == 8, \"size and alignment\");\n"
                  "_Static_assert(_Generic(*p, int: 1, default: 0), \"a value has no space\");\n"
                  "_Static_assert(_Generic(cp, const __attribute__((address_space(1))) int *: 1, default: 0), \"qualified pointee\");\n"
                  "int x = _Generic(*cp, int: 1);\n")-1,
sizeof("struct S { int m; };\n"
                  "__attribute__((address_space(1))) struct S s;\n"
                  "int *f(void) { return &s.m; }\n")-1,
sizeof("int * __attribute__((objc_gc(weak))) w;\n"
                  "int * __attribute__((objc_gc(strong))) s;\n"
                  "__attribute__((objc_gc(weak))) int *moved;\n"
                  "int * __attribute__((objc_gc(weak))) *inner;\n"
                  "int * __attribute__((objc_gc(weak))) array[2];\n"
                  "struct M { int * __attribute__((objc_gc(weak))) m; };\n"
                  "int **plain;\n"
                  "void f(void) {\n"
                  "  int * __attribute__((objc_gc(weak))) local;\n"
                  "  int * __attribute__((objc_gc(strong))) kept;\n"
                  "  plain = &w; inner = plain;\n"
                  "}\n")-1,
sizeof("int * __attribute__((objc_gc(weak))) __attribute__((objc_gc(strong))) w;\n")-1,
sizeof("struct S { int a, b; };\n"
                  "int f(__seg_gs int *p) { return *p + p[1]; }\n"
                  "void g(__seg_fs struct S *s, int v) { s->b = v; }\n")-1,
sizeof("void a(int __seg_gs *p, int *v, int *o) { __atomic_exchange(p, v, o, 5); }\n"
                  "void b(int __seg_gs *p, int *r) { __atomic_load(p, r, 5); }\n"
                  "void c(int __seg_gs *p, int *v) { __atomic_store(p, v, 5); }\n"
                  "_Bool d(int __seg_gs *p, int *e, int *w) { return __atomic_compare_exchange(p, e, w, 0, 5, 5); }\n"
                  "void a2(int __seg_gs *p, int __seg_gs *v, int *o) { __atomic_exchange(p, v, o, 5); }\n"
                  "void a3(int *p, int __seg_gs *v, int *o) { __atomic_exchange(p, v, o, 5); }\n"
                  "void b3(int *p, int __seg_gs *r) { __atomic_load(p, r, 5); }\n"
                  "void c3(int *p, int __seg_gs *v) { __atomic_store(p, v, 5); }\n"
                  "_Bool d3(int *p, int __seg_gs *e, int __seg_gs *w) { return __atomic_compare_exchange(p, e, w, 0, 5, 5); }\n")-1
};
static const CheckDriverDefaultWarningFixture fixture_1[] =
{
    {
        .name = "the alignment checks' errors, past 128 bits too, and an alignment of 1",
        .source = "int f(int x) { return __builtin_align_up(x, 0); }\n"
                  "int g(int x) { return __builtin_align_up(x, 1L << 40); }\n"
                  "int h(int x) { return __builtin_align_up(x, 3); }\n"
                  "_BitInt(200) k(_BitInt(200) x) { return __builtin_align_up(x, (unsigned _BitInt(300))1 << 200); }\n"
                  "int l(int x) { return __builtin_is_aligned(x, 1); }\n",
        .warnings = 1,
        .errors = 4,
        .notes = 0,
    },
    {
        .name = "the alignment checks' errors at clang's places",
        .source = "enum E { A, B };\n"
                  "int f1(int x) { return __builtin_align_up(x, (0)); }\n"
                  "int f2(int x) { return __builtin_align_down(x, -1); }\n"
                  "int f3(int x) { return __builtin_align_up(x, (long)6); }\n"
                  "char f4(char x) { return __builtin_align_up(x, 256); }\n"
                  "char *f5(char *x) { return __builtin_align_up(x, (__int128)1 << 64); }\n"
                  "enum E f6(enum E x) { return __builtin_align_up(x, 3); }\n"
                  "_Bool f7(unsigned short x) { return __builtin_is_aligned(x, 1 << 17); }\n"
                  "int f8(int x) { const int a = 0; return __builtin_align_up(x, a); }\n"
                  "static const int k = 5;\n"
                  "int f9(int x) { return __builtin_align_up(x, k); }\n"
                  "unsigned _BitInt(130) g(unsigned _BitInt(130) x) { return __builtin_align_up(x, (unsigned _BitInt(140))1 << 131); }\n"
                  "int f10(int x) { return __builtin_align_up(x, sizeof(int[3])); }\n",
        .warnings = 0,
        .errors = 11,
        .notes = 0,
    },
    {
        .name = "the alignment builtins' operand types",
        .source = "struct S { int a; };\n"
                  "double f1(double x) { return __builtin_align_up(x, 4); }\n"
                  "int f2(int x) { return __builtin_align_up(x, 4.0); }\n"
                  "int f3(struct S s) { return __builtin_is_aligned(s, 4); }\n"
                  "int f4(int x, int *p) { return __builtin_align_up(x, p); }\n"
                  "void f5(void (*fp)(void)) { (void)__builtin_align_up(fp, 4); }\n",
        .warnings = 0,
        .errors = 5,
        .notes = 2,
    },
    {
        .name = "an alignment of 1, unevaluated and under a pragma",
        .source = "int a(int x) { return __builtin_align_up(x, 1); }\n"
                  "int b(int x) { return __builtin_align_down(x, 1); }\n"
                  "int c(int x) { const int k = 1; return __builtin_is_aligned(x, k); }\n"
                  "int d(int x) { return __builtin_is_aligned(x, (char)1) + sizeof(__builtin_is_aligned(x, 1)); }\n"
                  "#pragma clang diagnostic ignored \"-Wtautological-compare\"\n"
                  "int e(int x) { return __builtin_is_aligned(x, 1); }\n",
        .warnings = 5,
        .errors = 0,
        .notes = 0,
    },
    {
        .name = "an alignment of 1 where the source's type is refused",
        .source = "struct S{int a;};enum E{A};\n"
                  "int a(double x) { return __builtin_is_aligned(x, 1); }\n"
                  "int b(int x) { return __builtin_is_aligned(x, 1); }\n"
                  "int c(struct S s) { return __builtin_is_aligned(s, 1); }\n"
                  "int d(enum E e) { return __builtin_is_aligned(e, 1); }\n"
                  "int e(void (*f)(void)) { return __builtin_is_aligned(f, 1); }\n"
                  "int g(int *p) { return __builtin_is_aligned(p, 1) + __builtin_is_aligned(p + 1, 1); }\n"
                  "int h(char a[4]) { char b[3]; return __builtin_is_aligned(b, 1) + __builtin_is_aligned(a, 1); }\n",
        .warnings = 5,
        .errors = 4,
        .notes = 2,
    },
};
static const size_t fixture_1_lengths[] = {
sizeof("int f(int x) { return __builtin_align_up(x, 0); }\n"
                  "int g(int x) { return __builtin_align_up(x, 1L << 40); }\n"
                  "int h(int x) { return __builtin_align_up(x, 3); }\n"
                  "_BitInt(200) k(_BitInt(200) x) { return __builtin_align_up(x, (unsigned _BitInt(300))1 << 200); }\n"
                  "int l(int x) { return __builtin_is_aligned(x, 1); }\n")-1,
sizeof("enum E { A, B };\n"
                  "int f1(int x) { return __builtin_align_up(x, (0)); }\n"
                  "int f2(int x) { return __builtin_align_down(x, -1); }\n"
                  "int f3(int x) { return __builtin_align_up(x, (long)6); }\n"
                  "char f4(char x) { return __builtin_align_up(x, 256); }\n"
                  "char *f5(char *x) { return __builtin_align_up(x, (__int128)1 << 64); }\n"
                  "enum E f6(enum E x) { return __builtin_align_up(x, 3); }\n"
                  "_Bool f7(unsigned short x) { return __builtin_is_aligned(x, 1 << 17); }\n"
                  "int f8(int x) { const int a = 0; return __builtin_align_up(x, a); }\n"
                  "static const int k = 5;\n"
                  "int f9(int x) { return __builtin_align_up(x, k); }\n"
                  "unsigned _BitInt(130) g(unsigned _BitInt(130) x) { return __builtin_align_up(x, (unsigned _BitInt(140))1 << 131); }\n"
                  "int f10(int x) { return __builtin_align_up(x, sizeof(int[3])); }\n")-1,
sizeof("struct S { int a; };\n"
                  "double f1(double x) { return __builtin_align_up(x, 4); }\n"
                  "int f2(int x) { return __builtin_align_up(x, 4.0); }\n"
                  "int f3(struct S s) { return __builtin_is_aligned(s, 4); }\n"
                  "int f4(int x, int *p) { return __builtin_align_up(x, p); }\n"
                  "void f5(void (*fp)(void)) { (void)__builtin_align_up(fp, 4); }\n")-1,
sizeof("int a(int x) { return __builtin_align_up(x, 1); }\n"
                  "int b(int x) { return __builtin_align_down(x, 1); }\n"
                  "int c(int x) { const int k = 1; return __builtin_is_aligned(x, k); }\n"
                  "int d(int x) { return __builtin_is_aligned(x, (char)1) + sizeof(__builtin_is_aligned(x, 1)); }\n"
                  "#pragma clang diagnostic ignored \"-Wtautological-compare\"\n"
                  "int e(int x) { return __builtin_is_aligned(x, 1); }\n")-1,
sizeof("struct S{int a;};enum E{A};\n"
                  "int a(double x) { return __builtin_is_aligned(x, 1); }\n"
                  "int b(int x) { return __builtin_is_aligned(x, 1); }\n"
                  "int c(struct S s) { return __builtin_is_aligned(s, 1); }\n"
                  "int d(enum E e) { return __builtin_is_aligned(e, 1); }\n"
                  "int e(void (*f)(void)) { return __builtin_is_aligned(f, 1); }\n"
                  "int g(int *p) { return __builtin_is_aligned(p, 1) + __builtin_is_aligned(p + 1, 1); }\n"
                  "int h(char a[4]) { char b[3]; return __builtin_is_aligned(b, 1) + __builtin_is_aligned(a, 1); }\n")-1
};
static const CheckDriverDefaultWarningFixture fixture_2[] =
{
    {
        // An object of automatic storage, `auto` or none, an array, a VLA, a struct, each declarator of a list, in a nested
        // block, a label of several strings and escapes; not a register variable's, a static's, an extern's, a function's or
        // a typedef's, nor a file-scope object's.
        .name = "asm labels on automatic variables",
        .source = "int g asm(\"g1\");\n"
                  "void a(void) { auto int c asm(\"c1\"); int d asm(\"d1\") = 2, e asm(\"e1\"); (void)c; (void)d; (void)e; }\n"
                  "void b(void) { typedef int T asm(\"t1\"); int f(void) asm(\"ff\"); extern int x asm(\"xx\"); static int s asm(\"ss\"); "
                  "register int r asm(\"eax\"); (void)r; (void)s; }\n"
                  "void c(int k) { int vla[k] asm(\"v\\x41\"); (void)vla; { struct { int a; } st asm(\"st\" \"1\"); (void)st; } }\n"
                  "void d(void) { int q __asm__(\"q1\") __attribute__((unused)); int u asm(\"u1\"), w asm(\"w1\"); u = w = 1; }\n",
        .warnings = 8,
    },
    {
        // A for statement's declarations (#2419): each declarator's label, after a pointer's or a parenthesized declarator,
        // with attributes after it; a register variable's is no automatic one's.
        .name = "asm labels in for statements' declarations",
        .source = "void b(void) { for (int i asm(\"i1\") = 0; i < 1; i++) {} }\n"
                  "void c(void) { for (int i __asm__(\"i2\") __attribute__((unused)) = 0, j asm(\"j\") = 1; i < j; i++) {} }\n"
                  "void d(void) { for (register int r asm(\"ebx\") = 0; r < 1; r++) {} }\n"
                  "void e(void) { for (int *p asm(\"p1\") = 0, (*q) asm(\"q1\"), (k) asm(\"k1\"); ;) { (void)p; (void)q; (void)k; break; } }\n",
        .warnings = 6,
    },
    {
        // C23's `auto` of an inferred type and constexpr objects.
        .name = "asm labels on C23 automatic variables",
        .source = "void a(void) { auto x __asm__(\"x1\") = 1; (void)x; constexpr int y __asm__(\"y1\") = 2; (void)y; }\n",
        .warnings = 2,
        .c23 = true,
    },
};
static const size_t fixture_2_lengths[] = {
sizeof("int g asm(\"g1\");\n"
                  "void a(void) { auto int c asm(\"c1\"); int d asm(\"d1\") = 2, e asm(\"e1\"); (void)c; (void)d; (void)e; }\n"
                  "void b(void) { typedef int T asm(\"t1\"); int f(void) asm(\"ff\"); extern int x asm(\"xx\"); static int s asm(\"ss\"); "
                  "register int r asm(\"eax\"); (void)r; (void)s; }\n"
                  "void c(int k) { int vla[k] asm(\"v\\x41\"); (void)vla; { struct { int a; } st asm(\"st\" \"1\"); (void)st; } }\n"
                  "void d(void) { int q __asm__(\"q1\") __attribute__((unused)); int u asm(\"u1\"), w asm(\"w1\"); u = w = 1; }\n")-1,
sizeof("void b(void) { for (int i asm(\"i1\") = 0; i < 1; i++) {} }\n"
                  "void c(void) { for (int i __asm__(\"i2\") __attribute__((unused)) = 0, j asm(\"j\") = 1; i < j; i++) {} }\n"
                  "void d(void) { for (register int r asm(\"ebx\") = 0; r < 1; r++) {} }\n"
                  "void e(void) { for (int *p asm(\"p1\") = 0, (*q) asm(\"q1\"), (k) asm(\"k1\"); ;) { (void)p; (void)q; (void)k; break; } }\n")-1,
sizeof("void a(void) { auto x __asm__(\"x1\") = 1; (void)x; constexpr int y __asm__(\"y1\") = 2; (void)y; }\n")-1
};
static const CheckDriverDefaultWarningFixture fixture_3[] =
{
    {
        // A `<<` of literals and a conditional of integer literals as a static assertion's condition, at file scope, among
        // a record's members and in a block, where the shift's count gives no warning of its own; a runtime one's does.
        .name = "static assertions' conditions converted to booleans",
        .source = "_Static_assert(1 << 40, \"big\");\n"
                  "struct Y { int a; _Static_assert(1 << 40, \"big\"); };\n"
                  "void f(void) { _Static_assert(1 << 40, \"big\"); if (1 << 40) {} }\n"
                  "_Static_assert(1 << 4, \"a\");\n"
                  "_Static_assert(2 ? 3 : 4, \"c\");\n"
                  "_Static_assert(1 ? 1 : 0, \"d\");\n"
                  "_Static_assert((1 << 4) != 0, \"e\");\n",
        .warnings = 7,
        .compare_warning_text = true,
    },
};
static const size_t fixture_3_lengths[] = {
sizeof("_Static_assert(1 << 40, \"big\");\n"
                  "struct Y { int a; _Static_assert(1 << 40, \"big\"); };\n"
                  "void f(void) { _Static_assert(1 << 40, \"big\"); if (1 << 40) {} }\n"
                  "_Static_assert(1 << 4, \"a\");\n"
                  "_Static_assert(2 ? 3 : 4, \"c\");\n"
                  "_Static_assert(1 ? 1 : 0, \"d\");\n"
                  "_Static_assert((1 << 4) != 0, \"e\");\n")-1
};
static const CheckDriverDefaultWarningFixture fixture_4[] =
{
    {
        // "expression evaluates to" with a const object's value its initializer gives: a scalar's, in an operand's
        // arithmetic, a member's, an element's, a block's static's and a char's (as a character).
        .name = "static assertions of const objects",
        .source = "const int k = 0;\n"
                  "_Static_assert(k == 45, \"\");\n"
                  "const long m = 7;\n"
                  "_Static_assert(m + 1 == 3, \"\");\n"
                  "struct P { int a; }; const struct P p = { 4 };\n"
                  "_Static_assert(p.a == 5, \"\");\n"
                  "const int arr[2] = { 1, 2 };\n"
                  "_Static_assert(arr[1] == 5, \"\");\n"
                  "void f(void) { static const int s = 3; _Static_assert(s == 4, \"\"); }\n"
                  "const char c = 'x';\n"
                  "_Static_assert(c == 'y', \"\");\n",
        .errors = 6,
        .notes = 6,
        .syntax_only = true,
    },
    {
        // The requirement as clang's printer prints it (#2482): a compound literal's completed array bound, a _Generic's
        // `int: 1` associations, and no note where a selection's chosen operand is a literal; a record or enumeration a
        // type name defines by its name, or `(unnamed at f.c:1:2)`, without its body.
        .name = "static assertion requirements of selections, compound literals and defined tags",
        .source = "int x;\n"
                  "_Static_assert(sizeof((int[]){1, 2}) == 1, \"a\");\n"
                  "_Static_assert(sizeof((int[][2]){{1, 2}, {3}}) == 1, \"b\");\n"
                  "_Static_assert(_Generic(x, int: 1, default: 2) == 2, \"c\");\n"
                  "_Static_assert(_Generic(x, int: 1, default: 2) + 1 == 3, \"d\");\n"
                  "_Static_assert(__builtin_choose_expr(1, 3, 4) == 4, \"e\");\n"
                  "_Static_assert(__builtin_offsetof(struct { int a, b; }, b) == 1, \"f\");\n"
                  "_Static_assert(__builtin_offsetof(struct T { int a, b; }, b) == 1, \"g\");\n"
                  "_Static_assert(__builtin_offsetof(union { int a, b; }, b) == 1, \"h\");\n"
                  "_Static_assert(sizeof(enum E { A }) == 1, \"i\");\n"
                  "_Static_assert(sizeof(enum { B }) == 1, \"j\");\n",
        .errors = 10,
        .notes = 8,
        .syntax_only = true,
    },
};
static const size_t fixture_4_lengths[] = {
sizeof("const int k = 0;\n"
                  "_Static_assert(k == 45, \"\");\n"
                  "const long m = 7;\n"
                  "_Static_assert(m + 1 == 3, \"\");\n"
                  "struct P { int a; }; const struct P p = { 4 };\n"
                  "_Static_assert(p.a == 5, \"\");\n"
                  "const int arr[2] = { 1, 2 };\n"
                  "_Static_assert(arr[1] == 5, \"\");\n"
                  "void f(void) { static const int s = 3; _Static_assert(s == 4, \"\"); }\n"
                  "const char c = 'x';\n"
                  "_Static_assert(c == 'y', \"\");\n")-1,
sizeof("int x;\n"
                  "_Static_assert(sizeof((int[]){1, 2}) == 1, \"a\");\n"
                  "_Static_assert(sizeof((int[][2]){{1, 2}, {3}}) == 1, \"b\");\n"
                  "_Static_assert(_Generic(x, int: 1, default: 2) == 2, \"c\");\n"
                  "_Static_assert(_Generic(x, int: 1, default: 2) + 1 == 3, \"d\");\n"
                  "_Static_assert(__builtin_choose_expr(1, 3, 4) == 4, \"e\");\n"
                  "_Static_assert(__builtin_offsetof(struct { int a, b; }, b) == 1, \"f\");\n"
                  "_Static_assert(__builtin_offsetof(struct T { int a, b; }, b) == 1, \"g\");\n"
                  "_Static_assert(__builtin_offsetof(union { int a, b; }, b) == 1, \"h\");\n"
                  "_Static_assert(sizeof(enum E { A }) == 1, \"i\");\n"
                  "_Static_assert(sizeof(enum { B }) == 1, \"j\");\n")-1
};
static const CheckDriverDefaultWarningFixture fixture_5[] =
{
    {
        // Assignments, compound assignments, initializers, returns, prototype arguments, brace
        // initializers and a typedef's spelling; a flag_enum's bits; enumerators, a variable and a cast don't warn.
        .name = "integer constants out of an enumeration",
        .source = "enum A { A1, A2 } a;\n"
                  "enum B { B1 = 1, B2 = 4, B3 = 8 } b;\n"
                  "enum __attribute__((flag_enum)) F { F1 = 1, F2 = 4 } fl;\n"
                  "typedef enum A TA;\n"
                  "void g(enum A);\n"
                  "enum A h(void) { return 7; }\n"
                  "void f(int x)\n"
                  "{\n"
                  "    a = 5; a = 1; a = A2; a = x; a = -1; a = 1 ? 3 : 0;\n"
                  "    enum A c = 7; TA d = 9; b = 2; b = 4; b = 3; fl = 5; fl = 2;\n"
                  "    g(4); a += 9; a = (enum A)9; a = 'x';\n"
                  "    enum A arr[2] = { 1, 6 };\n"
                  "    struct { enum A m; } s = { 9 };\n"
                  "    (void)c; (void)d; (void)arr; (void)s;\n"
                  "}\n"
                  "enum A k = 9;\n",
        .options = { "-Wassign-enum" },
        .warnings = 15,
    },
    {
        // enum_extensibility(open) and (closed); an anonymous typedef's; a value in the enumeration's width and signedness
        // (negative, past int, a fixed underlying type's truncation); a trailing flag_enum's masks; bit-fields; unreachable
        // and unevaluated code; designators, a compound literal; _Bool, character, conditional and comma sources.
        .name = "integer constants out of an enumeration's edges",
        .source = "enum __attribute__((enum_extensibility(open))) O { O1 } o;\n"
                  "enum __attribute__((enum_extensibility(closed))) C { C1 } cl;\n"
                  "typedef enum { U1, U2 } T;\n"
                  "enum N { NM = -1, N0, NB = 0x80000000u } n;\n"
                  "enum M { M1 = 1 } __attribute__((flag_enum)) m;\n"
                  "enum : unsigned char { X0 = 0, X1 = 1 } ux;\n"
                  "struct R { enum N f : 4; enum N g; } r;\n"
                  "void take(T, ...);\n"
                  "const enum N cn = 7;\n"
                  "void f(int x)\n"
                  "{\n"
                  "    o = 3; cl = 3; T t = 9; n = -1; n = 0x80000000u; n = 3; m = 1; m = ~1; m = 2;\n"
                  "    ux = 256; ux = 257; r.f = 5; r.g = 0; r.g = 2;\n"
                  "    take(5, 6);\n"
                  "    if (0) n = 9;\n"
                  "    unsigned long z = sizeof(n = 9);\n"
                  "    enum N arr[] = { [3] = 9, 1, 0 };\n"
                  "    struct R rr = { .g = 9 };\n"
                  "    T *pt = &(T){ 7 };\n"
                  "    n = (_Bool)1; n = (char)'a'; n = 0 ? 1 : 2; n = (1, 3);\n"
                  "    (void)t; (void)z; (void)arr; (void)rr; (void)pt;\n"
                  "}\n",
        .options = { "-Wassign-enum" },
        .c23 = true,
        .warnings = 21,
    },
    {
        // A braced scalar, a nested definition's enumerators, file-scope aggregates, a macro's argument, a pragma's
        // suppression and a return's conditional.
        .name = "integer constants out of an enumeration at file scope",
        .source = "enum A { A1, A2 = sizeof(enum B { B1, B2 = 5 }) } a;\n"
                  "enum A x = { 9 };\n"
                  "enum B y = 3;\n"
                  "struct S { enum A m[2]; enum B n; } s = { { 1, 7 }, 4 };\n"
                  "#define SET(v) a = v\n"
                  "#pragma clang diagnostic push\n"
                  "#pragma clang diagnostic ignored \"-Wassign-enum\"\n"
                  "enum A ig = 9;\n"
                  "#pragma clang diagnostic pop\n"
                  "enum A f(void) { SET(3); return 0 ? 2 : 3; }\n",
        .options = { "-Wassign-enum" },
        .warnings = 7,
    },
    {
        // Off by default; a pragma enables and ignores it.
        .name = "assign-enum pragmas",
        .source = "#pragma clang diagnostic warning \"-Wassign-enum\"\n"
                  "enum A { A1, A2 } a;\n"
                  "void f(void) { a = 5; }\n"
                  "#pragma clang diagnostic ignored \"-Wassign-enum\"\n"
                  "void g(void) { a = 5; }\n",
        .warnings = 1,
    },
};
static const size_t fixture_5_lengths[] = {
sizeof("enum A { A1, A2 } a;\n"
                  "enum B { B1 = 1, B2 = 4, B3 = 8 } b;\n"
                  "enum __attribute__((flag_enum)) F { F1 = 1, F2 = 4 } fl;\n"
                  "typedef enum A TA;\n"
                  "void g(enum A);\n"
                  "enum A h(void) { return 7; }\n"
                  "void f(int x)\n"
                  "{\n"
                  "    a = 5; a = 1; a = A2; a = x; a = -1; a = 1 ? 3 : 0;\n"
                  "    enum A c = 7; TA d = 9; b = 2; b = 4; b = 3; fl = 5; fl = 2;\n"
                  "    g(4); a += 9; a = (enum A)9; a = 'x';\n"
                  "    enum A arr[2] = { 1, 6 };\n"
                  "    struct { enum A m; } s = { 9 };\n"
                  "    (void)c; (void)d; (void)arr; (void)s;\n"
                  "}\n"
                  "enum A k = 9;\n")-1,
sizeof("enum __attribute__((enum_extensibility(open))) O { O1 } o;\n"
                  "enum __attribute__((enum_extensibility(closed))) C { C1 } cl;\n"
                  "typedef enum { U1, U2 } T;\n"
                  "enum N { NM = -1, N0, NB = 0x80000000u } n;\n"
                  "enum M { M1 = 1 } __attribute__((flag_enum)) m;\n"
                  "enum : unsigned char { X0 = 0, X1 = 1 } ux;\n"
                  "struct R { enum N f : 4; enum N g; } r;\n"
                  "void take(T, ...);\n"
                  "const enum N cn = 7;\n"
                  "void f(int x)\n"
                  "{\n"
                  "    o = 3; cl = 3; T t = 9; n = -1; n = 0x80000000u; n = 3; m = 1; m = ~1; m = 2;\n"
                  "    ux = 256; ux = 257; r.f = 5; r.g = 0; r.g = 2;\n"
                  "    take(5, 6);\n"
                  "    if (0) n = 9;\n"
                  "    unsigned long z = sizeof(n = 9);\n"
                  "    enum N arr[] = { [3] = 9, 1, 0 };\n"
                  "    struct R rr = { .g = 9 };\n"
                  "    T *pt = &(T){ 7 };\n"
                  "    n = (_Bool)1; n = (char)'a'; n = 0 ? 1 : 2; n = (1, 3);\n"
                  "    (void)t; (void)z; (void)arr; (void)rr; (void)pt;\n"
                  "}\n")-1,
sizeof("enum A { A1, A2 = sizeof(enum B { B1, B2 = 5 }) } a;\n"
                  "enum A x = { 9 };\n"
                  "enum B y = 3;\n"
                  "struct S { enum A m[2]; enum B n; } s = { { 1, 7 }, 4 };\n"
                  "#define SET(v) a = v\n"
                  "#pragma clang diagnostic push\n"
                  "#pragma clang diagnostic ignored \"-Wassign-enum\"\n"
                  "enum A ig = 9;\n"
                  "#pragma clang diagnostic pop\n"
                  "enum A f(void) { SET(3); return 0 ? 2 : 3; }\n")-1,
sizeof("#pragma clang diagnostic warning \"-Wassign-enum\"\n"
                  "enum A { A1, A2 } a;\n"
                  "void f(void) { a = 5; }\n"
                  "#pragma clang diagnostic ignored \"-Wassign-enum\"\n"
                  "void g(void) { a = 5; }\n")-1
};
static const char check_driver_bitfield_groups_source[] =
    "struct S { int a : 1; int b : 3; } s;\nchar c = 300;\nvoid f(void) { s.a = 1; s.b = 9; }\n";
static const CheckDriverDefaultWarningFixture fixture_6[] =
{
    {
        .name = "assignments truncate constants by their bit-fields' widths and signedness",
        .source = "struct S { int a : 1; signed char c : 2; unsigned u : 3; int b : 3; enum E { X, Y = 9 } e : 2; _Bool z : 1; } s;\n"
                  "void g(void) {\n    s.a = 1;\n    s.c = 200;\n    s.u = 9u;\n    s.b = 'a';\n    s.b = (9);\n    s.b = 3;\n    s.b = 4;\n"
                  "    s.b = -4;\n    s.u = -1;\n    s.z = 2;\n    s.e = Y;\n    s.e = 9;\n    s.b = 9L;\n    s.b = 9.0;\n    s.b += 9;\n    s.b++;\n}\n",
        .warnings = 9,
    },
    {
        .name = "a negated or complemented constant keeps its significant bits",
        .source = "struct S { int b : 3; unsigned u : 3; } s;\n"
                  "void g(void) {\n    s.b = ~8;\n    s.b = -(9);\n    s.b = -4;\n    s.b = -5;\n    s.u = -9;\n    s.u = ~0u;\n    s.u = -1;\n"
                  "    s.b = 0 - 5;\n}\n",
        .warnings = 5,
    },
    {
        .name = "a computed negative constant truncates in an unsigned bit-field, and fitting flags stay quiet",
        .source = "struct S { unsigned u : 3; int b : 3; unsigned v : 1; };\nstruct S g = { 0 - 2, 0 - 4, 1 };\n"
                  "void f(struct S *p) { struct S t = { .u = 0 - 2, .b = -4, .v = 1 }; p->u = 0 - 2; p->b = 0 - 5; p->v = 1; (void)t; }\n",
        .warnings = 4,
    },
    {
        // _BitInt constants past 128 bits (#1447, c_check_wide.c): their values change in narrower types, signed, unsigned
        // and wider than 128 bits, in decimal; a sign flip into a signed target is reported at once, as clang's.
        .name = "constants past 128 bits change value in narrower types",
        .source = "char c = ((_BitInt(200))1 << 150) | 257;\nint s = 340282366920938463463374607431768211457wb;\n"
                  "_BitInt(150) n = (_BitInt(300))1 << 200;\nunsigned _BitInt(129) m = ((unsigned _BitInt(300))1 << 250) + 7;\n"
                  "signed char k = ((_BitInt(200))1 << 7) + 0;\n_BitInt(129) p = ((_BitInt(130))1 << 128) + 1;\nunsigned char u = -(_BitInt(200))1;\n"
                  "short t = -((_BitInt(200))40000);\nunsigned long v = -((_BitInt(300))1 << 64);\n"
                  "int f(void) { int a = (_BitInt(200))1 << 150; unsigned _BitInt(200) b = (_BitInt(256))-1; long d = (_BitInt(200))1 << 63; return a + (int)b + (int)d; }\n",
        .warnings = 11,
    },
    {
        // A declarator after a specifier's parentheses is evaluated (#1447): `_BitInt(100) n = e;` (and `typeof(int) y = e;`) keeps
        // its conversion's warnings, which an operand of typeof's own drops.
        .name = "a declarator after typeof's or _BitInt's parentheses keeps its warnings",
        .source = "_BitInt(100) n = (_BitInt(120))1 << 110;\n__typeof__((char)300) z = 0;\nvoid f(void) { _BitInt(100) m = (_BitInt(120))1 << 110; (void)m; }\n",
        .warnings = 2,
    },
    {
        .name = "an assignment's truncation leaves out its constant conversion and follows clang's walk",
        .source = "struct S { signed char c : 2; unsigned char d : 4; int b : 3; unsigned u : 3; } s;\nint f(int);\n"
                  "void g(int x) {\n    s.c = 200;\n    s.d = 300;\n    s.b = 9, s.b = 10;\n    f(s.b = 12);\n    s.b = s.u = 9;\n    s.b = 1 ? 9 : 2;\n"
                  "    s.b = 1 << 32;\n    x ? (s.b = 9) : (s.u = 9);\n    0 && (s.b = 10);\n    return;\n    s.b = 9;\n}\n",
        .warnings = 13,
    },
    {
        .name = "typedefs, enumerations, members through pointers and wide bit-fields",
        .source = "typedef unsigned U;\ntypedef int I;\nenum E { A = 9, B = -9 };\n"
                  "struct S { int b : 3; unsigned u : 3; long long l : 40; enum E e : 3; unsigned char c : 4; I t : 2; };\n"
                  "void f(struct S *p) {\n    p->b = (I)9;\n    p->u = (U)9;\n    p->l = 0x10000000000LL;\n    p->l = -0x8000000001LL;\n    p->e = A;\n"
                  "    p->e = B;\n    p->c = 300;\n    p->t = -3;\n    p->b = 'z';\n    p->b = 1u << 31;\n}\n",
        .warnings = 10,
    },
    {
        .name = "initializers truncate in member order before their conversions",
        .source = "struct S { int a : 1; signed char c : 2; unsigned u : 3; int b : 3; int w; char z; };\n"
                  "struct S g1 = { 1, 200, 9, 1 + 8, 1.5, 300 };\nstruct S g2 = { .b = -5, .u = ~0u, .c = (char)200 };\n"
                  "int f(int x) {\n    struct S t = { 1, 200, 9, 1 + 8, 0, 1.5 };\n    struct S v[2] = { [1].b = 9, [0] = { .u = -9 } };\n"
                  "    struct S y = { x, 9, 9, x / 0, 300 };\n    return t.a + v[0].b + y.w;\n}\n",
        .warnings = 18,
    },
    {
        .name = "an initializer's truncation stands at its value's grouping parenthesis",
        .source = "struct S { int b : 3; int c : 3; };\nstruct S g1 = { (9) };\nstruct S g2 = { ((9)), (1 << 4) };\n"
                  "struct S g3 = { .b = (9), .c = 9 };\nstruct T { struct S s; } g4 = { { (9) } };\nstruct S g5[2] = { [0 ... 1] = { (9) } };\n"
                  "int f(void) { struct S l = (struct S){ (9), -(9) }; return l.b; }\nstruct S g6 = { -(9), (int)9 };\n",
        .warnings = 12,
    },
    {
        .name = "initializers keep their ordinary constant conversions",
        .source = "struct S { unsigned char c : 4; signed char d : 2; signed char e : 8; int i : 3; unsigned char f : 8; };\n"
                  "struct S g = { 300, 200, 200, 9, 256 };\nvoid f(void) {\n    struct S t = { 300, 200, 200, 9, 256 };\n    (void)t;\n}\n",
        .warnings = 14,
    },
    {
        .name = "unions, nested records, compound literals, unreachable and unevaluated initializers",
        .source = "struct S { int b : 3; unsigned u : 3; };\nunion W { int b : 3; unsigned u : 2; };\nstruct N { struct S s; int k : 2; };\n"
                  "union W gw = { 9 };\nstruct N gn = { { .u = 8 }, 4 };\nvoid f(void) {\n    (void)sizeof((struct S){ .b = 9 });\n"
                  "    (void)(struct S){ .b = 9, .u = 9 };\n    if (0) { struct S q = { 9 }; (void)q; }\n    union W w = { .u = 4 };\n    (void)w;\n"
                  "    return;\n    struct S r = { 10 };\n    (void)r;\n}\n",
        .warnings = 9,
    },
    {
        .name = "bit-field truncation's default groups",
        .source = check_driver_bitfield_groups_source,
        .warnings = 3,
    },
    {
        .name = "-Wno-conversion silences constant and bit-field truncation warnings",
        .source = check_driver_bitfield_groups_source,
        .options = { "-Wno-conversion" },
    },
    {
        .name = "-Wno-non-gcc silences constant and bit-field truncation warnings",
        .source = check_driver_bitfield_groups_source,
        .options = { "-Wno-non-gcc" },
    },
    {
        .name = "-Wno-bitfield-constant-conversion keeps the constant conversion",
        .source = check_driver_bitfield_groups_source,
        .options = { "-Wno-bitfield-constant-conversion" },
        .warnings = 1,
    },
    {
        .name = "-Wno-single-bit-bitfield-constant-conversion keeps the others",
        .source = check_driver_bitfield_groups_source,
        .options = { "-Wno-single-bit-bitfield-constant-conversion" },
        .warnings = 2,
    },
    {
        .name = "-Werror=bitfield-constant-conversion promotes both bit-field warnings",
        .source = check_driver_bitfield_groups_source,
        .options = { "-Werror=bitfield-constant-conversion" },
        .warnings = 1,
        .errors = 2,
    },
    {
        .name = "-Werror=constant-conversion promotes all three",
        .source = check_driver_bitfield_groups_source,
        .options = { "-Werror=constant-conversion" },
        .errors = 3,
    },
    {
        .name = "-Wconstant-conversion enables all three after -Wno-everything",
        .source = check_driver_bitfield_groups_source,
        .options = { "-Wno-everything", "-Wconstant-conversion" },
        .warnings = 3,
    },
    {
        .name = "-Wsingle-bit-bitfield-constant-conversion re-enables its own after -Wno-constant-conversion",
        .source = check_driver_bitfield_groups_source,
        .options = { "-Wno-constant-conversion", "-Wsingle-bit-bitfield-constant-conversion" },
        .warnings = 1,
    },
    {
        .name = "source policy reaches bit-field truncation",
        .source = "struct S { int a : 1; int b : 3; } s;\nvoid f(void) {\n#pragma clang diagnostic push\n"
                  "#pragma clang diagnostic ignored \"-Wbitfield-constant-conversion\"\n    s.a = 1;\n    s.b = 9;\n#pragma clang diagnostic pop\n"
                  "#pragma clang diagnostic error \"-Wsingle-bit-bitfield-constant-conversion\"\n    s.a = 1;\n    s.b = 9;\n}\n",
        .warnings = 1,
        .errors = 1,
    },
};
static const size_t fixture_6_lengths[] = {
sizeof("struct S { int a : 1; signed char c : 2; unsigned u : 3; int b : 3; enum E { X, Y = 9 } e : 2; _Bool z : 1; } s;\n"
                  "void g(void) {\n    s.a = 1;\n    s.c = 200;\n    s.u = 9u;\n    s.b = 'a';\n    s.b = (9);\n    s.b = 3;\n    s.b = 4;\n"
                  "    s.b = -4;\n    s.u = -1;\n    s.z = 2;\n    s.e = Y;\n    s.e = 9;\n    s.b = 9L;\n    s.b = 9.0;\n    s.b += 9;\n    s.b++;\n}\n")-1,
sizeof("struct S { int b : 3; unsigned u : 3; } s;\n"
                  "void g(void) {\n    s.b = ~8;\n    s.b = -(9);\n    s.b = -4;\n    s.b = -5;\n    s.u = -9;\n    s.u = ~0u;\n    s.u = -1;\n"
                  "    s.b = 0 - 5;\n}\n")-1,
sizeof("struct S { unsigned u : 3; int b : 3; unsigned v : 1; };\nstruct S g = { 0 - 2, 0 - 4, 1 };\n"
                  "void f(struct S *p) { struct S t = { .u = 0 - 2, .b = -4, .v = 1 }; p->u = 0 - 2; p->b = 0 - 5; p->v = 1; (void)t; }\n")-1,
sizeof("char c = ((_BitInt(200))1 << 150) | 257;\nint s = 340282366920938463463374607431768211457wb;\n"
                  "_BitInt(150) n = (_BitInt(300))1 << 200;\nunsigned _BitInt(129) m = ((unsigned _BitInt(300))1 << 250) + 7;\n"
                  "signed char k = ((_BitInt(200))1 << 7) + 0;\n_BitInt(129) p = ((_BitInt(130))1 << 128) + 1;\nunsigned char u = -(_BitInt(200))1;\n"
                  "short t = -((_BitInt(200))40000);\nunsigned long v = -((_BitInt(300))1 << 64);\n"
                  "int f(void) { int a = (_BitInt(200))1 << 150; unsigned _BitInt(200) b = (_BitInt(256))-1; long d = (_BitInt(200))1 << 63; return a + (int)b + (int)d; }\n")-1,
sizeof("_BitInt(100) n = (_BitInt(120))1 << 110;\n__typeof__((char)300) z = 0;\nvoid f(void) { _BitInt(100) m = (_BitInt(120))1 << 110; (void)m; }\n")-1,
sizeof("struct S { signed char c : 2; unsigned char d : 4; int b : 3; unsigned u : 3; } s;\nint f(int);\n"
                  "void g(int x) {\n    s.c = 200;\n    s.d = 300;\n    s.b = 9, s.b = 10;\n    f(s.b = 12);\n    s.b = s.u = 9;\n    s.b = 1 ? 9 : 2;\n"
                  "    s.b = 1 << 32;\n    x ? (s.b = 9) : (s.u = 9);\n    0 && (s.b = 10);\n    return;\n    s.b = 9;\n}\n")-1,
sizeof("typedef unsigned U;\ntypedef int I;\nenum E { A = 9, B = -9 };\n"
                  "struct S { int b : 3; unsigned u : 3; long long l : 40; enum E e : 3; unsigned char c : 4; I t : 2; };\n"
                  "void f(struct S *p) {\n    p->b = (I)9;\n    p->u = (U)9;\n    p->l = 0x10000000000LL;\n    p->l = -0x8000000001LL;\n    p->e = A;\n"
                  "    p->e = B;\n    p->c = 300;\n    p->t = -3;\n    p->b = 'z';\n    p->b = 1u << 31;\n}\n")-1,
sizeof("struct S { int a : 1; signed char c : 2; unsigned u : 3; int b : 3; int w; char z; };\n"
                  "struct S g1 = { 1, 200, 9, 1 + 8, 1.5, 300 };\nstruct S g2 = { .b = -5, .u = ~0u, .c = (char)200 };\n"
                  "int f(int x) {\n    struct S t = { 1, 200, 9, 1 + 8, 0, 1.5 };\n    struct S v[2] = { [1].b = 9, [0] = { .u = -9 } };\n"
                  "    struct S y = { x, 9, 9, x / 0, 300 };\n    return t.a + v[0].b + y.w;\n}\n")-1,
sizeof("struct S { int b : 3; int c : 3; };\nstruct S g1 = { (9) };\nstruct S g2 = { ((9)), (1 << 4) };\n"
                  "struct S g3 = { .b = (9), .c = 9 };\nstruct T { struct S s; } g4 = { { (9) } };\nstruct S g5[2] = { [0 ... 1] = { (9) } };\n"
                  "int f(void) { struct S l = (struct S){ (9), -(9) }; return l.b; }\nstruct S g6 = { -(9), (int)9 };\n")-1,
sizeof("struct S { unsigned char c : 4; signed char d : 2; signed char e : 8; int i : 3; unsigned char f : 8; };\n"
                  "struct S g = { 300, 200, 200, 9, 256 };\nvoid f(void) {\n    struct S t = { 300, 200, 200, 9, 256 };\n    (void)t;\n}\n")-1,
sizeof("struct S { int b : 3; unsigned u : 3; };\nunion W { int b : 3; unsigned u : 2; };\nstruct N { struct S s; int k : 2; };\n"
                  "union W gw = { 9 };\nstruct N gn = { { .u = 8 }, 4 };\nvoid f(void) {\n    (void)sizeof((struct S){ .b = 9 });\n"
                  "    (void)(struct S){ .b = 9, .u = 9 };\n    if (0) { struct S q = { 9 }; (void)q; }\n    union W w = { .u = 4 };\n    (void)w;\n"
                  "    return;\n    struct S r = { 10 };\n    (void)r;\n}\n")-1,
sizeof(check_driver_bitfield_groups_source)-1,
sizeof(check_driver_bitfield_groups_source)-1,
sizeof(check_driver_bitfield_groups_source)-1,
sizeof(check_driver_bitfield_groups_source)-1,
sizeof(check_driver_bitfield_groups_source)-1,
sizeof(check_driver_bitfield_groups_source)-1,
sizeof(check_driver_bitfield_groups_source)-1,
sizeof(check_driver_bitfield_groups_source)-1,
sizeof(check_driver_bitfield_groups_source)-1,
sizeof("struct S { int a : 1; int b : 3; } s;\nvoid f(void) {\n#pragma clang diagnostic push\n"
                  "#pragma clang diagnostic ignored \"-Wbitfield-constant-conversion\"\n    s.a = 1;\n    s.b = 9;\n#pragma clang diagnostic pop\n"
                  "#pragma clang diagnostic error \"-Wsingle-bit-bitfield-constant-conversion\"\n    s.a = 1;\n    s.b = 9;\n}\n")-1
};
static const CheckDriverDefaultWarningFixture fixture_7[] =
{
    {
        .name = "builtin arguments' pointer warnings",
        .source = "int g(unsigned char *p) { return __builtin_strlen(p) + __builtin_strcmp(p, \"x\") + __builtin_strncmp(\"y\", p, 1); }\n"
                  "void h(unsigned char *d, const char *s, const unsigned char *cu) { __builtin_strcpy(d, s); __builtin_strcpy((char *)cu, cu); __builtin_strcat(d, cu); }\n"
                  "void k(const char *c) { __builtin_strcpy(c, \"x\"); __builtin_memset(c, 0, 1); }\n"
                  "#define S(x) __builtin_strlen(x)\n"
                  "unsigned long m(signed char *sp) { return S(sp); }\n",
        .warnings = 10,
        .notes = 0,
    },
    {
        .name = "CFString's argument of no ordinary literal (item 1)",
        .source = "static const char s[] = \"x\";\n"
                  "const void* d = __builtin___CFStringMakeConstantString(s);\n"
                  "void f(int x, const char *p) { (void)__builtin___CFStringMakeConstantString(p); (void)__builtin___CFStringMakeConstantString((const char*)\"a\"); }\n"
                  "void g(void) { (void)__builtin___CFStringMakeConstantString((\"a\")); (void)__builtin___CFStringMakeConstantString(u8\"a\"); }\n",
        .warnings = 0,
        .errors = 3,
        .notes = 0,
    },
    {
        .name = "dump_struct's rest argument that doesn't convert to its printer's parameter (item 2)",
        .source = "struct S { int a; };\n"
                  "union U { int a; };\n"
                  "typedef struct { int a; } T;\n"
                  "int p(int* x, const char* f, ...);\n"
                  "int q(int y, int* x, const char* f, ...);\n"
                  "int r(long* x, const char* f, ...);\n"
                  "void g(struct S* s, double z) { __builtin_dump_struct(s, p, z); }\n"
                  "void h(union U* s, struct S v) { __builtin_dump_struct(s, &q, 1 + 2, v); }\n"
                  "void k(T* s, int *ip) { __builtin_dump_struct(s, p, 5); }\n"
                  "void m(struct S* s, int (*fp)(int*, const char*, ...)) { __builtin_dump_struct(s, fp, 1.5); }\n"
                  "void n(struct S* s, int *ip) { __builtin_dump_struct(s, r, ip); }\n",
        .warnings = 0,
        .errors = 5,
        .notes = 9,
    },
    {
        .name = "verbose_trap through a const pointer whose initializer lost its designator (item 4)",
        .source = "static const char arr[] = \"hello\";\n"
                  "static const char* const q = (const char*)(const void*)arr;\n"
                  "static const char* const q2 = arr;\n"
                  "static const char* const q3 = (const char*)(const void*)\"lit\";\n"
                  "static const char* const q4 = (const char*)arr, *const q5 = (const char*)(void*)arr;\n"
                  "struct R { char m[8]; };\n"
                  "static const struct R r = { \"member\" };\n"
                  "static const char* const q6 = (const char*)(const void*)r.m;\n"
                  "void f1(void) { __builtin_verbose_trap(\"c\", q); }\n"
                  "void f2(void) { __builtin_verbose_trap(\"c\", q2); }\n"
                  "void f3(void) { __builtin_verbose_trap(\"c\", q3); }\n"
                  "void f4(void) { __builtin_verbose_trap(\"c\", q4); }\n"
                  "void f5(void) { __builtin_verbose_trap(\"c\", q5); }\n"
                  "void f6(void) { __builtin_verbose_trap(\"c\", q6); }\n"
                  "void f7(void) { __builtin_verbose_trap(\"c\", (const char*)(const void*)q2); }\n",
        .warnings = 0,
        .errors = 4,
        .notes = 0,
    },
    {
        // A builtin's argument that doesn't convert to its parameter (#2460, check_driver_builtin_conversion): the
        // conversion's own words at the argument, no parameter's note; CFString's then adds its literal's error.
        .name = "builtin arguments that don't convert",
        .source = "struct S { int a; } s;\n"
                  "void g(void) { (void)__builtin_strlen(1); }\n"
                  "void h(void) { (void)__builtin_strlen(L\"a\"); }\n"
                  "void k(void) { (void)__builtin___CFStringMakeConstantString(1); }\n"
                  "void m(char *p, int *ip) { (void)__builtin_strlen(s); (void)__builtin_memcpy(p, 1, 2); "
                  "(void)__builtin___CFStringMakeConstantString(ip); }\n",
        .warnings = 0,
        .errors = 8,
        .notes = 0,
    },
};
static const size_t fixture_7_lengths[] = {
sizeof("int g(unsigned char *p) { return __builtin_strlen(p) + __builtin_strcmp(p, \"x\") + __builtin_strncmp(\"y\", p, 1); }\n"
                  "void h(unsigned char *d, const char *s, const unsigned char *cu) { __builtin_strcpy(d, s); __builtin_strcpy((char *)cu, cu); __builtin_strcat(d, cu); }\n"
                  "void k(const char *c) { __builtin_strcpy(c, \"x\"); __builtin_memset(c, 0, 1); }\n"
                  "#define S(x) __builtin_strlen(x)\n"
                  "unsigned long m(signed char *sp) { return S(sp); }\n")-1,
sizeof("static const char s[] = \"x\";\n"
                  "const void* d = __builtin___CFStringMakeConstantString(s);\n"
                  "void f(int x, const char *p) { (void)__builtin___CFStringMakeConstantString(p); (void)__builtin___CFStringMakeConstantString((const char*)\"a\"); }\n"
                  "void g(void) { (void)__builtin___CFStringMakeConstantString((\"a\")); (void)__builtin___CFStringMakeConstantString(u8\"a\"); }\n")-1,
sizeof("struct S { int a; };\n"
                  "union U { int a; };\n"
                  "typedef struct { int a; } T;\n"
                  "int p(int* x, const char* f, ...);\n"
                  "int q(int y, int* x, const char* f, ...);\n"
                  "int r(long* x, const char* f, ...);\n"
                  "void g(struct S* s, double z) { __builtin_dump_struct(s, p, z); }\n"
                  "void h(union U* s, struct S v) { __builtin_dump_struct(s, &q, 1 + 2, v); }\n"
                  "void k(T* s, int *ip) { __builtin_dump_struct(s, p, 5); }\n"
                  "void m(struct S* s, int (*fp)(int*, const char*, ...)) { __builtin_dump_struct(s, fp, 1.5); }\n"
                  "void n(struct S* s, int *ip) { __builtin_dump_struct(s, r, ip); }\n")-1,
sizeof("static const char arr[] = \"hello\";\n"
                  "static const char* const q = (const char*)(const void*)arr;\n"
                  "static const char* const q2 = arr;\n"
                  "static const char* const q3 = (const char*)(const void*)\"lit\";\n"
                  "static const char* const q4 = (const char*)arr, *const q5 = (const char*)(void*)arr;\n"
                  "struct R { char m[8]; };\n"
                  "static const struct R r = { \"member\" };\n"
                  "static const char* const q6 = (const char*)(const void*)r.m;\n"
                  "void f1(void) { __builtin_verbose_trap(\"c\", q); }\n"
                  "void f2(void) { __builtin_verbose_trap(\"c\", q2); }\n"
                  "void f3(void) { __builtin_verbose_trap(\"c\", q3); }\n"
                  "void f4(void) { __builtin_verbose_trap(\"c\", q4); }\n"
                  "void f5(void) { __builtin_verbose_trap(\"c\", q5); }\n"
                  "void f6(void) { __builtin_verbose_trap(\"c\", q6); }\n"
                  "void f7(void) { __builtin_verbose_trap(\"c\", (const char*)(const void*)q2); }\n")-1,
sizeof("struct S { int a; } s;\n"
                  "void g(void) { (void)__builtin_strlen(1); }\n"
                  "void h(void) { (void)__builtin_strlen(L\"a\"); }\n"
                  "void k(void) { (void)__builtin___CFStringMakeConstantString(1); }\n"
                  "void m(char *p, int *ip) { (void)__builtin_strlen(s); (void)__builtin_memcpy(p, 1, 2); "
                  "(void)__builtin___CFStringMakeConstantString(ip); }\n")-1
};
static const CheckDriverDefaultWarningFixture fixture_8[] =
{
    {
        // Each list warns at its first `[` under -pedantic: on a tag, a member, a declaration, a parameter, a declarator, an
        // enumerator, a statement, an empty one, and a pointer's.
        .name = "C23 attribute lists before C23",
        .source = "struct [[deprecated]] S { int a [[maybe_unused]]; [[maybe_unused]] int b; };\n"
                  "[[nodiscard]] [[maybe_unused]] int f(int x [[maybe_unused]]);\n"
                  "[[]] int g(int x) { switch (x) { case 1: x++; [[fallthrough]]; case 2: break; } return x; }\n"
                  "typedef int T [[deprecated]];\n"
                  "enum [[deprecated]] E { A [[deprecated]] };\n"
                  "int h(void) { [[]]; [[gnu::unused]] int y = 0; return y; }\n"
                  "void k(int *[[gnu::unused]] p);\n",
        .options = { "-pedantic" },
        .warnings = 15,
        .compare_warning_text = true,
    },
    {
        // -Wc23-extensions alone gives them, and they're ignored by default.
        .name = "C23 attribute lists under -Wc23-extensions",
        .source = "void f(int x) { [[maybe_unused]] int y = x; }\n"
                  "[[deprecated]] int g(void);\n",
        .options = { "-Wc23-extensions" },
        .warnings = 2,
        .compare_warning_text = true,
    },
    {
        .name = "C23 attribute lists by default",
        .source = "void f(int x) { [[maybe_unused]] int y = x; }\n"
                  "[[deprecated]] int g(void);\n",
        .compare_warning_text = true,
    },
};
static const size_t fixture_8_lengths[] = {
sizeof("struct [[deprecated]] S { int a [[maybe_unused]]; [[maybe_unused]] int b; };\n"
                  "[[nodiscard]] [[maybe_unused]] int f(int x [[maybe_unused]]);\n"
                  "[[]] int g(int x) { switch (x) { case 1: x++; [[fallthrough]]; case 2: break; } return x; }\n"
                  "typedef int T [[deprecated]];\n"
                  "enum [[deprecated]] E { A [[deprecated]] };\n"
                  "int h(void) { [[]]; [[gnu::unused]] int y = 0; return y; }\n"
                  "void k(int *[[gnu::unused]] p);\n")-1,
sizeof("void f(int x) { [[maybe_unused]] int y = x; }\n"
                  "[[deprecated]] int g(void);\n")-1,
sizeof("void f(int x) { [[maybe_unused]] int y = x; }\n"
                  "[[deprecated]] int g(void);\n")-1
};
static const CheckDriverDefaultWarningFixture fixture_9[] =
{
    {
        // An ordinary call's count error (#1921): clang's "too few/too many arguments to function call" with the counts, too
        // many at the first extra argument, and the "declared here" note where the callee is a function's name, through
        // parentheses and `&`, a typedef's function too; none for a pointer's or a member's.
        .name = "ordinary calls' argument counts",
        .source = "int h(void);\n"
                  "int k(int, int);\n"
                  "int v(int, ...);\n"
                  "typedef int F(int x);\n"
                  "F m;\n"
                  "int g(void)\n"
                  "{\n"
                  "    int (*fp)(int) = 0;\n"
                  "    struct { int (*f)(int y); } s = { 0 };\n"
                  "    h(1);\n"
                  "    k(1);\n"
                  "    k(1, h(), 4, 5);\n"
                  "    v();\n"
                  "    m();\n"
                  "    m(1, 2);\n"
                  "    fp();\n"
                  "    fp(1, 2);\n"
                  "    s.f();\n"
                  "    (h)(1);\n"
                  "    (&k)(1);\n"
                  "    return 0;\n"
                  "}\n",
        .warnings = 0,
        .errors = 11,
        .notes = 8,
    },
    {
        // A callee whose declaration names its only parameter: clang's "single argument 'a'" words, the latest declaration's
        // name, and a variadic one's "at least argument"; an unnamed one keeps the counts.
        .name = "single named parameter",
        .source = "int h(int a);\n"
                  "int h(int b);\n"
                  "int k(int a, ...);\n"
                  "int u(int);\n"
                  "int g(void)\n"
                  "{\n"
                  "    h(1, 2);\n"
                  "    h();\n"
                  "    k();\n"
                  "    u();\n"
                  "    u(1, 2, 3);\n"
                  "    (h)();\n"
                  "    (&h)();\n"
                  "    return 0;\n"
                  "}\n",
        .warnings = 0,
        .errors = 7,
        .notes = 7,
    },
    {
        // Builtins' count errors (#1860): each family's count, exact or a bound as clang's checkArgCountRange and
        // checkArgCountAtLeast word it, too many at the first extra argument but "at most" at the `)`, a scoped atomic's
        // count with its scope, and va_start's operands.
        .name = "builtin argument counts",
        .source = "typedef float v4 __attribute__((vector_size(16)));\n"
                  "void f(int x, ...)\n"
                  "{\n"
                  "    int i = 0;\n"
                  "    double d = 1;\n"
                  "    int *p = &i;\n"
                  "    v4 v = { 0 };\n"
                  "    __builtin_va_list ap;\n"
                  "    __builtin_constant_p();\n"
                  "    __builtin_constant_p(1, 2);\n"
                  "    __builtin_object_size(p);\n"
                  "    __builtin_object_size(p, 0, 1);\n"
                  "    __sync_fetch_and_add(p);\n"
                  "    __atomic_fetch_add(p, 1);\n"
                  "    __atomic_fetch_add(p, 1, 0, 0);\n"
                  "    __builtin_isnan(d, d);\n"
                  "    __builtin_copysign(d, d, d);\n"
                  "    __builtin_flt_rounds(1);\n"
                  "    __builtin_shufflevector(v);\n"
                  "    __c11_atomic_load(p);\n"
                  "    __c11_atomic_load(p, 0, 0);\n"
                  "    __atomic_load(p, p);\n"
                  "    __atomic_load(p, p, 0, 0);\n"
                  "    __hip_atomic_load();\n"
                  "    __hip_atomic_load(p, 0);\n"
                  "    __atomic_is_lock_free(4);\n"
                  "    __atomic_is_lock_free(4, p, 1);\n"
                  "    __atomic_load_n(p);\n"
                  "    __atomic_load_n(p, 0, 1);\n"
                  "    __atomic_thread_fence();\n"
                  "    __builtin_fpclassify(1, 2, 3, 4, 5);\n"
                  "    __builtin_fpclassify(1, 2, 3, 4, 5, d, 7);\n"
                  "    __builtin_inf(1);\n"
                  "    __builtin_va_start();\n"
                  "    __builtin_va_start(ap, x, __builtin_popcount(2));\n"
                  "    __builtin_va_end();\n"
                  "    __builtin_va_copy(ap);\n"
                  "    __builtin_expect(1);\n"
                  "    __builtin_expect(1, 2, 3);\n"
                  "    __builtin_assume_aligned(p);\n"
                  "    __builtin_assume_aligned(p, 1, 2, 3);\n"
                  "    __builtin_prefetch();\n"
                  "    __builtin_prefetch(p, 1, 2, 3);\n"
                  "    __builtin_unreachable(1);\n"
                  "    __builtin_clzg();\n"
                  "    __builtin_clzg(1u, 2, 3);\n"
                  "    __builtin_classify_type();\n"
                  "    __builtin_isgreater(d);\n"
                  "    __builtin_isfpclass(d);\n"
                  "    __builtin_nan();\n"
                  "    __builtin_elementwise_abs();\n"
                  "    __builtin_reduce_add();\n"
                  "    __builtin_dump_struct(p);\n"
                  "    __builtin_complex(d, d, d);\n"
                  "}\n",
        .options = { "-ferror-limit=0" },
        .warnings = 0,
        .errors = 46,
        .notes = 0,
    },
    {
        // The unary, overflow and complex part builtins, whose wrong count the reader reports (#1860).
        .name = "unary and overflow builtin counts",
        .source = "void f(int *p, double d)\n"
                  "{\n"
                  "    __builtin_popcount();\n"
                  "    __builtin_popcount(1, 2);\n"
                  "    __builtin_ctz();\n"
                  "    __builtin_bswap32(1, __builtin_popcount(2));\n"
                  "    __builtin_add_overflow(1, 2);\n"
                  "    __builtin_add_overflow(1, 2, p, 4);\n"
                  "    __builtin_sadd_overflow(1, 2);\n"
                  "    __builtin_creal();\n"
                  "    __builtin_creal(d, d);\n"
                  "    __builtin_cimagf(1, 2, 3);\n"
                  "}\n",
        .warnings = 0,
        .errors = 10,
        .notes = 0,
    },
    {
        // Passing arguments without a prototype (#1994): at the call's `(`, naming a direct callee, "a function" for a
        // pointer; a K&R definition's too few and too many at the call's `)`.
        .name = "calls without a prototype",
        .source = "void knr();\n"
                  "void (*fp)();\n"
                  "struct S { void (*g)(); } s;\n"
                  "void kd(a, b) int a, b; {}\n"
                  "void f(void)\n"
                  "{\n"
                  "    knr(1);\n"
                  "    fp(1);\n"
                  "    (knr)(1);\n"
                  "    (&knr)(1);\n"
                  "    s.g(1);\n"
                  "    (*fp)(2);\n"
                  "    kd(1);\n"
                  "    kd(1, 2, 3);\n"
                  "    (kd)(1);\n"
                  "    knr();\n"
                  "}\n",
        .warnings = 10,
        .errors = 0,
        .notes = 0,
    },
    {
        // In C23 `()` is a prototype (#1994): the count error and its note.
        .name = "C23 empty parameter lists",
        .source = "void knr();\n"
                  "void f(void) { knr(1); knr(1, 2); (knr)(3); }\n",
        .warnings = 0,
        .errors = 3,
        .notes = 3,
        .c23 = true,
    },
    {
        // A call the constant reader checks (a typeof's, an array bound's, an unevaluated sizeof's operand): the same words,
        // its named only parameter's too (check_constant_failure_error).
        .name = "a constant reader's variadic call",
        .source = "int k(int b, ...);\n"
                  "void f(void)\n"
                  "{\n"
                  "    typeof(k()) u;\n"
                  "    (void)u;\n"
                  "}\n",
        .warnings = 0,
        .errors = 1,
        .notes = 1,
    },
    {
        .name = "an array bound's call",
        .source = "int h(int a);\n"
                  "int arr[sizeof(h())];\n",
        .warnings = 0,
        .errors = 1,
        .notes = 1,
    },
    {
        .name = "an unevaluated operand's call",
        .source = "int h(int a);\n"
                  "void f(void)\n"
                  "{\n"
                  "    (void)sizeof(h(1, 2));\n"
                  "}\n",
        .warnings = 0,
        .errors = 1,
        .notes = 1,
    },
    {
        // A call's later arguments that don't convert either (#2413, check_graph_report_arguments): each its own error at its
        // argument, with its parameter's note, after an error-by-default conversion (incompatible pointers, an integer and a
        // pointer); a hard error (incompatible types, another address space) is the call's last.
        .name = "two failed argument conversions",
        .source = "void g(int *p, int (*fp)(int));\n"
                  "void f(long *l) { g(l, l); }\n",
        .errors = 2,
        .notes = 2,
    },
    {
        .name = "failed argument conversions until a hard error",
        .source = "struct S { int a; };\n"
                  "void g(int *p, int (*fp)(int), int x, struct S s, char *c);\n"
                  "void f(long *l, struct S s, unsigned char *u) { g(l, l, 1, s, (char*)u); g(0, 0, s, 1, 0); g(l, 0, 0, s, (char*)0); }\n"
                  "void h(void (*fp)(int *, int *), long *l) { fp(l, l); (*fp)(l, 0); }\n"
                  "void k(int __seg_gs *a, int *b);\n"
                  "void m(int *p, int __seg_fs *q) { k(p, q); k(q, q); }\n",
        .errors = 9,
        .notes = 6,
    },
    {
        // A call's conversion warnings and errors in argument order (#2481): an earlier argument's error before a later
        // one's -Wpointer-sign, both after the warnings of an inner call its arguments build.
        .name = "argument conversions in order",
        .source = "struct S { int a; };\n"
                  "void g(int *p, int (*fp)(int), int x, struct S s, char *c);\n"
                  "void f(long *l, struct S s, unsigned char *u) { g(l, 0, 1, s, u); }\n"
                  "void h(int a, char *c);\n"
                  "void f2(unsigned char *u) { h(u, u); }\n"
                  "void k(int *p, char *c, struct S s);\n"
                  "int m(char *c);\n"
                  "void f3(long *l, unsigned char *u, struct S s) { k(l, u, 1); k(l, (char *)l, s); m(l); int x = m(u) + m(l); (void)x; }\n",
        .warnings = 4,
        .errors = 7,
        .notes = 11,
    },
};
static const size_t fixture_9_lengths[] = {
sizeof("int h(void);\n"
                  "int k(int, int);\n"
                  "int v(int, ...);\n"
                  "typedef int F(int x);\n"
                  "F m;\n"
                  "int g(void)\n"
                  "{\n"
                  "    int (*fp)(int) = 0;\n"
                  "    struct { int (*f)(int y); } s = { 0 };\n"
                  "    h(1);\n"
                  "    k(1);\n"
                  "    k(1, h(), 4, 5);\n"
                  "    v();\n"
                  "    m();\n"
                  "    m(1, 2);\n"
                  "    fp();\n"
                  "    fp(1, 2);\n"
                  "    s.f();\n"
                  "    (h)(1);\n"
                  "    (&k)(1);\n"
                  "    return 0;\n"
                  "}\n")-1,
sizeof("int h(int a);\n"
                  "int h(int b);\n"
                  "int k(int a, ...);\n"
                  "int u(int);\n"
                  "int g(void)\n"
                  "{\n"
                  "    h(1, 2);\n"
                  "    h();\n"
                  "    k();\n"
                  "    u();\n"
                  "    u(1, 2, 3);\n"
                  "    (h)();\n"
                  "    (&h)();\n"
                  "    return 0;\n"
                  "}\n")-1,
sizeof("typedef float v4 __attribute__((vector_size(16)));\n"
                  "void f(int x, ...)\n"
                  "{\n"
                  "    int i = 0;\n"
                  "    double d = 1;\n"
                  "    int *p = &i;\n"
                  "    v4 v = { 0 };\n"
                  "    __builtin_va_list ap;\n"
                  "    __builtin_constant_p();\n"
                  "    __builtin_constant_p(1, 2);\n"
                  "    __builtin_object_size(p);\n"
                  "    __builtin_object_size(p, 0, 1);\n"
                  "    __sync_fetch_and_add(p);\n"
                  "    __atomic_fetch_add(p, 1);\n"
                  "    __atomic_fetch_add(p, 1, 0, 0);\n"
                  "    __builtin_isnan(d, d);\n"
                  "    __builtin_copysign(d, d, d);\n"
                  "    __builtin_flt_rounds(1);\n"
                  "    __builtin_shufflevector(v);\n"
                  "    __c11_atomic_load(p);\n"
                  "    __c11_atomic_load(p, 0, 0);\n"
                  "    __atomic_load(p, p);\n"
                  "    __atomic_load(p, p, 0, 0);\n"
                  "    __hip_atomic_load();\n"
                  "    __hip_atomic_load(p, 0);\n"
                  "    __atomic_is_lock_free(4);\n"
                  "    __atomic_is_lock_free(4, p, 1);\n"
                  "    __atomic_load_n(p);\n"
                  "    __atomic_load_n(p, 0, 1);\n"
                  "    __atomic_thread_fence();\n"
                  "    __builtin_fpclassify(1, 2, 3, 4, 5);\n"
                  "    __builtin_fpclassify(1, 2, 3, 4, 5, d, 7);\n"
                  "    __builtin_inf(1);\n"
                  "    __builtin_va_start();\n"
                  "    __builtin_va_start(ap, x, __builtin_popcount(2));\n"
                  "    __builtin_va_end();\n"
                  "    __builtin_va_copy(ap);\n"
                  "    __builtin_expect(1);\n"
                  "    __builtin_expect(1, 2, 3);\n"
                  "    __builtin_assume_aligned(p);\n"
                  "    __builtin_assume_aligned(p, 1, 2, 3);\n"
                  "    __builtin_prefetch();\n"
                  "    __builtin_prefetch(p, 1, 2, 3);\n"
                  "    __builtin_unreachable(1);\n"
                  "    __builtin_clzg();\n"
                  "    __builtin_clzg(1u, 2, 3);\n"
                  "    __builtin_classify_type();\n"
                  "    __builtin_isgreater(d);\n"
                  "    __builtin_isfpclass(d);\n"
                  "    __builtin_nan();\n"
                  "    __builtin_elementwise_abs();\n"
                  "    __builtin_reduce_add();\n"
                  "    __builtin_dump_struct(p);\n"
                  "    __builtin_complex(d, d, d);\n"
                  "}\n")-1,
sizeof("void f(int *p, double d)\n"
                  "{\n"
                  "    __builtin_popcount();\n"
                  "    __builtin_popcount(1, 2);\n"
                  "    __builtin_ctz();\n"
                  "    __builtin_bswap32(1, __builtin_popcount(2));\n"
                  "    __builtin_add_overflow(1, 2);\n"
                  "    __builtin_add_overflow(1, 2, p, 4);\n"
                  "    __builtin_sadd_overflow(1, 2);\n"
                  "    __builtin_creal();\n"
                  "    __builtin_creal(d, d);\n"
                  "    __builtin_cimagf(1, 2, 3);\n"
                  "}\n")-1,
sizeof("void knr();\n"
                  "void (*fp)();\n"
                  "struct S { void (*g)(); } s;\n"
                  "void kd(a, b) int a, b; {}\n"
                  "void f(void)\n"
                  "{\n"
                  "    knr(1);\n"
                  "    fp(1);\n"
                  "    (knr)(1);\n"
                  "    (&knr)(1);\n"
                  "    s.g(1);\n"
                  "    (*fp)(2);\n"
                  "    kd(1);\n"
                  "    kd(1, 2, 3);\n"
                  "    (kd)(1);\n"
                  "    knr();\n"
                  "}\n")-1,
sizeof("void knr();\n"
                  "void f(void) { knr(1); knr(1, 2); (knr)(3); }\n")-1,
sizeof("int k(int b, ...);\n"
                  "void f(void)\n"
                  "{\n"
                  "    typeof(k()) u;\n"
                  "    (void)u;\n"
                  "}\n")-1,
sizeof("int h(int a);\n"
                  "int arr[sizeof(h())];\n")-1,
sizeof("int h(int a);\n"
                  "void f(void)\n"
                  "{\n"
                  "    (void)sizeof(h(1, 2));\n"
                  "}\n")-1,
sizeof("void g(int *p, int (*fp)(int));\n"
                  "void f(long *l) { g(l, l); }\n")-1,
sizeof("struct S { int a; };\n"
                  "void g(int *p, int (*fp)(int), int x, struct S s, char *c);\n"
                  "void f(long *l, struct S s, unsigned char *u) { g(l, l, 1, s, (char*)u); g(0, 0, s, 1, 0); g(l, 0, 0, s, (char*)0); }\n"
                  "void h(void (*fp)(int *, int *), long *l) { fp(l, l); (*fp)(l, 0); }\n"
                  "void k(int __seg_gs *a, int *b);\n"
                  "void m(int *p, int __seg_fs *q) { k(p, q); k(q, q); }\n")-1,
sizeof("struct S { int a; };\n"
                  "void g(int *p, int (*fp)(int), int x, struct S s, char *c);\n"
                  "void f(long *l, struct S s, unsigned char *u) { g(l, 0, 1, s, u); }\n"
                  "void h(int a, char *c);\n"
                  "void f2(unsigned char *u) { h(u, u); }\n"
                  "void k(int *p, char *c, struct S s);\n"
                  "int m(char *c);\n"
                  "void f3(long *l, unsigned char *u, struct S s) { k(l, u, 1); k(l, (char *)l, s); m(l); int x = m(u) + m(l); (void)x; }\n")-1
};
static const CheckDriverDefaultWarningFixture fixture_10[] =
{
    {
        // A relational comparison whose left operand is one, unparenthesized, at the outer operator, an error that -w
        // leaves; not an equality's, a parenthesized one or a relational right operand.
        .name = "chained comparisons",
        .source = "int x = 1 < 2 < 3;\n"
                  "int a(int p, int q, int r) { return p < q < r; }\n"
                  "int b(int p, int q, int r) { return p <= q > r; }\n"
                  "int c(int p, int q, int r) { return p == q == r || p < q == r || (p < q) < r || p == q < r || p != q != r; }\n"
                  "int g(int p, int q, int r, int s) { return p < q < r < s; }\n",
        .errors = 5,
    },
    {
        .name = "chained comparisons demoted",
        .source = "int a(int p, int q, int r) { return p >= q >= r; }\n",
        .options = { "-Wno-error=parentheses" },
        .warnings = 1,
    },
};
static const size_t fixture_10_lengths[] = {
sizeof("int x = 1 < 2 < 3;\n"
                  "int a(int p, int q, int r) { return p < q < r; }\n"
                  "int b(int p, int q, int r) { return p <= q > r; }\n"
                  "int c(int p, int q, int r) { return p == q == r || p < q == r || (p < q) < r || p == q < r || p != q != r; }\n"
                  "int g(int p, int q, int r, int s) { return p < q < r < s; }\n")-1,
sizeof("int a(int p, int q, int r) { return p >= q >= r; }\n")-1
};
static const CheckDriverDefaultWarningFixture fixture_11[] =
{
    {
        .name = "the address of an enable_if function in parentheses",
        .source = "void q(int x) __attribute__((enable_if(x > 0, \"p1\")));\n"
                  "void f(void) { void (*p)(int) = (q); (void)p; }\n",
        .errors = 1,
    },
    {
        .name = "unevaluated uses and calls through parentheses",
        .source = "void q(int x) __attribute__((enable_if(x > 0, \"p1\")));\n"
                  "void f(void) { (void)sizeof(q); (void)_Alignof(q); __typeof__(q) *z = 0; (void)z; (q)(5); (&q)(5); }\n",
        .warnings = 1,
        .errors = 1,
    },
    {
        .name = "a call no enable_if admits",
        .source = "void f(int x) __attribute__((enable_if(x > 0, \"positive\")));\n"
                  "int h(void) { f(1); f(0); return 0; }\n",
        .errors = 1,
        .notes = 1,
    },
    {
        .name = "a disabled call gives no diagnose_if",
        .source = "void u(int x) __attribute__((enable_if(x, \"nz\"), diagnose_if(x == 3, \"three\", \"warning\")));\n"
                  "void f(void) { u(3); u(0); }\n",
        .warnings = 1,
        .errors = 1,
        .notes = 2,
    },
    {
        .name = "enable_if that is always false",
        .source = "void z(int x) __attribute__((enable_if(0, \"never\")));\n"
                  "int h(void) { z(1); return 0; }\n",
        .errors = 1,
        .notes = 1,
    },
    {
        .name = "enable_if with a message that is no string",
        .source = "void f(int x) __attribute__((enable_if(x, 1)));\n",
        .errors = 1,
    },
    {
        .name = "enable_if that never produces a constant",
        .source = "int g; void f(int x) __attribute__((enable_if(g, \"a\")));\n",
        .errors = 1,
        .notes = 1,
    },
    // A volatile parameter's read is never a constant (#2383); each declaration's error drops its attribute, and the unit
    // goes on to the next one's and to its calls.
    {
        .name = "enable_if and diagnose_if reading a volatile parameter",
        .source = "int b7(volatile int a) __attribute__((enable_if(a > 0, \"\")));\n"
                  "int b8(volatile int a) __attribute__((diagnose_if(a > 0, \"x\", \"warning\")));\n"
                  "int g; int c(int x) __attribute__((enable_if(g, \"\")));\n"
                  "int d(int x) __attribute__((enable_if(x, \"\")));\n"
                  "void h(void) { b7(1); c(1); d(0); }\n",
        .errors = 4,
        .notes = 4,
    },
    {
        .name = "a volatile parameter's read that some arguments skip",
        .source = "int c1(int x, volatile int a) __attribute__((enable_if(x && a, \"\")));\n"
                  "int c2(int x, volatile int a) __attribute__((enable_if(x || a, \"\")));\n"
                  "int c3(int x, volatile int a) __attribute__((enable_if(x ? a : 1, \"\")));\n"
                  "int c4(volatile int a) __attribute__((enable_if(sizeof(a) == 4, \"\")));\n"
                  "int c5(volatile int *a) __attribute__((enable_if(a != 0, \"\")));\n"
                  "void g(int* p) { c1(1, 2); c1(0, 2); c2(0, 3); c2(1, 3); c3(0, 1); c4(1); c5(p); }\n",
        .errors = 4,
        .notes = 4,
    },
    // Casts clang's constant evaluation refuses (#2253): to void, its note "non-literal type 'void'", and between an integer
    // and a pointer but a null pointer constant's, "this conversion is not allowed"; where no arguments skip them, in a
    // parameter's condition or not. A void condition isn't one; a call reads past a void left operand.
    {
        .name = "casts to void and between integers and pointers in a condition",
        .source = "void c(int x) __attribute__((diagnose_if(((void)x, x), \"m\", \"warning\")));\n"
                  "void l(long x) __attribute__((diagnose_if(((void*)x, x), \"m\", \"warning\")));\n"
                  "void a1(int x) __attribute__((diagnose_if(((void)0, x), \"m\", \"warning\")));\n"
                  "void a2(int x) __attribute__((diagnose_if((void)x, \"m\", \"warning\")));\n"
                  "void a3(int x) __attribute__((diagnose_if(x && ((void)x, 1), \"m\", \"warning\")));\n"
                  "void a4(int x) __attribute__((diagnose_if(((void*)0, x), \"m\", \"warning\")));\n"
                  "void a8(int x) __attribute__((enable_if(((void)x, x), \"m\")));\n"
                  "void a9(int *x) __attribute__((diagnose_if(((void*)x, 1), \"m\", \"warning\")));\n"
                  "void b1(int x) __attribute__((diagnose_if(((void)0, 1), \"m\", \"warning\")));\n"
                  "void b5(int x) __attribute__((diagnose_if(((void)x, 1) && x, \"m\", \"warning\")));\n"
                  "void b6(int x) __attribute__((diagnose_if(sizeof((void)x, 1) == 4 && x, \"m\", \"warning\")));\n"
                  "void b7(int x) __attribute__((diagnose_if((long)(char*)0 == 0 && x, \"m\", \"warning\")));\n"
                  "void b8(int x) __attribute__((diagnose_if(x ? 1 : ((void)x, 0), \"m\", \"warning\")));\n"
                  "void h(void) { a3(1); a9(0); b6(1); b8(1); b8(0); }\n",
        .warnings = 7,
        .errors = 8,
        .notes = 11,
    },
    {
        .name = "enable_if with an argument that is no constant",
        .source = "void f(int x) __attribute__((enable_if(x > 0, \"positive\")));\n"
                  "int h(int n) { f(n); return 0; }\n",
        .errors = 1,
        .notes = 1,
    },
    {
        .name = "the candidate note at the latest declaration",
        .source = "void r(int x) __attribute__((enable_if(x > 0, \"a\")));\n"
                  "void r(int x);\n"
                  "int h(void) { r(0); return 0; }\n",
        .errors = 1,
        .notes = 1,
    },
    // An inherited enable_if names the parameters of the declaration that wrote it, and clang binds a call's arguments to
    // the found declaration's, so each parameter it reads is unknown (#2464): a call through a later declaration is
    // disabled, one through the writer isn't, and an overloadable redeclaration's enable_ifs are its own.
    {
        .name = "an inherited enable_if that reads a parameter",
        .source = "int r(int n) __attribute__((enable_if(n < 100, \"small\")));\n"
                  "void t0(void) { r(8); }\n"
                  "int r(int n);\n"
                  "void t1(void) { r(8); }\n"
                  "int r(int m);\n"
                  "int r(int);\n"
                  "void t2(void) { r(9); }\n"
                  "int k(int n) __attribute__((overloadable, enable_if(n < 100, \"small\")));\n"
                  "int k(int n) __attribute__((overloadable, enable_if(n < 100, \"small\")));\n"
                  "void t3(void) { k(8); }\n"
                  "void w(int x) __attribute__((enable_if(0, \"p1\")));\n"
                  "void w(int x) __attribute__((enable_if(x < 10, \"p2\")));\n"
                  "void t4(void) { w(5); }\n"
                  "void w(int x);\n"
                  "void t5(void) { w(5); }\n",
        .errors = 3,
        .notes = 3,
    },
    // Its parameters are unknown values, not an error: an operator that doesn't read one still decides, a non-null
    // address is unknown too, and a diagnose_if still reads the arguments (#2464).
    {
        .name = "an inherited enable_if's unknown parameters",
        .source = "int a(int n) __attribute__((enable_if(1 || n, \"or\")));\n"
                  "int a(int n);\n"
                  "int c(int n) __attribute__((enable_if(n || 1, \"lor\")));\n"
                  "int c(int n);\n"
                  "int d(int n) __attribute__((enable_if(sizeof(n) == 4, \"size\")));\n"
                  "int d(int n);\n"
                  "int e(int n) __attribute__((enable_if((n, 1), \"comma\")));\n"
                  "int e(int n);\n"
                  "int f(int n) __attribute__((enable_if(n * 0 == 0, \"mul\")));\n"
                  "int f(int n);\n"
                  "int p(int *q) __attribute__((enable_if(q != 0, \"nonnull\")));\n"
                  "int p(int *q);\n"
                  "int g(int n) __attribute__((enable_if(1 || n, \"ok\"), diagnose_if(n == 8, \"eight\", \"warning\")));\n"
                  "int g(int n);\n"
                  "int v;\n"
                  "void t(void) { a(1); c(1); d(1); e(1); f(1); p(&v); g(8); g(7); }\n",
        .warnings = 2,
        .errors = 4,
        .notes = 5,
    },
    {
        .name = "an inherited enable_if at block scope and after a definition",
        .source = "int r(int n) __attribute__((enable_if(n < 100, \"small\")));\n"
                  "void t1(void) { int r(int n); r(8); }\n"
                  "void t2(void) { r(8); }\n"
                  "void t3(void) { extern int r(int k); r(8); }\n"
                  "int r(int n) { return n; }\n"
                  "void t4(void) { r(8); }\n",
        .errors = 3,
        .notes = 3,
    },
    // A redeclaration takes an enable_if only where it has none of its own, and then only the previous declaration's
    // first, as clang's attribute merge skips a kind the declaration has (#2464): `q`'s address can be taken.
    {
        .name = "a redeclaration's inherited enable_if is the first alone",
        .source = "void q(int x) __attribute__((enable_if(1, \"a\"), enable_if(0, \"b\")));\n"
                  "void q(int x);\n"
                  "void h(void) { q(1); void (*p)(int) = q; (void)p; }\n"
                  "void w(int x) __attribute__((enable_if(0, \"p1\")));\n"
                  "void w(int x) __attribute__((enable_if(x < 10, \"p2\")));\n"
                  "void hw(void) { w(5); }\n",
    },
    // A redeclaration whose own conditions are diagnose_ifs alone has no enable_if of its own, so it still inherits the
    // previous declaration's first (#2464): `r(8)` is disabled. `n == 9` doesn't hold, so no disabled call's diagnose_if
    // is at stake.
    {
        .name = "a redeclaration with a diagnose_if alone inherits the first enable_if",
        .source = "int r(int n) __attribute__((enable_if(n < 100, \"small\")));\n"
                  "int r(int n) __attribute__((diagnose_if(n == 9, \"nine\", \"warning\")));\n"
                  "void t(void) { r(8); }\n"
                  "int s(int n) __attribute__((enable_if(1, \"one\"), enable_if(0, \"zero\")));\n"
                  "int s(int n) __attribute__((diagnose_if(n == 9, \"nine\", \"warning\")));\n"
                  "void u(void) { int (*p)(int) = s; (void)p; s(8); }\n",
        .errors = 1,
        .notes = 1,
    },
    {
        .name = "an inherited enable_if of a pass_object_size function",
        .source = "int r(void *p __attribute__((pass_object_size(0)))) __attribute__((enable_if(p != 0, \"nn\")));\n"
                  "int r(void *p __attribute__((pass_object_size(0))));\n"
                  "int s(void *p __attribute__((pass_object_size(0)))) __attribute__((enable_if(1, \"one\")));\n"
                  "int s(void *p __attribute__((pass_object_size(0))));\n"
                  "void t(void) { char b[4]; r(b); s(b); }\n",
        .errors = 1,
        .notes = 1,
    },
    {
        .name = "enable_if with one argument",
        .source = "void f(int x) __attribute__((enable_if(x)));\n",
        .errors = 1,
    },
    {
        .name = "a redeclaration's own enable_if, not the one before",
        .source = "void q2(int x) __attribute__((enable_if(x > 5, \"p1\")));\n"
                  "void q2(int x) __attribute__((enable_if(x > 1, \"p2\")));\n"
                  "int h(void) { q2(3); q2(1); return 0; }\n",
        .errors = 1,
        .notes = 1,
    },
    {
        .name = "enable_if of a declaration's first",
        .source = "void q(int x) __attribute__((enable_if(x > 0, \"p1\"), enable_if(x > 1, \"p2\")));\n"
                  "int h(void) { q(0); return 0; }\n",
        .errors = 1,
        .notes = 1,
    },
    {
        .name = "enable_if with three arguments",
        .source = "void f(int x) __attribute__((enable_if(x, \"a\", \"b\")));\n",
        .errors = 1,
    },
    {
        .name = "the first error alone at a call",
        .source = "void n(int x) __attribute__((diagnose_if(x > 0, \"w\", \"warning\"), diagnose_if(x > 0, \"e1\", \"error\"), diagnose_if(x > 0, \"e2\", \"error\")));\n"
                  "void h(void) { n(0); n(1); }\n",
        .errors = 1,
        .notes = 1,
    },
    {
        .name = "an error at a use",
        .source = "void b(void) __attribute__((diagnose_if(1, \"e\", \"error\")));\n"
                  "void c(void) { b(); }\n",
        .errors = 1,
        .notes = 1,
    },
    {
        .name = "too many arguments",
        .source = "void f2(int x) __attribute__((diagnose_if(x, \"m\", \"warning\", \"foo\", \"bar\")));\n",
        .errors = 1,
    },
    {
        .name = "a warning group that is no string",
        .source = "void f5(int x) __attribute__((diagnose_if(x, \"m\", \"warning\", 1)));\n",
        .errors = 1,
    },
    {
        .name = "an unknown warning group",
        .source = "void f1(int x) __attribute__((diagnose_if(x, \"m\", \"warning\", \"foo\")));\n",
        .errors = 1,
    },
    {
        .name = "an empty warning group",
        .source = "void f6(int x) __attribute__((diagnose_if(x, \"m\", \"warning\", \"\")));\n",
        .errors = 1,
    },
    {
        .name = "a diagnostic type that is no string",
        .source = "void f6(int x) __attribute__((diagnose_if(x, \"m\", warning)));\n",
        .errors = 1,
    },
    {
        .name = "an invalid diagnostic type",
        .source = "void f2(int x) __attribute__((diagnose_if(x, \"m\", \"info\")));\n",
        .errors = 1,
    },
    {
        .name = "a message that is no string",
        .source = "void f3(int x) __attribute__((diagnose_if(x, 5, \"warning\")));\n",
        .errors = 1,
    },
    {
        .name = "a condition that never produces a constant",
        .source = "int g; void f1(int x) __attribute__((diagnose_if(g, \"glob\", \"warning\")));\n",
        .errors = 1,
        .notes = 1,
    },
    {
        .name = "a dependent condition that reads a variable",
        .source = "int g; void f1(int x) __attribute__((diagnose_if(x > g, \"glob\", \"warning\")));\n",
        .errors = 1,
        .notes = 1,
    },
    {
        .name = "one argument",
        .source = "void f3(int x) __attribute__((diagnose_if(x)));\n",
        .errors = 1,
    },
    {
        .name = "too few arguments",
        .source = "void f4(int x) __attribute__((diagnose_if(x, \"m\")));\n",
        .errors = 1,
    },
    {
        .name = "an undeclared name",
        .source = "void f7(int x) __attribute__((diagnose_if(y, \"m\", \"warning\")));\n",
        .errors = 1,
    },
    {
        .name = "no argument",
        .source = "void f4(int x) __attribute__((diagnose_if()));\n",
        .errors = 1,
    },
    {
        .name = "a tautological enable_if",
        .source = "void k(int x) __attribute__((enable_if(1, \"always\")));\n"
                  "void f(void) { void (*p)(int) = k; k(2); (void)p; }\n",
    },
    {
        .name = "a system header's enable_if(1, "")",
        .source = "# 1 \"sys.h\" 1 3\n"
                  "int w(int n) __attribute__((enable_if(1, \"\")));\n"
                  "# 3 \"user.c\" 2\n"
                  "int main(void){ int (*p)(int) = w; return w(1) + p(2); }\n",
    },
    {
        .name = "a system header function",
        .source = "# 1 \"sys.h\" 1 3\n"
                  "static inline int header_wrapper(int n) __attribute__((diagnose_if((n>8),(\"too large\"),\"warning\"))){return n;}\n"
                  "int opaque(char *p, int n) __attribute__((diagnose_if(__builtin_object_size(p, 1) < n, \"small\", \"warning\")));\n"
                  "# 4 \"user.c\" 2\n"
                  "int main(void){ char b[4]; return header_wrapper(3) + header_wrapper(9) + opaque(b, 2); }\n",
        .warnings = 1,
        .notes = 1,
    },
    {
        .name = "an array parameter",
        .source = "void f(int a[4], int n) __attribute__((diagnose_if(n > 4, \"over\", \"warning\")));\n"
                  "void g(int *p) { f(p, 5); }\n",
        .warnings = 1,
        .notes = 1,
    },
    {
        .name = "a _Bool parameter",
        .source = "void f(_Bool b) __attribute__((diagnose_if(b, \"true\", \"warning\")));\n"
                  "void g(void){ f(5); f(0); }\n",
        .warnings = 1,
        .notes = 1,
    },
    {
        .name = "the C23 spelling",
        .source = "[[clang::diagnose_if(1, \"c23\", \"warning\")]] void a(void);\n"
                  "void f(void) { a(); }\n",
        .warnings = 1,
    },
    {
        .name = "a character parameter",
        .source = "void f(char c) __attribute__((diagnose_if(c == 'x', \"x\", \"warning\")));\n"
                  "void g(void){ f('x'); f(120); f(1); }\n",
        .warnings = 2,
        .notes = 2,
    },
    {
        .name = "a message of joined strings",
        .source = "void f8(int x) __attribute__((diagnose_if(x, \"m\" \"n\", \"warning\"))); void g(void){f8(1);}\n",
        .warnings = 1,
        .notes = 1,
    },
    {
        .name = "a definition with diagnose_if",
        .source = "int d(int x) __attribute__((diagnose_if(x == 4, \"def\", \"warning\"))) { return x; }\n"
                  "int f(void) { return d(4) + d(3); }\n",
        .warnings = 1,
        .notes = 1,
    },
    {
        .name = "enable_if and diagnose_if together",
        .source = "void u(int x) __attribute__((enable_if(x, \"nz\"), diagnose_if(x == 3, \"three\", \"warning\")));\n"
                  "void f(void) { u(3); }\n",
        .warnings = 1,
        .notes = 1,
    },
    {
        .name = "an enumerator in a condition",
        .source = "enum { LIMIT = 8 }; void f(int x) __attribute__((diagnose_if(x > LIMIT, \"big\", \"warning\"))); void g(void){ f(9); f(8); f(LIMIT + 1); }\n",
        .warnings = 2,
        .notes = 2,
    },
    {
        .name = "a use at file scope",
        .source = "void a(void) __attribute__((diagnose_if(1, \"always\", \"warning\")));\n"
                  "void (*p)(void) = a;\n",
        .warnings = 1,
        .notes = 1,
    },
    {
        .name = "a long long parameter",
        .source = "void f(long long x) __attribute__((diagnose_if(x > 4000000000LL, \"huge\", \"warning\")));\n"
                  "void g(void){ f(5000000000LL); f(1); }\n",
        .warnings = 1,
        .notes = 1,
    },
    {
        .name = "shifts that fault decide nothing",
        .source = "void f(int x) __attribute__((diagnose_if((1 << x) > 100, \"shift\", \"warning\")));\n"
                  "void g(void){ f(10); f(40); f(-1); f(2); }\n",
        .warnings = 1,
        .notes = 1,
    },
    {
        .name = "nested arithmetic",
        .source = "void f(int a, int b) __attribute__((diagnose_if((a + b) * 2 > 10 || (a ^ b) == 7, \"mix\", \"warning\")));\n"
                  "void g(void){ f(3, 3); f(3, 4); f(1, 1); f(-5, 2); }\n",
        .warnings = 2,
        .notes = 2,
    },
    {
        .name = "source order, uses of a function and unevaluated uses",
        .source = "void m(int x) __attribute__((diagnose_if(x > 0, \"w1\", \"warning\"), diagnose_if(x > 1, \"w2\", \"warning\")));\n"
                  "void m(int x) __attribute__((diagnose_if(x > 2, \"w3\", \"warning\")));\n"
                  "void r(void) __attribute__((diagnose_if(1, \"u1\", \"warning\"), diagnose_if(1, \"u2\", \"warning\")));\n"
                  "void a(void) __attribute__((diagnose_if(1, \"always\", \"warning\")));\n"
                  "void a(void) { a(); }\n"
                  "int h(void) { m(3); m(1); r(); void (*w)(void) = r; (void)w; (void)sizeof(a); __typeof__(a) *p = 0; (void)p; (void)_Generic(a, default: 1); return 0; }\n",
        .warnings = 12,
        .notes = 12,
    },
    {
        .name = "an overflowing condition decides nothing",
        .source = "void f(int x) __attribute__((diagnose_if(x + 1 > 0, \"ovf\", \"warning\")));\n"
                  "void g(void) { f(2147483647); f(1); }\n",
        .warnings = 1,
        .notes = 1,
    },
    {
        .name = "an unnamed parameter before a named one",
        .source = "void f(int, int y) __attribute__((diagnose_if(y > 1, \"second\", \"warning\")));\n"
                  "void g(void) { f(5, 2); f(5, 0); }\n",
        .warnings = 1,
        .notes = 1,
    },
    {
        .name = "a pragma ignores the warning",
        .source = "#pragma clang diagnostic ignored \"-Wuser-defined-warnings\"\n"
                  "void f(int x) __attribute__((diagnose_if(x > 1, \"big\", \"warning\")));\n"
                  "void g(void){ f(2); }\n",
    },
    {
        .name = "a redeclaration inherits and renames",
        .source = "void f8(int x);\n"
                  "void f8(int y) __attribute__((diagnose_if(y == 3, \"redecl\", \"warning\")));\n"
                  "void f8(int z);\n"
                  "void h(void){ f8(3); f8(2); }\n",
        .warnings = 1,
        .notes = 1,
    },
    {
        .name = "pointer, floating, sizeof, unsigned, conditional, cast and short-circuit conditions",
        .source = "void f9(int *p) __attribute__((diagnose_if(p == 0, \"null\", \"warning\")));\n"
                  "void f10(double d) __attribute__((diagnose_if(d > 1.5, \"dbl\", \"warning\")));\n"
                  "void f11(int x) __attribute__((diagnose_if(sizeof(x) == 4 && x == 1, \"sz\", \"warning\")));\n"
                  "void f12(unsigned x) __attribute__((diagnose_if(x > -1, \"u\", \"warning\")));\n"
                  "void f14(int x) __attribute__((diagnose_if(x ? x / 2 == 3 : -x == 1, \"cond\", \"warning\")));\n"
                  "void f15(int x) __attribute__((diagnose_if((unsigned char)x == 1, \"cast\", \"warning\")));\n"
                  "void f16(int x) __attribute__((diagnose_if(x != 0 && 10 / x == 5, \"div\", \"warning\")));\n"
                  "void f17(char *p) __attribute__((diagnose_if(!p, \"notp\", \"warning\")));\n"
                  "void h(int n){ f9(0); f9(&n); f10(2.0); f10(1); f11(1); f12(5); f14(6); f14(-1); f14(2); f15(257); f15(2); f16(0); f16(2); f17((void*)0); f17(0); }\n",
        .warnings = 8,
        .notes = 8,
    },
    {
        .name = "diagnose_if on a variable",
        .source = "int v __attribute__((diagnose_if(1, \"var\", \"warning\")));\n",
        .warnings = 1,
    },
    {
        .name = "a variadic function",
        .source = "void v(int x, ...) __attribute__((diagnose_if(x > 2, \"var\", \"warning\"))); void c(void) { v(3); v(3, 1, 2); v(1, 5); }\n",
        .warnings = 2,
        .notes = 2,
    },
    {
        .name = "object and function addresses are never null",
        .source = "int glob;\n"
                  "void helper(void) {}\n"
                  "void f1(char *p) __attribute__((enable_if(p != 0, \"nonnull\")));\n"
                  "void f3(void (*fp)(void)) __attribute__((enable_if(fp != 0, \"nn\")));\n"
                  "void f4(int *p) __attribute__((enable_if(p != 0, \"nonnull\")));\n"
                  "void d(int *p) __attribute__((diagnose_if(p != 0, \"nonnull arg\", \"warning\")));\n"
                  "void h(void) { int local; f1(\"lit\"); f3(helper); f4(&glob); d(&glob); d(0); f4(&local); }\n",
        .warnings = 1,
        .notes = 1,
    },
    {
        .name = "a variable read a short circuit can skip",
        .source = "int g;\n"
                  "void f(int x) __attribute__((enable_if(x > 0 && g > 0, \"c\")));\n"
                  "void k(int x) __attribute__((enable_if(x > 0 ? g : 1, \"c\")));\n"
                  "void m(int x) __attribute__((diagnose_if(x > 0 || g, \"c\", \"warning\")));\n"
                  "void h(void) { f(0); }\n"
                  "void h2(void) { k(0); }\n"
                  "void h3(void) { m(1); m(0); }\n",
        .warnings = 1,
        .errors = 1,
        .notes = 2,
    },
    {
        .name = "addresses compared, tested and cast",
        .source = "int a[4], b;\n"
                  "void f(int *p, int *q) __attribute__((diagnose_if(p == q, \"same\", \"warning\")));\n"
                  "void g(int *p) __attribute__((diagnose_if(!p, \"null\", \"warning\"), diagnose_if(p ? 1 : 0, \"set\", \"warning\")));\n"
                  "void k(const char *s) __attribute__((diagnose_if((const void *)s != 0, \"cast\", \"warning\")));\n"
                  "void h(void) { f(a, &b); f(0, 0); g(a); g(0); k(\"x\"); k(0); }\n",
        .warnings = 4,
        .notes = 4,
    },
    {
        .name = "unknown operands skipped at calls",
        .source = "int g;\n"
                  "void m(int x) __attribute__((diagnose_if(x > 0 || g, \"or\", \"warning\")));\n"
                  "void n(int x, int y) __attribute__((diagnose_if(x == 0 || y > 3, \"either\", \"warning\")));\n"
                  "void k(int x) __attribute__((enable_if(x > 0 ? g : 1, \"c\")));\n"
                  "void h(int v) { m(1); m(0); n(0, v); n(1, v); n(v, 5); k(0); }\n",
        .warnings = 2,
        .notes = 2,
    },
    {
        .name = "one address error for each operation that converts",
        .source = "void q(int x) __attribute__((enable_if(x > 0, \"p1\")));\n"
                  "void r(int x) __attribute__((enable_if(x > 0, \"p2\")));\n"
                  "void s(int x);\n"
                  "void g(void (*)(int), void (*)(int));\n"
                  "void f1(int c) { void (*p)(int) = c ? q : r; (void)p; }\n"
                  "void f2(int c) { (void)(c ? r : q); (void)(c ? (q) : (r)); (void)(q ? q : 0); }\n"
                  "void f3(int c) { (void)(q == r); (void)(q, r); (void)(q && r); (void)(q ?: r); }\n"
                  "void f4(int c) { (void)(c ? (c ? q : r) : r); (void)(q == (c ? r : s)); }\n"
                  "void f5(int c) { (void)(&q == &r); (void)(c ? &q : &r); }\n",
        .errors = 14,
    },
    {
        .name = "one address error for each call and statement",
        .source = "void q(int x) __attribute__((enable_if(x > 0, \"p1\")));\n"
                  "void r(int x) __attribute__((enable_if(x > 0, \"p2\")));\n"
                  "void s(int x);\n"
                  "void g(void (*)(int), void (*)(int));\n"
                  "void f6(int c) { g(q, r); g(s, q); }\n"
                  "void f7(int c) { q; r; }\n"
                  "void f8(int c) { (void)((q == s) + (r == s)); (void)((s == q) == r); }\n"
                  "void f9(int c) { (void)(c ? q : r) == (c ? r : q); }\n",
        .errors = 9,
    },
    {
        .name = "address errors in initializer lists",
        .source = "void q(int x) __attribute__((enable_if(x > 0, \"p1\")));\n"
                  "void r(int x) __attribute__((enable_if(x > 0, \"p2\")));\n"
                  "void s(int x);\n"
                  "struct P { void (*a)(int); void (*b)(int); };\n"
                  "void f1(int c) { void (*a[2])(int) = { q, r }; (void)a; }\n"
                  "void f2(int c) { void (*a[2])(int) = { q, c ? r : s }; (void)a; }\n"
                  "void f3(int c) { struct P p = { .a = q, .b = c ? r : s }; (void)p; }\n"
                  "void f4(int c) { struct P p[2] = { { q, s }, { c ? s : r, s } }; (void)p; }\n",
        .errors = 5,
    },
    {
        .name = "address errors inside unevaluated operands",
        .source = "void q(int x) __attribute__((enable_if(x > 0, \"p1\")));\n"
                  "void r(int x) __attribute__((enable_if(x > 0, \"p2\")));\n"
                  "void f(int c) { (void)sizeof(q == r); (void)sizeof(&q); (void)sizeof((q)); (void)sizeof q; (void)sizeof(q, r); }\n"
                  "void h(int c) { __typeof__(c ? q : r) *p = 0; (void)p; (void)__alignof__(q); (void)_Generic(q, default: 0); }\n",
        .errors = 5,
    },
    {
        .name = "warning groups",
        .source = "void f(int x) __attribute__((diagnose_if(x > 0, \"shadowed\", \"warning\", \"shadow\")));\n"
                  "void h(int x) __attribute__((diagnose_if(x > 0, \"formatted\", \"error\", \"format\")));\n"
                  "void u(int x) __attribute__((diagnose_if(x > 0, \"plain\", \"warning\")));\n"
                  "void a(int x) __attribute__((diagnose_if(x > 0, \"most\", \"warning\", \"all\"), diagnose_if(x > 1, \"unused\", \"warning\", \"unused-variable\")));\n"
                  "void p(int x) __attribute__((diagnose_if(x > 0, \"pedantic\", \"warning\", \"pedantic\")));\n"
                  "int m(void) { f(1); h(2); u(1); a(2); p(1); f(0); return 0; }\n",
        .warnings = 5,
        .errors = 1,
        .notes = 1,
    },
    {
        .name = "warning groups under -Wno-format",
        .source = "void f(int x) __attribute__((diagnose_if(x > 0, \"shadowed\", \"warning\", \"shadow\")));\n"
                  "void h(int x) __attribute__((diagnose_if(x > 0, \"formatted\", \"error\", \"format\")));\n"
                  "void u(int x) __attribute__((diagnose_if(x > 0, \"plain\", \"warning\")));\n"
                  "void a(int x) __attribute__((diagnose_if(x > 0, \"most\", \"warning\", \"all\"), diagnose_if(x > 1, \"unused\", \"warning\", \"unused-variable\")));\n"
                  "void p(int x) __attribute__((diagnose_if(x > 0, \"pedantic\", \"warning\", \"pedantic\")));\n"
                  "int m(void) { f(1); h(2); u(1); a(2); p(1); f(0); return 0; }\n",
        .options = { "-Wno-format" },
        .warnings = 5,
        .notes = 1,
    },
    {
        .name = "warning groups under -Wall",
        .source = "void f(int x) __attribute__((diagnose_if(x > 0, \"shadowed\", \"warning\", \"shadow\")));\n"
                  "void h(int x) __attribute__((diagnose_if(x > 0, \"formatted\", \"error\", \"format\")));\n"
                  "void u(int x) __attribute__((diagnose_if(x > 0, \"plain\", \"warning\")));\n"
                  "void a(int x) __attribute__((diagnose_if(x > 0, \"most\", \"warning\", \"all\"), diagnose_if(x > 1, \"unused\", \"warning\", \"unused-variable\")));\n"
                  "void p(int x) __attribute__((diagnose_if(x > 0, \"pedantic\", \"warning\", \"pedantic\")));\n"
                  "int m(void) { f(1); h(2); u(1); a(2); p(1); f(0); return 0; }\n",
        .options = { "-Wall" },
        .warnings = 6,
        .notes = 1,
    },
    {
        .name = "warning groups under -Wno-all",
        .source = "void f(int x) __attribute__((diagnose_if(x > 0, \"shadowed\", \"warning\", \"shadow\")));\n"
                  "void h(int x) __attribute__((diagnose_if(x > 0, \"formatted\", \"error\", \"format\")));\n"
                  "void u(int x) __attribute__((diagnose_if(x > 0, \"plain\", \"warning\")));\n"
                  "void a(int x) __attribute__((diagnose_if(x > 0, \"most\", \"warning\", \"all\"), diagnose_if(x > 1, \"unused\", \"warning\", \"unused-variable\")));\n"
                  "void p(int x) __attribute__((diagnose_if(x > 0, \"pedantic\", \"warning\", \"pedantic\")));\n"
                  "int m(void) { f(1); h(2); u(1); a(2); p(1); f(0); return 0; }\n",
        .options = { "-Wno-all" },
        .warnings = 2,
    },
    {
        .name = "warning groups under -Werror=array-bounds",
        .source = "void f(int x) __attribute__((diagnose_if(x > 0, \"bounded\", \"warning\", \"array-bounds\")));\n"
                  "void h(int x) __attribute__((diagnose_if(x > 0, \"formatted\", \"error\", \"format\")));\n"
                  "void u(int x) __attribute__((diagnose_if(x > 0, \"plain\", \"warning\")));\n"
                  "void a(int x) __attribute__((diagnose_if(x > 0, \"most\", \"warning\", \"all\"), diagnose_if(x > 1, \"unused\", \"warning\", \"unused-variable\")));\n"
                  "void p(int x) __attribute__((diagnose_if(x > 0, \"pedantic\", \"warning\", \"pedantic\")));\n"
                  "int m(void) { f(1); h(2); u(1); a(2); p(1); f(0); return 0; }\n",
        .options = { "-Werror=array-bounds" },
        .warnings = 4,
        .errors = 2,
        .notes = 1,
    },
    {
        .name = "warning groups under -Werror -Wno-error=shadow",
        .source = "void f(int x) __attribute__((diagnose_if(x > 0, \"shadowed\", \"warning\", \"shadow\")));\n"
                  "void h(int x) __attribute__((diagnose_if(x > 0, \"formatted\", \"error\", \"format\")));\n"
                  "void u(int x) __attribute__((diagnose_if(x > 0, \"plain\", \"warning\")));\n"
                  "void a(int x) __attribute__((diagnose_if(x > 0, \"most\", \"warning\", \"all\"), diagnose_if(x > 1, \"unused\", \"warning\", \"unused-variable\")));\n"
                  "void p(int x) __attribute__((diagnose_if(x > 0, \"pedantic\", \"warning\", \"pedantic\")));\n"
                  "int m(void) { f(1); h(2); u(1); a(2); p(1); f(0); return 0; }\n",
        .options = { "-Werror", "-Wno-error=shadow" },
        .errors = 6,
        .notes = 1,
    },
    {
        .name = "warning groups under -Wno-error=shadow -Werror",
        .source = "void f(int x) __attribute__((diagnose_if(x > 0, \"shadowed\", \"warning\", \"shadow\")));\n"
                  "void h(int x) __attribute__((diagnose_if(x > 0, \"formatted\", \"error\", \"format\")));\n"
                  "void u(int x) __attribute__((diagnose_if(x > 0, \"plain\", \"warning\")));\n"
                  "void a(int x) __attribute__((diagnose_if(x > 0, \"most\", \"warning\", \"all\"), diagnose_if(x > 1, \"unused\", \"warning\", \"unused-variable\")));\n"
                  "void p(int x) __attribute__((diagnose_if(x > 0, \"pedantic\", \"warning\", \"pedantic\")));\n"
                  "int m(void) { f(1); h(2); u(1); a(2); p(1); f(0); return 0; }\n",
        .options = { "-Wno-error=shadow", "-Werror" },
        .errors = 6,
        .notes = 1,
    },
    {
        .name = "warning groups under -Wno-everything",
        .source = "void f(int x) __attribute__((diagnose_if(x > 0, \"shadowed\", \"warning\", \"shadow\")));\n"
                  "void h(int x) __attribute__((diagnose_if(x > 0, \"formatted\", \"error\", \"format\")));\n"
                  "void u(int x) __attribute__((diagnose_if(x > 0, \"plain\", \"warning\")));\n"
                  "void a(int x) __attribute__((diagnose_if(x > 0, \"most\", \"warning\", \"all\"), diagnose_if(x > 1, \"unused\", \"warning\", \"unused-variable\")));\n"
                  "void p(int x) __attribute__((diagnose_if(x > 0, \"pedantic\", \"warning\", \"pedantic\")));\n"
                  "int m(void) { f(1); h(2); u(1); a(2); p(1); f(0); return 0; }\n",
        .options = { "-Wno-everything" },
        .warnings = 4,
        .errors = 1,
    },
    {
        .name = "warning groups under -Wfatal-errors=array-bounds",
        .source = "void f(int x) __attribute__((diagnose_if(x > 0, \"bounded\", \"warning\", \"array-bounds\")));\n"
                  "void h(int x) __attribute__((diagnose_if(x > 0, \"formatted\", \"error\", \"format\")));\n"
                  "void u(int x) __attribute__((diagnose_if(x > 0, \"plain\", \"warning\")));\n"
                  "void a(int x) __attribute__((diagnose_if(x > 0, \"most\", \"warning\", \"all\"), diagnose_if(x > 1, \"unused\", \"warning\", \"unused-variable\")));\n"
                  "void p(int x) __attribute__((diagnose_if(x > 0, \"pedantic\", \"warning\", \"pedantic\")));\n"
                  "int m(void) { f(1); h(2); u(1); a(2); p(1); f(0); return 0; }\n",
        .options = { "-Wfatal-errors=array-bounds" },
        .errors = 1,
    },
    {
        .name = "warning groups under -Wno-error=format",
        .source = "void f(int x) __attribute__((diagnose_if(x > 0, \"shadowed\", \"warning\", \"shadow\")));\n"
                  "void h(int x) __attribute__((diagnose_if(x > 0, \"formatted\", \"error\", \"format\")));\n"
                  "void u(int x) __attribute__((diagnose_if(x > 0, \"plain\", \"warning\")));\n"
                  "void a(int x) __attribute__((diagnose_if(x > 0, \"most\", \"warning\", \"all\"), diagnose_if(x > 1, \"unused\", \"warning\", \"unused-variable\")));\n"
                  "void p(int x) __attribute__((diagnose_if(x > 0, \"pedantic\", \"warning\", \"pedantic\")));\n"
                  "int m(void) { f(1); h(2); u(1); a(2); p(1); f(0); return 0; }\n",
        .options = { "-Wno-error=format" },
        .warnings = 6,
        .notes = 1,
    },
    {
        .name = "warning groups under -Wformat",
        .source = "void f(int x) __attribute__((diagnose_if(x > 0, \"shadowed\", \"warning\", \"shadow\")));\n"
                  "void h(int x) __attribute__((diagnose_if(x > 0, \"formatted\", \"error\", \"format\")));\n"
                  "void u(int x) __attribute__((diagnose_if(x > 0, \"plain\", \"warning\")));\n"
                  "void a(int x) __attribute__((diagnose_if(x > 0, \"most\", \"warning\", \"all\"), diagnose_if(x > 1, \"unused\", \"warning\", \"unused-variable\")));\n"
                  "void p(int x) __attribute__((diagnose_if(x > 0, \"pedantic\", \"warning\", \"pedantic\")));\n"
                  "int m(void) { f(1); h(2); u(1); a(2); p(1); f(0); return 0; }\n",
        .options = { "-Wformat" },
        .warnings = 6,
        .notes = 1,
    },
    {
        .name = "warning groups under -Wno-array-bounds -Warray-bounds",
        .source = "void f(int x) __attribute__((diagnose_if(x > 0, \"bounded\", \"warning\", \"array-bounds\")));\n"
                  "void h(int x) __attribute__((diagnose_if(x > 0, \"formatted\", \"error\", \"format\")));\n"
                  "void u(int x) __attribute__((diagnose_if(x > 0, \"plain\", \"warning\")));\n"
                  "void a(int x) __attribute__((diagnose_if(x > 0, \"most\", \"warning\", \"all\"), diagnose_if(x > 1, \"unused\", \"warning\", \"unused-variable\")));\n"
                  "void p(int x) __attribute__((diagnose_if(x > 0, \"pedantic\", \"warning\", \"pedantic\")));\n"
                  "int m(void) { f(1); h(2); u(1); a(2); p(1); f(0); return 0; }\n",
        .options = { "-Wno-array-bounds", "-Warray-bounds" },
        .warnings = 5,
        .errors = 1,
        .notes = 1,
    },
    {
        .name = "warning groups under -Wno-unused",
        .source = "void f(int x) __attribute__((diagnose_if(x > 0, \"shadowed\", \"warning\", \"shadow\")));\n"
                  "void h(int x) __attribute__((diagnose_if(x > 0, \"formatted\", \"error\", \"format\")));\n"
                  "void u(int x) __attribute__((diagnose_if(x > 0, \"plain\", \"warning\")));\n"
                  "void a(int x) __attribute__((diagnose_if(x > 0, \"most\", \"warning\", \"all\"), diagnose_if(x > 1, \"unused\", \"warning\", \"unused-variable\")));\n"
                  "void p(int x) __attribute__((diagnose_if(x > 0, \"pedantic\", \"warning\", \"pedantic\")));\n"
                  "int m(void) { f(1); h(2); u(1); a(2); p(1); f(0); return 0; }\n",
        .options = { "-Wno-unused" },
        .warnings = 4,
        .errors = 1,
        .notes = 1,
    },
    {
        .name = "warning groups under -W",
        .source = "void f(int x) __attribute__((diagnose_if(x > 0, \"shadowed\", \"warning\", \"shadow\")));\n"
                  "void h(int x) __attribute__((diagnose_if(x > 0, \"formatted\", \"error\", \"format\")));\n"
                  "void u(int x) __attribute__((diagnose_if(x > 0, \"plain\", \"warning\")));\n"
                  "void a(int x) __attribute__((diagnose_if(x > 0, \"most\", \"warning\", \"all\"), diagnose_if(x > 1, \"unused\", \"warning\", \"unused-variable\")));\n"
                  "void p(int x) __attribute__((diagnose_if(x > 0, \"pedantic\", \"warning\", \"pedantic\")));\n"
                  "int m(void) { f(1); h(2); u(1); a(2); p(1); f(0); return 0; }\n",
        .options = { "-W" },
        .warnings = 5,
        .errors = 1,
        .notes = 1,
    },
    {
        .name = "warning groups under -Wno-error=format -Werror",
        .source = "void f(int x) __attribute__((diagnose_if(x > 0, \"shadowed\", \"warning\", \"shadow\")));\n"
                  "void h(int x) __attribute__((diagnose_if(x > 0, \"formatted\", \"error\", \"format\")));\n"
                  "void u(int x) __attribute__((diagnose_if(x > 0, \"plain\", \"warning\")));\n"
                  "void a(int x) __attribute__((diagnose_if(x > 0, \"most\", \"warning\", \"all\"), diagnose_if(x > 1, \"unused\", \"warning\", \"unused-variable\")));\n"
                  "void p(int x) __attribute__((diagnose_if(x > 0, \"pedantic\", \"warning\", \"pedantic\")));\n"
                  "int m(void) { f(1); h(2); u(1); a(2); p(1); f(0); return 0; }\n",
        .options = { "-Wno-error=format", "-Werror" },
        .errors = 6,
        .notes = 1,
    },
    {
        .name = "warning groups under pragmas",
        .source = "void f(int x) __attribute__((diagnose_if(x > 0, \"shadowed\", \"warning\", \"shadow\")));\n"
                  "void h(int x) __attribute__((diagnose_if(x > 0, \"formatted\", \"error\", \"format\")));\n"
                  "#pragma clang diagnostic warning \"-Wformat\"\n"
                  "int m(void) { f(1); h(2); return 0; }\n"
                  "#pragma clang diagnostic ignored \"-Wshadow-all\"\n"
                  "int n(void) { f(1); h(2); return 0; }\n"
                  "#pragma clang diagnostic error \"-Wshadow\"\n"
                  "#pragma clang diagnostic ignored \"-Wmost\"\n"
                  "int k(void) { f(1); h(2); return 0; }\n",
        .warnings = 3,
        .errors = 1,
    },
    {
        .name = "calls, assignments and increments a call skips or leaves unknown",
        .source = "int g(int);\n"
                  "int h(void);\n"
                  "int abs(int);\n"
                  "void f0(int x) __attribute__((diagnose_if(g(x) > 0, \"c0\", \"warning\")));\n"
                  "void f1(int x) __attribute__((diagnose_if(x > 3 || g(x), \"c1\", \"warning\")));\n"
                  "void f2(int x) __attribute__((diagnose_if(x > 0 && g(1), \"c2\", \"warning\")));\n"
                  "void f3(int x) __attribute__((diagnose_if(x ? g(1) : 1, \"c3\", \"warning\")));\n"
                  "void f4(int x) __attribute__((diagnose_if(g(g(x)), \"c4\", \"warning\")));\n"
                  "void f5(int x) __attribute__((diagnose_if(abs(x) > 3, \"c5\", \"warning\")));\n"
                  "void f6(int x) __attribute__((diagnose_if(x > 0 && (x = 3), \"c6\", \"warning\")));\n"
                  "void f7(int x) __attribute__((diagnose_if(x > 0 || (x = 1), \"c7\", \"warning\")));\n"
                  "void f8(int x) __attribute__((diagnose_if(x > 0 ? x++ : 0, \"c8\", \"warning\")));\n"
                  "void f9(int x) __attribute__((diagnose_if(x > 0 && g(x = 1), \"c9\", \"warning\")));\n"
                  "void k(void) { f0(5); f0(0); f1(5); f1(0); f2(5); f2(0); f3(5); f3(0); f4(5); f4(0); f5(5); f5(0); f6(5); f6(0); f7(5); f7(0); f8(5); f8(0); f9(5); f9(0); }\n",
        .warnings = 3,
        .notes = 3,
    },
    {
        .name = "a condition that never produces a constant: x == g(1)",
        .source = "int g(int);\nint h(void);\n"
                  "void f(int x) __attribute__((diagnose_if(x == g(1), \"c\", \"warning\")));\n",
        .errors = 1,
        .notes = 1,
    },
    {
        .name = "a condition that never produces a constant: (x += 1) > 2",
        .source = "int g(int);\nint h(void);\n"
                  "void f(int x) __attribute__((diagnose_if((x += 1) > 2, \"c\", \"warning\")));\n",
        .errors = 1,
        .notes = 1,
    },
    {
        .name = "a condition that never produces a constant: --x > 2",
        .source = "int g(int);\nint h(void);\n"
                  "void f(int x) __attribute__((diagnose_if(--x > 2, \"c\", \"warning\")));\n",
        .errors = 1,
        .notes = 1,
    },
    {
        .name = "a condition that never produces a constant: x++ > 3",
        .source = "int g(int);\nint h(void);\n"
                  "void f(int x) __attribute__((diagnose_if(x++ > 3, \"c\", \"warning\")));\n",
        .errors = 1,
        .notes = 1,
    },
    {
        .name = "a condition that never produces a constant: g(x = 1)",
        .source = "int g(int);\nint h(void);\n"
                  "void f(int x) __attribute__((diagnose_if(g(x = 1), \"c\", \"warning\")));\n",
        .errors = 1,
        .notes = 1,
    },
    {
        .name = "a condition that never produces a constant: (x++, 1)",
        .source = "int g(int);\nint h(void);\n"
                  "void f(int x) __attribute__((diagnose_if((x++, 1), \"c\", \"warning\")));\n",
        .errors = 1,
        .notes = 1,
    },
    {
        .name = "a condition that never produces a constant: h()",
        .source = "int g(int);\nint h(void);\n"
                  "void f(int x) __attribute__((diagnose_if(h(), \"c\", \"warning\")));\n",
        .errors = 1,
        .notes = 1,
    },
    {
        .name = "a condition that never produces a constant: g(1) > 0",
        .source = "int g(int);\nint h(void);\n"
                  "void f(int x) __attribute__((diagnose_if(g(1) > 0, \"c\", \"warning\")));\n",
        .errors = 1,
        .notes = 1,
    },
    // A comma operator's left operand in a condition (#1447, check_input_attribute_unused): -Wunused-value's "has no effect"
    // at the place clang's isUnusedResultAWarning gives (a nested comma's right operand, a conditional's else arm, a logical
    // operator, a cast's `(`, sizeof's keyword), quiet for a call, an assignment and a literal 0 after a comma, and
    // -Wunused-comparison's, with its note, for a comparison; and in another attribute's argument.
    {
        .name = "comma operators' left operands in conditions",
        .source = "void f(int x) __attribute__((diagnose_if((x, x > 1), \"big\", \"warning\")));\n"
                  "void g(int x) __attribute__((enable_if((1, x), \"e\")));\n"
                  "void h(int x) __attribute__((diagnose_if((x + 1, 2, x > 1), \"big\", \"error\")));\n"
                  "void k(void) { f(2); g(1); h(0); }\n",
        .warnings = 5,
        .notes = 1,
    },
    {
        .name = "the shapes of a comma's discarded left operand",
        .source = "void a(int x) __attribute__((diagnose_if((x == 1, x), \"m\", \"warning\")));\n"
                  "void b(int x) __attribute__((diagnose_if((x < 1, x), \"m\", \"warning\")));\n"
                  "void d(int x) __attribute__((diagnose_if((-x, x), \"m\", \"warning\")));\n"
                  "void e(int x) __attribute__((diagnose_if((x ? 1 : 2, x), \"m\", \"warning\")));\n"
                  "void f(int x) __attribute__((diagnose_if((sizeof x, x), \"m\", \"warning\")));\n"
                  "void g(int x) __attribute__((diagnose_if(((long)x, x), \"m\", \"warning\")));\n"
                  "void h(int x) __attribute__((diagnose_if((x && 1, x), \"m\", \"warning\")));\n"
                  "void i(int x) __attribute__((diagnose_if((0, x), \"m\", \"warning\")));\n"
                  "void j(int x) __attribute__((diagnose_if((1, 2), \"m\", \"warning\")));\n"
                  "void k(int x) __attribute__((diagnose_if(((x, 1), x), \"m\", \"warning\")));\n"
                  "void l(int x) __attribute__((diagnose_if(((x, 0), x > 1), \"m\", \"warning\")));\n"
                  "void m(int x) __attribute__((diagnose_if((x != 1, x), \"m\", \"warning\")));\n"
                  "void n(int x) __attribute__((enable_if((x, 1), \"m\")));\n"
                  "void o(int x) __attribute__((diagnose_if((x ? 1 : x++, x), \"m\", \"warning\")));\n",
        .warnings = 14,
        .notes = 2,
    },
    {
        .name = "a comma operator in another attribute's argument",
        .source = "int c __attribute__((aligned((7, 8))));\n",
        .warnings = 1,
        .errors = 1,
    },    // Overloadable functions' conditions in overload resolution (#1447, c_check_overload.c): an enable_if that doesn't
    // admit the call makes its candidate not viable, the candidate whose enable_ifs are another's and more is better, and
    // ones that differ (clang's profile: the tree, literals by value, parameters by place and type) are neither, and
    // are two functions of one signature; diagnose_if applies to the selected candidate. A call no candidate or several are
    // viable for has clang's error and candidate notes. And a pointer variable's argument, which is no constant.
    {
        .name = "overloads disabled by enable_if, and the one selected",
        .source = "int f(int a) __attribute__((overloadable, enable_if(a > 0, \"positive\")));\n"
                  "char f(long a) __attribute__((overloadable));\n"
                  "_Static_assert(sizeof(f(1)) == 4, \"enabled\");\n"
                  "_Static_assert(sizeof(f(-1)) == 1, \"disabled\");\n"
                  "void t(int x) { (void)f(x); }\n",
    },
    {
        .name = "no overload viable: a disabled candidate's note and another's argument count",
        .source = "int g(int a) __attribute__((overloadable, enable_if(a > 0, \"pos\")));\n"
                  "int g(int a, int b) __attribute__((overloadable));\n"
                  "void t(int x) { g(1); g(-1); g(x); g(); g(1, 2, 3); }\n",
        .errors = 4,
        .notes = 8,
    },
    {
        .name = "a variadic overload's count and an empty message",
        .source = "int v(int a, ...) __attribute__((overloadable, enable_if(a > 1, \"\")));\n"
                  "int v(int a, int b, int c) __attribute__((overloadable));\n"
                  "void t(void) { v(); v(2, 3); v(0, 1); }\n",
        .errors = 2,
        .notes = 4,
    },
    {
        .name = "the overload with more enable_if conditions is better",
        .source = "int m(int a, long x) __attribute__((overloadable, enable_if(a > 0, \"a\")));\n"
                  "int m(int a, long x) __attribute__((overloadable, enable_if(a > 0, \"a\")));\n"
                  "char m(int b, long long y) __attribute__((overloadable, enable_if(b > 0x0, \"b\"), enable_if(b < 9, \"c\")));\n"
                  "_Static_assert(sizeof(m(1, 0)) == 1, \"more\");\n"
                  "_Static_assert(sizeof(m(10, 0)) == 4, \"fewer\");\n",
    },
    {
        .name = "enable_if conditions that differ are ambiguous",
        .source = "#define ONE 1\n"
                  "int g1(int a, long x) __attribute__((overloadable, enable_if(a > (1), \"\"), enable_if(a < 9, \"\")));\n"
                  "char g1(int b, long long y) __attribute__((overloadable, enable_if(b > 1, \"\")));\n"
                  "int g2(int a, long x) __attribute__((overloadable, enable_if(a > 1L, \"\"), enable_if(a < 9, \"\")));\n"
                  "char g2(int b, long long y) __attribute__((overloadable, enable_if(b > ONE, \"\")));\n"
                  "int g3(long a) __attribute__((overloadable, enable_if(a > 0, \"\"), enable_if(a < 9, \"\")));\n"
                  "char g3(unsigned long a) __attribute__((overloadable, enable_if(a > 0, \"\")));\n"
                  "int g4(int a) __attribute__((overloadable, enable_if(a > 0, \"\"), enable_if(a < 9, \"\")));\n"
                  "int g4(int a) __attribute__((overloadable, enable_if(a < 9, \"\"), enable_if(a > 0, \"\")));\n"
                  "void t(void) { g1(3, 0); g2(3, 0); g3(1); g4(4); g4(10); }\n",
        .errors = 5,
        .notes = 10,
    },
    {
        .name = "an overload whose enable_if conditions differ is another function",
        .source = "int n(int a) __attribute__((overloadable, enable_if(a > 0, \"a\")));\n"
                  "int n(int a) __attribute__((overloadable));\n"
                  "int n(int a) __attribute__((overloadable, enable_if(a > 0, \"a\")));\n"
                  "int n(int a) __attribute__((overloadable, enable_if(a > 0, \"a\"))) { return a; }\n"
                  "int h(int a) __attribute__((overloadable, enable_if(a > 0, \"a\")));\n"
                  "int h(int a) __attribute__((overloadable, enable_if(a < 10, \"b\")));\n"
                  "void t(void) { n(1); n(-1); h(30); h(-1); h(5); }\n",
        .errors = 1,
        .notes = 2,
    },
    // The one candidate without overloadable reads an enable_if it inherits with its parameters unknown (#2464), so it
    // isn't viable and the call selects the other, whose diagnose_if holds.
    {
        .name = "an unmarked candidate's inherited enable_if in overload resolution",
        .source = "int f(int n) __attribute__((enable_if(n < 100, \"small\")));\n"
                  "int f(int n);\n"
                  "int f(double d) __attribute__((overloadable, diagnose_if(d == 8.0, \"dbl\", \"warning\")));\n"
                  "void t(void) { f(8); }\n",
        .warnings = 1,
        .notes = 1,
    },
    {
        .name = "an ambiguous call's candidates",
        .source = "long w(long a) __attribute__((overloadable));\n"
                  "long w(unsigned long a) __attribute__((overloadable));\n"
                  "long w(long long a) __attribute__((overloadable));\n"
                  "void t(void) { w(1); }\n",
        .errors = 1,
        .notes = 3,
    },
    // An overload call's candidate that fails by an argument's conversion (#2384): clang's "no known conversion" note,
    // these first in display order; and an overload set's address that matches no candidate, '<overloaded function
    // type>' with each candidate's note (check_driver_overload_address).
    {
        .name = "a candidate that fails by an argument's conversion",
        .source = "#define OV __attribute__((overloadable))\n"
                  "struct S { int x; };\n"
                  "int f(int a) OV;\n"
                  "int f(int *a, int b) OV;\n"
                  "void g(struct S s) { f(s); }\n",
        .errors = 1,
        .notes = 2,
    },
    {
        .name = "conversion failures first, with clang's fix-it words",
        .source = "#define OV __attribute__((overloadable))\n"
                  "struct S { int x; };\n"
                  "struct T { int y; };\n"
                  "int f(int a) OV;\n"
                  "int f(struct T t, int b) OV;\n"
                  "int f(int a, int b, int c) OV;\n"
                  "void g(struct S s, long *lp) { f(s); f(s, 1); f(1, s); f(s, s); }\n"
                  "int h(long *a) OV;\n"
                  "int h(struct T t) OV;\n"
                  "void k(int i) { h(i); h(1.5); }\n",
        .errors = 6,
        .notes = 16,
    },
    {
        .name = "an overload set's address that matches no candidate",
        .source = "#define OV __attribute__((overloadable))\n"
                  "int f(int a) OV __attribute__((enable_if(a > 0, \"pos\")));\n"
                  "int f(double a) OV;\n"
                  "int f(int a, int b) OV;\n"
                  "long f(char *s) OV;\n"
                  "int (*p)(int) = f;\n"
                  "void g(void) { int (*q)(long) = f; q = f; (void)q; }\n"
                  "int (*r)(int) = &f;\n",
        .errors = 4,
        .notes = 16,
    },
    {
        // Returned or passed (#2480, check_driver_overload_operand): '<overloaded function type>' as the source, with a
        // parameter's note where the callee's declaration names it, and no candidate notes; and an incompatible pointer
        // argument a viable conversion, whose error names the selected candidate's parameter.
        .name = "an overload set's address returned or passed, and an incompatible pointer argument",
        .source = "#define OV __attribute__((overloadable))\n"
                  "int f(double a) OV;\n"
                  "int f(char a) OV;\n"
                  "void take(int (*)(int));\n"
                  "void take2(int (*q)(int), int);\n"
                  "int (*ret(void))(int) { return f; }\n"
                  "void g(void) { take(f); take2(&f, 1); }\n"
                  "struct T { int y; };\n"
                  "int h(long *a) OV;\n"
                  "int h(struct T t) OV;\n"
                  "void k(int *ip) { h(ip); }\n",
        .errors = 4,
        .notes = 3,
    },
    {
        .name = "an overload set's address with one candidate the enable_ifs leave",
        .source = "long fc(char*);\n"
                  "int (*p)(int) = fc;\n"
                  "#define OV __attribute__((overloadable))\n"
                  "int f(int a) OV __attribute__((enable_if(a > 0, \"pos\")));\n"
                  "int f(double a) OV;\n"
                  "int (*p2)(int) = f;\n"
                  "int g(double a) OV;\n"
                  "int g(char a) OV;\n"
                  "int (*p3)(int) = g;\n"
                  "long h(double a) OV;\n"
                  "long h(char a) OV;\n"
                  "int (*p4)(int) = h;\n",
        .errors = 4,
        .notes = 6,
    },
    {
        .name = "an overload set's address: parameter counts, return types, variadic",
        .source = "#define OV __attribute__((overloadable))\n"
                  "long h(int a) OV;\n"
                  "int h(int a, ...) OV;\n"
                  "int h(int a, int b) OV;\n"
                  "int (*p4)(int) = h;\n"
                  "void (*p5)(int) = h;\n",
        .errors = 2,
        .notes = 6,
    },
    {
        .name = "diagnose_if on the selected overload",
        .source = "int k(int a) __attribute__((overloadable, diagnose_if(1, \"always\", \"warning\"), diagnose_if(a > 1, \"dep\", \"warning\")));\n"
                  "int k(double a) __attribute__((overloadable, diagnose_if(a > 5, \"bigd\", \"error\")));\n"
                  "int (*p)(int) = k;\n"
                  "void t(void) { k(2); k(6.0); k(1.0); int (*q)(double) = k; (void)q; }\n",
        .warnings = 2,
        .errors = 1,
        .notes = 3,
    },
    {
        .name = "diagnose_if accumulates over an overload's redeclarations",
        .source = "int r(int a) __attribute__((overloadable, enable_if(a > 0, \"e\"), diagnose_if(a > 1, \"one\", \"warning\")));\n"
                  "int r(int a) __attribute__((overloadable, enable_if(a > 0, \"e\"), diagnose_if(a > 2, \"two\", \"warning\")));\n"
                  "int r(double a) __attribute__((overloadable));\n"
                  "void t(void) { r(5); r(-5); }\n",
        .warnings = 2,
        .notes = 2,
    },
    {
        .name = "pointer arguments of enable_if, overloaded or not",
        .source = "int p1(int *p) __attribute__((overloadable, enable_if(p != 0, \"nn\")));\n"
                  "int p1(int *p, int n) __attribute__((overloadable));\n"
                  "int e1(int *p) __attribute__((enable_if(p != 0, \"nn\")));\n"
                  "int x, arr[4]; int *g;\n"
                  "void t(int *q) { p1(&x); p1(arr); p1(0); p1(q); p1(g); p1((int *)0); e1(&x); e1(q); e1(g); }\n",
        .errors = 6,
        .notes = 10,
    },
    // A user's function with a pass_object_size parameter reads its conditions as any other's (#2147): an undeclared name,
    // a constant condition at a call, enable_if's and diagnose_if's at calls, overloads, and its address.
    {
        .name = "pass_object_size functions' undeclared and constant conditions",
        .source = "void *f(void *p __attribute__((pass_object_size(0))), unsigned long n)\n"
                  "    __attribute__((diagnose_if(zz, \"always\", \"warning\")));\n"
                  "void *f2(void *p __attribute__((pass_object_size(0))), unsigned long n)\n"
                  "    __attribute__((diagnose_if(1, \"always\", \"warning\")));\n"
                  "void g(void) { char b[4]; f2(b, 8); }\n",
        .warnings = 1,
        .errors = 1,
        .notes = 1,
    },
    {
        .name = "pass_object_size functions' conditions at calls",
        .source = "#define OV __attribute__((overloadable))\n"
                  "void *f(void *p __attribute__((pass_object_size(0))), unsigned long n) __attribute__((enable_if(n < 100, \"small\")));\n"
                  "int g(int *p __attribute__((pass_object_size(1))), int k) OV __attribute__((enable_if(k > 0, \"pos\")));\n"
                  "int g(int *p, int k) OV;\n"
                  "int h(char *p __attribute__((pass_object_size(0))), int k) __attribute__((diagnose_if(k == 3, \"three\", \"warning\"), diagnose_if(k == 4, \"four\", \"error\")));\n"
                  "void t(void) { char b[4]; int i[2]; f(b, 8); f(b, 200); g(i, 1); g(i, 0); h(b, 3); h(b, 4); h(b, 5); (void)&f; }\n",
        .warnings = 1,
        .errors = 3,
        .notes = 3,
    },
    {
        .name = "pass_object_size functions' conditions that hold",
        .source = "void *f(void *p __attribute__((pass_object_size(0))), unsigned long n) __attribute__((enable_if(n < 100, \"small\")));\n"
                  "char gb[4];\n"
                  "int h(char *p __attribute__((pass_object_size(0))), int k) __attribute__((enable_if(k == 3, \"three\")));\n"
                  "int h2(int k, char *p __attribute__((pass_object_size(0)))) __attribute__((enable_if(k == 3, \"three\")));\n"
                  "void t(char *q) { char b[4]; f(0, 8); f(gb, 8); f(&gb[1], 8); f(q, 8); h(b, 3); h(gb, 3); h2(3, b); }\n",
    },
};
static const size_t fixture_11_lengths[] = {
sizeof("void q(int x) __attribute__((enable_if(x > 0, \"p1\")));\n"
                  "void f(void) { void (*p)(int) = (q); (void)p; }\n")-1,
sizeof("void q(int x) __attribute__((enable_if(x > 0, \"p1\")));\n"
                  "void f(void) { (void)sizeof(q); (void)_Alignof(q); __typeof__(q) *z = 0; (void)z; (q)(5); (&q)(5); }\n")-1,
sizeof("void f(int x) __attribute__((enable_if(x > 0, \"positive\")));\n"
                  "int h(void) { f(1); f(0); return 0; }\n")-1,
sizeof("void u(int x) __attribute__((enable_if(x, \"nz\"), diagnose_if(x == 3, \"three\", \"warning\")));\n"
                  "void f(void) { u(3); u(0); }\n")-1,
sizeof("void z(int x) __attribute__((enable_if(0, \"never\")));\n"
                  "int h(void) { z(1); return 0; }\n")-1,
sizeof("void f(int x) __attribute__((enable_if(x, 1)));\n")-1,
sizeof("int g; void f(int x) __attribute__((enable_if(g, \"a\")));\n")-1,
sizeof("int b7(volatile int a) __attribute__((enable_if(a > 0, \"\")));\n"
                  "int b8(volatile int a) __attribute__((diagnose_if(a > 0, \"x\", \"warning\")));\n"
                  "int g; int c(int x) __attribute__((enable_if(g, \"\")));\n"
                  "int d(int x) __attribute__((enable_if(x, \"\")));\n"
                  "void h(void) { b7(1); c(1); d(0); }\n")-1,
sizeof("int c1(int x, volatile int a) __attribute__((enable_if(x && a, \"\")));\n"
                  "int c2(int x, volatile int a) __attribute__((enable_if(x || a, \"\")));\n"
                  "int c3(int x, volatile int a) __attribute__((enable_if(x ? a : 1, \"\")));\n"
                  "int c4(volatile int a) __attribute__((enable_if(sizeof(a) == 4, \"\")));\n"
                  "int c5(volatile int *a) __attribute__((enable_if(a != 0, \"\")));\n"
                  "void g(int* p) { c1(1, 2); c1(0, 2); c2(0, 3); c2(1, 3); c3(0, 1); c4(1); c5(p); }\n")-1,
sizeof("void c(int x) __attribute__((diagnose_if(((void)x, x), \"m\", \"warning\")));\n"
                  "void l(long x) __attribute__((diagnose_if(((void*)x, x), \"m\", \"warning\")));\n"
                  "void a1(int x) __attribute__((diagnose_if(((void)0, x), \"m\", \"warning\")));\n"
                  "void a2(int x) __attribute__((diagnose_if((void)x, \"m\", \"warning\")));\n"
                  "void a3(int x) __attribute__((diagnose_if(x && ((void)x, 1), \"m\", \"warning\")));\n"
                  "void a4(int x) __attribute__((diagnose_if(((void*)0, x), \"m\", \"warning\")));\n"
                  "void a8(int x) __attribute__((enable_if(((void)x, x), \"m\")));\n"
                  "void a9(int *x) __attribute__((diagnose_if(((void*)x, 1), \"m\", \"warning\")));\n"
                  "void b1(int x) __attribute__((diagnose_if(((void)0, 1), \"m\", \"warning\")));\n"
                  "void b5(int x) __attribute__((diagnose_if(((void)x, 1) && x, \"m\", \"warning\")));\n"
                  "void b6(int x) __attribute__((diagnose_if(sizeof((void)x, 1) == 4 && x, \"m\", \"warning\")));\n"
                  "void b7(int x) __attribute__((diagnose_if((long)(char*)0 == 0 && x, \"m\", \"warning\")));\n"
                  "void b8(int x) __attribute__((diagnose_if(x ? 1 : ((void)x, 0), \"m\", \"warning\")));\n"
                  "void h(void) { a3(1); a9(0); b6(1); b8(1); b8(0); }\n")-1,
sizeof("void f(int x) __attribute__((enable_if(x > 0, \"positive\")));\n"
                  "int h(int n) { f(n); return 0; }\n")-1,
sizeof("void r(int x) __attribute__((enable_if(x > 0, \"a\")));\n"
                  "void r(int x);\n"
                  "int h(void) { r(0); return 0; }\n")-1,
sizeof("int r(int n) __attribute__((enable_if(n < 100, \"small\")));\n"
                  "void t0(void) { r(8); }\n"
                  "int r(int n);\n"
                  "void t1(void) { r(8); }\n"
                  "int r(int m);\n"
                  "int r(int);\n"
                  "void t2(void) { r(9); }\n"
                  "int k(int n) __attribute__((overloadable, enable_if(n < 100, \"small\")));\n"
                  "int k(int n) __attribute__((overloadable, enable_if(n < 100, \"small\")));\n"
                  "void t3(void) { k(8); }\n"
                  "void w(int x) __attribute__((enable_if(0, \"p1\")));\n"
                  "void w(int x) __attribute__((enable_if(x < 10, \"p2\")));\n"
                  "void t4(void) { w(5); }\n"
                  "void w(int x);\n"
                  "void t5(void) { w(5); }\n")-1,
sizeof("int a(int n) __attribute__((enable_if(1 || n, \"or\")));\n"
                  "int a(int n);\n"
                  "int c(int n) __attribute__((enable_if(n || 1, \"lor\")));\n"
                  "int c(int n);\n"
                  "int d(int n) __attribute__((enable_if(sizeof(n) == 4, \"size\")));\n"
                  "int d(int n);\n"
                  "int e(int n) __attribute__((enable_if((n, 1), \"comma\")));\n"
                  "int e(int n);\n"
                  "int f(int n) __attribute__((enable_if(n * 0 == 0, \"mul\")));\n"
                  "int f(int n);\n"
                  "int p(int *q) __attribute__((enable_if(q != 0, \"nonnull\")));\n"
                  "int p(int *q);\n"
                  "int g(int n) __attribute__((enable_if(1 || n, \"ok\"), diagnose_if(n == 8, \"eight\", \"warning\")));\n"
                  "int g(int n);\n"
                  "int v;\n"
                  "void t(void) { a(1); c(1); d(1); e(1); f(1); p(&v); g(8); g(7); }\n")-1,
sizeof("int r(int n) __attribute__((enable_if(n < 100, \"small\")));\n"
                  "void t1(void) { int r(int n); r(8); }\n"
                  "void t2(void) { r(8); }\n"
                  "void t3(void) { extern int r(int k); r(8); }\n"
                  "int r(int n) { return n; }\n"
                  "void t4(void) { r(8); }\n")-1,
sizeof("void q(int x) __attribute__((enable_if(1, \"a\"), enable_if(0, \"b\")));\n"
                  "void q(int x);\n"
                  "void h(void) { q(1); void (*p)(int) = q; (void)p; }\n"
                  "void w(int x) __attribute__((enable_if(0, \"p1\")));\n"
                  "void w(int x) __attribute__((enable_if(x < 10, \"p2\")));\n"
                  "void hw(void) { w(5); }\n")-1,
sizeof("int r(int n) __attribute__((enable_if(n < 100, \"small\")));\n"
                  "int r(int n) __attribute__((diagnose_if(n == 9, \"nine\", \"warning\")));\n"
                  "void t(void) { r(8); }\n"
                  "int s(int n) __attribute__((enable_if(1, \"one\"), enable_if(0, \"zero\")));\n"
                  "int s(int n) __attribute__((diagnose_if(n == 9, \"nine\", \"warning\")));\n"
                  "void u(void) { int (*p)(int) = s; (void)p; s(8); }\n")-1,
sizeof("int r(void *p __attribute__((pass_object_size(0)))) __attribute__((enable_if(p != 0, \"nn\")));\n"
                  "int r(void *p __attribute__((pass_object_size(0))));\n"
                  "int s(void *p __attribute__((pass_object_size(0)))) __attribute__((enable_if(1, \"one\")));\n"
                  "int s(void *p __attribute__((pass_object_size(0))));\n"
                  "void t(void) { char b[4]; r(b); s(b); }\n")-1,
sizeof("void f(int x) __attribute__((enable_if(x)));\n")-1,
sizeof("void q2(int x) __attribute__((enable_if(x > 5, \"p1\")));\n"
                  "void q2(int x) __attribute__((enable_if(x > 1, \"p2\")));\n"
                  "int h(void) { q2(3); q2(1); return 0; }\n")-1,
sizeof("void q(int x) __attribute__((enable_if(x > 0, \"p1\"), enable_if(x > 1, \"p2\")));\n"
                  "int h(void) { q(0); return 0; }\n")-1,
sizeof("void f(int x) __attribute__((enable_if(x, \"a\", \"b\")));\n")-1,
sizeof("void n(int x) __attribute__((diagnose_if(x > 0, \"w\", \"warning\"), diagnose_if(x > 0, \"e1\", \"error\"), diagnose_if(x > 0, \"e2\", \"error\")));\n"
                  "void h(void) { n(0); n(1); }\n")-1,
sizeof("void b(void) __attribute__((diagnose_if(1, \"e\", \"error\")));\n"
                  "void c(void) { b(); }\n")-1,
sizeof("void f2(int x) __attribute__((diagnose_if(x, \"m\", \"warning\", \"foo\", \"bar\")));\n")-1,
sizeof("void f5(int x) __attribute__((diagnose_if(x, \"m\", \"warning\", 1)));\n")-1,
sizeof("void f1(int x) __attribute__((diagnose_if(x, \"m\", \"warning\", \"foo\")));\n")-1,
sizeof("void f6(int x) __attribute__((diagnose_if(x, \"m\", \"warning\", \"\")));\n")-1,
sizeof("void f6(int x) __attribute__((diagnose_if(x, \"m\", warning)));\n")-1,
sizeof("void f2(int x) __attribute__((diagnose_if(x, \"m\", \"info\")));\n")-1,
sizeof("void f3(int x) __attribute__((diagnose_if(x, 5, \"warning\")));\n")-1,
sizeof("int g; void f1(int x) __attribute__((diagnose_if(g, \"glob\", \"warning\")));\n")-1,
sizeof("int g; void f1(int x) __attribute__((diagnose_if(x > g, \"glob\", \"warning\")));\n")-1,
sizeof("void f3(int x) __attribute__((diagnose_if(x)));\n")-1,
sizeof("void f4(int x) __attribute__((diagnose_if(x, \"m\")));\n")-1,
sizeof("void f7(int x) __attribute__((diagnose_if(y, \"m\", \"warning\")));\n")-1,
sizeof("void f4(int x) __attribute__((diagnose_if()));\n")-1,
sizeof("void k(int x) __attribute__((enable_if(1, \"always\")));\n"
                  "void f(void) { void (*p)(int) = k; k(2); (void)p; }\n")-1,
sizeof("# 1 \"sys.h\" 1 3\n"
                  "int w(int n) __attribute__((enable_if(1, \"\")));\n"
                  "# 3 \"user.c\" 2\n"
                  "int main(void){ int (*p)(int) = w; return w(1) + p(2); }\n")-1,
sizeof("# 1 \"sys.h\" 1 3\n"
                  "static inline int header_wrapper(int n) __attribute__((diagnose_if((n>8),(\"too large\"),\"warning\"))){return n;}\n"
                  "int opaque(char *p, int n) __attribute__((diagnose_if(__builtin_object_size(p, 1) < n, \"small\", \"warning\")));\n"
                  "# 4 \"user.c\" 2\n"
                  "int main(void){ char b[4]; return header_wrapper(3) + header_wrapper(9) + opaque(b, 2); }\n")-1,
sizeof("void f(int a[4], int n) __attribute__((diagnose_if(n > 4, \"over\", \"warning\")));\n"
                  "void g(int *p) { f(p, 5); }\n")-1,
sizeof("void f(_Bool b) __attribute__((diagnose_if(b, \"true\", \"warning\")));\n"
                  "void g(void){ f(5); f(0); }\n")-1,
sizeof("[[clang::diagnose_if(1, \"c23\", \"warning\")]] void a(void);\n"
                  "void f(void) { a(); }\n")-1,
sizeof("void f(char c) __attribute__((diagnose_if(c == 'x', \"x\", \"warning\")));\n"
                  "void g(void){ f('x'); f(120); f(1); }\n")-1,
sizeof("void f8(int x) __attribute__((diagnose_if(x, \"m\" \"n\", \"warning\"))); void g(void){f8(1);}\n")-1,
sizeof("int d(int x) __attribute__((diagnose_if(x == 4, \"def\", \"warning\"))) { return x; }\n"
                  "int f(void) { return d(4) + d(3); }\n")-1,
sizeof("void u(int x) __attribute__((enable_if(x, \"nz\"), diagnose_if(x == 3, \"three\", \"warning\")));\n"
                  "void f(void) { u(3); }\n")-1,
sizeof("enum { LIMIT = 8 }; void f(int x) __attribute__((diagnose_if(x > LIMIT, \"big\", \"warning\"))); void g(void){ f(9); f(8); f(LIMIT + 1); }\n")-1,
sizeof("void a(void) __attribute__((diagnose_if(1, \"always\", \"warning\")));\n"
                  "void (*p)(void) = a;\n")-1,
sizeof("void f(long long x) __attribute__((diagnose_if(x > 4000000000LL, \"huge\", \"warning\")));\n"
                  "void g(void){ f(5000000000LL); f(1); }\n")-1,
sizeof("void f(int x) __attribute__((diagnose_if((1 << x) > 100, \"shift\", \"warning\")));\n"
                  "void g(void){ f(10); f(40); f(-1); f(2); }\n")-1,
sizeof("void f(int a, int b) __attribute__((diagnose_if((a + b) * 2 > 10 || (a ^ b) == 7, \"mix\", \"warning\")));\n"
                  "void g(void){ f(3, 3); f(3, 4); f(1, 1); f(-5, 2); }\n")-1,
sizeof("void m(int x) __attribute__((diagnose_if(x > 0, \"w1\", \"warning\"), diagnose_if(x > 1, \"w2\", \"warning\")));\n"
                  "void m(int x) __attribute__((diagnose_if(x > 2, \"w3\", \"warning\")));\n"
                  "void r(void) __attribute__((diagnose_if(1, \"u1\", \"warning\"), diagnose_if(1, \"u2\", \"warning\")));\n"
                  "void a(void) __attribute__((diagnose_if(1, \"always\", \"warning\")));\n"
                  "void a(void) { a(); }\n"
                  "int h(void) { m(3); m(1); r(); void (*w)(void) = r; (void)w; (void)sizeof(a); __typeof__(a) *p = 0; (void)p; (void)_Generic(a, default: 1); return 0; }\n")-1,
sizeof("void f(int x) __attribute__((diagnose_if(x + 1 > 0, \"ovf\", \"warning\")));\n"
                  "void g(void) { f(2147483647); f(1); }\n")-1,
sizeof("void f(int, int y) __attribute__((diagnose_if(y > 1, \"second\", \"warning\")));\n"
                  "void g(void) { f(5, 2); f(5, 0); }\n")-1,
sizeof("#pragma clang diagnostic ignored \"-Wuser-defined-warnings\"\n"
                  "void f(int x) __attribute__((diagnose_if(x > 1, \"big\", \"warning\")));\n"
                  "void g(void){ f(2); }\n")-1,
sizeof("void f8(int x);\n"
                  "void f8(int y) __attribute__((diagnose_if(y == 3, \"redecl\", \"warning\")));\n"
                  "void f8(int z);\n"
                  "void h(void){ f8(3); f8(2); }\n")-1,
sizeof("void f9(int *p) __attribute__((diagnose_if(p == 0, \"null\", \"warning\")));\n"
                  "void f10(double d) __attribute__((diagnose_if(d > 1.5, \"dbl\", \"warning\")));\n"
                  "void f11(int x) __attribute__((diagnose_if(sizeof(x) == 4 && x == 1, \"sz\", \"warning\")));\n"
                  "void f12(unsigned x) __attribute__((diagnose_if(x > -1, \"u\", \"warning\")));\n"
                  "void f14(int x) __attribute__((diagnose_if(x ? x / 2 == 3 : -x == 1, \"cond\", \"warning\")));\n"
                  "void f15(int x) __attribute__((diagnose_if((unsigned char)x == 1, \"cast\", \"warning\")));\n"
                  "void f16(int x) __attribute__((diagnose_if(x != 0 && 10 / x == 5, \"div\", \"warning\")));\n"
                  "void f17(char *p) __attribute__((diagnose_if(!p, \"notp\", \"warning\")));\n"
                  "void h(int n){ f9(0); f9(&n); f10(2.0); f10(1); f11(1); f12(5); f14(6); f14(-1); f14(2); f15(257); f15(2); f16(0); f16(2); f17((void*)0); f17(0); }\n")-1,
sizeof("int v __attribute__((diagnose_if(1, \"var\", \"warning\")));\n")-1,
sizeof("void v(int x, ...) __attribute__((diagnose_if(x > 2, \"var\", \"warning\"))); void c(void) { v(3); v(3, 1, 2); v(1, 5); }\n")-1,
sizeof("int glob;\n"
                  "void helper(void) {}\n"
                  "void f1(char *p) __attribute__((enable_if(p != 0, \"nonnull\")));\n"
                  "void f3(void (*fp)(void)) __attribute__((enable_if(fp != 0, \"nn\")));\n"
                  "void f4(int *p) __attribute__((enable_if(p != 0, \"nonnull\")));\n"
                  "void d(int *p) __attribute__((diagnose_if(p != 0, \"nonnull arg\", \"warning\")));\n"
                  "void h(void) { int local; f1(\"lit\"); f3(helper); f4(&glob); d(&glob); d(0); f4(&local); }\n")-1,
sizeof("int g;\n"
                  "void f(int x) __attribute__((enable_if(x > 0 && g > 0, \"c\")));\n"
                  "void k(int x) __attribute__((enable_if(x > 0 ? g : 1, \"c\")));\n"
                  "void m(int x) __attribute__((diagnose_if(x > 0 || g, \"c\", \"warning\")));\n"
                  "void h(void) { f(0); }\n"
                  "void h2(void) { k(0); }\n"
                  "void h3(void) { m(1); m(0); }\n")-1,
sizeof("int a[4], b;\n"
                  "void f(int *p, int *q) __attribute__((diagnose_if(p == q, \"same\", \"warning\")));\n"
                  "void g(int *p) __attribute__((diagnose_if(!p, \"null\", \"warning\"), diagnose_if(p ? 1 : 0, \"set\", \"warning\")));\n"
                  "void k(const char *s) __attribute__((diagnose_if((const void *)s != 0, \"cast\", \"warning\")));\n"
                  "void h(void) { f(a, &b); f(0, 0); g(a); g(0); k(\"x\"); k(0); }\n")-1,
sizeof("int g;\n"
                  "void m(int x) __attribute__((diagnose_if(x > 0 || g, \"or\", \"warning\")));\n"
                  "void n(int x, int y) __attribute__((diagnose_if(x == 0 || y > 3, \"either\", \"warning\")));\n"
                  "void k(int x) __attribute__((enable_if(x > 0 ? g : 1, \"c\")));\n"
                  "void h(int v) { m(1); m(0); n(0, v); n(1, v); n(v, 5); k(0); }\n")-1,
sizeof("void q(int x) __attribute__((enable_if(x > 0, \"p1\")));\n"
                  "void r(int x) __attribute__((enable_if(x > 0, \"p2\")));\n"
                  "void s(int x);\n"
                  "void g(void (*)(int), void (*)(int));\n"
                  "void f1(int c) { void (*p)(int) = c ? q : r; (void)p; }\n"
                  "void f2(int c) { (void)(c ? r : q); (void)(c ? (q) : (r)); (void)(q ? q : 0); }\n"
                  "void f3(int c) { (void)(q == r); (void)(q, r); (void)(q && r); (void)(q ?: r); }\n"
                  "void f4(int c) { (void)(c ? (c ? q : r) : r); (void)(q == (c ? r : s)); }\n"
                  "void f5(int c) { (void)(&q == &r); (void)(c ? &q : &r); }\n")-1,
sizeof("void q(int x) __attribute__((enable_if(x > 0, \"p1\")));\n"
                  "void r(int x) __attribute__((enable_if(x > 0, \"p2\")));\n"
                  "void s(int x);\n"
                  "void g(void (*)(int), void (*)(int));\n"
                  "void f6(int c) { g(q, r); g(s, q); }\n"
                  "void f7(int c) { q; r; }\n"
                  "void f8(int c) { (void)((q == s) + (r == s)); (void)((s == q) == r); }\n"
                  "void f9(int c) { (void)(c ? q : r) == (c ? r : q); }\n")-1,
sizeof("void q(int x) __attribute__((enable_if(x > 0, \"p1\")));\n"
                  "void r(int x) __attribute__((enable_if(x > 0, \"p2\")));\n"
                  "void s(int x);\n"
                  "struct P { void (*a)(int); void (*b)(int); };\n"
                  "void f1(int c) { void (*a[2])(int) = { q, r }; (void)a; }\n"
                  "void f2(int c) { void (*a[2])(int) = { q, c ? r : s }; (void)a; }\n"
                  "void f3(int c) { struct P p = { .a = q, .b = c ? r : s }; (void)p; }\n"
                  "void f4(int c) { struct P p[2] = { { q, s }, { c ? s : r, s } }; (void)p; }\n")-1,
sizeof("void q(int x) __attribute__((enable_if(x > 0, \"p1\")));\n"
                  "void r(int x) __attribute__((enable_if(x > 0, \"p2\")));\n"
                  "void f(int c) { (void)sizeof(q == r); (void)sizeof(&q); (void)sizeof((q)); (void)sizeof q; (void)sizeof(q, r); }\n"
                  "void h(int c) { __typeof__(c ? q : r) *p = 0; (void)p; (void)__alignof__(q); (void)_Generic(q, default: 0); }\n")-1,
sizeof("void f(int x) __attribute__((diagnose_if(x > 0, \"shadowed\", \"warning\", \"shadow\")));\n"
                  "void h(int x) __attribute__((diagnose_if(x > 0, \"formatted\", \"error\", \"format\")));\n"
                  "void u(int x) __attribute__((diagnose_if(x > 0, \"plain\", \"warning\")));\n"
                  "void a(int x) __attribute__((diagnose_if(x > 0, \"most\", \"warning\", \"all\"), diagnose_if(x > 1, \"unused\", \"warning\", \"unused-variable\")));\n"
                  "void p(int x) __attribute__((diagnose_if(x > 0, \"pedantic\", \"warning\", \"pedantic\")));\n"
                  "int m(void) { f(1); h(2); u(1); a(2); p(1); f(0); return 0; }\n")-1,
sizeof("void f(int x) __attribute__((diagnose_if(x > 0, \"shadowed\", \"warning\", \"shadow\")));\n"
                  "void h(int x) __attribute__((diagnose_if(x > 0, \"formatted\", \"error\", \"format\")));\n"
                  "void u(int x) __attribute__((diagnose_if(x > 0, \"plain\", \"warning\")));\n"
                  "void a(int x) __attribute__((diagnose_if(x > 0, \"most\", \"warning\", \"all\"), diagnose_if(x > 1, \"unused\", \"warning\", \"unused-variable\")));\n"
                  "void p(int x) __attribute__((diagnose_if(x > 0, \"pedantic\", \"warning\", \"pedantic\")));\n"
                  "int m(void) { f(1); h(2); u(1); a(2); p(1); f(0); return 0; }\n")-1,
sizeof("void f(int x) __attribute__((diagnose_if(x > 0, \"shadowed\", \"warning\", \"shadow\")));\n"
                  "void h(int x) __attribute__((diagnose_if(x > 0, \"formatted\", \"error\", \"format\")));\n"
                  "void u(int x) __attribute__((diagnose_if(x > 0, \"plain\", \"warning\")));\n"
                  "void a(int x) __attribute__((diagnose_if(x > 0, \"most\", \"warning\", \"all\"), diagnose_if(x > 1, \"unused\", \"warning\", \"unused-variable\")));\n"
                  "void p(int x) __attribute__((diagnose_if(x > 0, \"pedantic\", \"warning\", \"pedantic\")));\n"
                  "int m(void) { f(1); h(2); u(1); a(2); p(1); f(0); return 0; }\n")-1,
sizeof("void f(int x) __attribute__((diagnose_if(x > 0, \"shadowed\", \"warning\", \"shadow\")));\n"
                  "void h(int x) __attribute__((diagnose_if(x > 0, \"formatted\", \"error\", \"format\")));\n"
                  "void u(int x) __attribute__((diagnose_if(x > 0, \"plain\", \"warning\")));\n"
                  "void a(int x) __attribute__((diagnose_if(x > 0, \"most\", \"warning\", \"all\"), diagnose_if(x > 1, \"unused\", \"warning\", \"unused-variable\")));\n"
                  "void p(int x) __attribute__((diagnose_if(x > 0, \"pedantic\", \"warning\", \"pedantic\")));\n"
                  "int m(void) { f(1); h(2); u(1); a(2); p(1); f(0); return 0; }\n")-1,
sizeof("void f(int x) __attribute__((diagnose_if(x > 0, \"bounded\", \"warning\", \"array-bounds\")));\n"
                  "void h(int x) __attribute__((diagnose_if(x > 0, \"formatted\", \"error\", \"format\")));\n"
                  "void u(int x) __attribute__((diagnose_if(x > 0, \"plain\", \"warning\")));\n"
                  "void a(int x) __attribute__((diagnose_if(x > 0, \"most\", \"warning\", \"all\"), diagnose_if(x > 1, \"unused\", \"warning\", \"unused-variable\")));\n"
                  "void p(int x) __attribute__((diagnose_if(x > 0, \"pedantic\", \"warning\", \"pedantic\")));\n"
                  "int m(void) { f(1); h(2); u(1); a(2); p(1); f(0); return 0; }\n")-1,
sizeof("void f(int x) __attribute__((diagnose_if(x > 0, \"shadowed\", \"warning\", \"shadow\")));\n"
                  "void h(int x) __attribute__((diagnose_if(x > 0, \"formatted\", \"error\", \"format\")));\n"
                  "void u(int x) __attribute__((diagnose_if(x > 0, \"plain\", \"warning\")));\n"
                  "void a(int x) __attribute__((diagnose_if(x > 0, \"most\", \"warning\", \"all\"), diagnose_if(x > 1, \"unused\", \"warning\", \"unused-variable\")));\n"
                  "void p(int x) __attribute__((diagnose_if(x > 0, \"pedantic\", \"warning\", \"pedantic\")));\n"
                  "int m(void) { f(1); h(2); u(1); a(2); p(1); f(0); return 0; }\n")-1,
sizeof("void f(int x) __attribute__((diagnose_if(x > 0, \"shadowed\", \"warning\", \"shadow\")));\n"
                  "void h(int x) __attribute__((diagnose_if(x > 0, \"formatted\", \"error\", \"format\")));\n"
                  "void u(int x) __attribute__((diagnose_if(x > 0, \"plain\", \"warning\")));\n"
                  "void a(int x) __attribute__((diagnose_if(x > 0, \"most\", \"warning\", \"all\"), diagnose_if(x > 1, \"unused\", \"warning\", \"unused-variable\")));\n"
                  "void p(int x) __attribute__((diagnose_if(x > 0, \"pedantic\", \"warning\", \"pedantic\")));\n"
                  "int m(void) { f(1); h(2); u(1); a(2); p(1); f(0); return 0; }\n")-1,
sizeof("void f(int x) __attribute__((diagnose_if(x > 0, \"shadowed\", \"warning\", \"shadow\")));\n"
                  "void h(int x) __attribute__((diagnose_if(x > 0, \"formatted\", \"error\", \"format\")));\n"
                  "void u(int x) __attribute__((diagnose_if(x > 0, \"plain\", \"warning\")));\n"
                  "void a(int x) __attribute__((diagnose_if(x > 0, \"most\", \"warning\", \"all\"), diagnose_if(x > 1, \"unused\", \"warning\", \"unused-variable\")));\n"
                  "void p(int x) __attribute__((diagnose_if(x > 0, \"pedantic\", \"warning\", \"pedantic\")));\n"
                  "int m(void) { f(1); h(2); u(1); a(2); p(1); f(0); return 0; }\n")-1,
sizeof("void f(int x) __attribute__((diagnose_if(x > 0, \"bounded\", \"warning\", \"array-bounds\")));\n"
                  "void h(int x) __attribute__((diagnose_if(x > 0, \"formatted\", \"error\", \"format\")));\n"
                  "void u(int x) __attribute__((diagnose_if(x > 0, \"plain\", \"warning\")));\n"
                  "void a(int x) __attribute__((diagnose_if(x > 0, \"most\", \"warning\", \"all\"), diagnose_if(x > 1, \"unused\", \"warning\", \"unused-variable\")));\n"
                  "void p(int x) __attribute__((diagnose_if(x > 0, \"pedantic\", \"warning\", \"pedantic\")));\n"
                  "int m(void) { f(1); h(2); u(1); a(2); p(1); f(0); return 0; }\n")-1,
sizeof("void f(int x) __attribute__((diagnose_if(x > 0, \"shadowed\", \"warning\", \"shadow\")));\n"
                  "void h(int x) __attribute__((diagnose_if(x > 0, \"formatted\", \"error\", \"format\")));\n"
                  "void u(int x) __attribute__((diagnose_if(x > 0, \"plain\", \"warning\")));\n"
                  "void a(int x) __attribute__((diagnose_if(x > 0, \"most\", \"warning\", \"all\"), diagnose_if(x > 1, \"unused\", \"warning\", \"unused-variable\")));\n"
                  "void p(int x) __attribute__((diagnose_if(x > 0, \"pedantic\", \"warning\", \"pedantic\")));\n"
                  "int m(void) { f(1); h(2); u(1); a(2); p(1); f(0); return 0; }\n")-1,
sizeof("void f(int x) __attribute__((diagnose_if(x > 0, \"shadowed\", \"warning\", \"shadow\")));\n"
                  "void h(int x) __attribute__((diagnose_if(x > 0, \"formatted\", \"error\", \"format\")));\n"
                  "void u(int x) __attribute__((diagnose_if(x > 0, \"plain\", \"warning\")));\n"
                  "void a(int x) __attribute__((diagnose_if(x > 0, \"most\", \"warning\", \"all\"), diagnose_if(x > 1, \"unused\", \"warning\", \"unused-variable\")));\n"
                  "void p(int x) __attribute__((diagnose_if(x > 0, \"pedantic\", \"warning\", \"pedantic\")));\n"
                  "int m(void) { f(1); h(2); u(1); a(2); p(1); f(0); return 0; }\n")-1,
sizeof("void f(int x) __attribute__((diagnose_if(x > 0, \"bounded\", \"warning\", \"array-bounds\")));\n"
                  "void h(int x) __attribute__((diagnose_if(x > 0, \"formatted\", \"error\", \"format\")));\n"
                  "void u(int x) __attribute__((diagnose_if(x > 0, \"plain\", \"warning\")));\n"
                  "void a(int x) __attribute__((diagnose_if(x > 0, \"most\", \"warning\", \"all\"), diagnose_if(x > 1, \"unused\", \"warning\", \"unused-variable\")));\n"
                  "void p(int x) __attribute__((diagnose_if(x > 0, \"pedantic\", \"warning\", \"pedantic\")));\n"
                  "int m(void) { f(1); h(2); u(1); a(2); p(1); f(0); return 0; }\n")-1,
sizeof("void f(int x) __attribute__((diagnose_if(x > 0, \"shadowed\", \"warning\", \"shadow\")));\n"
                  "void h(int x) __attribute__((diagnose_if(x > 0, \"formatted\", \"error\", \"format\")));\n"
                  "void u(int x) __attribute__((diagnose_if(x > 0, \"plain\", \"warning\")));\n"
                  "void a(int x) __attribute__((diagnose_if(x > 0, \"most\", \"warning\", \"all\"), diagnose_if(x > 1, \"unused\", \"warning\", \"unused-variable\")));\n"
                  "void p(int x) __attribute__((diagnose_if(x > 0, \"pedantic\", \"warning\", \"pedantic\")));\n"
                  "int m(void) { f(1); h(2); u(1); a(2); p(1); f(0); return 0; }\n")-1,
sizeof("void f(int x) __attribute__((diagnose_if(x > 0, \"shadowed\", \"warning\", \"shadow\")));\n"
                  "void h(int x) __attribute__((diagnose_if(x > 0, \"formatted\", \"error\", \"format\")));\n"
                  "void u(int x) __attribute__((diagnose_if(x > 0, \"plain\", \"warning\")));\n"
                  "void a(int x) __attribute__((diagnose_if(x > 0, \"most\", \"warning\", \"all\"), diagnose_if(x > 1, \"unused\", \"warning\", \"unused-variable\")));\n"
                  "void p(int x) __attribute__((diagnose_if(x > 0, \"pedantic\", \"warning\", \"pedantic\")));\n"
                  "int m(void) { f(1); h(2); u(1); a(2); p(1); f(0); return 0; }\n")-1,
sizeof("void f(int x) __attribute__((diagnose_if(x > 0, \"shadowed\", \"warning\", \"shadow\")));\n"
                  "void h(int x) __attribute__((diagnose_if(x > 0, \"formatted\", \"error\", \"format\")));\n"
                  "void u(int x) __attribute__((diagnose_if(x > 0, \"plain\", \"warning\")));\n"
                  "void a(int x) __attribute__((diagnose_if(x > 0, \"most\", \"warning\", \"all\"), diagnose_if(x > 1, \"unused\", \"warning\", \"unused-variable\")));\n"
                  "void p(int x) __attribute__((diagnose_if(x > 0, \"pedantic\", \"warning\", \"pedantic\")));\n"
                  "int m(void) { f(1); h(2); u(1); a(2); p(1); f(0); return 0; }\n")-1,
sizeof("void f(int x) __attribute__((diagnose_if(x > 0, \"shadowed\", \"warning\", \"shadow\")));\n"
                  "void h(int x) __attribute__((diagnose_if(x > 0, \"formatted\", \"error\", \"format\")));\n"
                  "#pragma clang diagnostic warning \"-Wformat\"\n"
                  "int m(void) { f(1); h(2); return 0; }\n"
                  "#pragma clang diagnostic ignored \"-Wshadow-all\"\n"
                  "int n(void) { f(1); h(2); return 0; }\n"
                  "#pragma clang diagnostic error \"-Wshadow\"\n"
                  "#pragma clang diagnostic ignored \"-Wmost\"\n"
                  "int k(void) { f(1); h(2); return 0; }\n")-1,
sizeof("int g(int);\n"
                  "int h(void);\n"
                  "int abs(int);\n"
                  "void f0(int x) __attribute__((diagnose_if(g(x) > 0, \"c0\", \"warning\")));\n"
                  "void f1(int x) __attribute__((diagnose_if(x > 3 || g(x), \"c1\", \"warning\")));\n"
                  "void f2(int x) __attribute__((diagnose_if(x > 0 && g(1), \"c2\", \"warning\")));\n"
                  "void f3(int x) __attribute__((diagnose_if(x ? g(1) : 1, \"c3\", \"warning\")));\n"
                  "void f4(int x) __attribute__((diagnose_if(g(g(x)), \"c4\", \"warning\")));\n"
                  "void f5(int x) __attribute__((diagnose_if(abs(x) > 3, \"c5\", \"warning\")));\n"
                  "void f6(int x) __attribute__((diagnose_if(x > 0 && (x = 3), \"c6\", \"warning\")));\n"
                  "void f7(int x) __attribute__((diagnose_if(x > 0 || (x = 1), \"c7\", \"warning\")));\n"
                  "void f8(int x) __attribute__((diagnose_if(x > 0 ? x++ : 0, \"c8\", \"warning\")));\n"
                  "void f9(int x) __attribute__((diagnose_if(x > 0 && g(x = 1), \"c9\", \"warning\")));\n"
                  "void k(void) { f0(5); f0(0); f1(5); f1(0); f2(5); f2(0); f3(5); f3(0); f4(5); f4(0); f5(5); f5(0); f6(5); f6(0); f7(5); f7(0); f8(5); f8(0); f9(5); f9(0); }\n")-1,
sizeof("int g(int);\nint h(void);\n"
                  "void f(int x) __attribute__((diagnose_if(x == g(1), \"c\", \"warning\")));\n")-1,
sizeof("int g(int);\nint h(void);\n"
                  "void f(int x) __attribute__((diagnose_if((x += 1) > 2, \"c\", \"warning\")));\n")-1,
sizeof("int g(int);\nint h(void);\n"
                  "void f(int x) __attribute__((diagnose_if(--x > 2, \"c\", \"warning\")));\n")-1,
sizeof("int g(int);\nint h(void);\n"
                  "void f(int x) __attribute__((diagnose_if(x++ > 3, \"c\", \"warning\")));\n")-1,
sizeof("int g(int);\nint h(void);\n"
                  "void f(int x) __attribute__((diagnose_if(g(x = 1), \"c\", \"warning\")));\n")-1,
sizeof("int g(int);\nint h(void);\n"
                  "void f(int x) __attribute__((diagnose_if((x++, 1), \"c\", \"warning\")));\n")-1,
sizeof("int g(int);\nint h(void);\n"
                  "void f(int x) __attribute__((diagnose_if(h(), \"c\", \"warning\")));\n")-1,
sizeof("int g(int);\nint h(void);\n"
                  "void f(int x) __attribute__((diagnose_if(g(1) > 0, \"c\", \"warning\")));\n")-1,
sizeof("void f(int x) __attribute__((diagnose_if((x, x > 1), \"big\", \"warning\")));\n"
                  "void g(int x) __attribute__((enable_if((1, x), \"e\")));\n"
                  "void h(int x) __attribute__((diagnose_if((x + 1, 2, x > 1), \"big\", \"error\")));\n"
                  "void k(void) { f(2); g(1); h(0); }\n")-1,
sizeof("void a(int x) __attribute__((diagnose_if((x == 1, x), \"m\", \"warning\")));\n"
                  "void b(int x) __attribute__((diagnose_if((x < 1, x), \"m\", \"warning\")));\n"
                  "void d(int x) __attribute__((diagnose_if((-x, x), \"m\", \"warning\")));\n"
                  "void e(int x) __attribute__((diagnose_if((x ? 1 : 2, x), \"m\", \"warning\")));\n"
                  "void f(int x) __attribute__((diagnose_if((sizeof x, x), \"m\", \"warning\")));\n"
                  "void g(int x) __attribute__((diagnose_if(((long)x, x), \"m\", \"warning\")));\n"
                  "void h(int x) __attribute__((diagnose_if((x && 1, x), \"m\", \"warning\")));\n"
                  "void i(int x) __attribute__((diagnose_if((0, x), \"m\", \"warning\")));\n"
                  "void j(int x) __attribute__((diagnose_if((1, 2), \"m\", \"warning\")));\n"
                  "void k(int x) __attribute__((diagnose_if(((x, 1), x), \"m\", \"warning\")));\n"
                  "void l(int x) __attribute__((diagnose_if(((x, 0), x > 1), \"m\", \"warning\")));\n"
                  "void m(int x) __attribute__((diagnose_if((x != 1, x), \"m\", \"warning\")));\n"
                  "void n(int x) __attribute__((enable_if((x, 1), \"m\")));\n"
                  "void o(int x) __attribute__((diagnose_if((x ? 1 : x++, x), \"m\", \"warning\")));\n")-1,
sizeof("int c __attribute__((aligned((7, 8))));\n")-1,
sizeof("int f(int a) __attribute__((overloadable, enable_if(a > 0, \"positive\")));\n"
                  "char f(long a) __attribute__((overloadable));\n"
                  "_Static_assert(sizeof(f(1)) == 4, \"enabled\");\n"
                  "_Static_assert(sizeof(f(-1)) == 1, \"disabled\");\n"
                  "void t(int x) { (void)f(x); }\n")-1,
sizeof("int g(int a) __attribute__((overloadable, enable_if(a > 0, \"pos\")));\n"
                  "int g(int a, int b) __attribute__((overloadable));\n"
                  "void t(int x) { g(1); g(-1); g(x); g(); g(1, 2, 3); }\n")-1,
sizeof("int v(int a, ...) __attribute__((overloadable, enable_if(a > 1, \"\")));\n"
                  "int v(int a, int b, int c) __attribute__((overloadable));\n"
                  "void t(void) { v(); v(2, 3); v(0, 1); }\n")-1,
sizeof("int m(int a, long x) __attribute__((overloadable, enable_if(a > 0, \"a\")));\n"
                  "int m(int a, long x) __attribute__((overloadable, enable_if(a > 0, \"a\")));\n"
                  "char m(int b, long long y) __attribute__((overloadable, enable_if(b > 0x0, \"b\"), enable_if(b < 9, \"c\")));\n"
                  "_Static_assert(sizeof(m(1, 0)) == 1, \"more\");\n"
                  "_Static_assert(sizeof(m(10, 0)) == 4, \"fewer\");\n")-1,
sizeof("#define ONE 1\n"
                  "int g1(int a, long x) __attribute__((overloadable, enable_if(a > (1), \"\"), enable_if(a < 9, \"\")));\n"
                  "char g1(int b, long long y) __attribute__((overloadable, enable_if(b > 1, \"\")));\n"
                  "int g2(int a, long x) __attribute__((overloadable, enable_if(a > 1L, \"\"), enable_if(a < 9, \"\")));\n"
                  "char g2(int b, long long y) __attribute__((overloadable, enable_if(b > ONE, \"\")));\n"
                  "int g3(long a) __attribute__((overloadable, enable_if(a > 0, \"\"), enable_if(a < 9, \"\")));\n"
                  "char g3(unsigned long a) __attribute__((overloadable, enable_if(a > 0, \"\")));\n"
                  "int g4(int a) __attribute__((overloadable, enable_if(a > 0, \"\"), enable_if(a < 9, \"\")));\n"
                  "int g4(int a) __attribute__((overloadable, enable_if(a < 9, \"\"), enable_if(a > 0, \"\")));\n"
                  "void t(void) { g1(3, 0); g2(3, 0); g3(1); g4(4); g4(10); }\n")-1,
sizeof("int n(int a) __attribute__((overloadable, enable_if(a > 0, \"a\")));\n"
                  "int n(int a) __attribute__((overloadable));\n"
                  "int n(int a) __attribute__((overloadable, enable_if(a > 0, \"a\")));\n"
                  "int n(int a) __attribute__((overloadable, enable_if(a > 0, \"a\"))) { return a; }\n"
                  "int h(int a) __attribute__((overloadable, enable_if(a > 0, \"a\")));\n"
                  "int h(int a) __attribute__((overloadable, enable_if(a < 10, \"b\")));\n"
                  "void t(void) { n(1); n(-1); h(30); h(-1); h(5); }\n")-1,
sizeof("int f(int n) __attribute__((enable_if(n < 100, \"small\")));\n"
                  "int f(int n);\n"
                  "int f(double d) __attribute__((overloadable, diagnose_if(d == 8.0, \"dbl\", \"warning\")));\n"
                  "void t(void) { f(8); }\n")-1,
sizeof("long w(long a) __attribute__((overloadable));\n"
                  "long w(unsigned long a) __attribute__((overloadable));\n"
                  "long w(long long a) __attribute__((overloadable));\n"
                  "void t(void) { w(1); }\n")-1,
sizeof("#define OV __attribute__((overloadable))\n"
                  "struct S { int x; };\n"
                  "int f(int a) OV;\n"
                  "int f(int *a, int b) OV;\n"
                  "void g(struct S s) { f(s); }\n")-1,
sizeof("#define OV __attribute__((overloadable))\n"
                  "struct S { int x; };\n"
                  "struct T { int y; };\n"
                  "int f(int a) OV;\n"
                  "int f(struct T t, int b) OV;\n"
                  "int f(int a, int b, int c) OV;\n"
                  "void g(struct S s, long *lp) { f(s); f(s, 1); f(1, s); f(s, s); }\n"
                  "int h(long *a) OV;\n"
                  "int h(struct T t) OV;\n"
                  "void k(int i) { h(i); h(1.5); }\n")-1,
sizeof("#define OV __attribute__((overloadable))\n"
                  "int f(int a) OV __attribute__((enable_if(a > 0, \"pos\")));\n"
                  "int f(double a) OV;\n"
                  "int f(int a, int b) OV;\n"
                  "long f(char *s) OV;\n"
                  "int (*p)(int) = f;\n"
                  "void g(void) { int (*q)(long) = f; q = f; (void)q; }\n"
                  "int (*r)(int) = &f;\n")-1,
sizeof("#define OV __attribute__((overloadable))\n"
                  "int f(double a) OV;\n"
                  "int f(char a) OV;\n"
                  "void take(int (*)(int));\n"
                  "void take2(int (*q)(int), int);\n"
                  "int (*ret(void))(int) { return f; }\n"
                  "void g(void) { take(f); take2(&f, 1); }\n"
                  "struct T { int y; };\n"
                  "int h(long *a) OV;\n"
                  "int h(struct T t) OV;\n"
                  "void k(int *ip) { h(ip); }\n")-1,
sizeof("long fc(char*);\n"
                  "int (*p)(int) = fc;\n"
                  "#define OV __attribute__((overloadable))\n"
                  "int f(int a) OV __attribute__((enable_if(a > 0, \"pos\")));\n"
                  "int f(double a) OV;\n"
                  "int (*p2)(int) = f;\n"
                  "int g(double a) OV;\n"
                  "int g(char a) OV;\n"
                  "int (*p3)(int) = g;\n"
                  "long h(double a) OV;\n"
                  "long h(char a) OV;\n"
                  "int (*p4)(int) = h;\n")-1,
sizeof("#define OV __attribute__((overloadable))\n"
                  "long h(int a) OV;\n"
                  "int h(int a, ...) OV;\n"
                  "int h(int a, int b) OV;\n"
                  "int (*p4)(int) = h;\n"
                  "void (*p5)(int) = h;\n")-1,
sizeof("int k(int a) __attribute__((overloadable, diagnose_if(1, \"always\", \"warning\"), diagnose_if(a > 1, \"dep\", \"warning\")));\n"
                  "int k(double a) __attribute__((overloadable, diagnose_if(a > 5, \"bigd\", \"error\")));\n"
                  "int (*p)(int) = k;\n"
                  "void t(void) { k(2); k(6.0); k(1.0); int (*q)(double) = k; (void)q; }\n")-1,
sizeof("int r(int a) __attribute__((overloadable, enable_if(a > 0, \"e\"), diagnose_if(a > 1, \"one\", \"warning\")));\n"
                  "int r(int a) __attribute__((overloadable, enable_if(a > 0, \"e\"), diagnose_if(a > 2, \"two\", \"warning\")));\n"
                  "int r(double a) __attribute__((overloadable));\n"
                  "void t(void) { r(5); r(-5); }\n")-1,
sizeof("int p1(int *p) __attribute__((overloadable, enable_if(p != 0, \"nn\")));\n"
                  "int p1(int *p, int n) __attribute__((overloadable));\n"
                  "int e1(int *p) __attribute__((enable_if(p != 0, \"nn\")));\n"
                  "int x, arr[4]; int *g;\n"
                  "void t(int *q) { p1(&x); p1(arr); p1(0); p1(q); p1(g); p1((int *)0); e1(&x); e1(q); e1(g); }\n")-1,
sizeof("void *f(void *p __attribute__((pass_object_size(0))), unsigned long n)\n"
                  "    __attribute__((diagnose_if(zz, \"always\", \"warning\")));\n"
                  "void *f2(void *p __attribute__((pass_object_size(0))), unsigned long n)\n"
                  "    __attribute__((diagnose_if(1, \"always\", \"warning\")));\n"
                  "void g(void) { char b[4]; f2(b, 8); }\n")-1,
sizeof("#define OV __attribute__((overloadable))\n"
                  "void *f(void *p __attribute__((pass_object_size(0))), unsigned long n) __attribute__((enable_if(n < 100, \"small\")));\n"
                  "int g(int *p __attribute__((pass_object_size(1))), int k) OV __attribute__((enable_if(k > 0, \"pos\")));\n"
                  "int g(int *p, int k) OV;\n"
                  "int h(char *p __attribute__((pass_object_size(0))), int k) __attribute__((diagnose_if(k == 3, \"three\", \"warning\"), diagnose_if(k == 4, \"four\", \"error\")));\n"
                  "void t(void) { char b[4]; int i[2]; f(b, 8); f(b, 200); g(i, 1); g(i, 0); h(b, 3); h(b, 4); h(b, 5); (void)&f; }\n")-1,
sizeof("void *f(void *p __attribute__((pass_object_size(0))), unsigned long n) __attribute__((enable_if(n < 100, \"small\")));\n"
                  "char gb[4];\n"
                  "int h(char *p __attribute__((pass_object_size(0))), int k) __attribute__((enable_if(k == 3, \"three\")));\n"
                  "int h2(int k, char *p __attribute__((pass_object_size(0)))) __attribute__((enable_if(k == 3, \"three\")));\n"
                  "void t(char *q) { char b[4]; f(0, 8); f(gb, 8); f(&gb[1], 8); f(q, 8); h(b, 3); h(gb, 3); h2(3, b); }\n")-1
};
static const CheckDriverDefaultWarningFixture fixture_12[] =
{
    {
        // At the `?`, naming both arms' types as written (a typedef's, an array's or a string's decayed pointer, function
        // pointers, records), a GNU `?:`'s left arm its condition; nested, parenthesized and through a macro.
        .name = "conditional pointer mismatches",
        .source = "int *p; long *q; int arr[3]; long larr[2];\n"
                  "void g(void) { void *r = 1 ? p : q; (void)r; }\n"
                  "typedef int I; I *pi; const char *cc; unsigned *u;\n"
                  "void h(int c) { (void)(c ? pi : q); (void)(c ? cc : u); (void)(c ? (p) : (q + 1)); }\n"
                  "void (*f1)(void); void (*f2)(int);\n"
                  "void k(int c) { (void)(c ? f1 : f2); (void)(c ?: q); }\n"
                  "struct S { int a; } *sp; union U { int b; } *up;\n"
                  "void m(int c) { (void)(c ? sp : up); (void)(c ? arr : larr); (void)(c ? \"x\" : q); (void)(c ? (c ? p : q) : q); }\n"
                  "#define SEL(c, a, b) ((c) ? (a) : (b))\n"
                  "void n(int c, int i) { (void)SEL(c, p, q); (void)(c ? i : p); (void)(c ? p : 1L); }\n",
        .warnings = 13,
        .notes = 1,
    },
    {
        // At file scope, before the initializer's own error.
        .name = "a file-scope conditional pointer mismatch",
        .source = "int *p; long *q;\n"
                  "void *r1 = 1 ? p : q;\n",
        .warnings = 1,
        .errors = 1,
    },
};
static const size_t fixture_12_lengths[] = {
sizeof("int *p; long *q; int arr[3]; long larr[2];\n"
                  "void g(void) { void *r = 1 ? p : q; (void)r; }\n"
                  "typedef int I; I *pi; const char *cc; unsigned *u;\n"
                  "void h(int c) { (void)(c ? pi : q); (void)(c ? cc : u); (void)(c ? (p) : (q + 1)); }\n"
                  "void (*f1)(void); void (*f2)(int);\n"
                  "void k(int c) { (void)(c ? f1 : f2); (void)(c ?: q); }\n"
                  "struct S { int a; } *sp; union U { int b; } *up;\n"
                  "void m(int c) { (void)(c ? sp : up); (void)(c ? arr : larr); (void)(c ? \"x\" : q); (void)(c ? (c ? p : q) : q); }\n"
                  "#define SEL(c, a, b) ((c) ? (a) : (b))\n"
                  "void n(int c, int i) { (void)SEL(c, p, q); (void)(c ? i : p); (void)(c ? p : 1L); }\n")-1,
sizeof("int *p; long *q;\n"
                  "void *r1 = 1 ? p : q;\n")-1
};
#define BUSTER_CHECK_DEFAULT_ERROR_BODIES \
    "void take(char *p);\n" \
    "int *f(long x, int *q)\n" \
    "{\n" \
    "    int *p = x; char *c = p; void (*fp)(int) = (void (*)(void))0;\n" \
    "    (void)c; (void)fp; p = 3; take(q); return x;\n" \
    "}\n" \
    "void g(void) { return 1; }\n" \
    "int h(void) { return; }\n"
#define BUSTER_CHECK_PARENTHESIZED_ARGUMENT_BODIES \
    "void take(int *p, char *c);\n" \
    "int nested(char *c);\n" \
    "void f(long *l, unsigned char *u, int i) { take((i << 40, l), (nested(u), u)); }\n"
static const CheckDriverDefaultWarningFixture fixture_13[] =
{
    {
        // Each group demoted: an initializer's, an assignment's, an argument's (with its parameter's note) and a return's
        // conversion, a function pointer's, and both -Wreturn-mismatch cases.
        .name = "default-error conversions demoted",
        .source = BUSTER_CHECK_DEFAULT_ERROR_BODIES,
        .options = { "-Wno-error=int-conversion", "-Wno-error=incompatible-pointer-types", "-Wno-error=return-mismatch" },
        .warnings = 8,
        .notes = 1,
    },
    {
        // One group demoted (with its function pointers' group under it), the others errors still.
        .name = "default-error conversions, one group demoted",
        .source = BUSTER_CHECK_DEFAULT_ERROR_BODIES,
        .options = { "-Wno-error=incompatible-pointer-types" },
        .warnings = 3,
        .errors = 5,
        .notes = 1,
    },
    {
        // Ignored and demoted through the groups that hold them: -Wconversion, -Wnon-gcc, -Wreturn-type and -Wall.
        .name = "default-error conversions through their parent groups",
        .source = BUSTER_CHECK_DEFAULT_ERROR_BODIES,
        .options = { "-Wno-error=non-gcc", "-Wno-incompatible-function-pointer-types", "-Wno-all" },
        .warnings = 3,
        .errors = 2,
        .notes = 1,
    },
    {
        .name = "default-error conversions ignored",
        .source = BUSTER_CHECK_DEFAULT_ERROR_BODIES,
        .options = { "-Wno-int-conversion", "-Wno-error=return-type" },
        .warnings = 2,
        .errors = 3,
        .notes = 1,
    },
    {
        // File-scope and local initializers, braced, nested and a compound literal's, of each group.
        .name = "default-error conversions in initializers",
        .source = "int g0;\n"
                  "int *gp = 5;\n"
                  "char *gc = &g0;\n"
                  "struct S { int *m; long n; } s = { 7, &g0 };\n"
                  "long arr[2] = { &g0, 0 };\n"
                  "void f(int *q)\n"
                  "{\n"
                  "    struct S t = { q, q };\n"
                  "    char *u[] = { q, 0 };\n"
                  "    int *w = (int *[]){ 3 }[0];\n"
                  "    (void)t; (void)u; (void)w;\n"
                  "}\n",
        .options = { "-Wno-error=int-conversion", "-Wno-error=incompatible-pointer-types" },
        .warnings = 8,
    },
    {
        // A call's demoted arguments among its other conversion warnings, in its arguments' order (#2481).
        .name = "default-error conversions among a call's warnings",
        .source = "void t(char *a, int *b, char *c);\n"
                  "void f(const char *x, char *y, long z) { t(x, z, x); t(y, (char *)0, x); }\n",
        .options = { "-Wno-error=int-conversion", "-Wno-error=incompatible-pointer-types" },
        .warnings = 5,
        .notes = 5,
    },
    {
        // The conversion applies to the whole parenthesized argument (#2521), while its inner call, shift and comma
        // retain their own diagnostic locations and completion order.
        .name = "parenthesized arguments' conversions and inner expressions",
        .source = BUSTER_CHECK_PARENTHESIZED_ARGUMENT_BODIES,
        .warnings = 4,
        .errors = 1,
        .notes = 3,
    },
    {
        // Repeated groups, the ordinary unparenthesized control, a group around only the first operand and a cast.
        // Each call has one incompatible pointer and one signedness warning, with its parameter's note.
        .name = "nested and partial argument parentheses",
        .source = "void take(int *p, char *c);\n"
                  "void f(long *l, unsigned char *u) { take((((l))), (((u)))); take(l, u); take((0) + l, (unsigned char *)u); }\n",
        .warnings = 3,
        .errors = 3,
        .notes = 6,
    },
    {
        // Source parentheses outside an identity macro keep their own locations. An indirect call has no parameter
        // notes, and its const-pointer warning uses the same whole-argument beginning as its incompatible pointer.
        .name = "parenthesized macro and indirect-call arguments",
        .source = "#define ID(x) x\n"
                  "void take(int *p, char *c);\n"
                  "void f(void (*fp)(int *, char *), long *l, unsigned char *u, const char *c) "
                  "{ take((ID(l)), (ID(u))); fp((((l))), (((c)))); }\n",
        .warnings = 2,
        .errors = 2,
        .notes = 2,
    },
    {
        // The relaxed conversion's warning keeps the same opening token and place among the call's warnings.
        .name = "parenthesized argument conversions demoted",
        .source = BUSTER_CHECK_PARENTHESIZED_ARGUMENT_BODIES,
        .options = { "-Wno-error=incompatible-pointer-types" },
        .warnings = 5,
        .notes = 3,
    },
    {
        // Mapping the groups by source pragma changes severity and visibility, retaining the same argument locations.
        .name = "parenthesized argument conversions' pragmas",
        .source = "void take(int *p, char *c);\n"
                  "#pragma clang diagnostic push\n"
                  "#pragma clang diagnostic warning \"-Wincompatible-pointer-types\"\n"
                  "void f(long *l, unsigned char *u) { take(((l)), ((u))); }\n"
                  "#pragma clang diagnostic ignored \"-Wpointer-sign\"\n"
                  "void g(long *l, unsigned char *u) { take(((l)), ((u))); }\n"
                  "#pragma clang diagnostic pop\n"
                  "void h(long *l, unsigned char *u) { take(((l)), ((u))); }\n",
        .warnings = 4,
        .errors = 1,
        .notes = 5,
    },
    {
        // Pragmas: a group's warning, ignored and error, and push and pop.
        .name = "default-error conversions' pragmas",
        .source = "#pragma clang diagnostic push\n"
                  "#pragma clang diagnostic warning \"-Wint-conversion\"\n"
                  "int *a(long x) { return x; }\n"
                  "#pragma clang diagnostic ignored \"-Wincompatible-pointer-types\"\n"
                  "char *b(int *q) { return q; }\n"
                  "void (*c(void (*p)(void)))(int) { return p; }\n"
                  "#pragma clang diagnostic pop\n"
                  "char *d(int *q) { return q; }\n"
                  "#pragma clang diagnostic error \"-Wint-conversion\"\n"
                  "long e(int *q) { return q; }\n"
                  "#pragma clang diagnostic warning \"-Wreturn-mismatch\"\n"
                  "int r(void) { return; }\n"
                  "void v(void) { return 1; }\n",
        .options = { "-Wno-error=incompatible-pointer-types" },
        .warnings = 4,
        .errors = 1,
    },
};
static const size_t fixture_13_lengths[] = {
sizeof(BUSTER_CHECK_DEFAULT_ERROR_BODIES)-1,
sizeof(BUSTER_CHECK_DEFAULT_ERROR_BODIES)-1,
sizeof(BUSTER_CHECK_DEFAULT_ERROR_BODIES)-1,
sizeof(BUSTER_CHECK_DEFAULT_ERROR_BODIES)-1,
sizeof("int g0;\n"
                  "int *gp = 5;\n"
                  "char *gc = &g0;\n"
                  "struct S { int *m; long n; } s = { 7, &g0 };\n"
                  "long arr[2] = { &g0, 0 };\n"
                  "void f(int *q)\n"
                  "{\n"
                  "    struct S t = { q, q };\n"
                  "    char *u[] = { q, 0 };\n"
                  "    int *w = (int *[]){ 3 }[0];\n"
                  "    (void)t; (void)u; (void)w;\n"
                  "}\n")-1,
sizeof("void t(char *a, int *b, char *c);\n"
                  "void f(const char *x, char *y, long z) { t(x, z, x); t(y, (char *)0, x); }\n")-1,
sizeof(BUSTER_CHECK_PARENTHESIZED_ARGUMENT_BODIES)-1,
sizeof("void take(int *p, char *c);\n"
                  "void f(long *l, unsigned char *u) { take((((l))), (((u)))); take(l, u); take((0) + l, (unsigned char *)u); }\n")-1,
sizeof("#define ID(x) x\n"
                  "void take(int *p, char *c);\n"
                  "void f(void (*fp)(int *, char *), long *l, unsigned char *u, const char *c) "
                  "{ take((ID(l)), (ID(u))); fp((((l))), (((c)))); }\n")-1,
sizeof(BUSTER_CHECK_PARENTHESIZED_ARGUMENT_BODIES)-1,
sizeof("void take(int *p, char *c);\n"
                  "#pragma clang diagnostic push\n"
                  "#pragma clang diagnostic warning \"-Wincompatible-pointer-types\"\n"
                  "void f(long *l, unsigned char *u) { take(((l)), ((u))); }\n"
                  "#pragma clang diagnostic ignored \"-Wpointer-sign\"\n"
                  "void g(long *l, unsigned char *u) { take(((l)), ((u))); }\n"
                  "#pragma clang diagnostic pop\n"
                  "void h(long *l, unsigned char *u) { take(((l)), ((u))); }\n")-1,
sizeof("#pragma clang diagnostic push\n"
                  "#pragma clang diagnostic warning \"-Wint-conversion\"\n"
                  "int *a(long x) { return x; }\n"
                  "#pragma clang diagnostic ignored \"-Wincompatible-pointer-types\"\n"
                  "char *b(int *q) { return q; }\n"
                  "void (*c(void (*p)(void)))(int) { return p; }\n"
                  "#pragma clang diagnostic pop\n"
                  "char *d(int *q) { return q; }\n"
                  "#pragma clang diagnostic error \"-Wint-conversion\"\n"
                  "long e(int *q) { return q; }\n"
                  "#pragma clang diagnostic warning \"-Wreturn-mismatch\"\n"
                  "int r(void) { return; }\n"
                  "void v(void) { return 1; }\n")-1
};
static const CheckDriverDefaultWarningFixture fixture_14[] =
{
    {
        // At the main file's last newline, after the preprocessor's own warnings.
        .name = "a unit of directives alone under -pedantic",
        .source = "#define X 1\n#if 0\nint x;\n#endif\n#warning a\n",
        .options = { "-pedantic" },
        .warnings = 3,
        .compare_warning_text = true,
    },
    {
        // At its end where no newline ends it.
        .name = "a unit of a directive without a final newline",
        .source = "#define X 1",
        .options = { "-Wempty-translation-unit" },
        .warnings = 1,
        .compare_warning_text = true,
    },
    {
        .name = "an empty unit",
        .source = "",
        .options = { "-pedantic" },
        .warnings = 1,
        .compare_warning_text = true,
    },
    {
        .name = "an empty unit by default",
        .source = "\n\n",
        .compare_warning_text = true,
    },
};
static const size_t fixture_14_lengths[] = {
sizeof("#define X 1\n#if 0\nint x;\n#endif\n#warning a\n")-1,
sizeof("#define X 1")-1,
sizeof("")-1,
sizeof("\n\n")-1
};
static const char check_driver_enum_mix_source[] =
    "enum E { A, B, A2 = A + 1 }; enum F { C, D, D2 = A | C };\n"
                  "typedef enum { T1, T2 } Tn; enum { U1, U2 }; enum { V1 };\n"
                  "#define MIX(a, b) ((a) + (b))\n"
                  "int g(int);\n"
                  "int f(enum E e, enum F f2, Tn t, double d, float _Complex z, unsigned u, long double ld) {\n"
                  "    int r = 0;\n"
                  "    r += (e + f2) < (A | C);\n"
                  "    r += MIX(e, f2);\n"
                  "    r += sizeof(e * f2);\n"
                  "    r += e < u;\n"
                  "    r += t + e;\n"
                  "    r += U1 + V1;\n"
                  "    r += U1 + e;\n"
                  "    r += e + d;\n"
                  "    r += d * e;\n"
                  "    r += z + e;\n"
                  "    r += e == d;\n"
                  "    d += e;\n"
                  "    d -= A;\n"
                  "    r += (e ? d : B) > 0;\n"
                  "    r += (int)e + f2;\n"
                  "    r += (enum E)f2 + e;\n"
                  "    r += g(e - f2);\n"
                  "    r += e % (f2 ^ A) / C;\n"
                  "    if (0) r += e & f2;\n"
                  "    return r;\n"
                  "    r += e - f2;\n"
                  "}\n"
                  "int h(enum E e, enum F f2) { return e <= f2 && e != C; }\n";
static const char check_driver_enum_forms_source[] =
    "enum E1 { A1, B1 };\n"
    "enum E2 { A2, B2 };\n"
    "struct S { enum E1 a; enum E2 b; };\n"
    "enum E1 f1(void);\n"
    "enum E2 f2(void);\n"
    "int g(struct S s, struct S* p, enum E1* q, enum E2 r[2], int i)\n"
    "{\n"
    "    int x = s.a + s.b;\n"
    "    x += p->a == p->b;\n"
    "    x += f1() | f2();\n"
    "    x += (enum E1)i * (enum E2)i;\n"
    "    x += *q - r[1];\n"
    "    x += (i, *q) < (i, r[0]);\n"
    "    return x + (i ? s.a : s.b);\n"
    "}\n";
static const char check_driver_enum_bounds_source[] =
    "enum E1 { A1, B1 };\n"
    "enum E2 { A2, B2 };\n"
    "int arr[A1 + A2];\n"
    "int s1 = sizeof(char[A1 | A2]);\n"
    "typedef int T[A1 * A2 + 1];\n"
    "enum C { X = A1 + A2, Y = B1 == B2, Z = (A1 < A2) };\n"
    "int f(void) { int local[A1 - A2 + 2]; return sizeof(int[A1 ^ A2 + 1]) + sizeof local; }\n"
    "_Static_assert(A1 + A2 == 0, \"\");\n"
    "struct S { int m[A1 + B2 + 1]; int bf : A1 + B2 + 1; };\n"
    "int c1 = A1 ? A1 : A2;\n"
    "enum D { P = (int)(1.0 + A1) };\n";
static const char check_driver_enum_constants_source[] =
    "typedef enum E1 { A1, B1 } TE1;\n"
    "typedef enum E2 { A2, B2 } TE2;\n"
    "enum { U1, U2 };\n"
    "enum C { X, Y = X + A1, Z = Y | A2, W = (TE1)1 + (TE2)1 };\n"
    "int a1[(A1 < A2) + 1];\n"
    "int a2[1 + (B1 ? A1 : A2)];\n"
    "enum F { Q = (int)(A1 + 2.0f) };\n"
    "int a4[U1 + A1 + 1];\n"
    "int a5[sizeof(typeof(A1 + A2))];\n"
    "_Alignas(4 << (A1 & A2)) int a6;\n"
    "int g(int i) {\n"
    "    switch (i) { case A1 + A2: return 1; }\n"
    "    return sizeof(char[(enum E1)1 * (TE2)1]);\n"
    "}\n"
    "struct S { unsigned bf : (A1 != B2) + 1; };\n";
static const CheckDriverDefaultWarningFixture fixture_15[] =
{
    {
        // #1829: exercise vector chunks and a scalar tail while preserving same-enum and integer fallbacks.
        .name = "enumerator coercion across 9 completed definitions",
        .source = "enum E0 { V0 };\n"
                  "enum E1 { V1 };\n"
                  "enum E2 { V2 };\n"
                  "enum E3 { V3 };\n"
                  "enum E4 { V4 };\n"
                  "enum E5 { V5 };\n"
                  "enum E6 { V6 };\n"
                  "enum E7 { V7 };\n"
                  "enum E8 { V8 };\n"
                  "int f(enum E4 mid, int x) { return (V0 == V8) + (V8 == V0) + (mid == V4) + (x == V8); }\n",
        .warnings = 2,
    },
    {
        .name = "enumerator coercion across 17 completed definitions",
        .source = "enum E0 { V0 };\n"
                  "enum E1 { V1 };\n"
                  "enum E2 { V2 };\n"
                  "enum E3 { V3 };\n"
                  "enum E4 { V4 };\n"
                  "enum E5 { V5 };\n"
                  "enum E6 { V6 };\n"
                  "enum E7 { V7 };\n"
                  "enum E8 { V8 };\n"
                  "enum E9 { V9 };\n"
                  "enum E10 { V10 };\n"
                  "enum E11 { V11 };\n"
                  "enum E12 { V12 };\n"
                  "enum E13 { V13 };\n"
                  "enum E14 { V14 };\n"
                  "enum E15 { V15 };\n"
                  "enum E16 { V16 };\n"
                  "int f(enum E8 mid, int x) { return (V0 == V16) + (V16 == V0) + (V7 == V8) + (mid == V8) + (x == V16); }\n",
        .warnings = 3,
    },
    {
        // The nearest opening definition is an already-closed inner enum for OuterLast and PeerLast.
        // This exercises check_common_enum_coerced's linear fallback, not its binary-search fast path.
        .name = "enumerator coercion with nested definitions and closed inner scopes",
        .source = "enum Outer { OuterFirst = sizeof(enum Inner { InnerOnly }), OuterLast };\n"
                  "enum Peer { PeerFirst = sizeof(enum PeerInner { PeerInnerOnly }), PeerLast };\n"
                  "int f(enum Outer a, enum Peer b) { return (OuterLast == PeerLast) + (a == OuterLast) + (b == PeerLast); }\n",
        .warnings = 1,
    },
    {
        .name = "comparisons of different enumerations warn by default, at their operators",
        .source = check_driver_enum_mix_source,
        .warnings = 3,
    },
    {
        .name = "-Wenum-conversion's arithmetic, bitwise, conditional and floating mixes",
        .source = check_driver_enum_mix_source,
        .options = { "-Wenum-conversion" },
        .warnings = 19,
        .notes = 1,
    },
    {
        .name = "-Wanon-enum-enum-conversion and -Wenum-float-conversion alone",
        .source = check_driver_enum_mix_source,
        .options = { "-Wanon-enum-enum-conversion", "-Wenum-float-conversion" },
        .warnings = 12,
    },
    {
        .name = "-Werror=enum-compare with -Wenum-enum-conversion",
        .source = check_driver_enum_mix_source,
        .options = { "-Werror=enum-compare", "-Wenum-enum-conversion" },
        .warnings = 10,
        .errors = 2,
        .notes = 1,
    },
    {
        .name = "-Wenum-conversion enables its implemented enum diagnostics",
        .source = "enum E { A, B }; enum F { C, D }; enum { X, Y }; typedef enum E TE;\n"
                  "int f(enum E e, enum F g, TE t, float fl, int i) {\n"
                  "    int r = 0;\n"
                  "    r += e + g;\n"
                  "    r += A + C;\n"
                  "    r += e | g;\n"
                  "    r += e < g;\n"
                  "    r += i ? e : g;\n"
                  "    r += e + X;\n"
                  "    r += e + fl > 0;\n"
                  "    r += t + g;\n"
                  "    r += e + t;\n"
                  "    e += g;\n"
                  "    r += (e, g);\n"
                  "    r += A & D;\n"
                  "    r += e * C;\n"
                  "    r += e == g;\n"
                  "    r += e << g;\n"
                  "    return r;\n"
                  "}\n",
        .options = { "-Wenum-conversion" },
        .warnings = 11,
    },
    {
        // Review on #1809: a comparison's operands are rvalues, and a GNU `?:`'s omitted operand is its promoted condition.
        .name = "qualified comparisons and GNU omitted conditional operands",
        .source = "enum E { A, B }; enum F { C, D }; typedef enum E TN; typedef const enum E CNST; typedef enum { X } AN;\n"
                  "int f(const enum E ce, volatile enum E ve, enum F f2, const double cd, const TN ct, CNST cn, volatile float vf, enum E e, double d, const AN an) {\n"
                  "    int r = 0;\n"
                  "    r += ce < f2; r += f2 == ve; r += ce < cd; r += vf > e; r += ct != f2; r += cn <= f2; r += an == f2;\n"
                  "    r += ce + f2; r += ct | f2; r += cd * ce;\n"
                  "    r += e ?: f2; r += e ?: 1.5; r += e ?: d; r += cd ?: e; r += d ?: e; r += A ?: C;\n"
                  "    return r;\n"
                  "}\n",
        .warnings = 5,
    },
    {
        .name = "qualified comparisons and GNU omitted conditional operands under -Wenum-conversion",
        .source = "enum E { A, B }; enum F { C, D }; typedef enum E TN; typedef const enum E CNST; typedef enum { X } AN;\n"
                  "int f(const enum E ce, volatile enum E ve, enum F f2, const double cd, const TN ct, CNST cn, volatile float vf, enum E e, double d, const AN an) {\n"
                  "    int r = 0;\n"
                  "    r += ce < f2; r += f2 == ve; r += ce < cd; r += vf > e; r += ct != f2; r += cn <= f2; r += an == f2;\n"
                  "    r += ce + f2; r += ct | f2; r += cd * ce;\n"
                  "    r += e ?: f2; r += e ?: 1.5; r += e ?: d; r += cd ?: e; r += d ?: e; r += A ?: C;\n"
                  "    return r;\n"
                  "}\n",
        .options = { "-Wenum-conversion", "-Wanon-enum-enum-conversion" },
        .warnings = 12,
    },
    {
        .name = "enumeration mixes of forms, by default",
        .source = check_driver_enum_forms_source,
        .warnings = 4,
    },
    {
        .name = "enumeration mixes of forms under -Wenum-conversion",
        .source = check_driver_enum_forms_source,
        .options = { "-Wenum-conversion", "-Wanon-enum-enum-conversion" },
        .warnings = 9,
    },
    {
        .name = "enumeration mixes of forms under -w",
        .source = check_driver_enum_forms_source,
        .options = { "-w" },
    },
    {
        .name = "enumeration mixes of bounds, by default",
        .source = check_driver_enum_bounds_source,
        .warnings = 2,
    },
    {
        .name = "enumeration mixes of bounds under -Wenum-conversion",
        .source = check_driver_enum_bounds_source,
        .options = { "-Wenum-conversion", "-Wanon-enum-enum-conversion" },
        .warnings = 12,
    },
    {
        .name = "enumeration mixes of bounds under -w",
        .source = check_driver_enum_bounds_source,
        .options = { "-w" },
    },
    {
        .name = "enumeration mixes of constants, by default",
        .source = check_driver_enum_constants_source,
        .warnings = 2,
    },
    {
        .name = "enumeration mixes of constants under -Wenum-conversion",
        .source = check_driver_enum_constants_source,
        .options = { "-Wenum-conversion", "-Wanon-enum-enum-conversion" },
        .warnings = 10,
    },
    {
        .name = "enumeration mixes of constants under -w",
        .source = check_driver_enum_constants_source,
        .options = { "-w" },
    },
    {
        .name = "-Werror=enum-compare in array bounds and bit-field widths",
        .source = check_driver_enum_constants_source,
        .options = { "-Werror=enum-compare" },
        .errors = 2,
    },
    {
        .name = "opposite mappings for unnamed and typedef-named macro enums",
        .source = "#define ENUM(name) enum { name }\n"
                  "enum Named { N };\n"
                  "ENUM(U) untyped;\n"
                  "typedef ENUM(T) Alias;\n"
                  "int f(void) {\n"
                  "#pragma clang diagnostic push\n"
                  "#pragma clang diagnostic ignored \"-Wanon-enum-enum-conversion\"\n"
                  "#pragma clang diagnostic warning \"-Wenum-compare\"\n"
                  "    int result = (N == U) + (N == T);\n"
                  "#pragma clang diagnostic ignored \"-Wenum-compare\"\n"
                  "#pragma clang diagnostic warning \"-Wanon-enum-enum-conversion\"\n"
                  "    result += (N == U) + (N == T);\n"
                  "#pragma clang diagnostic pop\n"
                  "    return result;\n"
                  "}\n",
        .warnings = 2,
    },
    {
        .name = "pragmas map the enumeration warnings at their operators",
        .source = "enum E { A, B }; enum F { C, D };\n"
                  "int f(enum E e, enum F g) {\n"
                  "    int r = e < g;\n"
                  "#pragma clang diagnostic push\n"
                  "#pragma clang diagnostic ignored \"-Wenum-compare\"\n"
                  "    r += e == g;\n"
                  "#pragma clang diagnostic warning \"-Wenum-enum-conversion\"\n"
                  "    r += e + g;\n"
                  "#pragma clang diagnostic pop\n"
                  "    r += e != C;\n"
                  "    r += e + g;\n"
                  "    return r;\n"
                  "}\n",
        .warnings = 3,
    },
};
static const size_t fixture_15_lengths[] = {
sizeof("enum E0 { V0 };\n"
                  "enum E1 { V1 };\n"
                  "enum E2 { V2 };\n"
                  "enum E3 { V3 };\n"
                  "enum E4 { V4 };\n"
                  "enum E5 { V5 };\n"
                  "enum E6 { V6 };\n"
                  "enum E7 { V7 };\n"
                  "enum E8 { V8 };\n"
                  "int f(enum E4 mid, int x) { return (V0 == V8) + (V8 == V0) + (mid == V4) + (x == V8); }\n")-1,
sizeof("enum E0 { V0 };\n"
                  "enum E1 { V1 };\n"
                  "enum E2 { V2 };\n"
                  "enum E3 { V3 };\n"
                  "enum E4 { V4 };\n"
                  "enum E5 { V5 };\n"
                  "enum E6 { V6 };\n"
                  "enum E7 { V7 };\n"
                  "enum E8 { V8 };\n"
                  "enum E9 { V9 };\n"
                  "enum E10 { V10 };\n"
                  "enum E11 { V11 };\n"
                  "enum E12 { V12 };\n"
                  "enum E13 { V13 };\n"
                  "enum E14 { V14 };\n"
                  "enum E15 { V15 };\n"
                  "enum E16 { V16 };\n"
                  "int f(enum E8 mid, int x) { return (V0 == V16) + (V16 == V0) + (V7 == V8) + (mid == V8) + (x == V16); }\n")-1,
sizeof("enum Outer { OuterFirst = sizeof(enum Inner { InnerOnly }), OuterLast };\n"
                  "enum Peer { PeerFirst = sizeof(enum PeerInner { PeerInnerOnly }), PeerLast };\n"
                  "int f(enum Outer a, enum Peer b) { return (OuterLast == PeerLast) + (a == OuterLast) + (b == PeerLast); }\n")-1,
sizeof(check_driver_enum_mix_source)-1,
sizeof(check_driver_enum_mix_source)-1,
sizeof(check_driver_enum_mix_source)-1,
sizeof(check_driver_enum_mix_source)-1,
sizeof("enum E { A, B }; enum F { C, D }; enum { X, Y }; typedef enum E TE;\n"
                  "int f(enum E e, enum F g, TE t, float fl, int i) {\n"
                  "    int r = 0;\n"
                  "    r += e + g;\n"
                  "    r += A + C;\n"
                  "    r += e | g;\n"
                  "    r += e < g;\n"
                  "    r += i ? e : g;\n"
                  "    r += e + X;\n"
                  "    r += e + fl > 0;\n"
                  "    r += t + g;\n"
                  "    r += e + t;\n"
                  "    e += g;\n"
                  "    r += (e, g);\n"
                  "    r += A & D;\n"
                  "    r += e * C;\n"
                  "    r += e == g;\n"
                  "    r += e << g;\n"
                  "    return r;\n"
                  "}\n")-1,
sizeof("enum E { A, B }; enum F { C, D }; typedef enum E TN; typedef const enum E CNST; typedef enum { X } AN;\n"
                  "int f(const enum E ce, volatile enum E ve, enum F f2, const double cd, const TN ct, CNST cn, volatile float vf, enum E e, double d, const AN an) {\n"
                  "    int r = 0;\n"
                  "    r += ce < f2; r += f2 == ve; r += ce < cd; r += vf > e; r += ct != f2; r += cn <= f2; r += an == f2;\n"
                  "    r += ce + f2; r += ct | f2; r += cd * ce;\n"
                  "    r += e ?: f2; r += e ?: 1.5; r += e ?: d; r += cd ?: e; r += d ?: e; r += A ?: C;\n"
                  "    return r;\n"
                  "}\n")-1,
sizeof("enum E { A, B }; enum F { C, D }; typedef enum E TN; typedef const enum E CNST; typedef enum { X } AN;\n"
                  "int f(const enum E ce, volatile enum E ve, enum F f2, const double cd, const TN ct, CNST cn, volatile float vf, enum E e, double d, const AN an) {\n"
                  "    int r = 0;\n"
                  "    r += ce < f2; r += f2 == ve; r += ce < cd; r += vf > e; r += ct != f2; r += cn <= f2; r += an == f2;\n"
                  "    r += ce + f2; r += ct | f2; r += cd * ce;\n"
                  "    r += e ?: f2; r += e ?: 1.5; r += e ?: d; r += cd ?: e; r += d ?: e; r += A ?: C;\n"
                  "    return r;\n"
                  "}\n")-1,
sizeof(check_driver_enum_forms_source)-1,
sizeof(check_driver_enum_forms_source)-1,
sizeof(check_driver_enum_forms_source)-1,
sizeof(check_driver_enum_bounds_source)-1,
sizeof(check_driver_enum_bounds_source)-1,
sizeof(check_driver_enum_bounds_source)-1,
sizeof(check_driver_enum_constants_source)-1,
sizeof(check_driver_enum_constants_source)-1,
sizeof(check_driver_enum_constants_source)-1,
sizeof(check_driver_enum_constants_source)-1,
sizeof("#define ENUM(name) enum { name }\n"
                  "enum Named { N };\n"
                  "ENUM(U) untyped;\n"
                  "typedef ENUM(T) Alias;\n"
                  "int f(void) {\n"
                  "#pragma clang diagnostic push\n"
                  "#pragma clang diagnostic ignored \"-Wanon-enum-enum-conversion\"\n"
                  "#pragma clang diagnostic warning \"-Wenum-compare\"\n"
                  "    int result = (N == U) + (N == T);\n"
                  "#pragma clang diagnostic ignored \"-Wenum-compare\"\n"
                  "#pragma clang diagnostic warning \"-Wanon-enum-enum-conversion\"\n"
                  "    result += (N == U) + (N == T);\n"
                  "#pragma clang diagnostic pop\n"
                  "    return result;\n"
                  "}\n")-1,
sizeof("enum E { A, B }; enum F { C, D };\n"
                  "int f(enum E e, enum F g) {\n"
                  "    int r = e < g;\n"
                  "#pragma clang diagnostic push\n"
                  "#pragma clang diagnostic ignored \"-Wenum-compare\"\n"
                  "    r += e == g;\n"
                  "#pragma clang diagnostic warning \"-Wenum-enum-conversion\"\n"
                  "    r += e + g;\n"
                  "#pragma clang diagnostic pop\n"
                  "    r += e != C;\n"
                  "    r += e + g;\n"
                  "    return r;\n"
                  "}\n")-1
};
static const char check_driver_enum_cast_contexts_source[] =
    "enum E { A, B }; enum F { C, D }; typedef enum E TE; enum { U1 }; typedef enum { T1 } Tn;\n"
                  "struct S { enum E e; enum F f : 2; };\n"
                  "enum E g(enum E);\n"
                  "enum E h(enum F f) {\n"
                  "    enum E e = C;\n"
                  "    enum E e2 = (enum F)0;\n"
                  "    enum F f2 = f;\n"
                  "    e = f;\n"
                  "    e = (f);\n"
                  "    e = 0 ? f : f;\n"
                  "    e = (e, f);\n"
                  "    TE t = f;\n"
                  "    struct S s = { f, e };\n"
                  "    s.e = f;\n"
                  "    g(f);\n"
                  "    e = U1;\n"
                  "    enum E e3 = (enum { V1 })0;\n"
                  "    Tn tn = f;\n"
                  "    e += f;\n"
                  "    e = (enum E)f;\n"
                  "    e = (int)f;\n"
                  "    _Bool bb = f;\n"
                  "    int i = f;\n"
                  "    (void)e2; (void)f2; (void)t; (void)e3; (void)tn; (void)bb; (void)i;\n"
                  "    if (0) e = f;\n"
                  "    return f;\n"
                  "}\n";
static const char check_driver_enum_cast_forms_source[] =
    "enum E { A, B }; enum F { C, D }; typedef enum E TE; typedef enum F TF; typedef enum { T1 } Tn;\n"
                  "enum E ge = C;\n"
                  "TE gt = D;\n"
                  "enum E garr[2] = { C, A };\n"
                  "struct S { enum E e; enum F f; } gs = { C, A };\n"
                  "void take(enum E, enum F);\n"
                  "TE back(enum F f) { return f; }\n"
                  "Tn anon(enum F f) { return f; }\n"
                  "int f(enum E e, TF g, int c) {\n"
                  "    e = c ? (c ? g : C) : D;\n"
                  "    e = (0, 1, g);\n"
                  "    take(g, e);\n"
                  "    take(C, A);\n"
                  "    struct S s = { g, e };\n"
                  "    struct S *p = &(struct S){ g, e };\n"
                  "    enum E arr[] = { g, C, e };\n"
                  "    TE t = g;\n"
                  "    t = C;\n"
                  "    e = (enum F)c;\n"
                  "    e = (enum E)g;\n"
                  "    e += g;\n"
                  "    c = g;\n"
                  "    (void)s; (void)p; (void)arr; (void)t;\n"
                  "#pragma clang diagnostic push\n"
                  "#pragma clang diagnostic ignored \"-Wimplicit-enum-enum-cast\"\n"
                  "    e = g;\n"
                  "#pragma clang diagnostic pop\n"
                  "    if (0) e = g;\n"
                  "    return e = g;\n"
                  "}\n";
static const char check_driver_enum_cast_typedef_source[] =
    "typedef enum { TA, TB } TAnon;\n"
    "typedef enum { UA, UB } UAnon;\n"
    "void f(void){ TAnon a; UAnon u; a = u; u = a; (void)a;(void)u; }\n"
    "void g(void){ TAnon a = UA; UAnon u = TB; (void)a; (void)u; }\n"
    "typedef enum { VA } VAnon, VAlias;\n"
    "VAlias h(UAnon x) { return x; }\n";
static const char check_driver_enum_cast_typedef_aliases_source[] =
    "typedef enum { VA } VAnon, VAlias;\n"
    "typedef VAnon VAlias2;\n"
    "typedef const enum { WA } WAnon, WAlias;\n"
    "typedef struct { int x; } SAnon, SAlias;\n"
    "enum G { GA };\n"
    "void f(enum G g) { VAlias a = g; VAlias2 b = g; VAnon c = g; WAlias w = g; (void)a; (void)b; (void)c; (void)w; }\n"
    "void h(SAlias s) { int *p = s; (void)p; }\n"
    "void k(void) { VAlias2 v = GA; enum G g = v; enum G g2 = VA; (void)g; (void)g2; }\n";
static const char check_driver_enum_cast_qualified_source[] =
    "typedef const struct { int x; } CS, CS2;\n"
    "typedef volatile enum { WA } WAnon;\n"
    "typedef enum { XA } __attribute__((aligned(8))) XAnon;\n"
    "enum G { GA };\n"
    "void h(CS s, CS2 t){ int *p = s; int *q = t; (void)p; (void)q; }\n"
    "void k(WAnon w, XAnon x){ enum G g = w; enum G g2 = x; enum G g3 = WA; enum G g4 = XA; int *p = w; (void)g; (void)g2; (void)g3; (void)g4; (void)p; }\n";
static const char check_driver_enum_cast_aka_source[] =
    "typedef struct { int x; } S, *SP;\n"
    "typedef S *SP2;\n"
    "typedef struct { int y; } *TP, T;\n"
    "void h(SP a, SP2 b, TP c){ int *p = a; int *q = b; int *r = c; (void)p; (void)q; (void)r; }\n";
static const char check_driver_enum_cast_widths_source[] =
    "enum Small : signed char { s0 }; enum Big : short { b0 = 30000, b1 = 5, b2 = -200 }; enum Bigger : int { i0 };\n"
    "enum USmall : unsigned char { u0 };\n"
    "void f1(enum Big x){ enum Small r = x; (void)r; }\n"
    "void f2(void){ enum Small r = b0; (void)r; }\n"
    "void f3(void){ enum Small r = b1; (void)r; }\n"
    "void f4(void){ enum Small r = b2; (void)r; }\n"
    "void f5(void){ enum USmall r = b2; (void)r; }\n"
    "void f6(void){ enum USmall r = b1; (void)r; }\n"
    "void f7(enum Small s){ enum USmall r = s; (void)r; }\n"
    "void f8(enum USmall s){ enum Small r = s; (void)r; }\n"
    "void f9(enum Small s){ enum Big r = s; (void)r; }\n"
    "enum E { A }; enum F { B = -1 }; enum G { C = 0x7fffffff, D = -1 };\n"
    "void g1(void){ enum E e = B; (void)e; }  void g2(enum F f){ enum E e = f; (void)e; }\n"
    "void g3(enum E x){ enum F e = x; (void)e; }  void g4(void){ enum E e = C; (void)e; }\n"
    "enum Big2 : short { b3 = 128, b4 = 255 }; enum UBig : unsigned short { ub = 128 };\n"
    "void h1(void){ enum Small r = b3; (void)r; }\n"
    "void h2(void){ enum Small r = ub; (void)r; }\n"
    "void h3(void){ enum USmall r = b4; (void)r; }\n"
    "struct BF { enum Big x : 4; enum Big y : 9; };\n"
    "void h4(struct BF *p){ enum Small r = p->x; enum Small q = p->y; (void)r; (void)q; }\n"
    "void h5(enum Big x, int c){ enum Small r = c ? b1 : x; (void)r; }\n";
static const char check_driver_enum_cast_locations_source[] =
    "enum E { A }; enum F { B };\n"
    "void f(enum E e, enum F g, int c) {\n"
    "    e = _Generic(c, int: g, default: B);\n"
    "    e = (_Generic(c, int: (g), default: B));\n"
    "    e = (e, g);\n"
    "    e = ((e, g));\n"
    "    e = (((e, g)));\n"
    "    e = ((0, (g)));\n"
    "    e = (c, (e, g));\n"
    "    e = (g);\n"
    "    e = ((g));\n"
    "}\n";
static const char check_driver_enum_cast_leaves_source[] =
    "enum E { A }; enum F { B };\n"
    "enum F hf(void);\n"
    "struct S { enum F f; enum F b : 3; } s, *ps, arr[2];\n"
    "void f(enum E e, enum F g, int c) {\n"
    "    enum F g2 = B;\n"
    "    e = (g2 = g);\n"
    "    e = (g2 += 1);\n"
    "    e = g++;\n"
    "    e = ++g;\n"
    "    e = (enum F)c;\n"
    "    e = hf();\n"
    "    e = ps->f;\n"
    "    e = (ps)->b;\n"
    "    e = arr[c].f;\n"
    "    e = (c, (g2 = g));\n"
    "    e = __builtin_choose_expr(1, g, e);\n"
    "    e = _Generic(c, int: (c, g), default: B);\n"
    "}\n";
static const char check_driver_enum_cast_nested_source[] =
    "enum O { OA = sizeof(enum I { IX, IY }), OB, OC = IY };\n"
    "enum P { PA };\n"
    "void f(enum P p) { p = OB; p = IX; p = OA; p = IY; p = OC; (void)p; }\n"
    "enum Q { QA = sizeof(enum R { RX }) + sizeof(enum S { SX }), QB };\n"
    "void g(enum P p) { p = QB; p = RX; p = SX; p = QA; (void)p; }\n";
static const char check_driver_enum_cast_arm_order_source[] =
    "enum E { A }; enum F { B }; enum G { C };\n"
    "void f(enum E e, enum F g, enum G h, int c, signed char sc, signed char t, _Bool b) {\n"
    "    e = c ? (g = h) : g;\n"
    "    e = c ? g : (g = h);\n"
    "    e = c ? (c ? (g = h) : g) : (g = h);\n"
    "    enum E e2 = c ? (g = h) : (enum F)(h = B);\n"
    "    sc = c ? (t = 300) : 400;\n"
    "    sc = c ? (c ? (t = 301) : 302) : (t = 303, 304);\n"
    "    sc = 1 ? 305 : (t = 306);\n"
    "    sc = 0 ? (t = 307) : 308;\n"
    "    e = c ? (g = h, (sc = 309, g)) : _Generic(c, int: (g = h));\n"
    "    b = c ? (t = 310) : (t = c ? 2 : 3);\n"
    "    if (0) { e = c ? (g = h) : g; sc = c ? (t = 311) : 312; }\n"
    "    (void)e2;\n"
    "}\n"
    "enum E r(int c, enum F g, enum G h, signed char t) { return c ? (g = h) : (t = 313, g); }\n";
static const char check_driver_enum_cast_argument_order_source[] =
    "enum E { A }; enum F { B }; enum G { C };\n"
    "void take(enum E);\n"
    "void take_char(signed char);\n"
    "void take2(enum E, signed char);\n"
    "void takeb(_Bool);\n"
    "void f(int c, enum F g, enum G h, enum E e, signed char t) {\n"
    "    take(c ? (g = h) : g);\n"
    "    take_char(c ? (t = 300) : 400);\n"
    "    take2(c ? g : (g = h), c ? (t = 301) : 302);\n"
    "    take(c ? (c ? (g = h) : g) : (g = h, g));\n"
    "    take_char(1 ? 303 : (t = 304));\n"
    "    takeb(c ? (t = 307) : (t = 308));\n"
    "    take2(c ? g : (c ? (g = h) : g), c ? (t = 309) : 310);\n"
    "    e = _Generic(c, int: c ? (g = h) : g);\n"
    "    take(_Generic(c, int: c ? (g = h) : g));\n"
    "    take(_Generic(c, int: c ? g : g));\n"
    "    if (0) take(c ? (g = h) : g);\n"
    "}\n";
static const char check_driver_enum_cast_macro_arguments_source[] =
    "enum A { A1 }; enum B { B1 };\n"
                  "#define ID(v) v\n"
                  "#define TWO(x, y) x; y\n"
                  "void take(enum A);\n"
                  "enum A r(void) { return ID(B1); }\n"
                  "void f(enum A a) {\n"
                  "    ID(a = B1);\n"
                  "    ID(take(B1));\n"
                  "    take(ID(B1));\n"
                  "    TWO(a = B1, a = ID(B1));\n"
                  "    a = ID(ID(B1));\n"
                  "    a = ID((B1));\n"
                  "    a = (ID(B1));\n"
                  "    enum A arr[1] = { ID(B1) };\n"
                  "    ID(enum A c = B1);\n"
                  "    (void)c;\n"
                  "}\n";
static const char check_driver_enum_cast_macro_forms_source[] =
    "enum A { A1 }; enum B { B1, B2 };\n"
                  "#define ID(v) v\n"
                  "#define B_VAL B1\n"
                  "#define PICK(c, x, y) ((c) ? (x) : (y))\n"
                  "#define INIT(v) { v }\n"
                  "#define ASSIGN(l, r) l = r\n"
                  "void take(enum A);\n"
                  "enum A g(int c) {\n"
                  "    enum A a = ID(B_VAL);\n"
                  "    a = PICK(c, B1, A1);\n"
                  "    a = c ? ID(B1) : ID(B2);\n"
                  "    enum A arr[2] = INIT(B1);\n"
                  "    ASSIGN(a, B1);\n"
                  "    ASSIGN(a, ID(B1));\n"
                  "    ID(enum A arr2[1] = { B1 });\n"
                  "    take(PICK(c, B1, B2));\n"
                  "    (void)arr; (void)arr2;\n"
                  "    return ID(c) ? B1 : A1;\n"
                  "}\n";
static const char check_driver_enum_cast_selection_source[] =
    "enum A { A1, A2 };\n"
                  "enum B { B1, B2 };\n"
                  "enum { C1 };\n"
                  "enum B vb;\n"
                  "void take(enum A);\n"
                  "enum A ret(void) { return _Generic(0, int: B2); }\n"
                  "void f(enum A a, int c)\n"
                  "{\n"
                  "    a = _Generic(1, int: A1);\n"
                  "    a = _Generic(1, int: C1);\n"
                  "    a = _Generic(1, int: 5);\n"
                  "    a = _Generic(1, long: A1, default: B2);\n"
                  "    a = _Generic(1, int: _Generic(2, int: B1));\n"
                  "    a = _Generic(1, int: vb);\n"
                  "    a = c ? _Generic(1, int: B1) : A1;\n"
                  "    take(_Generic(1, int: B1));\n"
                  "    enum A x = _Generic(1, int: (B1));\n"
                  "    enum A y[2] = { _Generic(1, int: B1), A2 };\n"
                  "    a = (_Generic(1, int: B1));\n"
                  "    a = _Generic(1, int: B1, char: A1);\n"
                  "}\n";
static const char check_driver_enum_cast_unnamed_source[] =
    "enum A { A1 };\n"
                  "enum B { B1 };\n"
                  "struct S { enum A a; enum B b; };\n"
                  "enum B gb(void);\n"
                  "void sa(struct S *p, int i) { p->a = p->b; p->a = gb(); p->a = (enum B)i; }\n"
                  "struct S mk(struct S *p) { struct S s = { gb() }; return s; }\n"
                  "void take(enum A);\n"
                  "void call(struct S *p) { take(p->b); }\n";
static const CheckDriverDefaultWarningFixture fixture_16[] =
{
    {
        .name = "initializers, assignments, arms, commas, arguments and returns convert between enumerations",
        .source = check_driver_enum_cast_contexts_source,
        .warnings = 16,
    },
    {
        .name = "file-scope, brace, compound literal and unreachable conversions between enumerations, and pragmas",
        .source = check_driver_enum_cast_forms_source,
        .warnings = 28,
    },
    {
        .name = "-Wno-implicit-enum-enum-cast",
        .source = check_driver_enum_cast_forms_source,
        .options = { "-Wno-implicit-enum-enum-cast" },
        .warnings = 2,
    },
    {
        .name = "-Wenum-conversion holds -Wimplicit-enum-enum-cast",
        .source = check_driver_enum_cast_forms_source,
        .options = { "-Wenum-conversion" },
        .warnings = 28,
    },
    {
        .name = "-Werror=implicit-enum-enum-cast",
        .source = check_driver_enum_cast_forms_source,
        .options = { "-Werror=implicit-enum-enum-cast" },
        .errors = 20,
    },
    {
        .name = "enumerations named only by typedefs",
        .source = check_driver_enum_cast_typedef_source,
        .warnings = 5,
    },
    {
        .name = "typedef aliases of anonymous enumerations and their a.k.a.",
        .source = check_driver_enum_cast_typedef_aliases_source,
        .warnings = 6,
        .errors = 1,
    },
    {
        .name = "a qualified typedef names no anonymous tag, an aligned one does",
        .source = check_driver_enum_cast_qualified_source,
        .warnings = 2,
        .errors = 3,
    },
    {
        .name = "a typedef that spells an anonymous record's definition prints its keyword in an a.k.a.",
        .source = check_driver_enum_cast_aka_source,
        .errors = 3,
    },
    {
        .name = "C23 underlying types: constant and width ranges",
        .source = check_driver_enum_cast_widths_source,
        .warnings = 17,
        .c23 = true,
    },
    {
        .name = "where a selection's, a comma's and a parenthesized leaf report",
        .source = check_driver_enum_cast_locations_source,
        .warnings = 15,
    },
    {
        .name = "where assignments, increments, casts, calls, members and bit-fields report",
        .source = check_driver_enum_cast_leaves_source,
        .warnings = 14,
    },
    {
        .name = "enumerators of definitions nested in an enumerator's value",
        .source = check_driver_enum_cast_nested_source,
        .warnings = 9,
    },
    {
        .name = "conversions in a conditional's arms, in clang's order",
        .source = check_driver_enum_cast_arm_order_source,
        .warnings = 36,
    },
    {
        .name = "conversions in a conditional argument's arms, in clang's order",
        .source = check_driver_enum_cast_argument_order_source,
        .warnings = 35,
    },
    {
        .name = "macro arguments' notes",
        .source = check_driver_enum_cast_macro_arguments_source,
        .warnings = 11,
        .notes = 9,
    },
    {
        .name = "macro arguments' notes in conditionals, initializers and calls",
        .source = check_driver_enum_cast_macro_forms_source,
        .warnings = 11,
        .notes = 11,
    },
    {
        .name = "selections that fold to enumerators",
        .source = check_driver_enum_cast_selection_source,
        .warnings = 10,
    },
    {
        .name = "selections that fold to enumerators in C23",
        .source = check_driver_enum_cast_selection_source,
        .warnings = 10,
        .c23 = true,
    },
    {
        .name = "a unit's enumerations reached only through members, calls and casts",
        .source = check_driver_enum_cast_unnamed_source,
        .warnings = 5,
    },
};
static const size_t fixture_16_lengths[] = {
sizeof(check_driver_enum_cast_contexts_source)-1,
sizeof(check_driver_enum_cast_forms_source)-1,
sizeof(check_driver_enum_cast_forms_source)-1,
sizeof(check_driver_enum_cast_forms_source)-1,
sizeof(check_driver_enum_cast_forms_source)-1,
sizeof(check_driver_enum_cast_typedef_source)-1,
sizeof(check_driver_enum_cast_typedef_aliases_source)-1,
sizeof(check_driver_enum_cast_qualified_source)-1,
sizeof(check_driver_enum_cast_aka_source)-1,
sizeof(check_driver_enum_cast_widths_source)-1,
sizeof(check_driver_enum_cast_locations_source)-1,
sizeof(check_driver_enum_cast_leaves_source)-1,
sizeof(check_driver_enum_cast_nested_source)-1,
sizeof(check_driver_enum_cast_arm_order_source)-1,
sizeof(check_driver_enum_cast_argument_order_source)-1,
sizeof(check_driver_enum_cast_macro_arguments_source)-1,
sizeof(check_driver_enum_cast_macro_forms_source)-1,
sizeof(check_driver_enum_cast_selection_source)-1,
sizeof(check_driver_enum_cast_selection_source)-1,
sizeof(check_driver_enum_cast_unnamed_source)-1
};
static const char check_driver_float_conversions_source[] =
    "typedef float F;\n"
    "typedef double D;\n"
    "typedef const double CD;\n"
    "struct P { float x; F y; double z; };\n"
    "union U { float f; double d; };\n"
    "float take(float, ...);\n"
    "float old();\n"
    "void vf(F);\n"
    "static float ret(D d) { return d; }\n"
    "static long double ret_quad(__float128 q) { return q; }\n"
    "#define SET(a, b) ((a) = (b))\n"
    "#define WRAP(x) (x)\n"
    "static float gf = (float)1.0 + 0.1;\n"
    "static struct P gp = { 0.1, 0.25, 0.1L };\n"
    "static float garr[] = { [1] = 0.1, [0] = 1.0 };\n"
    "static struct P gnest[2] = { { 0.5, 0.1 }, { .z = 0.1L } };\n"
    "static double gq = 1.1Q;\n"
    "static _Complex float gz = 0.1 + 0.25i;\n"
    "float use(double d, long double l, F f, D dd, CD cd, volatile double vd, struct P* p, union U u, int i, _Float16 h, __bf16 b, _Complex double z)\n"
    "{\n"
    "    float a = d, c = l;\n"
    "    F e = dd;\n"
    "    float g = cd;\n"
    "    float k = vd;\n"
    "    _Complex float w = z;\n"
    "    p->x = d;\n"
    "    p->y = p->z;\n"
    "    u.f = u.d;\n"
    "    f = take(d, d);\n"
    "    f = old(d);\n"
    "    vf(d);\n"
    "    vf(WRAP(d));\n"
    "    SET(f, d);\n"
    "    f = WRAP(d);\n"
    "    f = ((d));\n"
    "    f = i ? d : l;\n"
    "    f = i ? (d, f) : 0.5;\n"
    "    f = (struct P){ d, 0.1, 0.1 }.x;\n"
    "    f = ({ d; });\n"
    "    f = __builtin_choose_expr(1, d, f);\n"
    "    f = _Generic(i, int: d);\n"
    "    f = p->z;\n"
    "    f = (&d)[0];\n"
    "    f = __builtin_fabs(d);\n"
    "    f = ++d;\n"
    "    f = d++;\n"
    "    f = (d = 0.5);\n"
    "    p->x += d;\n"
    "    p->y -= 1.0;\n"
    "    f *= cd;\n"
    "    f /= 0.5;\n"
    "    h += 1.0;\n"
    "    h *= b;\n"
    "    b /= h;\n"
    "    d -= l;\n"
    "    dd += l;\n"
    "    vd += l;\n"
    "    h = f;\n"
    "    b = h;\n"
    "    f = d > 0 ? 1.0 : 0.1f;\n"
    "    f = 1e39;\n"
    "    f = 1e-50;\n"
    "    f = 0x1p-150;\n"
    "    f = __builtin_nan(\"1\");\n"
    "    f = __builtin_nans(\"\");\n"
    "    f = 1.0 / 3.0;\n"
    "    h = 65520.0;\n"
    "    h = 0.1f16;\n"
    "    b = 1.0078125;\n"
    "    if (0)\n"
    "        f = d;\n"
    "    i = i || (f = d);\n"
    "    return a + c + e + g + k + ret(d) + (float)ret_quad(2.0Q) + __real__ w + f + gp.x + gnest[0].y + garr[0] + gf + (float)gq + __real__ gz;\n"
    "}\n";
static const char check_driver_float_comparisons_source[] =
    "typedef float F;\n"
    "static int a1[(0.1 == 0.1f) + 1];\n"
    "enum E { X = 0.1 != 0.1f, Y = (int)(0.1L == (double)0.1), Z = 0.1 == (double)0.1f };\n"
    "_Static_assert(0.1 != 0.1f, \"\");\n"
    "struct S { unsigned b : (0.1 == 0.1f) + 1; };\n"
    "static int g = sizeof(0.1 == 0.1f);\n"
    "static int h = 0.1f == 0.1 ? 1 : 2;\n"
    "static __typeof__(0.1 == 0.1f) t;\n"
    "int e = 0.1L != 0.1;\n"
    "int k = 0.1q == 0.1;\n"
    "#define EQ(a, b) ((a) == (b))\n"
    "#define TENTH 0.1\n"
    "double g2(void);\n"
    "float g1(void);\n"
    "int f(int i, float x, F y, double d, long double l, __float128 q, _Float16 h16, __bf16 b16, float* p, struct S s)\n"
    "{\n"
    "    int r = a1[0] + g + h + t + e + k + (int)s.b;\n"
    "    switch (i) { case (0.1 == 0.1f): return 1; }\n"
    "    if (0) return x == 0.1;\n"
    "    r += (int)sizeof(char[(0.1 == 0.1f) + 1]) + (int)sizeof(x == 0.1) + (1 || x == 0.1) + _Generic(x == 0.1, int: 0);\n"
    "    r += x == 0.1;\n"
    "    r += 0.1 != x;\n"
    "    r += y == 0.1;\n"
    "    r += *p == 0.1;\n"
    "    r += p[1] != 1e-50;\n"
    "    r += (x) == (0.1);\n"
    "    r += (double)x == 0.1;\n"
    "    r += (double)(float)d == 0.1;\n"
    "    r += (float)d == 0.1;\n"
    "    r += g1() == 0.1;\n"
    "    r += d == 0.1L;\n"
    "    r += l == 0.1q;\n"
    "    r += q == 0.1;\n"
    "    r += 0.1 == h16;\n"
    "    r += 0.1 == b16;\n"
    "    r += h16 == 0.5;\n"
    "    r += x == 1e300;\n"
    "    r += x != 0x1p-150;\n"
    "    r += EQ(x, 0.1);\n"
    "    r += x == TENTH;\n"
    "    r += _Generic(0, int: 0.1) == x;\n"
    "    r += x == 0.5;\n"
    "    r += x == -0.1;\n"
    "    r += x == 0.1f;\n"
    "    r += x < 0.1;\n"
    "    r += i == 0.1;\n"
    "    r += 0.1 == 0.2;\n"
    "    r += d == 0.1;\n"
    "    r += g2() == 0.1;\n"
    "    r += (0.1, x) == 0.1;\n"
    "    return r;\n"
    "}\n";
static const char check_driver_float_controls_source[] =
    "typedef float F;\n"
    "struct P { float x; double y; };\n"
    "static const double half = 0.5;\n"
    "static const double tenth = 0.1;\n"
    "static const struct P exact = { 0.5f, 0.25 };\n"
    "float controls(double d, long double l, float f, _Float16 h, __bf16 b, int i, _Complex double z, struct P* p)\n"
    "{\n"
    "    const double local = 0.25;\n"
    "    _Atomic float af = d;\n"
    "    double w = f;\n"
    "    long double v = d;\n"
    "    float r = (float)d;\n"
    "    F e = (F)l;\n"
    "    float g = 0.5;\n"
    "    float k = -0.0;\n"
    "    float m = 0x1p-149;\n"
    "    float n = 3.4028234663852886e38;\n"
    "    float s = __builtin_inff();\n"
    "    float t = __builtin_inf();\n"
    "    float u = __builtin_nan(\"\");\n"
    "    float q = 0.5 + 0.25;\n"
    "    float c = half;\n"
    "    float c2 = local;\n"
    "    float c3 = exact.y;\n"
    "    _Float16 hh = 0.5f;\n"
    "    __bf16 bb = 1.0;\n"
    "    __fp16 fp = h;\n"
    "    _Complex float cz = 0.5 + 0.25i;\n"
    "    f = (float)d;\n"
    "    f = (short)i;\n"
    "    f += f;\n"
    "    f *= 2;\n"
    "    d += f;\n"
    "    h = (_Float16)f;\n"
    "    b = (__bf16)h;\n"
    "    f = sizeof(f = d);\n"
    "    f = (float)(d + l);\n"
    "    p->x = (float)p->y;\n"
    "    return f + (float)w + (float)v + r + e + g + k + m + n + s + t + u + q + c + c2 + c3 + hh + bb + fp + __real__ cz + af + (float)tenth + (float)__real__ z + b;\n"
    "}\n";
static const char check_driver_float_pragmas_source[] =
    "#define SET(a, b) ((a) = (b))\n"
    "#define NARROW(x) ((float)0 + (x))\n"
    "#define LOSE(x) float lost = x\n"
    "float pragmas(double d, long double l, float f)\n"
    "{\n"
    "    f = d;\n"
    "#pragma clang diagnostic push\n"
    "#pragma clang diagnostic warning \"-Wimplicit-float-conversion\"\n"
    "    f = d;\n"
    "    SET(f, l);\n"
    "    f = NARROW(d);\n"
    "    LOSE(d);\n"
    "    f += lost;\n"
    "    f += d;\n"
    "#pragma clang diagnostic error \"-Wimplicit-float-conversion\"\n"
    "    d = l;\n"
    "#pragma clang diagnostic ignored \"-Wimplicit-float-conversion\"\n"
    "    d = l;\n"
    "#pragma clang diagnostic pop\n"
    "    d = l;\n"
    "#pragma clang diagnostic ignored \"-Wliteral-range\"\n"
    "    f = f == 0.1;\n"
    "#pragma clang diagnostic warning \"-Wliteral-range\"\n"
    "    f = f == 0.1;\n"
    "    return f + d;\n"
    "}\n";
static const char check_driver_float_everything_source[] =
    "typedef float F;\n"
    "static double take(F x);\n"
    "static double take(F x)\n"
    "{\n"
    "    return (double)x;\n"
    "}\n"
    "static int compare(double d, long double l, float f)\n"
    "{\n"
    "    int r = (double)f == 0.1;\n"
    "    r += 0.1L != (long double)d;\n"
    "    r += (double)f != 0.5;\n"
    "    r += (long double)(float)l == 0.1L;\n"
    "    return r;\n"
    "}\n"
    "static float narrow(double d, long double l)\n"
    "{\n"
    "    float f = (float)d;\n"
    "    double e = l;\n"
    "    f = d;\n"
    "    f -= (float)e;\n"
    "    e = (double)l;\n"
    "    e += l;\n"
    "    return f + (float)take(d);\n"
    "}\n"
    "int main(void)\n"
    "{\n"
    "    float n = narrow(1.0, 2.0L);\n"
    "    return compare(1.0, 2.0L, 3.0f) + (n > 0.0f);\n"
    "}\n";
static const char check_driver_float_review_source[] =
    "_Atomic float af;\n"
    "_Atomic double ad;\n"
    "__fp16 gh;\n"
    "int atomic_compare(void)\n"
    "{\n"
    "    _Atomic float *p = &af;\n"
    "    return (af == 0.1) + ((double)af == 0.1) + (0.1 != af) + (af != 0.1f) + (*p == 0.1);\n"
    "}\n"
    "enum { ATOMIC_SIZE = sizeof(af == 0.1) };\n"
    "float compound(float f, _Float16 g, __bf16 b)\n"
    "{\n"
    "    gh += 1;\n"
    "    f += ad;\n"
    "    gh *= g;\n"
    "    gh /= gh;\n"
    "    g += gh;\n"
    "    b *= gh;\n"
    "    return f + g + b;\n"
    "}\n"
    "float commas(double d, int i, float f)\n"
    "{\n"
    "    f = (i, (i, d = 0.5));\n"
    "    f = i ? (0, d = 0.5) : 0.5;\n"
    "    f = (i, 0.5);\n"
    "    f = (0, (i, 0.25));\n"
    "    f = -(d = 0.5);\n"
    "    f = (i, -(d = 0.5));\n"
    "    f = (double)(d = 0.5);\n"
    "    f = (d = 0.5) * 1.0;\n"
    "    f = -(i, 0.5);\n"
    "    f = (d = 1, 0.5);\n"
    "    return f;\n"
    "}\n"
    "typedef double D;\n"
    "_Atomic D atomic_d;\n"
    "float compound_sugar(float f)\n"
    "{\n"
    "    f += atomic_d;\n"
    "    return f;\n"
    "}\n";
static const char check_driver_float_eval_extended_source[] =
    "#pragma clang fp eval_method(extended)\n"
    "float x;\n"
    "enum E { X = 0.1 != 0.1f, Y = 0.5 == 0.1f, Z = sizeof(x == 0.1L) };\n"
    "int f(void) { return (x == 0.1) + (x != 0.1L); }\n";
static const char check_driver_float_eval_double_source[] =
    "#pragma clang fp eval_method(double)\n"
    "float f(float a, float b, __fp16 *h, double d)\n"
    "{\n"
    "    a += b;\n"
    "    a *= 2.0f;\n"
    "    *h += a;\n"
    "    d += a;\n"
    "    return a + d;\n"
    "}\n";
static const char check_driver_float_small_source[] =
    "float small(double d, float f)\n"
    "{\n"
    "    f = d;\n"
    "    f += d;\n"
    "    return f == 0.1;\n"
    "}\n";
static const char check_driver_builtin_float_arguments_source[] =
    "typedef double D;\n"
    "float copy(D x, long double y) { return __builtin_copysignf(x, y); }\n"
    "float absolute(double x) { return __builtin_fabsf(x); }\n"
    "float fused(double x, long double y) { return __builtin_fmaf(x, 1.0f, y); }\n"
    "float nested(long double x) { return __builtin_copysignf(__builtin_ceil(x), __builtin_floor(x)); }\n"
    "float choose(int c, double x, double y) { return __builtin_sqrtf(c ? x : y); }\n"
    "float dead(double x) { if (0) return __builtin_sqrtf(x); return __builtin_ceilf(0.1); }\n"
    "float exchange(_Atomic float *p, double x) { return __c11_atomic_exchange(p, x, 5); }\n"
    "float exact(double x) { return __builtin_copysignf((float)x, 1.0); }\n"
    "int query(long double x) { return __builtin_isfinite(x) + (int)sizeof(__builtin_floorf(x)); }\n"
    "float component(_Complex double x) { return __builtin_crealf(x); }\n";
static const CheckDriverDefaultWarningFixture fixture_17[] =
{
    {
        .name = "builtin floating parameter conversions",
        .source = check_driver_builtin_float_arguments_source,
        .options = { "-Wno-absolute-value", "-Wimplicit-float-conversion" },
        .warnings = 15,
        .compare_node_window = true,
    },
    {
        .name = "builtin floating parameter conversions with the warning disabled",
        .source = check_driver_builtin_float_arguments_source,
        .options = { "-Wno-absolute-value", "-Wimplicit-float-conversion", "-Wno-implicit-float-conversion" },
        .compare_node_window = true,
    },
    {
        .name = "floating conversions to a lower rank, by default",
        .source = check_driver_float_conversions_source,
        .warnings = 2,
    },
    {
        .name = "floating conversions to a lower rank under -Wimplicit-float-conversion",
        .source = check_driver_float_conversions_source,
        .options = { "-Wimplicit-float-conversion" },
        .warnings = 60,
        .notes = 3,
    },
    {
        .name = "floating conversions to a lower rank under -Wall -Wimplicit-float-conversion",
        .source = check_driver_float_conversions_source,
        .options = { "-Wall", "-Wimplicit-float-conversion" },
        .warnings = 60,
        .notes = 3,
    },
    {
        .name = "floating conversions to a lower rank, -Wimplicit-float-conversion then -Wno-implicit-float-conversion",
        .source = check_driver_float_conversions_source,
        .options = { "-Wimplicit-float-conversion", "-Wno-implicit-float-conversion" },
        .warnings = 2,
    },
    {
        .name = "floating conversions to a lower rank under -Wconversion -Wno-conversion",
        .source = check_driver_float_small_source,
        .options = { "-Wconversion", "-Wno-conversion" },
        .warnings = 1,
    },
    {
        .name = "-Werror=implicit-float-conversion",
        .source = check_driver_float_small_source,
        .options = { "-Werror=implicit-float-conversion" },
        .warnings = 1,
        .errors = 2,
    },
    {
        .name = "-Werror=literal-range with -Wimplicit-float-conversion",
        .source = check_driver_float_small_source,
        .options = { "-Werror=literal-range", "-Wimplicit-float-conversion" },
        .warnings = 2,
        .errors = 1,
    },
    {
        .name = "floating comparisons with a literal, by default",
        .source = check_driver_float_comparisons_source,
        .warnings = 39,
        .notes = 1,
    },
    {
        .name = "floating comparisons with a literal under -Wall",
        .source = check_driver_float_comparisons_source,
        .options = { "-Wall" },
        .warnings = 39,
        .notes = 1,
    },
    {
        .name = "floating comparisons with a literal in C23",
        .source = check_driver_float_comparisons_source,
        .warnings = 39,
        .notes = 1,
        .c23 = true,
    },
    {
        .name = "floating comparisons with a literal under -Wno-literal-range",
        .source = check_driver_float_comparisons_source,
        .options = { "-Wno-literal-range" },
        .warnings = 2,
    },
    {
        .name = "floating controls, by default",
        .source = check_driver_float_controls_source,
        .warnings = 1,
    },
    {
        .name = "floating controls under -Wall -Wimplicit-float-conversion",
        .source = check_driver_float_controls_source,
        .options = { "-Wall", "-Wimplicit-float-conversion" },
        .warnings = 1,
    },
    {
        .name = "floating precision pragmas, by default",
        .source = check_driver_float_pragmas_source,
        .warnings = 6,
        .errors = 1,
        .notes = 3,
    },
    {
        .name = "floating precision pragmas under -Wimplicit-float-conversion",
        .source = check_driver_float_pragmas_source,
        .options = { "-Wimplicit-float-conversion" },
        .warnings = 9,
        .errors = 1,
        .notes = 3,
    },
    {
        .name = "floating precision and comparisons under -Weverything",
        .source = check_driver_float_everything_source,
        .options = { "-Weverything" },
        .warnings = 7,
    },
    {
        .name = "floating review cases, by default",
        .source = check_driver_float_review_source,
        .warnings = 13,
    },
    {
        .name = "floating review cases under -Wimplicit-float-conversion",
        .source = check_driver_float_review_source,
        .options = { "-Wimplicit-float-conversion" },
        .warnings = 25,
    },
    {
        .name = "floating comparisons under eval_method(extended)",
        .source = check_driver_float_eval_extended_source,
        .warnings = 2,
    },
    {
        .name = "floating compound assignments under eval_method(double) and -Wimplicit-float-conversion",
        .source = check_driver_float_eval_double_source,
        .options = { "-Wimplicit-float-conversion" },
        .warnings = 4,
    },
};
static const size_t fixture_17_lengths[] = {
sizeof(check_driver_builtin_float_arguments_source)-1,
sizeof(check_driver_builtin_float_arguments_source)-1,
sizeof(check_driver_float_conversions_source)-1,
sizeof(check_driver_float_conversions_source)-1,
sizeof(check_driver_float_conversions_source)-1,
sizeof(check_driver_float_conversions_source)-1,
sizeof(check_driver_float_small_source)-1,
sizeof(check_driver_float_small_source)-1,
sizeof(check_driver_float_small_source)-1,
sizeof(check_driver_float_comparisons_source)-1,
sizeof(check_driver_float_comparisons_source)-1,
sizeof(check_driver_float_comparisons_source)-1,
sizeof(check_driver_float_comparisons_source)-1,
sizeof(check_driver_float_controls_source)-1,
sizeof(check_driver_float_controls_source)-1,
sizeof(check_driver_float_pragmas_source)-1,
sizeof(check_driver_float_pragmas_source)-1,
sizeof(check_driver_float_everything_source)-1,
sizeof(check_driver_float_review_source)-1,
sizeof(check_driver_float_review_source)-1,
sizeof(check_driver_float_eval_extended_source)-1,
sizeof(check_driver_float_eval_double_source)-1
};
static const char check_driver_for_loop_forms_source[] =
    "struct S { int x; } gs; int g(int); extern int ext; enum { K = 3 };\n"
                  "typedef int T; volatile int vg;\n"
                  "void f(int n, int *p, int a[4], struct S s, struct S *ps) {\n"
                  "    int i = 0, j = 0, k = 0, m = 0, q = 0; static int st; volatile int vo = 0; int arr[4] = {0};\n"
                  "    for (; i < n; ) { i; }\n"
                  "    for (; i < n; ) { (void)i; }\n"
                  "    for (; i < n; ) { g(i); }\n"
                  "    for (; i < n; ) { int *pi = &i; (void)pi; }\n"
                  "    for (; i < n; ) { break; }\n"
                  "    for (; i < n; ) { for (;;) { break; } }\n"
                  "    for (; i < n; ) { if (g(0)) return; }\n"
                  "    for (; i < n; ) { continue; }\n"
                  "    for (; i < n && j < k && m > q; ) { }\n"
                  "    for (; i + j + k + m + q; ) { }\n"
                  "    for (; i < st; ) { }\n"
                  "    for (; i < vo; ) { }\n"
                  "    for (; i < ext; ) { }\n"
                  "    for (; i < K; ) { }\n"
                  "    for (; i < (T)n; ) { }\n"
                  "    for (; i < sizeof(n); ) { }\n"
                  "    for (; p; ) { p[0] = 1; }\n"
                  "    for (; p; ) { *p = 1; }\n"
                  "    for (; i < s.x; ) { }\n"
                  "    for (; ps; ) { ps->x = 1; }\n"
                  "    for (; i < n; ) { s.x = i; }\n"
                  "    for (; -i < ~n; ) { }\n"
                  "    for (; i ? j : k; ) { }\n"
                  "    for (; i < n; i++) { }\n"
                  "    for (; i < n; j++) { }\n"
                  "    for (; i < n; j++) { i++; }\n"
                  "    for (; i < n; i++) { i++; }\n"
                  "    for (; i < n; ++i) { --i; }\n"
                  "    for (; i < n; i--) { j++; i--; }\n"
                  "    for (; i < n; i++) { if (j) continue; i++; }\n"
                  "    for (; i < n; i++) { while (j) continue; i++; }\n"
                  "    for (; i < n; i++) { switch (j) { case 1: continue; } i++; }\n"
                  "    for (; i < n; i++) i++;\n"
                  "    for (; i < n; (i++)) { i++; }\n"
                  "    for (; i < n; i++) { (i++); }\n"
                  "    for (; i < n; i++) { i += 1; }\n"
                  "    for (; a; ) { }\n"
                  "    for (; i < n; ) { goto out; }\n"
                  "    for (; i < n; ) { ({ 0; }); }\n"
                  "    for (; i < 1.5; ) { }\n"
                  "    for (; i < 'c'; ) { }\n"
                  "    for (; (i) < (n); ) { }\n"
                  "    out: ;\n"
                  "}\n";
static const char check_driver_for_loop_order_source[] =
    "#define LOOP(v, n) for (int v = 0; v < (n); ) { }\n"
                  "#define STEP(v) v++\n"
                  "int g(int);\n"
                  "int f(int n, unsigned u) {\n"
                  "    int r = 0;\n"
                  "    for (int i = 0; i < n; ) {\n"
                  "        int unused;\n"
                  "        for (int j = 0; j < n; j++) { r += j < u; j++; }\n"
                  "        r == 1;\n"
                  "    }\n"
                  "    for (int i = 0; i < n; STEP(i)) { STEP(i); }\n"
                  "    for (int i = 0; i < n; i++) { r += g(i); i++; }\n"
                  "    for (int i = 0; i < n; ) {\n"
                  "#pragma clang diagnostic push\n"
                  "#pragma clang diagnostic ignored \"-Wfor-loop-analysis\"\n"
                  "        r++;\n"
                  "#pragma clang diagnostic pop\n"
                  "    }\n"
                  "    for (int i = 0; i < n; ) { for (int j = 0; j < i; ) { } }\n"
                  "    return r;\n"
                  "}\n";
static const char check_driver_for_loop_unevaluated_source[] =
    "void f(int i, int n) {\n"
    "    for (; i < n;) { (void)__builtin_constant_p(({ i = 8; 1; })); }\n"
    "    for (; i < n + __builtin_constant_p(({ i = 6; 1; })); ) { }\n"
    "    for (; i < n;) { (void)sizeof(({ i = 9; 1; })); }\n"
    "    for (; i < n;) { (void)_Alignof(({ i = 1; 1; })); }\n"
    "    for (; i < n;) { typeof(({ i = 1; 1; })) t = 0; (void)t; }\n"
    "    for (; i < n;) { (void)({ i = 1; 1; }); }\n"
    "    for (; i < n;) { (void)__builtin_constant_p(({ ({ i = 2; 1; }); })); }\n"
    "    for (; i < n;) { (void)sizeof(({ (void)({ i = 2; 1; }); 1; })); }\n"
    "    for (; i < n;) { (void)_Generic(1, int: ({ i = 4; 1; }), long: 2); }\n"
    "    for (; i < n;) { (void)_Generic(1, long: ({ i = 4; 1; }), int: 2); }\n"
    "    for (; i < n;) { (void)__builtin_choose_expr(1, ({ i = 4; 1; }), 2); }\n"
    "    for (; i < n;) { (void)__builtin_choose_expr(0, ({ i = 4; 1; }), 2); }\n"
    "    for (; i < n;) { (void)__builtin_object_size(({ i = 5; &i; }), 0); }\n"
    "    for (; i < n;) { (void)_Generic(1, long: ({ (void)({ i = 4; 1; }); 1; }), int: 2); }\n"
    "    for (; i < n;) { (void)_Generic(1, int: ({ (void)({ i = 4; 1; }); 1; }), long: 2); }\n"
    "    for (; i < n;) { (void)_Generic(1, int: ({ (void)sizeof(({ i = 4; 1; })); 1; }), long: 2); }\n"
    "}\n"
    "void g(int i, int n) {\n"
    "    for (; i < n;) { (void)sizeof(({ return; 1; })); }\n"
    "    for (; i < n;) { (void)sizeof(({ break; 1; })); }\n"
    "    for (; i < n;) { (void)({ break; 1; }); }\n"
    "    for (; i < n;) { (void)_Generic(1, long: ({ goto out; 1; }), int: 2); }\n"
    "    for (; i < n + sizeof(({ i = 2; 1; }));) { }\n"
    "    for (; i < n; (void)sizeof(({ i = 2; 1; }))) { }\n"
    "    for (; i < n; (void)__builtin_constant_p(({ (void)({ i++; 1; }); 1; }))) { }\n"
    "    for (; i < n;) { (void)sizeof(int[({ i = 1; n; })]); }\n"
    "    for (; i < n;) { (void)sizeof(int[i++]); }\n"
    "    for (; i < n;) { (void)sizeof(int (*)[i++]); }\n"
    "    for (; i < n;) { int a[n]; (void)sizeof(a[({ i = 3; 1; })]); }\n"
    "    for (; i < n;) { int a[({ i = 3; n; })]; (void)a; }\n"
    "    for (; i < n;) { int a = ({ i = 3; 8; }); (void)a; }\n"
    "    (void)sizeof(({ for (; i < n;) { i++; } 1; }));\n"
    "out:;\n"
    "}\n";
static const char check_driver_for_loop_nested_selections_source[] =
    "void f1(int i, int n) {\n"
    "    for (; i < n;) {\n"
    "        (void)({ (void)_Generic(1, long: ({ i++; 1; }), int: 2); 1; });\n"
    "    }\n"
    "}\n"
    "void f2(int i, int n) {\n"
    "    for (; i < n;) {\n"
    "        (void)({ (void)_Generic(1, int: ({ i++; 1; }), long: 2); 1; });\n"
    "    }\n"
    "}\n"
    "void f3(int i, int n) {\n"
    "    for (; i < n;) {\n"
    "        (void)({ (void)_Generic(1, long: ({ break; 1; }), int: 2); 1; });\n"
    "    }\n"
    "}\n"
    "void f4(int i, int n) {\n"
    "    for (; i < n;) {\n"
    "        (void)({ (void)_Generic(1, int: ({ break; 1; }), long: 2); 1; });\n"
    "    }\n"
    "}\n"
    "void f5(int i, int n) {\n"
    "    for (; i < n;) {\n"
    "        (void)_Generic(1, int: ({ (void)_Generic(1, long: ({ i++; 1; }), int: 2); 1; }), long: 2);\n"
    "    }\n"
    "}\n"
    "void f6(int i, int n) {\n"
    "    for (; i < n;) {\n"
    "        (void)_Generic(1, int: ({ (void)__builtin_choose_expr(1, ({ i++; 1; }), 2); 1; }), long: 2);\n"
    "    }\n"
    "}\n"
    "void f7(int i, int n) {\n"
    "    for (; i < n;) {\n"
    "        (void)({ (void)__builtin_choose_expr(0, ({ i++; 1; }), 2); 1; });\n"
    "    }\n"
    "}\n"
    "void f8(int i, int n) {\n"
    "    for (; i < n;) {\n"
    "        (void)({ (void)sizeof(_Generic(1, int: ({ i++; 1; }), long: 2)); 1; });\n"
    "    }\n"
    "}\n"
    "void f9(int i, int n) {\n"
    "    for (; i < n;) {\n"
    "        (void)({ (void)_Generic(1, long: ({ goto out; 1; }), int: 2); 1; });\n"
    "    }\n"
    "out:;\n"
    "}\n"
    "void f11(int i, int n) {\n"
    "    for (; i < n;) {\n"
    "        (void)_Generic(1, long: 0, int: ({ (void)_Generic(1, int: ({ (void)({ i++; 1; }); 1; }), long: 2); 1; }));\n"
    "    }\n"
    "}\n"
    "void f12(int i, int n) {\n"
    "    for (; i < n;) {\n"
    "        (void)_Generic(1, long: 0, int: ({ (void)_Generic(1, long: ({ (void)({ return; 1; }); 1; }), int: 2); 1; }));\n"
    "    }\n"
    "}\n";
static const CheckDriverDefaultWarningFixture fixture_18[] =
{
    {
        .name = "condition variables a for loop never changes, and steps its header and its body repeat",
        .source = check_driver_for_loop_forms_source,
        .options = { "-Wfor-loop-analysis" },
        .warnings = 25,
        .notes = 3,
    },
    {
        .name = "-Wloop-analysis holds -Wfor-loop-analysis",
        .source = check_driver_for_loop_forms_source,
        .options = { "-Wloop-analysis" },
        .warnings = 25,
        .notes = 3,
    },
    {
        .name = "-Wfor-loop-analysis is off by default",
        .source = check_driver_for_loop_forms_source,
        .warnings = 2,
    },
    {
        .name = "-Wall's for loop warnings follow their bodies' own, nested loops' first",
        .source = check_driver_for_loop_order_source,
        .options = { "-Wall" },
        .warnings = 9,
        .notes = 4,
    },
    {
        // Review on #1811: statement expressions, static selections and the builtins clang leaves unvisited in a condition.
        .name = "conditions with statement expressions, selections and unvisited builtins, and selections in the body",
        .source = "struct S { int a, b; };\n"
                  "void f(int i, int n, int j, int *p) {\n"
                  "    for (; ({ i < n; 1; }); ) { }\n"
                  "    for (; (int)({ i < n; 0; }); ) { }\n"
                  "    for (; _Generic(i, int: j < n, default: 0); ) { }\n"
                  "    for (; _Generic(0, int: i < n, default: 0); ) { }\n"
                  "    for (; i < __builtin_offsetof(struct S, b); ) { }\n"
                  "    for (; i < n + __builtin_constant_p(j); ) { }\n"
                  "    for (; i < __builtin_object_size(p, 0); ) { }\n"
                  "    for (; i < __builtin_classify_type(j); ) { }\n"
                  "    for (; __builtin_choose_expr(1, i < n, j); ) { }\n"
                  "    for (; i < n; ) { (void)__builtin_choose_expr(0, i++, 0); }\n"
                  "    for (; i < n; ) { (void)_Generic(0, int: 0, default: i++); }\n"
                  "    for (; i < n; ) { (void)_Generic(0, int: i++, default: 0); }\n"
                  "}\n",
        .options = { "-Wfor-loop-analysis" },
        .warnings = 11,
    },
    {
        // Review on #1811: the condition's and the increment's first tokens' pragmas, and many variables and nodes.
        .name = "pragmas at the condition and the increment, and long conditions",
        .source = "void f(int i, int n, int a, int b, int c, int d, int e, int g, int h, int k, int l, int m, int o, int p, int q, int r, int s, int t) {\n"
                  "#pragma clang diagnostic push\n"
                  "#pragma clang diagnostic ignored \"-Wfor-loop-analysis\"\n"
                  "    for (; i < n;\n"
                  "#pragma clang diagnostic pop\n"
                  "         i++) { i++; }\n"
                  "#pragma clang diagnostic push\n"
                  "#pragma clang diagnostic ignored \"-Wfor-loop-analysis\"\n"
                  "    for (; \n"
                  "#pragma clang diagnostic pop\n"
                  "        i < n; ) { }\n"
                  "    for (; a + b + c + d + e + g + h + k + l + m + o + p + q + r + s + t + i + n < 0; ) { }\n"
                  "    for (; i + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 < n; ) { }\n"
                  "}\n",
        .options = { "-Wfor-loop-analysis" },
        .warnings = 4,
        .notes = 1,
    },
    {
        // Second review on #1811: the unevaluated-argument builtins' operands in the body and the increment, and loops nested
        // in a statement expression that leads a condition.
        .name = "unvisited builtins' operands after the condition, and loops in a condition's statement expression",
        .source = "void f1(int n) { int i = 0; for (; i < n; ) { (void)__builtin_constant_p(i = 6); } }\n"
                  "void f2(int n) { int i = 0; for (; i < n; ) { (void)__builtin_object_size(&i, 0); } }\n"
                  "void f5(int n) { int i = 0; for (; i < n; ) { (void)__builtin_dynamic_object_size(&i, 0); } }\n"
                  "void f6(int n) { int i = 0; for (; i < n; ) { (void)__builtin_classify_type(i = 6); } }\n"
                  "void f7(int n) { int i = 0; for (; i < n; __builtin_constant_p(i = 6)) { } }\n"
                  "void f8(int n) { int i = 0; for (; i < n; ) { (void)__builtin_constant_p(0 ? 0 : (i = 6)); } }\n"
                  "void g(int n) {\n"
                  "    int i = 0;\n"
                  "    for (; ({ for (int x = 0; x < 2; ) { } 1; }); ) { }\n"
                  "    for (; ({ do { } while (i < 2); 1; }); ) { }\n"
                  "    for (; ({ int y = 0; for (; y < n; ) { } 1; }) && i < n; ) { }\n"
                  "    for (; i < ({ for (int z = 0; z < 2; ) { } 1; }); ) { }\n"
                  "    for (; (struct { int a; }){ i }.a < n; ) { }\n"
                  "}\n",
        .options = { "-Wfor-loop-analysis" },
        .warnings = 10,
    },
    {
        // #1821: a write in a GNU statement expression clang's visitor never reaches changes no loop variable: one in an
        // unevaluated operand (sizeof, _Alignof, typeof, an unevaluated-argument builtin's call, a sizeof's type name's
        // bounds), nested or not, or in a static selection's other arm, as a return, a break or a goto there is none.
        // One in a selected arm, in a bound or in an initializer is.
        .name = "statement expressions in unevaluated operands",
        .source = check_driver_for_loop_unevaluated_source,
        .options = { "-Wfor-loop-analysis", "-Wno-unevaluated-expression" },
        .warnings = 23,
    },
    {
        .name = "statement expressions in unevaluated operands in C23",
        .source = check_driver_for_loop_unevaluated_source,
        .options = { "-Wfor-loop-analysis", "-Wno-unevaluated-expression" },
        .warnings = 23,
        .c23 = true,
    },
    {
        .name = "statement expressions in unevaluated operands under -Wall",
        .source = check_driver_for_loop_unevaluated_source,
        .options = { "-Wall", "-Wno-unevaluated-expression" },
        .warnings = 23,
    },
    {
        .name = "statement expressions in unevaluated operands under -Wall -Wextra",
        .source = check_driver_for_loop_unevaluated_source,
        .options = { "-Wall", "-Wextra", "-Wno-unevaluated-expression" },
        .warnings = 24,
    },
    {
        .name = "nested selections in statement expressions",
        .source = check_driver_for_loop_nested_selections_source,
        .options = { "-Wfor-loop-analysis", "-Wno-unevaluated-expression" },
        .warnings = 7,
    },
    {
        .name = "nested selections in statement expressions in C23",
        .source = check_driver_for_loop_nested_selections_source,
        .options = { "-Wfor-loop-analysis", "-Wno-unevaluated-expression" },
        .warnings = 7,
        .c23 = true,
    },
    {
        .name = "nested selections in statement expressions under -Wall -Wextra",
        .source = check_driver_for_loop_nested_selections_source,
        .options = { "-Wall", "-Wextra", "-Wno-unevaluated-expression" },
        .warnings = 7,
    },
    {
        .name = "-Werror=for-loop-analysis and a pragma",
        .source = check_driver_for_loop_order_source,
        .options = { "-Werror=for-loop-analysis", "-Wall" },
        .warnings = 2,
        .errors = 7,
        .notes = 4,
    },
};
static const size_t fixture_18_lengths[] = {
sizeof(check_driver_for_loop_forms_source)-1,
sizeof(check_driver_for_loop_forms_source)-1,
sizeof(check_driver_for_loop_forms_source)-1,
sizeof(check_driver_for_loop_order_source)-1,
sizeof("struct S { int a, b; };\n"
                  "void f(int i, int n, int j, int *p) {\n"
                  "    for (; ({ i < n; 1; }); ) { }\n"
                  "    for (; (int)({ i < n; 0; }); ) { }\n"
                  "    for (; _Generic(i, int: j < n, default: 0); ) { }\n"
                  "    for (; _Generic(0, int: i < n, default: 0); ) { }\n"
                  "    for (; i < __builtin_offsetof(struct S, b); ) { }\n"
                  "    for (; i < n + __builtin_constant_p(j); ) { }\n"
                  "    for (; i < __builtin_object_size(p, 0); ) { }\n"
                  "    for (; i < __builtin_classify_type(j); ) { }\n"
                  "    for (; __builtin_choose_expr(1, i < n, j); ) { }\n"
                  "    for (; i < n; ) { (void)__builtin_choose_expr(0, i++, 0); }\n"
                  "    for (; i < n; ) { (void)_Generic(0, int: 0, default: i++); }\n"
                  "    for (; i < n; ) { (void)_Generic(0, int: i++, default: 0); }\n"
                  "}\n")-1,
sizeof("void f(int i, int n, int a, int b, int c, int d, int e, int g, int h, int k, int l, int m, int o, int p, int q, int r, int s, int t) {\n"
                  "#pragma clang diagnostic push\n"
                  "#pragma clang diagnostic ignored \"-Wfor-loop-analysis\"\n"
                  "    for (; i < n;\n"
                  "#pragma clang diagnostic pop\n"
                  "         i++) { i++; }\n"
                  "#pragma clang diagnostic push\n"
                  "#pragma clang diagnostic ignored \"-Wfor-loop-analysis\"\n"
                  "    for (; \n"
                  "#pragma clang diagnostic pop\n"
                  "        i < n; ) { }\n"
                  "    for (; a + b + c + d + e + g + h + k + l + m + o + p + q + r + s + t + i + n < 0; ) { }\n"
                  "    for (; i + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 < n; ) { }\n"
                  "}\n")-1,
sizeof("void f1(int n) { int i = 0; for (; i < n; ) { (void)__builtin_constant_p(i = 6); } }\n"
                  "void f2(int n) { int i = 0; for (; i < n; ) { (void)__builtin_object_size(&i, 0); } }\n"
                  "void f5(int n) { int i = 0; for (; i < n; ) { (void)__builtin_dynamic_object_size(&i, 0); } }\n"
                  "void f6(int n) { int i = 0; for (; i < n; ) { (void)__builtin_classify_type(i = 6); } }\n"
                  "void f7(int n) { int i = 0; for (; i < n; __builtin_constant_p(i = 6)) { } }\n"
                  "void f8(int n) { int i = 0; for (; i < n; ) { (void)__builtin_constant_p(0 ? 0 : (i = 6)); } }\n"
                  "void g(int n) {\n"
                  "    int i = 0;\n"
                  "    for (; ({ for (int x = 0; x < 2; ) { } 1; }); ) { }\n"
                  "    for (; ({ do { } while (i < 2); 1; }); ) { }\n"
                  "    for (; ({ int y = 0; for (; y < n; ) { } 1; }) && i < n; ) { }\n"
                  "    for (; i < ({ for (int z = 0; z < 2; ) { } 1; }); ) { }\n"
                  "    for (; (struct { int a; }){ i }.a < n; ) { }\n"
                  "}\n")-1,
sizeof(check_driver_for_loop_unevaluated_source)-1,
sizeof(check_driver_for_loop_unevaluated_source)-1,
sizeof(check_driver_for_loop_unevaluated_source)-1,
sizeof(check_driver_for_loop_unevaluated_source)-1,
sizeof(check_driver_for_loop_nested_selections_source)-1,
sizeof(check_driver_for_loop_nested_selections_source)-1,
sizeof(check_driver_for_loop_nested_selections_source)-1,
sizeof(check_driver_for_loop_order_source)-1
};
static const CheckDriverDefaultWarningFixture fixture_19[] =
{
    {
        .name = "narrow signed bit-precise data is not an int format argument",
        .source = "int printf(const char*,...);void f(_BitInt(8) x){printf(\"%d\",x);}\n",
        .warnings = 1,
        .c23 = true,
    },
    {
        .name = "narrow unsigned bit-precise data is not an unsigned int format argument",
        .source = "int printf(const char*,...);void f(unsigned _BitInt(24) x){printf(\"%u\",x);}\n",
        .warnings = 1,
        .c23 = true,
    },
    {
        .name = "one-bit unsigned data is not an int format argument",
        .source = "int printf(const char*,...);void f(unsigned _BitInt(1) x){printf(\"%d\",x);}\n",
        .warnings = 1,
        .c23 = true,
    },
    {
        .name = "equal-width bit-precise data is distinct from int",
        .source = "int printf(const char*,...);void f(_BitInt(32) x){printf(\"%d\",x);}\n",
        .warnings = 1,
        .c23 = true,
    },
    {
        .name = "character conversions require ordinary integer classes",
        .source = "int printf(const char*,...);void f(_BitInt(8) x,_BitInt(32) y){printf(\"%c %lc\",x,y);}\n",
        .warnings = 2,
        .c23 = true,
    },
    {
        .name = "count pointers require the ordinary pointed-to class",
        .source = "int printf(const char*,...);void f(_BitInt(8)*x,_BitInt(16)*y,_BitInt(32)*z){printf(\"%hhn %hn %n\",x,y,z);}\n",
        .warnings = 3,
        .c23 = true,
    },
    {
        .name = "field width does not promote a bit-precise integer to int",
        .source = "int printf(const char*,...);void f(_BitInt(8) x){printf(\"%*d\",x,1);}\n",
        .warnings = 1,
        .c23 = true,
    },
    {
        .name = "field precision does not promote a bit-precise integer to int",
        .source = "int printf(const char*,...);void f(unsigned _BitInt(24) x){printf(\"%.*s\",x,\"x\");}\n",
        .warnings = 1,
        .c23 = true,
    },
    {
        .name = "C23 exact-width modifiers still require their ordinary integer types",
        .source = "int printf(const char*,...);void f(_BitInt(8) x,_BitInt(32) y){printf(\"%w8d %w32d\",x,y);}\n",
        .warnings = 2,
        .c23 = true,
    },
    {
        .name = "explicit integer casts retain valid data width and precision",
        .source = "int printf(const char*,...);void f(_BitInt(8) x){printf(\"%d %c %*d %.*s\",(int)x,(int)x,(int)x,1,(int)x,\"x\");}\n",
        .c23 = true,
    },
    {
        .name = "ordinary arithmetic promotes the narrow bit-precise operand",
        .source = "int printf(const char*,...);void f(_BitInt(8) x){printf(\"%d\",x+0);}\n",
        .c23 = true,
    },
    {
        .name = "fixed int parameter converts a bit-precise source before format checking",
        .source = "void log_value(const char*,int) __attribute__((format(printf,1,2)));void f(_BitInt(8) x){log_value(\"%d\",x);}\n",
        .options = { "-Wno-gcc-compat" },
        .c23 = true,
    },
    {
        .name = "fixed long parameter conversion retains its valid format",
        .source = "void log_value(const char*,long) __attribute__((format(printf,1,2)));void f(_BitInt(8) x){log_value(\"%ld\",x);}\n",
        .options = { "-Wno-gcc-compat" },
        .c23 = true,
    },
    {
        .name = "fixed long parameter mismatch reports the converted type",
        .source = "void log_value(const char*,long) __attribute__((format(printf,1,2)));void f(_BitInt(8) x){log_value(\"%d\",x);}\n",
        .options = { "-Wno-gcc-compat" },
        .warnings = 1,
        .c23 = true,
    },
    {
        .name = "fixed bit-precise parameter retains its distinct type",
        .source = "void log_value(const char*,_BitInt(32)) __attribute__((format(printf,1,2)));void f(_BitInt(8) x){log_value(\"%d\",x);}\n",
        .options = { "-Wno-gcc-compat" },
        .warnings = 1,
        .c23 = true,
    },
    {
        .name = "ordinary narrow integer and count-pointer classes remain valid",
        .source = "int printf(const char*,...);void f(signed char x,short y,int z,signed char*a,short*b,int*c){printf(\"%hhd %hd %d %hhn %hn %n\",x,y,z,a,b,c);}\n",
        .c23 = true,
    },
    {
        .name = "wide bit-precise data remains distinct from equal-width long",
        .source = "int printf(const char*,...);void f(_BitInt(64) x){printf(\"%ld\",x);}\n",
        .warnings = 1,
        .c23 = true,
    },
    {
        .name = "ordinary boolean character warning is retained",
        .source = "int printf(const char*,...);void f(_Bool x){printf(\"%c\",x);}\n",
        .warnings = 1,
        .c23 = true,
    },
    {
        .name = "string conversions require character rather than bit-precise pointees",
        .source = "int printf(const char*,...);void f(_BitInt(8)*x,_BitInt(32)*y){printf(\"%s %ls\",x,y);}\n",
        .warnings = 2,
        .c23 = true,
    },
    {
        .name = "explicit string-pointer casts and generic pointer formats remain valid",
        .source = "int printf(const char*,...);void f(_BitInt(8)*x,_BitInt(32)*y){printf(\"%s %ls %p\",(char*)x,(int*)y,x);}\n",
        .c23 = true,
    },
    {
        .name = "fixed dynamic width and precision use their int parameter conversions",
        .source = "void log_value(const char*,int,int,const char*) __attribute__((format(printf,1,2)));void f(_BitInt(8) x){log_value(\"%*.*s\",x,x,\"x\");}\n",
        .options = { "-Wno-gcc-compat" },
        .c23 = true,
    },
    {
        .name = "fixed void pointer mismatch reports its converted count-pointer type",
        .source = "void log_value(const char*,void*) __attribute__((format(printf,1,2)));void f(_BitInt(32)*x){log_value(\"%n\",x);}\n",
        .options = { "-Wno-gcc-compat" },
        .warnings = 1,
        .c23 = true,
    },
    {
        .name = "fixed bit-precise data parameter converts an ordinary int before checking",
        .source = "void log_value(const char*,_BitInt(32)) __attribute__((format(printf,1,2)));void f(int x){log_value(\"%d\",x);}\n",
        .options = { "-Wno-gcc-compat" },
        .warnings = 1,
        .c23 = true,
    },
    {
        .name = "fixed bit-precise width parameter converts an ordinary int before checking",
        .source = "void log_value(const char*,_BitInt(32),int) __attribute__((format(printf,1,2)));void f(int x){log_value(\"%*d\",x,1);}\n",
        .options = { "-Wno-gcc-compat" },
        .warnings = 1,
        .c23 = true,
    },
    {
        .name = "fixed bit-precise pointer parameter converts void pointer before checking",
        .source = "void log_value(const char*,_BitInt(32)*) __attribute__((format(printf,1,2)));void f(void*x){log_value(\"%n\",x);}\n",
        .options = { "-Wno-gcc-compat" },
        .warnings = 1,
        .c23 = true,
    },
    // _Atomic arguments are their value types (#2234): clang's lvalue conversion drops _Atomic, so a matching one gives no
    // warning and a mismatched one names its value type.
    {
        .name = "atomic format arguments by their value types",
        .source = "int printf(const char*, ...);\n"
                  "static _Atomic int a = 5;\n"
                  "static _Atomic long l = 6;\n"
                  "static _Atomic double d = 6;\n"
                  "static _Atomic short s = 6;\n"
                  "static _Atomic char c = 6;\n"
                  "int main(void) { printf(\"%d %ld %f %hd %c\\n\", a, l, d, s, c); return 0; }\n",
        .warnings = 0,
    },
    {
        .name = "atomic format arguments that don't match, by their value types",
        .source = "int printf(const char*, ...);\n"
                  "typedef _Atomic long AL;\n"
                  "typedef _Atomic(int) AI;\n"
                  "static AL al = 1;\n"
                  "static AI ai = 2;\n"
                  "static _Atomic unsigned char uc = 3;\n"
                  "static _Atomic(int *) ap;\n"
                  "static _Atomic(float) af;\n"
                  "struct S { _Atomic int m; } s;\n"
                  "int main(void) { printf(\"%d %d %s %d %p %f %x %*d\\n\", al, ai, uc, s.m, ap, af, ai, ai, 1); printf(\"%s %c\\n\", ap, ai); return 0; }\n",
        .warnings = 3,
    },
};
static const size_t fixture_19_lengths[] = {
sizeof("int printf(const char*,...);void f(_BitInt(8) x){printf(\"%d\",x);}\n")-1,
sizeof("int printf(const char*,...);void f(unsigned _BitInt(24) x){printf(\"%u\",x);}\n")-1,
sizeof("int printf(const char*,...);void f(unsigned _BitInt(1) x){printf(\"%d\",x);}\n")-1,
sizeof("int printf(const char*,...);void f(_BitInt(32) x){printf(\"%d\",x);}\n")-1,
sizeof("int printf(const char*,...);void f(_BitInt(8) x,_BitInt(32) y){printf(\"%c %lc\",x,y);}\n")-1,
sizeof("int printf(const char*,...);void f(_BitInt(8)*x,_BitInt(16)*y,_BitInt(32)*z){printf(\"%hhn %hn %n\",x,y,z);}\n")-1,
sizeof("int printf(const char*,...);void f(_BitInt(8) x){printf(\"%*d\",x,1);}\n")-1,
sizeof("int printf(const char*,...);void f(unsigned _BitInt(24) x){printf(\"%.*s\",x,\"x\");}\n")-1,
sizeof("int printf(const char*,...);void f(_BitInt(8) x,_BitInt(32) y){printf(\"%w8d %w32d\",x,y);}\n")-1,
sizeof("int printf(const char*,...);void f(_BitInt(8) x){printf(\"%d %c %*d %.*s\",(int)x,(int)x,(int)x,1,(int)x,\"x\");}\n")-1,
sizeof("int printf(const char*,...);void f(_BitInt(8) x){printf(\"%d\",x+0);}\n")-1,
sizeof("void log_value(const char*,int) __attribute__((format(printf,1,2)));void f(_BitInt(8) x){log_value(\"%d\",x);}\n")-1,
sizeof("void log_value(const char*,long) __attribute__((format(printf,1,2)));void f(_BitInt(8) x){log_value(\"%ld\",x);}\n")-1,
sizeof("void log_value(const char*,long) __attribute__((format(printf,1,2)));void f(_BitInt(8) x){log_value(\"%d\",x);}\n")-1,
sizeof("void log_value(const char*,_BitInt(32)) __attribute__((format(printf,1,2)));void f(_BitInt(8) x){log_value(\"%d\",x);}\n")-1,
sizeof("int printf(const char*,...);void f(signed char x,short y,int z,signed char*a,short*b,int*c){printf(\"%hhd %hd %d %hhn %hn %n\",x,y,z,a,b,c);}\n")-1,
sizeof("int printf(const char*,...);void f(_BitInt(64) x){printf(\"%ld\",x);}\n")-1,
sizeof("int printf(const char*,...);void f(_Bool x){printf(\"%c\",x);}\n")-1,
sizeof("int printf(const char*,...);void f(_BitInt(8)*x,_BitInt(32)*y){printf(\"%s %ls\",x,y);}\n")-1,
sizeof("int printf(const char*,...);void f(_BitInt(8)*x,_BitInt(32)*y){printf(\"%s %ls %p\",(char*)x,(int*)y,x);}\n")-1,
sizeof("void log_value(const char*,int,int,const char*) __attribute__((format(printf,1,2)));void f(_BitInt(8) x){log_value(\"%*.*s\",x,x,\"x\");}\n")-1,
sizeof("void log_value(const char*,void*) __attribute__((format(printf,1,2)));void f(_BitInt(32)*x){log_value(\"%n\",x);}\n")-1,
sizeof("void log_value(const char*,_BitInt(32)) __attribute__((format(printf,1,2)));void f(int x){log_value(\"%d\",x);}\n")-1,
sizeof("void log_value(const char*,_BitInt(32),int) __attribute__((format(printf,1,2)));void f(int x){log_value(\"%*d\",x,1);}\n")-1,
sizeof("void log_value(const char*,_BitInt(32)*) __attribute__((format(printf,1,2)));void f(void*x){log_value(\"%n\",x);}\n")-1,
sizeof("int printf(const char*, ...);\n"
                  "static _Atomic int a = 5;\n"
                  "static _Atomic long l = 6;\n"
                  "static _Atomic double d = 6;\n"
                  "static _Atomic short s = 6;\n"
                  "static _Atomic char c = 6;\n"
                  "int main(void) { printf(\"%d %ld %f %hd %c\\n\", a, l, d, s, c); return 0; }\n")-1,
sizeof("int printf(const char*, ...);\n"
                  "typedef _Atomic long AL;\n"
                  "typedef _Atomic(int) AI;\n"
                  "static AL al = 1;\n"
                  "static AI ai = 2;\n"
                  "static _Atomic unsigned char uc = 3;\n"
                  "static _Atomic(int *) ap;\n"
                  "static _Atomic(float) af;\n"
                  "struct S { _Atomic int m; } s;\n"
                  "int main(void) { printf(\"%d %d %s %d %p %f %x %*d\\n\", al, ai, uc, s.m, ap, af, ai, ai, 1); printf(\"%s %c\\n\", ap, ai); return 0; }\n")-1
};
static const CheckDriverDefaultWarningFixture fixture_20[] =
{
    {
        .name = "C23 type attributes in constant queries' casts",
        .source = "int x = _Generic((int *[[clang::address_space(1)]])0, int *: 1, default: 2);\n"
                  "int y = _Generic((int [[clang::annotate_type(\"a\")]])0, int: 1, default: 2);\n"
                  "int z = _Generic((int *__attribute__((address_space(1))))0, int *: 1, default: 2);\n"
                  "void f(void) { int w = _Generic((int *[[clang::address_space(1)]])0, int *: 1, default: 2); (void)w; }\n"
                  "_Static_assert(_Generic((int *[[clang::address_space(1)]])0, int *: 1, default: 0) == 1, \"as\");\n"
                  "_Static_assert(_Generic((int *[[clang::annotate_type(\"a\")]])0, int *: 1, default: 0), \"anp\");\n"
                  "_Static_assert(sizeof((int [[clang::annotate_type(\"b\")]] *)0) == 8, \"sz\");\n"
                  "typedef typeof((int *[[clang::address_space(2)]])0) T;\n"
                  "_Static_assert(_Generic((T)0, int __attribute__((address_space(2))) *: 1, default: 0) == 0, \"t\");\n"
                  "int v = _Generic((char (*[[clang::annotate_type(\"c\")]])[3])0, char (*)[3]: 1, default: 2);\n",
        .c23 = true,
    },
};
static const size_t fixture_20_lengths[] = {
sizeof("int x = _Generic((int *[[clang::address_space(1)]])0, int *: 1, default: 2);\n"
                  "int y = _Generic((int [[clang::annotate_type(\"a\")]])0, int: 1, default: 2);\n"
                  "int z = _Generic((int *__attribute__((address_space(1))))0, int *: 1, default: 2);\n"
                  "void f(void) { int w = _Generic((int *[[clang::address_space(1)]])0, int *: 1, default: 2); (void)w; }\n"
                  "_Static_assert(_Generic((int *[[clang::address_space(1)]])0, int *: 1, default: 0) == 1, \"as\");\n"
                  "_Static_assert(_Generic((int *[[clang::annotate_type(\"a\")]])0, int *: 1, default: 0), \"anp\");\n"
                  "_Static_assert(sizeof((int [[clang::annotate_type(\"b\")]] *)0) == 8, \"sz\");\n"
                  "typedef typeof((int *[[clang::address_space(2)]])0) T;\n"
                  "_Static_assert(_Generic((T)0, int __attribute__((address_space(2))) *: 1, default: 0) == 0, \"t\");\n"
                  "int v = _Generic((char (*[[clang::annotate_type(\"c\")]])[3])0, char (*)[3]: 1, default: 2);\n")-1
};
static const CheckDriverDefaultWarningFixture fixture_21[] =
{
    {
        // Empty structs and unions, and those of unnamed bit-fields alone, at their keyword: a typedef's, a nested one's
        // before its enclosing record's, a block's and a member's; an anonymous member names none but counts.
        .name = "records without named members",
        .source = "struct s {};\n"
                  "typedef struct {} T;\n"
                  "  union u {};\n"
                  "struct b { int : 3; };\n"
                  "struct n { struct {}; };\n"
                  "void f(void) { struct l {} x; (void)x; }\n"
                  "struct o { struct m {} q; };\n"
                  "struct c { int : 0; };\n"
                  "struct d { int a : 2; };\n",
        .options = { "-pedantic" },
        .warnings = 8,
        .compare_warning_text = true,
    },
    {
        // -Wgnu-empty-struct and -Wgnu give them; they're ignored by default.
        .name = "records without named members under -Wgnu",
        .source = "struct s {};\nunion u { int : 1; };\n",
        .options = { "-Wgnu" },
        .warnings = 2,
        .compare_warning_text = true,
    },
    {
        .name = "records without named members by default",
        .source = "struct s {};\nunion u { int : 1; };\n",
        .compare_warning_text = true,
    },
};
static const size_t fixture_21_lengths[] = {
sizeof("struct s {};\n"
                  "typedef struct {} T;\n"
                  "  union u {};\n"
                  "struct b { int : 3; };\n"
                  "struct n { struct {}; };\n"
                  "void f(void) { struct l {} x; (void)x; }\n"
                  "struct o { struct m {} q; };\n"
                  "struct c { int : 0; };\n"
                  "struct d { int a : 2; };\n")-1,
sizeof("struct s {};\nunion u { int : 1; };\n")-1,
sizeof("struct s {};\nunion u { int : 1; };\n")-1
};
static const CheckDriverDefaultWarningFixture fixture_22[] =
{
    {
        // At the name, a macro's (with its note) or written past an empty one, and at a line's end without one, each
        // numbered as before its own marker, the first after a flag 1 with its include stack; a pragma ignores, promotes
        // (by -Wgnu) and demotes (by -Wpedantic) it; a #line is none.
        .name = "gnu line markers' places, macros and pragmas",
        .source = "#define NAME \"named.c\"\n"
                  "#define FLAG 1\n"
                  "#define EMPTY\n"
                  "# 10 NAME\n"
                  "# 20 \"f.c\" FLAG\n"
                  "# 30 \"main.c\" 2\n"
                  "#pragma clang diagnostic push\n"
                  "#pragma clang diagnostic ignored \"-Wgnu-line-marker\"\n"
                  "# 40 \"main.c\"\n"
                  "#pragma clang diagnostic pop\n"
                  "# 50 EMPTY \"main.c\" EMPTY\n"
                  "#pragma clang diagnostic error \"-Wgnu\"\n"
                  "# 60 \"main.c\"\n"
                  "#pragma clang diagnostic warning \"-Wpedantic\"\n"
                  "# 70 \"main.c\"\n"
                  "#line 80 \"main.c\"\n"
                  "# 90 \"main.c\" // comment\n"
                  "#\\\n"
                  " 100 \"main.c\"\n"
                  "# 110\n"
                  "int x;\n",
        .options = { "-pedantic" },
        .warnings = 8,
        .errors = 1,
        .notes = 1,
    },
    {
        // Without a name: at the line's end, past a comment and blanks, or at the file's end without a newline; and not
        // after a marker that makes a system header.
        .name = "gnu line markers without names",
        .source = "# 5\n"
                  "# 7 /* comment */  \n"
                  "# 12 \"main.c\" 1\n"
                  "# 14 \"main.c\" 2\n"
                  "# 20 \"s.c\" 3\n"
                  "# 30 \"main.c\"\n"
                  "int x;\n"
                  "# 40",
        .options = { "-Wgnu" },
        .warnings = 6,
    },
    {
        // Off by default, and ignored by a pragma of -Wgnu.
        .name = "gnu line markers off by default",
        .source = "#include <stddef.h>\n"
                  "# 1 \"user.c\"\n"
                  "# 2 \"user.c\"\n"
                  "int x;\n"
                  "#pragma clang diagnostic ignored \"-Wgnu\"\n"
                  "# 3 \"user.c\"\n",
    },
    {
        .name = "gnu line markers under -Wgnu-line-marker",
        .source = "#include <stddef.h>\n"
                  "# 1 \"user.c\"\n"
                  "# 2 \"user.c\"\n"
                  "int x;\n"
                  "#pragma clang diagnostic ignored \"-Wgnu\"\n"
                  "# 3 \"user.c\"\n",
        .options = { "-Wgnu-line-marker" },
        .warnings = 2,
    },
};
static const size_t fixture_22_lengths[] = {
sizeof("#define NAME \"named.c\"\n"
                  "#define FLAG 1\n"
                  "#define EMPTY\n"
                  "# 10 NAME\n"
                  "# 20 \"f.c\" FLAG\n"
                  "# 30 \"main.c\" 2\n"
                  "#pragma clang diagnostic push\n"
                  "#pragma clang diagnostic ignored \"-Wgnu-line-marker\"\n"
                  "# 40 \"main.c\"\n"
                  "#pragma clang diagnostic pop\n"
                  "# 50 EMPTY \"main.c\" EMPTY\n"
                  "#pragma clang diagnostic error \"-Wgnu\"\n"
                  "# 60 \"main.c\"\n"
                  "#pragma clang diagnostic warning \"-Wpedantic\"\n"
                  "# 70 \"main.c\"\n"
                  "#line 80 \"main.c\"\n"
                  "# 90 \"main.c\" // comment\n"
                  "#\\\n"
                  " 100 \"main.c\"\n"
                  "# 110\n"
                  "int x;\n")-1,
sizeof("# 5\n"
                  "# 7 /* comment */  \n"
                  "# 12 \"main.c\" 1\n"
                  "# 14 \"main.c\" 2\n"
                  "# 20 \"s.c\" 3\n"
                  "# 30 \"main.c\"\n"
                  "int x;\n"
                  "# 40")-1,
sizeof("#include <stddef.h>\n"
                  "# 1 \"user.c\"\n"
                  "# 2 \"user.c\"\n"
                  "int x;\n"
                  "#pragma clang diagnostic ignored \"-Wgnu\"\n"
                  "# 3 \"user.c\"\n")-1,
sizeof("#include <stddef.h>\n"
                  "# 1 \"user.c\"\n"
                  "# 2 \"user.c\"\n"
                  "int x;\n"
                  "#pragma clang diagnostic ignored \"-Wgnu\"\n"
                  "# 3 \"user.c\"\n")-1
};
static const CheckDriverDefaultWarningFixture fixture_23[] =
{
    {
        // At the directive's name, not in a skipped group, nor where a pragma ignores -Wpedantic.
        .name = "#ident under -pedantic",
        .source = "#ident \"x\"\nint a;\n#sccs \"y\"\n#if 0\n#ident \"z\"\n#endif\n"
                  "#pragma clang diagnostic ignored \"-Wpedantic\"\n#ident \"q\"\n",
        .options = { "-pedantic" },
        .warnings = 2,
        .compare_warning_text = true,
    },
    {
        .name = "#ident by default",
        .source = "#ident \"x\"\nint a;\n",
        .compare_warning_text = true,
    },
};
static const size_t fixture_23_lengths[] = {
sizeof("#ident \"x\"\nint a;\n#sccs \"y\"\n#if 0\n#ident \"z\"\n#endif\n"
                  "#pragma clang diagnostic ignored \"-Wpedantic\"\n#ident \"q\"\n")-1,
sizeof("#ident \"x\"\nint a;\n")-1
};
static const CheckDriverDefaultWarningFixture fixture_24[] =
{
    {
        .name = "library builtins named outside calls",
        .source = "void f(void) { int *q = malloc; }\n"
                  "void g(void) { int x = strlen; }\n"
                  "void h(void) { int *r = &malloc; void *s = calloc; (void)s; }\n",
        .errors = 6,
        .notes = 3,
    },
    {
        .name = "library builtins named outside calls before C99",
        .source = "int g(void) { return abs; }\n"
                  "void h(void) { void (*fp)(void) = free; (void)fp; }\n",
        .options = { "-std=gnu89" },
        .warnings = 2,
        .errors = 2,
        .notes = 2,
    },
    {
        // Before C99 the implicit declarations are warnings, so -Werror's errors carry clang's "-Werror," prefix.
        .name = "implicit declarations before C99, with -Wall",
        .source = "int g(void) { return abs(1) + foo(2); }\n",
        .options = { "-std=gnu89", "-Wall" },
        .warnings = 2,
        .notes = 1,
    },
};
static const size_t fixture_24_lengths[] = {
sizeof("void f(void) { int *q = malloc; }\n"
                  "void g(void) { int x = strlen; }\n"
                  "void h(void) { int *r = &malloc; void *s = calloc; (void)s; }\n")-1,
sizeof("int g(void) { return abs; }\n"
                  "void h(void) { void (*fp)(void) = free; (void)fp; }\n")-1,
sizeof("int g(void) { return abs(1) + foo(2); }\n")-1
};
static const CheckDriverDefaultWarningFixture fixture_25[] =
{
    {
        .name = "a literal conversion and a shift in one logical expression keep clang's order",
        .source = "int f(int x){return 1.5&&(x<<35);}\n",
        .warnings = 2,
    },
    {
        .name = "a shift in a boolean context warns under -Wall",
        .source = "int f(int x){return 1.5&&(x<<35);}\n",
        .options = { "-Wall" },
        .warnings = 3,
    },
    {
        .name = "shifts converted to _Bool through conditions, logical operators, assignments, calls and returns",
        .source = "_Bool b;void take(_Bool);_Bool r(int x){return x<<1;}\n"
                  "int f(int x,int y){if(x<<2)return 1;while(x<<3)x--;for(;x<<4;)x--;do x--;while(x<<5);y=!(x<<6);y=(x<<7)&&y;b=x<<8;take(x<<9);"
                  "b=(y,x<<10);b=y?(x<<11):0;return y;}\n",
        .options = { "-Wall" },
        .warnings = 12,
    },
    {
        .name = "literal shifts converted to _Bool always evaluate to one truth by default",
        .source = "int a(void){return (1<<2)?1:0;}int b(int x){return !(0<<x);}int c(void){return !(2<<32);}int d(void){return !(3<<32);}"
                  "int f(void){return !(1<<-1);}int g(int x){return !(-0<<x);}\n",
        .warnings = 9,
    },
    {
        .name = "parenthesized literals, unsigned shifts, casts and conditional arms take no warning of their own",
        .source = "int f(int x,int y,unsigned u){if((1)<<2)return 1;if(1<<(2))return 2;if(1u<<31)return 3;if(u<<2)return 4;"
                  "if((char)x<<2)return 5;if((_Bool)(x<<2))return 6;if(y?(x<<2):0)return 7;if((y,x<<2))return 8;return 0;}\n",
        .options = { "-Wall" },
        .warnings = 4,
    },
    {
        .name = "conditionals of integer constants always true, except the 0 and 1 idioms, casts and parentheses",
        .source = "int f(int x,int y){if(y?2:3)return 1;if(y?2:0)return 2;if(y?0:1)return 3;if(y?-1:3)return 4;if(y?(2):3)return 5;"
                  "if(y?2u:3u)return 6;if(y?2:3u)return 7;if(y?:3)return 8;if(y?1:3)return 9;return !(y?6:7);}\n",
        .warnings = 5,
    },
    {
        .name = "file-scope and brace initializers of _Bool warn at once in clang's order",
        .source = "_Bool g1=1<<2,g2=0?2:3;_Bool arr[2]={1<<3,1?8:9};\nvoid f(int x,int y){_Bool a[2]={x<<10,y?8:9};(void)a;}\n",
        .options = { "-Wall" },
        .warnings = 6,
    },
    {
        .name = "macro operands, unreachable code, short circuits and static assertions warn too",
        .source = "#define SH(x) ((x)<<1)\n#define CO(y) ((y)?2:3)\n"
                  "int f(int x,int y){if(SH(x))return 1;if(CO(y))return 2;return 0;if(x<<3)return 3;y=0&&(x<<4);y=1||(y?6:7);"
                  "_Static_assert(!(1<<3)||1,\"\");return y;}\n",
        .options = { "-Wall" },
        .warnings = 6,
        .notes = 2,
    },
    {
        .name = "_Atomic _Bool targets take no int-in-bool warning, unlike a plain _Bool",
        .source = "_Atomic _Bool fret(int x){return x<<1;}void take(_Atomic _Bool);void g(int x,int y){_Atomic _Bool l;l=x<<1;(void)l;_Atomic _Bool m=x<<2;"
                  "_Atomic _Bool n=y?2:3;_Bool p=y?2:3;take(x<<3);(void)m;(void)n;(void)p;}\n",
        .options = { "-Wall" },
        .warnings = 1,
    },
    {
        .name = "int-in-bool-context suppression keeps the tautological forms",
        .source = "int f(int x){if(x<<2)return 1;if(1<<2)return 2;if(x?2:3)return 3;return x<<40?1:0;}\n",
        .options = { "-Wall", "-Wno-int-in-bool-context" },
        .warnings = 2,
    },
    {
        .name = "tautological-compare suppression keeps int-in-bool-context",
        .source = "int f(int x){if(x<<2)return 1;if(1<<2)return 2;if(x?2:3)return 3;return x<<40?1:0;}\n",
        .options = { "-Wall", "-Wno-tautological-compare" },
        .warnings = 2,
    },
    {
        .name = "-Wno-most drops both groups",
        .source = "int f(int x){if(x<<2)return 1;if(1<<2)return 2;if(x?2:3)return 3;return x<<40?1:0;}\n",
        .options = { "-Wall", "-Wno-most" },
    },
    {
        .name = "tautological constant compare promotion rejects object publication",
        .source = "int f(int x){return (x?2:3)?1:0;}\n",
        .options = { "-Werror=tautological-constant-compare" },
        .errors = 1,
    },
};
static const size_t fixture_25_lengths[] = {
sizeof("int f(int x){return 1.5&&(x<<35);}\n")-1,
sizeof("int f(int x){return 1.5&&(x<<35);}\n")-1,
sizeof("_Bool b;void take(_Bool);_Bool r(int x){return x<<1;}\n"
                  "int f(int x,int y){if(x<<2)return 1;while(x<<3)x--;for(;x<<4;)x--;do x--;while(x<<5);y=!(x<<6);y=(x<<7)&&y;b=x<<8;take(x<<9);"
                  "b=(y,x<<10);b=y?(x<<11):0;return y;}\n")-1,
sizeof("int a(void){return (1<<2)?1:0;}int b(int x){return !(0<<x);}int c(void){return !(2<<32);}int d(void){return !(3<<32);}"
                  "int f(void){return !(1<<-1);}int g(int x){return !(-0<<x);}\n")-1,
sizeof("int f(int x,int y,unsigned u){if((1)<<2)return 1;if(1<<(2))return 2;if(1u<<31)return 3;if(u<<2)return 4;"
                  "if((char)x<<2)return 5;if((_Bool)(x<<2))return 6;if(y?(x<<2):0)return 7;if((y,x<<2))return 8;return 0;}\n")-1,
sizeof("int f(int x,int y){if(y?2:3)return 1;if(y?2:0)return 2;if(y?0:1)return 3;if(y?-1:3)return 4;if(y?(2):3)return 5;"
                  "if(y?2u:3u)return 6;if(y?2:3u)return 7;if(y?:3)return 8;if(y?1:3)return 9;return !(y?6:7);}\n")-1,
sizeof("_Bool g1=1<<2,g2=0?2:3;_Bool arr[2]={1<<3,1?8:9};\nvoid f(int x,int y){_Bool a[2]={x<<10,y?8:9};(void)a;}\n")-1,
sizeof("#define SH(x) ((x)<<1)\n#define CO(y) ((y)?2:3)\n"
                  "int f(int x,int y){if(SH(x))return 1;if(CO(y))return 2;return 0;if(x<<3)return 3;y=0&&(x<<4);y=1||(y?6:7);"
                  "_Static_assert(!(1<<3)||1,\"\");return y;}\n")-1,
sizeof("_Atomic _Bool fret(int x){return x<<1;}void take(_Atomic _Bool);void g(int x,int y){_Atomic _Bool l;l=x<<1;(void)l;_Atomic _Bool m=x<<2;"
                  "_Atomic _Bool n=y?2:3;_Bool p=y?2:3;take(x<<3);(void)m;(void)n;(void)p;}\n")-1,
sizeof("int f(int x){if(x<<2)return 1;if(1<<2)return 2;if(x?2:3)return 3;return x<<40?1:0;}\n")-1,
sizeof("int f(int x){if(x<<2)return 1;if(1<<2)return 2;if(x?2:3)return 3;return x<<40?1:0;}\n")-1,
sizeof("int f(int x){if(x<<2)return 1;if(1<<2)return 2;if(x?2:3)return 3;return x<<40?1:0;}\n")-1,
sizeof("int f(int x){return (x?2:3)?1:0;}\n")-1
};
static const CheckDriverDefaultWarningFixture fixture_26[] =
{
    {
        // The wrapped result at every width the graph folds, grouped by three past three digits, and its type: an operand's
        // typedef when only that operand has the result's type, canonical when both do.
        .name = "overflow results and types",
        .source = "typedef int T;\n"
                  "typedef long L;\n"
                  "int x = 0x7fffffff * 2;\n"
                  "long y = 0x7fffffffffffffffL * 2;\n"
                  "__int128 z = (__int128)0x7fffffffffffffffL * 0x7fffffffffffffffL * 4;\n"
                  "T a = (T)0x7fffffff * 2;\n"
                  "int b = (L)0x7fffffffffffffffL + 1 > 0;\n"
                  "int e = -(-2147483647 - 1);\n"
                  "int h = -2147483647 - 1 - 1;\n"
                  "unsigned long long q = 999999999LL * 999999999LL * 1000;\n"
                  "int f(int v) { int k = 2147483647 * 3 + v; return (1 << 31) + (3 << 30) + k; }\n",
        .warnings = 10,
        .compare_warning_text = true,
    },
    {
        // _BitInt results, past 128 bits too (check_wide_text's digits). Syntax only: clang's -c cannot compile a
        // _BitInt(70) static initializer.
        .name = "overflow results of bit-precise types",
        .source = "_BitInt(70) w = (_BitInt(70))0x1fffffffffffffffffwb * 4;\n"
                  "_BitInt(200) c = ((_BitInt(200))1 << 198) * 2;\n"
                  "signed _BitInt(9) s = (signed _BitInt(9))255 * 2;\n",
        .warnings = 3,
        .c23 = true,
        .syntax_only = true,
        .compare_warning_text = true,
    },
    {
        // What only the constant reader reads: an enumerator's value, a static assertion's condition, a case label.
        .name = "overflow results the constant reader folds",
        .source = "enum { E = 0x7fffffff + 1 };\n"
                  "enum { E2 = (long)0x7fffffffffffffffL * 3 > 0 };\n"
                  "_Static_assert(0x7fffffff + 1, \"\");\n"
                  "int g(int v) { switch (v) { case 0x7fffffff + 1: return 1; } return 0x7fffffff + 2; }\n",
        .warnings = 5,
        .compare_warning_text = true,
    },
};
static const size_t fixture_26_lengths[] = {
sizeof("typedef int T;\n"
                  "typedef long L;\n"
                  "int x = 0x7fffffff * 2;\n"
                  "long y = 0x7fffffffffffffffL * 2;\n"
                  "__int128 z = (__int128)0x7fffffffffffffffL * 0x7fffffffffffffffL * 4;\n"
                  "T a = (T)0x7fffffff * 2;\n"
                  "int b = (L)0x7fffffffffffffffL + 1 > 0;\n"
                  "int e = -(-2147483647 - 1);\n"
                  "int h = -2147483647 - 1 - 1;\n"
                  "unsigned long long q = 999999999LL * 999999999LL * 1000;\n"
                  "int f(int v) { int k = 2147483647 * 3 + v; return (1 << 31) + (3 << 30) + k; }\n")-1,
sizeof("_BitInt(70) w = (_BitInt(70))0x1fffffffffffffffffwb * 4;\n"
                  "_BitInt(200) c = ((_BitInt(200))1 << 198) * 2;\n"
                  "signed _BitInt(9) s = (signed _BitInt(9))255 * 2;\n")-1,
sizeof("enum { E = 0x7fffffff + 1 };\n"
                  "enum { E2 = (long)0x7fffffffffffffffL * 3 > 0 };\n"
                  "_Static_assert(0x7fffffff + 1, \"\");\n"
                  "int g(int v) { switch (v) { case 0x7fffffff + 1: return 1; } return 0x7fffffff + 2; }\n")-1
};
    static const CheckDriverDefaultWarningFixture fixture_27[] =
    {
        {
            .name = "logical discard reported call idioms",
            .source = "int work(int);void f(int x){x&&work(x);work(x)!=-38||work(x+1);}\n",
        },
        {
            .name = "logical discard reported assignment idioms",
            .source = "char* next(void);void f(int x,int*p){x&&(*p=1);char*v;(v=next())&&*v||(v=\"C\");}\n",
        },
        {
            .name = "logical discard value-only controls",
            .source = "void f(int a,int b){a&&b;a||b;}\n",
            .warnings = 2,
        },
        {
            .name = "logical discard left operands accept their own effects",
            .source = "int work(int);void f(int a,int b){work(a)&&b;work(a)||b;(a=1)&&b;(a=1)||b;a++&&b;--a||b;}\n",
        },
        {
            .name = "logical discard right writes and increments",
            .source = "void f(int a,int b,int*p){a&&(b+=1);a||(b-=1);a&&b++;a||--b;a&&(*p=1);}\n",
        },
        {
            .name = "logical discard nested value paths",
            .source = "int work(int);void f(int a,int b){a&&(b||work(a));a||(b&&work(a));(work(a)&&b)||a;(work(a)||b)&&a;}\n",
        },
        {
            .name = "logical discard off-path calls still warn",
            .source = "int work(int);void f(int a,int b,int*p){a&&(work(b)+1);(work(b)+1)||a;a&&(work(b)==b);a&&p[work(b)];}\n",
            .warnings = 4,
        },
        {
            .name = "logical discard comma result and literal-zero paths",
            .source = "int work(int);void f(int a){a&&(work(a),work(a));a&&(work(a),0);(a&&work(a),work(a));(work(a),a&&work(a));}\n",
        },
        {
            .name = "logical discard comma nonresult effects are insufficient",
            .source = "int work(int);void f(int a,int b){a&&(work(a),b);a&&(work(a),+0);}\n",
            .warnings = 2,
        },
        {
            .name = "logical discard conditional value arms",
            .source = "int work(int);void f(int a,int b,int c){a&&(b?work(a):c);a&&(b?c:work(a));a&&(b?:work(a));b?(a&&work(a)):a;}\n",
        },
        {
            .name = "logical discard conditional condition is insufficient",
            .source = "int work(int);void f(int a,int b,int c){a&&(work(a)?b:c);a&&(work(a)?:b);}\n",
            .warnings = 2,
        },
        {
            .name = "logical discard explicit nonvoid casts and unary values still warn",
            .source = "int work(int);void f(int a){a&&(int)work(a);a&&+work(a);(void)(a&&work(a));}\n",
            .warnings = 2,
        },
        {
            .name = "logical discard statement expression follows final result",
            .source = "int work(int);void f(int a,int b){a&&({work(a);});a&&({work(a);b;});}\n",
            .warnings = 1,
        },
        {
            .name = "logical discard selected value paths",
            .source = "int work(int);void f(int a){a&&_Generic(a,int:work(a),default:0);a&&__builtin_choose_expr(1,work(a),0);}\n",
        },
        {
            .name = "logical discard direct volatile reads",
            .source = "struct S{volatile int value;};void f(int a,volatile int*p,struct S*s){a&&*p;*p||a;a&&s->value;}\n",
        },
        {
            .name = "logical discard values computed from volatile reads still warn",
            .source = "void f(int a,volatile int*p){a&&(*p+1);a&&(int)*p;}\n",
            .warnings = 2,
        },
        {
            .name = "logical discard short-circuited effects remain syntactically quiet",
            .source = "int work(int);void f(int a){0&&work(a);1||work(a);}\n",
        },
        {
            .name = "logical discard attributed calls keep their result obligation",
            .source = "int pure_fn(int)__attribute__((pure));int const_fn(int)__attribute__((const));"
                      "int required(int)__attribute__((warn_unused_result));\n"
                      "void f(int a){a&&pure_fn(a);const_fn(a)||a;a&&required(a);a&&pure_fn(a++);}\n",
            .warnings = 4,
        },
        {
            .name = "logical discard inherited contracts survive a bare redeclaration",
            .source = "int pure_fn(int)__attribute__((pure));int pure_fn(int);"
                      "int const_fn(int)__attribute__((const));int const_fn(int);"
                      "int required(int)__attribute__((warn_unused_result));int required(int);\n"
                      "void f(int a){a&&pure_fn(a);a&&const_fn(a);a&&required(a);}\n",
            .warnings = 3,
        },
        {
            .name = "logical discard contracts follow source-visible declaration snapshots",
            .source = "int work(int);void before(int a){a&&work(a);}\n"
                      "int work(int)__attribute__((pure));int work(int);void after(int a){a&&work(a);}\n",
            .warnings = 1,
        },
        {
            .name = "logical discard a block contract does not escape its scope",
            .source = "int work(int);void f(int a){{extern int work(int)__attribute__((pure));a&&work(a);}a&&work(a);}\n",
            .warnings = 1,
        },
        {
            .name = "logical discard each contract kind inherits independently",
            .source = "int trace(const char*,...)__attribute__((pure));"
                      "int trace(const char*,...)__attribute__((format(printf,1,2)));"
                      "int required(int)__attribute__((warn_unused_result));int required(int)__attribute__((const));int required(int);\n"
                      "void f(int a){a&&trace(\"%d\",a);a&&required(a);}\n",
            .warnings = 2,
        },
        {
            .name = "logical discard direct function designator wrappers",
            .source = "int work(int);void f(int a){a&&(work)(a);a&&(&work)(a);a&&(*work)(a);}\n",
        },
        {
            .name = "logical discard typedef result contracts retain baseline warnings",
            .source = "typedef int Required __attribute__((warn_unused_result));Required work(int);void f(int a){a&&work(a);}\n",
            .warnings = 1,
        },
        {
            .name = "logical discard nested typedef result contracts retain baseline warnings",
            .source = "typedef int Required __attribute__((warn_unused_result));typedef Required Alias;Alias work(int);void f(int a){a&&work(a);}\n",
            .warnings = 1,
        },
        {
            .name = "logical discard typeof result contracts retain baseline warnings",
            .source = "typedef int Required __attribute__((warn_unused_result));typeof((Required)0) work(int);void f(int a){a&&work(a);}\n",
            .warnings = 1,
        },
        {
            .name = "logical discard a body-local typedef contract survives requested lanes",
            .source = "void f(int a){typedef int Required __attribute__((warn_unused_result));extern Required work(void);a&&work();}\n"
                      "int anchor(int a){return a+1;}\n",
            .warnings = 1,
        },
        {
            .name = "logical discard warning-specific source policy",
            .source = "int work(int);void f(int a,int b){\n"
                      "#pragma clang diagnostic push\n#pragma clang diagnostic ignored \"-Wunused-value\"\n"
                      "a&&b;\n#pragma clang diagnostic pop\na&&work(a);a&&b;}\n",
            .warnings = 1,
        },
        {
            .name = "logical discard command-line warning suppression",
            .source = "int work(int);void f(int a,int b){a&&b;a&&work(a);}\n",
            .options = { "-Wno-unused-value" },
        },
        {
            .name = "logical discard ordinary library calls accept discard",
            .source = "typedef __SIZE_TYPE__ size_t;int printf(const char*,...);void*memcpy(void*,const void*,size_t);"
                      "void*memmove(void*,const void*,size_t);void*memset(void*,int,size_t);void*malloc(size_t);"
                      "void*calloc(size_t,size_t);void*realloc(void*,size_t);int snprintf(char*,size_t,const char*,...);"
                      "int strcmp(const char*,const char*);size_t strlen(const char*);char*strdup(const char*);\n"
                      "void f(int a,char*d,const char*s,size_t n){a&&printf(\"%s\",s);a&&memcpy(d,s,n);a&&memmove(d,s,n);"
                      "a&&memset(d,0,n);a&&malloc(n);a&&calloc(n,1);a&&realloc(d,n);a&&snprintf(d,n,\"%s\",s);"
                      "a&&strcmp(d,s);a&&strlen(s);a&&strdup(s);}\n",
        },
        {
            .name = "logical discard implicit builtin contracts retain warnings",
            .source = "int abs(int);long labs(long);long long llabs(long long);double fabs(double);double floor(double);"
                      "int isalpha(int);int toupper(int);\n"
                      "void f(int a,double x){a&&abs(a);a&&labs(a);a&&llabs(a);a&&fabs(x);a&&floor(x);a&&isalpha(a);a&&toupper(a);}\n",
            .warnings = 7,
        },
        {
            .name = "logical discard disabling builtins drops implicit contracts",
            .source = "int abs(int);long labs(long);long long llabs(long long);double fabs(double);double floor(double);"
                      "int isalpha(int);int toupper(int);\n"
                      "void f(int a,double x){a&&abs(a);a&&labs(a);a&&llabs(a);a&&fabs(x);a&&floor(x);a&&isalpha(a);a&&toupper(a);}\n",
            .options = { "-fno-builtin" },
        },
        {
            .name = "logical discard per-name builtin disabling retains other contracts",
            .source = "int abs(int);long labs(long);void f(int a){a&&abs(a);a&&labs(a);}\n",
            .options = { "-fno-builtin-abs" },
            .warnings = 1,
        },
        {
            .name = "logical discard freestanding declarations have no implicit contracts",
            .source = "int abs(int);int isalpha(int);void f(int a){a&&abs(a);a&&isalpha(a);}\n",
            .options = { "-ffreestanding" },
        },
        {
            .name = "logical discard internal library spellings remain ordinary functions",
            .source = "static int abs(int a){return a;}static int isalpha(int a){return a;}void f(int a){a&&abs(a);a&&isalpha(a);}\n",
        },
        {
            .name = "logical discard explicit library contracts remain effective",
            .source = "typedef __SIZE_TYPE__ size_t;void*malloc(size_t)__attribute__((warn_unused_result));"
                      "int printf(const char*,...)__attribute__((pure));\n"
                      "void f(int a,size_t n){a&&malloc(n);a&&printf(\"%d\",a);}\n",
            .warnings = 2,
        },
        {
            .name = "logical discard explicit contracts survive builtin disabling",
            .source = "typedef __SIZE_TYPE__ size_t;void*malloc(size_t)__attribute__((warn_unused_result));"
                      "int printf(const char*,...)__attribute__((pure));\n"
                      "void f(int a,size_t n){a&&malloc(n);a&&printf(\"%d\",a);}\n",
            .options = { "-fno-builtin" },
            .warnings = 2,
        },
        {
            .name = "logical discard ordinary calls retain their policy when freestanding",
            .source = "int work(int);void f(int a){a&&work(a);}\n",
            .options = { "-ffreestanding" },
        },
    };
static const size_t fixture_27_lengths[] = {
sizeof("int work(int);void f(int x){x&&work(x);work(x)!=-38||work(x+1);}\n")-1,
sizeof("char* next(void);void f(int x,int*p){x&&(*p=1);char*v;(v=next())&&*v||(v=\"C\");}\n")-1,
sizeof("void f(int a,int b){a&&b;a||b;}\n")-1,
sizeof("int work(int);void f(int a,int b){work(a)&&b;work(a)||b;(a=1)&&b;(a=1)||b;a++&&b;--a||b;}\n")-1,
sizeof("void f(int a,int b,int*p){a&&(b+=1);a||(b-=1);a&&b++;a||--b;a&&(*p=1);}\n")-1,
sizeof("int work(int);void f(int a,int b){a&&(b||work(a));a||(b&&work(a));(work(a)&&b)||a;(work(a)||b)&&a;}\n")-1,
sizeof("int work(int);void f(int a,int b,int*p){a&&(work(b)+1);(work(b)+1)||a;a&&(work(b)==b);a&&p[work(b)];}\n")-1,
sizeof("int work(int);void f(int a){a&&(work(a),work(a));a&&(work(a),0);(a&&work(a),work(a));(work(a),a&&work(a));}\n")-1,
sizeof("int work(int);void f(int a,int b){a&&(work(a),b);a&&(work(a),+0);}\n")-1,
sizeof("int work(int);void f(int a,int b,int c){a&&(b?work(a):c);a&&(b?c:work(a));a&&(b?:work(a));b?(a&&work(a)):a;}\n")-1,
sizeof("int work(int);void f(int a,int b,int c){a&&(work(a)?b:c);a&&(work(a)?:b);}\n")-1,
sizeof("int work(int);void f(int a){a&&(int)work(a);a&&+work(a);(void)(a&&work(a));}\n")-1,
sizeof("int work(int);void f(int a,int b){a&&({work(a);});a&&({work(a);b;});}\n")-1,
sizeof("int work(int);void f(int a){a&&_Generic(a,int:work(a),default:0);a&&__builtin_choose_expr(1,work(a),0);}\n")-1,
sizeof("struct S{volatile int value;};void f(int a,volatile int*p,struct S*s){a&&*p;*p||a;a&&s->value;}\n")-1,
sizeof("void f(int a,volatile int*p){a&&(*p+1);a&&(int)*p;}\n")-1,
sizeof("int work(int);void f(int a){0&&work(a);1||work(a);}\n")-1,
sizeof("int pure_fn(int)__attribute__((pure));int const_fn(int)__attribute__((const));"
                      "int required(int)__attribute__((warn_unused_result));\n"
                      "void f(int a){a&&pure_fn(a);const_fn(a)||a;a&&required(a);a&&pure_fn(a++);}\n")-1,
sizeof("int pure_fn(int)__attribute__((pure));int pure_fn(int);"
                      "int const_fn(int)__attribute__((const));int const_fn(int);"
                      "int required(int)__attribute__((warn_unused_result));int required(int);\n"
                      "void f(int a){a&&pure_fn(a);a&&const_fn(a);a&&required(a);}\n")-1,
sizeof("int work(int);void before(int a){a&&work(a);}\n"
                      "int work(int)__attribute__((pure));int work(int);void after(int a){a&&work(a);}\n")-1,
sizeof("int work(int);void f(int a){{extern int work(int)__attribute__((pure));a&&work(a);}a&&work(a);}\n")-1,
sizeof("int trace(const char*,...)__attribute__((pure));"
                      "int trace(const char*,...)__attribute__((format(printf,1,2)));"
                      "int required(int)__attribute__((warn_unused_result));int required(int)__attribute__((const));int required(int);\n"
                      "void f(int a){a&&trace(\"%d\",a);a&&required(a);}\n")-1,
sizeof("int work(int);void f(int a){a&&(work)(a);a&&(&work)(a);a&&(*work)(a);}\n")-1,
sizeof("typedef int Required __attribute__((warn_unused_result));Required work(int);void f(int a){a&&work(a);}\n")-1,
sizeof("typedef int Required __attribute__((warn_unused_result));typedef Required Alias;Alias work(int);void f(int a){a&&work(a);}\n")-1,
sizeof("typedef int Required __attribute__((warn_unused_result));typeof((Required)0) work(int);void f(int a){a&&work(a);}\n")-1,
sizeof("void f(int a){typedef int Required __attribute__((warn_unused_result));extern Required work(void);a&&work();}\n"
                      "int anchor(int a){return a+1;}\n")-1,
sizeof("int work(int);void f(int a,int b){\n"
                      "#pragma clang diagnostic push\n#pragma clang diagnostic ignored \"-Wunused-value\"\n"
                      "a&&b;\n#pragma clang diagnostic pop\na&&work(a);a&&b;}\n")-1,
sizeof("int work(int);void f(int a,int b){a&&b;a&&work(a);}\n")-1,
sizeof("typedef __SIZE_TYPE__ size_t;int printf(const char*,...);void*memcpy(void*,const void*,size_t);"
                      "void*memmove(void*,const void*,size_t);void*memset(void*,int,size_t);void*malloc(size_t);"
                      "void*calloc(size_t,size_t);void*realloc(void*,size_t);int snprintf(char*,size_t,const char*,...);"
                      "int strcmp(const char*,const char*);size_t strlen(const char*);char*strdup(const char*);\n"
                      "void f(int a,char*d,const char*s,size_t n){a&&printf(\"%s\",s);a&&memcpy(d,s,n);a&&memmove(d,s,n);"
                      "a&&memset(d,0,n);a&&malloc(n);a&&calloc(n,1);a&&realloc(d,n);a&&snprintf(d,n,\"%s\",s);"
                      "a&&strcmp(d,s);a&&strlen(s);a&&strdup(s);}\n")-1,
sizeof("int abs(int);long labs(long);long long llabs(long long);double fabs(double);double floor(double);"
                      "int isalpha(int);int toupper(int);\n"
                      "void f(int a,double x){a&&abs(a);a&&labs(a);a&&llabs(a);a&&fabs(x);a&&floor(x);a&&isalpha(a);a&&toupper(a);}\n")-1,
sizeof("int abs(int);long labs(long);long long llabs(long long);double fabs(double);double floor(double);"
                      "int isalpha(int);int toupper(int);\n"
                      "void f(int a,double x){a&&abs(a);a&&labs(a);a&&llabs(a);a&&fabs(x);a&&floor(x);a&&isalpha(a);a&&toupper(a);}\n")-1,
sizeof("int abs(int);long labs(long);void f(int a){a&&abs(a);a&&labs(a);}\n")-1,
sizeof("int abs(int);int isalpha(int);void f(int a){a&&abs(a);a&&isalpha(a);}\n")-1,
sizeof("static int abs(int a){return a;}static int isalpha(int a){return a;}void f(int a){a&&abs(a);a&&isalpha(a);}\n")-1,
sizeof("typedef __SIZE_TYPE__ size_t;void*malloc(size_t)__attribute__((warn_unused_result));"
                      "int printf(const char*,...)__attribute__((pure));\n"
                      "void f(int a,size_t n){a&&malloc(n);a&&printf(\"%d\",a);}\n")-1,
sizeof("typedef __SIZE_TYPE__ size_t;void*malloc(size_t)__attribute__((warn_unused_result));"
                      "int printf(const char*,...)__attribute__((pure));\n"
                      "void f(int a,size_t n){a&&malloc(n);a&&printf(\"%d\",a);}\n")-1,
sizeof("int work(int);void f(int a){a&&work(a);}\n")-1
};
static const CheckDriverDefaultWarningFixture fixture_28[] =
{
    {
        // A cast of an lvalue, through parentheses, as an assignment's, a compound assignment's, an increment's or a
        // decrement's operand: clang's lvalue cast error at the cast's `(`, after the cast's own warning. A cast of an
        // rvalue and another rvalue keep "expression is not assignable" at the operator.
        .name = "lvalue casts",
        .source = "int *p;\n"
                  "int x;\n"
                  "struct S { int m; } s;\n"
                  "void f(void)\n"
                  "{\n"
                  "    (int)p = 0;\n"
                  "    (char)*p += 1;\n"
                  "    ((int)p)++;\n"
                  "    --(long)x;\n"
                  "    (int)x = 1;\n"
                  "    ((int)(x)) = 2;\n"
                  "    (int)5 = 3;\n"
                  "    (int)s.m = 4;\n"
                  "    x + 1 = 5;\n"
                  "    (short)x <<= 2;\n"
                  "}\n",
        .warnings = 2,
        .errors = 10,
    },
};
static const size_t fixture_28_lengths[] = {
sizeof("int *p;\n"
                  "int x;\n"
                  "struct S { int m; } s;\n"
                  "void f(void)\n"
                  "{\n"
                  "    (int)p = 0;\n"
                  "    (char)*p += 1;\n"
                  "    ((int)p)++;\n"
                  "    --(long)x;\n"
                  "    (int)x = 1;\n"
                  "    ((int)(x)) = 2;\n"
                  "    (int)5 = 3;\n"
                  "    (int)s.m = 4;\n"
                  "    x + 1 = 5;\n"
                  "    (short)x <<= 2;\n"
                  "}\n")-1
};
static const CheckDriverDefaultWarningFixture fixture_29[] =
{
    {
        // Constants out of an operand type's range on either side, its typedef as written, an enumerator's name, a _Bool's
        // and a known boolean's range, an unsigned comparison's wrapped gap, and those in range or at a limit, which say
        // nothing here.
        .name = "constants out of an operand's range",
        .source = "typedef signed char S;\n"
                  "enum E { A = 1000, B = 2 };\n"
                  "int f(signed char x) { return x < 1000; }\n"
                  "int h(unsigned char c, S s, _Bool b, unsigned u, short sh) {\n"
                  "  int r = 0;\n"
                  "  r += c == -1; r += c != 256; r += 255 >= c; r += c > 255; r += c >= 255;\n"
                  "  r += s == 200; r += s < A; r += b == 2; r += (c < u) == 2; r += 3 < (c != 1);\n"
                  "  r += u < -1; r += u == -1L; r += sh == 40000; r += s == 4000000000u; r += sh < 0x10000u;\n"
                  "  r += c < 0; r += c >= 0; r += s == B; r += c < 10;\n"
                  "  return r;\n"
                  "}\n"
                  "int m(signed char x) { if (0) return x < 1000; return sizeof(x < 1000); }\n"
                  "int n(signed char x) { switch (x) { case 1000 > 5: return x == 300; } return 0; }\n",
        .warnings = 12,
        .compare_warning_text = true,
    },
    {
        // A _BitInt constant past 128 bits (check_wide_text's digits), and file scope, where the comparison completes after
        // the initializer's error.
        .name = "constants out of range past 128 bits and at file scope",
        .source = "int g(signed char x) { return x < ((_BitInt(200))1 << 150); }\n"
                  "int k(long long v) { return v == 0x10000000000000000wb; }\n"
                  "signed char gc;\n"
                  "int gl = gc < 1000;\n",
        .warnings = 3,
        .errors = 1,
        .c23 = true,
        .syntax_only = true,
    },
    {
        // -Wsign-compare (-Wextra) gives nothing of an always true or false comparison, and both follow clang's walk of a
        // full expression: a comparison before its operands, an assignment's, a conditional's and a comparison's operands
        // left to right, any other node's right to left, a call's last argument first; GNU's ?: reads its condition once.
        .name = "constants out of range under -Wextra",
        .source = "int f(signed char s, unsigned u) { return (s == 4000000000u) + (u < -1) + (s < u); }\n"
                  "int g(unsigned char c, signed char s, unsigned u, int i, int h(int, int)) {\n"
                  "  int r = (c == -1) + (c != 256) + ((c < 300) == (c > -5));\n"
                  "  r += (c < 300) ?: 1; r += h(c < 300, c > -5); r = c > 300 ? c < 400 : c < 500;\n"
                  "  r += (i < u) + (s < u);\n"
                  "  return r;\n"
                  "}\n",
        .options = { "-Wextra" },
        .warnings = 15,
        .compare_warning_text = true,
    },
    {
        // Forty comparisons across the candidate pass's 16-node blocks (check_common_range_candidates): constants out of
        // and in a narrow operand's range on either side, both sides constant, neither, and a known boolean's.
        .name = "constants out of range across vector blocks",
        .source = "int f(unsigned char c, signed char s, int i, short h)\n"
                  "{\n"
                  "    int r = 0;\n"
                  "    r += c == 300; r += -1 < c; r += s > 2; r += i < 3; r += h == 200;\n"
                  "    r += c < i; r += 1 < 129; r += c != 'x'; r += s <= -70000; r += (c == 1) == 9;\n"
                  "    r += c == 300; r += -1 < c; r += s > 2; r += i < 3; r += h == 200;\n"
                  "    r += c < i; r += 1 < 129; r += c != 'x'; r += s <= -70000; r += (c == 1) == 9;\n"
                  "    r += c == 300; r += -1 < c; r += s > 2; r += i < 3; r += h == 200;\n"
                  "    r += c < i; r += 1 < 129; r += c != 'x'; r += s <= -70000; r += (c == 1) == 9;\n"
                  "    r += c == 300; r += -1 < c; r += s > 2; r += i < 3; r += h == 200;\n"
                  "    r += c < i; r += 1 < 129; r += c != 'x'; r += s <= -70000; r += (c == 1) == 9;\n"
                  "    return r;\n"
                  "}\n",
        .warnings = 16,
    },
    {
        // The void cast leaves no reach candidate after the comparisons (#2702). A return conversion here would drain
        // the full batches in the scan loop, hiding a missing second or third batch in the final drain.
        .name = "many trailing out of range comparisons",
        .source = "void many(unsigned char c) { (void)(\n"
                  "    (c > 300) + (c > 300) + (c > 300) + (c > 300) + (c > 300) + (c > 300) +\n"
                  "    (c > 300) + (c > 300) + (c > 300) + (c > 300) + (c > 300) + (c > 300) +\n"
                  "    (c > 300) + (c > 300) + (c > 300) + (c > 300) + (c > 300) + (c > 300) +\n"
                  "    (c > 300) + (c > 300) + (c > 300) + (c > 300) + (c > 300) + (c > 300) +\n"
                  "    (c > 300) + (c > 300) + (c > 300) + (c > 300) + (c > 300) + (c > 300) +\n"
                  "    (c > 300) + (c > 300) + (c > 300) + (c > 300) + (c > 300) + (c > 300) +\n"
                  "    (c > 300) + (c > 300) + (c > 300) + (c > 300) + (c > 300) + (c > 300) +\n"
                  "    (c > 300) + (c > 300) + (c > 300) + (c > 300) + (c > 300) + (c > 300)); }\n",
        .warnings = 48,
    },
    {
        // The vector test's type rule: an int or a long class operand against a constant its type covers is no candidate,
        // a narrower one's constant is (an int's against a long constant), and a boolean operator's always is.
        .name = "constants out of range of builtin types",
        .source = "int f(int i, unsigned long ul, long l, unsigned u, _Bool b)\n"
                  "{\n"
                  "    int r = 0;\n"
                  "    r += i == 4000000000; r += ul == -1; r += l < 5; r += u > 4294967296; r += (i < l) == 3;\n"
                  "    r += i < 5L; r += !i == 2; r += (i || l) > 2; r += b == 3; r += (unsigned char)i < 256;\n"
                  "    r += 2 < i; r += i == 1; r += l != 1L; r += u == 7u; r += -1 == ul; r += (long)i > 4294967296L;\n"
                  "    return r;\n"
                  "}\n",
        .warnings = 8,
        .notes = 2,
    },
};
static const size_t fixture_29_lengths[] = {
sizeof("typedef signed char S;\n"
                  "enum E { A = 1000, B = 2 };\n"
                  "int f(signed char x) { return x < 1000; }\n"
                  "int h(unsigned char c, S s, _Bool b, unsigned u, short sh) {\n"
                  "  int r = 0;\n"
                  "  r += c == -1; r += c != 256; r += 255 >= c; r += c > 255; r += c >= 255;\n"
                  "  r += s == 200; r += s < A; r += b == 2; r += (c < u) == 2; r += 3 < (c != 1);\n"
                  "  r += u < -1; r += u == -1L; r += sh == 40000; r += s == 4000000000u; r += sh < 0x10000u;\n"
                  "  r += c < 0; r += c >= 0; r += s == B; r += c < 10;\n"
                  "  return r;\n"
                  "}\n"
                  "int m(signed char x) { if (0) return x < 1000; return sizeof(x < 1000); }\n"
                  "int n(signed char x) { switch (x) { case 1000 > 5: return x == 300; } return 0; }\n")-1,
sizeof("int g(signed char x) { return x < ((_BitInt(200))1 << 150); }\n"
                  "int k(long long v) { return v == 0x10000000000000000wb; }\n"
                  "signed char gc;\n"
                  "int gl = gc < 1000;\n")-1,
sizeof("int f(signed char s, unsigned u) { return (s == 4000000000u) + (u < -1) + (s < u); }\n"
                  "int g(unsigned char c, signed char s, unsigned u, int i, int h(int, int)) {\n"
                  "  int r = (c == -1) + (c != 256) + ((c < 300) == (c > -5));\n"
                  "  r += (c < 300) ?: 1; r += h(c < 300, c > -5); r = c > 300 ? c < 400 : c < 500;\n"
                  "  r += (i < u) + (s < u);\n"
                  "  return r;\n"
                  "}\n")-1,
sizeof("int f(unsigned char c, signed char s, int i, short h)\n"
                  "{\n"
                  "    int r = 0;\n"
                  "    r += c == 300; r += -1 < c; r += s > 2; r += i < 3; r += h == 200;\n"
                  "    r += c < i; r += 1 < 129; r += c != 'x'; r += s <= -70000; r += (c == 1) == 9;\n"
                  "    r += c == 300; r += -1 < c; r += s > 2; r += i < 3; r += h == 200;\n"
                  "    r += c < i; r += 1 < 129; r += c != 'x'; r += s <= -70000; r += (c == 1) == 9;\n"
                  "    r += c == 300; r += -1 < c; r += s > 2; r += i < 3; r += h == 200;\n"
                  "    r += c < i; r += 1 < 129; r += c != 'x'; r += s <= -70000; r += (c == 1) == 9;\n"
                  "    r += c == 300; r += -1 < c; r += s > 2; r += i < 3; r += h == 200;\n"
                  "    r += c < i; r += 1 < 129; r += c != 'x'; r += s <= -70000; r += (c == 1) == 9;\n"
                  "    return r;\n"
                  "}\n")-1,
sizeof("void many(unsigned char c) { (void)(\n"
                  "    (c > 300) + (c > 300) + (c > 300) + (c > 300) + (c > 300) + (c > 300) +\n"
                  "    (c > 300) + (c > 300) + (c > 300) + (c > 300) + (c > 300) + (c > 300) +\n"
                  "    (c > 300) + (c > 300) + (c > 300) + (c > 300) + (c > 300) + (c > 300) +\n"
                  "    (c > 300) + (c > 300) + (c > 300) + (c > 300) + (c > 300) + (c > 300) +\n"
                  "    (c > 300) + (c > 300) + (c > 300) + (c > 300) + (c > 300) + (c > 300) +\n"
                  "    (c > 300) + (c > 300) + (c > 300) + (c > 300) + (c > 300) + (c > 300) +\n"
                  "    (c > 300) + (c > 300) + (c > 300) + (c > 300) + (c > 300) + (c > 300) +\n"
                  "    (c > 300) + (c > 300) + (c > 300) + (c > 300) + (c > 300) + (c > 300)); }\n")-1,
sizeof("int f(int i, unsigned long ul, long l, unsigned u, _Bool b)\n"
                  "{\n"
                  "    int r = 0;\n"
                  "    r += i == 4000000000; r += ul == -1; r += l < 5; r += u > 4294967296; r += (i < l) == 3;\n"
                  "    r += i < 5L; r += !i == 2; r += (i || l) > 2; r += b == 3; r += (unsigned char)i < 256;\n"
                  "    r += 2 < i; r += i == 1; r += l != 1L; r += u == 7u; r += -1 == ul; r += (long)i > 4294967296L;\n"
                  "    return r;\n"
                  "}\n")-1
};
static const char check_driver_pointer_cast_source[] =
    "#define TOI(p) ((int)(p))\n"
    "typedef void *VP; typedef unsigned U32; typedef enum E { E0 } EE;\n"
    "void *q;\n"
    "int z = sizeof((char)&q);\n"
    "_Static_assert(sizeof((short)&q) == 2, \"\");\n"
    "void f(int *p, VP v, int a[2], const char *s, _BitInt(32) *bp, int n) {\n"
    "    int x = (int)p << 40;\n"
    "    int y = TOI(v);\n"
    "    U32 u = (U32)v + (U32)a + (U32)\"lit\" + (unsigned char)s + (U32)&x;\n"
    "    EE e = (EE)v; enum E e2 = (enum E)p;\n"
    "    _Bool b = (_Bool)p; long l = (long)p; unsigned long long m = (unsigned long long)p;\n"
    "    _BitInt(32) w = (_BitInt(32))p; __int128 h = (__int128)p; int c = (int)(int[2]){ 0 }; int d = (int)*&p;\n"
    "    int vla[n]; int g = (char)vla + (short)bp;\n"
    "    (void)x; (void)y; (void)u; (void)e; (void)e2; (void)b; (void)l; (void)m; (void)w; (void)h; (void)c; (void)d; (void)g;\n"
    "    (void)sizeof((short)p); (void)_Generic((char)v, char: 0);\n"
    "}\n";
static const CheckDriverDefaultWarningFixture fixture_30[] =
{
    {
        .name = "casts from pointers to narrower integers",
        .source = check_driver_pointer_cast_source,
        .warnings = 19,
        .notes = 1,
    },
    {
        .name = "casts from pointers to narrower integers in C23 under -Wall -Wextra",
        .source = check_driver_pointer_cast_source,
        .options = { "-Wall", "-Wextra" },
        .warnings = 19,
        .notes = 1,
        .c23 = true,
    },
    {
        .name = "-Wno-pointer-to-int-cast holds the enumerations' and void's",
        .source = check_driver_pointer_cast_source,
        .options = { "-Wno-pointer-to-int-cast" },
        .warnings = 1,
    },
    {
        .name = "-Wno-void-pointer-to-int-cast holds -Wvoid-pointer-to-enum-cast",
        .source = check_driver_pointer_cast_source,
        .options = { "-Wno-void-pointer-to-int-cast" },
        .warnings = 15,
    },
    {
        .name = "-Wno-pointer-to-enum-cast holds -Wvoid-pointer-to-enum-cast",
        .source = check_driver_pointer_cast_source,
        .options = { "-Wno-pointer-to-enum-cast" },
        .warnings = 17,
        .notes = 1,
    },
    {
        .name = "-Werror=pointer-to-int-cast with -Wno-everything -Wvoid-pointer-to-enum-cast",
        .source = check_driver_pointer_cast_source,
        .options = { "-Wno-everything", "-Wvoid-pointer-to-enum-cast", "-Werror=pointer-to-int-cast" },
        .errors = 18,
        .notes = 1,
    },
};
static const size_t fixture_30_lengths[] = {
sizeof(check_driver_pointer_cast_source)-1,
sizeof(check_driver_pointer_cast_source)-1,
sizeof(check_driver_pointer_cast_source)-1,
sizeof(check_driver_pointer_cast_source)-1,
sizeof(check_driver_pointer_cast_source)-1,
sizeof(check_driver_pointer_cast_source)-1
};
static const CheckDriverDefaultWarningFixture fixture_31[] =
{
    {
        .name = "register objects' addresses and arrays' decays",
        .source = "struct S { int m; int a[2]; };\n"
                  "void f(void) {\n"
                  "    register int x; register int arr[3]; register struct S s;\n"
                  "    int *p = &x;\n"
                  "    int *q = arr;\n"
                  "    int *r = &arr[1];\n"
                  "    int *t = &s.m;\n"
                  "    int *u = s.a;\n"
                  "    int (*v)[3] = &arr;\n"
                  "    int y = arr[0];\n"
                  "    struct S *w = &s;\n"
                  "    (void)p; (void)q; (void)r; (void)t; (void)u; (void)v; (void)y; (void)w;\n"
                  "}\n",
        .errors = 7,
    },
    {
        .name = "a register array decays at its unparenthesized name, in every operand",
        .source = "struct I { int k; };\n"
                  "struct S { int m; int a[2]; struct I in; };\n"
                  "int g(int *);\n"
                  "int h(int p[2]);\n"
                  "void f(register int prm, register int parr[2]) {\n"
                  "    register int arr[3]; register struct S s; register struct S sa[2];\n"
                  "    int n1 = sizeof(arr);\n"
                  "    int n2 = sizeof arr[0];\n"
                  "    int n3 = *arr;\n"
                  "    int n4 = *(arr + 1);\n"
                  "    int n5 = g(arr);\n"
                  "    int *p6 = &arr[0];\n"
                  "    int *p7 = (arr);\n"
                  "    __typeof__(arr) t9;\n"
                  "    int *p10 = &s.in.k;\n"
                  "    int n11 = s.a[0];\n"
                  "    int n12 = sa[0].m;\n"
                  "    int *p13 = &prm;\n"
                  "    int *p14 = parr;\n"
                  "    int *p15 = &parr[0];\n"
                  "    int n16 = sizeof(&arr);\n"
                  "    int *p17 = 1 ? arr : 0;\n"
                  "    int n18 = (arr)[1];\n"
                  "    int n19 = 1[arr];\n"
                  "    int *p20 = (int *)arr;\n"
                  "    struct S cp = s;\n"
                  "    (void)n1;(void)n2;(void)n3;(void)n4;(void)n5;(void)p6;(void)p7;(void)t9;(void)p10;(void)n11;(void)n12;(void)p13;(void)p14;(void)p15;(void)n16;(void)p17;(void)n18;(void)n19;(void)p20;(void)cp;\n"
                  "}\n",
        .errors = 12,
    },
    {
        .name = "the & operator climbs parentheses, members and array subscripts to a register object",
        .source = "struct S { int m; int a[2]; struct { int k; } in; };\n"
                  "void f(void) {\n"
                  "    register int x; register struct S s; register int arr[2]; register int *rp;\n"
                  "    int *p1 = &(x);\n"
                  "    int *p2 = &((s).m);\n"
                  "    int *p3 = &s.a[0];\n"
                  "    int (*p4)[2] = &s.a;\n"
                  "    int *p5 = &(s.in.k);\n"
                  "    int **p6 = &rp;\n"
                  "    int *p7 = &*rp;\n"
                  "    int *p8 = &(arr)[0];\n"
                  "    void *p9 = &(arr);\n"
                  "    int *p10 = (&x);\n"
                  "    int *p11 = &x + 0, *p12 = &arr[1] + 1;\n"
                  "    (void)p1;(void)p2;(void)p3;(void)p4;(void)p5;(void)p6;(void)p7;(void)p8;(void)p9;(void)p10;(void)p11;(void)p12;\n"
                  "}\n",
        .errors = 11,
    },
};
static const size_t fixture_31_lengths[] = {
sizeof("struct S { int m; int a[2]; };\n"
                  "void f(void) {\n"
                  "    register int x; register int arr[3]; register struct S s;\n"
                  "    int *p = &x;\n"
                  "    int *q = arr;\n"
                  "    int *r = &arr[1];\n"
                  "    int *t = &s.m;\n"
                  "    int *u = s.a;\n"
                  "    int (*v)[3] = &arr;\n"
                  "    int y = arr[0];\n"
                  "    struct S *w = &s;\n"
                  "    (void)p; (void)q; (void)r; (void)t; (void)u; (void)v; (void)y; (void)w;\n"
                  "}\n")-1,
sizeof("struct I { int k; };\n"
                  "struct S { int m; int a[2]; struct I in; };\n"
                  "int g(int *);\n"
                  "int h(int p[2]);\n"
                  "void f(register int prm, register int parr[2]) {\n"
                  "    register int arr[3]; register struct S s; register struct S sa[2];\n"
                  "    int n1 = sizeof(arr);\n"
                  "    int n2 = sizeof arr[0];\n"
                  "    int n3 = *arr;\n"
                  "    int n4 = *(arr + 1);\n"
                  "    int n5 = g(arr);\n"
                  "    int *p6 = &arr[0];\n"
                  "    int *p7 = (arr);\n"
                  "    __typeof__(arr) t9;\n"
                  "    int *p10 = &s.in.k;\n"
                  "    int n11 = s.a[0];\n"
                  "    int n12 = sa[0].m;\n"
                  "    int *p13 = &prm;\n"
                  "    int *p14 = parr;\n"
                  "    int *p15 = &parr[0];\n"
                  "    int n16 = sizeof(&arr);\n"
                  "    int *p17 = 1 ? arr : 0;\n"
                  "    int n18 = (arr)[1];\n"
                  "    int n19 = 1[arr];\n"
                  "    int *p20 = (int *)arr;\n"
                  "    struct S cp = s;\n"
                  "    (void)n1;(void)n2;(void)n3;(void)n4;(void)n5;(void)p6;(void)p7;(void)t9;(void)p10;(void)n11;(void)n12;(void)p13;(void)p14;(void)p15;(void)n16;(void)p17;(void)n18;(void)n19;(void)p20;(void)cp;\n"
                  "}\n")-1,
sizeof("struct S { int m; int a[2]; struct { int k; } in; };\n"
                  "void f(void) {\n"
                  "    register int x; register struct S s; register int arr[2]; register int *rp;\n"
                  "    int *p1 = &(x);\n"
                  "    int *p2 = &((s).m);\n"
                  "    int *p3 = &s.a[0];\n"
                  "    int (*p4)[2] = &s.a;\n"
                  "    int *p5 = &(s.in.k);\n"
                  "    int **p6 = &rp;\n"
                  "    int *p7 = &*rp;\n"
                  "    int *p8 = &(arr)[0];\n"
                  "    void *p9 = &(arr);\n"
                  "    int *p10 = (&x);\n"
                  "    int *p11 = &x + 0, *p12 = &arr[1] + 1;\n"
                  "    (void)p1;(void)p2;(void)p3;(void)p4;(void)p5;(void)p6;(void)p7;(void)p8;(void)p9;(void)p10;(void)p11;(void)p12;\n"
                  "}\n")-1
};
static const CheckDriverDefaultWarningFixture fixture_32[] =
{
    {
        // A #define's reserved name (`__x`, `_X`) and an #undef's, but not a feature-test macro clang lists, a lowercase or
        // a single underscore's.
        .name = "reserved macro names and the feature-test macros",
        .source = "#define _GNU_SOURCE\n"
                  "#define _XOPEN_SOURCE 700\n"
                  "#define _POSIX_C_SOURCE 200809L\n"
                  "#define __STDC_WANT_LIB_EXT1__ 1\n"
                  "#define _FORTIFY_SOURCE 2\n"
                  "#define _DEFAULT_SOURCE\n"
                  "#define _BSD_SOURCE\n"
                  "#define _ISOC99_SOURCE\n"
                  "#define _LARGEFILE64_SOURCE\n"
                  "#define _FILE_OFFSET_BITS 64\n"
                  "#define __STDC_FORMAT_MACROS\n"
                  "#define _lower 1\n"
                  "#define __x 1\n"
                  "#define x__y 1\n"
                  "#define _ 1\n"
                  "#undef _Foo\n"
                  "#define _REENTRANT\n"
                  "#define _THREAD_SAFE\n"
                  "#define __STDC_CONSTANT_MACROS\n"
                  "int z;\n",
        .options = { "-Wreserved-macro-identifier" },
        .warnings = 5,
    },
    {
        // An #undef of a feature-test macro, and before a definition's whitespace warning and an #undef's extra tokens.
        .name = "reserved macro names before the directives' other warnings",
        .source = "#undef _GNU_SOURCE\n"
                  "#undef __STDC_FORMAT_MACROS\n"
                  "#undef _Foo\n"
                  "#define _Bar(x) x\n"
                  "#define __y@\n"
                  "#define _Baz 1 2\n"
                  "#undef _Q extra\n"
                  "int z;\n",
        .options = { "-Wreserved-identifier" },
        .warnings = 9,
    },
    {
        // None from a system header.
        .name = "reserved macro names in system headers",
        .source = "#include <stddef.h>\n"
                  "#include <stdint.h>\n"
                  "#define __mine 1\n"
                  "int z;\n",
        .options = { "-Wreserved-identifier" },
        .warnings = 1,
    },
    {
        // Off by default; a pragma enables and ignores it, by its own name or its group's.
        .name = "reserved macro names under pragmas",
        .source = "#define _A 1\n"
                  "#pragma clang diagnostic warning \"-Wreserved-macro-identifier\"\n"
                  "#define _B 1\n"
                  "#undef _B\n"
                  "#pragma clang diagnostic ignored \"-Wreserved-identifier\"\n"
                  "#define _C 1\n"
                  "int z;\n",
        .warnings = 2,
    },
};
static const size_t fixture_32_lengths[] = {
sizeof("#define _GNU_SOURCE\n"
                  "#define _XOPEN_SOURCE 700\n"
                  "#define _POSIX_C_SOURCE 200809L\n"
                  "#define __STDC_WANT_LIB_EXT1__ 1\n"
                  "#define _FORTIFY_SOURCE 2\n"
                  "#define _DEFAULT_SOURCE\n"
                  "#define _BSD_SOURCE\n"
                  "#define _ISOC99_SOURCE\n"
                  "#define _LARGEFILE64_SOURCE\n"
                  "#define _FILE_OFFSET_BITS 64\n"
                  "#define __STDC_FORMAT_MACROS\n"
                  "#define _lower 1\n"
                  "#define __x 1\n"
                  "#define x__y 1\n"
                  "#define _ 1\n"
                  "#undef _Foo\n"
                  "#define _REENTRANT\n"
                  "#define _THREAD_SAFE\n"
                  "#define __STDC_CONSTANT_MACROS\n"
                  "int z;\n")-1,
sizeof("#undef _GNU_SOURCE\n"
                  "#undef __STDC_FORMAT_MACROS\n"
                  "#undef _Foo\n"
                  "#define _Bar(x) x\n"
                  "#define __y@\n"
                  "#define _Baz 1 2\n"
                  "#undef _Q extra\n"
                  "int z;\n")-1,
sizeof("#include <stddef.h>\n"
                  "#include <stdint.h>\n"
                  "#define __mine 1\n"
                  "int z;\n")-1,
sizeof("#define _A 1\n"
                  "#pragma clang diagnostic warning \"-Wreserved-macro-identifier\"\n"
                  "#define _B 1\n"
                  "#undef _B\n"
                  "#pragma clang diagnostic ignored \"-Wreserved-identifier\"\n"
                  "#define _C 1\n"
                  "int z;\n")-1
};
static const char check_driver_shift_wrapv_source[] =
    "int a = 1 << 40;\n"
                  "int b = -1 << 2;\n"
                  "int c = 3 << 31;\n"
                  "long d = -8L << 60;\n"
                  "int f(int x) { return (3 << 31) | (-4 << 1) | (x << 40) | (1 << -1); }\n"
                  "void g(void) { int v = (-1 << 1); (void)v; }\n";
static const CheckDriverDefaultWarningFixture fixture_33[] =
{
    {
        .name = "shift values without -fwrapv",
        .source = check_driver_shift_wrapv_source,
        .warnings = 9,
    },
    {
        .name = "-fwrapv defines shift values",
        .source = check_driver_shift_wrapv_source,
        .options = { "-fwrapv" },
        .warnings = 3,
    },
    {
        .name = "-fno-strict-overflow defines shift values",
        .source = check_driver_shift_wrapv_source,
        .options = { "-fno-strict-overflow" },
        .warnings = 3,
    },
    {
        .name = "-fno-wrapv after -fno-strict-overflow keeps shift values' warnings",
        .source = check_driver_shift_wrapv_source,
        .options = { "-fno-strict-overflow", "-fno-wrapv" },
        .warnings = 9,
    },
    {
        .name = "nonconstant int operands retain left and right shift count warnings",
        .source = "int left(int x){return x<<40;}int right(int x){return x>>32;}\n",
        .warnings = 2,
    },
    {
        .name = "negative counts do not require a constant left operand",
        .source = "int left(int x){return x<<-1;}int right(int x){return x>>(-2L);}\n",
        .warnings = 2,
    },
    {
        .name = "ordinary integer widths use the promoted left type",
        .source = "unsigned int a(unsigned int x){return x<<31;}long b(long x){return x>>63;}"
                  "long c(long x){return x<<64;}unsigned long d(unsigned long x){return x>>64;}\n",
        .warnings = 2,
    },
    {
        .name = "narrow integer operands promote before count validation",
        .source = "int a(unsigned char x){return x<<8;}int b(unsigned short x){return x>>16;}"
                  "int c(unsigned char x){return x<<31;}int d(unsigned short x){return x>>32;}\n",
        .warnings = 1,
    },
    {
        .name = "128-bit values and counts retain their complete widths",
        .source = "unsigned __int128 a(unsigned __int128 x){return x<<127;}"
                  "unsigned __int128 b(unsigned __int128 x){return x>>128;}"
                  "int c(int x){return x<<((unsigned __int128)1<<100);}\n",
        .warnings = 2,
    },
    {
        .name = "bit-precise operands use their value width rather than storage bytes",
        .source = "_BitInt(9) a(_BitInt(9) x){return x<<8;}_BitInt(9) b(_BitInt(9) x){return x<<9;}"
                  "unsigned _BitInt(1) c(unsigned _BitInt(1) x){return x>>1;}\n",
        .warnings = 2,
        .c23 = true,
    },
    {
        .name = "narrow bit-fields use their integer promotion",
        .source = "struct S{unsigned long n:7;};int a(struct S x){return x.n<<31;}int b(struct S x){return x.n>>32;}\n",
        .warnings = 1,
    },
    {
        .name = "compound shifts use the original lvalue width",
        .source = "void f(int*x,long*y,unsigned char*z){*x<<=32;*y>>=64;*z<<=8;}\n",
        .warnings = 3,
    },
    {
        .name = "compound shifts retain negative count diagnostics",
        .source = "void f(unsigned int*x){*x>>=-1;}\n",
        .warnings = 1,
    },
    {
        .name = "atomic compound shifts use the underlying integer width",
        .source = "void f(_Atomic(int)*x){*x<<=32;}\n",
        .warnings = 1,
    },
    {
        .name = "Boolean shifts distinguish promoted ordinary width from compound storage width",
        .source = "int a(_Bool x){return x<<31;}int b(_Bool x){return x>>32;}int c(_Bool x){return x<<32;}"
                  "void d(_Bool x){x<<=0;x<<=1;x<<=7;x>>=0;x>>=1;x>>=7;}void e(_Bool x){x<<=8;x>>=8;}\n",
        .warnings = 4,
    },
    {
        .name = "Boolean dereferences atomic lvalues and bit-fields retain the compound byte boundary",
        .source = "struct S{_Bool n:1;};void a(_Bool*p){*p<<=1;*p>>=7;}void b(_Bool*p){*p<<=8;*p>>=8;}"
                  "void c(_Atomic(_Bool)*p){*p<<=1;*p>>=7;}void d(_Atomic(_Bool)*p){*p<<=8;*p>>=8;}"
                  "void e(struct S*p){p->n<<=1;p->n>>=7;}void f(struct S*p){p->n<<=8;p->n>>=8;}\n",
        .warnings = 6,
    },
    {
        .name = "Boolean count width refinement does not change negative warnings in any shift form",
        .source = "int a(_Bool x){return x<<-1;}int b(_Bool x){return x>>-1;}void c(_Bool x){x<<=-1;x>>=-1;}\n",
        .warnings = 4,
    },
    {
        .name = "non-Boolean compound storage and bit-precise value-width boundaries remain distinct",
        .source = "void a(unsigned char x){x<<=7;x>>=7;x<<=8;x>>=8;}"
                  "void b(unsigned short x){x<<=15;x>>=15;x<<=16;x>>=16;}"
                  "unsigned _BitInt(1) c(unsigned _BitInt(1) x){return (x<<0)+(x>>0)+(x<<1)+(x>>1);}"
                  "void d(unsigned _BitInt(1) x){x<<=0;x>>=0;x<<=1;x>>=1;}"
                  "unsigned _BitInt(3) e(unsigned _BitInt(3) x){return (x<<2)+(x>>2)+(x<<3)+(x>>3);}"
                  "void f(unsigned _BitInt(3) x){x<<=2;x>>=2;x<<=3;x>>=3;}\n",
        .warnings = 12,
        .c23 = true,
    },
    {
        .name = "compound bit-field counts use the declared integer type",
        .source = "struct S{unsigned long n:7;};void f(struct S*x){x->n<<=7;x->n>>=64;}\n",
        .warnings = 1,
    },
    {
        .name = "computed and explicitly converted count constants are checked independently",
        .source = "int a(int x){return x<<(16+16);}int b(int x){return x>>((int)33.0);}"
                  "int c(int x){return x>>(1?-1:0);}\n",
        .warnings = 3,
    },
    {
        .name = "signed and unsigned count conversions determine the warning family",
        .source = "int a(int x){return x<<(unsigned)-1;}int b(int x){return x>>(signed char)255;}"
                  "int c(int x){return x<<(unsigned char)256;}\n",
        .warnings = 2,
    },
    {
        .name = "bit-precise count signedness is retained",
        .source = "int a(int x){return x<<(_BitInt(8))-1;}int b(int x){return x>>(unsigned _BitInt(8))255;}\n",
        .warnings = 2,
        .c23 = true,
    },
    {
        .name = "unknown and in-range counts remain quiet",
        .source = "int a(int x,int n){return x<<n;}int b(int x){return x>>0;}\n",
    },
    {
        .name = "a known payload with side effects is not a constant count",
        .source = "int tick(void);int a(int x){return x<<(tick(),32);}int b(int x,int*p){return x>>(*p=32);}\n",
    },
    {
        .name = "effects in the left operand do not suppress a constant count warning",
        .source = "int tick(void);int a(int*p){return (*p)++<<32;}int b(void){return tick()>>-1;}\n",
        .warnings = 2,
    },
    {
        .name = "fully constant shifts retain one diagnostic each",
        .source = "int a(void){return 1<<32;}int b(void){return 1>>-1;}\n",
        .warnings = 2,
    },
    {
        .name = "constant and runtime shift diagnostics share expression order",
        .source = "int f(int x){return (1<<32)+(x>>32);}\n",
        .warnings = 2,
    },
    {
        .name = "runtime shift diagnostics can precede retained constant diagnostics",
        .source = "int f(int x){return (x<<32)+(1>>-1);}\n",
        .warnings = 2,
    },
    {
        .name = "retained shifts share statement order with runtime and unused-value diagnostics",
        .source = "void f(int x){x<<32;1>>-1;}\n",
        .warnings = 4,
    },
    {
        .name = "a failed program retains its already collected constant shift diagnostic",
        .source = "int f(void){return 1<<32;break;}\n",
        .warnings = 1,
        .errors = 1,
    },
    {
        .name = "sizeof operands do not diagnose runtime shift counts",
        .source = "unsigned long f(int x){return sizeof(x<<32);}\n",
    },
    {
        .name = "typeof and alignof operands do not diagnose runtime shift counts",
        .source = "unsigned long f(int x){return _Alignof(__typeof__(x>>-1));}\n",
    },
    {
        .name = "generic controlling expressions do not diagnose runtime shift counts",
        .source = "int f(int x){return _Generic(x<<32,int:7,default:0);}\n",
    },
    {
        .name = "unselected generic arms retain queued shift-count diagnostics",
        .source = "int f(int x){return _Generic(x,int:7,default:x>>-1);}\n",
        .warnings = 1,
    },
    {
        .name = "a selected generic arm before an unselected arm keeps diagnostic order",
        .source = "int f(int x){return _Generic(x,int:x<<32,default:x>>-1);}\n",
        .warnings = 2,
    },
    {
        .name = "a retained constant diagnostic in an unselected generic arm precedes the selected arm",
        .source = "int f(int x){return _Generic(x,default:1>>-1,int:x<<32);}\n",
        .warnings = 2,
    },
    {
        .name = "an unreachable generic selection still diagnoses its detached arm",
        .source = "int f(int x){if(0)return _Generic(x,int:x<<32,default:x>>-1);return x;}\n",
        .warnings = 1,
    },
    {
        .name = "logical and inside a detached generic arm retains its queued count warning",
        .source = "int f(int x){return _Generic(x,int:x,default:0&&(x>>-1));}\n",
        .warnings = 1,
    },
    {
        .name = "logical or inside a detached generic arm retains its queued count warning",
        .source = "int f(int x){return _Generic(x,int:x,default:1||(x<<32));}\n",
        .warnings = 1,
    },
    {
        .name = "an ordinary conditional inside a detached generic arm retains its queued count warning",
        .source = "int f(int x){return _Generic(x,int:x,default:0?(x<<32):x);}\n",
        .warnings = 1,
    },
    {
        .name = "sizeof suppresses counts inside and around detached generic arms",
        .source = "int a(int x){return _Generic(x,int:x,default:sizeof(x<<32));}"
                  "unsigned long b(int x){return sizeof(_Generic(x,int:x<<32,default:x>>-1));}\n",
    },
    {
        .name = "typeof suppresses counts inside and around detached generic arms",
        .source = "int a(int x){return _Generic(x,int:x,default:_Alignof(__typeof__(x>>-1)));}"
                  "unsigned long b(int x){return _Alignof(__typeof__(_Generic(x,int:x<<32,default:x>>-1)));}\n",
    },
    {
        .name = "a detached arm precedes a later statement's count diagnostic",
        .source = "int f(int x){if(0)x=_Generic(x,int:0,default:x<<32);return x>>-1;}\n",
        .warnings = 2,
    },
    {
        .name = "a detached arm under a conditional precedes the next operand's count diagnostic",
        .source = "int f(int x){return (0?_Generic(x,int:0,default:x<<32):0)+(x>>-1);}\n",
        .warnings = 2,
    },
    {
        .name = "unselected ordinary conditional arms do not diagnose runtime shift counts",
        .source = "int f(int x){return 0?(x<<32):x;}\n",
    },
    {
        .name = "short-circuited logical operands do not diagnose runtime shift counts",
        .source = "int a(int x){return 0&&(x>>-1);}int b(int x){return 1||(x<<40);}\n",
    },
    {
        .name = "unselected choose arms retain queued shift-count diagnostics",
        .source = "int f(int x){return __builtin_choose_expr(1,x,x<<32);}\n",
        .warnings = 1,
    },
    {
        .name = "unselected generic statement values publish each shift form exactly once",
        .source = "int a(int x){return _Generic(x,int:0,default:({x<<32;}));}"
                  "int b(int x){return _Generic(x,int:0,default:({x>>32;}));}"
                  "int c(int x){return _Generic(x,int:0,default:({x<<=32;}));}"
                  "int d(int x){return _Generic(x,int:0,default:({x>>=32;}));}\n",
        .warnings = 4,
    },
    {
        .name = "unselected choose statement values publish each shift form exactly once",
        .source = "int a(int x){return __builtin_choose_expr(0,({x<<32;}),0);}"
                  "int b(int x){return __builtin_choose_expr(0,({x>>32;}),0);}"
                  "int c(int x){return __builtin_choose_expr(0,({x<<=32;}),0);}"
                  "int d(int x){return __builtin_choose_expr(0,({x>>=32;}),0);}\n",
        .warnings = 4,
    },
    {
        .name = "detached statement initializers retain their single shift diagnostic",
        .source = "int a(int x){return _Generic(x,int:0,default:({int y=x<<32;y;}));}"
                  "int b(int x){return __builtin_choose_expr(0,({int y=x>>32;y;}),0);}\n",
        .warnings = 2,
    },
    {
        .name = "standalone and selected statement values retain one legitimate count diagnostic",
        .source = "int a(int x){return ({x<<32;});}int b(int x){return ({int y=x>>32;y;});}"
                  "int c(int x){return _Generic(x,int:({x<<32;}),default:0);}"
                  "int d(int x){return __builtin_choose_expr(1,({x>>32;}),0);}\n",
        .warnings = 4,
    },
    {
        .name = "nested detached statement selections share count ownership without dropping warnings",
        .source = "int a(int x){return _Generic(x,int:0,default:({__builtin_choose_expr(0,({x<<32;}),0);}));}"
                  "int b(int x){return __builtin_choose_expr(0,({_Generic(x,int:0,default:({x>>32;}));}),0);}\n",
        .warnings = 2,
    },
    {
        .name = "detached negative statement counts publish once in both static selections",
        .source = "int a(int x){return _Generic(x,int:0,default:({x<<-1;}));}"
                  "int b(int x){return __builtin_choose_expr(0,({x>>-1;}),0);}\n",
        .warnings = 2,
    },
    {
        .name = "unreachable owners still publish their detached statement count once",
        .source = "int a(int x){if(0)return _Generic(x,int:0,default:({x<<32;}));return 0;}"
                  "int b(int x){if(0)return __builtin_choose_expr(0,({x>>32;}),0);return 0;}\n",
        .warnings = 2,
    },
    {
        .name = "count ownership retains adjacent unused-value diagnostics and source order",
        .source = "int f(int x){x<<32;(void)_Generic(x,int:0,default:({x<<32;}));x>>32;return 0;}\n",
        .warnings = 5,
    },
    {
        .name = "unevaluated and in-range detached statement values remain quiet",
        .source = "int a(int x){return _Generic(x,int:0,default:({x<<31;}));}"
                  "int b(int x){return __builtin_choose_expr(0,({x>>31;}),0);}"
                  "unsigned long c(int x){return _Generic(x,int:0,default:sizeof(({x<<32;})));}"
                  "unsigned long d(int x){return __builtin_choose_expr(0,sizeof(({x>>32;})),0);}\n",
    },
    {
        .name = "distinct detached macro expansions retain one count group and note each",
        .source = "#define BAD(x) ({(x)<<32;})\nint a(int x){return _Generic(x,int:0,default:BAD(x));}"
                  "int b(int x){return __builtin_choose_expr(0,BAD(x),0);}\n",
        .warnings = 2,
        .notes = 2,
    },
    {
        .name = "a selected choose arm before an unselected arm keeps diagnostic order",
        .source = "int f(int x){return __builtin_choose_expr(1,x<<32,x>>-1);}\n",
        .warnings = 2,
    },
    {
        .name = "a selected choose arm after an unselected arm keeps diagnostic order",
        .source = "int f(int x){return __builtin_choose_expr(0,x>>-1,x<<32);}\n",
        .warnings = 2,
    },
    {
        .name = "an unreachable choose selection still diagnoses its detached arm",
        .source = "int f(int x){if(0)return __builtin_choose_expr(1,x<<32,x>>-1);return x;}\n",
        .warnings = 1,
    },
    {
        .name = "logical and inside a detached choose arm retains its queued count warning",
        .source = "int f(int x){return __builtin_choose_expr(1,x,0&&(x>>-1));}\n",
        .warnings = 1,
    },
    {
        .name = "logical or inside a detached choose arm retains its queued count warning",
        .source = "int f(int x){return __builtin_choose_expr(1,x,1||(x<<32));}\n",
        .warnings = 1,
    },
    {
        .name = "an ordinary conditional inside a detached choose arm retains its queued count warning",
        .source = "int f(int x){return __builtin_choose_expr(1,x,0?(x<<32):x);}\n",
        .warnings = 1,
    },
    {
        .name = "sizeof suppresses counts inside and around detached choose arms",
        .source = "int a(int x){return __builtin_choose_expr(1,x,sizeof(x<<32));}"
                  "unsigned long b(int x){return sizeof(__builtin_choose_expr(1,x<<32,x>>-1));}\n",
    },
    {
        .name = "typeof suppresses counts inside and around detached choose arms",
        .source = "int a(int x){return __builtin_choose_expr(1,x,_Alignof(__typeof__(x>>-1)));}"
                  "unsigned long b(int x){return _Alignof(__typeof__(__builtin_choose_expr(1,x<<32,x>>-1)));}\n",
    },
    {
        .name = "generic controllers suppress counts throughout nested static selections",
        .source = "int a(int x){return _Generic(_Generic(x,int:x<<32,default:x>>-1),int:0,default:0);}"
                  "int b(int x){return _Generic(__builtin_choose_expr(1,x<<32,x>>-1),int:0,default:0);}\n",
    },
    {
        .name = "generic controllers nested inside detached arms still suppress counts",
        .source = "int a(int x){return _Generic(x,int:x,default:_Generic(x<<32,int:0,default:0));}"
                  "int b(int x){return __builtin_choose_expr(1,x,_Generic(x>>-1,int:0,default:0));}\n",
    },
    {
        .name = "static assertions suppress count diagnostics in detached static-selection arms",
        .source = "void f(int x){_Static_assert(_Generic(x,int:1,default:x<<32),\"generic\");"
                  "_Static_assert(__builtin_choose_expr(1,1,x>>-1),\"choose\");}\n",
    },
    {
        .name = "case values suppress count diagnostics in detached static-selection arms",
        .source = "int f(int x){switch(x){case _Generic(x,int:0,default:x<<32):return 1;"
                  "case __builtin_choose_expr(1,1,x>>-1):return 2;}return 0;}\n",
    },
    {
        .name = "a file-scope constexpr initializer suppresses detached count diagnostics",
        .source = "extern int x;constexpr int y=_Generic(x,int:0,default:x<<32);\n",
        .c23 = true,
    },
    {
        .name = "a local constexpr initializer retains detached count diagnostics",
        .source = "int f(int x){constexpr int y=_Generic(x,int:0,default:x>>-1);return y;}\n",
        .warnings = 1,
        .c23 = true,
    },
    {
        .name = "an omitted-middle conditional diagnoses its shared condition once",
        .source = "int f(int x,int y){return (x<<32)?:y;}\n",
        .warnings = 1,
    },
    {
        .name = "an omitted-middle conditional in a detached arm diagnoses its shared condition once",
        .source = "int f(int x){return _Generic(x,int:0,default:(x<<32)?:0);}\n",
        .warnings = 1,
    },
    {
        .name = "a selected statement expression retains its dead shift's suppression",
        .source = "int f(int x){return _Generic(x,int:({if(0)(void)(x<<32);0;}),default:0);}\n",
    },
    {
        .name = "selected conditional operands still diagnose their counts",
        .source = "int a(int x){return x?x<<32:x;}int b(int x){return 1?x>>-1:x;}\n",
        .warnings = 2,
    },
    {
        .name = "dead statements do not diagnose runtime shift counts",
        .source = "int a(int x){if(0){return x<<32;}return x;}int b(int x){return x;x>>=-1;}"
                  "int c(int x){if(1)return x;return x>>32;}\n",
    },
    {
        .name = "reachable statement arms diagnose their counts",
        .source = "int a(int x){if(x)return x<<32;return x;}int b(int x){if(1)return x>>-1;return x;}\n",
        .warnings = 2,
    },
    {
        .name = "vector shifts retain their separate count semantics",
        .source = "typedef int V __attribute__((vector_size(16)));V f(V x){return x<<32;}\n",
        // Baseline x86-64 cannot lower this vector shift; the ordinary expression still checks warning exclusion.
        .syntax_only = true,
    },
    {
        .name = "macro shift counts retain expansion notes",
        .source = "#define SHIFT(x) ((x)<<32)\nint f(int x){return SHIFT(x);}\n",
        .warnings = 1,
        .notes = 1,
    },
    {
        .name = "a comma's discarded left operand warns where clang builds it, before a later shift count",
        .source = "int f(int x){return (x,1.5)?x<<32:0;}\n",
        .warnings = 2,
    },
    {
        .name = "commas, counts and divisions keep their build order within one expression",
        .source = "int a(int x){return (x<<40,2)+(x,3);}int b(int x){return ((x,1),x<<40);}int c(int x){(x,2),x<<40;return 0;}"
                  "int d(int x){return (x,1/0);}int e(int x){return (x,1)+1/0;}\n",
        .warnings = 14,
    },
    {
        .name = "a comma's marker precedes the constant conversions its full expression completes",
        .source = "char c;int f(int x){return (x,(c=300)+1);}int g(int x){return (x,1)+1/0+(c=301);}\n",
        .warnings = 5,
    },
    {
        .name = "statement conditions and for increments warn before their bodies",
        .source = "int a(int x,int y){if((x,y))return x<<32;return 0;}int b(int x){while(x<<40){x=1/0;}return 0;}"
                  "int c(int x){switch(x<<40){case 1:x=1/0;}return 0;}int d(int x){for(;;x<<40){x=1/0;}}"
                  "int e(int x){if(x<<41)x=1/0;else if(x<<42)x=2/0;return 0;}int f(int x){if(x){if(x<<40)x=1/0;}else x=2/0;return 0;}\n",
        .warnings = 16,
    },
    {
        .name = "a declarator's initializer warns before the later declarators'",
        .source = "int f(int x){int a=(x,1),b=x<<40;return a+b;}\n",
        .warnings = 2,
    },
    {
        .name = "comma and count ordering under -Wall",
        .source = "int f(int x){return (x,1.5)?x<<32:0;}int g(int x,int y){if((x,y))return x<<32;return 0;}\n",
        .options = { "-Wall" },
        .warnings = 4,
    },
    // A statement expression's statements warn where clang builds them (#1447): between what its enclosing expression built
    // before it and after it, its last value once.
    {
        .name = "a statement expression's statements warn between its enclosing expression's operands",
        .source = "int f(int x){int a=x/0+({int t=1/0;x%0;})+(x<<33);int b=({x<<34;})+x/0;int c=({int y=({2/0;3;});y/0;})+(x<<35);"
                  "int d=({char ch=300;ch;})+x/0;int e=({x,1;})+1/0;x/0,({x<<36;});return a+b+c+d+e;}\n",
        .warnings = 18,
    },
    {
        .name = "a statement expression's last value warns once",
        .source = "int g(int x){return ({x/0;})+(1<<32);}int h(int x){return ({x/0;});}void k(int x){({x/0;});({1;x%0;});}\n",
        .warnings = 8,
    },
    {
        .name = "a statement expression's conditions warn before their bodies and its later statements",
        .source = "int f(int x){int c=({if(1/0)x<<34;for(;x/0;){}5;})+6/0;if(({x/0;})+8/0)return 1;return c+({x/0;});}\n",
        .warnings = 8,
    },
    {
        .name = "statement expressions' order under -Wall",
        .source = "unsigned u;int g(int);int f(int x){int j=({u<x;1;})+({g(1);x/0;});return j+x/0+({int t=1/0;x%0;});}\n",
        .options = { "-Wall" },
        .warnings = 6,
    },
    {
        .name = "unused-value suppression keeps the reordered counts",
        .source = "int f(int x){return (x,1.5)?x<<32:0;}int g(int x){if(1/0)return x<<32;return 0;}\n",
        .options = { "-Wno-unused-value" },
        .warnings = 3,
    },
    {
        .name = "overflow count suppression preserves the negative count family",
        .source = "int a(int x){return x<<32;}int b(int x){return x>>-1;}\n",
        .options = { "-Wno-shift-count-overflow" },
        .warnings = 1,
    },
    {
        .name = "negative count suppression preserves the overflow count family",
        .source = "int a(int x){return x<<32;}int b(int x){return x>>-1;}\n",
        .options = { "-Wno-shift-count-negative" },
        .warnings = 1,
    },
    {
        .name = "specific count warning promotion rejects object publication",
        .source = "int f(int x){return x<<32;}\n",
        .options = { "-Werror=shift-count-overflow" },
        .errors = 1,
    },
    {
        .name = "source diagnostic push and pop preserve shift count policy",
        .source = "#pragma clang diagnostic push\n#pragma clang diagnostic ignored \"-Wshift-count-overflow\"\n"
                  "int a(int x){return x<<32;}\n#pragma clang diagnostic pop\nint b(int x){return x<<32;}\n",
        .warnings = 1,
    },
    // A folded shift's own warnings (#1447): clang's DiagnoseBadShiftValues words -Wshift-negative-value and
    // -Wshift-overflow, and only the former and the counts are runtime-behavior ones, deferred to the function's end
    // and dropped where no path reaches.
    {
        .name = "folded shifts word their overflow and negative left operands as clang does",
        .source = "typedef int I;\nint a=0x7fffffff<<2;int b=-1<<3;int c=1<<31;int d=3<<30;long e=0x7fffffffffffffffL<<60;\n"
                  "__int128 g=(__int128)0x7fffffffffffffffLL<<100;int h=(I)5<<30;int i=(short)1<<31;\n",
        .warnings = 5,
    },
    {
        .name = "a folded negative shift waits for the function's end while its overflow does not",
        .source = "int f(int x){int z=-3<<1;char c=300;x=0x7fffffff<<2;c=301;return z+c+x;}\n",
        .warnings = 4,
    },
    {
        .name = "a body's shift overflow precedes a later shift precedence warning",
        .source = "int f(int x)\n{\n    int v = 3 << 31;\n    int y = 1 << 3 + 1;\n    return v + y;\n}\n",
        .warnings = 2,
        .notes = 1,
    },
    {
        .name = "unreachable and unevaluated shift overflow keeps its source order",
        .source = "int f(void){int a=sizeof(3<<31);int b=1<<2+1;return a+b;int c=3<<31;int d=1<<3+1;}\n",
        .warnings = 4,
        .notes = 2,
    },
    {
        .name = "shift overflow warns before a deferred negative shift and a later precedence warning",
        .source = "int f(void){int a=-1<<2;int b=3<<31;int c=1<<3+1;return a+b+c;}\n",
        .warnings = 3,
        .notes = 1,
    },
    {
        .name = "source suppression of shift overflow preserves later precedence diagnostics",
        .source = "int f(void){\n#pragma clang diagnostic ignored \"-Wshift-overflow\"\n"
                  "int a=3<<31;int b=1<<3+1;return a+b;}\n",
        .warnings = 1,
        .notes = 1,
    },
    {
        .name = "unreachable folded shifts drop their runtime warnings and keep their overflow",
        .source = "int a(int x){return x;x=1<<32;x=-1<<1;x=3<<31;x=-1<<2;return x;}\n"
                  "int b(int x){if(x)return 1;else return 2;x=1<<33;}\n"
                  "int c(int x){if(0){x=1<<40;x=-1<<2;x=0x7fffffff<<3;}while(0){x=1<<42;}for(;;){}x=-1<<4;}\n"
                  "void d(int x){goto e;x=-1<<9;e:x=-1<<10;while(1){}x=-1<<11;}\n",
        .warnings = 3,
    },
    {
        .name = "constant contexts leave a folded negative shift to the constant evaluation",
        .source = "enum{E=-1<<2};_Static_assert((-1<<1)==-2,\"\");int f(int x){switch(x){case -1<<3:return 1;}"
                  "int y=sizeof(-1<<4);y+=x?(-1<<5):0;y+=1?0:(-1<<6);return y;}\n",
        .warnings = 1,
    },
    {
        .name = "an unreachable promoted folded shift neither reports nor rejects the unit",
        .source = "int f(int x){if(x)return 1;else return 0;x=-1<<8;x=1<<40;}\n",
        .options = { "-Werror=shift-negative-value", "-Werror=shift-count-overflow" },
    },
    {
        .name = "a reachable promoted folded shift rejects the unit",
        .source = "int f(int x){x=-1<<8;return x;}\n",
        .options = { "-Werror=shift-negative-value" },
        .errors = 1,
    },
    {
        .name = "source policy reaches folded shifts' runtime and immediate warnings",
        .source = "int f(int x){\n#pragma clang diagnostic push\n#pragma clang diagnostic ignored \"-Wshift-negative-value\"\n"
                  "x=-1<<2;\n#pragma clang diagnostic pop\n#pragma clang diagnostic error \"-Wshift-count-overflow\"\n"
                  "x=1<<40;x=-2<<1;x=0x7fffffff<<4;if(x)return 0;return x;x=1<<41;}\n",
        .warnings = 2,
        .errors = 1,
    },
    {
        // Review on #1778: clang has no CFG block for an unselected static-selection arm, and its Sema evaluates a reachable
        // statement's folded condition, whose range our program drops.
        .name = "unselected static-selection arms keep their folded negative shifts",
        .source = "int f(long x){int y=_Generic(x,int:0,long:-1<<2);y+=__builtin_choose_expr(1,0,-1<<3);"
                  "if(x)y=_Generic(x,int:x<<40,long:1);return y;}\nvoid g(long x){(void)_Generic(x,int:0,long:-1<<4);"
                  "(void)__builtin_choose_expr(0,-1<<5,0);}\n",
        .warnings = 4,
    },
    {
        .name = "a reachable statement's folded condition keeps its shifts' warnings and an unreached one drops them",
        .source = "#define SW (1<<44)\nint a(int x){if((1<<40)!=0)x=1;if(1&&((1<<41)!=0))x=2;if(x)x=5;else if((-1<<2)<0)x=6;"
                  "else if((1<<46)!=0)x=7;if(x){if((1<<47)!=0)x=8;}switch(SW){default:x=10;}if((0<<48)!=0)x=11;return x;}\n"
                  "int b(int x){return x;if((1<<40)!=0)x=1;if((-1<<2)<0)x=6;switch(SW){default:x=10;}if((0<<48)!=0)x=11;else x=12;return x;}\n"
                  "int c(int x){if(x)return 1;else return 2;if((1<<49)!=0)x=1;}\nint d(int x){if((1<<50)!=0)return 1;return x;}\n",
        .warnings = 7,
        .notes = 1,
    },
    {
        // Re-review on #1778: a static selection's unselected roots never stand for a folded condition's statement.
        .name = "a folded condition before a static selection keeps its shifts' warnings in its place",
        .source = "int f1(int x){if((1<<40)!=0)return _Generic(x,int:0,long:0);return 0;}\n"
                  "int f2(int x){if((1<<41)!=0)return __builtin_choose_expr(1,0,0);return 0;}\n"
                  "int f3(int x){if((1<<42)!=0){}_Generic(x,int:0,long:0);return 0;}\n"
                  "int f4(int x){switch(1<<43){default:return _Generic(x,int:0,long:0);}return 0;}\n"
                  "int f5(int x){if((-1<<2)<0)return _Generic(x,int:0,long:0);return 0;}\n"
                  "int f6(int x){return x;if((1<<44)!=0)return _Generic(x,int:0,long:0);return 0;}\n",
        .warnings = 6,
    },
    {
        // Re-review on #1778: an unselected static-selection arm's shifts warn in the selection's order, not its root's.
        .name = "unselected static-selection arms' folded shifts warn in their order",
        .source = "int f(int x){return _Generic(x,int:1<<40,default:-1<<2);}\n"
                  "int g(int x){return _Generic(x,long:1<<41,short:-2<<2,default:x)+__builtin_choose_expr(0,-3<<1,1<<42);}\n",
        .warnings = 6,
    },
    {
        // Re-review on #1778: a folded condition's statement whose arm has no expression is reached where its place is.
        .name = "a folded condition with an empty arm keeps its shifts' warnings only where its place is reached",
        .source = "int d1(int x){return 0;if((1<<40)!=0){}}\n"
                  "int n1(int x){return _Generic(x,int:0,long:0);}\n"
                  "int d2(int x){goto out;if((1<<41)!=0){}out:return x;}\n"
                  "int d3(int x){while(x){return 1;if((1<<42)!=0){}}return 0;}\n"
                  "int d4(int x){switch(x){case 1:return 1;if((1<<43)!=0){}case 2:if((1<<44)!=0){}}return 0;}\n"
                  "int d5(int x){while(1){if(x)return 1;}if((1<<45)!=0){}}\n"
                  "int r1(int x){if(x)return 1;if((1<<46)!=0){}return 0;}\n"
                  "int r2(int x){goto l;return 1;l:if((1<<47)!=0){}return 0;}\n"
                  "int r3(int x){while(x){if(x>2)break;if((1<<48)!=0){}}return 0;}\n"
                  "int r4(int x){for(;;){if(x)break;}if((1<<49)!=0){}return 0;}\n"
                  "int r5(int x){if(x){x=2;}else{return 1;}if((1<<50)!=0){}return x;}\n"
                  "int r6(int x){if((1<<51)!=0){}}\n",
        .warnings = 8,
    },
    {
        .name = "a unit with an error keeps its folded shifts' runtime warnings",
        .source = "int f(int x){x=-1<<2;x=1<<40;x=undeclared;return x;x=-1<<3;}\n",
        .warnings = 3,
        .errors = 1,
    },
};
static const size_t fixture_33_lengths[] = {
sizeof(check_driver_shift_wrapv_source)-1,
sizeof(check_driver_shift_wrapv_source)-1,
sizeof(check_driver_shift_wrapv_source)-1,
sizeof(check_driver_shift_wrapv_source)-1,
sizeof("int left(int x){return x<<40;}int right(int x){return x>>32;}\n")-1,
sizeof("int left(int x){return x<<-1;}int right(int x){return x>>(-2L);}\n")-1,
sizeof("unsigned int a(unsigned int x){return x<<31;}long b(long x){return x>>63;}"
                  "long c(long x){return x<<64;}unsigned long d(unsigned long x){return x>>64;}\n")-1,
sizeof("int a(unsigned char x){return x<<8;}int b(unsigned short x){return x>>16;}"
                  "int c(unsigned char x){return x<<31;}int d(unsigned short x){return x>>32;}\n")-1,
sizeof("unsigned __int128 a(unsigned __int128 x){return x<<127;}"
                  "unsigned __int128 b(unsigned __int128 x){return x>>128;}"
                  "int c(int x){return x<<((unsigned __int128)1<<100);}\n")-1,
sizeof("_BitInt(9) a(_BitInt(9) x){return x<<8;}_BitInt(9) b(_BitInt(9) x){return x<<9;}"
                  "unsigned _BitInt(1) c(unsigned _BitInt(1) x){return x>>1;}\n")-1,
sizeof("struct S{unsigned long n:7;};int a(struct S x){return x.n<<31;}int b(struct S x){return x.n>>32;}\n")-1,
sizeof("void f(int*x,long*y,unsigned char*z){*x<<=32;*y>>=64;*z<<=8;}\n")-1,
sizeof("void f(unsigned int*x){*x>>=-1;}\n")-1,
sizeof("void f(_Atomic(int)*x){*x<<=32;}\n")-1,
sizeof("int a(_Bool x){return x<<31;}int b(_Bool x){return x>>32;}int c(_Bool x){return x<<32;}"
                  "void d(_Bool x){x<<=0;x<<=1;x<<=7;x>>=0;x>>=1;x>>=7;}void e(_Bool x){x<<=8;x>>=8;}\n")-1,
sizeof("struct S{_Bool n:1;};void a(_Bool*p){*p<<=1;*p>>=7;}void b(_Bool*p){*p<<=8;*p>>=8;}"
                  "void c(_Atomic(_Bool)*p){*p<<=1;*p>>=7;}void d(_Atomic(_Bool)*p){*p<<=8;*p>>=8;}"
                  "void e(struct S*p){p->n<<=1;p->n>>=7;}void f(struct S*p){p->n<<=8;p->n>>=8;}\n")-1,
sizeof("int a(_Bool x){return x<<-1;}int b(_Bool x){return x>>-1;}void c(_Bool x){x<<=-1;x>>=-1;}\n")-1,
sizeof("void a(unsigned char x){x<<=7;x>>=7;x<<=8;x>>=8;}"
                  "void b(unsigned short x){x<<=15;x>>=15;x<<=16;x>>=16;}"
                  "unsigned _BitInt(1) c(unsigned _BitInt(1) x){return (x<<0)+(x>>0)+(x<<1)+(x>>1);}"
                  "void d(unsigned _BitInt(1) x){x<<=0;x>>=0;x<<=1;x>>=1;}"
                  "unsigned _BitInt(3) e(unsigned _BitInt(3) x){return (x<<2)+(x>>2)+(x<<3)+(x>>3);}"
                  "void f(unsigned _BitInt(3) x){x<<=2;x>>=2;x<<=3;x>>=3;}\n")-1,
sizeof("struct S{unsigned long n:7;};void f(struct S*x){x->n<<=7;x->n>>=64;}\n")-1,
sizeof("int a(int x){return x<<(16+16);}int b(int x){return x>>((int)33.0);}"
                  "int c(int x){return x>>(1?-1:0);}\n")-1,
sizeof("int a(int x){return x<<(unsigned)-1;}int b(int x){return x>>(signed char)255;}"
                  "int c(int x){return x<<(unsigned char)256;}\n")-1,
sizeof("int a(int x){return x<<(_BitInt(8))-1;}int b(int x){return x>>(unsigned _BitInt(8))255;}\n")-1,
sizeof("int a(int x,int n){return x<<n;}int b(int x){return x>>0;}\n")-1,
sizeof("int tick(void);int a(int x){return x<<(tick(),32);}int b(int x,int*p){return x>>(*p=32);}\n")-1,
sizeof("int tick(void);int a(int*p){return (*p)++<<32;}int b(void){return tick()>>-1;}\n")-1,
sizeof("int a(void){return 1<<32;}int b(void){return 1>>-1;}\n")-1,
sizeof("int f(int x){return (1<<32)+(x>>32);}\n")-1,
sizeof("int f(int x){return (x<<32)+(1>>-1);}\n")-1,
sizeof("void f(int x){x<<32;1>>-1;}\n")-1,
sizeof("int f(void){return 1<<32;break;}\n")-1,
sizeof("unsigned long f(int x){return sizeof(x<<32);}\n")-1,
sizeof("unsigned long f(int x){return _Alignof(__typeof__(x>>-1));}\n")-1,
sizeof("int f(int x){return _Generic(x<<32,int:7,default:0);}\n")-1,
sizeof("int f(int x){return _Generic(x,int:7,default:x>>-1);}\n")-1,
sizeof("int f(int x){return _Generic(x,int:x<<32,default:x>>-1);}\n")-1,
sizeof("int f(int x){return _Generic(x,default:1>>-1,int:x<<32);}\n")-1,
sizeof("int f(int x){if(0)return _Generic(x,int:x<<32,default:x>>-1);return x;}\n")-1,
sizeof("int f(int x){return _Generic(x,int:x,default:0&&(x>>-1));}\n")-1,
sizeof("int f(int x){return _Generic(x,int:x,default:1||(x<<32));}\n")-1,
sizeof("int f(int x){return _Generic(x,int:x,default:0?(x<<32):x);}\n")-1,
sizeof("int a(int x){return _Generic(x,int:x,default:sizeof(x<<32));}"
                  "unsigned long b(int x){return sizeof(_Generic(x,int:x<<32,default:x>>-1));}\n")-1,
sizeof("int a(int x){return _Generic(x,int:x,default:_Alignof(__typeof__(x>>-1)));}"
                  "unsigned long b(int x){return _Alignof(__typeof__(_Generic(x,int:x<<32,default:x>>-1)));}\n")-1,
sizeof("int f(int x){if(0)x=_Generic(x,int:0,default:x<<32);return x>>-1;}\n")-1,
sizeof("int f(int x){return (0?_Generic(x,int:0,default:x<<32):0)+(x>>-1);}\n")-1,
sizeof("int f(int x){return 0?(x<<32):x;}\n")-1,
sizeof("int a(int x){return 0&&(x>>-1);}int b(int x){return 1||(x<<40);}\n")-1,
sizeof("int f(int x){return __builtin_choose_expr(1,x,x<<32);}\n")-1,
sizeof("int a(int x){return _Generic(x,int:0,default:({x<<32;}));}"
                  "int b(int x){return _Generic(x,int:0,default:({x>>32;}));}"
                  "int c(int x){return _Generic(x,int:0,default:({x<<=32;}));}"
                  "int d(int x){return _Generic(x,int:0,default:({x>>=32;}));}\n")-1,
sizeof("int a(int x){return __builtin_choose_expr(0,({x<<32;}),0);}"
                  "int b(int x){return __builtin_choose_expr(0,({x>>32;}),0);}"
                  "int c(int x){return __builtin_choose_expr(0,({x<<=32;}),0);}"
                  "int d(int x){return __builtin_choose_expr(0,({x>>=32;}),0);}\n")-1,
sizeof("int a(int x){return _Generic(x,int:0,default:({int y=x<<32;y;}));}"
                  "int b(int x){return __builtin_choose_expr(0,({int y=x>>32;y;}),0);}\n")-1,
sizeof("int a(int x){return ({x<<32;});}int b(int x){return ({int y=x>>32;y;});}"
                  "int c(int x){return _Generic(x,int:({x<<32;}),default:0);}"
                  "int d(int x){return __builtin_choose_expr(1,({x>>32;}),0);}\n")-1,
sizeof("int a(int x){return _Generic(x,int:0,default:({__builtin_choose_expr(0,({x<<32;}),0);}));}"
                  "int b(int x){return __builtin_choose_expr(0,({_Generic(x,int:0,default:({x>>32;}));}),0);}\n")-1,
sizeof("int a(int x){return _Generic(x,int:0,default:({x<<-1;}));}"
                  "int b(int x){return __builtin_choose_expr(0,({x>>-1;}),0);}\n")-1,
sizeof("int a(int x){if(0)return _Generic(x,int:0,default:({x<<32;}));return 0;}"
                  "int b(int x){if(0)return __builtin_choose_expr(0,({x>>32;}),0);return 0;}\n")-1,
sizeof("int f(int x){x<<32;(void)_Generic(x,int:0,default:({x<<32;}));x>>32;return 0;}\n")-1,
sizeof("int a(int x){return _Generic(x,int:0,default:({x<<31;}));}"
                  "int b(int x){return __builtin_choose_expr(0,({x>>31;}),0);}"
                  "unsigned long c(int x){return _Generic(x,int:0,default:sizeof(({x<<32;})));}"
                  "unsigned long d(int x){return __builtin_choose_expr(0,sizeof(({x>>32;})),0);}\n")-1,
sizeof("#define BAD(x) ({(x)<<32;})\nint a(int x){return _Generic(x,int:0,default:BAD(x));}"
                  "int b(int x){return __builtin_choose_expr(0,BAD(x),0);}\n")-1,
sizeof("int f(int x){return __builtin_choose_expr(1,x<<32,x>>-1);}\n")-1,
sizeof("int f(int x){return __builtin_choose_expr(0,x>>-1,x<<32);}\n")-1,
sizeof("int f(int x){if(0)return __builtin_choose_expr(1,x<<32,x>>-1);return x;}\n")-1,
sizeof("int f(int x){return __builtin_choose_expr(1,x,0&&(x>>-1));}\n")-1,
sizeof("int f(int x){return __builtin_choose_expr(1,x,1||(x<<32));}\n")-1,
sizeof("int f(int x){return __builtin_choose_expr(1,x,0?(x<<32):x);}\n")-1,
sizeof("int a(int x){return __builtin_choose_expr(1,x,sizeof(x<<32));}"
                  "unsigned long b(int x){return sizeof(__builtin_choose_expr(1,x<<32,x>>-1));}\n")-1,
sizeof("int a(int x){return __builtin_choose_expr(1,x,_Alignof(__typeof__(x>>-1)));}"
                  "unsigned long b(int x){return _Alignof(__typeof__(__builtin_choose_expr(1,x<<32,x>>-1)));}\n")-1,
sizeof("int a(int x){return _Generic(_Generic(x,int:x<<32,default:x>>-1),int:0,default:0);}"
                  "int b(int x){return _Generic(__builtin_choose_expr(1,x<<32,x>>-1),int:0,default:0);}\n")-1,
sizeof("int a(int x){return _Generic(x,int:x,default:_Generic(x<<32,int:0,default:0));}"
                  "int b(int x){return __builtin_choose_expr(1,x,_Generic(x>>-1,int:0,default:0));}\n")-1,
sizeof("void f(int x){_Static_assert(_Generic(x,int:1,default:x<<32),\"generic\");"
                  "_Static_assert(__builtin_choose_expr(1,1,x>>-1),\"choose\");}\n")-1,
sizeof("int f(int x){switch(x){case _Generic(x,int:0,default:x<<32):return 1;"
                  "case __builtin_choose_expr(1,1,x>>-1):return 2;}return 0;}\n")-1,
sizeof("extern int x;constexpr int y=_Generic(x,int:0,default:x<<32);\n")-1,
sizeof("int f(int x){constexpr int y=_Generic(x,int:0,default:x>>-1);return y;}\n")-1,
sizeof("int f(int x,int y){return (x<<32)?:y;}\n")-1,
sizeof("int f(int x){return _Generic(x,int:0,default:(x<<32)?:0);}\n")-1,
sizeof("int f(int x){return _Generic(x,int:({if(0)(void)(x<<32);0;}),default:0);}\n")-1,
sizeof("int a(int x){return x?x<<32:x;}int b(int x){return 1?x>>-1:x;}\n")-1,
sizeof("int a(int x){if(0){return x<<32;}return x;}int b(int x){return x;x>>=-1;}"
                  "int c(int x){if(1)return x;return x>>32;}\n")-1,
sizeof("int a(int x){if(x)return x<<32;return x;}int b(int x){if(1)return x>>-1;return x;}\n")-1,
sizeof("typedef int V __attribute__((vector_size(16)));V f(V x){return x<<32;}\n")-1,
sizeof("#define SHIFT(x) ((x)<<32)\nint f(int x){return SHIFT(x);}\n")-1,
sizeof("int f(int x){return (x,1.5)?x<<32:0;}\n")-1,
sizeof("int a(int x){return (x<<40,2)+(x,3);}int b(int x){return ((x,1),x<<40);}int c(int x){(x,2),x<<40;return 0;}"
                  "int d(int x){return (x,1/0);}int e(int x){return (x,1)+1/0;}\n")-1,
sizeof("char c;int f(int x){return (x,(c=300)+1);}int g(int x){return (x,1)+1/0+(c=301);}\n")-1,
sizeof("int a(int x,int y){if((x,y))return x<<32;return 0;}int b(int x){while(x<<40){x=1/0;}return 0;}"
                  "int c(int x){switch(x<<40){case 1:x=1/0;}return 0;}int d(int x){for(;;x<<40){x=1/0;}}"
                  "int e(int x){if(x<<41)x=1/0;else if(x<<42)x=2/0;return 0;}int f(int x){if(x){if(x<<40)x=1/0;}else x=2/0;return 0;}\n")-1,
sizeof("int f(int x){int a=(x,1),b=x<<40;return a+b;}\n")-1,
sizeof("int f(int x){return (x,1.5)?x<<32:0;}int g(int x,int y){if((x,y))return x<<32;return 0;}\n")-1,
sizeof("int f(int x){int a=x/0+({int t=1/0;x%0;})+(x<<33);int b=({x<<34;})+x/0;int c=({int y=({2/0;3;});y/0;})+(x<<35);"
                  "int d=({char ch=300;ch;})+x/0;int e=({x,1;})+1/0;x/0,({x<<36;});return a+b+c+d+e;}\n")-1,
sizeof("int g(int x){return ({x/0;})+(1<<32);}int h(int x){return ({x/0;});}void k(int x){({x/0;});({1;x%0;});}\n")-1,
sizeof("int f(int x){int c=({if(1/0)x<<34;for(;x/0;){}5;})+6/0;if(({x/0;})+8/0)return 1;return c+({x/0;});}\n")-1,
sizeof("unsigned u;int g(int);int f(int x){int j=({u<x;1;})+({g(1);x/0;});return j+x/0+({int t=1/0;x%0;});}\n")-1,
sizeof("int f(int x){return (x,1.5)?x<<32:0;}int g(int x){if(1/0)return x<<32;return 0;}\n")-1,
sizeof("int a(int x){return x<<32;}int b(int x){return x>>-1;}\n")-1,
sizeof("int a(int x){return x<<32;}int b(int x){return x>>-1;}\n")-1,
sizeof("int f(int x){return x<<32;}\n")-1,
sizeof("#pragma clang diagnostic push\n#pragma clang diagnostic ignored \"-Wshift-count-overflow\"\n"
                  "int a(int x){return x<<32;}\n#pragma clang diagnostic pop\nint b(int x){return x<<32;}\n")-1,
sizeof("typedef int I;\nint a=0x7fffffff<<2;int b=-1<<3;int c=1<<31;int d=3<<30;long e=0x7fffffffffffffffL<<60;\n"
                  "__int128 g=(__int128)0x7fffffffffffffffLL<<100;int h=(I)5<<30;int i=(short)1<<31;\n")-1,
sizeof("int f(int x){int z=-3<<1;char c=300;x=0x7fffffff<<2;c=301;return z+c+x;}\n")-1,
sizeof("int f(int x)\n{\n    int v = 3 << 31;\n    int y = 1 << 3 + 1;\n    return v + y;\n}\n")-1,
sizeof("int f(void){int a=sizeof(3<<31);int b=1<<2+1;return a+b;int c=3<<31;int d=1<<3+1;}\n")-1,
sizeof("int f(void){int a=-1<<2;int b=3<<31;int c=1<<3+1;return a+b+c;}\n")-1,
sizeof("int f(void){\n#pragma clang diagnostic ignored \"-Wshift-overflow\"\n"
                  "int a=3<<31;int b=1<<3+1;return a+b;}\n")-1,
sizeof("int a(int x){return x;x=1<<32;x=-1<<1;x=3<<31;x=-1<<2;return x;}\n"
                  "int b(int x){if(x)return 1;else return 2;x=1<<33;}\n"
                  "int c(int x){if(0){x=1<<40;x=-1<<2;x=0x7fffffff<<3;}while(0){x=1<<42;}for(;;){}x=-1<<4;}\n"
                  "void d(int x){goto e;x=-1<<9;e:x=-1<<10;while(1){}x=-1<<11;}\n")-1,
sizeof("enum{E=-1<<2};_Static_assert((-1<<1)==-2,\"\");int f(int x){switch(x){case -1<<3:return 1;}"
                  "int y=sizeof(-1<<4);y+=x?(-1<<5):0;y+=1?0:(-1<<6);return y;}\n")-1,
sizeof("int f(int x){if(x)return 1;else return 0;x=-1<<8;x=1<<40;}\n")-1,
sizeof("int f(int x){x=-1<<8;return x;}\n")-1,
sizeof("int f(int x){\n#pragma clang diagnostic push\n#pragma clang diagnostic ignored \"-Wshift-negative-value\"\n"
                  "x=-1<<2;\n#pragma clang diagnostic pop\n#pragma clang diagnostic error \"-Wshift-count-overflow\"\n"
                  "x=1<<40;x=-2<<1;x=0x7fffffff<<4;if(x)return 0;return x;x=1<<41;}\n")-1,
sizeof("int f(long x){int y=_Generic(x,int:0,long:-1<<2);y+=__builtin_choose_expr(1,0,-1<<3);"
                  "if(x)y=_Generic(x,int:x<<40,long:1);return y;}\nvoid g(long x){(void)_Generic(x,int:0,long:-1<<4);"
                  "(void)__builtin_choose_expr(0,-1<<5,0);}\n")-1,
sizeof("#define SW (1<<44)\nint a(int x){if((1<<40)!=0)x=1;if(1&&((1<<41)!=0))x=2;if(x)x=5;else if((-1<<2)<0)x=6;"
                  "else if((1<<46)!=0)x=7;if(x){if((1<<47)!=0)x=8;}switch(SW){default:x=10;}if((0<<48)!=0)x=11;return x;}\n"
                  "int b(int x){return x;if((1<<40)!=0)x=1;if((-1<<2)<0)x=6;switch(SW){default:x=10;}if((0<<48)!=0)x=11;else x=12;return x;}\n"
                  "int c(int x){if(x)return 1;else return 2;if((1<<49)!=0)x=1;}\nint d(int x){if((1<<50)!=0)return 1;return x;}\n")-1,
sizeof("int f1(int x){if((1<<40)!=0)return _Generic(x,int:0,long:0);return 0;}\n"
                  "int f2(int x){if((1<<41)!=0)return __builtin_choose_expr(1,0,0);return 0;}\n"
                  "int f3(int x){if((1<<42)!=0){}_Generic(x,int:0,long:0);return 0;}\n"
                  "int f4(int x){switch(1<<43){default:return _Generic(x,int:0,long:0);}return 0;}\n"
                  "int f5(int x){if((-1<<2)<0)return _Generic(x,int:0,long:0);return 0;}\n"
                  "int f6(int x){return x;if((1<<44)!=0)return _Generic(x,int:0,long:0);return 0;}\n")-1,
sizeof("int f(int x){return _Generic(x,int:1<<40,default:-1<<2);}\n"
                  "int g(int x){return _Generic(x,long:1<<41,short:-2<<2,default:x)+__builtin_choose_expr(0,-3<<1,1<<42);}\n")-1,
sizeof("int d1(int x){return 0;if((1<<40)!=0){}}\n"
                  "int n1(int x){return _Generic(x,int:0,long:0);}\n"
                  "int d2(int x){goto out;if((1<<41)!=0){}out:return x;}\n"
                  "int d3(int x){while(x){return 1;if((1<<42)!=0){}}return 0;}\n"
                  "int d4(int x){switch(x){case 1:return 1;if((1<<43)!=0){}case 2:if((1<<44)!=0){}}return 0;}\n"
                  "int d5(int x){while(1){if(x)return 1;}if((1<<45)!=0){}}\n"
                  "int r1(int x){if(x)return 1;if((1<<46)!=0){}return 0;}\n"
                  "int r2(int x){goto l;return 1;l:if((1<<47)!=0){}return 0;}\n"
                  "int r3(int x){while(x){if(x>2)break;if((1<<48)!=0){}}return 0;}\n"
                  "int r4(int x){for(;;){if(x)break;}if((1<<49)!=0){}return 0;}\n"
                  "int r5(int x){if(x){x=2;}else{return 1;}if((1<<50)!=0){}return x;}\n"
                  "int r6(int x){if((1<<51)!=0){}}\n")-1,
sizeof("int f(int x){x=-1<<2;x=1<<40;x=undeclared;return x;x=-1<<3;}\n")-1
};
static const CheckDriverDefaultWarningFixture fixture_34[] =
{
    {
        // An unparenthesized `+` or `-` as either operand of a `<<` or `>>`, the left one first, at it; through a macro's
        // argument with the macro's note; not a parenthesized one, a multiplication, or a compound assignment's.
        .name = "additions in shifts",
        .source = "int a(int x, int b, int c) { return x << b + c; }\n"
                  "int b(int x, int b, int c) { return x + b << c; }\n"
                  "int c(int x, int b, int c) { return x >> b - c; }\n"
                  "int d(int x, int b, int c) { return x << (b + c) | (x + b) << c | x << b * c; }\n"
                  "int e(int x, int b, int c) { return x - b >> c + 1; }\n"
                  "#define SH(a, b) (a << b)\n"
                  "int f(int x, int b, int c) { return SH(x, b + c); }\n"
                  "#define ID(a) a\n"
                  "int g(int x) { return ID(x << x + 1) + (ID(x) << x + 1); }\n"
                  "int h(int x, int b) { x <<= b + 1; return x << b + 1 << 2; }\n",
        .warnings = 9,
        .notes = 11,
    },
    {
        // In constant contexts, beside the shift's own count warning, in an unevaluated operand.
        .name = "additions in shifts in other places",
        .source = "int g = 1 << 2 + 1;\n"
                  "int b(int x) { return 1 << 40 + x; }\n"
                  "unsigned long c(int x) { return sizeof(x << x + 1); }\n"
                  "enum { E = 1 << 3 - 1 };\n"
                  "int e(int x) { switch (x) { case 1 << 1 + 1: return 1; } return x >> (x) - 1; }\n",
        .warnings = 6,
        .notes = 6,
    },
};
static const size_t fixture_34_lengths[] = {
sizeof("int a(int x, int b, int c) { return x << b + c; }\n"
                  "int b(int x, int b, int c) { return x + b << c; }\n"
                  "int c(int x, int b, int c) { return x >> b - c; }\n"
                  "int d(int x, int b, int c) { return x << (b + c) | (x + b) << c | x << b * c; }\n"
                  "int e(int x, int b, int c) { return x - b >> c + 1; }\n"
                  "#define SH(a, b) (a << b)\n"
                  "int f(int x, int b, int c) { return SH(x, b + c); }\n"
                  "#define ID(a) a\n"
                  "int g(int x) { return ID(x << x + 1) + (ID(x) << x + 1); }\n"
                  "int h(int x, int b) { x <<= b + 1; return x << b + 1 << 2; }\n")-1,
sizeof("int g = 1 << 2 + 1;\n"
                  "int b(int x) { return 1 << 40 + x; }\n"
                  "unsigned long c(int x) { return sizeof(x << x + 1); }\n"
                  "enum { E = 1 << 3 - 1 };\n"
                  "int e(int x) { switch (x) { case 1 << 1 + 1: return 1; } return x >> (x) - 1; }\n")-1
};
static const CheckDriverDefaultWarningFixture fixture_35[] =
{
    {
        // A nonnegative signed left operand shifted exactly into its promoted type's sign bit, at file scope, in a body,
        // in an enumerator, a bound, an unevaluated operand and unreachable code; a typedef's spelling; not an unsigned
        // shift, one short of the sign bit, a negative left operand's or an over-wide count's.
        .name = "shifts into the sign bit",
        .source = "typedef int I;\n"
                  "int a = 1 << 31;\n"
                  "enum { E = 1 << 31 };\n"
                  "int b[(1 << 30 << 1) < 0 ? 1 : 2];\n"
                  "int f(int x)\n"
                  "{\n"
                  "    long c = 1L << 63;\n"
                  "    int d = 2 << 30, e = (I)3 << 30, g = (short)1 << 31, h = (char)64 << 25;\n"
                  "    unsigned u = 1u << 31;\n"
                  "    int v = 3 << 29, w = -1 << 3, y = 1 << 32, z = 0 << 31;\n"
                  "    unsigned long s = sizeof(1 << 31);\n"
                  "    __int128 q = (__int128)1 << 127;\n"
                  "    if (x)\n"
                  "        return 1 << 31;\n"
                  "    return (int)(x + c + d + e + g + h + u + v + w + y + z + s + q) + (1 << x);\n"
                  "}\n",
        .options = { "-Wshift-sign-overflow" },
        .warnings = 13,
    },
    {
        // The constant reader's shifts, which no graph node holds: enumerators, file-scope and member bounds, a static
        // assertion's, a block's enumerator and bound; a cast's typedef spelling; a 128-bit and a long shift.
        .name = "shifts into the sign bit in constants",
        .source = "typedef int I;\n"
                  "enum { E = (I)3 << 30, F = 1 << 30, G = (short)1 << 31 };\n"
                  "int b[((__int128)1 << 127) < 0 ? 1 : 2];\n"
                  "int c[((long)1 << 63) < 0 ? 1 : 2];\n"
                  "_Static_assert((1 << 31) < 0, \"\");\n"
                  "struct S { int x[(1 << 31) < 0]; };\n"
                  "void f(void) { enum { H = 2 << 30 }; int y[(1 << 31) < 0 ? 1 : 2]; (void)y; }\n",
        .options = { "-Wshift-sign-overflow" },
        .warnings = 8,
    },
    {
        // Off by default, and a pragma's; none under -fwrapv.
        .name = "shift sign overflow policies",
        .source = "int a = 1 << 31;\n"
                  "#pragma clang diagnostic warning \"-Wshift-sign-overflow\"\n"
                  "int b = 1 << 31;\n"
                  "#pragma clang diagnostic ignored \"-Wshift-sign-overflow\"\n"
                  "int c = 1 << 31;\n",
        .warnings = 1,
    },
    {
        // A bit-precise type's own width: its sign bit, not a byte's.
        .name = "shift sign overflow of bit-precise types",
        .source = "_BitInt(9) a(void) { return (_BitInt(9))1 << 8; }\n"
                  "_BitInt(9) b(void) { return (_BitInt(9))1 << 7; }\n"
                  "_BitInt(9) c(void) { return (_BitInt(9))3 << 7; }\n"
                  "_BitInt(65) d(void) { return (_BitInt(65))1 << 64; }\n",
        .options = { "-Weverything", "-Wno-missing-prototypes", "-Wno-pre-c23-compat" },
        .c23 = true,
        .warnings = 3,
    },
    {
        .name = "shift sign overflow under -fwrapv",
        .source = "int a = 1 << 31;\n",
        .options = { "-Wshift-sign-overflow", "-fwrapv" },
    },
};
static const size_t fixture_35_lengths[] = {
sizeof("typedef int I;\n"
                  "int a = 1 << 31;\n"
                  "enum { E = 1 << 31 };\n"
                  "int b[(1 << 30 << 1) < 0 ? 1 : 2];\n"
                  "int f(int x)\n"
                  "{\n"
                  "    long c = 1L << 63;\n"
                  "    int d = 2 << 30, e = (I)3 << 30, g = (short)1 << 31, h = (char)64 << 25;\n"
                  "    unsigned u = 1u << 31;\n"
                  "    int v = 3 << 29, w = -1 << 3, y = 1 << 32, z = 0 << 31;\n"
                  "    unsigned long s = sizeof(1 << 31);\n"
                  "    __int128 q = (__int128)1 << 127;\n"
                  "    if (x)\n"
                  "        return 1 << 31;\n"
                  "    return (int)(x + c + d + e + g + h + u + v + w + y + z + s + q) + (1 << x);\n"
                  "}\n")-1,
sizeof("typedef int I;\n"
                  "enum { E = (I)3 << 30, F = 1 << 30, G = (short)1 << 31 };\n"
                  "int b[((__int128)1 << 127) < 0 ? 1 : 2];\n"
                  "int c[((long)1 << 63) < 0 ? 1 : 2];\n"
                  "_Static_assert((1 << 31) < 0, \"\");\n"
                  "struct S { int x[(1 << 31) < 0]; };\n"
                  "void f(void) { enum { H = 2 << 30 }; int y[(1 << 31) < 0 ? 1 : 2]; (void)y; }\n")-1,
sizeof("int a = 1 << 31;\n"
                  "#pragma clang diagnostic warning \"-Wshift-sign-overflow\"\n"
                  "int b = 1 << 31;\n"
                  "#pragma clang diagnostic ignored \"-Wshift-sign-overflow\"\n"
                  "int c = 1 << 31;\n")-1,
sizeof("_BitInt(9) a(void) { return (_BitInt(9))1 << 8; }\n"
                  "_BitInt(9) b(void) { return (_BitInt(9))1 << 7; }\n"
                  "_BitInt(9) c(void) { return (_BitInt(9))3 << 7; }\n"
                  "_BitInt(65) d(void) { return (_BitInt(65))1 << 64; }\n")-1,
sizeof("int a = 1 << 31;\n")-1
};
static const CheckDriverDefaultWarningFixture fixture_36[] =
{
    {
        // A comma, an addition, a subtraction or an assignment whose operand decays to its type, through parentheses, each
        // such operand once; a member array, a dereferenced array pointer; not where the operator's type differs.
        .name = "sizeof of operators on decayed arrays",
        .source = "int a[10];\n"
                  "int b[3];\n"
                  "unsigned long f(int x) { return sizeof(0, a) + sizeof(0, 1, a) + sizeof(a, 0) + sizeof((0, a)) + sizeof(x, b, a) + sizeof(b, a); }\n"
                  "void g(int (*q)[10], int *p) { (void)sizeof(*q + 1); (void)sizeof(p += 0); (void)sizeof(a[0] + 1); (void)sizeof(p = a); }\n"
                  "unsigned long h(void) { struct { int m[4]; } s; return sizeof(s.m + 1) + sizeof((s).m - 1) + sizeof(1 + a); }\n",
        .warnings = 13,
    },
    {
        // At file scope, in a macro, a typedef's spelling, a variable length and a const array; not alignof's operand, an
        // unparenthesized operand, an array parameter or a pointer.
        .name = "sizeof of operators on decayed arrays in other places",
        .source = "int a[10];\n"
                  "typedef int A[3];\n"
                  "A t;\n"
                  "unsigned long z = sizeof(a + 1);\n"
                  "#define S(x) sizeof(x + 1)\n"
                  "unsigned long f(int n, int p[3]) { int v[n]; const int c[2] = {0}; return S(a) + sizeof(t + 1) + sizeof(v + 1) + sizeof(c + 1) + "
                  "__alignof__(a + 1) + sizeof a + 1 + sizeof(p + 1) + sizeof(&a[0] + 1); }\n",
        .warnings = 5,
        .notes = 1,
    },
};
static const size_t fixture_36_lengths[] = {
sizeof("int a[10];\n"
                  "int b[3];\n"
                  "unsigned long f(int x) { return sizeof(0, a) + sizeof(0, 1, a) + sizeof(a, 0) + sizeof((0, a)) + sizeof(x, b, a) + sizeof(b, a); }\n"
                  "void g(int (*q)[10], int *p) { (void)sizeof(*q + 1); (void)sizeof(p += 0); (void)sizeof(a[0] + 1); (void)sizeof(p = a); }\n"
                  "unsigned long h(void) { struct { int m[4]; } s; return sizeof(s.m + 1) + sizeof((s).m - 1) + sizeof(1 + a); }\n")-1,
sizeof("int a[10];\n"
                  "typedef int A[3];\n"
                  "A t;\n"
                  "unsigned long z = sizeof(a + 1);\n"
                  "#define S(x) sizeof(x + 1)\n"
                  "unsigned long f(int n, int p[3]) { int v[n]; const int c[2] = {0}; return S(a) + sizeof(t + 1) + sizeof(v + 1) + sizeof(c + 1) + "
                  "__alignof__(a + 1) + sizeof a + 1 + sizeof(p + 1) + sizeof(&a[0] + 1); }\n")-1
};
static const CheckDriverDefaultWarningFixture fixture_37[] =
{
    {
        // A string literal and an operand of integer, boolean or enumeration type, in either order, at the `+`, the operand's
        // type as written (a typedef's, __size_t's sugar); not through parentheses, not a subtraction, not a pointer.
        .name = "integers added to string literals",
        .source = "typedef unsigned long size_t;\n"
                  "typedef int myint;\n"
                  "enum X { X1 };\n"
                  "const char* a(void) { return \"abc\" + 1; }\n"
                  "const char* b(int i) { return i + \"abc\"; }\n"
                  "const char* c(char ch, _Bool f) { (void)(\"ab\" + f); return \"abc\" + ch; }\n"
                  "const char* d(void) { return (\"abc\") + -1; }\n"
                  "const char* e(void) { return \"abc\" + sizeof(int) * 3; }\n"
                  "const char* g(size_t n, myint m, enum X x, _BitInt(7) w) { (void)(\"ab\" + m); (void)(\"ab\" + x); (void)(\"ab\" + w); return \"ab\" + n; }\n"
                  "const char* h(void) { return \"a\" \"b\" \"c\" + 2; }\n"
                  "const char* k(int i) { const char* r = \"abc\"; r += i; (void)r; return \"abc\" - i; }\n"
                  "const char* m(int* p) { return (const char*)p + 1; }\n"
                  "const char* n(int i) { return L\"abc\" + i ? \"x\" : \"y\"; }\n",
        .warnings = 11,
        .notes = 11,
    },
    {
        // At file scope, in a macro, and before an operand's own warning.
        .name = "integers added to string literals in other places",
        .source = "const char* g = \"abc\" + 1;\n"
                  "const char* h(int i) { return \"abc\" + (1 << 40) + i; }\n"
                  "#define P(x) (x + 1)\n"
                  "const char* k(void) { return P(\"abc\"); }\n"
                  "const char* m(void) { return 1 + \"x\" \"y\"; }\n"
                  "const char* n(int i) { return \"abc\" + (i); }\n",
        .warnings = 6,
        .notes = 7,
    },
};
static const size_t fixture_37_lengths[] = {
sizeof("typedef unsigned long size_t;\n"
                  "typedef int myint;\n"
                  "enum X { X1 };\n"
                  "const char* a(void) { return \"abc\" + 1; }\n"
                  "const char* b(int i) { return i + \"abc\"; }\n"
                  "const char* c(char ch, _Bool f) { (void)(\"ab\" + f); return \"abc\" + ch; }\n"
                  "const char* d(void) { return (\"abc\") + -1; }\n"
                  "const char* e(void) { return \"abc\" + sizeof(int) * 3; }\n"
                  "const char* g(size_t n, myint m, enum X x, _BitInt(7) w) { (void)(\"ab\" + m); (void)(\"ab\" + x); (void)(\"ab\" + w); return \"ab\" + n; }\n"
                  "const char* h(void) { return \"a\" \"b\" \"c\" + 2; }\n"
                  "const char* k(int i) { const char* r = \"abc\"; r += i; (void)r; return \"abc\" - i; }\n"
                  "const char* m(int* p) { return (const char*)p + 1; }\n"
                  "const char* n(int i) { return L\"abc\" + i ? \"x\" : \"y\"; }\n")-1,
sizeof("const char* g = \"abc\" + 1;\n"
                  "const char* h(int i) { return \"abc\" + (1 << 40) + i; }\n"
                  "#define P(x) (x + 1)\n"
                  "const char* k(void) { return P(\"abc\"); }\n"
                  "const char* m(void) { return 1 + \"x\" \"y\"; }\n"
                  "const char* n(int i) { return \"abc\" + (i); }\n")-1
};
static const char check_driver_type_safety_calls_source[] =
    "typedef struct ompi_datatype_t *MPI_Datatype;\n"
    "struct ompi_predefined_datatype_t { int a; };\n"
    "typedef int MPI_Int;\n"
    "typedef struct { int x; } Pair;\n"
    "typedef struct { int y; } Same;\n"
    "typedef struct { long y; } Other;\n"
    "typedef union { int i; float f; } U1;\n"
    "typedef union { float g; int j; } U2;\n"
    "typedef enum { E0 } E1;\n"
    "typedef enum { F0 } E2;\n"
    "extern struct ompi_predefined_datatype_t mpi_int __attribute__((type_tag_for_datatype(mpi, int)));\n"
    "extern struct ompi_predefined_datatype_t mpi_double __attribute__((type_tag_for_datatype(mpi, double)));\n"
    "extern struct ompi_predefined_datatype_t mpi_alias __attribute__((type_tag_for_datatype(mpi, MPI_Int)));\n"
    "extern struct ompi_predefined_datatype_t mpi_null __attribute__((type_tag_for_datatype(mpi, void, must_be_null)));\n"
    "extern struct ompi_predefined_datatype_t mpi_pair __attribute__((type_tag_for_datatype(mpi, Pair, layout_compatible)));\n"
    "extern struct ompi_predefined_datatype_t mpi_union __attribute__((type_tag_for_datatype(mpi, U1, layout_compatible)));\n"
    "extern struct ompi_predefined_datatype_t mpi_enum __attribute__((type_tag_for_datatype(mpi, E1, layout_compatible)));\n"
    "extern struct ompi_predefined_datatype_t mpi_char __attribute__((type_tag_for_datatype(mpi, char)));\n"
    "extern struct ompi_predefined_datatype_t mpi_const __attribute__((type_tag_for_datatype(mpi, const int)));\n"
    "extern struct ompi_predefined_datatype_t other_int __attribute__((type_tag_for_datatype(other, int)));\n"
    "#define MPI_INT ((MPI_Datatype)&mpi_int)\n"
    "#define MPI_DOUBLE ((MPI_Datatype)&mpi_double)\n"
    "int MPI_Send(const void *buf, int count, MPI_Datatype datatype) __attribute__((pointer_with_type_tag(mpi, 1, 3)));\n"
    "int MPI_Recv(void *buf, int count, MPI_Datatype datatype);\n"
    "int MPI_Recv(void *buf, int count, MPI_Datatype datatype) __attribute__((pointer_with_type_tag(mpi, 1, 3)));\n"
    "int MPI_Recv(void *buf, int count, MPI_Datatype datatype);\n"
    "void put(int value, MPI_Datatype datatype) __attribute__((argument_with_type_tag(mpi, 1, 2)));\n"
    "void (*sender)(void *buf, MPI_Datatype datatype) __attribute__((pointer_with_type_tag(mpi, 1, 2)));\n"
    "static const int magic_long __attribute__((type_tag_for_datatype(magic, long))) = 42;\n"
    "enum { MAGIC_DOUBLE = 7 };\n"
    "static const int magic_double __attribute__((type_tag_for_datatype(magic, double))) = MAGIC_DOUBLE;\n"
    "void take(void *buffer, int tag) __attribute__((pointer_with_type_tag(magic, 1, 2)));\n"
    "void use(int c) {\n"
    "    int i = 0; double d = 0; float f = 0; long l = 0; char ch = 0; signed char sc = 0; unsigned char uc = 0;\n"
    "    const int ci = 0; MPI_Int alias = 0; int array[4] = { 0 };\n"
    "    Pair pair; Same same; Other other; U1 u1; U2 u2; E1 e1; E2 e2;\n"
    "    MPI_Send(&i, 1, MPI_INT);\n"
    "    MPI_Send(&d, 1, MPI_INT);\n"
    "    MPI_Send(&f, 1, MPI_DOUBLE);\n"
    "    MPI_Send(&l, 1, (MPI_Datatype)&mpi_double);\n"
    "    MPI_Send(array, 4, MPI_INT);\n"
    "    MPI_Send(&array, 4, MPI_INT);\n"
    "    MPI_Send(&ci, 1, MPI_INT);\n"
    "    MPI_Send(&ci, 1, (MPI_Datatype)&mpi_const);\n"
    "    MPI_Send(&i, 1, (MPI_Datatype)&mpi_const);\n"
    "    MPI_Send(&alias, 1, (MPI_Datatype)&mpi_alias);\n"
    "    MPI_Send(&d, 1, (MPI_Datatype)&mpi_alias);\n"
    "    MPI_Send((void *)&d, 1, MPI_INT);\n"
    "    MPI_Send(0, 1, MPI_INT);\n"
    "    MPI_Send(&i, 1, (MPI_Datatype)&mpi_null);\n"
    "    MPI_Send(0, 1, (MPI_Datatype)&mpi_null);\n"
    "    MPI_Send(&ch, 1, (MPI_Datatype)&mpi_char);\n"
    "    MPI_Send(&sc, 1, (MPI_Datatype)&mpi_char);\n"
    "    MPI_Send(&uc, 1, (MPI_Datatype)&mpi_char);\n"
    "    MPI_Send(&same, 1, (MPI_Datatype)&mpi_pair);\n"
    "    MPI_Send(&other, 1, (MPI_Datatype)&mpi_pair);\n"
    "    MPI_Send(&pair, 1, (MPI_Datatype)&mpi_pair);\n"
    "    MPI_Send(&u2, 1, (MPI_Datatype)&mpi_union);\n"
    "    MPI_Send(&u1, 1, (MPI_Datatype)&mpi_union);\n"
    "    MPI_Send(&e2, 1, (MPI_Datatype)&mpi_enum);\n"
    "    MPI_Send(&i, 1, (MPI_Datatype)&other_int);\n"
    "    MPI_Send(&d, 1, c ? MPI_INT : MPI_DOUBLE);\n"
    "    MPI_Send(&d, 1, 1 ? MPI_INT : MPI_DOUBLE);\n"
    "    MPI_Send(&d, 1, (0, MPI_INT));\n"
    "    MPI_Send((&d), 1, MPI_INT);\n"
    "    MPI_Send(c ? &d : &d, 1, MPI_INT);\n"
    "    MPI_Send(array + 1, 1, MPI_DOUBLE);\n"
    "    MPI_Send(&pair.x, 1, MPI_DOUBLE);\n"
    "    MPI_Send(&d, 1, MPI_INT), MPI_Send(&f, 1, MPI_INT);\n"
    "    MPI_Recv(&d, 1, MPI_INT);\n"
    "    put(i, MPI_INT);\n"
    "    put(d, MPI_INT);\n"
    "    put(l, (MPI_Datatype)&mpi_double);\n"
    "    sender(&d, MPI_INT);\n"
    "    (*sender)(&d, MPI_INT);\n"
    "    take(&l, 42);\n"
    "    take(&d, 42);\n"
    "    take(&l, MAGIC_DOUBLE);\n"
    "    take(&l, 7);\n"
    "    take(&d, 43);\n"
    "}\n";
static const char check_driver_type_safety_order_source[] =
    "typedef int Datatype;\n"
    "void put(void *buffer, Datatype type) __attribute__((pointer_with_type_tag(tag, 1, 2)));\n"
    "void early(long *l) { put(l, 5); }\n"
    "static const Datatype tag_int __attribute__((type_tag_for_datatype(tag, int))) = 5;\n"
    "void middle(long *l) { put(l, 5); }\n"
    "static const Datatype tag_long __attribute__((type_tag_for_datatype(tag, long))) = 5;\n"
    "void late(long *l, int *i) {\n"
    "    put(l, 5);\n"
    "    put(i, 5);\n"
    "#pragma clang diagnostic push\n"
    "#pragma clang diagnostic ignored \"-Wtype-safety\"\n"
    "    put(i, 5);\n"
    "#pragma clang diagnostic pop\n"
    "    put(i, 0x5);\n"
    "    put(i, 5u);\n"
    "    put(i, (5));\n"
    "    put(i, '\\5');\n"
    "    put(i, +5);\n"
    "    put(i, (Datatype)5);\n"
    "    {\n"
    "        static const Datatype local __attribute__((type_tag_for_datatype(tag, int))) = 6;\n"
    "    }\n"
    "    put(l, 6);\n"
    "}\n"
    "struct ompi { int a; };\n"
    "extern struct ompi tag_short __attribute__((type_tag_for_datatype(tag, short)));\n"
    "extern struct ompi tag_short;\n"
    "void put2(void *buffer, struct ompi *type) __attribute__((pointer_with_type_tag(tag, 1, 2)));\n"
    "void put2(void *buffer, struct ompi *type);\n"
    "void put2(void *buffer, struct ompi *type) __attribute__((argument_with_type_tag(tag, 1, 2)));\n"
    "void again(int *i) { put2(i, &tag_short); }\n";
static const CheckDriverDefaultWarningFixture fixture_38[] =
{
    {
        .name = "-Wtype-safety's calls",
        .source = check_driver_type_safety_calls_source,
        .warnings = 25,
    },
    {
        .name = "-Wtype-safety's calls with an unsigned plain char",
        .source = check_driver_type_safety_calls_source,
        .options = { "-funsigned-char" },
        .warnings = 25,
    },
    {
        .name = "-Wtype-safety's calls in C23",
        .source = check_driver_type_safety_calls_source,
        .c23 = true,
        .warnings = 25,
    },
    {
        .name = "-Wno-type-safety",
        .source = check_driver_type_safety_calls_source,
        .options = { "-Wno-type-safety" },
        .warnings = 1,
    },
    {
        .name = "-Werror=type-safety",
        .source = check_driver_type_safety_calls_source,
        .options = { "-Werror=type-safety" },
        // clang's error limit stops it at its twentieth error, before the other warning.
        .errors = 20,
    },
    {
        .name = "registered values in source order, a pragma and redeclarations' rules",
        .source = check_driver_type_safety_order_source,
        .warnings = 8,
    },
};
static const size_t fixture_38_lengths[] = {
sizeof(check_driver_type_safety_calls_source)-1,
sizeof(check_driver_type_safety_calls_source)-1,
sizeof(check_driver_type_safety_calls_source)-1,
sizeof(check_driver_type_safety_calls_source)-1,
sizeof(check_driver_type_safety_calls_source)-1,
sizeof(check_driver_type_safety_order_source)-1
};
static const CheckDriverDefaultWarningFixture fixture_39[] =
{
    {
        .name = "aligned typedefs retain their names in conversions and incomplete arrays",
        .source = "typedef char C __attribute__((aligned(8)));\nC *p = 1;\nC c = \"x\";\n"
                  "struct X;\ntypedef struct X TX __attribute__((aligned(8)));\nTX a[3];\n",
        .errors = 4,
        .notes = 1,
    },
    {
        .name = "an aligned typedef names an array element whose size is not a multiple of its alignment",
        .source = "typedef char C __attribute__((aligned(8)));\nC a[2];\n",
        .errors = 1,
    },
    {
        .name = "aligned typedefs retain their own and outer qualifiers without naming plain neighbors",
        .source = "typedef const int CI __attribute__((aligned(8)));\ntypedef int *P __attribute__((aligned(32)));\n"
                  "void f(void){volatile CI *a=1;const P b=1;P c=1;char *d=1;}\n",
        .errors = 4,
    },
    {
        .name = "a qualified aligned typedef names its incomplete array element",
        .source = "struct X;\ntypedef struct X TX __attribute__((aligned(8)));\nconst TX a[3];\n",
        .errors = 1,
        .notes = 1,
    },
    {
        .name = "a decayed function typedef survives pointer arithmetic at file scope",
        .source = "typedef int F(void);\nF f1;\nint z2 = f1 + 1;\n",
        .errors = 2,
    },
    {
        .name = "function typedefs survive both addition orders subtraction and address operations",
        .source = "typedef int F(void);typedef F G;\nG g;F f;\nvoid h(void){int a=f+1;int b=1+f;int c=f-1;"
                  "int d=g+2;int e=&f;int z=*&f+3;int (*raw)(void)=f;int w=raw+1;}\n",
        .errors = 7,
    },
    {
        .name = "function pointer typedefs in members parameters and casts keep their spelling",
        .source = "typedef int F(void);typedef F *FP;\nstruct S{F *p;FP q;};\n"
                  "void h(struct S s,FP p){int a=s.p+1;int b=p+1;int c=(F*)0+1;int d=*(F*)0+1;}\n",
        .errors = 4,
    },
    {
        // A dereference's or subscript's operand keeps the typedef its object's declaration chain names at that level
        // (check_driver_spelling_chain): a vector reached through a pointer typedef prints its own typedef, a typedef
        // inside a typedef its inner name, a parameter's array typedef its element's.
        .name = "typedef chains through dereferences and subscripts",
        .source = "typedef int v4si __attribute__((vector_size(16)));\n"
                  "typedef v4si *pv;\n"
                  "typedef pv *pvp;\n"
                  "typedef void *VP;\n"
                  "typedef VP *VPP;\n"
                  "typedef int I;\n"
                  "typedef I *IP;\n"
                  "typedef IP IPA[2];\n"
                  "void f(pv p, pvp pp, VPP b, IPA a, IP *q, v4si *direct)\n"
                  "{\n"
                  "    (*p)++;\n"
                  "    p[1]--;\n"
                  "    ++**pp;\n"
                  "    (*pp)();\n"
                  "    (void)**b;\n"
                  "    a[0]();\n"
                  "    (*a[1])();\n"
                  "    (*q)();\n"
                  "    (**q)();\n"
                  "    (*direct)++;\n"
                  "}\n",
        .warnings = 1,
        .errors = 9,
    },
    {
        // A member's operand keeps its member declarator's typedef (check_semantic_member_token): through `.`, `->`,
        // anonymous members, a member's own dereference and subscript, and a const record's or member's qualifiers.
        .name = "member typedefs in operand errors",
        .source = "typedef int I;\n"
                  "struct u { int a; };\n"
                  "typedef struct u uu;\n"
                  "typedef uu *uup;\n"
                  "typedef int v4si __attribute__((vector_size(16)));\n"
                  "struct s\n"
                  "{\n"
                  "    uu f;\n"
                  "    uup g;\n"
                  "    I arr[2];\n"
                  "    struct { uu deep; I *ip; };\n"
                  "    union { v4si v; float fl; } un;\n"
                  "    const uu cf;\n"
                  "    struct s *next;\n"
                  "};\n"
                  "void g(struct s x, struct s *px, const struct s cx)\n"
                  "{\n"
                  "    x.f++;\n"
                  "    px->f++;\n"
                  "    (*x.g)++;\n"
                  "    x.g->a();\n"
                  "    x.arr[0]();\n"
                  "    x.deep--;\n"
                  "    (*px->ip)();\n"
                  "    x.un.v++;\n"
                  "    cx.f++;\n"
                  "    x.cf++;\n"
                  "    px->next->next->f++;\n"
                  "    (x).f();\n"
                  "    x.next->ip();\n"
                  "}\n",
        .errors = 13,
    },
    {
        // A typedef of a qualified type names the element of its array (type_print_element_qualifiers): clang's
        // `'CI[2]' (aka 'const int[2]')`, in the const variable's error and an increment's.
        .name = "qualified typedefs of array elements",
        .source = "typedef const int CI;\n"
                  "typedef volatile int VI;\n"
                  "typedef const int CA[3];\n"
                  "void f(void)\n"
                  "{\n"
                  "    CI arr[2] = { 1, 2 };\n"
                  "    arr[0] = 3;\n"
                  "    arr++;\n"
                  "    VI v[4];\n"
                  "    v++;\n"
                  "    CA m[2] = { 0 };\n"
                  "    m[1][2] = 4;\n"
                  "    m++;\n"
                  "}\n",
        .errors = 5,
        .notes = 2,
    },
    {
        // A qualifier written again beside a qualified typedef (check_input_typedef_sugar) prints over its name, as
        // clang's qualifiers over a typedef's sugar do (`'const CI[1]' (aka 'const int[1]')`); a typedef of fewer
        // qualifiers than its level's names it under the others (`'volatile CI[2]'`).
        .name = "qualifiers written again over a qualified typedef",
        .source = "typedef const int CI;\n"
                  "typedef volatile int VI;\n"
                  "typedef unsigned U;\n"
                  "struct s { const CI m; CI n; };\n"
                  "void f(const CI y, volatile U u, struct s *ps)\n"
                  "{\n"
                  "    const CI twice[1] = { 1 };\n"
                  "    twice++;\n"
                  "    const CI one = 1;\n"
                  "    one = 2;\n"
                  "    CI const after[2] = { 1 };\n"
                  "    after++;\n"
                  "    volatile CI mixed[2] = { 0 };\n"
                  "    mixed++;\n"
                  "    const VI cv[2] = { 0 };\n"
                  "    cv++;\n"
                  "    static const CI s2[2][3];\n"
                  "    s2++;\n"
                  "    const CI *p = 0;\n"
                  "    p();\n"
                  "    if (y < u) {}\n"
                  "    if (ps->m < u) {}\n"
                  "    ps->m();\n"
                  "    ps->n();\n"
                  "    const U a = 1, b = 2;\n"
                  "    if (a + b < y) {}\n"
                  "}\n",
        .options = { "-Wsign-compare" },
        .warnings = 3,
        .errors = 9,
        .notes = 1,
    },
    {
        // A format argument prints its type as clang's lvalue conversion leaves it (check_common_format_value): without
        // its top-level qualifiers, so a typedef that holds them itself prints desugared (`CI`'s `'int'`), and an array
        // decays to a pointer to its qualified element (`'const int *'`).
        .name = "format arguments' value types",
        .source = "int printf(const char *, ...);\n"
                  "typedef const int CI;\n"
                  "typedef int I;\n"
                  "typedef const char *CS;\n"
                  "const int g = 1;\n"
                  "const I gi = 2;\n"
                  "CI gc = 3;\n"
                  "struct s { const I m; CI n; const int k; };\n"
                  "void f(const int l, const I x, CI y, struct s t, const CS q, const I *pi, volatile I vi)\n"
                  "{\n"
                  "    printf(\"%s %s %s %s %s\\n\", g, gi, gc, l, x);\n"
                  "    printf(\"%s %s %s %s %d %d\\n\", y, t.m, t.n, t.k, q, pi);\n"
                  "    printf(\"%s %s\\n\", vi, *pi);\n"
                  "    const int a[2] = { 0 };\n"
                  "    printf(\"%d\\n\", a);\n"
                  "}\n",
        .warnings = 14,
    },
    {
        // A target address space one macro writes throughout the unit prints by the macro (check_driver_space_macros,
        // clang's MacroQualifiedType): before its level, with that level's other qualifiers after its specifier; a
        // function-like macro by its invocation, nested macros by the outermost; a typedef's a.k.a. spells it out.
        .name = "address space macro names",
        .source = "#define AS1 __attribute__((address_space(1)))\n"
                  "#define ASN(n) __attribute__((address_space(n)))\n"
                  "#define INNER __attribute__((address_space(4)))\n"
                  "#define OUTER INNER\n"
                  "typedef AS1 int I1;\n"
                  "struct m { AS1 int *f; };\n"
                  "void f(const AS1 int *a, AS1 const volatile int *b, int *AS1 *c, I1 *d, ASN(3) int *e, OUTER int *g, struct m mm, AS1 int *const k, I1 *const *l)\n"
                  "{\n"
                  "    a();\n"
                  "    b();\n"
                  "    c();\n"
                  "    d();\n"
                  "    e();\n"
                  "    g();\n"
                  "    mm.f();\n"
                  "    k();\n"
                  "    l();\n"
                  "    a = e;\n"
                  "    int x = a;\n"
                  "}\n",
        .errors = 11,
    },
    {
        // Each declaration's own address space macro (#1447 item 2, check_driver_space_scope): two macros of one space and a
        // direct spelling, in the address space errors' operands (an assignment's, an initialization's, a return's, a call's,
        // a nested pointer's, and both operands of non-overlapping spaces' arithmetic); a typedef's by the unit's.
        .name = "address space macros per declaration",
        .source = "#define AS1 __attribute__((address_space(1)))\n"
                  "#define ASA __attribute__((address_space(1)))\n"
                  "#define AS2 __attribute__((address_space(2)))\n"
                  "typedef AS1 int T1;\n"
                  "void g(AS2 int *q);\n"
                  "AS1 int *ret(ASA int *x) { return x; }\n"
                  "void f(AS1 int *pa, ASA int *pb)\n"
                  "{\n"
                  "    AS1 int *a = 0;\n"
                  "    ASA int *b = 0;\n"
                  "    __attribute__((address_space(1))) int *c = 0;\n"
                  "    AS2 int *d = 0;\n"
                  "    T1 *t = 0;\n"
                  "    long *p;\n"
                  "    int *i = a;\n"
                  "    AS2 int *e = b;\n"
                  "    p = a;\n"
                  "    p = b;\n"
                  "    p = c;\n"
                  "    p = t;\n"
                  "    p = pa;\n"
                  "    p = pb;\n"
                  "    d = a;\n"
                  "    a = d;\n"
                  "    b = d;\n"
                  "    g(a);\n"
                  "    g(b);\n"
                  "    p = &*b;\n"
                  "    long *q = pb;\n"
                  "    int x = d - b;\n"
                  "    AS1 int **pp = 0;\n"
                  "    int **ip = pp;\n"
                  "}\n",
        .errors = 17,
        .notes = 2,
    },
    {
        .name = "address space macros of one declaration",
        .source = "#define AS1 __attribute__((address_space(1)))\n"
                  "#define ASA __attribute__((address_space(1)))\n"
                  "void f(void)\n"
                  "{\n"
                  "    AS1 int *a = 0;\n"
                  "    ASA int *b = 0;\n"
                  "    __attribute__((address_space(1))) int *c = 0;\n"
                  "    long *p;\n"
                  "    p = a;\n"
                  "    p = b;\n"
                  "    p = c;\n"
                  "    p = &*a;\n"
                  "}\n",
        .errors = 4,
    },
    {
        // A failed conversion's types, by each declaration's macro, and no "dereference with *" where the pointee's space
        // differs from the target's (compareTypesSimple's compatiblyIncludes).
        .name = "address space macros in conversions",
        .source = "#define AS1 __attribute__((address_space(1)))\n"
                  "#define ASA __attribute__((address_space(1)))\n"
                  "void h(ASA long *z);\n"
                  "void f(void)\n"
                  "{\n"
                  "    AS1 int *a = 0;\n"
                  "    ASA long *l = a;\n"
                  "    AS1 long *m = 0;\n"
                  "    m = a;\n"
                  "    l = a;\n"
                  "    h(a);\n"
                  "    int n = a;\n"
                  "    ASA char c = 0;\n"
                  "    char *pc = &c;\n"
                  "}\n",
        .errors = 6,
        .notes = 1,
    },
    {
        // No macro names a space where clang's FindLocsWithCommonFileID finds none: a predefined macro's (`__seg_gs`, and
        // a user macro over it) and an attribute list that isn't its macro's whole expansion.
        .name = "address spaces no macro names",
        .source = "#define MYGS __seg_gs\n"
                  "#define CAS const __attribute__((address_space(1)))\n"
                  "#define ASV __attribute__((address_space(2))) volatile\n"
                  "#define AS3 __attribute__((address_space(3)))\n"
                  "void f(__seg_gs int *a, MYGS int *b, CAS int *c, ASV int *d, AS3 int *e)\n"
                  "{\n"
                  "    a();\n"
                  "    b();\n"
                  "    c();\n"
                  "    d();\n"
                  "    e();\n"
                  "}\n",
        .errors = 5,
    },
    {
        // Several warnings of one pass print by the macros, each event after the first reading the pass's map
        // (check_driver_spelling_ready builds it below the events' marks).
        .name = "address space macro names in several warnings of one pass",
        .source = "int printf(const char *, ...);\n"
                  "#define AS1 __attribute__((address_space(1)))\n"
                  "#define AS2 __attribute__((address_space(2)))\n"
                  "void f(AS1 int *p, AS2 char *q, AS1 const int *r)\n"
                  "{\n"
                  "    printf(\"%d\\n\", p);\n"
                  "    printf(\"%f\\n\", q);\n"
                  "    printf(\"%d %d\\n\", r, p);\n"
                  "}\n",
        .warnings = 4,
    },
    {
        // The same through incompatible pointer conversions' errors.
        .name = "address space macro names in several conversion errors",
        .source = "#define AS1 __attribute__((address_space(1)))\n"
                  "#define AS2 __attribute__((address_space(2)))\n"
                  "void f(AS1 int *p, AS2 char *q)\n"
                  "{\n"
                  "    AS1 char *a = p;\n"
                  "    AS2 int *b = q;\n"
                  "    AS1 long *c = p;\n"
                  "    AS2 short *d = q;\n"
                  "    (void)a; (void)b; (void)c; (void)d;\n"
                  "}\n",
        .errors = 4,
    },
    {
        // A space written directly with an integer suffix is that space's direct spelling: the macro another declaration
        // writes it with names neither.
        .name = "address spaces written directly with integer suffixes",
        .source = "#define AS1 __attribute__((address_space(1)))\n"
                  "int AS1 *x;\n"
                  "void f(int __attribute__((address_space(1u))) *p, int __attribute__((address_space(1UL))) *r)\n"
                  "{\n"
                  "    int *q = p;\n"
                  "    int *s = r;\n"
                  "}\n",
        .errors = 2,
    },
    {
        // An operand that isn't a plain integer constant (`1+0`) may write any space: no macro names one.
        .name = "address spaces written with a constant expression",
        .source = "#define AS1 __attribute__((address_space(1)))\n"
                  "int AS1 *x;\n"
                  "void f(int __attribute__((address_space(1+0))) *p)\n"
                  "{\n"
                  "    int *q = p;\n"
                  "}\n",
        .errors = 1,
    },
    {
        // A multidimensional array's qualifiers pass through each element array to the typedef that names them.
        .name = "qualified typedefs of multidimensional array elements",
        .source = "typedef const int CI;\n"
                  "typedef volatile int VI;\n"
                  "void f(void) { CI b[2][3] = { 0 }; b++; b[0]++; VI c[1][2][3]; c++; c[0]++; }\n",
        .errors = 4,
    },
    {
        // Warnings' operands keep their member's typedef (check_common_operand_spelling): -Wsign-compare's, -Wformat's
        // and -Wenum-compare's, through `.`, `->` and a member array's subscript.
        .name = "member typedefs in warning operands",
        .source = "int printf(const char *, ...);\n"
                  "typedef unsigned long ul;\n"
                  "typedef enum { A1, A2 } EA;\n"
                  "typedef enum { B1 } EB;\n"
                  "typedef double D;\n"
                  "struct s { ul n; EA ea; EB eb; D d; ul arr[2]; struct s *next; };\n"
                  "int f(struct s x, struct s *px, int i)\n"
                  "{\n"
                  "    int r = 0;\n"
                  "    r += x.n < i;\n"
                  "    r += px->next->arr[0] < i;\n"
                  "    r += x.ea == x.eb;\n"
                  "    r += x.ea + px->eb;\n"
                  "    r += (x.ea < px->eb);\n"
                  "    printf(\"%d %s %f\\n\", x.n, px->d, x.arr[1]);\n"
                  "    printf(\"%ld\\n\", x.d);\n"
                  "    return r + (i ? x.ea : x.eb);\n"
                  "}\n",
        .options = { "-Wsign-compare" },
        .warnings = 8,
    },
    {
        // clang's desugarForDiagnostic doesn't look inside an _Atomic (check_driver_atomic_value): a typedef that is an
        // atomic's value type gives no a.k.a.
        .name = "typedefs inside _Atomic",
        .source = "typedef int I;\n"
                  "typedef long L;\n"
                  "struct S { int x; };\n"
                  "typedef struct S TS;\n"
                  "void f(_Atomic(I) *ap, _Atomic(L) a2[2], _Atomic(TS) *sp, _Atomic I *kw)\n"
                  "{\n"
                  "    ap();\n"
                  "    char *d = ap;\n"
                  "    char *e = a2;\n"
                  "    char *g = sp;\n"
                  "    char *h = kw;\n"
                  "}\n",
        .errors = 5,
    },
    {
        // A typeof's operand prints as written (#1837, check_driver_typeof_text): an expression as clang's StmtPrinter
        // does, with expression spacing (`'typeof (x + 1) *'`), and a type name with its typedef names (`'typeof(L *)'`).
        .name = "typeof expressions and type names with typedefs",
        .source = "typedef long L;\n"
                  "typedef int I;\n"
                  "int x, arr[4];\n"
                  "struct T { int f; } t;\n"
                  "typeof(x + 1) y;\n"
                  "typeof(L *) z;\n"
                  "typeof(x+1) *w;\n"
                  "typeof(arr[1]) v;\n"
                  "typeof(t.f) u;\n"
                  "typeof(-x) n;\n"
                  "typeof((x)) pq;\n"
                  "typeof(sizeof x) sz;\n"
                  "typeof(L const *) cz;\n"
                  "typeof(I *) iz[2];\n"
                  "typeof(x ? 1 : 2) cond;\n"
                  "void f(void)\n"
                  "{\n"
                  "    char *a = &y;\n"
                  "    char *b = z;\n"
                  "    char *c = w;\n"
                  "    char *d = &v;\n"
                  "    char *e = &u;\n"
                  "    char *g = &n;\n"
                  "    char *h = &pq;\n"
                  "    char *i = &sz;\n"
                  "    char *j = cz;\n"
                  "    char *k = iz;\n"
                  "    char *l = &cond;\n"
                  "}\n",
        .errors = 11,
    },
    {
        // The same in C23, with GNU's spellings, typeof_unqual, a nested typeof, a call, a cast and a string literal.
        .name = "typeof expressions in C23",
        .source = "typedef long L;\n"
                  "int x;\n"
                  "const int cx = 0;\n"
                  "__typeof__(x * 2) a;\n"
                  "__typeof(x) b2;\n"
                  "typeof_unqual(cx + 1) c;\n"
                  "typeof_unqual(L *) d;\n"
                  "typeof(typeof(x + 1)) e;\n"
                  "int f(int);\n"
                  "typeof(f(x)) h;\n"
                  "typeof((L)x) i;\n"
                  "typeof(\"ab\") s;\n"
                  "void k(void)\n"
                  "{\n"
                  "    char *p1 = &a; char *p3 = &c; char *p4 = d; char *p5 = &e; char *p6 = &h; char *p7 = &i; int *p8 = &s;\n"
                  "}\n",
        .errors = 7,
        .c23 = true,
    },
    {
        // A member's own declarator's specifiers spell its type (#1837, check_semantic_member_token): a conversion's
        // source through `&` and `*` (check_driver_pointer_spelling), an assignment's member target, and the null pointer
        // warning's.
        .name = "member typedefs and typeofs in conversions",
        .source = "typedef long L;\n"
                  "struct S { typeof(long) m; L l; typeof(L *) p; } s;\n"
                  "int x;\n"
                  "typeof(x + 1) y;\n"
                  "typeof(L *) z;\n"
                  "void f(void)\n"
                  "{\n"
                  "    char *a = &s.m;\n"
                  "    char *b = &s.l;\n"
                  "    char *c = s.p;\n"
                  "    char *d = &y;\n"
                  "    char *e = z;\n"
                  "}\n",
        .errors = 5,
    },
    {
        .name = "member typedefs as conversion sources and targets",
        .source = "typedef long L;\n"
                  "typedef L *LP;\n"
                  "typedef int I;\n"
                  "struct In { L deep; };\n"
                  "struct S { L l; LP lp; LP *lpp; struct In in; L arr[3]; typeof(I) ti; I *ip; const L cl; } s, *ps;\n"
                  "void take(char *);\n"
                  "void f(void)\n"
                  "{\n"
                  "    char *a = &ps->l;\n"
                  "    char *b = s.lp;\n"
                  "    char *c = *s.lpp;\n"
                  "    char *d = &s.in.deep;\n"
                  "    char *e = s.arr;\n"
                  "    char *g = &s.arr[1];\n"
                  "    char *h = &s.ti;\n"
                  "    char *k = &s.cl;\n"
                  "    take(&s.l);\n"
                  "    take(s.lp);\n"
                  "    char *m;\n"
                  "    m = s.ip;\n"
                  "    s.lp = m;\n"
                  "    s.ip = m;\n"
                  "    ps->lp = m;\n"
                  "    s.l = m;\n"
                  "    return;\n"
                  "}\n",
        .errors = 15,
        .notes = 2,
    },
    {
        .name = "member typedefs in null pointer warnings",
        .source = "typedef long *LP;\n"
                  "typedef unsigned U;\n"
                  "struct S { LP lp; U u; } s, *ps;\n"
                  "int n;\n"
                  "void f(void)\n"
                  "{\n"
                  "    s.lp = 1-1;\n"
                  "    ps->lp = 1-1;\n"
                  "    (s).lp = 1-1;\n"
                  "    int r = s.u < n;\n"
                  "    static int z = sizeof(s.u < -1);\n"
                  "    LP local = 1-1;\n"
                  "}\n",
        .options = { "-Wsign-compare" },
        .warnings = 5,
    },
    {
        // A compound literal's type name spells its value's type (#1812, check_input_token_type_spelling): through `&`, a
        // decay, a member, -Wformat's and -Wsign-compare's operands.
        .name = "compound literals' typedefs",
        .source = "int printf(const char *, ...);\n"
                  "typedef long L;\n"
                  "typedef unsigned U;\n"
                  "typedef struct P { int x; } P;\n"
                  "typedef int A2[2];\n"
                  "void f(int n)\n"
                  "{\n"
                  "    char *a = &(L){ 1 };\n"
                  "    char *b = (A2){ 1, 2 };\n"
                  "    int c = (P){ 1 };\n"
                  "    char *d = &(const L){ 2 };\n"
                  "    printf(\"%s %s\\n\", (L){ 3 }, (A2){ 0 });\n"
                  "    if (n < (U){ 4 }) {}\n"
                  "    char *e = (L[]){ 1, 2, 3 };\n"
                  "    char *g = &(P){ 0 }.x;\n"
                  "}\n",
        .options = { "-Wsign-compare" },
        .warnings = 3,
        .errors = 6,
    },
    {
        // GNU's array initialized by a compound literal of another array type: the literal's typedef as written.
        .name = "an array literal's typedef in its mismatch",
        .source = "typedef int A2[2];\n"
                  "typedef const int CA[2];\n"
                  "void f(void)\n"
                  "{\n"
                  "    int x[3] = (A2){1,2};\n"
                  "    long y[2] = (A2){1,2};\n"
                  "    int z[2] = (CA){1,2};\n"
                  "}\n",
        .errors = 3,
    },
    {
        // A null pointer constant argument's warning prints its parameter's type with the typedef the callee's declaration
        // writes (#1100, check_input_parameter_spelling): a function's, a function pointer object's (through `*`), its
        // typedef'd function type's and a member's own parameter list; a variadic argument has none.
        .name = "call arguments' parameter typedefs in null pointer warnings",
        .source = "typedef struct N { int x; } N;\n"
                  "typedef N *NP;\n"
                  "typedef int *IP;\n"
                  "typedef void F(N *);\n"
                  "void a(const N *q);\n"
                  "void b(NP);\n"
                  "void h(int x, IP p, N *const r);\n"
                  "void e(N *q[]);\n"
                  "void f(int n, N *(*g)(void), NP const r);\n"
                  "void d(int, ...);\n"
                  "void (*fp)(N *);\n"
                  "F *gp;\n"
                  "struct S { void (*m)(N *); } s;\n"
                  "static int z = sizeof(a(1-1), 0);\n"
                  "int main(void)\n"
                  "{\n"
                  "    a(1-1); b(1-1); h(0, 1-1, 1-1); e(1-1); f(0, 1-1, 1-1); d(1, 1-1);\n"
                  "    (a)(1-1); fp(1-1); (*fp)(1-1); gp(1-1); s.m(1-1);\n"
                  "    void (*lp)(int, N *) = 0;\n"
                  "    lp(0, 1-1);\n"
                  "    return 0;\n"
                  "}\n",
        .warnings = 13,
    },
    {
        // A conversion's target keeps the typedef its declaration writes (#1447): an enumeration conversion's parameter
        // (check_input_call_parameter_spelling), and an initializer subobject's member or element, found by its offset
        // from the initialized object (check_semantic_subobject_spelling), in -Wimplicit-enum-enum-cast and in a failed
        // conversion's error alike.
        .name = "parameter, member and element targets' typedefs",
        .source = "enum E { A, B };\n"
                  "enum F { X, Y };\n"
                  "typedef enum E TE;\n"
                  "typedef long L;\n"
                  "typedef long *LP;\n"
                  "struct S { TE te; L l; LP lp; };\n"
                  "void take(TE e);\n"
                  "TE arr[2];\n"
                  "void f(enum F v, char *c)\n"
                  "{\n"
                  "    take(X);\n"
                  "    take(v);\n"
                  "    struct S s = { .te = X };\n"
                  "    struct S t = { v };\n"
                  "    s.te = v;\n"
                  "    arr[0] = v;\n"
                  "    TE local = v;\n"
                  "    TE ls[2] = { v, X };\n"
                  "    struct S w = { .lp = c };\n"
                  "    struct S z = { 0, c };\n"
                  "    L la[2] = { c };\n"
                  "    LP lpa[2] = { 0, c };\n"
                  "}\n"
                  "struct In { TE e; LP p; };\n"
                  "struct Out { int k; struct In in[2]; union { L ul; TE ue; } u; };\n"
                  "void g(enum F v, char *c, struct S *ps)\n"
                  "{\n"
                  "    struct Out o = { 0, { { X, 0 }, { .e = v } }, { .ue = v } };\n"
                  "    struct Out q = { 0, { { A, 0 }, { .p = c } } };\n"
                  "    void (*fp)(int, TE) = 0;\n"
                  "    fp(0, v);\n"
                  "    (*fp)(1, X);\n"
                  "}\n",
        .warnings = 14,
        .errors = 5,
    },
    {
        // A discarded call whose callee has no function's name keeps its return type's typedef (#1447,
        // check_common_ignored_callee): a member's, an element's, a call's result's, a comma's and a conditional's value
        // and a pointer to a pointer's dereference, each by the typedef past its declarator's `*`.
        .name = "nodiscard return typedefs through nameless callees",
        .source = "typedef int R __attribute__((warn_unused_result));\n"
                  "struct __attribute__((warn_unused_result)) S { int x; };\n"
                  "typedef R (*FP)(void);\n"
                  "struct T { R (*m)(void); struct S (*sm)(void); } t, *pt;\n"
                  "R (*arr[2])(void);\n"
                  "FP get(void);\n"
                  "void f(int n, R (**pp)(void), FP a, FP b, struct S (*sp)(void))\n"
                  "{\n"
                  "    t.m();\n"
                  "    pt->sm();\n"
                  "    arr[0]();\n"
                  "    get()();\n"
                  "    (n, a)();\n"
                  "    (n ? a : b)();\n"
                  "    (*pp)();\n"
                  "    sp();\n"
                  "    a();\n"
                  "}\n",
        .options = { "-Wall" },
        .warnings = 10,
    },
    {
        // The same callees whose pointer returns another type: no warning.
        .name = "nameless callees of unmarked return types",
        .source = "typedef int R __attribute__((warn_unused_result));\n"
                  "typedef int Q;\n"
                  "struct T { Q (*m)(void); R *(*rp)(void); } t;\n"
                  "Q (*arr[2])(void);\n"
                  "R *(*parr[2])(void);\n"
                  "Q (*get(void))(void);\n"
                  "void f(int n, Q (**pp)(void), R *(**rpp)(void))\n"
                  "{\n"
                  "    t.m(); t.rp(); arr[0](); parr[1](); get()(); (*pp)(); (*rpp)(); (n, arr[0])();\n"
                  "}\n",
        .options = { "-Wall" },
        .warnings = 1,
    },
};
static const size_t fixture_39_lengths[] = {
sizeof("typedef char C __attribute__((aligned(8)));\nC *p = 1;\nC c = \"x\";\n"
                  "struct X;\ntypedef struct X TX __attribute__((aligned(8)));\nTX a[3];\n")-1,
sizeof("typedef char C __attribute__((aligned(8)));\nC a[2];\n")-1,
sizeof("typedef const int CI __attribute__((aligned(8)));\ntypedef int *P __attribute__((aligned(32)));\n"
                  "void f(void){volatile CI *a=1;const P b=1;P c=1;char *d=1;}\n")-1,
sizeof("struct X;\ntypedef struct X TX __attribute__((aligned(8)));\nconst TX a[3];\n")-1,
sizeof("typedef int F(void);\nF f1;\nint z2 = f1 + 1;\n")-1,
sizeof("typedef int F(void);typedef F G;\nG g;F f;\nvoid h(void){int a=f+1;int b=1+f;int c=f-1;"
                  "int d=g+2;int e=&f;int z=*&f+3;int (*raw)(void)=f;int w=raw+1;}\n")-1,
sizeof("typedef int F(void);typedef F *FP;\nstruct S{F *p;FP q;};\n"
                  "void h(struct S s,FP p){int a=s.p+1;int b=p+1;int c=(F*)0+1;int d=*(F*)0+1;}\n")-1,
sizeof("typedef int v4si __attribute__((vector_size(16)));\n"
                  "typedef v4si *pv;\n"
                  "typedef pv *pvp;\n"
                  "typedef void *VP;\n"
                  "typedef VP *VPP;\n"
                  "typedef int I;\n"
                  "typedef I *IP;\n"
                  "typedef IP IPA[2];\n"
                  "void f(pv p, pvp pp, VPP b, IPA a, IP *q, v4si *direct)\n"
                  "{\n"
                  "    (*p)++;\n"
                  "    p[1]--;\n"
                  "    ++**pp;\n"
                  "    (*pp)();\n"
                  "    (void)**b;\n"
                  "    a[0]();\n"
                  "    (*a[1])();\n"
                  "    (*q)();\n"
                  "    (**q)();\n"
                  "    (*direct)++;\n"
                  "}\n")-1,
sizeof("typedef int I;\n"
                  "struct u { int a; };\n"
                  "typedef struct u uu;\n"
                  "typedef uu *uup;\n"
                  "typedef int v4si __attribute__((vector_size(16)));\n"
                  "struct s\n"
                  "{\n"
                  "    uu f;\n"
                  "    uup g;\n"
                  "    I arr[2];\n"
                  "    struct { uu deep; I *ip; };\n"
                  "    union { v4si v; float fl; } un;\n"
                  "    const uu cf;\n"
                  "    struct s *next;\n"
                  "};\n"
                  "void g(struct s x, struct s *px, const struct s cx)\n"
                  "{\n"
                  "    x.f++;\n"
                  "    px->f++;\n"
                  "    (*x.g)++;\n"
                  "    x.g->a();\n"
                  "    x.arr[0]();\n"
                  "    x.deep--;\n"
                  "    (*px->ip)();\n"
                  "    x.un.v++;\n"
                  "    cx.f++;\n"
                  "    x.cf++;\n"
                  "    px->next->next->f++;\n"
                  "    (x).f();\n"
                  "    x.next->ip();\n"
                  "}\n")-1,
sizeof("typedef const int CI;\n"
                  "typedef volatile int VI;\n"
                  "typedef const int CA[3];\n"
                  "void f(void)\n"
                  "{\n"
                  "    CI arr[2] = { 1, 2 };\n"
                  "    arr[0] = 3;\n"
                  "    arr++;\n"
                  "    VI v[4];\n"
                  "    v++;\n"
                  "    CA m[2] = { 0 };\n"
                  "    m[1][2] = 4;\n"
                  "    m++;\n"
                  "}\n")-1,
sizeof("typedef const int CI;\n"
                  "typedef volatile int VI;\n"
                  "typedef unsigned U;\n"
                  "struct s { const CI m; CI n; };\n"
                  "void f(const CI y, volatile U u, struct s *ps)\n"
                  "{\n"
                  "    const CI twice[1] = { 1 };\n"
                  "    twice++;\n"
                  "    const CI one = 1;\n"
                  "    one = 2;\n"
                  "    CI const after[2] = { 1 };\n"
                  "    after++;\n"
                  "    volatile CI mixed[2] = { 0 };\n"
                  "    mixed++;\n"
                  "    const VI cv[2] = { 0 };\n"
                  "    cv++;\n"
                  "    static const CI s2[2][3];\n"
                  "    s2++;\n"
                  "    const CI *p = 0;\n"
                  "    p();\n"
                  "    if (y < u) {}\n"
                  "    if (ps->m < u) {}\n"
                  "    ps->m();\n"
                  "    ps->n();\n"
                  "    const U a = 1, b = 2;\n"
                  "    if (a + b < y) {}\n"
                  "}\n")-1,
sizeof("int printf(const char *, ...);\n"
                  "typedef const int CI;\n"
                  "typedef int I;\n"
                  "typedef const char *CS;\n"
                  "const int g = 1;\n"
                  "const I gi = 2;\n"
                  "CI gc = 3;\n"
                  "struct s { const I m; CI n; const int k; };\n"
                  "void f(const int l, const I x, CI y, struct s t, const CS q, const I *pi, volatile I vi)\n"
                  "{\n"
                  "    printf(\"%s %s %s %s %s\\n\", g, gi, gc, l, x);\n"
                  "    printf(\"%s %s %s %s %d %d\\n\", y, t.m, t.n, t.k, q, pi);\n"
                  "    printf(\"%s %s\\n\", vi, *pi);\n"
                  "    const int a[2] = { 0 };\n"
                  "    printf(\"%d\\n\", a);\n"
                  "}\n")-1,
sizeof("#define AS1 __attribute__((address_space(1)))\n"
                  "#define ASN(n) __attribute__((address_space(n)))\n"
                  "#define INNER __attribute__((address_space(4)))\n"
                  "#define OUTER INNER\n"
                  "typedef AS1 int I1;\n"
                  "struct m { AS1 int *f; };\n"
                  "void f(const AS1 int *a, AS1 const volatile int *b, int *AS1 *c, I1 *d, ASN(3) int *e, OUTER int *g, struct m mm, AS1 int *const k, I1 *const *l)\n"
                  "{\n"
                  "    a();\n"
                  "    b();\n"
                  "    c();\n"
                  "    d();\n"
                  "    e();\n"
                  "    g();\n"
                  "    mm.f();\n"
                  "    k();\n"
                  "    l();\n"
                  "    a = e;\n"
                  "    int x = a;\n"
                  "}\n")-1,
sizeof("#define AS1 __attribute__((address_space(1)))\n"
                  "#define ASA __attribute__((address_space(1)))\n"
                  "#define AS2 __attribute__((address_space(2)))\n"
                  "typedef AS1 int T1;\n"
                  "void g(AS2 int *q);\n"
                  "AS1 int *ret(ASA int *x) { return x; }\n"
                  "void f(AS1 int *pa, ASA int *pb)\n"
                  "{\n"
                  "    AS1 int *a = 0;\n"
                  "    ASA int *b = 0;\n"
                  "    __attribute__((address_space(1))) int *c = 0;\n"
                  "    AS2 int *d = 0;\n"
                  "    T1 *t = 0;\n"
                  "    long *p;\n"
                  "    int *i = a;\n"
                  "    AS2 int *e = b;\n"
                  "    p = a;\n"
                  "    p = b;\n"
                  "    p = c;\n"
                  "    p = t;\n"
                  "    p = pa;\n"
                  "    p = pb;\n"
                  "    d = a;\n"
                  "    a = d;\n"
                  "    b = d;\n"
                  "    g(a);\n"
                  "    g(b);\n"
                  "    p = &*b;\n"
                  "    long *q = pb;\n"
                  "    int x = d - b;\n"
                  "    AS1 int **pp = 0;\n"
                  "    int **ip = pp;\n"
                  "}\n")-1,
sizeof("#define AS1 __attribute__((address_space(1)))\n"
                  "#define ASA __attribute__((address_space(1)))\n"
                  "void f(void)\n"
                  "{\n"
                  "    AS1 int *a = 0;\n"
                  "    ASA int *b = 0;\n"
                  "    __attribute__((address_space(1))) int *c = 0;\n"
                  "    long *p;\n"
                  "    p = a;\n"
                  "    p = b;\n"
                  "    p = c;\n"
                  "    p = &*a;\n"
                  "}\n")-1,
sizeof("#define AS1 __attribute__((address_space(1)))\n"
                  "#define ASA __attribute__((address_space(1)))\n"
                  "void h(ASA long *z);\n"
                  "void f(void)\n"
                  "{\n"
                  "    AS1 int *a = 0;\n"
                  "    ASA long *l = a;\n"
                  "    AS1 long *m = 0;\n"
                  "    m = a;\n"
                  "    l = a;\n"
                  "    h(a);\n"
                  "    int n = a;\n"
                  "    ASA char c = 0;\n"
                  "    char *pc = &c;\n"
                  "}\n")-1,
sizeof("#define MYGS __seg_gs\n"
                  "#define CAS const __attribute__((address_space(1)))\n"
                  "#define ASV __attribute__((address_space(2))) volatile\n"
                  "#define AS3 __attribute__((address_space(3)))\n"
                  "void f(__seg_gs int *a, MYGS int *b, CAS int *c, ASV int *d, AS3 int *e)\n"
                  "{\n"
                  "    a();\n"
                  "    b();\n"
                  "    c();\n"
                  "    d();\n"
                  "    e();\n"
                  "}\n")-1,
sizeof("int printf(const char *, ...);\n"
                  "#define AS1 __attribute__((address_space(1)))\n"
                  "#define AS2 __attribute__((address_space(2)))\n"
                  "void f(AS1 int *p, AS2 char *q, AS1 const int *r)\n"
                  "{\n"
                  "    printf(\"%d\\n\", p);\n"
                  "    printf(\"%f\\n\", q);\n"
                  "    printf(\"%d %d\\n\", r, p);\n"
                  "}\n")-1,
sizeof("#define AS1 __attribute__((address_space(1)))\n"
                  "#define AS2 __attribute__((address_space(2)))\n"
                  "void f(AS1 int *p, AS2 char *q)\n"
                  "{\n"
                  "    AS1 char *a = p;\n"
                  "    AS2 int *b = q;\n"
                  "    AS1 long *c = p;\n"
                  "    AS2 short *d = q;\n"
                  "    (void)a; (void)b; (void)c; (void)d;\n"
                  "}\n")-1,
sizeof("#define AS1 __attribute__((address_space(1)))\n"
                  "int AS1 *x;\n"
                  "void f(int __attribute__((address_space(1u))) *p, int __attribute__((address_space(1UL))) *r)\n"
                  "{\n"
                  "    int *q = p;\n"
                  "    int *s = r;\n"
                  "}\n")-1,
sizeof("#define AS1 __attribute__((address_space(1)))\n"
                  "int AS1 *x;\n"
                  "void f(int __attribute__((address_space(1+0))) *p)\n"
                  "{\n"
                  "    int *q = p;\n"
                  "}\n")-1,
sizeof("typedef const int CI;\n"
                  "typedef volatile int VI;\n"
                  "void f(void) { CI b[2][3] = { 0 }; b++; b[0]++; VI c[1][2][3]; c++; c[0]++; }\n")-1,
sizeof("int printf(const char *, ...);\n"
                  "typedef unsigned long ul;\n"
                  "typedef enum { A1, A2 } EA;\n"
                  "typedef enum { B1 } EB;\n"
                  "typedef double D;\n"
                  "struct s { ul n; EA ea; EB eb; D d; ul arr[2]; struct s *next; };\n"
                  "int f(struct s x, struct s *px, int i)\n"
                  "{\n"
                  "    int r = 0;\n"
                  "    r += x.n < i;\n"
                  "    r += px->next->arr[0] < i;\n"
                  "    r += x.ea == x.eb;\n"
                  "    r += x.ea + px->eb;\n"
                  "    r += (x.ea < px->eb);\n"
                  "    printf(\"%d %s %f\\n\", x.n, px->d, x.arr[1]);\n"
                  "    printf(\"%ld\\n\", x.d);\n"
                  "    return r + (i ? x.ea : x.eb);\n"
                  "}\n")-1,
sizeof("typedef int I;\n"
                  "typedef long L;\n"
                  "struct S { int x; };\n"
                  "typedef struct S TS;\n"
                  "void f(_Atomic(I) *ap, _Atomic(L) a2[2], _Atomic(TS) *sp, _Atomic I *kw)\n"
                  "{\n"
                  "    ap();\n"
                  "    char *d = ap;\n"
                  "    char *e = a2;\n"
                  "    char *g = sp;\n"
                  "    char *h = kw;\n"
                  "}\n")-1,
sizeof("typedef long L;\n"
                  "typedef int I;\n"
                  "int x, arr[4];\n"
                  "struct T { int f; } t;\n"
                  "typeof(x + 1) y;\n"
                  "typeof(L *) z;\n"
                  "typeof(x+1) *w;\n"
                  "typeof(arr[1]) v;\n"
                  "typeof(t.f) u;\n"
                  "typeof(-x) n;\n"
                  "typeof((x)) pq;\n"
                  "typeof(sizeof x) sz;\n"
                  "typeof(L const *) cz;\n"
                  "typeof(I *) iz[2];\n"
                  "typeof(x ? 1 : 2) cond;\n"
                  "void f(void)\n"
                  "{\n"
                  "    char *a = &y;\n"
                  "    char *b = z;\n"
                  "    char *c = w;\n"
                  "    char *d = &v;\n"
                  "    char *e = &u;\n"
                  "    char *g = &n;\n"
                  "    char *h = &pq;\n"
                  "    char *i = &sz;\n"
                  "    char *j = cz;\n"
                  "    char *k = iz;\n"
                  "    char *l = &cond;\n"
                  "}\n")-1,
sizeof("typedef long L;\n"
                  "int x;\n"
                  "const int cx = 0;\n"
                  "__typeof__(x * 2) a;\n"
                  "__typeof(x) b2;\n"
                  "typeof_unqual(cx + 1) c;\n"
                  "typeof_unqual(L *) d;\n"
                  "typeof(typeof(x + 1)) e;\n"
                  "int f(int);\n"
                  "typeof(f(x)) h;\n"
                  "typeof((L)x) i;\n"
                  "typeof(\"ab\") s;\n"
                  "void k(void)\n"
                  "{\n"
                  "    char *p1 = &a; char *p3 = &c; char *p4 = d; char *p5 = &e; char *p6 = &h; char *p7 = &i; int *p8 = &s;\n"
                  "}\n")-1,
sizeof("typedef long L;\n"
                  "struct S { typeof(long) m; L l; typeof(L *) p; } s;\n"
                  "int x;\n"
                  "typeof(x + 1) y;\n"
                  "typeof(L *) z;\n"
                  "void f(void)\n"
                  "{\n"
                  "    char *a = &s.m;\n"
                  "    char *b = &s.l;\n"
                  "    char *c = s.p;\n"
                  "    char *d = &y;\n"
                  "    char *e = z;\n"
                  "}\n")-1,
sizeof("typedef long L;\n"
                  "typedef L *LP;\n"
                  "typedef int I;\n"
                  "struct In { L deep; };\n"
                  "struct S { L l; LP lp; LP *lpp; struct In in; L arr[3]; typeof(I) ti; I *ip; const L cl; } s, *ps;\n"
                  "void take(char *);\n"
                  "void f(void)\n"
                  "{\n"
                  "    char *a = &ps->l;\n"
                  "    char *b = s.lp;\n"
                  "    char *c = *s.lpp;\n"
                  "    char *d = &s.in.deep;\n"
                  "    char *e = s.arr;\n"
                  "    char *g = &s.arr[1];\n"
                  "    char *h = &s.ti;\n"
                  "    char *k = &s.cl;\n"
                  "    take(&s.l);\n"
                  "    take(s.lp);\n"
                  "    char *m;\n"
                  "    m = s.ip;\n"
                  "    s.lp = m;\n"
                  "    s.ip = m;\n"
                  "    ps->lp = m;\n"
                  "    s.l = m;\n"
                  "    return;\n"
                  "}\n")-1,
sizeof("typedef long *LP;\n"
                  "typedef unsigned U;\n"
                  "struct S { LP lp; U u; } s, *ps;\n"
                  "int n;\n"
                  "void f(void)\n"
                  "{\n"
                  "    s.lp = 1-1;\n"
                  "    ps->lp = 1-1;\n"
                  "    (s).lp = 1-1;\n"
                  "    int r = s.u < n;\n"
                  "    static int z = sizeof(s.u < -1);\n"
                  "    LP local = 1-1;\n"
                  "}\n")-1,
sizeof("int printf(const char *, ...);\n"
                  "typedef long L;\n"
                  "typedef unsigned U;\n"
                  "typedef struct P { int x; } P;\n"
                  "typedef int A2[2];\n"
                  "void f(int n)\n"
                  "{\n"
                  "    char *a = &(L){ 1 };\n"
                  "    char *b = (A2){ 1, 2 };\n"
                  "    int c = (P){ 1 };\n"
                  "    char *d = &(const L){ 2 };\n"
                  "    printf(\"%s %s\\n\", (L){ 3 }, (A2){ 0 });\n"
                  "    if (n < (U){ 4 }) {}\n"
                  "    char *e = (L[]){ 1, 2, 3 };\n"
                  "    char *g = &(P){ 0 }.x;\n"
                  "}\n")-1,
sizeof("typedef int A2[2];\n"
                  "typedef const int CA[2];\n"
                  "void f(void)\n"
                  "{\n"
                  "    int x[3] = (A2){1,2};\n"
                  "    long y[2] = (A2){1,2};\n"
                  "    int z[2] = (CA){1,2};\n"
                  "}\n")-1,
sizeof("typedef struct N { int x; } N;\n"
                  "typedef N *NP;\n"
                  "typedef int *IP;\n"
                  "typedef void F(N *);\n"
                  "void a(const N *q);\n"
                  "void b(NP);\n"
                  "void h(int x, IP p, N *const r);\n"
                  "void e(N *q[]);\n"
                  "void f(int n, N *(*g)(void), NP const r);\n"
                  "void d(int, ...);\n"
                  "void (*fp)(N *);\n"
                  "F *gp;\n"
                  "struct S { void (*m)(N *); } s;\n"
                  "static int z = sizeof(a(1-1), 0);\n"
                  "int main(void)\n"
                  "{\n"
                  "    a(1-1); b(1-1); h(0, 1-1, 1-1); e(1-1); f(0, 1-1, 1-1); d(1, 1-1);\n"
                  "    (a)(1-1); fp(1-1); (*fp)(1-1); gp(1-1); s.m(1-1);\n"
                  "    void (*lp)(int, N *) = 0;\n"
                  "    lp(0, 1-1);\n"
                  "    return 0;\n"
                  "}\n")-1,
sizeof("enum E { A, B };\n"
                  "enum F { X, Y };\n"
                  "typedef enum E TE;\n"
                  "typedef long L;\n"
                  "typedef long *LP;\n"
                  "struct S { TE te; L l; LP lp; };\n"
                  "void take(TE e);\n"
                  "TE arr[2];\n"
                  "void f(enum F v, char *c)\n"
                  "{\n"
                  "    take(X);\n"
                  "    take(v);\n"
                  "    struct S s = { .te = X };\n"
                  "    struct S t = { v };\n"
                  "    s.te = v;\n"
                  "    arr[0] = v;\n"
                  "    TE local = v;\n"
                  "    TE ls[2] = { v, X };\n"
                  "    struct S w = { .lp = c };\n"
                  "    struct S z = { 0, c };\n"
                  "    L la[2] = { c };\n"
                  "    LP lpa[2] = { 0, c };\n"
                  "}\n"
                  "struct In { TE e; LP p; };\n"
                  "struct Out { int k; struct In in[2]; union { L ul; TE ue; } u; };\n"
                  "void g(enum F v, char *c, struct S *ps)\n"
                  "{\n"
                  "    struct Out o = { 0, { { X, 0 }, { .e = v } }, { .ue = v } };\n"
                  "    struct Out q = { 0, { { A, 0 }, { .p = c } } };\n"
                  "    void (*fp)(int, TE) = 0;\n"
                  "    fp(0, v);\n"
                  "    (*fp)(1, X);\n"
                  "}\n")-1,
sizeof("typedef int R __attribute__((warn_unused_result));\n"
                  "struct __attribute__((warn_unused_result)) S { int x; };\n"
                  "typedef R (*FP)(void);\n"
                  "struct T { R (*m)(void); struct S (*sm)(void); } t, *pt;\n"
                  "R (*arr[2])(void);\n"
                  "FP get(void);\n"
                  "void f(int n, R (**pp)(void), FP a, FP b, struct S (*sp)(void))\n"
                  "{\n"
                  "    t.m();\n"
                  "    pt->sm();\n"
                  "    arr[0]();\n"
                  "    get()();\n"
                  "    (n, a)();\n"
                  "    (n ? a : b)();\n"
                  "    (*pp)();\n"
                  "    sp();\n"
                  "    a();\n"
                  "}\n")-1,
sizeof("typedef int R __attribute__((warn_unused_result));\n"
                  "typedef int Q;\n"
                  "struct T { Q (*m)(void); R *(*rp)(void); } t;\n"
                  "Q (*arr[2])(void);\n"
                  "R *(*parr[2])(void);\n"
                  "Q (*get(void))(void);\n"
                  "void f(int n, Q (**pp)(void), R *(**rpp)(void))\n"
                  "{\n"
                  "    t.m(); t.rp(); arr[0](); parr[1](); get()(); (*pp)(); (*rpp)(); (n, arr[0])();\n"
                  "}\n")-1
};
static const CheckDriverDefaultWarningFixture fixture_40[] =
{
    {
        .name = "variable array bounds and anonymous tags in operand errors",
        .source = "struct { int a; } anon;\n"
                  "union { int b; } anon_u;\n"
                  "void f(int n, int m)\n"
                  "{\n"
                  "    int a[n];\n"
                  "    a++;\n"
                  "    int (*p)[n + 1] = 0;\n"
                  "    p();\n"
                  "    int b[n][m * 2];\n"
                  "    b++;\n"
                  "    char c[sizeof(int) * n];\n"
                  "    c++;\n"
                  "    int d[(n)];\n"
                  "    d();\n"
                  "    anon++;\n"
                  "    anon_u();\n"
                  "    struct { int x; } loc;\n"
                  "    loc();\n"
                  "    enum { E1 } e;\n"
                  "    e();\n"
                  "}\n",
        .errors = 9,
    },
    {
        .name = "variable array bounds of macros, calls, members and typedefs",
        .source = "#define N(x) ((x)*2)\n"
                  "int g(int);\n"
                  "struct S { int k; };\n"
                  "void f(int n, int m, struct S *s, int *ip)\n"
                  "{\n"
                  "    int a[N(n)]; a++;\n"
                  "    int c[g(n) + 1]; c++;\n"
                  "    int d[n ? m : 1]; d++;\n"
                  "    int e[-n + ~m]; e++;\n"
                  "    int h[s->k]; h++;\n"
                  "    int i[*ip]; i++;\n"
                  "    int j[n++]; j++;\n"
                  "    int k[sizeof n]; k++;\n"
                  "    int l[n][3]; l++;\n"
                  "    int o[3][n]; o++;\n"
                  "    typedef int T[n * m];\n"
                  "    T t; t++;\n"
                  "    int p[n << 1 | m]; p++;\n"
                  "    int q[ip[0]]; q++;\n"
                  "    int r[(int)sizeof(struct S) * n]; r++;\n"
                  "    int v[!n + 1]; v++;\n"
                  "}\n",
        .errors = 15,
    },
    {
        .name = "variable array bounds in conversions",
        .source = "void take(double *);\n"
                  "void f(int n)\n"
                  "{\n"
                  "    int a[n];\n"
                  "    int (*p)[n] = &a;\n"
                  "    double *d = p;\n"
                  "    take(&a);\n"
                  "    float x = a;\n"
                  "    int b[n + 1][2];\n"
                  "    struct T { int z; } t = b;\n"
                  "    a = 0;\n"
                  "}\n",
        .errors = 5,
        .notes = 1,
    },
    {
        // A cast's builtin type keywords print as clang's TypePrinter spells the type (check_semantic_builtin_spelling):
        // `(unsigned)n` is `(unsigned int)n`, `(long unsigned)n` `(unsigned long)n`, `(signed)1` `(int)1`.
        .name = "cast type names in variable array bounds",
        .source = "typedef long L;\n"
                  "int printf(const char *, ...);\n"
                  "int n;\n"
                  "void f(void)\n"
                  "{\n"
                  "    int a[(unsigned)n];\n"
                  "    int b[(long unsigned)n];\n"
                  "    int c[(const short)n + (signed)1];\n"
                  "    int d[(unsigned long long int)n];\n"
                  "    int e[(L)n * (char)2];\n"
                  "    int g[(int long)n];\n"
                  "    int h[(unsigned char)n];\n"
                  "    int i[(signed char)n + (short int)n];\n"
                  "    a(); b(); c(); d(); e(); g(); h(); i();\n"
                  "}\n",
        .errors = 8,
    },
};
static const size_t fixture_40_lengths[] = {
sizeof("struct { int a; } anon;\n"
                  "union { int b; } anon_u;\n"
                  "void f(int n, int m)\n"
                  "{\n"
                  "    int a[n];\n"
                  "    a++;\n"
                  "    int (*p)[n + 1] = 0;\n"
                  "    p();\n"
                  "    int b[n][m * 2];\n"
                  "    b++;\n"
                  "    char c[sizeof(int) * n];\n"
                  "    c++;\n"
                  "    int d[(n)];\n"
                  "    d();\n"
                  "    anon++;\n"
                  "    anon_u();\n"
                  "    struct { int x; } loc;\n"
                  "    loc();\n"
                  "    enum { E1 } e;\n"
                  "    e();\n"
                  "}\n")-1,
sizeof("#define N(x) ((x)*2)\n"
                  "int g(int);\n"
                  "struct S { int k; };\n"
                  "void f(int n, int m, struct S *s, int *ip)\n"
                  "{\n"
                  "    int a[N(n)]; a++;\n"
                  "    int c[g(n) + 1]; c++;\n"
                  "    int d[n ? m : 1]; d++;\n"
                  "    int e[-n + ~m]; e++;\n"
                  "    int h[s->k]; h++;\n"
                  "    int i[*ip]; i++;\n"
                  "    int j[n++]; j++;\n"
                  "    int k[sizeof n]; k++;\n"
                  "    int l[n][3]; l++;\n"
                  "    int o[3][n]; o++;\n"
                  "    typedef int T[n * m];\n"
                  "    T t; t++;\n"
                  "    int p[n << 1 | m]; p++;\n"
                  "    int q[ip[0]]; q++;\n"
                  "    int r[(int)sizeof(struct S) * n]; r++;\n"
                  "    int v[!n + 1]; v++;\n"
                  "}\n")-1,
sizeof("void take(double *);\n"
                  "void f(int n)\n"
                  "{\n"
                  "    int a[n];\n"
                  "    int (*p)[n] = &a;\n"
                  "    double *d = p;\n"
                  "    take(&a);\n"
                  "    float x = a;\n"
                  "    int b[n + 1][2];\n"
                  "    struct T { int z; } t = b;\n"
                  "    a = 0;\n"
                  "}\n")-1,
sizeof("typedef long L;\n"
                  "int printf(const char *, ...);\n"
                  "int n;\n"
                  "void f(void)\n"
                  "{\n"
                  "    int a[(unsigned)n];\n"
                  "    int b[(long unsigned)n];\n"
                  "    int c[(const short)n + (signed)1];\n"
                  "    int d[(unsigned long long int)n];\n"
                  "    int e[(L)n * (char)2];\n"
                  "    int g[(int long)n];\n"
                  "    int h[(unsigned char)n];\n"
                  "    int i[(signed char)n + (short int)n];\n"
                  "    a(); b(); c(); d(); e(); g(); h(); i();\n"
                  "}\n")-1
};
static const CheckDriverDefaultWarningFixture fixture_41[] =
{
    {
        .name = "calling convention macro names",
        .source = "#define MS __attribute__((ms_abi))\n"
                  "#define VC __attribute__((vectorcall))\n"
                  "#define PM __attribute__((preserve_most))\n"
                  "#define IO __attribute__((intel_ocl_bicc))\n"
                  "MS void a(void);\n"
                  "void b(void) MS;\n"
                  "void VC c(void);\n"
                  "PM void d(void);\n"
                  "IO void e(void);\n"
                  "typedef MS void T(void);\n"
                  "T *t;\n"
                  "void use(void)\n"
                  "{\n"
                  "    int x;\n"
                  "    x = a;\n"
                  "    x = b;\n"
                  "    x = c;\n"
                  "    x = d;\n"
                  "    x = e;\n"
                  "    x = t;\n"
                  "    x = &a;\n"
                  "}\n",
        .errors = 7,
    },
    {
        .name = "calling conventions as written and canonical",
        .source = "typedef void TI(void) __attribute__((intel_ocl_bicc));\n"
                  "typedef void TA(void) __attribute__((swiftasynccall));\n"
                  "void m(void) __attribute__((ms_abi));\n"
                  "void pm(void) __attribute__((preserve_most));\n"
                  "void pa(void) __attribute__((preserve_all));\n"
                  "void pn(void) __attribute__((preserve_none));\n"
                  "void io(void) __attribute__((intel_ocl_bicc));\n"
                  "void __regcall rc(void);\n"
                  "TI *ti;\n"
                  "TA *ta;\n"
                  "void use(void)\n"
                  "{\n"
                  "    int x;\n"
                  "    x = m;\n"
                  "    x = pm;\n"
                  "    x = pa;\n"
                  "    x = pn;\n"
                  "    x = io;\n"
                  "    x = rc;\n"
                  "    x = ti;\n"
                  "    x = ta;\n"
                  "}\n",
        .errors = 8,
    },
    {
        // A declaration's convention as its type sugar keeps it (c_check_type_sugar_input.c): clang's AttributedType where
        // the attribute is written, inside the ParenType of a pointer's group (`'__attribute__((preserve_most))  void
        // ((*))(void)'`), its macro's MacroQualifiedType, the attribute a macro in a group before `*` writes dropped with
        // its function's modified type (`void (MS *r)(void)`'s `'MS void (*)(void)'`), a pointer's own, and the ones
        // reached through `*` and `&`.
        .name = "declarator convention sugar",
        .source = "#define MS __attribute__((ms_abi))\n"
                  "void f(void) __attribute__((preserve_most));\n"
                  "void (*p)(void) __attribute__((preserve_most));\n"
                  "void (**pp)(void) __attribute__((preserve_all));\n"
                  "void (*a[2])(void) __attribute__((preserve_none));\n"
                  "typedef void F(void) __attribute__((preserve_most));\n"
                  "F *fp;\n"
                  "void (*q)(void) __attribute__((ms_abi));\n"
                  "void (MS *r)(void);\n"
                  "void (* MS s)(void);\n"
                  "void (MS **t)(void);\n"
                  "MS void (*u)(void);\n"
                  "void (*v)(void) MS;\n"
                  "void g(void) __attribute__((sysv_abi));\n"
                  "void (*w)(void) __attribute__((sysv_abi));\n"
                  "void h(void)\n"
                  "{\n"
                  "    int x1 = f, x2 = p, x3 = pp, x4 = a, x5 = fp, x6 = q, x7 = r, x8 = s;\n"
                  "    int x9 = t, x10 = u, x11 = v, x12 = &f, x13 = g, x14 = w, x15 = &g, x16 = *pp;\n"
                  "}\n",
        .warnings = 1,
        .errors = 16,
    },
    {
        // Every placement: a const pointer's group and its own `* const`, a pointer to pointer's inner `*`, arrays, a
        // function returning a pointer, a function-like macro, a group's sysv_abi, specifiers', C23 lists before the
        // specifiers (the whole type's) and after the declarator, a local's, and assignments' targets.
        .name = "convention sugar placements",
        .source = "#define MS __attribute__((ms_abi))\n"
                  "#define PM __attribute__((preserve_most))\n"
                  "#define AS2(x) __attribute__((x))\n"
                  "void (*const c1)(void) MS = 0;\n"
                  "void (* const MS c2)(void) = 0;\n"
                  "void (* MS *pq)(void);\n"
                  "void (*arr[3])(void) PM;\n"
                  "void (*(*fpf)(int))(void) MS;\n"
                  "void (AS2(ms_abi) *m2)(void);\n"
                  "void (__attribute__((sysv_abi)) *sg)(void);\n"
                  "__attribute__((vectorcall)) void (*vc)(void);\n"
                  "[[gnu::ms_abi]] void (*c23)(void);\n"
                  "void (*c23b)(void) [[gnu::ms_abi]];\n"
                  "void h(void)\n"
                  "{\n"
                  "    void (*local)(void) MS;\n"
                  "    int a = local, c = pq, d = *pq, e = arr, f = arr[1], g = &arr, i = fpf, k = m2, l = sg;\n"
                  "    int m = vc, n = c23, o = c23b, r = c1, s = c2;\n"
                  "    local = 1;\n"
                  "    pq = 2;\n"
                  "    *pq = 3;\n"
                  "}\n",
        .warnings = 1,
        .errors = 17,
    },
    {
        // Each convention's AttributedType spelling, explicit sysv_abi and cdecl too, which the canonical type doesn't
        // keep; and no_caller_saved_registers beside one, with which clang rebuilds the type without its sugar.
        .name = "convention attribute spellings",
        .source = "void a1(void) __attribute__((sysv_abi));\n"
                  "void a2(void) __attribute__((ms_abi));\n"
                  "void a3(void) __attribute__((vectorcall));\n"
                  "void a4(void) __attribute__((regcall));\n"
                  "void a5(void) __attribute__((preserve_all));\n"
                  "void a8(void) __attribute__((no_caller_saved_registers));\n"
                  "void a9(void) __attribute__((intel_ocl_bicc));\n"
                  "void a10(void) __attribute__((swiftcall));\n"
                  "void a11(void) __attribute__((swiftasynccall));\n"
                  "void __regcall a12(void);\n"
                  "void __vectorcall a13(void);\n"
                  "void a15(void) __attribute__((__ms_abi__));\n"
                  "void a16(void) __attribute__((ms_abi, no_caller_saved_registers));\n"
                  "void a17(void) __attribute__((cdecl));\n"
                  "void (*b9)(void) __attribute__((intel_ocl_bicc));\n"
                  "void (__regcall *b12)(void);\n"
                  "void (* __attribute__((vectorcall)) b3)(void);\n"
                  "void h(void)\n"
                  "{\n"
                  "    int x1 = a1, x2 = a2, x3 = a3, x4 = a4, x5 = a5, x8 = a8, x9 = a9, x10 = a10, x11 = a11;\n"
                  "    int x12 = a12, x13 = a13, x15 = a15, x16 = a16, x17 = a17, y9 = b9, y12 = b12, y3 = b3;\n"
                  "}\n",
        .errors = 17,
    },
};
static const size_t fixture_41_lengths[] = {
sizeof("#define MS __attribute__((ms_abi))\n"
                  "#define VC __attribute__((vectorcall))\n"
                  "#define PM __attribute__((preserve_most))\n"
                  "#define IO __attribute__((intel_ocl_bicc))\n"
                  "MS void a(void);\n"
                  "void b(void) MS;\n"
                  "void VC c(void);\n"
                  "PM void d(void);\n"
                  "IO void e(void);\n"
                  "typedef MS void T(void);\n"
                  "T *t;\n"
                  "void use(void)\n"
                  "{\n"
                  "    int x;\n"
                  "    x = a;\n"
                  "    x = b;\n"
                  "    x = c;\n"
                  "    x = d;\n"
                  "    x = e;\n"
                  "    x = t;\n"
                  "    x = &a;\n"
                  "}\n")-1,
sizeof("typedef void TI(void) __attribute__((intel_ocl_bicc));\n"
                  "typedef void TA(void) __attribute__((swiftasynccall));\n"
                  "void m(void) __attribute__((ms_abi));\n"
                  "void pm(void) __attribute__((preserve_most));\n"
                  "void pa(void) __attribute__((preserve_all));\n"
                  "void pn(void) __attribute__((preserve_none));\n"
                  "void io(void) __attribute__((intel_ocl_bicc));\n"
                  "void __regcall rc(void);\n"
                  "TI *ti;\n"
                  "TA *ta;\n"
                  "void use(void)\n"
                  "{\n"
                  "    int x;\n"
                  "    x = m;\n"
                  "    x = pm;\n"
                  "    x = pa;\n"
                  "    x = pn;\n"
                  "    x = io;\n"
                  "    x = rc;\n"
                  "    x = ti;\n"
                  "    x = ta;\n"
                  "}\n")-1,
sizeof("#define MS __attribute__((ms_abi))\n"
                  "void f(void) __attribute__((preserve_most));\n"
                  "void (*p)(void) __attribute__((preserve_most));\n"
                  "void (**pp)(void) __attribute__((preserve_all));\n"
                  "void (*a[2])(void) __attribute__((preserve_none));\n"
                  "typedef void F(void) __attribute__((preserve_most));\n"
                  "F *fp;\n"
                  "void (*q)(void) __attribute__((ms_abi));\n"
                  "void (MS *r)(void);\n"
                  "void (* MS s)(void);\n"
                  "void (MS **t)(void);\n"
                  "MS void (*u)(void);\n"
                  "void (*v)(void) MS;\n"
                  "void g(void) __attribute__((sysv_abi));\n"
                  "void (*w)(void) __attribute__((sysv_abi));\n"
                  "void h(void)\n"
                  "{\n"
                  "    int x1 = f, x2 = p, x3 = pp, x4 = a, x5 = fp, x6 = q, x7 = r, x8 = s;\n"
                  "    int x9 = t, x10 = u, x11 = v, x12 = &f, x13 = g, x14 = w, x15 = &g, x16 = *pp;\n"
                  "}\n")-1,
sizeof("#define MS __attribute__((ms_abi))\n"
                  "#define PM __attribute__((preserve_most))\n"
                  "#define AS2(x) __attribute__((x))\n"
                  "void (*const c1)(void) MS = 0;\n"
                  "void (* const MS c2)(void) = 0;\n"
                  "void (* MS *pq)(void);\n"
                  "void (*arr[3])(void) PM;\n"
                  "void (*(*fpf)(int))(void) MS;\n"
                  "void (AS2(ms_abi) *m2)(void);\n"
                  "void (__attribute__((sysv_abi)) *sg)(void);\n"
                  "__attribute__((vectorcall)) void (*vc)(void);\n"
                  "[[gnu::ms_abi]] void (*c23)(void);\n"
                  "void (*c23b)(void) [[gnu::ms_abi]];\n"
                  "void h(void)\n"
                  "{\n"
                  "    void (*local)(void) MS;\n"
                  "    int a = local, c = pq, d = *pq, e = arr, f = arr[1], g = &arr, i = fpf, k = m2, l = sg;\n"
                  "    int m = vc, n = c23, o = c23b, r = c1, s = c2;\n"
                  "    local = 1;\n"
                  "    pq = 2;\n"
                  "    *pq = 3;\n"
                  "}\n")-1,
sizeof("void a1(void) __attribute__((sysv_abi));\n"
                  "void a2(void) __attribute__((ms_abi));\n"
                  "void a3(void) __attribute__((vectorcall));\n"
                  "void a4(void) __attribute__((regcall));\n"
                  "void a5(void) __attribute__((preserve_all));\n"
                  "void a8(void) __attribute__((no_caller_saved_registers));\n"
                  "void a9(void) __attribute__((intel_ocl_bicc));\n"
                  "void a10(void) __attribute__((swiftcall));\n"
                  "void a11(void) __attribute__((swiftasynccall));\n"
                  "void __regcall a12(void);\n"
                  "void __vectorcall a13(void);\n"
                  "void a15(void) __attribute__((__ms_abi__));\n"
                  "void a16(void) __attribute__((ms_abi, no_caller_saved_registers));\n"
                  "void a17(void) __attribute__((cdecl));\n"
                  "void (*b9)(void) __attribute__((intel_ocl_bicc));\n"
                  "void (__regcall *b12)(void);\n"
                  "void (* __attribute__((vectorcall)) b3)(void);\n"
                  "void h(void)\n"
                  "{\n"
                  "    int x1 = a1, x2 = a2, x3 = a3, x4 = a4, x5 = a5, x8 = a8, x9 = a9, x10 = a10, x11 = a11;\n"
                  "    int x12 = a12, x13 = a13, x15 = a15, x16 = a16, x17 = a17, y9 = b9, y12 = b12, y3 = b3;\n"
                  "}\n")-1
};
static const CheckDriverDefaultWarningFixture fixture_42[] =
{
    {
        // Members const themselves through `.` and `->`, nested chains with a note per level, a const return value, a
        // record with a const member or a nested one, a const pointer member, compound assignments and increments.
        .name = "const members, variables and return values",
        .source = "typedef int I;\n"
                  "struct s { const int a; int b; };\n"
                  "struct in { const int a; int z; };\n"
                  "struct ct { const struct in in; int q; };\n"
                  "struct w { struct ct ct; struct in in2; int k; };\n"
                  "struct p { const int *cp; int *const pc; struct s *ps; };\n"
                  "const struct s *f(void);\n"
                  "const int g(void);\n"
                  "struct t { struct s s; int k; };\n"
                  "void use(void)\n"
                  "{\n"
                  "    struct s x = { 1, 2 }, y = { 3, 4 };\n"
                  "    x.a = 2;\n"
                  "    x.b = 2;\n"
                  "    const struct ct ct = { { 1, 2 }, 3 };\n"
                  "    ct.in.a = 1;\n"
                  "    struct ct m = { { 1, 2 }, 3 };\n"
                  "    m.in.a = 1;\n"
                  "    m.in.z = 1;\n"
                  "    f()->b = 3;\n"
                  "    x = y;\n"
                  "    struct w ww = { 0 }, w2 = { 0 };\n"
                  "    ww = w2;\n"
                  "    ww.ct = w2.ct;\n"
                  "    struct p pp = { 0 };\n"
                  "    *pp.cp = 1;\n"
                  "    pp.pc = 0;\n"
                  "    pp.ps->a = 1;\n"
                  "    x.a++;\n"
                  "    --m.in.a;\n"
                  "    x.a += 1;\n"
                  "    struct t tt = { 0 };\n"
                  "    tt.s = x;\n"
                  "    *f() = x;\n"
                  "    struct s *px = &x;\n"
                  "    *px = y;\n"
                  "    px->a = 4;\n"
                  "    const I ci = 0;\n"
                  "    ci = 1;\n"
                  "}\n",
        .errors = 19,
        .notes = 23,
    },
    {
        // Subscripts of a const pointer, anonymous members, unions, arrays of const and of records.
        .name = "const assignment through subscripts, unions and arrays",
        .source = "typedef const int CI;\n"
                  "typedef int I;\n"
                  "typedef const struct s0 { int v; } CS;\n"
                  "struct an { struct { const int x; int y; }; int z; };\n"
                  "union un { const int a; float f; };\n"
                  "struct arr { const int ca[2]; struct an inner[2]; };\n"
                  "struct deep { struct an an; union un un; CI ci; const I cti; };\n"
                  "static const int *const g(void);\n"
                  "extern __attribute__((unused)) CS *h(void);\n"
                  "typedef float v4f __attribute__((ext_vector_type(4)));\n"
                  "struct vec { const v4f v; };\n"
                  "void use(const int *const p, int i)\n"
                  "{\n"
                  "    p[0] = 1;\n"
                  "    i[p] = 2;\n"
                  "    struct an a = { 0 }, b = { 0 };\n"
                  "    a.x = 1;\n"
                  "    a = b;\n"
                  "    union un u = { 0 }, w = { 0 };\n"
                  "    u = w;\n"
                  "    u.f = 2;\n"
                  "    struct arr r = { 0 }, s = { 0 };\n"
                  "    r.ca[1] = 3;\n"
                  "    r = s;\n"
                  "    r.inner[0].x = 4;\n"
                  "    r.inner[1] = a;\n"
                  "}\n",
        .errors = 9,
        .notes = 9,
    },
    {
        // Typedef'd const members, attributes and storage classes before a const return type, vector elements,
        // parenthesized lvalues and dereferences.
        .name = "const assignment through returns, vectors and parentheses",
        .source = "typedef const int CI;\n"
                  "typedef int I;\n"
                  "typedef const struct s0 { int v; } CS;\n"
                  "struct an { struct { const int x; int y; }; int z; };\n"
                  "union un { const int a; float f; };\n"
                  "struct arr { const int ca[2]; struct an inner[2]; };\n"
                  "struct deep { struct an an; union un un; CI ci; const I cti; };\n"
                  "static const int *const g(void);\n"
                  "extern __attribute__((unused)) CS *h(void);\n"
                  "typedef float v4f __attribute__((ext_vector_type(4)));\n"
                  "struct vec { const v4f v; };\n"
                  "void use(void)\n"
                  "{\n"
                  "    struct an a = { 0 }, b = { 0 };\n"
                  "    struct deep d = { 0 }, e = { 0 };\n"
                  "    d = e;\n"
                  "    d.ci = 1;\n"
                  "    d.cti = 2;\n"
                  "    *g() = 1;\n"
                  "    h()->v = 5;\n"
                  "    struct vec vv = { 0 };\n"
                  "    vv.v.x = 1;\n"
                  "    vv.v[0] = 2;\n"
                  "    a.y += 1;\n"
                  "    (a).x = 1;\n"
                  "    (a) = b;\n"
                  "    (&a)->x = 2;\n"
                  "    *(&a) = b;\n"
                  "}\n",
        .errors = 11,
        .notes = 13,
    },
    {
        // A call's return value is a function's only through a direct callee (clang's getDirectCallee): a function's name
        // through `*`, `&` and parentheses; a function pointer variable's or parameter's call is the generic error.
        .name = "const return values of direct and indirect calls",
        .source = "struct s { int a; const int b; };\n"
                  "const struct s *f(void);\n"
                  "const struct s *(*hp)(void);\n"
                  "void use(const struct s *(*lp)(void))\n"
                  "{\n"
                  "    f()->a = 1;\n"
                  "    hp()->a = 2;\n"
                  "    lp()->a = 3;\n"
                  "    (*hp)()->a = 4;\n"
                  "    hp()->b = 5;\n"
                  "    (&f)()->a = 6;\n"
                  "    (*f)()->a = 7;\n"
                  "    (**f)()->a = 8;\n"
                  "    (&*f)()->a = 9;\n"
                  "    ((f))()->a = 10;\n"
                  "}\n",
        .errors = 10,
        .notes = 7,
    },
};
static const size_t fixture_42_lengths[] = {
sizeof("typedef int I;\n"
                  "struct s { const int a; int b; };\n"
                  "struct in { const int a; int z; };\n"
                  "struct ct { const struct in in; int q; };\n"
                  "struct w { struct ct ct; struct in in2; int k; };\n"
                  "struct p { const int *cp; int *const pc; struct s *ps; };\n"
                  "const struct s *f(void);\n"
                  "const int g(void);\n"
                  "struct t { struct s s; int k; };\n"
                  "void use(void)\n"
                  "{\n"
                  "    struct s x = { 1, 2 }, y = { 3, 4 };\n"
                  "    x.a = 2;\n"
                  "    x.b = 2;\n"
                  "    const struct ct ct = { { 1, 2 }, 3 };\n"
                  "    ct.in.a = 1;\n"
                  "    struct ct m = { { 1, 2 }, 3 };\n"
                  "    m.in.a = 1;\n"
                  "    m.in.z = 1;\n"
                  "    f()->b = 3;\n"
                  "    x = y;\n"
                  "    struct w ww = { 0 }, w2 = { 0 };\n"
                  "    ww = w2;\n"
                  "    ww.ct = w2.ct;\n"
                  "    struct p pp = { 0 };\n"
                  "    *pp.cp = 1;\n"
                  "    pp.pc = 0;\n"
                  "    pp.ps->a = 1;\n"
                  "    x.a++;\n"
                  "    --m.in.a;\n"
                  "    x.a += 1;\n"
                  "    struct t tt = { 0 };\n"
                  "    tt.s = x;\n"
                  "    *f() = x;\n"
                  "    struct s *px = &x;\n"
                  "    *px = y;\n"
                  "    px->a = 4;\n"
                  "    const I ci = 0;\n"
                  "    ci = 1;\n"
                  "}\n")-1,
sizeof("typedef const int CI;\n"
                  "typedef int I;\n"
                  "typedef const struct s0 { int v; } CS;\n"
                  "struct an { struct { const int x; int y; }; int z; };\n"
                  "union un { const int a; float f; };\n"
                  "struct arr { const int ca[2]; struct an inner[2]; };\n"
                  "struct deep { struct an an; union un un; CI ci; const I cti; };\n"
                  "static const int *const g(void);\n"
                  "extern __attribute__((unused)) CS *h(void);\n"
                  "typedef float v4f __attribute__((ext_vector_type(4)));\n"
                  "struct vec { const v4f v; };\n"
                  "void use(const int *const p, int i)\n"
                  "{\n"
                  "    p[0] = 1;\n"
                  "    i[p] = 2;\n"
                  "    struct an a = { 0 }, b = { 0 };\n"
                  "    a.x = 1;\n"
                  "    a = b;\n"
                  "    union un u = { 0 }, w = { 0 };\n"
                  "    u = w;\n"
                  "    u.f = 2;\n"
                  "    struct arr r = { 0 }, s = { 0 };\n"
                  "    r.ca[1] = 3;\n"
                  "    r = s;\n"
                  "    r.inner[0].x = 4;\n"
                  "    r.inner[1] = a;\n"
                  "}\n")-1,
sizeof("typedef const int CI;\n"
                  "typedef int I;\n"
                  "typedef const struct s0 { int v; } CS;\n"
                  "struct an { struct { const int x; int y; }; int z; };\n"
                  "union un { const int a; float f; };\n"
                  "struct arr { const int ca[2]; struct an inner[2]; };\n"
                  "struct deep { struct an an; union un un; CI ci; const I cti; };\n"
                  "static const int *const g(void);\n"
                  "extern __attribute__((unused)) CS *h(void);\n"
                  "typedef float v4f __attribute__((ext_vector_type(4)));\n"
                  "struct vec { const v4f v; };\n"
                  "void use(void)\n"
                  "{\n"
                  "    struct an a = { 0 }, b = { 0 };\n"
                  "    struct deep d = { 0 }, e = { 0 };\n"
                  "    d = e;\n"
                  "    d.ci = 1;\n"
                  "    d.cti = 2;\n"
                  "    *g() = 1;\n"
                  "    h()->v = 5;\n"
                  "    struct vec vv = { 0 };\n"
                  "    vv.v.x = 1;\n"
                  "    vv.v[0] = 2;\n"
                  "    a.y += 1;\n"
                  "    (a).x = 1;\n"
                  "    (a) = b;\n"
                  "    (&a)->x = 2;\n"
                  "    *(&a) = b;\n"
                  "}\n")-1,
sizeof("struct s { int a; const int b; };\n"
                  "const struct s *f(void);\n"
                  "const struct s *(*hp)(void);\n"
                  "void use(const struct s *(*lp)(void))\n"
                  "{\n"
                  "    f()->a = 1;\n"
                  "    hp()->a = 2;\n"
                  "    lp()->a = 3;\n"
                  "    (*hp)()->a = 4;\n"
                  "    hp()->b = 5;\n"
                  "    (&f)()->a = 6;\n"
                  "    (*f)()->a = 7;\n"
                  "    (**f)()->a = 8;\n"
                  "    (&*f)()->a = 9;\n"
                  "    ((f))()->a = 10;\n"
                  "}\n")-1
};
static const CheckDriverDefaultWarningFixture fixture_43[] =
{
    {
        .name = "library builtins' __size_t",
        .source = "typedef struct _IO_FILE FILE;\n"
                  "void f(const char *s, char *d, unsigned long n, int i)\n"
                  "{\n"
                  "    int *p = strlen(s);\n"
                  "    void *m = malloc(1);\n"
                  "    memcpy(d, s, 1);\n"
                  "    int *q = malloc;\n"
                  "    int *r = memcpy;\n"
                  "    int *t = strlen;\n"
                  "    int *u = &strlen;\n"
                  "    char *a = strlen(s) + 1;\n"
                  "    char *b = sizeof(int) * strlen(s);\n"
                  "    char *c = (strlen(s));\n"
                  "    char *e = sizeof(int) + 1;\n"
                  "}\n",
        .errors = 12,
        .notes = 3,
    },
    {
        .name = "__size_t through arithmetic",
        .source = "typedef struct _IO_FILE FILE;\n"
                  "void f(const char *s, char *d, unsigned long n, int i)\n"
                  "{\n"
                  "    char *e = sizeof(int) + 1;\n"
                  "    char *g = 1 + sizeof(int);\n"
                  "    char *h = n + sizeof(int);\n"
                  "    char *k = sizeof(int) + n;\n"
                  "    char *l = i ? sizeof(int) : 2;\n"
                  "    char *o = -sizeof(int);\n"
                  "    char *v = sizeof(int) << 2;\n"
                  "    char *w = strlen(s) - n;\n"
                  "    char *x = (unsigned long)strlen(s);\n"
                  "    char *y = i + strlen(s);\n"
                  "}\n",
        .errors = 11,
        .notes = 1,
    },
};
static const size_t fixture_43_lengths[] = {
sizeof("typedef struct _IO_FILE FILE;\n"
                  "void f(const char *s, char *d, unsigned long n, int i)\n"
                  "{\n"
                  "    int *p = strlen(s);\n"
                  "    void *m = malloc(1);\n"
                  "    memcpy(d, s, 1);\n"
                  "    int *q = malloc;\n"
                  "    int *r = memcpy;\n"
                  "    int *t = strlen;\n"
                  "    int *u = &strlen;\n"
                  "    char *a = strlen(s) + 1;\n"
                  "    char *b = sizeof(int) * strlen(s);\n"
                  "    char *c = (strlen(s));\n"
                  "    char *e = sizeof(int) + 1;\n"
                  "}\n")-1,
sizeof("typedef struct _IO_FILE FILE;\n"
                  "void f(const char *s, char *d, unsigned long n, int i)\n"
                  "{\n"
                  "    char *e = sizeof(int) + 1;\n"
                  "    char *g = 1 + sizeof(int);\n"
                  "    char *h = n + sizeof(int);\n"
                  "    char *k = sizeof(int) + n;\n"
                  "    char *l = i ? sizeof(int) : 2;\n"
                  "    char *o = -sizeof(int);\n"
                  "    char *v = sizeof(int) << 2;\n"
                  "    char *w = strlen(s) - n;\n"
                  "    char *x = (unsigned long)strlen(s);\n"
                  "    char *y = i + strlen(s);\n"
                  "}\n")-1
};
static const CheckDriverDefaultWarningFixture fixture_44[] =
{
    {
        // A failed assertion of a binary operator but `||` notes its sides' values at the operator (clang's
        // DiagnoseStaticAssertDetails), where a side isn't a literal: casts, sizeof, arithmetic, enumeration constants.
        .name = "comparisons' sides evaluated",
        .source = "_Static_assert(1 == 2, \"a\");\n"
                  "_Static_assert((unsigned)1 == 2, \"x\");\n"
                  "_Static_assert((long unsigned)sizeof(int) == 3, \"y\");\n"
                  "_Static_assert(sizeof(int) == 3, \"z\");\n"
                  "_Static_assert(1 + 1 == 3, \"w\");\n"
                  "_Static_assert((char)1 < 0, \"v\");\n"
                  "enum { K = 2 };\n"
                  "_Static_assert(K == 3, \"u\");\n"
                  "_Static_assert((int)K == 3, \"t\");\n",
        .errors = 8,
        .notes = 7,
    },
    {
        // An `&&`'s first failing conjunct is the requirement, at it (findFailedBooleanCondition); integer literals print
        // by value and suffix (StmtPrinter's `1U`, `9223372036854775807LL`); a negative side, a char, a bool.
        .name = "failing conjuncts and literal spellings",
        .source = "enum { K = 2, Z = 0 };\n"
                  "_Static_assert(K - 2, \"a\");\n"
                  "_Static_assert(K && Z, \"b\");\n"
                  "_Static_assert(Z || Z, \"c\");\n"
                  "_Static_assert(K == -3, \"d\");\n"
                  "_Static_assert(-K == 3, \"e\");\n"
                  "_Static_assert(1.5 == K, \"f\");\n"
                  "_Static_assert((_Bool)K == 0, \"g\");\n"
                  "_Static_assert((K) == (3), \"h\");\n"
                  "_Static_assert(K & 1, \"i\");\n"
                  "_Static_assert('a' == K, \"j\");\n"
                  "_Static_assert((signed char)-1 == K, \"k\");\n"
                  "_Static_assert(K == 3 && 1, \"l\");\n"
                  "_Static_assert(!K, \"m\");\n"
                  "_Static_assert(K < 1u, \"n\");\n"
                  "_Static_assert(0x7fffffffffffffffLL == K, \"o\");\n"
                  "_Static_assert((unsigned char)200 == K, \"p\");\n"
                  "_Static_assert((char)'\\n' == K, \"q\");\n",
        .errors = 17,
        .notes = 14,
    },
    {
        // A plain char's value as a character literal with its code unit and value (escapes, `<U+0000>`, `<0xFF>`), a
        // bool's `false`, an unsigned long long's and an __int128's values.
        .name = "character and integer values",
        .source = "enum { K = 2 };\n"
                  "_Static_assert((char)-1 == K, \"\");\n"
                  "_Static_assert((char)'a' == K, \"\");\n"
                  "_Static_assert((char)' ' == K, \"\");\n"
                  "_Static_assert((char)'\\'' == K, \"\");\n"
                  "_Static_assert((char)'\\\\' == K, \"\");\n"
                  "_Static_assert((char)127 == K, \"\");\n"
                  "_Static_assert((char)'\\t' == K, \"\");\n"
                  "_Static_assert((char)'\"' == K, \"\");\n"
                  "_Static_assert((char)0 == K, \"\");\n"
                  "_Static_assert((_Bool)0 == K, \"\");\n"
                  "_Static_assert((unsigned long long)-1 == K, \"\");\n"
                  "_Static_assert(K == (__int128)3, \"\");\n"
                  "_Static_assert((char)200 == K, \"\");\n",
        .errors = 13,
        .notes = 13,
    },
    {
        // The same with -funsigned-char: a char past 0x7F is positive.
        .name = "character values of unsigned char",
        .source = "enum { K = 2 };\n"
                  "_Static_assert((char)-1 == K, \"\");\n"
                  "_Static_assert((char)'a' == K, \"\");\n"
                  "_Static_assert((char)' ' == K, \"\");\n"
                  "_Static_assert((char)'\\'' == K, \"\");\n"
                  "_Static_assert((char)'\\\\' == K, \"\");\n"
                  "_Static_assert((char)127 == K, \"\");\n"
                  "_Static_assert((char)'\\t' == K, \"\");\n"
                  "_Static_assert((char)'\"' == K, \"\");\n"
                  "_Static_assert((char)0 == K, \"\");\n"
                  "_Static_assert((_Bool)0 == K, \"\");\n"
                  "_Static_assert((unsigned long long)-1 == K, \"\");\n"
                  "_Static_assert(K == (__int128)3, \"\");\n"
                  "_Static_assert((char)200 == K, \"\");\n",
        .options = { "-funsigned-char" },
        .errors = 13,
        .notes = 13,
    },
    {
        // Floating sides and literals as llvm's APFloat::toString spells them: `100`, `0.5`, `0.10000000000000001`,
        // `1.0E+10`; a literal's trailing `.` and its `F` (`2.`, `1.5F`).
        .name = "floating values and literals",
        .source = "enum{K=2};\n"
                  "_Static_assert(2.0 == K+1, \"\");\n"
                  "_Static_assert(0.5 == K, \"\");\n"
                  "_Static_assert(100.0 == K, \"\");\n"
                  "_Static_assert(1e10 == K, \"\");\n"
                  "_Static_assert(0.1 == K, \"\");\n"
                  "_Static_assert(1.0/3 == K, \"\");\n"
                  "_Static_assert(1.5f == K, \"\");\n"
                  "_Static_assert(1234567.0 == K, \"\");\n"
                  "_Static_assert(-0.25 == K, \"\");\n"
                  "_Static_assert(1e-5 == K, \"\");\n"
                  "_Static_assert(1000.0 == K, \"\");\n"
                  "_Static_assert(10000.0 == K, \"\");\n",
        .errors = 12,
        .notes = 12,
    },
    {
        // C23's static_assert without a message, `nullptr`, and no note for a boolean value compared with `true` or
        // `false` (isKnownToHaveBooleanValue); `(bool)` casts.
        .name = "C23 assertions and boolean literals",
        .source = "enum { K = 2 };\n"
                  "static_assert(K == 3);\n"
                  "static_assert(true == (K == 3));\n"
                  "static_assert((K == 3) == true);\n"
                  "static_assert((K == 2) && (K == 3) && 1, \"x\");\n"
                  "static_assert(((K == 2) && (1 && K > 5)), \"y\");\n"
                  "static_assert(nullptr != nullptr, \"z\");\n"
                  "static_assert(K + 0u == 3, \"w\");\n"
                  "static_assert((K == 2) && !K, \"v\");\n"
                  "static_assert(sizeof(long double) == 4);\n"
                  "static_assert(1 ? K == 3 : 0);\n",
        .errors = 10,
        .notes = 5,
        .c23 = true,
    },
    {
        // A boolean literal beside a value that isn't known to be boolean is noted.
        .name = "C23 boolean literal sides",
        .source = "enum { K = 2 };\n"
                  "static_assert(true == K);\n"
                  "static_assert(K == false + 3);\n"
                  "static_assert(false == (K + 1));\n"
                  "static_assert((_Bool)K == false);\n"
                  "static_assert(false != 0);\n",
        .errors = 5,
        .notes = 3,
        .c23 = true,
    },
    {
        // A static assertion among a structure's or a union's members (#2264), which declares none: checked as a block's,
        // a failing one's details too, and the members around it kept.
        .name = "static assertions among members",
        .source = "struct S { int a; _Static_assert(1, \"\"); int b; };\n"
                  "struct T { _Static_assert(sizeof(int) == 4, \"x\"); int c; union { _Static_assert(1, \"y\"); int d; }; };\n"
                  "union U { _Static_assert(1, \"u\"); int a; float b; };\n"
                  "struct V { int a; _Static_assert(sizeof(int) == 3, \"fails\"); char b : 2; };\n"
                  "struct X { int a; _Static_assert(1, \"\"); };\n"
                  "int z = sizeof(struct S) + sizeof(struct T) + sizeof(union U) + sizeof(struct V) + sizeof(struct X);\n"
                  "void f(struct S *s) { s->b = s->a; }\n",
        .errors = 1,
        .notes = 1,
    },
    {
        .name = "C23 static assertions among members",
        .source = "struct S { int a; static_assert(1); int b; static_assert(sizeof(int) == 4, \"m\"); };\n"
                  "struct W { static_assert(1); };\n"
                  "int z = sizeof(struct S);\n",
        .c23 = true,
    },
};
static const size_t fixture_44_lengths[] = {
sizeof("_Static_assert(1 == 2, \"a\");\n"
                  "_Static_assert((unsigned)1 == 2, \"x\");\n"
                  "_Static_assert((long unsigned)sizeof(int) == 3, \"y\");\n"
                  "_Static_assert(sizeof(int) == 3, \"z\");\n"
                  "_Static_assert(1 + 1 == 3, \"w\");\n"
                  "_Static_assert((char)1 < 0, \"v\");\n"
                  "enum { K = 2 };\n"
                  "_Static_assert(K == 3, \"u\");\n"
                  "_Static_assert((int)K == 3, \"t\");\n")-1,
sizeof("enum { K = 2, Z = 0 };\n"
                  "_Static_assert(K - 2, \"a\");\n"
                  "_Static_assert(K && Z, \"b\");\n"
                  "_Static_assert(Z || Z, \"c\");\n"
                  "_Static_assert(K == -3, \"d\");\n"
                  "_Static_assert(-K == 3, \"e\");\n"
                  "_Static_assert(1.5 == K, \"f\");\n"
                  "_Static_assert((_Bool)K == 0, \"g\");\n"
                  "_Static_assert((K) == (3), \"h\");\n"
                  "_Static_assert(K & 1, \"i\");\n"
                  "_Static_assert('a' == K, \"j\");\n"
                  "_Static_assert((signed char)-1 == K, \"k\");\n"
                  "_Static_assert(K == 3 && 1, \"l\");\n"
                  "_Static_assert(!K, \"m\");\n"
                  "_Static_assert(K < 1u, \"n\");\n"
                  "_Static_assert(0x7fffffffffffffffLL == K, \"o\");\n"
                  "_Static_assert((unsigned char)200 == K, \"p\");\n"
                  "_Static_assert((char)'\\n' == K, \"q\");\n")-1,
sizeof("enum { K = 2 };\n"
                  "_Static_assert((char)-1 == K, \"\");\n"
                  "_Static_assert((char)'a' == K, \"\");\n"
                  "_Static_assert((char)' ' == K, \"\");\n"
                  "_Static_assert((char)'\\'' == K, \"\");\n"
                  "_Static_assert((char)'\\\\' == K, \"\");\n"
                  "_Static_assert((char)127 == K, \"\");\n"
                  "_Static_assert((char)'\\t' == K, \"\");\n"
                  "_Static_assert((char)'\"' == K, \"\");\n"
                  "_Static_assert((char)0 == K, \"\");\n"
                  "_Static_assert((_Bool)0 == K, \"\");\n"
                  "_Static_assert((unsigned long long)-1 == K, \"\");\n"
                  "_Static_assert(K == (__int128)3, \"\");\n"
                  "_Static_assert((char)200 == K, \"\");\n")-1,
sizeof("enum { K = 2 };\n"
                  "_Static_assert((char)-1 == K, \"\");\n"
                  "_Static_assert((char)'a' == K, \"\");\n"
                  "_Static_assert((char)' ' == K, \"\");\n"
                  "_Static_assert((char)'\\'' == K, \"\");\n"
                  "_Static_assert((char)'\\\\' == K, \"\");\n"
                  "_Static_assert((char)127 == K, \"\");\n"
                  "_Static_assert((char)'\\t' == K, \"\");\n"
                  "_Static_assert((char)'\"' == K, \"\");\n"
                  "_Static_assert((char)0 == K, \"\");\n"
                  "_Static_assert((_Bool)0 == K, \"\");\n"
                  "_Static_assert((unsigned long long)-1 == K, \"\");\n"
                  "_Static_assert(K == (__int128)3, \"\");\n"
                  "_Static_assert((char)200 == K, \"\");\n")-1,
sizeof("enum{K=2};\n"
                  "_Static_assert(2.0 == K+1, \"\");\n"
                  "_Static_assert(0.5 == K, \"\");\n"
                  "_Static_assert(100.0 == K, \"\");\n"
                  "_Static_assert(1e10 == K, \"\");\n"
                  "_Static_assert(0.1 == K, \"\");\n"
                  "_Static_assert(1.0/3 == K, \"\");\n"
                  "_Static_assert(1.5f == K, \"\");\n"
                  "_Static_assert(1234567.0 == K, \"\");\n"
                  "_Static_assert(-0.25 == K, \"\");\n"
                  "_Static_assert(1e-5 == K, \"\");\n"
                  "_Static_assert(1000.0 == K, \"\");\n"
                  "_Static_assert(10000.0 == K, \"\");\n")-1,
sizeof("enum { K = 2 };\n"
                  "static_assert(K == 3);\n"
                  "static_assert(true == (K == 3));\n"
                  "static_assert((K == 3) == true);\n"
                  "static_assert((K == 2) && (K == 3) && 1, \"x\");\n"
                  "static_assert(((K == 2) && (1 && K > 5)), \"y\");\n"
                  "static_assert(nullptr != nullptr, \"z\");\n"
                  "static_assert(K + 0u == 3, \"w\");\n"
                  "static_assert((K == 2) && !K, \"v\");\n"
                  "static_assert(sizeof(long double) == 4);\n"
                  "static_assert(1 ? K == 3 : 0);\n")-1,
sizeof("enum { K = 2 };\n"
                  "static_assert(true == K);\n"
                  "static_assert(K == false + 3);\n"
                  "static_assert(false == (K + 1));\n"
                  "static_assert((_Bool)K == false);\n"
                  "static_assert(false != 0);\n")-1,
sizeof("struct S { int a; _Static_assert(1, \"\"); int b; };\n"
                  "struct T { _Static_assert(sizeof(int) == 4, \"x\"); int c; union { _Static_assert(1, \"y\"); int d; }; };\n"
                  "union U { _Static_assert(1, \"u\"); int a; float b; };\n"
                  "struct V { int a; _Static_assert(sizeof(int) == 3, \"fails\"); char b : 2; };\n"
                  "struct X { int a; _Static_assert(1, \"\"); };\n"
                  "int z = sizeof(struct S) + sizeof(struct T) + sizeof(union U) + sizeof(struct V) + sizeof(struct X);\n"
                  "void f(struct S *s) { s->b = s->a; }\n")-1,
sizeof("struct S { int a; static_assert(1); int b; static_assert(sizeof(int) == 4, \"m\"); };\n"
                  "struct W { static_assert(1); };\n"
                  "int z = sizeof(struct S);\n")-1
};
static const CheckDriverDefaultWarningFixture fixture_45[] =
{
    {
        .name = "parameters' typedefs",
        .source = "typedef int I;\n"
                  "typedef I J;\n"
                  "typedef void (*F)(I);\n"
                  "void f(I x);\n"
                  "void g(void (*cb)(I), J (*h)(I, J));\n"
                  "void use(void)\n"
                  "{\n"
                  "    int *p;\n"
                  "    void (*q)(I) = 0;\n"
                  "    F r = 0;\n"
                  "    p = q;\n"
                  "    p = r;\n"
                  "    p = f;\n"
                  "    p = &f;\n"
                  "    p = g;\n"
                  "    int (*s)(I*, J) = 0;\n"
                  "    p = s;\n"
                  "    I a[2];\n"
                  "    p = &a;\n"
                  "}\n",
        .errors = 7,
    },
    {
        .name = "parameters' typedefs by place",
        .source = "typedef int I;\n"
                  "typedef I J;\n"
                  "typedef const int CI;\n"
                  "typedef void (*F)(I);\n"
                  "typedef void G(I);\n"
                  "struct S { int x; };\n"
                  "typedef struct S T;\n"
                  "void take(void (*cb)(I));\n"
                  "void takef(F f);\n"
                  "void h(I a, ...);\n"
                  "void k(void);\n"
                  "int (*a)(I), (*b)(J *, T);\n"
                  "G *gp;\n"
                  "I (*ret)(I);\n"
                  "void (*arr[2])(I);\n"
                  "void (*pp)(CI *, I);\n"
                  "void (*kr)();\n"
                  "void use(int n, int *ip)\n"
                  "{\n"
                  "    void (*q)(I) = ip;\n"
                  "    int *p;\n"
                  "    p = h;\n"
                  "    p = a;\n"
                  "    p = b;\n"
                  "    p = gp;\n"
                  "    p = ret;\n"
                  "    p = arr;\n"
                  "    p = arr[0];\n"
                  "    p = *arr;\n"
                  "    p = pp;\n"
                  "    q = ip;\n"
                  "    take(ip);\n"
                  "    takef(ip);\n"
                  "    p = take;\n"
                  "    p = k;\n"
                  "    p = kr;\n"
                  "    void (*vla)(int (*)[2], I) = 0;\n"
                  "    p = vla;\n"
                  "    void (*na)(I, J (*)(T)) = 0;\n"
                  "    p = na;\n"
                  "    p = &na;\n"
                  "}\n",
        .errors = 19,
        .notes = 2,
    },
};
static const size_t fixture_45_lengths[] = {
sizeof("typedef int I;\n"
                  "typedef I J;\n"
                  "typedef void (*F)(I);\n"
                  "void f(I x);\n"
                  "void g(void (*cb)(I), J (*h)(I, J));\n"
                  "void use(void)\n"
                  "{\n"
                  "    int *p;\n"
                  "    void (*q)(I) = 0;\n"
                  "    F r = 0;\n"
                  "    p = q;\n"
                  "    p = r;\n"
                  "    p = f;\n"
                  "    p = &f;\n"
                  "    p = g;\n"
                  "    int (*s)(I*, J) = 0;\n"
                  "    p = s;\n"
                  "    I a[2];\n"
                  "    p = &a;\n"
                  "}\n")-1,
sizeof("typedef int I;\n"
                  "typedef I J;\n"
                  "typedef const int CI;\n"
                  "typedef void (*F)(I);\n"
                  "typedef void G(I);\n"
                  "struct S { int x; };\n"
                  "typedef struct S T;\n"
                  "void take(void (*cb)(I));\n"
                  "void takef(F f);\n"
                  "void h(I a, ...);\n"
                  "void k(void);\n"
                  "int (*a)(I), (*b)(J *, T);\n"
                  "G *gp;\n"
                  "I (*ret)(I);\n"
                  "void (*arr[2])(I);\n"
                  "void (*pp)(CI *, I);\n"
                  "void (*kr)();\n"
                  "void use(int n, int *ip)\n"
                  "{\n"
                  "    void (*q)(I) = ip;\n"
                  "    int *p;\n"
                  "    p = h;\n"
                  "    p = a;\n"
                  "    p = b;\n"
                  "    p = gp;\n"
                  "    p = ret;\n"
                  "    p = arr;\n"
                  "    p = arr[0];\n"
                  "    p = *arr;\n"
                  "    p = pp;\n"
                  "    q = ip;\n"
                  "    take(ip);\n"
                  "    takef(ip);\n"
                  "    p = take;\n"
                  "    p = k;\n"
                  "    p = kr;\n"
                  "    void (*vla)(int (*)[2], I) = 0;\n"
                  "    p = vla;\n"
                  "    void (*na)(I, J (*)(T)) = 0;\n"
                  "    p = na;\n"
                  "    p = &na;\n"
                  "}\n")-1
};
static const CheckDriverDefaultWarningFixture fixture_46[] =
{
    {
        .name = "counted_by family sugar",
        .source = "#define __counted_by(n) __attribute__((counted_by(n)))\n"
                  "struct B { int n; int *__counted_by(n) p; char *__attribute__((sized_by(n))) q; void *__attribute__((sized_by_or_null(n))) r; int *__attribute__((counted_by_or_null(n))) s; };\n"
                  "struct F { int n; int fam[] __counted_by(n); };\n"
                  "void f(struct B *b, struct F *g)\n"
                  "{\n"
                  "    long *l;\n"
                  "    l = b->p;\n"
                  "    l = b->q;\n"
                  "    l = b->r;\n"
                  "    l = b->s;\n"
                  "    l = g->fam;\n"
                  "    l = &b->p;\n"
                  "    double d = b->p;\n"
                  "    int *ok = b->p;\n"
                  "}\n",
        .errors = 6,
    },
    {
        .name = "counted_by sugar of targets and siblings",
        .source = "#define __counted_by(n) __attribute__((counted_by(n)))\n"
                  "struct B { int n; int *__counted_by(n) p; int *__counted_by(n) p2, *plain; };\n"
                  "struct F { int n; int fam[] __counted_by(n); };\n"
                  "void take(long *x);\n"
                  "void f(struct B *b, struct F *g, struct B v, long *l)\n"
                  "{\n"
                  "    b->p = l;\n"
                  "    v.p = l;\n"
                  "    take(b->p);\n"
                  "    take(g->fam);\n"
                  "    l = b->p2;\n"
                  "    l = b->plain;\n"
                  "    l = v.p;\n"
                  "    l = &g->fam;\n"
                  "    int *q = b->p;\n"
                  "}\n",
        .errors = 8,
        .notes = 2,
    },
    {
        // A member's specifiers' typedef past a GNU attribute list, whose arguments' names are no specifier (#2417: an
        // invalid counted_by's count printed as the member's typedef), and kept in the counted sugar (`'const T *
        // __counted_by(n)'`).
        .name = "counted_by sugar with typedefs",
        .source = "typedef int T;\n"
                  "struct B { int n; const int *__attribute__((counted_by(n + 1))) e; T __attribute__((aligned(8))) *t; __attribute__((aligned(8))) T *u; const T *__attribute__((counted_by(n))) v; };\n"
                  "void f(struct B *b, long *l)\n"
                  "{\n"
                  "    l = b->e;\n"
                  "    l = b->t;\n"
                  "    l = b->u;\n"
                  "    l = b->v;\n"
                  "}\n",
        .errors = 5,
    },
    {
        .name = "counted_by sugar of qualified typedefs",
        .source = "typedef const int CI;\n"
                  "typedef int *IP;\n"
                  "struct B { int n; CI *__attribute__((counted_by(n))) p; volatile CI *__attribute__((counted_by(n))) q; };\n"
                  "void f(struct B *b, long *l) { l = b->p; l = b->q; l = &b->p; }\n",
        .errors = 3,
    },
    {
        // The operands of every other error that prints their types (#1842's 3c, check_driver_operand_type): binary and
        // unary operators', a `.`'s base, an array's assignment and increment, sizeof's, a subtraction's, a conditional's
        // and a switch's; through parentheses, a comma's right operand, a conditional of the same member's arms, `*&`, an
        // increment, a struct's copy's member and a flexible array's decay.
        .name = "counted_by sugar of operands",
        .source = "struct B { int n; int *p __attribute__((counted_by(n))); char *q __attribute__((sized_by(n))); int fam[] __attribute__((counted_by(n))); };\n"
                  "void f(struct B *b, struct B v, int k)\n"
                  "{\n"
                  "    (b->p) + 1.0;\n"
                  "    b->fam + 1.0;\n"
                  "    (0, b->p) * 2;\n"
                  "    (k ? b->p : b->p) + 1.0;\n"
                  "    -b->p;\n"
                  "    ~b->p;\n"
                  "    b->fam.x;\n"
                  "    b->p.x;\n"
                  "    b->p++ + 1.0;\n"
                  "    *&b->p + 1.0;\n"
                  "    b->fam = 0;\n"
                  "    b->fam++;\n"
                  "    sizeof(b->fam);\n"
                  "    v.p * 2;\n"
                  "    b->p - (char *)0;\n"
                  "    b->p - b->q;\n"
                  "    k ? b->p : 1.5;\n"
                  "    switch (b->p) { }\n"
                  "}\n",
        .errors = 18,
        .warnings = 1,
    },
    {
        // A call's callee, a `.`'s base, `&`'s operand, one member on both sides (the second without its a.k.a.), a statement
        // expression's value, an initializer's member target, -Wformat's argument, -Wnon-literal-null-conversion's assigned
        // and initialized member, an ordered comparison's and a pointer type mismatch's operands (#1842's 3c); and the
        // pointer arithmetic on a use that is clang's "cannot use" error, which reports nothing else (#1842's 3d).
        .name = "counted_by sugar of callees, targets and warnings",
        .source = "int printf(const char *, ...);\n"
                  "struct B { int n; int *p __attribute__((counted_by(n))); char *q __attribute__((sized_by(n))); };\n"
                  "struct I { int n; struct Inc *r __attribute__((counted_by(n))); };\n"
                  "void g(struct B *b, struct B v, struct I *i, long *l)\n"
                  "{\n"
                  "    b->p();\n"
                  "    b->q / 2;\n"
                  "    &b->p + 1.0;\n"
                  "    b->p * b->p;\n"
                  "    v.p.x;\n"
                  "    b->p % 2;\n"
                  "    ({ b->p; }) + 1.0;\n"
                  "    l = ({ b->p; });\n"
                  "    i->r + 1;\n"
                  "    struct B x = { .p = 2.5 };\n"
                  "}\n"
                  "void h(struct B *b)\n"
                  "{\n"
                  "    b->p = 1 - 1;\n"
                  "    int r = b->p < 1;\n"
                  "    printf(\"%d %s\\n\", b->p, b->q);\n"
                  "    struct B y = { .p = 1 ? 0 : 0 };\n"
                  "    (void)(b->n ? b->p : (char *)0);\n"
                  "}\n",
        .errors = 10,
        .warnings = 5,
        .notes = 2,
    },
};
static const size_t fixture_46_lengths[] = {
sizeof("#define __counted_by(n) __attribute__((counted_by(n)))\n"
                  "struct B { int n; int *__counted_by(n) p; char *__attribute__((sized_by(n))) q; void *__attribute__((sized_by_or_null(n))) r; int *__attribute__((counted_by_or_null(n))) s; };\n"
                  "struct F { int n; int fam[] __counted_by(n); };\n"
                  "void f(struct B *b, struct F *g)\n"
                  "{\n"
                  "    long *l;\n"
                  "    l = b->p;\n"
                  "    l = b->q;\n"
                  "    l = b->r;\n"
                  "    l = b->s;\n"
                  "    l = g->fam;\n"
                  "    l = &b->p;\n"
                  "    double d = b->p;\n"
                  "    int *ok = b->p;\n"
                  "}\n")-1,
sizeof("#define __counted_by(n) __attribute__((counted_by(n)))\n"
                  "struct B { int n; int *__counted_by(n) p; int *__counted_by(n) p2, *plain; };\n"
                  "struct F { int n; int fam[] __counted_by(n); };\n"
                  "void take(long *x);\n"
                  "void f(struct B *b, struct F *g, struct B v, long *l)\n"
                  "{\n"
                  "    b->p = l;\n"
                  "    v.p = l;\n"
                  "    take(b->p);\n"
                  "    take(g->fam);\n"
                  "    l = b->p2;\n"
                  "    l = b->plain;\n"
                  "    l = v.p;\n"
                  "    l = &g->fam;\n"
                  "    int *q = b->p;\n"
                  "}\n")-1,
sizeof("typedef int T;\n"
                  "struct B { int n; const int *__attribute__((counted_by(n + 1))) e; T __attribute__((aligned(8))) *t; __attribute__((aligned(8))) T *u; const T *__attribute__((counted_by(n))) v; };\n"
                  "void f(struct B *b, long *l)\n"
                  "{\n"
                  "    l = b->e;\n"
                  "    l = b->t;\n"
                  "    l = b->u;\n"
                  "    l = b->v;\n"
                  "}\n")-1,
sizeof("typedef const int CI;\n"
                  "typedef int *IP;\n"
                  "struct B { int n; CI *__attribute__((counted_by(n))) p; volatile CI *__attribute__((counted_by(n))) q; };\n"
                  "void f(struct B *b, long *l) { l = b->p; l = b->q; l = &b->p; }\n")-1,
sizeof("struct B { int n; int *p __attribute__((counted_by(n))); char *q __attribute__((sized_by(n))); int fam[] __attribute__((counted_by(n))); };\n"
                  "void f(struct B *b, struct B v, int k)\n"
                  "{\n"
                  "    (b->p) + 1.0;\n"
                  "    b->fam + 1.0;\n"
                  "    (0, b->p) * 2;\n"
                  "    (k ? b->p : b->p) + 1.0;\n"
                  "    -b->p;\n"
                  "    ~b->p;\n"
                  "    b->fam.x;\n"
                  "    b->p.x;\n"
                  "    b->p++ + 1.0;\n"
                  "    *&b->p + 1.0;\n"
                  "    b->fam = 0;\n"
                  "    b->fam++;\n"
                  "    sizeof(b->fam);\n"
                  "    v.p * 2;\n"
                  "    b->p - (char *)0;\n"
                  "    b->p - b->q;\n"
                  "    k ? b->p : 1.5;\n"
                  "    switch (b->p) { }\n"
                  "}\n")-1,
sizeof("int printf(const char *, ...);\n"
                  "struct B { int n; int *p __attribute__((counted_by(n))); char *q __attribute__((sized_by(n))); };\n"
                  "struct I { int n; struct Inc *r __attribute__((counted_by(n))); };\n"
                  "void g(struct B *b, struct B v, struct I *i, long *l)\n"
                  "{\n"
                  "    b->p();\n"
                  "    b->q / 2;\n"
                  "    &b->p + 1.0;\n"
                  "    b->p * b->p;\n"
                  "    v.p.x;\n"
                  "    b->p % 2;\n"
                  "    ({ b->p; }) + 1.0;\n"
                  "    l = ({ b->p; });\n"
                  "    i->r + 1;\n"
                  "    struct B x = { .p = 2.5 };\n"
                  "}\n"
                  "void h(struct B *b)\n"
                  "{\n"
                  "    b->p = 1 - 1;\n"
                  "    int r = b->p < 1;\n"
                  "    printf(\"%d %s\\n\", b->p, b->q);\n"
                  "    struct B y = { .p = 1 ? 0 : 0 };\n"
                  "    (void)(b->n ? b->p : (char *)0);\n"
                  "}\n")-1
};
static const CheckDriverDefaultWarningFixture fixture_47[] =
{
    {
        .name = "counted_by pointee incomplete",
        .source = "#define __counted_by(n) __attribute__((counted_by(n)))\n"
                  "struct Inc;\n"
                  "struct B { int n; struct Inc *__counted_by(n) p; };\n"
                  "struct Inc *g(struct B *b, struct Inc *x)\n"
                  "{\n"
                  "    b->p = x;\n"
                  "    struct Inc *y = b->p;\n"
                  "    return b->p;\n"
                  "}\n"
                  "void h(struct B *b) { (void)b->p; void *v = b->p; struct Inc **pp = &b->p; }\n",
        .errors = 5,
        .notes = 10,
    },
    {
        .name = "counted_by pointee completed later",
        .source = "#define __counted_by(n) __attribute__((counted_by(n)))\n"
                  "struct Inc;\n"
                  "struct Late;\n"
                  "struct B { int n; struct Inc *__counted_by(n) p; struct Late *__counted_by(n) l; struct Inc *__attribute__((counted_by_or_null(n))) o; struct Inc *__attribute__((sized_by(n))) z; };\n"
                  "void early(struct B *b, struct B v)\n"
                  "{\n"
                  "    struct Late *a = b->l;\n"
                  "    struct Inc *c = v.p;\n"
                  "    struct Inc *d = b->o;\n"
                  "    struct Inc *e = b->z;\n"
                  "    if (b->p) { }\n"
                  "    b->o = 0;\n"
                  "    struct Inc **f = &v.p;\n"
                  "}\n"
                  "struct Late { int x; };\n"
                  "void late(struct B *b)\n"
                  "{\n"
                  "    struct Late *a = b->l;\n"
                  "    int k = b->l[0].x;\n"
                  "}\n",
        .errors = 5,
        .notes = 10,
    },
    {
        // Initializations (#1842's 3d, CheckInitCounted): "cannot initialize" at each value the member takes, a file scope
        // object's and a compound literal's too, and "cannot implicitly initialize" where a list of its record leaves it out:
        // at explicit braces' `}`, at the last value a brace elision took, and at the end of the designation that made a
        // designator's list, each when the braces that fill it in close (`o1`'s and `o2`'s are out of source order), once
        // a GNU range element; a typedef's anonymous record by the typedef's name; none for a sized_by member, an object
        // with no initializer, a copy, or a pointee completed before.
        .name = "counted_by initializations of an incomplete pointee",
        .source = "#define __counted_by(n) __attribute__((counted_by(n)))\n"
                  "struct Inc;\n"
                  "struct B { int n; struct Inc *__counted_by(n) p; };\n"
                  "struct O { struct B a; struct B b; };\n"
                  "typedef struct { int n; struct Inc *__attribute__((counted_by_or_null(n))) p; struct Inc *__attribute__((sized_by(n))) s; } T;\n"
                  "struct Inc *get(void);\n"
                  "void take(struct B);\n"
                  "struct B gb = { 0, 0 };\n"
                  "void f(void)\n"
                  "{\n"
                  "    struct B b = { 1, get() };\n"
                  "    struct B c = { .n = 2, .p = get() };\n"
                  "    struct B e = { 0 };\n"
                  "    struct B d[3] = { { 1 }, { 2, get() }, [2].n = 3 };\n"
                  "    struct O o1 = { { 1 }, .b.n = 2, .a.p = get() };\n"
                  "    struct O o2 = { .b.n = 2, .a = { 1 } };\n"
                  "    struct O o3 = { 1, get(), 2 };\n"
                  "    struct B r[3] = { [0 ... 2].n = 1 };\n"
                  "    T t = { 1 };\n"
                  "    take((struct B){ 1, get() });\n"
                  "    struct B none;\n"
                  "    struct B copy = b;\n"
                  "    (void)c; (void)e; (void)d; (void)o1; (void)o2; (void)o3; (void)r; (void)t; (void)none; (void)copy;\n"
                  "}\n"
                  "struct Inc { int x; };\n"
                  "void g(void) { struct B late = { 1 }; (void)late; }\n",
        .errors = 19,
        .notes = 38,
    },
};
static const size_t fixture_47_lengths[] = {
sizeof("#define __counted_by(n) __attribute__((counted_by(n)))\n"
                  "struct Inc;\n"
                  "struct B { int n; struct Inc *__counted_by(n) p; };\n"
                  "struct Inc *g(struct B *b, struct Inc *x)\n"
                  "{\n"
                  "    b->p = x;\n"
                  "    struct Inc *y = b->p;\n"
                  "    return b->p;\n"
                  "}\n"
                  "void h(struct B *b) { (void)b->p; void *v = b->p; struct Inc **pp = &b->p; }\n")-1,
sizeof("#define __counted_by(n) __attribute__((counted_by(n)))\n"
                  "struct Inc;\n"
                  "struct Late;\n"
                  "struct B { int n; struct Inc *__counted_by(n) p; struct Late *__counted_by(n) l; struct Inc *__attribute__((counted_by_or_null(n))) o; struct Inc *__attribute__((sized_by(n))) z; };\n"
                  "void early(struct B *b, struct B v)\n"
                  "{\n"
                  "    struct Late *a = b->l;\n"
                  "    struct Inc *c = v.p;\n"
                  "    struct Inc *d = b->o;\n"
                  "    struct Inc *e = b->z;\n"
                  "    if (b->p) { }\n"
                  "    b->o = 0;\n"
                  "    struct Inc **f = &v.p;\n"
                  "}\n"
                  "struct Late { int x; };\n"
                  "void late(struct B *b)\n"
                  "{\n"
                  "    struct Late *a = b->l;\n"
                  "    int k = b->l[0].x;\n"
                  "}\n")-1,
sizeof("#define __counted_by(n) __attribute__((counted_by(n)))\n"
                  "struct Inc;\n"
                  "struct B { int n; struct Inc *__counted_by(n) p; };\n"
                  "struct O { struct B a; struct B b; };\n"
                  "typedef struct { int n; struct Inc *__attribute__((counted_by_or_null(n))) p; struct Inc *__attribute__((sized_by(n))) s; } T;\n"
                  "struct Inc *get(void);\n"
                  "void take(struct B);\n"
                  "struct B gb = { 0, 0 };\n"
                  "void f(void)\n"
                  "{\n"
                  "    struct B b = { 1, get() };\n"
                  "    struct B c = { .n = 2, .p = get() };\n"
                  "    struct B e = { 0 };\n"
                  "    struct B d[3] = { { 1 }, { 2, get() }, [2].n = 3 };\n"
                  "    struct O o1 = { { 1 }, .b.n = 2, .a.p = get() };\n"
                  "    struct O o2 = { .b.n = 2, .a = { 1 } };\n"
                  "    struct O o3 = { 1, get(), 2 };\n"
                  "    struct B r[3] = { [0 ... 2].n = 1 };\n"
                  "    T t = { 1 };\n"
                  "    take((struct B){ 1, get() });\n"
                  "    struct B none;\n"
                  "    struct B copy = b;\n"
                  "    (void)c; (void)e; (void)d; (void)o1; (void)o2; (void)o3; (void)r; (void)t; (void)none; (void)copy;\n"
                  "}\n"
                  "struct Inc { int x; };\n"
                  "void g(void) { struct B late = { 1 }; (void)late; }\n")-1
};
static const CheckDriverDefaultWarningFixture fixture_48[] =
{
    {
        .name = "vector member diagnostics through dot and arrow",
        .source = "typedef float v4 __attribute__((ext_vector_type(4)));\n"
                  "typedef float g4 __attribute__((vector_size(16)));\n"
                  "float a(g4 *p) { return (*p).y; }\n"
                  "float b(v4 *p) { return (*p).q; }\n"
                  "void c(v4 *p) { (*p).xx = (*p).zw; }\n"
                  "float *d(v4 *p) { return &(*p).x; }\n"
                  "float e(g4 *p) { return p->y; }\n"
                  "float f(v4 *p) { return p->q; }\n"
                  "void g(v4 *p) { p->xx = p->zw; }\n"
                  "float *h(v4 *p) { return &p->x; }\n",
        .errors = 8,
    },
    {
        .name = "vector component characters and bounds",
        .source = "typedef float v4 __attribute__((ext_vector_type(4)));\n"
                  "typedef float v2 __attribute__((ext_vector_type(2)));\n"
                  "typedef _Bool b4 __attribute__((ext_vector_type(4)));\n"
                  "void f(v4 v, v4 *p, v2 small, b4 bits)\n{\n"
                  "    (void)v.xq;\n    (void)v.xr;\n    (void)v.s0g;\n    (void)v.s;\n"
                  "    (void)v.s04;\n    (void)small.z;\n    (void)bits.x;\n    (void)bits.lo;\n"
                  "    (void)p->xq;\n    (void)p->s0g;\n    (void)p->s4;\n"
                  "    (void)p->  xq;\n    (void)v.  xq;\n"
                  "    (void)v.f;\n    (void)v.fq;\n    (void)v.ABC;\n}\n",
        .errors = 16,
    },
    {
        .name = "vector duplicate lvalues and element addresses",
        .source = "typedef float v4 __attribute__((ext_vector_type(4)));\n"
                  "typedef float v2 __attribute__((ext_vector_type(2)));\n"
                  "void f(v4 v, const v4 c)\n{\n"
                  "    v.xx += v.zw;\n    c.xx = v.xy;\n    v.xx[0] = 1;\n"
                  "    (v + v).xx = v.xy;\n    (v + v).xx[0] = 1;\n"
                  "    (void)&v[1];\n    (void)&v.x;\n    (void)&v.xx;\n"
                  "    (void)&(v + v).x;\n    (void)&((v4){0}).x;\n"
                  "    v.xy = v.zw;\n    v.x += 1;\n}\n",
        .errors = 10,
    },
    {
        .name = "swizzle aliases exclude fields and typeof aliases",
        .source = "typedef float v4 __attribute__((ext_vector_type(4)));\n"
                  "typedef v4 Alias;\n"
                  "struct S { __typeof__(((v4){0}).xy) wrong; Alias member; };\n"
                  "typedef __typeof__(((v4){0}).xy) T;\n"
                  "void f(v4 v, struct S s) { (void)&v.xx; s.member++; }\n"
                  "typedef float v2 __attribute__((ext_vector_type(2)));\n"
                  "void g(v4 v) { (void)&v.xx; }\n",
        .errors = 3,
    },
    {
        .name = "swizzle result names an aligned vector typedef",
        .source = "typedef float v4 __attribute__((ext_vector_type(4)));\n"
                  "typedef float v2 __attribute__((ext_vector_type(2), aligned(32)));\n"
                  "void f(v4 v, const v4 c) { (void)&v.xx; (void)&c.xx; (void)v.xx.z; }\n",
        .errors = 3,
    },
    {
        .name = "valid vector members and ordinary records",
        .source = "typedef float v4 __attribute__((ext_vector_type(4)));\n"
                  "struct S { int q, xx; };\n"
                  "float f(v4 v, v4 *p, struct S *s)\n{\n"
                  "    v.xy = p->zw;\n    p->s01 += v.yx;\n    v.x++;\n"
                  "    s->xx = s->q;\n    int *q = &s->q;\n"
                  "    return v.x + p->y + v.lo[0] + v.hi[0] + v.even[0] + v.odd[0] + *q;\n}\n",
        // Swizzle lowering is an existing named refusal, independent of these semantic diagnostics.
        .syntax_only = true,
    },
};
static const size_t fixture_48_lengths[] = {
sizeof("typedef float v4 __attribute__((ext_vector_type(4)));\n"
                  "typedef float g4 __attribute__((vector_size(16)));\n"
                  "float a(g4 *p) { return (*p).y; }\n"
                  "float b(v4 *p) { return (*p).q; }\n"
                  "void c(v4 *p) { (*p).xx = (*p).zw; }\n"
                  "float *d(v4 *p) { return &(*p).x; }\n"
                  "float e(g4 *p) { return p->y; }\n"
                  "float f(v4 *p) { return p->q; }\n"
                  "void g(v4 *p) { p->xx = p->zw; }\n"
                  "float *h(v4 *p) { return &p->x; }\n")-1,
sizeof("typedef float v4 __attribute__((ext_vector_type(4)));\n"
                  "typedef float v2 __attribute__((ext_vector_type(2)));\n"
                  "typedef _Bool b4 __attribute__((ext_vector_type(4)));\n"
                  "void f(v4 v, v4 *p, v2 small, b4 bits)\n{\n"
                  "    (void)v.xq;\n    (void)v.xr;\n    (void)v.s0g;\n    (void)v.s;\n"
                  "    (void)v.s04;\n    (void)small.z;\n    (void)bits.x;\n    (void)bits.lo;\n"
                  "    (void)p->xq;\n    (void)p->s0g;\n    (void)p->s4;\n"
                  "    (void)p->  xq;\n    (void)v.  xq;\n"
                  "    (void)v.f;\n    (void)v.fq;\n    (void)v.ABC;\n}\n")-1,
sizeof("typedef float v4 __attribute__((ext_vector_type(4)));\n"
                  "typedef float v2 __attribute__((ext_vector_type(2)));\n"
                  "void f(v4 v, const v4 c)\n{\n"
                  "    v.xx += v.zw;\n    c.xx = v.xy;\n    v.xx[0] = 1;\n"
                  "    (v + v).xx = v.xy;\n    (v + v).xx[0] = 1;\n"
                  "    (void)&v[1];\n    (void)&v.x;\n    (void)&v.xx;\n"
                  "    (void)&(v + v).x;\n    (void)&((v4){0}).x;\n"
                  "    v.xy = v.zw;\n    v.x += 1;\n}\n")-1,
sizeof("typedef float v4 __attribute__((ext_vector_type(4)));\n"
                  "typedef v4 Alias;\n"
                  "struct S { __typeof__(((v4){0}).xy) wrong; Alias member; };\n"
                  "typedef __typeof__(((v4){0}).xy) T;\n"
                  "void f(v4 v, struct S s) { (void)&v.xx; s.member++; }\n"
                  "typedef float v2 __attribute__((ext_vector_type(2)));\n"
                  "void g(v4 v) { (void)&v.xx; }\n")-1,
sizeof("typedef float v4 __attribute__((ext_vector_type(4)));\n"
                  "typedef float v2 __attribute__((ext_vector_type(2), aligned(32)));\n"
                  "void f(v4 v, const v4 c) { (void)&v.xx; (void)&c.xx; (void)v.xx.z; }\n")-1,
sizeof("typedef float v4 __attribute__((ext_vector_type(4)));\n"
                  "struct S { int q, xx; };\n"
                  "float f(v4 v, v4 *p, struct S *s)\n{\n"
                  "    v.xy = p->zw;\n    p->s01 += v.yx;\n    v.x++;\n"
                  "    s->xx = s->q;\n    int *q = &s->q;\n"
                  "    return v.x + p->y + v.lo[0] + v.hi[0] + v.even[0] + v.odd[0] + *q;\n}\n")-1
};
static const char check_driver_unevaluated_operators_source[] =
    "int g(int); int pf(void) __attribute__((pure)); int cf(int) __attribute__((const));\n"
    "struct S { int m; } s, *ps;\n"
    "void f(int i, int *p, volatile int v, __builtin_va_list ap, _Atomic int *ai) {\n"
    "    (void)sizeof(i++); (void)sizeof(i = 1); (void)sizeof(g(i)); (void)sizeof(pf()); (void)sizeof(cf(i++));\n"
    "    (void)sizeof(v); (void)sizeof(--i); (void)sizeof(i += 2); (void)sizeof i++; (void)sizeof (i++);\n"
    "    (void)_Alignof(i++); (void)__alignof__(i <<= 1); (void)_Generic(i++, int: 1); (void)_Generic(i, int: 1);\n"
    "    (void)sizeof(int[i++]); int a[i]; (void)sizeof(a[i++]); int b[i][i]; (void)sizeof(b[i++]);\n"
    "    (void)sizeof(*p = 2); (void)sizeof(i += 2, 3); (void)sizeof(__builtin_constant_p(i++));\n"
    "    (void)sizeof(i ? i++ : 0); (void)sizeof(i && i++); (void)sizeof(g(i = 1)); (void)sizeof(ps->m++); (void)sizeof(s.m = 1);\n"
    "    (void)sizeof(p[i++]); (void)sizeof(_Generic(0, int: i++)); (void)sizeof(_Generic(i++, int: 1));\n"
    "    (void)sizeof(__builtin_choose_expr(1, i++, 0)); (void)sizeof(__builtin_choose_expr(0, i++, 0));\n"
    "    (void)sizeof((char){i++}); (void)sizeof(__extension__ (i++)); (void)sizeof(-i++); (void)sizeof((long)i++);\n"
    "    (void)sizeof(__real__ i++); (void)sizeof(sizeof(i++));\n"
    "    (void)sizeof(__c11_atomic_load(ai, 5)); (void)sizeof(__atomic_load_n(p, 5));\n"
    "    (void)sizeof(__sync_fetch_and_add(p, 1)); (void)sizeof(__atomic_thread_fence(5), 0);\n"
    "}\n";
static const char check_driver_unevaluated_statements_source[] =
    "int g(int);\n"
    "void f(int i) {\n"
    "    (void)sizeof(({ int x = 1; x; })); (void)sizeof(({ int x; x; })); (void)sizeof(({ g(i); 1; }));\n"
    "    (void)sizeof(({ __builtin_constant_p(i++); })); (void)sizeof(({ (void)__builtin_constant_p(i++); 1; }));\n"
    "    (void)sizeof(({ int y = i++; y; })); (void)sizeof(({ int y[i++]; 1; })); (void)sizeof(({ if (i) i = 2; 1; }));\n"
    "    (void)sizeof(({ sizeof(i++); })); (void)sizeof(({ return; 1; })); (void)sizeof(({ i++; }) + 1);\n"
    "    (void)sizeof(({ (void)({ i = 2; 1; }); 1; })); (void)_Alignof(({ i = 1; 1; }));\n"
    "    (void)sizeof(({ _Generic(0, int: 1, long: i++); })); (void)sizeof(({ _Generic(0, long: 1, int: i++); }));\n"
    "    (void)sizeof(({ struct { int m; } t = { i++ }; t.m; }));\n"
    "    (void)sizeof(({ if (__builtin_constant_p(i++)) {} 1; })); (void)sizeof(({ (__builtin_constant_p(i++)); 1; }));\n"
    "    typeof(i++) t1 = 0; (void)t1;\n"
    "}\n";
static const char check_driver_unevaluated_macros_source[] =
    "#define ID(x) x\n"
    "#define SZ(x) sizeof(x)\n"
    "#define INC(x) x++\n"
    "#define PLUS +\n"
    "int g(int);\n"
    "void f(int i, int *p) {\n"
    "    (void)sizeof(ID(i++)); (void)sizeof(INC(i)); (void)SZ(i++); (void)sizeof(ID((i++)));\n"
    "    (void)sizeof(i = ID(1)); (void)sizeof(ID(i) = 1); (void)sizeof(i ID(=) 1); (void)sizeof(ID(i)++); (void)sizeof(++ID(i));\n"
    "    (void)sizeof(ID(++)i); (void)sizeof(i ID(++)); (void)sizeof(ID(g)(i++)); (void)sizeof(g(ID(i)++));\n"
    "    (void)sizeof(i++ PLUS 1); (void)sizeof(1 PLUS i++); (void)sizeof(ID(1) + i++); (void)sizeof(i ? ID(1) : i++);\n"
    "    (void)sizeof(ID(i) ? 1 : i++); (void)sizeof((int)ID(i++)); (void)sizeof(ID((int))i++);\n"
    "    (void)_Generic(ID(i++), int: 1); (void)sizeof(({ ID(i++); 1; }));\n"
    "}\n";
static const char check_driver_unevaluated_constant_source[] =
    "int x;\n"
                  "int arr[sizeof(x++)];\n"
                  "enum { E = sizeof(x = 1) };\n"
                  "_Static_assert(sizeof(x++) == 4, \"s\");\n"
                  "int y = sizeof(x--);\n"
                  "struct S { int a[sizeof(++x)]; };\n"
                  "int f(void) { int v[sizeof(x++)]; return sizeof v + _Alignof(int) + (int)sizeof(typeof(x++)); }\n"
                  "int g = _Generic(x++, int: 1);\n"
                  "char c[_Generic(x = 2, int: 3)];\n";
static const char check_driver_unevaluated_constant_forms_source[] =
    "int x; int arr2[4];\n"
                  "typedef int T;\n"
                  "struct S { int a; int b[2]; };\n"
                  "int f(void);\n"
                  "#define INC(v) v++\n"
                  "int a1[sizeof(int)];\n"
                  "int a2[sizeof(T)];\n"
                  "int a3[sizeof((struct S){ .a = 1, .b[1] = 2 })];\n"
                  "int a4[sizeof x++];\n"
                  "int a5[__alignof__(x = 3)];\n"
                  "int a6[sizeof(sizeof(x++))];\n"
                  "int a7[sizeof((int)(x = 1))];\n"
                  "int a8[sizeof(x, x++)];\n"
                  "int a9[sizeof(f())];\n"
                  "int a10[sizeof(INC(x))];\n"
                  "int a11[sizeof(arr2[x++])];\n"
                  "struct B { int w : sizeof(x++); };\n"
                  "enum { E1 = _Generic(x++, int: 1), E2 = sizeof(x += 2) };\n"
                  "int a12[sizeof(x ? x-- : 0)];\n"
                  "int a13[sizeof(T[2])];\n"
                  "void g(void) { switch (x) { case sizeof(x++): break; } _Alignas(sizeof(x++)) int z; (void)z; }\n";
static const CheckDriverDefaultWarningFixture fixture_49[] =
{
    {
        .name = "side effects in the constant reader's unevaluated operands",
        .source = check_driver_unevaluated_constant_source,
        .warnings = 8,
    },
    {
        .name = "side effects in the constant reader's unevaluated operands: forms",
        .source = check_driver_unevaluated_constant_forms_source,
        .warnings = 12,
    },
    {
        .name = "side effects in unevaluated operands",
        .source = check_driver_unevaluated_operators_source,
        .warnings = 32,
    },
    {
        .name = "side effects in unevaluated operands in C23",
        .source = check_driver_unevaluated_operators_source,
        .warnings = 32,
        .c23 = true,
    },
    {
        .name = "side effects in unevaluated operands under -Wall -Wextra",
        .source = check_driver_unevaluated_operators_source,
        .options = { "-Wall", "-Wextra" },
        .warnings = 33,
    },
    {
        .name = "-Wno-unevaluated-expression",
        .source = check_driver_unevaluated_operators_source,
        .options = { "-Wno-unevaluated-expression" },
        .warnings = 1,
    },
    {
        .name = "-Wno-unused-value holds -Wunevaluated-expression",
        .source = check_driver_unevaluated_operators_source,
        .options = { "-Wno-unused-value" },
        .warnings = 1,
    },
    {
        .name = "side effects in statement expressions in unevaluated operands",
        .source = check_driver_unevaluated_statements_source,
        .warnings = 12,
    },
    {
        .name = "side effects in statement expressions under -Wall",
        .source = check_driver_unevaluated_statements_source,
        .options = { "-Wall" },
        .warnings = 13,
    },
    {
        .name = "side effects in statement expressions under -Wall -Wextra in C23",
        .source = check_driver_unevaluated_statements_source,
        .options = { "-Wall", "-Wextra" },
        .warnings = 13,
        .c23 = true,
    },
    {
        .name = "side effects macros write",
        .source = check_driver_unevaluated_macros_source,
        .warnings = 7,
    },
    {
        .name = "side effects macros write under -Wall -Wextra",
        .source = check_driver_unevaluated_macros_source,
        .options = { "-Wall", "-Wextra" },
        .warnings = 8,
    },
    {
        .name = "-Werror=unevaluated-expression",
        .source = check_driver_unevaluated_macros_source,
        .options = { "-Werror=unevaluated-expression" },
        .errors = 7,
    },
};
static const size_t fixture_49_lengths[] = {
sizeof(check_driver_unevaluated_constant_source)-1,
sizeof(check_driver_unevaluated_constant_forms_source)-1,
sizeof(check_driver_unevaluated_operators_source)-1,
sizeof(check_driver_unevaluated_operators_source)-1,
sizeof(check_driver_unevaluated_operators_source)-1,
sizeof(check_driver_unevaluated_operators_source)-1,
sizeof(check_driver_unevaluated_operators_source)-1,
sizeof(check_driver_unevaluated_statements_source)-1,
sizeof(check_driver_unevaluated_statements_source)-1,
sizeof(check_driver_unevaluated_statements_source)-1,
sizeof(check_driver_unevaluated_macros_source)-1,
sizeof(check_driver_unevaluated_macros_source)-1,
sizeof(check_driver_unevaluated_macros_source)-1
};
static const char check_driver_unsequenced_operators_source[] =
    "int g(int, int);\n"
    "struct S { int m; } s;\n"
    "void f(int c, int x, int y, int *p, int a[], struct S *ps) {\n"
    "    x = x++; x = ++x; x++ + x; x + (x = 1); g(x++, x); g(x++, x++); x = g(x++, 0);\n"
    "    (x++, x++); x++ && x++; y = (x, x++) + x; a[x] = x++; p[x++] = x; x += x++;\n"
    "    c ? x++ : x++; s.m = s.m++; ps->m = ps->m++; *p = (*p)++; (y = 1) + (y = 2);\n"
    "    x = (2, x++); x = 1 && x++; x = 0 && x++; x = 1 ? x++ : 0; x = 0 ? x++ : 0;\n"
    "    y = c ?: x++ + x; y = (c ? x : y) + x++; x = (x += 1) + x;\n"
    "}\n"
    "void h(int c, int x, int y, int z) {\n"
    "    int b[2] = { x++, x++ }; int d[2] = { x, x++ }; int e[3] = { [0 ... 2] = x++ };\n"
    "    int k[2][2] = { { y++ }, { y++ } }; int m = x++ + x++, n = z++;\n"
    "    (void)b; (void)d; (void)e; (void)k; (void)m; (void)n;\n"
    "}\n";
static const char check_driver_unsequenced_contexts_source[] =
    "#define INC(v) v++\n"
    "int g(int);\n"
    "void f(int c, int x, int y, signed char sc, _Bool b) {\n"
    "    if (0) { x = x++; }\n"
    "    sc = c ? (sc = 300) : 400;\n"
    "    b = c ? (b = c ? 5 : 6) : 7;\n"
    "    sc = c ? (c ? (sc = 300) : 301) : (sc = 302, 303);\n"
    "    x = INC(x);\n"
    "    y = ({ x++ + x++; });\n"
    "    y = ({ x; }) + x++;\n"
    "    y = __builtin_constant_p(x++) + x++;\n"
    "    y = _Generic(x++, int: x) + x++;\n"
    "    y = sizeof(x++) + x++;\n"
    "    x = __builtin_expect(x++, 1) + x;\n"
    "    for (int i = 0; i < 10; i = i++) {}\n"
    "    while ((x = x++)) {}\n"
    "    #pragma clang diagnostic push\n"
    "    #pragma clang diagnostic ignored \"-Wunsequenced\"\n"
    "    y = y++;\n"
    "    #pragma clang diagnostic pop\n"
    "    y = y++ + (char)300;\n"
    "}\n"
    "void h(int y)\n"
    "{\n"
    "    y = y + 1;\n"
    "    return;\n"
    "    y = y++;\n"
    "}\n";
static const char check_driver_unsequenced_lanes_source[] =
    "int g(int);\n"
    "void f(int x, int y) {\n"
    "    y = x++ + x;\n"
    "    y = x++ + 1 + x;\n"
    "    y = x++ + 1 + 1 + x;\n"
    "    y = x++ + 1 + 1 + 1 + x;\n"
    "    y = x++ + 1 + 1 + 1 + 1 + x;\n"
    "    y = x++ + 1 + 1 + 1 + 1 + 1 + x;\n"
    "    y = x++ + 1 + 1 + 1 + 1 + 1 + 1 + x;\n"
    "    y = x++ + 1 + 1 + 1 + 1 + 1 + 1 + 1 + x;\n"
    "    y = x++ + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + x;\n"
    "    y = x++ + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + x;\n"
    "    y = x++ + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + x;\n"
    "    y = x++ + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + x;\n"
    "    y = x++ + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + x;\n"
    "    y = x++ + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + x;\n"
    "    y = x++ + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + x;\n"
    "    y = x++ + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + x;\n"
    "    y = x++ + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + x;\n"
    "    y = x++ + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + x;\n"
    "    y = x++ + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + x;\n"
    "    y = x++ + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + x;\n"
    "    y = x++ + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + x;\n"
    "    y = x++ + -1 + x;\n"
    "    y = x++ + 1 + -1 + x;\n"
    "    y = x++ + 1 + 1 + -1 + x;\n"
    "    y = x++ + 1 + 1 + 1 + -1 + x;\n"
    "    y = x++ + 1 + 1 + 1 + 1 + -1 + x;\n"
    "    y = x++ + 1 + 1 + 1 + 1 + 1 + -1 + x;\n"
    "    y = x++ + 1 + 1 + 1 + 1 + 1 + 1 + -1 + x;\n"
    "    y = x++ + 1 + 1 + 1 + 1 + 1 + 1 + 1 + -1 + x;\n"
    "    y = x++ + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + -1 + x;\n"
    "    y = x++ + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + -1 + x;\n"
    "    y = x++ + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + -1 + x;\n"
    "    y = x++ + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + -1 + x;\n"
    "    y = x++ + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + -1 + x;\n"
    "    y = x++ + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + -1 + x;\n"
    "    y = x++ + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + -1 + x;\n"
    "    y = x++ + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + -1 + x;\n"
    "    y = x++ + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + -1 + x;\n"
    "    y = x++ + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + -1 + x;\n"
    "    y = x++ + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + -1 + x;\n"
    "    y = x++ + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + -1 + x;\n"
    "    y = x++ + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + -1 + x;\n"
    "    y = (x += 1) + x; y = (x -= 1) + x; y = (x *= 2) + x; y = (x /= 2) + x; y = (x %= 2) + x;\n"
    "    y = (x <<= 1) + x; y = (x >>= 1) + x; y = (x &= 1) + x; y = (x |= 1) + x; y = (x ^= 1) + x;\n"
    "}\n"
    "void h(int x) {\n"
    "    g(x++ + x);\n"
    "    g(x++ + 1 + x);\n"
    "    g(x++ + 1 + 1 + x);\n"
    "    g(x++ + 1 + 1 + 1 + x);\n"
    "    g(x++ + 1 + 1 + 1 + 1 + x);\n"
    "    g(x++ + 1 + 1 + 1 + 1 + 1 + x);\n"
    "    g(x++ + 1 + 1 + 1 + 1 + 1 + 1 + x);\n"
    "    g(x++ + 1 + 1 + 1 + 1 + 1 + 1 + 1 + x);\n"
    "    g(x++ + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + x);\n"
    "    g(x++ + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + x);\n"
    "    g(x++ + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + x);\n"
    "    g(x++ + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + x);\n"
    "    g(x++ + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + x);\n"
    "    g(x++ + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + x);\n"
    "    g(x++ + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + x);\n"
    "    g(x++ + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + x);\n"
    "    g(x++ + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + x);\n"
    "    g(x++ + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + x);\n"
    "    g(x++ + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + x);\n"
    "    g(x++ + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + x);\n"
    "    g(x++ + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + x);\n"
    "    g(x++ + -1 + x);\n"
    "    g(x++ + 1 + -1 + x);\n"
    "    g(x++ + 1 + 1 + -1 + x);\n"
    "    g(x++ + 1 + 1 + 1 + -1 + x);\n"
    "    g(x++ + 1 + 1 + 1 + 1 + -1 + x);\n"
    "    g(x++ + 1 + 1 + 1 + 1 + 1 + -1 + x);\n"
    "    g(x++ + 1 + 1 + 1 + 1 + 1 + 1 + -1 + x);\n"
    "    g(x++ + 1 + 1 + 1 + 1 + 1 + 1 + 1 + -1 + x);\n"
    "    g(x++ + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + -1 + x);\n"
    "    g(x++ + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + -1 + x);\n"
    "    g(x++ + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + -1 + x);\n"
    "    g(x++ + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + -1 + x);\n"
    "    g(x++ + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + -1 + x);\n"
    "    g(x++ + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + -1 + x);\n"
    "    g(x++ + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + -1 + x);\n"
    "    g(x++ + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + -1 + x);\n"
    "    g(x++ + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + -1 + x);\n"
    "    g(x++ + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + -1 + x);\n"
    "    g(x++ + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + -1 + x);\n"
    "    g(x++ + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + -1 + x);\n"
    "    g(x++ + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + -1 + x);\n"
    "}\n";
static const char check_driver_unsequenced_sole_source[] =
    "#define STEP(v) ((v)++)\n"
    "void pair(int, int);\n"
    "int f(volatile int x, int y, int *p) {\n"
    "    x = x + y; x += x; ++x; x--; (void)(x -= y); *p = x;\n"
    "    if ((x = y)) { (void)STEP(x); }\n"
    "    x = STEP(x);\n"
    "    x += ++x;\n"
    "    pair(STEP(x), x);\n"
    "    return x += y;\n"
    "}\n";
static const CheckDriverDefaultWarningFixture fixture_50[] =
{
    {
        .name = "sole volatile modifications and nested unsequenced accesses",
        .source = check_driver_unsequenced_sole_source,
        .options = { "-Wno-everything", "-Wunsequenced" },
        .warnings = 3,
        .notes = 2,
    },
    {
        .name = "unsequenced modifications and reads by operator",
        .source = check_driver_unsequenced_operators_source,
        .warnings = 27,
        // (-c can't compile a range designator.)
        .syntax_only = true,
    },
    {
        .name = "unsequenced modifications and reads by operator in C23 under -Wall -Wextra",
        .source = check_driver_unsequenced_operators_source,
        .options = { "-Wall", "-Wextra" },
        .warnings = 28,
        .c23 = true,
        .syntax_only = true,
    },
    {
        .name = "-Wno-sequence-point holds -Wunsequenced",
        .source = check_driver_unsequenced_operators_source,
        .options = { "-Wno-sequence-point" },
        .warnings = 5,
        .syntax_only = true,
    },
    {
        .name = "-Werror=unsequenced",
        .source = check_driver_unsequenced_operators_source,
        .options = { "-Werror=unsequenced" },
        .warnings = 5,
        .errors = 20,
        .syntax_only = true,
    },
    {
        .name = "unsequenced modifications and reads on every lane of the scans",
        .source = check_driver_unsequenced_lanes_source,
        .warnings = 94,
    },
    {
        .name = "unsequenced accesses by context",
        .source = check_driver_unsequenced_contexts_source,
        .warnings = 19,
        .notes = 1,
    },
    {
        .name = "unsequenced accesses by context in C23 under -Wall -Wextra",
        .source = check_driver_unsequenced_contexts_source,
        .options = { "-Wall", "-Wextra" },
        .warnings = 19,
        .notes = 1,
        .c23 = true,
    },
    {
        .name = "-Wunsequenced alone",
        .source = check_driver_unsequenced_contexts_source,
        .options = { "-Wno-everything", "-Wunsequenced" },
        .warnings = 10,
        .notes = 1,
    },
};
static const size_t fixture_50_lengths[] = {
sizeof(check_driver_unsequenced_sole_source)-1,
sizeof(check_driver_unsequenced_operators_source)-1,
sizeof(check_driver_unsequenced_operators_source)-1,
sizeof(check_driver_unsequenced_operators_source)-1,
sizeof(check_driver_unsequenced_operators_source)-1,
sizeof(check_driver_unsequenced_lanes_source)-1,
sizeof(check_driver_unsequenced_contexts_source)-1,
sizeof(check_driver_unsequenced_contexts_source)-1,
sizeof(check_driver_unsequenced_contexts_source)-1
};
static const CheckDriverDefaultWarningFixture fixture_51[] =
{
    {
        // Locals whose every use sets them, among the unused ones at each scope's end, in declaration order: plain,
        // compound and stepped writes, a static's, a struct's and a pointer's, a volatile's plain write; and those another
        // use reads (a member, an element, a read of itself, a tested write, a nested assignment, sizeof, typeof,
        // _Generic, a parenthesized target, a volatile's compound write, a statement expression's value).
        .name = "variables set but not used",
        .source = "struct P { int a; };\n"
                  "void f(int c) {\n"
                  "  int x; x = 1;\n"
                  "  int y = 2; y += 3;\n"
                  "  int z = 0; z++;\n"
                  "  int w = 0; w = w + 1;\n"
                  "  int v; int u;\n"
                  "  { int k; k = 2; }\n"
                  "  static int s; s = 4;\n"
                  "  struct P p; p.a = 1;\n"
                  "  struct P q; q = (struct P){0};\n"
                  "  int *ptr; ptr = 0;\n"
                  "  int arr[2]; arr[0] = 1;\n"
                  "  volatile int vol; vol = 1;\n"
                  "  volatile int v2 = 0; v2 += 1;\n"
                  "  int m; if ((m = c)) {}\n"
                  "  int n; n = c, n = 2;\n"
                  "  int t; t = 0, (void)0;\n"
                  "  int a; a = 1; (void)sizeof(a);\n"
                  "  int b; (b) = 1;\n"
                  "  int o; o = 1; __typeof__(o) o2 = 0; (void)o2;\n"
                  "  int r; r = 1; (void)_Generic(r, int: 1);\n"
                  "  int l, l2; l = l2 = 0;\n"
                  "  int g; g = 1; ({ g = 2; });\n"
                  "  int e __attribute__((unused)); e = 1;\n"
                  "}\n",
        .options = { "-Wall" },
        .warnings = 12,
        .compare_warning_text = true,
    },
    {
        // A for header's clauses, an if's arms, a block's shadowing name, and a unit whose error drops its scope's.
        .name = "variables set but not used in control statements",
        .source = "void f(int c) { int d; for (d = 0; c; d++) {} int e; for (e = 0; e < c; e++) {} }\n"
                  "void g(int c) { int f2; if (c) f2 = 1; else f2 = 2; int g2; g2 = 1; { int g2; g2 = 2; } }\n"
                  "void h(int c) { for (int i = 0; c; i++) { int z; z = 2; } }\n",
        .options = { "-Wunused-but-set-variable" },
        .warnings = 6,
        .compare_warning_text = true,
    },
    {
        // A step or an assignment as a call's argument or an initializer's element is read; a comma operator's left
        // operand isn't.
        .name = "variables stepped in argument and initializer lists",
        .source = "int g(int, int);\n"
                  "int h(int);\n"
                  "void f(void) { int c = 0; g(c++, 1); int d = 0; g(1, d++); int e = 0; h(e = 1); int k = 0; int a[2] = { k++, 1 }; (void)a;\n"
                  "  int m = 0; (void)(m++, 1); }\n",
        .options = { "-Wall" },
        .warnings = 1,
        .compare_warning_text = true,
    },
    {
        .name = "variables set but not used in a rejected unit",
        .source = "void f(int c) { int x; x = 1; c = undeclared; }\n"
                  "void h(void) { int a; a = 1; }\n",
        .options = { "-Wall" },
        .warnings = 1,
        .errors = 1,
        .syntax_only = true,
    },
    {
        .name = "variables set but not used by default",
        .source = "void f(void) { int x; x = 1; }\n",
        .compare_warning_text = true,
    },
};
static const size_t fixture_51_lengths[] = {
sizeof("struct P { int a; };\n"
                  "void f(int c) {\n"
                  "  int x; x = 1;\n"
                  "  int y = 2; y += 3;\n"
                  "  int z = 0; z++;\n"
                  "  int w = 0; w = w + 1;\n"
                  "  int v; int u;\n"
                  "  { int k; k = 2; }\n"
                  "  static int s; s = 4;\n"
                  "  struct P p; p.a = 1;\n"
                  "  struct P q; q = (struct P){0};\n"
                  "  int *ptr; ptr = 0;\n"
                  "  int arr[2]; arr[0] = 1;\n"
                  "  volatile int vol; vol = 1;\n"
                  "  volatile int v2 = 0; v2 += 1;\n"
                  "  int m; if ((m = c)) {}\n"
                  "  int n; n = c, n = 2;\n"
                  "  int t; t = 0, (void)0;\n"
                  "  int a; a = 1; (void)sizeof(a);\n"
                  "  int b; (b) = 1;\n"
                  "  int o; o = 1; __typeof__(o) o2 = 0; (void)o2;\n"
                  "  int r; r = 1; (void)_Generic(r, int: 1);\n"
                  "  int l, l2; l = l2 = 0;\n"
                  "  int g; g = 1; ({ g = 2; });\n"
                  "  int e __attribute__((unused)); e = 1;\n"
                  "}\n")-1,
sizeof("void f(int c) { int d; for (d = 0; c; d++) {} int e; for (e = 0; e < c; e++) {} }\n"
                  "void g(int c) { int f2; if (c) f2 = 1; else f2 = 2; int g2; g2 = 1; { int g2; g2 = 2; } }\n"
                  "void h(int c) { for (int i = 0; c; i++) { int z; z = 2; } }\n")-1,
sizeof("int g(int, int);\n"
                  "int h(int);\n"
                  "void f(void) { int c = 0; g(c++, 1); int d = 0; g(1, d++); int e = 0; h(e = 1); int k = 0; int a[2] = { k++, 1 }; (void)a;\n"
                  "  int m = 0; (void)(m++, 1); }\n")-1,
sizeof("void f(int c) { int x; x = 1; c = undeclared; }\n"
                  "void h(void) { int a; a = 1; }\n")-1,
sizeof("void f(void) { int x; x = 1; }\n")-1
};
static const CheckDriverDefaultWarningFixture fixture_52[] =
{
    {
        // A label no goto or address names, a statement expression's too, and a local label's at its `__label__` list;
        // one named by a goto, an address or an inner list's own label isn't; unused and maybe_unused mark one used.
        .name = "unused labels",
        .source = "void f(int x) { l: x++; }\n"
                  "void g(int x) { a: b: x++; goto b; }\n"
                  "void h(void) { __label__ m; m: ; }\n"
                  "int k(int x) { void *p = &&q; q: return x + (p != 0); }\n"
                  "void n(int x) { __attribute__((unused)) u: x++; v: __attribute__((unused)); [[maybe_unused]] w: ; }\n"
                  "void o(int x) { if (x) { z: ; } }\n"
                  "#define L(n) n: ;\n"
                  "void q(void) { L(w) }\n"
                  "int r(int x) { return ({ y: x; }); }\n"
                  "void s(void) { l: ; { __label__ l; l: ; goto l; } }\n"
                  "void t(int x) { switch (x) { case 1: l: ; } }\n",
        .options = { "-Wall" },
        .warnings = 8,
        .c23 = true,
    },
    {
        // Clang sorts a function body's unused declarations by place as it pops its scope: its labels among its own
        // variables, after an inner block's, before the body's runtime warnings.
        .name = "unused labels among a body's unused variables",
        .source = "void f(int x) { int a; l: x++; { int b; c: ; } int d; m: ; int e; }\n"
                  "void g(int x) { int a; l: { int b; } (void)x; }\n"
                  "void h(int x) { l: { int b; k: ; } int y = 1 << 40; (void)x; }\n"
                  "void s(int x) { lab: ; static int st; (void)x; }\n",
        .options = { "-Wall" },
        .warnings = 17,
    },
    {
        // A function with an error warns of no unused label, as of no unused variable; a pragma ignores one.
        .name = "unused labels beside errors and pragmas",
        .source = "void f(int x) { l: x++; int y = undeclared; }\n"
                  "void g(int x) { l: x++; }\n"
                  "#pragma clang diagnostic push\n"
                  "#pragma clang diagnostic ignored \"-Wunused-label\"\n"
                  "void k(void) { q: ; }\n"
                  "#pragma clang diagnostic pop\n"
                  "void k2(void) { q: ; }\n",
        .options = { "-Wunused-label" },
        .warnings = 2,
        .errors = 1,
    },
    {
        // A goto whose jump into a statement expression is an error still uses its label, which the recovery's view
        // leaves out with the goto; an unused variable of that function still warns, as the jump's error isn't its scope's.
        .name = "a label an erroneous goto names",
        .source = "void f(int x) { int y; goto in; x = ({ in: 1; }); }\n"
                  "void g(void) { out: ; }\n",
        .options = { "-Wall" },
        .warnings = 2,
        .errors = 1,
        .notes = 1,
    },
    {
        // An asm goto's labels are used as a goto's are: the function's, and a local label its block's list declares,
        // not one of the same name in another scope.
        .name = "labels an asm goto names",
        .source = "void f(void) { asm goto(\"\" :::: l2, l4); l2: ; l4: ; l5: ; }\n"
                  "void g(void) { { __label__ l; asm goto(\"\" :::: l); l: ; } }\n"
                  "void h(void) { { __label__ m; m: ; } asm goto(\"\" :::: m); m: ; }\n"
                  "void q(void) { { __label__ z; z: ; } { __label__ z; asm goto(\"\" :::: z); z: ; } }\n",
        .options = { "-Wall" },
        .warnings = 3,
    },
};
static const size_t fixture_52_lengths[] = {
sizeof("void f(int x) { l: x++; }\n"
                  "void g(int x) { a: b: x++; goto b; }\n"
                  "void h(void) { __label__ m; m: ; }\n"
                  "int k(int x) { void *p = &&q; q: return x + (p != 0); }\n"
                  "void n(int x) { __attribute__((unused)) u: x++; v: __attribute__((unused)); [[maybe_unused]] w: ; }\n"
                  "void o(int x) { if (x) { z: ; } }\n"
                  "#define L(n) n: ;\n"
                  "void q(void) { L(w) }\n"
                  "int r(int x) { return ({ y: x; }); }\n"
                  "void s(void) { l: ; { __label__ l; l: ; goto l; } }\n"
                  "void t(int x) { switch (x) { case 1: l: ; } }\n")-1,
sizeof("void f(int x) { int a; l: x++; { int b; c: ; } int d; m: ; int e; }\n"
                  "void g(int x) { int a; l: { int b; } (void)x; }\n"
                  "void h(int x) { l: { int b; k: ; } int y = 1 << 40; (void)x; }\n"
                  "void s(int x) { lab: ; static int st; (void)x; }\n")-1,
sizeof("void f(int x) { l: x++; int y = undeclared; }\n"
                  "void g(int x) { l: x++; }\n"
                  "#pragma clang diagnostic push\n"
                  "#pragma clang diagnostic ignored \"-Wunused-label\"\n"
                  "void k(void) { q: ; }\n"
                  "#pragma clang diagnostic pop\n"
                  "void k2(void) { q: ; }\n")-1,
sizeof("void f(int x) { int y; goto in; x = ({ in: 1; }); }\n"
                  "void g(void) { out: ; }\n")-1,
sizeof("void f(void) { asm goto(\"\" :::: l2, l4); l2: ; l4: ; l5: ; }\n"
                  "void g(void) { { __label__ l; asm goto(\"\" :::: l); l: ; } }\n"
                  "void h(void) { { __label__ m; m: ; } asm goto(\"\" :::: m); m: ; }\n"
                  "void q(void) { { __label__ z; z: ; } { __label__ z; asm goto(\"\" :::: z); z: ; } }\n")-1
};
static const CheckDriverDefaultWarningFixture fixture_53[] =
{
    {
        .name = "source enables unused binding warnings with default command-line policy",
        .source = "#pragma clang diagnostic push\n"
                  "#pragma clang diagnostic warning \"-Wunused-variable\"\n"
                  "int in_scope(void) { int unused; return 1; }\n"
                  "#pragma clang diagnostic pop\n"
                  "int outside(void) { int unused; return 2; }\n"
                  "#pragma clang diagnostic warning \"-Wunused-local-typedef\"\n"
                  "int local_type(void) { typedef int T; return 3; }\n",
        .warnings = 2,
    },
    {
        // Unused block typedefs, a variable array's with a comma bound and a pointer to one among them, and one a
        // declaration's specifiers use.
        .name = "a block's unused typedefs, a variable array's among them",
        .source = "void f(int x, int n)\n"
                  "{\n"
                  "    typedef int T[(x, n)];\n"
                  "    typedef int U[n];\n"
                  "    typedef int V[4];\n"
                  "    typedef int (*W)[n];\n"
                  "    typedef int Y[n];\n"
                  "    Y y;\n"
                  "    (void)y;\n"
                  "}\n",
        .options = { "-Wall" },
        .warnings = 5,
    },
    {
        // Given at the unit's end in source order, after the bodies' unused variables and runtime warnings: an inner
        // block's, a tag's typedef, shadowing ones; not an attribute unused one or a used one.
        .name = "unused typedefs at the unit's end",
        .source = "void f(int n)\n"
                  "{\n"
                  "    typedef int Z;\n"
                  "    int unused1;\n"
                  "    {\n"
                  "        typedef int Inner;\n"
                  "        int unused2;\n"
                  "    }\n"
                  "    typedef int Used;\n"
                  "    Used u = 0;\n"
                  "    (void)u;\n"
                  "    typedef struct S { int a; } SS;\n"
                  "}\n"
                  "int g(void) { int q; typedef long L; return 1 << 40; }\n"
                  "void h(void) { typedef int __attribute__((unused)) Q; typedef int R; R *p = 0; (void)p; typedef int G; { typedef int G; } }\n",
        .options = { "-Wall" },
        .warnings = 10,
    },
    {
        // After the tentative arrays' and the unused file-scope declarations' warnings, under their gate: none after
        // an error -Werror made before them.
        .name = "unused typedefs after the unused file-scope declarations",
        .source = "static void unused_fn(void) {}\n"
                  "int tent[];\n"
                  "void f(void) { typedef int Z; }\n"
                  "static int unused_var;\n"
                  "void g(void) { typedef int Y; int k; }\n",
        .options = { "-Wall" },
        .warnings = 6,
    },
    {
        // An unused function's error under -Werror comes after the gate, so the typedefs' still follow.
        .name = "unused typedefs after an unused function",
        .source = "void f(void) { typedef int Z; typedef int W; }\n"
                  "static void u(void) {}\n",
        .options = { "-Wall" },
        .warnings = 3,
    },
    {
        // Uses in another typedef, sizeof, a cast, an inner block, a prototype, a statement expression and a
        // declarator list; a macro's typedef comes last; a pragma ignores one.
        .name = "unused typedefs' uses",
        .source = "#define DECL(n) typedef int n\n"
                  "int f(int n)\n"
                  "{\n"
                  "    typedef int A; typedef A B;\n"
                  "    typedef long C; int s = sizeof(C);\n"
                  "    typedef short D; int t = (D)n;\n"
                  "    typedef char E; { E e = 0; (void)e; }\n"
                  "    typedef int F; void g(F);\n"
                  "    typedef int __attribute__((unused)) G;\n"
                  "    DECL(H);\n"
                  "    typedef struct { int x; } I; int z = ({ I i = { 1 }; i.x; });\n"
                  "    typedef int J[sizeof(int)];\n"
                  "#pragma clang diagnostic push\n"
                  "#pragma clang diagnostic ignored \"-Wunused-local-typedef\"\n"
                  "    typedef int K;\n"
                  "#pragma clang diagnostic pop\n"
                  "    typedef int L, M; L l = 0;\n"
                  "    return s + t + z + l;\n"
                  "}\n",
        .options = { "-Wall" },
        .warnings = 4,
    },
};
static const size_t fixture_53_lengths[] = {
sizeof("#pragma clang diagnostic push\n"
                  "#pragma clang diagnostic warning \"-Wunused-variable\"\n"
                  "int in_scope(void) { int unused; return 1; }\n"
                  "#pragma clang diagnostic pop\n"
                  "int outside(void) { int unused; return 2; }\n"
                  "#pragma clang diagnostic warning \"-Wunused-local-typedef\"\n"
                  "int local_type(void) { typedef int T; return 3; }\n")-1,
sizeof("void f(int x, int n)\n"
                  "{\n"
                  "    typedef int T[(x, n)];\n"
                  "    typedef int U[n];\n"
                  "    typedef int V[4];\n"
                  "    typedef int (*W)[n];\n"
                  "    typedef int Y[n];\n"
                  "    Y y;\n"
                  "    (void)y;\n"
                  "}\n")-1,
sizeof("void f(int n)\n"
                  "{\n"
                  "    typedef int Z;\n"
                  "    int unused1;\n"
                  "    {\n"
                  "        typedef int Inner;\n"
                  "        int unused2;\n"
                  "    }\n"
                  "    typedef int Used;\n"
                  "    Used u = 0;\n"
                  "    (void)u;\n"
                  "    typedef struct S { int a; } SS;\n"
                  "}\n"
                  "int g(void) { int q; typedef long L; return 1 << 40; }\n"
                  "void h(void) { typedef int __attribute__((unused)) Q; typedef int R; R *p = 0; (void)p; typedef int G; { typedef int G; } }\n")-1,
sizeof("static void unused_fn(void) {}\n"
                  "int tent[];\n"
                  "void f(void) { typedef int Z; }\n"
                  "static int unused_var;\n"
                  "void g(void) { typedef int Y; int k; }\n")-1,
sizeof("void f(void) { typedef int Z; typedef int W; }\n"
                  "static void u(void) {}\n")-1,
sizeof("#define DECL(n) typedef int n\n"
                  "int f(int n)\n"
                  "{\n"
                  "    typedef int A; typedef A B;\n"
                  "    typedef long C; int s = sizeof(C);\n"
                  "    typedef short D; int t = (D)n;\n"
                  "    typedef char E; { E e = 0; (void)e; }\n"
                  "    typedef int F; void g(F);\n"
                  "    typedef int __attribute__((unused)) G;\n"
                  "    DECL(H);\n"
                  "    typedef struct { int x; } I; int z = ({ I i = { 1 }; i.x; });\n"
                  "    typedef int J[sizeof(int)];\n"
                  "#pragma clang diagnostic push\n"
                  "#pragma clang diagnostic ignored \"-Wunused-local-typedef\"\n"
                  "    typedef int K;\n"
                  "#pragma clang diagnostic pop\n"
                  "    typedef int L, M; L l = 0;\n"
                  "    return s + t + z + l;\n"
                  "}\n")-1
};
static const CheckDriverDefaultWarningFixture fixture_54[] =
{
    {
        // Used: expanded (in a #if line too), named by #ifdef or a live `defined`. Unused: named only in an unexpanded body or
        // a dead `defined`, a function-like name without its (, a definition #undef or a redefinition replaces.
        .name = "basic unused macros",
        .source = "#define USED 1\n"
                  "#define UNUSED 2\n"
                  "#define ONLY_IF 3\n"
                  "#define IN_BODY 4\n"
                  "#define OUTER IN_BODY\n"
                  "#define FN(x) (x)\n"
                  "#define TESTED 6\n"
                  "#define LIVE 7\n"
                  "#define DEAD 8\n"
                  "#define BEFORE 9\n"
                  "#undef BEFORE\n"
                  "#define TWICE 10\n"
                  "#define TWICE 10\n"
                  "#define AGAIN 11\n"
                  "#undef AGAIN\n"
                  "#define AGAIN 12\n"
                  "#if ONLY_IF\n"
                  "#endif\n"
                  "#ifdef TESTED\n"
                  "#endif\n"
                  "#if defined(LIVE) || defined(DEAD)\n"
                  "#endif\n"
                  "#if 0 && defined(DEAD)\n"
                  "#endif\n"
                  "int FN;\n"
                  "int x = USED + FN(1) + AGAIN;\n",
        .options = { "-Wunused-macros" },
        .warnings = 8,
    },
    {
        // The main file's own definitions only, not those after a line marker that enters a file or makes a system header;
        // and an #undef there of a main file's macro, which warns, and its redefinition, which takes it out.
        .name = "sys unused macros",
        .source = "#include <stddef.h>\n"
                  "#define MAIN 1\n"
                  "# 1 \"entered.h\" 1\n"
                  "#define ENTERED 1\n"
                  "# 4 \"basic.c\" 2\n"
                  "#define BACK 1\n"
                  "# 1 \"system.h\" 3\n"
                  "#define SYSTEM 1\n"
                  "#undef MAIN\n"
                  "#define BACK 2\n"
                  "# 8 \"basic.c\"\n"
                  "#define LATER 1\n"
                  "int z;\n",
        .options = { "-Wunused-macros" },
        .warnings = 2,
    },
    {
        // Off by default: a pragma enables, promotes and ignores it, read at each definition's place.
        .name = "prag unused macros",
        .source = "#define OFF 1\n"
                  "#pragma clang diagnostic push\n"
                  "#pragma clang diagnostic warning \"-Wunused-macros\"\n"
                  "#define ON 1\n"
                  "#pragma clang diagnostic error \"-Wunused-macros\"\n"
                  "#define AS_ERROR 1\n"
                  "#pragma clang diagnostic pop\n"
                  "#define OFF_AGAIN 1\n"
                  "#pragma clang diagnostic warning \"-Wunused-macros\"\n"
                  "#define ENABLED 1\n"
                  "#pragma clang diagnostic ignored \"-Wunused-macros\"\n"
                  "int z;\n",
        .warnings = 2,
        .errors = 1,
    },
    {
        // The warnings left at the main file's end, in the order of clang's set of places, through its growth and #undefs.
        .name = "order unused macros",
        .source = "#define M0 0\n"
                  "#define M1 1\n"
                  "#define M2 2\n"
                  "#define M3 3\n"
                  "#define M4 4\n"
                  "#define M5 5\n"
                  "#define M6 6\n"
                  "#define M7 7\n"
                  "#define M8 8\n"
                  "#define M9 9\n"
                  "#define M10 10\n"
                  "#define M11 11\n"
                  "#define M12 12\n"
                  "#define M13 13\n"
                  "#define M14 14\n"
                  "#define M15 15\n"
                  "#define M16 16\n"
                  "#define M17 17\n"
                  "#define M18 18\n"
                  "#define M19 19\n"
                  "#define M20 20\n"
                  "#define M21 21\n"
                  "#define M22 22\n"
                  "#define M23 23\n"
                  "#define M24 24\n"
                  "#define M25 25\n"
                  "#define M26 26\n"
                  "#define M27 27\n"
                  "#define M28 28\n"
                  "#define M29 29\n"
                  "#define M30 30\n"
                  "#define M31 31\n"
                  "#define M32 32\n"
                  "#define M33 33\n"
                  "#define M34 34\n"
                  "#define M35 35\n"
                  "#define M36 36\n"
                  "#define M37 37\n"
                  "#define M38 38\n"
                  "#define M39 39\n"
                  "#undef M0\n"
                  "#undef M3\n"
                  "#undef M6\n"
                  "#undef M9\n"
                  "#undef M12\n"
                  "#undef M15\n"
                  "#undef M18\n"
                  "#undef M21\n"
                  "#undef M24\n"
                  "#undef M27\n"
                  "#undef M30\n"
                  "#undef M33\n"
                  "#undef M36\n"
                  "#undef M39\n"
                  "int v1 = M1;\n"
                  "int v11 = M11;\n"
                  "int v16 = M16;\n"
                  "int v26 = M26;\n"
                  "int v31 = M31;\n"
                  "#define M40(a) a\n"
                  "#define M41(a) a\n"
                  "#define M42(a) a\n"
                  "#define M43(a) a\n"
                  "#define M44(a) a\n"
                  "#define M45(a) a\n"
                  "#define M46(a) a\n"
                  "#define M47(a) a\n"
                  "#define M48(a) a\n"
                  "#define M49(a) a\n"
                  "#define M50(a) a\n"
                  "#define M51(a) a\n"
                  "int z;\n",
        .options = { "-Wunused-macros" },
        .warnings = 47,
    },
    {
        // #pragma pop_macro takes the replaced definition's place out silently, and an #undef after a pop warns again.
        .name = "push unused macros",
        .source = "#define P 1\n"
                  "#pragma push_macro(\"P\")\n"
                  "#undef P\n"
                  "#pragma pop_macro(\"P\")\n"
                  "#undef P\n"
                  "#define Q 1\n"
                  "#pragma push_macro(\"Q\")\n"
                  "#define Q 2\n"
                  "#pragma pop_macro(\"Q\")\n"
                  "#define V 1\n"
                  "#pragma push_macro(\"V\")\n"
                  "#pragma pop_macro(\"V\")\n"
                  "int z;\n",
        .options = { "-Wunused-macros" },
        .warnings = 3,
    },
    {
        // Not in -Wall.
        .name = "unused macros under -Wall",
        .source = "#define UNUSED 1\n"
                  "int z;\n",
        .options = { "-Wall" },
    },
};
static const size_t fixture_54_lengths[] = {
sizeof("#define USED 1\n"
                  "#define UNUSED 2\n"
                  "#define ONLY_IF 3\n"
                  "#define IN_BODY 4\n"
                  "#define OUTER IN_BODY\n"
                  "#define FN(x) (x)\n"
                  "#define TESTED 6\n"
                  "#define LIVE 7\n"
                  "#define DEAD 8\n"
                  "#define BEFORE 9\n"
                  "#undef BEFORE\n"
                  "#define TWICE 10\n"
                  "#define TWICE 10\n"
                  "#define AGAIN 11\n"
                  "#undef AGAIN\n"
                  "#define AGAIN 12\n"
                  "#if ONLY_IF\n"
                  "#endif\n"
                  "#ifdef TESTED\n"
                  "#endif\n"
                  "#if defined(LIVE) || defined(DEAD)\n"
                  "#endif\n"
                  "#if 0 && defined(DEAD)\n"
                  "#endif\n"
                  "int FN;\n"
                  "int x = USED + FN(1) + AGAIN;\n")-1,
sizeof("#include <stddef.h>\n"
                  "#define MAIN 1\n"
                  "# 1 \"entered.h\" 1\n"
                  "#define ENTERED 1\n"
                  "# 4 \"basic.c\" 2\n"
                  "#define BACK 1\n"
                  "# 1 \"system.h\" 3\n"
                  "#define SYSTEM 1\n"
                  "#undef MAIN\n"
                  "#define BACK 2\n"
                  "# 8 \"basic.c\"\n"
                  "#define LATER 1\n"
                  "int z;\n")-1,
sizeof("#define OFF 1\n"
                  "#pragma clang diagnostic push\n"
                  "#pragma clang diagnostic warning \"-Wunused-macros\"\n"
                  "#define ON 1\n"
                  "#pragma clang diagnostic error \"-Wunused-macros\"\n"
                  "#define AS_ERROR 1\n"
                  "#pragma clang diagnostic pop\n"
                  "#define OFF_AGAIN 1\n"
                  "#pragma clang diagnostic warning \"-Wunused-macros\"\n"
                  "#define ENABLED 1\n"
                  "#pragma clang diagnostic ignored \"-Wunused-macros\"\n"
                  "int z;\n")-1,
sizeof("#define M0 0\n"
                  "#define M1 1\n"
                  "#define M2 2\n"
                  "#define M3 3\n"
                  "#define M4 4\n"
                  "#define M5 5\n"
                  "#define M6 6\n"
                  "#define M7 7\n"
                  "#define M8 8\n"
                  "#define M9 9\n"
                  "#define M10 10\n"
                  "#define M11 11\n"
                  "#define M12 12\n"
                  "#define M13 13\n"
                  "#define M14 14\n"
                  "#define M15 15\n"
                  "#define M16 16\n"
                  "#define M17 17\n"
                  "#define M18 18\n"
                  "#define M19 19\n"
                  "#define M20 20\n"
                  "#define M21 21\n"
                  "#define M22 22\n"
                  "#define M23 23\n"
                  "#define M24 24\n"
                  "#define M25 25\n"
                  "#define M26 26\n"
                  "#define M27 27\n"
                  "#define M28 28\n"
                  "#define M29 29\n"
                  "#define M30 30\n"
                  "#define M31 31\n"
                  "#define M32 32\n"
                  "#define M33 33\n"
                  "#define M34 34\n"
                  "#define M35 35\n"
                  "#define M36 36\n"
                  "#define M37 37\n"
                  "#define M38 38\n"
                  "#define M39 39\n"
                  "#undef M0\n"
                  "#undef M3\n"
                  "#undef M6\n"
                  "#undef M9\n"
                  "#undef M12\n"
                  "#undef M15\n"
                  "#undef M18\n"
                  "#undef M21\n"
                  "#undef M24\n"
                  "#undef M27\n"
                  "#undef M30\n"
                  "#undef M33\n"
                  "#undef M36\n"
                  "#undef M39\n"
                  "int v1 = M1;\n"
                  "int v11 = M11;\n"
                  "int v16 = M16;\n"
                  "int v26 = M26;\n"
                  "int v31 = M31;\n"
                  "#define M40(a) a\n"
                  "#define M41(a) a\n"
                  "#define M42(a) a\n"
                  "#define M43(a) a\n"
                  "#define M44(a) a\n"
                  "#define M45(a) a\n"
                  "#define M46(a) a\n"
                  "#define M47(a) a\n"
                  "#define M48(a) a\n"
                  "#define M49(a) a\n"
                  "#define M50(a) a\n"
                  "#define M51(a) a\n"
                  "int z;\n")-1,
sizeof("#define P 1\n"
                  "#pragma push_macro(\"P\")\n"
                  "#undef P\n"
                  "#pragma pop_macro(\"P\")\n"
                  "#undef P\n"
                  "#define Q 1\n"
                  "#pragma push_macro(\"Q\")\n"
                  "#define Q 2\n"
                  "#pragma pop_macro(\"Q\")\n"
                  "#define V 1\n"
                  "#pragma push_macro(\"V\")\n"
                  "#pragma pop_macro(\"V\")\n"
                  "int z;\n")-1,
sizeof("#define UNUSED 1\n"
                  "int z;\n")-1
};
static const char check_driver_unused_result_functions[] =
    "__attribute__((const)) int c(int);\n"
    "__attribute__((pure)) int p(int);\n"
    "__attribute__((warn_unused_result)) int w(int);\n"
    "[[nodiscard]] int d(int);\n"
    "[[nodiscard(\"because\")]] int dm(int);\n"
    "__attribute__((warn_unused_result(\"why\"))) int wm(int);\n"
    "[[gnu::warn_unused_result]] int gw(int);\n"
    "__attribute__((const, warn_unused_result)) int cw(int);\n"
    "int e(int);\n"
    "int g(int n) {\n"
    "  c(n); p(n); w(n); d(n); dm(n); wm(n); gw(n); cw(n); e(n);\n"
    "  (c)(n); (void)w(n); (void)c(n);\n"
    "  c(n), 0; n, c(n); c(n), p(n);\n"
    "  n ? c(n) : p(n); n ? c(n) : e(n); n ? e(n) : p(n); n ? c(n) : 0;\n"
    "  for (c(n); n; p(n)) break;\n"
    "  if (n) c(n); else w(n);\n"
    "  return c(n), w(n);\n"
    "}\n";
static const char check_driver_unused_result_conditionals[] =
    "__attribute__((warn_unused_result)) int w(int);\n"
    "__attribute__((warn_unused_result)) long wl(int);\n"
    "__attribute__((const)) int c(int);\n"
    "int e(int);\n"
    "void f(void);\n"
    "void g(void);\n"
    "struct S { int a; } s;\n"
    "void h(int n) {\n"
    "  n ? (f(), 0) : (g(), 1); n ? (f(), 1) : (g(), (0)); n ? (n ? (f(), 0) : (g(), 0)) : (g(), 0);\n"
    "  (n ? (f(), 0) : (g(), 0)), n; (n ? c(n) : c(n)), 0; 0, (n ? c(n) : e(n));\n"
    "  n ? (0, w(n)) : (n, (0)); n ? (n, (n, w(n))) : w(n); n ? (n ? 1 : 2) : (n ? 3 : f());\n"
    "  n, (n, w(n)); (n, w(n)), n; n, (n ? (f(), 0) : (g(), 0));\n"
    "  n ?: w(n); e(n) ?: 0; w(n) ?: w(n);\n"
    "  n ? wl(n) : w(n); n ? w(n) : e(n); n ? w(n) : n + 1; n ? n + 1 : w(n); n ? c(n) : (n, 0); n ? s.a : s.a;\n"
    "  _Generic(n, int: (n ? w(n) : w(n))); _Generic(n, int: (f(), 0)); _Generic(n, int: (n ? 1 : 2)); n ? _Generic(n, int: w(n)) : c(n);\n"
    "  for (n ? w(n) : w(n); n; n ? c(n) : c(n)) { }\n"
    "}\n";
static const char check_driver_unused_result_macro_arguments[] =
    "__attribute__((pure)) int p(int);\n"
    "__attribute__((const)) int c(int);\n"
    "__attribute__((warn_unused_result)) int w(int);\n"
    "struct [[nodiscard]] R { int x; };\n"
    "struct R r(int);\n"
    "#define ID(x) x\n"
    "#define STMT(x) do { x; } while (0)\n"
    "#define CALL(f) f(1)\n"
    "#define TWO(x) ID(x)\n"
    "#define ARG(x) p(x)\n"
    "void g(int n) {\n"
    "    ID(p(n)); ID(c(n)); ID(w(n)); ID(r(n));\n"
    "    STMT(p(n)); STMT(w(n));\n"
    "    CALL(p); CALL(w);\n"
    "    TWO(p(n)); TWO(w(n));\n"
    "    ARG(n);\n"
    "    ID((p)(n));\n"
    "    ID(n ? p(n) : c(n));\n"
    "}\n";
static const CheckDriverDefaultWarningFixture fixture_55[] =
{
    {
        .name = "ignored results of calls macros' arguments write",
        .source = check_driver_unused_result_macro_arguments,
        .warnings = 12,
        .notes = 14,
        .c23 = true,
    },
    {
        .name = "ignored results of calls macros' arguments write under -Wall -Wextra",
        .source = check_driver_unused_result_macro_arguments,
        .options = { "-Wall", "-Wextra" },
        .warnings = 12,
        .notes = 14,
        .c23 = true,
    },
    {
        .name = "ignored results of calls macros' arguments write without -Wunused-result",
        .source = check_driver_unused_result_macro_arguments,
        .options = { "-Wno-unused-result" },
        .warnings = 8,
        .notes = 9,
        .c23 = true,
    },
    {
        // Each spelling, its message (a standard nodiscard's alone) and its flag; warn_unused_result before const; a void
        // cast; a statement's, a comma's operands', a conditional's arms' (both must warn, the else arm's reported), a for
        // clause's, an if's and a return's comma's.
        .name = "ignored results of attributed functions",
        .source = check_driver_unused_result_functions,
        .warnings = 21,
        .c23 = true,
    },
    {
        .name = "ignored results without -Wunused-value",
        .source = check_driver_unused_result_functions,
        .options = { "-Wno-unused-value" },
        .c23 = true,
    },
    {
        .name = "ignored results without -Wunused-result",
        .source = check_driver_unused_result_functions,
        .options = { "-Wno-unused-result" },
        .warnings = 14,
        .c23 = true,
    },
    {
        .name = "ignored results without -Wunused",
        .source = check_driver_unused_result_functions,
        .options = { "-Wno-unused" },
        .c23 = true,
    },
    {
        .name = "ignored results without -Wall",
        .source = check_driver_unused_result_functions,
        .options = { "-Wno-all" },
        .c23 = true,
    },
    {
        .name = "ignored results with -Wunused-result alone",
        .source = check_driver_unused_result_functions,
        .options = { "-Wno-unused", "-Wunused-result" },
        .warnings = 7,
        .c23 = true,
    },
    {
        // A pure or const call written in a macro's body is quiet, a warn_unused_result one's isn't and notes the
        // expansion; a call whose argument a macro writes is the file's.
        .name = "ignored results through macros",
        .source = "__attribute__((const)) int c(int);\n"
                  "__attribute__((pure)) int p(int);\n"
                  "__attribute__((warn_unused_result)) int w(int);\n"
                  "#define CALLC(x) c(x)\n"
                  "#define CALLP(x) p(x)\n"
                  "#define CALLW(x) w(x)\n"
                  "#define ID(x) x\n"
                  "#define STATEMENT(x) c(x);\n"
                  "void f(int n) {\n"
                  "  CALLC(n); CALLP(n); CALLW(n); STATEMENT(n)\n"
                  "  c(ID(n)); w(ID(n));\n"
                  "}\n",
        .warnings = 3,
        .notes = 1,
    },
    {
        // A return type's struct, union, enum or typedef (through another typedef), the tag before the typedef; not a
        // pointer to one; the function's own attribute first.
        .name = "ignored results of nodiscard types",
        .source = "struct [[nodiscard]] S { int a; };\n"
                  "struct [[nodiscard(\"keep it\")]] M { int a; };\n"
                  "union __attribute__((warn_unused_result)) U { int a; };\n"
                  "enum [[nodiscard]] E { A };\n"
                  "typedef int __attribute__((warn_unused_result)) WI;\n"
                  "typedef WI WJ;\n"
                  "typedef struct S TS;\n"
                  "struct S mk(void);\n"
                  "struct M mm(void);\n"
                  "union U mu(void);\n"
                  "enum E me(void);\n"
                  "WI mwi(void);\n"
                  "WJ mwj(void);\n"
                  "TS mts(void);\n"
                  "struct S *ps(void);\n"
                  "[[nodiscard]] struct S both(void);\n"
                  "void f(void) {\n"
                  "  mk(); mm(); mu(); me(); mwi(); mwj(); mts(); ps(); both(); (void)mk();\n"
                  "}\n",
        .warnings = 8,
        .c23 = true,
    },
    {
        // A redeclaration inherits the attributes before it; a call reads those its lookup sees.
        .name = "ignored results through redeclarations",
        .source = "int h(int);\n"
                  "int h(int) __attribute__((const));\n"
                  "int k(int) __attribute__((pure));\n"
                  "int k(int);\n"
                  "int m(int);\n"
                  "void before(int n) { m(n); }\n"
                  "int m(int) __attribute__((warn_unused_result));\n"
                  "void after(int n) { h(n); k(n); m(n); }\n",
        .warnings = 3,
    },
    {
        // Clang's builtin table's const and pure (a g row's const too, an e row's not under -fmath-errno), a library
        // function's where the unit keeps it a builtin and declares it external; a query builtin's constant and a
        // selection's chosen operand.
        .name = "ignored results of builtins",
        .source = "int abs(int);\n"
                  "double rint(double);\n"
                  "double sin(double);\n"
                  "static long labs(long x) { return x; }\n"
                  "struct S { int a; };\n"
                  "void f(int n, double d, const char *s) {\n"
                  "  __builtin_expect(n, 1); __builtin_clz(n); __builtin_popcount(n); __builtin_constant_p(n); __builtin_classify_type(n);\n"
                  "  __builtin_abs(n); __builtin_fabs(d); __builtin_rint(d); __builtin_sin(d); __builtin_nan(\"\"); __builtin_isnan(d);\n"
                  "  __builtin_strlen(s); __builtin_bswap32(n);\n"
                  "  abs(n); rint(d); sin(d); labs(n);\n"
                  "  __builtin_offsetof(struct S, a); __builtin_types_compatible_p(int, long);\n"
                  "  _Generic(n, int: n, default: 0); _Generic(n, int: abs(n), default: 0); __builtin_choose_expr(1, abs(n), 0);\n"
                  "}\n",
        .warnings = 18,
    },
    {
        // A statement expression in sizeof's operand is unevaluated: its calls' results are clang's to drop quietly.
        .name = "ignored results in an unevaluated statement expression",
        .source = "__attribute__((const)) int c(int);\n"
                  "__attribute__((warn_unused_result)) int w(int);\n"
                  "void f(int n) {\n"
                  "  (void)sizeof(({ c(n); w(n); 1; }));\n"
                  "  int a[n];\n"
                  "  (void)sizeof(a[c(n)]);\n"
                  "  ({ c(n); 1; });\n"
                  "}\n",
        .warnings = 2,
    },
    {
        // An initializer's values (scalar and braced, designated, nested and a compound literal's) are read, not discarded,
        // though a declaration's `;` casts each to void as a root of its own; a statement's call after them still warns.
        .name = "initializers' calls keep their results",
        .source = "typedef struct { const char* p; unsigned long n; } S;\n"
                  "extern unsigned long strlen(const char*) __attribute__((__pure__));\n"
                  "__attribute__((const)) int c(int);\n"
                  "__attribute__((warn_unused_result)) int w(int);\n"
                  "unsigned long f(const char* x) { S s = { .p = x, .n = __builtin_strlen(x) }; return s.n; }\n"
                  "unsigned long g(const char* x) { const S s = { .p = x, .n = strlen(x), }; return s.n; }\n"
                  "unsigned long h(const char* x) { S s = { x, strlen(x) }; S t[1] = { { x, strlen(x) } }; return s.n + t[0].n; }\n"
                  "int k(int n) { int a = c(n); int b[2] = { c(n), w(n) }; int d = { c(n) }; return a + b[0] + d; }\n"
                  "unsigned long m(const char* x) { return ((S){ .p = x, .n = strlen(x) }).n; }\n"
                  "unsigned long q(const char* x) { S s; s = (S){ x, strlen(x) }; return s.n; }\n"
                  "static int z[2] = { sizeof(int), 1 };\n"
                  "int y(int n) { c(n); strlen(\"\"); return z[0]; }\n",
        .warnings = 2,
    },
    {
        // A conditional whose arms hide their results behind the `(x, 0)` idiom is quiet (clang's isUnusedResultAWarning).
        .name = "ignored results: a conditional of hidden results",
        .source = "void f(void); void g(void);\n"
                  "void h(int n) { n ? (f(), 0) : (g(), 0); }\n",
    },
    {
        // A comma's left operand or a discarded comma's value warns of the call the conditional leaves, the else arm's.
        .name = "ignored results: a comma's conditional operand",
        .source = "__attribute__((warn_unused_result)) int w(int);\n"
                  "void f(int n) { (n ? w(n) : w(n)), 0; }\n"
                  "void f2(int n) { 0, (n ? w(n) : w(n)); }\n",
        .warnings = 3,
    },
    {
        // A conditional's arms warn through their commas and their own conditionals.
        .name = "ignored results: a conditional's comma and conditional arms",
        .source = "__attribute__((warn_unused_result)) int w(int);\n"
                  "void f(int n) { n ? (n, w(n)) : (n, w(n)); }\n"
                  "void f2(int n) { n ? (n ? w(n) : w(n)) : w(n); }\n",
        .warnings = 4,
    },
    {
        // A call through a pointer warns of the typedef its declarator spells as the return type.
        .name = "ignored results: a call through a pointer",
        .source = "typedef int __attribute__((warn_unused_result)) WI;\n"
                  "WI (*fp)(void);\n"
                  "void f(void) { fp(); }\n",
        .warnings = 1,
    },
    {
        // The `(x, 0)` idiom in one arm, parenthesized, nested; commas of commas; GNU `?:`, whose else arm alone counts;
        // an arm of no effect, of a plain call, of another type; a member; selections of conditionals and commas; a for
        // clause's conditionals.
        .name = "ignored results through conditionals, commas and selections",
        .source = check_driver_unused_result_conditionals,
        .warnings = 28,
    },
    {
        .name = "ignored results through conditionals without -Wunused-result",
        .source = check_driver_unused_result_conditionals,
        .options = { "-Wno-unused-result" },
        .warnings = 19,
    },
    {
        // A pointer object's and a parameter's declarator, a pointer typedef, a function typedef's pointer, a typedef of the
        // typedef; not a pointer the call returns; a tag; a callee through dereferences.
        .name = "ignored results of calls through pointers",
        .source = "typedef int __attribute__((warn_unused_result)) WI;\n"
                  "typedef WI WJ;\n"
                  "typedef WI (*FP)(void);\n"
                  "typedef WI FN(void);\n"
                  "struct __attribute__((warn_unused_result)) S { int a; };\n"
                  "__attribute__((warn_unused_result)) int w(int);\n"
                  "__attribute__((const)) int c(int);\n"
                  "WI (*fp)(void);\n"
                  "WJ (*fj)(void);\n"
                  "WI *(*fpp)(void);\n"
                  "WI *pw(void);\n"
                  "FP fq;\n"
                  "FN *fn;\n"
                  "struct S (*sp)(void);\n"
                  "int (*plain)(void);\n"
                  "void f(WI (*cb)(void), FP cb2) {\n"
                  "  fp(); (*fp)(); (fp)(); fj(); fpp(); pw(); fq(); fn(); sp(); plain(); cb(); cb2(); (*w)(1); (**c)(1);\n"
                  "}\n",
        .warnings = 11,
    },
    {
        // A pure or const call is quiet where the discarded expression itself is a macro body's: a call's callee, a comma's
        // operator, a conditional's first token; a warn_unused_result call warns anyway.
        .name = "ignored results of conditionals and commas through macros",
        .source = "__attribute__((const)) int c(int);\n"
                  "__attribute__((warn_unused_result)) int w(int);\n"
                  "#define C c\n"
                  "#define W w\n"
                  "#define PICK(n) ((n) ? c(n) : c(n))\n"
                  "#define COMMA(n) ((void)0, c(n))\n"
                  "#define CO ,\n"
                  "#define N n\n"
                  "#define Q ?\n"
                  "void f(int n) {\n"
                  "  n ? C(n) : C(n); n, C(n); C(n), n; C(n);\n"
                  "  PICK(n); COMMA(n); n CO c(n); N ? c(n) : c(n); n Q c(n) : c(n);\n"
                  "  n ? W(n) : W(n); N ? w(n) : w(n);\n"
                  "}\n",
        .warnings = 8,
        .notes = 3,
    },
    {
        // A conditional in a comma's result chain warns only where both arms do; a conditional's comma, conditional and
        // selection arms; a selection's comma and conditional; a statement's comma, conditional and selection in
        // unreachable code, a dead for clause's, a constant condition's other arm's and a short-circuited side's comma;
        // a call's report at its callee, through the parentheses of the callee alone, a dereference and an address.
        .name = "ignored results through nested values, unreachable code and callee groups",
        .source = "int e(int);\n"
                  "__attribute__((warn_unused_result)) int w(int);\n"
                  "__attribute__((pure)) int q(int);\n"
                  "int a, x, m;\n"
                  "void f(int n) {\n"
                  "  (a, n ? e(n) : w(n)), x; x, (a, n ? e(n) : w(n));\n"
                  "  n ? w(n) : (x, w(n)); n ? (x, w(n)) : w(n); n ? w(n) : (m ? w(n) : w(n)); n ? w(n) : _Generic(n, int: w(n));\n"
                  "  n ? w(n) : (x, q(n)); n ? q(n) : _Generic(n, int: q(n));\n"
                  "  _Generic(n, int: (x, w(n)), default: 0); __builtin_choose_expr(1, (x, w(n)), 0); _Generic(n, int: (n ? w(n) : w(n)), default: 0);\n"
                  "}\n"
                  "int g(int n) {\n"
                  "  if (n) { return 0; n ? w(n) : w(n); n, w(n); (n ? w(n) : w(n)), 0; w(n), 0; _Generic(n, int: w(n)); (n, w(n)), n; }\n"
                  "  for (;; n ? w(n) : w(n)) break;\n"
                  "  if (0) { n ? w(n) : w(n); }\n"
                  "  return 1 ? 0 : (w(n), 1);\n"
                  "}\n"
                  "int h(int n) { return 0 && (w(n), 1); }\n"
                  "void k(int n) {\n"
                  "  (w(n)); x = (w(n), 5); (w)(n); ((w))(n); ((w)(n)); (*w)(n); (**w)(n); (&w)(n);\n"
                  "}\n",
        .warnings = 36,
    },
    {
        // A place's and a type query's builtin constant, discarded, reports at its keyword, in a conditional's arm, a
        // comma's operand and a selection too.
        .name = "unused values of keyword builtins",
        .source = "typedef int v4 __attribute__((vector_size(16)));\n"
                  "struct S { int a; };\n"
                  "void f(int n) {\n"
                  "  __builtin_FILE(); __builtin_LINE(); __builtin_FUNCTION(); __builtin_COLUMN(); __builtin_FILE_NAME();\n"
                  "  __builtin_vectorelements(v4); __is_destructible(int); __is_bitwise_cloneable(int); __is_nothrow_destructible(int);\n"
                  "  n ? __builtin_LINE() : __builtin_LINE(); n, __builtin_FILE(); __builtin_LINE(), n;\n"
                  "  n ? __builtin_offsetof(struct S, a) : __builtin_offsetof(struct S, a); _Generic(n, int: __builtin_LINE()); _Generic(n, int: (n, __builtin_LINE()));\n"
                  "}\n",
        .warnings = 18,
    },
    {
        // An unevaluated operand's (sizeof's, typeof's, _Alignof's, a _Generic's controlling expression) commas and
        // conditionals are quiet; a _Generic's other association, a short-circuited side, a statement expression's
        // unreachable statement and a constant condition's other arm are clang's to warn of.
        .name = "ignored results in unevaluated operands and dead code",
        .source = "__attribute__((warn_unused_result)) int w(int);\n"
                  "__attribute__((const)) int c(int);\n"
                  "void f(int n) {\n"
                  "  (void)sizeof((w(1), 1)); __typeof__((w(1), 1)) y = 0; (void)_Alignof(__typeof__((w(1), 1))); (void)y;\n"
                  "  (void)_Generic(n, int: 0, default: (w(1), 1)); (void)_Generic((w(1), n), int: 0);\n"
                  "  (void)sizeof((n ? w(1) : w(2), 1));\n"
                  "  (void)sizeof(({ n ? w(1) : w(2); 1; }));\n"
                  "  (void)(0 && (c(1), 1)); (void)(1 || (n, c(1)));\n"
                  "  ({ return; n ? w(1) : w(2); });\n"
                  "}\n"
                  "static int g(int n) { return 0 ? (c(n), 1) : 0; }\n"
                  "int h(int n) { return g(n); }\n",
        .warnings = 4,
    },
    {
        // Logical operators among conditionals and commas (#1390): a logical operator's value warns where both operands
        // do, at the operator, and a conditional's where both arms' do; a call whose result warns makes its logical operand
        // warn (a tag's contract, a g row's const), a plain one, an enum's, an e row's or a pointer's doesn't; a statement
        // expression's final value; a volatile object's read accepts the discard everywhere.
        .name = "ignored results among logical operators",
        .source = "__attribute__((warn_unused_result)) int w(int);\n"
                  "__attribute__((const)) int c(int);\n"
                  "int e(int);\n"
                  "enum E { A, B };\n"
                  "enum E g(void);\n"
                  "enum __attribute__((warn_unused_result)) F { C };\n"
                  "enum F h(void);\n"
                  "double sin(double);\n"
                  "double rint(double);\n"
                  "int (*fp)(int);\n"
                  "void f(int n, int a, int b, int x, double d, volatile int *p) {\n"
                  "  n ? (a && w(n)) : (b || w(n)); n ? (a && e(n)) : (b || w(n)); (x && 0), w(n); (x && w(n)), 0; x, (a && b);\n"
                  "  (a && b), x; a && (n ? w(n) : w(n)); a && (n ? w(n) : e(n)); a || (x, (b && c(n))); (a && b) || (n ? a : b);\n"
                  "  a && ({ e(n); }); n ? ({ 1; }) : ({ 2; }); ({ e(n); 3; }), x;\n"
                  "  a && g(); a && h(); a && sin(d); a && rint(d); a && fp(1);\n"
                  "  *p; a ? *p : *p; *p, a; a, *p; a && *p;\n"
                  "}\n",
        .warnings = 19,
    },
    {
        // A statement expression's value is its final expression's, and one that ends without an expression is quiet; a
        // void dereference is no cast to void.
        .name = "unused values of statement expressions",
        .source = "void *p;\n"
                  "int e(int);\n"
                  "void f(int n, int a) {\n"
                  "  n ? ({ int z = 1; (void)z; }) : ({ int y = 2; (void)y; });\n"
                  "  n ? ({ e(n); }) : ({ 3; });\n"
                  "  n ? ({ (void)0; }) : ({ (void)1; });\n"
                  "  ({ int q = 1; (void)q; }), a;\n"
                  "  a, ({ int q = 1; (void)q; });\n"
                  "  n ? ({ *p; }) : ({ *p; });\n"
                  "}\n",
        .options = { "-Wno-void-ptr-dereference" },
        .warnings = 3,
    },
    {
        // Discarded values among runtime shift-count warnings (#1394): each keeps clang's order, the counts' before the
        // unused-value markers they precede, in commas, conditionals, logical operators and selections.
        .name = "ignored results among shift-count warnings",
        .source = "__attribute__((warn_unused_result)) int w(int);\n"
                  "void f(int x, int n, int a) {\n"
                  "  x << 40, w(1); n ? x << 40 : x >> -1; (x << 33) && a; a || (x >> 40); (w(x << 40), 0);\n"
                  "  _Generic(n, int: x, default: x << 40); n ? w(x << 33) : w(x >> 33);\n"
                  "}\n",
        .warnings = 17,
    },
    {
        .name = "ignored results of library functions without builtins",
        .source = "int abs(int);\n"
                  "double rint(double);\n"
                  "void f(int n, double d) {\n"
                  "  abs(n); rint(d); __builtin_rint(d);\n"
                  "}\n",
        .options = { "-fno-builtin" },
        .warnings = 1,
    },
    {
        // An initialized pointer declarator's return-type typedef (review on #1732): the declarator hangs from its `=`,
        // at file scope and in a block, static, a later declarator's, a pointer typedef's object, `_Nonnull`.
        .name = "ignored results through initialized pointer declarators",
        .source = "typedef __attribute__((warn_unused_result)) int wur_int;\n"
                  "int plain_fn(void) { return 0; }\n"
                  "wur_int (*gp)(void) = plain_fn;\n"
                  "static wur_int (*sp)(void) = &plain_fn, (*sq)(void) = 0;\n"
                  "typedef wur_int (*FP)(void);\n"
                  "FP tp = plain_fn;\n"
                  "void test(int n)\n"
                  "{\n"
                  "    wur_int (*fp)(void) = plain_fn;\n"
                  "    fp();\n"
                  "    gp();\n"
                  "    sp();\n"
                  "    sq();\n"
                  "    tp();\n"
                  "    wur_int (*_Nonnull np)(void) = (plain_fn);\n"
                  "    np();\n"
                  "    wur_int (*cp)(void) = n ? plain_fn : plain_fn;\n"
                  "    cp();\n"
                  "    wur_int x = 1, (*dp)(void) = plain_fn;\n"
                  "    dp();\n"
                  "    (void)x;\n"
                  "}\n",
        .warnings = 8,
    },
};
static const size_t fixture_55_lengths[] = {
sizeof(check_driver_unused_result_macro_arguments)-1,
sizeof(check_driver_unused_result_macro_arguments)-1,
sizeof(check_driver_unused_result_macro_arguments)-1,
sizeof(check_driver_unused_result_functions)-1,
sizeof(check_driver_unused_result_functions)-1,
sizeof(check_driver_unused_result_functions)-1,
sizeof(check_driver_unused_result_functions)-1,
sizeof(check_driver_unused_result_functions)-1,
sizeof(check_driver_unused_result_functions)-1,
sizeof("__attribute__((const)) int c(int);\n"
                  "__attribute__((pure)) int p(int);\n"
                  "__attribute__((warn_unused_result)) int w(int);\n"
                  "#define CALLC(x) c(x)\n"
                  "#define CALLP(x) p(x)\n"
                  "#define CALLW(x) w(x)\n"
                  "#define ID(x) x\n"
                  "#define STATEMENT(x) c(x);\n"
                  "void f(int n) {\n"
                  "  CALLC(n); CALLP(n); CALLW(n); STATEMENT(n)\n"
                  "  c(ID(n)); w(ID(n));\n"
                  "}\n")-1,
sizeof("struct [[nodiscard]] S { int a; };\n"
                  "struct [[nodiscard(\"keep it\")]] M { int a; };\n"
                  "union __attribute__((warn_unused_result)) U { int a; };\n"
                  "enum [[nodiscard]] E { A };\n"
                  "typedef int __attribute__((warn_unused_result)) WI;\n"
                  "typedef WI WJ;\n"
                  "typedef struct S TS;\n"
                  "struct S mk(void);\n"
                  "struct M mm(void);\n"
                  "union U mu(void);\n"
                  "enum E me(void);\n"
                  "WI mwi(void);\n"
                  "WJ mwj(void);\n"
                  "TS mts(void);\n"
                  "struct S *ps(void);\n"
                  "[[nodiscard]] struct S both(void);\n"
                  "void f(void) {\n"
                  "  mk(); mm(); mu(); me(); mwi(); mwj(); mts(); ps(); both(); (void)mk();\n"
                  "}\n")-1,
sizeof("int h(int);\n"
                  "int h(int) __attribute__((const));\n"
                  "int k(int) __attribute__((pure));\n"
                  "int k(int);\n"
                  "int m(int);\n"
                  "void before(int n) { m(n); }\n"
                  "int m(int) __attribute__((warn_unused_result));\n"
                  "void after(int n) { h(n); k(n); m(n); }\n")-1,
sizeof("int abs(int);\n"
                  "double rint(double);\n"
                  "double sin(double);\n"
                  "static long labs(long x) { return x; }\n"
                  "struct S { int a; };\n"
                  "void f(int n, double d, const char *s) {\n"
                  "  __builtin_expect(n, 1); __builtin_clz(n); __builtin_popcount(n); __builtin_constant_p(n); __builtin_classify_type(n);\n"
                  "  __builtin_abs(n); __builtin_fabs(d); __builtin_rint(d); __builtin_sin(d); __builtin_nan(\"\"); __builtin_isnan(d);\n"
                  "  __builtin_strlen(s); __builtin_bswap32(n);\n"
                  "  abs(n); rint(d); sin(d); labs(n);\n"
                  "  __builtin_offsetof(struct S, a); __builtin_types_compatible_p(int, long);\n"
                  "  _Generic(n, int: n, default: 0); _Generic(n, int: abs(n), default: 0); __builtin_choose_expr(1, abs(n), 0);\n"
                  "}\n")-1,
sizeof("__attribute__((const)) int c(int);\n"
                  "__attribute__((warn_unused_result)) int w(int);\n"
                  "void f(int n) {\n"
                  "  (void)sizeof(({ c(n); w(n); 1; }));\n"
                  "  int a[n];\n"
                  "  (void)sizeof(a[c(n)]);\n"
                  "  ({ c(n); 1; });\n"
                  "}\n")-1,
sizeof("typedef struct { const char* p; unsigned long n; } S;\n"
                  "extern unsigned long strlen(const char*) __attribute__((__pure__));\n"
                  "__attribute__((const)) int c(int);\n"
                  "__attribute__((warn_unused_result)) int w(int);\n"
                  "unsigned long f(const char* x) { S s = { .p = x, .n = __builtin_strlen(x) }; return s.n; }\n"
                  "unsigned long g(const char* x) { const S s = { .p = x, .n = strlen(x), }; return s.n; }\n"
                  "unsigned long h(const char* x) { S s = { x, strlen(x) }; S t[1] = { { x, strlen(x) } }; return s.n + t[0].n; }\n"
                  "int k(int n) { int a = c(n); int b[2] = { c(n), w(n) }; int d = { c(n) }; return a + b[0] + d; }\n"
                  "unsigned long m(const char* x) { return ((S){ .p = x, .n = strlen(x) }).n; }\n"
                  "unsigned long q(const char* x) { S s; s = (S){ x, strlen(x) }; return s.n; }\n"
                  "static int z[2] = { sizeof(int), 1 };\n"
                  "int y(int n) { c(n); strlen(\"\"); return z[0]; }\n")-1,
sizeof("void f(void); void g(void);\n"
                  "void h(int n) { n ? (f(), 0) : (g(), 0); }\n")-1,
sizeof("__attribute__((warn_unused_result)) int w(int);\n"
                  "void f(int n) { (n ? w(n) : w(n)), 0; }\n"
                  "void f2(int n) { 0, (n ? w(n) : w(n)); }\n")-1,
sizeof("__attribute__((warn_unused_result)) int w(int);\n"
                  "void f(int n) { n ? (n, w(n)) : (n, w(n)); }\n"
                  "void f2(int n) { n ? (n ? w(n) : w(n)) : w(n); }\n")-1,
sizeof("typedef int __attribute__((warn_unused_result)) WI;\n"
                  "WI (*fp)(void);\n"
                  "void f(void) { fp(); }\n")-1,
sizeof(check_driver_unused_result_conditionals)-1,
sizeof(check_driver_unused_result_conditionals)-1,
sizeof("typedef int __attribute__((warn_unused_result)) WI;\n"
                  "typedef WI WJ;\n"
                  "typedef WI (*FP)(void);\n"
                  "typedef WI FN(void);\n"
                  "struct __attribute__((warn_unused_result)) S { int a; };\n"
                  "__attribute__((warn_unused_result)) int w(int);\n"
                  "__attribute__((const)) int c(int);\n"
                  "WI (*fp)(void);\n"
                  "WJ (*fj)(void);\n"
                  "WI *(*fpp)(void);\n"
                  "WI *pw(void);\n"
                  "FP fq;\n"
                  "FN *fn;\n"
                  "struct S (*sp)(void);\n"
                  "int (*plain)(void);\n"
                  "void f(WI (*cb)(void), FP cb2) {\n"
                  "  fp(); (*fp)(); (fp)(); fj(); fpp(); pw(); fq(); fn(); sp(); plain(); cb(); cb2(); (*w)(1); (**c)(1);\n"
                  "}\n")-1,
sizeof("__attribute__((const)) int c(int);\n"
                  "__attribute__((warn_unused_result)) int w(int);\n"
                  "#define C c\n"
                  "#define W w\n"
                  "#define PICK(n) ((n) ? c(n) : c(n))\n"
                  "#define COMMA(n) ((void)0, c(n))\n"
                  "#define CO ,\n"
                  "#define N n\n"
                  "#define Q ?\n"
                  "void f(int n) {\n"
                  "  n ? C(n) : C(n); n, C(n); C(n), n; C(n);\n"
                  "  PICK(n); COMMA(n); n CO c(n); N ? c(n) : c(n); n Q c(n) : c(n);\n"
                  "  n ? W(n) : W(n); N ? w(n) : w(n);\n"
                  "}\n")-1,
sizeof("int e(int);\n"
                  "__attribute__((warn_unused_result)) int w(int);\n"
                  "__attribute__((pure)) int q(int);\n"
                  "int a, x, m;\n"
                  "void f(int n) {\n"
                  "  (a, n ? e(n) : w(n)), x; x, (a, n ? e(n) : w(n));\n"
                  "  n ? w(n) : (x, w(n)); n ? (x, w(n)) : w(n); n ? w(n) : (m ? w(n) : w(n)); n ? w(n) : _Generic(n, int: w(n));\n"
                  "  n ? w(n) : (x, q(n)); n ? q(n) : _Generic(n, int: q(n));\n"
                  "  _Generic(n, int: (x, w(n)), default: 0); __builtin_choose_expr(1, (x, w(n)), 0); _Generic(n, int: (n ? w(n) : w(n)), default: 0);\n"
                  "}\n"
                  "int g(int n) {\n"
                  "  if (n) { return 0; n ? w(n) : w(n); n, w(n); (n ? w(n) : w(n)), 0; w(n), 0; _Generic(n, int: w(n)); (n, w(n)), n; }\n"
                  "  for (;; n ? w(n) : w(n)) break;\n"
                  "  if (0) { n ? w(n) : w(n); }\n"
                  "  return 1 ? 0 : (w(n), 1);\n"
                  "}\n"
                  "int h(int n) { return 0 && (w(n), 1); }\n"
                  "void k(int n) {\n"
                  "  (w(n)); x = (w(n), 5); (w)(n); ((w))(n); ((w)(n)); (*w)(n); (**w)(n); (&w)(n);\n"
                  "}\n")-1,
sizeof("typedef int v4 __attribute__((vector_size(16)));\n"
                  "struct S { int a; };\n"
                  "void f(int n) {\n"
                  "  __builtin_FILE(); __builtin_LINE(); __builtin_FUNCTION(); __builtin_COLUMN(); __builtin_FILE_NAME();\n"
                  "  __builtin_vectorelements(v4); __is_destructible(int); __is_bitwise_cloneable(int); __is_nothrow_destructible(int);\n"
                  "  n ? __builtin_LINE() : __builtin_LINE(); n, __builtin_FILE(); __builtin_LINE(), n;\n"
                  "  n ? __builtin_offsetof(struct S, a) : __builtin_offsetof(struct S, a); _Generic(n, int: __builtin_LINE()); _Generic(n, int: (n, __builtin_LINE()));\n"
                  "}\n")-1,
sizeof("__attribute__((warn_unused_result)) int w(int);\n"
                  "__attribute__((const)) int c(int);\n"
                  "void f(int n) {\n"
                  "  (void)sizeof((w(1), 1)); __typeof__((w(1), 1)) y = 0; (void)_Alignof(__typeof__((w(1), 1))); (void)y;\n"
                  "  (void)_Generic(n, int: 0, default: (w(1), 1)); (void)_Generic((w(1), n), int: 0);\n"
                  "  (void)sizeof((n ? w(1) : w(2), 1));\n"
                  "  (void)sizeof(({ n ? w(1) : w(2); 1; }));\n"
                  "  (void)(0 && (c(1), 1)); (void)(1 || (n, c(1)));\n"
                  "  ({ return; n ? w(1) : w(2); });\n"
                  "}\n"
                  "static int g(int n) { return 0 ? (c(n), 1) : 0; }\n"
                  "int h(int n) { return g(n); }\n")-1,
sizeof("__attribute__((warn_unused_result)) int w(int);\n"
                  "__attribute__((const)) int c(int);\n"
                  "int e(int);\n"
                  "enum E { A, B };\n"
                  "enum E g(void);\n"
                  "enum __attribute__((warn_unused_result)) F { C };\n"
                  "enum F h(void);\n"
                  "double sin(double);\n"
                  "double rint(double);\n"
                  "int (*fp)(int);\n"
                  "void f(int n, int a, int b, int x, double d, volatile int *p) {\n"
                  "  n ? (a && w(n)) : (b || w(n)); n ? (a && e(n)) : (b || w(n)); (x && 0), w(n); (x && w(n)), 0; x, (a && b);\n"
                  "  (a && b), x; a && (n ? w(n) : w(n)); a && (n ? w(n) : e(n)); a || (x, (b && c(n))); (a && b) || (n ? a : b);\n"
                  "  a && ({ e(n); }); n ? ({ 1; }) : ({ 2; }); ({ e(n); 3; }), x;\n"
                  "  a && g(); a && h(); a && sin(d); a && rint(d); a && fp(1);\n"
                  "  *p; a ? *p : *p; *p, a; a, *p; a && *p;\n"
                  "}\n")-1,
sizeof("void *p;\n"
                  "int e(int);\n"
                  "void f(int n, int a) {\n"
                  "  n ? ({ int z = 1; (void)z; }) : ({ int y = 2; (void)y; });\n"
                  "  n ? ({ e(n); }) : ({ 3; });\n"
                  "  n ? ({ (void)0; }) : ({ (void)1; });\n"
                  "  ({ int q = 1; (void)q; }), a;\n"
                  "  a, ({ int q = 1; (void)q; });\n"
                  "  n ? ({ *p; }) : ({ *p; });\n"
                  "}\n")-1,
sizeof("__attribute__((warn_unused_result)) int w(int);\n"
                  "void f(int x, int n, int a) {\n"
                  "  x << 40, w(1); n ? x << 40 : x >> -1; (x << 33) && a; a || (x >> 40); (w(x << 40), 0);\n"
                  "  _Generic(n, int: x, default: x << 40); n ? w(x << 33) : w(x >> 33);\n"
                  "}\n")-1,
sizeof("int abs(int);\n"
                  "double rint(double);\n"
                  "void f(int n, double d) {\n"
                  "  abs(n); rint(d); __builtin_rint(d);\n"
                  "}\n")-1,
sizeof("typedef __attribute__((warn_unused_result)) int wur_int;\n"
                  "int plain_fn(void) { return 0; }\n"
                  "wur_int (*gp)(void) = plain_fn;\n"
                  "static wur_int (*sp)(void) = &plain_fn, (*sq)(void) = 0;\n"
                  "typedef wur_int (*FP)(void);\n"
                  "FP tp = plain_fn;\n"
                  "void test(int n)\n"
                  "{\n"
                  "    wur_int (*fp)(void) = plain_fn;\n"
                  "    fp();\n"
                  "    gp();\n"
                  "    sp();\n"
                  "    sq();\n"
                  "    tp();\n"
                  "    wur_int (*_Nonnull np)(void) = (plain_fn);\n"
                  "    np();\n"
                  "    wur_int (*cp)(void) = n ? plain_fn : plain_fn;\n"
                  "    cp();\n"
                  "    wur_int x = 1, (*dp)(void) = plain_fn;\n"
                  "    dp();\n"
                  "    (void)x;\n"
                  "}\n")-1
};
static const char check_driver_vla_fold_contexts_source[] =
    "#define F (int)(1.0 + 2)\n"
    "int a1[F];\n"
    "int a2[2][F];\n"
    "int *a3[F];\n"
    "int (*a4)[F];\n"
    "typedef int T1[F];\n"
    "struct S { int m[F]; int bf : F; };\n"
    "enum E { X = F };\n"
    "_Static_assert(F, \"\");\n"
    "extern int a5[F];\n"
    "int a6[F], a7[F];\n"
    "void p(int x[F]);\n"
    "int f(int n)\n"
    "{\n"
    "    int b1[F];\n"
    "    static int b2[F];\n"
    "    extern int b3[F];\n"
    "    typedef int T2[F];\n"
    "    switch (n) { case F: return 1; }\n"
    "    int c = sizeof(int[F]);\n"
    "    _Alignas(F) int d;\n"
    "    return b1[0] + b2[0] + c + d;\n"
    "}\n"
    "int q[] = { [F] = 1 };\n"
    "_Alignas(F * 4) int e;\n";
static const char check_driver_vla_fold_declarators_source[] =
    "#define F (int)(1.0 + 2)\n"
    "int a[F][F];\n"
    "struct S { int x; int m[F][2]; int : F; };\n"
    "int z[F] = { 1, 2 };\n"
    "const int k = 2;\n"
    "int w[k + (int)(1.0 + 1)];\n"
    "void g(void) { static int q[F][F]; extern int r[F]; int ok[F]; (void)ok; (void)q; (void)r; }\n";
static const char check_driver_vla_fold_forms_source[] =
    "int a1[(int)2.5];\n"
    "int a2[(int)(1.0 + 2)];\n"
    "char a3[(unsigned)3.0f];\n"
    "int a4[(long)1.5 + 1];\n"
    "typedef int T1[(int)2.0];\n"
    "struct S { int m[(int)3.0]; int bf : (int)2.0; };\n"
    "int s1 = sizeof(int[(int)2.0]);\n"
    "enum E { X = (int)2.5 };\n"
    "_Static_assert((int)1.0, \"\");\n"
    "int f(int n)\n"
    "{\n"
    "    int b1[(int)2.5];\n"
    "    static int b2[(int)2.5];\n"
    "    int b3[n];\n"
    "    int b4[sizeof(b3) > 0 ? 1 : 2];\n"
    "    switch (n) { case (int)1.0: return 1; }\n"
    "    int c = sizeof(int[(int)2.0]);\n"
    "    return b1[0] + b2[0] + b4[0] + c;\n"
    "}\n"
    "int g1[__builtin_constant_p(1) ? 2 : 3];\n"
    "const int k = 3;\n"
    "int g2[k];\n"
    "int g3[(int)\"x\"[0] - 'x' + 1];\n";
static const char check_driver_vla_place_source_0[] =
    "#define F (int)(1.0 + 2)\n"
    "int s = 1 + sizeof(int[F]);\n";
static const char check_driver_vla_place_source_1[] =
    "#define F (int)(1.0 + 2)\n"
    "int g[sizeof(int[F])];\n";
static const char check_driver_vla_place_source_2[] =
    "#define F (int)(1.0 + 2)\n"
    "void f(void) { static int b[F]; extern int c[F]; static int d[sizeof(int[F])]; }\n";
static const char check_driver_vla_place_source_3[] =
    "#define F (int)(1.0 + 2)\n"
    "struct S { int m[sizeof(int[F])]; };\n";
static const char check_driver_vla_place_source_4[] =
    "int n;\n"
    "int g[2][n];\n";
static const char check_driver_vla_place_source_5[] =
    "int n;\n"
    "int (*p)[n];\n";
static const char check_driver_vla_place_source_6[] =
    "int n;\n"
    "typedef int T[n];\n";
static const char check_driver_vla_place_source_7[] =
    "int n;\n"
    "int s[2][2] = { { 1, 2 }, { [1] = 3 + (sizeof(int[n])) } };\n";
static const char check_driver_vla_place_source_8[] =
    "void f(int n) { extern int b[n]; }\n";
static const char check_driver_vla_place_source_9[] =
    "void f(int n) { extern int (*p)[n]; }\n";
static const char check_driver_vla_place_source_10[] =
    "void f(int n) { static _Thread_local int b[n]; }\n";
static const char check_driver_vla_place_source_11[] =
    "void f(int n) { struct S { int a; int (*p)[n]; }; }\n";
static const char check_driver_vla_place_source_12[] =
    "int n;\n"
    "union U { int m[2][n]; };\n";
static const char check_driver_vla_place_source_13[] =
    "int n;\n"
    "int (g)[n];\n";
static const char check_driver_vla_place_source_14[] =
    "int n;\n"
    "int ((g))[2][n];\n";
static const char check_driver_vla_place_source_15[] =
    "int n;\n"
    "int *(p)[n];\n";
static const char check_driver_vla_place_source_16[] =
    "int n;\n"
    "int (*(p))[n];\n";
static const char check_driver_vla_misplaced_source[] =
    "int n;\n"
    "int a[n];\n"
    "int (*vp)[n];\n"
    "int b[n], c;\n"
    "int use = a[0] + c + *vp[0];\n"
    "void f(int k) { static int s[k]; extern int e[k]; extern int (*ep)[k]; int u = q + s[0] + e[0]; (void)u; }\n"
    "typedef int T[n];\n"
    "int z = w;\n";
static const char check_driver_vla_compound_source[] =
    "int a[(int){3}];\n"
    "int b[(long){2 * 4} + 1];\n"
    "struct S { int m[(int){2}]; };\n"
    "void f(void) { static int s[(int){4}]; int t[(int){5}]; int *p = &(int){1}; (void)s; (void)t; (void)p; }\n"
    "int c[(const int){2}];\n"
    "enum { E = (int){1} };\n"
    "int e = (int){3} + E;\n"
    "int sz = sizeof((int){1});\n"
    "_Static_assert(sizeof(a) == 12 && sizeof(b) == 36, \"\");\n";
static const char check_driver_vla_initializer_source[] =
    "void f(int n) {\n"
    "  int a[n] = {1};\n"
    "  int b[n + 1][2] = {{1}};\n"
    "  char s[n] = \"ab\";\n"
    "  int c[(n)] = {1, 2}, d = q1;\n"
    "  int e[n] = 5;\n"
    "  int use = a[0] + b[0][0] + s[0] + c[0] + e[0] + d;\n"
    "  int (*p)[n] = 0;\n"
    "  char *bad = use;\n"
    "  int g[n] = {1, \"x\"}; char *t3 = g;\n"
    "  int h[n] = {}; char *t4 = h;\n"
    "  (void)p; (void)bad; (void)t3; (void)t4;\n"
    "}\n"
    "int x = y;\n";
static const char check_driver_vla_unevaluated_source[] =
    "int n; void *p = (int(*)[n])0;\n"
    "int n2; int s = (int)(long)(int(*)[n2])0;\n"
    "int n3; int s3 = _Alignof(int[n3]);\n"
    "_Static_assert(_Alignof(long[n3]) == 8, \"\");\n"
    "int s4 = _Alignof(int[n3][4]) + sizeof(int);\n"
    "char *bad = (int(*)[n])0;\n"
    "int s5 = sizeof(int[n]);\n";
static const char check_driver_vla_pointer_size_source[] =
    "int n;\n"
    "unsigned long c = sizeof(int(*)[n]);\n"
    "unsigned long a = sizeof(int(*)[(3, 2)]);\n"
    "unsigned long p = sizeof(int(*[3])[n]);\n"
    "unsigned long m = sizeof(int(*)[n][n + 1]);\n"
    "enum { P = sizeof(int(*)[++n]), A = sizeof(int(*[3])[n]) };\n"
    "_Static_assert(P == 8 && A == 24, \"fixed pointer size\");\n"
    "_Static_assert(_Alignof(int[n]) == 4 && _Alignof(int(*)[n]) == 8, \"fixed alignment\");\n"
    "unsigned long nested_p = sizeof(int(*)[sizeof(int[n])]);\n"
    "unsigned long nested_a = _Alignof(int[sizeof(int[n])]);\n"
    "unsigned long nested_s = sizeof(sizeof(int[n]));\n"
    "unsigned long nested_side = sizeof(sizeof(int[++n]));\n";
static const char check_driver_vla_pointer_size_error_source[] =
    "int n;\n"
    "unsigned long c = sizeof(int(*)[n]);\n"
    "unsigned long a = sizeof(int(*)[(3, 2)]);\n"
    "unsigned long d = sizeof(int[n]);\n";
static const char check_driver_vla_cast_source[] =
    "int f(int n, int *v) { return (int)sizeof(*(int (*)[n])v); }\n"
    "int g(int n, int *v) { int (*p)[n] = (int (*)[n])v; return (int)sizeof *p; }\n"
    "void h(int n) { (void)((int (*)[n])0); }\n"
    "void k(int n) { (void)sizeof((int (*)[n])0); }\n"
    "void a(int n, int *v) { (int (*)[n])v; }\n"
    "int b(int n, int x) { return (int)sizeof(x++, (int(*)[n])0) + x; }\n"
    "void d(int i) { (void)sizeof((int (*)[i++])0); }\n"
    "void e(int n, int *v) { if ((int (*)[n])v) {} }\n"
    "void q(int n, int *v) { (void)(typeof(int[n]) *)v; }\n"
    "int r(int n, int *v) { return ((int (*)[n])v == (int (*)[n + 1])v); }\n"
    "int m(int n, int *v) { return _Alignof(int[n]) + (int)_Generic((int (*)[n])v, int (*)[]: 1, default: 2); }\n"
    "int u1(int n, int *v) { return ((int (*)[n++])v)[0][0] + n; }\n"
    "int u2(int n) { return (int)sizeof(int[n++]) + n; }\n"
    "int u3(int n, int *v) { return (int)sizeof(*(int (*)[n++])v) + n; }\n";
static const char check_driver_vla_fold_commas_source[] =
    "int a1[(1, 2)];\n"
    "int a2[1 ? 2 : (3, 4)];\n"
    "int a3[(1, 2, 3)];\n"
    "int a4[((void)0, 2)];\n"
    "int a5[(1 + 1, 2)];\n"
    "int a6[(sizeof(int), 2)];\n"
    "int a7[sizeof((1, 2))];\n"
    "int a8[((1, 0), 2)];\n"
    "int a9[(1 == 1, 2)];\n"
    "int a10[((char)1, 2)];\n"
    "int a11[(-1, 2) + (3, 4)];\n"
    "typedef int T[(5, 6)];\n"
    "struct S { int m[(7, 8)]; int n : (1, 3); };\n"
    "enum { E1 = (1, 2), E2 = ((void)0, 3), E3 = (E1, 4) };\n"
    "int f(void)\n"
    "{\n"
    "    static int s[(1, 2)];\n"
    "    enum { L = (3, 4) };\n"
    "    int u = 1 / 0;\n"
    "    return s[0] + L + u;\n"
    "}\n";
static const char check_driver_vla_variable_commas_source[] =
    "void *g = (int(*)[(5, 2)])0;\n"
    "unsigned long al = _Alignof(int[(4, 2)]);\n"
    "int a[(1, 2)];\n"
    "enum { A = (3, 4) };\n"
    "struct S { int m[(6, 3)]; };\n"
    "void f(void) { void *p = (int(*)[(7, 2)])0; (void)p; }\n"
    "void k(int n) { unsigned long s = sizeof(int[(8, n)]); (void)s; }\n";
static const char check_driver_vla_body_commas_source[] =
    "int f(void)\n"
    "{\n"
    "    int a[3];\n"
    "    a[5] = 0;\n"
    "    enum { B = (9, 1), C = ((void)0, 2), D = (B, 3) };\n"
    "    typedef int T[(7, 2)];\n"
    "    a[6] = 1;\n"
    "    enum { E = (4, 5) };\n"
    "    struct S { int m[(1, 2)]; int w : (3, 4); };\n"
    "    int u = 1 / 0;\n"
    "    {\n"
    "        static int s[(5, 2)];\n"
    "        a[7] = s[0];\n"
    "        {\n"
    "            enum { G = (6, 7) };\n"
    "            a[8] = G;\n"
    "        }\n"
    "    }\n"
    "    a[9] = (int)sizeof(T) + E;\n"
    "    return u;\n"
    "}\n"
    "int g(int n)\n"
    "{\n"
    "    int b[2];\n"
    "    b[2] = n;\n"
    "    enum { H = (8, 9) };\n"
    "    if (n) { enum { I = (1, 2) }; b[3] = I; }\n"
    "    do { enum { J = (3, 4) }; } while (b[4]);\n"
    "    for (int i = b[5]; i < 1; i++) { enum { K = (5, 6) }; }\n"
    "    return H;\n"
    "}\n";
static const char check_driver_vla_body_assertion_condition_source[] =
    "int f(void)\n"
    "{\n"
    "    int a[3];\n"
    "    a[5] = 0;\n"
    "    enum { B = (9, 1) };\n"
    "    _Static_assert((1, 0) ? 1 : 0, \"x\");\n"
    "    typedef int T[(7, 2)];\n"
    "    a[6] = 1;\n"
    "    enum { C = (4, 5) };\n"
    "    a[7] = B + C;\n"
    "    return 0;\n"
    "}\n";
static const char check_driver_vla_body_assertion_arm_source[] =
    "int f(void)\n"
    "{\n"
    "    int a[3];\n"
    "    a[5] = 0;\n"
    "    enum { B = (9, 1) };\n"
    "    typedef int T[(7, 2)];\n"
    "    a[6] = 1;\n"
    "    _Static_assert(0 ? (3, 1) : 0, \"z\");\n"
    "    enum { C = (4, 5) };\n"
    "    a[7] = B + C;\n"
    "    return 0;\n"
    "}\n";
static const char check_driver_vla_body_comparisons_source[] =
    "void f(void)\n"
    "{\n"
    "    int a[3];\n"
    "    a[5] = 0;\n"
    "    enum { B = (1 == 1, 2), C = ((void *)0, 3), D = (4, 5), E = (1 < 2, 6) };\n"
    "    a[6] = 1;\n"
    "    typedef int T[(2 != 3, 2)];\n"
    "    a[7] = 1;\n"
    "    (void)sizeof(T);\n"
    "}\n";
static const char check_driver_vla_static_commas_source[] =
    "void f(void)\n"
    "{\n"
    "    int a[2];\n"
    "    a[3] = 0;\n"
    "    static int b = sizeof(int[(6, 2)]);\n"
    "    enum { E = (1, 2) };\n"
    "    a[4] = 0;\n"
    "}\n";
static const char check_driver_vla_body_completions_source[] =
    "void g(int);\n"
    "int f(int i)\n"
    "{\n"
    "    int a[3];\n"
    "    char c;\n"
    "    a[3] = 0;\n"
    "    a[4] = (int)sizeof(struct { int m[(1, 2)]; });\n"
    "    int x = a[5] + (int)sizeof(enum { E = (3, 4) }) + a[6];\n"
    "    1 + (int)sizeof(struct { int m[(5, 6)]; });\n"
    "    i++ + i++ + (int)sizeof(struct { int m[(7, 8)]; });\n"
    "    c = 300 + (int)sizeof(struct { int m[(9, 1)]; });\n"
    "    g(a[7] + (int)sizeof(struct { int m[(2, 3)]; }));\n"
    "    return x + c;\n"
    "}\n";
static const char check_driver_vla_body_nested_source[] =
    "void g(int, int);\n"
    "void f(void)\n"
    "{\n"
    "    int a[3];\n"
    "    a[3] = 0;\n"
    "    a[4] = ({ enum { E = (1, 2) }; 0; });\n"
    "    g(a[5], ({ static int s[(3, 4)]; s[0]; }));\n"
    "    a[6] = ({ a[7]; enum { F = (5, 6) }; 0; });\n"
    "    int x = *(int *)0 + (int)sizeof(struct { int m[(7, 8)]; });\n"
    "    x = x / (sizeof(struct { int m[(9, 2)]; }) - 8);\n"
    "    x = 1 << (sizeof(struct { int m[(1, 2)]; }) * 8);\n"
    "    for (a[8] = 0; (int)sizeof(struct { int m[(3, 1)]; }) > a[9]; a[10]++)\n"
    "    {\n"
    "        enum { G = (4, 5) };\n"
    "    }\n"
    "    (void)x;\n"
    "}\n";
static const char check_driver_vla_body_operators_source[] =
    "_Atomic struct A { int m; } s;\n"
    "int y;\n"
    "int f(void)\n"
    "{\n"
    "    int a[3];\n"
    "    a[3] = 0;\n"
    "    int x = 1 / 0 + (int)sizeof(struct { int m[(1, 2)]; });\n"
    "    x += (1 << 40) + (int)sizeof(struct { int m[(3, 4)]; });\n"
    "    x += s.m + (int)sizeof(struct { int m[(5, 6)]; });\n"
    "    x += (y, 1) + (int)sizeof(struct { int m[(7, 8)]; });\n"
    "    return x;\n"
    "}\n";
static const char check_driver_vla_body_comparison_queue_source[] =
    "int i;\n"
    "unsigned u;\n"
    "unsigned char c;\n"
    "int f(void)\n"
    "{\n"
    "    int a[3];\n"
    "    a[3] = 0;\n"
    "    int x = (i < u) + (int)sizeof(struct { int m[(1, 2)]; });\n"
    "    x += (c < 300) + (int)sizeof(struct { int m[(3, 4)]; });\n"
    "    return x;\n"
    "}\n";
static const char check_driver_vla_body_builtin_source[] =
    "typedef int v4si __attribute__((vector_size(16)));\n"
    "v4si f(v4si x)\n"
    "{\n"
    "    x = __builtin_ia32_pshufd(x, 300);\n"
    "    x = __builtin_ia32_pshufd(x, (int)sizeof(struct { int m[(1, 2)]; }) + 300);\n"
    "    return x;\n"
    "}\n";
static const char check_driver_vla_body_member_comparisons_source[] =
    "void f(void)\n"
    "{\n"
    "    int a[3];\n"
    "    a[5] = 0;\n"
    "    struct S { int m[(1 < 2, 2)]; int w : (3 != 3, 4); };\n"
    "    a[6] = 1;\n"
    "    union U { char n[(5 == 5, 1)]; int v : (6 >= 7, 2); };\n"
    "}\n";
static const char check_driver_vla_discarded_undefined_source[] =
    "int a1[(1 << 44, 3)];\n"
    "int a2[((-2147483647 - 1) / -1, 3)];\n"
    "int a3[(2147483647 + 1, 3)];\n"
    "int a4[((void)(1 << 44), 3)];\n"
    "static int a5[(-1 << 2, 3)];\n"
    "extern int a6[(1u << 44, 3)];\n"
    "typedef int T7[(1 >> 44, 3)];\n"
    "int (*p8)[(1 << 44, 3)];\n"
    "int a9[(1 << 44, 3)], a10[(5, 2)];\n"
    "int b1[(0 ? 1 << 44 : 1, 3)];\n"
    "int b2[(0 && (1 << 44), 3)];\n"
    "const int c = 3;\n"
    "int b3[(c, 2)];\n"
    "int b4[(1 << 31, 3)];\n"
    "enum { E = (1 << 44, 3) };\n"
    "struct B { int b : (1 << 44, 3); };\n"
    "int g(int x) { switch (x) { case (1 << 44, 3): return 1; } return 0; }\n"
    "_Static_assert((1 << 44, 3), \"\");\n"
    "int ini = (1 << 44, 3);\n";
static const char check_driver_vla_sizeof_recovery_source[] =
    "int b = sizeof(int[(6, 2)]) + sizeof(int[(7, 3)]);\n"
    "int c = (1, 2);\n"
    "int d = sizeof(int[(8, 2)]), e = (9, 4);\n"
    "int f[(1 << 44, 3)];\n"
    "int g = (10, 5);\n";
static const char check_driver_vla_compound_fold_source[] =
    "int *g = (int[(1, 2)]){ 3, 4 };\n"
    "int f(int n)\n"
    "{\n"
    "    int *p = (int[(1, 2)]){ 5, 6 };\n"
    "    int *r = (int[2][(1, 1)]){ { 7 }, { 8 } }[1];\n"
    "    return p[0] + p[1] + r[0] + g[1] + n + (int)sizeof((int[(1, 3)]){ 0 });\n"
    "}\n"
    "int main(void) { return f(1) == 5 + 6 + 8 + 4 + 1 + 12 ? 0 : 1; }\n";
static const CheckDriverDefaultWarningFixture fixture_56[] =
{
    {
        .name = "a body's casts to variably modified types",
        .source = check_driver_vla_cast_source,
        .warnings = 2,
    },
    {
        .name = "misplaced variable-length arrays recover",
        .source = check_driver_vla_misplaced_source,
        .errors = 9,
    },
    {
        .name = "scalar compound literals in bounds",
        .source = check_driver_vla_compound_source,
        .warnings = 5,
    },
    {
        .name = "a file-scope cast's and _Alignof's variable type names",
        .source = check_driver_vla_unevaluated_source,
        .errors = 2,
    },
    {
        .name = "a file-scope sizeof of pointers to variable arrays stays constant",
        .source = check_driver_vla_pointer_size_source,
        .warnings = 1,
    },
    {
        .name = "a file-scope sizeof refuses only the runtime-sized array",
        .source = check_driver_vla_pointer_size_error_source,
        .warnings = 1,
        .errors = 1,
    },
    {
        .name = "a file-scope evaluated nested variable array size remains nonconstant",
        .source = "int n; unsigned long x=sizeof(int[sizeof(int[n])]);\n",
        .errors = 1,
    },
    {
        .name = "a file-scope unevaluated nested size still checks its array bound type",
        .source = "unsigned long x=sizeof(sizeof(int[1.5]));\n",
        .errors = 1,
    },
    {
        .name = "a block's variable-length array with an initializer",
        .source = check_driver_vla_initializer_source,
        .errors = 11,
    },
    {
        .name = "variable bounds' comma operators the constant reader alone reads",
        .source = check_driver_vla_variable_commas_source,
        .warnings = 9,
    },
    {
        .name = "a body's constants' commas among its queued diagnostics in source order",
        .source = check_driver_vla_body_commas_source,
        .warnings = 24,
        .notes = 9,
    },
    {
        .name = "a body's constants' comparisons as commas' left operands at once",
        .source = check_driver_vla_body_comparisons_source,
        .warnings = 8,
        .notes = 3,
    },
    // A file-scope sizeof's variable bound's commas, which clang gives as it reads them, before its initializer's "not a
    // compile-time constant" once the initializer is read (#2252): alone, beside a folded bound in a braced list, with an
    // _Alignof's in a member's, and after a designator.
    {
        .name = "a file-scope sizeof's variable bound's comma before its initializer's error",
        .source = "int x;\nint b = sizeof(int[(6, 2)]);\n",
        .warnings = 1,
        .errors = 1,
    },
    {
        .name = "a braced file-scope sizeof's two variable bounds' commas before its error",
        .source = "int a[(1, 2)] = { sizeof(int[(6, 2)][(8, 3)]) };\n",
        .warnings = 4,
        .errors = 1,
    },
    {
        .name = "a member's _Alignof's and sizeof's variable bounds' commas before its error",
        .source = "struct S { int m; } s = { _Alignof(int[(4, 2)]) + sizeof(int[(5, 2)]) };\n",
        .warnings = 2,
        .errors = 1,
    },
    {
        .name = "a designated file-scope sizeof's variable bound's comma before its error",
        .source = "int b[] = { 1, [2] = sizeof(int[(6, 2)]) };\n",
        .warnings = 1,
        .errors = 1,
    },
    {
        .name = "a block's static sizeof's error before its body's queued commas",
        .source = check_driver_vla_static_commas_source,
        .warnings = 4,
        .errors = 1,
        .notes = 2,
    },
    // A file-scope sizeof's comma in a later declarator's initializer, or before a later declarator, whose initializer's
    // error is at its own `,` or `;` (#2252, check_driver_initializer_last).
    {
        .name = "a second declarator's sizeof's variable bound's comma before its error",
        .source = "int b = 1, c = sizeof(int[(6, 2)]);\n",
        .warnings = 1,
        .errors = 1,
    },
    {
        .name = "a middle declarator's sizeof's variable bound's comma before its error",
        .source = "int b = 1, c = sizeof(int[(6, 2)]), d = 2;\n",
        .warnings = 1,
        .errors = 1,
    },
    {
        .name = "a first declarator's sizeof's variable bound's comma before its error",
        .source = "int b = sizeof(int[(6, 2)]), c = 1;\n",
        .warnings = 1,
        .errors = 1,
    },
    {
        .name = "a body's constants' commas before what their full expressions queue as they complete",
        .source = check_driver_vla_body_completions_source,
        .warnings = 20,
        .notes = 5,
    },
    {
        .name = "a body's constants' commas in statement expressions, operators' operands and a for statement's clauses",
        .source = check_driver_vla_body_nested_source,
        .warnings = 25,
        .notes = 9,
    },
    {
        .name = "what building a body's operators queues before a later constant's comma",
        .source = check_driver_vla_body_operators_source,
        .warnings = 12,
        .errors = 1,
        .notes = 1,
    },
    {
        .name = "a body's comparisons' constant warnings after a constant's comma they hold",
        .source = check_driver_vla_body_comparison_queue_source,
        .warnings = 6,
        .notes = 1,
    },
    {
        .name = "a body's comparisons' sign warnings after a constant's comma they hold",
        .source = check_driver_vla_body_comparison_queue_source,
        .options = { "-Wsign-compare" },
        .warnings = 7,
        .notes = 1,
    },
    {
        .name = "an x86 builtin's range error after a constant's comma in its argument",
        .source = check_driver_vla_body_builtin_source,
        .warnings = 2,
        .errors = 2,
    },
    {
        .name = "a body's members' and bit-fields' comparisons as commas' left operands at once",
        .source = check_driver_vla_body_member_comparisons_source,
        .warnings = 8,
        .notes = 2,
    },
    {
        .name = "a body's rejected static assertion's condition's comma among its queued diagnostics in source order",
        .source = check_driver_vla_body_assertion_condition_source,
        .warnings = 7,
        .errors = 1,
        .notes = 3,
    },
    {
        .name = "a body's rejected static assertion's arm's comma among its queued diagnostics in source order",
        .source = check_driver_vla_body_assertion_arm_source,
        .warnings = 7,
        .errors = 1,
        .notes = 3,
    },
    {
        .name = "constant bounds' comma operators' discarded left operands",
        .source = check_driver_vla_fold_commas_source,
        .warnings = 31,
    },
    {
        .name = "constant bounds' comma operators under -Wno-unused-value",
        .source = check_driver_vla_fold_commas_source,
        .options = { "-Wno-unused-value" },
        .warnings = 13,
    },
    {
        .name = "constant bounds' comma operators under -Wno-unused-value -Wunused-comparison",
        .source = check_driver_vla_fold_commas_source,
        .options = { "-Wno-unused-value", "-Wunused-comparison" },
        .warnings = 14,
    },
    {
        .name = "folded bounds in each context, by default",
        .source = check_driver_vla_fold_contexts_source,
        .warnings = 11,
        .errors = 2,
        .notes = 2,
    },
    {
        .name = "folded bounds in each context under -w",
        .source = check_driver_vla_fold_contexts_source,
        .options = { "-w" },
        .errors = 2,
        .notes = 2,
    },
    {
        .name = "folded bounds in each context under -Werror=gnu-folding-constant",
        .source = check_driver_vla_fold_contexts_source,
        .options = { "-Werror=gnu-folding-constant" },
        .errors = 18,
        .notes = 7,
    },
    {
        .name = "a declarator's folded bounds warn once, at its name",
        .source = check_driver_vla_fold_declarators_source,
        .warnings = 6,
    },
    {
        .name = "folds of casts, GNU object reads and string subscripts",
        .source = check_driver_vla_fold_forms_source,
        .warnings = 3,
    },
    {
        .name = "folded bounds under -Wno-gnu-folding-constant",
        .source = check_driver_vla_fold_forms_source,
        .options = { "-Wno-gnu-folding-constant" },
    },
    {
        .name = "a type name's folded-looking bound in a file-scope initializer stays variable",
        .source = check_driver_vla_place_source_0,
        .errors = 1,
    },
    {
        .name = "a file-scope bound that holds a variable type name",
        .source = check_driver_vla_place_source_1,
        .errors = 1,
    },
    {
        .name = "a block's static array whose bound holds a variable type name",
        .source = check_driver_vla_place_source_2,
        .warnings = 2,
        .errors = 1,
    },
    {
        .name = "a member whose bound holds a variable type name",
        .source = check_driver_vla_place_source_3,
        .errors = 1,
    },
    {
        .name = "a file-scope variable-length array",
        .source = check_driver_vla_place_source_4,
        .errors = 1,
    },
    {
        .name = "a file-scope variably modified pointer",
        .source = check_driver_vla_place_source_5,
        .errors = 1,
    },
    {
        .name = "a file-scope variable-length typedef",
        .source = check_driver_vla_place_source_6,
        .errors = 1,
    },
    {
        .name = "a list item's variable type name in a file-scope initializer",
        .source = check_driver_vla_place_source_7,
        .errors = 1,
    },
    {
        .name = "a block's extern variable-length array",
        .source = check_driver_vla_place_source_8,
        .errors = 1,
    },
    {
        .name = "a block's extern variably modified pointer",
        .source = check_driver_vla_place_source_9,
        .errors = 1,
    },
    {
        .name = "a block's static thread-local variable-length array",
        .source = check_driver_vla_place_source_10,
        .errors = 1,
    },
    {
        .name = "a block's record's variably modified member",
        .source = check_driver_vla_place_source_11,
        .errors = 1,
    },
    {
        .name = "a file-scope record's variable-length member",
        .source = check_driver_vla_place_source_12,
        .errors = 1,
    },
    {
        .name = "a parenthesized file-scope variable-length array",
        .source = check_driver_vla_place_source_13,
        .errors = 1,
    },
    {
        .name = "a nested parenthesized file-scope variable-length array",
        .source = check_driver_vla_place_source_14,
        .errors = 1,
    },
    {
        .name = "a parenthesized array of pointers at file scope, a variable-length array",
        .source = check_driver_vla_place_source_15,
        .errors = 1,
    },
    {
        .name = "a parenthesized pointer to a variable-length array at file scope, a variably modified type",
        .source = check_driver_vla_place_source_16,
        .errors = 1,
    },
    {
        .name = "a comma's discarded undefined behavior makes its bound variable",
        .source = check_driver_vla_discarded_undefined_source,
        .warnings = 24,
        .errors = 9,
    },
    {
        .name = "a file-scope sizeof's runtime-sized type name recovers",
        .source = check_driver_vla_sizeof_recovery_source,
        .warnings = 7,
        .errors = 3,
    },
    {
        .name = "compound literals' bounds fold, in a body too",
        .source = check_driver_vla_compound_fold_source,
        .warnings = 8,
    },
};
static const size_t fixture_56_lengths[] = {
sizeof(check_driver_vla_cast_source)-1,
sizeof(check_driver_vla_misplaced_source)-1,
sizeof(check_driver_vla_compound_source)-1,
sizeof(check_driver_vla_unevaluated_source)-1,
sizeof(check_driver_vla_pointer_size_source)-1,
sizeof(check_driver_vla_pointer_size_error_source)-1,
sizeof("int n; unsigned long x=sizeof(int[sizeof(int[n])]);\n")-1,
sizeof("unsigned long x=sizeof(sizeof(int[1.5]));\n")-1,
sizeof(check_driver_vla_initializer_source)-1,
sizeof(check_driver_vla_variable_commas_source)-1,
sizeof(check_driver_vla_body_commas_source)-1,
sizeof(check_driver_vla_body_comparisons_source)-1,
sizeof("int x;\nint b = sizeof(int[(6, 2)]);\n")-1,
sizeof("int a[(1, 2)] = { sizeof(int[(6, 2)][(8, 3)]) };\n")-1,
sizeof("struct S { int m; } s = { _Alignof(int[(4, 2)]) + sizeof(int[(5, 2)]) };\n")-1,
sizeof("int b[] = { 1, [2] = sizeof(int[(6, 2)]) };\n")-1,
sizeof(check_driver_vla_static_commas_source)-1,
sizeof("int b = 1, c = sizeof(int[(6, 2)]);\n")-1,
sizeof("int b = 1, c = sizeof(int[(6, 2)]), d = 2;\n")-1,
sizeof("int b = sizeof(int[(6, 2)]), c = 1;\n")-1,
sizeof(check_driver_vla_body_completions_source)-1,
sizeof(check_driver_vla_body_nested_source)-1,
sizeof(check_driver_vla_body_operators_source)-1,
sizeof(check_driver_vla_body_comparison_queue_source)-1,
sizeof(check_driver_vla_body_comparison_queue_source)-1,
sizeof(check_driver_vla_body_builtin_source)-1,
sizeof(check_driver_vla_body_member_comparisons_source)-1,
sizeof(check_driver_vla_body_assertion_condition_source)-1,
sizeof(check_driver_vla_body_assertion_arm_source)-1,
sizeof(check_driver_vla_fold_commas_source)-1,
sizeof(check_driver_vla_fold_commas_source)-1,
sizeof(check_driver_vla_fold_commas_source)-1,
sizeof(check_driver_vla_fold_contexts_source)-1,
sizeof(check_driver_vla_fold_contexts_source)-1,
sizeof(check_driver_vla_fold_contexts_source)-1,
sizeof(check_driver_vla_fold_declarators_source)-1,
sizeof(check_driver_vla_fold_forms_source)-1,
sizeof(check_driver_vla_fold_forms_source)-1,
sizeof(check_driver_vla_place_source_0)-1,
sizeof(check_driver_vla_place_source_1)-1,
sizeof(check_driver_vla_place_source_2)-1,
sizeof(check_driver_vla_place_source_3)-1,
sizeof(check_driver_vla_place_source_4)-1,
sizeof(check_driver_vla_place_source_5)-1,
sizeof(check_driver_vla_place_source_6)-1,
sizeof(check_driver_vla_place_source_7)-1,
sizeof(check_driver_vla_place_source_8)-1,
sizeof(check_driver_vla_place_source_9)-1,
sizeof(check_driver_vla_place_source_10)-1,
sizeof(check_driver_vla_place_source_11)-1,
sizeof(check_driver_vla_place_source_12)-1,
sizeof(check_driver_vla_place_source_13)-1,
sizeof(check_driver_vla_place_source_14)-1,
sizeof(check_driver_vla_place_source_15)-1,
sizeof(check_driver_vla_place_source_16)-1,
sizeof(check_driver_vla_discarded_undefined_source)-1,
sizeof(check_driver_vla_sizeof_recovery_source)-1,
sizeof(check_driver_vla_compound_fold_source)-1
};
static const char check_driver_format_plain_source[] =
    "typedef struct _IO_FILE FILE;\n"
    "int printf(const char*,...);\nint fprintf(FILE*,const char*,...);\n"
    "int sprintf(char*,const char*,...);\nint snprintf(char*,unsigned long,const char*,...);\n"
    "void f(FILE*p,char*b){printf(\"%d\",\"str\");fprintf(p,\"%d\",\"str\");"
    "sprintf(b,\"%d\",\"str\");snprintf(b,16,\"%d\",\"str\");snprintf(b,16,\"%s.mo\\0\",\"x\");}\n";
static const char check_driver_feature_tested_attributes_source[] =
    "#if __has_attribute(format)\n"
    "#define PRINTF_LIKE(f, a) __attribute__((format(printf, f, a)))\n"
    "#else\n"
    "#define PRINTF_LIKE(f, a)\n"
    "#endif\n"
    "#if __has_attribute(__warn_unused_result__)\n"
    "#define MUST_USE __attribute__((warn_unused_result))\n"
    "#else\n"
    "#define MUST_USE\n"
    "#endif\n"
    "#if __has_attribute(deprecated) && __has_extension(attribute_deprecated_with_message)\n"
    "#define OLD(m) __attribute__((deprecated(m)))\n"
    "#elif __has_attribute(deprecated)\n"
    "#define OLD(m) __attribute__((deprecated))\n"
    "#else\n"
    "#define OLD(m)\n"
    "#endif\n"
    "#if __has_attribute(const) && __has_attribute(pure)\n"
    "#define CONST __attribute__((const))\n"
    "#define PURE __attribute__((pure))\n"
    "#else\n"
    "#define CONST\n"
    "#define PURE\n"
    "#endif\n"
    "#if __has_attribute(noreturn)\n"
    "#define NORETURN __attribute__((noreturn))\n"
    "#else\n"
    "#define NORETURN\n"
    "#endif\n"
    "#if __has_attribute(unused)\n"
    "#define MAYBE __attribute__((unused))\n"
    "#else\n"
    "#define MAYBE\n"
    "#endif\n"
    "int log_line(const char*, ...) PRINTF_LIKE(1, 2);\n"
    "MUST_USE int take(int);\n"
    "OLD(\"use take\") int give(int);\n"
    "CONST int square(int);\n"
    "PURE int peek(const int*);\n"
    "NORETURN void die(void);\n"
    "static int helper MAYBE;\n"
    "int f(int n, const int* p)\n"
    "{\n"
    "    log_line(\"%d\", 1.5);\n"
    "    take(n);\n"
    "    square(n);\n"
    "    peek(p);\n"
    "    if (n)\n"
    "        return give(n);\n"
    "    die();\n"
    "}\n";
static const char check_driver_format_attributed_source[] =
    "int printf(const char*,...)__attribute__((format(printf,1,2)));\nint printf(const char*,...);\n"
    "int snprintf(char*,unsigned long,const char*,...);\n"
    "int snprintf(char*,unsigned long,const char*,...)__attribute__((format(printf,3,4)));\n"
    "int trace(int,const char*,...)__attribute__((format(printf,2,3)));\n"
    "void f(char*b){printf(\"%d\",\"str\");snprintf(b,16,\"%d\",\"str\");trace(0,\"%d\",\"str\");}\n";
static const char check_driver_gnu_designator_source[] =
    "struct P { int a, b; };\n"
    "struct P p = { b: 1, a: 2 };\n"
    "int g[4] = { [1 ... 2] = 3 };\n"
    "int h[4] = { [1 ... 2] 3, [3] 4 };\n"
    "struct P q[2] = { [1] { 1, 2 }, [0].a = 3, [0] .b = 4 };\n"
    "int n[] = { [4] 1 };\n"
    "int f(void)\n"
    "{\n"
    "    int e[3] = { [0] 2, 1, [2] 5.5 };\n"
    "    struct P r = { a: 1.5 };\n"
    "#pragma clang diagnostic push\n"
    "#pragma clang diagnostic ignored \"-Wgnu-designator\"\n"
    "    int s[2] = { [1] 1 };\n"
    "#pragma clang diagnostic pop\n"
    "    return e[0] + r.a + s[1];\n"
    "}\n";
static const char check_driver_atomic_access_source[] =
    "struct A { int x; int y; };\n"
    "_Atomic struct A a1;\n"
    "_Atomic(struct A) *pa;\n"
    "int f(void) { return a1.x + pa->y; }\n"
    "int g(void) { return sizeof(a1.x); }\n"
    "void h(void) { a1.y = 3; int q = undeclared; (void)q; }\n"
    "int k(void) { return (&a1)->x; }\n"
    "int u = sizeof(pa->x);\n";
static const char check_driver_atomic_access_valid_source[] =
    "struct A { int x; int y; };\n"
    "union U { int x; double d; };\n"
    "_Atomic(struct A) a;\n_Atomic(struct A) *p;\n_Atomic(union U) u;\n"
    "_Atomic(struct A *) ordinary_pointer;\n"
    "_Atomic(struct A) array[1];\n"
    "extern _Atomic(struct A) incomplete[];\n"
    "const _Atomic(struct A) fixed;\n"
    "int f(void) { return a.x + p->y + u.x; }\n"
    "void g(void) { a.y = 3; fixed.x = 2; }\n"
    "int pointer(void) { return ordinary_pointer->x; }\n"
    "int decayed(void) { return array->x; }\n"
    "int incomplete_decay(void) { return incomplete->x; }\n"
    "int size = sizeof(a.x);\n"
    "int bound[sizeof(p->x)];\n"
    "typedef __typeof__(p->x) Member;\n"
    "_Static_assert(__builtin_types_compatible_p(Member, int), \"member type\");\n";
static const CheckDriverDefaultWarningFixture fixture_57[] =
{
    {
        .name = "attributes chosen by __has_attribute",
        .source = check_driver_feature_tested_attributes_source,
        .warnings = 5,
        .notes = 2,
    },
    {
        .name = "attributes chosen by __has_attribute under -Wall -Wextra",
        .source = check_driver_feature_tested_attributes_source,
        .options = { "-Wall", "-Wextra" },
        .warnings = 5,
        .notes = 2,
    },
    {
        .name = "atomic record accesses default to errors after the body's structural errors",
        .source = check_driver_atomic_access_source,
        .errors = 5,
        .syntax_only = true,
    },
    {
        .name = "C23 atomic record accesses default to deferred errors",
        .source = check_driver_atomic_access_source,
        .errors = 5,
        .c23 = true,
        .syntax_only = true,
    },
    {
        .name = "atomic record accesses can be demoted independently of structural errors",
        .source = check_driver_atomic_access_source,
        .options = { "-Wno-error=atomic-access" },
        .warnings = 4,
        .errors = 1,
        .syntax_only = true,
    },
    {
        .name = "atomic record warning suppression keeps structural recovery",
        .source = check_driver_atomic_access_source,
        .options = { "-Wno-atomic-access" },
        .errors = 1,
        .syntax_only = true,
    },
    {
        .name = "demoted atomic struct and union accesses retain their member types and compile",
        .source = check_driver_atomic_access_valid_source,
        .options = { "-Wno-error=atomic-access" },
        .warnings = 7,
    },
    {
        .name = "suppressed atomic accesses retain member types in code and unevaluated queries",
        .source = check_driver_atomic_access_valid_source,
        .options = { "-Wno-atomic-access" },
    },
    {
        .name = "atomic member errors follow a file initializer's own constant error",
        .source = "struct A { int x; };\n_Atomic(struct A) a;\nint use = a.x;\n",
        .errors = 2,
        .syntax_only = true,
    },
    {
        .name = "an atomic member's constant address still queues its runtime diagnostic",
        .source = "struct A { int x; };\n_Atomic(struct A) a;\nint *p = &a.x;\n",
        .errors = 1,
        .syntax_only = true,
    },
    {
        .name = "atomic member lookup errors name the underlying record before the atomic diagnostic",
        .source = "struct A { int x; };\n_Atomic(struct A) a;\nint f(void) { return a.missing; }\n",
        .errors = 2,
        .syntax_only = true,
    },
    {
        .name = "nested ordinary members do not repeat an enclosing atomic access diagnostic",
        .source = "struct B { int x; };\nstruct A { struct B b; };\n_Atomic(struct A) a;\n"
                  "_Atomic(union U { int x; double d; }) u;\nint f(void) { return a.b.x + u.x; }\n",
        .errors = 2,
        .syntax_only = true,
    },
    {
        .name = "atomic member diagnostics follow runtime reachability",
        .source = "struct A { int x; };\n_Atomic(struct A) a;\n_Atomic(struct A) *p;\n"
                  "int f(int n) { if (0) return a.x; if (n) return p->x; return 0; a.x = 1; }\n"
                  "int g(void) { return 0 && a.x; }\nint h(void) { return 1 ? 0 : p->x; }\n",
        .errors = 3,
        .syntax_only = true,
    },
    {
        .name = "demoted atomic diagnostics retain CFG reachability in later bodies",
        .source = "struct A { int x; };\n_Atomic(struct A) a;\n_Atomic(struct A) *p;\n"
                  "int f(int n) { if (0) return a.x; if (n) return p->x; return 0; a.x = 1; }\n"
                  "int g(void) { return 0 && a.x; }\nint h(void) { return 1 ? 0 : p->x; }\n",
        .options = { "-Wno-error=atomic-access" },
        .warnings = 1,
        .syntax_only = true,
    },
    {
        .name = "a structural error flushes unreachable atomic member diagnostics",
        .source = "struct A { int x; };\n_Atomic(struct A) a;\n"
                  "void f(void) { if (0) a.x = 0; int q = undeclared; (void)q; }\n",
        .errors = 2,
        .syntax_only = true,
    },
    {
        .name = "atomic member diagnostic pragmas preserve ignored warning and error mappings",
        .source = "struct A { int x; };\n_Atomic(struct A) a;\n"
                  "#pragma clang diagnostic push\n#pragma clang diagnostic ignored \"-Watomic-access\"\n"
                  "int ignored(void) { return a.x; }\n#pragma clang diagnostic pop\n"
                  "#pragma clang diagnostic warning \"-Watomic-access\"\nint warning(void) { return a.x; }\n"
                  "#pragma clang diagnostic error \"-Watomic-access\"\nint error(void) { return a.x; }\n",
        .warnings = 1,
        .errors = 1,
        .syntax_only = true,
    },
    {
        .name = "quiet bodies skip their atomic queue while global addresses retain the default error",
        .source = "struct A { int x; };\n_Atomic(struct A) a;\n"
                  "int f(void) { return a.x; }\nint *p = &a.x;\n",
        .options = { "-w" },
        .errors = 1,
        .syntax_only = true,
    },
    {
        .name = "a quiet source error pragma re-enables a global atomic access but not a valid body's queue",
        .source = "struct A { int x; };\n_Atomic(struct A) a;\n"
                  "#pragma clang diagnostic error \"-Watomic-access\"\n"
                  "int f(void) { return a.x; }\nint *p = &a.x;\n",
        .options = { "-w", "-Wno-atomic-access" },
        .errors = 1,
        .syntax_only = true,
    },
    {
        .name = "a global atomic error flushes a later quiet body's queued accesses",
        .source = "struct A { int x; };\n_Atomic(struct A) a;\nint *p = &a.x;\n"
                  "int f(void) { return 0 && a.x; }\n",
        .options = { "-w" },
        .errors = 2,
        .syntax_only = true,
    },
    {
        .name = "a prior common semantic error flushes a later atomic queue",
        .source = "struct A { int x; };\n_Atomic(struct A) a;\n"
                  "int f(int x, int y, int z) { return x < y < z; }\n"
                  "int g(void) { return 0 && a.x; }\n",
        .errors = 2,
        .syntax_only = true,
    },
    {
        // A failed static assertion's requirement and its operands' values (#1447, check_semantic_assert): the first
        // false term of a conjunction, literals printed as clang's StmtPrinter prints them (`2147483648U`, `'\x00'`,
        // `2.`, `1.0E+10`), `sizeof (x)`, `__alignof`, and the "expression evaluates to" note where an operand isn't
        // obvious, a plain char's value as `'<0xC8>' (0xC8, -56)`, floats at APFloat's default precision.
        .name = "static assertion requirements and their values",
        .source = "enum { A = 3 };\n"
                  "_Static_assert(A == 4, \"a\");\n"
                  "_Static_assert(1 && A > 2 && (A < 3 || A > 5), \"b\");\n"
                  "_Static_assert(-A == 4 && 1, \"c\");\n"
                  "_Static_assert('a' == A, \"d\");\n"
                  "_Static_assert(1.5 + A < 2.0, \"e\");\n"
                  "_Static_assert((_Bool)A == 0, \"f\");\n"
                  "_Static_assert(A + 0u > 5u, \"g\");\n"
                  "_Static_assert((char)A == 'b', \"h\");\n"
                  "_Static_assert((char)200 == (char)'\\n', \"i\");\n"
                  "_Static_assert(A < 1 == 1, \"j\");\n"
                  "_Static_assert(A - 3, \"k\");\n"
                  "_Static_assert(0x80000000 == A + 3000000000, \"l\");\n"
                  "_Static_assert(1e300 * A == 0.1f, \"m\");\n"
                  "_Static_assert(1e-5 * A == 1e5, \"n\");\n"
                  "_Static_assert(sizeof A == sizeof (A) + sizeof(int), \"o\");\n"
                  "_Static_assert(__alignof__(A) == 2 * _Alignof(int), \"p\");\n",
        .errors = 16,
        .notes = 14,
    },
    {
        // (Apart, as clang stops at 20 errors.)
        .name = "static assertion requirements and their values, literals and conjunctions",
        .source = "enum { A = 3 };\n"
                  "_Static_assert('\\0' == 1 && 0, \"q\");\n"
                  "_Static_assert((0), \"r\");\n"
                  "_Static_assert(1 && (0), \"s\");\n"
                  "_Static_assert(0 && 2 == 3, \"t\");\n"
                  "_Static_assert(L'\\x263a' + u'x' == 1, \"u\");\n"
                  "_Static_assert(-0.0 == 1.0L, \"v\");\n"
                  "_Static_assert((A & 1) == 0 && (A | 4) == 3, \"w\");\n"
                  "_Static_assert((A << 2) == (A >> 1), \"x\");\n"
                  "_Static_assert(A == 3 ? 0 : 1, \"y\");\n"
                  "_Static_assert(!A, \"z\");\n"
                  "void f(void) { _Static_assert(A * 1000000 == 4, \"block\"); }\n",
        .errors = 11,
        .notes = 4,
    },
    {
        .name = "static assertion requirements and their values in C23",
        .source = "enum { A = 3 };\n"
                  "_Static_assert((bool)A == false, \"a\");\n"
                  "_Static_assert((_Bool)A == 0, \"b\");\n"
                  "_Static_assert(1wb + A == 2uwb, \"c\");\n"
                  "_Static_assert(1'000 * A == 18446744073709551615u, \"d\");\n"
                  "_Static_assert(alignof(int) == sizeof 1 + 1, \"e\");\n"
                  "_Static_assert(true && A == 4, \"f\");\n"
                  "_Static_assert(u8'a' == 1.0e10, \"g\");\n"
                  "_Static_assert((float)A / 3 == 2, \"h\");\n"
                  "_Static_assert(false, \"i\");\n",
        .errors = 9,
        .notes = 6,
        .c23 = true,
    },
    {
        // A statement expression's statements are evaluated as it is (#1447, check_common_statement_roots): a
        // short-circuited operand's, a constant conditional's other arm's, a constant if's and unreachable code's give
        // none of their runtime or unused-value warnings, as clang's CFG leaves their blocks unreachable.
        .name = "statements of unevaluated statement expressions",
        .source = "int g(int);\n"
                  "int f(int x)\n"
                  "{\n"
                  "    int r = 0;\n"
                  "    r += 0 && ({ x << 40; 1; });\n"
                  "    r += 1 || ({ 1 / 0; 1; });\n"
                  "    r += 0 ? ({ x << 33; 1; }) : 2;\n"
                  "    if (0) { r += ({ x << 34; 1; }); }\n"
                  "    return r;\n"
                  "    r += ({ x << 35; 1; });\n"
                  "}\n",
        .options = { "-Wall", "-Wextra" },
    },
    {
        // A body with statement expressions keeps its unreachable-code proof (#1447, check_common_unreachable).
        .name = "unreachable code in a body with statement expressions",
        .source = "int f(int x)\n"
                  "{\n"
                  "    int r = 0;\n"
                  "    return r;\n"
                  "    r += x << 35;\n"
                  "    x << 36;\n"
                  "    r += ({ x << 37; 1; });\n"
                  "    ({ x << 38; 1; });\n"
                  "}\n",
        .options = { "-Wall", "-Wextra" },
    },
    {
        .name = "reachable statement expressions, jumps out of them and returns inside them",
        .source = "int g(int);\n"
                  "int f(int x, int y)\n"
                  "{\n"
                  "    int r = ({ x << 40; 1; });\n"
                  "    r += y ? ({ x << 41; 2; }) : ({ x << 42; 3; });\n"
                  "    r += 1 && ({ x / 0; 1; });\n"
                  "    r += ({ if (x) goto out; 0; });\n"
                  "    r += ({ int k = ({ x << 43; 4; }); k; });\n"
                  "    for (;;) { r += ({ x << 44; 1; }); if (r) break; }\n"
                  "    while (1) { }\n"
                  "    r += ({ x << 45; 1; });\n"
                  "out:\n"
                  "    r += ({ x << 46; 1; });\n"
                  "    r += 0 && ({ int u; u + ({ x << 47; 1; }); });\n"
                  "    return r;\n"
                  "}\n"
                  "int h(int x)\n"
                  "{\n"
                  "    int r = ({ if (x) return 1; x << 48; 2; });\n"
                  "    r += ({ return 2; x << 49; 3; });\n"
                  "    return r;\n"
                  "}\n",
        .options = { "-Wall", "-Wextra" },
        .warnings = 16,
    },
    {
        .name = "-Wuninitialized in unevaluated statement expressions",
        .source = "int g(int);\n"
                  "int f(int x)\n"
                  "{\n"
                  "    int u;\n"
                  "    int r = 0 && ({ u + 1; });\n"
                  "    r += 0 ? ({ g(u); }) : 1;\n"
                  "    int v;\n"
                  "    r += ({ v; });\n"
                  "    return r;\n"
                  "    ({ int w; w; });\n"
                  "}\n",
        .options = { "-Wall", "-Wextra" },
        .warnings = 2,
        .notes = 1,
    },
    {
        // An enclosing construct's warning comes after the diagnostics its operands gave as clang built them (#1941): a
        // condition's -Wparentheses at its `)` or `;`, a call's -Wformat from its `)`, a bitwise operator's precedence and a
        // logical not's at their right operand's end; a statement expression's and a nested call's warnings first. A call
        // argument's -Wformat is at its callee.
        .name = "enclosing warnings follow their operands' diagnostics",
        .source = "int printf(const char *, ...);\n"
                  "int f(int x)\n"
                  "{\n"
                  "    if (x = ({ printf(\"%s\", 1); x; })) return 1;\n"
                  "    if (x = printf(\"%s\", 2)) return 1;\n"
                  "    while (x = ({ printf(\"%s\", 3); x; })) {}\n"
                  "    for (; x = ({ printf(\"%d\", \"v\"); 1; }); ) {}\n"
                  "    do {} while (x = ({ printf(\"%d\", \"w\"); 1; }));\n"
                  "    printf(\"%s\", ({ printf(\"%d\", \"s\"); 1; }));\n"
                  "    printf(\"%s\", printf(\"%d\", \"t\"));\n"
                  "    int a = x & ({ printf(\"%d\", \"u\"); 1; }) == 2;\n"
                  "    int b = !x == ({ printf(\"%d\", \"y\"); 1; });\n"
                  "    (void)a; (void)b;\n"
                  "    return (x = 1) ? printf(\"%s\", 4) : 0;\n"
                  "}\n",
        .options = { "-Wall" },
        .warnings = 19,
        .notes = 14,
    },
    {
        .name = "enclosing warnings follow their operands' diagnostics in C23 under -Wextra",
        .source = "int printf(const char *, ...);\n"
                  "int f(int x)\n"
                  "{\n"
                  "    if (x = ({ printf(\"%s\", 1); x; })) return 1;\n"
                  "    if (x = printf(\"%s\", 2)) return 1;\n"
                  "    while (x = ({ printf(\"%s\", 3); x; })) {}\n"
                  "    for (; x = ({ printf(\"%d\", \"v\"); 1; }); ) {}\n"
                  "    do {} while (x = ({ printf(\"%d\", \"w\"); 1; }));\n"
                  "    printf(\"%s\", ({ printf(\"%d\", \"s\"); 1; }));\n"
                  "    printf(\"%s\", printf(\"%d\", \"t\"));\n"
                  "    int a = x & ({ printf(\"%d\", \"u\"); 1; }) == 2;\n"
                  "    int b = !x == ({ printf(\"%d\", \"y\"); 1; });\n"
                  "    (void)a; (void)b;\n"
                  "    return (x = 1) ? printf(\"%s\", 4) : 0;\n"
                  "}\n",
        .options = { "-Wall", "-Wextra" },
        .warnings = 19,
        .notes = 14,
        .c23 = true,
    },
    {
        // Clang's DiagRuntimeBehavior drops a runtime warning in an array bound (ConstantEvaluated), a variable array's
        // too, and in an unevaluated operand's statement expression: shift counts, divisions, sign comparisons, constant
        // conversions and array indexes; a comma's unused value stays (#1447, check_common_bound).
        .name = "runtime warnings in array bounds and unevaluated statement expressions",
        .source = "int g(void) __attribute__((warn_unused_result));\n"
                  "void f(int n, unsigned u) {\n"
                  "    int b[n + (1 << 40)];\n"
                  "    int c[n + 1 / 0];\n"
                  "    int d[n + (u < -1)];\n"
                  "    char cc = 0;\n"
                  "    int e[n + (cc = 300)];\n"
                  "    int h[n + (n, 1)];\n"
                  "    int a2[3]; int k[n + a2[5]];\n"
                  "    int s[n + sizeof(1 << 41)];\n"
                  "    int t = sizeof(int[n + (1 << 45)]);\n"
                  "    int v = (int)sizeof(({ int w = 1 << 46; w; })) + (int)sizeof(({ 1 << 47; }));\n"
                  "    int x = (1 << 48) + 1 / 0;\n"
                  "    (void)b; (void)c; (void)d; (void)e; (void)h; (void)k; (void)s; (void)t; (void)v; (void)x;\n"
                  "}\n",
        .options = { "-Wall", "-Wextra" },
        .warnings = 3,
    },
    {
        .name = "runtime warnings in array bounds and unevaluated statement expressions in C23",
        .source = "int g(void) __attribute__((warn_unused_result));\n"
                  "void f(int n, unsigned u) {\n"
                  "    int b[n + (1 << 40)];\n"
                  "    int c[n + 1 / 0];\n"
                  "    int d[n + (u < -1)];\n"
                  "    char cc = 0;\n"
                  "    int e[n + (cc = 300)];\n"
                  "    int h[n + (n, 1)];\n"
                  "    int a2[3]; int k[n + a2[5]];\n"
                  "    int s[n + sizeof(1 << 41)];\n"
                  "    int t = sizeof(int[n + (1 << 45)]);\n"
                  "    int v = (int)sizeof(({ int w = 1 << 46; w; })) + (int)sizeof(({ 1 << 47; }));\n"
                  "    int x = (1 << 48) + 1 / 0;\n"
                  "    (void)b; (void)c; (void)d; (void)e; (void)h; (void)k; (void)s; (void)t; (void)v; (void)x;\n"
                  "}\n",
        .warnings = 3,
        .c23 = true,
    },
    {
        .name = "return flow conservative no-fallthrough and reachable fallthrough",
        .source = "int a(int c){if(c)return 1;return 2;}int b(int c){if(c)return 1;}int d(void){while(1){}}_Noreturn void r(void){while(1){}}\n",
        .warnings = 1,
    },
    {
        .name = "floating literal file and local initializers",
        .source = "int a=1.5;\nint f(void){int b=2.5;return b;}\n",
        .warnings = 2,
    },
    {
        // An enumeration or an _Atomic target takes neither -Wliteral-conversion nor -Wconstant-conversion in clang (#1447,
        // review on #1453): only a builtin type, qualified or not, does.
        .name = "conversion warnings skip enumeration and atomic targets",
        .source = "enum E { A, B };\nvoid arg(enum E);\nvoid argi(int);\nenum E fret(void) { return 3.5; }\n_Atomic int gy = 7.5;\n"
                  "_Atomic char gc = 300;\nvoid f(void) {\n  int x = 1.5; enum E e = 2.5; _Atomic int y = 3.5; _Atomic char z = 4.5;\n"
                  "  arg(4.5); argi(4.5); e = 5.5; y = 6.5; const int c = 8.5; volatile int v = 9.5;\n"
                  "  _Bool b = 0.5; _Atomic _Bool ab = 0.5; enum E e2 = 300; _Atomic char k = 300; char d = 300; z = 500;\n"
                  "  (void)x; (void)e; (void)y; (void)z; (void)c; (void)v; (void)b; (void)ab; (void)e2; (void)k; (void)d;\n}\n",
        .warnings = 6,
    },
    {
        // A brace element's destination is _Atomic by its declared type, which its plan part records stripped (#1447).
        .name = "conversion warnings skip atomic initializer elements",
        .source = "_Atomic char ga[1] = { 1.5 };\nstruct S { _Atomic char c; int i; };\nstruct S gs = { 1.5, 2.5 };\nvoid f(void) {\n"
                  "  _Atomic char a[2] = { 1.5, 2 };\n  struct S s = { 3.5, 4.5 };\n  struct { _Atomic int x; double d; } t = { .x = 5.5, .d = 1 };\n"
                  "  (void)a; (void)s; (void)t;\n}\n",
        .warnings = 2,
    },
    {
        // A return's or a prototype argument's _Atomic destination too, for either warning, beside the int, char and
        // plain parameter ones that still warn (review on #1453).
        .name = "conversion warnings skip atomic returns and arguments",
        .source = "_Atomic int f(void) { return 3.5; }\n_Atomic int gpar(_Atomic int);\nvoid h(void) { gpar(3.5); }\n"
                  "_Atomic char g(void) { return 300; }\nvoid gc(_Atomic char);\nvoid kc(void) { gc(300); }\n"
                  "struct S { int i; _Atomic int m; };\nvoid k(void) { struct S t; t.m = 3.5; t.m = 5000000000LL; (void)t; }\n"
                  "int fi(void) { return 2.5; }\nvoid pi(int);\nvoid hp(void) { pi(2.5); }\nchar fc(void) { return 300; }\n",
        .warnings = 3,
    },
    {
        // An enumeration takes -Wconstant-conversion by its integer type's range, though not -Wliteral-conversion, in
        // every position (review on #1453). (A brace element takes neither yet: #1759.)
        .name = "constant conversions to enumerations",
        .source = "enum Small : signed char { X };\nenum Small e = 300;\nenum Small rs(void) { return 300; }\n"
                  "void ca(enum Small);\nvoid cc(void) { ca(300); }\n"
                  "void as(void) { enum Small s; s = 300; (void)s; }\nenum FB : _Bool { FA };\nenum FB fb = 2;\n"
                  "enum E { A, B };\nenum E ee = 5000000000LL;\nenum Small lit = 2.5;\n",
        .warnings = 6,
        .c23 = true,
    },
    {
        // An assignment's or an increment's value is no constant to clang's evaluator (#1447), in a list's element too
        // (`{ y = 300 }`), but a comma's right operand is.
        .name = "no constant conversion of an assignment's value",
        .source = "void g(void) { int y; char c = y = 1000; char d[1] = { y = 300 }; unsigned char u = (y += 1, 300); char e = y++; "
                  "char f = (y = 1, 400); _Bool b = (y = 2); float fl = (y = 16777217); "
                  "(void)c; (void)d; (void)u; (void)e; (void)f; (void)b; (void)fl; }\n",
        .warnings = 2,
    },
    {
        // -Wunreachable-code-generic-assoc (#1447): an association of array type or a qualified one (an address space's,
        // restrict, a typedef's const spelled as its typedef), at its type's first token past the qualifiers, at file
        // scope and in a body, in sizeof's operand too; not _Atomic.
        .name = "generic associations never selected",
        .source = "typedef const int CI;\n"
                  "void g(void) { int x; int b[2];\n"
                  "int c = _Generic(b, int[2]: 1, default: 2);\nint d = _Generic(x, _Atomic int: 1, default: 2);\n"
                  "int e = _Generic(x, int const: 1, volatile long: 3, default: 2);\nint f = _Generic(x, CI: 1, default: 2);\n"
                  "int h = _Generic(&x, int * __attribute__((address_space(1))): 1, int * restrict: 4, default: 2);\n"
                  "int i = sizeof(_Generic(x, const char: 1, default: 2));\n"
                  "(void)c; (void)d; (void)e; (void)f; (void)h; (void)i; }\n"
                  "int k = _Generic(1, const int: 1, int[3]: 2, default: 0);\n",
        .warnings = 9,
    },
    {
        .name = "generic associations never selected, without -Wunreachable-code",
        .source = "void g(void) { int x; int b[2]; int c = _Generic(b, int[2]: 1, const int: 3, default: 2); (void)c; (void)x; }\n",
        .options = { "-Wno-unreachable-code" },
    },
    {
        // An association's type name is read as a cast's (#1447): objc_gc's qualifier, which the warning names, and
        // objc_ownership's warning on a type it doesn't apply to.
        .name = "attributes in generic association types",
        .source = "void g(void) { int x;\nint a = _Generic(x, const int: 1, default: 2);\n"
                  "int c = _Generic(&x, int __attribute__((objc_gc(weak))) *: 1, default: 2);\n"
                  "int e = _Generic(&x, int __attribute__((objc_gc(strong))) *: 1, default: 2);\n"
                  "int f = _Generic(&x, int __attribute__((objc_ownership(weak))) *: 1, default: 2);\n"
                  "(void)a; (void)c; (void)e; (void)f; }\n",
        .warnings = 4,
    },
    {
        .name = "floating literal assignment return and call conversions",
        .source = "int f(void){int a;a=1.5;return -2.5;}\nvoid g(int);void h(void){g(3.5);}\n",
        .warnings = 3,
    },
    {
        // A truth context converts a floating literal to _Bool (#147): conditions, `!`, `&&`, `||` and a conditional's first
        // operand, in unreachable code and short-circuited operands too; never a conditional's arms, a comma's result or
        // sizeof's operand.
        .name = "floating literal truth contexts",
        .source = "int f(int x){if(0.25)x=1;while(0.5)break;for(;0.75;)break;do{}while(1.5);return (2.5&&x)+(x||-3.5)+!4.5+(5.5?x:1)+(1.0&&x)+(0.0||x);}\n"
                  "int g(int x){return (x?1.5:2.5)&&x;}int h(int x){return (x,1.5)&&x;}unsigned long k(int x){return sizeof(1.5&&x);}\n"
                  "int u(int x){if(0)return 6.5&&x;return 0&&7.5;}\n_Bool b=1.5;_Bool c(void){return 2.5;}\n",
        .warnings = 13,
    },
    {
        // A static assertion's condition is a truth context too, warned where clang's parser reads it: between a declaration's
        // initializer and a later statement's, at file scope, and in unreachable code.
        .name = "floating literal static assertions",
        .source = "int o(int x){int y=2.5;_Static_assert(1.5,\"\");_Static_assert(0.0==0,\"\");return y+(x&&3.5);}\n_Static_assert(-0.5,\"\");\n"
                  "_Static_assert(1.5&&2.5,\"\");int z(int x){if(0){_Static_assert(0.5,\"\");}return x;}\n",
        .warnings = 7,
    },
    {
        .name = "floating literal source formats",
        .source = "int a=1.1f;int b=1.1;int c=1.1L;\n",
        .warnings = 3,
    },
    {
        .name = "floating literal array and record initializer elements",
        .source = "int values[2]={1.5,2.5};\nstruct S{int n;}object={1.5};\n",
        .warnings = 3,
    },
    {
        .name = "floating literal local brace initializer order",
        .source = "int f(void){int a[2]={1.5,2.5};int b={3.5};return a[0]+b;}\n",
        .warnings = 3,
    },
    {
        .name = "floating literal scalar and aggregate declaration order",
        .source = "int f(void){int x=4.5;int a[2]={1.5,2.5};int y=3.5;return x+a[0]+y;}\n",
        .warnings = 4,
    },
    {
        .name = "floating literal range initializer conversions",
        .source = "int values[4]={[0 ... 3]=1.5};\n",
        .warnings = 4,
    },
    {
        .name = "floating literal decimal and hexadecimal spelling",
        .source = "int a=0.9999999999999999;int b=1e-30;int c=0x1.8p0;\n",
        .warnings = 3,
    },
    {
        .name = "floating literal adjacent integer precision",
        .source = "int a=1.9999999999999998;int b=1.0000000000000002;\n",
        .warnings = 2,
    },
    {
        .name = "floating literal call argument subtrees follow right to left conversion order",
        .source = "void f(int,int);int g(int);void h(void){f(g(1.5),2.5);f(3.5,g(4.5));f(5.5,6.5);}\n",
        .warnings = 6,
    },
    {
        .name = "floating literal nested call and comma conversions are emitted once",
        .source = "void f(int,int);int g(int);void h(void){f(g(1.5),g(2.5));f(3.5,4.5),f(5.5,6.5);}\n",
        .warnings = 6,
    },
    {
        .name = "binary operand calls visit literal conversions right to left",
        .source = "int f(int);int h(void){return f(1.5)+f(2.5);}\n",
        .warnings = 2,
    },
    {
        .name = "comma assignment conversions visit the right operand first",
        .source = "int h(void){int a,b;a=1.5,b=2.5;return a+b;}\n",
        .warnings = 2,
    },
    {
        // A brace initializer's or a compound literal's element is checked for -Warray-bounds only by an operator above
        // its subscript, as clang's CheckArrayAccess of the full expression sees the initializer list (#2252).
        .name = "brace elements' array bounds only under an operator",
        .source =
            "int a[2]; int fn(int);\n"
            "struct P { int x, y; };\n"
            "void f(int i) {\n"
            "  int x1[2] = { a[5], 0 };\n"
            "  int x2[2] = { (a[5]), 0 };\n"
            "  int x3[2] = { -a[5], 0 };\n"
            "  int x4[2] = { fn(a[5]), 0 };\n"
            "  int x5[2] = { a[5] ? 1 : 2, 0 };\n"
            "  int x6[2] = { (char)a[5], 0 };\n"
            "  int *x7[2] = { &a[5], 0 };\n"
            "  int x8[2] = { [1] = a[5] };\n"
            "  int x9[1][1] = { { a[5] } };\n"
            "  struct P x10 = { a[5], i };\n"
            "  int x11 = { a[5] };\n"
            "  int *x12 = (int[]){ a[5] };\n"
            "  int x13[2] = { a[i ? 5 : 6] };\n"
            "  int x14[2] = { a[5] , a[6] };\n"
            "  int x15[2] = { i, a[5] = 1 };\n"
            "  int x16[2] = { (i, a[5]) };\n"
            "  static int s = 0; (void)s;\n"
            "  (void)x1;(void)x2;(void)x3;(void)x4;(void)x5;(void)x6;(void)x7;(void)x8;(void)x9;(void)x10;(void)x11;(void)x12;(void)x13;(void)x14;(void)x15;(void)x16;\n"
            "}\n"
            "int g1[2] = { 0 };\n",
        .warnings = 5,
        .notes = 4,
    },
    {
        .name = "reverse conversions precede source ordered bounds and unused results",
        .source = "int f(int);void h(void){int a[1];(f(1.5)+a[2]),(f(2.5)+a[3]);}\n",
        .warnings = 6,
        .notes = 2,
    },
    {
        .name = "reverse conversions preserve each inner comma marker before its bounds warning",
        .source = "void f(int);void h(void){int a[1];(a[2],f(1.5)),(a[3],f(2.5));}\n",
        .warnings = 6,
        .notes = 2,
    },
    {
        .name = "comma integer call conversions follow the same reverse walk",
        .source = "short f(short);void h(void){f(65536),f(65537);}\n",
        .warnings = 2,
    },
    {
        .name = "brace initializer conversions precede nested call conversions",
        .source = "int f(int);int h(void){int a[2]={(f(1.5),2.5),(f(3.5),4.5)};return a[0];}\n",
        .warnings = 4,
    },
    {
        .name = "unreachable return and local initializer retain literal conversion warnings",
        .source = "int f(void){if(0)return 1.5;if(0){int a=2.5;(void)a;}return 0;}\n",
        .warnings = 2,
    },
    {
        .name = "unreachable call conversion precedes the later reachable conversion",
        .source = "void f(int);void h(void){if(0)f(1.5);f(2.5);}\n",
        .warnings = 2,
    },
    {
        .name = "unreachable literal conversions do not enable runtime warning families",
        .source = "int f(void){int a[1];if(0){int x=1.5;(void)x;1;a[2];return 1/0;}return 0;}\n",
        .warnings = 1,
    },
    {
        .name = "short-circuited and conditional call literals remain source checks",
        .source = "int g(int);int f(void){return 0&&g(1.5);}int h(void){return 1?0:g(2.5);}\n",
        .warnings = 2,
    },
    {
        .name = "conditional call arms retain literal conversions",
        .source = "int f(int); void h(int c){c ? f(1.5) : f(2.5);}\n",
        .warnings = 2,
    },
    {
        .name = "comma conditional arms do not acquire outer conversion",
        .source = "int side(void);void take(int);int f(int c){int x=c?(side(),2.5):3.0;x=c?3.0:(side(),2.5);take(c?(side(),2.5):3.0);return c?(side(),2.5):3.0;}\n",
        .options = { "-Werror=literal-conversion" },
        .c23 = true,
    },
    {
        .name = "nested comma and conditional comma results do not inherit literal conversion",
        .source = "int side(void);int f(int c){return (side(),(side(),2.5));}int g(int c){return (side(),(c?2.5:2.5));}\n",
        .options = { "-Werror=literal-conversion" },
        .c23 = true,
    },
    {
        .name = "integer conversion of comma results uses the whole result expression",
        .source = "int side(void);short f(int c){return (side(),(c?65536:65537));}short g(void){return (side(),(1?65536:65537));}short h(void){return (side(),(side(),65536));}short i(int c){return c?(side(),65536):65537;}\n",
        .warnings = 4,
    },
    {
        .name = "top level comma still receives outer conversion",
        .source = "int side(void);int f(void){return (side(),2.5);}\n",
        .warnings = 1,
    },
    {
        .name = "unevaluated sizeof and generic arms suppress literal conversions",
        .source = "int f(void){return sizeof((int){1.5})+_Generic(0,int:0,default:(int){2.5});}\n",
    },
    {
        .name = "conditional literal arms inherit initializer and return targets",
        .source = "int a=0?1.5:2.5;int b=1?3.5:4.5;int f(int c){return c?5.5:6.5;}\n",
        .warnings = 6,
    },
    {
        .name = "conditional brace initializer and unreachable argument targets",
        .source = "int a[1]={0?1.5:2.5};void f(int);void h(int c){if(0)f(c?3.5:4.5);}\n",
        .warnings = 4,
    },
    {
        .name = "conditional integer conversions retain selected-arm pruning",
        .source = "short a=0?65536:65537;short b=1?65538:65539;\n",
        .warnings = 2,
    },
    {
        .name = "nested integer argument conversions follow right to left order",
        .source = "void f(short,short);short g(short);void h(void){f(g(65536),65537);}\n",
        .warnings = 2,
    },
    {
        .name = "unreachable integer conversion families remain suppressed",
        .source = "void f(short);short g(void){if(0)return 65536;if(0){short a=65536;(void)a;}return 0;}"
                  "void h(void){if(0)f(65536);f(65537);}int i(void){return 0&&(f(65536),1);}int j(void){return 1?0:(f(65536),1);}\n",
        .warnings = 1,
    },
    {
        // An unreachable initializer's barriers outlive its body's scratch (#1447): the next body's marks and queue
        // must not reuse them, which made a later body's initialized variables "uninitialized when used here".
        .name = "unreachable initializer barriers outlive their body",
        .source = "int f(int n) {\n  return n;\n  int dead = n;\n  return dead;\n}\n"
                  "int g(int n) {\n  int a = n + 1;\n  if (n > 1) n = a;\n  int b = n + 2;\n  if (n > 2) n = b;\n"
                  "  int c = n + 3;\n  if (n > 3) n = c;\n  int d = n + 4;\n  if (n > 4) n = d;\n  return n;\n}\n",
        .options = { "-Wall" },
    },
    {
        .name = "initializers after return retain only literal source conversions",
        .source = "int h(void){return 0;short a=65536;int b=1.5;(void)a;(void)b;}\n",
        .warnings = 1,
    },
    // Clang reports a literal conversion at once, as its full expression completes (Sema::Diag), while constant
    // conversions, shift counts and division by zero wait for their function's end (DiagRuntimeBehavior); at file scope a
    // declarator's constant conversion follows its literal ones. The whole output is clang's, in clang's order.
    {
        .name = "a truth context's literal conversion precedes the body's shift counts",
        .source = "int f(int x){return (x<<40)+(x>>-1)+(1.5?x<<33:0);}\n",
        .warnings = 4,
    },
    {
        .name = "literal conversions report at once before the body's deferred conversions and shift counts",
        .source = "char c=1<<9;\n"
                  "void g(int x){char d=1<<9;char e=x<<40;int k=2.5;if(0.5){x<<=64;}x=!1.5?x>>99:x;(void)d;(void)e;(void)k;}\n",
        .warnings = 7,
    },
    {
        // A divisor clang's EvaluateAsInt finds zero through a const object's initializer (#1447,
        // check_common_zero_divisor): a scalar's, an element's, a member's, through parentheses and casts, at file and
        // block scope; not a volatile's, a non-const's or one initialized at run time, and none in unreachable code.
        .name = "division by a const object's zero",
        .source = "const int k = 0;\n"
                  "static const int ks = 0;\n"
                  "const volatile int kv = 0;\n"
                  "int nk = 0;\n"
                  "const long kl = 0;\n"
                  "const int ka[2] = { 0, 1 };\n"
                  "struct P { int m; };\n"
                  "const struct P kp = { 0 };\n"
                  "const int one = 1;\n"
                  "const char s[] = \"a\";\n"
                  "int f(int x) {\n"
                  "    const int lk = 0;\n"
                  "    const int lk2 = x;\n"
                  "    int r = 1 / k + 1 % ks + 1 / kv + 1 / nk + x / kl + 1 / lk + 1 / lk2 + 1 / ka[0] + 1 / kp.m + 1 / (k) + 1 / (int)k;\n"
                  "    if (0) { r = 1 / k; }\n"
                  "    r += (int)sizeof(1 / k) + 1 / one + 1 / s[1];\n"
                  "    r += x ? 1 / lk : 0;\n"
                  "    return r;\n"
                  "    r = 1 / k;\n"
                  "}\n",
        .warnings = 10,
    },
    {
        .name = "division by a const object's zero in C23 under -Wall",
        .source = "const int k = 0;\n"
                  "static const int ks = 0;\n"
                  "const volatile int kv = 0;\n"
                  "int nk = 0;\n"
                  "const long kl = 0;\n"
                  "const int ka[2] = { 0, 1 };\n"
                  "struct P { int m; };\n"
                  "const struct P kp = { 0 };\n"
                  "const int one = 1;\n"
                  "const char s[] = \"a\";\n"
                  "int f(int x) {\n"
                  "    const int lk = 0;\n"
                  "    const int lk2 = x;\n"
                  "    int r = 1 / k + 1 % ks + 1 / kv + 1 / nk + x / kl + 1 / lk + 1 / lk2 + 1 / ka[0] + 1 / kp.m + 1 / (k) + 1 / (int)k;\n"
                  "    if (0) { r = 1 / k; }\n"
                  "    r += (int)sizeof(1 / k) + 1 / one + 1 / s[1];\n"
                  "    r += x ? 1 / lk : 0;\n"
                  "    return r;\n"
                  "    r = 1 / k;\n"
                  "}\n",
        .options = { "-Wall" },
        .warnings = 10,
        .c23 = true,
    },
    {
        .name = "literal conversions precede selection arms' shift counts and division by zero",
        .source = "int h(int x){int a=_Generic(x,int:1,long:x<<70);int b=1.5&&(x+(x<<35));int c=__builtin_choose_expr(1,x,x>>40);short s=3.7;"
                  "return a+b+c+s+(x<<-3)/0;}\n",
        .warnings = 7,
    },
    {
        .name = "argument and conditional-arm literal conversions precede deferred constant conversions",
        .source = "void take(char);int m(int x){take(1<<9);take(2.5);unsigned char u=(x?300:1.5);(void)u;return x?x<<32:(0?x<<50:1);}\n",
        .warnings = 5,
    },
    {
        .name = "literal conversions in unreachable and short-circuited code precede deferred shift counts",
        .source = "int g1(int x){if(0){int a=2.5;x<<=40;(void)a;}int b=sizeof(x<<40)+sizeof((char)3.5);int c=0&&(x<<40)&&1.5;"
                  "int d=_Generic(1.5,double:x<<1,default:x<<99);int e=(char)(x>>70)+4;int f[2]={1.5,x<<33};return b+c+d+e+f[0];}\n"
                  "_Static_assert(1.5,\"x\");struct S{int m;}s={2.5};\n",
        .warnings = 8,
    },
    {
        .name = "file-scope literal conversions keep each declarator's order with constant conversions",
        .source = "char c=1<<9;int a=2.5;_Bool b=0.5;char d=1.5?300:2;char w=300,x=5.5;int v[3]={300,4.5,7};_Static_assert(1.5,\"\");"
                  "struct T{int i;double e;}t={6.5,1.5};\n",
        .warnings = 10,
    },
    {
        .name = "unreachable code keeps literal conversions in each full expression's conversion order",
        .source = "int c0(int);int u(int x){return x;x=x<<40;int a=2.5;char c=1.5?300:0;x/=0;return a+c+c0(3.5)+(x&&4.5);}\n"
                  "int w(int x){if(0){x=x<<40;x=5.5;}while(0){x=x/0+6.5;}return x;}\n",
        .warnings = 5,
    },
    {
        .name = "floating literal boolean conversions",
        .source = "_Bool a=1.5;_Bool b=2.0;_Bool c=1.0;\n",
        .warnings = 2,
    },
    {
        .name = "floating literal out of range conversions",
        .source = "unsigned char a=1000.5;unsigned b=-1.5;int c=1e30;\n",
        .warnings = 3,
    },
    {
        .name = "floating literal macro expansion note",
        .source = "#define VALUE 1.5\nint a=VALUE;\n",
        .warnings = 1,
        .notes = 1,
    },
    {
        .name = "floating literal parentheses retain the literal warning",
        .source = "int a=((1.5));int b=+2.5;int c=-3.5;\n",
        .warnings = 3,
    },
    {
        .name = "explicit and nonliteral floating conversions stay quiet by default",
        .source = "int a=(double)1.5f;int b=(int)1.5;int c=2.5-1.0;int d=2.5+0.0;int e=1.0;\n"
                  "int f(double a){return a;}int g(void){double a=1.5;return a;}\nint h=__builtin_nan(\"\");int i=__builtin_inf();\n",
    },
    {
        .name = "floating literal conversion group disabled",
        .source = "int a=1.5;\n",
        .options = { "-Wno-literal-conversion" },
    },
    {
        // A block's declaration with linkage (an extern object, a function) belongs to the translation unit in clang, so
        // it is never an unused variable or function; the block's own static, register and automatic objects are (#1447).
        .name = "a block's extern declarations are never unused",
        .source = "void f(void) { extern int x; }\nvoid g(void) { extern int y; (void)y; }\nvoid h(void) { extern int z(void); }\n"
                  "void k(void) { extern int w __attribute__((unused)); }\nvoid m(void) { extern int v; { extern int v; v = 1; } }\n"
                  "int q;\nvoid n(void) { extern int q; }\nstatic int s5;\nvoid o(void) { extern int s5; (void)s5; }\n"
                  "void p(void) { extern int arr[]; extern int a, b; (void)b; }\nvoid s(void) { static int st; register int r; int loc; }\n"
                  "void t(void) { int y4; { extern int y4; } }\n",
        .options = { "-Wall" },
        .warnings = 4,
    },
    {
        // A variable with an applied cleanup is used, as clang's ShouldDiagnoseUnusedDecl has it (#1881): one declarator's,
        // a specifier's on several declarators, and one never read but assigned; another declarator of the declaration is
        // still unused. (A file-scope variable whose cleanup is ignored is unused too, but its -Wignored-attributes would
        // be an error before it under the sweep's -Werror, after which clang gives no file-scope unused warning.)
        .name = "a cleanup variable is never unused",
        .source = "void rel(int *p);\nvoid relv(void *p);\nint f(int a) { int c __attribute__((cleanup(rel))) = a; if (a) return 1; return 2; }\n"
                  "void g(void) { __attribute__((cleanup(rel))) int c = 0, d = 1; }\nvoid h(int a) { int c __attribute__((cleanup(relv))); c = a; }\n"
                  "void k(void) { int c __attribute__((cleanup(rel))), e; }\n",
        .options = { "-Wall" },
        .warnings = 1,
    },
    {
        // A use through a block's declaration with linkage uses the outer entity it redeclares, through nested blocks too;
        // a block's extern that nothing uses leaves a file-scope static unused (#1447).
        .name = "a use through a block's extern declaration uses the outer entity",
        .source = "static void sf(void);\nvoid o(void) { extern void sf(void); sf(); }\nstatic void sf(void) {}\nstatic int t;\n"
                  "void p(void) { { extern int t; } }\nstatic int u;\nvoid q(void) { { extern int u; { extern int u; (void)u; } } }\n",
        .options = { "-Wall" },
        .warnings = 1,
    },
    {
        // Clang's error at a block's extern declarator with an initializer, __private_extern__ too, not a generic one.
        .name = "a block's extern declaration with an initializer",
        .source = "int y;\nvoid f(void) { extern int y = 2, z; (void)z; }\n",
        .errors = 1,
    },
    {
        .name = "a block's private extern declaration with an initializer",
        .source = "void f(void) { __private_extern__ int x = 1; }\n",
        .errors = 1,
    },
    {
        .name = "floating literal conversion parent group disabled",
        .source = "int a=1.5;\n",
        .options = { "-Wno-conversion" },
    },
    {
        .name = "floating literal conversion source policy",
        .source = "#pragma clang diagnostic error \"-Wliteral-conversion\"\nint a=1.5;\n",
        .errors = 1,
    },
    {
        .name = "float conversion error does not promote literal conversion",
        .source = "int a=1.5;\n",
        .options = { "-Werror=float-conversion" },
        .warnings = 1,
    },
    {
        .name = "float conversion disabled does not suppress literal conversion",
        .source = "int a=1.5;\n",
        .options = { "-Wno-float-conversion" },
        .warnings = 1,
    },
    {
        .name = "literal disabled before float conversion error",
        .source = "int a=1.5;\n",
        .options = { "-Wno-literal-conversion", "-Werror=float-conversion" },
    },
    {
        .name = "literal error after float conversion disabled",
        .source = "int a=1.5;\n",
        .options = { "-Wno-float-conversion", "-Werror=literal-conversion" },
        .errors = 1,
    },
    {
        .name = "float conversion source policy does not promote literal conversion",
        .source = "#pragma clang diagnostic error \"-Wfloat-conversion\"\nint a=1.5;\n",
        .warnings = 1,
    },
    {
        .name = "literal source policy remains disabled across float conversion error",
        .source = "#pragma clang diagnostic ignored \"-Wliteral-conversion\"\n#pragma clang diagnostic error \"-Wfloat-conversion\"\nint a=1.5;\n",
    },
    {
        .name = "struct brace initializer members warn of constant conversions at file and block scope",
        .source = "struct S{int i;char c;}s={2,300};\nvoid f(void){struct S t={2,300};(void)t;}\n",
        .warnings = 2,
    },
    {
        .name = "array, nested and designated brace initializers warn in clang's reverse order",
        .source = "char a[3]={300,301,302};struct T{struct S{char x,y;}s;char d[2];}t={{303,304},{305,306}};struct S u={.y=307};\n",
        .warnings = 8,
    },
    {
        .name = "brace constant conversions follow their values' runtime warnings, arms, commas and ranges",
        .source = "void f(int x){char b[3]={301,x<<40,302};char c[2]={x?303:1,(x,304)};char e[3]={[0 ... 2]=305};(void)b;(void)c;(void)e;}\n",
        .warnings = 9,
    },
    {
        .name = "brace constant conversions skip unreachable code and keep clang's unsigned and bit-pattern exemptions",
        .source = "void f(void){if(0){char g[1]={310};(void)g;}}unsigned char t1[]={255,256,-1,-129};signed char t2[]={127,128,-129,0xff,0x1ff};\n",
        .warnings = 4,
    },
    {
        .name = "same-width brace constants warn at once, except into a character element",
        .source = "short g[]={32768,70000};struct{signed char c;short s;}h={128,32768};void k(int x){short t[2]={32768,70000};x<<40;(void)t;}\n",
        .warnings = 7,
    },
    {
        .name = "same-width scalar constants warn at once, before a body's queued warnings",
        .source = "void f(int x){x<<40;short a=32768;short b=70000;(void)a;(void)b;}\n",
        .warnings = 4,
    },
    {
        .name = "a file-scope shift count follows its declarator's literal conversions",
        .source = "int h[2]={15.5,1<<40};\n",
        .warnings = 2,
    },
    {
        .name = "file-scope declarators queue shift counts and constant conversions to their own ends",
        .source = "int a=1<<40,b=2.5;int e[2]={1<<41,4.5},f=5.5,g=1<<42;char h[2]={301,1<<43},i[1]={6.5};struct{char c;int i;}k={302,1<<44};\n",
        .warnings = 12,
    },
    {
        // A comma's left operand's -Wunused-value in a file-scope initializer is queued to the declarator's end with its
        // operands' shift counts, in the order clang builds them (#1943); a brace initializer's values walk in
        // initializer order, before its conversions, in a function too.
        .name = "comma and shift warnings in initializers in clang's order",
        .source = "struct T { char a; char b; };\n"
                  "int z = (1 << 40, 3), y = (2, 1 << 41);\n"
                  "int w = (2 << 42, 1 << 43, 3);\n"
                  "char c = (1 << 42, 300);\n"
                  "struct T s = { (1 << 43, 1), (4, 1 << 44) };\n"
                  "int arr[2] = { (5, 6), 7 };\n"
                  "struct T g = { (5, 302), (6, 303) };\n"
                  "void f(int x) { struct T t = { (1, 300), (2, 301) }; struct T u = { (3, x << 40), 1.5 }; struct T v = { x / 0, (4, x) }; (void)t; (void)u; (void)v;\n"
                  "    static int k = (1 << 45, 3); (void)k; int q = (1 << 46, 2); (void)q; }\n",
        .options = { "-Wall" },
        .warnings = 34,
    },
    {
        .name = "comma warnings in initializers in clang's order without shift counts",
        .source = "struct T { char a; char b; };\n"
                  "int z = (1 << 40, 3), y = (2, 1 << 41);\n"
                  "int w = (2 << 42, 1 << 43, 3);\n"
                  "char c = (1 << 42, 300);\n"
                  "struct T s = { (1 << 43, 1), (4, 1 << 44) };\n"
                  "int arr[2] = { (5, 6), 7 };\n"
                  "struct T g = { (5, 302), (6, 303) };\n"
                  "void f(int x) { struct T t = { (1, 300), (2, 301) }; struct T u = { (3, x << 40), 1.5 }; struct T v = { x / 0, (4, x) }; (void)t; (void)u; (void)v;\n"
                  "    static int k = (1 << 45, 3); (void)k; int q = (1 << 46, 2); (void)q; }\n",
        .options = { "-Wno-shift-count-overflow" },
        .warnings = 24,
        .c23 = true,
        // (clang 23's C23 mode can't compile these static initializers: "cannot compile this static initializer yet".)
        .syntax_only = true,
    },
    {
        .name = "literal conversions precede constant conversions in one brace initializer",
        .source = "char a[4]={300,1.5,301,2.5};void f(void){char b[4]={303,5.5,304,6.5};int y=7.5;(void)b;(void)y;}\n",
        .warnings = 9,
    },
    {
        .name = "brace members of an enumeration warn by its integer type's range",
        .source = "enum Small:signed char{S0};struct T{enum Small m;int i;}st={300,1};enum Small sa[2]={1,301};\n",
        .warnings = 2,
        .c23 = true,
    },
    {
        .name = "brace parts of a constant shift warn of its changed value, and into _Bool of its truth",
        .source = "struct S{short s;char c;};short a[1]={1<<20};int c[1]={3LL<<40};short d={1<<20};struct S e={1<<18,2<<8};"
                  "void f(void){short x[1]={4<<18};struct S y={0,1<<9};_Bool b[1]={1<<3};short z[1]={1<<3};(void)x;(void)y;(void)b;(void)z;}\n",
        .warnings = 8,
    },
    {
        .name = "a compound literal's constant conversions follow its full expression's counts, in conditions and increments too",
        .source = "struct S{int i;char c;};int f(int x){x=(struct S){x,300}.c+(x<<33);if((struct S){x,301}.c+(x<<34))return x<<32;"
                  "for(int i=0;i<2;i+=(struct S){1,302}.c+(x<<35)){struct S s={1,303};x+=s.c+(x<<36);}return x;}\n",
        .warnings = 9,
    },
    {
        .name = "_Atomic brace elements and members take no constant conversion",
        .source = "_Atomic short a0[2]={32768,1};struct{_Atomic char c;int i;}s={300,1};void f(void){_Atomic short a3[2]={32768,70000};(void)a3;}\n",
    },
    {
        .name = "brace constant conversion suppression keeps literal conversions",
        .source = "char a[4]={300,1.5,301,2.5};short g[]={32768};\n",
        .options = { "-Wno-constant-conversion" },
        .warnings = 2,
    },
    {
        .name = "brace constant conversion promotion rejects object publication",
        .source = "struct S{int i;char c;}s={2,300};\n",
        .options = { "-Werror=constant-conversion" },
        .errors = 1,
    },
    {
        .name = "file initializer discards pointer qualifiers at its declaration",
        .source = "const int b=1;\nint *c=&b;\n",
        .warnings = 1,
    },
    {
        .name = "local initializer discards pointer qualifiers",
        .source = "int f(void){const int b=1;int *c=&b;return *c;}\n",
        .warnings = 1,
    },
    {
        .name = "assignment discards pointer qualifiers",
        .source = "void f(const int *a,int *b){b=a;}\n",
        .warnings = 1,
    },
    {
        .name = "return discards pointer qualifiers at its expression",
        .source = "const int b=1;\nint *f(void){return &b;}\n",
        .warnings = 1,
    },
    {
        .name = "discarded pointer qualifiers follow named policy",
        .source = "const int b=1;\nint *c=&b;\n",
        .options = { "-Wno-incompatible-pointer-types-discards-qualifiers" },
    },
    {
        .name = "discarded pointer qualifiers honor source severity",
        .source = "#pragma clang diagnostic error \"-Wincompatible-pointer-types-discards-qualifiers\"\nconst int b=1;\nint *c=&b;\n",
        .errors = 1,
    },
    {
        .name = "discarded pointer qualifiers retain typedef spellings",
        .source = "typedef const int CI;CI b=1;typedef int *P;P c=&b;\n",
        .warnings = 1,
    },
    {
        .name = "discarded array qualifiers retain the source array type",
        .source = "const int b[2]={1,2};int *c=b;\n",
        .warnings = 1,
    },
    {
        .name = "discarded pointer qualifiers retain outer const spelling",
        .source = "const int b=1;int *const c=&b;\n"
                  "void f(const int *const a){int *const b=a;(void)b;}\n"
                  "int *g(const int *const a){return a;}\n",
        .warnings = 3,
    },
    {
        .name = "plain char pointer initializer and return conversion",
        .source = "unsigned char a[2];char *b=a;\nchar *f(void){return a;}\n",
        .warnings = 2,
    },
    {
        .name = "direct call qualifier warnings retain named and unnamed parameter notes",
        .source = "void f(int *,int *b);void g(const int *p){f(p,p);}\n",
        .warnings = 2,
        .notes = 2,
    },
    {
        .name = "direct call parameter note uses the visible redeclaration",
        .source = "void f(int *first);void f(int *second);void g(const int *p){f(p);}\n",
        .warnings = 1,
        .notes = 1,
    },
    {
        .name = "empty-list redeclaration retains conversion checks without a parameter note",
        .source = "void f(int *first);void f();void g(const int *p){f(p);}\n",
        .options = { "-Wno-deprecated-non-prototype" },
        .warnings = 1,
    },
    {
        .name = "closed-block prototype supplies no parameter note to an unprototyped call",
        .source = "void earlier(void){void f(int *hidden);}void f();void g(const int *p){f(p);}\n",
        .options = { "-Wno-deprecated-non-prototype" },
    },
    {
        .name = "function pointer variable call has no parameter declaration note",
        .source = "void (*f)(int *parameter);void g(const int *p){f(p);}\n",
        .warnings = 1,
    },
    {
        .name = "function pointer typedef and parameter calls have no declaration notes",
        .source = "typedef void (*F)(int *parameter);F f;void g(const int *p){f(p);}\n"
                  "void h(void (*callback)(int *parameter),const int *p){callback(p);}\n",
        .warnings = 2,
    },
    {
        .name = "dereferenced and cast callees have no parameter declaration notes",
        .source = "void f(int *parameter);void g(const int *p){(*f)(p);((void(*)(int *))f)(p);}\n",
        .warnings = 2,
    },
    {
        .name = "pointer argument warning is located at the expression beginning",
        .source = "void f(int *parameter);void g(const int *p){f(p+1);}\n",
        .warnings = 1,
        .notes = 1,
    },
    {
        .name = "nested pointer qualifier wording includes the parameter note",
        .source = "void f(int **parameter);void g(const int **p){f(p);}\n",
        .warnings = 1,
        .notes = 1,
    },
    {
        .name = "pointer call macro expansion precedes its parameter note",
        .source = "#define F f\n#define P p\nvoid f(int *parameter);void g(const int *p){F(P);}\n",
        .warnings = 1,
        .notes = 2,
    },
    {
        .name = "mixed pointer conversion groups follow argument order",
        .source = "void f(int *a,int *b);void g(const int *p,unsigned int *q){f(q,p);f(p,q);}\n",
        .warnings = 4,
        .notes = 4,
    },
    {
        .name = "plain char signedness overrides an array qualifier discard",
        .source = "void f(char *p);void g(void){const unsigned char a[2]={1,2};f(a);}\n",
        .warnings = 1,
        .notes = 1,
    },
    {
        .name = "pointer parameter notes skip intervening scalar and callback parameters",
        .source = "void f(int *,int count,void callback(int *),int *last);\n"
                  "void g(const int *p){f(p,0,0,p);}\n",
        .warnings = 2,
        .notes = 2,
    },
    {
        .name = "pointer parameter type spelling belongs to its own specifiers",
        .source = "typedef int *P;void f(P first,int *second);void g(const int *p){f(p,p);}\n",
        .warnings = 2,
        .notes = 2,
    },
    {
        .name = "pointer call qualifiers and signedness obey independent group policy",
        .source = "void f(int *a,int *b);void g(const int *p,unsigned int *q){f(p,q);}\n",
        .options = { "-Wno-incompatible-pointer-types-discards-qualifiers" },
        .warnings = 1,
        .notes = 1,
    },
    {
        .name = "pointer call warning promotion retains its parameter note",
        .source = "#pragma clang diagnostic error \"-Wincompatible-pointer-types-discards-qualifiers\"\n"
                  "void f(int *parameter);void g(const int *p){f(p);}\n",
        .errors = 1,
        .notes = 1,
    },
    {
        .name = "nested pointer initialization assignment and return wording",
        .source = "void f(const int **p,int **q){int **r=p;q=p;(void)r;}\nint **g(const int **p){return p;}\n",
        .warnings = 3,
    },
    {
        .name = "nonconstant file initializer",
        .source = "int a;\nint b=a;\n",
        .errors = 1,
    },
    {
        .name = "nonconstant aggregate initializer element",
        .source = "int a;\nint values[2]={1,a};\n",
        .errors = 1,
    },
    {
        .name = "nonconstant static local initializer",
        .source = "int read(void);\nint f(void){static int value=read();return value;}\n",
        .errors = 1,
    },
    {
        .name = "duplicate qualifiers and declaration specifiers",
        .source = "const const int a;\nvolatile volatile int b;\n_Atomic _Atomic int c;\nextern extern int d;\n"
                  "static static int e;\ntypedef typedef int T;\nunsigned unsigned int f;\n",
        .warnings = 7,
    },
    {
        .name = "duplicate function specifiers",
        .source = "inline inline void f(void){}\n_Noreturn _Noreturn void g(void){for(;;){}}\n",
        .warnings = 2,
    },
    {
        .name = "duplicate separated noreturn specifiers",
        .source = "_Noreturn void _Noreturn f(void){for(;;){}}\n_Noreturn extern _Noreturn void g(void);\n",
        .warnings = 2,
    },
    {
        .name = "duplicate parameter and pointer qualifiers",
        .source = "int f(const const int x,int *volatile volatile p){return x+*p;}\n",
        .warnings = 2,
    },
    {
        .name = "duplicate specifiers in operand type names",
        .source = "typeof(unsigned unsigned int) q;\nint r = sizeof(typeof(const const int));\nenum E : unsigned unsigned short { A };\n"
                  "_Atomic(signed signed char) s;\ntypeof(_Atomic _Atomic int) t;\n"
                  "int f(void) { return sizeof(short short) + (int)(typeof(volatile volatile long))1; }\n",
        .warnings = 7,
        .compare_warning_text = true,
    },
    {
        // An enum base's const and volatile (#1952): clang's -Wunderlying-cv-qualifier-ignored once per base, at its first
        // token that isn't a qualifier, a typedef's qualifiers too, and no stand-alone declaration's warning for them.
        .name = "enum underlying type qualifiers",
        .source = "enum H : const int { D };\nenum I : const volatile const int { E };\nenum J : int const { F };\n"
                  "enum K : volatile unsigned long { G };\ntypedef const int CI;\nenum L : CI { H1 };\nenum M : const CI { M1 };\n"
                  "enum N : const int;\nconst enum O : const int { O1 };\nenum Q : const int { Q1 } q;\n"
                  "void f(void) { enum R : const short { R1 }; enum R r = R1; (void)r; }\nstruct T { enum U : const int { U1 } u; };\n",
        .warnings = 13,
        .compare_warning_text = true,
    },
    {
        .name = "enum underlying type qualifiers under -Wall",
        .source = "enum H : const int { D };\nenum I : const volatile const int { E };\nenum J : int const { F };\n"
                  "enum K : volatile unsigned long { G };\ntypedef const int CI;\nenum L : CI { H1 };\nenum M : const CI { M1 };\n"
                  "enum N : const int;\nconst enum O : const int { O1 };\nenum Q : const int { Q1 } q;\n"
                  "void f(void) { enum R : const short { R1 }; enum R r = R1; (void)r; }\nstruct T { enum U : const int { U1 } u; };\n",
        .options = { "-Wall" },
        .warnings = 13,
        .compare_warning_text = true,
    },
    {
        .name = "enum underlying type qualifiers under -w",
        .source = "enum H : const int { D };\nenum I : const volatile const int { E };\nenum J : int const { F };\n"
                  "enum K : volatile unsigned long { G };\ntypedef const int CI;\nenum L : CI { H1 };\nenum M : const CI { M1 };\n"
                  "enum N : const int;\nconst enum O : const int { O1 };\nenum Q : const int { Q1 } q;\n"
                  "void f(void) { enum R : const short { R1 }; enum R r = R1; (void)r; }\nstruct T { enum U : const int { U1 } u; };\n",
        .options = { "-w" },
    },
    {
        .name = "enum underlying type qualifiers as errors",
        .source = "enum H : const int { D };\n",
        .options = { "-Werror=underlying-cv-qualifier-ignored" },
        .errors = 1,
    },
    {
        .name = "enum underlying type qualifiers disabled",
        .source = "enum H : const int { D };\n",
        .options = { "-Wno-underlying-cv-qualifier-ignored" },
    },
    {
        .name = "enum underlying atomic qualifier is a default error",
        .source = "typedef _Atomic(int) Atomic; enum E : _Atomic int { E0 }; enum F : Atomic { F0 };\n"
                  "_Static_assert(sizeof(enum E)==4 && sizeof(enum F)==4, \"atomic base stripped\");\n",
        .errors = 2,
    },
    {
        .name = "enum underlying atomic qualifier can be demoted",
        .source = "typedef _Atomic(int) Atomic; enum E : _Atomic int { E0 }; enum F : Atomic { F0 };\n"
                  "_Static_assert(sizeof(enum E)==4 && sizeof(enum F)==4, \"atomic base stripped\");\n",
        .options = { "-Wno-error=underlying-atomic-qualifier-ignored" },
        .warnings = 2,
    },
    {
        .name = "enum underlying atomic qualifier can be suppressed",
        .source = "typedef _Atomic(int) Atomic; enum E : _Atomic int { E0 }; enum F : Atomic { F0 };\n"
                  "_Static_assert(sizeof(enum E)==4 && sizeof(enum F)==4, \"atomic base stripped\");\n",
        .options = { "-Wno-underlying-atomic-qualifier-ignored" },
    },
    {
        .name = "enum underlying atomic qualifier stays an error under -w",
        .source = "enum E : _Atomic int { E0 };\n",
        .options = { "-w" },
        .errors = 1,
    },
    {
        // An enum's fixed base in a declaration with a declarator (#2213): clang's -Welaborated-enum-base, an error by default,
        // at the `:`, after which the declaration is an elaborated reference: a new name declared with the base (a later
        // body's "previously declared with fixed underlying type"), a visible enum's base ignored; the base's own warnings.
        .name = "an enum base with a declarator",
        .source = "enum P : unsigned const long volatile x;\nvoid f(void) { enum S : volatile char s; s = 1; (void)s; }\nenum Q : short q1, q2;\n"
                  "enum Q { QA = 1 };\n_Static_assert(sizeof(q1) == 2, \"\");\nenum E : int;\nvoid g(void) { enum E : short y; (void)y; }\n"
                  "enum F { FA };\nenum F : int z;\ntypedef enum T : char TT;\n_Static_assert(sizeof(TT) == 1, \"\");\n",
        .warnings = 2,
        .errors = 7,
        .notes = 1,
    },
    {
        .name = "an enum base with a declarator demoted",
        .source = "enum P : unsigned const long volatile x;\nvoid f(void) { enum S : volatile char s; s = 1; (void)s; }\nenum Q : short q1, q2;\n"
                  "enum Q { QA = 1 };\n_Static_assert(sizeof(q1) == 2, \"\");\nenum E : int;\nvoid g(void) { enum E : short y; (void)y; }\n"
                  "enum F { FA };\nenum F : int z;\ntypedef enum T : char TT;\n_Static_assert(sizeof(TT) == 1, \"\");\n",
        .options = { "-Wno-error=elaborated-enum-base", "-Werror=underlying-cv-qualifier-ignored" },
        .warnings = 6,
        .errors = 3,
        .notes = 1,
    },
    {
        .name = "an enum base with a declarator ignored",
        .source = "enum P : unsigned const long volatile x;\nvoid f(void) { enum S : volatile char s; s = 1; (void)s; }\nenum Q : short q1, q2;\n"
                  "enum Q { QA = 1 };\n_Static_assert(sizeof(q1) == 2, \"\");\nenum E : int;\nvoid g(void) { enum E : short y; (void)y; }\n"
                  "enum F { FA };\nenum F : int z;\ntypedef enum T : char TT;\n_Static_assert(sizeof(TT) == 1, \"\");\n",
        .options = { "-Wno-elaborated-enum-base", "-w" },
        .errors = 1,
        .notes = 1,
    },
    {
        .name = "an enum base with a declarator under -w",
        .source = "enum P : unsigned const long volatile x;\nvoid f(void) { enum S : volatile char s; s = 1; (void)s; }\nenum Q : short q1, q2;\n"
                  "enum Q { QA = 1 };\n_Static_assert(sizeof(q1) == 2, \"\");\nenum E : int;\nvoid g(void) { enum E : short y; (void)y; }\n"
                  "enum F { FA };\nenum F : int z;\ntypedef enum T : char TT;\n_Static_assert(sizeof(TT) == 1, \"\");\n",
        .options = { "-w" },
        .errors = 7,
        .notes = 1,
    },
    {
        // An object left an array of unknown bound by its tentative definitions (#2238): clang's
        // -Wtentative-definition-array once per object, at its last tentative definition, in the order of its first one,
        // before the unit's unused warnings; none for a defined or completed one, an extern one, or under the pragma.
        .name = "tentative array definitions",
        .source = "int a[];\nint a[];\nint b[]; int b[3];\nstatic int c[];\nextern int d[];\nint e[], f[];\nstatic void u(void) {}\n"
                  "typedef int A[];\nA x;\nint q[3]; int q[];\nint r[]; int r[2] = { 1 };\nint s[] = { 1, 2 }; int s[];\n"
                  "int t[]; extern int t[];\nint *p[];\nconst int k[];\nint m[][2];\n"
                  "void g(void) { extern int z[]; static int y[2]; (void)z; (void)y; }\n"
                  "#pragma clang diagnostic ignored \"-Wtentative-definition-array\"\nint i[];\n",
        .options = { "-Wall" },
        .warnings = 11,
        .compare_warning_text = true,
    },
    {
        .name = "tentative array definitions in C23",
        .source = "int a[];\nint a[];\nint b[]; int b[3];\nstatic int c[];\nextern int d[];\nint e[], f[];\nstatic void u(void) {}\n"
                  "typedef int A[];\nA x;\nint q[3]; int q[];\nint r[]; int r[2] = { 1 };\nint s[] = { 1, 2 }; int s[];\n"
                  "int t[]; extern int t[];\nint *p[];\nconst int k[];\nint m[][2];\n"
                  "void g(void) { extern int z[]; static int y[2]; (void)z; (void)y; }\n"
                  "#pragma clang diagnostic ignored \"-Wtentative-definition-array\"\nint i[];\n",
        .options = { "-Wall" },
        .warnings = 11,
        .c23 = true,
        .compare_warning_text = true,
    },
    {
        .name = "tentative array definitions under -w",
        .source = "int a[];\nint a[];\nint b[]; int b[3];\nstatic int c[];\nextern int d[];\nint e[], f[];\nstatic void u(void) {}\n"
                  "typedef int A[];\nA x;\nint q[3]; int q[];\nint r[]; int r[2] = { 1 };\nint s[] = { 1, 2 }; int s[];\n"
                  "int t[]; extern int t[];\nint *p[];\nconst int k[];\nint m[][2];\n"
                  "void g(void) { extern int z[]; static int y[2]; (void)z; (void)y; }\n"
                  "#pragma clang diagnostic ignored \"-Wtentative-definition-array\"\nint i[];\n",
        .options = { "-w" },
    },
    {
        .name = "tentative array definitions as errors",
        .source = "int a[];\nint b[];\n",
        .options = { "-Werror=tentative-definition-array" },
        .errors = 2,
    },
    {
        .name = "tentative array definitions disabled",
        .source = "int a[];\n",
        .options = { "-Wno-tentative-definition-array" },
    },
    {
        // Clang's loop over the tentative definitions has no error test: a rejected unit warns too, a definition after
        // the error included.
        .name = "tentative array definitions in a rejected unit",
        .source = "int a[];\nint z[];\nint a[];\nint f(void) { return undeclared; }\nint w[];\nint g(void) { return 1 / 0; }\n",
        .options = { "-Wall" },
        .warnings = 4,
        .errors = 1,
    },
    {
        // The unit's end in clang's order (#2238): -Wundefined-internal, the tentative arrays, the unused declarations;
        // under -Werror the first promoted one leaves out the unused ones.
        .name = "unit end order",
        .source = "static int c;\nstatic void h(void);\nvoid k(void) { h(); }\nint a[];\nstatic void u(void) {}\n",
        .options = { "-Wall" },
        .warnings = 4,
        .notes = 1,
        .compare_warning_text = true,
    },
    {
        // A promoted graph warning, published after the reader's, is an error before -Wundefined-internal (#2238).
        .name = "unit end after a promoted graph warning",
        .source = "static void h(void);\nvoid k(void) { h(); (void)(1 / 0); }\nstatic int c;\n",
        .options = { "-Wall" },
        .warnings = 3,
        .notes = 1,
        .compare_warning_text = true,
    },
    {
        // A block's promoted unused variable is an error before the unit's end (#2238).
        .name = "unit end after a promoted scope warning",
        .source = "void f(void) { int x; }\nstatic int c;\nstatic void g(void) {}\n",
        .options = { "-Wall" },
        .warnings = 3,
        .compare_warning_text = true,
    },
    {
        .name = "duplicate declaration specifier group disabled",
        .source = "const const int value;\n",
        .options = { "-Wno-duplicate-decl-specifier" },
    },
    {
        .name = "duplicate declaration specifier source policy",
        .source = "#pragma clang diagnostic ignored \"-Wduplicate-decl-specifier\"\nconst const int value;\n",
    },
    {
        .name = "noreturn fall off",
        .source = "_Noreturn void f(void){}\n",
        .warnings = 1,
    },
    {
        .name = "noreturn explicit return",
        .source = "_Noreturn void f(void){return;}\n",
        .warnings = 1,
    },
    {
        .name = "noreturn valued return",
        .source = "__attribute__((noreturn)) int f(void){return 1;}\n",
        .warnings = 1,
    },
    {
        .name = "noreturn dead explicit return",
        .source = "_Noreturn void f(void){if(0)return;for(;;){}}\n",
        .warnings = 1,
    },
    {
        .name = "noreturn ordinary call can return",
        .source = "void g(void);_Noreturn void f(void){g();}\n",
        .warnings = 1,
    },
    {
        .name = "noreturn call ends the path",
        .source = "_Noreturn void g(void);_Noreturn void f(void){g();}\n",
    },
    {
        .name = "noreturn partial terminal path",
        .source = "_Noreturn void g(void);_Noreturn void f(int x){if(x)g();}\n",
        .warnings = 1,
    },
    {
        .name = "noreturn trap ends the path",
        .source = "_Noreturn void f(void){__builtin_trap();}\n",
    },
    {
        .name = "noreturn cast terminal path",
        .source = "_Noreturn int g(void);_Noreturn void f(void){(void)g();}\n",
    },
    {
        .name = "noreturn partial cast terminal path",
        .source = "_Noreturn int g(void);_Noreturn void f(int x){if(x)(void)g();}\n",
        .warnings = 1,
    },
    {
        .name = "noreturn partial trap path",
        .source = "_Noreturn void f(int x){if(x)__builtin_trap();}\n",
        .warnings = 1,
    },
    {
        .name = "noreturn independent of return type warning policy",
        .source = "_Noreturn void f(void){}\n",
        .options = { "-Wno-return-type" },
        .warnings = 1,
    },
    {
        .name = "noreturn call when return-type warnings are disabled",
        .source = "_Noreturn void g(void);_Noreturn void f(void){g();}\n",
        .options = { "-Wno-return-type" },
    },
    {
        .name = "noreturn group disabled",
        .source = "_Noreturn void f(void){return;}\n",
        .options = { "-Wno-invalid-noreturn" },
    },
    {
        .name = "noreturn source policy",
        .source = "#pragma clang diagnostic ignored \"-Winvalid-noreturn\"\n_Noreturn void f(void){}\n",
    },
    {
        .name = "scalar return fall off after ordinary call",
        .source = "void g(void);int f(void){g();}\n",
        .warnings = 1,
    },
    {
        .name = "scalar return partial terminal path",
        .source = "_Noreturn void g(void);int f(int x){if(x)g();}\n",
        .warnings = 1,
    },
    {
        .name = "scalar return terminal call",
        .source = "_Noreturn int g(void);int f(void){(void)g();}\n",
    },
    {
        .name = "scalar return partial trap path",
        .source = "int f(int x){if(x)__builtin_trap();}\n",
        .warnings = 1,
    },
    {
        .name = "private extern declarations",
        .source = "__private_extern__ int x;\n__private_extern__ int f(void);\nvoid g(void){__private_extern__ int y;}\n",
        .warnings = 2,
        .notes = 2,
    },
    {
        .name = "private extern definitions",
        .source = "__private_extern__ int x=7;\n__private_extern__ int f(void){return x;}\n",
    },
    {
        .name = "private extern direct initializer after attribute",
        .source = "__private_extern__ int x __attribute__((unused)) (3);\n",
    },
    {
        .name = "private extern thread local declaration",
        .source = "__private_extern__ __thread int x;\n",
        .warnings = 1,
        .notes = 1,
    },
    {
        .name = "private extern redeclarations",
        .source = "__private_extern__ int x;int x;\nint y;__private_extern__ int y;\n__private_extern__ int z;int z=3;\n",
        .warnings = 3,
        .notes = 3,
    },
    {
        .name = "private extern multiple declarators",
        .source = "__private_extern__ int x,y=2,z;\n",
        .warnings = 2,
        .notes = 2,
    },
    {
        .name = "private extern duplicate specifier",
        .source = "__private_extern__ __private_extern__ int x;\n",
        .warnings = 2,
        .notes = 1,
    },
    {
        .name = "private extern group disabled",
        .source = "__private_extern__ int x;\n",
        .options = { "-Wno-private-extern" },
    },
    {
        .name = "private extern source policy",
        .source = "#pragma clang diagnostic ignored \"-Wprivate-extern\"\n__private_extern__ int x;\n",
    },
    {
        .name = "first block annotation survives its own later bare declaration",
        .source = "void declare(void){extern int printf(const char*,...)__attribute__((format(printf,1,2)));"
                  "extern int printf(const char*,...);}\nint printf(const char*,...);\n"
                  "void call(void){printf(\"%d\",\"str\");}\n",
        .options = { "-fno-builtin" },
        .warnings = 1,
    },
    {
        .name = "first bare block extern does not export a later block annotation",
        .source = "void declare(void){extern int printf(const char*,...);"
                  "extern int printf(const char*,...)__attribute__((format(printf,1,2)));"
                  "extern int printf(const char*,...);}\nint printf(const char*,...);\n"
                  "void call(void){printf(\"%d\",\"str\");}\n",
        .options = { "-fno-builtin" },
    },
    {
        .name = "all supported explicit format builtins keep their source argument indexes",
        .source = "typedef struct _IO_FILE FILE;\nvoid f(FILE*p,char*b){"
                  "__builtin_printf(\"%d\",\"str\");__builtin_fprintf(p,\"%d\",\"str\");"
                  "__builtin_sprintf(b,\"%d\",\"str\");__builtin_snprintf(b,16,\"%d\",\"str\");"
                  "__builtin_snprintf(b,16,\"%s.mo\\0\",\"x\");}\n",
        .options = { "-ffreestanding", "-fno-builtin" },
        .warnings = 5,
    },
    {
        .name = "explicit format receipts follow interleaved unrelated intrinsic calls",
        .source = "void f(const char*s){(void)__builtin_strlen(s);__builtin_printf(\"%d\",\"str\");(void)__builtin_strlen(s);}\n",
        .options = { "-fno-builtin" },
        .warnings = 1,
    },
    {
        .name = "first block extern format contract reaches the first file declaration",
        .source = "void declare(void){extern int printf(const char*,...)__attribute__((format(printf,1,2)));}\n"
                  "int printf(const char*,...);\nvoid call(void){printf(\"%d\",\"str\");}\n",
        .options = { "-fno-builtin" },
        .warnings = 1,
    },
    {
        .name = "later file declaration does not import a nested outer redeclaration annotation",
        .source = "int printf(const char*,...);\n"
                  "void declare(void){extern int printf(const char*,...)__attribute__((format(printf,1,2)));}\n"
                  "int printf(const char*,...);\nvoid call(void){printf(\"%d\",\"str\");}\n",
        .options = { "-fno-builtin" },
    },
    {
        .name = "middle format annotation survives a final bare declaration",
        .source = "int printf(const char*,...);\nint printf(const char*,...)__attribute__((format(printf,1,2)));\n"
                  "int printf(const char*,...);\nvoid f(void){printf(\"%d\",\"str\");}\n",
        .options = { "-fno-builtin" },
        .warnings = 1,
    },
    {
        .name = "later format annotation does not change an earlier call",
        .source = "int report(const char*,...);\nvoid before(void){report(\"%d\",\"str\");}\n"
                  "int report(const char*,...)__attribute__((format(printf,1,2)));\nint report(const char*,...);\n"
                  "void after(void){report(\"%d\",\"str\");}\n",
        .warnings = 1,
    },
    {
        .name = "block format inheritance follows the visible declaration",
        .source = "int report(const char*,...);\nvoid f(void){{"
                  "int report(const char*,...)__attribute__((format(printf,1,2)));"
                  "int report(const char*,...);report(\"%d\",\"str\");}"
                  "report(\"%d\",\"str\");}\n",
        .warnings = 1,
    },
    {
        .name = "bare format inheritance preserves unrelated declaration attributes",
        .source = "int report(const char*,...)__attribute__((format(printf,1,2)));\n"
                  "int report(const char*,...)__attribute__((noinline));\nvoid f(void){report(\"%d\",\"str\");}\n",
        .warnings = 1,
    },
    {
        .name = "hosted plain format names retain inferred checks",
        .source = check_driver_format_plain_source,
        .warnings = 5,
    },
    {
        .name = "freestanding plain format names have no inferred contract",
        .source = check_driver_format_plain_source,
        .options = { "-ffreestanding" },
    },
    {
        .name = "global no builtin disables plain format inference",
        .source = check_driver_format_plain_source,
        .options = { "-fno-builtin" },
    },
    {
        .name = "per name exclusions disable all four supported format names",
        .source = check_driver_format_plain_source,
        .options = { "-fno-builtin-printf", "-fno-builtin-fprintf", "-fno-builtin-sprintf", "-fno-builtin-snprintf" },
    },
    {
        .name = "printf exclusion preserves the other names",
        .source = check_driver_format_plain_source,
        .options = { "-fno-builtin-printf" },
        .warnings = 4,
    },
    {
        .name = "snprintf exclusion disables its embedded NUL check too",
        .source = check_driver_format_plain_source,
        .options = { "-fno-builtin-snprintf" },
        .warnings = 3,
    },
    {
        .name = "builtin exclusions match the whole name",
        .source = check_driver_format_plain_source,
        .options = { "-fno-builtin-print" },
        .warnings = 5,
    },
    {
        .name = "later builtin option restores plain format inference",
        .source = check_driver_format_plain_source,
        .options = { "-fno-builtin", "-fbuiltin" },
        .warnings = 5,
    },
    {
        .name = "later no builtin option disables plain format inference",
        .source = check_driver_format_plain_source,
        .options = { "-fbuiltin", "-fno-builtin" },
    },
    {
        .name = "freestanding preserves explicit and redeclared format contracts",
        .source = check_driver_format_attributed_source,
        .options = { "-ffreestanding" },
        .warnings = 3,
    },
    {
        .name = "global no builtin preserves explicit and redeclared format contracts",
        .source = check_driver_format_attributed_source,
        .options = { "-fno-builtin" },
        .warnings = 3,
    },
    {
        .name = "per name exclusions preserve explicit and redeclared format contracts",
        .source = check_driver_format_attributed_source,
        .options = { "-fno-builtin-printf", "-fno-builtin-snprintf" },
        .warnings = 3,
    },
    {
        .name = "plain dprintf needs an explicit format contract",
        .source = "int dprintf(int,const char*,...);\nvoid f(void){dprintf(1,\"%d\",\"str\");}\n",
    },
    {
        .name = "attributed dprintf remains checked when builtins are disabled",
        .source = "int dprintf(int,const char*,...)__attribute__((format(printf,2,3)));\nvoid f(void){dprintf(1,\"%d\",\"str\");}\n",
        .options = { "-ffreestanding", "-fno-builtin", "-fno-builtin-dprintf" },
        .warnings = 1,
    },
    {
        .name = "explicit builtin printf remains checked when builtins are disabled",
        .source = "void f(void){__builtin_printf(\"%d\",\"str\");}\n",
        .options = { "-ffreestanding", "-fno-builtin", "-fno-builtin-printf" },
        .warnings = 1,
    },
    {
        .name = "local printf function pointer has no inferred format contract",
        .source = "void f(void(*printf)(const char*,...)){printf(\"%d\",\"str\");}\n",
    },
    {
        .name = "valid plain format calls retain a quiet twin",
        .source = "int printf(const char*,...);\nint snprintf(char*,unsigned long,const char*,...);\nvoid f(char*b){printf(\"%d\",7);snprintf(b,16,\"%s.mo\",\"x\");}\n",
    },
    {
        .name = "one parenthesized comparison does not hide the other warning",
        .source = "int f(int a,int b,int c,int d){return ((a<b) & c<d)+(a==b ^ (c!=d));}\n",
        .warnings = 2,
        .notes = 4,
    },
    {
        .name = "parenthesized eager chain leaves outer precedence visible",
        .source = "int f(int a,int b,int c,int d,int e,int g){return (a<b & c<d) ^ e<g;}\n",
        .warnings = 1,
        .notes = 2,
    },
    {
        .name = "constant initializer comparison pairs",
        .source = "int a=1<2 & 3<4; static int b=1==2 ^ 3!=4; int f(void){return a+b;}\n",
    },
    {
        .name = "constant initializer single comparisons",
        .source = "int a=1<2 & 3; static int b=1 ^ 2!=3; int f(void){return a+b;}\n",
        .warnings = 2,
        .notes = 4,
    },
    {
        .name = "enum comparison pairs",
        .source = "enum E{A=1<2 & 3<4,B=1==2 ^ 3!=4};int f(void){return A+B;}\n",
    },
    {
        .name = "enum single comparisons",
        .source = "enum E{A=1<2 & 3,B=1 ^ 2!=3};int f(void){return A+B;}\n",
        .warnings = 2,
        .notes = 4,
    },
    {
        .name = "unevaluated comparison pairs",
        .source = "unsigned long f(int a,int b,int c,int d){return sizeof(a<b & c<d);}\n",
    },
    {
        .name = "unevaluated single comparison",
        .source = "unsigned long f(int a,int b,int c){return sizeof(a<b & c);}\n",
        .warnings = 1,
        .notes = 2,
    },
    {
        .name = "unselected generic comparison pair",
        .source = "int f(int a,int b,int c,int d){return _Generic(0,int:1,default:a<b ^ c<d);}\n",
    },
    {
        .name = "unselected generic single comparison",
        .source = "int f(int a,int b,int c){return _Generic(0,int:1,default:a<b ^ c);}\n",
        .warnings = 1,
        .notes = 2,
    },
    {
        .name = "two relational operands of each bitwise operator",
        .source = "int f(int a,int b,int c,int d){return (a<b & c<d)+(a>b | c>d)+(a<=b ^ c>=d);}\n",
    },
    {
        .name = "two equality operands of each bitwise operator",
        .source = "int f(int a,int b,int c,int d){return (a==b & c!=d)+(a!=b | c==d)+(a==b ^ c!=d);}\n",
    },
    {
        .name = "mixed equality and relational operands",
        .source = "int f(int a,int b,int c,int d){return (a==b & c<d)+(a>=b | c!=d)+(a!=b ^ c<=d);}\n",
    },
    {
        .name = "eager chains of three comparisons",
        .source = "int f(int a,int b,int c,int d,int e,int g){return (a<b ^ c<d ^ e<g)+(a==b & c==d & e==g)+(a!=b | c!=d | e!=g);}\n",
    },
    {
        .name = "mixed eager bitwise chains",
        .source = "int f(int a,int b,int c,int d,int e,int g){return (a<b & c<d ^ e<g)+(a==b ^ c==d | e==g);}\n",
    },
    {
        .name = "bare bitwise operand suppresses comparison precedence",
        .source = "int f(int a,int b,int c,int d){return (a&b ^ c<d)+(a<b | c^d);}\n",
    },
    {
        .name = "parenthesized comparisons are explicit",
        .source = "int f(int a,int b,int c,int d){return ((a<b) & (c<d))+((a==b)^c)+(a|(b!=c));}\n",
    },
    {
        .name = "relational left operand still warns once per operator",
        .source = "int f(int a,int b,int c){return (a<b & c)+(a<=b | c)+(a>b ^ c);}\n",
        .warnings = 3,
        .notes = 6,
    },
    {
        .name = "relational right operand still warns once per operator",
        .source = "int f(int a,int b,int c){return (a & b>=c)+(a | b<c)+(a ^ b<=c);}\n",
        .warnings = 3,
        .notes = 6,
    },
    {
        .name = "equality left operand still warns once per operator",
        .source = "int f(int a,int b,int c){return (a==b & c)+(a!=b | c)+(a==b ^ c);}\n",
        .warnings = 3,
        .notes = 6,
    },
    {
        .name = "equality right operand still warns once per operator",
        .source = "int f(int a,int b,int c){return (a & b!=c)+(a | b==c)+(a ^ b!=c);}\n",
        .warnings = 3,
        .notes = 6,
    },
    {
        .name = "parenthesized bitwise operand does not suppress warning",
        .source = "int f(int a,int b,int c,int d){return ((a&b) ^ c<d)+(a<b | (c^d));}\n",
        .warnings = 2,
        .notes = 4,
    },
    {
        .name = "nondecimal literal conversion bit patterns and lossy controls",
        .source = "#define X 0xe2\n"
                  "signed char take(signed char x) { return x; }\n"
                  "signed char small(void) { return (0xff); }\n"
                  "signed char large(void) { return 0x100; }\n"
                  "signed char single=0xff, overflow=0x1ff;\n"
                  "signed char values[8]; short s;\n"
                  "void f(void) { values[0]=0xe2; values[1]=(0342); values[2]=0b11100010; values[3]=X; s=0xffff; take(0x80); }\n"
                  "void hex_loss(void) { values[4]=0x100; }\n"
                  "void dec_loss(void) { values[5]=226; }\n"
                  "void calc_loss(void) { values[6]=0xe2+0; }\n"
                  "void unary_loss(void) { values[7]=+0xe2; }\n"
                  "void short_loss(void) { s=65535; }\n"
                  "void call_loss(void) { take(0x180); }\n",
        .warnings = 8,
        .c23 = true,
    },
    {
        .name = "nondecimal conversion with unsigned plain char",
        .source = "char c; signed char s; short h; void f(void) { c=0xe2; s=(0Xff); h=0177777; s=0x100; }\n",
        .options = { "-funsigned-char" },
        .warnings = 1,
    },
    {
        // Clang points at the cast, while the existing checker points at its literal. Compare the complete
        // warning text and severity, apart from that independent location discrepancy.
        .name = "explicit cast does not receive literal exemption",
        .source = "signed char s; void f(void) { s=(int)0xff; }\n",
        .options = { "-funsigned-char" },
        .warnings = 1,
        .compare_warning_text = true,
    },
    {
        .name = "nonliteral integer zero pointer conversion",
        .source = "int*p=1-1;\n",
        .warnings = 1,
    },
    {
        .name = "overflowing double literal",
        .source = "double value=1e400;\n",
        .warnings = 1,
    },
    {
        .name = "underflowing float literal",
        .source = "float value=1e-99f;\n",
        .warnings = 1,
    },
    {
        .name = "ordered pointer integer comparison",
        .source = "int f(int*p){return p<1;}\n",
        .warnings = 1,
    },
    {
        .name = "ordinary declaration declares nothing",
        .source = "int;\n",
        .warnings = 1,
    },
    {
        .name = "untagged record declares nothing",
        .source = "struct{int x;};\n",
        .warnings = 1,
    },
    {
        .name = "plain complex has an inferred element type",
        .source = "_Complex value;\n",
        .warnings = 1,
    },
    {
        .name = "member declaration declares nothing",
        .source = "struct S{int;int x;};\n",
        .warnings = 1,
    },
    {
        .name = "untagged enum member declares its enumerators",
        .source = "struct S{enum{E};};union U{enum{A};};struct T{struct{enum{B};};};int main(void){return E+A+B;}\n",
    },
    {
        .name = "anonymous union member declares a member",
        .source = "struct S{union{int x;};int y;};int main(void){struct S s;s.x=1;return s.x;}\n",
    },
    {
        .name = "named tag member declares nothing",
        .source = "struct S{struct Named{int x;};};\n",
        .warnings = 1,
    },
    {
        .name = "typedef without a declarator requires a name",
        .source = "typedef int;\n",
        .warnings = 1,
    },
    {
        .name = "typedef of a named record without a declarator requires a name",
        .source = "typedef struct S{int x;};\n",
        .warnings = 1,
    },
    {
        .name = "typedef of a named enum without a declarator requires a name",
        .source = "typedef enum E{A};\n",
        .warnings = 1,
    },
    {
        .name = "extern on a tag declaration is ignored",
        .source = "extern struct S;\n",
        .warnings = 1,
    },
    {
        .name = "static on a tag declaration is ignored",
        .source = "static union U;\n",
        .warnings = 1,
    },
    {
        .name = "const on a tag declaration is ignored",
        .source = "const struct S;\n",
        .warnings = 1,
    },
    {
        .name = "qualified ordinary declaration declares nothing",
        .source = "const int;\n",
        .warnings = 1,
    },
    {
        .name = "flexible record member is not last",
        .source = "struct S{int n;int a[];};struct P{struct S s;int after;};\n",
        .warnings = 1,
    },
    {
        .name = "external inline contains modifiable static local",
        .source = "inline int f(void){static int value;return value;}\n",
        .warnings = 1,
        .notes = 1,
    },
    {
        .name = "leading attribute keeps the inline note at the declaration",
        .source = "__attribute__((unused)) inline int g(void){static int value;return value;}\n",
        .warnings = 1,
        .notes = 1,
    },
    {
        .name = "leading extension keeps the inline note after it",
        .source = "__extension__ inline int g(void){static int value;return value;}\n",
        .warnings = 1,
        .notes = 1,
    },
    {
        .name = "trailing attribute keeps the inline note at its first declaration",
        .source = "inline int g(void) __attribute__((unused));\ninline int g(void){static int value;return value;}\n",
        .warnings = 1,
        .notes = 1,
    },
    {
        .name = "used internal function has no definition",
        .source = "static int missing(void);int f(void){return missing();}\n",
        .warnings = 1,
        .notes = 1,
    },
    {
        .name = "evaluated sizeof VLA bound use precedes a later call",
        .source = "static int m(void);void f(void){int a[sizeof(int[m()])];a[0]=m();(void)a;}\n",
        .warnings = 1,
        .notes = 1,
    },
    {
        .name = "evaluated sizeof VLA bound use is a use alone",
        .source = "static int m(void);void f(void){int a[sizeof(int[m()])];(void)a;}\n",
        .warnings = 1,
        .notes = 1,
    },
    {
        .name = "evaluated sizeof VLA bound use in an addition",
        .source = "static int m(void);int f(void){return sizeof(int[m()])+1;}\n",
        .warnings = 1,
        .notes = 1,
    },
    {
        .name = "evaluated alignof VLA bound use",
        .source = "static int m(void);int f(void){return _Alignof(int[m()]);}\n",
        .warnings = 1,
        .notes = 1,
    },
    {
        .name = "evaluated conditional VLA bound use",
        .source = "static int m(void);int f(void){return sizeof(int[1?m():2]);}\n",
        .warnings = 1,
        .notes = 1,
    },
    {
        .name = "evaluated comma VLA bound use",
        .source = "static int m(void);int f(int n){return sizeof(int[(m(),n)]);}\n",
        .warnings = 1,
        .notes = 1,
    },
    {
        .name = "undefined batch follows first use and survives its own promotion",
        .source = "static int first(void);static int second(void);int f(void){return second()+first();}\n",
        .warnings = 2,
        .notes = 2,
    },
    {
        .name = "earlier promoted literal error suppresses final undefined batch",
        .source = "static int missing(void);int f(void){return missing();}double value=1e400;\n",
        .warnings = 2,
        .notes = 1,
    },
    {
        .name = "mapped sparse error retains same body return analysis",
        .source = "struct S{long a,b;};struct S f(int n){int*p=1-1;(void)p;if(n)return(struct S){1,2};}\n",
        .options = { "-Werror=non-literal-null-conversion" },
        .warnings = 1,
        .errors = 1,
    },
    {
        .name = "pre C23 definition omits parameter name",
        .source = "int f(int){return 0;}\n",
        .warnings = 1,
    },
    {
        .name = "literal zero pointer conversion is quiet",
        .source = "int*p=0;\n",
    },
    {
        .name = "nonzero subnormal literal is quiet",
        .source = "float value=1e-45f;\n",
    },
    {
        .name = "exact literal zero with a small exponent is quiet",
        .source = "float value=0e-9999f;\n",
    },
    {
        .name = "explicit complex element type is quiet",
        .source = "_Complex double value;\n",
    },
    {
        .name = "terminal flexible record member is quiet",
        .source = "struct S{int n;int a[];};struct P{int before;struct S s;};\n",
    },
    {
        .name = "external inline constant static local is quiet",
        .source = "inline int f(void){static const int value=1;return value;}\n",
    },
    {
        .name = "later internal definition discharges the warning",
        .source = "static int missing(void);int f(void){return missing();}static int missing(void){return 1;}\n",
    },
    {
        .name = "unevaluated internal function reference is quiet",
        .source = "static int missing(void);unsigned long value=sizeof missing;\n",
    },
    {
        .name = "C23 definition may omit parameter name",
        .source = "int f(int){return 0;}\n",
        .c23 = true,
    },
    {
        // clang's extra `;` of attribute lists alone (#1447): only the C23 lists warn, whatever the GNU lists' order.
        .name = "attribute-only declaration warns only for its C23 lists",
        .source = "[[gnu::unused]] __attribute__((unused));\n"
                  "[[gnu::unused]] __attribute__((unused)) [[gnu::unused]] __attribute__((unused));\n"
                  "__attribute__((unused)) [[gnu::unused]] __attribute__((aligned(8)));\n"
                  "[[gnu::unused]] __attribute__((deprecated, packed)) [[gnu::unused]];\n"
                  "[[gnu::unused]] __attribute__((unknown_gnu));\n"
                  "[[unknown_c23]] __attribute__((unknown_gnu));\n",
        .warnings = 8,
        .c23 = true,
    },
    {
        .name = "attribute-only declaration's GNU lists stay quiet without ignored-attribute warnings",
        .source = "[[gnu::unused]] __attribute__((unused));\n[[unknown_c23]] __attribute__((unknown_gnu));\n",
        .options = { "-Wno-ignored-attributes" },
        .warnings = 1,
        .c23 = true,
    },
    {
        .name = "null conversion source push pop retains named policy",
        .source = "#pragma clang diagnostic push\n#pragma clang diagnostic ignored \"-Wnon-literal-null-conversion\"\n"
                  "int*quiet=1-1;\n#pragma clang diagnostic pop\nint*loud=2-2;\n",
        .warnings = 1,
    },
    {
        .name = "empty declaration source error is promoted",
        .source = "#pragma clang diagnostic error \"-Wmissing-declarations\"\nint;\n",
        .errors = 1,
    },
    {
        .name = "unnamed parameter source suppression is scoped",
        .source = "#pragma clang diagnostic push\n#pragma clang diagnostic ignored \"-Wc23-extensions\"\n"
                  "int quiet(int){return 0;}\n#pragma clang diagnostic pop\nint loud(int){return 0;}\n",
        .warnings = 1,
    },
    {
        .name = "named no error overrides global warning promotion",
        .source = "int*p=1-1;\n",
        .options = { "-Werror", "-Wno-error=non-literal-null-conversion" },
        .warnings = 1,
    },
    {
        .name = "everything does not restore an explicitly disabled diagnostic",
        .source = "int*p=1-1;\n",
        .options = { "-Wno-everything", "-Weverything", "-Wno-missing-variable-declarations" },
    },
    {
        .name = "later broad suppression disables a named diagnostic",
        .source = "int*p=1-1;\n",
        .options = { "-Wnon-literal-null-conversion", "-Wno-everything" },
    },
    {
        .name = "later named diagnostic overrides broad suppression",
        .source = "int*p=1-1;\n",
        .options = { "-Wno-everything", "-Wnon-literal-null-conversion" },
        .warnings = 1,
    },
    {
        .name = "everything retains a named suppression",
        .source = "int*p=1-1;\n",
        .options = { "-Wno-non-literal-null-conversion", "-Weverything", "-Wno-missing-variable-declarations" },
    },
    {
        .name = "system warning families are suppressed by default",
        .source = "# 1 \"system-warning-705.h\" 3\nint*p=1-1;\ndouble value=1e400;\nint;\nint f(int){return 0;}\n"
                  "# 10 \"user-warning-705.c\"\nint ordinary;\n",
    },
    {
        .name = "system warning opt in enables sparse families",
        .source = "# 1 \"system-warning-705.h\" 3\nint*p=1-1;\ndouble value=1e400;\nint;\nint f(int){return 0;}\n"
                  "# 10 \"user-warning-705.c\"\nint ordinary;\n",
        .options = { "-Wsystem-headers" },
        .warnings = 4,
    },
    {
        .name = "user expansion of a system macro retains diagnostic notes",
        .source = "# 1 \"system-warning-705.h\" 3\n#define ZERO (1-1)\n# 10 \"user-warning-705.c\"\nint*p=ZERO;\n",
        .warnings = 1,
        .notes = 1,
    },
    {
        // An indirection through a pointer to void (#147, -Wvoid-ptr-dereference): its operand's type as written (a typedef
        // kept, top-level qualifiers dropped), in dead code too; not right after a unary `&` nor in sizeof's or alignof's
        // operand.
        .name = "void pointer dereferences",
        .source = "typedef void *VP;\nvoid f(void *p, VP v, const void *c, void *const k) {\n"
                  "  (void)*p; (void)*v; (void)*c; (void)*k; void *q = &*p; q = &(*p); q = & *p;\n"
                  "  (void)sizeof(*p); (void)_Alignof(*p); (void)__alignof__ *p; (void)(1 ? *p : *p);\n"
                  "  if (0) (void)*p; (void)**(void **)p; (void)q;\n}\n",
        .warnings = 10,
    },
    {
        // A dereference of a null pointer constant (#1447, -Wnull-dereference): read or assigned (a compound assignment's
        // too, a cast to void's operand too), through casts (a void pointer's, a constant expression's), with clang's note;
        // not its address, a member of it, its increment, a volatile one, a pointer variable's, a subscript, sizeof's
        // operand, nor unreachable code.
        .name = "null pointer dereferences",
        .source = "struct S { int a; };\nint g(int);\nint f(int n) {\n"
                  "  *(int *)0 = 1; *(int *)0 += 2; int x = *(int *)0; g(*(int *)0); int k = n ? *(int *)0 : 1;\n"
                  "  int c = *(const int *)(0); int l = *(int *)(1 - 1); int t = *(char *)(void *)0L;\n"
                  "  int m = (*(struct S *)0).a; int *q = &*(int *)0; (*(int *)0)++; *(volatile int *)0 = 3;\n"
                  "  int *p = 0; *p = 4; int y = ((int *)0)[0]; int s = sizeof(*(int *)0); ((struct S *)0)->a = 2;\n"
                  "  if (0) { int z = *(int *)0; (void)z; }\n"
                  "  (void)*(int *)0;\n"
                  "  return x + k + c + l + t + m + y + s + (q != 0);\n  *(int *)0 = 9;\n}\n",
        .warnings = 9,
        .notes = 9,
    },
    {
        // A nullptr_t operand is a null pointer constant too (#1447, C23): `nullptr` and a nullptr_t variable through casts,
        // not a volatile target.
        .name = "null pointer dereferences of nullptr",
        .source = "typedef typeof(nullptr) np;\nint g(np n) {\n"
                  "  int a = *(int *)n; int b = *(int *)(nullptr); int c = *(volatile int *)nullptr; int d = *(int *)(void *)nullptr;\n"
                  "  *(int *)nullptr = 1;\n"
                  "  return a + b + c + d;\n}\n",
        .c23 = true,
        .warnings = 4,
        .notes = 4,
    },
    {
        // Unreachable initializers (#1447): after a return, in a constant false branch and in a `while (0)`'s body,
        // clang's runtime behavior's warnings (array bounds, division by zero, null dereference) stay silent.
        .name = "runtime warnings skip unreachable initializers",
        .source = "int a[2];\nint f(int n) {\n"
                  "  if (0) { int d = a[5]; int e = n / 0; int z = *(int *)0; (void)d; (void)e; (void)z; }\n"
                  "  while (0) { int d = a[5]; int e = n / 0; int z = *(int *)0; (void)d; (void)e; (void)z; }\n"
                  "  return n;\n"
                  "  { int d = a[5]; int e = n / 0; int z = *(int *)0; (void)d; (void)e; (void)z; }\n}\n",
    },
    {
        // An unreachable initializer's barriers outlive its body's scratch (#1447): the next body's marks and queue
        // must not reuse them, which made a later body's initialized variables "uninitialized when used here".
        .name = "unreachable initializer barriers outlive their body",
        .source = "int f(int n) {\n  return n;\n  int dead = n;\n  return dead;\n}\n"
                  "int g(int n) {\n  int a = n + 1;\n  if (n > 1) n = a;\n  int b = n + 2;\n  if (n > 2) n = b;\n"
                  "  int c = n + 3;\n  if (n > 3) n = c;\n  int d = n + 4;\n  if (n > 4) n = d;\n  return n;\n}\n",
        .options = { "-Wall" },
    },
    {
        // A compound literal's unnamed object is no variable for -Wuninitialized (#1447): its own value, at its closing
        // `}`, is no read within its own initialization. Scalar, pointer, array and struct literals in initializers and
        // assignments, at file scope, in loops, under `&` and nested, say nothing.
        .name = "compound literals are no variables for -Wuninitialized",
        .source = "struct S { int x; int y; };\nstruct T { int n; int *p; };\n"
                  "int *gp = &(int){ 4 };\nstruct S *gs = &(struct S){ .x = 3 };\nint *gq = (int[]){ 5, 6 };\n"
                  "int scalars(void) {\n  int e = (int){ 4 };\n  long l;\n  l = (long){ 5 };\n  int *q;\n  q = (int *){ 0 };\n"
                  "  return e + (int)l + (q != 0) + *gp + gs->x + gq[1];\n}\n"
                  "int aggregates(void) {\n  int a[2] = { (int){ 1 }, (int){ 2 } };\n  int z = { (int){ 3 } };\n"
                  "  struct S s = (struct S){ .x = 1 };\n  struct S m = { .x = (int){ 1 } };\n  int *p = (int[2]){ 1, 2 };\n"
                  "  s = (struct S){ .y = 2 };\n  return a[0] + z + s.x + m.x + p[1];\n}\n"
                  "int loops(int n) {\n  int total = 0;\n"
                  "  for (int i = 0; i < n; i += 1) { int e = (int){ i }; total += e + (int){ 2 }; }\n"
                  "  while (n > 0) { int d = (int){ n }; total += d; n -= 1; }\n  return total;\n}\n"
                  "int addresses(void) {\n  int *p = &(int){ 4 };\n  int **pp = &(int *){ &(int){ 5 } };\n  return *p + **pp;\n}\n"
                  "int nested(void) {\n  int e = (int){ (int){ 4 } };\n  struct T t = (struct T){ .n = (int){ 1 }, .p = &(int){ 2 } };\n"
                  "  int a = (int){ (int){ (int){ 3 } } + 1 };\n  return e + t.n + *t.p + a;\n}\n",
        .options = { "-Wall" },
    },
    {
        // The variables a compound literal's initializer reads keep their warnings (#1447): an uninitialized one is used
        // here, directly or through a nested literal or an assignment's, and the declared variable itself inside its
        // own initializer's literal, braced or not, is used within its own initialization.
        .name = "compound literal initializers keep their variables' uninitialized reads",
        .source = "int reads(void) {\n  int u;\n  int e = (int){ u };\n  return e;\n}\n"
                  "int self(void) {\n  int x = (int){ x };\n  return x;\n}\n"
                  "int nested(void) {\n  int u;\n  int v;\n  int e = (int){ (int){ u } + v };\n  return e;\n}\n"
                  "int assigned(void) {\n  int x;\n  x = (int){ x };\n  return x;\n}\n"
                  "int braced(void) {\n  int y = { (int){ y } };\n  return y;\n}\n"
                  "int pointer(void) {\n  int *p = (int *){ p };\n  return p != 0;\n}\n",
        .options = { "-Wall" },
        .warnings = 7,
        .notes = 4,
    },
    {
        // A logical operator one operand decides though the other isn't known (#1447, clang's CFG tryEvaluateBool):
        // `x && 0` and `x || 1`, through `!` and casts, prune the arm they leave out for the runtime warnings and for
        // -Wreturn-type alike; `x && (x || 1)` and `x && 1` decide nothing.
        .name = "short-circuit conditions one operand decides",
        .source = "int a[2];\nint f(int n) {\n"
                  "  if (n && 0) { n = n / 0; }\n"
                  "  if (!(n || 1)) { n = a[5]; }\n"
                  "  if ((long)(n || 1)) { n += 1; } else { n = n % 0; }\n"
                  "  while (n && 0) { n = *(int *)0; }\n"
                  "  if (n && (n || 1)) { n = n / 0; }\n"
                  "  return n;\n}\n"
                  "int g(int n) {\n  if (n || 1) return 1;\n}\n"
                  "int h(int n) {\n  while (n || 1) { if (n) return 2; }\n}\n"
                  "int k(int n) {\n  if (n && 1) return 1;\n}\n",
        .warnings = 2,
    },
    {
        // The same conditions prune a conditional's arm and a logical operator's right operand (#1447, clang's CFG builder
        // in VisitConditionalOperator and VisitLogicalOperator): `n && 1` and `n || 0` decide nothing.
        .name = "short-circuit operands one operand decides",
        .source = "int a[2];\nint f(int n) {\n"
                  "  int r = (n && 0) ? n / 0 : (n || 1) ? 1 : *(int *)0;\n"
                  "  r += ((n && 0) && n % 0) + ((n || 1) || a[5]) + (!(n || 1) ? a[5] : 0) + ((long)(n && 0) ? *(int *)0 : 1);\n"
                  "  r += (n && 1) ? n / 0 : 0;\n"
                  "  r += (n || 0) || *(int *)0;\n"
                  "  return r;\n}\n",
        .warnings = 2,
        .notes = 1,
    },
    {
        // Clang decides by the context its parser is in (#147): an unselected _Generic association or choose_expr operand in
        // an alignof's operand is unevaluated with it, as are a _Generic's controlling expression and a statement
        // expression in sizeof's; an array declarator's bound, in a sizeof's type name too, is evaluated; and a sizeof of a
        // variable array's element evaluates its operand.
        .name = "void pointer dereferences by context",
        .source = "void *p; int i;\nunsigned long f(int n) {\n  char v[n][n]; int w[(*p, 3)];\n"
                  "  return _Alignof(_Generic(i, int: i, default: *p)) + _Alignof(__builtin_choose_expr(0, i, *p)) + _Generic(*p, void: 1, default: 2)\n"
                  "    + sizeof(({ (void)*p; 1; })) + sizeof(char (*)[(*p, n)]) + sizeof(int[(*p, n)]) + sizeof(v[(*p, 0)]) + sizeof(w);\n}\n"
                  "void g(int a[(*p, 3)]) { (void)a; }\n",
        .warnings = 12,
    },
    {
        // A file-scope declaration of attribute lists and `__extension__`s alone is clang's extra `;` (#1447), which says
        // nothing but its C23 lists' ignored-attribute warnings; GNU attributes after an `__extension__` are specifiers,
        // which declare nothing. A declaration's leading attribute lists, C23's and GNU's in any order, go on past its
        // `__extension__`s.
        .name = "file-scope extension markers after attributes",
        .source = "__extension__;\n__attribute__((unused)) __extension__;\nint a; __extension__ __extension__;\n"
                  "__extension__ __attribute__((unused));\n__attribute__((unused)) [[gnu::unused]] __extension__ int b;\n"
                  "__attribute__((unused)) [[gnu::unused]] __extension__;\n[[gnu::unused]] __extension__ __extension__;\n",
        .warnings = 3,
        .c23 = true,
    },
    {
        // `__extension__`s before a static assertion (#1447), at file scope and in a block: the assertion, checked.
        .name = "extension markers before static assertions",
        .source = "__extension__ _Static_assert(1, \"\");\n__extension__ _Static_assert(0, \"file\");\n"
                  "void f(void) { __extension__ __extension__ _Static_assert(0, \"block\"); }\n",
        .errors = 2,
    },
    {
        // An assignment to a const variable, through an array's subscripts or a record's members to it, or through a
        // pointer to a const record (#147): the variable named with its declared type and the "declared const here" note at
        // its name; a pointer's target is the generic error.
        .name = "const variable assignments",
        .source = "typedef const int CI;\nstruct s { int a; };\nvoid f(const int p, const struct s *q) {\n  const int x = 1; x = 2; x++; p = 3;\n"
                  "  const int a[2] = {0}; a[0] = 1; const int m[2][2] = {0}; m[0][1] = 1;\n"
                  "  CI y = 1; y = 2; const struct s v = {0}; v.a = 1; q->a = 2;\n}\nvoid g(const int *r) { r[0] = 1; *r = 2; }\n",
        .errors = 10,
        .notes = 8,
    },
    {
        // Arithmetic on a pointer to an incomplete type (#147): clang's message of the pointee as written, a subscript's at
        // its `[`, and the "forward declaration" note at the tag's declaring name.
        .name = "incomplete pointer arithmetic",
        .source = "struct s; union u; enum e; typedef struct s S;\nvoid f(struct s *p, struct s *q, union u *w, enum e *n, S *t) {\n"
                  "  (void)(p + 1); (void)(1 + p); (void)(p - q); p++; --p; p += 2; (void)p[1]; (void)1[p];\n"
                  "  (void)(w + 1); (void)(n - 1); (void)(t + 1);\n}\n",
        .errors = 11,
        .notes = 11,
    },
    {
        .name = "independent bodies retain source order at requested lanes",
        .source = "int*f0(void){return 1-1;}\nint*f1(void){return 2-2;}\nint*f2(void){return 3-3;}\n",
        .warnings = 3,
    },
    {
        // A GNU statement expression in an unevaluated operand (#147): its statements are the graph's roots, but clang drops
        // the unused-result and runtime-behavior warnings in sizeof's, _Alignof's, __alignof__'s and typeof's operands
        // (check_common_unevaluated). None of these statement expressions has a side effect, which clang's
        // -Wunevaluated-expression would report.
        .name = "statement expression results in sizeof operands",
        .source = "int *q;\nunsigned long g(void) { return sizeof(({ *q; 1; })); }\nunsigned long k(void) { return sizeof(({ 1 + 2; 1; })); }\n",
    },
    {
        .name = "unused results in unevaluated statement expressions",
        .source = "int *q;\nstruct S { int m; } *ps, vs;\nunsigned long f(int x) {\n"
                  "    return sizeof(({ x == 1; x != 1; x < 1; 1; })) + sizeof(({ (0, x); (void *)q; ps->m; vs.m; 1; })) +\n"
                  "           sizeof(({ x ? 1 : 2; ({ 3; 4; }); 5; })) + sizeof(x ? ({ 1; 2; }) : 3) + sizeof (({ *q; 1; })) +\n"
                  "           __alignof__(({ *q; x == 1; (void *)q; 1; })) + _Alignof(({ 1; 2; }));\n}\n",
        .warnings = 1,
    },
    {
        .name = "runtime behavior warnings in unevaluated statement expressions",
        .source = "int a[2];\nunsigned u;\nint s;\nunsigned long f(int x) {\n"
                  "    return sizeof(({ x / 0; 1; })) + sizeof(({ x % 0; 1; })) + sizeof(({ a[5]; 1; })) + sizeof(({ char c = 300; c; })) +\n"
                  "           sizeof(({ u < s; 1; })) + sizeof(({ int b[2]; b[2]; })) + __alignof__(({ a[2]; x / 0; 1; }));\n}\n",
        .options = { "-Wsign-compare" },
    },
    {
        // A statement expression whose value is unevaluated has no node evaluated either (check_common_region_evaluation):
        // -Wuninitialized reads none of its reads and writes. `sizeof ({ ... })`'s `(` is the statement expression's own.
        .name = "uninitialized variables in unevaluated statement expressions",
        .source = "int f1(void) { int u; (void)sizeof(({ u = 1; })); return u; }\n"
                  "int f2(void) { int u; (void)sizeof(({ u; })); u = 2; return u; }\n"
                  "int f3(int n) { int u; (void)(n ? sizeof(({ u; })) : 0); return 0; }\n"
                  "int f4(void) { int u; (void)({ u = 1; }); return u; }\n"
                  "int f5(void) { int u; return (int)sizeof ({ u; }); }\n"
                  "int f6(void) { int u; return (int)sizeof ({ int v = u; v; }) + (int)__alignof__(({ u; })); }\n"
                  "int f8(void) { int u; return _Generic(1, long: ({ u; }), default: 0); }\n"
                  "int f9(int n) { return sizeof ({ n; }) + sizeof({ (char)n; }) + sizeof ({ int k = n; k; }) * 2; }\n"
                  "int f10(int n) { int u; return (int)sizeof(({ ({ u; }); })) + (int)sizeof(({ (void)sizeof(({ u = 1; })); 1; })) + u; }\n",
        .options = { "-Wall", "-Wno-unevaluated-expression" },
        .warnings = 2,
        .notes = 2,
    },
    {
        // A statement expression whose value is unevaluated has no node evaluated either (check_common_region_evaluation):
        // -Wuninitialized reads none of its reads and writes. `sizeof ({ ... })`'s `(` is the statement expression's own.
        .name = "uninitialized variables in unevaluated statement expressions under -Wextra in C23",
        .source = "int f1(void) { int u; (void)sizeof(({ u = 1; })); return u; }\n"
                  "int f2(void) { int u; (void)sizeof(({ u; })); u = 2; return u; }\n"
                  "int f3(int n) { int u; (void)(n ? sizeof(({ u; })) : 0); return 0; }\n"
                  "int f4(void) { int u; (void)({ u = 1; }); return u; }\n"
                  "int f5(void) { int u; return (int)sizeof ({ u; }); }\n"
                  "int f6(void) { int u; return (int)sizeof ({ int v = u; v; }) + (int)__alignof__(({ u; })); }\n"
                  "int f8(void) { int u; return _Generic(1, long: ({ u; }), default: 0); }\n"
                  "int f9(int n) { return sizeof ({ n; }) + sizeof({ (char)n; }) + sizeof ({ int k = n; k; }) * 2; }\n"
                  "int f10(int n) { int u; return (int)sizeof(({ ({ u; }); })) + (int)sizeof(({ (void)sizeof(({ u = 1; })); 1; })) + u; }\n",
        .options = { "-Wall", "-Wextra", "-Wno-unevaluated-expression" },
        .warnings = 3,
        .notes = 2,
        .c23 = true,
    },
    {
        // A statement expression in a static selection's chosen operand is evaluated where the selection is: its
        // statements, roots of their own, are left out of the selection's unselected roots (#2023), so -Wuninitialized
        // reads them and an initializer's -Wconstant-conversion is given; nested in another selection's other operand,
        // they stay unselected.
        .name = "statement expressions in a chosen selection operand are evaluated",
        .source = "int f1(void) { int u; return _Generic(1, int: ({ u; }), default: 0); }\n"
                  "int f2(void) { int u; return __builtin_choose_expr(1, ({ u; }), 0); }\n"
                  "int f3(void) { return _Generic(1, int: ({ char c = 302; c; }), default: 0); }\n"
                  "int f4(void) { int u; return _Generic(1, int: _Generic(2, long: 0, default: ({ u; })), default: 0); }\n"
                  "int f5(void) { int u; return __builtin_choose_expr(0, _Generic(1, int: ({ u; })), 0); }\n"
                  "int f6(int x) { return _Generic(1, int: ({ x == 1; 0; }), default: 0); }\n"
                  "int f7(void) { int u; return _Generic(1, long: ({ u; }), int: ({ int v = 1; v; })); }\n",
        .options = { "-Wall" },
        .warnings = 5,
        .notes = 4,
    },
    {
        // A discarded statement expression's comparison value warns as clang's DiagnoseUnusedExprResult of the statement
        // expression does (#1447): "expression result unused", no comparison's note, queued after the statements before it,
        // in its own -Wunused-value rather than -Wunused-comparison; a statement's own comparison keeps its warning.
        .name = "a discarded statement expression's comparison value",
        .source = "int g(int);\n"
                  "int f(int x) {\n"
                  "    ({ x; x == 1; });\n"
                  "    ({ l: x == 2; });\n"
                  "    (({ x == 3; }), 0);\n"
                  "    ({ ({ x != 4; }); });\n"
                  "    ({ x > 5; }), x;\n"
                  "    if (x) ({ x == 6; });\n"
                  "    ({ g(x) == 7; });\n"
                  "    ({ (x == 8); });\n"
                  "    x == 9;\n"
                  "    return 0;\n"
                  "}\n",
        .warnings = 11,
        .notes = 1,
    },
    {
        .name = "a discarded statement expression's comparison value under -Wno-unused-comparison in C23",
        .source = "int g(int);\n"
                  "int f(int x) {\n"
                  "    ({ x; x == 1; });\n"
                  "    ({ l: x == 2; });\n"
                  "    (({ x == 3; }), 0);\n"
                  "    ({ ({ x != 4; }); });\n"
                  "    ({ x > 5; }), x;\n"
                  "    if (x) ({ x == 6; });\n"
                  "    ({ g(x) == 7; });\n"
                  "    ({ (x == 8); });\n"
                  "    x == 9;\n"
                  "    return 0;\n"
                  "}\n",
        .options = { "-Wno-unused-comparison" },
        .warnings = 10,
        .c23 = true,
    },
    {
        .name = "typeof statement expressions are unevaluated",
        .source = "int *q;\nvoid f(int x) {\n    __typeof__(({ *q; x == 1; x = x; x / 0; 1; })) t = 0;\n"
                  "    typeof(({ (0, x); (void *)q; 1; })) v = 0;\n    (void)t;\n    (void)v;\n}\n",
        .options = { "-Wself-assign" },
    },
    {
        // The evaluated controls: a statement expression outside the operand, sizeof's own discarded result, and array
        // bounds, which clang evaluates as constant expressions even in a sizeof's type name or in a declaration inside its
        // statement expression, until a nested sizeof makes them unevaluated again.
        .name = "evaluated statement expressions and array bounds keep their warnings",
        .source = "int *q;\nunsigned long f(int x) {\n    ({ *q; 1; });\n    sizeof(({ 1; 2; }));\n"
                  "    unsigned long n = sizeof(int[({ x == 1; 2; })]) + sizeof(({ int w[({ 3; 4; })]; 5; }));\n"
                  "    return n + ({ x < 1; 6; }) + sizeof(int[sizeof(({ 7; 8; }))]);\n}\n",
        .warnings = 6,
        .notes = 1,
    },
    {
        // A sizeof of an expression of variable array type evaluates it after all (clang's TransformToPotentiallyEvaluated),
        // which the contexts mark TRANSFORMED; a statement expression whose value decays to a pointer is no variable array,
        // and stays unevaluated. (A statement expression inside a variable array's operand isn't supported yet.)
        .name = "a statement expression decaying from a variable array stays unevaluated",
        .source = "void g(int n) {\n    char vv[n][n];\n    (void)sizeof(({ 3; vv[0]; }));\n    (void)sizeof(({ 4; vv; }));\n}\n",
    },
    {
        // -Wsign-compare's operands keep their declared typedef's spelling (#1100): a parameter's typedef, a cast's,
        // and sizeof's `__size_t`, each with clang's (aka) of what the sugar hides; the same sugar survives the
        // operands' shared-type arithmetic.
        .name = "sign-compare operands keep their typedef spelling",
        .source = "typedef int wchar_t;\ntypedef unsigned long size_t;\ntypedef int myint;\ntypedef signed char tiny;\n"
                  "int s1(wchar_t wc) { return wc < 0xffU; }\n"
                  "int s2(int n) { int a[4]; return n >= sizeof a / sizeof a[0]; }\n"
                  "int s3(int n, size_t m) { return n < m; }\n"
                  "int s4(myint n, unsigned u) { return n < u; }\n"
                  "int s5(int n, size_t m) { return n < m + 1; }\n"
                  "int s6(int n, size_t m) { return n < 1 + m; }\n"
                  "int s7(int n, size_t m) { return n < (m >> 1); }\n"
                  "int s8(int n, size_t m, unsigned long u) { return n < m + u; }\n"
                  "int s9(int n) { return n < (size_t)1; }\n"
                  "int s10(tiny x, tiny y, unsigned u) { return x + y < u; }\n",
        .options = { "-Wsign-compare" },
        .warnings = 10,
    },
    {
        // A format argument keeps its declared typedef's spelling (#1100), with the (aka) of what it hides.
        .name = "format arguments keep their typedef spelling",
        .source = "typedef unsigned long size_t;\ntypedef long ptrdiff_t;\ntypedef int wchar_t;\ntypedef int myint;\n"
                  "int printf(const char*,...);\n"
                  "void f(size_t m, ptrdiff_t d, wchar_t *w, myint n) { printf(\"%u\", m); printf(\"%u\", d); printf(\"%d\", w); printf(\"%lu\", -n); printf(\"%lu\", +n); printf(\"%lu\", ~n); }\n",
        .options = { "-Wformat" },
        .warnings = 6,
    },
    {
        // A fixed-parameter conversion must not transfer the source cast's typedef to the converted pointer.
        .name = "format fixed conversion does not borrow source typedef",
        .source = "typedef _BitInt(32) T;\nvoid f(const char*, _BitInt(32)*) __attribute__((format(printf,1,2)));\n"
                  "void g(void) { f(\"%d\", (T)0); }\n",
        .options = { "-Wformat", "-Wno-gcc-compat", "-Wno-non-literal-null-conversion" },
        .warnings = 1,
    },
    {
        // A for clause's value in parentheses is the clause's (#1447): clang's IgnoreParens finds the discarded comma,
        // its operand of no effect and its literal 0 idiom through them, in the init and the increment; the condition's
        // value is read.
        .name = "parenthesized comma for clauses discard their values",
        .source = "int g(int);\nvoid f(int n, int *p) {\n    int i = 0, j = 0;\n    for ((i, j); i < n; ++i) {}\n"
                  "    for (; ; (i++, j)) { break; }\n    for (((i, j)); ; ) { break; }\n    for ((j, i++); ; ((i, 2))) { break; }\n"
                  "    for (; (i, j); ) { break; }\n    for ((i == 1, j == 2); ; (i < 2)) { break; }\n"
                  "    for ((i == 1); ; ((i < 2))) { break; }\n    for ((g(1), j); ; (j, (void)0)) { break; }\n"
                  "    for ((i, 0); ; (j, 0)) { break; }\n    for ((void)(i, j); ; ) { break; }\n    for ((p[0], (j)); ; ) { break; }\n}\n",
        .warnings = 14,
        .notes = 1,
    },
    {
        // Clang's Sema gives -Wself-assign as it builds each assignment, so it sorts among the statement's other warnings
        // by place, in unreachable code and in a conditional's or a _Generic's unselected arm too, and before the condition's
        // -Wparentheses at one assignment; types other than int's are spelled.
        .name = "self-assignments in source order among other warnings",
        .source = "void f(int x) { x = x; if (x); }\nvoid g(int x) { x = x; int y = 1 << 40; (void)y; }\n"
                  "void h(int x) { if (0) x = x; return; x = x; }\nvoid k(int x) { x = x; if (x); int y = 0 ? (x = x) : 1; (void)y; }\n"
                  "int m(int x) { return (x = x) + _Generic(x, int: 1, default: (x = x)); }\n"
                  "float fl(float x) { x = x; return x; }\nint *pt(int *p) { p = p; return p; }\nvoid q(int x) { if (x = x) return; }\n",
        .options = { "-Wself-assign" },
        .warnings = 15,
        .notes = 4,
    },
    {
        // __float128 literals (#1250): each value its binary128 bits', printed at 35 digits, a -0's sign too (as every
        // format's), and the format's own limits.
        .name = "__float128 literal conversions and limits",
        .source = "int d = 1.5q;\n_Bool b = 0.1q;\n_Bool t = 0x1p-16494q;\n_Bool z = -0.0q;\nunsigned u = -1.5q;\nint i = 1e40q;\n"
                  "short s = 70000.5q;\nlong long l = 9007199254740993.5q;\n__int128 e = 12345678901234567890123.0q;\n__int128 f = -0.1q;\n"
                  "__float128 big = 1e5000q;\n__float128 small = 1e-5000q;\n__float128 tiny = 0x1p-16495q;\n__float128 rounded = 0x1.8p-16495q;\n"
                  "_Bool zd = -0.0;\nint g(void) { int x = 2.75q; int y = -0.0L; return x + y; }\n",
        .warnings = 15,
    },
    {
        // Clang's ActOnFinishFunctionBody gives a function's unused parameters after its body scope's unused variables
        // and before its missing return.
        .name = "unused parameters after the body's unused variables",
        .source = "int f(int y, int z) { int w; { int q; } if (z) return 1; }\nint g(int y) { int a; return 0; }\n"
                  "void h(int p, int r) { int u; (void)r; }\n",
        .options = { "-Wall", "-Wextra" },
        .warnings = 8,
    },
    {
        // Files that line markers enter (#1954): each diagnostic in one prints clang's "In file included from" chain of the
        // markers' lines when it differs from the last one's, nested, after a flag 2 returns, and for a system header's
        // (silent here) and a user file's entered from the same presumed line; the main file's, the preprocessor's error
        // after them, none.
        .name = "include stacks of files line markers enter",
        .source = "# 1 \"lm_main.c\"\n# 1 \"outer.h\" 1\n# 1 \"inner.h\" 1\nint f(void) { return 1 << 40; }\n"
                  "int f2(void) { return 1 << 41; }\n# 2 \"outer.h\" 2\nint g(void) { return 1 << 33; }\n"
                  "# 3 \"lm_main.c\" 2\nint h(void) { return 1 << 34; }\n# 1 \"again.h\" 1 3 4\nint k(void) { return 1 << 35; }\n"
                  "# 4 \"lm_main.c\" 2\n# 1 \"user.h\" 1\nint m(void) { return 1 << 36; }\n# 5 \"lm_main.c\" 2\n#error done\n",
        .warnings = 5,
        .errors = 1,
    },
    {
        // Clang takes the overflow builtins of _BitInts past 128 bits (#1447) but mul_overflow's of a signed one, as an
        // operand or the destination, at that argument, the first of them alone; an unsigned one's product, and a signed
        // one's sum and difference, are taken.
        .name = "mul_overflow of a signed _BitInt past 128 bits",
        .source = "typedef _BitInt(200) S; typedef unsigned _BitInt(200) U;\n"
                  "int f1(S a, S b, S *r) { return __builtin_mul_overflow(a, b, r); }\n"
                  "int f2(int a, int b, S *r) { return __builtin_mul_overflow(a, b, r); }\n"
                  "int f3(U a, U b, U *r) { return __builtin_mul_overflow(a, b, r); }\n"
                  "int f4(U a, S b, U *r) { return __builtin_mul_overflow(a, b, r); }\n"
                  "int f5(U a, int b, U *r) { return __builtin_mul_overflow(a, b, r); }\n"
                  "int f6(_BitInt(129) a, int b, int *r) { return __builtin_mul_overflow(a, (b), r); }\n"
                  "int f7(__int128 a, __int128 b, _BitInt(256) *r) { return __builtin_mul_overflow(a, b, r); }\n"
                  "int f8(S a, S b, S *r) { return __builtin_add_overflow(a, b, r) + __builtin_sub_overflow(a, b, r); }\n"
                  "int f9(unsigned _BitInt(129) a, U *r) { return __builtin_mul_overflow(a, 3, r); }\n",
        .errors = 5,
    },
    {
        // A tag a prototype's list declares first (#1447, clang's ActOnTag): -Wvisibility at its name (an unnamed enum's
        // keyword), in a definition's list, a nested prototype's (not one the outer list declares already), a member's, a
        // block's and a bound's, a definition shadowing a file-scope tag; a list's redefinition, with its note, and an
        // enum's, which is an unnamed one's too. Not one declared outside, nor an unnamed record.
        .name = "tags declared in a prototype's list",
        .source = "struct S6;\nvoid f1(struct S1 *p);\nvoid f2(struct S2 { int a; } *p);\nvoid f3(union U3 *p);\n"
                  "void f4(enum E4 { A4 } e);\nvoid f5(enum { A5 } e, enum : long { B5 } f);\nvoid f6(struct S6 *p);\n"
                  "void f7(struct S7 *p) { (void)p; }\nint f8(struct S8 (*fp)(struct S9 *q));\nvoid f9(struct S10 *p, int (*g)(struct S10 *));\n"
                  "void (*f10)(struct S11 *);\nvoid f11(void) { void g(struct S12 *); }\nvoid f12(struct { int a; } *p, struct A { struct B *b; } *a);\n"
                  "struct V { void (*fp)(struct U *); };\nstruct T { int b; };\nvoid g1(struct T *p, struct T { int c; } *q);\n"
                  "int g2(struct R { int x; } a, struct R { int y; } b);\nint g3(enum F { B1 } a, enum F { B2 } b);\n"
                  "int g4(int (*a)[sizeof(struct Q { int q; })]);\n",
        .warnings = 22,
        .notes = 2,
    },
    {
        // C23's definitions there are no warning: a compatible definition outside may redefine them.
        .name = "tags declared in a prototype's list under C23",
        .source = "struct S6;\nvoid f1(struct S1 *p);\nvoid f2(struct S2 { int a; } *p);\nvoid f3(union U3 *p);\n"
                  "void f4(enum E4 { A4 } e);\nvoid f5(enum { A5 } e, enum : long { B5 } f);\nvoid f6(struct S6 *p);\n"
                  "void f7(struct S7 *p) { (void)p; }\nint f8(struct S8 (*fp)(struct S9 *q));\nvoid f9(struct S10 *p, int (*g)(struct S10 *));\n"
                  "void (*f10)(struct S11 *);\nvoid f11(void) { void g(struct S12 *); }\nvoid f12(struct { int a; } *p, struct A { struct B *b; } *a);\n"
                  "struct V { void (*fp)(struct U *); };\nstruct T { int b; };\nvoid g1(struct T *p, struct T { int c; } *q);\n"
                  "int g4(int (*a)[sizeof(struct Q { int q; })]);\n",
        .warnings = 10,
        .c23 = true,
    },
    {
        // -Wvisibility's policy: its option and a source pragma.
        .name = "prototype tag visibility policy",
        .source = "void f1(struct S1 *p);\n#pragma clang diagnostic push\n#pragma clang diagnostic ignored \"-Wvisibility\"\n"
                  "void f2(struct S2 *p);\n#pragma clang diagnostic pop\nvoid f3(struct S3 *p, struct S3 { int a; } *q);\n",
        .options = { "-Wno-visibility" },
    },
    {
        .name = "prototype tag visibility pragma",
        .source = "void f1(struct S1 *p);\n#pragma clang diagnostic push\n#pragma clang diagnostic ignored \"-Wvisibility\"\n"
                  "void f2(struct S2 *p);\n#pragma clang diagnostic pop\nint f3(struct S3 { int a; } p, struct S3 { int b; } q);\n",
        .warnings = 3,
        .notes = 1,
    },
    {
        // C23 records redefined with other attributes (#1447): clang's -Wodr is an error by default; ignored, the
        // definitions are compatible, and the name keeps the first's type (its layout, which the assertions read).
        .name = "odr attribute differences ignored",
        .source = "struct S { char c; int a; } __attribute__((packed));\nstruct S { char c; int a; };\n"
                  "_Static_assert(sizeof(struct S) == 5, \"first\");\n"
                  "struct U { char c; int a __attribute__((aligned(16))); };\nstruct U { char c; int a; };\n"
                  "_Static_assert(sizeof(struct U) == 32, \"first u\");\nstruct S s;\nstruct U u;\n",
        .options = { "-Wno-odr" },
        .c23 = true,
    },
    {
        // Demoted, each is a warning with its note at the attribute the earlier list has.
        .name = "odr attribute differences demoted",
        .source = "struct S { char c; int a; } __attribute__((packed));\nstruct S { char c; int a; };\n"
                  "_Static_assert(sizeof(struct S) == 5, \"first\");\n"
                  "struct U { char c; int a __attribute__((aligned(16))); };\nstruct U { char c; int a; };\n"
                  "_Static_assert(sizeof(struct U) == 32, \"first u\");\nstruct S s;\nstruct U u;\n",
        .options = { "-Wno-error=odr" },
        .warnings = 2,
        .notes = 2,
        .c23 = true,
    },
    {
        // Source pragmas: ignored for one, a warning for another (one -Werror leaves), and the default error after them.
        .name = "odr attribute differences under pragmas",
        .source = "struct S { char c; int a; } __attribute__((packed));\n#pragma clang diagnostic push\n#pragma clang diagnostic ignored \"-Wodr\"\n"
                  "struct S { char c; int a; };\n#pragma clang diagnostic pop\n_Static_assert(sizeof(struct S) == 5, \"first\");\n"
                  "struct U { char c; int a __attribute__((aligned(16))); };\n#pragma clang diagnostic push\n#pragma clang diagnostic warning \"-Wodr\"\n"
                  "struct U { char c; int a; };\n#pragma clang diagnostic pop\n_Static_assert(sizeof(struct U) == 32, \"first u\");\n"
                  "struct V { int a; } __attribute__((aligned(8)));\nstruct V { int a; } __attribute__((aligned(16)));\n",
        .warnings = 1,
        .errors = 1,
        .notes = 3,
        .c23 = true,
    },
    {
        // In a system header (here a line marker's), clang ignores it, error or not, without -Wsystem-headers; the name
        // keeps the first definition's type.
        .name = "odr attribute differences in a system header",
        .source = "# 1 \"odr_system.h\" 1 3\nstruct S { char c; int a; } __attribute__((packed));\nstruct S { char c; int a; };\n"
                  "# 4 \"odr_main.c\" 2\n_Static_assert(sizeof(struct S) == 5, \"first\");\nstruct S s;\n",
        .c23 = true,
    },
    {
        // A C23 parameter list's compatible redefinition of its own record (#1869) declares the first's type: the body
        // reads both parameters and a pointer to it as one type, compiled on every path.
        .name = "C23 parameter list redefines its record compatibly",
        .source = "int g(struct T { int x; } a, struct T { int x; } b, struct T *c) { return a.x + b.x + c->x; }\n"
                  "int n(struct W { int a; } *p, int (*q)(struct W { int a; } *r)) { return p->a + (q != 0); }\n",
        .c23 = true,
    },
    {
        // `#pragma pack`'s own warnings (#1849): clang's parser's for malformed directives, at the token they name or past
        // the line's last, and Sema's at the directive (a bad value, a name and a value to pop, an empty stack's pop,
        // show's value: the default's 8, a pack value, options align's).
        .name = "pragma pack syntax and Sema warnings",
        .source = "#pragma pack(3)\n#pragma pack(push, r, 4)\n#pragma pack(pop, r, 2)\n#pragma pack(pop, nosuch)\n#pragma pack\n"
                  "#pragma pack(foo)\n#pragma pack(push, 4) extra\n#pragma pack(pop, 32)\n#pragma pack(push, 4\n#pragma pack(push, r, x)\n"
                  "#pragma pack(+)\n#pragma pack(show)\n#pragma pack(2)\n#pragma pack(show)\n#pragma options align=packed\n#pragma pack(show)\n"
                  "#pragma pack(pop)\n#pragma pack(pop)\nstruct S { char c; int i; };\nint main(void) { return sizeof(struct S) != 6; }\n",
        .warnings = 14,
    },
    {
        // A push left open at the unit's end (#1849): one warning each, the innermost first, the innermost with clang's
        // note at the reset that left the default value.
        .name = "pragma pack pushes left open at the end",
        .source = "#pragma pack(push, 4)\n#pragma pack(push, inner, 1)\nstruct S { char c; int i; };\n#pragma pack()\n"
                  "int main(void) { return sizeof(struct S) != 5; }\n",
        .warnings = 2,
        .notes = 1,
    },
    {
        // The note of a push that no directive set a value after has no place (#1849), which the oracle's count of
        // located notes leaves out; the complete output compares it.
        .name = "pragma pack push left open without a value",
        .source = "#pragma pack(push)\nint main(void) { return 0; }\n",
        .warnings = 1,
    },
    {
        // Sema's show after a function comes after the function's own warnings (#1849): clang handles the annotation at
        // the top level.
        .name = "pragma pack show after a function's warnings",
        .source = "#pragma pack(push, 2)\nint main(void) { int x; return 0; }\n#pragma pack(show)\n#pragma pack(pop)\n",
        .options = { "-Wall" },
        .warnings = 2,
    },
    {
        // The unit's end in clang's Sema::ActOnEndOfTranslationUnit order (#2141): an unterminated pack push, #pragma
        // weak's undeclared identifier, an internal function used but not defined, then the unused file-scope
        // declarations, each after the function's own unused local.
        .name = "unit end warnings in clang's order",
        .source = "#pragma weak nothere\n#pragma pack(push, 4)\nstatic int unused(void) { return 0; }\nstatic int unused_var;\n"
                  "static void declared(void);\nint main(void) { int x; declared(); return 0; }\n",
        .options = { "-Wall" },
        .warnings = 6,
        .notes = 1,
    },
    {
        // Clang diagnoses the unused file-scope declarations only where no error occurred (#2141): under -Werror the
        // undefined internal function's error leaves them out, and alone they reject the unit themselves.
        .name = "unit end unused declarations after an error",
        .source = "static int unused(void) { return 0; }\nstatic int unused_var;\nstatic void declared(void);\nint main(void) { declared(); return 0; }\n",
        .options = { "-Wall" },
        .warnings = 3,
        .notes = 1,
    },
    {
        // An ignored attribute's warning that -Werror promotes is an error too, so clang's ActOnEndOfTranslationUnit gives
        // the unused file-scope variable no warning after it (#2232); without -Werror both warnings are given.
        .name = "unit end unused declarations after a promoted ignored attribute",
        .source = "void rel(int *p);\nstatic int q __attribute__((cleanup(rel)));\n",
        .options = { "-Wall" },
        .warnings = 2,
    },
    {
        // GCC's cast to a union (#2301, clang's CheckCStyleCast): from a member's unqualified type after the operand's
        // lvalue conversion (a qualified, an array's and a char's), -Wgnu-union-cast at the cast's `(` under -pedantic;
        // from no member's type the error "cast to union type from type 'T' not present in union", the operand's type
        // with its sugar; and a cast to a struct from another type "used type 'T' where arithmetic or pointer type is
        // required", at the `(` too.
        .name = "casts to unions",
        .source = "typedef short ms;\nunion U{int*p;long*q;char c;int i;};struct S{int a;};\n"
                  "int f(int n,const int k,int arr[2]){union U u=(union U)&n;union U v=(union U)arr;(void)(union U)(char)n;\n"
                  "(void)(union U)k;(void)v;return *u.p;}\n"
                  "int g(ms s,double d){(void)(union U)s;(void)(union U)d;(void)(struct S)s;return 0;}\n",
        .options = { "-pedantic" },
        .warnings = 4,
        .errors = 3,
    },
    {
        // A record's casts (#2375, clang's CheckCStyleCast): to its own type -Wpedantic's "C99 forbids casting nonscalar type
        // 'T' to the same type" at the cast's `(`, the type as written (a typedef's and a qualified one's); and to an
        // arithmetic or pointer type the error "operand of type 'T' where arithmetic or pointer type is required" at the
        // operand's first token, its type after lvalue conversion (a typedef's sugar kept, a const typedef's dropped).
        .name = "casts of records",
        .source = "struct S{int a;struct S*n;}s;union U{int a;float f;}u;typedef struct S T;typedef const struct S CT;T t;CT ct;\n"
                  "struct S h(void);struct W{struct S in;}w,*wp;\n"
                  "void g(struct S*p){(void)(struct S)s;(void)(union U)u;(void)(const struct S)s;(void)(T)t;(void)(CT)s;(void)(const T)t;\n"
                  "(void)sizeof((T)t);(void)(int)t;(void)(int)ct;(void)(long)u;(void)(char*)s;(void)(int)h();(void)(int)w.in;\n"
                  "(void)(int)wp->in;(void)(float)p[0];(void)(_Bool)*p;(void)(int)(s);}\n",
        .options = { "-pedantic" },
        .warnings = 7,
        .errors = 10,
    },
    {
        // The same error for a cast to an atomic scalar type from a record, and to a scalar from an atomic cast's rvalue
        // (#2375, #2230), its type '_Atomic(int)'.
        .name = "casts of records and atomic rvalues to atomic types",
        .source = "struct S { int a; } s;\nvoid g(int x){ long l = (_Atomic long)(_Atomic int)x; (void)(_Atomic int)s; (void)(_Atomic(int *))s;\n"
                  "(void)(int)(_Atomic int)x; (void)l; }\n",
        .errors = 4,
    },
    {
        // An initializer list's diagnostics in clang's InitListChecker order (#2914): its subobjects' conversion errors,
        // excess elements and overrides as the walk meets them, then the completed initializer's -Wliteral-conversion;
        // a default error's conversion (-Wint-conversion) leaves the list valid, and its excess elements warned, where a
        // hard one's (double to a pointer) doesn't; at file scope, in a body, in arrays.
        .name = "initializer list diagnostics in walk order",
        .source = "struct S { int n; int *p; };\n"
                  "struct S c[2] = { { 1, 2.5 }, { .n = 1, .n = 2 } };\nstruct S d = { 2.5, { 0, 3 } };\nstruct S e = { 1, { 2, 3 } };\n"
                  "struct S g = { 1, 2, 3 };\nint *q = { 2, 3 };\nint *r[2] = { 1, 2, 3 };\nstruct S h = { 1, { 2.5, 3 } };\n"
                  "void f(void) { struct S i = { 2.5, { 0, 3 } }; int x = 1.5; struct S j = { 3.5, 0, 1 }; struct S k = { 1, { 2, 3 } };\n"
                  "int *m = { 2, 3 }; (void)i; (void)x; (void)j; (void)k; (void)m; }\nint t[2] = { 1.5, 2, 3 };\n",
        .warnings = 16,
        .errors = 9,
        .notes = 1,
    },
    {
        // A builtin's call is made after its argument's failed conversion that clang only warns of by default as an error
        // (#2914): its result's own conversion is checked, as an ordinary call's is.
        .name = "builtin results after a failed argument",
        .source = "long g(long);\n"
                  "void f(int *p) { long *l = g(p); long *m = __builtin_expect(p, 0); (void)l; (void)m; }\n",
        .errors = 4,
        .notes = 1,
    },
    {
        // A discarded comparison's -Wunused-comparison follows the comparison's own warnings (#2914): clang's
        // DiagnoseUnusedExprResult runs at the full expression's end.
        .name = "unused comparisons after the comparison's warnings",
        .source = "void f(int *p, char *c) { p < 1; p == 1; p > c; p != c; }\n",
        .warnings = 8,
        .notes = 2,
    },
    {
        // -Wcompare-distinct-pointer-types and -Wpointer-integer-compare name both operands' types (#2914): each after its
        // lvalue conversion (an array's decay, a const's dropped), not the comparison's to their common type, a typedef's
        // sugar kept; ordered and equality comparisons, function pointers, a conditional's condition.
        .name = "comparisons' operand types",
        .source = "typedef int *P; typedef char C; typedef long L;\n"
                  "void f(int *p, P q, C *c, const int *k, int a[2], void (*g)(void), long *l, L n, const int x) {\n"
                  "(void)(p < (char *)0); (void)(q == c); (void)(c != p); (void)(k > (long*)0); (void)(a <= l); (void)(g == (void(*)(int))0);\n"
                  "(void)(p == l ? 1 : 0); (void)(p == 1); (void)(q != n); (void)(x == a); (void)(1 == q); (void)(p == 1 ? 1 : 0); }\n",
        .warnings = 12,
    },
    {
        // A cast between a pointer and a floating or complex type (#2914, clang's CheckCStyleCast), at the operand's first
        // token: "pointer cannot be cast to type 'T'", the target as written (an _Atomic one's value type), from a pointer,
        // an array's or a function's decay; "operand of type 'T' cannot be cast to a pointer type", the operand's type after
        // its lvalue conversion (a typedef's sugar kept, a const's dropped).
        .name = "casts between pointers and floating types",
        .source = "typedef float F; typedef int *P; typedef double D; struct S { int *m; }; int *h(void);\n"
                  "void f(int *p, double d, P q, _Complex float z, const int *cp, int a[2], struct S s, D e, const double cd, _Complex int ci) {\n"
                  "(void)(float)p; (void)(F)q; (void)(double)(p + 1); (void)(int *)d; (void)(P)1.5f; (void)(_Complex double)p; (void)(int*)z;\n"
                  "(void)(long double)cp; (void)(float)(void*)0; (void)(_Float16)p; (void)(float)f; (void)(float)\"x\"; (void)(float)a;\n"
                  "(void)(float)p++; (void)(float)s.m; (void)(float)h(); (void)(float)(d ? p : p); (void)(int*)e; (void)(int*)cd;\n"
                  "(void)(_Atomic float)p; (void)(_Complex int)p; (void)(int*)ci; (void)(char*)(float)p; }\n",
        .errors = 20,
    },
    {
        // A _Generic selection that matches no association and has no default (#2914): clang's "controlling expression
        // type 'T' not compatible with any generic association type" at the controlling expression's first token, its
        // type after the lvalue conversion (a typedef's sugar kept, a const typedef's dropped, an array's decay), at file
        // scope too.
        .name = "generic selections that match no association",
        .source = "typedef int *P; typedef const int CI;\n"
                  "void f(P q, CI c, int a[2], int *p, int x) { (void)_Generic(q, char: 1); (void)_Generic(c, char: 1); (void)_Generic(a, char: 1);\n"
                  "(void)_Generic((P)0, char: 1); (void)_Generic(x + 1.0, char: 1); (void)_Generic((p), char: 1, short: 2); int y = _Generic(p, char: 1) + 1; (void)y; }\n"
                  "int g = _Generic(1.0, char: 1);\n",
        .errors = 8,
    },
    {
        // A cast to or from nullptr_t that C23 6.5.4p4 doesn't allow (#2914, clang's err_bad_cstyle_cast_generic), at the
        // operand's first token: "cannot cast an object of type 'S' to 'T'", the other side's sugar kept (a typedef's, the
        // operand's after its lvalue conversion) and nullptr_t's dropped, an _Atomic target's value type; and the casts
        // it allows, to a pointer, bool or void and from a nullptr_t.
        .name = "casts to and from nullptr_t",
        .source =
                  "typedef float F; typedef typeof(nullptr) N; typedef N M; typedef int I; typedef int *IP; enum E { A };\n"
                  "void f(N n, const N cn, M m, I i, IP p, const int ci, int a[2]) {\n"
                  "(void)(float)nullptr; (void)(_Complex float)nullptr; (void)(F)n; (void)(enum E)m; (void)(long double)cn; (void)(_BitInt(8))nullptr;\n"
                  "(void)(_Atomic float)n; (void)(N)1; (void)(N)i; (void)(N)p; (void)(M)ci; (void)(N)a; (void)(N)(int*)0; (void)(N)1.5; (void)(const N)p;\n"
                  "(void)(I)n; (void)(N)\"x\";\n"
                  "(void)(_Bool)nullptr; (void)(void*)n; (void)(int*)m; (void)(void)n; (void)(N)n; (void)(N)0; (void)(N)(void *)0; }\n",
        .errors = 17,
        .c23 = true,
    },
    {
        // A null pointer constant cast to nullptr_t (#2914): an integer constant expression's zero, a character's, an
        // enumerator's, false and (void *)0, at file scope as a static object's constant too.
        .name = "null pointer constants cast to nullptr_t",
        .source =
                  "typedef typeof(nullptr) N; enum E { A };\n"
                  "N g = (N)0; N h = (N)(void *)0; static N k = (N)false; N u; void *v = (N)0; struct P { int a; N n; } ps = { 1, (N)0 };\n"
                  "int f(void) { N a = (N)0; N b = (N)(void*)0; N c = (N)(1 - 1); N d = (N)A; N e = (N)'\\0'; N q = (N)(char)0; N r = (N)((void*)0);\n"
                  "return (a == nullptr) + (b == nullptr) + (c == nullptr) + (d == nullptr) + (e == nullptr) + (q == nullptr) + (r == nullptr) + (g == nullptr) + (h == nullptr) + (k == nullptr); }\n",
        .c23 = true,
    },
    {
        // A _Generic selection's duplicate associations (#2914, clang's CreateGenericSelectionExpr and its parser): each
        // type compatible with an earlier one's, for every earlier one, at the later type name past its qualifiers with
        // "compatible type 'T' specified here" at the earlier; a second default alone, its parser stopping there; in a
        // body, at file scope, in an array bound, a case label and a static assertion.
        .name = "generic selections' duplicate associations",
        .source =
                  "typedef int I; typedef const int CI;\n"
                  "void f(int x) {\n"
                  "(void)_Generic(x, int: 1, int: 2, int: 3); (void)_Generic(x, I: 1, int: 2); (void)_Generic(x, char: 1, int: 2, char: 3, short: 4);\n"
                  "(void)_Generic(x, int: 1, int: 2, default: 1, default: 2, default: 3); (void)_Generic(x, default: 1, default: 2);\n"
                  "(void)_Generic(x, CI: 3, default: 0); (void)_Generic(x, int*: 1, int*: 2);\n"
                  "(void)_Generic(x, int(*)[]: 1, int(*)[2]: 2); (void)_Generic(x, long: 1, long int: 2); (void)_Generic(x, default: 0, int[2]: 3, int: 1, int: 2);\n"
                  "}\n"
                  "int g = _Generic(1, int: 1, int: 2);\n"
                  "int h[_Generic(1, long: 1, long: 2)];\n"
                  "int k(void) { switch (1) { case _Generic(1, int: 1, int: 2): return 0; } return 1; }\n"
                  "_Static_assert(_Generic(1, default: 1, default: 2), \"\");\n",
        .warnings = 2,
        .errors = 15,
        .notes = 15,
        .c23 = true,
    },
    {
        // -Wabsolute-value (#2914, clang's CheckAbsoluteValueFunction): an unsigned argument's, a larger one's of the function's kind,
        // another kind's, each with its replacement's note (the header's where it is undeclared, none where a declaration of it isn't the
        // library's), of builtins, library functions and a parenthesized callee; and what it leaves alone (bool, a _Complex's cabs with a
        // floating argument too small for any).
        .name = "absolute value functions' arguments",
        .source =
                  "int abs(int); long labs(long); double fabs(double); float fabsf(float);\n"
                  "typedef unsigned long size_type; typedef long L; enum E { A, B };\n"
                  "size_type s; const unsigned cu; L lv; enum E e; _Bool bo; unsigned char uc; char ch; __int128 i128; long double ld; float fl; double d; _Complex double cd; int *p; int arr[2]; void fn(void);\n"
                  "void g(void) {\n"
                  "(void)__builtin_abs(cu); (void)__builtin_abs(lv); (void)__builtin_abs(d); (void)__builtin_fabs(ch); (void)__builtin_fabsf(d); (void)__builtin_labs(ld);\n"
                  "(void)abs(s); (void)abs(lv); (void)abs(d); (void)fabs(ch); (void)fabsf(ld); (void)abs(e); (void)abs(bo); (void)abs(uc); (void)abs(i128); (void)fabs(fl);\n"
                  "(void)__builtin_abs(cd); (void)__builtin_cabs(d); (void)__builtin_llabs(ch); (void)(abs)(lv); (void)abs((L)1); (void)abs(1.0f);\n"
                  "}\n"
                  "static long llabs(long long x) { return x; }\n"
                  "void h(void) { (void)abs(1LL); }\n",
        .warnings = 21,
        .notes = 20,
        .c23 = true,
    },
    {
        // -Wabsolute-value's pointer, array and function forms (#2914), after their argument's -Wint-conversion error, of builtins and
        // library functions.
        .name = "absolute value functions of pointers",
        .source =
                  "int abs(int); long labs(long);\n"
                  "int *p; int arr[2]; void fn(void);\n"
                  "void g(void) { (void)__builtin_abs(p); (void)__builtin_labs(arr); (void)labs(arr); (void)abs(fn); (void)__builtin_llabs(p); }\n",
        .warnings = 5,
        .errors = 5,
        .notes = 2,
        .c23 = true,
    },
    {
        // -Wint-to-pointer-cast and -Wint-to-void-pointer-cast (#2914, clang's checkIntToPointerCast): a typedef's sugar on either side,
        // the target's qualifiers dropped and an _Atomic one's value type, in sizeof, of a bit-field and a _BitInt; none of bool, an
        // enumeration, a wide integer or an integer constant expression.
        .name = "casts to pointers from narrower integers",
        .source =
                  "typedef short S; typedef int *IP; typedef void *VP; typedef const void *CVP;\n"
                  "enum E { A }; enum E e; S s; char c; _Bool bo; int i; long l; unsigned _BitInt(63) u63; _BitInt(7) b7; const short cs; volatile char vc; __int128 i128;\n"
                  "struct R { int f : 3; } r;\n"
                  "void f(void) {\n"
                  "(void)(void*)s; (void)(IP)c; (void)(VP)i; (void)(void*)e; (void)(void*)bo; (void)(void*)l; (void)(void*)u63; (void)(void*)b7; (void)(CVP)i;\n"
                  "(void)(void*)(char)1; (void)(void*)(s+1); (void)(void*)cs; (void)(void*)vc; (void)(const void*)c; (void)sizeof((void*)c);\n"
                  "(void)(_Atomic(int*))c; (void)(void(*)(void))c; (void)(int(*)[2])c; (void)(void*)'a'; (void)(void*)(short)i; (void)(char*)(c);\n"
                  "(void)(void*)(char)(1 ? 2 : i); (void)(void*)(enum E)c; (void)(void*)__extension__ c; (void)(void*)r.f; (void)(int * const)c; (void)(void*)i128;\n"
                  "(void)(void*)(c = 1); (void)(void*)c++; (void)(void*)(i, c); (void)(void*)(int)1.5; (void)(void*)(1 + 2); (void)(void*)(char)i; }\n"
                  "void *g = (void*)(char)3;\n",
        .warnings = 24,
        .c23 = true,
    },
    {
        // A builtin's later arguments' conversion errors after a default error's (#2914, GatherArgumentsForCall), none after a hard one,
        // and a size_t parameter as clang spells it, '__size_t' (aka 'unsigned long').
        .name = "builtins' later failed arguments",
        .source =
                  "struct S { int a; } s; int *p; float *fp; double d; char q[4];\n"
                  "void f(void) {\n"
                  "long a = __builtin_expect(p, p); long c = __builtin_expect(p, s); long e = __builtin_expect_with_probability(p, p, p);\n"
                  "void *m = __builtin_memcpy(1, 2, p); void *n = __builtin_memcpy(fp, d, p);\n"
                  "(void)__builtin_alloca_with_align(p, 64); __xray_typedevent(p, q, p);\n"
                  "(void)a; (void)c; (void)e; (void)m; (void)n; }\n",
        .errors = 14,
        .c23 = true,
    },
    {
        // A floating builtin's argument that doesn't convert to its prototype's parameter (#2914): "passing 'T' to parameter of
        // incompatible type 'U'" at the argument; and the integer absolute value builtins' -Wint-conversion.
        .name = "floating builtins' prototypes",
        .source =
                  "int *p; struct S { int a; } s;\n"
                  "void f(void) { (void)__builtin_fabs(p); (void)__builtin_fabsf(p); (void)__builtin_fabsl(s); (void)__builtin_canonicalize(p); (void)__builtin_signbitf(p); (void)__builtin_abs(p); (void)__builtin_labs(p); }\n",
        .warnings = 2,
        .errors = 7,
        .c23 = true,
    },
    {
        // An initializer list at file scope with a default error keeps its other parts' conversion warnings, as at block scope (#2914):
        // the rejected view casts the failed part's source.
        .name = "file-scope initializers beside errors",
        .source =
                  "char c0 = 1000;\n"
                  "char c = 1000;\n"
                  "struct S { int *p; int n; char c; } s = { 2, 1.5, 1000 };\n"
                  "int a[3] = { 1.5, (int*)0, 2.5 };\n"
                  "struct S t[2] = { { 2, 1.5 }, { 3, 2.5 } };\n"
                  "int *h = 2;\n"
                  "int z = 1.5;\n",
        .warnings = 9,
        .errors = 5,
        .c23 = true,
    },
    {
        // A _Generic selection's diagnostics in clang's CreateGenericSelectionExpr order at its `)` (#2914): each association's
        // -Wunreachable-code-generic-assoc, then its type's errors against later associations', and the no-match error after them.
        .name = "generic selections' diagnostics in clang's order",
        .source =
                  "void f(int x) {\n"
                  "(void)_Generic(x, int: 1, char: 2, char: 3, int: 4);\n"
                  "(void)_Generic(x, const int: 1, int const: 2, int[2]: 3, default: 0);\n"
                  "(void)_Generic(x, int[2]: 1, int[3]: 2);\n"
                  "(void)_Generic(x, int: 1, const char: 2, char: 3, int: 4, long[1]: 5);\n"
                  "}\n"
                  "int h[_Generic(1, long: 1, const int: 2, long: 3)];\n",
        .warnings = 8,
        .errors = 6,
        .notes = 5,
        .c23 = true,
    },
    {
        // A GNU attribute's argument a stray token follows (#2914, clang's ParseGNUAttributeArgs and ParseGNUAttributes): "expected ')'"
        // twice, a third where more of the list follows, and the declaration's "extraneous ')' before ';'"; no undeclared name's error.
        .name = "attributes' stray argument tokens after declarators",
        .source =
                  "int y __attribute__((aligned(8 8)));\n"
                  "int n; int z __attribute__((aligned(n n)));\n"
                  "int y2 __attribute__((aligned(8 8, 4)));\n"
                  "int y3 __attribute__((aligned(8 8), unused));\n",
        .errors = 13,
        .c23 = true,
    },
    {
        // The same with the declaration's other ends (#2914): "expected ';' after top level declarator" and a function's body.
        .name = "attributes' stray argument tokens before declarators' ends",
        .source =
                  "int y4 __attribute__((unused, aligned((8) 8)));\n"
                  "int y5 __attribute__((aligned(8 8))), z5;\n"
                  "int y6 __attribute__((aligned(8 8))) = 3;\n"
                  "void g(void) __attribute__((aligned(8 8)));\n",
        .errors = 12,
        .c23 = true,
    },
    {
        // The same in members and a block (#2914), the unit's later warnings given as clang's recovery reads on.
        .name = "attributes' stray argument tokens in members and blocks",
        .source =
                  "struct B { int x __attribute__((aligned(4 4))), y; int z; };\n"
                  "struct A { int m; int *p __attribute__((aligned(m m))); };\n"
                  "void f(void) { int w __attribute__((aligned(8 8))) = 1; (void)w; char c = 1000; (void)c; }\n"
                  "int w = 1.5;\n",
        .warnings = 2,
        .errors = 9,
        .c23 = true,
    },
    {
        // On functions (#2914): the body's error by the declarator's derivation, after its other attributes too, not a function
        // pointer's, not after an asm label or a later declarator; a definition's skip to the next `;` leaves `kept` undeclared.
        .name = "attributes' stray argument tokens on functions",
        .source =
                  "void f(void) __attribute__((unused)) __attribute__((aligned(8 8))) { } int kept; int *p = &kept; int y __attribute__((aligned(8 8))), z;\n"
                  "int (*q)(void) __attribute__((aligned(8 8)));\n"
                  "int r(void) __asm__(\"r\") __attribute__((aligned(8 8)));\n"
                  "int s, t(void) __attribute__((aligned(8 8)));\n",
        .errors = 16,
        .c23 = true,
    },
    {
        // The list's attributes before the failed one stay (#2914): the declarator's deprecation is warned of at its uses.
        .name = "attributes' stray argument tokens after kept attributes",
        .source =
                  "int old __attribute__((deprecated, aligned(8 8))), skipped; int read_old(void) { return old; }\n"
                  "int g(void) { int older __attribute__((deprecated, aligned(8 8))), skipped2; return older; }\n",
        .warnings = 2,
        .errors = 6,
        .notes = 2,
        .c23 = true,
    },
    {
        // A definition at the unit's end, without a `;` to skip to (#2914).
        .name = "attributes' stray argument tokens at the unit's end",
        .source = "int x = 1; void f(void) __attribute__((unused, aligned(8 8))) {}\n",
        .errors = 3,
        .c23 = true,
    },
    {
        .name = "unit end unused declarations alone",
        .source = "static int unused(void) { return 0; }\nstatic int unused_var;\nint main(void) { return 0; }\n",
        .options = { "-Wall" },
        .warnings = 2,
    },    {
        // GNU's designators (#2202), as clang's parser warns of them: an array designation without its `=` (at the value) and
        // an old-style field designator (at its name), on by default, before the value's own conversion warnings; an array
        // range (at its `...`), -pedantic's; all -Wgnu-designator's, under -Wgnu, and a pragma's ignored region drops them.
        .name = "GNU designators by default",
        .source = check_driver_gnu_designator_source,
        .warnings = 11,
    },
    {
        .name = "GNU designators under -pedantic",
        .source = check_driver_gnu_designator_source,
        .options = { "-pedantic" },
        .warnings = 13,
    },
    {
        .name = "GNU designators under -pedantic-errors",
        .source = check_driver_gnu_designator_source,
        .options = { "-pedantic-errors" },
        .warnings = 2,
        .errors = 11,
    },
    {
        .name = "GNU designators under -Wno-gnu-designator",
        .source = check_driver_gnu_designator_source,
        .options = { "-Wno-gnu-designator" },
        .warnings = 2,
    },
    {
        .name = "GNU designators under -Wno-gnu -Wgnu-designator",
        .source = check_driver_gnu_designator_source,
        .options = { "-Wno-gnu", "-Wgnu-designator" },
        .warnings = 13,
    },
    {
        // Automatic const objects without an initializer (#2168): -Wdefault-const-init-var-unsafe of a const type, an
        // array's, a typedef's ('volatile CI[2]' (aka ...)), a pointer's; -Wdefault-const-init-field-unsafe of a struct with a
        // const member, nested, with its note; both of a const struct; none of a union, an array of structs, an extern or
        // an initialized one; static storage's off by default.
        .name = "default-initialized const objects",
        .source = "typedef const int CI;\n"
                  "typedef const volatile int CVI;\n"
                  "const int file_a;\n"
                  "static const int file_b;\n"
                  "extern const int file_c;\n"
                  "struct M { const int m; int x; };\n"
                  "struct N { struct M inner; int y; };\n"
                  "union U { const int u; float f; };\n"
                  "struct M file_m;\n"
                  "void f(void)\n"
                  "{\n"
                  "    const int a;\n"
                  "    const int b[2];\n"
                  "    const volatile int c;\n"
                  "    volatile CI d[2];\n"
                  "    CVI e;\n"
                  "    static const int s;\n"
                  "    extern const int ex;\n"
                  "    struct M m;\n"
                  "    struct N n;\n"
                  "    union U u;\n"
                  "    const struct M cm;\n"
                  "    struct M ms[2];\n"
                  "    const int ok = 1;\n"
                  "    register const int r;\n"
                  "    struct { const int z; } anon;\n"
                  "    const int *p;\n"
                  "    int *const q;\n"
                  "}\n",
        .warnings = 12,
        .notes = 4,
    },
    {
        // A struct's const member through a union member and an anonymous struct; none of a union itself.
        .name = "const members through unions and anonymous structs",
        .source = "struct M { const int m; };\n"
                  "union V { struct M s; int i; };\n"
                  "struct W { union V v; };\n"
                  "struct X { int a; struct { const int deep; }; };\n"
                  "void f(void) { union V v; struct W w; struct X x; }\n",
        .warnings = 2,
        .notes = 2,
    },
    {
        // A bit-field, a const struct member, a typedef's; not a const array member nor a flexible array member; a
        // variable array's and an _Atomic's const objects.
        .name = "const members' kinds",
        .source = "struct A { const int a[2]; };\n"
                  "struct B { int n; const int fam[]; };\n"
                  "struct C { const int bf : 3; };\n"
                  "struct D { struct A arr[2]; };\n"
                  "struct E { const struct { int q; } s; };\n"
                  "typedef const int CI;\n"
                  "struct F { CI t; };\n"
                  "void f(void) { struct A a; struct B b; struct C c; struct D d; struct E e; struct F g; const struct A ca; struct A *p; }\n"
                  "void k(int n) { const int vla[n]; _Atomic const int at; const int ci = 1, cj; }\n",
        .warnings = 7,
        .notes = 3,
    },
    {
        // -Wc++-compat adds -Wdefault-const-init-var of static storage, and the unsafe ones' "and is incompatible with
        // C++".
        .name = "default-initialized const objects and -Wc++-compat",
        .source = "typedef const int CI;\n"
                  "typedef const volatile int CVI;\n"
                  "const int file_a;\n"
                  "static const int file_b;\n"
                  "extern const int file_c;\n"
                  "struct M { const int m; int x; };\n"
                  "struct N { struct M inner; int y; };\n"
                  "union U { const int u; float f; };\n"
                  "struct M file_m;\n"
                  "void f(void)\n"
                  "{\n"
                  "    const int a;\n"
                  "    const int b[2];\n"
                  "    const volatile int c;\n"
                  "    volatile CI d[2];\n"
                  "    CVI e;\n"
                  "    static const int s;\n"
                  "    extern const int ex;\n"
                  "    struct M m;\n"
                  "    struct N n;\n"
                  "    union U u;\n"
                  "    const struct M cm;\n"
                  "    struct M ms[2];\n"
                  "    const int ok = 1;\n"
                  "    register const int r;\n"
                  "    struct { const int z; } anon;\n"
                  "    const int *p;\n"
                  "    int *const q;\n"
                  "}\n",
        .options = { "-Wc++-compat" },
        .warnings = 15,
        .notes = 4,
    },
    {
        // A file scope's const object warns once, at the unit's end, at its last tentative definition, with its type
        // completed (`'const int[1]'`), after its tentative array's warning, in the order of their first tentative
        // definitions; none where a later declaration initializes it.
        .name = "tentative const definitions",
        .source = "const int a;\n"
                  "const int a;\n"
                  "int arr[];\n"
                  "extern const int x;\n"
                  "const int x;\n"
                  "const int b[];\n"
                  "const int c[];\n"
                  "const int c[3];\n"
                  "const int z;\n"
                  "const int z = 2;\n"
                  "static const int s;\n"
                  "const int t[];\n"
                  "void f(void) { int unused; }\n",
        .options = { "-Wall", "-Wdefault-const-init" },
        .warnings = 11,
    },
    {
        // The words follow -Wc++-compat's pragma, which holds the unsafe warnings too.
        .name = "-Wc++-compat by source pragma",
        .source = "#pragma clang diagnostic warning \"-Wc++-compat\"\n"
                  "void f(void) { const int a; }\n"
                  "#pragma clang diagnostic ignored \"-Wc++-compat\"\n"
                  "void g(void) { const int b; }\n",
        .warnings = 1,
    },
    {
        // A tentative definition's -Wdefault-const-init-var at the unit's end, after the undefined internal functions'
        // and before the unused declarations'.
        .name = "tentative definitions' const objects at the unit's end",
        .source = "#pragma pack(push, 4)\n"
                  "#pragma weak never_declared\n"
                  "static void undefined_internal(void);\n"
                  "static int unused_static;\n"
                  "const int tentative;\n"
                  "static const int tentative_static;\n"
                  "void use(void) { undefined_internal(); }\n",
        .options = { "-Wall", "-Wdefault-const-init", "-Wunused" },
        .warnings = 7,
        .notes = 1,
    },
};
static const size_t fixture_57_lengths[] = {
sizeof(check_driver_feature_tested_attributes_source)-1,
sizeof(check_driver_feature_tested_attributes_source)-1,
sizeof(check_driver_atomic_access_source)-1,
sizeof(check_driver_atomic_access_source)-1,
sizeof(check_driver_atomic_access_source)-1,
sizeof(check_driver_atomic_access_source)-1,
sizeof(check_driver_atomic_access_valid_source)-1,
sizeof(check_driver_atomic_access_valid_source)-1,
sizeof("struct A { int x; };\n_Atomic(struct A) a;\nint use = a.x;\n")-1,
sizeof("struct A { int x; };\n_Atomic(struct A) a;\nint *p = &a.x;\n")-1,
sizeof("struct A { int x; };\n_Atomic(struct A) a;\nint f(void) { return a.missing; }\n")-1,
sizeof("struct B { int x; };\nstruct A { struct B b; };\n_Atomic(struct A) a;\n"
                  "_Atomic(union U { int x; double d; }) u;\nint f(void) { return a.b.x + u.x; }\n")-1,
sizeof("struct A { int x; };\n_Atomic(struct A) a;\n_Atomic(struct A) *p;\n"
                  "int f(int n) { if (0) return a.x; if (n) return p->x; return 0; a.x = 1; }\n"
                  "int g(void) { return 0 && a.x; }\nint h(void) { return 1 ? 0 : p->x; }\n")-1,
sizeof("struct A { int x; };\n_Atomic(struct A) a;\n_Atomic(struct A) *p;\n"
                  "int f(int n) { if (0) return a.x; if (n) return p->x; return 0; a.x = 1; }\n"
                  "int g(void) { return 0 && a.x; }\nint h(void) { return 1 ? 0 : p->x; }\n")-1,
sizeof("struct A { int x; };\n_Atomic(struct A) a;\n"
                  "void f(void) { if (0) a.x = 0; int q = undeclared; (void)q; }\n")-1,
sizeof("struct A { int x; };\n_Atomic(struct A) a;\n"
                  "#pragma clang diagnostic push\n#pragma clang diagnostic ignored \"-Watomic-access\"\n"
                  "int ignored(void) { return a.x; }\n#pragma clang diagnostic pop\n"
                  "#pragma clang diagnostic warning \"-Watomic-access\"\nint warning(void) { return a.x; }\n"
                  "#pragma clang diagnostic error \"-Watomic-access\"\nint error(void) { return a.x; }\n")-1,
sizeof("struct A { int x; };\n_Atomic(struct A) a;\n"
                  "int f(void) { return a.x; }\nint *p = &a.x;\n")-1,
sizeof("struct A { int x; };\n_Atomic(struct A) a;\n"
                  "#pragma clang diagnostic error \"-Watomic-access\"\n"
                  "int f(void) { return a.x; }\nint *p = &a.x;\n")-1,
sizeof("struct A { int x; };\n_Atomic(struct A) a;\nint *p = &a.x;\n"
                  "int f(void) { return 0 && a.x; }\n")-1,
sizeof("struct A { int x; };\n_Atomic(struct A) a;\n"
                  "int f(int x, int y, int z) { return x < y < z; }\n"
                  "int g(void) { return 0 && a.x; }\n")-1,
sizeof("enum { A = 3 };\n"
                  "_Static_assert(A == 4, \"a\");\n"
                  "_Static_assert(1 && A > 2 && (A < 3 || A > 5), \"b\");\n"
                  "_Static_assert(-A == 4 && 1, \"c\");\n"
                  "_Static_assert('a' == A, \"d\");\n"
                  "_Static_assert(1.5 + A < 2.0, \"e\");\n"
                  "_Static_assert((_Bool)A == 0, \"f\");\n"
                  "_Static_assert(A + 0u > 5u, \"g\");\n"
                  "_Static_assert((char)A == 'b', \"h\");\n"
                  "_Static_assert((char)200 == (char)'\\n', \"i\");\n"
                  "_Static_assert(A < 1 == 1, \"j\");\n"
                  "_Static_assert(A - 3, \"k\");\n"
                  "_Static_assert(0x80000000 == A + 3000000000, \"l\");\n"
                  "_Static_assert(1e300 * A == 0.1f, \"m\");\n"
                  "_Static_assert(1e-5 * A == 1e5, \"n\");\n"
                  "_Static_assert(sizeof A == sizeof (A) + sizeof(int), \"o\");\n"
                  "_Static_assert(__alignof__(A) == 2 * _Alignof(int), \"p\");\n")-1,
sizeof("enum { A = 3 };\n"
                  "_Static_assert('\\0' == 1 && 0, \"q\");\n"
                  "_Static_assert((0), \"r\");\n"
                  "_Static_assert(1 && (0), \"s\");\n"
                  "_Static_assert(0 && 2 == 3, \"t\");\n"
                  "_Static_assert(L'\\x263a' + u'x' == 1, \"u\");\n"
                  "_Static_assert(-0.0 == 1.0L, \"v\");\n"
                  "_Static_assert((A & 1) == 0 && (A | 4) == 3, \"w\");\n"
                  "_Static_assert((A << 2) == (A >> 1), \"x\");\n"
                  "_Static_assert(A == 3 ? 0 : 1, \"y\");\n"
                  "_Static_assert(!A, \"z\");\n"
                  "void f(void) { _Static_assert(A * 1000000 == 4, \"block\"); }\n")-1,
sizeof("enum { A = 3 };\n"
                  "_Static_assert((bool)A == false, \"a\");\n"
                  "_Static_assert((_Bool)A == 0, \"b\");\n"
                  "_Static_assert(1wb + A == 2uwb, \"c\");\n"
                  "_Static_assert(1'000 * A == 18446744073709551615u, \"d\");\n"
                  "_Static_assert(alignof(int) == sizeof 1 + 1, \"e\");\n"
                  "_Static_assert(true && A == 4, \"f\");\n"
                  "_Static_assert(u8'a' == 1.0e10, \"g\");\n"
                  "_Static_assert((float)A / 3 == 2, \"h\");\n"
                  "_Static_assert(false, \"i\");\n")-1,
sizeof("int g(int);\n"
                  "int f(int x)\n"
                  "{\n"
                  "    int r = 0;\n"
                  "    r += 0 && ({ x << 40; 1; });\n"
                  "    r += 1 || ({ 1 / 0; 1; });\n"
                  "    r += 0 ? ({ x << 33; 1; }) : 2;\n"
                  "    if (0) { r += ({ x << 34; 1; }); }\n"
                  "    return r;\n"
                  "    r += ({ x << 35; 1; });\n"
                  "}\n")-1,
sizeof("int f(int x)\n"
                  "{\n"
                  "    int r = 0;\n"
                  "    return r;\n"
                  "    r += x << 35;\n"
                  "    x << 36;\n"
                  "    r += ({ x << 37; 1; });\n"
                  "    ({ x << 38; 1; });\n"
                  "}\n")-1,
sizeof("int g(int);\n"
                  "int f(int x, int y)\n"
                  "{\n"
                  "    int r = ({ x << 40; 1; });\n"
                  "    r += y ? ({ x << 41; 2; }) : ({ x << 42; 3; });\n"
                  "    r += 1 && ({ x / 0; 1; });\n"
                  "    r += ({ if (x) goto out; 0; });\n"
                  "    r += ({ int k = ({ x << 43; 4; }); k; });\n"
                  "    for (;;) { r += ({ x << 44; 1; }); if (r) break; }\n"
                  "    while (1) { }\n"
                  "    r += ({ x << 45; 1; });\n"
                  "out:\n"
                  "    r += ({ x << 46; 1; });\n"
                  "    r += 0 && ({ int u; u + ({ x << 47; 1; }); });\n"
                  "    return r;\n"
                  "}\n"
                  "int h(int x)\n"
                  "{\n"
                  "    int r = ({ if (x) return 1; x << 48; 2; });\n"
                  "    r += ({ return 2; x << 49; 3; });\n"
                  "    return r;\n"
                  "}\n")-1,
sizeof("int g(int);\n"
                  "int f(int x)\n"
                  "{\n"
                  "    int u;\n"
                  "    int r = 0 && ({ u + 1; });\n"
                  "    r += 0 ? ({ g(u); }) : 1;\n"
                  "    int v;\n"
                  "    r += ({ v; });\n"
                  "    return r;\n"
                  "    ({ int w; w; });\n"
                  "}\n")-1,
sizeof("int printf(const char *, ...);\n"
                  "int f(int x)\n"
                  "{\n"
                  "    if (x = ({ printf(\"%s\", 1); x; })) return 1;\n"
                  "    if (x = printf(\"%s\", 2)) return 1;\n"
                  "    while (x = ({ printf(\"%s\", 3); x; })) {}\n"
                  "    for (; x = ({ printf(\"%d\", \"v\"); 1; }); ) {}\n"
                  "    do {} while (x = ({ printf(\"%d\", \"w\"); 1; }));\n"
                  "    printf(\"%s\", ({ printf(\"%d\", \"s\"); 1; }));\n"
                  "    printf(\"%s\", printf(\"%d\", \"t\"));\n"
                  "    int a = x & ({ printf(\"%d\", \"u\"); 1; }) == 2;\n"
                  "    int b = !x == ({ printf(\"%d\", \"y\"); 1; });\n"
                  "    (void)a; (void)b;\n"
                  "    return (x = 1) ? printf(\"%s\", 4) : 0;\n"
                  "}\n")-1,
sizeof("int printf(const char *, ...);\n"
                  "int f(int x)\n"
                  "{\n"
                  "    if (x = ({ printf(\"%s\", 1); x; })) return 1;\n"
                  "    if (x = printf(\"%s\", 2)) return 1;\n"
                  "    while (x = ({ printf(\"%s\", 3); x; })) {}\n"
                  "    for (; x = ({ printf(\"%d\", \"v\"); 1; }); ) {}\n"
                  "    do {} while (x = ({ printf(\"%d\", \"w\"); 1; }));\n"
                  "    printf(\"%s\", ({ printf(\"%d\", \"s\"); 1; }));\n"
                  "    printf(\"%s\", printf(\"%d\", \"t\"));\n"
                  "    int a = x & ({ printf(\"%d\", \"u\"); 1; }) == 2;\n"
                  "    int b = !x == ({ printf(\"%d\", \"y\"); 1; });\n"
                  "    (void)a; (void)b;\n"
                  "    return (x = 1) ? printf(\"%s\", 4) : 0;\n"
                  "}\n")-1,
sizeof("int g(void) __attribute__((warn_unused_result));\n"
                  "void f(int n, unsigned u) {\n"
                  "    int b[n + (1 << 40)];\n"
                  "    int c[n + 1 / 0];\n"
                  "    int d[n + (u < -1)];\n"
                  "    char cc = 0;\n"
                  "    int e[n + (cc = 300)];\n"
                  "    int h[n + (n, 1)];\n"
                  "    int a2[3]; int k[n + a2[5]];\n"
                  "    int s[n + sizeof(1 << 41)];\n"
                  "    int t = sizeof(int[n + (1 << 45)]);\n"
                  "    int v = (int)sizeof(({ int w = 1 << 46; w; })) + (int)sizeof(({ 1 << 47; }));\n"
                  "    int x = (1 << 48) + 1 / 0;\n"
                  "    (void)b; (void)c; (void)d; (void)e; (void)h; (void)k; (void)s; (void)t; (void)v; (void)x;\n"
                  "}\n")-1,
sizeof("int g(void) __attribute__((warn_unused_result));\n"
                  "void f(int n, unsigned u) {\n"
                  "    int b[n + (1 << 40)];\n"
                  "    int c[n + 1 / 0];\n"
                  "    int d[n + (u < -1)];\n"
                  "    char cc = 0;\n"
                  "    int e[n + (cc = 300)];\n"
                  "    int h[n + (n, 1)];\n"
                  "    int a2[3]; int k[n + a2[5]];\n"
                  "    int s[n + sizeof(1 << 41)];\n"
                  "    int t = sizeof(int[n + (1 << 45)]);\n"
                  "    int v = (int)sizeof(({ int w = 1 << 46; w; })) + (int)sizeof(({ 1 << 47; }));\n"
                  "    int x = (1 << 48) + 1 / 0;\n"
                  "    (void)b; (void)c; (void)d; (void)e; (void)h; (void)k; (void)s; (void)t; (void)v; (void)x;\n"
                  "}\n")-1,
sizeof("int a(int c){if(c)return 1;return 2;}int b(int c){if(c)return 1;}int d(void){while(1){}}_Noreturn void r(void){while(1){}}\n")-1,
sizeof("int a=1.5;\nint f(void){int b=2.5;return b;}\n")-1,
sizeof("enum E { A, B };\nvoid arg(enum E);\nvoid argi(int);\nenum E fret(void) { return 3.5; }\n_Atomic int gy = 7.5;\n"
                  "_Atomic char gc = 300;\nvoid f(void) {\n  int x = 1.5; enum E e = 2.5; _Atomic int y = 3.5; _Atomic char z = 4.5;\n"
                  "  arg(4.5); argi(4.5); e = 5.5; y = 6.5; const int c = 8.5; volatile int v = 9.5;\n"
                  "  _Bool b = 0.5; _Atomic _Bool ab = 0.5; enum E e2 = 300; _Atomic char k = 300; char d = 300; z = 500;\n"
                  "  (void)x; (void)e; (void)y; (void)z; (void)c; (void)v; (void)b; (void)ab; (void)e2; (void)k; (void)d;\n}\n")-1,
sizeof("_Atomic char ga[1] = { 1.5 };\nstruct S { _Atomic char c; int i; };\nstruct S gs = { 1.5, 2.5 };\nvoid f(void) {\n"
                  "  _Atomic char a[2] = { 1.5, 2 };\n  struct S s = { 3.5, 4.5 };\n  struct { _Atomic int x; double d; } t = { .x = 5.5, .d = 1 };\n"
                  "  (void)a; (void)s; (void)t;\n}\n")-1,
sizeof("_Atomic int f(void) { return 3.5; }\n_Atomic int gpar(_Atomic int);\nvoid h(void) { gpar(3.5); }\n"
                  "_Atomic char g(void) { return 300; }\nvoid gc(_Atomic char);\nvoid kc(void) { gc(300); }\n"
                  "struct S { int i; _Atomic int m; };\nvoid k(void) { struct S t; t.m = 3.5; t.m = 5000000000LL; (void)t; }\n"
                  "int fi(void) { return 2.5; }\nvoid pi(int);\nvoid hp(void) { pi(2.5); }\nchar fc(void) { return 300; }\n")-1,
sizeof("enum Small : signed char { X };\nenum Small e = 300;\nenum Small rs(void) { return 300; }\n"
                  "void ca(enum Small);\nvoid cc(void) { ca(300); }\n"
                  "void as(void) { enum Small s; s = 300; (void)s; }\nenum FB : _Bool { FA };\nenum FB fb = 2;\n"
                  "enum E { A, B };\nenum E ee = 5000000000LL;\nenum Small lit = 2.5;\n")-1,
sizeof("void g(void) { int y; char c = y = 1000; char d[1] = { y = 300 }; unsigned char u = (y += 1, 300); char e = y++; "
                  "char f = (y = 1, 400); _Bool b = (y = 2); float fl = (y = 16777217); "
                  "(void)c; (void)d; (void)u; (void)e; (void)f; (void)b; (void)fl; }\n")-1,
sizeof("typedef const int CI;\n"
                  "void g(void) { int x; int b[2];\n"
                  "int c = _Generic(b, int[2]: 1, default: 2);\nint d = _Generic(x, _Atomic int: 1, default: 2);\n"
                  "int e = _Generic(x, int const: 1, volatile long: 3, default: 2);\nint f = _Generic(x, CI: 1, default: 2);\n"
                  "int h = _Generic(&x, int * __attribute__((address_space(1))): 1, int * restrict: 4, default: 2);\n"
                  "int i = sizeof(_Generic(x, const char: 1, default: 2));\n"
                  "(void)c; (void)d; (void)e; (void)f; (void)h; (void)i; }\n"
                  "int k = _Generic(1, const int: 1, int[3]: 2, default: 0);\n")-1,
sizeof("void g(void) { int x; int b[2]; int c = _Generic(b, int[2]: 1, const int: 3, default: 2); (void)c; (void)x; }\n")-1,
sizeof("void g(void) { int x;\nint a = _Generic(x, const int: 1, default: 2);\n"
                  "int c = _Generic(&x, int __attribute__((objc_gc(weak))) *: 1, default: 2);\n"
                  "int e = _Generic(&x, int __attribute__((objc_gc(strong))) *: 1, default: 2);\n"
                  "int f = _Generic(&x, int __attribute__((objc_ownership(weak))) *: 1, default: 2);\n"
                  "(void)a; (void)c; (void)e; (void)f; }\n")-1,
sizeof("int f(void){int a;a=1.5;return -2.5;}\nvoid g(int);void h(void){g(3.5);}\n")-1,
sizeof("int f(int x){if(0.25)x=1;while(0.5)break;for(;0.75;)break;do{}while(1.5);return (2.5&&x)+(x||-3.5)+!4.5+(5.5?x:1)+(1.0&&x)+(0.0||x);}\n"
                  "int g(int x){return (x?1.5:2.5)&&x;}int h(int x){return (x,1.5)&&x;}unsigned long k(int x){return sizeof(1.5&&x);}\n"
                  "int u(int x){if(0)return 6.5&&x;return 0&&7.5;}\n_Bool b=1.5;_Bool c(void){return 2.5;}\n")-1,
sizeof("int o(int x){int y=2.5;_Static_assert(1.5,\"\");_Static_assert(0.0==0,\"\");return y+(x&&3.5);}\n_Static_assert(-0.5,\"\");\n"
                  "_Static_assert(1.5&&2.5,\"\");int z(int x){if(0){_Static_assert(0.5,\"\");}return x;}\n")-1,
sizeof("int a=1.1f;int b=1.1;int c=1.1L;\n")-1,
sizeof("int values[2]={1.5,2.5};\nstruct S{int n;}object={1.5};\n")-1,
sizeof("int f(void){int a[2]={1.5,2.5};int b={3.5};return a[0]+b;}\n")-1,
sizeof("int f(void){int x=4.5;int a[2]={1.5,2.5};int y=3.5;return x+a[0]+y;}\n")-1,
sizeof("int values[4]={[0 ... 3]=1.5};\n")-1,
sizeof("int a=0.9999999999999999;int b=1e-30;int c=0x1.8p0;\n")-1,
sizeof("int a=1.9999999999999998;int b=1.0000000000000002;\n")-1,
sizeof("void f(int,int);int g(int);void h(void){f(g(1.5),2.5);f(3.5,g(4.5));f(5.5,6.5);}\n")-1,
sizeof("void f(int,int);int g(int);void h(void){f(g(1.5),g(2.5));f(3.5,4.5),f(5.5,6.5);}\n")-1,
sizeof("int f(int);int h(void){return f(1.5)+f(2.5);}\n")-1,
sizeof("int h(void){int a,b;a=1.5,b=2.5;return a+b;}\n")-1,
sizeof("int a[2]; int fn(int);\n"
            "struct P { int x, y; };\n"
            "void f(int i) {\n"
            "  int x1[2] = { a[5], 0 };\n"
            "  int x2[2] = { (a[5]), 0 };\n"
            "  int x3[2] = { -a[5], 0 };\n"
            "  int x4[2] = { fn(a[5]), 0 };\n"
            "  int x5[2] = { a[5] ? 1 : 2, 0 };\n"
            "  int x6[2] = { (char)a[5], 0 };\n"
            "  int *x7[2] = { &a[5], 0 };\n"
            "  int x8[2] = { [1] = a[5] };\n"
            "  int x9[1][1] = { { a[5] } };\n"
            "  struct P x10 = { a[5], i };\n"
            "  int x11 = { a[5] };\n"
            "  int *x12 = (int[]){ a[5] };\n"
            "  int x13[2] = { a[i ? 5 : 6] };\n"
            "  int x14[2] = { a[5] , a[6] };\n"
            "  int x15[2] = { i, a[5] = 1 };\n"
            "  int x16[2] = { (i, a[5]) };\n"
            "  static int s = 0; (void)s;\n"
            "  (void)x1;(void)x2;(void)x3;(void)x4;(void)x5;(void)x6;(void)x7;(void)x8;(void)x9;(void)x10;(void)x11;(void)x12;(void)x13;(void)x14;(void)x15;(void)x16;\n"
            "}\n"
            "int g1[2] = { 0 };\n")-1,
sizeof("int f(int);void h(void){int a[1];(f(1.5)+a[2]),(f(2.5)+a[3]);}\n")-1,
sizeof("void f(int);void h(void){int a[1];(a[2],f(1.5)),(a[3],f(2.5));}\n")-1,
sizeof("short f(short);void h(void){f(65536),f(65537);}\n")-1,
sizeof("int f(int);int h(void){int a[2]={(f(1.5),2.5),(f(3.5),4.5)};return a[0];}\n")-1,
sizeof("int f(void){if(0)return 1.5;if(0){int a=2.5;(void)a;}return 0;}\n")-1,
sizeof("void f(int);void h(void){if(0)f(1.5);f(2.5);}\n")-1,
sizeof("int f(void){int a[1];if(0){int x=1.5;(void)x;1;a[2];return 1/0;}return 0;}\n")-1,
sizeof("int g(int);int f(void){return 0&&g(1.5);}int h(void){return 1?0:g(2.5);}\n")-1,
sizeof("int f(int); void h(int c){c ? f(1.5) : f(2.5);}\n")-1,
sizeof("int side(void);void take(int);int f(int c){int x=c?(side(),2.5):3.0;x=c?3.0:(side(),2.5);take(c?(side(),2.5):3.0);return c?(side(),2.5):3.0;}\n")-1,
sizeof("int side(void);int f(int c){return (side(),(side(),2.5));}int g(int c){return (side(),(c?2.5:2.5));}\n")-1,
sizeof("int side(void);short f(int c){return (side(),(c?65536:65537));}short g(void){return (side(),(1?65536:65537));}short h(void){return (side(),(side(),65536));}short i(int c){return c?(side(),65536):65537;}\n")-1,
sizeof("int side(void);int f(void){return (side(),2.5);}\n")-1,
sizeof("int f(void){return sizeof((int){1.5})+_Generic(0,int:0,default:(int){2.5});}\n")-1,
sizeof("int a=0?1.5:2.5;int b=1?3.5:4.5;int f(int c){return c?5.5:6.5;}\n")-1,
sizeof("int a[1]={0?1.5:2.5};void f(int);void h(int c){if(0)f(c?3.5:4.5);}\n")-1,
sizeof("short a=0?65536:65537;short b=1?65538:65539;\n")-1,
sizeof("void f(short,short);short g(short);void h(void){f(g(65536),65537);}\n")-1,
sizeof("void f(short);short g(void){if(0)return 65536;if(0){short a=65536;(void)a;}return 0;}"
                  "void h(void){if(0)f(65536);f(65537);}int i(void){return 0&&(f(65536),1);}int j(void){return 1?0:(f(65536),1);}\n")-1,
sizeof("int f(int n) {\n  return n;\n  int dead = n;\n  return dead;\n}\n"
                  "int g(int n) {\n  int a = n + 1;\n  if (n > 1) n = a;\n  int b = n + 2;\n  if (n > 2) n = b;\n"
                  "  int c = n + 3;\n  if (n > 3) n = c;\n  int d = n + 4;\n  if (n > 4) n = d;\n  return n;\n}\n")-1,
sizeof("int h(void){return 0;short a=65536;int b=1.5;(void)a;(void)b;}\n")-1,
sizeof("int f(int x){return (x<<40)+(x>>-1)+(1.5?x<<33:0);}\n")-1,
sizeof("char c=1<<9;\n"
                  "void g(int x){char d=1<<9;char e=x<<40;int k=2.5;if(0.5){x<<=64;}x=!1.5?x>>99:x;(void)d;(void)e;(void)k;}\n")-1,
sizeof("const int k = 0;\n"
                  "static const int ks = 0;\n"
                  "const volatile int kv = 0;\n"
                  "int nk = 0;\n"
                  "const long kl = 0;\n"
                  "const int ka[2] = { 0, 1 };\n"
                  "struct P { int m; };\n"
                  "const struct P kp = { 0 };\n"
                  "const int one = 1;\n"
                  "const char s[] = \"a\";\n"
                  "int f(int x) {\n"
                  "    const int lk = 0;\n"
                  "    const int lk2 = x;\n"
                  "    int r = 1 / k + 1 % ks + 1 / kv + 1 / nk + x / kl + 1 / lk + 1 / lk2 + 1 / ka[0] + 1 / kp.m + 1 / (k) + 1 / (int)k;\n"
                  "    if (0) { r = 1 / k; }\n"
                  "    r += (int)sizeof(1 / k) + 1 / one + 1 / s[1];\n"
                  "    r += x ? 1 / lk : 0;\n"
                  "    return r;\n"
                  "    r = 1 / k;\n"
                  "}\n")-1,
sizeof("const int k = 0;\n"
                  "static const int ks = 0;\n"
                  "const volatile int kv = 0;\n"
                  "int nk = 0;\n"
                  "const long kl = 0;\n"
                  "const int ka[2] = { 0, 1 };\n"
                  "struct P { int m; };\n"
                  "const struct P kp = { 0 };\n"
                  "const int one = 1;\n"
                  "const char s[] = \"a\";\n"
                  "int f(int x) {\n"
                  "    const int lk = 0;\n"
                  "    const int lk2 = x;\n"
                  "    int r = 1 / k + 1 % ks + 1 / kv + 1 / nk + x / kl + 1 / lk + 1 / lk2 + 1 / ka[0] + 1 / kp.m + 1 / (k) + 1 / (int)k;\n"
                  "    if (0) { r = 1 / k; }\n"
                  "    r += (int)sizeof(1 / k) + 1 / one + 1 / s[1];\n"
                  "    r += x ? 1 / lk : 0;\n"
                  "    return r;\n"
                  "    r = 1 / k;\n"
                  "}\n")-1,
sizeof("int h(int x){int a=_Generic(x,int:1,long:x<<70);int b=1.5&&(x+(x<<35));int c=__builtin_choose_expr(1,x,x>>40);short s=3.7;"
                  "return a+b+c+s+(x<<-3)/0;}\n")-1,
sizeof("void take(char);int m(int x){take(1<<9);take(2.5);unsigned char u=(x?300:1.5);(void)u;return x?x<<32:(0?x<<50:1);}\n")-1,
sizeof("int g1(int x){if(0){int a=2.5;x<<=40;(void)a;}int b=sizeof(x<<40)+sizeof((char)3.5);int c=0&&(x<<40)&&1.5;"
                  "int d=_Generic(1.5,double:x<<1,default:x<<99);int e=(char)(x>>70)+4;int f[2]={1.5,x<<33};return b+c+d+e+f[0];}\n"
                  "_Static_assert(1.5,\"x\");struct S{int m;}s={2.5};\n")-1,
sizeof("char c=1<<9;int a=2.5;_Bool b=0.5;char d=1.5?300:2;char w=300,x=5.5;int v[3]={300,4.5,7};_Static_assert(1.5,\"\");"
                  "struct T{int i;double e;}t={6.5,1.5};\n")-1,
sizeof("int c0(int);int u(int x){return x;x=x<<40;int a=2.5;char c=1.5?300:0;x/=0;return a+c+c0(3.5)+(x&&4.5);}\n"
                  "int w(int x){if(0){x=x<<40;x=5.5;}while(0){x=x/0+6.5;}return x;}\n")-1,
sizeof("_Bool a=1.5;_Bool b=2.0;_Bool c=1.0;\n")-1,
sizeof("unsigned char a=1000.5;unsigned b=-1.5;int c=1e30;\n")-1,
sizeof("#define VALUE 1.5\nint a=VALUE;\n")-1,
sizeof("int a=((1.5));int b=+2.5;int c=-3.5;\n")-1,
sizeof("int a=(double)1.5f;int b=(int)1.5;int c=2.5-1.0;int d=2.5+0.0;int e=1.0;\n"
                  "int f(double a){return a;}int g(void){double a=1.5;return a;}\nint h=__builtin_nan(\"\");int i=__builtin_inf();\n")-1,
sizeof("int a=1.5;\n")-1,
sizeof("void f(void) { extern int x; }\nvoid g(void) { extern int y; (void)y; }\nvoid h(void) { extern int z(void); }\n"
                  "void k(void) { extern int w __attribute__((unused)); }\nvoid m(void) { extern int v; { extern int v; v = 1; } }\n"
                  "int q;\nvoid n(void) { extern int q; }\nstatic int s5;\nvoid o(void) { extern int s5; (void)s5; }\n"
                  "void p(void) { extern int arr[]; extern int a, b; (void)b; }\nvoid s(void) { static int st; register int r; int loc; }\n"
                  "void t(void) { int y4; { extern int y4; } }\n")-1,
sizeof("void rel(int *p);\nvoid relv(void *p);\nint f(int a) { int c __attribute__((cleanup(rel))) = a; if (a) return 1; return 2; }\n"
                  "void g(void) { __attribute__((cleanup(rel))) int c = 0, d = 1; }\nvoid h(int a) { int c __attribute__((cleanup(relv))); c = a; }\n"
                  "void k(void) { int c __attribute__((cleanup(rel))), e; }\n")-1,
sizeof("static void sf(void);\nvoid o(void) { extern void sf(void); sf(); }\nstatic void sf(void) {}\nstatic int t;\n"
                  "void p(void) { { extern int t; } }\nstatic int u;\nvoid q(void) { { extern int u; { extern int u; (void)u; } } }\n")-1,
sizeof("int y;\nvoid f(void) { extern int y = 2, z; (void)z; }\n")-1,
sizeof("void f(void) { __private_extern__ int x = 1; }\n")-1,
sizeof("int a=1.5;\n")-1,
sizeof("#pragma clang diagnostic error \"-Wliteral-conversion\"\nint a=1.5;\n")-1,
sizeof("int a=1.5;\n")-1,
sizeof("int a=1.5;\n")-1,
sizeof("int a=1.5;\n")-1,
sizeof("int a=1.5;\n")-1,
sizeof("#pragma clang diagnostic error \"-Wfloat-conversion\"\nint a=1.5;\n")-1,
sizeof("#pragma clang diagnostic ignored \"-Wliteral-conversion\"\n#pragma clang diagnostic error \"-Wfloat-conversion\"\nint a=1.5;\n")-1,
sizeof("struct S{int i;char c;}s={2,300};\nvoid f(void){struct S t={2,300};(void)t;}\n")-1,
sizeof("char a[3]={300,301,302};struct T{struct S{char x,y;}s;char d[2];}t={{303,304},{305,306}};struct S u={.y=307};\n")-1,
sizeof("void f(int x){char b[3]={301,x<<40,302};char c[2]={x?303:1,(x,304)};char e[3]={[0 ... 2]=305};(void)b;(void)c;(void)e;}\n")-1,
sizeof("void f(void){if(0){char g[1]={310};(void)g;}}unsigned char t1[]={255,256,-1,-129};signed char t2[]={127,128,-129,0xff,0x1ff};\n")-1,
sizeof("short g[]={32768,70000};struct{signed char c;short s;}h={128,32768};void k(int x){short t[2]={32768,70000};x<<40;(void)t;}\n")-1,
sizeof("void f(int x){x<<40;short a=32768;short b=70000;(void)a;(void)b;}\n")-1,
sizeof("int h[2]={15.5,1<<40};\n")-1,
sizeof("int a=1<<40,b=2.5;int e[2]={1<<41,4.5},f=5.5,g=1<<42;char h[2]={301,1<<43},i[1]={6.5};struct{char c;int i;}k={302,1<<44};\n")-1,
sizeof("struct T { char a; char b; };\n"
                  "int z = (1 << 40, 3), y = (2, 1 << 41);\n"
                  "int w = (2 << 42, 1 << 43, 3);\n"
                  "char c = (1 << 42, 300);\n"
                  "struct T s = { (1 << 43, 1), (4, 1 << 44) };\n"
                  "int arr[2] = { (5, 6), 7 };\n"
                  "struct T g = { (5, 302), (6, 303) };\n"
                  "void f(int x) { struct T t = { (1, 300), (2, 301) }; struct T u = { (3, x << 40), 1.5 }; struct T v = { x / 0, (4, x) }; (void)t; (void)u; (void)v;\n"
                  "    static int k = (1 << 45, 3); (void)k; int q = (1 << 46, 2); (void)q; }\n")-1,
sizeof("struct T { char a; char b; };\n"
                  "int z = (1 << 40, 3), y = (2, 1 << 41);\n"
                  "int w = (2 << 42, 1 << 43, 3);\n"
                  "char c = (1 << 42, 300);\n"
                  "struct T s = { (1 << 43, 1), (4, 1 << 44) };\n"
                  "int arr[2] = { (5, 6), 7 };\n"
                  "struct T g = { (5, 302), (6, 303) };\n"
                  "void f(int x) { struct T t = { (1, 300), (2, 301) }; struct T u = { (3, x << 40), 1.5 }; struct T v = { x / 0, (4, x) }; (void)t; (void)u; (void)v;\n"
                  "    static int k = (1 << 45, 3); (void)k; int q = (1 << 46, 2); (void)q; }\n")-1,
sizeof("char a[4]={300,1.5,301,2.5};void f(void){char b[4]={303,5.5,304,6.5};int y=7.5;(void)b;(void)y;}\n")-1,
sizeof("enum Small:signed char{S0};struct T{enum Small m;int i;}st={300,1};enum Small sa[2]={1,301};\n")-1,
sizeof("struct S{short s;char c;};short a[1]={1<<20};int c[1]={3LL<<40};short d={1<<20};struct S e={1<<18,2<<8};"
                  "void f(void){short x[1]={4<<18};struct S y={0,1<<9};_Bool b[1]={1<<3};short z[1]={1<<3};(void)x;(void)y;(void)b;(void)z;}\n")-1,
sizeof("struct S{int i;char c;};int f(int x){x=(struct S){x,300}.c+(x<<33);if((struct S){x,301}.c+(x<<34))return x<<32;"
                  "for(int i=0;i<2;i+=(struct S){1,302}.c+(x<<35)){struct S s={1,303};x+=s.c+(x<<36);}return x;}\n")-1,
sizeof("_Atomic short a0[2]={32768,1};struct{_Atomic char c;int i;}s={300,1};void f(void){_Atomic short a3[2]={32768,70000};(void)a3;}\n")-1,
sizeof("char a[4]={300,1.5,301,2.5};short g[]={32768};\n")-1,
sizeof("struct S{int i;char c;}s={2,300};\n")-1,
sizeof("const int b=1;\nint *c=&b;\n")-1,
sizeof("int f(void){const int b=1;int *c=&b;return *c;}\n")-1,
sizeof("void f(const int *a,int *b){b=a;}\n")-1,
sizeof("const int b=1;\nint *f(void){return &b;}\n")-1,
sizeof("const int b=1;\nint *c=&b;\n")-1,
sizeof("#pragma clang diagnostic error \"-Wincompatible-pointer-types-discards-qualifiers\"\nconst int b=1;\nint *c=&b;\n")-1,
sizeof("typedef const int CI;CI b=1;typedef int *P;P c=&b;\n")-1,
sizeof("const int b[2]={1,2};int *c=b;\n")-1,
sizeof("const int b=1;int *const c=&b;\n"
                  "void f(const int *const a){int *const b=a;(void)b;}\n"
                  "int *g(const int *const a){return a;}\n")-1,
sizeof("unsigned char a[2];char *b=a;\nchar *f(void){return a;}\n")-1,
sizeof("void f(int *,int *b);void g(const int *p){f(p,p);}\n")-1,
sizeof("void f(int *first);void f(int *second);void g(const int *p){f(p);}\n")-1,
sizeof("void f(int *first);void f();void g(const int *p){f(p);}\n")-1,
sizeof("void earlier(void){void f(int *hidden);}void f();void g(const int *p){f(p);}\n")-1,
sizeof("void (*f)(int *parameter);void g(const int *p){f(p);}\n")-1,
sizeof("typedef void (*F)(int *parameter);F f;void g(const int *p){f(p);}\n"
                  "void h(void (*callback)(int *parameter),const int *p){callback(p);}\n")-1,
sizeof("void f(int *parameter);void g(const int *p){(*f)(p);((void(*)(int *))f)(p);}\n")-1,
sizeof("void f(int *parameter);void g(const int *p){f(p+1);}\n")-1,
sizeof("void f(int **parameter);void g(const int **p){f(p);}\n")-1,
sizeof("#define F f\n#define P p\nvoid f(int *parameter);void g(const int *p){F(P);}\n")-1,
sizeof("void f(int *a,int *b);void g(const int *p,unsigned int *q){f(q,p);f(p,q);}\n")-1,
sizeof("void f(char *p);void g(void){const unsigned char a[2]={1,2};f(a);}\n")-1,
sizeof("void f(int *,int count,void callback(int *),int *last);\n"
                  "void g(const int *p){f(p,0,0,p);}\n")-1,
sizeof("typedef int *P;void f(P first,int *second);void g(const int *p){f(p,p);}\n")-1,
sizeof("void f(int *a,int *b);void g(const int *p,unsigned int *q){f(p,q);}\n")-1,
sizeof("#pragma clang diagnostic error \"-Wincompatible-pointer-types-discards-qualifiers\"\n"
                  "void f(int *parameter);void g(const int *p){f(p);}\n")-1,
sizeof("void f(const int **p,int **q){int **r=p;q=p;(void)r;}\nint **g(const int **p){return p;}\n")-1,
sizeof("int a;\nint b=a;\n")-1,
sizeof("int a;\nint values[2]={1,a};\n")-1,
sizeof("int read(void);\nint f(void){static int value=read();return value;}\n")-1,
sizeof("const const int a;\nvolatile volatile int b;\n_Atomic _Atomic int c;\nextern extern int d;\n"
                  "static static int e;\ntypedef typedef int T;\nunsigned unsigned int f;\n")-1,
sizeof("inline inline void f(void){}\n_Noreturn _Noreturn void g(void){for(;;){}}\n")-1,
sizeof("_Noreturn void _Noreturn f(void){for(;;){}}\n_Noreturn extern _Noreturn void g(void);\n")-1,
sizeof("int f(const const int x,int *volatile volatile p){return x+*p;}\n")-1,
sizeof("typeof(unsigned unsigned int) q;\nint r = sizeof(typeof(const const int));\nenum E : unsigned unsigned short { A };\n"
                  "_Atomic(signed signed char) s;\ntypeof(_Atomic _Atomic int) t;\n"
                  "int f(void) { return sizeof(short short) + (int)(typeof(volatile volatile long))1; }\n")-1,
sizeof("enum H : const int { D };\nenum I : const volatile const int { E };\nenum J : int const { F };\n"
                  "enum K : volatile unsigned long { G };\ntypedef const int CI;\nenum L : CI { H1 };\nenum M : const CI { M1 };\n"
                  "enum N : const int;\nconst enum O : const int { O1 };\nenum Q : const int { Q1 } q;\n"
                  "void f(void) { enum R : const short { R1 }; enum R r = R1; (void)r; }\nstruct T { enum U : const int { U1 } u; };\n")-1,
sizeof("enum H : const int { D };\nenum I : const volatile const int { E };\nenum J : int const { F };\n"
                  "enum K : volatile unsigned long { G };\ntypedef const int CI;\nenum L : CI { H1 };\nenum M : const CI { M1 };\n"
                  "enum N : const int;\nconst enum O : const int { O1 };\nenum Q : const int { Q1 } q;\n"
                  "void f(void) { enum R : const short { R1 }; enum R r = R1; (void)r; }\nstruct T { enum U : const int { U1 } u; };\n")-1,
sizeof("enum H : const int { D };\nenum I : const volatile const int { E };\nenum J : int const { F };\n"
                  "enum K : volatile unsigned long { G };\ntypedef const int CI;\nenum L : CI { H1 };\nenum M : const CI { M1 };\n"
                  "enum N : const int;\nconst enum O : const int { O1 };\nenum Q : const int { Q1 } q;\n"
                  "void f(void) { enum R : const short { R1 }; enum R r = R1; (void)r; }\nstruct T { enum U : const int { U1 } u; };\n")-1,
sizeof("enum H : const int { D };\n")-1,
sizeof("enum H : const int { D };\n")-1,
sizeof("typedef _Atomic(int) Atomic; enum E : _Atomic int { E0 }; enum F : Atomic { F0 };\n"
                  "_Static_assert(sizeof(enum E)==4 && sizeof(enum F)==4, \"atomic base stripped\");\n")-1,
sizeof("typedef _Atomic(int) Atomic; enum E : _Atomic int { E0 }; enum F : Atomic { F0 };\n"
                  "_Static_assert(sizeof(enum E)==4 && sizeof(enum F)==4, \"atomic base stripped\");\n")-1,
sizeof("typedef _Atomic(int) Atomic; enum E : _Atomic int { E0 }; enum F : Atomic { F0 };\n"
                  "_Static_assert(sizeof(enum E)==4 && sizeof(enum F)==4, \"atomic base stripped\");\n")-1,
sizeof("enum E : _Atomic int { E0 };\n")-1,
sizeof("enum P : unsigned const long volatile x;\nvoid f(void) { enum S : volatile char s; s = 1; (void)s; }\nenum Q : short q1, q2;\n"
                  "enum Q { QA = 1 };\n_Static_assert(sizeof(q1) == 2, \"\");\nenum E : int;\nvoid g(void) { enum E : short y; (void)y; }\n"
                  "enum F { FA };\nenum F : int z;\ntypedef enum T : char TT;\n_Static_assert(sizeof(TT) == 1, \"\");\n")-1,
sizeof("enum P : unsigned const long volatile x;\nvoid f(void) { enum S : volatile char s; s = 1; (void)s; }\nenum Q : short q1, q2;\n"
                  "enum Q { QA = 1 };\n_Static_assert(sizeof(q1) == 2, \"\");\nenum E : int;\nvoid g(void) { enum E : short y; (void)y; }\n"
                  "enum F { FA };\nenum F : int z;\ntypedef enum T : char TT;\n_Static_assert(sizeof(TT) == 1, \"\");\n")-1,
sizeof("enum P : unsigned const long volatile x;\nvoid f(void) { enum S : volatile char s; s = 1; (void)s; }\nenum Q : short q1, q2;\n"
                  "enum Q { QA = 1 };\n_Static_assert(sizeof(q1) == 2, \"\");\nenum E : int;\nvoid g(void) { enum E : short y; (void)y; }\n"
                  "enum F { FA };\nenum F : int z;\ntypedef enum T : char TT;\n_Static_assert(sizeof(TT) == 1, \"\");\n")-1,
sizeof("enum P : unsigned const long volatile x;\nvoid f(void) { enum S : volatile char s; s = 1; (void)s; }\nenum Q : short q1, q2;\n"
                  "enum Q { QA = 1 };\n_Static_assert(sizeof(q1) == 2, \"\");\nenum E : int;\nvoid g(void) { enum E : short y; (void)y; }\n"
                  "enum F { FA };\nenum F : int z;\ntypedef enum T : char TT;\n_Static_assert(sizeof(TT) == 1, \"\");\n")-1,
sizeof("int a[];\nint a[];\nint b[]; int b[3];\nstatic int c[];\nextern int d[];\nint e[], f[];\nstatic void u(void) {}\n"
                  "typedef int A[];\nA x;\nint q[3]; int q[];\nint r[]; int r[2] = { 1 };\nint s[] = { 1, 2 }; int s[];\n"
                  "int t[]; extern int t[];\nint *p[];\nconst int k[];\nint m[][2];\n"
                  "void g(void) { extern int z[]; static int y[2]; (void)z; (void)y; }\n"
                  "#pragma clang diagnostic ignored \"-Wtentative-definition-array\"\nint i[];\n")-1,
sizeof("int a[];\nint a[];\nint b[]; int b[3];\nstatic int c[];\nextern int d[];\nint e[], f[];\nstatic void u(void) {}\n"
                  "typedef int A[];\nA x;\nint q[3]; int q[];\nint r[]; int r[2] = { 1 };\nint s[] = { 1, 2 }; int s[];\n"
                  "int t[]; extern int t[];\nint *p[];\nconst int k[];\nint m[][2];\n"
                  "void g(void) { extern int z[]; static int y[2]; (void)z; (void)y; }\n"
                  "#pragma clang diagnostic ignored \"-Wtentative-definition-array\"\nint i[];\n")-1,
sizeof("int a[];\nint a[];\nint b[]; int b[3];\nstatic int c[];\nextern int d[];\nint e[], f[];\nstatic void u(void) {}\n"
                  "typedef int A[];\nA x;\nint q[3]; int q[];\nint r[]; int r[2] = { 1 };\nint s[] = { 1, 2 }; int s[];\n"
                  "int t[]; extern int t[];\nint *p[];\nconst int k[];\nint m[][2];\n"
                  "void g(void) { extern int z[]; static int y[2]; (void)z; (void)y; }\n"
                  "#pragma clang diagnostic ignored \"-Wtentative-definition-array\"\nint i[];\n")-1,
sizeof("int a[];\nint b[];\n")-1,
sizeof("int a[];\n")-1,
sizeof("int a[];\nint z[];\nint a[];\nint f(void) { return undeclared; }\nint w[];\nint g(void) { return 1 / 0; }\n")-1,
sizeof("static int c;\nstatic void h(void);\nvoid k(void) { h(); }\nint a[];\nstatic void u(void) {}\n")-1,
sizeof("static void h(void);\nvoid k(void) { h(); (void)(1 / 0); }\nstatic int c;\n")-1,
sizeof("void f(void) { int x; }\nstatic int c;\nstatic void g(void) {}\n")-1,
sizeof("const const int value;\n")-1,
sizeof("#pragma clang diagnostic ignored \"-Wduplicate-decl-specifier\"\nconst const int value;\n")-1,
sizeof("_Noreturn void f(void){}\n")-1,
sizeof("_Noreturn void f(void){return;}\n")-1,
sizeof("__attribute__((noreturn)) int f(void){return 1;}\n")-1,
sizeof("_Noreturn void f(void){if(0)return;for(;;){}}\n")-1,
sizeof("void g(void);_Noreturn void f(void){g();}\n")-1,
sizeof("_Noreturn void g(void);_Noreturn void f(void){g();}\n")-1,
sizeof("_Noreturn void g(void);_Noreturn void f(int x){if(x)g();}\n")-1,
sizeof("_Noreturn void f(void){__builtin_trap();}\n")-1,
sizeof("_Noreturn int g(void);_Noreturn void f(void){(void)g();}\n")-1,
sizeof("_Noreturn int g(void);_Noreturn void f(int x){if(x)(void)g();}\n")-1,
sizeof("_Noreturn void f(int x){if(x)__builtin_trap();}\n")-1,
sizeof("_Noreturn void f(void){}\n")-1,
sizeof("_Noreturn void g(void);_Noreturn void f(void){g();}\n")-1,
sizeof("_Noreturn void f(void){return;}\n")-1,
sizeof("#pragma clang diagnostic ignored \"-Winvalid-noreturn\"\n_Noreturn void f(void){}\n")-1,
sizeof("void g(void);int f(void){g();}\n")-1,
sizeof("_Noreturn void g(void);int f(int x){if(x)g();}\n")-1,
sizeof("_Noreturn int g(void);int f(void){(void)g();}\n")-1,
sizeof("int f(int x){if(x)__builtin_trap();}\n")-1,
sizeof("__private_extern__ int x;\n__private_extern__ int f(void);\nvoid g(void){__private_extern__ int y;}\n")-1,
sizeof("__private_extern__ int x=7;\n__private_extern__ int f(void){return x;}\n")-1,
sizeof("__private_extern__ int x __attribute__((unused)) (3);\n")-1,
sizeof("__private_extern__ __thread int x;\n")-1,
sizeof("__private_extern__ int x;int x;\nint y;__private_extern__ int y;\n__private_extern__ int z;int z=3;\n")-1,
sizeof("__private_extern__ int x,y=2,z;\n")-1,
sizeof("__private_extern__ __private_extern__ int x;\n")-1,
sizeof("__private_extern__ int x;\n")-1,
sizeof("#pragma clang diagnostic ignored \"-Wprivate-extern\"\n__private_extern__ int x;\n")-1,
sizeof("void declare(void){extern int printf(const char*,...)__attribute__((format(printf,1,2)));"
                  "extern int printf(const char*,...);}\nint printf(const char*,...);\n"
                  "void call(void){printf(\"%d\",\"str\");}\n")-1,
sizeof("void declare(void){extern int printf(const char*,...);"
                  "extern int printf(const char*,...)__attribute__((format(printf,1,2)));"
                  "extern int printf(const char*,...);}\nint printf(const char*,...);\n"
                  "void call(void){printf(\"%d\",\"str\");}\n")-1,
sizeof("typedef struct _IO_FILE FILE;\nvoid f(FILE*p,char*b){"
                  "__builtin_printf(\"%d\",\"str\");__builtin_fprintf(p,\"%d\",\"str\");"
                  "__builtin_sprintf(b,\"%d\",\"str\");__builtin_snprintf(b,16,\"%d\",\"str\");"
                  "__builtin_snprintf(b,16,\"%s.mo\\0\",\"x\");}\n")-1,
sizeof("void f(const char*s){(void)__builtin_strlen(s);__builtin_printf(\"%d\",\"str\");(void)__builtin_strlen(s);}\n")-1,
sizeof("void declare(void){extern int printf(const char*,...)__attribute__((format(printf,1,2)));}\n"
                  "int printf(const char*,...);\nvoid call(void){printf(\"%d\",\"str\");}\n")-1,
sizeof("int printf(const char*,...);\n"
                  "void declare(void){extern int printf(const char*,...)__attribute__((format(printf,1,2)));}\n"
                  "int printf(const char*,...);\nvoid call(void){printf(\"%d\",\"str\");}\n")-1,
sizeof("int printf(const char*,...);\nint printf(const char*,...)__attribute__((format(printf,1,2)));\n"
                  "int printf(const char*,...);\nvoid f(void){printf(\"%d\",\"str\");}\n")-1,
sizeof("int report(const char*,...);\nvoid before(void){report(\"%d\",\"str\");}\n"
                  "int report(const char*,...)__attribute__((format(printf,1,2)));\nint report(const char*,...);\n"
                  "void after(void){report(\"%d\",\"str\");}\n")-1,
sizeof("int report(const char*,...);\nvoid f(void){{"
                  "int report(const char*,...)__attribute__((format(printf,1,2)));"
                  "int report(const char*,...);report(\"%d\",\"str\");}"
                  "report(\"%d\",\"str\");}\n")-1,
sizeof("int report(const char*,...)__attribute__((format(printf,1,2)));\n"
                  "int report(const char*,...)__attribute__((noinline));\nvoid f(void){report(\"%d\",\"str\");}\n")-1,
sizeof(check_driver_format_plain_source)-1,
sizeof(check_driver_format_plain_source)-1,
sizeof(check_driver_format_plain_source)-1,
sizeof(check_driver_format_plain_source)-1,
sizeof(check_driver_format_plain_source)-1,
sizeof(check_driver_format_plain_source)-1,
sizeof(check_driver_format_plain_source)-1,
sizeof(check_driver_format_plain_source)-1,
sizeof(check_driver_format_plain_source)-1,
sizeof(check_driver_format_attributed_source)-1,
sizeof(check_driver_format_attributed_source)-1,
sizeof(check_driver_format_attributed_source)-1,
sizeof("int dprintf(int,const char*,...);\nvoid f(void){dprintf(1,\"%d\",\"str\");}\n")-1,
sizeof("int dprintf(int,const char*,...)__attribute__((format(printf,2,3)));\nvoid f(void){dprintf(1,\"%d\",\"str\");}\n")-1,
sizeof("void f(void){__builtin_printf(\"%d\",\"str\");}\n")-1,
sizeof("void f(void(*printf)(const char*,...)){printf(\"%d\",\"str\");}\n")-1,
sizeof("int printf(const char*,...);\nint snprintf(char*,unsigned long,const char*,...);\nvoid f(char*b){printf(\"%d\",7);snprintf(b,16,\"%s.mo\",\"x\");}\n")-1,
sizeof("int f(int a,int b,int c,int d){return ((a<b) & c<d)+(a==b ^ (c!=d));}\n")-1,
sizeof("int f(int a,int b,int c,int d,int e,int g){return (a<b & c<d) ^ e<g;}\n")-1,
sizeof("int a=1<2 & 3<4; static int b=1==2 ^ 3!=4; int f(void){return a+b;}\n")-1,
sizeof("int a=1<2 & 3; static int b=1 ^ 2!=3; int f(void){return a+b;}\n")-1,
sizeof("enum E{A=1<2 & 3<4,B=1==2 ^ 3!=4};int f(void){return A+B;}\n")-1,
sizeof("enum E{A=1<2 & 3,B=1 ^ 2!=3};int f(void){return A+B;}\n")-1,
sizeof("unsigned long f(int a,int b,int c,int d){return sizeof(a<b & c<d);}\n")-1,
sizeof("unsigned long f(int a,int b,int c){return sizeof(a<b & c);}\n")-1,
sizeof("int f(int a,int b,int c,int d){return _Generic(0,int:1,default:a<b ^ c<d);}\n")-1,
sizeof("int f(int a,int b,int c){return _Generic(0,int:1,default:a<b ^ c);}\n")-1,
sizeof("int f(int a,int b,int c,int d){return (a<b & c<d)+(a>b | c>d)+(a<=b ^ c>=d);}\n")-1,
sizeof("int f(int a,int b,int c,int d){return (a==b & c!=d)+(a!=b | c==d)+(a==b ^ c!=d);}\n")-1,
sizeof("int f(int a,int b,int c,int d){return (a==b & c<d)+(a>=b | c!=d)+(a!=b ^ c<=d);}\n")-1,
sizeof("int f(int a,int b,int c,int d,int e,int g){return (a<b ^ c<d ^ e<g)+(a==b & c==d & e==g)+(a!=b | c!=d | e!=g);}\n")-1,
sizeof("int f(int a,int b,int c,int d,int e,int g){return (a<b & c<d ^ e<g)+(a==b ^ c==d | e==g);}\n")-1,
sizeof("int f(int a,int b,int c,int d){return (a&b ^ c<d)+(a<b | c^d);}\n")-1,
sizeof("int f(int a,int b,int c,int d){return ((a<b) & (c<d))+((a==b)^c)+(a|(b!=c));}\n")-1,
sizeof("int f(int a,int b,int c){return (a<b & c)+(a<=b | c)+(a>b ^ c);}\n")-1,
sizeof("int f(int a,int b,int c){return (a & b>=c)+(a | b<c)+(a ^ b<=c);}\n")-1,
sizeof("int f(int a,int b,int c){return (a==b & c)+(a!=b | c)+(a==b ^ c);}\n")-1,
sizeof("int f(int a,int b,int c){return (a & b!=c)+(a | b==c)+(a ^ b!=c);}\n")-1,
sizeof("int f(int a,int b,int c,int d){return ((a&b) ^ c<d)+(a<b | (c^d));}\n")-1,
sizeof("#define X 0xe2\n"
                  "signed char take(signed char x) { return x; }\n"
                  "signed char small(void) { return (0xff); }\n"
                  "signed char large(void) { return 0x100; }\n"
                  "signed char single=0xff, overflow=0x1ff;\n"
                  "signed char values[8]; short s;\n"
                  "void f(void) { values[0]=0xe2; values[1]=(0342); values[2]=0b11100010; values[3]=X; s=0xffff; take(0x80); }\n"
                  "void hex_loss(void) { values[4]=0x100; }\n"
                  "void dec_loss(void) { values[5]=226; }\n"
                  "void calc_loss(void) { values[6]=0xe2+0; }\n"
                  "void unary_loss(void) { values[7]=+0xe2; }\n"
                  "void short_loss(void) { s=65535; }\n"
                  "void call_loss(void) { take(0x180); }\n")-1,
sizeof("char c; signed char s; short h; void f(void) { c=0xe2; s=(0Xff); h=0177777; s=0x100; }\n")-1,
sizeof("signed char s; void f(void) { s=(int)0xff; }\n")-1,
sizeof("int*p=1-1;\n")-1,
sizeof("double value=1e400;\n")-1,
sizeof("float value=1e-99f;\n")-1,
sizeof("int f(int*p){return p<1;}\n")-1,
sizeof("int;\n")-1,
sizeof("struct{int x;};\n")-1,
sizeof("_Complex value;\n")-1,
sizeof("struct S{int;int x;};\n")-1,
sizeof("struct S{enum{E};};union U{enum{A};};struct T{struct{enum{B};};};int main(void){return E+A+B;}\n")-1,
sizeof("struct S{union{int x;};int y;};int main(void){struct S s;s.x=1;return s.x;}\n")-1,
sizeof("struct S{struct Named{int x;};};\n")-1,
sizeof("typedef int;\n")-1,
sizeof("typedef struct S{int x;};\n")-1,
sizeof("typedef enum E{A};\n")-1,
sizeof("extern struct S;\n")-1,
sizeof("static union U;\n")-1,
sizeof("const struct S;\n")-1,
sizeof("const int;\n")-1,
sizeof("struct S{int n;int a[];};struct P{struct S s;int after;};\n")-1,
sizeof("inline int f(void){static int value;return value;}\n")-1,
sizeof("__attribute__((unused)) inline int g(void){static int value;return value;}\n")-1,
sizeof("__extension__ inline int g(void){static int value;return value;}\n")-1,
sizeof("inline int g(void) __attribute__((unused));\ninline int g(void){static int value;return value;}\n")-1,
sizeof("static int missing(void);int f(void){return missing();}\n")-1,
sizeof("static int m(void);void f(void){int a[sizeof(int[m()])];a[0]=m();(void)a;}\n")-1,
sizeof("static int m(void);void f(void){int a[sizeof(int[m()])];(void)a;}\n")-1,
sizeof("static int m(void);int f(void){return sizeof(int[m()])+1;}\n")-1,
sizeof("static int m(void);int f(void){return _Alignof(int[m()]);}\n")-1,
sizeof("static int m(void);int f(void){return sizeof(int[1?m():2]);}\n")-1,
sizeof("static int m(void);int f(int n){return sizeof(int[(m(),n)]);}\n")-1,
sizeof("static int first(void);static int second(void);int f(void){return second()+first();}\n")-1,
sizeof("static int missing(void);int f(void){return missing();}double value=1e400;\n")-1,
sizeof("struct S{long a,b;};struct S f(int n){int*p=1-1;(void)p;if(n)return(struct S){1,2};}\n")-1,
sizeof("int f(int){return 0;}\n")-1,
sizeof("int*p=0;\n")-1,
sizeof("float value=1e-45f;\n")-1,
sizeof("float value=0e-9999f;\n")-1,
sizeof("_Complex double value;\n")-1,
sizeof("struct S{int n;int a[];};struct P{int before;struct S s;};\n")-1,
sizeof("inline int f(void){static const int value=1;return value;}\n")-1,
sizeof("static int missing(void);int f(void){return missing();}static int missing(void){return 1;}\n")-1,
sizeof("static int missing(void);unsigned long value=sizeof missing;\n")-1,
sizeof("int f(int){return 0;}\n")-1,
sizeof("[[gnu::unused]] __attribute__((unused));\n"
                  "[[gnu::unused]] __attribute__((unused)) [[gnu::unused]] __attribute__((unused));\n"
                  "__attribute__((unused)) [[gnu::unused]] __attribute__((aligned(8)));\n"
                  "[[gnu::unused]] __attribute__((deprecated, packed)) [[gnu::unused]];\n"
                  "[[gnu::unused]] __attribute__((unknown_gnu));\n"
                  "[[unknown_c23]] __attribute__((unknown_gnu));\n")-1,
sizeof("[[gnu::unused]] __attribute__((unused));\n[[unknown_c23]] __attribute__((unknown_gnu));\n")-1,
sizeof("#pragma clang diagnostic push\n#pragma clang diagnostic ignored \"-Wnon-literal-null-conversion\"\n"
                  "int*quiet=1-1;\n#pragma clang diagnostic pop\nint*loud=2-2;\n")-1,
sizeof("#pragma clang diagnostic error \"-Wmissing-declarations\"\nint;\n")-1,
sizeof("#pragma clang diagnostic push\n#pragma clang diagnostic ignored \"-Wc23-extensions\"\n"
                  "int quiet(int){return 0;}\n#pragma clang diagnostic pop\nint loud(int){return 0;}\n")-1,
sizeof("int*p=1-1;\n")-1,
sizeof("int*p=1-1;\n")-1,
sizeof("int*p=1-1;\n")-1,
sizeof("int*p=1-1;\n")-1,
sizeof("int*p=1-1;\n")-1,
sizeof("# 1 \"system-warning-705.h\" 3\nint*p=1-1;\ndouble value=1e400;\nint;\nint f(int){return 0;}\n"
                  "# 10 \"user-warning-705.c\"\nint ordinary;\n")-1,
sizeof("# 1 \"system-warning-705.h\" 3\nint*p=1-1;\ndouble value=1e400;\nint;\nint f(int){return 0;}\n"
                  "# 10 \"user-warning-705.c\"\nint ordinary;\n")-1,
sizeof("# 1 \"system-warning-705.h\" 3\n#define ZERO (1-1)\n# 10 \"user-warning-705.c\"\nint*p=ZERO;\n")-1,
sizeof("typedef void *VP;\nvoid f(void *p, VP v, const void *c, void *const k) {\n"
                  "  (void)*p; (void)*v; (void)*c; (void)*k; void *q = &*p; q = &(*p); q = & *p;\n"
                  "  (void)sizeof(*p); (void)_Alignof(*p); (void)__alignof__ *p; (void)(1 ? *p : *p);\n"
                  "  if (0) (void)*p; (void)**(void **)p; (void)q;\n}\n")-1,
sizeof("struct S { int a; };\nint g(int);\nint f(int n) {\n"
                  "  *(int *)0 = 1; *(int *)0 += 2; int x = *(int *)0; g(*(int *)0); int k = n ? *(int *)0 : 1;\n"
                  "  int c = *(const int *)(0); int l = *(int *)(1 - 1); int t = *(char *)(void *)0L;\n"
                  "  int m = (*(struct S *)0).a; int *q = &*(int *)0; (*(int *)0)++; *(volatile int *)0 = 3;\n"
                  "  int *p = 0; *p = 4; int y = ((int *)0)[0]; int s = sizeof(*(int *)0); ((struct S *)0)->a = 2;\n"
                  "  if (0) { int z = *(int *)0; (void)z; }\n"
                  "  (void)*(int *)0;\n"
                  "  return x + k + c + l + t + m + y + s + (q != 0);\n  *(int *)0 = 9;\n}\n")-1,
sizeof("typedef typeof(nullptr) np;\nint g(np n) {\n"
                  "  int a = *(int *)n; int b = *(int *)(nullptr); int c = *(volatile int *)nullptr; int d = *(int *)(void *)nullptr;\n"
                  "  *(int *)nullptr = 1;\n"
                  "  return a + b + c + d;\n}\n")-1,
sizeof("int a[2];\nint f(int n) {\n"
                  "  if (0) { int d = a[5]; int e = n / 0; int z = *(int *)0; (void)d; (void)e; (void)z; }\n"
                  "  while (0) { int d = a[5]; int e = n / 0; int z = *(int *)0; (void)d; (void)e; (void)z; }\n"
                  "  return n;\n"
                  "  { int d = a[5]; int e = n / 0; int z = *(int *)0; (void)d; (void)e; (void)z; }\n}\n")-1,
sizeof("int f(int n) {\n  return n;\n  int dead = n;\n  return dead;\n}\n"
                  "int g(int n) {\n  int a = n + 1;\n  if (n > 1) n = a;\n  int b = n + 2;\n  if (n > 2) n = b;\n"
                  "  int c = n + 3;\n  if (n > 3) n = c;\n  int d = n + 4;\n  if (n > 4) n = d;\n  return n;\n}\n")-1,
sizeof("struct S { int x; int y; };\nstruct T { int n; int *p; };\n"
                  "int *gp = &(int){ 4 };\nstruct S *gs = &(struct S){ .x = 3 };\nint *gq = (int[]){ 5, 6 };\n"
                  "int scalars(void) {\n  int e = (int){ 4 };\n  long l;\n  l = (long){ 5 };\n  int *q;\n  q = (int *){ 0 };\n"
                  "  return e + (int)l + (q != 0) + *gp + gs->x + gq[1];\n}\n"
                  "int aggregates(void) {\n  int a[2] = { (int){ 1 }, (int){ 2 } };\n  int z = { (int){ 3 } };\n"
                  "  struct S s = (struct S){ .x = 1 };\n  struct S m = { .x = (int){ 1 } };\n  int *p = (int[2]){ 1, 2 };\n"
                  "  s = (struct S){ .y = 2 };\n  return a[0] + z + s.x + m.x + p[1];\n}\n"
                  "int loops(int n) {\n  int total = 0;\n"
                  "  for (int i = 0; i < n; i += 1) { int e = (int){ i }; total += e + (int){ 2 }; }\n"
                  "  while (n > 0) { int d = (int){ n }; total += d; n -= 1; }\n  return total;\n}\n"
                  "int addresses(void) {\n  int *p = &(int){ 4 };\n  int **pp = &(int *){ &(int){ 5 } };\n  return *p + **pp;\n}\n"
                  "int nested(void) {\n  int e = (int){ (int){ 4 } };\n  struct T t = (struct T){ .n = (int){ 1 }, .p = &(int){ 2 } };\n"
                  "  int a = (int){ (int){ (int){ 3 } } + 1 };\n  return e + t.n + *t.p + a;\n}\n")-1,
sizeof("int reads(void) {\n  int u;\n  int e = (int){ u };\n  return e;\n}\n"
                  "int self(void) {\n  int x = (int){ x };\n  return x;\n}\n"
                  "int nested(void) {\n  int u;\n  int v;\n  int e = (int){ (int){ u } + v };\n  return e;\n}\n"
                  "int assigned(void) {\n  int x;\n  x = (int){ x };\n  return x;\n}\n"
                  "int braced(void) {\n  int y = { (int){ y } };\n  return y;\n}\n"
                  "int pointer(void) {\n  int *p = (int *){ p };\n  return p != 0;\n}\n")-1,
sizeof("int a[2];\nint f(int n) {\n"
                  "  if (n && 0) { n = n / 0; }\n"
                  "  if (!(n || 1)) { n = a[5]; }\n"
                  "  if ((long)(n || 1)) { n += 1; } else { n = n % 0; }\n"
                  "  while (n && 0) { n = *(int *)0; }\n"
                  "  if (n && (n || 1)) { n = n / 0; }\n"
                  "  return n;\n}\n"
                  "int g(int n) {\n  if (n || 1) return 1;\n}\n"
                  "int h(int n) {\n  while (n || 1) { if (n) return 2; }\n}\n"
                  "int k(int n) {\n  if (n && 1) return 1;\n}\n")-1,
sizeof("int a[2];\nint f(int n) {\n"
                  "  int r = (n && 0) ? n / 0 : (n || 1) ? 1 : *(int *)0;\n"
                  "  r += ((n && 0) && n % 0) + ((n || 1) || a[5]) + (!(n || 1) ? a[5] : 0) + ((long)(n && 0) ? *(int *)0 : 1);\n"
                  "  r += (n && 1) ? n / 0 : 0;\n"
                  "  r += (n || 0) || *(int *)0;\n"
                  "  return r;\n}\n")-1,
sizeof("void *p; int i;\nunsigned long f(int n) {\n  char v[n][n]; int w[(*p, 3)];\n"
                  "  return _Alignof(_Generic(i, int: i, default: *p)) + _Alignof(__builtin_choose_expr(0, i, *p)) + _Generic(*p, void: 1, default: 2)\n"
                  "    + sizeof(({ (void)*p; 1; })) + sizeof(char (*)[(*p, n)]) + sizeof(int[(*p, n)]) + sizeof(v[(*p, 0)]) + sizeof(w);\n}\n"
                  "void g(int a[(*p, 3)]) { (void)a; }\n")-1,
sizeof("__extension__;\n__attribute__((unused)) __extension__;\nint a; __extension__ __extension__;\n"
                  "__extension__ __attribute__((unused));\n__attribute__((unused)) [[gnu::unused]] __extension__ int b;\n"
                  "__attribute__((unused)) [[gnu::unused]] __extension__;\n[[gnu::unused]] __extension__ __extension__;\n")-1,
sizeof("__extension__ _Static_assert(1, \"\");\n__extension__ _Static_assert(0, \"file\");\n"
                  "void f(void) { __extension__ __extension__ _Static_assert(0, \"block\"); }\n")-1,
sizeof("typedef const int CI;\nstruct s { int a; };\nvoid f(const int p, const struct s *q) {\n  const int x = 1; x = 2; x++; p = 3;\n"
                  "  const int a[2] = {0}; a[0] = 1; const int m[2][2] = {0}; m[0][1] = 1;\n"
                  "  CI y = 1; y = 2; const struct s v = {0}; v.a = 1; q->a = 2;\n}\nvoid g(const int *r) { r[0] = 1; *r = 2; }\n")-1,
sizeof("struct s; union u; enum e; typedef struct s S;\nvoid f(struct s *p, struct s *q, union u *w, enum e *n, S *t) {\n"
                  "  (void)(p + 1); (void)(1 + p); (void)(p - q); p++; --p; p += 2; (void)p[1]; (void)1[p];\n"
                  "  (void)(w + 1); (void)(n - 1); (void)(t + 1);\n}\n")-1,
sizeof("int*f0(void){return 1-1;}\nint*f1(void){return 2-2;}\nint*f2(void){return 3-3;}\n")-1,
sizeof("int *q;\nunsigned long g(void) { return sizeof(({ *q; 1; })); }\nunsigned long k(void) { return sizeof(({ 1 + 2; 1; })); }\n")-1,
sizeof("int *q;\nstruct S { int m; } *ps, vs;\nunsigned long f(int x) {\n"
                  "    return sizeof(({ x == 1; x != 1; x < 1; 1; })) + sizeof(({ (0, x); (void *)q; ps->m; vs.m; 1; })) +\n"
                  "           sizeof(({ x ? 1 : 2; ({ 3; 4; }); 5; })) + sizeof(x ? ({ 1; 2; }) : 3) + sizeof (({ *q; 1; })) +\n"
                  "           __alignof__(({ *q; x == 1; (void *)q; 1; })) + _Alignof(({ 1; 2; }));\n}\n")-1,
sizeof("int a[2];\nunsigned u;\nint s;\nunsigned long f(int x) {\n"
                  "    return sizeof(({ x / 0; 1; })) + sizeof(({ x % 0; 1; })) + sizeof(({ a[5]; 1; })) + sizeof(({ char c = 300; c; })) +\n"
                  "           sizeof(({ u < s; 1; })) + sizeof(({ int b[2]; b[2]; })) + __alignof__(({ a[2]; x / 0; 1; }));\n}\n")-1,
sizeof("int f1(void) { int u; (void)sizeof(({ u = 1; })); return u; }\n"
                  "int f2(void) { int u; (void)sizeof(({ u; })); u = 2; return u; }\n"
                  "int f3(int n) { int u; (void)(n ? sizeof(({ u; })) : 0); return 0; }\n"
                  "int f4(void) { int u; (void)({ u = 1; }); return u; }\n"
                  "int f5(void) { int u; return (int)sizeof ({ u; }); }\n"
                  "int f6(void) { int u; return (int)sizeof ({ int v = u; v; }) + (int)__alignof__(({ u; })); }\n"
                  "int f8(void) { int u; return _Generic(1, long: ({ u; }), default: 0); }\n"
                  "int f9(int n) { return sizeof ({ n; }) + sizeof({ (char)n; }) + sizeof ({ int k = n; k; }) * 2; }\n"
                  "int f10(int n) { int u; return (int)sizeof(({ ({ u; }); })) + (int)sizeof(({ (void)sizeof(({ u = 1; })); 1; })) + u; }\n")-1,
sizeof("int f1(void) { int u; (void)sizeof(({ u = 1; })); return u; }\n"
                  "int f2(void) { int u; (void)sizeof(({ u; })); u = 2; return u; }\n"
                  "int f3(int n) { int u; (void)(n ? sizeof(({ u; })) : 0); return 0; }\n"
                  "int f4(void) { int u; (void)({ u = 1; }); return u; }\n"
                  "int f5(void) { int u; return (int)sizeof ({ u; }); }\n"
                  "int f6(void) { int u; return (int)sizeof ({ int v = u; v; }) + (int)__alignof__(({ u; })); }\n"
                  "int f8(void) { int u; return _Generic(1, long: ({ u; }), default: 0); }\n"
                  "int f9(int n) { return sizeof ({ n; }) + sizeof({ (char)n; }) + sizeof ({ int k = n; k; }) * 2; }\n"
                  "int f10(int n) { int u; return (int)sizeof(({ ({ u; }); })) + (int)sizeof(({ (void)sizeof(({ u = 1; })); 1; })) + u; }\n")-1,
sizeof("int f1(void) { int u; return _Generic(1, int: ({ u; }), default: 0); }\n"
                  "int f2(void) { int u; return __builtin_choose_expr(1, ({ u; }), 0); }\n"
                  "int f3(void) { return _Generic(1, int: ({ char c = 302; c; }), default: 0); }\n"
                  "int f4(void) { int u; return _Generic(1, int: _Generic(2, long: 0, default: ({ u; })), default: 0); }\n"
                  "int f5(void) { int u; return __builtin_choose_expr(0, _Generic(1, int: ({ u; })), 0); }\n"
                  "int f6(int x) { return _Generic(1, int: ({ x == 1; 0; }), default: 0); }\n"
                  "int f7(void) { int u; return _Generic(1, long: ({ u; }), int: ({ int v = 1; v; })); }\n")-1,
sizeof("int g(int);\n"
                  "int f(int x) {\n"
                  "    ({ x; x == 1; });\n"
                  "    ({ l: x == 2; });\n"
                  "    (({ x == 3; }), 0);\n"
                  "    ({ ({ x != 4; }); });\n"
                  "    ({ x > 5; }), x;\n"
                  "    if (x) ({ x == 6; });\n"
                  "    ({ g(x) == 7; });\n"
                  "    ({ (x == 8); });\n"
                  "    x == 9;\n"
                  "    return 0;\n"
                  "}\n")-1,
sizeof("int g(int);\n"
                  "int f(int x) {\n"
                  "    ({ x; x == 1; });\n"
                  "    ({ l: x == 2; });\n"
                  "    (({ x == 3; }), 0);\n"
                  "    ({ ({ x != 4; }); });\n"
                  "    ({ x > 5; }), x;\n"
                  "    if (x) ({ x == 6; });\n"
                  "    ({ g(x) == 7; });\n"
                  "    ({ (x == 8); });\n"
                  "    x == 9;\n"
                  "    return 0;\n"
                  "}\n")-1,
sizeof("int *q;\nvoid f(int x) {\n    __typeof__(({ *q; x == 1; x = x; x / 0; 1; })) t = 0;\n"
                  "    typeof(({ (0, x); (void *)q; 1; })) v = 0;\n    (void)t;\n    (void)v;\n}\n")-1,
sizeof("int *q;\nunsigned long f(int x) {\n    ({ *q; 1; });\n    sizeof(({ 1; 2; }));\n"
                  "    unsigned long n = sizeof(int[({ x == 1; 2; })]) + sizeof(({ int w[({ 3; 4; })]; 5; }));\n"
                  "    return n + ({ x < 1; 6; }) + sizeof(int[sizeof(({ 7; 8; }))]);\n}\n")-1,
sizeof("void g(int n) {\n    char vv[n][n];\n    (void)sizeof(({ 3; vv[0]; }));\n    (void)sizeof(({ 4; vv; }));\n}\n")-1,
sizeof("typedef int wchar_t;\ntypedef unsigned long size_t;\ntypedef int myint;\ntypedef signed char tiny;\n"
                  "int s1(wchar_t wc) { return wc < 0xffU; }\n"
                  "int s2(int n) { int a[4]; return n >= sizeof a / sizeof a[0]; }\n"
                  "int s3(int n, size_t m) { return n < m; }\n"
                  "int s4(myint n, unsigned u) { return n < u; }\n"
                  "int s5(int n, size_t m) { return n < m + 1; }\n"
                  "int s6(int n, size_t m) { return n < 1 + m; }\n"
                  "int s7(int n, size_t m) { return n < (m >> 1); }\n"
                  "int s8(int n, size_t m, unsigned long u) { return n < m + u; }\n"
                  "int s9(int n) { return n < (size_t)1; }\n"
                  "int s10(tiny x, tiny y, unsigned u) { return x + y < u; }\n")-1,
sizeof("typedef unsigned long size_t;\ntypedef long ptrdiff_t;\ntypedef int wchar_t;\ntypedef int myint;\n"
                  "int printf(const char*,...);\n"
                  "void f(size_t m, ptrdiff_t d, wchar_t *w, myint n) { printf(\"%u\", m); printf(\"%u\", d); printf(\"%d\", w); printf(\"%lu\", -n); printf(\"%lu\", +n); printf(\"%lu\", ~n); }\n")-1,
sizeof("typedef _BitInt(32) T;\nvoid f(const char*, _BitInt(32)*) __attribute__((format(printf,1,2)));\n"
                  "void g(void) { f(\"%d\", (T)0); }\n")-1,
sizeof("int g(int);\nvoid f(int n, int *p) {\n    int i = 0, j = 0;\n    for ((i, j); i < n; ++i) {}\n"
                  "    for (; ; (i++, j)) { break; }\n    for (((i, j)); ; ) { break; }\n    for ((j, i++); ; ((i, 2))) { break; }\n"
                  "    for (; (i, j); ) { break; }\n    for ((i == 1, j == 2); ; (i < 2)) { break; }\n"
                  "    for ((i == 1); ; ((i < 2))) { break; }\n    for ((g(1), j); ; (j, (void)0)) { break; }\n"
                  "    for ((i, 0); ; (j, 0)) { break; }\n    for ((void)(i, j); ; ) { break; }\n    for ((p[0], (j)); ; ) { break; }\n}\n")-1,
sizeof("void f(int x) { x = x; if (x); }\nvoid g(int x) { x = x; int y = 1 << 40; (void)y; }\n"
                  "void h(int x) { if (0) x = x; return; x = x; }\nvoid k(int x) { x = x; if (x); int y = 0 ? (x = x) : 1; (void)y; }\n"
                  "int m(int x) { return (x = x) + _Generic(x, int: 1, default: (x = x)); }\n"
                  "float fl(float x) { x = x; return x; }\nint *pt(int *p) { p = p; return p; }\nvoid q(int x) { if (x = x) return; }\n")-1,
sizeof("int d = 1.5q;\n_Bool b = 0.1q;\n_Bool t = 0x1p-16494q;\n_Bool z = -0.0q;\nunsigned u = -1.5q;\nint i = 1e40q;\n"
                  "short s = 70000.5q;\nlong long l = 9007199254740993.5q;\n__int128 e = 12345678901234567890123.0q;\n__int128 f = -0.1q;\n"
                  "__float128 big = 1e5000q;\n__float128 small = 1e-5000q;\n__float128 tiny = 0x1p-16495q;\n__float128 rounded = 0x1.8p-16495q;\n"
                  "_Bool zd = -0.0;\nint g(void) { int x = 2.75q; int y = -0.0L; return x + y; }\n")-1,
sizeof("int f(int y, int z) { int w; { int q; } if (z) return 1; }\nint g(int y) { int a; return 0; }\n"
                  "void h(int p, int r) { int u; (void)r; }\n")-1,
sizeof("# 1 \"lm_main.c\"\n# 1 \"outer.h\" 1\n# 1 \"inner.h\" 1\nint f(void) { return 1 << 40; }\n"
                  "int f2(void) { return 1 << 41; }\n# 2 \"outer.h\" 2\nint g(void) { return 1 << 33; }\n"
                  "# 3 \"lm_main.c\" 2\nint h(void) { return 1 << 34; }\n# 1 \"again.h\" 1 3 4\nint k(void) { return 1 << 35; }\n"
                  "# 4 \"lm_main.c\" 2\n# 1 \"user.h\" 1\nint m(void) { return 1 << 36; }\n# 5 \"lm_main.c\" 2\n#error done\n")-1,
sizeof("typedef _BitInt(200) S; typedef unsigned _BitInt(200) U;\n"
                  "int f1(S a, S b, S *r) { return __builtin_mul_overflow(a, b, r); }\n"
                  "int f2(int a, int b, S *r) { return __builtin_mul_overflow(a, b, r); }\n"
                  "int f3(U a, U b, U *r) { return __builtin_mul_overflow(a, b, r); }\n"
                  "int f4(U a, S b, U *r) { return __builtin_mul_overflow(a, b, r); }\n"
                  "int f5(U a, int b, U *r) { return __builtin_mul_overflow(a, b, r); }\n"
                  "int f6(_BitInt(129) a, int b, int *r) { return __builtin_mul_overflow(a, (b), r); }\n"
                  "int f7(__int128 a, __int128 b, _BitInt(256) *r) { return __builtin_mul_overflow(a, b, r); }\n"
                  "int f8(S a, S b, S *r) { return __builtin_add_overflow(a, b, r) + __builtin_sub_overflow(a, b, r); }\n"
                  "int f9(unsigned _BitInt(129) a, U *r) { return __builtin_mul_overflow(a, 3, r); }\n")-1,
sizeof("struct S6;\nvoid f1(struct S1 *p);\nvoid f2(struct S2 { int a; } *p);\nvoid f3(union U3 *p);\n"
                  "void f4(enum E4 { A4 } e);\nvoid f5(enum { A5 } e, enum : long { B5 } f);\nvoid f6(struct S6 *p);\n"
                  "void f7(struct S7 *p) { (void)p; }\nint f8(struct S8 (*fp)(struct S9 *q));\nvoid f9(struct S10 *p, int (*g)(struct S10 *));\n"
                  "void (*f10)(struct S11 *);\nvoid f11(void) { void g(struct S12 *); }\nvoid f12(struct { int a; } *p, struct A { struct B *b; } *a);\n"
                  "struct V { void (*fp)(struct U *); };\nstruct T { int b; };\nvoid g1(struct T *p, struct T { int c; } *q);\n"
                  "int g2(struct R { int x; } a, struct R { int y; } b);\nint g3(enum F { B1 } a, enum F { B2 } b);\n"
                  "int g4(int (*a)[sizeof(struct Q { int q; })]);\n")-1,
sizeof("struct S6;\nvoid f1(struct S1 *p);\nvoid f2(struct S2 { int a; } *p);\nvoid f3(union U3 *p);\n"
                  "void f4(enum E4 { A4 } e);\nvoid f5(enum { A5 } e, enum : long { B5 } f);\nvoid f6(struct S6 *p);\n"
                  "void f7(struct S7 *p) { (void)p; }\nint f8(struct S8 (*fp)(struct S9 *q));\nvoid f9(struct S10 *p, int (*g)(struct S10 *));\n"
                  "void (*f10)(struct S11 *);\nvoid f11(void) { void g(struct S12 *); }\nvoid f12(struct { int a; } *p, struct A { struct B *b; } *a);\n"
                  "struct V { void (*fp)(struct U *); };\nstruct T { int b; };\nvoid g1(struct T *p, struct T { int c; } *q);\n"
                  "int g4(int (*a)[sizeof(struct Q { int q; })]);\n")-1,
sizeof("void f1(struct S1 *p);\n#pragma clang diagnostic push\n#pragma clang diagnostic ignored \"-Wvisibility\"\n"
                  "void f2(struct S2 *p);\n#pragma clang diagnostic pop\nvoid f3(struct S3 *p, struct S3 { int a; } *q);\n")-1,
sizeof("void f1(struct S1 *p);\n#pragma clang diagnostic push\n#pragma clang diagnostic ignored \"-Wvisibility\"\n"
                  "void f2(struct S2 *p);\n#pragma clang diagnostic pop\nint f3(struct S3 { int a; } p, struct S3 { int b; } q);\n")-1,
sizeof("struct S { char c; int a; } __attribute__((packed));\nstruct S { char c; int a; };\n"
                  "_Static_assert(sizeof(struct S) == 5, \"first\");\n"
                  "struct U { char c; int a __attribute__((aligned(16))); };\nstruct U { char c; int a; };\n"
                  "_Static_assert(sizeof(struct U) == 32, \"first u\");\nstruct S s;\nstruct U u;\n")-1,
sizeof("struct S { char c; int a; } __attribute__((packed));\nstruct S { char c; int a; };\n"
                  "_Static_assert(sizeof(struct S) == 5, \"first\");\n"
                  "struct U { char c; int a __attribute__((aligned(16))); };\nstruct U { char c; int a; };\n"
                  "_Static_assert(sizeof(struct U) == 32, \"first u\");\nstruct S s;\nstruct U u;\n")-1,
sizeof("struct S { char c; int a; } __attribute__((packed));\n#pragma clang diagnostic push\n#pragma clang diagnostic ignored \"-Wodr\"\n"
                  "struct S { char c; int a; };\n#pragma clang diagnostic pop\n_Static_assert(sizeof(struct S) == 5, \"first\");\n"
                  "struct U { char c; int a __attribute__((aligned(16))); };\n#pragma clang diagnostic push\n#pragma clang diagnostic warning \"-Wodr\"\n"
                  "struct U { char c; int a; };\n#pragma clang diagnostic pop\n_Static_assert(sizeof(struct U) == 32, \"first u\");\n"
                  "struct V { int a; } __attribute__((aligned(8)));\nstruct V { int a; } __attribute__((aligned(16)));\n")-1,
sizeof("# 1 \"odr_system.h\" 1 3\nstruct S { char c; int a; } __attribute__((packed));\nstruct S { char c; int a; };\n"
                  "# 4 \"odr_main.c\" 2\n_Static_assert(sizeof(struct S) == 5, \"first\");\nstruct S s;\n")-1,
sizeof("int g(struct T { int x; } a, struct T { int x; } b, struct T *c) { return a.x + b.x + c->x; }\n"
                  "int n(struct W { int a; } *p, int (*q)(struct W { int a; } *r)) { return p->a + (q != 0); }\n")-1,
sizeof("#pragma pack(3)\n#pragma pack(push, r, 4)\n#pragma pack(pop, r, 2)\n#pragma pack(pop, nosuch)\n#pragma pack\n"
                  "#pragma pack(foo)\n#pragma pack(push, 4) extra\n#pragma pack(pop, 32)\n#pragma pack(push, 4\n#pragma pack(push, r, x)\n"
                  "#pragma pack(+)\n#pragma pack(show)\n#pragma pack(2)\n#pragma pack(show)\n#pragma options align=packed\n#pragma pack(show)\n"
                  "#pragma pack(pop)\n#pragma pack(pop)\nstruct S { char c; int i; };\nint main(void) { return sizeof(struct S) != 6; }\n")-1,
sizeof("#pragma pack(push, 4)\n#pragma pack(push, inner, 1)\nstruct S { char c; int i; };\n#pragma pack()\n"
                  "int main(void) { return sizeof(struct S) != 5; }\n")-1,
sizeof("#pragma pack(push)\nint main(void) { return 0; }\n")-1,
sizeof("#pragma pack(push, 2)\nint main(void) { int x; return 0; }\n#pragma pack(show)\n#pragma pack(pop)\n")-1,
sizeof("#pragma weak nothere\n#pragma pack(push, 4)\nstatic int unused(void) { return 0; }\nstatic int unused_var;\n"
                  "static void declared(void);\nint main(void) { int x; declared(); return 0; }\n")-1,
sizeof("static int unused(void) { return 0; }\nstatic int unused_var;\nstatic void declared(void);\nint main(void) { declared(); return 0; }\n")-1,
sizeof("void rel(int *p);\nstatic int q __attribute__((cleanup(rel)));\n")-1,
sizeof("typedef short ms;\nunion U{int*p;long*q;char c;int i;};struct S{int a;};\n"
                  "int f(int n,const int k,int arr[2]){union U u=(union U)&n;union U v=(union U)arr;(void)(union U)(char)n;\n"
                  "(void)(union U)k;(void)v;return *u.p;}\n"
                  "int g(ms s,double d){(void)(union U)s;(void)(union U)d;(void)(struct S)s;return 0;}\n")-1,
sizeof("struct S{int a;struct S*n;}s;union U{int a;float f;}u;typedef struct S T;typedef const struct S CT;T t;CT ct;\n"
                  "struct S h(void);struct W{struct S in;}w,*wp;\n"
                  "void g(struct S*p){(void)(struct S)s;(void)(union U)u;(void)(const struct S)s;(void)(T)t;(void)(CT)s;(void)(const T)t;\n"
                  "(void)sizeof((T)t);(void)(int)t;(void)(int)ct;(void)(long)u;(void)(char*)s;(void)(int)h();(void)(int)w.in;\n"
                  "(void)(int)wp->in;(void)(float)p[0];(void)(_Bool)*p;(void)(int)(s);}\n")-1,
sizeof("struct S { int a; } s;\nvoid g(int x){ long l = (_Atomic long)(_Atomic int)x; (void)(_Atomic int)s; (void)(_Atomic(int *))s;\n"
                  "(void)(int)(_Atomic int)x; (void)l; }\n")-1,
sizeof("struct S { int n; int *p; };\n"
                  "struct S c[2] = { { 1, 2.5 }, { .n = 1, .n = 2 } };\nstruct S d = { 2.5, { 0, 3 } };\nstruct S e = { 1, { 2, 3 } };\n"
                  "struct S g = { 1, 2, 3 };\nint *q = { 2, 3 };\nint *r[2] = { 1, 2, 3 };\nstruct S h = { 1, { 2.5, 3 } };\n"
                  "void f(void) { struct S i = { 2.5, { 0, 3 } }; int x = 1.5; struct S j = { 3.5, 0, 1 }; struct S k = { 1, { 2, 3 } };\n"
                  "int *m = { 2, 3 }; (void)i; (void)x; (void)j; (void)k; (void)m; }\nint t[2] = { 1.5, 2, 3 };\n")-1,
sizeof("long g(long);\n"
                  "void f(int *p) { long *l = g(p); long *m = __builtin_expect(p, 0); (void)l; (void)m; }\n")-1,
sizeof("void f(int *p, char *c) { p < 1; p == 1; p > c; p != c; }\n")-1,
sizeof("typedef int *P; typedef char C; typedef long L;\n"
                  "void f(int *p, P q, C *c, const int *k, int a[2], void (*g)(void), long *l, L n, const int x) {\n"
                  "(void)(p < (char *)0); (void)(q == c); (void)(c != p); (void)(k > (long*)0); (void)(a <= l); (void)(g == (void(*)(int))0);\n"
                  "(void)(p == l ? 1 : 0); (void)(p == 1); (void)(q != n); (void)(x == a); (void)(1 == q); (void)(p == 1 ? 1 : 0); }\n")-1,
sizeof("typedef float F; typedef int *P; typedef double D; struct S { int *m; }; int *h(void);\n"
                  "void f(int *p, double d, P q, _Complex float z, const int *cp, int a[2], struct S s, D e, const double cd, _Complex int ci) {\n"
                  "(void)(float)p; (void)(F)q; (void)(double)(p + 1); (void)(int *)d; (void)(P)1.5f; (void)(_Complex double)p; (void)(int*)z;\n"
                  "(void)(long double)cp; (void)(float)(void*)0; (void)(_Float16)p; (void)(float)f; (void)(float)\"x\"; (void)(float)a;\n"
                  "(void)(float)p++; (void)(float)s.m; (void)(float)h(); (void)(float)(d ? p : p); (void)(int*)e; (void)(int*)cd;\n"
                  "(void)(_Atomic float)p; (void)(_Complex int)p; (void)(int*)ci; (void)(char*)(float)p; }\n")-1,
sizeof("typedef int *P; typedef const int CI;\n"
                  "void f(P q, CI c, int a[2], int *p, int x) { (void)_Generic(q, char: 1); (void)_Generic(c, char: 1); (void)_Generic(a, char: 1);\n"
                  "(void)_Generic((P)0, char: 1); (void)_Generic(x + 1.0, char: 1); (void)_Generic((p), char: 1, short: 2); int y = _Generic(p, char: 1) + 1; (void)y; }\n"
                  "int g = _Generic(1.0, char: 1);\n")-1,
sizeof("typedef float F; typedef typeof(nullptr) N; typedef N M; typedef int I; typedef int *IP; enum E { A };\n"
                  "void f(N n, const N cn, M m, I i, IP p, const int ci, int a[2]) {\n"
                  "(void)(float)nullptr; (void)(_Complex float)nullptr; (void)(F)n; (void)(enum E)m; (void)(long double)cn; (void)(_BitInt(8))nullptr;\n"
                  "(void)(_Atomic float)n; (void)(N)1; (void)(N)i; (void)(N)p; (void)(M)ci; (void)(N)a; (void)(N)(int*)0; (void)(N)1.5; (void)(const N)p;\n"
                  "(void)(I)n; (void)(N)\"x\";\n"
                  "(void)(_Bool)nullptr; (void)(void*)n; (void)(int*)m; (void)(void)n; (void)(N)n; (void)(N)0; (void)(N)(void *)0; }\n")-1,
sizeof("typedef typeof(nullptr) N; enum E { A };\n"
                  "N g = (N)0; N h = (N)(void *)0; static N k = (N)false; N u; void *v = (N)0; struct P { int a; N n; } ps = { 1, (N)0 };\n"
                  "int f(void) { N a = (N)0; N b = (N)(void*)0; N c = (N)(1 - 1); N d = (N)A; N e = (N)'\\0'; N q = (N)(char)0; N r = (N)((void*)0);\n"
                  "return (a == nullptr) + (b == nullptr) + (c == nullptr) + (d == nullptr) + (e == nullptr) + (q == nullptr) + (r == nullptr) + (g == nullptr) + (h == nullptr) + (k == nullptr); }\n")-1,
sizeof("typedef int I; typedef const int CI;\n"
                  "void f(int x) {\n"
                  "(void)_Generic(x, int: 1, int: 2, int: 3); (void)_Generic(x, I: 1, int: 2); (void)_Generic(x, char: 1, int: 2, char: 3, short: 4);\n"
                  "(void)_Generic(x, int: 1, int: 2, default: 1, default: 2, default: 3); (void)_Generic(x, default: 1, default: 2);\n"
                  "(void)_Generic(x, CI: 3, default: 0); (void)_Generic(x, int*: 1, int*: 2);\n"
                  "(void)_Generic(x, int(*)[]: 1, int(*)[2]: 2); (void)_Generic(x, long: 1, long int: 2); (void)_Generic(x, default: 0, int[2]: 3, int: 1, int: 2);\n"
                  "}\n"
                  "int g = _Generic(1, int: 1, int: 2);\n"
                  "int h[_Generic(1, long: 1, long: 2)];\n"
                  "int k(void) { switch (1) { case _Generic(1, int: 1, int: 2): return 0; } return 1; }\n"
                  "_Static_assert(_Generic(1, default: 1, default: 2), \"\");\n")-1,
sizeof("int abs(int); long labs(long); double fabs(double); float fabsf(float);\n"
                  "typedef unsigned long size_type; typedef long L; enum E { A, B };\n"
                  "size_type s; const unsigned cu; L lv; enum E e; _Bool bo; unsigned char uc; char ch; __int128 i128; long double ld; float fl; double d; _Complex double cd; int *p; int arr[2]; void fn(void);\n"
                  "void g(void) {\n"
                  "(void)__builtin_abs(cu); (void)__builtin_abs(lv); (void)__builtin_abs(d); (void)__builtin_fabs(ch); (void)__builtin_fabsf(d); (void)__builtin_labs(ld);\n"
                  "(void)abs(s); (void)abs(lv); (void)abs(d); (void)fabs(ch); (void)fabsf(ld); (void)abs(e); (void)abs(bo); (void)abs(uc); (void)abs(i128); (void)fabs(fl);\n"
                  "(void)__builtin_abs(cd); (void)__builtin_cabs(d); (void)__builtin_llabs(ch); (void)(abs)(lv); (void)abs((L)1); (void)abs(1.0f);\n"
                  "}\n"
                  "static long llabs(long long x) { return x; }\n"
                  "void h(void) { (void)abs(1LL); }\n")-1,
sizeof("int abs(int); long labs(long);\n"
                  "int *p; int arr[2]; void fn(void);\n"
                  "void g(void) { (void)__builtin_abs(p); (void)__builtin_labs(arr); (void)labs(arr); (void)abs(fn); (void)__builtin_llabs(p); }\n")-1,
sizeof("typedef short S; typedef int *IP; typedef void *VP; typedef const void *CVP;\n"
                  "enum E { A }; enum E e; S s; char c; _Bool bo; int i; long l; unsigned _BitInt(63) u63; _BitInt(7) b7; const short cs; volatile char vc; __int128 i128;\n"
                  "struct R { int f : 3; } r;\n"
                  "void f(void) {\n"
                  "(void)(void*)s; (void)(IP)c; (void)(VP)i; (void)(void*)e; (void)(void*)bo; (void)(void*)l; (void)(void*)u63; (void)(void*)b7; (void)(CVP)i;\n"
                  "(void)(void*)(char)1; (void)(void*)(s+1); (void)(void*)cs; (void)(void*)vc; (void)(const void*)c; (void)sizeof((void*)c);\n"
                  "(void)(_Atomic(int*))c; (void)(void(*)(void))c; (void)(int(*)[2])c; (void)(void*)'a'; (void)(void*)(short)i; (void)(char*)(c);\n"
                  "(void)(void*)(char)(1 ? 2 : i); (void)(void*)(enum E)c; (void)(void*)__extension__ c; (void)(void*)r.f; (void)(int * const)c; (void)(void*)i128;\n"
                  "(void)(void*)(c = 1); (void)(void*)c++; (void)(void*)(i, c); (void)(void*)(int)1.5; (void)(void*)(1 + 2); (void)(void*)(char)i; }\n"
                  "void *g = (void*)(char)3;\n")-1,
sizeof("struct S { int a; } s; int *p; float *fp; double d; char q[4];\n"
                  "void f(void) {\n"
                  "long a = __builtin_expect(p, p); long c = __builtin_expect(p, s); long e = __builtin_expect_with_probability(p, p, p);\n"
                  "void *m = __builtin_memcpy(1, 2, p); void *n = __builtin_memcpy(fp, d, p);\n"
                  "(void)__builtin_alloca_with_align(p, 64); __xray_typedevent(p, q, p);\n"
                  "(void)a; (void)c; (void)e; (void)m; (void)n; }\n")-1,
sizeof("int *p; struct S { int a; } s;\n"
                  "void f(void) { (void)__builtin_fabs(p); (void)__builtin_fabsf(p); (void)__builtin_fabsl(s); (void)__builtin_canonicalize(p); (void)__builtin_signbitf(p); (void)__builtin_abs(p); (void)__builtin_labs(p); }\n")-1,
sizeof("char c0 = 1000;\n"
                  "char c = 1000;\n"
                  "struct S { int *p; int n; char c; } s = { 2, 1.5, 1000 };\n"
                  "int a[3] = { 1.5, (int*)0, 2.5 };\n"
                  "struct S t[2] = { { 2, 1.5 }, { 3, 2.5 } };\n"
                  "int *h = 2;\n"
                  "int z = 1.5;\n")-1,
sizeof("void f(int x) {\n"
                  "(void)_Generic(x, int: 1, char: 2, char: 3, int: 4);\n"
                  "(void)_Generic(x, const int: 1, int const: 2, int[2]: 3, default: 0);\n"
                  "(void)_Generic(x, int[2]: 1, int[3]: 2);\n"
                  "(void)_Generic(x, int: 1, const char: 2, char: 3, int: 4, long[1]: 5);\n"
                  "}\n"
                  "int h[_Generic(1, long: 1, const int: 2, long: 3)];\n")-1,
sizeof("int y __attribute__((aligned(8 8)));\n"
                  "int n; int z __attribute__((aligned(n n)));\n"
                  "int y2 __attribute__((aligned(8 8, 4)));\n"
                  "int y3 __attribute__((aligned(8 8), unused));\n")-1,
sizeof("int y4 __attribute__((unused, aligned((8) 8)));\n"
                  "int y5 __attribute__((aligned(8 8))), z5;\n"
                  "int y6 __attribute__((aligned(8 8))) = 3;\n"
                  "void g(void) __attribute__((aligned(8 8)));\n")-1,
sizeof("struct B { int x __attribute__((aligned(4 4))), y; int z; };\n"
                  "struct A { int m; int *p __attribute__((aligned(m m))); };\n"
                  "void f(void) { int w __attribute__((aligned(8 8))) = 1; (void)w; char c = 1000; (void)c; }\n"
                  "int w = 1.5;\n")-1,
sizeof("void f(void) __attribute__((unused)) __attribute__((aligned(8 8))) { } int kept; int *p = &kept; int y __attribute__((aligned(8 8))), z;\n"
                  "int (*q)(void) __attribute__((aligned(8 8)));\n"
                  "int r(void) __asm__(\"r\") __attribute__((aligned(8 8)));\n"
                  "int s, t(void) __attribute__((aligned(8 8)));\n")-1,
sizeof("int old __attribute__((deprecated, aligned(8 8))), skipped; int read_old(void) { return old; }\n"
                  "int g(void) { int older __attribute__((deprecated, aligned(8 8))), skipped2; return older; }\n")-1,
sizeof("int x = 1; void f(void) __attribute__((unused, aligned(8 8))) {}\n")-1,
sizeof("static int unused(void) { return 0; }\nstatic int unused_var;\nint main(void) { return 0; }\n")-1,
sizeof(check_driver_gnu_designator_source)-1,
sizeof(check_driver_gnu_designator_source)-1,
sizeof(check_driver_gnu_designator_source)-1,
sizeof(check_driver_gnu_designator_source)-1,
sizeof(check_driver_gnu_designator_source)-1,
sizeof("typedef const int CI;\n"
                  "typedef const volatile int CVI;\n"
                  "const int file_a;\n"
                  "static const int file_b;\n"
                  "extern const int file_c;\n"
                  "struct M { const int m; int x; };\n"
                  "struct N { struct M inner; int y; };\n"
                  "union U { const int u; float f; };\n"
                  "struct M file_m;\n"
                  "void f(void)\n"
                  "{\n"
                  "    const int a;\n"
                  "    const int b[2];\n"
                  "    const volatile int c;\n"
                  "    volatile CI d[2];\n"
                  "    CVI e;\n"
                  "    static const int s;\n"
                  "    extern const int ex;\n"
                  "    struct M m;\n"
                  "    struct N n;\n"
                  "    union U u;\n"
                  "    const struct M cm;\n"
                  "    struct M ms[2];\n"
                  "    const int ok = 1;\n"
                  "    register const int r;\n"
                  "    struct { const int z; } anon;\n"
                  "    const int *p;\n"
                  "    int *const q;\n"
                  "}\n")-1,
sizeof("struct M { const int m; };\n"
                  "union V { struct M s; int i; };\n"
                  "struct W { union V v; };\n"
                  "struct X { int a; struct { const int deep; }; };\n"
                  "void f(void) { union V v; struct W w; struct X x; }\n")-1,
sizeof("struct A { const int a[2]; };\n"
                  "struct B { int n; const int fam[]; };\n"
                  "struct C { const int bf : 3; };\n"
                  "struct D { struct A arr[2]; };\n"
                  "struct E { const struct { int q; } s; };\n"
                  "typedef const int CI;\n"
                  "struct F { CI t; };\n"
                  "void f(void) { struct A a; struct B b; struct C c; struct D d; struct E e; struct F g; const struct A ca; struct A *p; }\n"
                  "void k(int n) { const int vla[n]; _Atomic const int at; const int ci = 1, cj; }\n")-1,
sizeof("typedef const int CI;\n"
                  "typedef const volatile int CVI;\n"
                  "const int file_a;\n"
                  "static const int file_b;\n"
                  "extern const int file_c;\n"
                  "struct M { const int m; int x; };\n"
                  "struct N { struct M inner; int y; };\n"
                  "union U { const int u; float f; };\n"
                  "struct M file_m;\n"
                  "void f(void)\n"
                  "{\n"
                  "    const int a;\n"
                  "    const int b[2];\n"
                  "    const volatile int c;\n"
                  "    volatile CI d[2];\n"
                  "    CVI e;\n"
                  "    static const int s;\n"
                  "    extern const int ex;\n"
                  "    struct M m;\n"
                  "    struct N n;\n"
                  "    union U u;\n"
                  "    const struct M cm;\n"
                  "    struct M ms[2];\n"
                  "    const int ok = 1;\n"
                  "    register const int r;\n"
                  "    struct { const int z; } anon;\n"
                  "    const int *p;\n"
                  "    int *const q;\n"
                  "}\n")-1,
sizeof("const int a;\n"
                  "const int a;\n"
                  "int arr[];\n"
                  "extern const int x;\n"
                  "const int x;\n"
                  "const int b[];\n"
                  "const int c[];\n"
                  "const int c[3];\n"
                  "const int z;\n"
                  "const int z = 2;\n"
                  "static const int s;\n"
                  "const int t[];\n"
                  "void f(void) { int unused; }\n")-1,
sizeof("#pragma clang diagnostic warning \"-Wc++-compat\"\n"
                  "void f(void) { const int a; }\n"
                  "#pragma clang diagnostic ignored \"-Wc++-compat\"\n"
                  "void g(void) { const int b; }\n")-1,
sizeof("#pragma pack(push, 4)\n"
                  "#pragma weak never_declared\n"
                  "static void undefined_internal(void);\n"
                  "static int unused_static;\n"
                  "const int tentative;\n"
                  "static const int tentative_static;\n"
                  "void use(void) { undefined_internal(); }\n")-1
};

static void put(const char *s, size_t n) { uint32_t len=n; assert(fwrite(&len,4,1,stdout)); assert(fwrite(s,1,n,stdout)==n); }
static void emit(const CheckDriverDefaultWarningFixture *f,size_t n) {
 assert(!f->baseline_spellings && f->source && strlen(f->source)==n);
 put(f->source,n);put(f->name,strlen(f->name));
 char m[100];int k=snprintf(m,sizeof m,"%u %u %u %u %u %u %u",f->warnings,f->errors,f->notes,f->c23,f->compare_warning_text,f->compare_node_window,f->syntax_only);put(m,k);
 for(int i=0;i<4;i++){const char *o=f->options[i]?f->options[i]:"";put(o,strlen(o));}
}
int main(void){
_Static_assert(sizeof fixture_0/sizeof *fixture_0 == sizeof fixture_0_lengths/sizeof(size_t),"count");
for(unsigned i=0;i<sizeof fixture_0/sizeof *fixture_0;i++)emit(&fixture_0[i],fixture_0_lengths[i]);
_Static_assert(sizeof fixture_1/sizeof *fixture_1 == sizeof fixture_1_lengths/sizeof(size_t),"count");
for(unsigned i=0;i<sizeof fixture_1/sizeof *fixture_1;i++)emit(&fixture_1[i],fixture_1_lengths[i]);
_Static_assert(sizeof fixture_2/sizeof *fixture_2 == sizeof fixture_2_lengths/sizeof(size_t),"count");
for(unsigned i=0;i<sizeof fixture_2/sizeof *fixture_2;i++)emit(&fixture_2[i],fixture_2_lengths[i]);
_Static_assert(sizeof fixture_3/sizeof *fixture_3 == sizeof fixture_3_lengths/sizeof(size_t),"count");
for(unsigned i=0;i<sizeof fixture_3/sizeof *fixture_3;i++)emit(&fixture_3[i],fixture_3_lengths[i]);
_Static_assert(sizeof fixture_4/sizeof *fixture_4 == sizeof fixture_4_lengths/sizeof(size_t),"count");
for(unsigned i=0;i<sizeof fixture_4/sizeof *fixture_4;i++)emit(&fixture_4[i],fixture_4_lengths[i]);
_Static_assert(sizeof fixture_5/sizeof *fixture_5 == sizeof fixture_5_lengths/sizeof(size_t),"count");
for(unsigned i=0;i<sizeof fixture_5/sizeof *fixture_5;i++)emit(&fixture_5[i],fixture_5_lengths[i]);
_Static_assert(sizeof fixture_6/sizeof *fixture_6 == sizeof fixture_6_lengths/sizeof(size_t),"count");
for(unsigned i=0;i<sizeof fixture_6/sizeof *fixture_6;i++)emit(&fixture_6[i],fixture_6_lengths[i]);
_Static_assert(sizeof fixture_7/sizeof *fixture_7 == sizeof fixture_7_lengths/sizeof(size_t),"count");
for(unsigned i=0;i<sizeof fixture_7/sizeof *fixture_7;i++)emit(&fixture_7[i],fixture_7_lengths[i]);
_Static_assert(sizeof fixture_8/sizeof *fixture_8 == sizeof fixture_8_lengths/sizeof(size_t),"count");
for(unsigned i=0;i<sizeof fixture_8/sizeof *fixture_8;i++)emit(&fixture_8[i],fixture_8_lengths[i]);
_Static_assert(sizeof fixture_9/sizeof *fixture_9 == sizeof fixture_9_lengths/sizeof(size_t),"count");
for(unsigned i=0;i<sizeof fixture_9/sizeof *fixture_9;i++)emit(&fixture_9[i],fixture_9_lengths[i]);
_Static_assert(sizeof fixture_10/sizeof *fixture_10 == sizeof fixture_10_lengths/sizeof(size_t),"count");
for(unsigned i=0;i<sizeof fixture_10/sizeof *fixture_10;i++)emit(&fixture_10[i],fixture_10_lengths[i]);
_Static_assert(sizeof fixture_11/sizeof *fixture_11 == sizeof fixture_11_lengths/sizeof(size_t),"count");
for(unsigned i=0;i<sizeof fixture_11/sizeof *fixture_11;i++)emit(&fixture_11[i],fixture_11_lengths[i]);
_Static_assert(sizeof fixture_12/sizeof *fixture_12 == sizeof fixture_12_lengths/sizeof(size_t),"count");
for(unsigned i=0;i<sizeof fixture_12/sizeof *fixture_12;i++)emit(&fixture_12[i],fixture_12_lengths[i]);
_Static_assert(sizeof fixture_13/sizeof *fixture_13 == sizeof fixture_13_lengths/sizeof(size_t),"count");
for(unsigned i=0;i<sizeof fixture_13/sizeof *fixture_13;i++)emit(&fixture_13[i],fixture_13_lengths[i]);
_Static_assert(sizeof fixture_14/sizeof *fixture_14 == sizeof fixture_14_lengths/sizeof(size_t),"count");
for(unsigned i=0;i<sizeof fixture_14/sizeof *fixture_14;i++)emit(&fixture_14[i],fixture_14_lengths[i]);
_Static_assert(sizeof fixture_15/sizeof *fixture_15 == sizeof fixture_15_lengths/sizeof(size_t),"count");
for(unsigned i=0;i<sizeof fixture_15/sizeof *fixture_15;i++)emit(&fixture_15[i],fixture_15_lengths[i]);
_Static_assert(sizeof fixture_16/sizeof *fixture_16 == sizeof fixture_16_lengths/sizeof(size_t),"count");
for(unsigned i=0;i<sizeof fixture_16/sizeof *fixture_16;i++)emit(&fixture_16[i],fixture_16_lengths[i]);
_Static_assert(sizeof fixture_17/sizeof *fixture_17 == sizeof fixture_17_lengths/sizeof(size_t),"count");
for(unsigned i=0;i<sizeof fixture_17/sizeof *fixture_17;i++)emit(&fixture_17[i],fixture_17_lengths[i]);
_Static_assert(sizeof fixture_18/sizeof *fixture_18 == sizeof fixture_18_lengths/sizeof(size_t),"count");
for(unsigned i=0;i<sizeof fixture_18/sizeof *fixture_18;i++)emit(&fixture_18[i],fixture_18_lengths[i]);
_Static_assert(sizeof fixture_19/sizeof *fixture_19 == sizeof fixture_19_lengths/sizeof(size_t),"count");
for(unsigned i=0;i<sizeof fixture_19/sizeof *fixture_19;i++)emit(&fixture_19[i],fixture_19_lengths[i]);
_Static_assert(sizeof fixture_20/sizeof *fixture_20 == sizeof fixture_20_lengths/sizeof(size_t),"count");
for(unsigned i=0;i<sizeof fixture_20/sizeof *fixture_20;i++)emit(&fixture_20[i],fixture_20_lengths[i]);
_Static_assert(sizeof fixture_21/sizeof *fixture_21 == sizeof fixture_21_lengths/sizeof(size_t),"count");
for(unsigned i=0;i<sizeof fixture_21/sizeof *fixture_21;i++)emit(&fixture_21[i],fixture_21_lengths[i]);
_Static_assert(sizeof fixture_22/sizeof *fixture_22 == sizeof fixture_22_lengths/sizeof(size_t),"count");
for(unsigned i=0;i<sizeof fixture_22/sizeof *fixture_22;i++)emit(&fixture_22[i],fixture_22_lengths[i]);
_Static_assert(sizeof fixture_23/sizeof *fixture_23 == sizeof fixture_23_lengths/sizeof(size_t),"count");
for(unsigned i=0;i<sizeof fixture_23/sizeof *fixture_23;i++)emit(&fixture_23[i],fixture_23_lengths[i]);
_Static_assert(sizeof fixture_24/sizeof *fixture_24 == sizeof fixture_24_lengths/sizeof(size_t),"count");
for(unsigned i=0;i<sizeof fixture_24/sizeof *fixture_24;i++)emit(&fixture_24[i],fixture_24_lengths[i]);
_Static_assert(sizeof fixture_25/sizeof *fixture_25 == sizeof fixture_25_lengths/sizeof(size_t),"count");
for(unsigned i=0;i<sizeof fixture_25/sizeof *fixture_25;i++)emit(&fixture_25[i],fixture_25_lengths[i]);
_Static_assert(sizeof fixture_26/sizeof *fixture_26 == sizeof fixture_26_lengths/sizeof(size_t),"count");
for(unsigned i=0;i<sizeof fixture_26/sizeof *fixture_26;i++)emit(&fixture_26[i],fixture_26_lengths[i]);
_Static_assert(sizeof fixture_27/sizeof *fixture_27 == sizeof fixture_27_lengths/sizeof(size_t),"count");
for(unsigned i=0;i<sizeof fixture_27/sizeof *fixture_27;i++)emit(&fixture_27[i],fixture_27_lengths[i]);
_Static_assert(sizeof fixture_28/sizeof *fixture_28 == sizeof fixture_28_lengths/sizeof(size_t),"count");
for(unsigned i=0;i<sizeof fixture_28/sizeof *fixture_28;i++)emit(&fixture_28[i],fixture_28_lengths[i]);
_Static_assert(sizeof fixture_29/sizeof *fixture_29 == sizeof fixture_29_lengths/sizeof(size_t),"count");
for(unsigned i=0;i<sizeof fixture_29/sizeof *fixture_29;i++)emit(&fixture_29[i],fixture_29_lengths[i]);
_Static_assert(sizeof fixture_30/sizeof *fixture_30 == sizeof fixture_30_lengths/sizeof(size_t),"count");
for(unsigned i=0;i<sizeof fixture_30/sizeof *fixture_30;i++)emit(&fixture_30[i],fixture_30_lengths[i]);
_Static_assert(sizeof fixture_31/sizeof *fixture_31 == sizeof fixture_31_lengths/sizeof(size_t),"count");
for(unsigned i=0;i<sizeof fixture_31/sizeof *fixture_31;i++)emit(&fixture_31[i],fixture_31_lengths[i]);
_Static_assert(sizeof fixture_32/sizeof *fixture_32 == sizeof fixture_32_lengths/sizeof(size_t),"count");
for(unsigned i=0;i<sizeof fixture_32/sizeof *fixture_32;i++)emit(&fixture_32[i],fixture_32_lengths[i]);
_Static_assert(sizeof fixture_33/sizeof *fixture_33 == sizeof fixture_33_lengths/sizeof(size_t),"count");
for(unsigned i=0;i<sizeof fixture_33/sizeof *fixture_33;i++)emit(&fixture_33[i],fixture_33_lengths[i]);
_Static_assert(sizeof fixture_34/sizeof *fixture_34 == sizeof fixture_34_lengths/sizeof(size_t),"count");
for(unsigned i=0;i<sizeof fixture_34/sizeof *fixture_34;i++)emit(&fixture_34[i],fixture_34_lengths[i]);
_Static_assert(sizeof fixture_35/sizeof *fixture_35 == sizeof fixture_35_lengths/sizeof(size_t),"count");
for(unsigned i=0;i<sizeof fixture_35/sizeof *fixture_35;i++)emit(&fixture_35[i],fixture_35_lengths[i]);
_Static_assert(sizeof fixture_36/sizeof *fixture_36 == sizeof fixture_36_lengths/sizeof(size_t),"count");
for(unsigned i=0;i<sizeof fixture_36/sizeof *fixture_36;i++)emit(&fixture_36[i],fixture_36_lengths[i]);
_Static_assert(sizeof fixture_37/sizeof *fixture_37 == sizeof fixture_37_lengths/sizeof(size_t),"count");
for(unsigned i=0;i<sizeof fixture_37/sizeof *fixture_37;i++)emit(&fixture_37[i],fixture_37_lengths[i]);
_Static_assert(sizeof fixture_38/sizeof *fixture_38 == sizeof fixture_38_lengths/sizeof(size_t),"count");
for(unsigned i=0;i<sizeof fixture_38/sizeof *fixture_38;i++)emit(&fixture_38[i],fixture_38_lengths[i]);
_Static_assert(sizeof fixture_39/sizeof *fixture_39 == sizeof fixture_39_lengths/sizeof(size_t),"count");
for(unsigned i=0;i<sizeof fixture_39/sizeof *fixture_39;i++)emit(&fixture_39[i],fixture_39_lengths[i]);
_Static_assert(sizeof fixture_40/sizeof *fixture_40 == sizeof fixture_40_lengths/sizeof(size_t),"count");
for(unsigned i=0;i<sizeof fixture_40/sizeof *fixture_40;i++)emit(&fixture_40[i],fixture_40_lengths[i]);
_Static_assert(sizeof fixture_41/sizeof *fixture_41 == sizeof fixture_41_lengths/sizeof(size_t),"count");
for(unsigned i=0;i<sizeof fixture_41/sizeof *fixture_41;i++)emit(&fixture_41[i],fixture_41_lengths[i]);
_Static_assert(sizeof fixture_42/sizeof *fixture_42 == sizeof fixture_42_lengths/sizeof(size_t),"count");
for(unsigned i=0;i<sizeof fixture_42/sizeof *fixture_42;i++)emit(&fixture_42[i],fixture_42_lengths[i]);
_Static_assert(sizeof fixture_43/sizeof *fixture_43 == sizeof fixture_43_lengths/sizeof(size_t),"count");
for(unsigned i=0;i<sizeof fixture_43/sizeof *fixture_43;i++)emit(&fixture_43[i],fixture_43_lengths[i]);
_Static_assert(sizeof fixture_44/sizeof *fixture_44 == sizeof fixture_44_lengths/sizeof(size_t),"count");
for(unsigned i=0;i<sizeof fixture_44/sizeof *fixture_44;i++)emit(&fixture_44[i],fixture_44_lengths[i]);
_Static_assert(sizeof fixture_45/sizeof *fixture_45 == sizeof fixture_45_lengths/sizeof(size_t),"count");
for(unsigned i=0;i<sizeof fixture_45/sizeof *fixture_45;i++)emit(&fixture_45[i],fixture_45_lengths[i]);
_Static_assert(sizeof fixture_46/sizeof *fixture_46 == sizeof fixture_46_lengths/sizeof(size_t),"count");
for(unsigned i=0;i<sizeof fixture_46/sizeof *fixture_46;i++)emit(&fixture_46[i],fixture_46_lengths[i]);
_Static_assert(sizeof fixture_47/sizeof *fixture_47 == sizeof fixture_47_lengths/sizeof(size_t),"count");
for(unsigned i=0;i<sizeof fixture_47/sizeof *fixture_47;i++)emit(&fixture_47[i],fixture_47_lengths[i]);
_Static_assert(sizeof fixture_48/sizeof *fixture_48 == sizeof fixture_48_lengths/sizeof(size_t),"count");
for(unsigned i=0;i<sizeof fixture_48/sizeof *fixture_48;i++)emit(&fixture_48[i],fixture_48_lengths[i]);
_Static_assert(sizeof fixture_49/sizeof *fixture_49 == sizeof fixture_49_lengths/sizeof(size_t),"count");
for(unsigned i=0;i<sizeof fixture_49/sizeof *fixture_49;i++)emit(&fixture_49[i],fixture_49_lengths[i]);
_Static_assert(sizeof fixture_50/sizeof *fixture_50 == sizeof fixture_50_lengths/sizeof(size_t),"count");
for(unsigned i=0;i<sizeof fixture_50/sizeof *fixture_50;i++)emit(&fixture_50[i],fixture_50_lengths[i]);
_Static_assert(sizeof fixture_51/sizeof *fixture_51 == sizeof fixture_51_lengths/sizeof(size_t),"count");
for(unsigned i=0;i<sizeof fixture_51/sizeof *fixture_51;i++)emit(&fixture_51[i],fixture_51_lengths[i]);
_Static_assert(sizeof fixture_52/sizeof *fixture_52 == sizeof fixture_52_lengths/sizeof(size_t),"count");
for(unsigned i=0;i<sizeof fixture_52/sizeof *fixture_52;i++)emit(&fixture_52[i],fixture_52_lengths[i]);
_Static_assert(sizeof fixture_53/sizeof *fixture_53 == sizeof fixture_53_lengths/sizeof(size_t),"count");
for(unsigned i=0;i<sizeof fixture_53/sizeof *fixture_53;i++)emit(&fixture_53[i],fixture_53_lengths[i]);
_Static_assert(sizeof fixture_54/sizeof *fixture_54 == sizeof fixture_54_lengths/sizeof(size_t),"count");
for(unsigned i=0;i<sizeof fixture_54/sizeof *fixture_54;i++)emit(&fixture_54[i],fixture_54_lengths[i]);
_Static_assert(sizeof fixture_55/sizeof *fixture_55 == sizeof fixture_55_lengths/sizeof(size_t),"count");
for(unsigned i=0;i<sizeof fixture_55/sizeof *fixture_55;i++)emit(&fixture_55[i],fixture_55_lengths[i]);
_Static_assert(sizeof fixture_56/sizeof *fixture_56 == sizeof fixture_56_lengths/sizeof(size_t),"count");
for(unsigned i=0;i<sizeof fixture_56/sizeof *fixture_56;i++)emit(&fixture_56[i],fixture_56_lengths[i]);
_Static_assert(sizeof fixture_57/sizeof *fixture_57 == sizeof fixture_57_lengths/sizeof(size_t),"count");
for(unsigned i=0;i<sizeof fixture_57/sizeof *fixture_57;i++)emit(&fixture_57[i],fixture_57_lengths[i]);
}
