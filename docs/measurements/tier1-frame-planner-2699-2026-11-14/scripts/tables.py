# Prints this record's tables from 9700x/*.log: python3 scripts/tables.py (from the record's directory).
import re, statistics

def frames(path):
    table = {}
    shape = None
    for line in open(path):
        line = line.strip()
        m = re.match(r'tier1-frame shape=(\S+) objects=(\d+)', line)
        if m:
            shape = (m.group(1), int(m.group(2)))
            continue
        m = re.match(r'phase=(\S+) path=(\S+) ns/object=(\S+) ns/function=(\S+) objects/s=\S+ cycles/object=(\S+)', line)
        if m and shape:
            table[(shape[0], m.group(1), m.group(2))] = (float(m.group(4)), float(m.group(5)), shape[1])
    return table

def sizes(path):
    table = {}
    count = None
    shape = None
    for line in open(path):
        line = line.strip()
        m = re.match(r'count (\d+)', line)
        if m:
            count = int(m.group(1))
            continue
        m = re.match(r'tier1-frame shape=(\S+) objects=(\d+)', line)
        if m:
            shape = m.group(1)
            continue
        m = re.match(r'phase=(\S+) path=(\S+) ns/object=(\S+) ns/function=(\S+)', line)
        if m and count is not None:
            table[(count, shape, m.group(1), m.group(2))] = float(m.group(4))
    return table

def stat(path):
    table = {}
    run = None
    for line in open(path):
        line = line.strip()
        if line.startswith('run '):
            run = line[4:]
        m = re.match(r'^([0-9.]+),(?:msec)?,(cycles:u|instructions:u|task-clock)', line)
        if m and run:
            table.setdefault((run, m.group(2)), []).append(float(m.group(1)))
    return table

def probe(path):
    runs = {}
    run = 'vector'
    seen = 0
    for line in open(path):
        m = re.match(r'run (\S+) (\S+)', line.strip())
        if m:
            run = (m.group(1), m.group(2))
            continue
        m = re.search(r'ticks=(\d+) calls=1368 ', line)
        if m:
            key = run if isinstance(run, tuple) else ('', 'vector' if seen < 7 else 'scalar')
            runs.setdefault(key, []).append(int(m.group(1)))
            seen += 1
    return runs

builds = ['main', 'head-a', 'head-b']
print('## benchmark-tier1-frame, ns per function (both rounds)\n')
for phase in ('prepare', 'color', 'layout', 'total'):
    print('| %s | objects | %s |' % (phase, ' | '.join('%s %s' % (b, p) for b in builds for p in ('scalar', 'vector'))))
    print('| --- | ---: | %s |' % ' | '.join('---:' for _ in range(len(builds) * 2)))
    rounds = {b: [frames('9700x/frame-%s-%d.log' % (b, r)) for r in (1, 2)] for b in builds}
    for shape in ('leaf', 'calls', 'variadic', 'dynamic-realigned'):
        cells = []
        objects = 0
        for b in builds:
            for p in ('scalar', 'vector'):
                values = [t[(shape, phase, p)] for t in rounds[b] if (shape, phase, p) in t]
                objects = values[0][2] if values else objects
                cells.append(' / '.join('%.1f' % v[0] for v in values))
        print('| %s | %d | %s |' % (shape, objects, ' | '.join(cells)))
    print()
print('## color phase, cycles per object (both rounds)\n')
print('| shape | %s |' % ' | '.join('%s %s' % (b, p) for b in builds for p in ('scalar', 'vector')))
print('| --- | %s |' % ' | '.join('---:' for _ in range(len(builds) * 2)))
rounds = {b: [frames('9700x/frame-%s-%d.log' % (b, r)) for r in (1, 2)] for b in builds}
for shape in ('leaf', 'calls', 'variadic', 'dynamic-realigned'):
    cells = []
    for b in builds:
        for p in ('scalar', 'vector'):
            cells.append(' / '.join('%.2f' % t[(shape, 'color', p)][1] for t in rounds[b] if (shape, 'color', p) in t))
    print('| %s | %s |' % (shape, ' | '.join(cells)))
print()
print('## Frame sizes (--count), the indexed `calls` shape, ns per function\n')
main = sizes('9700x/sizes-main.log')
head = sizes('9700x/sizes-head-b.log')
print('| objects | main prepare | head-b prepare | main color | head-b color | main layout | head-b layout | main total | head-b total | head-b scalar total |')
print('| ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |')
for count in (1, 2, 4, 8, 16, 32, 33, 48, 64, 128):
    g = lambda table, phase, path: table.get((count, 'calls', phase, path), float('nan'))
    print('| %d | %.1f | %.1f | %.1f | %.1f | %.1f | %.1f | %.1f | %.1f | %.1f |' % (count, g(main, 'prepare', 'vector'), g(head, 'prepare', 'vector'),
        g(main, 'color', 'vector'), g(head, 'color', 'vector'), g(main, 'layout', 'vector'), g(head, 'layout', 'vector'), g(main, 'total', 'vector'),
        g(head, 'total', 'vector'), g(head, 'total', 'scalar')))
print()
print('## Whole compile, `--tier1 -c sqlite3.c --lanes 1` on CPU 2 (7 interleaved runs each)\n')
print('| run | build | cycles:u median (min to max) | instructions:u median | task-clock ms median |')
print('| --- | --- | ---: | ---: | ---: |')
for tag in ('a', 'b'):
    table = stat('9700x/stat-%s.log' % tag)
    for build in ('main', 'head-' + tag):
        c = table[(build, 'cycles:u')]
        print('| %s | %s | %.0f (%.0f to %.0f) | %.0f | %.0f |' % (tag, build, statistics.median(c), min(c), max(c),
            statistics.median(table[(build, 'instructions:u')]), statistics.median(table[(build, 'task-clock')])))
print()
print('## The planner\'s TSC ticks in one compile\n')
for name in ('probe-sqlite', 'probe-sqlite-a', 'probe-sqlite-b', 'probe2-b'):
    try:
        runs = probe('9700x/%s.log' % name)
    except FileNotFoundError:
        continue
    for key in sorted(runs):
        v = runs[key]
        print('- %s %s %s: median %d (%d to %d), %d runs' % (name, key[0], key[1], statistics.median(v), min(v), max(v), len(v)))
