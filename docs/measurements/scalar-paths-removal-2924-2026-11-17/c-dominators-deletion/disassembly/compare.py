import json, sys
a = json.load(open(sys.argv[1])); b = json.load(open(sys.argv[2]))
only_a = [f for f in a if f not in b]; only_b = [f for f in b if f not in a]
diff = [f for f in a if f in b and a[f] != b[f]]
same = sum(1 for f in a if f in b and a[f] == b[f])
print(f"functions: base {len(a)}, b2 {len(b)}, identical {same}, differ {len(diff)}, base only {len(only_a)}, b2 only {len(only_b)}")
for name, lst in (("base only", only_a), ("b2 only", only_b), ("differ", diff)):
    for f in lst[:200]:
        extra = ''
        if name == 'differ':
            extra = f"  ({len(a[f])} vs {len(b[f])} instructions)"
        print(f"{name}\t{f}{extra}")
