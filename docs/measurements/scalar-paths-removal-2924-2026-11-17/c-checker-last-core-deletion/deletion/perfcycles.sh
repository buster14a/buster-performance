#!/bin/bash
# Cycles by function, base against head: perf record -e cycles:u (period 10007) of 30 compiles of gate3's 256 groups'
# fixture and 5 of -c --lanes 1 sqlite3.c, by each build, alternating base and head.
cd "$(dirname "$0")"
D=$PWD
export EXCLUSIVE_OWNER=claude-2924 EXCLUSIVE_TITLE="Scalar paths removed: the checker core's last twins, C12c-3 core-3" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2924
L=~/buster-fast-bench/exclusive.sh
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
sqlite=$corpus/sqlite
F=$D/../c12k-gate3/fixtures/overloadable-256.c
out=/dev/shm/claude-2924-c12c33q; rm -rf "$out"; mkdir -p "$out" logs/cycles
for b in base head; do cp compilers/$b "$out/$b"; done
for list in fixture sqlite; do
    case $list in fixture) n=30; args=("$F" -o "$out/x.o");; sqlite) n=5; args=(-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I"$sqlite" "$sqlite/sqlite3.c" -o "$out/x.o");; esac
    $L sh -c "cd $out && for i in \$(seq 1 $n); do for b in base head; do taskset -c 2 perf record -q -e cycles:u -c 10007 -o $out/$list-\$b-\$i.data -- $out/\$b -c --lanes 1 $(printf '%q ' "${args[@]}") > /dev/null 2>&1 || exit 1; done; done"
    echo "perf $list: $?" >> logs/cycles/status.txt
    for b in base head; do
        for i in $(seq 1 $n); do perf report -q -i "$out/$list-$b-$i.data" --stdio --sort symbol -F sample,symbol 2>/dev/null; done > logs/cycles/$list-$b.txt
    done
    rm -f "$out"/*.data
done
rm -rf "$out"
echo done >> logs/cycles/status.txt
