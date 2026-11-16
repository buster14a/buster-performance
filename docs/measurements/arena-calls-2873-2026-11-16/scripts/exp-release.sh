#!/bin/bash
# exp-release.sh: an experiment, not a change: piece 2's tree with one line more (an arena released without a pool stays
# mapped where BUSTER_EXPERIMENT_KEEP_RELEASED is set), built as `keep`; then that executable with the variable unset
# against set, on one copy (ab.sh's SAME; an empty value on A's side so that both environments are of one size... the
# variable's presence decides, so A's side names another variable of the same length), musl a unit a process and
# sqlite3.c. A hold of the lock each.
cd "$(dirname "$0")"
cp huge.patch huge-p2b.patch
cp huge-p2x.patch huge.patch
./build-tree.sh keep 1c6cc8ab5e778ab32078cbef17049c4814b30dca tool.patch huge.patch list.patch > build-keep.out 2>&1
cp huge-p2b.patch huge.patch
log=series-keep.log
: > "$log"
step() { local name=$1; shift; local start=$(date +%s); SAME=1 A_ENV=BUSTER_EXPERIMENT_KEEP_RELEASEX=1 B_ENV=BUSTER_EXPERIMENT_KEEP_RELEASED=1 ./lock.sh timeout -k 10 900 "$@" > "results/$name.log" 2>&1; echo "$? $(( $(date +%s) - start ))s $name" >> "$log"; }
step keep-musl ./ab.sh results/keep-musl musl 9 "munmap=$PWD/keep/build/compiler" "keep=$PWD/keep/build/compiler"
step keep-sqlite ./ab.sh results/keep-sqlite sqlite 21 "munmap=$PWD/keep/build/compiler" "keep=$PWD/keep/build/compiler"
step keep-hello ./ab.sh results/keep-hello hello 11 "munmap=$PWD/keep/build/compiler" "keep=$PWD/keep/build/compiler"
echo done >> "$log"
