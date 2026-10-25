# parse.py DIRECTORY: reads #270's A/B logs (run.log to run5.log, or run.txt to run5.txt, from run.sh to run5.sh) and
# prints Markdown: the builds, the generated code's identity, every benchmark metric's per-round values for both
# trees with the medians, the change of the medians and the range of the per-round changes (head against base in the
# same round), the whole drivers' processes, link-foreign, the sort phase's counters (the first study's plan) and the
# extra rounds of benchmark-checker-source (the current pair's run5.sh), in a table of their own.
import os, re, sys, collections, statistics

directory = sys.argv[1]
def read(name):
    text = ''
    for path in (os.path.join(directory, name + '.log'), os.path.join(directory, name + '.txt')):
        if not text and os.path.exists(path):
            text = open(path).read()
    return text
run, run2, run3, run4, run5 = read('run'), read('run2'), read('run3'), read('run4'), read('run5')
out = []

def med(values):
    return statistics.median(values) if values else float('nan')

def pct(new, old):
    return 100.0 * (new - old) / old

def fmt(value, reference):
    return f'{value:,.0f}' if reference >= 1000 else (f'{value:.2f}' if reference >= 10 else f'{value:.3f}')

# Builds.
builds = collections.defaultdict(list)
for m in re.finditer(r'^== build round (\d+) tree (\w+) debug (\d) .*?\n(.*?)(?=^== |\Z)', run, re.M | re.S):
    body = m.group(4)
    compiled = re.search(r'^build\.sh: (\d+) sources compiled in ([\d.]+) s; the longest: (\S+) ([\d.]+) s, (\S+) ([\d.]+) s, (\S+) ([\d.]+) s', body, re.M)
    wall = re.search(r'^build wall: ([\d.]+) s, user ([\d.]+) s, system ([\d.]+) s', body, re.M)
    exe = re.search(r'^executable: (\d+) bytes; text (\d+), data (\d+), bss (\d+); (\d+) functions', body, re.M)
    if 'build failed' in body or not (compiled and wall and exe):
        out.append(f'**build failed or incomplete**: round {m.group(1)} tree {m.group(2)} debug {m.group(3)}')
        continue
    builds[(m.group(2), m.group(3))].append({
        'round': int(m.group(1)),
        'compiled': float(compiled.group(2)),
        'longest': [(compiled.group(3 + 2 * k), float(compiled.group(4 + 2 * k))) for k in range(3)],
        'wall': float(wall.group(1)),
        'cpu': float(wall.group(2)) + float(wall.group(3)),
        'bytes': int(exe.group(1)),
        'text': int(exe.group(2)),
    })
if builds:
    out.append('### Builds')
    out.append('')
    out.append('| Configuration | Tree | `build.sh` wall, each round | Median | CPU (median) | Longest compiles (median) |')
    out.append('| --- | --- | --- | ---: | ---: | --- |')
    for debug, name in (('1', 'debug information'), ('0', '`BUSTER_DEBUG_INFO=0`')):
        for tree in ('base', 'head'):
            rows = sorted(builds[(tree, debug)], key=lambda r: r['round'])
            if rows:
                longest = ', '.join(f"{unit.replace('main_unit_', '').replace('.c', '')} {med([r['longest'][k][1] for r in rows]):.1f} s"
                                    for k, (unit, _) in enumerate(rows[-1]['longest']))
                walls = ', '.join('%.2f' % r['wall'] for r in rows)
                out.append(f"| {name} | {tree} | {walls} s | {med([r['wall'] for r in rows]):.2f} s | {med([r['cpu'] for r in rows]):.0f} s | {longest} |")
        b, h = builds[('base', debug)], builds[('head', debug)]
        if b and h:
            out.append(f"| {name} | change | | {pct(med([r['wall'] for r in h]), med([r['wall'] for r in b])):+.1f}% | "
                       f"{pct(med([r['cpu'] for r in h]), med([r['cpu'] for r in b])):+.1f}% | |")
    out.append('')

# Identity.
identity = re.findall(r'^(identity: .*|differs: .*|\w+ outputs: .*|(?:base|head) [^:]*: status \d+.*)$', run, re.M)
if identity:
    out.append('### Generated code')
    out.append('')
    out.extend(f'- {line}' for line in identity)
    out.append('')

# ab's runs: (log, round, tree, config, text).
def ab_runs(log):
    parts = re.split(r'^== round (\d+) tree (\S+) config \[(.*)\]\n', log, flags=re.M)
    for i in range(1, len(parts) - 3, 4):
        yield int(parts[i]), 'head' if parts[i + 1].endswith('/head') else 'base', parts[i + 2], parts[i + 3]

values = collections.defaultdict(lambda: collections.defaultdict(dict))
def put(group, key, tree, round_, value):
    values[(group, key)][tree][round_] = value

