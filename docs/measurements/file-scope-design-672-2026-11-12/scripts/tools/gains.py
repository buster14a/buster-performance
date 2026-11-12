#!/usr/bin/env python3
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
#
# gains.py RAW_DIR: the design's estimate of its gain on the two many-unit workloads, twice: an estimate, not a
# measurement of the design, which isn't built.
#
# First, from the emulation's measured compiles. For each of musl's command (1,336 units) and the generated glibc units
# (512), all as one command on one lane, in cycles of both modes (perf stat's medians):
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
#
# Second, where RAW_DIR/skip2 is there, from the skip measured in the compiler's own reader (skip2.sh: the patched
# build passes the emulation's skipped declarations; the rounds of one page state, tools/skip_table.py's rule), which
# replaces the first estimate's guesses of what the reader saves and of what a skipped token still costs:
#   R, S   `-c` of the sources, every declaration read, and skipped; D = R - S is the skip's measured saving, with the
#          decisions made outside the compiler and no pass of the design run
#   step 2, conservative  85% of D, less the prototype's passes with its own scan
#   step 2, expected      D less the passes at 12 cycles a token
#   step 3, expected      ... and what a skipped token still costs the reader (check-input, both modes), which the
#                         third step takes the token out of: tools/skip_residual.py's figure, from the preprocessed
#                         units skipped (RAW_DIR/skip2, RAW_DIR/skip3) and with the tokens gone (RAW_DIR/semi)
#   step 3, optimistic    D less the passes without their scan, and everything a skipped token still costs outside its
#                         lexing and its parse
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


def rounds(directory, name):
    rows = []
    for file in sorted(os.listdir(os.path.join(raw, directory))):
        if re.fullmatch('stat-' + re.escape(name) + r'-\d+\.csv', file):
            row = {}
            for line in open(os.path.join(raw, directory, file)):
                p = line.strip().split(',')
                if len(p) > 2 and p[0] and not line.startswith('#'):
                    try:
                        row[p[2]] = float(p[0])
                    except ValueError:
                        pass
            rows.append(row)
    return rows


def state_medians(directory, name):
    # The rounds of the state with fewer page faults (skip_table.py's split), or all where there is one state.
    rows = rounds(directory, name)
    faults = [r['page-faults'] for r in rows]
    low, high = min(faults), max(faults)
    if high - low >= 0.02 * low:
        rows = [r for r in rows if r['page-faults'] < (low + high) / 2]
    cycles = statistics.median(r['cycles:u'] for r in rows) + statistics.median(r['cycles:k'] for r in rows)
    return cycles, statistics.median(r['task-clock'] for r in rows), len(rows)


def stage_sums(directory, prefix, members):
    values = collections.defaultdict(list)
    tokens = []
    for file in sorted(os.listdir(os.path.join(raw, directory))):
        if not re.fullmatch(re.escape(prefix) + r'-p1-\d+\.txt(?:\.gz)?', file):
            continue
        header = None
        total = 0.0
        for line in read_lines(os.path.join(raw, directory, file)):
            p = line.rstrip('\n').split('\t')
            if p[0] == 'probe-stage':
                if p[1] == 'stage':
                    header = p[2:]
                    continue
                row = dict(zip(header, p[2:]))
                if members is None or p[1] in members:
                    total += float(row['cycles-u']) + float(row['cycles-k'])
            elif p[0] == 'time-process' and p[1] == 'tokens':
                tokens.append(float(p[2]))
        values['sum'].append(total)
    return statistics.median(values['sum']), statistics.median(tokens)


if os.path.isdir(os.path.join(raw, 'skip2')):
    print()
    print("from the skip in the compiler's own reader (skip2.sh), cycles of both modes, the rounds of one page state")
    print('workload\tR: read, M cycles (ms, rounds)\tS: skipped\tD = R - S, M\tR over S\ta skipped token still costs: the reader\teverything but its lexing and parse\tstep 2: conservative\texpected\tstep 3: expected\toptimistic')
    LEX_PARSE = ('preprocess', 'parse')
    for label, residual_dir in (('musl', 'skip2'), ('glibc', 'skip3')):
        r_cycles, r_ms, r_n = state_medians('skip2', f'{label}-c-read')
        s_cycles, s_ms, s_n = state_medians('skip2', f'{label}-c-skipped')
        d = r_cycles - s_cycles
        _, tokens = stages('semi', f'{label}-i')
        _, gone_tokens = stages('semi', f'{label}-live')
        skipped = tokens - gone_tokens
        reader = rest = None
        if os.path.isdir(os.path.join(raw, residual_dir)) and any(f.startswith(f'{label}-i-skipped-p1-') for f in os.listdir(os.path.join(raw, residual_dir))):
            skipped_reader, _ = stage_sums(residual_dir, f'{label}-i-skipped', ('check-input',))
            gone_reader, _ = stage_sums('semi', f'{label}-live', ('check-input',))
            skipped_all, _ = stage_sums(residual_dir, f'{label}-i-skipped', None)
            gone_all, _ = stage_sums('semi', f'{label}-live', None)
            skipped_front, _ = stage_sums(residual_dir, f'{label}-i-skipped', LEX_PARSE)
            gone_front, _ = stage_sums('semi', f'{label}-live', LEX_PARSE)
            reader = (skipped_reader - gone_reader) / skipped
            rest = ((skipped_all - gone_all) - (skipped_front - gone_front)) / skipped
        def times(saving):
            return f'{r_cycles / (r_cycles - saving):.2f} ({saving / 1e6:.0f} M)'
        conservative2 = 0.85 * d - scan_cost * tokens
        expected2 = d - 12 * tokens
        columns = [times(conservative2), times(expected2)]
        if reader is not None:
            columns += [times(expected2 + reader * skipped), times(d - lists_cost * tokens + rest * skipped)]
            residual = f'{reader:.1f}\t{rest:.1f}'
        else:
            columns += ['', '']
            residual = '\t'
        print(f'{label}\t{r_cycles / 1e6:.0f} ({r_ms:.1f}, {r_n})\t{s_cycles / 1e6:.0f} ({s_ms:.1f}, {s_n})\t{d / 1e6:.0f}\t{r_cycles / s_cycles:.3f}\t{residual}\t' + '\t'.join(columns))
