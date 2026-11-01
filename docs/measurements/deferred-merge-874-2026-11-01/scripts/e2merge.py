#!/usr/bin/env python3
"""Count the 2 MB regions of the merge's pass that more than one thread store-faulted.

A store fault at one 4 KB page per thread in a 2 MB region is a huge page's first write; a
thread that faults several pages there is writing base pages, which is not the race.
e2merge.py DIR UNIT...
"""
import collections
import gzip
import os
import re
import sys

WINDOW = 100e-6
directory, units = sys.argv[1], sys.argv[2:]


def operand_has_memory(text):
    depth = 0
    for ch in text:
        if ch == '(':
            depth += 1
        elif ch == ')':
            depth -= 1
        elif ch == ',' and depth == 0:
            return True
    return '(' in text


def is_store(mnemonic, text):
    if not operand_has_memory(text):
        return False
    return not re.match(r'(cmp|test|vptest|kortest|ucomis|comis|bt\b)', mnemonic)


for unit in units:
    for tree in ('fix', 'control'):
        path = os.path.join(directory, f'faults-{tree}-{unit}.txt.gz')
        if not os.path.exists(path):
            continue
        stores = collections.defaultdict(list)
        symbols = collections.defaultdict(collections.Counter)
        for line in gzip.open(path, 'rt', errors='replace'):
            p = line.split()
            if len(p) < 6 or '/' not in p[0] or not p[1].endswith(':'):
                continue
            pid, tid = p[0].split('/')
            address, ip, sym = int(p[2], 16), int(p[-2], 16), p[-1]
            if not (0 < address < 0x800000000000) or ip >= 0x10000000:
                continue
            # The instruction text is in the ops file; the symbol is the fault's own.
            if 'check_deferred_pass' not in sym:
                continue
            stores[address >> 21].append((float(p[1][:-1]), int(tid), address >> 12, sym))
            symbols[address >> 21][sym] += 1
        races = []
        for region, events in stores.items():
            events.sort()
            i = 0
            while i < len(events):
                j = i
                while j < len(events) and events[j][0] - events[i][0] <= WINDOW:
                    j += 1
                burst = events[i:j]
                per = collections.Counter(e[1] for e in burst)
                pages = collections.defaultdict(set)
                for _, tid, page, _ in burst:
                    pages[tid].add(page)
                if len(per) > 1 and max(len(v) for v in pages.values()) == 1:
                    races.append((region, len(per), burst))
                i = j
        print(f'{unit} {tree}: {len(stores)} merge regions with a store fault, {len(races)} with two threads at one page each')
        for region, threads, burst in races:
            print(f'  region {region << 21:#x}: {threads} threads, {len(burst)} faults, symbols ' +
                  ', '.join(f'{k} {v}' for k, v in symbols[region].most_common(3)))
