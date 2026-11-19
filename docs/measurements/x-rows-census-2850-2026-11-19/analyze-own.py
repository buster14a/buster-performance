#!/usr/bin/env python3
# analyze-own.py CORPUS=FILE.tsv...: the X census's own part, a template at a time: its records, its distinct lists of
# entries, and the smallest set of features found (backward elimination) that gives the number of its entries and the
# entries themselves; with features derived as X's code reads them (whether it loads, a narrow class, a constant's kind).
import sys, collections
rows = []
for argument in sys.argv[1:]:
    corpus, path = argument.split('=', 1)
    with open(path) as f:
        names = f.readline().rstrip('\n').split('\t')[1:]
        for line in f:
            parts = line.rstrip('\n').split('\t')
            rows.append((int(parts[0]), dict(zip(names, parts[1:]))))
ADDRESS_CONTEXT = 1  # BUSTER_CHECK_LOWER_TEMPLATE_ADDRESS, read from the lines below
def derive(row):
    d = dict(row)
    ctx = int(row['ctx']); facts = int(row['facts']); c0 = int(row['c0class']); c1 = int(row['c1class']); cls = int(row['class']); up = int(row['up'])
    d['facts_address'] = str((facts >> 2) & 1)
    d['narrow0'] = str(1 if 1 <= c0 <= 4 else 0)
    d['narrow1'] = str(1 if 1 <= c1 <= 4 else 0)
    d['class_group'] = 'i8-i64' if cls in (1, 3, 5, 7) else 'u8-u64' if cls in (2, 4, 6, 8) else 'float' if cls in (9, 10) else 'other'
    d['plan'] = str(up & 0x7f)
    d['plan_classes'] = '%d/%d/%d' % ((up >> 8) & 0xff, (up >> 16) & 0xff, (up >> 24) & 0xff)
    return d
derived = [(n, derive(r)) for n, r in rows]
features = ['op', 'class', 'class_group', 'kind', 'facts_address', 'category', 'constant', 'flags', 'ctx', 'state', 'c0class', 'narrow0', 'c1class', 'narrow1', 'ob', 'off', 'mo', 'plan', 'plan_classes', 'last', 'tclass', 'same']
def answer(row, what):
    text = row['own']
    return (0 if text == '-' else text.count(',') + 1) if what == 'count' else text
def conflicts(items, keys, what):
    groups = collections.defaultdict(collections.Counter)
    for n, row in items:
        groups[tuple(row[k] for k in keys)][answer(row, what)] += n
    return sum(sum(c.values()) - max(c.values()) for c in groups.values()), len(groups)
by_template = collections.defaultdict(list)
for n, row in derived:
    by_template[int(row['tpl'])].append((n, row))
NAMES = {0: 'NONE', 1: 'CONSTANT', 2: 'VOID', 3: 'ADDRESS', 4: 'LOCAL', 5: 'GLOBAL', 6: 'PASS', 7: 'DEREFERENCE', 8: 'MEMBER', 9: 'UNARY', 10: 'TRUTH', 11: 'BINARY', 12: 'POINTER', 13: 'STORE_LOCAL',
         14: 'STORE_GLOBAL', 15: 'STORE', 16: 'BRANCH', 17: 'DECIDED', 18: 'SECOND', 19: 'CALL', 20: 'UPDATE', 21: 'BRANCHES', 255: 'not evaluated'}
total = sum(n for n, _ in derived)
print('records %d' % total)
for template in sorted(by_template):
    items = by_template[template]
    records = sum(n for n, _ in items)
    patterns = collections.Counter()
    counts = collections.Counter()
    for n, row in items:
        patterns[row['own']] += n
        counts[answer(row, 'count')] += n
    line = '%-14s %7d records (%5.2f%%); entries: %s; %d lists' % (NAMES.get(template, str(template)), records, 100.0 * records / total, ' '.join('%d:%d' % kv for kv in sorted(counts.items())), len(patterns))
    print(line)
    for what in ('count', 'entries'):
        keys = list(features)
        base, _ = conflicts(items, keys, what)
        changed = True
        while changed:
            changed = False
            for k in list(keys):
                trial = [j for j in keys if j != k]
                c, _ = conflicts(items, trial, what)
                if c <= base:
                    keys = trial
                    changed = True
        c, table = conflicts(items, keys, what)
        print('      %-8s by %s: %d rows, %d records in conflict' % (what, ', '.join(keys) if keys else '(nothing)', table, c))
    if len(patterns) <= 6:
        print('      lists: ' + '; '.join('%s x%d' % kv for kv in patterns.most_common()))
    else:
        print('      most: ' + '; '.join('%s x%d' % kv for kv in patterns.most_common(6)))
