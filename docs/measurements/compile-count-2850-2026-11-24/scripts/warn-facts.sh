#!/bin/bash
# What each part of the default warnings' facts and root walk costs sqlite3.c's compile on the 9700X: main e347ec526
# with the experiment's switches (experiment-facts.patch, not for merge), built as the job builds it, each part left
# out in turn. Every switch leaves the object and the (empty) diagnostics as they are. One hold.
set -u
cd ~/buster-fast-bench/2850-claude-vjgaob/buster
S=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
out=$HOME/buster-fast-bench/2850-claude-vjgaob/results/warn-facts-e347ec526
rm -rf "$out"; mkdir -p "$out"
{ date -u; cat /proc/loadavg; } > "$out/before.txt"
git checkout -q -- . && git apply ../bin/experiment-facts.patch || { echo "patch failed" > "$out/failed"; exit 1; }
start=$(date +%s)
BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0 ./build.sh --config Release > "$out/build.log" 2>&1; echo "build-status=$? seconds=$(( $(date +%s) - start ))" >> "$out/build.log"
C=$PWD/build/compiler-facts-e347ec526
cp "$(BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0 ./build.sh print-output --config Release 2>/dev/null)" "$C" && chmod +x "$C"
git checkout -q -- .
"$C" --version > /dev/null 2>&1 || { echo "the compiler doesn't run" > "$out/failed"; exit 1; }
O=(--lanes 1 -c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$S" "$S/sqlite3.c")
cd "$out"
names=(none w unreachable operand-masks reach-scan edges unsequenced ignored-statement root-frames unselected-roots root-loop unevaluated-scan range-candidates evaluated-parts reach-parts walk-parts everything)
masks=(0 0 $((1<<5)) $((1<<6)) $((1<<7)) $((1<<8)) $((1<<9)) $((1<<10)) $((1<<11)) $((1<<12)) $((1<<13)) $((1<<14)) $((1<<15)) $(( (1<<5)|(1<<6)|(1<<12) )) $(( (1<<7)|(1<<15) )) $(( (1<<9)|(1<<13)|(1<<14) )) $(( (1<<5)|(1<<6)|(1<<7)|(1<<9)|(1<<12)|(1<<13)|(1<<14)|(1<<15) )))
taskset -c 2 "$C" "${O[@]}" -o none.o 2> none.err; echo "status=$?" >> none.err
E=cycles:u,instructions:u,task-clock,L1-dcache-load-misses:u,cache-misses:u,branch-misses:u
run() {
    local i=$1 round=$2 extra=()
    [ "${names[$i]}" = w ] && extra=(-w)
    BUSTER_EXPERIMENT_SKIP=${masks[$i]} taskset -c 2 perf stat -x, -e $E -r 11 -o "stat-${names[$i]}-$round.csv" -- "$C" "${extra[@]}" "${O[@]}" -o x.o > /dev/null 2> "err-${names[$i]}-$round.txt"
    echo "status=$?" >> "err-${names[$i]}-$round.txt"
    cmp -s x.o none.o || echo "${names[$i]} round $round: object differs" >> differs.txt
}
for i in "${!names[@]}"; do run "$i" 1; done
for (( i=${#names[@]}-1; i>=0; i-- )); do run "$i" 2; done
for i in "${!names[@]}"; do run "$i" 3; done
rm -f x.o
{ date -u; cat /proc/loadavg; } > after.txt
echo done > complete
