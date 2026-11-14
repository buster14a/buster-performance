#!/usr/bin/env python3
# attr.py BINARY IPS...: samples by inlined frame (innermost function, and each frame of the inline chain), via
# llvm-symbolizer --inlining. Prints TSVs: innermost function totals, and "self+inlined" chain-inclusive totals.
import sys, subprocess, collections
binary = sys.argv[1]
counts = collections.Counter()
other = 0
for path in sys.argv[2:]:
    for line in open(path):
        ip, kind = line.split()
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
    frames = [(rows[i], rows[i + 1]) for i in range(0, len(rows) - 1, 2)]
    n = counts[a]
    fn, loc = frames[0]
    inner[fn] += n
    outer[frames[-1][0]] += n
    file = loc.rsplit('/', 1)[-1]
    lines[fn + '\t' + ':'.join(file.split(':')[:2])] += n
    for f in set(fr[0] for fr in frames):
        inclusive[f] += n
total = sum(counts.values())
def dump(name, c):
    with open(name, 'w') as out:
        for k, v in c.most_common():
            out.write('%d\t%s\n' % (v, k))
tag = sys.argv[2].rsplit('/', 1)[-1].split('.')[0]
dump(tag + '.inner.tsv', inner); dump(tag + '.inclusive.tsv', inclusive); dump(tag + '.lines.tsv', lines); dump(tag + '.outer.tsv', outer)
print(tag, 'compiler samples', total, 'other', other)
