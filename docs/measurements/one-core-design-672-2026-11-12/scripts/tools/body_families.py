#!/usr/bin/env python3
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
#
# body_families.py WHOLE.work.tsv SPINE.work.tsv RUNS BODY_TOKENS: the function bodies' cost (the whole unit's compile
# less its file scope's, spineprofile.sh's two profiles) by family of function, a name's prefix, in cycles and
# instructions per body token. A function is in the first family whose prefix it has.
import sys

whole_path, spine_path, runs, body_tokens = sys.argv[1], sys.argv[2], int(sys.argv[3]), int(sys.argv[4])

def load(path):
    rows = {}
    header = None
    for line in open(path):
        p = line.rstrip('\n').split('\t')
        if header is None:
            header = p[1:]
            continue
        if len(p) == len(header) + 1:
            rows[p[0]] = [float(v) / runs for v in p[1:]]
    return rows

whole, spine = load(whole_path), load(spine_path)
FAMILIES = [
    ('the C rules for a node', ('check_action',)),
    ('the type table', ('type_',)),
    ('the graph run and its loop', ('check_graph',)),
    ("the graph's construction: the expressions' walk and the literals", ('check_input_expression', 'check_literal', 'check_input_string')),
    ('the lowering', ('check_lower',)),
    ('warnings', ('check_common', 'check_unseq', 'check_driver_common', 'check_input_warning', 'check_warning')),
    ('the program and its controls', ('check_program', 'check_control')),
    ("the reader's other functions", ('check_input', 'check_constant', 'check_sparse', 'c_bindings', 'cbuiltin', 'check_semantic')),
    ('initializers and static data', ('check_init', 'check_data', 'check_const')),
    ('the emission: Tier 0, the encoder, branch sizing, unwinding', ('tier0', 'x86_', 'branch_sizing', 'unwind', 'emission', 'abi_')),
    ("the parser and the tree's columns", ('parse_',)),
    ('the preprocessor and the lexer', ('pp_', 'tokenize_', 'refine_')),
    ('libc: memset, memmove, memcmp', ('__mem',)),
]
totals = {name: [0.0, 0.0] for name, _ in FAMILIES}
totals['everything else'] = [0.0, 0.0]
for name in set(whole) | set(spine):
    w = whole.get(name, [0.0, 0.0])
    s = spine.get(name, [0.0, 0.0])
    family = 'everything else'
    for label, prefixes in FAMILIES:
        if name.startswith(prefixes):
            family = label
            break
    totals[family][0] += w[0] - s[0]
    totals[family][1] += w[1] - s[1]
print('family\tcycles per body token\tinstructions per body token')
for family, (cycles, instructions) in sorted(totals.items(), key=lambda x: -x[1][0]):
    print(f'{family}\t{cycles / body_tokens:.1f}\t{instructions / body_tokens:.1f}')
print(f"total\t{sum(v[0] for v in totals.values()) / body_tokens:.1f}\t{sum(v[1] for v in totals.values()) / body_tokens:.1f}")
