#!/usr/bin/env python3
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
#
# anchor_fit.py DIRECTORY GROUP RUN...: the delay of a lap log's first anchor. laps.patch reads the TSC and then
# CLOCK_MONOTONIC_RAW for each anchor; the first read of the clock in a process is slow (its first call), so the first
# anchor's time is late by a delay d0 and every sample's TSC comes out early by d0 at the start of the run, falling to
# the second anchor's few tens of ns at its end. For each run, tries d0 from 0 to 4000 ns and prints, for each, the
# share of the samples of functions that one stage alone runs that fall in that stage; the d0 with the largest share is
# the run's.
import bisect, gzip, re, sys
sys.path.insert(0, __import__('os').path.dirname(__file__))
import laps

LINE = re.compile(r'^\s*(\d+)\.(\d+):\s+(\d+)\s+(\S+):\s+([0-9a-f]+)\s+(.*)$')
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
    directory, group, runs = sys.argv[1], sys.argv[2], sys.argv[3:]
    for run in runs:
        log = laps.read(laps.find(f'{directory}/{group}-{run}.laps'))
        samples = []
        with laps.open_text(laps.find(f'{directory}/{group}-{run}.samples')) as f:
            lead = None
            for line in f:
                m = LINE.match(line)
                if not m:
                    continue
                event = m.group(4)
                lead = lead or event
                symbol = m.group(6).strip().split('.buster_split')[0]
                if event == lead and symbol in OWN:
                    samples.append((int(m.group(1)) * 1000000000 + int(m.group(2).ljust(9, '0')[:9]), int(m.group(3)), symbol))
        tsc0, ns0, tsc1, ns1 = log.anchor
        best = None
        row = []
        for d0 in range(0, 4001, 100):
            rate = (tsc1 - tsc0) / ((ns1 - 25) - (ns0 - d0))
            inside = total = 0
            for ns, period, symbol in samples:
                tsc = tsc0 + (ns - (ns0 - d0)) * rate
                k = bisect.bisect_left(log.tsc, tsc)
                stage = log.stages.get(log.stage[k], '') if k < len(log.tsc) else ''
                total += period
                inside += period if stage.startswith(OWN[symbol]) else 0
            share = inside / total
            row.append((d0, share))
            if best is None or share > best[1]:
                best = (d0, share)
        print(f'{group}-{run}: best d0 {best[0]} ns, {100 * best[1]:.2f}% of {len(samples)} samples in their stages; d0=0: {100 * row[0][1]:.2f}%; ' +
              ' '.join(f'{d}:{100 * s:.2f}' for d, s in row[::4]))

main()
