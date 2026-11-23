#!/usr/bin/env python3
# chunks.py IN.i OUTDIR K...: variants of a preprocessed unit for the locality experiment. `whole.i` is the unit,
# `none.i` has every function definition's body replaced by `;` (a `{` at file scope that follows a `)`), and for each K
# `kK-cI.i` keeps the bodies of chunk I alone: the bodies in source order cut into K runs of about equal body tokens.
import sys, os
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from tok import tokenize
src, outdir = sys.argv[1:3]
ks = [int(k) for k in sys.argv[3:]]
data = open(src, 'rb').read()
toks = tokenize(data)
text = [data[a:b] for a, b in toks]
n = len(toks)
bodies = []
depth = 0
i = 0
while i < n:
    t = text[i]
    if t == b'{':
        if depth == 0 and i > 0 and text[i - 1] == b')':
            d = 0
            j = i
            while True:
                if text[j] == b'{':
                    d += 1
                elif text[j] == b'}':
                    d -= 1
                    if d == 0:
                        break
                j += 1
            # Its name: the identifier before the `(` that the `)` before its brace closes (a plain declarator's).
            d = 0
            p = i - 1
            while p >= 0:
                if text[p] == b')':
                    d += 1
                elif text[p] == b'(':
                    d -= 1
                    if d == 0:
                        break
                p -= 1
            name = text[p - 1] if p > 0 and (text[p - 1][:1].isalpha() or text[p - 1][:1] == b'_') else None
            bodies.append((i, j, name))
            i = j + 1
            continue
        depth += 1
    elif t == b'}':
        depth -= 1
    i += 1
total = sum(j - i + 1 for i, j, name in bodies)
def write(name, keep):
    out = []
    pos = 0
    kept = []
    for index, (i, j, function) in enumerate(bodies):
        if index not in keep:
            out.append(data[pos:toks[i][0]])
            out.append(b';')
            pos = toks[j][1]
        elif function is not None and function not in (b'if', b'while', b'for', b'switch', b'sizeof', b'__attribute__'):
            kept.append(function)
    out.append(data[pos:])
    # Every function the variant defines stays referenced, so that the same functions are emitted in the unit whole
    # and in a batch whose callers of a static function are gone.
    out.append(b'\nvoid* const buster_locality_keeper[] = { (void*)0')
    for function in kept:
        out.append(b', (void*)' + function)
    out.append(b' };\n')
    open(os.path.join(outdir, name), 'wb').write(b''.join(out))
os.makedirs(outdir, exist_ok=True)
write('whole.i', set(range(len(bodies))))
write('none.i', set())
lines = [f'tokens {n} bodies {len(bodies)} body-tokens {total} named {sum(1 for b in bodies if b[2] is not None)}']
for k in ks:
    chunk = 0
    seen = 0
    keep = [set() for _ in range(k)]
    sizes = [0] * k
    for index, (i, j, name) in enumerate(bodies):
        size = j - i + 1
        while chunk < k - 1 and seen + size / 2 > (chunk + 1) * total / k:
            chunk += 1
        keep[chunk].add(index)
        sizes[chunk] += size
        seen += size
    for c in range(k):
        write(f'k{k}-c{c}.i', keep[c])
        lines.append(f'k{k}-c{c} bodies {len(keep[c])} body-tokens {sizes[c]}')
open(os.path.join(outdir, 'chunks.txt'), 'w').write('\n'.join(lines) + '\n')
print(lines[0])
