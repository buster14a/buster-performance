import json, re, sys, difflib, collections
a = json.load(open('base.json')); b = json.load(open('b2.json'))
diff = [f for f in a if f in b and a[f] != b[f]]
def imm_norm(i): return re.sub(r'\$0x[0-9a-f]+|\b0x[0-9a-f]+\b|\b\d+\b', 'N', i)
cats = collections.defaultdict(list)
for f in diff:
    x, y = a[f], b[f]
    if len(x) == len(y) and [imm_norm(i) for i in x] == [imm_norm(i) for i in y]:
        cats['immediates only'].append(f)
    elif len(x) == len(y):
        cats['same length, other'].append(f)
    else:
        cats['length differs'].append(f)
for k, v in cats.items():
    print(k, len(v))
for f in cats['length differs'][:60]:
    print('L', f, len(a[f]), len(b[f]))
for f in cats['same length, other'][:40]:
    print('S', f, len(a[f]))
