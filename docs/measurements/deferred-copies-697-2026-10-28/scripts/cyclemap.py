# perf script -F pid,tid,ip,sym output of `perf record -e cycles -g`: the samples on the main thread (pid == tid) and on
# the lanes, by leaf symbol, and the kernel's samples by the first user frame under them.
import sys, collections
leaf = collections.Counter(); under = collections.Counter(); total = collections.Counter()
role = None; frames = []
def flush():
    global frames
    if role is not None and frames:
        total[role] += 1
        leaf[(role, frames[0][1])] += 1
        if frames[0][0]:
            user = next((f[1] for f in frames if not f[0]), '?')
            under[(role, user)] += 1
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
for r in ('main', 'lane'):
    print('%s: %d samples' % (r, total[r]))
    for (rr, sym), n in sorted(((k, v) for k, v in leaf.items() if k[0] == r), key=lambda x: -x[1])[:25]:
        print('  %6d %5.1f%% %s' % (n, 100.0 * n / max(total[r], 1), sym))
    print('  kernel samples by the user frame under them:')
    for (rr, sym), n in sorted(((k, v) for k, v in under.items() if k[0] == r), key=lambda x: -x[1])[:15]:
        print('  %6d %5.1f%% %s' % (n, 100.0 * n / max(total[r], 1), sym))
