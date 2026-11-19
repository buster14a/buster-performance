#!/usr/bin/env python3
# analyze-shapes.py CORPUS=FILE.tsv... (the second census's files, with `uk`): X's rows as a table's rows. For each
# part: the key, derived as X's code reads its inputs; whether the key gives the number of entries and their kinds
# with no conflict; and whether each entry's class is, for every record of a key, one same source: a class the record
# has (its own, its two conversions', its target's, an update's stored, calculated and computing ones) or a fixed one.
import sys, collections
corpora = {}
for argument in sys.argv[1:]:
    corpus, path = argument.split('=', 1)
    rows = []
    with open(path) as f:
        names = f.readline().rstrip('\n').split('\t')[1:]
        for line in f:
            parts = line.rstrip('\n').split('\t')
            rows.append((int(parts[0]), dict(zip(names, parts[1:]))))
    corpora[corpus] = rows
NARROW = (1, 2, 3, 4)
def derive(row):
    d = dict(row)
    ctx = int(row['ctx']); facts = int(row['facts']); cls = int(row['class']); tpl = int(row['tpl']); op = int(row['op']); up = int(row['up']); uk = int(row['uk']); state = int(row['state'])
    tfacts = int(row['tfacts']); tclass = int(row['tclass'])
    d['loads'] = str(1 if (ctx & 1) == 0 and (facts & 4) == 0 else 0)
    d['narrow0'] = str(1 if int(row['c0class']) in NARROW else 0)
    d['narrow1'] = str(1 if int(row['c1class']) in NARROW else 0)
    constant = tpl in (1, 3)
    d['cshape'] = '%s/%s/%s/%s/%s/%s' % (ctx & 2, row['constant'], row['category'], 'i' if cls in (1, 3, 5, 7) else 'u' if cls in (2, 4, 6, 8) else 'f' if cls in (9, 10) else 'o', row['ob'], row['off']) if constant else '-'
    d['folded'] = row['fold'] if constant else '-'
    update = tpl == 20
    stored = (up >> 8) & 0xff; calculated = (up >> 16) & 0xff; computing = (up >> 24) & 0xff
    d['plan'] = '%d/%d/%d/%d/%d' % (up & 0x7f, uk & 0xff, (uk >> 8) & 0xff, (uk >> 16) & 0xff, (uk >> 24) & 0xff) if update else '-'
    # The plan's classes as X compares them: which are the same, and which are narrow.
    d['plan_relation'] = '%d%d%d/%d' % (stored == calculated, calculated == computing, stored == computing, 1 if stored in NARROW else 0) if update else '-'
    d['evaluated'] = str(state & 1)
    converts = ctx == 0 and row['same'] == '0'
    d['converts'] = str(1 if converts else 0)
    d['tshape'] = '%d/%d' % (tclass, tfacts & 0x93) if converts else '-'
    d['fshape'] = '%d/%d' % (cls, facts & 0x83) if converts else '-'
    split = (state & 8) != 0
    d['after_state'] = str(state & 0xfe)
    d['split_plan'] = '%d/%d/%d/%d/%d' % (up & 0x7f, uk & 0xff, (uk >> 8) & 0xff, (uk >> 16) & 0xff, (uk >> 24) & 0xff) if split else '-'
    d['split_relation'] = '%d%d%d/%d' % (stored == calculated, calculated == computing, stored == computing, 1 if stored in NARROW else 0) if split else '-'
    d['hook_narrow'] = str(1 if int(row['hc0class']) in NARROW else 0) if (state & 2) != 0 else '-'
    d['branch_narrow'] = str(1 if tclass in NARROW else 0) if (state & 0x10) != 0 else '-'
    d['hook_void'] = str(1 if int(row['hclass']) == 0 else 0) if (state & 4) != 0 else '-'
    d['hook_or'] = str(1 if row['hop'] == '22' else 0) if (state & 2) != 0 else '-'
    d['sources'] = {'own': cls, 'c0': int(row['c0class']), 'c1': int(row['c1class']), 'target': tclass, 'stored': stored if (update or split) else -1, 'calculated': calculated if (update or split) else -1,
                    'computing': computing if (update or split) else -1, 'hook': int(row['hclass']), 'hook_c0': int(row['hc0class'])}
    return d
