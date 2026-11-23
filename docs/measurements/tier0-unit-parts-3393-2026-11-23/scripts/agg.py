# agg.py CHAINS IPS PATTERN [MODE]: samples whose outer symbol matches PATTERN, by outer, inner, and inner line.
import collections, re, sys
chains_path, ips_path, pattern = sys.argv[1], sys.argv[2], re.compile(sys.argv[3])
mode = sys.argv[4] if len(sys.argv) > 4 else 'all'
chains = {}
cur = None
for line in open(chains_path):
    line = line.rstrip('\n')
    if line.startswith('0x'):
        a, rest = line.split(': ', 1)
        cur = int(a, 16); chains[cur] = [rest]
    elif line.startswith(' (inlined by) ') and cur is not None:
        chains[cur].append(line[len(' (inlined by) '):])
counts = collections.Counter(int(l.split()[0], 16) for l in open(ips_path) if l.strip())
outer = collections.Counter(); inner = collections.Counter(); lines = collections.Counter(); pairs = collections.Counter()
for a, n in counts.items():
    ch = chains.get(a, ['?? at ?'])
    names = [c.split(' at ')[0].replace('.buster_split', '') for c in ch]
    if not pattern.search(names[-1]): continue
    outer[names[-1]] += n; inner[names[0]] += n; pairs[(names[-1], names[0])] += n
    # line of outermost frame inside the outer function and the innermost line
    loc_outer = ch[-1].split(' at ')[-1]; loc_inner = ch[0].split(' at ')[-1]
    lines[(names[-1], loc_outer.split('/')[-1], names[0], loc_inner.split('/')[-1])] += n
tot = sum(counts.values())
print('total', tot, 'matched', sum(outer.values()))
for k, n in outer.most_common(40): print('%6d %s' % (n, k))
print('== pairs')
for k, n in pairs.most_common(60): print('%6d %s / %s' % (n, k[0], k[1]))
print('== lines')
for k, n in lines.most_common(int(mode) if mode.isdigit() else 80): print('%6d %s %s | %s %s' % (n, *k))
