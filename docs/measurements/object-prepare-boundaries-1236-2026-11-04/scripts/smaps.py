# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
# smaps.py (gdb): at exit_group, the anonymous mappings with resident pages, and their resident and AnonHugePages kB.
import gdb
pid = gdb.selected_inferior().pid
text = open('/proc/%d/smaps' % pid).read()
cur = None
rows = []
for line in text.splitlines():
    parts = line.split()
    if '-' in parts[0] and len(parts) >= 5 and not parts[0].endswith(':'):
        cur = {'range': parts[0], 'name': parts[5] if len(parts) > 5 else '', 'perm': parts[1]}
        rows.append(cur)
    elif parts[0] in ('Rss:', 'AnonHugePages:', 'Size:'):
        cur[parts[0][:-1]] = int(parts[1])
total_huge = sum(r.get('AnonHugePages', 0) for r in rows)
total_rss = sum(r.get('Rss', 0) for r in rows if r['name'] == '')
print('anon rss %d kB, anon huge %d kB' % (total_rss, total_huge))
for r in rows:
    if r['name'] == '' and r.get('Rss', 0) > 0:
        print('%s %s size %d kB rss %d kB huge %d kB' % (r['range'], r['perm'], r['Size'], r['Rss'], r.get('AnonHugePages', 0)))
