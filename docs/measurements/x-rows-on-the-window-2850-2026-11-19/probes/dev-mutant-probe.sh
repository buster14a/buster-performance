#!/bin/bash
# dev-mutant-probe.sh LIST CASES INDEX...: each fault INDEX of LIST (a faults-rows-N.py) applied alone to the working
# tree (trees/xrd, at the round's base), a Develop build, and the probes of CASES (probes/CASES), a file a statement:
# which probe sees a fault the fixture does not. Prints, a fault, the probes whose rows differ from X's on T's columns
# or whose counts differ from the base's (run first). The two files restored after.
cd "$(dirname "$0")"
bench=$PWD
list=$bench/$1; cases=$2; shift 2
tree=$bench/trees/xrd
out=$bench/results/xrd
clang_bin=$(dirname "$(ls -d ~/.cache/buster/benchpress-clang/*/bin/clang | head -1)")
export PATH=$clang_bin:$PATH
rows=src/buster/compiler/c_check_node_machine_rows.c
census=src/buster/compiler/c_check_node_census.c
cp "$tree/$rows" "$out/rows-pristine.c" && cp "$tree/$census" "$out/census-pristine.c" || exit 1
for n in base "$@"; do
    cp "$out/rows-pristine.c" "$tree/$rows"; cp "$out/census-pristine.c" "$tree/$census"
    if [ "$n" = base ]; then name=base; else name=$(python3 "$list" "$tree" "$n") || { echo "not-applied $n"; continue; }; fi
    ./lock.sh bash -c "cd $tree && ./build.sh" > "$out/mutant-build.log" 2>&1 || { echo "not-built $name"; continue; }
    ./lock.sh bash -c "cd probes && python3 probe.py $tree/build/compiler $cases" > "$out/mutant-probes-$name.txt" 2>&1
    if [ "$n" = base ]; then echo "== base: $(grep -c 'status 0' "$out/mutant-probes-base.txt") probes"; continue; fi
    echo "== $name: probes that differ from the base's"
    diff <(grep 'status' "$out/mutant-probes-base.txt") <(grep 'status' "$out/mutant-probes-$name.txt") | grep '^>' | cut -c1-240
done
cp "$out/rows-pristine.c" "$tree/$rows"; cp "$out/census-pristine.c" "$tree/$census"
./lock.sh bash -c "cd $tree && ./build.sh" > "$out/mutant-build.log" 2>&1
echo mutant probes done
