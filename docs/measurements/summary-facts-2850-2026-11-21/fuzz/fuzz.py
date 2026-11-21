#!/usr/bin/env python3
# fuzz.py COMPILER SEED COUNT OUT [OPTIONS...]: random one-statement programs through the shadow
# (measure-node-machine --shadow --window-rows --passes 0), whose own comparisons are the oracle: a program whose run
# reports a comparison that is not zero is written to OUT/NAME.c with its signature (the report's lines and keys that
# are not zero) in OUT/found.txt. A program the compiler rejects (no report) is counted and dropped. The expressions
# are typed loosely (an integer's, a pointer's, a floating one's) and weighted toward constants, addresses and casts,
# where a fold may leave a record whose fields say two things.
import os, random, re, subprocess, sys
compiler, seed, count, out = sys.argv[1], int(sys.argv[2]), int(sys.argv[3]), sys.argv[4]
options = sys.argv[5:]
os.makedirs(out, exist_ok=True)
rng = random.Random(seed)
PRE = '''struct pair { int first; long second; int (*call)(int); int list[4]; struct pair* next; char tag; unsigned bits : 3; };
enum color { RED, GREEN = 5, BLUE = 70000 };
typedef __SIZE_TYPE__ size_t;
extern int g;
static int sg;
extern long gl;
extern unsigned gu;
extern char gc;
extern short gh;
extern double gd;
extern float gflt;
int ga[8];
static char sc[16];
struct pair gp;
static struct pair sp;
extern struct pair* gq;
extern const char* names[4];
extern int weak_one __attribute__((weak));
int one(int a);
int callee(int a, long b);
long wide(long a);
double real(double a);
void voided(void);
void stop(void) __attribute__((noreturn));
extern int (*gf)(int);
int f(int a, long b, char c, int* p, struct pair* q, int (*fp)(int), double d, unsigned u, short h, char* s)
{
    static int counter;
    int local = 0;
    long along = 0;
    double dl = 0;
    int* ptr = 0;
    char* text = 0;
    unsigned char uc = 0;
'''
POST = '''
    return local + (int)along + (int)dl + (ptr != 0) + (text != 0) + counter + uc;
}
'''
def pick(items): return rng.choice(items)
INT_CONSTANTS = ['0', '1', '2', '3', '-1', '7', '8', '255', '256', '65535', '65536', '0x7fffffff', '0x80000000u', '1L', '0L', '1u', '0u', '4096', "'a'", "'\\0'", 'RED', 'GREEN', 'BLUE',
                 '(char)1', '(char)256', '0x100000000', '-2147483647 - 1', '1ull << 40', '100000']
INT_LEAVES = ['a', 'b', 'c', 'u', 'h', 'local', 'along', 'uc', 'g', 'sg', 'gl', 'gu', 'gc', 'gh', 'counter', 'ga[1]', 'ga[a & 7]', 'gp.first', 'gp.second', 'gp.tag', 'sp.first', 'q->first',
              'q->second', 'q->list[2]', 'gq->first', '*p', 'p[1]', 'p[a]', 'sc[3]', '*s', 's[a]', 'gp.list[a & 3]', 'q->next->first', 'weak_one']
PTR_LEAVES = ['p', 'ptr', '&g', '&sg', 'ga', '&ga[2]', '&ga[a & 7]', '&gp.first', '&local', 'q->list', 'gp.list', '(int*)0', '&counter', '&weak_one', '&*p', 'ga + 1', '&q->first', '&sp.first',
              '(int*)ga', '&p[2]', '(int*)(void*)0']
CHAR_PTRS = ['s', 'text', 'sc', '"abc"', '"x"', '&sc[2]', 'names[1]', 'names[a & 3]', '(char*)ga', '(char*)&g', '&gp.tag', '(char*)0', '"abc" + 1', 'sc + 4']
STRUCT_PTRS = ['q', 'gq', '&gp', '&sp', 'q->next', 'gp.next', '(struct pair*)0', '&*q']
DBL_LEAVES = ['d', 'dl', 'gd', 'gflt', '1.5', '0.0', '2.0f', '-0.0', '1e30', '0.5', '(double)a', '(float)b', '1e-3', '3.0']
FNS = ['one', 'fp', 'gf', 'q->call', 'gp.call', '&one', '*one', '*fp']
INT_TYPES = ['char', 'short', 'int', 'long', 'unsigned', 'unsigned char', 'unsigned short', 'unsigned long', '_Bool', 'signed char', 'long long', 'size_t', 'enum color']
BIN = ['+', '-', '*', '/', '%', '<<', '>>', '&', '|', '^', '<', '<=', '>', '>=', '==', '!=']
SLOPPY = float(os.environ.get('FUZZ_SLOPPY', '0'))
def integer(depth):
    if SLOPPY and rng.random() < SLOPPY:
        return other(depth, 'integer')
    return integer_own(depth)
