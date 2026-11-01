#!/usr/bin/env bash
# micro-summary.sh DIR: micro.sh's table, ns per division: each build's median of its 11 rounds per kernel (a round's
# figure is micro.c's best of 7 trials), the checksums, and each kernel's divisions and one-operand multiplications.
set -u
export LC_ALL=C
dir=$1
for b in t0 t1base t1 clang2; do
    printf "%s:" "$b"
    for k in chain_udiv64 chain_sdiv32 chain_srem64 stream_urem32 stream_sdiv64; do
        printf " %s %s" "$k" "$(cat $dir/r*-$b.txt | awk -v k=$k '$1 == k { print $2 }' | sort -n | awk '{ v[NR] = $1 } END { print v[(NR + 1) / 2] }')"
    done
    echo
done
echo "checksums: $(cat $dir/r*-*.txt | awk '$1 == "checksum" { print $2 }' | sort | uniq -c | tr '\n' ' ')"
for b in t0 t1base t1 clang2; do
    echo "$b's divisions and one-operand multiplications: $(tr '\n' ' ' < $dir/divisions-$b.txt)"
done
