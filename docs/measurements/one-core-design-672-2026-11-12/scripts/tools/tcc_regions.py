#!/usr/bin/env python3
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
#
# tcc_regions.py RESULTS/tcc TOKENS: tccprofile.sh's samples by region of the package's stripped libtcc.so. The library
# exports its ST_FUNC functions, and its text keeps its source files' order but for a few small functions, so the
# address ranges between chosen exported symbols stand for the source files: a sample in a static function, which perf
# can't name, goes to its file by its address, the library's load base in its process taken from the nearest named
# sample. Prints each region's and each exported symbol's cycles and instructions per token.
import gzip, re, sys, collections

directory, tokens = sys.argv[1], int(sys.argv[2])
symbols = {}
ordered = []
for line in open(f'{directory}/libtcc-symbols.txt'):
    p = line.split()
    if len(p) == 3 and p[1] in 'Tt':
        symbols[p[2]] = int(p[0], 16)
        ordered.append((int(p[0], 16), p[2]))
ordered.sort()
text_low, text_high = ordered[0][0], ordered[-1][0] + 0x4000
bounds = [(symbols['get_tok_str'], 'libtcc.c: allocation, strings, options'),
          (symbols['gsym'], 'tccpp.c: lexer and preprocessor'),
          (symbols['tcc_tcov_block_end'], 'tccgen.c: parser, semantics, code generation'),
          (symbols['g'], 'tccelf.c, tccdbg.c, tccasm.c, tccrun.c: object file'),
          (1 << 62, 'x86_64-gen.c, i386-asm.c: machine code')]

def region(address):
    for limit, name in bounds:
        if address < limit:
            return name
    return bounds[-1][1]

def nearest(address):
    name = '?'
    for a, n in ordered:
        if a > address:
            break
        name = n
    return name

LINE = re.compile(r'^\s*(\d+)\s+(\S+):\s+([0-9a-f]+)\s+(\S+)\s+\((.*)\)\s*$')
samples = []
with gzip.open(f'{directory}/samples.gz', 'rt') as f:
    for line in f:
        m = LINE.match(line)
        if m:
            samples.append((int(m.group(1)), m.group(2), int(m.group(3), 16), m.group(4), m.group(5)))
# The library's base at each named sample; an unnamed one takes the nearer named sample's base that puts it in the text.
bases = [None] * len(samples)
for i, (period, event, ip, symoff, dso) in enumerate(samples):
    if dso.endswith('libtcc.so') and '+' in symoff:
        name, offset = symoff.rsplit('+', 1)
        if name in symbols:
            bases[i] = ip - symbols[name] - int(offset, 16)
before = [None] * len(samples)
last = None
for i in range(len(samples)):
    if bases[i] is not None: last = bases[i]
    before[i] = last
after = [None] * len(samples)
last = None
for i in range(len(samples) - 1, -1, -1):
    if bases[i] is not None: last = bases[i]
    after[i] = last
total = collections.Counter()
regions = collections.defaultdict(collections.Counter)
functions = collections.defaultdict(collections.Counter)
unplaced = 0
for i, (period, event, ip, symoff, dso) in enumerate(samples):
    total[event] += period
    if dso.endswith('libtcc.so'):
        address = None
        for base in (bases[i], before[i], after[i]):
            if base is not None and text_low <= ip - base < text_high:
                address = ip - base
                break
        if address is None:
            unplaced += period if event == 'cycles:u' else 0
            regions['libtcc.so, unplaced'][event] += period
        else:
            regions[region(address)][event] += period
            functions[nearest(address)][event] += period
    elif 'libc' in dso:
        regions['libc: memcpy, malloc, read'][event] += period
    else:
        regions['loader, shell and the rest'][event] += period
runs = 8
print(f'# tcc -c sqlite3.c, {runs} compiles, per compile; per token over {tokens} tokens (buster\'s count of the same unit)')
print('region\tcycles\tinstructions\tcycles/token\tinstructions/token\tIPC\tshare\tmispredicts/token\tL1 fills/token')
for name, c in sorted(regions.items(), key=lambda x: -x[1]['cycles:u']):
    cycles, instructions = c['cycles:u'] / runs, c['instructions:u'] / runs
    print(f"{name}\t{cycles:.0f}\t{instructions:.0f}\t{cycles / tokens:.1f}\t{instructions / tokens:.1f}\t{instructions / cycles:.2f}\t{100 * c['cycles:u'] / total['cycles:u']:.1f}%\t{c['ex_ret_brn_misp:u'] / runs / tokens:.2f}\t{c['ls_dmnd_fills_from_sys.all:u'] / runs / tokens:.2f}")
print(f"total\t{total['cycles:u'] / runs:.0f}\t{total['instructions:u'] / runs:.0f}\t{total['cycles:u'] / runs / tokens:.1f}\t{total['instructions:u'] / runs / tokens:.1f}")
print('# by the exported symbol at or before the sample (a static function falls under the one before it)')
for name, c in sorted(functions.items(), key=lambda x: -x[1]['cycles:u'])[:45]:
    print(f"{name}\t{c['cycles:u'] / runs / tokens:.1f}\t{c['instructions:u'] / runs / tokens:.1f}\t{region(symbols[name])}")
