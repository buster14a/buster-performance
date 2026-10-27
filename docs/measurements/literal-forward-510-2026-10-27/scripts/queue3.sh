#!/usr/bin/env bash
# #510 on the 9700X, after queue1.sh linked main's executables: the head's links, the tests, then rounds of
# -fsyntax-only of sqlite3.c by perf stat over every executable (its order rotated per round), rounds of
# benchmark-checker-source, and the profiles. Every link and run takes the lock alone.
set -u
here="$HOME/buster-fast-bench/literal-510"
cd "$here"
r=results
for s in 0 16 32 48 64 1024; do
    ./locked.sh ./link.sh head checker $s "$here/bin/head-s$s" >> $r/link.txt 2>&1 || { echo "link head $s failed"; exit 1; }
    cp bin/head-s$s bin/head-s$s-copy
done
binaries=()
for tree in main head; do
    for s in 0 16 32 48 64 1024; do binaries+=($tree-s$s $tree-s$s-copy); done
done
for tree in main head; do
    objcopy -O binary -j .text $tree/objects/checker-direct.o /tmp/l510-direct.bin
    objcopy -O binary -j .text $tree/objects/link-checker-0-0/checker.o /tmp/l510-asm.bin
    cmp /tmp/l510-direct.bin /tmp/l510-asm.bin && echo "$tree: assembled code is the direct compile's" >> $r/link.txt
done
for b in "${binaries[@]}"; do
    printf '%s ' "$b"; nm bin/$b | awk '$3 == "check_input_expressions" || $3 == "check_literal_number_plain" || $3 == "check_input_literal" || $3 == "check_literal_number" {printf "%s=%s ", $3, $1}'; echo
done > $r/addresses.txt
sha256sum bin/* > $r/sha.txt
echo built > $r/queue3.built
./tests.sh > $r/tests.txt 2>&1; echo "tests status $?" >> $r/tests.txt
for round in 1 2 3 4; do
    ./stat-round.sh $round "${binaries[@]}" || echo "stat round $round failed"
done
echo stat > $r/queue3.stat
for round in 1 2; do
    ./source-round.sh $round || echo "source round $round failed"
done
echo source > $r/queue3.source
for tree in main head; do
    ./locked.sh ./profile.sh $tree > $r/profile-$tree.txt 2>&1
done
echo done > $r/queue3.done