derived = {c: [(n, derive(r)) for n, r in rows] for c, rows in corpora.items()}
total = {c: sum(n for n, _ in rows) for c, rows in derived.items()}
everything = [item for rows in derived.values() for item in rows]
KEYS = {
    'own': ['tpl', 'loads', 'mo', 'narrow0', 'narrow1', 'op', 'cshape', 'folded', 'plan', 'plan_relation'],
    'conv': ['evaluated', 'converts', 'fold', 'fshape', 'tshape'],
    'after': ['after_state', 'split_plan', 'split_relation', 'hook_narrow', 'branch_narrow', 'hook_void', 'hook_or', 'ob'],
}
print('records: ' + ', '.join('%s %d' % (c, total[c]) for c in derived))
for part, keys in KEYS.items():
    kinds_of = lambda row: '-' if row[part] == '-' else ','.join(e.split(':')[0] for e in row[part].split(','))
    groups = collections.defaultdict(collections.Counter)
    for n, row in everything:
        groups[tuple(row[k] for k in keys)][kinds_of(row)] += n
    conflict = sum(sum(c.values()) - max(c.values()) for c in groups.values())
    longest = max((0 if k == '-' else k.count(',') + 1) for c in groups.values() for k in c)
    print('\n%s: key %s: %d rows; the kinds (and so the number) of its entries: %d records in conflict; the longest list %d entries' % (part, ', '.join(keys), len(groups), conflict, longest))
    for lost, k, c in sorted(((sum(c.values()) - max(c.values()), k, c) for k, c in groups.items() if len(c) > 1), key=lambda x: -x[0])[:4]:
        print('      in conflict %d: %s -> %s' % (lost, dict(zip(keys, k)), dict(c.most_common(4))))
    # Each entry's class: the sources that give it for every record of the key and list of kinds.
    possible = {}
    counts = collections.Counter()
    for n, row in everything:
        if row[part] == '-':
            continue
        key = (tuple(row[k] for k in keys), kinds_of(row))
        classes = [int(e.split(':')[1]) for e in row[part].split(',')]
        sets = []
        for c in classes:
            s = {name for name, value in row['sources'].items() if value == c}
            s.add('=%d' % c)
            sets.append(s)
        if key in possible:
            possible[key] = [a & b for a, b in zip(possible[key], sets)]
        else:
            possible[key] = sets
        counts[key] += n
    unsourced = sum(counts[key] for key, sets in possible.items() if any(len(s) == 0 for s in sets))
    entries = sum(len(sets) * counts[key] for key, sets in possible.items())
    by_source = collections.Counter()
    for key, sets in possible.items():
        for s in sets:
            order = ['own', 'c0', 'c1', 'target', 'stored', 'calculated', 'computing', 'hook', 'hook_c0']
            fixed = [x for x in s if x.startswith('=')]
            choice = fixed[0] if fixed else next((x for x in order if x in s), 'NONE')
            by_source['fixed' if choice.startswith('=') else choice] += counts[key]
    print('   classes: %d entries of %d records; records with an entry whose class no one source gives for its whole key: %d; an entry\'s class by source: %s' % (
        entries, sum(counts.values()), unsourced, ', '.join('%s %d' % kv for kv in by_source.most_common())))
    for key, sets in sorted(possible.items(), key=lambda kv: -counts[kv[0]]):
        if any(len(s) == 0 for s in sets):
            print('      no one source: %s kinds %s (%d records)' % (dict(zip(keys, key[0])), key[1], counts[key]))
            break

# The gates: each part's key learned on three corpora and read on the fourth (the entries' kinds, and so their number);
# the rows that cover 98% and 99% of a corpus's records; and the entries a record, all three parts together.
print()
for part, keys in KEYS.items():
    kinds_of = lambda row: '-' if row[part] == '-' else ','.join(e.split(':')[0] for e in row[part].split(','))
    for left_out in derived:
        learned = collections.defaultdict(collections.Counter)
        for corpus, rows in derived.items():
            if corpus != left_out:
                for n, row in rows:
                    learned[tuple(row[k] for k in keys)][kinds_of(row)] += n
        right = wrong = unseen = 0
        for n, row in derived[left_out]:
            key = tuple(row[k] for k in keys)
            if key not in learned:
                unseen += n
            elif learned[key].most_common(1)[0][0] == kinds_of(row):
                right += n
            else:
                wrong += n
        print('%-5s learned without %-8s read on it: right %d (%.2f%%), flagged %d (%.2f%%), wrong %d' % (part, left_out, right, 100.0 * right / total[left_out], unseen, 100.0 * unseen / total[left_out], wrong))
    for corpus, rows in derived.items():
        by_key = collections.Counter()
        for n, row in rows:
            by_key[tuple(row[k] for k in keys)] += n
        covered = 0; needed = {}
        for i, (key, n) in enumerate(by_key.most_common()):
            covered += n
            for share in (0.98, 0.99, 0.999):
                if share not in needed and covered >= share * total[corpus]:
                    needed[share] = i + 1
        print('%-5s %-8s rows that cover 98%%, 99%% and 99.9%% of its records: %d, %d, %d of %d' % (part, corpus, needed[0.98], needed[0.99], needed[0.999], len(by_key)))
sizes = collections.Counter()
for n, row in everything:
    size = sum(0 if row[p] == '-' else row[p].count(',') + 1 for p in ('own', 'conv', 'after'))
    sizes[size] += n
print('entries a record, the three parts together: ' + ', '.join('%d: %d' % kv for kv in sorted(sizes.items())))
print('entries: %d for %d records (%.3f a record)' % (sum(k * v for k, v in sizes.items()), sum(sizes.values()), sum(k * v for k, v in sizes.items()) / sum(sizes.values())))
