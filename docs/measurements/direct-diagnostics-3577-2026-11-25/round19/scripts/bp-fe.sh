#!/bin/bash
# bp-fe.sh: front-end counters (op cache, BTB, ITLB, I-cache fills), PipelineL2, and IBS fetch samples of main (base)
# and the head (work), one hold.
D=$HOME/buster-fast-bench/3577-claude
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
export EXCLUSIVE_OWNER=claude-3577 EXCLUSIVE_TITLE="#3577 direct path: front-end counters, main vs head" EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/3597
cd "$D/work" || exit 1
~/buster-fast-bench/exclusive.sh timeout -k 5 590 bash -c '
  sqlite=$1
  flags=(-c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c" -o /tmp/3577-claude-c.o)
  for t in base work base work; do
    echo "== $t"
    for ev in op_cache_hit_miss.op_cache_miss:u,op_cache_hit_miss.all_op_cache_accesses:u,de_src_op_disp.op_cache:u,de_src_op_disp.x86_decoder:u \
              bp_l2_btb_correct:u,bp_de_redirect:u,bp_l1_tlb_miss_l2_tlb_hit:u,ic_cache_fill_l2:u \
              ic_tag_hit_miss.instruction_cache_miss:u,ic_cache_fill_sys:u,bp_redirects.resync:u,ex_ret_brn_tkn:u \
              cycles:u,instructions:u,bp_dyn_ind_pred:u,ex_ret_brn_ind_misp:u; do
      (cd ../$t && taskset -c 2 perf stat -r 10 -e $ev ./build/compiler "${flags[@]}" 2>&1 | grep -E "^ +[0-9,]+ +[a-z]" | sed "s/  */ /g")
    done
  done
  for t in base work; do
    echo "== L2 $t"
    (cd ../$t && taskset -c 2 perf stat -r 10 -M PipelineL2 ./build/compiler "${flags[@]}" 2>&1 | grep -E "%" | sed "s/  */ /g")
  done
  for t in base work; do
    (cd ../$t && taskset -c 2 perf record -q -e ibs_fetch/rand_en=1,swfilt=1/u -c 2048 -o ../pif-$t.data -- bash -c "for i in \$(seq 20); do ./build/compiler \"\$@\"; done" _ "${flags[@]}" > /dev/null 2>&1) || echo "record failed $t"
  done
' x "$sqlite"
cd "$D" || exit 1
ls -la pif-*.data
perf report -D -i pif-base.data 2>/dev/null | grep -m1 -B3 -A6 "ibs_fetch_ctl\|IbsFetchCtl\|FetchCtl" | head -20
echo DONE
