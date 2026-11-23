#!/bin/bash
# run.sh FIRST LAST [known]: each seed's program by clang -O0, --tier1 with the pass and --tier1 without it. The recorded
# results were made while the pass was on by default; +storemotion says the same now that it is opt-in.
B=/home/user/buster/build/compiler
CL=/root/.cache/buster/toolchain/4444af0bee44de2d/llvm-23.1.4/bin/clang
fail=0; moved=0; sunk=0
for seed in $(seq $1 $2); do
    python3 gen.py $seed $3 > p$seed.c
    $CL -O0 -fwrapv -w p$seed.c -o p$seed.ref 2> p$seed.cerr || { echo "seed $seed: clang failed"; fail=$((fail+1)); continue; }
    timeout 10 ./p$seed.ref > p$seed.ref.txt; rs=$?
    $B --tier1 --tier1-passes=+storemotion --tier1-report -w p$seed.c -o p$seed.on 2> p$seed.report || { echo "seed $seed: buster failed"; fail=$((fail+1)); continue; }
    timeout 10 ./p$seed.on > p$seed.on.txt; os=$?
    k=$(grep store-motion p$seed.report | sed -n 's/.*\tkeys=\([0-9]*\).*/\1/p'); moved=$((moved + ${k:-0}))
    k=$(grep store-motion p$seed.report | sed -n 's/.*\tsunk=\([0-9]*\).*/\1/p'); sunk=$((sunk + ${k:-0}))
    if [ $rs != $os ] || ! cmp -s p$seed.ref.txt p$seed.on.txt; then
        $B --tier1 --tier1-passes=-storemotion -w p$seed.c -o p$seed.off 2> /dev/null; timeout 10 ./p$seed.off > p$seed.off.txt
        if cmp -s p$seed.ref.txt p$seed.off.txt; then echo "seed $seed: DIFFERS WITH THE PASS (status $rs/$os)"; else echo "seed $seed: differs without the pass too"; fi
        fail=$((fail+1))
    else
        rm -f p$seed.c p$seed.ref p$seed.on p$seed.ref.txt p$seed.on.txt p$seed.report p$seed.cerr
    fi
done
echo "seeds $1..$2: failures=$fail keys_moved=$moved keys_sunk=$sunk"
