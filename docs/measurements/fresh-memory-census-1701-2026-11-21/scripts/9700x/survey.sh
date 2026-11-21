#!/bin/bash
# survey.sh LABEL: a one-core survey of -c sqlite3.c on CPU 2, in one hold of the lock (run under exclusive.sh).
# 5 stage clocks, perf stat PipelineL1/L2 (5 runs each), 2 counter groups x 3 timestamped samplings.
set -u
cd "$(dirname "$0")"
label=${1:?label}
C=$PWD/corpus
X=$PWD/compiler-$label
FLAGS="--predefines $C/provenance/gnu17-pinned-predefines.txt -march=znver5 -std=gnu17 -nostdinc -isystem $C/headers/usr/lib/clang/23/include -isystem $C/headers/usr/local/include -isystem $C/headers/usr/include"
out=$PWD/results/$label
t=/dev/shm/sc-l70yen
mkdir -p "$out" "$t"
head -3 /var/lib/buster-9700x/owner > "$out/holder.txt"
uptime > "$out/uptime.txt"
run() { taskset -c 2 "$X" "$@" -c $FLAGS "$C/sqlite/sqlite3.c" -o "$t/o.o"; }
run > /dev/null 2>&1
for r in 1 2 3 4 5; do run --time-stages > /dev/null 2> "$out/stages-$r.txt"; done
sha256sum "$t/o.o" > "$out/object.sha256"
perf stat -M PipelineL1 -r 5 -o "$out/pipeline-l1.txt" -- taskset -c 2 "$X" -c $FLAGS "$C/sqlite/sqlite3.c" -o "$t/o.o"
perf stat -M PipelineL2 -r 5 -o "$out/pipeline-l2.txt" -- taskset -c 2 "$X" -c $FLAGS "$C/sqlite/sqlite3.c" -o "$t/o.o"
perf stat -e cycles:u,cycles:k,instructions:u,ex_ret_brn_misp:u,ls_dmnd_fills_from_sys.all:u,ls_dmnd_fills_from_sys.dram_io_near:u -r 5 -o "$out/counts.txt" -- taskset -c 2 "$X" -c $FLAGS "$C/sqlite/sqlite3.c" -o "$t/o.o"
g1='{cycles:u,instructions:u,ex_ret_brn_misp:u,de_no_dispatch_per_slot.no_ops_from_frontend:u,ex_no_retire.load_not_complete:u}:S'
g2='{cycles:u,ls_dmnd_fills_from_sys.all:u,ls_dmnd_fills_from_sys.dram_io_near:u,op_cache_hit_miss.op_cache_miss:u,de_no_dispatch_per_slot.backend_stalls:u}:S'
for r in 1 2 3; do
    for g in 1 2; do
        if [[ $g == 1 ]]; then ev=$g1; else ev=$g2; fi
        taskset -c 5 perf record -q -T -o "$t/s.data" -e "$ev" -c 100003 -- taskset -c 2 "$X" --time-stages -c $FLAGS "$C/sqlite/sqlite3.c" -o "$t/o.o" > /dev/null 2> "$out/g$g-$r.stages.txt"
        perf script -i "$t/s.data" -F time,period,event,ip,sym 2> /dev/null | gzip -c > "$out/g$g-$r.samples.gz"
        rm -f "$t/s.data"
    done
done
rm -rf "$t"
date -u +%FT%TZ > "$out/.done"
