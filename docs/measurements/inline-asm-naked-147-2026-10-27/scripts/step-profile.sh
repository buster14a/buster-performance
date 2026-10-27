#!/usr/bin/env bash
# After step-three.sh (PID $1): where head's 1.8 M fewer user instructions on sqlite3.c's -c go, by function: perf record
# of instructions:u over 5 compiles of each tree, under the lock once each.
cd ~/buster-fast-bench/asm-147b-claude || exit 1
echo $$ > step-profile.pid
while kill -0 "$1" 2> /dev/null; do sleep 10; done
export EXCLUSIVE_OWNER=claude-asm-147 EXCLUSIVE_TITLE="Inline assembly: naked functions and symbols (#147)" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/147
L=~/buster-fast-bench/exclusive.sh
unset CPATH C_INCLUDE_PATH
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
system=(-nostdinc -isystem "$corpus/headers/usr/lib/clang/23/include" -isystem "$corpus/headers/usr/local/include" -isystem "$corpus/headers/usr/include")
drive=(--predefines "$corpus/provenance/gnu17-pinned-predefines.txt" --target=x86_64-linux-gnu -march=znver5 -std=gnu17 "${system[@]}")
sqlite="$corpus/sqlite/sqlite3.c"
for t in base head; do
    $L taskset -c 2 perf record -q -e instructions:u -c 200003 -o profile-$t.data -- bash -c "for i in 1 2 3 4 5; do $t/build/compiler -c ${drive[*]} $sqlite -o /dev/null; done" > /dev/null 2>&1
    perf report -i profile-$t.data --stdio --sort symbol --percent-limit 0.05 2> /dev/null | grep -v "^#" | grep -v "^$" | head -80 > profile-$t.txt
    echo "$t profile $?"
done > step-profile.log 2>&1
echo done >> step-profile.log
