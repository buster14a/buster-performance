#!/bin/bash
# attr2.sh LABEL NAME FUNC: the samples of results/LABEL/hot-NAME.txt in FUNC by source line (addr2line -a, the innermost
# line), with the 64-byte code lines each source line's addresses touch.
cd ~/buster-fast-bench/2524-claude-layout/results/$1
awk -v f="$3" '$2==f {print $1}' hot-$2.txt | sort | uniq -c > /tmp/claude-2524-attr-ips.txt
awk '{print "0x"$2}' /tmp/claude-2524-attr-ips.txt | addr2line -a -e compiler > /tmp/claude-2524-attr-lines.txt
python3 - <<'PY'
counts = {}
for line in open('/tmp/claude-2524-attr-ips.txt'):
    c, ip = line.split()
    counts[int(ip, 16)] = int(c)
cur = None
out = []
for line in open('/tmp/claude-2524-attr-lines.txt'):
    line = line.strip()
    if line.startswith('0x'):
        cur = int(line, 16); continue
    loc = line.split(' ')[0]
    f, _, n = loc.rpartition(':')
    out.append((f.split('/')[-1], n, cur, counts.get(cur, 0)))
for f, n, ip, c in out:
    print(f, n, ip >> 6, c)
PY
