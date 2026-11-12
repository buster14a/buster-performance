#!/bin/bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
#
# tccprofile.sh: tcc's -c of the frozen sqlite3.c (the compile_time step's command) under a leader-sampled group, 8
# compiles on CPU 2 in one hold of the lock, with libtcc.so's dynamic symbols by address. The package's libtcc.so is
# stripped but exports its ST_FUNC functions, and its text keeps its objects' link order, so a sample's source file
# (tccpp.c, tccgen.c, x86_64-gen.c, tccelf.c) follows from its address between exported symbols.
set -u
cd "$(dirname "$0")"
out=results/tcc
mkdir -p "$out" scratch
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
options=(-c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c")
export LC_ALL=C
status=0
head -1 /var/lib/buster-9700x/owner > "$out/holder.txt"
tcc -v > "$out/version.txt" 2>&1
sha256sum /usr/bin/tcc /usr/lib/libtcc.so >> "$out/version.txt"
nm -D --defined-only -n /usr/lib/libtcc.so > "$out/libtcc-symbols.txt"
readelf -S -W /usr/lib/libtcc.so > "$out/libtcc-sections.txt"
printf -v loop '%q ' taskset -c 2 tcc "${options[@]}" -o scratch/tcc-sqlite3.o
taskset -c 5 perf record -q -o scratch/tcc.data -e '{cycles:u,instructions:u,ex_ret_brn_misp:u,ls_dmnd_fills_from_sys.all:u,ls_dmnd_fills_from_sys.dram_io_near:u}:S' -c 100003 -- \
    bash -c "for i in 1 2 3 4 5 6 7 8; do $loop > /dev/null 2>&1 || exit 1; done" > "$out/record.log" 2>&1 || status=1
perf script -i scratch/tcc.data -F period,event,ip,sym,symoff,dso 2>> "$out/record.log" | gzip -c > "$out/samples.gz" || status=1
taskset -c 2 perf stat -x, -r 5 -o "$out/stat-E.csv" -e '{cycles:u,instructions:u,cycles:k,instructions:k}' -e task-clock -- tcc -E "${options[@]:1}" -o scratch/tcc-sqlite3.i > /dev/null 2>&1 || status=1
taskset -c 2 perf stat -x, -r 5 -o "$out/stat-c.csv" -e '{cycles:u,instructions:u,cycles:k,instructions:k}' -e task-clock -- tcc "${options[@]}" -o scratch/tcc-sqlite3.o > /dev/null 2>&1 || status=1
wc -c scratch/tcc-sqlite3.i scratch/tcc-sqlite3.o > "$out/sizes.txt"
rm -f scratch/tcc.data
if ((status == 0)); then date -u +%FT%TZ > "$out/.done"; fi
exit $status
