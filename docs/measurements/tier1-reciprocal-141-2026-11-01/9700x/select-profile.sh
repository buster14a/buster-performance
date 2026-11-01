#!/usr/bin/env bash
# select-profile.sh HEAD: where selection's cycles go on the frozen sqlite3.c: perf record (cycles:u, a sample per
# 100,003) of benchmark-tier1-select-source --only select and --only select-scalar, each one hold of the shared lock,
# pinned to CPU 2, and each profile's symbols.
. ~/buster-fast-bench/claude-141-reciprocal/common.sh
head=$1
out=$PWD/select-profile-$head
mkdir -p $out
for v in select select-scalar; do
    "$lock" bash -c "taskset -c 2 perf record -q -e cycles:u -c 100003 -o $out/perf-$v.data -- $PWD/$head/build/compiler benchmark-tier1-select-source --only $v $FLAGS -I$Q $Q/sqlite3.c > $out/run-$v.txt 2>&1; perf report -i $out/perf-$v.data --stdio --no-children --sort symbol 2>/dev/null | grep -v '^#' | grep -v '^\$' | head -60 > $out/symbols-$v.txt"
done
echo done > $out/done
