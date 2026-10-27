#!/usr/bin/env bash
# #565's review fix, its scan's own cost: e1dc5d01 with a measurement switch (switch.diff, not committed) that skips the
# naked attributes' test, one executable, -c of sqlite3.c with the switch off and on in turn, each perf stat under the
# 9700X's lock on its own, on CPU 2.
cd ~/buster-fast-bench/asm-147d-claude || exit 1
mkdir -p tmp && export TMPDIR=$PWD/tmp
echo $$ > switch.pid
export EXCLUSIVE_OWNER=claude-asm-147 EXCLUSIVE_TITLE="Inline assembly: naked functions and symbols (#147)" EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/565
L=~/buster-fast-bench/exclusive.sh
unset CPATH C_INCLUDE_PATH
export SOURCE_DATE_EPOCH=1792454400
(cd switch && LC_NUMERIC=C BUSTER_DEBUG_INFO=0 $L ./build.sh > build.log 2>&1; echo "switch build $?")
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
system=(-nostdinc -isystem "$corpus/headers/usr/lib/clang/23/include" -isystem "$corpus/headers/usr/local/include" -isystem "$corpus/headers/usr/include")
drive=(--predefines "$corpus/provenance/gnu17-pinned-predefines.txt" --target=x86_64-linux-gnu -march=znver5 -std=gnu17 "${system[@]}")
sqlite="$corpus/sqlite/sqlite3.c"
$L taskset -c 2 switch/build/compiler -c "${drive[@]}" "$sqlite" -o switch-scan.o > switch-scan.log 2>&1; echo "scan drive check $? $(md5sum < switch-scan.o)"
BUSTER_NO_NAKED_SCAN=1 $L taskset -c 2 switch/build/compiler -c "${drive[@]}" "$sqlite" -o switch-noscan.o > switch-noscan.log 2>&1; echo "no scan drive check $? $(md5sum < switch-noscan.o)"
for r in 1 2 3; do
    for v in scan noscan; do
        if [ $v = noscan ]; then export BUSTER_NO_NAKED_SCAN=1; else unset BUSTER_NO_NAKED_SCAN; fi
        $L taskset -c 2 perf stat -r 11 -e instructions:u,cycles:u,task-clock switch/build/compiler -c "${drive[@]}" "$sqlite" -o /dev/null > perf-switch-$v-$r.log 2>&1; echo "$v perf $r $?"
    done
    unset BUSTER_NO_NAKED_SCAN
done
echo done
