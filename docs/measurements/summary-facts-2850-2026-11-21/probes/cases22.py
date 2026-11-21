# cases22.py: a summary node's side facts' cases (#2850): one statement each in a function, a reference of each kind
# in each place, a call of each form in each place, and conditions whose truth an operand may decide; and the
# statements whose answer is a neighbour's (a call's callee's, a count before a record's) swept over a block's lanes
# (a statement after 0 to 69 statements of three records each, `local++;`).
PRE = '''struct pair { int first; long second; int (*call)(int); int list[4]; struct pair* next; };
enum color { RED, GREEN = 5 };
extern int g;
extern long gl;
extern char gc;
static int sg;
int tentative;
int ga[8];
static int sa[4];
extern int ea[];
struct pair gp;
static struct pair sp;
extern struct pair* gq;
extern const char* names[4];
extern _Thread_local int tls;
int callee(int a, long b);
int one(int a);
void voided(void);
static int own(int a) { return a + sg; }
void stop(void) __attribute__((noreturn));
_Noreturn void quit(int code);
void exit(int code);
void abort(void);
void _Exit(int code);
void longjmp(void* buffer, int value);
int old();
extern int (*gf)(int);
static int (*sf)(int);
extern int (*table[4])(int);
typedef int function(int);
extern function typed;
int f(int a, long b, char c, int* p, struct pair* q, int (*fp)(int), int (**fpp)(int), void* buffer)
{
    static int counter;
    static const char text[] = "text";
    int local = 0;
    long wide = 0;
    int* ptr = 0;
    const char* string = 0;
    int (*lf)(int) = 0;
'''
POST = '''
    return local + (int)wide + (ptr != 0) + (string != 0) + (lf != 0) + counter + text[0];
}
'''
def S(name, statement, pad=0):
    C(name, PRE + '    local++;\n' * pad + '    ' + statement + POST)