def pointer(depth):
    if SLOPPY and rng.random() < SLOPPY:
        return other(depth, 'pointer')
    return pointer_own(depth)
def floating(depth):
    if SLOPPY and rng.random() < SLOPPY:
        return other(depth, 'floating')
    return floating_own(depth)
def other(depth, kind):
    r = rng.random()
    if r < 0.30 and kind != 'integer': return integer_own(depth)
    if r < 0.55 and kind != 'pointer': return pointer_own(depth)
    if r < 0.70 and kind != 'floating': return floating_own(depth)
    if r < 0.80: return pick(CHAR_PTRS)
    if r < 0.88: return pick(STRUCT_PTRS)
    if r < 0.94: return pick(FNS)
    return pick(['gp', '*q', 'ga', 'sc', 'voided()', 'stop()', 'names', 'gp.list', '(void)a'])
def integer_own(depth):
    if depth <= 0 or rng.random() < 0.18:
        r = rng.random()
        return pick(INT_CONSTANTS) if r < 0.4 else pick(INT_LEAVES)
    r = rng.random()
    if r < 0.20: return '(%s %s %s)' % (integer(depth - 1), pick(BIN), integer(depth - 1))
    if r < 0.28: return '%s%s' % (pick(['-', '~', '!', '+', '!!']), integer(depth - 1))
    if r < 0.40: return '(%s)%s' % (pick(INT_TYPES), integer(depth - 1))
    if r < 0.47: return '(%s)(long)%s' % (pick(INT_TYPES), pointer(depth - 1))
    if r < 0.51: return '(long)%s' % pointer(depth - 1)
    if r < 0.55: return '(%s)%s' % (pick(INT_TYPES), floating(depth - 1))
    if r < 0.61: return '(%s %s %s)' % (integer(depth - 1), pick(['&&', '||']), integer(depth - 1))
    if r < 0.65: return '(%s %s %s)' % (anything(depth - 1), pick(['&&', '||']), anything(depth - 1))
    if r < 0.70: return '(%s ? %s : %s)' % (anything(depth - 1), integer(depth - 1), integer(depth - 1))
    if r < 0.73: return '(%s, %s)' % (anything(depth - 1), integer(depth - 1))
    if r < 0.77: return '(%s %s %s)' % (pointer(depth - 1), pick(['==', '!=', '<', '>=']), pointer(depth - 1))
    if r < 0.79: return '(%s - %s)' % (pointer(depth - 1), pointer(depth - 1))
    if r < 0.82: return '!%s' % pointer(depth - 1)
    if r < 0.84: return '(%s %s %s)' % (floating(depth - 1), pick(['<', '>', '==', '!=', '<=']), floating(depth - 1))
    if r < 0.86: return '!%s' % floating(depth - 1)
    if r < 0.91: return pick(['one(%s)', 'fp(%s)', 'gf(%s)', 'q->call(%s)', '(*fp)(%s)']) % integer(depth - 1)
    if r < 0.93: return 'callee(%s, %s)' % (integer(depth - 1), integer(depth - 1))
    if r < 0.95: return '(stop(), %s)' % integer(depth - 1)
    if r < 0.97: return '*%s' % pointer(depth - 1)
    if r < 0.985: return '%s[%s]' % (pointer(depth - 1), integer(depth - 1))
    return pick(['(local = %s)', '(local += %s)', '(g = %s)', '(along = %s)', '(uc = %s)']) % integer(depth - 1)
def pointer_own(depth):
    if depth <= 0 or rng.random() < 0.45:
        return pick(PTR_LEAVES)
    r = rng.random()
    if r < 0.25: return '(%s + %s)' % (pointer(depth - 1), integer(depth - 1))
    if r < 0.35: return '(%s - %s)' % (pointer(depth - 1), integer(depth - 1))
    if r < 0.50: return '(%s ? %s : %s)' % (anything(depth - 1), pointer(depth - 1), pointer(depth - 1))
    if r < 0.60: return '(int*)%s' % pick([pointer(depth - 1), pick(CHAR_PTRS), pick(STRUCT_PTRS)])
    if r < 0.70: return '&%s[%s]' % (pointer(depth - 1), integer(depth - 1))
    if r < 0.80: return '(%s, %s)' % (anything(depth - 1), pointer(depth - 1))
    if r < 0.90: return '&*%s' % pointer(depth - 1)
    return '(ptr = %s)' % pointer(depth - 1)
