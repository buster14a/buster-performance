#!/bin/bash
# musl-ab.sh OUT ROUNDS A=COMPILER B=COMPILER: musl's 1,336 units (musl-common.sh, the one-core record's selection and
# options) as one -c command on one lane by A and B, ROUNDS rounds in ABBA order, on CPU 2 under waitall, counted on CPU 2
# as a whole (perf stat -C 2: kernel and user cycles, page faults). OUT/NAME-ROUND.csv; the objects compared, unit by
# unit (OUT/objects.txt). One hold of the lock.
set -u
cd "$(dirname "$0")"
here=$PWD
source ./musl-common.sh
out=$1
rounds=$2
a=$3
b=$4
mkdir -p "$out"
: > "$out/objects.txt"
run()
{
    local name=${1%%=*} compiler=${1#*=} round=$2
    rm -rf "/dev/shm/1167-musl-$name" && mkdir -p "/dev/shm/1167-musl-$name" && cd "/dev/shm/1167-musl-$name" || exit 1
    perf stat -C 2 -x, -e cycles:k,cycles:u,page-faults -o "$here/$out/$name-$round.csv" -- taskset -c 2 "$here/tools/waitall" "$compiler" "${options[@]}" \
        --lanes 1 -c "${files[@]}" 2> "$here/$out/$name-$round.err"
    cd "$here"
}
for ((r = 0; r < rounds; r += 1)); do
    if ((r % 2 == 0)); then run "$a" $r; run "$b" $r; else run "$b" $r; run "$a" $r; fi
    echo "$r $(diff -rq "/dev/shm/1167-musl-${a%%=*}" "/dev/shm/1167-musl-${b%%=*}" > /dev/null && echo same || echo DIFFERENT) $(ls "/dev/shm/1167-musl-${a%%=*}" | wc -l)" >> "$out/objects.txt"
done
rm -rf /dev/shm/1167-musl-*
