#!/bin/bash
# The marks' cost split: arm 3 makes the marks and scans by the scalar arm. Exact user instructions, one run each of
# arms 0 (vector), 1 (scalar), 2 (marks), 3 (marks made, scalar scan), -E of musl's units, under the lock on CPU 2.
set -uo pipefail
cd "$(dirname "$0")"
D=$PWD
. ~/buster-fast-bench/2924-asm-pp-claude/env.sh
G=$D/split2
mkdir -p $G/logs
if [ ! -d $G/src ]; then git clone -q --shared $W/src $G/src || exit 1; fi
git -C $G/src checkout -q --detach 968a085f && git -C $G/src reset -q --hard && git -C $G/src clean -qfd src
(cd $G/src && git apply "$D/${PATCH:-body-knob3.patch}") || { echo "patch failed" >> $G/logs/status.txt; exit 1; }
(cd $G/src && $EX timeout -k 5 900 ./build.sh --config Release > $G/logs/build.log 2>&1) || { echo "build failed" >> $G/logs/status.txt; exit 1; }
rm -rf $G/c; mkdir -p $G/c; cp $G/src/build/compiler $G/c/base
for m in 0 1 2 3; do ln $G/c/base $G/c/compiler-areas$m; done
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
musl=$corpus/libc/musl
export LC_ALL=C
files=()
declare -A seen
for f in "$musl"/src/*/*.c "$musl"/src/*/x86_64/*.c; do b=${f##*/}; if [[ -z ${seen[$b]:-} ]]; then seen[$b]=1; files+=("$f"); fi; done
M=(-std=c99 -nostdinc -ffreestanding -D_XOPEN_SOURCE=700 -I "$musl/arch/x86_64" -I "$musl/arch/generic" -I "$corpus/musl-generated/obj/src/internal" -I "$musl/src/include" -I "$musl/src/internal" -I "$corpus/musl-generated/obj/include" -I "$musl/include")
time=/dev/shm/claude-2924-split
rm -rf $time; mkdir -p $time
(cd $time && $EX timeout -k 5 300 taskset -c 2 $G/c/compiler-areas0 time-runs --runs 2 --directory $time --build vector $G/c/compiler-areas0 --build scalar $G/c/compiler-areas1 --build marks $G/c/compiler-areas2 --build marks-scalar $G/c/compiler-areas3 --list -E "${M[@]}" "${files[@]}" > $G/logs/time.log 2>&1)
echo "time: $?" >> $G/logs/status.txt
rm -rf $time
echo done >> $G/logs/status.txt