def time_runs_name(arguments):
    if arguments.startswith('-E '):
        return '`-E` sqlite3.c'
    if arguments.startswith('parse '):
        return '`parse -fsyntax-only` sqlite3.c'
    if arguments.startswith('-fsyntax-only') and arguments.endswith('sqlite3.c'):
        return '`-fsyntax-only` sqlite3.c'
    if arguments.startswith('-fsyntax-only') and '-funsigned-char' in arguments:
        return None
    if arguments.startswith('-fsyntax-only'):
        return '`-fsyntax-only` main.c (4 unsupported constructs: status 1)'
    if arguments.startswith('-o '):
        return 'compile and link 00216.c'
    if arguments.startswith('-c '):
        return '`-c` 00216.c'
    return arguments[:40]

statuses = collections.Counter()
for log, prefix in ((run, ''), (run2, ''), (run3, ''), (run5, 'more rounds: ')):
    for round_, tree, config, text in ab_runs(log):
        name = config.split()[0]
        if name == 'benchmark-checker-source':
            for m in re.finditer(r'body_graph: path=(\w+) ns_per_node=([\d.]+) cycles_per_node=([\d.]+)', text):
                put(prefix + 'checker-source', m.group(1) + ', ns/node', tree, round_, float(m.group(2)))
                put(prefix + 'checker-source', m.group(1) + ', cycles/node', tree, round_, float(m.group(3)))
        elif name == 'benchmark-checker-bindings':
            for m in re.finditer(r'check_input: mode=([\w-]+) ns=\d+ .*?ns_per_token=([\d.]+)', text):
                put('checker-bindings', m.group(1) + ', ns/token', tree, round_, float(m.group(2)))
        elif name == 'benchmark-parser-bindings':
            for m in re.finditer(r'^  ([\w-]+): ([\d.]+) ms/unit', text, re.M):
                put('parser-bindings', m.group(1) + ', ms', tree, round_, float(m.group(2)))
        elif name == 'benchmark-gnu':
            for m in re.finditer(r'^([\w-]+)\s+([\d.]+)\s+[\d.]+\s+[\d.]+$', text, re.M):
                put('gnu', m.group(1) + ', ns/token', tree, round_, float(m.group(2)))
        elif name == 'benchmark-assembler':
            for m in re.finditer(r'^(scalar|vector)\s+([\d.\s]+)$', text, re.M):
                # lex, parse, match, layout, encode/link, object, total, then CFI where the benchmark has it.
                put('assembler', m.group(1) + ' total, ms', tree, round_, float(m.group(2).split()[6]))
        elif name == 'benchmark-foreign-strings':
            for m in re.finditer(r'foreign-strings (\w+) count (\d+) units \d+ ([\w-]+) runs \d+: .*?total ([\d.]+) us', text):
                put('foreign-strings', f'{m.group(1)} {m.group(2)} {m.group(3)}, µs', tree, round_, float(m.group(4)))
        elif name == 'benchmark-debug':
            for m in re.finditer(r'^  (scalar|vector): ([\d.]+) ns/row', text, re.M):
                put('debug', m.group(1) + ', ns/row', tree, round_, float(m.group(2)))
        elif name == 'benchmark-lexer':
            for m in re.finditer(r'^\s+(c_tokenize\w*)\s+([\d.]+) ms\s+[\d.]+ GB/s\s+([\d.]+) cycles/B.*?([\d.]+) instructions/B', text, re.M):
                put('lexer', m.group(1) + ', ms', tree, round_, float(m.group(2)))
                put('lexer', m.group(1) + ', instructions/B', tree, round_, float(m.group(4)))
        elif name == 'benchmark-x86-encoder':
            for m in re.finditer(r'^\s*(x86_encode\w*)\s+([\d.]+)', text, re.M):
                put('x86-encoder', m.group(1) + ', ns', tree, round_, float(m.group(2)))
        elif name == 'time-runs':
            for m in re.finditer(r'^run \d+ list (\d+): .*status (\d+)$', text, re.M):
                statuses[(tree, m.group(2))] += 1
            for m in re.finditer(r'^list \d+ \[(.*?)\]: \d+ runs, median ([\d.]+) ms wall \([\d.]+ to [\d.]+\), ([\d.]+) ms user, ([\d.]+) ms system, (\d+) KB peak, (\d+) minor faults', text, re.M):
                label = time_runs_name(m.group(1))
                if label is not None:
                    put('driver ' + label, 'wall, ms', tree, round_, float(m.group(2)))
                    put('driver ' + label, 'user + system, ms', tree, round_, float(m.group(3)) + float(m.group(4)))
                    put('driver ' + label, 'peak resident, KB', tree, round_, float(m.group(5)))
                    put('driver ' + label, 'minor faults', tree, round_, float(m.group(6)))
        elif name == 'benchmark-link':
            program = None
            for line in text.splitlines():
                header = re.match(r'^(\d+) workers? in (\d+) units?, .*linked as (.*):$', line)
                row = re.match(r'^\s+link-foreign, (its threads|1 thread)\s+([\d.]+) us: min [\d.]+, max [\d.]+ of \d+ runs; \d+ bytes, (\d+) page faults, ([\d.]+) MB peak resident', line)
                if header:
                    program = f'{int(header.group(1)):,} workers, {header.group(3)}'
                elif row and program:
                    put('link-foreign ' + program, row.group(1) + ', µs', tree, round_, float(row.group(2)))
                    put('link-foreign ' + program, row.group(1) + ', peak MB', tree, round_, float(row.group(4)))

