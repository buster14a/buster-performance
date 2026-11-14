#!/bin/bash
# corpora.sh COMPILER OUT: every corpus's objects by windows of 0 (one part), 1 and 2,048 tokens, with -g and without,
# and by 1 with --poison-arenas and by --scalar: each must be the bytes of one part. One hold of the lock a corpus.
set -u
compiler=$PWD/$1
out=$PWD/$2
cd ~/buster-fast-bench/2536-step1-claude
export EXCLUSIVE_OWNER=claude-2536-step1 EXCLUSIVE_TITLE="Problem 2536 (step 1)" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2536
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
sqlite=$corpus/sqlite
musl=$corpus/libc/musl
lua=~/buster-fast-bench/1189-codex-01a1b81e-plan/input-reference/lua-5.4.8/src
mkdir -p "$out"
if [ ! -d c-testsuite ]; then
    git init -q --template= c-testsuite
    git -C c-testsuite fetch -q --depth 1 https://github.com/c-testsuite/c-testsuite 5c7275656d751de0e68b2d340a95b5681858ed07
    git -C c-testsuite checkout -q FETCH_HEAD
fi
variants=("w0::--emit-window=0" "w1::--emit-window=1" "w2048::--emit-window=2048" "w1p::--emit-window=1 --poison-arenas"
          "gw0:-g:--emit-window=0" "gw1:-g:--emit-window=1" "gw2048:-g:--emit-window=2048" "gw1p:-g:--emit-window=1 --poison-arenas"
          "sw0:--scalar:--emit-window=0" "sw1:--scalar:--emit-window=1")
# run_corpus NAME DIRECTORY OPTIONS...: each variant's objects in OUT/NAME/VARIANT (one hold of the lock a variant),
# then each compared with one part's.
run_corpus()
{
    local name=$1 directory=$2
    shift 2
    for v in "${variants[@]}"; do
        tag=${v%%:*}; rest=${v#*:}; extra=${rest%%:*}; window=${rest#*:}
        timeout 900 ~/buster-fast-bench/exclusive.sh ./corpus-run.sh "$compiler" "$out" "$name" "$directory" "$tag" "$extra" "$window" "$@" >> "$out/$name.log" 2>&1
        echo "$name $tag hold status $?" >> "$out/summary.txt"
    done
    for v in "${variants[@]}"; do
        tag=${v%%:*}
        reference=w0
        [[ $tag == g* ]] && reference=gw0
        [[ $tag == s* ]] && reference=w0
        same=0; differ=0; failed=0
        while read -r status base; do
            ref_status=$(awk -v b="$base" '$2 == b { print $1 }' "$out/$name/$reference.status")
            if [ "$status" != "$ref_status" ]; then differ=$((differ + 1)); echo "status $name $tag $base $status/$ref_status" >> "$out/differences.txt"
            elif [ "$status" != 0 ]; then
                if cmp -s "$out/$name/$tag/$base.err" "$out/$name/$reference/$base.err"; then failed=$((failed + 1)); else differ=$((differ + 1)); echo "diagnostics $name $tag $base" >> "$out/differences.txt"; fi
            elif cmp -s "$out/$name/$tag/$base.o" "$out/$name/$reference/$base.o"; then same=$((same + 1))
            else differ=$((differ + 1)); echo "object $name $tag $base" >> "$out/differences.txt"; fi
        done < "$out/$name/$tag.status"
        echo "$name $tag against $reference: $same objects the same, $failed failures the same, $differ different" >> "$out/summary.txt"
    done
}
echo "$sqlite/sqlite3.c" > "$out/sqlite.files"
ls "$lua"/*.c > "$out/lua.files"
sed -n 's|^\([0-9][0-9]*\)$|'"$PWD"'/c-testsuite/tests/single-exec/\1.c|p' head2/tests/c-testsuite/subset.txt > "$out/c-testsuite.files"
echo "$PWD/head2/src/buster/compiler/main.c" > "$out/main.files"
cp ~/buster-fast-bench/672-allcore-claude/scratch/musl.all.txt "$out/musl.files"
run_corpus sqlite "$sqlite" -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite"
run_corpus lua "$lua" -DLUA_USE_LINUX
run_corpus c-testsuite "$PWD/c-testsuite"
run_corpus main "$PWD/head2" -march=native -Isrc -fwrapv -funsigned-char
run_corpus musl "$musl" -std=c99 -nostdinc -ffreestanding -D_XOPEN_SOURCE=700 -I "$musl/arch/x86_64" -I "$musl/arch/generic" -I "$corpus/musl-generated/obj/src/internal" -I "$musl/src/include" -I "$musl/src/internal" -I "$corpus/musl-generated/obj/include" -I "$musl/include"
echo done >> "$out/summary.txt"
