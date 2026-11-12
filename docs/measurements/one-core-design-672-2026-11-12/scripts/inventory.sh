#!/bin/bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
#
# inventory.sh: the tree's own counts of what a table of node transitions could take of the frozen sqlite3.c, inside
# one hold of the lock (they count, they don't time): #1048's inventory of the lowering's node templates, as it is and
# with each exception category allowed, and #1050's memoized transitions' hits and misses on -c.
set -u
cd "$(dirname "$0")"
out=results/inventory
mkdir -p "$out" scratch
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
defines=(-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite")
compiler=src/build/compiler
export LC_ALL=C
status=0
head -1 /var/lib/buster-9700x/owner > "$out/holder.txt"
taskset -c 2 "$compiler" measure-lowering-templates --top 40 --keys 60 --abstracts 200 "${defines[@]}" "$sqlite/sqlite3.c" > "$out/templates.txt" 2>&1 || status=1
taskset -c 2 "$compiler" measure-lowering-templates --top 10 --keys 10 --abstracts 10 --allow call --allow '&&-||-?:' "${defines[@]}" "$sqlite/sqlite3.c" > "$out/templates-allow-calls-selections.txt" 2>&1 || echo "allow run: status $?" >> "$out/templates-allow-calls-selections.txt"
taskset -c 2 "$compiler" --time-stages --check-transitions -c "${defines[@]}" "$sqlite/sqlite3.c" -o scratch/sqlite3-transitions.o > /dev/null 2> "$out/transitions.stages.txt" || status=1
taskset -c 2 "$compiler" measure-lowering-templates --help > "$out/help.txt" 2>&1
if ((status == 0)); then date -u +%FT%TZ > "$out/.done"; fi
exit $status
