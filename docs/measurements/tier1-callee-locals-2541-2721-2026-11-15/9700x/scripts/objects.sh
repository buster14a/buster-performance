#!/bin/bash
# objects.sh TREE: TREE's --tier1 objects of sqlite3.c, speedtest1.c and Lua's units (-O2, the 9700X job's sqlite
# options) by one lane and by eight, and by eight with --tier1-no-hold, by the vector path and the scalar twin, each
# triple compared byte for byte: the unit's summaries and the last pass are by whichever lane needs each first (#2541
# steps 1 and 2), and the held code (step 2) is the code its lane would make: the object must depend on neither. Run inside one hold of the lock. results/objects.txt.
set -u
cd "$(dirname "$0")"
root=$PWD
tree=${1:?a tree}
out=$root/results
mkdir -p "$out"
export LC_ALL=C
unset CPATH C_INCLUDE_PATH
head -1 /var/lib/buster-9700x/owner >> "$out/holders.txt"
inputs=$HOME/buster-fast-bench/138-tier1-quality-claude/inputs
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
tmp=$(mktemp -d /tmp/claude-2541-step2-objects.XXXXXX)
sources=("$sqlite/sqlite3.c" "$inputs/speedtest1.c")
for f in "$inputs"/lua-5.4.8/src/*.c; do sources+=("$f"); done
status=0
same=0
differ=0
: > "$out/objects.txt"
for s in "${sources[@]}"; do
    name=$(basename "$s" .c)
    for path in vector scalar; do
        flag=; [ $path = scalar ] && flag=--scalar
        for lanes in 1 8 8h; do
            hold=; [ $lanes = 8h ] && hold=--tier1-no-hold
            "$root/$tree/build/compiler" $flag $hold --lanes ${lanes%h} --tier1 --tier1-report -O2 -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE \
                "-I$sqlite" "-I$inputs/lua-5.4.8/src" -c "$s" -o "$tmp/$name-$path-$lanes.o" > "$tmp/$name-$path-$lanes.log" 2>&1 || status=1
        done
        inlined=$(tr '\t' '\n' < "$tmp/$name-$path-1.log" | grep '^inlined=' | sed 's/inlined=//' | awk '{ s += $1 } END { print s + 0 }')
        if cmp -s "$tmp/$name-$path-1.o" "$tmp/$name-$path-8.o" && cmp -s "$tmp/$name-$path-1.o" "$tmp/$name-$path-8h.o"; then same=$((same + 1)); verdict=same; else differ=$((differ + 1)); verdict=DIFFERS; fi
        dead=$(tr '\t' '\n' < "$tmp/$name-$path-1.log" | grep '^dead=' | sed 's/dead=//' | awk '{ s += $1 } END { print s + 0 }')
        echo "$name $path lanes-1-8-nohold $verdict inlined=$inlined dead=$dead $(sha256sum < "$tmp/$name-$path-1.o" | cut -c1-64)" >> "$out/objects.txt"
    done
done
echo "pairs $((same + differ)) same $same differ $differ status $status" >> "$out/objects.txt"
rm -rf "$tmp"
