#!/usr/bin/env python3
# gen-spec.py FETCH NUMBERS OUT: the branches' rows' specification (OUT) from its template beside this file: the first
# table (before-counts.py's, of FETCH's final runs), the count's (count-table.py's), and the numbers its sentences
# quote, each computed here from the piece before's final readings (FETCH's first runs' lines and NUMBERS,
# piece-numbers.py's medians).
import os, re, subprocess, sys
fetch, numbers, out = sys.argv[1], sys.argv[2], sys.argv[3]
here = os.path.dirname(os.path.abspath(__file__))
# The count's lines: beside this file in the record, in before/ where it was written.
before = here + '/before' if os.path.isdir(here + '/before') else here
values = {}
values['before_counts'] = subprocess.run([sys.executable, here + '/before-counts.py', fetch], capture_output=True, text=True, check=True).stdout.strip()
values['count_table'] = subprocess.run([sys.executable, here + '/count-table.py', before + '/9700x-count.txt', before + '/cloud-own-count.txt'], capture_output=True, text=True, check=True).stdout.strip()
pattern = r"listed first for branches=(\d+) with another record that lists them=(\d+) alone=(\d+); of those alone: records evaluated as branches=(\d+) of-them-roots=(\d+) tested values=(\d+) with a conversion's part=(\d+) of a narrow class=(\d+) rows over eight with the test=(\d+) own entries 0\.\.4=(\d+),(\d+),(\d+),(\d+),(\d+)(?: expressions with such a row=(\d+))?"
count = [re.search(pattern, l).groups() for l in open(before + '/9700x-count.txt').read().splitlines()]
own = re.search(pattern, open(before + '/cloud-own-count.txt').read()).groups()
f = lambda x: '{:,}'.format(int(x))
for c, row in zip(('sqlite3', 'lua', 'musl'), count):
    values['alone_' + c] = f(row[2])
    assert row[6] == '0' and row[8] == '0', row
values['own_over'] = f(own[8]); values['own_full'] = f(own[14]); values['own_first'] = f(own[0])
table = open(numbers).read()
for c in ('sqlite3', 'lua', 'musl'):
    text = open('%s/rows-on1-%s-1.txt' % (fetch, c), errors='replace').read()
    swept = int(re.search(r'window rows expressions=\d+ .*? records-swept=(\d+)', text).group(1))
    branched = int(re.search(r'window contexts branched=(\d+)', text).group(1))
    updates = int(re.search(r"an update's line=(\d+)", text).group(1))
    values['one_in_' + c] = '%.0f' % (swept / branched)
    values['branched_' + c] = f(branched)
    values['swept_' + c] = swept; values['updates_' + c] = updates
for c in ('sqlite3', 'lua', 'musl'):
    m = re.search(r"^%s ticks an update: first run on ([\d.]+), on less off ([\d.]+)" % c, table, re.M)
    r = re.search(r"^%s the rows' sweeps, a record swept +on ([\d.]+) " % c, table, re.M)
    per = float(m.group(2))
    values['per_update_' + c] = '%.0f' % per
    values['sum_' + c] = r.group(1)
    values['estimate_' + c] = '%.2f' % (per * int(values['branched_' + c].replace(',', '')) / values['swept_' + c])
text = open(here + '/spec-template.md').read()
for key, value in values.items():
    text = text.replace('@@%s@@' % key, str(value))
open(out, 'w').write(text)
print('left:', sorted(set(re.findall(r'@@(\w+)@@', text))), 'bytes', len(text))
print({k: v for k, v in values.items() if k not in ('before_counts', 'count_table')})
