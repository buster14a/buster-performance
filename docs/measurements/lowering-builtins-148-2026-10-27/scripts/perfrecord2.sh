#!/usr/bin/env bash
# perfrecord2.sh TAG TREE...: one lock hold that, for each tree, counts user instructions, cycles and branch misses of
# benchmark-lowering-source on sqlite3.c and records its user cycles (frequency mode), CPU 2; then prints each tree's
# per-symbol shares.
set -u
cd "$(dirname "$0")"
tag=$1; shift
export EXCLUSIVE_OWNER=ld148-claude EXCLUSIVE_TITLE="#148 long double, __int128 and _BitInt builtins: perf record" EXCLUSIVE_LINK="https://github.com/buster14a/buster/issues/148"
SQLITE=~/buster-fast-bench/refine-claude/inputs/sqlite3.c
mkdir -p perf
~/buster-fast-bench/exclusive.sh bash -c '
    for t in '"$*"'; do
        taskset -c 2 perf stat -x, -e instructions:u,cycles:u,branch-misses:u -o perf/'"$tag"'-$t.stat $t/build/compiler benchmark-lowering-source '"$SQLITE"' > /dev/null 2>&1
        taskset -c 2 perf record -q -F 15000 -e cycles:u -o perf/'"$tag"'-$t.data $t/build/compiler benchmark-lowering-source '"$SQLITE"' > perf/'"$tag"'-$t.log 2>&1
    done'
for t in "$@"; do
    perf report -q -i perf/$tag-$t.data --sort symbol --stdio 2>/dev/null | awk '{print $3, $1}' > perf/$tag-$t.symbols
done
echo done
