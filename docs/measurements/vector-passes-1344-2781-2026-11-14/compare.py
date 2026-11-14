import sys, collections, subprocess
W = "/home/david/.cache/droid-vector-census"
def load(exe, hist):
    out = subprocess.run(["python3", f"{W}/annotate.py", exe, hist, "dump"], capture_output=True, text=True).stdout
    rows = []
    for line in out.splitlines():
        c = int(line[:10]); k = line[49:77].strip(); t = line[78:].rstrip()
        rows.append((c, k, t))
    return rows
names = sys.argv[1:]
data = {}
for n in names:
    exe, hist = n.split("=")[1].split(":")
    data[n.split("=")[0]] = load(exe, hist)
keys = list(data)
classes = collections.defaultdict(lambda: collections.Counter())
for n in keys:
    for c, k, t in data[n]: classes[k][n] += c
order = sorted(classes, key=lambda k: -classes[k][keys[0]])
print(f"{'class':30s} " + " ".join(f"{n:>12s}" for n in keys))
for k in order:
    print(f"{k:30s} " + " ".join(f"{classes[k][n]:12d}" for n in keys))
print(f"{'total':30s} " + " ".join(f"{sum(c for c,_,_ in data[n]):12d}" for n in keys))
