# fuzzgen.py SEED BYTES OUT: C-like text with the window lexer's hard cases: punctuator runs, dots and digits,
# prefixes before literals, long identifiers, comments of all lengths (and comment-like bytes in literals), splices,
# directives, non-ASCII and control bytes, numbers with exponents and separators.
import random, sys
r = random.Random(int(sys.argv[1]))
n = int(sys.argv[2])
pieces = []
puncts = ['+', '-', '*', '/', '%', '&', '|', '^', '<', '>', '=', '!', '~', '?', ':', ';', ',', '.', '(', ')', '[', ']', '{', '}', '#', '##']
def ident():
    k = r.choice([1, 1, 2, 3, 5, 8, 15, 16, 17, 31, 63, 64, 65, 127, 200, 255, 256, 257, 300])
    first = r.choice('abcxyzLuU_$ABE')
    return first + ''.join(r.choice('abcdefghijklmnopqrstuvwxyz_0123456789ABEepP$') for _ in range(k - 1))
def number():
    return r.choice(['0', '1', '42', '0x1F', '1.5', '.5', '1.', '1e5', '1e-6', '1E+5', '0x1p-3', '2.5e+3f', '1..2', '1.e2', "1'000", '10UL', '123456789012', '1.2.3', '9e', '0e+', '..', '...', '....'])
def piece():
    c = r.random()
    if c < 0.25: return ident()
    if c < 0.35: return number()
    if c < 0.55: return ''.join(r.choice(puncts) for _ in range(r.choice([1, 1, 2, 3, 4, 5])))
    if c < 0.62:
        body = ''.join(r.choice('ab */\n"\'#\\x') for _ in range(r.choice([0, 1, 2, 5, 20, 40, 60, 63, 64, 65, 100, 200])))
        return '/*' + body.replace('*/', '* /') + '*/'
    if c < 0.64: return '//' + ''.join(r.choice('ab */"\'\\') for _ in range(r.randint(0, 30))) + '\n'
    if c < 0.69:
        body = ''.join(r.choice('ab /*\'#') for _ in range(r.randint(0, 70)))
        return r.choice(['', '', 'L', 'u', 'U', 'u8', 'x', 'u9']) + '"' + body + r.choice(['"', '"', '"', '\\"', '\n'])
    if c < 0.73: return r.choice(['', '', 'L', 'u', 'U', 'u8', '1']) + r.choice(["'c'", "'\\n'", "'\\''", "'\"'", "'\\x41'", "'ab'", "'", "''"])
    if c < 0.77: return '\n' + r.choice(['', ' ', '\t', '   ']) + r.choice(['#', '# define X 1', '#if 0', '#endif', '#x', '## y'])
    if c < 0.79: return r.choice(['\\\n', '\\', '\\ \n', '\\\r\n'])
    if c < 0.81: return r.choice(['\x80', '\xc3\xa9', '\xff', '\x01', '\x7f', '@', '`', '\x0c', '\x0b', '\r', '\xab', '\xbd', '\xb5', '\xae', '\xe1', '\xbe', '\xa6'])
    if c < 0.95: return r.choice([' ', ' ', '  ', '\t', '\n', '\n\n', ' \n ', '      '])
    return r.choice(['a+++b', 'x<<=1', 'a->>b', 'a>>>=b', 'i++==j', 'x+++++y', '-->', '<<<', '&&&', '|||', '===', '!==', '.5.5', 'a.b.c'])
out = []
size = 0
while size < n:
    s = piece(); out.append(s); size += len(s)
open(sys.argv[3], 'wb').write(''.join(out).encode('latin-1'))
