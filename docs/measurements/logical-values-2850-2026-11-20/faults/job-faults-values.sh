#!/bin/bash
# job-faults-values.sh TREE PATCH REVISION CONFIG NAME LIST INDEX...: the values' fault rounds on the 9700X, in a tree of
# its own (trees/TREE: PATCH on main REVISION): the tree as it is first (the control, which must pass), then each fault
# INDEX of LIST alone: the fault applied, an incremental CONFIG build, and test-checker's part 5 of 8 (the node
# machine's tests); the four files restored after each. A line a fault in results/TREE/NAME.txt: caught (the part
# fails), not-built, or SURVIVED. Each build and each run its own hold of the lock.
cd "$(dirname "$0")"
bench=$PWD
tree_name=$1; patch=$2; revision=$3; config=$4; name=$5; faults=$bench/$6; shift 6
tree=$bench/trees/$tree_name
out=$bench/results/$tree_name
mkdir -p "$out"
git -C src fetch -q origin "$revision" 2>/dev/null || git -C src fetch -q origin main
rm -rf "$tree"
git -C src worktree prune
git -C src worktree add -q --detach "$tree" "$revision" || exit 1
git -C "$tree" apply "$bench/$patch" || { echo "patch failed"; exit 1; }
clang_bin=$(dirname "$(ls -d ~/.cache/buster/benchpress-clang/*/bin/clang | head -1)")
export PATH=$clang_bin:$PATH
files="src/buster/compiler/c_check_node_machine_rows.c src/buster/compiler/c_check_node_machine_facts.c src/buster/compiler/c_check_node_machine_window.c src/buster/compiler/c_check_node_census.c"
mkdir -p "$out/pristine"
for f in $files; do cp "$tree/$f" "$out/pristine/$(basename $f)" || exit 1; done
restore() { for f in $files; do cp "$out/pristine/$(basename $f)" "$tree/$f"; done; }
python3 "$faults" "$tree" > /dev/null || exit 1
list=$out/$name.txt
: > "$list"
run() {
    fault=$1
    ./lock.sh bash -c "cd $tree && ./build.sh --config $config" > "$out/fault-build.log" 2>&1
    if [ $? != 0 ] || ! test -x "$tree/build/compiler"; then echo "not-built $fault" >> "$list"; cp "$out/fault-build.log" "$out/not-built-$fault.log"; return; fi
    (cd "$tree" && clang -dM -E -march=native -fwrapv -funsigned-char -x c /dev/null > build/predefines.h)
    ./lock.sh bash -c "cd $tree && timeout 600 ./build/compiler test-checker --seed 133 --part 5/8" > "$out/fault-part5.out" 2>&1
    status=$?
    summary=$(grep 'test-checker:.*checks' "$out/fault-part5.out" | tail -1)
    if [ $status = 0 ]; then verdict=SURVIVED; else verdict=caught; fi
    if [ "$fault" = control ]; then if [ $status = 0 ]; then verdict=control-passes; else verdict=CONTROL-FAILS; fi; fi
    echo "$verdict $fault status $status; $summary" >> "$list"
}
run control
grep -q control-passes "$list" || { echo "the control fails"; exit 1; }
for n in "$@"; do
    [ -e "$out/stop" ] && break
    restore
    fault=$(python3 "$faults" "$tree" "$n") || { echo "not-applied $n" >> "$list"; continue; }
    run "$n $fault"
done
restore
echo job finished >> "$list"
