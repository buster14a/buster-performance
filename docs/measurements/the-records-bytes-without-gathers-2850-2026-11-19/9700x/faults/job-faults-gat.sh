#!/bin/bash
# job-faults-gat.sh: the sweep piece's fault round on the 9700X, in its tree (trees/gat2, PR #3030's sources with the
# piece): the tree as it is first (the control, which must pass), then each of faults-gat.py's faults alone: the
# fault applied to c_check_node_census.c, an incremental Release build, and test-checker's part 5 of 8 (the node
# machine's tests); the file restored after each. A line a fault in results/gat2/faults.txt: caught (the part fails),
# not-built, or SURVIVED. Each build and each run its own hold of the lock.
cd "$(dirname "$0")"
bench=$PWD
tree=$bench/trees/gat2
out=$bench/results/gat2
file=$tree/src/buster/compiler/c_check_node_census.c
clang_bin=$(dirname "$(ls -d ~/.cache/buster/benchpress-clang/*/bin/clang | head -1)")
export PATH=$clang_bin:$PATH
cp "$file" "$out/census-pristine.c" || exit 1
count=$(python3 "$bench/faults-gat.py" "$file") || exit 1
: > "$out/faults.txt"
run() {
    # run NAME: build the tree and run part 5; a line of faults.txt.
    name=$1
    ./lock.sh bash -c "cd $tree && ./build.sh --config Release" > "$out/fault-build.log" 2>&1
    if [ $? != 0 ] || ! test -x "$tree/build/compiler"; then echo "not-built $name" >> "$out/faults.txt"; return; fi
    (cd "$tree" && clang -dM -E -march=native -fwrapv -funsigned-char -x c /dev/null > build/predefines.h)
    ./lock.sh bash -c "cd $tree && ./build/compiler test-checker --seed 133 --part 5/8" > "$out/fault-part5.out" 2>&1
    status=$?
    summary=$(grep 'test-checker:.*checks' "$out/fault-part5.out" | tail -1)
    if [ $status = 0 ]; then verdict=SURVIVED; else verdict=caught; fi
    if [ "$name" = control ]; then if [ $status = 0 ]; then verdict=control-passes; else verdict=CONTROL-FAILS; fi; fi
    echo "$verdict $name status $status; $summary" >> "$out/faults.txt"
}
run control
grep -q control-passes "$out/faults.txt" || { echo "the control fails"; exit 1; }
for n in $(seq 0 $((count - 1))); do
    cp "$out/census-pristine.c" "$file"
    name=$(python3 "$bench/faults-gat.py" "$file" "$n") || { echo "not-applied $n" >> "$out/faults.txt"; continue; }
    run "$name"
done
cp "$out/census-pristine.c" "$file"
rm -rf "$tree/build"
echo job finished
