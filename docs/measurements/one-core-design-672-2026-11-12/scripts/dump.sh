#!/bin/bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
#
# dump.sh: the per-node data the sweeps' prototype reads (tools/sweeps.c), inside one hold of the lock: the tree with
# inventory-dump.patch applied (a measurement's patch to measure-lowering-templates, not a compile's code) is rebuilt,
# and its inventory of the frozen sqlite3.c and of musl.sh's 1,336 units writes each body's pops, keys and entries.
set -u
cd "$(dirname "$0")"
out=$PWD/results/sweeps
mkdir -p "$out" scratch
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
sqlite=$corpus/sqlite
musl="$corpus/libc/musl"
export LC_ALL=C
status=0
head -1 /var/lib/buster-9700x/owner > "$out/dump.holder.txt"
(
    cd src || exit 1
    git apply --check ../inventory-dump.patch 2> /dev/null && git apply ../inventory-dump.patch
    git diff --stat
    ./build.sh
) > "$out/dump-build.log" 2>&1 || status=1
sha256sum src/build/compiler inventory-dump.patch > "$out/dump-identity.txt"
compiler=src/build/compiler
sq=(-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c")
mo=(-std=c99 -nostdinc -ffreestanding -D_XOPEN_SOURCE=700 -I "$musl/arch/x86_64" -I "$musl/arch/generic"
    -I "$corpus/musl-generated/obj/src/internal" -I "$musl/src/include" -I "$musl/src/internal"
    -I "$corpus/musl-generated/obj/include" -I "$musl/include")
files=()
declare -A seen
for f in "$musl"/src/*/*.c "$musl"/src/*/x86_64/*.c; do
    b=${f##*/}
    if [[ -z ${seen[$b]:-} ]]; then seen[$b]=1; files+=("$f"); fi
done
BUSTER_INVENTORY_DUMP=scratch/sqlite3.dump taskset -c 2 "$compiler" measure-lowering-templates --top 1 --keys 1 --abstracts 1 "${sq[@]}" > "$out/dump-sqlite3.txt" 2>&1 || status=1
BUSTER_INVENTORY_DUMP=scratch/musl.dump taskset -c 2 "$compiler" measure-lowering-templates --top 1 --keys 1 --abstracts 1 "${mo[@]}" "${files[@]}" > "$out/dump-musl.txt" 2>&1 || status=1
ls -l scratch/sqlite3.dump scratch/musl.dump > "$out/dump-sizes.txt" 2>&1
sha256sum scratch/sqlite3.dump scratch/musl.dump >> "$out/dump-sizes.txt"
if ((status == 0)); then date -u +%FT%TZ > "$out/dump.done"; fi
exit $status
