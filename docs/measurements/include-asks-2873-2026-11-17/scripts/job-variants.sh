#!/bin/bash
# job-variants.sh: where musl's units' cost with the asks comes from. Each a Release build of main 2d8174328 in one
# hold of the lock, then base2 against it on musl's units, a process each (ab.sh: CPU 2, CPU-wide counts), 11 rounds,
# and on hello.c, 41 rounds:
#   scratch    the asks, their path among the cache's (no page of stack), with the start order made again (slots's)
#   off        scratch with the asks never made (the threshold 0): the counting alone
#   none       scratch with no miss counted: the code there, and nothing run of it
#   orderonly  main with the start order made again alone
# and base2 against a second copy of itself (same), twice.
cd "$(dirname "$0")"
main=2d817432864947a0853abd1e79879b0086fbd9b7
: > job-variants.done
log=variants.log
: > "$log"
./build-tree.sh scratch $main files-scratch.patch order-slots.patch > build-scratch.out 2>&1
./build-tree.sh off $main files-off.patch order-slots.patch > build-off.out 2>&1
./build-tree.sh none $main files-none.patch order-slots.patch > build-none.out 2>&1
./build-tree.sh orderonly $main order-slots.patch > build-orderonly.out 2>&1
for t in scratch off none orderonly; do tail -2 build-$t.out >> "$log"; done
for spec in musl:11:scratch musl:11:off musl:11:none musl:11:orderonly musl:11:same musl:11:scratch:again musl:11:none:again musl:11:orderonly:again musl:11:same:again hello:41:scratch hello:41:none; do
    IFS=: read -r kind rounds other again <<< "$spec"
    label=$kind-$other${again:+-$again}
    tree=$other
    [ "$other" = same ] && tree=base2
    start=$(date +%s)
    ./lock.sh timeout -k 10 900 ./ab.sh "results/abv-$label" "$kind" "$rounds" "base2=$PWD/base2/build/compiler" "$other=$PWD/$tree/build/compiler" > "results/abv-$label.log" 2>&1
    echo "$? $(( $(date +%s) - start ))s $label" >> "$log"
    tools/abstat "results/abv-$label" base2 "$other" > "results/abstatv-$label.txt" 2>&1
done
echo done >> "$log"
echo finished > job-variants.done
