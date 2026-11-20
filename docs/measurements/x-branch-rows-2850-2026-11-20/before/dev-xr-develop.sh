#!/bin/bash
# dev-xr.sh PATCH [REVISION]: the rows piece's working tree on the 9700X (trees/xrd: PATCH on main REVISION, its build
# directory kept between calls): the patch applied to a clean tree, an incremental Develop build and test-checker's
# part 5 of 8, each its own hold of the lock. Prints the build's end and the part's summary and failures.
cd "$(dirname "$0")"
bench=$PWD
patch=$bench/$1; revision=${2:-903bf7ef4}
tree=$bench/trees/xrd
out=$bench/results/xrd
mkdir -p "$out"
if ! test -d "$tree"; then
    git -C src fetch -q origin "$revision" 2>/dev/null || git -C src fetch -q origin main
    git -C src worktree prune
    git -C src worktree add -q --detach "$tree" "$revision" || exit 1
fi
git -C "$tree" checkout -q -- . && git -C "$tree" clean -q -fd -e build || exit 1
git -C "$tree" apply "$patch" || { echo "patch failed"; exit 1; }
clang_bin=$(dirname "$(ls -d ~/.cache/buster/benchpress-clang/*/bin/clang | head -1)")
export PATH=$clang_bin:$PATH
./lock.sh bash -c "cd $tree && ./build.sh" > "$out/build.log" 2>&1
status=$?
if [ $status != 0 ] || ! test -x "$tree/build/compiler"; then echo "BUILD FAILED"; grep -m8 "error" "$out/build.log"; exit 1; fi
(cd "$tree" && clang -dM -E -march=native -fwrapv -funsigned-char -x c /dev/null > build/predefines.h)
./lock.sh bash -c "cd $tree && timeout 300 ./build/compiler test-checker --seed 133 --part 5/8" > "$out/part5.out" 2>&1
echo "part 5 status $?"
grep "test-checker:.*checks\|node-rows\|FAIL\|fail" "$out/part5.out" | grep -v "0 failures" | head -20
grep 'test-checker:.*checks' "$out/part5.out" | tail -1
