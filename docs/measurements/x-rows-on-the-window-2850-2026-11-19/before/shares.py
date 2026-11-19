#!/usr/bin/env python3
# shares.py FILE...: from first-piece.py's reports, the first piece's records by what the sweep reads for them: a
# target that is not the record's type, a member's record, a truth's, an address constant's; and the reference X's
# time's median and range from x-reference.txt.
import re, sys, statistics
for path in sys.argv[1:]:
    text = open(path).read()
    if 'x-reference:' in text:
        by = {}
        for line in text.splitlines():
            m = re.match(r'.*run-(\w+)-\d+\.txt:x-reference: expressions=(\d+) records=(\d+) entries=(\d+) ticks=(\d+)', line)
            if m:
                by.setdefault(m.group(1), []).append((int(m.group(5)) / int(m.group(3)), int(m.group(2)), int(m.group(3)), int(m.group(4))))
        for corpus, runs in by.items():
            values = [r[0] for r in runs]
            print('%s: the reference X: %.2f ticks a record (%.2f to %.2f, %d readings); expressions %d records %d entries %d' % (
                corpus, statistics.median(values), min(values), max(values), len(values), runs[0][1], runs[0][2], runs[0][3]))
        continue
    first = int(re.search(r'first\s+expressions \d+ \([\d.]+%\) records (\d+)', text).group(1))
    owns = re.search(r'own lists: (.*)', text).group(1).split('; ')
    by_template = {}
    address = 0; multi = 0
    for item in owns:
        m = re.match(r't(\d+) (\S+) x(\d+)', item)
        t, kinds, n = int(m.group(1)), m.group(2), int(m.group(3))
        by_template[t] = by_template.get(t, 0) + n
        if t == 1 and kinds.split(',')[0] in ('3', '5'):
            address += n
    other = int(re.search(r'0/value (\d+)', text).group(1))
    lengths = re.search(r'entries a record \(own and conversion\): (.*)', text).group(1)
    print('%s: records %d; a target that is not their type, in a value\'s context: %d (%.1f%%); a member\'s: %d (%.1f%%); a truth\'s: %d (%.1f%%); an address constant of an object: %d (%.1f%%); lengths %s' % (
        path.split('first-piece-')[1].split('.')[0], first, other, 100.0 * other / first, by_template.get(8, 0), 100.0 * by_template.get(8, 0) / first, by_template.get(10, 0),
        100.0 * by_template.get(10, 0) / first, address, 100.0 * address / first, lengths))
