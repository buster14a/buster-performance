# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md of buster14a/buster.
#
# common.sh: what the record's scripts share (sourced): the measured compiler, the inputs and their options. Options
# are plain words, since procbench's lists split arguments at single spaces.
here=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
c=$here/src/build/compiler
# The outputs' directory, on tmpfs, as the linker design's numbers are; and the runtime snapshot's cache, this
# record's own, so that no other tree's compiler rewrites the snapshot between runs (a snapshot serves the executable
# that wrote it).
t=/tmp/672-wb-claude
export XDG_CACHE_HOME=$t/cache
export LC_ALL=C
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
sqlite=$corpus/sqlite
musl=$corpus/libc/musl
G=/usr/lib64/gcc/x86_64-pc-linux-gnu/16
# sqlite3.c as the 9700X job's compile_time step compiles it (the one-core record's command).
ct="-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I$sqlite"
# SQLite's shell as test-sqlite builds it (sqlite_test.c's sqlite_test_shell_options).
sh="-DSQLITE_DQS=0 -DSQLITE_ENABLE_FTS4 -DSQLITE_ENABLE_RTREE -DSQLITE_ENABLE_EXPLAIN_COMMENTS -DSQLITE_ENABLE_UNKNOWN_SQL_FUNCTION -DSQLITE_ENABLE_STMTVTAB -DSQLITE_ENABLE_DBPAGE_VTAB -DSQLITE_ENABLE_DBSTAT_VTAB -DSQLITE_ENABLE_BYTECODE_VTAB -DSQLITE_ENABLE_OFFSET_SQL_FUNC -DSQLITE_ENABLE_PERCENTILE -DSQLITE_STRICT_SUBTYPE=1 -DSQLITE_ENABLE_MATH_FUNCTIONS -I$sqlite"
# musl's units as the corpus's README has its build's options (the one-core record's command).
mo="-std=c99 -nostdinc -ffreestanding -D_XOPEN_SOURCE=700 -I $musl/arch/x86_64 -I $musl/arch/generic -I $corpus/musl-generated/obj/src/internal -I $musl/src/include -I $musl/src/internal -I $corpus/musl-generated/obj/include -I $musl/include"
# A program against musl's public headers.
mh="-std=c99 -nostdinc -I $musl/arch/x86_64 -I $musl/arch/generic -I $corpus/musl-generated/obj/include -I $musl/include"
# The system linkers' lines for the shell's objects, as clang's driver gives them to GNU ld (results/prepare/clang-*.txt),
# their paths shortened: before the objects, and after them.
dyn="--hash-style=gnu --build-id --eh-frame-hdr -m elf_x86_64 -pie -dynamic-linker /lib64/ld-linux-x86-64.so.2 /usr/lib64/Scrt1.o /usr/lib64/crti.o $G/crtbeginS.o -L$G -L/usr/lib64 -L/lib -L/usr/lib"
dynend="-lm -lgcc --as-needed -lgcc_s --no-as-needed -lc -lgcc --as-needed -lgcc_s --no-as-needed $G/crtendS.o /usr/lib64/crtn.o"
static="--hash-style=gnu --build-id --eh-frame-hdr -m elf_x86_64 -static /usr/lib64/crt1.o /usr/lib64/crti.o $G/crtbeginT.o -L$G -L/usr/lib64 -L/lib -L/usr/lib"
staticend="-lm --start-group -lgcc -lgcc_eh -lc --end-group $G/crtend.o /usr/lib64/crtn.o"