def floating_own(depth):
    if depth <= 0 or rng.random() < 0.4:
        return pick(DBL_LEAVES)
    r = rng.random()
    if r < 0.35: return '(%s %s %s)' % (floating(depth - 1), pick(['+', '-', '*', '/']), floating(depth - 1))
    if r < 0.50: return '(%s %s %s)' % (floating(depth - 1), pick(['+', '*']), integer(depth - 1))
    if r < 0.65: return '(%s)%s' % (pick(['double', 'float']), integer(depth - 1))
    if r < 0.75: return '-%s' % floating(depth - 1)
    if r < 0.85: return '(%s ? %s : %s)' % (anything(depth - 1), floating(depth - 1), floating(depth - 1))
    if r < 0.92: return 'real(%s)' % floating(depth - 1)
    return '(double)(long)%s' % pointer(depth - 1)
def anything(depth):
    r = rng.random()
    if r < 0.62: return integer(depth)
    if r < 0.80: return pointer(depth)
    if r < 0.86: return pick(CHAR_PTRS)
    if r < 0.90: return pick(STRUCT_PTRS)
    if r < 0.94: return pick(FNS)
    return floating(depth)
def statement():
    depth = pick([1, 1, 2, 2, 2, 3, 3, 4])
    r = rng.random()
    if r < 0.16: return 'local = %s;' % integer(depth)
    if r < 0.30: return 'if (%s) local = 1;' % anything(depth)
    if r < 0.36: return 'while (%s) { if (a) break; a++; }' % anything(depth)
    if r < 0.40: return 'do { if (a) break; a++; } while (%s);' % anything(depth)
    if r < 0.44: return 'for (; %s; a++) { if (a) break; }' % anything(depth)
    if r < 0.50: return 'if (a) return %s;' % integer(depth)
    if r < 0.54: return 'switch (%s) { case 1: local = 2; break; default: local = 3; }' % integer(depth)
    if r < 0.60: return 'ptr = %s;' % pointer(depth)
    if r < 0.65: return 'dl = %s;' % floating(depth)
    if r < 0.70: return 'along = %s;' % anything(depth)
    if r < 0.74: return 'uc = %s;' % integer(depth)
    if r < 0.78: return '%s;' % pick(['one(%s)', 'fp(%s)', 'voided(), one(%s)', 'callee(%s, 1)']) % integer(depth)
    if r < 0.82: return pick(['g = %s;', 'ga[a & 7] = %s;', '*p = %s;', 'q->first = %s;', 'gp.second = %s;', 'sc[1] = %s;', 'gc = %s;', 'gh = %s;', 'gl = %s;']) % integer(depth)
    if r < 0.86: return pick(['local += %s;', 'local -= %s;', 'along |= %s;', 'g ^= %s;', 'local <<= %s;', 'uc *= %s;', 'local %%= %s;', 'ptr += %s;', 'dl += %s;']) % integer(depth)
    if r < 0.90: return 'if (%s && %s) local = 1;' % (anything(depth - 1), anything(depth - 1))
    if r < 0.94: return 'if (%s || %s) local = 1;' % (anything(depth - 1), anything(depth - 1))
    if r < 0.97: return 'local = %s ? %s : %s;' % (anything(depth - 1), integer(depth - 1), integer(depth - 1))
    return 'text = %s;' % pick(CHAR_PTRS)
key = re.compile(r'(\S*differ\S*|values wrong|failures|not-kept\S*|unkept|wrong|taken-there-and-refused-by-the-census|census-alone)=(\d+)')
found, rejected, clean = 0, 0, 0
log = open(os.path.join(out, 'found.txt'), 'a')
path = os.path.join(out, 'case-%d.c' % seed)
pragma = '#pragma STDC FENV_ACCESS ON\n' if os.environ.get('FUZZ_PRAGMA') else ''
padded = bool(os.environ.get('FUZZ_PAD'))
several = bool(os.environ.get('FUZZ_SEVERAL'))
for i in range(count):
    s = statement()
    if several:
        s = ' '.join([s] + [statement() for _ in range(rng.randrange(1, 6))])
    pad = '    local++;\n' * rng.randrange(0, 70) if padded else ''
    text = pragma + PRE + pad + '    ' + s + POST
    open(path, 'w').write(text)
    r = subprocess.run([compiler, 'measure-node-machine', '--shadow', '--window-rows', '--passes', '0', '--list', '3'] + options + [path], capture_output=True, text=True)
    output = r.stdout + r.stderr
    if 'window rows expressions=' not in output:
        rejected += 1
        continue
    if r.returncode == 0:
        clean += 1
        continue
    signature = []
    for line in output.split('\n'):
        if not line.startswith('node-shadow:'):
            continue
        head = ' '.join(line.split()[1:4])
        for k, n in key.findall(line):
            if int(n) != 0:
                signature.append('%s/%s' % (head, k))
    found += 1
    name = 'found-%d-%d.c' % (seed, i)
    open(os.path.join(out, name), 'w').write(text)
    log.write('%s status %d | %s | %s\n' % (name, r.returncode, '; '.join(signature) or 'NO KEY', s))
    log.flush()
os.unlink(path)
print('seed %d: %d programs, %d rejected, %d clean, %d found' % (seed, count, rejected, clean, found))
