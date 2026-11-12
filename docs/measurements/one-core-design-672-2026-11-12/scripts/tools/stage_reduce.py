#!/usr/bin/env python3
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
#
# stage_reduce.py DIRECTORY GROUP RUN...: puts every sample of stagecounters.sh's runs in the stage its time falls in.
# A run's stage boundaries are its own --time-stages report's top-level stages, in order, from the clock's start; the
# start's place on perf's clock is the median of three estimates: the first sample of a function of the parse, of the
# reader and of Tier 0, each less the stages before its stage. Prints each stage's counts per compile
# (the runs' mean) and, with --functions N, each stage's top N functions.
import gzip, re, sys, collections

def read_stages(path):
    stages = []
    tokens = 0
    for line in open(path):
        p = line.rstrip('\n').split('\t')
        if p[0] == 'time-stage' and p[1] not in ('stage', 'total') and '.' not in p[1]:
            stages.append((p[1], float(p[2])))
        if p[0] == 'time-process' and p[1] == 'tokens':
            tokens = int(p[2])
    return stages, tokens

LINE = re.compile(r'^\s*(\d+\.\d+):\s+(\d+)\s+(\S+):\s+([0-9a-f]+)\s+(.*)$')

def read_samples(path):
    out = []
    with gzip.open(path, 'rt') as f:
        for line in f:
            m = LINE.match(line)
            if m:
                out.append((float(m.group(1)), int(m.group(2)), m.group(3), m.group(5).strip()))
    return out

def main():
    args = sys.argv[1:]
    functions = 0
    if '--functions' in args:
        i = args.index('--functions'); functions = int(args[i + 1]); del args[i:i + 2]
    directory, group, runs = args[0], args[1], args[2:]
    totals = collections.OrderedDict()
    by_function = collections.defaultdict(lambda: collections.Counter())
    events = []
    tokens = 0
    checks = []
    for run in runs:
        stages, tokens = read_stages(f'{directory}/{group}-{run}.stages.txt')
        samples = read_samples(f'{directory}/{group}-{run}.samples.gz')
        bounds = []
        t = 0.0
        for name, ms in stages:
            bounds.append((name, t, t + ms)); t += ms
        end = {name: e for name, s, e in bounds}
        # Three estimates of the clock's start on perf's clock, each a stage's first sample of a function only that
        # stage runs, less the stages before it; the median is the offset, and the spread is printed.
        def first(prefix, after=0.0):
            return min(s[0] for s in samples if s[3].startswith(prefix) and s[0] > after) * 1000.0
        estimates = sorted([first('parse_tokens_from_output') - end['preprocess'] if any(s[3].startswith('parse_tokens_from_output') for s in samples) else first('parse_') - end['preprocess'],
                            first('check_input') - end['type-table'],
                            first('tier0_generate') - end['lower']])
        offset = estimates[1]
        checks.append(estimates[2] - estimates[0])
        index = 0
        for time, period, event, symbol in samples:
            ms = time * 1000.0 - offset
            stage = 'before'
            if ms >= 0:
                stage = 'after'
                for name, s, e in bounds:
                    if s <= ms < e:
                        stage = name; break
            if event not in events: events.append(event)
            totals.setdefault(stage, collections.Counter())[event] += period
            by_function[stage][(symbol, event)] += period
    n = len(runs)
    print(f'# {group}: {n} runs, {tokens} tokens; spread of the three estimates of the clock\'s start, ms: ' + ' '.join(f'{c:.3f}' for c in checks))
    order = ['before'] + [name for name, _ in stages] + ['after']
    print('stage\t' + '\t'.join(events))
    sums = collections.Counter()
    for stage in order:
        if stage in totals:
            print(stage + '\t' + '\t'.join(f'{totals[stage][e] / n:.0f}' for e in events))
            for e in events: sums[e] += totals[stage][e] / n
    print('total\t' + '\t'.join(f'{sums[e]:.0f}' for e in events))
    if functions:
        lead = events[0]
        for stage in order:
            if stage not in totals or totals[stage][lead] / n < 0.004 * sums[lead]: continue
            print(f'## {stage}')
            names = collections.Counter()
            for (symbol, event), v in by_function[stage].items():
                if event == lead: names[symbol] += v
            for symbol, v in names.most_common(functions):
                print(f'{symbol}\t' + '\t'.join(f'{by_function[stage][(symbol, e)] / n:.0f}' for e in events))

main()
