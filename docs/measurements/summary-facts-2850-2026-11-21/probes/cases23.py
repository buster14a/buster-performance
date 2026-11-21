# cases23.py: a summary node's side facts' cases (#2850), the walks' other sources: the references' walk's (a compound
# literal's initializer, a statement expression's region, an overloaded call's selected function, a constant string's
# builtin, `__func__`, a label's address, a thread's object), the return flow's builtins that stop, a pointer to a
# function declared noreturn, and the library's builtins the reader marks. One statement each in a function.
PRE = '''struct pair { int first; long second; int (*call)(int); int list[4]; struct pair* next; };
typedef __SIZE_TYPE__ size_t;
extern int g;
static int sg;
int ga[8];
struct pair gp;
extern _Thread_local int tls;
static _Thread_local int stls;
int one(int a);
int callee(int a, long b);
void voided(void);
void stop(void) __attribute__((noreturn));
extern void (*stopper)(void) __attribute__((noreturn));
int ov(int a) __attribute__((overloadable));
int ov(long a) __attribute__((overloadable));
int ov(const char* a) __attribute__((overloadable));
void* memcpy(void* to, const void* from, size_t size);
void* memset(void* to, int value, size_t size);
size_t strlen(const char* text);
int strcmp(const char* a, const char* b);
int abs(int value);
int printf(const char* format, ...);
int f(int a, long b, char c, int* p, struct pair* q, int (*fp)(int), void* buffer)
{
    static int counter;
    int local = 0;
    long wide = 0;
    int* ptr = 0;
    const char* string = 0;
    struct pair value = { 0 };
'''
POST = '''
    return local + (int)wide + (ptr != 0) + (string != 0) + counter + value.first;
}
'''
def S(name, statement):
    C(name, PRE + '    ' + statement + POST)
others = [
    'q = &(struct pair){ g, 1 };', 'q = &(struct pair){ .first = sg, .list = { g, a } };', 'local = (int){ g };', 'ptr = (int[]){ g, sg, a };', 'local = ((struct pair){ g, b }).first;',
    'value = (struct pair){ a, b };', 'value = (struct pair){ g, gp.second };', 'local = one((int){ sg });', 'ptr = (int[2]){ 1, 2 };', 'string = (const char[]){ "abc" };',
    'local = ({ g; });', 'local = ({ int t = g; t + sg; });', 'local = ({ one(g); });', 'local = a + ({ sg; });', 'if (({ g; })) local = 1;', 'local = ({ stop(); 1; });',
    'local = ({ if (a) stop(); g; });', 'local = one(({ int t = ga[a]; t; }));',
    'local = ov(a);', 'local = ov(b);', 'local = ov("abc");', 'local = ov(g);', 'local = ov(a) + ov(b);', 'local = one(ov(a));', 'if (ov(a)) local = 1;',
    'string = __func__;', 'local = __func__[a];', 'local = __func__[0];', 'local = sizeof(__func__);', 'string = __FUNCTION__;', 'string = __PRETTY_FUNCTION__;',
    'local = tls;', 'tls = a;', 'ptr = &tls;', 'local = stls + tls;', 'stls = g;', 'ptr = &stls;',
    '{ buffer = &&here; here: local++; }', '{ static void* const targets[] = { &&here }; buffer = targets[0]; here: local++; }',
    '__builtin_unreachable();', '__builtin_trap();', '__builtin_abort();', 'if (a) __builtin_unreachable();', 'if (a) __builtin_trap();', 'if (a) __builtin_abort();',
    'local = a ? (__builtin_unreachable(), 1) : g;', 'local = (__builtin_trap(), a);', 'local = a && (__builtin_abort(), b);', 'local = one((__builtin_unreachable(), a));',
    'if (a) __builtin_longjmp(buffer, 1);',
    'stopper();', 'if (a) stopper();', '(*stopper)();', 'local = (stopper(), a);', 'local = a ? (stopper(), 1) : 2;',
    'local = __builtin_expect(g, 0);', 'if (__builtin_expect(a, 0)) local = g;', 'local = __builtin_constant_p(g);', 'local = __builtin_constant_p(4);', 'local = __builtin_popcount(g);',
    'local = __builtin_clz(a) + __builtin_ctz(sg);', 'wide = __builtin_strlen("abc");', 'wide = __builtin_strlen(string);', 'ptr = __builtin_memcpy(ptr, ga, 4);',
    'ptr = __builtin_memcpy(ptr, ga, b);', 'local = __builtin_abs(g);', 'wide = __builtin_offsetof(struct pair, second) + g;', 'local = __builtin_types_compatible_p(int, long) + sg;',
    'local = __builtin_choose_expr(1, g, sg);', 'ptr = __builtin_alloca(a);', 'local = __builtin_add_overflow(a, g, &local);', 'local = __builtin_object_size(ga, 0) != 0;',
    'memcpy(ptr, ga, 4);', 'memcpy(ptr, ga, b);', 'ptr = memcpy(ga, p, 8);', 'memset(ga, 0, sizeof(ga));', 'memset(&gp, a, sizeof gp);', 'wide = strlen("abc");', 'wide = strlen(string);',
    'local = strcmp(string, "abc");', 'local = strcmp("a", "b");', 'local = abs(g);', 'local = abs(-3);', 'printf("%d\\n", g);', 'local = printf("x");', 'printf(string);',
    'local = _Generic(a, int: g, default: sg);', 'local = _Generic(b, int: g, default: sg);', 'local = _Generic(one, int (*)(int): one, default: fp)(a);',
    'local = _Generic(a, int: one(g), long: stop);', 'wide = _Generic(b, long: sizeof(ga), default: 0);',
    'local = sizeof(ga);', 'local = sizeof ga / sizeof ga[0];', 'local = (int)sizeof(g) + g;', 'local = _Alignof(struct pair) + sg;', 'local = sizeof(one(g));', 'local = sizeof(int[a]);',
    'local = sizeof(struct pair) + sizeof gp.list;', 'wide = sizeof("abc") + g;', 'local = _Alignof(int) == 4;',
    'string = "abc";', 'string = "a" "b";', 'local = L"abc"[a];', 'local = u8"abc"[1];', 'wide = (long)"abc";', 'string = a ? "x" : "yz";', 'local = *("abc" + a);',
    'one("abc"[a]);', 'string = &"abc"[1];', 'local = "abc" != 0;', 'local = !"abc";', 'local = "abc" && a;', 'local = strlen("abc") + sg;',
    'fp = a ? one : fp;', 'fp = *one;', 'fp = &*one;', 'local = (**one)(a);', 'local = (*&one)(a);', 'local = (&*one)(a);', 'local = (***one)(g);', 'local = (*(a ? one : fp))(b);',
    'local = ((int (*)(int))callee)(a);', 'local = (one + 0 == one);', 'fp = (int (*)(int))voided;', 'local = (*(int (*)(int))voided)(a);',
]
for i, statement in enumerate(others):
    S('other-%d' % i, statement)
