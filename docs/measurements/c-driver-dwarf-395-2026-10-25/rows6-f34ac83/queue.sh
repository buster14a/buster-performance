#!/usr/bin/env bash
# #426 at f34ac833 (a link with -g records the history as it runs) on the 9700X: -g's overhead in instructions,
# cycles, wall time and peak RSS, and the default compile's instructions against 06e6538b's (rows5's part1) and main
# 4f4a0bfa's. Each step under the shared lock on its own; ab takes the lock for each of its runs itself.
cd "$(dirname "$0")" || exit 1
root="$(pwd)"
export EXCLUSIVE_OWNER=claude-linker-80 EXCLUSIVE_TITLE="#395 DWARF from compiled code (part 1), head f34ac833" EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/426
export TMPDIR="$root/tmp"
step()
{
    local name="$1"
    shift
    echo "== $name $(date +%T)"
    ~/buster-fast-bench/exclusive.sh "$@" > "$root/$name.log" 2>&1
    echo "== $name status $? $(date +%T)"
}
(cd "$root/part1" && step build env LC_NUMERIC=C BUSTER_DEBUG_INFO=0 ./build.sh)
cp ../rows3/tmp/program.c "$TMPDIR/program.c"
step perfstat bash -c 'for i in 1 2 3; do for t in main head06e part1; do for g in "" "-g"; do echo "== $t $g round $i"; perf stat -x, -e instructions:u,cycles:u,page-faults -r 21 taskset -c 2 $t/build/compiler $g -o tmp/program-$t$g tmp/program.c 2>&1 >/dev/null | cut -d, -f1,3; done; done; done; cmp tmp/program-head06e-g tmp/program-part1-g && cmp tmp/program-main tmp/program-part1 && echo "the same executables"'
echo "== ab-debug $(date +%T)"
part1/build/compiler ab --rounds 5 --cpu 2 --lock ~/buster-fast-bench/exclusive.sh "$root/part1" -- time-runs --runs 21 --list -o "$TMPDIR/program" "$TMPDIR/program.c" --list -g -o "$TMPDIR/program-g" "$TMPDIR/program.c" > "$root/ab-debug.log" 2>&1
echo "== ab-debug status $? $(date +%T)"
echo "== done $(date +%T)"
