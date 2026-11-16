import collections, statistics
funcs = {}   # address -> [size, name, unit]
cur = None
for line in open('symbols.txt', errors='replace'):
    p = line.split()
    if len(p) >= 8 and p[0].endswith(':'):
        if p[3] == 'FILE':
            cur = p[7]
        elif p[3] == 'FUNC' and p[6] != 'UND':
            try: a = int(p[1], 16); s = int(p[2], 0)
            except ValueError: continue
            if s == 0 or p[7].endswith('.buster_split'): continue
            unit = cur if (p[4] == 'LOCAL' and cur and (cur == 'main.c' or cur.startswith('main_unit_'))) else None
            if a not in funcs or funcs[a][0] < s: funcs[a] = [s, p[7], unit]
CHECK = (0xe18000, 0xe18000 + 0x5a2b35)
def read(path):
    traces = []
    for line in open(path):
        line = line.strip()
        if line == 'trace': traces.append([])
        elif line: traces[-1].append(int(line, 16))
    return traces
files = [('syntax', read('syntax.txt')), ('preprocess', read('preprocess.txt')), ('tiny', read('tiny.txt')), ('hello', read('hello.txt')), ('musl', read('musl.txt')), ('sqlite', read('sqlite.txt'))]
def windows_now(t):
    w = set()
    for a in t:
        s = funcs[a][0]
        for x in range(a >> 16, ((a + s - 1) >> 16) + 1): w.add(x)
    return len(w)
def layout(order):
    # three regions: start (unit locals outside the checker section), checker (listed first), text by-name first
    pos = {}
    start = 0; checker = 0; name = 0
    for a in order:
        s = funcs[a][0]
        s16 = (s + 15) & ~15
        in_checker = CHECK[0] <= a < CHECK[1]
        if in_checker:
            pos[a] = ('c', checker); checker += s16
        elif funcs[a][2] is not None:
            pos[a] = ('s', start); start += s16
        else:
            pos[a] = ('n', name); name += s16
    return pos, start, checker, name
def windows_new(t, pos, bases):
    w = set(); miss = 0
    for a in t:
        if a not in pos:
            # an unlisted function: where it is now
            s = funcs[a][0]
            for x in range(a >> 16, ((a + s - 1) >> 16) + 1): w.add(('old', x))
            miss += 1
            continue
        r, off = pos[a]
        b = bases[r] + off
        s = funcs[a][0]
        for x in range(b >> 16, ((b + s - 1) >> 16) + 1): w.add(x)
    return len(w), miss
def order_ranked(files):
    seen = {}; order = []
    for name, traces in files:
        count = collections.Counter()
        for t in traces:
            for a in set(t): count[a] += 1
        new = [a for a in count if a not in seen]
        new.sort(key=lambda a: (-count[a], a))
        for a in new: seen[a] = name
        order += new
    return order
def order_first(files):
    seen = {}; order = []
    for name, traces in files:
        new = sorted({a for t in traces for a in t if a not in seen})
        for a in new: seen[a] = name
        order += new
    return order
for label, order in [('by first file, address order', order_first(files)), ('ranked within musl', order_ranked(files))]:
    pos, start, checker, name = layout(order)
    # the start section begins on a 2 MB boundary; the checker's on the next page after it; .text after the whole checker section (5,770 KB)
    bases = {'s': 0x1000000, 'c': (0x1000000 + start + 4095) & ~4095}
    bases['n'] = bases['c'] + 0x5a2b35 + 64
    print(f"== {label}: start {start/1024:.0f} KB, checker listed {checker/1024:.0f} KB, by name {name/1024:.0f} KB")
    for fname, traces in files:
        now = [windows_now(t) for t in traces]
        new = [windows_new(t, pos, bases)[0] for t in traces]
        if len(traces) == 1:
            print(f"   {fname}: windows now {now[0]}, new {new[0]}")
        else:
            print(f"   {fname}: windows now mean {statistics.mean(now):.1f} (median {statistics.median(now)}), new mean {statistics.mean(new):.1f} (median {statistics.median(new)}), min {min(new)} max {max(new)}")
