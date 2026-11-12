#!/usr/bin/env python3
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
#
# laps.py: reading laps.patch's lap logs, shared by the reducers. A log has the TSC's two anchors on
# CLOCK_MONOTONIC_RAW (A), the pipeline's stage names (S), a row per compiled function (F) and the laps (L): the TSC
# at a stage's end, the stage, and the function being compiled. A lap's time is its TSC less the previous lap's.
import gzip, lzma, os, collections

DRIVER = 100
DRIVER_STAGES = ['setup', 'lanes-start', 'preprocess', 'parse', 'type-table', 'check-input', 'check-expressions', 'check-declarations', 'static-data',
                 'check-program', 'select', 'backend-setup', 'lower', 'tier0', 'emit-setup', 'lanes', 'branch-sizing', 'encode', 'unwind', 'code-atoms',
                 'debug', 'publish-data', 'object-build', 'object-write', 'runtime', 'executable', 'write', 'release']
FUNCTION_FIELDS = ['unit', 'body', 'typed_entries', 'typed_locals', 'lowered_instructions', 'lowered_blocks', 'promoted_locals', 'promoted_instructions',
                   'promoted_blocks', 'optimized_instructions', 'optimized_blocks', 'effective_uses', 'cfg_values', 'cfg_blocks', 'cfg_edges', 'cfg_positions',
                   'cfg_phis', 'cfg_uses', 'dense_values', 'liveness_iterations', 'intervals', 'allocations', 'records', 'branches', 'chain', 'tier1']

# The stages' groups, for the summary tables: (group, the stages' names' prefixes or names).
GROUPS = [
    ('lowering to the IR', ['lower.validate', 'lower.plan', 'lower.count', 'lower.emit']),
    ('lowering: verification', ['lower.verify']),
    ('inlining', ['inline']),
    ('SSA: CFG, classes, dominators, liveness', ['ssa.cfg', 'ssa.classify', 'ssa.prepare']),
    ('SSA: input dominance check', ['ssa.dominance']),
    ('SSA: definitions, phis, renaming', ['ssa.definitions', 'ssa.construct', 'ssa.simplify']),
    ('SSA: the new function', ['ssa.layout', 'ssa.fill']),
    ('SSA: verification', ['ssa.verify']),
    ('wide integers, vector pieces, truth, if-conversion', ['wide', 'vector-split', 'truth', 'if-convert']),
    ('optimizer: input verification', ['opt.verify-input']),
    ('optimizer: CFG, uses, dominators', ['opt.cfg-uses', 'opt.dominators']),
    ('optimizer: input dominance check', ['opt.dominance']),
    ('optimizer: SCCP', ['opt.sccp']),
    ('optimizer: dead code', ['opt.dce']),
    ('optimizer: rewrite (CFG cleanup, layout)', ['opt.rewrite']),
    ('final verification: rows', ['final.rows']),
    ('final verification: CFG and graph', ['final.cfg']),
    ('final verification: dominators', ['final.dominators']),
    ('final verification: dominance', ['final.dominance']),
    ('selection: uses, depths, barriers', ['select.prepare']),
    ('selection: known bits, canonical, ranges', ['select.facts']),
    ('selection: labeling', ['select.label']),
    ('selection: patterns and the needed walk', ['select.patterns']),
    ('selection: effective uses', ['select.uses']),
    ('straight line: liveness, allocation, frame, records', ['chain.liveness', 'chain.prepare', 'chain.allocate', 'chain.frame', 'chain.records']),
    ('CFG consumer: the problem', ['cfg.problem']),
    ('allocation 1: validation', ['alloc1.validate']),
    ('allocation 1: homes, dense values, hints', ['alloc1.prepare']),
    ('allocation 1: liveness', ['alloc1.liveness']),
    ('allocation 1: block lists, fixed ranges', ['alloc1.lists']),
    ('allocation 1: intervals', ['alloc1.intervals']),
    ('allocation 1: assignment', ['alloc1.assign']),
    ('allocation 1: lookup, slot sharing', ['alloc1.lookup']),
    ('allocation 1: edge moves', ['alloc1.edges']),
    ('allocation 2: validation', ['alloc2.validate']),
    ('allocation 2: homes, dense values, hints', ['alloc2.prepare']),
    ('allocation 2: liveness', ['alloc2.liveness']),
    ('allocation 2: block lists, fixed ranges', ['alloc2.lists']),
    ('allocation 2: intervals', ['alloc2.intervals']),
    ('allocation 2: assignment', ['alloc2.assign']),
    ('allocation 2: lookup, slot sharing', ['alloc2.lookup']),
    ('allocation 2: edge moves', ['alloc2.edges']),
    ('CFG consumer: callee-saved preference', ['cfg.callee']),
    ('CFG consumer: saves', ['cfg.saves']),
    ('CFG consumer: frame', ['cfg.frame']),
    ('CFG consumer: records', ['cfg.records']),
    ('publication and the rest', ['arenas', 'publish', 'rest', 'certify', 'gvn', 'other']),
]

