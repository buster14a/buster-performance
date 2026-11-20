#!/bin/bash
# job-faults-rows.sh PATCH REVISION FROM TO: the rows piece's fault round on the 9700X, in a tree of its own (trees/xrf:
# PATCH on main REVISION): the tree as it is first (the control, which must pass), then each of faults-rows.py's
# faults FROM to TO alone: the fault applied, an incremental Release build, and test-checker's part 5 of 8 (the node
# machine's tests); the two files restored after each. A line a fault in results/xrf/faults-FROM-TO.txt: caught (the
# part fails), not-built, or SURVIVED. Each build and each run its own hold of the lock.
cd "$(dirname "$0")"
bench=$PWD
patch=$1; revision=$2; from=$3; to=$4
tree=$bench/trees/xrf
out=$bench/results/xrf
mkdir -p "$out"
git -C src fetch -q origin "$revision" 2>/dev/null || git -C src fetch -q origin main
rm -rf "$tree"
git -C src worktree prune
git -C src worktree add -q --detach "$tree" "$revision" || exit 1
git -C "$tree" apply "$bench/$patch" || { echo "patch failed"; exit 1; }
clang_bin=$(dirname "$(ls -d ~/.cache/buster/benchpress-clang/*/bin/clang | head -1)")
export PATH=$clang_bin:$PATH
rows=src/buster/compiler/c_check_node_machine_rows.c
census=src/buster/compiler/c_check_node_census.c
cp "$tree/$rows" "$out/rows-pristine.c" && cp "$tree/$census" "$out/census-pristine.c" || exit 1
count=$(python3 "$bench/faults-rows.py" "$tree") || exit 1
list=$out/faults-$from-$to.txt
: > "$list"
run() {
    name=$1
    ./lock.sh bash -c "cd $tree && ./build.sh --config Release" > "$out/fault-build.log" 2>&1
    if [ $? != 0 ] || ! test -x "$tree/build/compiler"; then echo "not-built $name" >> "$list"; return; fi
    (cd "$tree" && clang -dM -E -march=native -fwrapv -funsigned-char -x c /dev/null > build/predefines.h)
    ./lock.sh bash -c "cd $tree && timeout 300 ./build/compiler test-checker --seed 133 --part 5/8" > "$out/fault-part5.out" 2>&1
    status=$?
    summary=$(grep 'test-checker:.*checks' "$out/fault-part5.out" | tail -1)
    if [ $status = 0 ]; then verdict=SURVIVED; else verdict=caught; fi
    if [ "$name" = control ]; then if [ $status = 0 ]; then verdict=control-passes; else verdict=CONTROL-FAILS; fi; fi
    echo "$verdict $name status $status; $summary" >> "$list"
}
run control
grep -q control-passes "$list" || { echo "the control fails"; exit 1; }
last=$((count - 1)); [ "$to" -lt "$last" ] && last=$to
for n in $(seq "$from" "$last"); do
    cp "$out/rows-pristine.c" "$tree/$rows"; cp "$out/census-pristine.c" "$tree/$census"
    name=$(python3 "$bench/faults-rows.py" "$tree" "$n") || { echo "not-applied $n" >> "$list"; continue; }
    run "$name"
done
cp "$out/rows-pristine.c" "$tree/$rows"; cp "$out/census-pristine.c" "$tree/$census"
rm -rf "$tree/build"
echo job finished
