#!/bin/sh
# What a static link would save a compile's start (#652): the v2 build's objects linked -static, baked, against the
# same build linked as it is, each under the lock.
set -e
d=~/buster-fast-bench/652-claude-4
b=$d/head-v2/build/cmake/znver5-g0
cd $b
cmd=$(ninja -f build-Release.ninja -t commands Release/compiler.link | grep -- "-o Release/compiler.link" | tail -1 | sed 's/^: && //; s/ && :$//')
static=$(echo "$cmd" | sed 's/-no-pie/-no-pie -static/; s| -o Release/compiler.link| -o '$d'/compiler-static.link|')
eval "$static" > $d/static-link.log 2>&1 || { echo "link failed"; tail -20 $d/static-link.log; exit 1; }
cd $d
./compiler-static.link bake-tables compiler-static > static-bake.log 2>&1 || { echo "bake failed"; cat static-bake.log; }
D=$b/Release/compiler
ls -la compiler-static $D
readelf -d compiler-static | head -3
export EXCLUSIVE_OWNER=claude-652 EXCLUSIVE_TITLE="652 remaining work" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/652
~/buster-fast-bench/exclusive.sh sh -c "
for c in $D $d/compiler-static; do
  for a in '-fsyntax-only empty.c' '-E -P empty.c -o /dev/null' '-c tiny.c -o /dev/null'; do
    echo \"== \$c \$a\"
    taskset -c 2 perf stat -r 501 -e task-clock,page-faults,cycles:u,cycles:k \$c \$a 2>&1 >/dev/null | grep -E 'task-clock|page-faults|cycles|elapsed'
  done
done" > static.txt 2>&1
cat static.txt
