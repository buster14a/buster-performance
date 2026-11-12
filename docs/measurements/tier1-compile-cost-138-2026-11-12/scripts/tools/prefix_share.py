#!/usr/bin/env python3
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
#
# prefix_share.py LOG...: how much of the plain assignment lies before the end of the last definition interval bound
# to a register, from laps5.patch's lap logs (a "two" log's G lines: pinned_end, the general class's; required_most,
# the most required uses at one position; quiet, whether its pressure before that end fits its registers). For the
# functions with a preferred allocation: the plain assignment's time (alloc1.assign), the part of it in the functions
# where the pressure bound holds, and its part before pinned_end taken as the positions' share of each function's
# time (the scan's cost per position is assumed level within a function). Then the functions with the most time
# outside the bound.
import sys, os, statistics
sys.path.insert(0, os.path.dirname(__file__))
import laps

KEYS = ['crossing', 'second', 'same_intervals', 'calls', 'fixed_ranges', 'fragments', 'moves', 'spills', 'scan_intervals', 'common_intervals', 'splits',
        'pressure0', 'pressure1', 'pressure2', 'registers0', 'fixed_general', 'pinned', 'quiet', 'required_most', 'pinned_end', 'pinned_pressure']

for path in sys.argv[1:]:
    log = laps.read(path)
    extra = {}
    with laps.open_text(path) as f:
        for line in f:
            p = line.rstrip('\n').split('\t')
            if p[0] == 'G':
                extra[int(p[1])] = dict(zip(KEYS, (int(x) for x in p[2:])))
    _, by_function = laps.totals(log)
    def ms(f, name):
        return by_function.get(f, {}).get(name, 0) / log.ticks_per_ns / 1e6
    taken = [f for f in log.functions if extra.get(f, {}).get('second') == 1]
    total = sum(ms(f, 'alloc1.assign') for f in taken)
    quiet = [f for f in taken if extra[f]['quiet'] == 1]
    loud = [f for f in taken if extra[f]['quiet'] == 0]
    before = before_loud = 0.0
    ratios = []
    for f in taken:
        positions = log.functions[f]['cfg_positions']
        ratio = min(1.0, extra[f]['pinned_end'] / positions) if positions else 0.0
        ratios.append(ratio)
        before += ms(f, 'alloc1.assign') * ratio
        before_loud += ms(f, 'alloc1.assign') * ratio if extra[f]['quiet'] == 0 else 0.0
    print(f'# {path}')
    print(f'functions with a preferred allocation\t{len(taken)}')
    print(f'the plain assignment in them, ms\t{total:.3f}')
    print(f'where the pressure bound holds\t{len(quiet)} functions\t{sum(ms(f, "alloc1.assign") for f in quiet):.3f} ms')
    print(f'where it does not\t{len(loud)} functions\t{sum(ms(f, "alloc1.assign") for f in loud):.3f} ms')
    print(f'before the last bound definition interval\'s end, by positions\t{before:.3f} ms\t{100 * before / total:.1f}%\tof it where the bound does not hold\t{before_loud:.3f} ms')
    print(f'the positions\' share before that end\tmedian {statistics.median(ratios):.3f}\tmean {statistics.mean(ratios):.3f}')
    print(f'the most required uses at one position (the general class)\t{max(extra[f]["required_most"] for f in taken)}\tits registers\t{max(extra[f]["registers0"] for f in taken)}')
    print('function\tplain assignment ms\tpositions\tpinned_end\tpressure before it\tbound definitions\tmost required uses')
    for f in sorted(loud, key=lambda f: -ms(f, 'alloc1.assign'))[:12]:
        print(f"{log.functions[f]['name']}\t{ms(f, 'alloc1.assign'):.3f}\t{log.functions[f]['cfg_positions']}\t{extra[f]['pinned_end']}\t{extra[f]['pinned_pressure']}\t{extra[f]['pinned']}\t{extra[f]['required_most']}")
    print()
