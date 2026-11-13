#!/usr/bin/env python3
# Remove exclusive.sh's "waiting for the 9700X, held by: ..." blocks, which quote
# other sessions' commands and links. In a locked() log the block ends at the
# first line the wrapper itself prints (a bare `date -u +%FT%TZ` stamp); in an
# outer hold log (stderr of exclusive.sh only) the whole file is the block.
import re, sys
stamp = re.compile(r'^\d{4}-\d\d-\d\dT\d\d:\d\d:\d\dZ$')
for path in sys.argv[1:]:
    lines = open(path).read().split('\n')
    out, skipping = [], False
    for line in lines:
        if line.startswith('exclusive.sh: waiting for the 9700X'):
            skipping = True
            out.append('[exclusive.sh lock-wait message removed: it names another session]')
            continue
        if skipping and (stamp.match(line) or line.startswith('exclusive.sh: other processes busy')):
            skipping = False
        if not skipping:
            out.append(line)
    open(path, 'w').write('\n'.join(out))
