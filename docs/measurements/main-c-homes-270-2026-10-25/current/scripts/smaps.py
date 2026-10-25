# Run by gdb at the checker's first munmap of more than 64 MB (its arenas' release, when they are all still mapped): the process's peak and current resident set, and its mappings by resident
# bytes, so that the two trees' peak resident sets can be compared mapping by mapping.
import gdb, re
pid = gdb.selected_inferior().pid
status = open(f'/proc/{pid}/status').read()
for key in ('VmHWM', 'VmRSS', 'RssAnon', 'RssFile', 'RssShmem'):
    m = re.search(rf'^{key}:\s+(\d+) kB', status, re.M)
    print(f'{key}: {m.group(1) if m else "?"} kB')
rows = []
current = None
for line in open(f'/proc/{pid}/smaps'):
    head = re.match(r'^([0-9a-f]+)-([0-9a-f]+) (\S+) \S+ \S+ \S+\s*(.*)$', line)
    if head:
        current = {'range': f'{head.group(1)}-{head.group(2)}', 'size': (int(head.group(2), 16) - int(head.group(1), 16)) // 1024,
                   'perms': head.group(3), 'name': head.group(4) or '[anon]', 'rss': 0, 'huge': 0}
        rows.append(current)
    elif current is not None:
        m = re.match(r'^(Rss|AnonHugePages):\s+(\d+) kB', line)
        if m:
            current['rss' if m.group(1) == 'Rss' else 'huge'] = int(m.group(2))
rows = [r for r in rows if r['rss'] != 0]
rows.sort(key=lambda r: (-r['size'], -r['rss']))
print(f'mappings: {len(rows)}, resident in them: {sum(r["rss"] for r in rows)} kB')
for r in rows:
    print(f'  {r["rss"]:>9} kB resident, {r["huge"]:>9} kB huge, {r["size"]:>12} kB mapped {r["perms"]} {r["name"]}')
