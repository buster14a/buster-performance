# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md of buster14a/buster.
#
# common.sh: what #893's scripts share (sourced): the two compilers, the inputs and their options.
here=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
base=$here/base-26f0bb0e/build/compiler
head=$here/${HEAD_TREE:?HEAD_TREE names the head tree}/build/compiler
t=/tmp/893-claude
export XDG_CACHE_HOME=$t/cache
export LC_ALL=C
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
sqlite=$corpus/sqlite
musl=$corpus/libc/musl
cts=$here/c-testsuite/tests/single-exec
# sqlite3.c as the 9700X job's compile_time step compiles it.
ct="-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I$sqlite"
# musl's units with the corpus README's build options (the whole-build record's).
mo="-std=c99 -nostdinc -ffreestanding -D_XOPEN_SOURCE=700 -I $musl/arch/x86_64 -I $musl/arch/generic -I $corpus/musl-generated/obj/src/internal -I $musl/src/include -I $musl/src/internal -I $corpus/musl-generated/obj/include -I $musl/include"
lock()
{
    EXCLUSIVE_OWNER=claude-893 EXCLUSIVE_TITLE="#893: the intrinsic set-up's memo ($1)" \
    EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/893 ~/buster-fast-bench/exclusive.sh "${@:2}"
}
