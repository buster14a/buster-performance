# perf script -F pid,tid,ip,sym output of `perf record -e cycles -g`: the lanes' kernel samples under each of the user
# frames named on the command line, by their kernel frames (leaf first, up to five).
import sys, collections
wanted = set(sys.argv[1:])
chains = collections.Counter()
role = None; frames = []
def flush():
    global frames
    if role == 'lane' and frames and frames[0][0]:
        user = next((f[1] for f in frames if not f[0]), '?')
        if user in wanted:
            kernel = [f[1] for f in frames if f[0]][:6]
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
for (user, chain), n in chains.most_common(30):
    print('%4d %-26s %s' % (n, user, chain))
