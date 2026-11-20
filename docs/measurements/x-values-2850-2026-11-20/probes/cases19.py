# cases19.py: the entries' values, a temporary's number: one, two and three postfix updates through an address in an
# expression, by each shape of their destinations' own entries; with calls and with operators that own a label, each
# numbered in its turn.
P = ('struct pair { int first; long second; char third; _Bool flag; }; struct outer { struct pair inner; struct pair* link; int list[4]; };\n'
     'extern int global; extern int table[8]; extern struct outer global_outer; int callee(int a, long b); int one(int a); long wider(long a);\n')
F = P + ('int f(int a, long b, char c, short h, unsigned char u, int* p, struct outer* o, double d, _Bool t, float f, long* lp, char* cp, double* dp, int** pp)\n'
         '{ int local = 0; long wide = 0; int list[4]; struct outer whole; int* q = p; double value = 0;\n  %s\n  return local + (int)wide + list[0] + whole.inner.first + *q + (int)value; }\n')
def S(name, statement): C(name, F % statement)
kept = {'dereference': '(*p)++', 'dereference_down': '(*q)--', 'long': '(*lp)--', 'char': '(*cp)++', 'double': '(*dp)++', 'member': 'o->inner.first++', 'member_offset': 'o->inner.second--',
        'link': 'o->link->first++', 'subscript': 'p[a]++', 'subscript_long': 'lp[b]--', 'subscript_char': 'cp[a]++', 'local_list': 'list[a]--', 'global_table': 'table[a]++',
        'local_member': 'whole.inner.first++', 'global_member': 'global_outer.inner.first--', 'pointed': '(**pp)++', 'pointed_index': 'pp[a][2]--', 'member_list': 'o->list[a]++',
        'cast': '(*(char*)p)++', 'cast_index': '((short*)p)[a]--'}
names = list(kept)
for name, value in kept.items():
    S('kept_one_%s' % name, 'local = %s; wide += local;' % value)
    S('kept_alone_%s' % name, '%s; wide += local;' % value)
    S('kept_wide_%s' % name, 'wide = %s; value = %s; local = a;' % (value, value))
    S('kept_argument_%s' % name, 'local = callee(%s, b); wide = wider(%s);' % (value, value))
    if name != 'double':
        S('kept_index_%s' % name, 'local = list[%s & 3]; p[%s & 1] = a;' % (value, value))
    S('kept_tested_%s' % name, 'if (%s && a) local = 1; if (b || %s) local = 2;' % (value, value))
for i, first in enumerate(names):
    for second in names[i:]:
        a_, b_ = kept[first], kept[second]
        S('kept_two_%s_%s' % (first, second), 'wide = %s + %s; local = a;' % (a_, b_))
        S('kept_two_swapped_%s_%s' % (first, second), 'wide = %s - %s; local = a;' % (b_, a_))
        S('kept_two_call_%s_%s' % (first, second), 'local = callee((int)%s, (long)%s); wide = local;' % (a_, b_))
        S('kept_two_tested_%s_%s' % (first, second), 'if (%s && %s) local = 1; wide = local;' % (a_, b_))
triples = [('dereference', 'long', 'subscript'), ('member', 'member_offset', 'link'), ('local_list', 'global_table', 'local_member'), ('char', 'double', 'pointed'),
           ('subscript', 'subscript', 'subscript'), ('dereference', 'dereference_down', 'cast'), ('global_member', 'member_list', 'cast_index'), ('pointed_index', 'subscript_char', 'subscript_long')]
for x, y, z in triples:
    S('kept_three_%s_%s_%s' % (x, y, z), 'wide = %s + %s + %s; local = a;' % (kept[x], kept[y], kept[z]))
    S('kept_three_call_%s_%s_%s' % (x, y, z), 'local = callee((int)%s, (long)%s) + one((int)%s); wide = local;' % (kept[x], kept[y], kept[z]))
    S('kept_three_nested_%s_%s_%s' % (x, y, z), 'local = callee(one((int)%s), wider((long)%s)) + (int)%s; wide = local;' % (kept[x], kept[y], kept[z]))
    S('kept_three_labels_%s_%s_%s' % (x, y, z), 'if ((%s || %s) && (%s || a)) local = 1; wide = local;' % (kept[x], kept[y], kept[z]))
    S('kept_three_mixed_%s_%s_%s' % (x, y, z), 'if ((%s || callee(a, b)) && ((%s && one(c)) || %s)) local = 1; wide = local;' % (kept[x], kept[y], kept[z]))
mixed = {
    'nested_index': 'local = p[(*q)++]++; wide = local;', 'nested_index_three': 'local = p[list[(*q)++ & 3]++ & 3]++; wide = local;', 'store_kept': 'p[(*q)++ & 3] = (*p)--; wide = local;',
    'update_kept': 'p[(*q)++ & 3] += (*p)--; wide = local;', 'kept_plus_update': 'local = (*p)++ + a++ + (*q)-- + --b; wide = local;', 'kept_in_callee_argument': 'local = one(one((*p)++) + (*q)--); wide = local;',
    'four': 'wide = (*p)++ + (*q)-- + (*lp)++ + o->inner.first--; local = a;', 'five': 'wide = (*p)++ + (*q)-- + (*lp)++ + o->inner.first-- + p[a]++; local = a;',
    'six_calls': 'wide = one((*p)++) + one((*q)--) + wider((*lp)++) + one(o->inner.first--) + one(p[a]++) + one(list[a]--); local = a;',
    'all_three_kinds': 'if (((*p)++ || one(a)) && ((*q)-- || one(c)) && ((*lp)++ || wider(b))) local = 1; wide = local;',
    'all_three_deep': 'if (((*p)++ && (one(a) || ((*q)-- && one(c)))) || ((*lp)++ && (wider(b) || o->inner.first--))) local = 1; wide = local;',
    'do_kept': 'do { local++; } while ((local < 3 && (*p)++) || ((*q)-- && one(a))); wide = local;', 'while_kept': 'while (((*p)++ || (*q)--) && (local < 2 || (*lp)--)) local++; wide = local;',
    'long_far': 'wide = ' + ' + '.join(['a'] * 40) + ' + (*p)++ + (*q)--; local = a;', 'long_both': 'wide = (*p)++ + ' + ' + '.join(['a'] * 40) + ' + (*q)--; local = a;',
    'long_three_kinds': 'if ((' + ' + '.join(['a'] * 34) + ' || (*p)++) && (one(c) || (*q)--)) local = 1; wide = local;',
    'no_room_first': 'whole.inner.second--; local = a;', 'no_room_after': 'local = a; whole.inner.second--; wide = b; global_outer.inner.second++; local = one(a); o->inner.third++;',
    'no_room_between': 'wide = (*p)++ + (*q)--; whole.inner.second--; local = one(a) + one(c); global_outer.inner.second++; if ((a || b) && (c || h)) local = 2;',
}
for name, statement in mixed.items():
    S('kept_mixed_%s' % name, statement)
    S('kept_mixed_%s_twice' % name, statement + ' ' + statement)
