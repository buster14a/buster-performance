#!/usr/bin/env bash
# The placement sweep: main's checker unit with 0 to 2,048 bytes before its code, as clang lays it out and with
# -falign-functions=64, and #473 on main both ways; then -fsyntax-only of sqlite3.c by perf stat, by turns, two rounds.
# Every build, link and run takes the lock on its own.
set -u
here="$HOME/buster-fast-bench/checker-placement-502"
cd "$here"
. "$HOME/buster-fast-bench/pp-117-templates/args.sh"
r=results
for tree in main-35f26f6 pr473-on-35f26f6; do
    ./locked.sh ./objects.sh $tree > $r/objects1-$tree.txt 2>&1 || { echo "objects $tree failed"; exit 1; }
done
mkdir -p bin
binaries=()
add()
{
    ./locked.sh ./link.sh "$1" "$2" "$3" "$here/bin/$4" >> $r/link1.txt 2>&1 || { echo "link $4 failed"; exit 1; }
    binaries+=("$4")
}
for s in 0 16 32 48 64 128 256 512 1024 2048; do add main-35f26f6 checker $s main-s$s; done
for s in 0 16 64 128 256 512 1024 2048; do add main-35f26f6 checker-align64 $s align-s$s; done
add pr473-on-35f26f6 checker 0 pr473-s0
add pr473-on-35f26f6 checker-align64 0 pr473-align-s0
# The assembly's object must be the direct compile's.
for tree in main-35f26f6 pr473-on-35f26f6; do
    objcopy -O binary -j .text $tree/objects/checker-direct.o /tmp/c502-direct.bin
    objcopy -O binary -j .text $tree/objects/link-checker-0/checker.o /tmp/c502-asm.bin
    cmp /tmp/c502-direct.bin /tmp/c502-asm.bin && echo "$tree: assembled .text is the direct compile's" >> $r/link1.txt
done
sha256sum bin/* > $r/sha1.txt
n=${#binaries[@]}
for round in 1 2; do
    for ((k = 0; k < n; k += 1)); do
        b=${binaries[$(((k + (round - 1) * 7) % n))]}
        ./locked.sh taskset -c 2 perf stat -r 21 -x, -e cycles:u,instructions:u,cycles:k "$here/bin/$b" -fsyntax-only "${sqlite[@]}" \
            > /dev/null 2> $r/stat1-$b-$round.txt
    done
done
echo done > $r/queue1.done
