set -euo pipefail
root="$PWD"
out="$root/followup-9700x/3648"
wrappers="$(mktemp -d "$out/assembler-wrapper.XXXXXX")"
trap 'rm -rf "$wrappers"' EXIT
install -m 755 "$root/assembler-3648-no-compression.sh" "$wrappers/as"
export PATH="$wrappers:$PATH"
cd pr3648
status=0
taskset -c 2 perf stat --no-big-num -x, -e cycles:u,instructions:u,task-clock -o "$out/assembly-no-compression.csv" -- ./build/compiler test-assembly-output --cross-check --c-testsuite "$root/c-testsuite" --subset tests/c-testsuite/subset.txt > "$out/assembly-no-compression.out" 2>&1 || status=$?
printf 'exit %s\n' "$status" > "$out/assembly-no-compression-status.txt"
grep -Eq 'assembly output: [1-9][0-9]* checks, 0 failures' "$out/assembly-no-compression.out"
