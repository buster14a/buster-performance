import sys, collections
sys.path.insert(0, '.')
from tok import tokenize
# transform.py IN.i SHADOW.txt OUT.i MODE: replaces each taken full expression of a statement, a condition or a switch by one
# leaf, the volatile global __z, where MODE selects the expressions: all, nothing-listed, plain (no call, label, temporary
# or control branch), or none (the declaration alone is added).
src, shadow, dst, mode = sys.argv[1:5]
data = open(src, 'rb').read()
toks = tokenize(data)
text = [data[a:b] for a, b in toks]
n = len(toks)
match = [-1] * n
stack = []
pairs = {b')': b'(', b']': b'[', b'}': b'{'}
for i, t in enumerate(text):
    if t in (b'(', b'[', b'{'):
        stack.append(i)
    elif t in pairs:
        j = stack.pop()
        assert text[j] == pairs[t], (i, j)
        match[i] = j
        match[j] = i
assert not stack
spans = [tuple(map(int, l.split()[1:])) for l in open(shadow) if l.startswith('experiment-span')]
BOUNDARY = {b';', b'{', b'}', b'else', b'do', b':'}

def extend(low, root):
    # The expression's first token: `low` is its lowest record's token, which a cast's `)` can be, with its `(` and its
    # type before it, and grouping parentheses that close before the root can open before that.
    first = low
    while True:
        if text[first] in pairs and match[first] < first:
            first = match[first]
        elif text[first - 1] == b'(' and first - 1 < match[first - 1] < root:
            first -= 1
        else:
            return first
ranges = []
stats = collections.Counter()
for low, high, cls, mask, kind, op, root, records in spans:
    selected = mode == 'all' or (mode == 'nothing-listed' and cls == 0) or (mode == 'plain' and cls == 0 and mask == 0)
    if cls == 2 or not selected or mode == 'none':
        stats['not selected'] += 1
        continue
    rt = text[root]
    first = last = -1
    if kind in (1, 3) and rt == b')':
        first, last = match[root] + 1, root - 1
        if text[match[root] - 1] not in (b'if', b'while', b'switch'):
            stats['condition: unexpected header'] += 1
            continue
    elif kind == 1 and rt == b';':
        first, last = extend(low, root), root - 1
        if text[first - 1] != b';':
            stats['for condition: unexpected left'] += 1
            continue
    elif kind == 0:
        first, last = extend(low, root), root - 1
        left = text[first - 1]
        header = left == b')' and text[match[first - 1] - 1] in (b'if', b'while', b'for', b'switch')
        for_init = left == b'(' and text[first - 2] == b'for'
        if not (left in BOUNDARY or header or for_init):
            stats['statement: unexpected left ' + left.decode()] += 1
            continue
    else:
        stats[f'kind {kind} left as it is'] += 1
        continue
    if first > last:
        stats['empty'] += 1
        continue
    # The range must be balanced.
    depth = 0
    ok = True
    for i in range(first, last + 1):
        if text[i] in (b'(', b'[', b'{'):
            ok = ok and first <= match[i] <= last
        elif text[i] in pairs:
            ok = ok and first <= match[i] <= last
    if not ok:
        stats['unbalanced'] += 1
        continue
    ranges.append((first, last, records))
    stats[f'replaced kind {kind}'] += 1
    stats['replaced records'] += records
ranges.sort()
kept = []
end = -1
for first, last, records in ranges:
    if first > end:
        kept.append((first, last))
        end = last
    else:
        stats['nested in a replaced one'] += 1
out = []
pos = 0
for first, last in kept:
    out.append(data[pos:toks[first][0]])
    out.append(b'__z')
    pos = toks[last][1]
out.append(data[pos:])
open(dst, 'wb').write(b'volatile int __z;\n' + b''.join(out))
for k, v in sorted(stats.items()):
    print(f'{mode}: {k}: {v}')
print(f'{mode}: tokens before {n}, removed {sum(l - f for f, l in kept)}')
