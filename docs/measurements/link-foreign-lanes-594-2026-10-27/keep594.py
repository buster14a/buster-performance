#!/usr/bin/env python3
# keep594.py SOURCE DESTINATION: a log of #594's runs without exclusive.sh's lock messages, which name other sessions'
# commands and links: only the lines this record's own tools print, from the first line that matches the log's kind
# (by its name) onward, without any later lock block. A log of no own line is written empty.
import re
import sys

STARTS = [
    (r'build-v\d\.log$', r'^build\.sh: '),
    (r'links/.*\.log$', r'^benchmark-link: '),
    (r'linkbench594-.*\.log$', r'^benchmark-link: '),
    (r'v1-test-foreign_--cross-check\.log$', r'^  programs: |^programs: '),
    (r'(setup594|sweep594|confirm594)\.log$', r'^'),
    (r'outputs594\.txt$', r'^'),
]
source, destination = sys.argv[1], sys.argv[2]
start = None
for pattern, first in STARTS:
    if re.search(pattern, source):
        start = re.compile(first)
assert start is not None, source
lines = open(source, errors='replace').read().splitlines()
kept = []
on = False
blocked = False
meta = False
for line in lines:
    if line.startswith('exclusive.sh: '):
        blocked = True
        meta = False
        continue
    if blocked:
        # A holder's command may span lines; its title, link and pull request lines end its block. Before the log's
        # own first line, that line ends it too.
        if line.startswith('  title: ') or line.startswith('  link: ') or line.startswith('  pull request: '):
            meta = True
            continue
        if not meta and (on or not start.match(line)):
            continue
        blocked = False
    if not on and start.match(line):
        on = True
    if on:
        kept.append(line)
open(destination, 'w').write('\n'.join(kept) + ('\n' if kept else ''))
