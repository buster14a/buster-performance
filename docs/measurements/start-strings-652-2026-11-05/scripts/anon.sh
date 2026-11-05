#!/bin/sh
# The static head's anonymous faults in an empty file's -fsyntax-only, by the mapping that holds each (#652): with the
# address space's randomization off (setarch -R), strace's mmap and brk results and perf's fault addresses line up.
cd ~/buster-fast-bench/652-claude-5
export EXCLUSIVE_OWNER=claude-652 EXCLUSIVE_TITLE="652 remaining work" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/652
C=$PWD/shifts-s3/compiler-0
~/buster-fast-bench/exclusive.sh sh -c "taskset -c 2 setarch -R strace -f -e trace=mmap,brk,munmap -o anon-strace.txt $C -fsyntax-only empty.c > /dev/null 2>&1; taskset -c 2 setarch -R perf record -q -e page-faults -c 1 -d -o anon.data -- $C -fsyntax-only empty.c > /dev/null 2>&1"
perf script -i anon.data -F addr,ip,sym 2>/dev/null > anon-faults.txt
python3 - <<'PY'
import re
maps = []
for l in open("anon-strace.txt"):
    m = re.search(r'mmap\((NULL|0x[0-9a-f]+), (\d+),.*\) = (0x[0-9a-f]+)', l)
    if m:
        maps.append((int(m.group(3), 16), int(m.group(2)), "mmap %d" % len(maps)))
    b = re.search(r'brk\((NULL|0x[0-9a-f]+)\)\s+= (0x[0-9a-f]+)', l)
    if b:
        maps.append((int(b.group(2), 16) - (1 << 30), 1 << 30, "brk heap"))
counts = {}
first = {}
for l in open("anon-faults.txt"):
    p = l.split()
    if not p: continue
    a = int(p[0], 16)
    if a < 0x10000000 or a >= 0x7ff000000000: continue
    name = "other"
    for start, size, n in maps:
        if start <= a < start + size: name = "%s (%d MB)" % (n, size >> 20)
    counts[name] = counts.get(name, 0) + 1
    first.setdefault(name, " ".join(p[1:3]))
print(len(maps), "mappings")
for n, c in sorted(counts.items(), key=lambda x: -x[1]): print("%4d %-28s first fault in %s" % (c, n, first[n]))
PY
echo done
