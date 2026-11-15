#!/bin/bash
# counters.sh SUFFIX PASSES LABEL...: perf stat of the shadow's three tight sets (no options: T, T+C, T+C+X; PASSES
# passes, CPU 2) on Lua and sqlite3.c for each LABEL's compiler, four event groups, each a run, all in one hold; the
# files are results/LABEL/counters-<corpus>-gN<suffix>.txt.
set -u
cd "$(dirname "$0")"
suffix=$1; passes=$2
shift 2
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
sqlite=$corpus/sqlite
lua=$PWD/inputs/lua-5.4.8/src
export LC_ALL=C
g1="cycles:u,instructions:u,ex_ret_brn_misp:u,ex_ret_brn_ind_misp:u,bp_l2_btb_correct:u,bp_redirects.resync:u"
g2="cycles:u,ls_bad_status2.stli_other:u,ls_stlf:u,ls_dmnd_fills_from_sys.all:u,ls_l1_d_tlb_miss.all:u,ls_hw_pf_dc_fills.all:u"
g3="cycles:u,op_cache_hit_miss.op_cache_miss:u,de_src_op_disp.x86_decoder:u,de_src_op_disp.op_cache:u,ic_tag_hit_miss.instruction_cache_miss:u,bp_de_redirect:u"
g4="cycles:u,bp_redirects.ex_redir:u,ex_ret_brn_tkn_misp:u,ex_ret_near_ret_mispred:u,bp_l1_tlb_miss_l2_tlb_hit:u,bp_l1_tlb_miss_l2_tlb_miss.all:u"
commands="head -1 /var/lib/buster-9700x/owner | cut -c1-200 >> $PWD/results/holds-counters$suffix.txt"
for label in "$@"; do
    out=$PWD/results/$label
    n=0
    for group in "$g1" "$g2" "$g3" "$g4"; do
        n=$((n + 1))
        f=$out/counters-lua-g$n$suffix.txt
        commands="$commands; perf stat -x, -o $f -e $group -- taskset -c 2 $out/compiler measure-node-machine --shadow --passes $passes $lua/*.c > $f.out 2>&1; echo status \$? >> $f"
        f=$out/counters-sqlite3-g$n$suffix.txt
        commands="$commands; perf stat -x, -o $f -e $group -- taskset -c 2 $out/compiler measure-node-machine --shadow --passes $passes -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I$sqlite $sqlite/sqlite3.c > $f.out 2>&1; echo status \$? >> $f"
    done
done
./lock.sh bash -c "$commands"
