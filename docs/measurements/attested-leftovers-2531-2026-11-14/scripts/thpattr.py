#!/usr/bin/env python3
# thpattr.py: perf script output (cycles:k with call chains) on stdin; for each sample whose kernel chain is in a huge-page
# fault (do_huge_pmd_anonymous_page and below), the first user frame's symbol; and the same for base-page faults. Prints
# the top symbols of each with their sample counts.
import sys, collections
huge = collections.Counter()
base = collections.Counter()
total = 0
frames = []
def flush():
    global frames, total
    if not frames:
        return
    total += 1
    kernel = [f for f in frames if f[1]]
    user = [f for f in frames if not f[1]]
    names = [f[0] for f in kernel]
    first = user[0][0] if user else '?'
    if any(('huge_pmd' in n) or ('anon_folio_pmd' in n) or ('clear_huge_page' in n) for n in names):
        huge[first] += 1
    elif any('do_anonymous_page' in n for n in names):
        base[first] += 1
    frames = []
for line in sys.stdin:
    s = line.rstrip('\n')
    if not s.strip():
        flush()
        continue
    if not s.startswith((' ', '\t')):
        flush()
        continue
    parts = s.strip().split(None, 2)
    if len(parts) >= 2:
        sym = parts[1]
        dso = parts[2] if len(parts) > 2 else ''
        frames.append((sym.split('+')[0], 'kernel' in dso))
flush()
print('samples', total, 'in huge-page faults', sum(huge.values()), 'in base-page faults', sum(base.values()))
print('huge-page faults by the user code that touched the page:')
for k, v in huge.most_common(15):
    print('  %6d %s' % (v, k))
print('base-page faults by the user code:')
for k, v in base.most_common(12):
    print('  %6d %s' % (v, k))
