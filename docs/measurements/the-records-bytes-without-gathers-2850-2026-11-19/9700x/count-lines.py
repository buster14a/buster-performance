#!/usr/bin/env python3
# count-lines.py FILE: a shadow run's output with its times left out, for comparing two runs' counts. The lock's
# waiting messages go; `N ticks each` loses its number; and a line is cut at its first `ticks`, after which the
# shadow's lines have times only.
import re, sys
for line in open(sys.argv[1], errors='replace'):
    line = line.rstrip('\n')
    if line.startswith('exclusive.sh:') or line.startswith('  title:') or line.startswith('  link:'):
        continue
    line = re.sub(r'[0-9.]+ ticks each', 'T each', line)
    at = line.find('ticks')
    if at >= 0:
        line = line[:at]
    print(line.rstrip())
