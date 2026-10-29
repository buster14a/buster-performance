# perf script --show-mmap-events -F tid,addr,ip,sym output of `perf record -e page-faults -c 1 -d --data-mmap -g`: each
# fault, on the main thread or a lane (tid != pid), by whether its kernel path is a huge page's (do_huge_pmd_*), the
# size of the anonymous mapping that holds its address (0x3600000000 a lane's mapping, 0x1000200000 a 64 GB arena: the
# state's own, a thread's scratch or the benchmark's) and the first two user frames under it; then the lanes' faults by
# the lane mapping's arena that holds them (by offset: output, scratch, results, types, type index, names).
import sys, re, collections
LANE = 0x3600000000
ARENAS = [('output', 1 << 36), ('scratch', 1 << 36), ('results', 1 << 36), ('types', 1 << 34), ('type_index', 1 << 32), ('names', 1 << 32)]
maps = []
pid = None
counts = collections.Counter()
arenas = collections.Counter()
sample = None
def arena_of(start, addr):
    offset = addr - start
    for name, size in ARENAS:
        if offset < size:
            return name
        offset -= size
    return '?'
def flush():
    global sample
    if sample is not None:
        tid, addr, frames = sample
        huge = any('do_huge_pmd' in f for f in frames)
        users = [f for f in frames if not f.startswith('[k]')]
        size = None
        start = None
        for s0, length in maps:
            if s0 <= addr < s0 + length:
                size = length
                start = s0
        main = tid == pid
        counts[(main, huge, size, ' <- '.join(users[:2]) if users else '?')] += 1
        if size == LANE and not main:
            arenas[(arena_of(start, addr), users[0] if users else '?')] += 1
    sample = None
for raw in sys.stdin:
    line = raw.rstrip('\n')
    if 'PERF_RECORD_MMAP' in line:
        flush()
        m = re.search(r'\[(0x[0-9a-f]+)\((0x[0-9a-f]+)\)', line)
        if m:
            maps.append((int(m.group(1), 16), int(m.group(2), 16)))
        p = re.search(r' (\d+)/(\d+):', line)
        if p and pid is None and p.group(1) != '-1':
            pid = int(p.group(1))
        continue
    if not line.strip():
        flush()
        continue
    if raw[0] in '0123456789':
        flush()
        parts = line.split()
        if len(parts) >= 2 and re.match(r'^[0-9a-f]+$', parts[1]):
            sample = (int(parts[0]), int(parts[1], 16), [])
        continue
    if sample is not None:
        parts = line.split()
        if len(parts) >= 2:
            sample[2].append(('[k]' if parts[0].startswith('ffffffff') else '') + parts[1])
flush()
total = collections.Counter()
for (main, huge, size, user), n in counts.items():
    total[main] += n
print('faults: main %d, lanes %d' % (total[True], total[False]))
for (main, huge, size, user), n in counts.most_common(40):
    print('%6d %s %s mapping=%s user=%s' % (n, 'main' if main else 'lane', 'huge' if huge else 'base', '%#x' % size if size else '?', user))
print("the lanes' faults in their mappings, by arena and user frame:")
for (arena, user), n in arenas.most_common(30):
    print('%6d %-10s %s' % (n, arena, user))
