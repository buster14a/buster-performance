#!/usr/bin/env python3
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
#
# gains.py: the estimate of buster#2524's design's gains on `-c sqlite3.c`, from this record's measurements and three
# sets of assumptions. An estimate, not a measurement: the removed work per step is a reading of tables/body-families.tsv
# and tables/body-share.tsv (which functions a step stops running for what the machine takes), and the coverage and the
# machine's own cost are assumed. It prints the table of the design's "Expected gains".
USER = 595.2e6          # perf stat's user cycles of the compile (raw/baseline/stat-basic.csv)
KERNEL = 86.3e6         # its kernel cycles
SAMPLED = 610.68e6      # the sampled runs' user cycles (tables/stage-work.tsv's total), whose per-token figures the
                        # body tables are in: scaled back by USER / SAMPLED
BODY_TOKENS = 568641

# Cycles a body token that a step no longer spends for what the machine takes, at full coverage.
STEP2 = {
    "the graph's construction": 98.9,
    'the graph run: its loop, the C rules, the type table': 52.3 + 30.9 + 5.9,
    'the warning passes that read nodes (about 90 of 121.6)': 90.0,
    "the program's reference walk and per-node reads (about 35 of 126.2)": 35.0,
    "the lowering's tasks (about 70 of 93.0)": 70.0,
    "memset of the graph's and the stream's columns (about 8 of 26.7)": 8.0,
}
STEP3 = {
    'the rest of the program and its controls': 126.2 - 35.0,
    'the rest of the warnings': 121.6 - 90.0,
    'the rest of the lowering': 93.0 - 70.0,
    'local initializers and static data (about 10 of 24.6)': 10.0,
    "the selection's walk (about 4 of 7.0) and the reader's controls": 8.0,
}
STEP4 = {
    "the reader's other functions": 152.9,
    'the rest of memset': 26.7 - 8.0,
    "the tree's columns, made a body at a time (about 7 of 12.5)": 7.0,
}
# The kernel's cycles a step's rows and columns cost today (their pages' first touches), at full coverage.
KERNEL_STEP = (10e6, 5e6, 32e6)

CASES = [
    # name, nodes in taken expressions, tokens in taken bodies, the machine's cycles a body token for each step's part
    ('conservative', 0.80, 0.70, (90.0, 20.0, 40.0)),
    ('expected', 0.90, 0.85, (55.0, 15.0, 30.0)),
    ('optimistic', 0.95, 0.95, (45.0, 10.0, 5.0)),
]

scale = USER / SAMPLED
total = USER + KERNEL
bound = (752.5 * BODY_TOKENS * scale + 30e6)
print(f'whole compile: {total / 1e6:.1f} M cycles; the bodies\' work from check-input to lower free: {total / (total - bound):.2f} times')
for label, removed in (('step 2', STEP2), ('step 3', STEP3), ('step 4', STEP4)):
    print(f'{label} removes {sum(removed.values()):.1f} cycles a body token at full coverage')
print('case\tafter step 2\tafter step 3\tafter step 4\tcycles left, M')
for name, expressions, bodies, machine in CASES:
    saved = 0.0
    row = []
    for step, (removed, coverage) in enumerate(((STEP2, expressions), (STEP3, bodies), (STEP4, bodies))):
        saved += (coverage * sum(removed.values()) - machine[step]) * BODY_TOKENS * scale + coverage * KERNEL_STEP[step]
        row.append(total / (total - saved))
    print(f'{name}\t{row[0]:.2f}\t{row[1]:.2f}\t{row[2]:.2f}\t{(total - saved) / 1e6:.0f}')
# Step 2 by the machine's own cost, at the expected coverage, beside what the prototype of its three sweeps costs
# (tables/sweeps.md: 99.7 cycles a node of sqlite3.c's 266,707, an expression at a time, with hashed tables and its
# lookups given).
PROTOTYPE = 99.7 * 266707 / BODY_TOKENS
print(f"the prototype's sweeps: {PROTOTYPE:.1f} cycles a body token")
print("step 2 at 90% of the nodes, by the machine's cycles a body token:")
for machine in (45.0, 55.0, 75.0, 90.0, 120.0, 150.0):
    saved = (0.90 * sum(STEP2.values()) - machine) * BODY_TOKENS * scale + 0.90 * KERNEL_STEP[0]
    print(f'{machine:.0f}\t{total / (total - saved):.2f}')
