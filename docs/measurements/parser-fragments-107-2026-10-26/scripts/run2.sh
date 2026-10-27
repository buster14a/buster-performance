#!/usr/bin/env bash
# #107 on the 9700X, the rest of the series after SQLite's five pipeline runs, the decisive corpora first: every step
# under its own lock acquisition, pinned to CPU 2.
set -u
base=~/buster-fast-bench/claude-fragments-106-107
tree=$base/tree-7808e811
inputs=$base/inputs
results=$base/results-7808e811
export EXCLUSIVE_OWNER=claude-fragments-107
export EXCLUSIVE_TITLE="Salter fragments #107: four-path measurement"
export EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/107
lock=~/buster-fast-bench/exclusive.sh
step()
{
    local name="$1"
    shift
    echo "$(date -Is) start $name" >> "$results/progress"
    ( cd "$tree" && "$lock" "$@" ) > "$results/$name.log" 2>&1
    echo "$(date -Is) end $name" >> "$results/progress"
}
b="taskset -c 2 ./build/compiler benchmark-parser --expressions all --passes 21"
for i in 1 2 3; do
    step "bench-libc-pipeline-$i" bash -c "sha256sum --quiet --check $inputs/libc.sha256 && $b --counters pipeline --files-from $inputs/libc.txt"
    step "bench-long-$i" bash -c "cd $inputs && sha256sum --quiet --check generated.sha256 && cd $tree && $b $inputs/long_expressions.c"
    step "bench-small-$i" bash -c "cd $inputs && sha256sum --quiet --check generated.sha256 && cd $tree && $b $inputs/small_functions.c"
done
step bench-sqlite-branches-1 bash -c "$b --counters branches $inputs/sqlite3.c"
step bench-libc-branches-1 bash -c "$b --counters branches --files-from $inputs/libc.txt"
step bench-sqlite-ir-1 bash -c "$b --to-ir $inputs/sqlite3.c"
step bench-sqlite-stalls-1 bash -c "$b --counters stalls $inputs/sqlite3.c"
step bench-sqlite-memory-1 bash -c "$b --counters memory $inputs/sqlite3.c"
step bench-sqlite-scalar-1 bash -c "$b --interleave scalar $inputs/sqlite3.c"
step bench-sqlite-payload48-1 bash -c "$b --payload 48 $inputs/sqlite3.c"
echo "$(date -Is) done" >> "$results/progress"
