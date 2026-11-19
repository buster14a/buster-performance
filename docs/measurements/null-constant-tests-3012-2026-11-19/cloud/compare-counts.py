#!/usr/bin/env python3
# compare-counts.py DIR_A DIR_B: the shadow's outputs of two builds (shadow-limited.sh's files), a file a corpus and mode:
# every `key=number` of every line, in order; the keys whose numbers differ, by how many files, with the values where
# the number is no tick figure. Lines only one build prints are listed.
import re, sys, os, collections
a_dir, b_dir = sys.argv[1], sys.argv[2]
token = re.compile(r"([\w'-]+)=(-?\d[\d.]*)")
def lines(path):
    out = collections.OrderedDict()
    for line in open(path, errors='replace'):
        m = re.match(r'(node-\w+: )(.*)', line.rstrip('\n'))
        if not m:
            continue
        body = m.group(2)
        # A line's name: its words up to the first key=number.
        first = token.search(body)
        name = (body[:first.start()] if first else body).strip()
        # Lines of a list (an op, a test, an event, a root) are named with their first key's value.
        k = name
        n = 0
        while (k, n) in out:
            n += 1
        out[(k, n)] = body
    return out
differ = collections.Counter(); shown = collections.defaultdict(list); only = collections.Counter()
files = sorted(f for f in os.listdir(a_dir) if f.endswith('.out'))
for f in files:
    a = lines(os.path.join(a_dir, f)); b = lines(os.path.join(b_dir, f))
    for key in a.keys() | b.keys():
        if key not in a or key not in b:
            only[(key[0][:70], 'A' if key in a else 'B')] += 1
            continue
        ta = token.findall(a[key]); tb = token.findall(b[key])
        if [k for k, _ in ta] != [k for k, _ in tb]:
            differ[(key[0][:60], '<the keys>')] += 1
            shown[(key[0][:60], '<the keys>')].append((f[:12], ' '.join(k for k, _ in ta)[:60], ' '.join(k for k, _ in tb)[:60]))
            continue
        # A tick figure: its key or its line's name says ticks, or it is followed by a parenthesis that is no percentage
        # (`the loop=804446 (2.78)`, where a count's is `expressions=51338 (98.03%)`).
        for ma, (k, va), (_, vb) in zip(token.finditer(a[key]), ta, tb):
            after = a[key][ma.end():ma.end() + 24]
            ticks = 'tick' in k or 'tick' in key[0] or (after.startswith(' (') and re.match(r' \(-?[\d.]+%', after) is None)
            if va != vb:
                differ[(key[0][:60], k, ticks)] += 1
                shown[(key[0][:60], k, ticks)].append((f[:12], va, vb))
print('files', len(files))
for (name, where), n in sorted(only.items()):
    print('only in %s: %s (%d files)' % (where, name, n))
keys = 0
for item, n in sorted(differ.items(), key=lambda kv: (str(kv[0][0]), str(kv[0][1]))):
    if len(item) == 2:
        print('* | %s | the line has other keys in %d files' % (item[0], n))
        continue
    name, k, tick = item
    if tick:
        keys += 1
    else:
        print('* | %s | %s differs in %d files: %s' % (name, k, n, '; '.join('%s %s -> %s' % v for v in shown[item][:8])))
print('tick figures that differ: %d keys' % keys)
