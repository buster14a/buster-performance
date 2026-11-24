#!/bin/bash
# What a scan of the tokens' roles and kinds costs, and what three token passes' work a candidate costs, on the 9700X:
# main e347ec526 with experiment-scans.patch (not for merge), built as the job builds it. One hold.
set -u
cd ~/buster-fast-bench/2850-claude-vjgaob/buster
S=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
out=$HOME/buster-fast-bench/2850-claude-vjgaob/results/warn-scans-e347ec526
rm -rf "$out"; mkdir -p "$out"
{ date -u; cat /proc/loadavg; } > "$out/before.txt"
git checkout -q -- . && git apply ../bin/experiment-scans.patch || { echo "patch failed" > "$out/failed"; exit 1; }
start=$(date +%s)
BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0 ./build.sh --config Release > "$out/build.log" 2>&1; echo "build-status=$? seconds=$(( $(date +%s) - start ))" >> "$out/build.log"
C=$PWD/build/compiler-scans-e347ec526
cp "$(BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0 ./build.sh print-output --config Release 2>/dev/null)" "$C" && chmod +x "$C"
git checkout -q -- .
O=(--lanes 1 -c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$S" "$S/sqlite3.c")
cd "$out"
names=(none scans-10 scans-20 sizeof-body empty-body parentheses-body three-bodies)
skips=(0 0 0 2 4 8 14)
scans=(0 10 20 0 0 0 0)
taskset -c 2 "$C" "${O[@]}" -o none.o 2> none.err; echo "status=$?" >> none.err
E=cycles:u,instructions:u,task-clock,L1-dcache-load-misses:u,cache-misses:u,branch-misses:u
run() {
    local i=$1 round=$2
    BUSTER_EXPERIMENT_SKIP=${skips[$i]} BUSTER_EXPERIMENT_SCANS=${scans[$i]} taskset -c 2 perf stat -x, -e $E -r 15 -o "stat-${names[$i]}-$round.csv" -- "$C" "${O[@]}" -o x.o > /dev/null 2> "err-${names[$i]}-$round.txt"
    cmp -s x.o none.o || echo "${names[$i]} round $round: object differs" >> differs.txt
}
for i in "${!names[@]}"; do run "$i" 1; done
for (( i=${#names[@]}-1; i>=0; i-- )); do run "$i" 2; done
for i in "${!names[@]}"; do run "$i" 3; done
rm -f x.o
{ date -u; cat /proc/loadavg; } > after.txt
echo done > complete
