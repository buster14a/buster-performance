#!/usr/bin/env bash
# #502's section (section.patch) on main and on #473: the code before it shifted by 0 to 1,024 bytes, its contents by
# 16, 64 and 4,096 bytes, with clang's function alignment and with -falign-functions=64; main as it is beside them.
# Then -fsyntax-only of sqlite3.c by perf stat, by turns, three rounds. Every build, link and run takes the lock alone.
set -u
here="$HOME/buster-fast-bench/checker-placement-502"
cd "$here"
. "$HOME/buster-fast-bench/pp-117-templates/args.sh"
r=results
for pair in sec-35f26f6:main-35f26f6 sec-pr473:pr473-on-35f26f6; do
    tree=${pair%%:*}; base=${pair#*:}
    rm -rf $tree; mkdir $tree; (cd $base && tar cf - --exclude=./objects --exclude=./build .) | (cd $tree && tar xf -)
    (cd $tree && patch -p1 < "$here/section.patch") > $r/patch3-$tree.txt 2>&1 || { echo "patch $tree failed"; exit 1; }
    ./locked.sh ./objects.sh $tree > $r/objects3-$tree.txt 2>&1 || { echo "objects $tree failed"; exit 1; }
done
binaries=()
add()
{
    ./locked.sh ./link.sh "$1" "$2" "$3" "$here/bin/$4" "${5-0}" >> $r/link3.txt 2>&1 || { echo "link $4 failed"; exit 1; }
    binaries+=("$4")
}
add main-35f26f6 checker 0 m-s0
add main-35f26f6 checker 16 m-s16
for s in 0 16 32 48 64 1024; do add sec-35f26f6 checker $s sec-s$s; done
for k in 16 64 4096; do add sec-35f26f6 checker 0 sec-k$k $k; done
for s in 0 16; do add sec-35f26f6 checker-align64 $s seca-s$s; done
for k in 64 4096; do add sec-35f26f6 checker-align64 0 seca-k$k $k; done
add sec-pr473 checker 0 secpr-s0
add sec-pr473 checker-align64 0 secapr-s0
for tree in main-35f26f6 sec-35f26f6; do
    objcopy -O binary -j .text -j .text.buster_checker $tree/objects/checker-direct.o /tmp/c502-direct.bin
    objcopy -O binary -j .text -j .text.buster_checker $tree/objects/link-checker-0-0/checker.o /tmp/c502-asm.bin
    cmp /tmp/c502-direct.bin /tmp/c502-asm.bin && echo "$tree: assembled code is the direct compile's" >> $r/link3.txt
done
for b in "${binaries[@]}"; do
    printf '%s ' "$b"; nm bin/$b | awk '$3 == "check_input_expressions" || $3 == "check_literal_number_plain" || $3 == "pp_run_contexts" {printf "%s=%s ", $3, $1}'; echo
done > $r/addresses3.txt
sha256sum bin/* > $r/sha3.txt
n=${#binaries[@]}
for round in 1 2 3; do
    for ((k = 0; k < n; k += 1)); do
        b=${binaries[$(((k + (round - 1) * 5) % n))]}
        ./locked.sh taskset -c 2 perf stat -r 21 -x, -e cycles:u,instructions:u "$here/bin/$b" -fsyntax-only "${sqlite[@]}" \
            > /dev/null 2> $r/stat3-$b-$round.txt
    done
done
echo done > $r/queue3.done
