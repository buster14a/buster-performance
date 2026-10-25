#!/usr/bin/env bash
# #426 (part 1 of #395) at a0c5b8c2 on the 9700X, against main at its merge base (5863eeda, rows3's build): each step
# under the shared lock on its own; ab takes the lock for each of its runs itself.
cd "$(dirname "$0")" || exit 1
root="$(pwd)"
export EXCLUSIVE_OWNER=claude-linker-80 EXCLUSIVE_TITLE="#395 DWARF from compiled code (part 1), head a0c5b8c2" EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/426
export TMPDIR="$root/tmp"
step()
{
    local name="$1"
    shift
    echo "== $name $(date +%T)"
    ~/buster-fast-bench/exclusive.sh "$@" > "$root/$name.log" 2>&1
    echo "== $name status $? $(date +%T)"
}
cd "$root/part1" && step build env LC_NUMERIC=C BUSTER_DEBUG_INFO=0 ./build.sh
step call-graph env LC_NUMERIC=C BUSTER_DEBUG_INFO=0 ./build.sh check-call-graph
step check-debug ./build/compiler test-check-debug --cross-check
step checker ./build/compiler test-checker --seed 133
step tier0 ./build/compiler test-tier0 --cross-check
step debug ./build/compiler test-debug --cross-check
step driver ./build/compiler test-checker-driver --executable ./build/compiler
for i in 1 2 3; do
    step bench-plain-$i taskset -c 2 ./build/compiler benchmark-check-debug
done
step bench-scalar taskset -c 2 ./build/compiler benchmark-check-debug --path scalar
step bench-vector taskset -c 2 ./build/compiler benchmark-check-debug --path vector
step bench-after taskset -c 2 ./build/compiler benchmark-check-debug --path vector --after-scalar 200
step bench-directives-2000 taskset -c 2 ./build/compiler benchmark-check-debug --directives --only build
step bench-directives-16000 taskset -c 2 ./build/compiler benchmark-check-debug --directives --functions 16000 --runs 11 --only build
./build/compiler benchmark-check-debug --print "$TMPDIR/program.c"
cmp "$TMPDIR/program.c" "$root/../rows3/tmp/program.c" && echo "== program: the same as rows3's"
cd "$root"
step perfstat bash -c 'for i in 1 2 3; do for t in main part1; do echo "== $t round $i"; perf stat -x, -e instructions:u,cycles:u,instructions:k,cycles:k -r 21 taskset -c 2 $t/build/compiler -o tmp/program-$t tmp/program.c 2>&1 >/dev/null | cut -d, -f1,3; done; done; cmp tmp/program-main tmp/program-part1 && echo "the same executable"'
size main/build/compiler part1/build/compiler > "$root/size.log" 2>&1
echo "== ab-default $(date +%T)"
part1/build/compiler ab --rounds 5 --cpu 2 --lock ~/buster-fast-bench/exclusive.sh "$root/main" "$root/part1" -- time-runs --runs 21 --list -o "$TMPDIR/program" "$TMPDIR/program.c" > "$root/ab-default.log" 2>&1
echo "== ab-default status $? $(date +%T)"
echo "== ab-debug $(date +%T)"
part1/build/compiler ab --rounds 5 --cpu 2 --lock ~/buster-fast-bench/exclusive.sh "$root/part1" -- time-runs --runs 21 --list -o "$TMPDIR/program" "$TMPDIR/program.c" --list -g -o "$TMPDIR/program-g" "$TMPDIR/program.c" > "$root/ab-debug.log" 2>&1
echo "== ab-debug status $? $(date +%T)"
echo "== done $(date +%T)"
