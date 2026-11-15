# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md of buster14a/buster.
#
# common.sh: what the record's scripts share (sourced). Inputs and options are the whole-build record's
# (docs/measurements/whole-build-672-2026-11-12/scripts/common.sh): musl's 1,336 units, sqlite3.c, SQLite's shell.
here=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
root=$(cd "$here/.." && pwd)
base=2ebfe68a856613e300231520af5e7ec5627708b6
trees="base head"
t=/tmp/2668-claude
export XDG_CACHE_HOME=$t/cache
export LC_ALL=C
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
sqlite=$corpus/sqlite
musl=$corpus/libc/musl
G=/usr/lib64/gcc/x86_64-pc-linux-gnu/16
ct="-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I$sqlite"
sh="-DSQLITE_DQS=0 -DSQLITE_ENABLE_FTS4 -DSQLITE_ENABLE_RTREE -DSQLITE_ENABLE_EXPLAIN_COMMENTS -DSQLITE_ENABLE_UNKNOWN_SQL_FUNCTION -DSQLITE_ENABLE_STMTVTAB -DSQLITE_ENABLE_DBPAGE_VTAB -DSQLITE_ENABLE_DBSTAT_VTAB -DSQLITE_ENABLE_BYTECODE_VTAB -DSQLITE_ENABLE_OFFSET_SQL_FUNC -DSQLITE_ENABLE_PERCENTILE -DSQLITE_STRICT_SUBTYPE=1 -DSQLITE_ENABLE_MATH_FUNCTIONS -I$sqlite"
mo="-std=c99 -nostdinc -ffreestanding -D_XOPEN_SOURCE=700 -I $musl/arch/x86_64 -I $musl/arch/generic -I $corpus/musl-generated/obj/src/internal -I $musl/src/include -I $musl/src/internal -I $corpus/musl-generated/obj/include -I $musl/include"
dyn="--hash-style=gnu --build-id --eh-frame-hdr -m elf_x86_64 -pie -dynamic-linker /lib64/ld-linux-x86-64.so.2 /usr/lib64/Scrt1.o /usr/lib64/crti.o $G/crtbeginS.o -L$G -L/usr/lib64 -L/lib -L/usr/lib"
dynend="-lm -lgcc --as-needed -lgcc_s --no-as-needed -lc -lgcc --as-needed -lgcc_s --no-as-needed $G/crtendS.o /usr/lib64/crtn.o"
