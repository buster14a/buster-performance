#!/usr/bin/env bash
# perfrecord.sh TAG TREE...: one lock hold that records user cycles (frequency mode, CPU 2) of benchmark-lowering-source
# on sqlite3.c for each tree, then prints each tree's per-symbol shares of the lowering's functions.
set -u
cd "$(dirname "$0")"
tag=$1; shift
export EXCLUSIVE_OWNER=ld148-claude EXCLUSIVE_TITLE="#148 long double and __int128 builtins: perf record" EXCLUSIVE_LINK="https://github.com/buster14a/buster/issues/148"
SQLITE=~/buster-fast-bench/refine-claude/inputs/sqlite3.c
mkdir -p perf
~/buster-fast-bench/exclusive.sh bash -c '
    for t in '"$*"'; do
        taskset -c 2 perf record -q -F 15000 -e cycles:u -o perf/'"$tag"'-$t.data $t/build/compiler benchmark-lowering-source '"$SQLITE"' > perf/'"$tag"'-$t.log 2>&1
    done'
for t in "$@"; do
    perf report -q -i perf/$tag-$t.data --sort symbol --stdio 2>/dev/null | awk '{print $3, $1}' > perf/$tag-$t.symbols
done
echo done
