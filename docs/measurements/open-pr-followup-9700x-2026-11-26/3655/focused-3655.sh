set -euo pipefail
out="$PWD/followup-9700x/3655"
cd pr3655
for kind in format-matches invalid-records; do
    status=0
    taskset -c 2 perf stat --no-big-num -x, -e cycles:u,instructions:u,task-clock -o "$out/$kind-tests.csv" -- ./build/compiler test-checker-driver "--$kind-only" --in-process > "$out/$kind-tests.out" 2>&1 || status=$?
    printf '%s %s\n' "$kind" "$status" >> "$out/checker-status.tsv"
done
