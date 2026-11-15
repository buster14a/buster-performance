#!/bin/bash
# run.sh: BASE (the environment's commit) and the commit in symbols.bundle (HEAD) built at Release, each under the lock; then every unit of every
# corpus by both compilers' --selection-census and by HEAD's -c and --provisional-selection -c (census.sh, one hold a
# corpus); then sqlite3.c's and main.c's census, -c and --provisional-selection -c by both, alternating, 7 rounds
# (repeat.sh, one hold a file). Every compile on CPU 2, --lanes 1.
set -u
cd ~/buster-fast-bench/2536-step2c2-claude
export EXCLUSIVE_OWNER=claude-2536-step2c2 EXCLUSIVE_TITLE="Problem 2536 (step 2.2c.2 symbols before the loop)" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2536
repo=~/buster-fast-bench/2536-step1-claude/repo
git -C "$repo" fetch -q origin main
git -C "$repo" fetch -q "$PWD/symbols.bundle" +HEAD:refs/heads/symbols-2536-step2c2
head=$(git -C "$repo" rev-parse symbols-2536-step2c2)
base=${BASE:?the base commit}
for side in base head; do
    commit=$head
    [ "$side" = base ] && commit=$base
    [ -d "$side" ] || git -C "$repo" worktree add --detach "$PWD/$side" "$commit"
    git -C "$side" checkout -q --detach "$commit"
    echo "$commit" > "COMMIT.$side"
    (cd "$side" && ~/buster-fast-bench/exclusive.sh timeout 1800 ./build.sh --config Release) > "build.$side.log" 2>&1
    echo "build status $?" >> "build.$side.log"
    cp "$side/build/compiler" "compiler-$side"
    sha256sum "compiler-$side" >> "build.$side.log"
done
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
    ~/buster-fast-bench/exclusive.sh timeout 900 "$@" >> out/holds.log 2>&1
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
