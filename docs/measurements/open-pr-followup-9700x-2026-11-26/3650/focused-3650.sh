set -euo pipefail
out="$PWD/followup-9700x/3650"
for side in base pr3650; do
    (cd "$side" && taskset -c 2 perf stat --no-big-num -x, -e cycles:u,instructions:u,task-clock -o "$out/calling-convention-$side.csv" -- ./build/compiler test-calling-convention) > "$out/calling-convention-$side.out" 2>&1
done
