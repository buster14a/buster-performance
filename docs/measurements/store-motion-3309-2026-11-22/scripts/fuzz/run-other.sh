#!/bin/bash
# run-other.sh FIRST LAST: each seed's program by clang -O0 and by the other branch's --tier1 with +promote and without.
B=/home/user/buster-other/build/compiler
CL=/root/.cache/buster/toolchain/4444af0bee44de2d/llvm-23.1.4/bin/clang
fail=0; moved=0
cd other
for seed in $(seq $1 $2); do
    python3 ../gen.py $seed > p$seed.c
    $CL -O0 -fwrapv -w p$seed.c -o p$seed.ref 2> p$seed.cerr || { echo "seed $seed: clang failed"; fail=$((fail+1)); continue; }
    timeout 10 ./p$seed.ref > p$seed.ref.txt; rs=$?
    $B --tier1 --tier1-passes=+promote --tier1-report -w p$seed.c -o p$seed.on 2> p$seed.report || { echo "seed $seed: buster failed"; fail=$((fail+1)); continue; }
    timeout 10 ./p$seed.on > p$seed.on.txt; os=$?
    k=$(tr '\t' '\n' < p$seed.report | sed -n 's/^globals_promoted=//p' | head -1); moved=$((moved + ${k:-0}))
    if [ $rs != $os ] || ! cmp -s p$seed.ref.txt p$seed.on.txt; then
        $B --tier1 -w p$seed.c -o p$seed.off 2> /dev/null; timeout 10 ./p$seed.off > p$seed.off.txt
        if cmp -s p$seed.ref.txt p$seed.off.txt; then echo "seed $seed: DIFFERS WITH THE PASS (status $rs/$os)"; else echo "seed $seed: differs without the pass too"; fi
        fail=$((fail+1))
    else
        rm -f p$seed.c p$seed.ref p$seed.on p$seed.ref.txt p$seed.on.txt p$seed.report p$seed.cerr
    fi
done
echo "seeds $1..$2: failures=$fail keys_promoted=$moved"