def table(title, groups):
    rows = [(g, k) for (g, k) in sorted(values) if any(g.startswith(p) for p in groups)]
    if not rows:
        return
    out.append(title)
    out.append('')
    out.append('| Workload | Metric | main, each round | head, each round | main median | head median | Change | Per-round changes |')
    out.append('| --- | --- | --- | --- | ---: | ---: | ---: | --- |')
    for group, key in rows:
        b, h = values[(group, key)].get('base', {}), values[(group, key)].get('head', {})
        if not b or not h:
            continue
        # Only the rounds both trees ran: a study stopped in a round has the round's first runs alone.
        rounds = sorted(set(b) & set(h))
        if not rounds:
            continue
        mb, mh = med([b[r] for r in rounds]), med([h[r] for r in rounds])
        changes = [pct(h[r], b[r]) for r in rounds if b[r] != 0]
        spread = f'{min(changes):+.1f}% to {max(changes):+.1f}%' if changes else ''
        change = f'{pct(mh, mb):+.1f}%' if mb != 0 else ''
        out.append(f"| {group.replace('driver ', '')} | {key} | {', '.join(fmt(b[r], mb) for r in rounds)} | {', '.join(fmt(h[r], mb) for r in rounds)} | "
                   f"{fmt(mb, mb)} | {fmt(mh, mb)} | {change} | {spread} |")
    out.append('')

table('### Benchmarks', ('checker', 'parser-bindings', 'gnu', 'assembler', 'foreign-strings', 'debug', 'lexer', 'x86-encoder'))
table('### Whole drivers (`time-runs`, each round the median of its processes)', ('driver ',))
if statuses:
    out.append('time-runs processes by status: ' + ', '.join(f'{tree} status {status}: {count}' for (tree, status), count in sorted(statuses.items())) +
               ' (the refused `-funsigned-char` list of `main.c` left out of the table)')
    out.append('')
table('### link-foreign (`benchmark-link --only linkers`)', ('link-foreign',))
table('### `benchmark-checker-source` again, six more rounds (run5.sh)', ('more rounds: ',))

# The sort phase's counters.
counters = collections.defaultdict(lambda: collections.defaultdict(list))
for m in re.finditer(r'^== round (\d+) tree (\w+)\n(.*?)(?=^== round|\Z)', run4, re.M | re.S):
    tree, body = m.group(2), m.group(3)
    sort = re.search(r'^  sort: ([\d.]+) ms/unit', body, re.M)
    if sort:
        counters[tree]['sort, ms'].append(float(sort.group(1)))
    for c in re.finditer(r'^(\d+),[^,]*,(cycles|instructions|r1000001a0|r100001ea0),\d+,([\d.]+),', body, re.M):
        counters[tree][c.group(2)].append(int(c.group(1)))
        counters[tree][c.group(2) + ' running %'].append(float(c.group(3)))
if counters:
    out.append('### The sort phase alone (`benchmark-parser-bindings --only sort --passes 101` under `perf stat`)')
    out.append('')
    out.append('| Tree | sort, ms | cycles | instructions | IPC | front end: no ops dispatched (slots) | back end: stalled (slots) |')
    out.append('| --- | --- | --- | --- | --- | --- | --- |')
    for tree in ('base', 'head'):
        c = counters[tree]
        if c['cycles']:
            ipc = ', '.join(f'{i / k:.2f}' for i, k in zip(c['instructions'], c['cycles']))
            out.append(f"| {tree} | {', '.join(f'{v:.3f}' for v in c['sort, ms'])} | {', '.join(f'{v / 1e9:.3f} G' for v in c['cycles'])} | "
                       f"{', '.join(f'{v / 1e9:.3f} G' for v in c['instructions'])} | {ipc} | {', '.join(f'{v / 1e9:.3f} G' for v in c['r1000001a0'])} | "
                       f"{', '.join(f'{v / 1e9:.3f} G' for v in c['r100001ea0'])} |")
    running = [v for tree in counters for key, vs in counters[tree].items() if key.endswith('running %') for v in vs]
    if running:
        out.append('')
        out.append(f'Counters running: {min(running):.2f}% to {max(running):.2f}% of the time (100% is no multiplexing).')
    out.append('')
print('\n'.join(out))
