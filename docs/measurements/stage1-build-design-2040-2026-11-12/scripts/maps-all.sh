#!/bin/bash
# Every unit of the build stopped before LLVM's optimizer (the build's own commands with -Xclang -disable-llvm-passes
# -emit-llvm, eight at once), then function_files' map of each, to be run inside the lock as one run: what each of the
# 43 units compiles, for the count of the functions several units compile (tools/duplication.py). The step's wall time
# is the 43 front ends' on eight jobs.
set -u
export LC_ALL=C
d=$HOME/buster-fast-bench/2040-claude
mkdir -p "$d/scratch/unopt" "$d/results/maps-all"
head -1 /var/lib/buster-9700x/owner > "$d/results/maps-all/holder.txt"
cd "$d/src" || exit 2
one()
{
    local unit
    unit=$(basename "$1" .c)
    mapfile -t command < <(python3 "$d/scripts/unit_command.py" build/compile_commands.json "$unit")
    local start end
    start=$(date +%s.%N)
    "${command[@]}" -Xclang -disable-llvm-passes -emit-llvm -o "$d/scratch/unopt/$unit.bc" > "$d/scratch/unopt/$unit.log" 2>&1
    end=$(date +%s.%N)
    "$d/tools/function_files" "$d/scratch/unopt/$unit.bc" "$d/results/maps-all/$unit.functions.tsv" "$d/results/maps-all/$unit.edges.tsv"
    printf '%s\t%.2f\t%s\n' "$unit" "$(echo "$end - $start" | bc)" "$(stat -c %s "$d/scratch/unopt/$unit.bc")" >> "$d/results/maps-all/front-ends.tsv"
}
export -f one
export d
rm -f "$d/results/maps-all/front-ends.tsv"
TIMEFORMAT='%R s wall, %U s user, %S s system for the 43 front ends and their maps on eight jobs'
{ time ./build.sh print-sources | xargs -0 -n 1 -P 8 bash -c 'one "$0"'; } 2> "$d/results/maps-all/time.txt"
rm -f "$d"/results/maps-all/*.edges.tsv
cat "$d/results/maps-all/time.txt"
