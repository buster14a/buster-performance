#!/usr/bin/env python3
# compare-corpora.py BEFORE_DIR AFTER_DIR: the four corpora's shadow reports (shadow-limited.sh's files), the code
# before against the code after: for each corpus and warning set the counts that say how much is taken (T's at reader
# time, the tests', the rows', C's on the window, the kernel's) and what the new lines count. A line a count that
# differs; then a table.
import re, sys, os
before, after = sys.argv[1], sys.argv[2]
KEYS = [
    ('T taken', r'reader-time T expressions=\d+ records=\d+ typed=\d+ taken=(\d+)'),
    ('T expressions', r'reader-time T expressions=(\d+)'),
    ('T refused callee', r'reader-time T refused=callee expressions=(\d+)'),
    ('T refused leaf', r'reader-time T refused=leaf expressions=(\d+)'),
    ('tests taken there', r'reader-time tests compared=\d+ never-lowered=\d+ taken-there=(\d+)'),
    ('tests refused', r'reader-time tests expressions=\d+ refused=(\d+)'),
    ('C decided', r'window contexts expressions=\d+ records=\d+ decided=(\d+)'),
    ('C refused', r'window contexts expressions=\d+ records=\d+ decided=\d+ \([^)]*\) their-records=\d+ \([^)]*\) of-them-refused=(\d+)'),
    ('rows taken', r'window rows expressions=\d+ records=\d+ taken=(\d+)'),
    ('rows entries', r'window rows expressions=\d+ records=\d+ taken=\d+ \([^)]*\) their-records=\d+ \([^)]*\) their-entries=(\d+)'),
    ('kernel made', r'reader-time fact words made=(\d+)'),
    ('kernel left', r'reader-time fact words made=\d+ \([^)]*\) left=(\d+)'),
    ('lines made again', r"declarations'-lines=\d+ \([^;]*; (\d+) made again"),
    ('summaries kept', r'window summaries compared=(\d+)'),
    ('nothing listed', r'own tests expressions-with-nothing-listed=(\d+)'),
    ('orders left out', r"pointers'-ordered-comparisons-left-out=(\d+)"),
    ('own objects', r"the-program's-own-objects=(\d+)"),
    ('pragma-labelled', r'objects-a-pragma-labelled=(\d+)'),
    ('objects', r'reader-time T objects=(\d+)'),
    ('library calls', r'reader-time T objects=\d+ differences=\d+ library-calls=(\d+)'),
]
def read(path):
    text = open(path).read() if os.path.exists(path) else ''
    out = {}
    for name, pattern in KEYS:
        m = re.search(pattern, text)
        out[name] = int(m.group(1)) if m else None
    return out
rows = []
differ = 0
for corpus in ('sqlite', 'lua', 'musl', 'main'):
    for tag, label in (('--passes0--window-rows--list20', ''), ('--passes0--window-rows-Wall-Wextra--list20', ' -Wall -Wextra')):
        b = read('%s/%s%s.out' % (before, corpus, tag))
        a = read('%s/%s%s.out' % (after, corpus, tag))
        for name, _ in KEYS:
            if b[name] != a[name]:
                differ += 1
                print('%s%s: %s: before %s, after %s' % (corpus, label, name, b[name], a[name]))
        rows.append((corpus + label, a))
print('counts that differ: %d' % differ)
print('| | ' + ' | '.join(r[0] for r in rows) + ' |')
print('| --- |' + ' ---: |' * len(rows))
for name, _ in KEYS:
    print('| %s | ' % name + ' | '.join('-' if r[1][name] is None else '{:,}'.format(r[1][name]) for r in rows) + ' |')
