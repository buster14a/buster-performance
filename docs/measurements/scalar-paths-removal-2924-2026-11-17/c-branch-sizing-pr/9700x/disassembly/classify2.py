import json, re, sys, collections
a = json.load(open(sys.argv[1])); b = json.load(open(sys.argv[2]))
diff = [f for f in a if f in b and a[f] != b[f]]
def imm_norm(i): return re.sub(r'\$0x[0-9a-f]+|\b0x[0-9a-f]+\b|\b\d+\b', 'N', i)
def sym_norm(i): return re.sub(r'<[^>]*>', '<S>', imm_norm(i))
cats = collections.defaultdict(list)
for f in diff:
    x, y = a[f], b[f]
    if len(x) == len(y) and [imm_norm(i) for i in x] == [imm_norm(i) for i in y]:
        cats['immediates only'].append(f)
    elif len(x) == len(y) and [sym_norm(i) for i in x] == [sym_norm(i) for i in y]:
        cats['symbols or immediates only'].append(f)
    elif len(x) == len(y):
        cats['same length, other'].append(f)
    else:
        cats['length differs'].append(f)
for k, v in cats.items():
    print(k, len(v))
for k in ('length differs', 'same length, other'):
    for f in cats[k]:
        print(k[0].upper(), f, len(a[f]), len(b[f]))