class Log:
    pass

# A text file, plain, gzipped or xz-compressed by its name.
def open_text(path):
    return gzip.open(path, 'rt') if path.endswith('.gz') else lzma.open(path, 'rt') if path.endswith('.xz') else open(path, 'rt')

# `stem` with the compression it is kept in: the record keeps .xz, the host's results .gz.
def find(stem):
    for suffix in ('.gz', '.xz', ''):
        if os.path.exists(stem + suffix):
            return stem + suffix
    raise FileNotFoundError(stem)

def read(path):
    log = Log()
    log.stages = {}
    log.functions = {}
    tsc, stage, function = [], [], []
    with open_text(path) as f:
        for line in f:
            p = line.rstrip('\n').split('\t')
            if p[0] == 'L':
                tsc.append(int(p[1])); stage.append(int(p[2])); function.append(int(p[3]))
            elif p[0] == 'F':
                row = dict(zip(FUNCTION_FIELDS, (int(x) for x in p[2:2 + len(FUNCTION_FIELDS)])))
                row['name'] = p[2 + len(FUNCTION_FIELDS)] if len(p) > 2 + len(FUNCTION_FIELDS) else ''
                log.functions[int(p[1])] = row
            elif p[0] == 'S':
                log.stages[int(p[1])] = p[2]
            elif p[0] == 'A':
                log.anchor = tuple(int(x) for x in p[1:5])
    for k, name in enumerate(DRIVER_STAGES):
        log.stages[DRIVER + k] = 'driver.' + name
    log.tsc, log.stage, log.function = tsc, stage, function
    tsc0, ns0, tsc1, ns1 = log.anchor
    log.ticks_per_ns = (tsc1 - tsc0) / (ns1 - ns0)
    return log

def ns_to_tsc(log, ns):
    tsc0, ns0, _, _ = log.anchor
    return tsc0 + (ns - ns0) * log.ticks_per_ns

# Each stage's ticks, and each function's ticks by stage: {stage name: ticks}, {function: {stage name: ticks}}.
def totals(log):
    by_stage = collections.Counter()
    by_function = collections.defaultdict(collections.Counter)
    previous = log.anchor[0]
    for tsc, stage, function in zip(log.tsc, log.stage, log.function):
        name = log.stages.get(stage, f'stage{stage}')
        by_stage[name] += tsc - previous
        # A driver stage's lap right after a function's laps is that function's (branch sizing, encoding, its unwind
        # rows, its atoms); `other`, the loop's own time before a function, is the function's too.
        by_function[function][name] += tsc - previous
        previous = tsc
    return by_stage, by_function

def group_of():
    table = {}
    for group, names in GROUPS:
        for name in names:
            table[name] = group
    return table
