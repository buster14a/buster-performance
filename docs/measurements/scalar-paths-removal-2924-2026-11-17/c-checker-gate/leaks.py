# #2924 C12c: where a gated value leaves its area in the rewritten tree. A gated value is the gated `scalar` local, any
# expression with buster_scalar_area(N), or a local initialized from one (one level). Each use as (part of) a call's
# argument or a store's right side is listed with its consumer: the callee (its file's bit) or the stored field.
# Run from src/buster/compiler of the rewritten tree.
import sys, glob, re, os, collections
exec(open(os.path.join(os.path.dirname(os.path.abspath(__file__)), 'knob2.py')).read().split("def main():")[0])
stage = sorted(set(f for f in glob.glob('c_check*.c') if not f.endswith(('_test.c', '_benchmark.c'))))
ss = set(stage)
defs = definitions(glob.glob('*.c') + glob.glob('*.h'))
SEE_THROUGH = {'BUSTER_SCALAR_PATH', 'BUSTER_VECTOR_PATH', '__builtin_expect'}

def consumer(toks, j, lo):
    # The innermost enclosing call (seen through the path macros and grouping parentheses) or store of the token j.
    depth = 0
    k = j - 1
    while k > lo:
        t = toks[k][1]
        if toks[k][0] == 'punct':
            if t in (')', ']', '}'):
                depth += 1
            elif t in ('(', '[', '{'):
                if depth == 0:
                    if t == '(' and toks[k - 1][0] == 'ident' and toks[k - 1][1] not in KEYWORDS:
                        name = toks[k - 1][1]
                        if name not in SEE_THROUGH:
                            return ('call', name)
                    elif t == '(' and toks[k - 1][1] in ('if', 'while', 'for', 'switch'):
                        return ('branch', toks[k - 1][1])
                    elif t == '{':
                        # A brace list: a designated field's store, or a block (a branch).
                        m = k + 1
                        return ('init', None)
                else:
                    depth -= 1
            elif depth == 0 and t in ASSIGN:
                lhs = []
                m = k - 1
                while m > lo and toks[m][1] not in (';', '{', '}', ',', '(') :
                    lhs.insert(0, toks[m][1])
                    m -= 1
                return ('store', ''.join(lhs))
            elif depth == 0 and t in (';',):
                return ('branch', None)
            elif depth == 0 and t == ',' :
                pass
        elif toks[k][1] == 'return' and depth == 0:
            return ('return', None)
        k -= 1
    return ('branch', None)

def designator(toks, j, lo):
    # In a brace list, the designated field the token's entry stores to (`.field = ...`), if any.
    depth = 0
    k = j - 1
    while k > lo:
        t = toks[k][1]
        if t in (')', ']', '}'):
            depth += 1
        elif t in ('(', '[', '{'):
            if depth == 0:
                return None
            depth -= 1
        elif depth == 0 and t == '=' and toks[k - 2][1] == '.':
            return '.' + toks[k - 1][1]
        elif depth == 0 and t == ',':
            return None
        k -= 1
    return None

out = collections.Counter()
lines = []
for f in stage:
    bit = file_bit(f)
    text = open(f).read()
    toks = tokenize(text)
    for name, po, pc, bo, bc in functions(toks):
        body = ''.join(t[1] + ' ' for t in toks[bo:bc + 1])
        gated_local = 'buster_scalar_area' in body and re.search(r'scalar = scalar_raw \|\| buster_scalar_area', body) is not None
        aliases = set()
        for j in range(bo + 1, bc):
            k, t = toks[j][0], toks[j][1]
            is_gated = (k == 'ident' and t == 'buster_scalar_area') or \
                       (k == 'ident' and t == 'scalar' and gated_local and toks[j - 1][1] not in ('.', '->') and toks[j + 1][1] != '=') or \
                       (k == 'ident' and t in aliases and toks[j - 1][1] not in ('.', '->') and toks[j + 1][1] != '=')
            if not is_gated:
                continue
            c = consumer(toks, j, bo)
            line = text.count('\n', 0, toks[j][2]) + 1
            src = text[text.rfind('\n', 0, toks[j][2]) + 1:text.find('\n', toks[j][2])].strip()
            if re.search(r'const bool \w+ = \w+_raw (\|\||&&) !?buster_scalar_area', src) or 'scalar_raw, scalar = scalar_raw' in src:
                continue
            # The bit this token carries: its own buster_scalar_area(N), else the file's (the gated name).
            carried = int(toks[j + 2][1]) if t == 'buster_scalar_area' and toks[j + 2][0] == 'number' else bit
            if c[0] == 'store':
                # A local initialized from a gated value: an alias.
                m = re.match(r'^(?:const)?(?:bool|uint\w*|int)(\w+)$', c[1] or '')
                if m:
                    aliases.add(m.group(1))
                    continue
                lines.append((f, line, bit, 'store', c[1], src))
            elif c[0] == 'init':
                d = designator(toks, j, bo)
                lines.append((f, line, bit, 'init', d, src))
            elif c[0] == 'call':
                home = defs.get(c[1])
                hb = file_bit(home) if home in ss else foreign_bit(home)
                if hb != carried and not (carried in range(2, 8)):
                    lines.append((f, line, carried, 'call', f'{c[1]} ({home}) -> {hb}', src))
            elif c[0] == 'return':
                lines.append((f, line, bit, 'return', name, src))
seen = set()
for r in lines:
    key = (r[0], r[1], r[3], r[4])
    if key in seen:
        continue
    seen.add(key)
    print(f'{r[0]}:{r[1]}\t{r[2]}\t{r[3]}\t{r[4]}\t{r[5][:150]}')
