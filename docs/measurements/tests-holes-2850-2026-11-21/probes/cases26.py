# cases26.py: the objects' side (#3203, #3206, #3207): what T and the kernel read of an object that the reader settles
# after the bodies. A unit each: a function multiversioned by target strings, called, its address taken, declared and
# not called, by target_clones and by cpu_dispatch; an asm label after a definition, after a tentative definition, on a
# register variable, twice, on a builtin kept and ignored; a rename pragma before and after its declaration, with a
# library builtin's call before and after; a weak name by each way the reader notes one, used before and after.
OPTIONS = ['-nostdinc']
TAIL = '\nint tail(int a) { return a + 1; }\n'
SIZE = 'typedef unsigned long size_t;\nvoid* memcpy(void* destination, const void* source, size_t count);\nvoid* memmove(void* destination, const void* source, size_t count);\nint abs(int value);\n'
units = {
    # A multiversioned function.
    'mv-called': '__attribute__((target("default"))) int v(int n) { return n; }\n__attribute__((target("avx2"))) int v(int n) { return n + 1; }\nint f(int n) { return v(n); }\n',
    'mv-called-twice': '__attribute__((target("default"))) int v(int n) { return n; }\n__attribute__((target("avx2"))) int v(int n) { return n + 1; }\nint g(int);\nint f(int n) { int a = v(n); int b = g(n); return a + b + v(b); }\n',
    'mv-address': '__attribute__((target("default"))) int v(int n) { return n; }\n__attribute__((target("avx2"))) int v(int n) { return n + 1; }\nint (*f(void))(int) { return v; }\n',
    'mv-address-stored': '__attribute__((target("default"))) int v(int n) { return n; }\n__attribute__((target("avx2"))) int v(int n) { return n + 1; }\nint (*keep)(int) = v;\nint f(int n) { int (*p)(int) = v; return p(n); }\n',
    'mv-not-called': '__attribute__((target("default"))) int v(int n) { return n; }\n__attribute__((target("avx2"))) int v(int n) { return n + 1; }\nint g(int);\nint f(int n) { return g(n); }\n',
    'mv-static': 'static __attribute__((target("default"))) int v(void) { return 0; }\nstatic __attribute__((target("avx2"))) int v(void) { return 1; }\nint f(void) { return v(); }\n',
    'mv-declared-later': 'int g(int);\nint f(int n) { return g(n); }\n__attribute__((target("default"))) int v(int n) { return n; }\n__attribute__((target("avx2"))) int v(int n) { return n + 1; }\nint h(int n) { return v(n) + g(n); }\n',
    'mv-clones': '__attribute__((target_clones("avx2", "default"))) int tc(int n) { return n * 3; }\nint f(int n) { int (*p)(int) = tc; return tc(n) + p(n); }\n',
    'mv-clones-not-called': '__attribute__((target_clones("avx2", "default"))) int tc(int n) { return n * 3; }\nint g(int);\nint f(int n) { return g(n); }\n',
    'mv-dispatch': '__attribute__((cpu_specific(generic))) int s(int n) { return n + 1; }\n__attribute__((cpu_specific(haswell))) int s(int n) { return n * 3; }\n__attribute__((cpu_dispatch(generic, haswell))) int s(int n);\nint (*keep)(int) = s;\nint f(int n) { int (*p)(int) = s; return s(n) + p(n); }\n',
    'overloadable': 'int __attribute__((overloadable)) o(int);\nint __attribute__((overloadable)) o(long);\nint g(int);\nint before(int a) { return g(a); }\nint f(int a) { return o(a) + g(a); }\nint after(int a) { (void)a; return g(a); }\n',
    'overloadable-unused': 'int __attribute__((overloadable)) o(int);\nint __attribute__((overloadable)) o(long);\nint g(int);\nint f(int a) { return g(a); }\n',
    # An asm label.
    'label-after-definition': 'int x = 1;\nextern int x asm("b");\nint f(void) { return x; }\n',
    'label-after-function': 'int k(void) { return 2; }\nint k(void) asm("late");\nint f(void) { return k(); }\n',
    'label-before-definition': 'extern int x asm("b");\nint x = 1;\nint f(void) { return x; }\n',
    'label-after-tentative': 'int x;\nextern int x asm("b");\nint f(void) { return x; }\n',
    'label-twice': 'extern int x asm("b");\nextern int x asm("b");\nint x = 1;\nint f(void) { return x; }\n',
    'label-then-ignored': 'extern int x asm("b");\nint x = 1;\nextern int x asm("b");\nint f(void) { return x; }\n',
    'label-register': 'int f(int n) { register long r asm("r10") = n; return (int)r; }\n',
    'label-static-local': 'int f(int n) { static int s asm("named") = 3; return s + n; }\n',
    'label-builtin-kept': SIZE + 'void* memcpy(void*, const void*, size_t) asm("copied");\nint f(char* to, const char* from) { memcpy(to, from, 8); return 1; }\n',
    'label-builtin-kept-first': 'typedef unsigned long size_t;\nvoid* memcpy(void*, const void*, size_t) asm("copied");\nint abs(int) asm("absolute");\nint f(char* to, const char* from, int n) { memcpy(to, from, 8); return abs(n); }\n',
    'label-builtin-ignored': 'typedef unsigned long size_t;\nvoid* memcpy(void* d, const void* s, size_t n) { char* a = d; const char* b = s; while (n--) *a++ = *b++; return d; }\nvoid* memcpy(void*, const void*, size_t) asm("late_copy");\nint f(char* to, const char* from) { memcpy(to, from, 8); return 1; }\n',
    'label-builtin-ignored-abs': 'int abs(int n) { return n < 0 ? -n : n; }\nint abs(int) asm("late_abs");\nint f(int n) { return abs(n); }\n',
    'label-builtin-none': SIZE + 'int f(char* to, const char* from, int n) { memcpy(to, from, 8); memmove(to, from, 4); return abs(n); }\n',
    'label-other-builtin': SIZE + 'void* memmove(void*, const void*, size_t) asm("moved");\nint f(char* to, const char* from, int n) { memcpy(to, from, 8); memmove(to, from, 4); return abs(n); }\n',
    # A rename pragma.
    'rename-before': SIZE + 'extern int other asm("o");\n#pragma redefine_extname memmove renamed_move\nint f(char* to, const char* from) { memmove(to, from, 8); return other; }\n',
    'rename-declared-after': 'typedef unsigned long size_t;\nextern int other asm("o");\n#pragma redefine_extname memcpy renamed_copy\nvoid* memcpy(void* destination, const void* source, size_t count);\nint f(char* to, const char* from) { memcpy(to, from, 8); return other; }\n',
    'rename-after-call': SIZE + 'extern int other asm("o");\nint f(char* to, const char* from) { memcpy(to, from, 8); return other; }\n#pragma redefine_extname memcpy renamed_copy\nint g(char* to, const char* from) { memcpy(to, from, 8); return abs(other); }\n',
    'rename-object': 'extern int data;\nextern int other asm("o");\n#pragma redefine_extname data renamed_data\nint f(void) { return data + other; }\n',
    'rename-no-asm': SIZE + '#pragma redefine_extname memcpy renamed_copy\nint f(char* to, const char* from, int n) { memcpy(to, from, 8); return abs(n); }\n',
    'rename-defined-before': 'extern int other asm("o");\nint defined = 11;\n#pragma redefine_extname defined not_emitted\nint f(void) { return defined + other; }\n',
    'rename-other-function': SIZE + 'extern int other asm("o");\nint g(int);\n#pragma redefine_extname g renamed_g\nint f(char* to, const char* from, int n) { memcpy(to, from, 8); return g(n) + other; }\n',
    'rename-labelled': 'extern int explicit_name asm("chosen");\n#pragma redefine_extname explicit_name not_chosen\nint f(void) { return explicit_name; }\n',
    # A weak name.
    'weak-then-defined': 'int k(void) __attribute__((weak));\nint k(void) { return 1; }\nint f(void) { return k(); }\n',
    'weak-then-defined-tested': 'int k(void) __attribute__((weak));\nint k(void) { return 1; }\nint f(void) { return k ? k() : 0; }\n',
    'weak-block': 'static int h(void) { return 1; }\nint f(void) { int h(void) __attribute__((weak)); return h(); }\n',
    'weak-block-before-after': 'static int h(void) { return 1; }\nint early(void) { return h(); }\nint f(void) { int h(void) __attribute__((weak)); return h(); }\nint late(void) { return h(); }\nint later(void) { return h() + h(); }\n',
    'weak-block-tested': 'int h(void);\nint early(void) { return h ? 1 : 0; }\nint f(void) { int h(void) __attribute__((weak)); return h ? 1 : 0; }\nint late(void) { return h ? 1 : 0; }\n',
    'weak-block-object': 'extern int w;\nint early(void) { return &w != 0; }\nint f(void) { extern int w __attribute__((weak)); return &w != 0; }\nint late(void) { return &w != 0; }\n',
    'weakref-function': 'static int missing(void) __attribute__((weakref("target")));\nint f(void) { return missing(); }\n',
    'weakref-defined': 'static int target(int n) { return n * 2; }\nstatic int reference(int) __attribute__((weakref("target")));\nint f(int n) { return reference(n); }\n',
    'weakref-object': 'static int data __attribute__((weakref("external_data")));\nint f(void) { return data; }\n',
    'weakref-tested': 'static int missing(void) __attribute__((weakref("target")));\nint f(void) { return missing ? missing() : 0; }\n',
    'weak-only': 'int k(void) __attribute__((weak));\nint f(void) { return k(); }\n',
    'weak-only-tested': 'extern int k(void) __attribute__((weak));\nint f(void) { return k ? k() : 0; }\n',
    'weak-object': 'extern int w __attribute__((weak));\nint f(void) { return &w ? w : 0; }\n',
    'weak-redeclared-later': 'int k(void);\nint early(void) { return k ? 1 : 0; }\nint k(void) __attribute__((weak));\nint late(void) { return k ? 1 : 0; }\n',
    'weak-pragma': 'int k(void);\nint early(void) { return k ? 1 : 0; }\n#pragma weak k\nint late(void) { return k ? 1 : 0; }\n',
    'weak-pragma-and-attribute': 'int k(void);\nint j(void) __attribute__((weak));\nint early(void) { return (k ? 1 : 0) + (j ? 1 : 0); }\n#pragma weak k\nint late(void) { return (k ? 1 : 0) + (j ? 1 : 0); }\n',
    'weak-many': ''.join('int w%d(void) __attribute__((weak));\n' % i for i in range(20)) + 'int plain(void);\nint f(void) { return ' + ' + '.join('(w%d ? 1 : 0)' % i for i in range(20)) + ' + (plain ? 1 : 0); }\n',
    'weak-local-same-name': 'int f(int n) { int w = n; { extern int w __attribute__((weak)); n += &w != 0; } return w + n; }\n',
}
for name, text in units.items():
    C(name, text + TAIL)
