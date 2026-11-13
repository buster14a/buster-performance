# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md of buster14a/buster.
#
# common.sh: what the record's scripts share (sourced). The inputs and options are the whole-build record's
# (docs/measurements/whole-build-672-2026-11-12/scripts/common.sh), so that its m-c line is measured as it was.
here=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
root=$(cd "$here/.." && pwd)
base=26f0bb0e1ab0ae8fc0a7c119064796dfd4b0d5fa
trees="main head nocheck"
t=/tmp/2547-claude
export XDG_CACHE_HOME=$t/cache
export LC_ALL=C
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
sqlite=$corpus/sqlite
musl=$corpus/libc/musl
ct="-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I$sqlite"
mo="-std=c99 -nostdinc -ffreestanding -D_XOPEN_SOURCE=700 -I $musl/arch/x86_64 -I $musl/arch/generic -I $corpus/musl-generated/obj/src/internal -I $musl/src/include -I $musl/src/internal -I $corpus/musl-generated/obj/include -I $musl/include"
