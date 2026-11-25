#!/bin/bash
# Counter split and IBS cycle profiles: base (09c3b79b) against work (the PR head as a patch on 19e85f76b), sqlite3.c's
# default -c; the work tree built in one locked run, the counters and profiles taken in another.
D=$HOME/buster-fast-bench/3577-claude
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
cd "$D/work" || exit 1
git checkout -q -- src tools docs 2>/dev/null
git checkout -q --detach 19e85f76b || exit 1
git apply --whitespace=nowarn ../step7-head.patch || { echo "PATCH FAILED"; exit 1; }
export EXCLUSIVE_OWNER=claude-3577 EXCLUSIVE_TITLE="#3577 direct path: counter split and cycle profiles" EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/3597
~/buster-fast-bench/exclusive.sh timeout -k 5 590 ./build.sh --config Release > ../work-build.log 2>&1 || { echo "BUILD FAILED"; tail -20 ../work-build.log; exit 1; }
chmod +x build/compiler; ./build/compiler --version > /dev/null || { echo "NO COMPILER"; exit 1; }
cd "$D"
~/buster-fast-bench/exclusive.sh timeout -k 5 590 bash -c '
  sqlite=$1
  flags=(-c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c")
  A=cycles:u,instructions:u,ex_ret_brn_misp:u,ic_tag_hit_miss.instruction_cache_miss:u,ls_bad_status2.stli_other:u,l2_cache_req_stat.dc_access_in_l2:u
  B=cycles:u,l2_cache_req_stat.ic_access_in_l2:u,bp_l1_tlb_miss_l2_tlb_miss.all:u,dTLB-load-misses:u,de_dispatch_stall_cycle_dynamic_tokens_part1.store_queue_rsrc_stall:u,de_dispatch_stall_cycle_dynamic_tokens_part1.load_queue_rsrc_stall:u
  for round in 1 2; do
    for t in base work; do
      echo "== $t A round $round"; (cd $t && taskset -c 2 perf stat -r 21 -x, -e $A ./build/compiler "${flags[@]}" -o /tmp/3577-claude-c.o 2>&1 >/dev/null | cut -d, -f1,3)
      echo "== $t B round $round"; (cd $t && taskset -c 2 perf stat -r 21 -x, -e $B ./build/compiler "${flags[@]}" -o /tmp/3577-claude-c.o 2>&1 >/dev/null | cut -d, -f1,3)
    done
  done
  for t in base work; do
    (cd $t && taskset -c 2 perf record -q -e ibs_op/cnt_ctl=0,swfilt=1/u -c 400000 -o ../pcyc8-$t.data -- bash -c "for i in \$(seq 100); do ./build/compiler \"\$@\" -o /tmp/3577-claude-i.o; done" _ "${flags[@]}" > /dev/null 2>&1) || echo "record failed $t"
  done
' ctr "$sqlite" > ctr7.out 2>&1
for t in base work; do
  perf report -q -i pcyc8-$t.data --no-children --sort symbol --stdio 2>/dev/null | grep -v "^$" > cyc8-$t.txt
  perf report -q -i pcyc8-$t.data --no-children --sort srcline --stdio 2>/dev/null | grep -v "^$" > cyc8-lines-$t.txt
done
echo DONE
