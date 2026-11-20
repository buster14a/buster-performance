# synth.py DIR: synthetic units for the warnings' helpers the gate's lists never reach (#2924 C12c-2), 60 units each:
# typo/   a scope of 3,000 globals and 50 misspelled uses (typo correction's limit), -ferror-limit=0;
# regsave/ functions no_caller_saved_registers marks, each calling plain functions (-Wexcessive-regsave);
# generic/ functions of many _Generic and __builtin_choose_expr selections, nested (the unselected roots, chosen spans);
# rejected/ failed initializers holding comma expressions (the rejected initializers' commas).
import os, random, sys
D = sys.argv[1]
alpha = 'abcdefghijklmnopqrstuvwxyz'
def name(r, i):
    return ''.join(r.choice(alpha) for _ in range(r.randint(6, 18))) + str(i)
for kind in ('typo', 'regsave', 'generic', 'rejected'):
    os.makedirs(os.path.join(D, kind), exist_ok=True)
for u in range(60):
    r = random.Random(1000 + u)
    names = [name(r, i) for i in range(3000)]
    lines = ['int %s;' % n for n in names] + ['int f(void)', '{', '    int s = 0;']
    for i in range(50):
        n = names[r.randrange(len(names))]
        k = r.randrange(len(n) - 1)
        lines.append('    s += %s;' % (n[:k] + n[k + 1:]))
    lines += ['    return s;', '}']
    open(os.path.join(D, 'typo', 'u%02d.c' % u), 'w').write('\n'.join(lines) + '\n')
    lines = ['void plain%d(int);' % i for i in range(64)]
    for f in range(200):
        lines += ['__attribute__((no_caller_saved_registers)) void handler%d(int x)' % f, '{']
        for c in range(8):
            lines.append('    plain%d(x + %d);' % (r.randrange(64), c))
        lines.append('}')
    open(os.path.join(D, 'regsave', 'u%02d.c' % u), 'w').write('\n'.join(lines) + '\n')
    lines = ['int g%d(int x)' % 0, '{', '    int s = 0;']
    for i in range(2000):
        a = r.choice(['1', '1u', '1.0', "'a'", '(short)1'])
        lines.append('    s += _Generic(%s, int: x + %d, unsigned: __builtin_choose_expr(%d, x, x * 2), double: _Generic(x, int: x - 1, default: 0), default: %d);' % (a, i, i & 1, i))
    lines += ['    return s;', '}']
    open(os.path.join(D, 'generic', 'u%02d.c' % u), 'w').write('\n'.join(lines) + '\n')
    lines = ['struct S { int a; int b; };', 'int f(int x)', '{', '    int s = 0;']
    for i in range(300):
        lines.append('    struct S v%d = { .missing%d = (x, %d), (x + %d, x) };' % (i, i, i, i))
        lines.append('    s += v%d.a;' % i)
    lines += ['    return s;', '}']
    open(os.path.join(D, 'rejected', 'u%02d.c' % u), 'w').write('\n'.join(lines) + '\n')
print('written')
