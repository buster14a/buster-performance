# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
# smapsfile.py (gdb): at exit_group, the process's mappings of its own executable, with their size, resident and
# FilePmdMapped kB (file pages mapped as 2 MB pages).
import gdb
import os
pid = gdb.selected_inferior().pid
exe = os.readlink('/proc/%d/exe' % pid)
cur = None
for line in open('/proc/%d/smaps' % pid).read().splitlines():
    parts = line.split()
    if '-' in parts[0] and not parts[0].endswith(':'):
        cur = {'range': parts[0], 'perm': parts[1], 'name': parts[5] if len(parts) > 5 else ''}
        continue
    if cur is not None and cur['name'] == exe and parts[0] in ('Size:', 'Rss:', 'FilePmdMapped:'):
        cur[parts[0][:-1]] = int(parts[1])
        if parts[0] == 'FilePmdMapped:':
            print('%s %s size %d kB rss %d kB file-pmd %d kB' % (cur['range'], cur['perm'], cur['Size'], cur['Rss'], cur['FilePmdMapped']))
