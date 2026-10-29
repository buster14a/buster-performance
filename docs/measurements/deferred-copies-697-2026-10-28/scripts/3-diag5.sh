#!/bin/bash
# Where item 2's lanes spend their walks on h16x19.c on 8 lanes once the deferred state's own arenas are in base pages
# (3-diag3.sh: 62 ns/token of walks against main3's 15): item2-nothp and main3-nothp under perf record of their page
# faults with their addresses and call chains, and of their cycles with call chains, a lock hold each; then the reports
# (faultmaps2.py by mapping and user function, cyclemap.py by leaf symbol), in a hold of their own.
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
L="$D/3-diag5.txt"
for tree in item2-nothp main3-nothp; do
    echo "== $(date -Is) faults $tree $unit" >> "$L"
    ~/buster-fast-bench/exclusive.sh perf record -q -e page-faults -c 1 -d --data-mmap -g -o "$D/3-diag5-$tree-faults.data" "$D/$tree/build/compiler" benchmark-checker-deferred --passes 6 --lanes 8 --every-lane --cpus 2,0,1,3,4,5,6,7 "${options[@]}" "$unit" >> "$L" 2>&1
    echo "exit=$? $(date -Is)" >> "$L"
    sleep 5
    echo "== $(date -Is) cycles $tree $unit" >> "$L"
    ~/buster-fast-bench/exclusive.sh perf record -q -e cycles -F 20000 -g -o "$D/3-diag5-$tree-cycles.data" "$D/$tree/build/compiler" benchmark-checker-deferred --passes 6 --lanes 8 --every-lane --cpus 2,0,1,3,4,5,6,7 "${options[@]}" "$unit" >> "$L" 2>&1
    echo "exit=$? $(date -Is)" >> "$L"
    sleep 5
done
~/buster-fast-bench/exclusive.sh bash -c '
D=/home/david/buster-fast-bench/697-cloud
for tree in item2-nothp main3-nothp; do
    perf script -i "$D/3-diag5-$tree-faults.data" --show-mmap-events -F tid,addr,ip,sym 2>/dev/null | python3 "$D/faultmaps2.py" > "$D/3-diag5-$tree-faultmap.txt"
    perf script -i "$D/3-diag5-$tree-cycles.data" -F pid,tid,ip,sym 2>/dev/null | python3 "$D/cyclemap.py" > "$D/3-diag5-$tree-cyclemap.txt"
done' >> "$L" 2>&1
echo "3-diag5 done $(date -Is)" >> "$D/chain.out"
