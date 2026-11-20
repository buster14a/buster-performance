# cases13.py: a statement's condition evaluated as branches, one statement at a time: `&&`, `||` and `!` under an if, a
# while, a do and a for; each nested in either operand of each, three deep; a tested value of each class, a pointer's,
# a floating one's, a bool's, a member's, a call's, a comparison's and an update's; conditions C lists; and tested
# values with a conversion of their own, which the rows list.
P = ('struct pair { int first; long second; char third; _Bool flag; }; struct outer { struct pair inner; struct pair* link; int list[4]; };\n'
     'extern int global; extern struct outer global_outer; int callee(int a, long b);\n')
F = P + 'int f(int a, long b, char c, short h, unsigned char u, int* p, struct outer* o, double d, _Bool t, float f, const _Bool cb, const struct outer* co, unsigned long ul) { int local = 0; long wide = 0; %s return local + (int)wide; }\n'
def S(name, statement): C(name, F % statement)
controls = {'if': 'if (%s) local = 1;', 'while': 'while (%s) { a--; b--; }', 'do': 'do { a++; } while (%s);', 'for': 'for (local = 0; %s; local++) wide += local;'}
shapes = {
    'and': 'a && b', 'or': 'a || b', 'not_and': '!a && b', 'and_not': 'a && !b', 'not_or': '!a || b', 'or_not': 'a || !b', 'nots': '!a && !b',
    'and_and': 'a && b && c', 'or_or': 'a || b || c', 'and_or': 'a && b || c', 'or_and': 'a || b && c', 'and_lor': 'a && (b || c)', 'lor_and': '(a || b) && c',
    'lor_land': '(a || b) && (c || h)', 'land_lor': '(a && b) || (c && h)', 'deep_left': '((a && b) || c) && h', 'deep_right': 'a || (b && (c || h))',
    'deep_not': 'a && (b || (c && !h))', 'not_group': '!(a || b) && c', 'group_not': 'a || !(b && c)', 'four': 'a && b && c && h', 'four_or': 'a || b || c || h',
}
for control, text in controls.items():
    for shape, condition in shapes.items():
        S('%s_%s' % (control, shape), text % condition)
values = {
    'char': 'c', 'short': 'h', 'uchar': 'u', 'bool': 't', 'long': 'b', 'ulong': 'ul', 'pointer': 'p', 'double': 'd', 'float': 'f', 'member': 'o->inner.first', 'member_far': 'o->inner.second',
    'member_narrow': 'o->link->third', 'member_bool': 'o->inner.flag', 'global': 'global', 'global_member': 'global_outer.inner.second', 'subscript': 'p[a]', 'dereference': '*p',
    'call': 'callee(a, b)', 'less': 'a < b', 'equal': 'a == local', 'sum': 'a + local', 'negative': '-a', 'complement': '~a', 'cast': '(char)a', 'cast_wide': '(long)a',
    'post': 'a++', 'pre': '--b', 'post_narrow': 'c--', 'pre_narrow': '++h', 'post_pointer': 'p++', 'post_member': 'o->inner.second--', 'post_dereference': '(*p)++',
    'compound': '(c += 2)', 'assign': '(local = a)', 'assign_narrow': '(c = a)', 'address': '&global', 'constant': '1', 'zero': '0', 'sizeof': 'sizeof(a)', 'string': '"x"',
    'const_bool': 'cb', 'const_member_bool': 'co->inner.flag', 'const_member': 'co->inner.first', 'comma': '(a, b)', 'conditional': '(a ? b : c)', 'value_and': '(a && b) + 1',
}
for name, value in values.items():
    S('first_%s' % name, 'if (%s && a) local = 1;' % value)
    S('second_%s' % name, 'if (a || %s) local = 1;' % value)
    S('negated_%s' % name, 'if (a && !%s) local = 1;' % value)
    S('do_%s' % name, 'do { local++; } while (local < 3 && %s);' % value)
# What C lists, or takes as a value: a `!` over a `!`, a condition over a `!` over an operator, an operator that is a value.
S('not_not', 'if (!!a && b) local = 1;')
S('condition_not_and', 'if (!(a && b)) local = 1;')
S('condition_not_or', 'if (!(a || b)) local = 1;')
S('value_and', 'local = a && b;')
S('value_or_in_condition', 'if ((a || b) == c) local = 1;')
S('argument_and', 'local = callee(a && b, b);')
S('folded_and', 'if (1 && a) local = 1;')
S('folded_or', 'if (0 || a) local = 1;')
S('folded_dead', 'if (0 && a) local = 1;')
S('plain_if', 'if (a) local = 1;')
S('plain_not', 'if (!a) local = 1;')
S('plain_do', 'do { a++; } while (a < 4);')
S('switch_and', 'switch (a && b) { case 1: local = 1; break; default: break; }')
S('return_and', 'if (a) return a && b;')
