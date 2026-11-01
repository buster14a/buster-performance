#!/usr/bin/env bash
# identity.sh BASE HEAD: --tier1 -c of the frozen sqlite3.c by both paths, by each tree, each compile one hold of the
# shared lock: the objects must be the same bytes.
. ~/buster-fast-bench/claude-141-remaining/common.sh
out=$PWD/identity-$2
mkdir -p $out
for p in vector scalar; do
    s=$([ $p = scalar ] && echo --scalar)
    for t in $1 $2; do
        "$lock" bash -c "$PWD/$t/build/compiler --tier1 $s -fno-asynchronous-unwind-tables -c $FLAGS -I$Q -o $out/$t-$p.o $Q/sqlite3.c"
    done
    cmp $out/$1-$p.o $out/$2-$p.o && echo "$p: identical, $(stat -c %s $out/$2-$p.o) bytes, sha256 $(sha256sum < $out/$2-$p.o | cut -c1-16)"
done
