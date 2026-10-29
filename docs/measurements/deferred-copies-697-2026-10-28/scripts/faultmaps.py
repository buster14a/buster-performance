# perf script --show-mmap-events -F tid,addr,ip,sym output of `perf record -e page-faults -c 1 -d --data-mmap -g`:
# each fault on a lane (tid != pid) whose kernel path is a huge page's (do_huge_pmd_*), by the anonymous mapping that
# holds its address (by the mapping's size, which names the arena) and the user function under it.
import sys, re, collections
maps = []
pid = None
counts = collections.Counter()
sample = None
def flush():
    global sample
    if sample is not None:
        tid, addr, frames = sample
        huge = any('do_huge_pmd' in f for f in frames)
        user = next((f for f in reversed(frames) if not f.startswith('[k]')), '?')
        size = None
        for start, length in maps:
            if start <= addr < start + length:
                size = length
        counts[(tid == pid, huge, size, user)] += 1
    sample = None
for line in sys.stdin:
    if 'PERF_RECORD_MMAP' in line:
        m = re.search(r'\[(0x[0-9a-f]+)\((0x[0-9a-f]+)\)', line)
        if m:
            maps.append((int(m.group(1), 16), int(m.group(2), 16)))
        p = re.search(r' (\d+)/(\d+):', line)
        if p and pid is None:
            pid = int(p.group(1))
        continue
    s = line.strip()
    if not s:
        flush(); continue
    m = re.match(r'(\d+)\s+([0-9a-f]+)\s*$', s)
    if m and sample is None:
        sample = (int(m.group(1)), int(m.group(2), 16), [])
        continue
    if sample is not None:
        parts = s.split()
        if len(parts) >= 2:
            sample[2].append(('[k]' if parts[0].startswith('ffffffff') else '') + parts[1])
flush()
for (main, huge, size, user), n in counts.most_common(25):
    print('%5d %s %s mapping=%s user=%s' % (n, 'main' if main else 'lane', 'huge' if huge else 'base', '%#x' % size if size else '?', user))
