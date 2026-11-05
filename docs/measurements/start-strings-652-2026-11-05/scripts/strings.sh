#!/bin/sh
# String locality (#652): order.sh's function-sections objects relinked by lld with -O0, which keeps each object's
# strings in their order rather than merging them in hash order ("unmerged"), against the same objects linked by lld
# with its default -O1 ("sections"). Faults by region, then a time-runs A/B.
set -e
d=~/buster-fast-bench/652-claude-5
cd $d
export EXCLUSIVE_OWNER=claude-652 EXCLUSIVE_TITLE="652 remaining work" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/652
B=$d/head-order/build/cmake/znver5-g0
link=$(ninja -C $B -f build-Release.ninja -t commands Release/compiler | grep -- '-o Release/compiler.link' | sed 's/-fuse-ld=[^ ]*//g; s/--ld-path=[^ ]*//g')
post=$(ninja -C $B -f build-Release.ninja -t commands Release/compiler | grep -- 'BusterPostLink.cmake')
l=$(printf '%s' "$link" | sed "s|-o Release/compiler.link|-fuse-ld=lld -Wl,-O0 -o Release/compiler-unmerged.link|")
p=$(printf '%s' "$post" | sed "s|Release/compiler.link|Release/compiler-unmerged.link|; s|-DOUTPUT=$B/Release/compiler |-DOUTPUT=$B/Release/compiler-unmerged |")
(cd $B && ~/buster-fast-bench/exclusive.sh sh -c "$l && $p") > strings-link.log 2>&1
cp $B/Release/compiler-unmerged order-unmerged
for C in order-sections order-unmerged; do
  echo "== $C"; ls -la $C | awk '{print $5, "bytes"}'
  ~/buster-fast-bench/exclusive.sh sh -c "taskset -c 2 perf record -q -e page-faults -c 1 -d -o strings-faults.data -- $PWD/$C -fsyntax-only empty.c > /dev/null 2>&1; taskset -c 2 perf stat -r 200 -e task-clock,page-faults,cycles:u,cycles:k $PWD/$C -fsyntax-only empty.c 2>&1 >/dev/null | grep -E 'task-clock|faults|cycles|elapsed'"
  readelf -SW $C | awk '{ for (i = 1; i <= NF; i++) if ($i ~ /^\./) { print $i, $(i+2), $(i+4); break } }' > strings-sections.txt
  perf script -i strings-faults.data -F addr,sym 2>/dev/null | python3 -c '
import sys
secs = []
for l in open("strings-sections.txt"):
    p = l.split()
    if len(p) == 3:
        try: secs.append((p[0], int(p[1], 16), int(p[2], 16)))
        except ValueError: pass
counts = {}
for l in sys.stdin:
    a = int(l.split()[0], 16)
    r = "(none)" if a == 0 else "stack/vdso" if a >= 0x7ff000000000 else "anonymous"
    for n, s, z in secs:
        if s <= a < s + z and z: r = n
    counts[r] = counts.get(r, 0) + 1
for r, c in sorted(counts.items(), key=lambda x: -x[1])[:8]: print(c, r)'
done
builds="--build sections $d/order-sections --build unmerged $d/order-unmerged"
~/buster-fast-bench/exclusive.sh taskset -c 2 $d/shifts-s3/compiler-0 time-runs --runs 30 --warmups 3 --copies 4 $builds --list -fsyntax-only empty.c --list -E -P empty.c -o /dev/null --list -c tiny.c -o /dev/null --list -c hello.c -o /dev/null 2>&1 | grep -v "^run \|^list [0-9] .*copy"
echo done
