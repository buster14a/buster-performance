#!/bin/bash
# run.sh: the census commit (census.bundle on main) built at Release under the lock; then --selection-census on every
# unit of every corpus (census.sh, one hold a corpus); then sqlite3.c's and main.c's census and plain -c alternating,
# 7 runs each (repeat.sh, one hold a file). Every compile on CPU 2, --lanes 1.
set -u
cd ~/buster-fast-bench/2536-step2-claude
export EXCLUSIVE_OWNER=claude-2536-step2 EXCLUSIVE_TITLE="Problem 2536 (step 2.1 census)" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2536
repo=~/buster-fast-bench/2536-step1-claude/repo
git -C "$repo" fetch -q origin main
git -C "$repo" fetch -q "$PWD/census.bundle" HEAD:refs/heads/census-2536-step2
commit=$(git -C "$repo" rev-parse census-2536-step2)
[ -d head ] || git -C "$repo" worktree add --detach "$PWD/head" "$commit"
git -C head checkout -q --detach "$commit"
echo "$commit" > COMMIT
(cd head && timeout 1800 ~/buster-fast-bench/exclusive.sh ./build.sh --config Release) > build.log 2>&1
echo "build status $?" >> build.log
cp head/build/compiler compiler-head
sha256sum compiler-head >> build.log
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
musl=$corpus/libc/musl
lua=~/buster-fast-bench/1189-codex-01a1b81e-plan/input-reference/lua-5.4.8/src
c=~/buster-fast-bench/2536-step1-claude/c-testsuite
mkdir -p out
echo "$corpus/sqlite/sqlite3.c" > out/sqlite.files
ls "$lua"/*.c > out/lua.files
sed -n 's|^\([0-9][0-9]*\)$|'"$c"'/tests/single-exec/\1.c|p' head/tests/c-testsuite/subset.txt > out/ct.files
echo "$PWD/head/src/buster/compiler/main.c" > out/main.files
cp ~/buster-fast-bench/672-allcore-claude/scratch/musl.all.txt out/musl.files
hold()
{
    timeout 900 ~/buster-fast-bench/exclusive.sh "$@" >> out/holds.log 2>&1
    echo "$* status $?" >> out/holds.log
}
hold ./census.sh sqlite "$corpus/sqlite" -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$corpus/sqlite"
hold ./census.sh lua "$lua" -DLUA_USE_LINUX
hold ./census.sh ct "$c"
hold ./census.sh main "$PWD/head" -march=native -Isrc -fwrapv -funsigned-char
hold ./census.sh musl "$musl" -std=c99 -nostdinc -ffreestanding -D_XOPEN_SOURCE=700 -I "$musl/arch/x86_64" -I "$musl/arch/generic" -I "$corpus/musl-generated/obj/src/internal" -I "$musl/src/include" -I "$musl/src/internal" -I "$corpus/musl-generated/obj/include" -I "$musl/include"
hold ./repeat.sh sqlite "$corpus/sqlite" "$corpus/sqlite/sqlite3.c" -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$corpus/sqlite"
hold ./repeat.sh main "$PWD/head" "$PWD/head/src/buster/compiler/main.c" -march=native -Isrc -fwrapv -funsigned-char
echo done >> out/holds.log
