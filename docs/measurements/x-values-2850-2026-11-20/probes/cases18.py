# cases18.py: the entries' values, a branch's label: every condition of two to four tested values over `&&`, `||` and
# `!`, under each control, with values of several classes; the control's own label and an operator's, numbered.
import itertools
P = ('struct pair { int first; long second; char third; _Bool flag; }; struct outer { struct pair inner; struct pair* link; int list[4]; };\n'
     'extern int global; int callee(int a, long b); int one(int a);\n')
F = P + ('int f(int a, long b, char c, short h, unsigned char u, int* p, struct outer* o, double d, _Bool t, float f, long* lp, unsigned long ul)\n'
         '{ int local = 0; long wide = 0;\n  %s\n  return local + (int)wide; }\n')
def S(name, statement): C(name, F % statement)
leaves = ['a', 'b', 'c', 'h', 'd', 'p', 'u', 't']
def trees(n):
    # Every shape of n leaves under binary operators, each operator `&&` or `||`.
    if n == 1:
        yield None
        return
    for left in range(1, n):
        for l in trees(left):
            for r in trees(n - left):
                for op in ('&&', '||'):
                    yield (op, l, r)
def render(tree, names, negate):
    # `negate` is a set of the inner operators' numbers (preorder) that get a `!`.
    counter = [0]
    def go(t, top):
        if t is None:
            return names.pop(0)
        number = counter[0]; counter[0] += 1
        op, l, r = t
        text = '%s %s %s' % (go(l, False), op, go(r, False))
        if number in negate:
            return '!(%s)' % text
        return text if top else '(%s)' % text
    return go(tree, True)
controls = {'if': 'if (%s) local = 1;', 'while': 'while (%s) { a--; b--; local++; if (local > 3) break; }', 'do': 'do { local++; a++; } while (%s);',
            'for': 'for (local = 0; %s; local++) { wide += local; a = 0; b = 0; c = 0; h = 0; d = 0; p = 0; u = 0; t = 0; }'}
count = 0
for n in (2, 3, 4):
    for index, tree in enumerate(trees(n)):
        inner = n - 1
        # No `!`, a `!` on each inner operator alone, and on all of them.
        negations = [set()] + [{k} for k in range(inner)] + ([set(range(inner))] if inner > 1 else [])
        for which, negate in enumerate(negations):
            text = render(tree, list(leaves[:n]), negate)
            for control, statement in controls.items():
                # Every control for two and three values; the four-valued ones under an if and a do, the two senses.
                if n == 4 and control not in ('if', 'do'): continue
                S('label_%d_%d_%d_%s' % (n, index, which, control), statement % text + ' wide += local;')
                count += 1
# A leaf of each kind under an operator with a label of its own, and beside it.
values = {'int': 'a', 'long': 'b', 'char': 'c', 'short': 'h', 'double': 'd', 'pointer': 'p', 'uchar': 'u', 'bool': 't', 'float': 'f', 'ulong': 'ul', 'member': 'o->inner.second',
          'member_char': 'o->link->third', 'subscript': 'p[a]', 'dereference': '*lp', 'compare': 'a < b', 'equal': 'c == h', 'sum': 'a + c', 'call': 'callee(a, b)',
          'update': 'a++', 'update_long': '--b', 'kept': '(*p)++', 'kept_member': 'o->inner.first--', 'assign': '(local = a)', 'global': 'global', 'negative': '-a', 'not': '~c',
          'cast': '(char)a', 'constant': '5', 'zero': '0', 'truth': '!a'}
shapes = {'first_owned': 'if ((%s || b) && c) local = 1;', 'second_owned': 'if ((b || %s) && c) local = 1;', 'beside_owned': 'if ((b || c) && %s) local = 1;',
          'both_owned': 'if ((%s || b) && (c || %s)) local = 1;', 'deep_owned': 'if ((b && (%s || (c && %s))) || h) local = 1;', 'do_owned': 'do { local++; } while ((local < 3 && %s) || c);',
          'not_owned': 'if (!(%s && b) && !(c && %s)) local = 1;', 'while_owned': 'while ((%s || b) && (local < 2 || %s)) local++;'}
for vname, value in values.items():
    for sname, shape in shapes.items():
        S('labeled_%s_%s' % (sname, vname), shape.replace('%s', value) + ' wide += local;')
