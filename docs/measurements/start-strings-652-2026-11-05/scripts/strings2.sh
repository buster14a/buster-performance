#!/bin/sh
# String locality on the build's own objects (#652): 0e1b580b's objects (head-s3's tree, no -ffunction-sections) linked
# by mold as the build links them ("mold"), by lld ("lld") and by lld with -O0 ("lld-O0"), each baked as the build
# bakes it. Faults by region, then a time-runs A/B.
set -e
d=~/buster-fast-bench/652-claude-5
cd $d
export EXCLUSIVE_OWNER=claude-652 EXCLUSIVE_TITLE="652 remaining work" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/652
B=$d/head-s3/build/cmake/znver5-g0
(cd head-s3 && ~/buster-fast-bench/exclusive.sh taskset -c 0-7 env BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0 ./build.sh --config Release) > strings2-build.log 2>&1
cp $B/Release/compiler strings2-mold
link=$(ninja -C $B -f build-Release.ninja -t commands Release/compiler | grep -- '-o Release/compiler.link' | sed 's/-fuse-ld=[^ ]*//g; s/--ld-path=[^ ]*//g')
post=$(ninja -C $B -f build-Release.ninja -t commands Release/compiler | grep -- 'BusterPostLink.cmake')
for variant in lld lld-O0; do
  extra="-fuse-ld=lld"
  [ $variant = lld-O0 ] && extra="-fuse-ld=lld -Wl,-O0"
  l=$(printf '%s' "$link" | sed "s|-o Release/compiler.link|$extra -o Release/compiler-$variant.link|")
  p=$(printf '%s' "$post" | sed "s|Release/compiler.link|Release/compiler-$variant.link|; s|-DOUTPUT=$B/Release/compiler |-DOUTPUT=$B/Release/compiler-$variant |")
  (cd $B && ~/buster-fast-bench/exclusive.sh sh -c "$l && $p") >> strings2-link.log 2>&1
  cp $B/Release/compiler-$variant strings2-$variant
done
for C in strings2-mold strings2-lld strings2-lld-O0; do
  echo "== $C"; ls -la $C | awk '{print $5, "bytes"}'
  ./$C test-baked-tables 2>&1 | head -1
  ~/buster-fast-bench/exclusive.sh sh -c "taskset -c 2 perf record -q -e page-faults -c 1 -d -o strings2-faults.data -- $PWD/$C -fsyntax-only empty.c > /dev/null 2>&1; taskset -c 2 perf stat -r 200 -e task-clock,page-faults,cycles:u,cycles:k $PWD/$C -fsyntax-only empty.c 2>&1 >/dev/null | grep -E 'task-clock|faults|cycles|elapsed'"
  readelf -SW $C | awk '{ for (i = 1; i <= NF; i++) if ($i ~ /^\./) { print $i, $(i+2), $(i+4); break } }' > strings2-sections.txt
  perf script -i strings2-faults.data -F addr 2>/dev/null | python3 -c '
import sys
secs = []
for l in open("strings2-sections.txt"):
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
builds="--build mold $d/strings2-mold --build lld $d/strings2-lld --build lld-O0 $d/strings2-lld-O0"
~/buster-fast-bench/exclusive.sh taskset -c 2 $d/shifts-s3/compiler-0 time-runs --runs 30 --warmups 3 --copies 4 $builds --list -fsyntax-only empty.c --list -E -P empty.c -o /dev/null --list -c tiny.c -o /dev/null --list -c hello.c -o /dev/null 2>&1 | grep -v "^run \|^list [0-9] .*copy"
q=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
~/buster-fast-bench/exclusive.sh taskset -c 2 $d/shifts-s3/compiler-0 time-runs --runs 4 --warmups 1 --copies 2 $builds --list -fsyntax-only -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -I$q $q/sqlite3.c 2>&1 | grep -v "^run \|^list [0-9] .*copy"
echo done
