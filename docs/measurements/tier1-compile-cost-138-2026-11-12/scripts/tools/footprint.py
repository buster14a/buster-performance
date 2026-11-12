#!/usr/bin/env python3
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
#
# footprint.py DIRECTORY GROUP RUN...: the code the pipeline's samples fell in (stagecounters.sh's leader event, the
# samples in laps.patch's own stages): the distinct 64-byte lines and 4 KiB pages of their instruction addresses, over
# all the runs together, in all and by laps.py's groups of stages; a lower bound of the code the pipeline runs (a line
# no sample fell in isn't counted), with the lines that hold half and 90% of the samples.
import bisect, collections, gzip, re, sys
sys.path.insert(0, __import__('os').path.dirname(__file__))
import laps

LINE = re.compile(r'^\s*(\d+)\.(\d+):\s+(\d+)\s+(\S+):\s+([0-9a-f]+)\s+(.*)$')

def main():
    directory, group, runs = sys.argv[1], sys.argv[2], sys.argv[3:]
    table = laps.group_of()
    lines = collections.Counter()
    by_group = collections.defaultdict(set)
    symbols = set()
    for run in runs:
        log = laps.read(laps.find(f'{directory}/{group}-{run}.laps'))
        tsc0, ns0, tsc1, ns1 = log.anchor
        d0 = 3000
        rate = (tsc1 - tsc0) / ((ns1 - 25) - (ns0 - d0))
        lead = None
        with laps.open_text(laps.find(f'{directory}/{group}-{run}.samples')) as f:
            for line in f:
                m = LINE.match(line)
                if not m:
                    continue
                lead = lead or m.group(4)
                if m.group(4) != lead:
                    continue
                ns = int(m.group(1)) * 1000000000 + int(m.group(2).ljust(9, '0')[:9])
                k = bisect.bisect_left(log.tsc, tsc0 + (ns - (ns0 - d0)) * rate)
                if k >= len(log.tsc) or log.stage[k] >= laps.DRIVER:
                    continue
                ip = int(m.group(5), 16)
                if ip >= 0xffff800000000000:
                    continue
                lines[ip >> 6] += 1
                by_group[table.get(log.stages[log.stage[k]], 'publication and the rest')].add(ip >> 6)
                symbols.add(m.group(6).strip())
    total = sum(lines.values())
    ordered = sorted(lines.values(), reverse=True)
    def lines_for(share):
        acc = 0
        for n, v in enumerate(ordered):
            acc += v
            if acc >= share * total:
                return n + 1
        return len(ordered)
    pages = {l >> 6 for l in lines}
    print(f'# {group}: {len(runs)} runs, {total} samples of the leader in the pipeline\'s stages, {len(symbols)} functions')
    print(f'distinct 64-byte lines\t{len(lines)}\t{len(lines) * 64 / 1024:.0f} KiB')
    print(f'distinct 4 KiB pages\t{len(pages)}\t{len(pages) * 4} KiB')
    print(f'lines holding half the samples\t{lines_for(0.5)}\t{lines_for(0.5) * 64 / 1024:.0f} KiB')
    print(f'lines holding 90% of the samples\t{lines_for(0.9)}\t{lines_for(0.9) * 64 / 1024:.0f} KiB')
    print('group\tdistinct lines\tKiB')
    for g, _ in laps.GROUPS:
        if g in by_group:
            print(f'{g}\t{len(by_group[g])}\t{len(by_group[g]) * 64 / 1024:.0f}')

main()
