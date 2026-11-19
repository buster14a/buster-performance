#!/usr/bin/env python3
# analyze-x.py CORPUS=FILE.tsv...: the X census's count. For each of a row's three parts (own, conv, after) and for
# two answers (the number of its entries; its entries' kinds and classes): the smallest set of the lines' features
# found that gives the answer with no conflict on every corpus (backward elimination from all of them, then each
# remaining feature tried again), the rows of that key's table, and the table learned on all corpora but one read on
# the one left out: the records its key gives rightly, wrongly, and those whose key it has not seen (flagged).
import sys, collections, itertools
corpora = {}
names = None
for argument in sys.argv[1:]:
    corpus, path = argument.split('=', 1)
    rows = []
    with open(path) as f:
        header = f.readline().rstrip('\n').split('\t')
        names = header[1:]
        for line in f:
            parts = line.rstrip('\n').split('\t')
            rows.append((int(parts[0]), tuple(parts[1:])))
    corpora[corpus] = rows
features = names[:-3]
part_index = {'own': len(names) - 3, 'conv': len(names) - 2, 'after': len(names) - 1}
total = {c: sum(n for n, _ in rows) for c, rows in corpora.items()}
print('records: ' + ', '.join('%s %d' % (c, total[c]) for c in corpora) + '; unique rows: ' + ', '.join('%s %d' % (c, len(corpora[c])) for c in corpora))

def answer_of(row, part, what):
    text = row[part_index[part]]
    if what == 'count':
        return 0 if text == '-' else text.count(',') + 1
    return text

def conflicts(rows_list, indices, part, what):
    """The records whose answer is not their key's most frequent one, over the rows given."""
    groups = collections.defaultdict(collections.Counter)
    for n, row in rows_list:
        groups[tuple(row[i] for i in indices)][answer_of(row, part, what)] += n
    return sum(sum(c.values()) - max(c.values()) for c in groups.values()), len(groups)

everything = [item for rows in corpora.values() for item in rows]
for part in ('own', 'conv', 'after'):
    distribution = collections.Counter()
    for n, row in everything:
        distribution[answer_of(row, part, 'count')] += n
    print('\n== %s: entries a record: %s' % (part, ', '.join('%d: %d' % kv for kv in sorted(distribution.items()))))
    patterns = collections.Counter()
    for n, row in everything:
        patterns[row[part_index[part]]] += n
    print('   distinct lists of entries: %d; the most frequent: %s' % (len(patterns), '; '.join('%s x%d' % kv for kv in patterns.most_common(8))))
    for what in ('count', 'entries'):
        indices = list(range(len(features)))
        base, _ = conflicts(everything, indices, part, what)
        # Backward elimination: drop a feature where the conflicts stay the full set's.
        changed = True
        while changed:
            changed = False
            for i in list(indices):
                trial = [j for j in indices if j != i]
                c, _ = conflicts(everything, trial, part, what)
                if c <= base:
                    indices = trial
                    changed = True
        c, table = conflicts(everything, indices, part, what)
        print('   %-7s all features leave %d records in conflict; the key found: %s (%d features, %d rows, %d in conflict)' % (
            what + ':', base, ', '.join(features[i] for i in indices), len(indices), table, c))
        for left_out in corpora:
            learned = collections.defaultdict(collections.Counter)
            for corpus, rows in corpora.items():
                if corpus != left_out:
                    for n, row in rows:
                        learned[tuple(row[i] for i in indices)][answer_of(row, part, what)] += n
            right = wrong = unseen = 0
            for n, row in corpora[left_out]:
                key = tuple(row[i] for i in indices)
                if key not in learned:
                    unseen += n
                elif learned[key].most_common(1)[0][0] == answer_of(row, part, what):
                    right += n
                else:
                    wrong += n
            print('      learned without %-8s read on it: right %d (%.2f%%), flagged (key not seen) %d (%.2f%%), wrong %d (%.3f%%)' % (
                left_out, right, 100.0 * right / total[left_out], unseen, 100.0 * unseen / total[left_out], wrong, 100.0 * wrong / total[left_out]))
