#!/usr/bin/env python3
# stage.py BINARY_A IPS_A... -- BINARY_B IPS_B...: samples whose out-of-line function is the checker's input reader's
# (OUTER regex), by innermost function, A against B, per run in M events (PERIOD 200003).
import sys, re, subprocess, collections
OUTER = re.compile(r'^(check_input|c_binding|check_tag|check_constant|check_deferred|check_declspec|check_sparse|type_)')
def attribute(binary, paths):
    counts = collections.Counter()
    for path in paths:
        for line in open(path):
            p = line.split()
            if len(p) == 2 and p[1] == 'C':
                counts[int(p[0], 16)] += 1
    addrs = sorted(counts)
    out = subprocess.run(['llvm-symbolizer', '--inlining', '--functions=linkage', '--no-demangle', '--obj=' + binary],
                         input=''.join('0x%x\n' % a for a in addrs), capture_output=True, text=True).stdout
    inner = collections.Counter()
    for a, b in zip(addrs, out.strip('\n').split('\n\n')):
        rows = b.split('\n')
        names = [rows[i].replace('.buster_split', '') for i in range(0, len(rows) - 1, 2)]
        if OUTER.search(names[-1]):
            inner[names[0]] += counts[a] / len(paths) * 200003 / 1e6
    return inner
args = sys.argv[1:]
k = args.index('--')
a = attribute(args[0], args[1:k]); b = attribute(args[k + 1], args[k + 2:])
keys = sorted(set(a) | set(b), key=lambda x: -(a[x] - b[x]))
print('total A %.1f B %.1f' % (sum(a.values()), sum(b.values())))
for x in keys[:30]: print('%+7.2f %7.2f %7.2f %s' % (a[x] - b[x], a[x], b[x], x))
print('...')
for x in keys[-20:]: print('%+7.2f %7.2f %7.2f %s' % (a[x] - b[x], a[x], b[x], x))
