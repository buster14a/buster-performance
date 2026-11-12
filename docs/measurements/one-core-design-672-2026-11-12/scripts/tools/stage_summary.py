#!/usr/bin/env python3
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
#
# stage_summary.py WORK.tsv TD.tsv LAT.tsv TOKENS: stage_reduce.py's three tables as one, per token, in Markdown. The
# stages from tier0 to code-atoms are one row, `emission`: its loop runs them function by function, so a sample's time
# can't say which of them it fell in (tier0_generate's samples fall in four of their buckets). Top-down shares are of
# the stage's dispatch slots, 8 a cycle on Zen 5.
import sys

def load(path):
    rows = {}
    header = None
    for line in open(path):
        if line.startswith('#'):
            continue
        p = line.rstrip('\n').split('\t')
        if header is None:
            header = p[1:]
            continue
        rows[p[0]] = dict(zip(header, map(float, p[1:])))
    return rows

work, td, lat, tokens = load(sys.argv[1]), load(sys.argv[2]), load(sys.argv[3]), int(sys.argv[4])
EMISSION = ['tier0', 'emit-setup', 'branch-sizing', 'encode', 'unwind', 'code-atoms']
ORDER = ['preprocess', 'parse', 'check-input', 'check-expressions', 'check-declarations', 'static-data', 'check-program', 'select', 'lower', 'emission',
         'publish-data', 'object-build', 'total']

def merged(table, stage):
    names = EMISSION if stage == 'emission' else [stage]
    out = {}
    for name in names:
        for key, value in table.get(name, {}).items():
            out[key] = out.get(key, 0.0) + value
    return out

print('| stage | cycles | instructions | IPC | mispredicts | L1D fills | from L2 | from L3 | from DRAM | op-cache misses | retiring | bad speculation | frontend | backend | a load not complete |')
print('| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |')
for stage in ORDER:
    w, t, l = merged(work, stage), merged(td, stage), merged(lat, stage)
    if not w:
        continue
    cycles, instructions = w['cycles:u'], w['instructions:u']
    slots = 8 * t['ls_not_halted_cyc:u']
    retired, dispatched = t['ex_ret_ops:u'], t['de_src_op_disp.all:u']
    frontend, backend = t['de_no_dispatch_per_slot.no_ops_from_frontend:u'], t['de_no_dispatch_per_slot.backend_stalls:u']
    print(f"| {stage} | {cycles / tokens:.1f} | {instructions / tokens:.1f} | {instructions / cycles:.2f} | {w['ex_ret_brn_misp:u'] / tokens:.2f} | "
          f"{w['ls_dmnd_fills_from_sys.all:u'] / tokens:.2f} | {l['ls_dmnd_fills_from_sys.local_l2:u'] / tokens:.2f} | {l['ls_dmnd_fills_from_sys.local_ccx:u'] / tokens:.2f} | "
          f"{w['ls_dmnd_fills_from_sys.dram_io_near:u'] / tokens:.2f} | {l['op_cache_hit_miss.op_cache_miss:u'] / tokens:.1f} | {100 * retired / slots:.0f}% | "
          f"{100 * (dispatched - retired) / slots:.0f}% | {100 * frontend / slots:.0f}% | {100 * backend / slots:.0f}% | "
          f"{100 * l['ex_no_retire.load_not_complete:u'] / l['ls_not_halted_cyc:u']:.0f}% |")
