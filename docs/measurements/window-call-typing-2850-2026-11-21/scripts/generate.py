from pathlib import Path
dest = Path(__file__).resolve().parent
decls = """
extern int zero(void);
extern int one(int);
extern int mix(unsigned short, void *);
extern void side(int);
extern int variadic(int, ...);
extern _Noreturn void stop(void);
"""
body = """
int fNUM(int x,void *p,int(*indirect)(int)) {
    side(x); side(one(x)); mix(3,p); zero();
    if (one(x) == 3) return zero();
    if (indirect(4)) return one(one(x));
    return mix(x + 1,p);
}
"""
for n in [1,8,64]:
    (dest / ('repeated-%s.c' % n)).write_text(decls + ''.join(body.replace('NUM',str(i)) for i in range(n)))
for name,d,typ,expr in [
    ('zero','int callee(void)','int', 'callee()'),('one','int callee(int)','int','callee(x)'),
    ('two','int callee(unsigned short, void *)','int','callee(x, p)'),
    ('varargs','int callee(int, ...)','int','callee(1, (char)x, p)'),
    ('old','int callee()','int','callee()'),
    ('indirect','int callee(int)','int','indirect(x)'),
    ('nested','int callee(int)','int','callee(callee(x))'),
    ('float','int callee(double)','int','callee((double)x)'),
    ('noreturn','_Noreturn int callee(int)','int','callee(x)'),
    ('attrs','int __attribute__((const)) callee(int)','int','callee(x)'),
    ('target','int __attribute__((target("avx2"))) callee(int)','int','callee(x)')]:
    (dest / (name+'.c')).write_text(d+';\n'+''.join(f'{typ} w{i}(int x, void *p, int (*indirect)(int)) {{ return {expr}; }}\n' for i in range(128)))
