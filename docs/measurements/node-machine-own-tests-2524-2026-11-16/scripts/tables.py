#!/usr/bin/env python3
# tables.py [RECORD]: every table of the record's README, from the result files under results/9700x (python3 -I).
import glob, os, re, statistics, sys

root = sys.argv[1] if len(sys.argv) > 1 else os.path.join(os.path.dirname(os.path.abspath(__file__)), '..')
results = os.path.join(root, 'results', '9700x')
CORPORA = ['sqlite3', 'lua', 'musl']
READER = r'reader-time T expressions=(\d+) records=(\d+) typed=(\d+) taken=(\d+) roots-not-run=(\d+) late-types=(\d+) ticks=(\d+) setup-ticks=(\d+)'

def good(text):
    return re.search(r'^status 0$', text, re.M) is not None

# A run with a part of the own form switched off refuses other expressions than the census: its status is 1, and its
# ticks are read all the same.
def runs(label, tag, corpus, suffix):
    values = []
    for path in sorted(glob.glob(os.path.join(results, label, 'types-%s-%s-%s-*.txt' % (tag, corpus, suffix)))):
        text = open(path, errors='replace').read()
        match = re.search(READER, text)
        if match and (good(text) or tag.startswith('skip')):
            values.append(int(match.group(7)) / int(match.group(3)))
    return values

def median(label, tag, corpus, suffix):
    values = runs(label, tag, corpus, suffix)
    return statistics.median(values) if values else None

def cell(value, form='%.1f'):
    return form % value if value is not None else '-'

def less(a, b):
    return a - b if a is not None and b is not None else None

def suffixes(label, tag):
    found = set()
    for path in glob.glob(os.path.join(results, label, 'types-%s-sqlite3-*-1.txt' % tag)):
        found.add(os.path.basename(path).split('-')[3])
    return sorted(found)

print('1. TSC ticks a typed record at reader time, by build (medians; runs a row: sqlite3.c, Lua, musl)')
print('   sweeps = T, C and X; tests = with the census\'s code on the view; own = with the own form')
for label in ['o1', 'o2', 'o3', 'o4', 'o5', 'o6', 'o7', 'o8']:
    for suffix in suffixes(label, 'own'):
        sweeps_suffix = suffix if runs(label, 'sweeps', 'sqlite3', suffix) else (suffixes(label, 'sweeps') or [suffix])[0]
        for tag in ['sweeps', 'tests', 'own', 'testslast', 'ownlast']:
            tag_suffix = sweeps_suffix if tag in ('sweeps', 'tests', 'testslast') and not runs(label, tag, 'sqlite3', suffix) else suffix
            values = [median(label, tag, corpus, tag_suffix) for corpus in CORPORA]
            if values[0] is None:
                continue
            counts = '/'.join(str(len(runs(label, tag, corpus, tag_suffix))) for corpus in CORPORA)
            spans = '; '.join('%.1f to %.1f' % (min(v), max(v)) if v else '-' for v in [runs(label, tag, corpus, tag_suffix) for corpus in CORPORA])
            line = '   %-3s %-2s %-10s %7s %7s %7s   runs %s   (%s)' % (label, tag_suffix, tag, cell(values[0]), cell(values[1]), cell(values[2]), counts, spans)
            if tag != 'sweeps':
                base = [median(label, 'sweeps', corpus, sweeps_suffix) for corpus in CORPORA]
                # The difference of the two medians as printed, to a tenth.
                line += '   less the sweeps: %s %s %s' % tuple(cell(less(round(values[i], 1) if values[i] is not None else None, round(base[i], 1) if base[i] is not None else None)) for i in range(3))
            print(line)

print()
print('2. The own form\'s parts (build o8x, BUSTER_NODE_TESTS_SKIP; ticks a typed record, medians of 7; sqlite3.c, Lua)')
def skip(label, bits, corpus, suffix):
    return median(label, 'skip%d' % bits, corpus, suffix)
