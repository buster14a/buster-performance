# cases9.py: updates, one statement a file (the update's rows' piece): each operator; a destination by name (a local,
# a parameter, a global, a static), through `.`, `->`, a subscript and `*`; a pointer's, a floating one's, a bool's,
# each narrow class's; its value used, discarded and converted; an update below another, in an argument, in an index.
PRE = "struct pair { int first; long second; char third; _Bool flag; short fourth; unsigned char fifth; float sixth; double seventh; int* eighth; };\nstruct outer { struct pair inner; struct pair* link; int list[4]; long longs[4]; };\nextern int g; extern long gl; extern char gc; extern double gd; extern int* gp; extern struct outer go; extern int gt[8]; static int si; int callee(int a, long b);\n"
def U(name, body, params="int a, long b, char c, short h, unsigned char u, int* p, struct outer* o, double d, _Bool t, float f, unsigned n, unsigned long ul, long* lp, char* cp"):
    C(name, PRE + "void f(" + params + ") { int local = 0; long wide = 0; struct outer whole; int list[4]; " + body + " (void)local; (void)wide; (void)whole; (void)list; }\n")
ops = [('add', '+='), ('sub', '-='), ('mul', '*='), ('div', '/='), ('mod', '%='), ('and', '&='), ('or', '|='), ('xor', '^='), ('shl', '<<='), ('shr', '>>=')]
for name, op in ops:
    U('up-local-' + name, "local %s a;" % op)
    U('up-param-' + name, "a %s local;" % op)
    U('up-global-' + name, "g %s a;" % op)
    U('up-member-' + name, "o->inner.second %s b;" % op)
    U('up-deref-' + name, "*p %s a;" % op)
    U('up-subscript-' + name, "p[a] %s 3;" % op)
    U('up-unsigned-' + name, "n %s a;" % op)
    U('up-char-' + name, "c %s a;" % op)
    U('up-constant-' + name, "local %s 4;" % op)
for name, op in ops[:4]:
    U('up-double-' + name, "d %s a;" % op)
    U('up-float-' + name, "f %s d;" % op)
    U('up-int-by-double-' + name, "local %s d;" % op)
for name, form in [('post-inc', '%s++'), ('pre-inc', '++%s'), ('post-dec', '%s--'), ('pre-dec', '--%s')]:
    for dn, dest in [('local', 'local'), ('param', 'a'), ('global', 'g'), ('static', 'si'), ('long', 'b'), ('char', 'c'), ('short', 'h'), ('uchar', 'u'), ('unsigned', 'n'), ('ulong', 'ul'),
                     ('double', 'd'), ('float', 'f'), ('bool', 't'), ('pointer', 'p'), ('char-pointer', 'cp'), ('global-pointer', 'gp'), ('global-char', 'gc'), ('global-double', 'gd'),
                     ('deref', '(*p)'), ('deref-long', '(*lp)'), ('deref-char', '(*cp)'), ('member-near', 'o->inner.first'), ('member-far', 'o->inner.second'), ('member-char', 'o->inner.third'),
                     ('member-short', 'o->inner.fourth'), ('member-float', 'o->inner.sixth'), ('member-double', 'o->inner.seventh'), ('member-pointer', 'o->inner.eighth'), ('member-bool', 'o->inner.flag'),
                     ('link', 'o->link->second'), ('link-near', 'o->link->first'), ('subscript', 'p[a]'), ('subscript-char', 'cp[a]'), ('local-array', 'list[a]'), ('local-array-const', 'list[2]'),
                     ('global-array', 'gt[a]'), ('global-array-const', 'gt[3]'), ('local-struct-near', 'whole.inner.first'), ('local-struct-far', 'whole.inner.second'),
                     ('global-struct-near', 'go.inner.first'), ('global-struct-far', 'go.inner.second'), ('absolute', '(*(int*)32)'), ('member-array', 'o->list[a]'), ('member-longs', 'o->longs[1]')]:
        U('%s-%s' % (name, dn), (form % dest) + ";")
U('value-post-used', "local = a++;")
U('value-pre-used', "local = ++a;")
U('value-post-converted', "wide = a++;")
U('value-compound-used', "wide = local += 2;")
U('value-char-used', "local = (c += 1);")
U('value-char-post-used', "local = c++;")
U('value-double', "d = local++;")
U('value-deref-post', "wide = (*p)++;")
U('value-member-post', "local = o->inner.second--;")
U('value-returned', "local = callee(a++, b--);")
U('value-void', "(void)a++;")
U('value-void-member', "(void)o->inner.second++;")
U('nested-compound', "local += a++;")
U('nested-chain', "wide += local += a;")
U('nested-index', "p[a++] = 1;")
U('nested-index-update', "list[local++ & 3] += 2;")
U('nested-deref-post', "*p++ = a;")
U('nested-deref-pre', "*++p = a;")
U('nested-read-post', "local = *p--;")
U('nested-both', "*p++ += *lp++;")
U('nested-member-index', "o->list[a++]++;")
U('pointer-add', "p += a;")
U('pointer-sub', "p -= a;")
U('pointer-add-long', "p += b;")
U('pointer-add-const', "p += 2;")
U('pointer-char-add', "cp += a;")
U('pointer-member-add', "o->inner.eighth += a;")
U('pointer-member-post', "o->link++;")
U('pointer-deref-post', "(*(int**)lp)++;")
U('bool-or', "t |= a;")
U('bool-and', "t &= t;")
U('bool-post', "t++;")
U('shift-char', "c <<= 2;")
U('shift-long-by-int', "b <<= a;")
U('shift-int-by-long', "a >>= b;")
U('unsigned-char-add', "u += 300;")
U('ulong-add-int', "ul += a;")
U('long-add-unsigned', "b += n;")
U('float-post', "f++;")
U('float-add-int', "f += a;")
U('double-sub-float', "d -= f;")
U('div-constant', "local /= 4;")
U('mod-constant', "local %= 8;")
U('div-unsigned-constant', "n /= 16;")
U('for-increment', "for (local = 0; local < a; local++) wide += local;")
U('while-decrement', "while (a--) wide++;")
U('if-update', "if (a++) local = 1;")
U('conditional-update', "if (a) local++; else local--;")
U('return-like', "wide = local++ + ++a;")
