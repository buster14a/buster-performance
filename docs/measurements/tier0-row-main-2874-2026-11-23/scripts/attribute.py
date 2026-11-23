#!/usr/bin/env python3
# attribute.py BINARY OUT IPS...: perf's sampled addresses (one "ip dso" a line) by function, with each address's inline
# chain from llvm-symbolizer over BINARY's debug information. Writes OUT.chains (the symbolizer's output) once and
# prints three tables: by outermost symbol, by innermost function, and by (outermost, innermost) pair. buster#2874.
import collections
import os
import subprocess
import sys

SYMBOLIZER = None
for root, dirs, files in os.walk('/root/.cache/buster/toolchain'):
    if 'llvm-symbolizer' in files and root.endswith('/bin'):
        SYMBOLIZER = os.path.join(root, 'llvm-symbolizer')
        break


def main():
    binary, out = sys.argv[1], sys.argv[2]
    counts = collections.Counter()
    for path in sys.argv[3:]:
        with open(path) as f:
            for line in f:
                parts = line.split()
                if not parts:
                    continue
                counts[int(parts[0], 16)] += 1
    total = sum(counts.values())
    chains_path = out + '.chains'
    chains = {}
    if not os.path.exists(chains_path):
        addresses = '\n'.join('0x%x' % a for a in sorted(counts)) + '\n'
        result = subprocess.run([SYMBOLIZER, '-a', '-p', '-i', '-s', '--no-demangle', '--obj=' + binary], input=addresses, capture_output=True, text=True)
        with open(chains_path, 'w') as f:
            f.write(result.stdout)
    current = None
    with open(chains_path) as f:
        for line in f:
            line = line.rstrip('\n')
            if line.startswith('0x'):
                address, rest = line.split(': ', 1)
                current = int(address, 16)
                chains[current] = [rest.split(' at ')[0]]
            elif line.startswith(' (inlined by) ') and current is not None:
                chains[current].append(line[len(' (inlined by) '):].split(' at ')[0])
    outer = collections.Counter()
    inner = collections.Counter()
    pair = collections.Counter()
    for address, n in counts.items():
        chain = chains.get(address, ['??'])
        chain = [c.replace('.buster_split', '') for c in chain]
        outer[chain[-1]] += n
        inner[chain[0]] += n
        pair[(chain[-1], chain[0])] += n
    print('samples', total)
    print('\n== by symbol')
    for name, n in outer.most_common(60):
        print('%8d %6.2f%%  %s' % (n, 100.0 * n / total, name))
    print('\n== by innermost function')
    for name, n in inner.most_common(120):
        print('%8d %6.2f%%  %s' % (n, 100.0 * n / total, name))
    print('\n== by symbol / innermost')
    for (o, i), n in pair.most_common(150):
        print('%8d %6.2f%%  %s / %s' % (n, 100.0 * n / total, o, i))


main()
