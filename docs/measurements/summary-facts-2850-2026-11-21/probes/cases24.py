# cases24.py: a summary node's side facts' cases (#2850), a branch's condition whose truth the program's walk
# (check_program_branch_truth) may know through a cast, a conversion or a `!` where the condition's value has none:
# casts of an address constant to each type, of a string's and a function's, of an absolute address; under `!`, under
# `&&` and `||` on either side; casts of integer and floating constants, which fold; casts of what has no truth; the
# builtin queries; and a logical operator one operand decides under a cast. One statement each in a function.
PRE = '''struct pair { int first; long second; int (*call)(int); int list[4]; struct pair* next; };
typedef __SIZE_TYPE__ size_t;
extern int g;
static int sg;
int ga[8];
struct pair gp;
extern int weak_one __attribute__((weak));
int one(int a);
void stop(void) __attribute__((noreturn));
int f(int a, long b, char c, int* p, struct pair* q, int (*fp)(int))
{
    int local = 0;
    long wide = 0;
'''
POST = '''
    return local + (int)wide;
}
'''
def S(name, statement):
    C(name, PRE + '    ' + statement + POST)
conditions = [
    '(char)(long)&g', '(int)(long)&g', '(short)(long)&g', '(long)&g', '(unsigned long)&g', '(_Bool)&g', '(_Bool)(long)&g', '(void*)&g', '(char*)&g', '(double)(long)&g',
    '(float)(long)&g', '(char)(long)ga', '(char)(long)"abc"', '(char)(long)one', '(char)(long)&gp.second', '(char)(long)&ga[2]', '(long)&ga[2]', '(long)ga', '(long)one',
    '(long)"abc"', '(unsigned char)(unsigned long)&sg', '(char)(short)(long)&g', '(long)(char)(long)&g', '(int)(char)(long)&g', '(char)(long)(void*)&g', '(char)(size_t)&g',
    '(char)(long)&weak_one', '(long)&weak_one', '&weak_one', '(char)(long)&gp', '(char)(long)gp.list', '(char)(long)&gp.list[1]', '(unsigned)(long)&g', '(__int128)(long)&g',
    '!(char)(long)&g', '!(long)&g', '!!(char)(long)&g', '!!(long)&g', '(char)!(long)&g', '(char)!&g', '(int)!ga', '!(int)!&g', '-(char)(long)&g', '~(char)(long)&g',
    '(char)(long)&g && a', 'a && (char)(long)&g', '(char)(long)&g || a', 'a || (char)(long)&g', '(char)(long)&g && (char)(long)&sg', '(char)(long)&g || (char)(long)&sg',
    '!(char)(long)&g && a', 'a || !(char)(long)&g', '(long)&g && a', 'a && (long)&g', '(long)&g || a', 'a || (long)&g', '(char)((long)&g && a)', '(char)(a && (long)&g)',
    '(char)(long)&g == 0', '(char)(long)&g != 0', '((char)(long)&g, a)', '(a, (char)(long)&g)', '(char)(long)&g + a', '(char)(long)&g ? a : b', 'a ? (char)(long)&g : b',
    '(char)256', '(char)1', '(_Bool)2', '(int)1.5', '(float)0', '(long)0', '(void*)0', '(char*)0', '(int*)4096', '(char)(long)(int*)4096', '(char)(long)(int*)4097',
    '(long)(int*)4096', '(_Bool)(int*)4096', '(char)0.5', '(_Bool)0.5', '(int)0.5', '(unsigned char)-1', '(char)(a - a)', '(double)1', '(char)(int)(long)(void*)0',
    '(char)a', '(_Bool)a', '(long)p', '!(char)a', '(char)b', '(int)b', '(char)(long)p', '(_Bool)p', '(long)fp', '(char)(long)q', '(char)g', '(char)sg', '(char)ga[1]',
    '&g', 'ga', 'one', '"s"', 'p', '1.5f', '0.0', '-0.0', '!&g', '!ga', '!"s"', '!one', '!!&g', '!(void*)0', '!1.5', '!0.0', '&g != 0', '&g == 0', 'ga == 0', '&g != &sg',
    '&ga[1]', '&gp.second', '&*ga', '&ga[1] != 0', '!&ga[1]', '(char*)ga + 1', '(long)&g + 1', '(long)&g != 0', '(long)&g == 0', '(char)(long)&g == (char)(long)&sg',
    '__builtin_constant_p(a)', '__builtin_constant_p(4)', '!__builtin_constant_p(a)', '__builtin_constant_p(a) && b', 'b && __builtin_constant_p(a)',
    '(char)__builtin_constant_p(a)', '(char)__builtin_constant_p(4)', '__builtin_expect(a, 0)', '__builtin_expect(0, 0)', '__builtin_expect(1, 1)', '__builtin_expect(a && 0, 0)',
    '__builtin_expect((long)&g, 1)', '__builtin_expect((char)(long)&g, 1)', '__builtin_object_size(p, 0) != 0', '__builtin_types_compatible_p(int, long)',
    '__builtin_choose_expr(1, a, b)', '__builtin_choose_expr(1, (char)(long)&g, b)', '__builtin_classify_type(a)', '_Generic(a, int: 1, default: 0)',
    '_Generic(a, int: (char)(long)&g, default: 0)', 'sizeof(a) > 2 && a', 'a && sizeof(a) > 8', '(char)sizeof(a)', '(char)(sizeof(a) - 4)',
    '(char)(a && 0)', '(int)(a || 1)', '!(int)(a && 0)', '(long)(a && 0) || b', '(char)(0 && a)', '(int)(1 || a)', '(a && 0) == 0', '(char)(a && b)', '(_Bool)(a || b)',
    '(char)(a && (b || 1))', '(char)((a && 0) || b)', '(char)!(a || 1)', '(char)(long)(a && 0)',
]
kinds = [('if', 'if (%s) local = 1;'), ('while', 'while (%s) { if (a) break; a++; }'), ('do', 'do { if (a) break; a++; } while (%s);'), ('for', 'for (; %s;) { if (a) break; a++; }')]
for i, condition in enumerate(conditions):
    S('if-%d' % i, kinds[0][1] % condition)
for i, condition in enumerate(conditions[:66]):
    for kind, form in kinds[1:]:
        S('%s-%d' % (kind, i), form % condition)
# The same truths where no branch asks them: a value's, a conditional's condition's, an argument's, a return's operand's.
# (An int from a pointer is no program: the three conditions that are a pointer's have no value's case.)
for i, condition in enumerate(conditions[:66]):
    if i not in (7, 8, 28):
        S('value-%d' % i, 'local = %s;' % condition)
    S('select-%d' % i, 'local = %s ? 1 : 2;' % condition)
# And a function with no return after such a condition, which -Wreturn-type reads by the walk's truth.
for i, condition in enumerate(conditions[:66]):
    C('fall-%d' % i, PRE + '    if (%s) return 1;\n}\n' % condition)
