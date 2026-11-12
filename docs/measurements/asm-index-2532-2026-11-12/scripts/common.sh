# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
#
# common.sh: sourced by the measurement scripts: the corpus, the options, the units and the two trees. (After
# file-scope-design-672-2026-11-12's common.sh.)
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
sqlite=$corpus/sqlite
musl="$corpus/libc/musl"
sqlite_options=(-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite")
musl_options=(-std=c99 -nostdinc -ffreestanding -D_XOPEN_SOURCE=700 -I "$musl/arch/x86_64" -I "$musl/arch/generic"
    -I "$corpus/musl-generated/obj/src/internal" -I "$musl/src/include" -I "$musl/src/internal"
    -I "$corpus/musl-generated/obj/include" -I "$musl/include")
export LC_ALL=C
# The two builds: main at the PR's base and the PR's head.
ways=(main head)
# The scripts' directory, which each script enters before sourcing this file.
root=$PWD
compiler_of()
{
    printf '%s/%s/build/compiler' "$root" "$1"
}
# musl's units: the first source of each base name (two units of one name would write one object), as the earlier
# records take them.
musl_units()
{
    local f b
    declare -A seen
    for f in "$musl"/src/*/*.c "$musl"/src/*/x86_64/*.c; do
        b=${f##*/}
        if [[ -z ${seen[$b]:-} ]]; then seen[$b]=1; printf '%s\n' "$f"; fi
    done
}
# /proc/vmstat's page and huge-page counts, one line: a run's page state is told by them (the earlier record's
# section 13: a run in three of musl's command gets no huge page from its randomized layout).
thp()
{
    grep -E '^(thp_fault_alloc|thp_fault_fallback|pgfault) ' /proc/vmstat | tr '\n' ' '
    echo
}
