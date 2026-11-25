# fuzzgen2.py SEED BYTES OUT: C-like text the direct path's preprocessor takes without bailing out, with the window
# lexer's hard cases: punctuator runs, dots and digits, long identifiers, comments of every length (with quotes,
# slashes and stars in them), literals with comment-like bytes, '#' and '##' in macro bodies, object and function-like
# macros used in the text.
import random, sys
r = random.Random(int(sys.argv[1]))
n = int(sys.argv[2])
puncts = ['+', '-', '*', '/', '%', '&', '|', '^', '<', '>', '=', '!', '~', '?', ':', ';', ',', '.', '(', ')', '[', ']', '{', '}']
def ident():
    k = r.choice([1, 1, 2, 3, 5, 8, 15, 16, 17, 31, 63, 64, 65, 127, 200, 255, 256, 257, 300])
    first = r.choice('abcxyzLuUABE_$')
    s = first + ''.join(r.choice('abcdefghijklmnopqrstuvwxyz_0123456789ABEepP') for _ in range(k - 1))
    return s
def number():
    return r.choice(['0', '1', '42', '0x1F', '1.5', '.5', '1.', '1e5', '1e-6', '1E+5', '0x1p-3', '2.5e+3f', '10UL', '123456789012', '7', '65535', '0777', '1.25'])
def comment():
    body = ''.join(r.choice('ab */\n"\'#\\x/') for _ in range(r.choice([0, 1, 2, 5, 20, 40, 59, 60, 61, 62, 63, 64, 65, 100, 130, 200, 500])))
    while '*/' in body: body = body.replace('*/', '* /')
    return '/*' + body + '*/'
def piece():
    c = r.random()
    if c < 0.26: return ident()
    if c < 0.34: return ' ' + number() + ' '
    if c < 0.54: return ''.join(r.choice(puncts) for _ in range(r.choice([1, 1, 1, 2, 3, 4, 5])))
    if c < 0.64: return comment()
    if c < 0.66: return '//' + ''.join(r.choice('ab */"\'') for _ in range(r.randint(0, 30))) + '\n'
    if c < 0.70: return r.choice(['', '', '', ' u8', ' ']) + '"' + ''.join(r.choice('ab /*\'#,') for _ in range(r.randint(0, 70))) + '"'
    if c < 0.73: return ' ' + r.choice(["'c'", "'\\n'", "'\\''", "'\"'", "'/'", "'*'", "'#'"])
    if c < 0.76: return '\n' + r.choice(['', ' ', '\t']) + r.choice(['#define OBJ 1 + 2', '#define F(a, b) a ## b + #a', '#define E', '#undef OBJ', '#if 1', '#endif', '#if 0\n' + comment() + ' "x" \'y\' #endif\n#endif', '#define ID(x) x', '# /* c */ define Q (1 /* d */ + 2)']) + '\n'
    if c < 0.79: return r.choice(['OBJ', 'F(x, y)', 'ID(a+++b)', 'E', 'Q', 'F(<, <=)', 'ID(ID(1.5))', 'F ( u , 8 )'])
    if c < 0.95: return r.choice([' ', ' ', '  ', '\t', '\n', '\n\n', ' \n ', '      ', '\f', '\v', '\r\n'])
    return r.choice(['a+++b', 'x<<=1', 'a->>b', 'a>>>=b', 'i++==j', 'x+++++y', '-->', '<<<', '&&&', '|||', '===', '!==', ' .5 ', 'a.b.c', '...', ' 1.e2 '])
out = []
size = 0
while size < n:
    s = piece(); out.append(s); size += len(s)
txt = ''.join(out)
# A balanced conditional stack: drop stray #endif lines and close the open ones.
lines = txt.split('\n')
depth = 0
kept = []
for ln in lines:
    t = ln.strip()
    if t.startswith('#if'): depth += 1
    if t.startswith('#endif'):
        if depth == 0: continue
        depth -= 1
    kept.append(ln)
txt = '\n'.join(kept) + '\n' + '#endif\n' * depth + '\n' * 100
open(sys.argv[3], 'wb').write(txt.encode('latin-1'))
