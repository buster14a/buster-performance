#!/bin/bash
# profile.sh OUT: lane 0's functions in sqlite3.c's -c -w on CPUs 0-7, with --deferred-bodies (8 lanes) and without:
# perf's user-cycle samples of the process's first thread (lane 0: its tid is its pid), by function.
set -uo pipefail
out=$1
head=~/buster-fast-bench/151-claude/final/build/compiler
export EXCLUSIVE_OWNER=claude-151 EXCLUSIVE_TITLE="GitHub issue #151" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/151
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
o=(-w -c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c")
for mode in --deferred-bodies --no-deferred-bodies; do
  ~/buster-fast-bench/exclusive.sh taskset -c 0-7 perf record -q -F 20000 -e cycles:u -o /tmp/claude-151-perf.data -- $head $mode "${o[@]}" -o /tmp/claude-151-perf.o 2> /dev/null
  perf script -i /tmp/claude-151-perf.data -F pid,tid,ip,sym 2> /dev/null \
    | awk '{ split($1, id, "/"); symbol = $3 == "" ? "[unknown]" : $3; all += 1 } id[1] == id[2] { lane0 += 1; count[symbol] += 1 } END { printf "all-samples\t%d\tlane0-samples\t%d\n", all, lane0; for (f in count) printf "%d\t%.2f\t%s\n", count[f], 100 * count[f] / lane0, f }' \
    | sort -t$'\t' -k1,1nr > "$out/lane0-functions$mode.tsv"
done
rm -f /tmp/claude-151-perf.data /tmp/claude-151-perf.o
