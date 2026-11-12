#!/usr/bin/env python3
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
#
# skip_residual.py RAW_DIR: what a skipped token still costs each stage. For musl's and the generated glibc units'
# preprocessed units as one command, the probe's stage counters (medians of the runs) three ways: read (every
# declaration, RAW_DIR/skip2's musl-i-read and RAW_DIR/skip3's glibc-i-read), skipped (the compiler's reader passes the
# emulation's skipped declarations, whose tokens stay: the -skipped runs beside them), and gone (the same units with
# those tokens removed from the text, RAW_DIR/semi's musl-live and glibc-live). Skipped less gone, over the skipped
# tokens, is what a token the reader doesn't read still costs the stage: its lexing and its parse, which the design
# keeps, and the unit-wide passes that still see it, which the design's third step takes it out of.
import os, re, statistics, sys, collections


def read_lines(path):
    if path.endswith('.gz'):
        import gzip
        return gzip.open(path, 'rt', errors='replace')
    return open(path, errors='replace')


def stages(directory, prefix):
    user = collections.defaultdict(list)
    kernel = collections.defaultdict(list)
    tokens = []
    order = []
    for file in sorted(os.listdir(directory)):
        if not re.fullmatch(re.escape(prefix) + r'-p1-\d+\.txt(?:\.gz)?', file):
            continue
        header = None
        for line in read_lines(os.path.join(directory, file)):
            p = line.rstrip('\n').split('\t')
            if p[0] == 'probe-stage':
                if p[1] == 'stage':
                    header = p[2:]
                    continue
                row = dict(zip(header, p[2:]))
                if p[1] not in order:
                    order.append(p[1])
                user[p[1]].append(float(row['cycles-u']))
                kernel[p[1]].append(float(row['cycles-k']))
            elif p[0] == 'time-process' and p[1] == 'tokens':
                tokens.append(float(p[2]))
    return order, {s: statistics.median(v) for s, v in user.items()}, {s: statistics.median(v) for s, v in kernel.items()}, statistics.median(tokens)


raw = sys.argv[1]
GROUPS = [
    ('preprocess: the lexing', ('preprocess',)),
    ('parse', ('parse',)),
    ('check-input: the reader', ('check-input',)),
    ('the checker\'s other stages (type-table to select)', ('type-table', 'check-expressions', 'check-declarations', 'static-data', 'check-program', 'select')),
    ('lower to the object', ('backend-setup', 'lower', 'tier0', 'emit-setup', 'branch-sizing', 'encode', 'unwind', 'code-atoms', 'debug', 'publish-data', 'object-build', 'object-write')),
    ('a unit\'s start, end and the time between two', ('setup', 'lanes-start', 'release')),
]
print('workload\tstage\tread: user M\tskipped: user M\tgone: user M\tskipped less gone: user M\tuser cycles a skipped token\tkernel M: read\tskipped\tgone\tkernel cycles a skipped token')
for label, read_dir, gone_dir in (('musl', 'skip2', 'semi'), ('glibc', 'skip3', 'semi')):
    if not os.path.isdir(os.path.join(raw, read_dir)) or not any(f.startswith(f'{label}-i-read-p1-') for f in os.listdir(os.path.join(raw, read_dir))):
        continue
    order, ru, rk, tokens = stages(os.path.join(raw, read_dir), f'{label}-i-read')
    _, su, sk, _ = stages(os.path.join(raw, read_dir), f'{label}-i-skipped')
    _, gu, gk, gone_tokens = stages(os.path.join(raw, gone_dir), f'{label}-live')
    skipped = tokens - gone_tokens
    total = [0.0] * 7
    for name, members in GROUPS:
        a = sum(ru.get(s, 0) for s in members); b = sum(su.get(s, 0) for s in members); c = sum(gu.get(s, 0) for s in members)
        ka = sum(rk.get(s, 0) for s in members); kb = sum(sk.get(s, 0) for s in members); kc = sum(gk.get(s, 0) for s in members)
        for i, v in enumerate((a, b, c, ka, kb, kc)):
            total[i] += v
        print(f'{label}\t{name}\t{a / 1e6:.1f}\t{b / 1e6:.1f}\t{c / 1e6:.1f}\t{(b - c) / 1e6:.1f}\t{(b - c) / skipped:.1f}\t{ka / 1e6:.1f}\t{kb / 1e6:.1f}\t{kc / 1e6:.1f}\t{(kb - kc) / skipped:.1f}')
    a, b, c, ka, kb, kc = total[:6]
    print(f'{label}\tall\t{a / 1e6:.1f}\t{b / 1e6:.1f}\t{c / 1e6:.1f}\t{(b - c) / 1e6:.1f}\t{(b - c) / skipped:.1f}\t{ka / 1e6:.1f}\t{kb / 1e6:.1f}\t{kc / 1e6:.1f}\t{(kb - kc) / skipped:.1f}')
    print(f'{label}\ttokens {tokens:.0f}, skipped {skipped:.0f}')
