// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
static const char check_test_stack_protector_rules_source[] =
    "void use(void*);\n"
    "struct S { int a; char b[4]; };\n"
    "struct T { int a; int b; };\n"
    "struct U { char big[16]; };\n"
    "int f_char8(void) { char b[8]; use(b); return 0; }\n"
    "int f_char7(void) { char b[7]; use(b); return 0; }\n"
    "int f_int4(void) { int b[4]; use(b); return 0; }\n"
    "int f_int_noescape(void) { int b[4] = { 1, 2, 3, 4 }; return b[1]; }\n"
    "int f_addr(void) { int x; use(&x); return x; }\n"
    "int f_struct_arr(void) { struct S s; use(&s); return s.a; }\n"
    "int f_struct_noarr(void) { struct T t; use(&t); return t.a; }\n"
    "int f_struct_big(void) { struct U u; use(&u); return 0; }\n"
    "int f_vla(int n) { char b[n]; use(b); return 0; }\n"
    "int f_alloca(int n) { char* b = __builtin_alloca(n); use(b); return 0; }\n"
    "int f_alloca_const(void) { char* b = __builtin_alloca(8); use(b); return 0; }\n"
    "int f_plain(int x) { return x + 1; }\n"
    "int f_addr_noescape(int x) { int* p = &x; return *p; }\n"
    "int f_param_addr(int x) { use(&x); return 0; }\n"
    "int f_char_ptr_local(void) { char* p = 0; use(&p); return 0; }\n"
    "int f_struct_nested(void) { struct { struct S s; } w; use(&w); return 0; }\n"
    "int f_nested_big(void) { struct { int x; struct { char n[9]; } in; } s; use(&s); return 0; }\n"
    "int f_union_arr(void) { union { char c[2]; int i; } u; use(&u); return 0; }\n"
    "int f_union16(void) { union { int i; char c[16]; } u; use(&u); return 0; }\n"
    "int f_2d(void) { char b[4][4]; use(b); return 0; }\n"
    "int f_array_of_records(void) { struct { char c[8]; } s[2]; use(s); return 0; }\n"
    "int f_bool(void) { _Bool b[8]; use(b); return 0; }\n"
    "int f_uchar(void) { unsigned char b[8]; use(b); return 0; }\n"
    "int f_compound(void) { use((char[16]){ 0 }); return 0; }\n"
    "int f_string(void) { char s[] = \"hello world\"; use(s); return 0; }\n"
    "int f_volatile_array(void) { volatile char b[16]; b[0] = 1; return b[0]; }\n"
    "__attribute__((no_stack_protector)) int f_before(void);\n"
    "int f_before(void) { char b[16]; use(b); return 0; }\n"
    "__attribute__((no_stack_protector)) int f_exempt(int x) { char b[64]; use(b); return x; }\n"
    "int f_callee(int);\n"
    "int f_musttail(int x) { char b[16]; use(b); __attribute__((musttail)) return f_callee(x); }\n";

// Tier 0's splices of an always_inline callee: a caller is guarded where its callee is, but where its own
// no_stack_protector attribute exempts it, as clang's. (--tier1 doesn't expand a guarded callee: the call stays, and
// the callee keeps its own guard.)
static const char check_test_stack_protector_inlining_source[] =
    "void use(void*);\n"
    "static inline __attribute__((always_inline)) int inlined(void) { char b[16]; use(b); return b[0]; }\n"
    "__attribute__((no_stack_protector)) int f_exempt_caller(void) { return inlined(); }\n"
    "int f_caller(int x) { return inlined() + x; }\n"
    "int f_plain_caller(int x) { return x * 2; }\n";

// The functions whose guards differ from clang -O0's by design, and the guarded ones among them under -fstack-protector
// alone: clang's IR pads a union and an over-aligned struct with arrays of bytes (not guarded here), and a constant
// alloca under 8 bytes is (any ALLOCA is).
static const char check_test_stack_protector_differences_source[] =
    "void use(void*);\n"
    "int d_aligned(void) { struct { char c; } __attribute__((aligned(16))) s; use(&s); return 0; }\n"
    "int d_union_padding(void) { union { double d; char c[4]; int x[3]; } u; use(&u); return 0; }\n"
    "int d_alloca_small(void) { char* p = __builtin_alloca(7); use(p); return 0; }\n";

static const char check_test_stack_protector_smash_source[] =
    "#include <alloca.h>\n"
    "#include <stdio.h>\n"
    "#include <stdlib.h>\n"
    "#include <string.h>\n"
    "typedef struct { long a, b; } Pair;\n"
    "typedef int v8si __attribute__((vector_size(32)));\n"
    "static volatile int extra;\n"
    "__attribute__((noinline)) void fill(char* p, int n) { memset(p, 'A', (size_t)n); }\n"
    "__attribute__((noinline)) int plain(void) { char b[16]; fill(b, 16 + extra); return b[0]; }\n"
    "__attribute__((noinline)) int aligned64(void) { _Alignas(64) char b[100]; fill(b, 100 + extra); return b[99]; }\n"
    "__attribute__((noinline)) int vla(int n) { char b[n]; fill(b, n + 8 * extra); return b[0]; }\n"
    "__attribute__((noinline)) int with_alloca(int n) { char* b = alloca(n); fill(b, n + 8 * extra); return b[0]; }\n"
    "__attribute__((noinline)) Pair pair(void) { char b[16]; fill(b, 16 + extra); return (Pair){ b[0], 2 }; }\n"
    "__attribute__((noinline)) long double ld(void) { char b[16]; fill(b, 16 + extra); return b[0] * 1.5L; }\n"
    "int callee(int x);\n"
    "__attribute__((noinline)) int callee(int x) { return x + 7; }\n"
    "__attribute__((noinline)) int tail(int x) { char b[16]; fill(b, 16 + extra); __attribute__((musttail)) return callee(x + b[1]); }\n"
    "__attribute__((noinline, preserve_most)) int preserving(int x) { char b[16]; fill(b, 16 + extra); return x + b[4]; }\n"
    "__attribute__((noinline)) v8si vec(v8si a) { char b[16]; fill(b, 16 + extra); return a + b[5]; }\n"
    "__attribute__((noinline)) int addressed(void) { long x; fill((char*)&x, 8 + extra); return (int)x; }\n"
    "int main(int argc, char** argv)\n"
    "{\n"
    "    extra = argc > 1 ? 64 : 0;\n"
    "    const int c = argc > 1 ? atoi(argv[1]) : -1;\n"
    "    v8si v = { 1, 2, 3, 4, 5, 6, 7, 8 };\n"
    "    if (c < 0)\n"
    "    {\n"
    "        Pair p = pair();\n"
    "        printf(\"%d %d %d %d %ld %ld %d %d %d %d %d\\n\", plain(), aligned64(), vla(40), with_alloca(40), p.a, p.b, (int)ld(), tail(1),\n"
    "               preserving(1), vec(v)[7], addressed());\n"
    "        return 0;\n"
    "    }\n"
    "    const int r = c == 0 ? plain() : c == 1 ? aligned64() : c == 2 ? vla(40) : c == 3 ? with_alloca(40) : c == 4 ? (int)pair().a : c == 5 ? (int)ld() :\n"
    "                  c == 6 ? tail(1) : c == 7 ? preserving(1) : c == 8 ? vec(v)[0] : addressed();\n"
    "    printf(\"not detected %d\\n\", r);\n"
    "    return 0;\n"
    "}\n";

