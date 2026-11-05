#!/usr/bin/env bash
# 1435 front-end counters: closures.lua by each build at shift 0, 32 and 96, two event groups (six counters each), ROUNDS
# rounds (default 5), builds rotating, each run one hold, pinned to CPU 2.
set -u
W=$HOME/buster-fast-bench/1435-claude
export EXCLUSIVE_OWNER=claude-1435 EXCLUSIVE_TITLE='Problem 1435' EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/1435
L=$HOME/buster-fast-bench/exclusive.sh
O=$W/fecount${TAG:-}
SHIFTS=${SHIFTS:-0 32 96}
ROUNDS=${ROUNDS:-5}
BUILDS=${BUILDS:-main pad0 pad8 pad16 pad32 pad0w}
mkdir -p $O && cd $O || exit 1
exe() { case $1 in main) echo $W/base/lua-main-p$2 ;; *) echo $W/pad/lua-$1-p$2 ;; esac; }
GA=cycles:u,de_no_dispatch_per_slot.no_ops_from_frontend:u,de_src_op_disp.x86_decoder:u,de_src_op_disp.op_cache:u,op_cache_hit_miss.op_cache_miss:u,ic_tag_hit_miss.instruction_cache_miss:u
GB=cycles:u,bp_de_redirect:u,bp_redirects.resync:u,ex_ret_brn_misp:u,bp_l1_tlb_miss_l2_tlb_hit:u,de_no_dispatch_per_slot.backend_stalls:u
: > runs.txt
for round in $(seq 1 $ROUNDS); do
    for n in $SHIFTS; do
        r=$(( (round + n / 16) % $(echo $BUILDS | wc -w) ))
        rot=$(echo $BUILDS | awk -v r=$r '{ for (i = 0; i < NF; i++) printf "%s ", $(((i + r) % NF) + 1) }')
        for c in $rot; do
            for g in A B; do
                E=$([ $g = A ] && echo $GA || echo $GB)
                $L taskset -c 2 perf stat -x, -e $E -o $O/one.txt $(exe $c $n) $W/base/closures.lua > /dev/null 2>&1
                awk -F, -v c=$c -v r=$round -v p=$n -v g=$g 'BEGIN{ORS=""; print p, r, c g} /^[0-9]/{n=$3; sub(/:u$/,"",n); print " " n "=" $1} END{print "\n"}' $O/one.txt >> runs.txt
            done
        done
    done
done
echo done > done.txt
