#!/usr/bin/env python3
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
#
# samples_by_size.py DIRECTORY GROUP RUN...: stagecounters.sh's samples that fall in the pipeline's laps (laps.patch's
# own stages, not the driver's), by the size class of the function being compiled (its lowered IR instructions), with
# the first anchor's delay fitted as samples_reduce.py does. Prints each class's counts per compile (the runs' mean).
import bisect, collections, gzip, re, sys
sys.path.insert(0, __import__('os').path.dirname(__file__))
import laps

LINE = re.compile(r'^\s*(\d+)\.(\d+):\s+(\d+)\s+(\S+):\s+([0-9a-f]+)\s+(.*)$')
OWN = {
    'tier1_emit_cfg_problem': ('cfg.problem',), 'tier1_cfg_allocate_impl': ('alloc1.', 'alloc2.'), 'tier1_emit_cfg_records': ('cfg.records',),
    'ir_optimize_rewrite': ('opt.rewrite',), 'ssa_ir_promote_path': ('ssa.',), 'tier1_emit_cfg_callee': ('cfg.callee',),
    'ir_typed_emit_function': ('lower.emit',), 'ir_typed_count_function': ('lower.count',),
}
BOUNDS = [0, 32, 64, 128, 256, 512, 1024, 2048, 4096, 1 << 30]

def main():
    directory, group, runs = sys.argv[1], sys.argv[2], sys.argv[3:]
    totals = collections.defaultdict(collections.Counter)
    events = []
    counts = collections.Counter()
    for run in runs:
        log = laps.read(laps.find(f'{directory}/{group}-{run}.laps'))
        samples = []
        with laps.open_text(laps.find(f'{directory}/{group}-{run}.samples')) as f:
            for line in f:
                m = LINE.match(line)
                if m:
                    samples.append((int(m.group(1)) * 1000000000 + int(m.group(2).ljust(9, '0')[:9]), int(m.group(3)), m.group(4), m.group(6).strip()))
        tsc0, ns0, tsc1, ns1 = log.anchor
        lead = samples[0][2]
        def convert(d0):
            rate = (tsc1 - tsc0) / ((ns1 - 25) - (ns0 - d0))
            return lambda ns: tsc0 + (ns - (ns0 - d0)) * rate
        own = [(ns, period, OWN[symbol.split('.buster_split')[0]]) for ns, period, event, symbol in samples if event == lead and symbol.split('.buster_split')[0] in OWN]
        shares = []
        for d in range(0, 6001, 100):
            to_tsc = convert(d)
            inside = 0
            for ns, period, prefixes in own:
                k = bisect.bisect_left(log.tsc, to_tsc(ns))
                inside += period if k < len(log.tsc) and log.stages.get(log.stage[k], '').startswith(prefixes) else 0
            shares.append((d, inside))
        top = max(v for _, v in shares)
        good = [d for d, v in shares if v >= top - 0.0002 * sum(period for _, period, _ in own)]
        to_tsc = convert((good[0] + good[-1]) // 2)
        if not counts:
            for f, row in log.functions.items():
                size = row['lowered_instructions']
                counts[max(b for b in BOUNDS if b <= size)] += 1
        for ns, period, event, symbol in samples:
            if event not in events:
                events.append(event)
            k = bisect.bisect_left(log.tsc, to_tsc(ns))
            if k >= len(log.tsc) or log.stage[k] >= laps.DRIVER or log.function[k] not in log.functions:
                continue
            size = log.functions[log.function[k]]['lowered_instructions']
            totals[max(b for b in BOUNDS if b <= size)][event] += period
    n = len(runs)
    print(f'# {group}: {n} runs; the pipeline\'s laps alone, by the function\'s lowered IR instructions')
    print('class\tfunctions\t' + '\t'.join(events))
    for lo, hi in zip(BOUNDS, BOUNDS[1:]):
        if lo in totals:
            label = f'{lo} to {hi - 1}' if hi < (1 << 30) else f'{lo} and more'
            print(f'{label}\t{counts[lo]}\t' + '\t'.join(f'{totals[lo][e] / n:.0f}' for e in events))
    print('total\t' + str(sum(counts.values())) + '\t' + '\t'.join(f'{sum(totals[b][e] for b in totals) / n:.0f}' for e in events))

main()
