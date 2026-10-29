#!/usr/bin/env python3
# perf script -F pid,tid,ip,sym output (with -g): the lanes' samples whose leaf frame is one of the names given (or every
# sample with `all`), by their whole kernel chain (leaf first) and first user frame, the most common first.
#   chains.py LEAF... < script.txt
import sys, collections
wanted = set(sys.argv[1:])
chains = collections.Counter()
role = None; frames = []
def flush():
    global frames
    if role == 'lane' and frames and ('all' in wanted or frames[0][1] in wanted):
        user = next((f[1] for f in frames if not f[0]), '?')
        kernel = [f[1] for f in frames if f[0]]
        chains[(user, ' <- '.join(kernel))] += 1
    frames = []
for line in sys.stdin:
    s = line.strip()
    if not s:
        flush(); continue
    parts = s.split()
    if '/' in parts[0] and not frames:
        pid, tid = parts[0].split('/')
        role = 'main' if pid == tid else 'lane'
        continue
    if len(parts) >= 2:
        frames.append((parts[0].startswith('ffffffff'), parts[1]))
flush()
for (user, chain), n in chains.most_common(25):
    print('%4d %-26s %s' % (n, user, chain))
