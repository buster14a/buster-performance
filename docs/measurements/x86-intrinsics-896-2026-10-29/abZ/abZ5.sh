#!/bin/bash
# A fourth control of abZ's difference in user cycles: the head's .rodata is 31,308 bytes larger than base's, which
# moves its whole .text 32 KB later (0x8ec000 against 0x8e4000, .text page-aligned), every code address the same mod
# 32 KB, which abZ2's to abZ4's shifts within a page don't vary. `pad` is base's tree with an unused array of 31,308
# bytes in main_unit_x86.c's .rodata, so that base's code lands where the head's does; then perf stat of base's, pad's
# and the head's executables, three rounds whose order rotates. Every run takes the lock on its own and runs pinned to
# CPU 2.
set -u
export EXCLUSIVE_OWNER=claude-126-cloud EXCLUSIVE_TITLE="solve #126 (cloud session): 9d's head against its parent, .rodata padding" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/126
lock=~/buster-fast-bench/exclusive.sh
unset CPATH C_INCLUDE_PATH BUSTER_ORACLE_CACHE
here=~/buster-fast-bench/claude-126-cloud/abZ
export TMPDIR=$here/tmp
mkdir -p "$TMPDIR"
export SOURCE_DATE_EPOCH=1792454400
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
system=(-nostdinc -isystem "$corpus/headers/usr/lib/clang/23/include" -isystem "$corpus/headers/usr/local/include" -isystem "$corpus/headers/usr/include")
lower=(--predefines "$corpus/provenance/gnu17-pinned-predefines.txt" --target=x86_64-linux-gnu -march=znver5 -std=gnu17 "${system[@]}" "$corpus/sqlite/sqlite3.c")
check=(--clang-features "${lower[@]}")
cd "$here"
rm -rf pad && mkdir pad && tar xf base.tar -C pad
printf '\n// abZ5: base'"'"'s code placed where the head'"'"'s is (not part of any commit).\n__attribute__((used, retain)) static const unsigned char buster_rodata_padding[31308] = { 1 };\n' >> pad/src/buster/compiler/main_unit_x86.c
(cd pad && $lock env BUSTER_DEBUG_INFO=0 LC_NUMERIC=C ./build.sh > ../build_pad.log 2>&1) || { echo "build pad failed"; exit 1; }
mkdir -p padded
for tree in base pad h9d; do
    cp $tree/build/compiler padded/$tree
    echo "$tree: $(readelf -SW padded/$tree | awk '$2 == ".rodata" || $2 == ".text" {printf "%s %s %s  ", $2, $4, $6}')"
done
$lock taskset -c 2 padded/pad -c -o lower_pad.o "${lower[@]}" > lower_pad.log 2>&1
cmp lower_base.o lower_pad.o && echo "pad's object identical"
front=instructions:u,cycles:u,branch-misses:u,ic_tag_hit_miss.instruction_cache_miss:u,op_cache_hit_miss.op_cache_miss:u
order=(base pad h9d)
for round in 1 2 3; do
    for i in "${!order[@]}"; do
        tree=${order[$(( (i + round - 1) % ${#order[@]} ))]}
        echo "== round $round tree $tree lower front" >> padded.log
        $lock perf stat -x, -e $front -r 11 taskset -c 2 padded/$tree -c -o /dev/null "${lower[@]}" 2>> padded.log >/dev/null
        echo "== round $round tree $tree drive front" >> padded.log
        $lock perf stat -x, -e $front -r 11 taskset -c 2 padded/$tree -fsyntax-only "${check[@]}" 2>> padded.log >/dev/null
    done
done
sha256sum padded/* lower_pad.o pad/src/buster/compiler/main_unit_x86.c > abZ5.sha256
echo done
