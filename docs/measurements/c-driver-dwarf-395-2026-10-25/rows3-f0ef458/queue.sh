#!/usr/bin/env bash
# #426 (part 1 of #395) on the 9700X at its head, against main at its merge base: each step under the shared lock on its
# own; ab takes the lock for each of its runs itself.
cd "$(dirname "$0")" || exit 1
root="$(pwd)"
export EXCLUSIVE_OWNER=claude-linker-80 EXCLUSIVE_TITLE="#395 DWARF from compiled code (part 1)" EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/426
export TMPDIR="$root/tmp"
mkdir -p "$TMPDIR"
step()
{
    local name="$1"
    shift
    echo "== $name $(date +%T)"
    ~/buster-fast-bench/exclusive.sh "$@" > "$root/$name.log" 2>&1
    echo "== $name status $? $(date +%T)"
}
cd "$root/part1" && step build-part1 env LC_NUMERIC=C BUSTER_DEBUG_INFO=0 ./build.sh
cd "$root/main" && step build-main env LC_NUMERIC=C BUSTER_DEBUG_INFO=0 ./build.sh
cd "$root/part1"
step check-debug ./build/compiler test-check-debug --cross-check
step checker ./build/compiler test-checker --seed 133
step tier0 ./build/compiler test-tier0 --cross-check
step debug ./build/compiler test-debug --cross-check
step driver ./build/compiler test-checker-driver --executable ./build/compiler
step streaming ./build/compiler test-streaming --cross-check
for i in 1 2 3; do
    step bench-plain-$i taskset -c 2 ./build/compiler benchmark-check-debug
done
for i in 1 2 3; do
    step bench-scalar-$i taskset -c 2 ./build/compiler benchmark-check-debug --path scalar
    step bench-vector-$i taskset -c 2 ./build/compiler benchmark-check-debug --path vector
    step bench-after-$i taskset -c 2 ./build/compiler benchmark-check-debug --path vector --after-scalar 200
done
step bench-directives-2000 taskset -c 2 ./build/compiler benchmark-check-debug --directives --only build
step bench-directives-16000 taskset -c 2 ./build/compiler benchmark-check-debug --directives --functions 16000 --runs 11 --only build
./build/compiler benchmark-check-debug --print "$TMPDIR/program.c"
echo "== ab-default $(date +%T)"
./build/compiler ab --rounds 5 --cpu 2 --lock ~/buster-fast-bench/exclusive.sh "$root/main" "$root/part1" -- time-runs --runs 21 --list -o "$TMPDIR/program" "$TMPDIR/program.c" > "$root/ab-default.log" 2>&1
echo "== ab-default status $? $(date +%T)"
echo "== ab-debug $(date +%T)"
./build/compiler ab --rounds 5 --cpu 2 --lock ~/buster-fast-bench/exclusive.sh "$root/part1" -- time-runs --runs 21 --list -o "$TMPDIR/program" "$TMPDIR/program.c" --list -g -o "$TMPDIR/program-g" "$TMPDIR/program.c" > "$root/ab-debug.log" 2>&1
echo "== ab-debug status $? $(date +%T)"
echo "== done $(date +%T)"