sweeps = [median('o8', 'sweeps', corpus, 'n') for corpus in ['sqlite3', 'lua']]
rows = [('everything (skip 0)', lambda c: skip('o8x', 0, c, 'n')),
        ('the leaves\' tests (0 less 1)', lambda c: less(skip('o8x', 0, c, 'n'), skip('o8x', 1, c, 'n'))),
        ('the tree\'s tests (0 less 2)', lambda c: less(skip('o8x', 0, c, 'n'), skip('o8x', 2, c, 'n'))),
        ('the operators\' tests (0 less 4)', lambda c: less(skip('o8x', 0, c, 'n'), skip('o8x', 4, c, 'n'))),
        ('  the calls (0 less 32)', lambda c: less(skip('o8x', 0, c, 'n'), skip('o8x', 32, c, 'n'))),
        ('  a constant operand alone (0 less 64)', lambda c: less(skip('o8x', 0, c, 'n'), skip('o8x', 64, c, 'n'))),
        ('  the other operators (0 less 256)', lambda c: less(skip('o8x', 0, c, 'n'), skip('o8x', 256, c, 'n'))),
        ('  the walk and the census\'s visits (0 less 128)', lambda c: less(skip('o8x', 0, c, 'n'), skip('o8x', 128, c, 'n'))),
        ('the expression\'s own tests (0 less 8)', lambda c: less(skip('o8x', 0, c, 'n'), skip('o8x', 8, c, 'n'))),
        ('the loop over the records (15 less 31)', lambda c: less(skip('o8x', 15, c, 'n'), skip('o8x', 31, c, 'n'))),
        ('all four lists\' tests (0 less 15)', lambda c: less(skip('o8x', 0, c, 'n'), skip('o8x', 15, c, 'n'))),
        ('nothing but the call (skip 31)', lambda c: skip('o8x', 31, c, 'n'))]
for name, value in rows:
    print('   %-50s %7s %7s' % (name, cell(value('sqlite3')), cell(value('lua'))))
print('   %-50s %7s %7s' % ('the sweeps alone (build o8)', cell(sweeps[0]), cell(sweeps[1])))
print('   %-50s %7s %7s' % ('the shell (skip 31 less o8\'s sweeps)', cell(less(skip('o8x', 31, 'sqlite3', 'n'), sweeps[0])), cell(less(skip('o8x', 31, 'lua', 'n'), sweeps[1]))))
print('   %-50s %7s %7s' % ('the own form (skip 0 less o8\'s sweeps)', cell(less(skip('o8x', 0, 'sqlite3', 'n'), sweeps[0])), cell(less(skip('o8x', 0, 'lua', 'n'), sweeps[1]))))

print()
print('2b. The parts by build (the same knob in o4x, o5x, o6x and o8x; sqlite3.c, then Lua)')
def any_suffix(label, bits, corpus):
    values = []
    for path in sorted(glob.glob(os.path.join(results, label, 'types-skip%d-%s-*-*.txt' % (bits, corpus)))):
        match = re.search(READER, open(path, errors='replace').read())
        if match:
            values.append(int(match.group(7)) / int(match.group(3)))
    return statistics.median(values) if values else None
for label in ['o4x', 'o5x', 'o6x', 'o8x']:
    line = '   %-4s' % label
    for corpus in ['sqlite3', 'lua']:
        line += ' | %s: leaves %s, operators %s, tree %s, the expression\'s own %s, the loop %s' % (
            corpus, cell(less(any_suffix(label, 0, corpus), any_suffix(label, 1, corpus))), cell(less(any_suffix(label, 0, corpus), any_suffix(label, 4, corpus))),
            cell(less(any_suffix(label, 0, corpus), any_suffix(label, 2, corpus))), cell(less(any_suffix(label, 0, corpus), any_suffix(label, 8, corpus))),
            cell(less(any_suffix(label, 15, corpus), any_suffix(label, 31, corpus))))
    print(line)

print()
print('3. The loop\'s indexed lookups (build o8y: 15 = the loop alone; +512 no type byte, +1024 no role, +2048 no operand bytes)')
for name, value in [('the loop (15 less 31)', lambda c: less(skip('o8y', 15, c, 'p'), skip('o8y', 31, c, 'p'))),
                    ('a record\'s type\'s byte (15 less 527)', lambda c: less(skip('o8y', 15, c, 'p'), skip('o8y', 527, c, 'p'))),
                    ('a record\'s token\'s role (15 less 1039)', lambda c: less(skip('o8y', 15, c, 'p'), skip('o8y', 1039, c, 'p'))),
                    ('its operands\' bytes (15 less 2063)', lambda c: less(skip('o8y', 15, c, 'p'), skip('o8y', 2063, c, 'p'))),
                    ('all three (15 less 3599)', lambda c: less(skip('o8y', 15, c, 'p'), skip('o8y', 3599, c, 'p'))),
                    ('the loop without them (3599 less 31)', lambda c: less(skip('o8y', 3599, c, 'p'), skip('o8y', 31, c, 'p')))]:
    print('   %-50s %7s %7s' % (name, cell(value('sqlite3')), cell(value('lua'))))

