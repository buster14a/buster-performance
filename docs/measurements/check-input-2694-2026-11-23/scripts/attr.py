#!/usr/bin/env python3
# attr.py BINARY OUT IPS... (from check-input-1489-regrowth-2026-11-13's attr.py): samples by inlined frame, via
# llvm-symbolizer --inlining, per run. Writes OUT.inner.tsv (innermost function), OUT.inclusive.tsv (every frame of the
# inline chain), OUT.lines.tsv (innermost function and line) and OUT.outer.tsv (the out-of-line function).
import sys, subprocess, collections
binary, prefix = sys.argv[1], sys.argv[2]
paths = sys.argv[3:]
counts = collections.Counter()
other = 0
for path in paths:
    for line in open(path):
        parts = line.split()
        if len(parts) != 2:
            continue
        ip, kind = parts
        if kind == 'C':
            counts[int(ip, 16)] += 1
        else:
            other += 1
addrs = sorted(counts)
proc = subprocess.run(['llvm-symbolizer', '--inlining', '--functions=linkage', '--no-demangle', '--obj=' + binary],
                      input=''.join('0x%x\n' % a for a in addrs), capture_output=True, text=True)
blocks = proc.stdout.strip('\n').split('\n\n')
assert len(blocks) == len(addrs), (len(blocks), len(addrs))
inner = collections.Counter(); inclusive = collections.Counter(); lines = collections.Counter(); outer = collections.Counter()
for a, b in zip(addrs, blocks):
    rows = b.split('\n')
    frames = [(rows[i].replace('.buster_split', ''), rows[i + 1]) for i in range(0, len(rows) - 1, 2)]
    n = counts[a]
    fn, loc = frames[0]
    inner[fn] += n
    outer[frames[-1][0]] += n
    file = loc.rsplit('/', 1)[-1]
    lines[fn + '\t' + ':'.join(file.split(':')[:2])] += n
    for f in set(fr[0] for fr in frames):
        inclusive[f] += n
runs = len(paths)
def dump(name, c):
    with open(prefix + '.' + name + '.tsv', 'w') as out:
        for k, v in c.most_common():
            out.write('%.1f\t%s\n' % (v / runs, k))
dump('inner', inner); dump('inclusive', inclusive); dump('lines', lines); dump('outer', outer)
print(prefix, 'runs', runs, 'compiler samples a run', sum(counts.values()) / runs, 'other', other / runs)
