#!/usr/bin/env python3
# Campaign B8 (#847): each unit's medians over the rounds of the eight-lane reading by the rule of the final tree
# (FINAL, one pair of lane constants), the claim tree with two pairs (TWO), main (MAIN) and #791's head (HEAD), with
# their lanes; the final tree against the faster of main and the head, and against two pairs.
#   b8sum.py LOG FINAL TWO MAIN HEAD
import collections, re, statistics, sys
log = sys.argv[1]
names = sys.argv[2:6]
runs = collections.defaultdict(list)
tokens = {}
cur = None
for line in open(log, errors='replace'):
    if line.startswith('== round '):
        p = line.split()
        cur = dict(name=p[3], unit=p[4])
        runs[(p[3], p[4])].append(cur)
    elif cur is not None and line.startswith('checker-deferred: file='):
        tokens[cur['unit']] = int(re.search(r'tokens=(\d+)', line).group(1))
    elif cur is not None and line.startswith('checker-deferred:   lanes=8 active='):
        cur['whole'] = float(re.search(r'whole=([\d.]+)', line).group(1))
        cur['active'] = int(re.search(r'active=(\d+)', line).group(1))
    elif cur is not None and line.startswith('exit='):
        cur['exit'] = line.split()[0]
bad = [(k, r.get('exit')) for k, rs in runs.items() for r in rs if r.get('exit') != 'exit=0']
print(f'runs: {sum(len(v) for v in runs.values())}, failed: {bad[:3]}')
print('| Unit | Tokens | Lanes: final, two pairs, main, head | Final | Two pairs | Main | Head | Final against the faster of main and head | Final against two pairs |')
print('| --- | ---: | --- | ---: | ---: | ---: | ---: | ---: | ---: |')
against, pairs = [], []
for unit in sorted({u for (_, u) in runs}, key=lambda u: tokens[u]):
    whole = [statistics.median(r['whole'] for r in runs[(n, unit)]) for n in names]
    lanes = [statistics.median(r['active'] for r in runs[(n, unit)]) for n in names]
    a = 100 * (whole[0] / min(whole[2], whole[3]) - 1)
    b = 100 * (whole[0] / whole[1] - 1)
    against.append((a, unit))
    pairs.append((b, unit))
    print(f'| `{unit}.c` | {tokens[unit]} | {"/".join(str(int(x)) for x in lanes)} | ' + ' | '.join(f'{w:.2f}' for w in whole) + f' | {a:+.1f}% | {b:+.1f}% |')
print(f'\nfinal against the faster of main and head: median {statistics.median(x for x, _ in against):+.2f}%, from {min(against)[0]:+.1f}% ({min(against)[1]}) '
      f'to {max(against)[0]:+.1f}% ({max(against)[1]}), over +1%: {sum(x > 1 for x, _ in against)}, over +2%: {sum(x > 2 for x, _ in against)}')
print(f'final against two pairs: median {statistics.median(x for x, _ in pairs):+.2f}%, from {min(pairs)[0]:+.1f}% ({min(pairs)[1]}) to {max(pairs)[0]:+.1f}% ({max(pairs)[1]})')
