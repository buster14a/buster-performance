#!/bin/bash
# job-faults-gat2.sh: the sweep piece's second fault round on the 9700X, in its tree (trees/gat2), with the sweep's
# verify's new check (census-round2.c: a record the kernel didn't place has no byte): the tree as it is first (the
# control), then the four faults that drop a column's mask of the placed records (faults-gat.py's 28 to 31), which the
# first round's tests passed. A line a fault in results/gat2/faults-round2.txt. Each build and each run its own hold of
# the lock.
cd "$(dirname "$0")"
bench=$PWD
tree=$bench/trees/gat2
out=$bench/results/gat2
file=$tree/src/buster/compiler/c_check_node_census.c
clang_bin=$(dirname "$(ls -d ~/.cache/buster/benchpress-clang/*/bin/clang | head -1)")
export PATH=$clang_bin:$PATH
while ! grep -q "job finished\|the control fails" job-faults-gat.log; do sleep 20; done
: > "$out/faults-round2.txt"
run() {
    name=$1
    ./lock.sh bash -c "cd $tree && ./build.sh --config Release" > "$out/fault2-build.log" 2>&1
    if [ $? != 0 ] || ! test -x "$tree/build/compiler"; then echo "not-built $name" >> "$out/faults-round2.txt"; return; fi
    (cd "$tree" && clang -dM -E -march=native -fwrapv -funsigned-char -x c /dev/null > build/predefines.h)
    ./lock.sh bash -c "cd $tree && ./build/compiler test-checker --seed 133 --part 5/8" > "$out/fault2-part5.out" 2>&1
    status=$?
    summary=$(grep 'test-checker:.*checks' "$out/fault2-part5.out" | tail -1)
    if [ $status = 0 ]; then verdict=SURVIVED; else verdict=caught; fi
    if [ "$name" = control ]; then if [ $status = 0 ]; then verdict=control-passes; else verdict=CONTROL-FAILS; fi; fi
    echo "$verdict $name status $status; $summary" >> "$out/faults-round2.txt"
}
cp "$bench/census-round2.c" "$file"
run control
grep -q control-passes "$out/faults-round2.txt" || { echo "the control fails"; cp "$out/census-pristine.c" "$file"; exit 1; }
for n in 28 29 30 31; do
    cp "$bench/census-round2.c" "$file"
    name=$(python3 "$bench/faults-gat.py" "$file" "$n") || { echo "not-applied $n" >> "$out/faults-round2.txt"; continue; }
    run "$name"
done
cp "$out/census-pristine.c" "$file"
rm -rf "$tree/build"
echo job finished
