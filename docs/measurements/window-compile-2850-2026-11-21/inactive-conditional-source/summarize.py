#!/usr/bin/env python3
"""Summarize records emitted by the instrumented preprocessor (standard input)."""
import csv
import sys
from collections import Counter

files = Counter()
ranges = {}
for line in sys.stdin:
    kind, *fields = line.rstrip().split('\t')
    if kind == 'pp-group-file':
        length, tokens, identifiers, directives = map(int, fields)
        files[length] += 1
        row = ranges.setdefault(length, [0] * 8)
        for i, n in enumerate((tokens, identifiers, directives)):
            row[i] += n
    elif kind == 'pp-group-skip':
        length, inclusion, begin, end, start, stop, names, directives = map(int, fields)
        if end < begin or stop < start:
            raise ValueError(line)
        row = ranges[length]
        for i, n in enumerate((1, end - begin, stop - start, names, directives), start=3):
            row[i] += n
writer = csv.writer(sys.stdout, delimiter='\t', lineterminator='\n')
writer.writerow(('file_bytes', 'preparations', 'raw_tokens', 'raw_identifiers', 'directives',
                 'skipped_groups', 'skipped_tokens', 'skipped_bytes', 'skipped_identifiers', 'skipped_directive_tokens'))
for length in sorted(ranges, reverse=True):
    writer.writerow((length, files[length], *ranges[length]))
