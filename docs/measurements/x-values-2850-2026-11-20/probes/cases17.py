# cases17.py: the entries' values, a call's row: calls nested in arguments and in a callee, side by side, in conditions,
# with updates and with calls that are not evaluated.
P = ('struct pair { int first; long second; char third; _Bool flag; }; struct outer { struct pair inner; struct pair* link; int list[4]; };\n'
     'extern int global; extern int table[8];\n'
     'int callee(int a, long b); long wider(long a); int one(int a); int none(void); void nothing(int a); double real(double d, float f); int three(int a, int b, int c);\n'
     'int (*picker(int which))(int, long); int (*(*chooser(int a))(int))(int, long); int variadic(int count, ...);\n')
F = P + ('int f(int a, long b, char c, short h, unsigned char u, int* p, struct outer* o, double d, _Bool t, float f, long* lp, int (*fp)(int, long), int (**fpp)(int, long))\n'
         '{ int local = 0; long wide = 0; double value = 0; int list[4]; int* q = p;\n'
         '  %s\n  return local + (int)wide + (int)value + list[0] + *q; }\n')
def S(name, statement): C(name, F % statement)
calls = {
    'plain': 'callee(a, b);', 'value': 'local = callee(a, b);', 'none': 'local = none();', 'nothing': 'nothing(a);', 'real': 'value = real(d, f);',
    'nested_first': 'local = callee(callee(a, b), b);', 'nested_second': 'local = callee(a, wider(b));', 'nested_both': 'local = callee(callee(a, b), wider(b));',
    'nested_three': 'local = three(one(a), one(c), one(h));', 'nested_three_deep': 'local = three(one(one(a)), one(one(c)), one(one(h)));',
    'side': 'local = callee(a, b) + callee(c, a);', 'side_three': 'local = callee(a, b) + callee(c, a) + callee(h, b);', 'side_four': 'local = one(a) + one(c) + one(h) + one(u);',
    'side_tree': 'local = (one(a) + one(c)) * (one(h) + one(u));', 'side_nested': 'local = one(one(a)) + one(one(c));', 'side_nested_three': 'local = one(one(one(a))) - one(one(c)) + one(h);',
    'deep3': 'local = one(one(one(a)));', 'deep6': 'local = one(one(one(one(one(one(a))))));', 'deep_mixed': 'wide = wider(wider(wider(b)) + wider(a));',
    'tree': 'wide = wider(callee(a, wider(b)) + callee(callee(c, a), wider(wider(b))));', 'ten': 'local = ' + ' + '.join('one(%s)' % v for v in 'a c h u a c h u a c'.split()) + ';',
    'callee_call': 'local = picker(a)(a, b);', 'callee_call_arguments': 'local = picker(a)(callee(a, b), b);', 'callee_call_all': 'local = picker(callee(a, b))(callee(c, a), wider(b));',
    'callee_chain': 'local = chooser(a)(c)(h, b);', 'callee_chain_arguments': 'local = chooser(one(a))(one(c))(one(h), wider(b));',
    'pointer': 'local = fp(a, b);', 'pointer_star': 'local = (*fp)(a, b);', 'pointer_nested': 'local = fp(fp(a, b), b);', 'pointer_pointed': 'local = (*fpp)(a, b) + (**fpp)(c, b);',
    'pointer_indexed': 'local = fpp[a](c, b) + fpp[1](a, b);', 'pointer_argument': 'local = fp(callee(a, b), wider(b)) + callee(fp(c, b), b);',
    'index': 'p[callee(a, b)] = callee(c, a);', 'index_both': 'local = p[one(a)] + list[one(c) & 3];', 'store_call': '*p = one(a); o->inner.first = one(c);',
    'update_call': 'local += callee(a, b) + callee(c, a);', 'update_call_address': 'p[one(a)] += one(c);', 'update_argument': 'local = callee(a++, b--);',
    'update_arguments': 'local = callee(a++, wider(b--)) + one(--c);', 'kept_argument': 'local = callee((*p)++, (*lp)--);', 'kept_arguments_nested': 'local = callee(one((*p)++), wider((*lp)--));',
    'member_call': 'local = o->list[one(a) & 3] + callee(o->inner.first, o->inner.second);', 'converted': 'value = callee(c, h); wide = one(u); local = (int)wider(a);',
    'compare': 'local = one(a) < one(c); local = one(a) == one(one(h));', 'negate': 'local = -one(a) + ~one(c) + !one(h);', 'cast': 'wide = (long)one(a) + (char)one(c);',
    'discard': '(void)callee(a, b); (void)one(one(a));', 'not_evaluated': 'local = (int)sizeof(callee(a, b)) + callee(c, a);',
    'not_evaluated_nested': 'local = (int)sizeof(callee(callee(a, b), b)) + (int)sizeof(wider(b));', 'not_evaluated_argument': 'local = callee(a, (long)sizeof(wider(b))) + callee(c, (long)sizeof(callee(a, b)));',
    'not_evaluated_alone': 'local = (int)sizeof(one(one(a)));', 'alignof_call': 'local = (int)_Alignof(int) + one(a) + (int)sizeof(one(c));',
    'variadic': 'local = variadic(2, a, b);', 'variadic_nested': 'local = variadic(3, one(a), wider(b), one(c)) + one(h);', 'builtin': 'value = __builtin_fabs(real(d, f)) + real(real(d, f), f);',
    'condition': 'if (callee(a, b)) local = 1;', 'condition_nested': 'if (one(one(a))) local = 1;', 'while_call': 'while (one(a) < one(c)) a++;', 'for_call': 'for (local = one(a); local < one(c); local += one(h)) wide++;',
    'return_call': 'if (a) return callee(one(a), wider(b)); local = a;', 'return_side': 'if (a) return one(a) + one(c); local = a;',
    'and_calls': 'if (callee(a, b) && callee(c, a)) local = 1;', 'or_calls': 'if (one(a) || one(c)) local = 1;', 'and_three': 'if (one(a) && one(c) && one(h)) local = 1;',
    'or_and': 'if (callee(a, b) || (callee(c, a) && wider(b))) local = 2;', 'and_or': 'if ((one(a) || one(c)) && (one(h) || one(u))) local = 3;',
    'and_nested': 'if (callee(callee(a, b), b) && a) local = 4;', 'and_nested_both': 'if (one(one(a)) && one(one(c))) local = 5;', 'not_calls': 'if (!one(a) && !one(one(c))) local = 6;',
    'label_call': 'if ((a || callee(a, b)) && c) local = 7;', 'label_calls': 'if ((one(a) || b) && (c || one(h))) local = 8;', 'do_calls': 'do { a++; } while (one(a) < 9 && one(c));',
    'while_calls': 'while (one(a) && (one(c) || one(h))) a--;', 'for_calls': 'for (local = 0; one(local) < 3 && one(a); local++) wide += local;',
    'compare_calls': 'if (one(a) < one(c) && one(h) > one(u)) local = 9;', 'kept_calls': 'if ((*p)++ && callee((*q)--, b)) local = 10;',
    'long_far': 'local = ' + ' + '.join(['a'] * 40) + ' + callee(a, b) + callee(c, a);', 'long_near': 'local = callee(a, b) + callee(c, a) + ' + ' + '.join(['a'] * 40) + ';',
    'long_both': 'local = callee(a, b) + ' + ' + '.join(['a'] * 40) + ' + callee(c, a);', 'long_one': 'local = ' + ' + '.join(['a'] * 40) + ' + callee(c, a);',
    'long_three': 'local = one(a) + ' + ' + '.join(['a'] * 35) + ' + one(c) + ' + ' + '.join(['a'] * 35) + ' + one(h);', 'long_nested': 'local = ' + ' + '.join(['a'] * 70) + ' + one(one(one(a)));',
    'long_arguments': 'local = three(' + ' + '.join(['a'] * 30) + ', one(c), ' + ' + '.join(['a'] * 30) + ' + one(h));',
}
for name, statement in calls.items():
    S('call_%s' % name, '%s wide += local;' % statement)
    S('call_%s_twice' % name, '%s %s' % (statement, statement))
    S('call_%s_after' % name, 'wide = one(a) + one(c); %s wide += one(h) + one(u);' % statement)
