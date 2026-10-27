#!/usr/bin/env bash
# #510 on the 9700X: main (e04462c1) and the branch's head as objects (#502's objects.sh), the checker's unit linked
# with 0 to 1,024 bytes of .text before it (#502's link.sh), and a fresh copy of each executable. Then the tests on the
# head, -fsyntax-only of sqlite3.c by perf stat by turns, benchmark-checker-source by turns, and the profiles. Every
# compile, link and run takes the lock alone.
set -u
here="$HOME/buster-fast-bench/literal-510"
cd "$here"
. "$HOME/buster-fast-bench/pp-117-templates/args.sh"
r=results
mkdir -p $r bin
for tree in main head; do
    ./locked.sh ./objects.sh $tree > $r/objects-$tree.txt 2>&1 || { echo "objects $tree failed"; exit 1; }
done
binaries=()
for tree in main head; do
    for s in 0 16 32 48 64 1024; do
        ./locked.sh ./link.sh $tree checker $s "$here/bin/$tree-s$s" >> $r/link.txt 2>&1 || { echo "link $tree $s failed"; exit 1; }
        cp bin/$tree-s$s bin/$tree-s$s-copy
        binaries+=($tree-s$s $tree-s$s-copy)
    done
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
echo built > $r/queue1.built
./tests.sh > $r/tests.txt 2>&1; echo "tests status $?" >> $r/tests.txt
n=${#binaries[@]}
for round in 1 2 3; do
    for ((k = 0; k < n; k += 1)); do
        b=${binaries[$(((k + (round - 1) * 7) % n))]}
        ./locked.sh taskset -c 2 perf stat -r 11 -x, -e cycles:u,instructions:u,ls_bad_status2.stli_other:u,ex_ret_brn_misp:u "$here/bin/$b" -fsyntax-only "${sqlite[@]}" \
            > /dev/null 2> $r/stat-$b-$round.txt
    done
done
echo stat > $r/queue1.stat
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
source=(--predefines "$corpus/provenance/gnu17-pinned-predefines.txt" --clang-features --no-default-config --target=x86_64-linux-gnu -march=znver5 -std=gnu17 -nostdinc -isystem "$corpus/headers/usr/lib/clang/23/include" -isystem "$corpus/headers/usr/local/include" -isystem "$corpus/headers/usr/include" "$corpus/sqlite/sqlite3.c")
for round in 1 2; do
    trees=(main head); [ $round = 2 ] && trees=(head main)
    for s in 0 16 32 48 64 1024; do
        for tree in "${trees[@]}"; do
            ./locked.sh taskset -c 2 "$here/bin/$tree-s$s" benchmark-checker-source "${source[@]}" > $r/source-$tree-s$s-$round.txt 2>&1
        done
    done
done
echo source > $r/queue1.source
for tree in main head; do
    ./locked.sh ./profile.sh $tree > $r/profile-$tree.txt 2>&1
done
echo done > $r/queue1.done
