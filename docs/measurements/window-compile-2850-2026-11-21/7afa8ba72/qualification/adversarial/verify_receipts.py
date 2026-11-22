#!/usr/bin/env python3
"""Check recorded statuses and source fingerprints without running a compiler."""
import csv
import gzip
import hashlib
import json
from collections import Counter
from pathlib import Path

from replay import HERE, load_sources


def rows(name):
    with gzip.open(HERE / 'receipts' / f'{name}.tsv.gz', 'rt') as table:
        return list(csv.DictReader(table, delimiter='\t'))


def check(condition, message):
    if not condition:
        raise ValueError(message)


def main():
    for line in (HERE / 'SHA256SUMS').read_text().splitlines():
        expected, filename = line.split('  ', 1)
        check(hashlib.sha256((HERE / filename).read_bytes()).hexdigest() == expected,
              f'Wrong receipt hash for {filename}')
    source_counts = Counter(entry['group'] for entry, _ in load_sources())
    check(source_counts == {'focused': 28, 'pragmas': 2, 'warnings': 128,
                            'real': 2400, 'runtime': 28, 'sequence': 28}, 'Source totals')
    expected = {'focused': 336, 'options': 420, 'warnings': 384,
                'real': 4800, 'runtime': 112, 'sequence': 112}
    for suite, total in expected.items():
        records = rows(suite)
        fixed = [row for row in records if row.get('image', 'fixed') == 'fixed']
        check(len(fixed) == total, f'{suite} count')
        if suite == 'options':
            baseline = {(row['source'], row['option']): row['status']
                        for row in records if row['image'] == 'ref'}
            check(all(row['status'] == baseline[row['source'], row['option']]
                      and row['same_stdout'] == row['same_stable_stderr'] == row['same_object'] == '1'
                      for row in fixed), 'Stable driver option output')
        elif suite in ('runtime', 'sequence'):
            check(all(row['pair'] == '1' and row['rc'] == '0' for row in fixed), suite)
            dual = {(row['source'], row['mode']): row['actual']
                    for row in records if row['image'] == 'ref'}
            check(all(row['actual'] == dual[row['source'], row['mode']] for row in fixed), suite)
            agreed = sum(row['clang_runtime'] == '1' for row in fixed)
            check(agreed == (112 if suite == 'sequence' else 48), f'{suite} Clang outcomes')
        else:
            key = 'fixed_same' if suite == 'real' else 'same'
            check(all(row[key] == '1' for row in fixed), suite)
            if suite == 'real':
                check(sum(row['mode'] == 'c' and row['ref_status'] == '0' for row in fixed)
                      == 1191, 'Number of native objects')
        print(f'{suite}: {total} matching comparisons')
    check(sum(expected.values()) == 6164, 'Total comparison count')
    print('2,614 input fingerprints and 6,164 comparison outcomes verified.')


if __name__ == '__main__':
    main()
