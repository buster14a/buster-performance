set -euo pipefail
out="$PWD/followup-9700x/3654"
for side in base3597 pr3654; do
    (cd "$side" && taskset -c 2 perf stat --no-big-num -x, -e cycles:u,instructions:u,task-clock -o "$out/checker-part-6-$side.csv" -- ./build/compiler test-checker --part 6/8) > "$out/checker-part-6-$side.out" 2>&1
done
root="$PWD"
cd pr3654
clang -std=c17 -O2 -Wall -Wextra -Werror tools/ci/runtime-fixtures.c -o "$out/runtime-fixtures.bin"
taskset -c 2 perf stat --no-big-num -x, -e cycles:u,instructions:u,task-clock -o "$out/runtime-fixtures.csv" -- "$out/runtime-fixtures.bin" "$PWD/build/compiler" "$(command -v clang)" "$PWD" > "$out/runtime-fixtures.out" 2>&1
grep -Eq 'runtime-fixtures: [1-9][0-9]* checks, 0 failures' "$out/runtime-fixtures.out"
