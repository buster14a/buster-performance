#!/usr/bin/env python3
# sanitizers-summary.py PROGRESS: the sanitizers' rows' one line: the steps, those with status 0, and the reports.
import re, sys
lines = [l for l in open(sys.argv[1]) if ' status ' in l]
ok = sum(1 for l in lines if re.search(r' status 0\b', l))
reports = sum(int(m.group(1)) for l in lines for m in [re.search(r'reports (\d+)', l)] if m)
rows = sorted(set(l.split()[0] for l in lines))
if not any('chain' in l or 'thread part5' in l for l in lines) and len(rows) < 3:
    raise SystemExit('the rows are not all there: ' + ', '.join(rows))
print('%d of %d steps with status 0, %d reports' % (ok, len(lines), reports), end='')
