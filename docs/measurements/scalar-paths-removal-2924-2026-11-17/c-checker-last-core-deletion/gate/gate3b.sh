#!/bin/bash
# #2924 C12c-3 core-3, the gate's second round, on gate3.sh's build (src/build/compiler, knob.diff):
# 1. The deferred merge (bit 2): ab, three rounds, around time-runs (three runs) of no bit, bit 2 and no bit again, -c
#    --lanes 4 --deferred-bodies of sqlite3.c and Lua's units, on CPUs 2 to 9 (taskset; ab without --cpu), since one
#    CPU reads every body in source order.
# 2. The fixtures of 64 and 256 groups: ab, five rounds, around time-runs (nine runs) of no bit, bits 3, 4, 5 and no
#    bit again.
# 3. perf record (cycles:u, period 10007) of 20 compiles each of the 256 groups' fixture by no bit, bit 5 and no bit
#    again: the samples in check_input_condition_uses, and in every function, by build.
set -uo pipefail
cd "$(dirname "$0")"
D=$PWD
export EXCLUSIVE_OWNER=claude-2924 EXCLUSIVE_TITLE="Scalar paths removed: the checker core's last twins' gate, C12c-3 core-3" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2924
L=~/buster-fast-bench/exclusive.sh
: > logs/status-b.txt
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
sqlite=$corpus/sqlite
lua=$D/../c3pr/inputs/lua-5.4.8/src
S=(-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I"$sqlite" "$sqlite/sqlite3.c")
DF=(--lanes 4 --deferred-bodies)
exe=/dev/shm/claude-2924-c12k3b-exe
rm -rf "$exe"; mkdir -p "$exe"
cp src/build/compiler "$exe/file"; cat "$exe/file" > /dev/null
for m in 0 4 8 16 32; do mkdir -p "$exe/m$m"; ln "$exe/file" "$exe/m$m/compiler-areas$m"; done
mkdir -p "$exe/again"; ln "$exe/file" "$exe/again/compiler-areas0"
out=/dev/shm/claude-2924-c12k3b
for list in dsqlite dlua; do
    rm -rf "$out"; mkdir -p "$out"
    case $list in
        dsqlite) args=(-c "${DF[@]}" "${S[@]}" -o "$out/sqlite3.o");;
        dlua) args=(-c "${DF[@]}" "$lua"/*.c);;
    esac
    B=(--build none "$exe/m0/compiler-areas0" --build bit2 "$exe/m4/compiler-areas4" --build none-again "$exe/again/compiler-areas0")
    (cd "$out" && taskset -c 2-9 "$exe/file" ab --rounds 3 --lock ~/buster-fast-bench/exclusive.sh "$exe/file" \
        -- time-runs --runs 3 --directory "$out" "${B[@]}" --list "${args[@]}" > "$D/logs/time-b-$list.log" 2>&1)
    echo "time $list: $?" >> logs/status-b.txt
done
for n in 64 256; do
    rm -rf "$out"; mkdir -p "$out"
    B=(--build none "$exe/m0/compiler-areas0" --build bit3 "$exe/m8/compiler-areas8" --build bit4 "$exe/m16/compiler-areas16" --build bit5 "$exe/m32/compiler-areas32" --build none-again "$exe/again/compiler-areas0")
    (cd "$out" && "$exe/file" ab --rounds 5 --cpu 2 --lock ~/buster-fast-bench/exclusive.sh "$exe/file" \
        -- time-runs --runs 9 --directory "$out" "${B[@]}" --list -c --lanes 1 "$D/fixtures/overloadable-$n.c" -o "$out/fixture.o" > "$D/logs/time-b-f$n.log" 2>&1)
    echo "time f$n: $?" >> logs/status-b.txt
done
rm -rf "$out"; mkdir -p "$out" logs/perf
for b in m0 m32 again; do
    x="$exe/$b/compiler-areas$( [ $b = again ] && echo 0 || echo ${b#m})"
    $L sh -c "cd $out && for i in \$(seq 1 20); do taskset -c 2 perf record -q -e cycles:u -c 10007 -o $out/perf-$b-\$i.data -- $x -c --lanes 1 $D/fixtures/overloadable-256.c -o $out/fixture.o > /dev/null 2>&1 || exit 1; done"
    echo "perf $b: $?" >> logs/status-b.txt
    for i in $(seq 1 20); do perf report -q -i "$out/perf-$b-$i.data" --stdio --sort symbol -F overhead,sample,symbol 2>/dev/null; done > "logs/perf/report-$b.txt"
done
rm -rf "$out" "$exe"
echo done >> logs/status-b.txt