references = [
    'local = g;', 'local = g + g;', 'local = g + sg;', 'local = sg + tentative + g;', 'g = a;', 'sg = a;', 'tentative = a;', 'g += a;', 'sg++;', '--g;', 'local = g++;',
    'local = -g;', 'local = !g;', 'local = ~sg;', 'wide = gl;', 'wide = gl + g;', 'local = gc;', 'gc = (char)a;', 'ptr = &g;', 'ptr = &sg;', 'local = *&g;', 'ptr = &*&g;',
    'local = ga[a];', 'local = ga[1];', 'local = ga[0] + ga[7];', 'ga[a] = b;', 'ga[2] = 3;', 'ptr = ga;', 'ptr = &ga[a];', 'ptr = &ga[3];', 'ptr = ga + a;', 'ptr = ga + 1;',
    'local = *ga;', 'local = *(ga + a);', 'local = a[ga];', 'local = sa[a];', 'sa[1] = a;', 'ptr = sa;', 'local = ea[a];', 'ptr = ea;', 'local = ga[sa[a]];', 'local = ga[g];',
    'local = gp.first;', 'wide = gp.second;', 'gp.first = a;', 'local = gp.list[a];', 'local = gp.list[1];', 'ptr = gp.list;', 'ptr = &gp.first;', 'q = &gp;', 'q = gp.next;',
    'local = gp.next->first;', 'local = sp.first + gp.first;', 'sp.second = b;', 'q = &sp;', 'local = gq->first;', 'gq->first = a;', 'q = gq;', 'gq = q;', 'local = gq->list[a];',
    'local = q->first + g;', 'q->first = g;', 'q->list[g] = sg;', 'local = p[g];', 'p[a] = g;', '*p = sg;', 'local = *p + g;',
    'local = counter;', 'counter = a;', 'counter++;', 'ptr = &counter;', 'local = text[a];', 'local = text[1];', 'string = text;', 'local = *text;',
    'string = "abc";', 'local = "abc"[a];', 'local = "abc"[1];', 'local = *"abc";', 'string = "abc" + 1;', 'string = "abc" + a;', 'string = &"abc"[a];', 'local = "a" == "b";',
    'local = "a"[a] + "b"[a];', 'string = a ? "yes" : "no";', 'local = (a ? "yes" : "no")[1];', 'string = names[a];', 'string = names[1];', 'local = names[a][a];',
    'local = *names[a];', 'local = names[a] != 0;', 'local = names[a] == string;', 'local = callee(a, b);', 'local = one(a);', 'local = one(g);', 'local = one(g) + one(sg);',
    'local = callee(g, gl);', 'local = own(a);', 'local = own(g);', 'voided();', 'local = typed(a);', 'local = one(one(a));', 'local = callee(one(a), one(b));',
    'lf = one;', 'lf = &one;', 'lf = own;', 'lf = typed;', 'gf = one;', 'sf = own;', 'lf = gf;', 'lf = sf;', 'lf = a ? one : own;', 'local = one == own;', 'local = lf == one;',
    'local = gf == one;', 'local = gf(a);', 'local = sf(a);', 'local = table[a](b);', 'local = table[1](b);', 'lf = table[a];', 'table[a] = one;', 'local = (*gf)(a);',
    'local = RED + a;', 'local = GREEN;', 'local = a == GREEN;', 'local = a;', 'local = a + b;', 'local = local;', 'ptr = p;', 'ptr = &local;', 'q = q->next;',
    'local = tls;', 'tls = a;', 'ptr = &tls;', 'local = a ? g : sg;', 'local = a ? g : 1;', 'local = a && g;', 'local = g || sg;', 'local = (a, g);', 'local = (g, a);',
    'if (g) local = 1;', 'if (g && sg) local = 1;', 'if (!g) local = sg;', 'while (g) g--;', 'do local++; while (sg);', 'for (g = 0; g < sg; g++) local += ga[g];',
    'switch (g) { case 1: local = sg; }', 'if (ga[a]) local = gp.first;', 'if (callee(g, b)) local = 1;', 'if (names[a]) local = 1;', 'if ("abc"[a]) local = 1;',
    'local = (int)g;', 'wide = (long)g;', 'local = (char)sg;', 'ptr = (int*)ga;', 'ptr = (int*)&gp;', 'wide = (long)&g;', 'local = (int)(long)&g;', 'string = (const char*)ga;',
    'local = sizeof(g);', 'local = sizeof(ga) / sizeof(ga[0]);', 'local = _Alignof(struct pair);', 'local = g + (int)sizeof(sg);',
]
calls = [
    'local = one(a);', 'local = (one)(a);', 'local = (*one)(a);', 'local = (**one)(a);', 'local = (&one)(a);', 'local = (*&one)(a);', 'local = own(a);', 'local = typed(a);',
    'local = fp(a);', 'local = (fp)(a);', 'local = (*fp)(a);', 'local = (**fp)(a);', 'local = lf(a);', 'local = gf(a);', 'local = sf(a);', 'local = (*gf)(a);',
    'local = (*fpp)(a);', 'local = (**fpp)(a);', 'local = fpp[a](b);', 'local = table[a](b);', 'local = (*table[a])(b);', 'local = q->call(a);', 'local = (*q->call)(a);',
    'local = gp.call(a);', 'local = sp.call(a);', 'local = gq->call(a);', 'local = q->next->call(a);', 'local = (a ? one : own)(b);', 'local = (a ? fp : one)(b);',
    'local = (a, one)(b);', 'local = (a, fp)(b);', 'local = ((int (*)(int))one)(a);', 'local = ((int (*)(int))fp)(a);', 'local = ((function*)one)(a);', 'local = old();',
    'local = old(a);', 'local = old(a, b);', 'local = one(fp(a));', 'local = fp(one(a));', 'local = fp(fp(a));', 'local = callee(fp(a), b);', 'local = callee(a, fp(a));',
    'local = one(a) + fp(a);', 'local = fp(a) + one(a);', 'local = a ? one(a) : fp(a);', 'local = a ? fp(a) : one(a);', 'local = a && fp(a);', 'local = fp(a) && a;',
    'local = a || fp(a);', 'local = fp(a) || a;', 'local = (fp(a), a);', 'local = (a, fp(a));', 'local = !fp(a);', 'local = -fp(a);', 'local = (int)fp(a);',
    'local = p[fp(a)];', 'p[fp(a)] = a;', 'q->first = fp(a);', 'local += fp(a);', 'if (fp(a)) local = 1;', 'while (fp(a)) a--;', 'if (a && fp(a)) local = 1;',
    'if (one(a)) local = 1;', 'if (a && one(a)) local = 1;', 'fp(a);', '(void)fp(a);', 'one(a);', '(void)one(a);', 'voided();', 'lf = a ? one : fp; local = lf(a);',
]
stops = [
    'stop();', 'quit(1);', 'quit(a);', '(void)stop();', 'if (a) stop();', 'if (a) quit(2);', 'if (a) { stop(); }', 'local = (stop(), a);', 'local = (a, stop(), b);',
    '(a, stop());', '(stop(), a);', 'local = a ? (stop(), a) : 2;', 'local = a ? 2 : (stop(), a);', 'local = a ? (stop(), a) : (quit(1), c);', 'local = a ? (stop(), a) : (stop(), a);',
    'local = (stop(), a) ? 1 : 2;', 'local = (stop(), a) ? b : c;', 'a ? stop() : voided();', 'a ? voided() : stop();', 'a ? stop() : stop();', 'a ? stop() : quit(1);',
    'local = a && (stop(), b);', 'local = (stop(), a) && b;', 'local = a || (stop(), b);', 'local = (stop(), a) || b;', 'local = (a && (stop(), b)) || c;',
    'local = (stop(), a) && (quit(1), b);', 'local = one((stop(), a));', 'local = callee((stop(), a), b);', 'local = callee(a, (stop(), b));', 'local = callee((stop(), a), (quit(1), b));',
    'local = one(a ? (stop(), a) : 2);', 'local = one(a ? (stop(), a) : (quit(1), c));', 'local = fp((stop(), a));', 'local = (a ? (stop(), a) : 2) + fp(a);',
    'local = (a ? (stop(), a) : (stop(), c)) + fp(a);', 'local = a ? (stop(), a) : fp(a);', 'local = a ? fp(a) : (stop(), a);', 'local = (stop(), fp(a));',
    'local = (fp(a), stop(), a);', 'local = one(a) + (stop(), a);', 'local = (stop(), a) + (quit(1), b);', 'local = -(stop(), a);', 'local = !(stop(), a);',
    'p[(stop(), a)] = b;', 'q->first = (stop(), a);', 'local += (stop(), a);', 'if ((stop(), a)) local = 1;', 'while ((stop(), a)) a--;', 'if (a && (stop(), b)) local = 1;',
    'if ((stop(), a) && b) local = 1;', 'if (a || (quit(1), b)) local = 1;', 'if (!(stop(), a)) local = 1;', 'if (a ? (stop(), b) : c) local = 1;',
    'if (a ? (stop(), b) : (quit(1), c)) local = 1;', 'local = a ? (b ? (stop(), a) : (quit(1), c)) : (stop(), b);', 'local = a ? (b ? (stop(), a) : 2) : (stop(), b);',
    'local = (a ? (stop(), b) : (stop(), c)) ? 1 : 2;', 'local = a && b && (stop(), c);', 'local = (stop(), a) && b && c;', 'local = a || b || (stop(), c);',
    'exit(1);', 'abort();', '_Exit(2);', 'longjmp(buffer, 1);', 'if (a) exit(a);', 'if (a) abort();', 'local = (exit(1), a);', 'local = a ? (abort(), a) : 2;',
    'local = (abort(), a) + (stop(), b);', 'local = one((exit(1), a));', '(*stop)();', '(&stop)();', '(stop)();', 'lf = (int (*)(int))stop; local = lf(a);',
]
truths = [
    'if (a && 0) local = 1;', 'if (a || 1) local = 1;', 'if (a && 1) local = 1;', 'if (a || 0) local = 1;', 'if (0 && a) local = 1;', 'if (1 || a) local = 1;',
    'if (1 && a) local = 1;', 'if (0 || a) local = 1;', 'if (!(a && 0)) local = 1;', 'if (!(a || 1)) local = 1;', 'if (!!(a && 0)) local = 1;', 'if ((a && 0) || b) local = 1;',
    'if ((a || 1) && b) local = 1;', 'if (b && (a || 1)) local = 1;', 'if (b || (a && 0)) local = 1;', 'if (a && b && 0) local = 1;', 'if (a || b || 1) local = 1;',
    'if (a && (b, 0)) local = 1;', 'if (a && !1) local = 1;', 'if (a || !0) local = 1;', 'if (a && (int)0) local = 1;', 'if (a && 0L) local = 1;', 'if (a && 0.0) local = 1;',
    'if (a || 1.5) local = 1;', 'if (a && (void*)0) local = 1;', 'if (a || &g) local = 1;', 'if (a || ga) local = 1;', 'if (a || "s") local = 1;', 'if (a || one) local = 1;',
    'if (a && RED) local = 1;', 'if (a || GREEN) local = 1;', 'if (a && sizeof(a)) local = 1;', 'if (a && g) local = 1;', 'if (a || sg) local = 1;',
    'while (a && 0) a--;', 'while (a || 1) { if (b) break; b++; }', 'do local++; while (a && 0);', 'do local++; while (a || 1 ? b-- : 0);', 'for (; a && 0;) local++;',
    'for (; a || 1;) { if (b) break; b++; }', 'local = a && 0;', 'local = a || 1;', 'local = a && 1;', 'local = a || 0;', 'local = (a && 0) + b;', 'local = one(a || 1);',
    'local = a ? (b && 0) : c;', 'local = (a && 0) ? b : c;', 'local = !(a || 1);', 'wide = a && 0;', 'if (1) local = 1;', 'if (0) local = 1;', 'while (0) local++;',
    'do local++; while (0);', 'for (;;) { if (a) break; a++; }', 'while (1) { if (a) break; a++; }', 'if (!0) local = 1;', 'if (!1) local = 1;', 'if (2 > 1) local = 1;',
    'if (sizeof(a) == 4) local = 1;', 'if (RED) local = 1;', 'if (GREEN) local = 1;', 'if ((a, 1)) local = 1;', 'if ((a, 0)) local = 1;', 'if ((1, a)) local = 1;',
    'if ((0, 1)) local = 1;', 'if ((g, 1)) local = 1;', 'if ((one(a), 1)) local = 1;', 'while ((a, 0)) local++;', 'if (&g) local = 1;', 'if (ga) local = 1;',
    'if ("s") local = 1;', 'if (one) local = 1;', 'if (!&g) local = 1;', 'if (&g && a) local = 1;', 'if (a && &g) local = 1;', 'if (a == a) local = 1;',
    'switch (a) { case 1: local = 2; }', 'switch (a + g) { case 1: local = 2; default: local = 3; }', 'switch (1) { case 1: local = 2; }', 'switch (a && 0) { case 0: local = 2; }',
    'switch ((enum color)a) { case RED: local = 1; break; case GREEN: local = 2; }', 'switch (c) { case 1: local = 2; }', 'switch (one(a)) { case 1: local = 2; }',
    'switch (fp(a)) { case 1: local = 2; }', 'switch ((stop(), a)) { case 1: local = 2; }',
]
for group, statements in (('reference', references), ('call', calls), ('stop', stops), ('truth', truths)):
    for i, statement in enumerate(statements):
        S('%s-%d' % (group, i), statement)
