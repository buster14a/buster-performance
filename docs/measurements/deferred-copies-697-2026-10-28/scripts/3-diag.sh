#!/bin/bash
# Why item 2's walks on 8 lanes cost more than main3's on h16x19.c (campaign A3's rounds 1 and 2): each tree's
# benchmark on 8 lanes with every lane, under perf stat (page faults, context switches, migrations, task clock), twice;
# then perf record of its page faults and of its cycles by symbol. One lock hold each.
D=/home/david/buster-fast-bench/697-cloud
cd "$D" || exit 1
export EXCLUSIVE_OWNER=claude-697-cloud
export EXCLUSIVE_TITLE="#697 deferred bodies (cloud session): a diagnostic of item 2's lanes on the 9700X"
export EXCLUSIVE_LINK="https://github.com/buster14a/buster/issues/697"
unset CPATH C_INCLUDE_PATH
export SOURCE_DATE_EPOCH=1792454400
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
options=(--predefines "$corpus/provenance/gnu17-pinned-predefines.txt" --clang-features --no-default-config --target=x86_64-linux-gnu -march=znver5 -std=gnu17 -nostdinc -isystem "$corpus/headers/usr/lib/clang/23/include" -isystem "$corpus/headers/usr/local/include" -isystem "$corpus/headers/usr/include")
unit="$D/inputs/synthetic/${1:-h16x19}.c"
L="$D/3-diag.txt"
for rep in 1 2; do
    for tree in item2 main3; do
        echo "== $(date -Is) stat $tree $unit $rep" >> "$L"
        ~/buster-fast-bench/exclusive.sh perf stat -e page-faults,context-switches,cpu-migrations,task-clock "$D/$tree/build/compiler" benchmark-checker-deferred --passes 12 --lanes 8 --every-lane --cpus 2,0,1,3,4,5,6,7 "${options[@]}" "$unit" >> "$L" 2>&1
        echo "exit=$? $(date -Is)" >> "$L"
    done
done
for tree in item2 main3; do
    for event in page-faults cycles; do
        echo "== $(date -Is) record $event $tree $unit" >> "$L"
        ~/buster-fast-bench/exclusive.sh perf record -q -e "$event" $([ $event = page-faults ] && echo "-c 1" || echo "-F 20000") -o "$D/3-diag-$tree-$event.data" "$D/$tree/build/compiler" benchmark-checker-deferred --passes 6 --lanes 8 --every-lane --cpus 2,0,1,3,4,5,6,7 "${options[@]}" "$unit" >> "$L" 2>&1
        echo "exit=$? $(date -Is)" >> "$L"
        perf report -i "$D/3-diag-$tree-$event.data" --stdio --sort sym 2>/dev/null | grep -v "^#" | grep -v "^$" | head -40 > "$D/3-diag-$tree-$event.txt"
    done
done
echo "3-diag done $(date -Is)" >> "$D/chain.out"
