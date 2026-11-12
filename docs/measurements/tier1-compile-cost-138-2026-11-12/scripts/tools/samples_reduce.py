#!/usr/bin/env python3
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
#
# samples_reduce.py [--functions N] [--groups] [--no-fit] DIRECTORY GROUP RUN...: puts every sample of stagecounters.sh's
# runs in the lap its time falls in. A sample's CLOCK_MONOTONIC_RAW time becomes a TSC through the run's own lap log's
# anchors, and its lap is the first whose end is at or past it. The first anchor's clock read is the process's first
# and comes late (2 to 3 us here), which would put the start of each stage's samples in the stage before: its delay is
# fitted per run as anchor_fit.py does, the middle of the delays that put the most samples of functions one stage alone
# runs in that stage (--no-fit takes none). Prints each stage's counts per compile (the runs' mean), and with
# --functions N each stage's top N functions by the group's first event; with --groups, by laps.py's groups of stages.
import bisect, collections, gzip, re, sys
sys.path.insert(0, __import__('os').path.dirname(__file__))
import laps

LINE = re.compile(r'^\s*(\d+)\.(\d+):\s+(\d+)\s+(\S+):\s+([0-9a-f]+)\s+(.*)$')
# Functions that one stage alone runs, and that stage's name's prefixes: the anchor's fit.
OWN = {
    'tier1_emit_cfg_problem': ('cfg.problem',),
    'tier1_cfg_allocate_impl': ('alloc1.', 'alloc2.'),
    'tier1_emit_cfg_records': ('cfg.records',),
    'ir_optimize_rewrite': ('opt.rewrite',),
    'ssa_ir_promote_path': ('ssa.',),
    'tier1_emit_cfg_callee': ('cfg.callee',),
    'ir_typed_emit_function': ('lower.emit',),
    'ir_typed_count_function': ('lower.count',),
}

def main():
    args = sys.argv[1:]
    functions, groups, fit = 0, False, True
    if '--no-fit' in args:
        fit = False; args.remove('--no-fit')
    if '--functions' in args:
        i = args.index('--functions'); functions = int(args[i + 1]); del args[i:i + 2]
    if '--groups' in args:
        groups = True; args.remove('--groups')
    directory, group, runs = args[0], args[1], args[2:]
    table = laps.group_of()
    totals = collections.defaultdict(collections.Counter)
    by_function = collections.defaultdict(collections.Counter)
    events = []
    order = []
    outside = collections.Counter()
    delays = []
    for run in runs:
        log = laps.read(laps.find(f'{directory}/{group}-{run}.laps'))
        if not order:
            order = [log.stages[k] for k in sorted(log.stages)]
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
        d0 = 0
        if fit:
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
            d0 = (good[0] + good[-1]) // 2
        delays.append(d0)
        to_tsc = convert(d0)
        first = log.anchor[0]
        for ns, period, event, symbol in samples:
            if event not in events:
                events.append(event)
            tsc = to_tsc(ns)
            k = bisect.bisect_left(log.tsc, tsc)
            if tsc < first:
                stage = 'before the first lap'
            elif k >= len(log.tsc):
                stage = 'after the last lap'
            else:
                stage = log.stages.get(log.stage[k], f'stage{log.stage[k]}')
                if groups and not stage.startswith('driver.'):
                    stage = table.get(stage, 'publication and the rest')
            totals[stage][event] += period
            by_function[stage][(symbol, event)] += period
    n = len(runs)
    names = ['before the first lap'] + ([g for g, _ in laps.GROUPS] if groups else []) + order + ['after the last lap']
    seen = []
    for name in names:
        if name in totals and name not in seen:
            seen.append(name)
    print(f'# {group}: {n} runs; the first anchor\'s fitted delay, ns: ' + ' '.join(str(d) for d in delays))
    print('stage\t' + '\t'.join(events))
    sums = collections.Counter()
    for stage in seen:
        print(stage + '\t' + '\t'.join(f'{totals[stage][e] / n:.0f}' for e in events))
        for e in events:
            sums[e] += totals[stage][e] / n
    print('total\t' + '\t'.join(f'{sums[e]:.0f}' for e in events))
    if functions:
        lead = events[0]
        for stage in seen:
            if totals[stage][lead] / n < 0.004 * sums[lead]:
                continue
            print(f'## {stage}\t{totals[stage][lead] / n:.0f}')
            names = collections.Counter()
            for (symbol, event), v in by_function[stage].items():
                if event == lead:
                    names[symbol] += v
            for symbol, v in names.most_common(functions):
                print(f'{symbol}\t' + '\t'.join(f'{by_function[stage][(symbol, e)] / n:.0f}' for e in events))

main()
