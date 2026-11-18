#!/bin/bash
# #2924 C9c: where SSA promotion's vector path loses to its twin on sqlite3.c (benchmark-ir-source --only promote and
# --only promote-scalar, three rounds each, fresh copies), then each path's cycles by symbol (perf record).
D=~/buster-fast-bench/2924-c-df-claude/c9cgate
cd "$D" || exit 1
S=$D/logs/profile-status.txt
rm -f "$S"
export EXCLUSIVE_OWNER=claude-2924 EXCLUSIVE_TITLE="Scalar paths removed: SSA promotion's gate" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2924
L=~/buster-fast-bench/exclusive.sh
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
SOURCE=(--predefines "$corpus/provenance/gnu17-pinned-predefines.txt" --no-default-config --target=x86_64-linux-gnu -march=znver5 -std=gnu17 -nostdinc -isystem "$corpus/headers/usr/lib/clang/23/include" -isystem "$corpus/headers/usr/local/include" -isystem "$corpus/headers/usr/include" "$corpus/sqlite/sqlite3.c")
lua=$D/../c3pr/inputs/lua-5.4.8/src
for round in 1 2 3; do
    for v in promote promote-scalar; do
        cp compiler copies/run
        $L timeout -k 5 600 taskset -c 2 ./copies/run benchmark-ir-source --only $v "${SOURCE[@]}" > logs/only-sqlite-$v-$round.log 2>&1
        echo "only sqlite $v $round: $?" >> "$S"
        $L timeout -k 5 600 taskset -c 2 ./copies/run benchmark-ir-source --only $v "$lua"/*.c > logs/only-lua-$v-$round.log 2>&1
        echo "only lua $v $round: $?" >> "$S"
        rm -f copies/run
    done
done
for v in promote promote-scalar; do
    cp compiler copies/run
    $L timeout -k 5 900 taskset -c 2 perf record -q -e cycles -c 200003 -o logs/perf-$v.data ./copies/run benchmark-ir-source --only $v "${SOURCE[@]}" > logs/perf-$v.log 2>&1
    echo "perf $v: $?" >> "$S"
    perf report -i logs/perf-$v.data --no-children --sort sym --percent-limit 0.3 --stdio 2>/dev/null | head -80 > logs/perf-$v.txt
    rm -f copies/run
done
echo done >> "$S"
