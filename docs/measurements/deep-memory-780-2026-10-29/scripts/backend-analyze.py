# benchmark-backend-source's runs in backend.sh's log: per tree and variant, the median over the rounds of each column
# (ns, cycles and instructions per typed entry), and the head's ratio to the base's. Every run's status must be 0.
import statistics
import sys

path, a, b = sys.argv[1], sys.argv[2], sys.argv[3]
rows = {}
statuses = []
tree = None
for line in open(path):
    words = line.split()
    if line.startswith('=== round') and len(words) == 4:
        tree = words[3]
    elif line.startswith('=== round') and 'status' in words:
        statuses.append(int(words[-1]))
    elif tree is not None and len(words) == 8 and words[0] in ('vector', 'scalar', 'sizing', 'encode', 'validate', 'validate-scalar', 'choose', 'choose-scalar'):
        rows.setdefault((tree, words[0]), []).append([float(w) for w in words[1:4]])
print(f'runs {len(statuses)}, statuses all 0: {all(s == 0 for s in statuses)}')
print(f'{"variant":16} {"column":10} {a:>10} {b:>10} {"ratio":>8}   ({a} and {b} per round)')
for variant in ('vector', 'scalar', 'sizing', 'encode', 'validate', 'validate-scalar', 'choose', 'choose-scalar'):
    for column, name in enumerate(('ns/entry', 'cyc/entry', 'ins/entry')):
        va = [r[column] for r in rows[(a, variant)]]
        vb = [r[column] for r in rows[(b, variant)]]
        ma, mb = statistics.median(va), statistics.median(vb)
        print(f'{variant:16} {name:10} {ma:10.2f} {mb:10.2f} {(mb / ma - 1) * 100:+7.2f}%   ({", ".join(f"{v:.2f}" for v in va)}; {", ".join(f"{v:.2f}" for v in vb)})')
