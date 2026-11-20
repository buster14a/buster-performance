# symdiff.py A B: text symbols (nm -S, types t/T) whose summed size by name differs between two builds.
import collections, sys
def load(p):
    c = collections.Counter()
    for line in open(p):
        w = line.split()
        c[w[3]] += int(w[1], 16)
    return c
a, b = load(sys.argv[1]), load(sys.argv[2])
diff = sorted(((b.get(k, 0) - a.get(k, 0), k) for k in set(a) | set(b) if a.get(k, 0) != b.get(k, 0)), key=lambda x: -abs(x[0]))
print(f'{sys.argv[2]} against {sys.argv[1]}: {len(diff)} symbols differ, text {sum(b.values()) - sum(a.values()):+d} bytes')
for d, k in diff[:int(sys.argv[3]) if len(sys.argv) > 3 else 25]:
    print(f'  {d:+7d} {k} ({a.get(k, 0)} -> {b.get(k, 0)})')
