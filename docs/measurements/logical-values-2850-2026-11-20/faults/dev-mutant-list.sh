#!/bin/bash
# dev-mutant.sh INDEX...: each fault INDEX of faults-rows-2.py applied alone to the working tree (trees/xrd, at the
# round's base), a Develop build, and the three corpora's shadow with the rows on: whether a fault the fixture does not
# see is seen by a corpus. Prints, a fault, each corpus's status and its counts' lines. The two files restored after.
cd "$(dirname "$0")"
bench=$PWD
tree=$bench/trees/xrd
out=$bench/results/xrd
. ./corpora.sh
clang_bin=$(dirname "$(ls -d ~/.cache/buster/benchpress-clang/*/bin/clang | head -1)")
export PATH=$clang_bin:$PATH
rows=src/buster/compiler/c_check_node_machine_rows.c
census=src/buster/compiler/c_check_node_census.c
cp "$tree/$rows" "$out/rows-pristine.c" && cp "$tree/$census" "$out/census-pristine.c" || exit 1
for n in "$@"; do
    cp "$out/rows-pristine.c" "$tree/$rows"; cp "$out/census-pristine.c" "$tree/$census"
    if [ "$n" = base ]; then name=base; else name=$(python3 "$bench/${LIST:-faults-rows-2.py}" "$tree" "$n") || { echo "not-applied $n"; continue; }; fi
    ./lock.sh bash -c "cd $tree && ./build.sh" > "$out/mutant-build.log" 2>&1 || { echo "not-built $name"; continue; }
    echo "== $name"
    for c in sqlite3 lua musl; do
        case $c in
            sqlite3) arguments=$sqlite_arguments ;;
            lua) arguments=$lua_arguments ;;
            musl) arguments=$musl_arguments ;;
        esac
        ./lock.sh bash -c "taskset -c 2 $tree/build/compiler measure-node-machine --shadow --passes 0 --window-rows $arguments; echo status \$?" > "$out/mutant-$c.txt" 2>&1
        echo "$c $(grep '^status' "$out/mutant-$c.txt") $(grep -o 'window rows expressions=[0-9]* records=[0-9]* taken=[0-9]* ([0-9.]*%) their-records=[0-9]* ([0-9.]*%) their-entries=[0-9]* differences=[0-9]* not-kept-by-the-reference=[0-9]* second-runs-that-differ=[0-9]* records-swept=[0-9]* entries-written=[0-9]*' "$out/mutant-$c.txt") $(grep -o 'update=[0-9]* branches=[0-9]* refused-conversion=[0-9]* constant-to-a-floating-class=[0-9]*' "$out/mutant-$c.txt") $(grep -o "a target's word=[0-9]* ([0-9.]*% of the records swept) a line or a table=[0-9]*" "$out/mutant-$c.txt")"
    done
done
cp "$out/rows-pristine.c" "$tree/$rows"; cp "$out/census-pristine.c" "$tree/$census"
echo mutants done
