#!/usr/bin/env python3
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
#
# second.py LOG: what became of the callee-saved preference's second allocation, from a laps3.patch lap log's F and G
# lines: the functions by outcome, with their share of the first allocation's time (laps); whether the second
# allocation's intervals were the first's; and how many functions' first allocation can evict nothing (its peak
# pressure in each class no more than the registers every interval may take), with their share of the first
# allocation's assignment time.
import gzip, sys, collections
sys.path.insert(0, __import__('os').path.dirname(__file__))
import laps

def main():
    path = sys.argv[1]
    log = laps.read(path)
    extra = {}
    with laps.open_text(path) as f:
        for line in f:
            p = line.rstrip('\n').split('\t')
            if p[0] == 'G':
                keys = ['crossing', 'second', 'same_intervals', 'calls', 'fixed_ranges', 'fragments', 'moves', 'spills', 'scan_intervals', 'common_intervals', 'splits',
                        'pressure0', 'pressure1', 'pressure2', 'registers0', 'fixed_general', 'pinned', 'quiet', 'required_most', 'pinned_end', 'pinned_pressure']
                extra[int(p[1])] = dict(zip(keys, (int(x) for x in p[2:])))
    _, by_function = laps.totals(log)
    def ms(f, prefix):
        return sum(t for n, t in by_function.get(f, {}).items() if n.startswith(prefix)) / log.ticks_per_ns / 1e6
    names = {0: 'none asked', 1: 'taken', 2: 'refused: splits', 3: 'refused: a temporary slot', 4: 'refused: a constraint', 5: 'refused: capacity', 6: 'refused: another error'}
    rows = collections.defaultdict(lambda: [0, 0.0, 0.0, 0.0, 0])
    total1 = total2 = 0.0
    general = [f for f in log.functions if not log.functions[f]['chain'] and log.functions[f]['tier1']]
    for f in general:
        g = extra[f]
        a1, a2 = ms(f, 'alloc1.'), ms(f, 'alloc2.')
        tail1 = ms(f, 'alloc1.assign') + ms(f, 'alloc1.lookup') + ms(f, 'alloc1.edges')
        r = rows[g['second']]
        r[0] += 1; r[1] += a1; r[2] += a2; r[3] += tail1; r[4] += g['same_intervals']
        total1 += a1; total2 += a2
    print(f'# {path}: {len(log.functions)} functions, {len(general)} through the CFG consumer; allocation 1 {total1:.3f} ms, allocation 2 {total2:.3f} ms')
    print('second allocation\tfunctions\tallocation 1 ms\tallocation 2 ms\tallocation 1 assignment, lookup and edges ms\tsame intervals')
    for k in sorted(rows):
        r = rows[k]
        print(f'{names[k]}\t{r[0]}\t{r[1]:.3f}\t{r[2]:.3f}\t{r[3]:.3f}\t{r[4]}')
    # No eviction possible in the first allocation: every class's peak pressure fits the registers any interval may take.
    quiet = [f for f in general if extra[f]['pressure0'] <= extra[f]['registers0'] - extra[f]['fixed_general'] and extra[f]['pressure1'] == 0 and extra[f]['pressure2'] == 0]
    taken = [f for f in general if extra[f]['second'] == 1]
    quiet_taken = [f for f in quiet if extra[f]['second'] == 1]
    assign = lambda fs: sum(ms(f, 'alloc1.assign') for f in fs)
    print(f'first allocation without pressure (general peak <= its registers, no vector or mask interval): {len(quiet)} of {len(general)} functions; '
          f'of the {len(taken)} taken, {len(quiet_taken)}, with {assign(quiet_taken):.3f} of {assign(taken):.3f} ms of allocation 1\'s assignment')
    scan = sum(extra[f]['scan_intervals'] for f in general); common = sum(extra[f]['common_intervals'] for f in general)
    print(f'final allocation: {scan} intervals by the scan, {common} by the common path; fixed ranges {sum(extra[f]["fixed_ranges"] for f in general)}; '
          f'pinned values {sum(extra[f]["pinned"] for f in general)}; functions with calls {sum(1 for f in general if extra[f]["calls"])}; three allocations {sum(1 for f in general if log.functions[f]["allocations"] >= 3)}')
    hist = collections.Counter(min(extra[f]['pressure0'], 20) for f in general)
    print('general peak pressure: ' + ' '.join(f'{k}:{hist[k]}' for k in sorted(hist)))

main()
