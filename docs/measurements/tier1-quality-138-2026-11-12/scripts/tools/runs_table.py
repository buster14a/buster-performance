#!/usr/bin/env python3
# runs_table.py RUNS.tsv [REFERENCE [SECOND]]: the medians of runs.sh's measured runs by build: speedtest1's and the sum
# of the five scripts' medians, in task-clock ms, user cycles (M), instructions (M) and branch misses (M), each build
# against REFERENCE (O2) and SECOND (tier1) in cycles. Tab-separated on standard output.
import sys, statistics, collections
path = sys.argv[1]
reference = sys.argv[2] if len(sys.argv) > 2 else 'O2'
second = sys.argv[3] if len(sys.argv) > 3 else 'tier1'
cells = collections.defaultdict(list)
order = []
failed = 0
for line in open(path):
    phase, rnd, program, build, clock, cycles, instructions, branches, misses, status = line.rstrip('\n').split('\t')
    if build not in order:
        order.append(build)
    if status != '0':
        failed += 1
    if phase != 'measured':
        continue
    cells[(build, program)].append((float(clock), int(cycles), int(instructions), int(branches), int(misses)))
scripts = ['calls', 'tables', 'strings', 'arithmetic', 'closures']
def med(build, program, k):
    return statistics.median(v[k] for v in cells[(build, program)])
def row(build):
    st = [med(build, 'speedtest1', k) for k in range(5)]
    lua = [sum(med(build, s, k) for s in scripts) for k in range(5)]
    return st, lua
rows = {b: row(b) for b in order}
ref = rows[reference]; sec = rows[second]
print('# failed runs:', failed, ' rounds:', len(cells[(order[0], 'speedtest1')]))
print('\t'.join(['build', 'st ms', 'st cycles M', 'st instr M', 'st misses M', 'st/' + reference, 'st gap closed',
                 'lua ms', 'lua cycles M', 'lua instr M', 'lua misses M', 'lua/' + reference, 'lua gap closed']))
for b in order:
    st, lua = rows[b]
    def closed(x, i):
        # The share of tier1's cycle gap to the reference that this build closes (1 = the reference, 0 = tier1).
        gap = sec[i][1] - ref[i][1]
        return (sec[i][1] - x) / gap if gap else float('nan')
    print('\t'.join([b, f'{st[0]:.1f}', f'{st[1] / 1e6:.1f}', f'{st[2] / 1e6:.1f}', f'{st[4] / 1e6:.2f}', f'{st[1] / ref[0][1]:.3f}', f'{closed(st[1], 0):.2f}',
                     f'{lua[0]:.1f}', f'{lua[1] / 1e6:.1f}', f'{lua[2] / 1e6:.1f}', f'{lua[4] / 1e6:.2f}', f'{lua[1] / ref[1][1]:.3f}', f'{closed(lua[1], 1):.2f}']))
