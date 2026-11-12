#!/bin/bash
# probe.sh: one short hold that shows the formats the reducers read (not a measurement).
cd "$(dirname "$0")"
mkdir -p probe scratch
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
options=(-c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c")
export LC_ALL=C
head -1 /var/lib/buster-9700x/owner > probe/holder.txt
taskset -c 2 src/build/compiler --time-stages --lanes 1 "${options[@]}" -o scratch/p.o > probe/stages.stdout.txt 2> probe/stages.txt
echo "status $?" >> probe/stages.txt
perf stat -a -A -C 2,5 -x, -o probe/stat.csv -e '{cycles:u,instructions:u,cycles:k,instructions:k}' -e amd_umc/umc_cas_cmd.rd/,amd_umc/umc_cas_cmd.wr/,amd_umc/umc_mem_clk/ -e msr/aperf/,msr/mperf/,msr/tsc/ -e power/energy-pkg/ -- taskset -c 2 src/build/compiler --lanes 1 "${options[@]}" -o scratch/p.o > /dev/null 2> probe/stat.err
echo "status $?" >> probe/stat.err
perf record -q -a -C 2 -k CLOCK_MONOTONIC -T -o scratch/probe.data -e '{cycles,cycles:u,instructions:u,cycles:k,instructions:k}:S' -c 100003 -- taskset -c 2 src/build/compiler --time-stages --lanes 1 "${options[@]}" -o scratch/p.o > /dev/null 2> probe/record.stages.txt
echo "status $?" >> probe/record.stages.txt
perf script -i scratch/probe.data -F cpu,pid,tid,time,period,event,ip,sym 2> probe/script.err | head -40 > probe/script.head.txt
perf script -i scratch/probe.data -F cpu,pid,tid,time,period,event,ip,sym 2>/dev/null | wc -l > probe/script.lines.txt
perf stat -a -x, -I 5 -o probe/interval.csv -e amd_umc/umc_cas_cmd.rd/,amd_umc/umc_cas_cmd.wr/ -- taskset -c 2 src/build/compiler --lanes 1 "${options[@]}" -o scratch/p.o > /dev/null 2> probe/interval.err
echo "status $?" >> probe/interval.err
strace -f -c -o probe/strace.txt taskset -c 2 src/build/compiler --lanes 1 "${options[@]}" -o scratch/p.o > /dev/null 2>&1
perf list 2>/dev/null | grep -E "l2_fill_rsp_src|ls_dmnd_fills_from_sys|ls_hw_pf_dc_fills|l2_pf_|ex_no_retire|ls_any_fills_from_sys|l3_" > probe/events.txt
cat /sys/kernel/mm/transparent_hugepage/enabled /sys/kernel/mm/transparent_hugepage/defrag > probe/thp.txt
rm -f scratch/probe.data
date -u +%FT%TZ > probe/.done
