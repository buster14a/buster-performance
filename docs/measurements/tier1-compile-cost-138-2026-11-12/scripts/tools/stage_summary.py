#!/usr/bin/env python3
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
#
# stage_summary.py [--markdown] LAPS.tsv WORK.tsv TD.tsv LAT.tsv: one table of the pipeline's stages (or groups):
# stage_table.py's milliseconds (the laps' TSC, exact) beside samples_reduce.py's counters per compile for the same
# rows: user cycles and instructions, IPC, mispredicted branches, L1D demand fills (all, from L2, from L3, from DRAM),
# op-cache misses, the top-down shares of the stage's dispatch slots (8 a cycle on Zen 5: retiring, bad speculation,
# waiting for the frontend, for the backend) and the share of cycles with a load not complete at retirement. The last
# rows sum the pipeline's rows and the driver's.
import sys

def load(path):
    rows, header, order = {}, None, []
    for line in open(path):
        if line.startswith('#'):
            continue
        p = line.rstrip('\n').split('\t')
        if header is None:
            header = p[1:]
            continue
        try:
            rows[p[0]] = dict(zip(header, (float(x.rstrip('%')) if x else 0.0 for x in p[1:])))
            order.append(p[0])
        except ValueError:
            pass
    return rows, order

def main():
    args = sys.argv[1:]
    markdown = '--markdown' in args
    if markdown: args.remove('--markdown')
    laps, order = load(args[0])
    work, _ = load(args[1]); td, _ = load(args[2]); lat, _ = load(args[3])
    names = [n for n in order if n in work and n not in ('the pipeline', 'all laps')]
    columns = ['stage', 'ms', 'M cycles', 'M instructions', 'IPC', 'k mispredicts', 'per 1,000 instructions', 'k L1D fills', 'from L2', 'from L3', 'from DRAM', 'k op-cache misses',
               'retiring', 'bad speculation', 'frontend', 'backend', 'a load not complete']
    out = []
    def row(name, w, t, l, ms):
        cycles, instructions = w['cycles:u'], w['instructions:u']
        slots = 8 * t['ls_not_halted_cyc:u']
        retired, dispatched = t['ex_ret_ops:u'], t['de_src_op_disp.all:u']
        frontend, backend = t['de_no_dispatch_per_slot.no_ops_from_frontend:u'], t['de_no_dispatch_per_slot.backend_stalls:u']
        return [name, f'{ms:.2f}', f'{cycles / 1e6:.1f}', f'{instructions / 1e6:.1f}', f'{instructions / cycles:.2f}', f"{w['ex_ret_brn_misp:u'] / 1e3:.0f}",
                f"{1e3 * w['ex_ret_brn_misp:u'] / instructions:.1f}", f"{w['ls_dmnd_fills_from_sys.all:u'] / 1e3:.0f}", f"{l['ls_dmnd_fills_from_sys.local_l2:u'] / 1e3:.0f}",
                f"{l['ls_dmnd_fills_from_sys.local_ccx:u'] / 1e3:.0f}", f"{w['ls_dmnd_fills_from_sys.dram_io_near:u'] / 1e3:.1f}", f"{l['op_cache_hit_miss.op_cache_miss:u'] / 1e3:.0f}",
                f'{100 * retired / slots:.0f}%', f'{100 * (dispatched - retired) / slots:.0f}%', f'{100 * frontend / slots:.0f}%', f'{100 * backend / slots:.0f}%',
                f"{100 * l['ex_no_retire.load_not_complete:u'] / l['ls_not_halted_cyc:u']:.0f}%"]
    def total(keys, table):
        s = {}
        for k in keys:
            for e, v in table.get(k, {}).items():
                s[e] = s.get(e, 0.0) + v
        return s
    for n in names:
        out.append(row(n, work[n], td.get(n, {}), lat.get(n, {}), laps[n]['ms']))
    pipeline = [n for n in names if not n.startswith('driver.')]
    driver = [n for n in names if n.startswith('driver.')]
    out.append(row('the pipeline', total(pipeline, work), total(pipeline, td), total(pipeline, lat), sum(laps[n]['ms'] for n in pipeline)))
    if driver:
        out.append(row('the driver\'s stages', total(driver, work), total(driver, td), total(driver, lat), sum(laps[n]['ms'] for n in driver)))
    if markdown:
        print('| ' + ' | '.join(columns) + ' |')
        print('| --- |' + ' ---: |' * (len(columns) - 1))
        for r in out:
            print('| ' + ' | '.join(r) + ' |')
    else:
        print('\t'.join(columns))
        for r in out:
            print('\t'.join(r))

main()
