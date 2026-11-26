set -euo pipefail
out="$PWD/followup-9700x/3636"
cd pr3636
taskset -c 2 perf stat --no-big-num -x, -e cycles:u,instructions:u,task-clock -o "$out/warning-tests.csv" -- ./build/compiler test-checker-driver --missing-variable-only --in-process > "$out/warning-tests.out" 2>&1
