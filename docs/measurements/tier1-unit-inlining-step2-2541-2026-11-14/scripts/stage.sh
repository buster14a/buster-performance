#!/bin/bash
# stage.sh TREE: the unit stage's share of TREE's --tier1 -c of the frozen sqlite3.c, one lane, pinned to CPU 2: perf
# record of user cycles (-c 200003, call graphs), and the inclusive shares of the unit stage (check_tier1_inline_stage),
# the summaries (check_tier1_inline_summary) and the expansions (check_tier1_inline_expand), and the whole compile's
# samples. Run inside one hold of the lock. results/stage-TREE.txt.
set -u
cd "$(dirname "$0")"
root=$PWD
tree=${1:?a tree}
out=$root/results
export LC_ALL=C
unset CPATH C_INCLUDE_PATH
head -1 /var/lib/buster-9700x/owner >> "$out/holders.txt"
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
tmp=$(mktemp -d /tmp/claude-2541-step2-stage.XXXXXX)
taskset -c 2 perf record -q -g -e cycles:u -c 200003 -o "$tmp/perf.data" -- "$root/$tree/build/compiler" --lanes 1 --tier1 -c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 \
    -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c" -o "$tmp/x.o" > /dev/null 2>&1
perf report -i "$tmp/perf.data" --children --stdio --sort symbol -g none 2>/dev/null | grep -E 'check_tier1_inline|check_tier1_passes|check_tier1_compile|ir_optimize_inline|ir_optimize_sroa' > "$out/stage-$tree.txt"
perf report -i "$tmp/perf.data" --stdio --sort symbol 2>/dev/null | grep -E '^# (Samples|Event count)' >> "$out/stage-$tree.txt"
rm -rf "$tmp"