# A neighbour's answer at each lane of a block: a call with its callee and a reference before it, a call through a
# pointer, a call that stops, and a statement of two expressions whose references are counted from one to the next.
swept = [('lane-plain', 'local = one(g) + sg;'), ('lane-pointer', 'local = fp(g) + sg;'), ('lane-stop', 'if (a) stop();'), ('lane-both', 'local = a ? (stop(), g) : fp(sg);'),
         ('lane-two', 'if (g) local = sg + ga[a];'), ('lane-string', 'local = "abc"[a] + text[a];'), ('lane-far', 'local = callee(a + a + a + a + a + a + a + a + a + a + a + a + a + a + a + a + a + a + a + a + a + a + a + a + a + a + a + a + a + a + a + a + a + a + a + a + a + a + a + a + a + a + a + a + a + a + a + a + a + a + a + a + a + a + a + a + a + a + a + a + a + a + a + a + a + a + a + a + a + a + a + a + a + a + a + a + a + a + a + a + a + a + a + a + a + a + a + a + a + a + a + a + a + a + a + a + a + a + a + a + a + a + a + a + a + a + a + a + a + a + a + a + a + a + a + a + a + a + a + a + a + a + a + a + a + a + a + a + a + a + a + a + a + a + a + a + a + a + a + a, gl) + g;')]
for name, statement in swept:
    for pad in range(0, 70) if name != 'lane-far' else range(0, 24):
        S('%s-%d' % (name, pad), statement, pad)
