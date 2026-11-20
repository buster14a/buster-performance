# cases21.py: the logical piece's cases (#2850: `&&` and `||` as values, `?:` and a comma on the window): one statement
# each in a function with operands of every class, and the statements whose answer is a neighbour's swept over a
# block's lanes (a statement after 0 to 69 statements of three records each, `local++;`).
PRE = '''struct pair { int first; long second; };
struct bits { int low : 3; int high : 5; };
int callee(int a, long b);
void voided(void);
int quiet(void);
extern int g;
extern char gc;
extern long gl;
extern struct pair gp;
int f(int a, long b, char c, short h, unsigned char u, _Bool t, float x, double d, int* p, struct pair* q, long double ld, unsigned long ul, struct bits* bf)
{
    int local = 0;
    long wide = 0;
    char narrow = 0;
    _Bool flag = 0;
    double real = 0;
    int* ptr = 0;
'''
POST = '''
    return local + (int)wide + narrow + flag + (int)real + (ptr != 0);
}
'''
def S(name, statement, pad=0):
    C(name, PRE + '    local++;\n' * pad + '    ' + statement + POST)
commas = [
    'a++, b++;', 'local = 1, wide = 2;', '(void)(a, b);', 'a, b;', 'local = (a++, b);', 'local = (a, b, c);', 'wide = (a, b);', 'local = (a, c);',
    'if ((a, b)) local = 1;', 'while ((a--, b)) b--;', 'local = (a, (b, c));', '(void)(a, (b, c));', '(a, b), c;', 'a, (b, c);', '(voided(), a);', 'local = (voided(), a);',
    '(a, voided());', '(void)(a, voided());', 'gp = (a, *q);', 'local = (a, *q).first;', 'ptr = (a, p);', 'local = *(a, p);', 'local = (a, p)[1];', '(const void)(a, b);',
    '(volatile void)(a++, b);', 'local = a ? (b, c) : 0;', 'a ? (void)(b, c) : voided();', 'a ? (b++, voided()) : voided();', '(local = 1, a);', '(gp = *q, a);',
    '(q->first = 1, a);', '(flag = a, b);', '(bf->low = 1, a);', '(bf->low++, a);', 'local = (1, 2);', '(void)(1, 2);', 'local = a + (3, 4);',
    'for (a = 0, b = 1; a < 3; a++, b--) local += a;', 'local = (callee(a, b), quiet());', '(void)(callee(a, b), quiet());', 'local = (a, b) + (c, h);',
    'local = (a = 1, b = 2, c);', 'local = ((void)a, b);', 'local = (a, (void)b, c);', 'wide = (a, b) ? 1 : 2;', 'local = (a, b) && c;', 'local = c || (a, b);',
    '(a, b) ? voided() : voided();', 'local = callee((a, b), (c, h));', 'ptr = (a, &local);', 'local = (a, g);', '(void)(a, g);', 'local = (a, 1.5) > x;',
    'real = (a, d);', 'flag = (a, t);', 'local = (t, flag);', 'local = (a, ld) > 1;', '(void)(a, ld);', 'local = sizeof(a, b);',
]
conditionals = [
    'local = a ? b : c;', 'local = a ? 1 : 2;', 'wide = a ? 1 : 2;', 'narrow = a ? 1 : 2;', 'flag = a ? 1 : 0;', 'flag = a ? b : c;', 'real = a ? 1 : 2;', 'wide = a ? c : b;',
    'real = a ? x : d;', 'local = a ? t : u;', 'flag = a ? t : flag;', 'a ? voided() : voided();', 'a ? (void)b : voided();', 'a ? (void)(b++) : (void)c;', '(void)(a ? b : c);',
    'local = c ? a : b;', 'local = t ? a : b;', 'local = u ? a : b;', 'local = p ? *p : 0;', 'local = x ? a : b;', 'local = d ? a : b;', 'local = ld ? a : b;',
    'local = a < b ? c : h;', 'local = !a ? b : c;', 'local = !!a ? b : c;', 'local = (a && b) ? c : h;', 'local = (a || b) ? c : h;', 'local = !(a && b) ? c : h;',
    'local = !!(a || b) ? c : h;', 'local = (a && !b) ? c : h;', 'local = (a, b) ? c : h;', 'local = (a ? b : c) ? h : u;', 'local = 1 ? a : b;', 'local = 0 ? a : b;',
    'local = sizeof(a) == 4 ? a : b;', 'local = g ? a : b;', 'local = &g ? a : b;', 'local = "s" ? a : b;', 'local = q->first ? a : b;', 'local = (a = b) ? c : h;',
    'local = a++ ? b : c;', 'local = a ? b ? 1 : 2 : 3;', 'local = a ? 1 : b ? 2 : 3;', 'local = (a ? b : c) + (h ? u : t);',
    'local = (a ? 1 : 2) + (b ? 3 : 4) + (c ? 5 : 6) + (h ? 7 : 8);', 'local = a ? callee(a, b) : quiet();', 'local = callee(a ? 1 : 2, b);', 'local = callee(a, a ? b : c);',
    'callee(a ? 1 : 2, a ? 3 : 4);', 'ptr = a ? p : 0;', 'ptr = a ? p : ptr;', 'local = *(a ? p : ptr);', 'local = (a ? p : ptr)[2];', 'local = (a ? q : q)->first;',
    'gp = a ? *q : gp;', 'local = (a ? *q : gp).first;', 'local = a ?: b;', 'local = a ?: 3;', 'if (h) return a ? b : c;', 'if (h) return a ? 1 : 2;',
    '{ int z = a ? b : c; local = z; }', '{ char z = a ? 1 : 2; local = z; }', '{ long z = a ? 1 : c; local = (int)z; }', '{ _Bool z = a ? b : c; local = z; }',
    '{ double z = a ? 1 : 2; local = (int)z; }', '{ long z = a ? 1 : 2; local = (int)z; }', '{ int z = a ? 1 : 2; local = z; }', 'if (a ? b : c) local = 1;',
    'while (a ? b-- : c--) local++;', 'do local++; while (a ? b : 0);', 'if (h && (a ? b : c)) local = 1;', 'if ((a ? b : c) || h) local = 1;', 'if (!(a ? b : c)) local = 1;',
    'local = a ? b : (c ? h : u);', 'local = (a ? b : c) ? (h ? 1 : 2) : (u ? 3 : 4);', 'wide = a ? b : 1;', 'wide = a ? 1 : b;', 'narrow = a ? c : 1;', 'narrow = a ? c : c;',
    'local = a ? c : h;', 'ul = a ? u : ul;', 'real = a ? 1 : x;', 'real = a ? d : 1;', 'local = a ? x : d;', 'x = a ? 1 : 2;', 'local = (char)(a ? 1 : 2);',
    'local = (long)(a ? 1 : 2) > b;', 'wide = (a ? 1 : 2) + b;', 'local = (a ? 1 : 2) << c;', 'q->second = a ? 1 : 2;', 'q->first = a ? 1 : 2;', '*p = a ? c : h;',
    'p[a ? 1 : 2] = 3;', 'local = p[a ? b : c];', 'ptr = p + (a ? 1 : 2);', 'local += a ? 1 : 2;', 'wide += a ? 1 : 2;', 'narrow += a ? 1 : 2;', 'wide = -(a ? 1 : 2);',
    'local = ~(a ? b : c);', 'local = !(a ? b : c);', 'local = a ? g : gc;', 'gl = a ? 1 : 2;', 'gc = a ? 1 : 2;', 'local = a ? (b ? callee(a, b) : quiet()) : callee(c, a);',
    'local = a ? b++ : c--;', 'local = a ? (wide = 1) : (narrow = 2);', 'local = (a ? &local : p) != 0;', 'local = a ? bf->low : 1;', 'bf->high = a ? 1 : 2;',
    'local = t ? 1 : 2;', 'flag = t ? flag : t;', 'local = flag ? t : 3;', 'local = a ? 1.5 > x : 2;', 'local = a ? (int)x : (int)d;', 'local = ld > 1 ? a : b;',
    'ld = a ? 1 : 2;', 'ld = a ? ld : 2;', 'local = a ? 1 : 2 ? 3 : 4;', 'local = (a ? callee : callee)(a, b);', 'local = a ? sizeof(a) : sizeof(b);',
]
logicals = [
    'local = a && b;', 'local = a || b;', 'local = c && h;', 'local = a && c;', 'local = c && a;', 'local = t || u;', 'local = a || t;', 'local = x && d;', 'local = p && q;',
    'local = a && !b;', 'local = !a && b;', 'local = !(a && b);', 'local = !!(a || b);', 'local = (a && b) || c;', 'local = a && (b || c);', 'local = a && (b || c) && h;',
    'local = a && b && c && h && u;', 'local = a && (b && (c && (h && u)));', 'wide = a && b;', 'narrow = a || b;', 'flag = a && b;', 'real = a && b;', '(void)(a || b);',
    '(void)(a && callee(a, b));', 'a || callee(a, b);', '(void)(a && quiet());', 'local = (a && b) + (c || h);', 'local = (a && b) * 3;', 'local = -(a && b);', 'local = ~(a || b);',
    'local = callee(a && b, c || h);', 'local = callee(a || b, 1);', 'local = a ? b && c : h || u;', 'if ((a && b) == c) local = 1;', 'if ((a || b) + 1) local = 2;',
    'local = 1 && a;', 'local = 0 || a;', 'local = 0 && a;', 'local = 1 || a;', 'local = a && 1;', 'local = a || 0;', 'if (h) return a && b;', '{ int z = a && b; local = z; }',
    '{ long z = a || b; local = (int)z; }', '{ _Bool z = a && b; local = z; }', '{ char z = a || b; local = z; }', 'if (!(a && b)) local = 1;', 'if (!!(a && b)) local = 1;',
    'if (c || !(a && b)) local = 1;', 'if (!(a && b) || c) local = 1;', 'local = !(a && b) || c;', 'local = c || !(a && b);', 'if (a && !!!(b && c)) local = 1;',
    'if (a && !!(b && c)) local = 1;', 'if (a && !(b && c)) local = 1;', 'if (!!!(b && c) && a) local = 1;', 'local = a && !!!(b && c);', 'local = !!!(b && c) && a;',
    'if (a && (b || (c && (h || u)))) local = 1;', 'if (a && (b || (c && (h || (u && t))))) local = 1;', 'if (a && (b || (c && (h || (u && (t || a)))))) local = 1;',
    'local = a && (b || (c && (h || u)));', 'while (a && (b || c)) a--;', 'do a--; while ((a || b) && !(c && h));', 'for (; a && !(b || c); a--) local++;',
    'local = (a && b) ? 1 : 2;', 'local = (a || b) && (c || h);', 'local = (a && b) || (c && h);', 'local = ((a && b) || c) && h;', 'local = (!a || b) && c;',
    'local = !(!a || b) && c;', 'local = (a < b) && (c > h);', 'local = (a & b) && (c | h);', 'local = ld && a;', 'local = a && ld;', 'local = x || a;', 'local = ptr || p;',
    'local = a && (wide = b);', 'local = (wide = b) || a;', 'local = a++ && b--;', 'local = a && bf->low;', 'local = bf->low && a;', 'local = g && gc;', 'local = gc && g;',
    'local = (a, b) && (c, h);', 'local = a && b ? c : h;', 'local = a ? b : c && h;', 'local = (a ? b : c) && h;', 'local = h && (a ? b : c);', 'local = (a && b) < (c || h);',
    'local = a && sizeof(b);', 'local = sizeof(b) && a;', 'local = a && "s";', 'local = "s" && a;', 'local = &g && a;', 'local = a && &g;', 'local = a && 0;', 'local = a || 1;',
    'if (a && (c ? b : h)) local = 3;', 'if ((c ? b : h) && a) local = 3;', 'if (a || (b && c) || (h && u)) local = 4;', 'if ((a && b && c) || (h && u && t)) local = 5;',
    'local = !a;', 'local = !!a;', 'local = !(a ? b : c);', 'if (!!a) local = 1;', 'if (!a && !b) local = 1;', 'if (!(a || b) && !(c || h)) local = 1;',
]
S('baseline', ';')
plain = [
    'local = a && b;', 'local = a || wide;', 'local = (a && b) || wide;', 'local = a && (b || wide);', 'local = a && (b || wide) && g;', 'local = a && b && wide && g && local;',
    'local = a && (b && (wide && (g && local)));', 'local = (a && b) + (wide || g);', 'local = a ? b && wide : g || local;', 'local = !(a && b) || wide;',
    'local = wide || !(a && b);', 'local = a && !!!(b && wide);', 'local = !!!(b && wide) && a;', 'local = a && (b || (wide && (g || local)));', 'local = (a || b) && (wide || g);',
    'local = (a && b) || (wide && g);', 'local = ((a && b) || wide) && g;', 'local = (!a || b) && wide;', 'local = !(!a || b) && wide;', 'local = (a < b) && (wide > g);',
    'local = a && (wide = b);', 'local = (wide = b) || a;', 'local = a++ && b--;', 'local = a && b ? wide : g;', 'local = a ? b : wide && g;', 'local = (a ? b : wide) && g;',
    'local = g && (a ? b : wide);', 'local = (a && b) < (wide || g);', 'if (a && (wide ? b : g)) local = 3;', 'if ((wide ? b : g) && a) local = 3;',
    'if (a || (b && wide) || (g && local)) local = 4;', 'if ((a && b && wide) || (g && local && a)) local = 5;', 'if (!(a || b) && !(wide || g)) local = 1;',
    'local = (a, b) && (wide, g);', 'local = (a ? b : wide) ? (g ? 1 : 2) : (local ? 3 : 4);', 'local = !(a ? b : wide) && !(g ? a : b);', 'local = (a && b) ? (wide || g) : (local && a);',
    'local = a && (b ? wide : g) && local;', 'local = (a || b) + (wide && g) + (local || a) + (b && wide);', 'if ((a && b) + (wide || g)) local = 6;',
    'local = callee(a && b, 1) + callee(wide || g, 2);', 'local = (a && b) ? callee(a, b) : quiet();', 'local = a && callee(a, b) && quiet();',
    '(void)((a || b) && (wide || callee(a, b)));', 'a || (quiet(), 0);', '(void)(a || (quiet(), 0));', 'local = a ? (b, wide) : (g, local);', 'local = (a ? b : wide, g ? local : a);',
]
for group, statements in (('comma', commas), ('conditional', conditionals), ('logical', logicals), ('plain', plain)):
    for i, statement in enumerate(statements):
        S('%s_%d' % (group, i), statement)
# The statements whose answer is another record's, the next one's or a consumer's far from it, at each lane of a block.
swept = [
    ('edge_not', 'if (a && !(b && c)) local = 1;'),
    ('chain', 'if (a && (b || (c && h))) local = 1;'),
    ('value_chain', 'local = a && !(b || !c);'),
    ('discard', '(void)(a++, b--, c);'),
    ('void_arm', 'a ? (void)(b++, c) : voided();'),
    ('shallow', 'if ((a + b + c + h + u) && !t) local = 1;'),
    ('held', 'local = (a ? c + h + u + c : c) + (t || a);'),
    ('held_far', 'local = (a ? c + h + u + c + local + a + c + h + u + c + local + a + c + h + u + c + local + a + c + h + u + c + local + a : c) + (t || a);'),
    ('comma_far', '(void)(a++, local += c + h + u + c + local + a + c + h + u + c + local + a + c + h + u + c + local + a + c + h + u + c + local + a);'),
]
for name, statement in swept:
    for pad in range(70):
        S('%s_at_%d' % (name, pad), statement, pad)
