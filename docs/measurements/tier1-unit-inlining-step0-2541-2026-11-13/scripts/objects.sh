#!/bin/bash
# objects.sh: speedtest1's, Lua's and sqlite3.c's objects by --tier1 of main's and head's Release compilers (one lane,
# the 9700X job's sqlite options, -O2), each pair compared byte for byte: #2541's step 0 changes no unit without an
# always_inline callee. Run inside one hold of the lock. results/objects.txt.
set -u
cd "$(dirname "$0")"
root=$PWD
out=$root/results
mkdir -p "$out"
export LC_ALL=C
unset CPATH C_INCLUDE_PATH
head -1 /var/lib/buster-9700x/owner >> "$out/holders.txt"
inputs=$HOME/buster-fast-bench/138-tier1-quality-claude/inputs
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
tmp=$(mktemp -d /tmp/claude-2541-objects.XXXXXX)
sources=("$sqlite/sqlite3.c" "$inputs/speedtest1.c")
for f in "$inputs"/lua-5.4.8/src/*.c; do sources+=("$f"); done
status=0
same=0
differ=0
: > "$out/objects.txt"
for s in "${sources[@]}"; do
    name=$(basename "$s" .c)
    for tree in main head; do
        "$root/$tree/build/compiler" --lanes 1 --tier1 --tier1-report -O2 -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE \
            "-I$sqlite" "-I$inputs/lua-5.4.8/src" -c "$s" -o "$tmp/$name-$tree.o" > "$tmp/$name-$tree.log" 2>&1 || status=1
    done
    inlined=$(tr '\t' '\n' < "$tmp/$name-head.log" | grep '^inlined=' | paste -sd+ | sed 's/inlined=//g' | bc)
    if cmp -s "$tmp/$name-main.o" "$tmp/$name-head.o"; then same=$((same + 1)); verdict=same; else differ=$((differ + 1)); verdict=DIFFERS; fi
    echo "$name $verdict inlined=${inlined:-?} $(sha256sum < "$tmp/$name-head.o" | cut -c1-64)" >> "$out/objects.txt"
done
echo "units $((same + differ)) same $same differ $differ status $status" >> "$out/objects.txt"
rm -rf "$tmp"