print()
print('4. What the own form\'s loop lists and sends (build o8; one run a row)')
OWN = r"own tests expressions=(\d+) records=(\d+) expressions-with-a-record-sent=(\d+) \(([\d.]+)%\) records-sent=(\d+) \(([\d.]+)%\) walks=(\d+) \(([\d.]+)%\) (?:compared-with-the-census's-code )?differences=(\d+) walks-of-another-count=(\d+)"
LISTS = r"own tests listed leaves=(\d+) \(([\d.]+)%\) tree=(\d+) \(([\d.]+)%\) operators=(\d+) \(([\d.]+)%: calls (\d+), with a constant operand (\d+), with a third operand (\d+)\)"
for name, tag, suffix in [('default warnings', 'own', 'n'), ('default, --verify', 'verifyown', 'wall'), ('-Wall -Wextra, --verify', 'wallown', 'wall')]:
    for corpus in CORPORA:
        for path in sorted(glob.glob(os.path.join(results, 'o8', 'types-%s-%s-%s-*.txt' % (tag, corpus, suffix))))[:1]:
            text = open(path, errors='replace').read()
            own = re.search(OWN, text)
            lists = re.search(LISTS, text)
            if not own or not lists:
                print('   %-24s %-8s no report in %s' % (name, corpus, os.path.basename(path)))
                continue
            print('   %-24s %-8s expressions %s records %s; leaves %s%% tree %s%% operators %s%% (calls %s, constant operand %s, third operand %s); records sent %s (%s%%), expressions walked %s (%s%%); differences %s, walks of another count %s; status 0: %s' % (
                name, corpus, own.group(1), own.group(2), lists.group(2), lists.group(4), lists.group(6), lists.group(7), lists.group(8), lists.group(9),
                own.group(5), own.group(6), own.group(7), own.group(8), own.group(9), own.group(10), 'yes' if good(text) else 'NO'))
            for sent in re.findall(r"own tests sent-by=(\S+) (records|expressions)=(\d+) \(([\d.]+)%\)", text):
                print('   %-24s %-8s   sent by %-22s %s %s (%s%%)' % ('', '', sent[0], sent[1], sent[2], sent[3]))

print()
print('5. buster#2871\'s operators\' kernel without (p1) and with (p2) the reader-time series: cycles an evaluated node, six runs in turn')
OPS = r"the operators' kernel a unit: cycles=(\d+) instructions=(\d+) mispredicted-branches=(\d+); a record it made: cycles=([\d.]+); a record of the windows: cycles=([\d.]+) instructions=([\d.]+) mispredicted-branches=([\d.]+); an evaluated node: cycles=([\d.]+) instructions=([\d.]+)"
OPREC = r"node-facts: operators records=(\d+) taken=(\d+) \(([\d.]+)%\)"
for corpus in CORPORA:
    for suffix, what in [('-ops', 'whole records'), ('-opslean', 'lean records')]:
        line = '   %-8s %-14s' % (corpus, what)
        for label in ['p1', 'p2']:
            values, instructions, taken, failed = [], [], '', 0
            for path in sorted(glob.glob(os.path.join(results, label, 'facts-%s%s-[0-9]*.txt' % (corpus, suffix)))):
                text = open(path, errors='replace').read()
                match = re.search(OPS, text)
                if not match or not good(text):
                    failed += 1
                    continue
                values.append(float(match.group(8)))
                instructions.append(float(match.group(9)))
                taken = re.search(OPREC, text).group(3)
            line += ' | %s: %.2f (%.2f to %.2f), %.2f instructions, taken %s%%, %d runs%s' % (
                label, statistics.median(values), min(values), max(values), statistics.median(instructions), taken, len(values), ', %d failed' % failed if failed else '') if values else ' | %s: no runs' % label
        print(line)
