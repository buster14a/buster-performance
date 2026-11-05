#!/bin/sh
# The functions small compiles run, by the static head (shifts-s3/compiler-0): user instructions sampled every 499 over
# 300 processes each of an empty file's -fsyntax-only and -E -P, tiny.c's -c and hello.c's -c (stdio.h); then their
# sizes, and the 64 KB windows of .text (the kernel's fault-around) they touch as laid out now and packed together.
cd ~/buster-fast-bench/652-claude-5
export EXCLUSIVE_OWNER=claude-652 EXCLUSIVE_TITLE="652 remaining work" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/652
C=$PWD/shifts-s3/compiler-0
printf '#include <stdio.h>\nint main(void){printf("%%d\\n", 1);return 0;}\n' > hello.c
~/buster-fast-bench/exclusive.sh sh -c "taskset -c 2 perf record -q -e instructions:u -c 499 -o hot.data -- sh -c 'for i in \$(seq 300); do $C -fsyntax-only empty.c; $C -E -P empty.c -o /dev/null; $C -c tiny.c -o /dev/null; $C -c hello.c -o /dev/null; done' > /dev/null 2>&1"
perf report -i hot.data --stdio --comm compiler-0 --sort sym 2>/dev/null | awk '/\[\.\]/ { print $NF }' | sort -u > hot.funcs
nm -S $C | awk '$3 ~ /^[tTwW]$/ && NF == 4 { print $4, $1, $2 }' | sort -k1,1 > hot.sizes
join hot.funcs hot.sizes | python3 -c '
import sys
rows = [l.split() for l in sys.stdin]
total = sum(int(r[2], 16) for r in rows)
windows = set()
for r in rows:
    a, s = int(r[1], 16), int(r[2], 16)
    for w in range(a >> 16, ((a + s - 1) >> 16) + 1):
        windows.add(w)
print(f"{len(rows)} functions sampled, {total // 1024} KB; 64 KB windows touched as laid out: {len(windows)}; packed: {(total + 65535) // 65536}")
'
echo done
