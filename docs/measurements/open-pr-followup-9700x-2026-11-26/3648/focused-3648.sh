set -euo pipefail
root="$PWD"
out="$root/followup-9700x/3648"
cd pr3648
as --version | head -1 > "$out/assembly-oracle.txt"
git -C "$root/c-testsuite" rev-parse HEAD >> "$out/assembly-oracle.txt"
subset=tests/c-testsuite/subset.txt
sha256sum "$subset" >> "$out/assembly-oracle.txt"
taskset -c 2 perf stat --no-big-num -x, -e cycles:u,instructions:u,task-clock -o "$out/assembly-tests.csv" -- ./build/compiler test-assembly-output --cross-check --c-testsuite "$root/c-testsuite" --subset "$subset" > "$out/assembly-tests.out" 2>&1
grep -Eq 'assembly output: [1-9][0-9]* checks, 0 failures' "$out/assembly-tests.out"
