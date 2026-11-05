#!/bin/sh
# Link-time layout (#652): 0e1b580b built with -ffunction-sections, linked as the build links it ("sections") and again
# with the functions small compiles run first (--symbol-ordering-file, "ordered"), each baked as the build bakes it.
# The functions are those holding hot.sh's samples on shifts-s3/compiler-0 (hot2.sh's), by name. Then each build's
# faults by region, and a time-runs A/B of s3, sections and ordered.
set -e
d=~/buster-fast-bench/652-claude-5
cd $d
export EXCLUSIVE_OWNER=claude-652 EXCLUSIVE_TITLE="652 remaining work" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/652
repo=~/buster-fast-bench/652-claude-3/main
[ -d head-order ] || (cd $repo && git worktree add -q --detach $d/head-order 0e1b580b2ebb7864d3ef1e84c018c12154a27640)
B=$d/head-order/build/cmake/znver5-g0
(cd head-order && ~/buster-fast-bench/exclusive.sh taskset -c 0-7 env BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0 BUSTER_BUILD_DEFINES=-ffunction-sections ./build.sh --config Release) > order-build.log 2>&1
cp $B/Release/compiler order-mold
# The order: every function holding a sample, hottest first.
python3 - <<'PY'
import bisect, collections
ips = [int(l, 16) for l in open("hot.ips") if l.strip()]
syms = []
for l in open("hot.symbols"):
    a, s, n = l.split()
    syms.append((int(a, 16), int(s, 16), n))
starts = [s[0] for s in syms]
count = collections.Counter()
for ip in ips:
    i = bisect.bisect_right(starts, ip) - 1
    if i >= 0 and syms[i][0] <= ip < syms[i][0] + syms[i][1]:
        count[syms[i][2]] += 1
with open("order.txt", "w") as f:
    for name, _ in count.most_common():
        f.write(name + "\n")
print(len(count), "functions in order.txt")
PY
link=$(ninja -C $B -f build-Release.ninja -t commands Release/compiler | grep -- '-o Release/compiler.link' | sed 's/-fuse-ld=[^ ]*//g; s/--ld-path=[^ ]*//g')
post=$(ninja -C $B -f build-Release.ninja -t commands Release/compiler | grep -- 'BusterPostLink.cmake')
# Both relinked by lld, which takes an ordering file (mold 3.0 has none): the same linker either way.
for variant in sections ordered; do
  extra=""
  [ $variant = ordered ] && extra="-Wl,--symbol-ordering-file=$d/order.txt -Wl,--no-warn-symbol-ordering"
  l=$(printf '%s' "$link" | sed "s|-o Release/compiler.link|-fuse-ld=lld $extra -o Release/compiler-$variant.link|")
  p=$(printf '%s' "$post" | sed "s|Release/compiler.link|Release/compiler-$variant.link|; s|-DOUTPUT=$B/Release/compiler |-DOUTPUT=$B/Release/compiler-$variant |")
  (cd $B && ~/buster-fast-bench/exclusive.sh sh -c "$l && $p") >> order-link.log 2>&1
  cp $B/Release/compiler-$variant order-$variant
done
./order-ordered test-baked-tables > order-baked.txt 2>&1 || true
: > empty.c
for C in shifts-s3/compiler-0 order-sections order-ordered; do
  echo "== $C"
  ~/buster-fast-bench/exclusive.sh sh -c "taskset -c 2 perf record -q -e page-faults -c 1 -d -o order-faults.data -- $PWD/$C -fsyntax-only empty.c > /dev/null 2>&1; taskset -c 2 perf stat -r 200 -e task-clock,page-faults,cycles:u,cycles:k $PWD/$C -fsyntax-only empty.c 2>&1 >/dev/null | grep -E 'task-clock|faults|cycles|elapsed'"
  readelf -SW $C | awk '{ for (i = 1; i <= NF; i++) if ($i ~ /^\./) { print $i, $(i+2), $(i+4); break } }' > order-sections.txt
  perf script -i order-faults.data -F addr 2>/dev/null | python3 -c '
import sys
secs = []
for l in open("order-sections.txt"):
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
for r, c in sorted(counts.items(), key=lambda x: -x[1]): print(c, r)'
done
builds="--build s3 $d/shifts-s3/compiler-0 --build sections $d/order-sections --build ordered $d/order-ordered"
printf 'int main(void){return 0;}\n' > tiny.c
~/buster-fast-bench/exclusive.sh taskset -c 2 $d/shifts-s3/compiler-0 time-runs --runs 30 --warmups 3 --copies 4 $builds --list -fsyntax-only empty.c --list -E -P empty.c -o /dev/null --list -c tiny.c -o /dev/null --list -c hello.c -o /dev/null 2>&1 | grep -v "^run "
echo done
