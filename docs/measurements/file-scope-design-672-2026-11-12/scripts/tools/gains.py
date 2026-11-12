#!/usr/bin/env python3
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
#
# gains.py RAW_DIR: the design's estimate of its gain on the two many-unit workloads, from the emulation's measured
# compiles: an estimate, not a measurement of the design, which isn't built. For each of musl's command (1,336 units)
# and the generated glibc units (512), all as one command on one lane, in cycles of both modes (perf stat's medians):
#   T      `-c` of the sources (RAW_DIR/musl, RAW_DIR/glibc)
#   I      `-c` of the preprocessed units (RAW_DIR/semi)
#   SEMI   ... with every skipped declaration's tokens kept as empty declarations: the design does less than this
#   LIVE   ... with the skipped declarations' tokens gone: the design does more than this
# The design leaves a skipped declaration's tokens in the unit, lexed and parsed as they were; LIVE also removed their
# parse and their lexing from the preprocessed text, which the stage counters of I and LIVE give (RAW_DIR/semi's
# probe reports) and the estimate puts back. Three cases:
#   conservative  SEMI's saving, at 85% of the emulation's coverage (the reader's own test of what a declaration did may
#                 refuse more than the emulation's spelling rules), less the prototype's passes as measured with its own
#                 scan (RAW_DIR/chain3)
#   expected      LIVE's saving less the parse and lexing put back, less 20 cycles a skipped token for the unit-wide
#                 passes that still see it, less the passes at 12 cycles a token (the lists from the parser's roles)
#   optimistic    LIVE's saving less the lexing put back, less the passes at the prototype's cost without its scan: the
#                 skipped declarations out of the unit-wide passes and the tree's columns too (step 3)
# and the bound: every cycle of the file scope's reading free (rank.py's first row, for musl).
import os, re, statistics, sys, collections


def read_lines(path):
    # A report's lines, whether the record keeps it as it was written or gzipped (its units' diagnostics make it large).
    if path.endswith('.gz'):
        import gzip
        return gzip.open(path, 'rt', errors='replace')
    return open(path, errors='replace')

raw = sys.argv[1]


def stat(directory, name):
    values = collections.defaultdict(list)
    for file in sorted(os.listdir(os.path.join(raw, directory))):
        if re.fullmatch('stat-' + re.escape(name) + r'-\d+\.csv', file):
            for line in open(os.path.join(raw, directory, file)):
                p = line.strip().split(',')
                if len(p) > 2 and p[0] and not line.startswith('#'):
                    try:
                        values[p[2]].append(float(p[0]))
                    except ValueError:
                        pass
    cycles = statistics.median(values['cycles:u']) + statistics.median(values['cycles:k'])
    return cycles, statistics.median(values['task-clock'])


def stages(directory, prefix):
    runs = collections.defaultdict(list)
    tokens = []
    for file in sorted(os.listdir(os.path.join(raw, directory))):
        if not re.fullmatch(re.escape(prefix) + r'-p1-\d+\.txt(?:\.gz)?', file):
            continue
        header = None
        for line in read_lines(os.path.join(raw, directory, file)):
            p = line.rstrip('\n').split('\t')
            if p[0] == 'probe-stage':
                if p[1] == 'stage':
                    header = p[2:]
                    continue
                row = dict(zip(header, p[2:]))
                runs[p[1]].append(float(row['cycles-u']) + float(row['cycles-k']))
            elif p[0] == 'time-process' and p[1] == 'tokens':
                tokens.append(float(p[2]))
    return {s: statistics.median(v) for s, v in runs.items()}, statistics.median(tokens)


def prototype(name, row):
    values = []
    directory = os.path.join(raw, 'chain3')
    for file in sorted(os.listdir(directory)):
        if re.fullmatch(re.escape(name) + r'-\d+\.txt', file):
            for line in open(os.path.join(directory, file)):
                p = line.rstrip('\n').split('\t')
                if p[0] == row:
                    values.append(float(p[1]))
    return statistics.median(values)


scan_cost = prototype('musl-scan', 'cycles a token')
lists_cost = prototype('musl-lists', 'cycles a token')
print(f"the prototype's passes on musl, cycles a token: {scan_cost:.2f} with its own scan, {lists_cost:.2f} with the lists given")
print('workload\tT, M cycles (ms)\tI\tSEMI\tLIVE\ttokens\tskipped\tparse and lexing put back, M\tconservative\texpected\toptimistic')
for label, source in (('musl', 'musl'), ('glibc', 'glibc')):
    t_cycles, t_ms = stat(source, 'c')
    i_cycles, i_ms = stat('semi', f'{label}-i')
    semi_cycles, semi_ms = stat('semi', f'{label}-semi')
    live_cycles, live_ms = stat('semi', f'{label}-live')
    i_stages, tokens = stages('semi', f'{label}-i')
    live_stages, live_tokens = stages('semi', f'{label}-live')
    skipped = tokens - live_tokens
    back_parse = i_stages['parse'] - live_stages['parse']
    back_lex = i_stages['preprocess'] - live_stages['preprocess']
    conservative = 0.85 * (i_cycles - semi_cycles) - scan_cost * tokens
    expected = (i_cycles - live_cycles) - back_parse - back_lex - 20 * skipped - 12 * tokens
    optimistic = (i_cycles - live_cycles) - back_lex - lists_cost * tokens
    def times(saving):
        return f'{t_cycles / (t_cycles - saving):.2f} ({saving / 1e6:.0f} M)'
    print(f'{label}\t{t_cycles / 1e6:.0f} ({t_ms:.0f})\t{i_cycles / 1e6:.0f} ({i_ms:.0f})\t{semi_cycles / 1e6:.0f} ({semi_ms:.0f})\t{live_cycles / 1e6:.0f} ({live_ms:.0f})\t'
          f'{tokens:.0f}\t{skipped:.0f}\t{(back_parse + back_lex) / 1e6:.0f}\t{times(conservative)}\t{times(expected)}\t{times(optimistic)}')
