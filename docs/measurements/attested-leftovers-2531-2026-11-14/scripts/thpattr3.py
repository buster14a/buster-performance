#!/usr/bin/env python3
# thpattr3.py: each huge-page fault sample by its first four user frames (frame-pointer chains).
import sys, collections
huge = collections.Counter()
total = 0
frames = []
def flush():
    global frames, total
    if not frames:
        return
    total += 1
    kernel = [f for f in frames if f[1]]
    user = [f[0] for f in frames if not f[1]]
    names = [f[0] for f in kernel]
    if any(('huge_pmd' in n) or ('anon_folio_pmd' in n) or ('clear_huge_page' in n) for n in names):
        huge[' < '.join(user[:4]) if user else '?'] += 1
    frames = []
for line in sys.stdin:
    s = line.rstrip('\n')
    if not s.strip() or not s.startswith((' ', '\t')):
        flush()
        continue
    parts = s.strip().split(None, 2)
    if len(parts) >= 2:
        frames.append((parts[1].split('+')[0], 'kernel' in (parts[2] if len(parts) > 2 else '')))
flush()
print('samples', total, 'in huge-page faults', sum(huge.values()))
for k, v in huge.most_common(20):
    print('%6d %s' % (v, k))
