#!/usr/bin/env python3
# strip_lock.py FILE...: removes exclusive.sh's waiting messages, which name other sessions' commands and private links:
# from each "exclusive.sh: waiting" line up to this record's own holder line (claude-2538), a queue marker ("== ") or
# the next waiting line. Rewrites each file in place and prints how many lines it removed.
import re, sys
keep = re.compile(r'^(\d{4}-\d\d-\d\dT\S+ claude-2538:|== |exclusive\.sh: waiting)')
for path in sys.argv[1:]:
    lines = open(path).read().split('\n')
    out, dropping, removed = [], False, 0
    for line in lines:
        if line.startswith('exclusive.sh: waiting'):
            dropping = True
            removed += 1
            continue
        if dropping and not keep.match(line):
            removed += 1
            continue
        dropping = False
        out.append(line)
    open(path, 'w').write('\n'.join(out))
    print(f'{path}: {removed} lines removed')
