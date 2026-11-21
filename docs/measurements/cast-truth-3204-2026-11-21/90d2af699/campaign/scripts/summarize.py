"""Check exact-head correctness campaign logs and write counts for the evidence record."""
import collections
import pathlib
import re
import sys

root = pathlib.Path(sys.argv[1])
bad = []
def require(predicate, description):
    if not predicate:
        bad.append(description)

for kind, prefix in [('checker', 'test-checker'), ('driver', 'checker-driver')]:
    totals = []
    for part in range(1, 9):
        stem = root / 'tests' / f'{kind}-{part}'
        status = stem.with_suffix('.status').read_text().strip()
        m = re.search(rf'^{prefix}: (\d+) checks, (\d+) failures$', stem.with_suffix('.log').read_text(), re.M)
        require(status == '0' and m is not None and m[2] == '0', f'{stem.name} failed')
        if m:
            totals.append(int(m[1]))
    print(f'{prefix} {len(totals)} shards, {sum(totals):,} checks')
for group in ['inline', 'tests']:
    count = len((root / f'{group}.list').read_text().splitlines())
    for policy in ['default', 'wall', 'everything']:
        path = root / 'sweep' / f'{group}-{policy}.tsv'
        rows = [x.split('\t') for x in path.read_text().splitlines()]
        types = collections.Counter(row[1] for row in rows)
        unsafe = sum(int(row[3]) for row in rows)
        abnormal = [row for row in rows if (row[1],row[2]) not in {('clean','0'),('rejected','1')}]
        require(len(rows) == count and unsafe == 0 and not abnormal, f'{path.name} abnormal: {abnormal[:2]}')
        print(f'{group} {policy} {count:,} inputs, {types["clean"]:,} clean, {types["rejected"]:,} rejected, {unsafe} unsound takes')
superseded = len(sys.argv) == 3 and sys.argv[2] == '--completed-predecessor'
if superseded:
    print((root / 'superseded.txt').read_text().strip())
else:
    summary = (root / 'triggers.txt').read_text().splitlines()[-1]
    print(summary)
    require('93 warnings' in summary and '0 with none' in summary and summary.endswith('0 with a run that differs'), 'trigger mismatch')
    availability = next((line for line in (root / 'triggers.txt').read_text().splitlines() if re.match(r'\s*72 AVAILABILITY\s', line)), '')
    require(availability.count('0+event') == 3, 'availability must produce ID 72 in all three policies')
    files = sorted((root / 'probes').glob('cases*.txt'))
    probes = 0
    for f in files:
        for line in f.read_text().splitlines():
            probes += 1
            require(' status 0 ' in line and 'diff refs 0 facts 0 folds 0 truths 0' in line and line.count(' diff 0') == 2, f'{f.name}: {line[:60]}')
    require(len(files) == 26 and probes == 8009, 'missing probe set')
    print(f'{probes:,} probes in {len(files)} suites')
stats = [0] * 4
for seed in range(61, 67):
    log = (root / 'fuzz' / f'{seed}.log').read_text().strip()
    m = re.fullmatch(rf'seed {seed}: (\d+) programs, (\d+) rejected, (\d+) clean, (\d+) found', log)
    require(m is not None, f'bad fuzz log {seed}')
    if m:
        n, rejected, clean, found = map(int, m.groups())
        require(n == 15000 and n == rejected + clean + found and not found, f'failures seed {seed}')
        for i, x in enumerate([n, rejected, clean, found]):
            stats[i] += x
print('deterministic generator {:,} inputs, {:,} rejected, {:,} clean, {:,} differences'.format(*stats))
for item in bad[:30]:
    print(item, file=sys.stderr)
sys.exit(bool(bad))
