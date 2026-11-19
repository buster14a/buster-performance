# #2924 C12c's gate: the logs of gate.sh (logs/time-gG-LIST.log) to a table: each build's user cycles against none's,
# round by round, and its instructions' median against none's, per list.
import re, sys, glob, statistics, collections, os

NAMES = {'bit10': 'reader', 'bit11': 'bindings', 'bit12': 'warnings', 'bit13': 'attested', 'bit14': 'core',
         'bit15': 'program', 'bit16': 'lowering', 'bit17': 'aliases', 'bit18': 'emission', 'bit19': 'selection',
         'bit20': 'asm', 'bit21': 'driver', 'bit22': 'foreign: front end', 'bit23': 'static data',
         'bit24': 'lazy planner (control)', 'bit25': 'node machine', 'bit26': 'checker Tier 1',
         'bit27': 'foreign: builtins lowering', 'bit28': 'foreign: emission', 'roots': 'C12 roots', 'areas': 'all areas',
         'none-again': 'none again (control)'}
run = re.compile(r'run \d+ list \d+ (\S+): ([\d.]+) ms wall, .* (\d+) user cycles, (\d+) instructions, status (\d+)')

def parse(path):
    rounds = []
    for line in open(path):
        if line.startswith('== round'):
            rounds.append(collections.defaultdict(list))
            continue
        m = run.match(line)
        if m and rounds:
            rounds[-1][m.group(1)].append((int(m.group(3)), int(m.group(4)), int(m.group(5))))
    return rounds

d = sys.argv[1] if len(sys.argv) > 1 else 'logs'
table = collections.defaultdict(dict)
order = []
for path in sorted(glob.glob(os.path.join(d, 'time-g*-*.log'))):
    list_name = path.rsplit('-', 1)[1][:-4]
    rounds = parse(path)
    builds = [b for b in rounds[0] if b != 'none'] if rounds else []
    for b in builds:
        if b not in order:
            order.append(b)
        cyc = []
        ins = []
        bad = 0
        for r in rounds:
            base = statistics.median(x[0] for x in r['none'])
            cyc.append(100 * (statistics.median(x[0] for x in r[b]) / base - 1))
            ins.append(statistics.median(x[1] for x in r[b]) - statistics.median(x[1] for x in r['none']))
            bad += sum(x[2] != 0 for x in r[b])
        key = (b, os.path.basename(path).split('-')[1])
        table[b][list_name] = (cyc, statistics.median(ins), len(rounds), bad)
print(f"{'build':34s} {'sqlite3.c':28s} {'Lua':28s} {'musl':28s} instructions (M: sqlite3.c, Lua, musl)")
for b in order:
    cells = []
    insc = []
    for l in ('sqlite', 'lua', 'musl'):
        if l in table[b]:
            cyc, ins, n, bad = table[b][l]
            cells.append(', '.join(f'{c:+.2f}' for c in cyc) + ('' if not bad else f' ({bad} failed)'))
            insc.append(f'{ins / 1e6:+.2f}')
        else:
            cells.append('-')
            insc.append('-')
    print(f"{NAMES.get(b, b) + ' (' + b + ')':34s} {cells[0]:28s} {cells[1]:28s} {cells[2]:28s} {', '.join(insc)}")
