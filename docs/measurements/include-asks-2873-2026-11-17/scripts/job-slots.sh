#!/bin/bash
# job-slots.sh: the include search's asks with their counts in the directory's own slots, on today's main, with the
# start order made again from their build; as job-final.sh, whose base2 and final builds it reads.
#   base2   main 2d8174328
#   order1s  main with the asks (files-slots.patch), built as the list's header says (znver5, no debug information): the
#           start order made again from its build (order.sh), and written into its cmake/BusterStartOrder.txt
#           (order-slots.patch is that file's change)
#   slots   main with the asks and the list made again
#   order2s  the list made once more from slots's build: the same functions, or the difference
# Then the compilers' file system calls (counts.sh), base2 against slots, a hold of the lock an A/B (ab.sh: CPU 2,
# CPU-wide counts), base2 against a second copy of itself (same) as what two copies of one executable read, and abstat's
# table of each. Every build, trace and A/B in one hold of the lock.
cd "$(dirname "$0")"
main=2d817432864947a0853abd1e79879b0086fbd9b7
: > job-slots.done
log=slots.log
: > "$log"
HOST_ARCH=znver5 DEBUG_INFO=0 ./build-tree.sh order1s $main files-slots.patch > build-order1s.out 2>&1
for step in "small" "sqlite" "musl 0 334" "musl 334 668" "musl 668 1002" "musl 1002 1336" "list"; do
    ./lock.sh timeout -k 10 600 ./order.sh order1s results/order1s $step >> "$log" 2>&1
    echo "$? order1s $step" >> "$log"
done
{
    sed -n '1,/^# Refresh it as that guide says/p' order1s/cmake/BusterStartOrder.txt | sed "s|from main at c7caeb56b with #2873's change|from main at 2d8174328 with #2873's asks of the include search|"
    cat results/order1s/body.txt
} > results/order1s/BusterStartOrder.txt
cp results/order1s/BusterStartOrder.txt order1s/cmake/BusterStartOrder.txt
git -C order1s diff -- cmake/BusterStartOrder.txt > order-slots.patch
echo "order-slots.patch: $(grep -c '^[+-][^+-]' order-slots.patch) changed lines" >> "$log"
./build-tree.sh slots $main files-slots.patch order-slots.patch > build-slots.out 2>&1
for step in "small" "sqlite" "musl 0 334" "musl 334 668" "musl 668 1002" "musl 1002 1336" "list"; do
    ./lock.sh timeout -k 10 600 ./order.sh slots results/order2s $step >> "$log" 2>&1
    echo "$? order2s $step" >> "$log"
done
{
    echo "the list made from order1s's build against the one made again from slots's:"
    echo "  functions: $(grep -vc '^#' results/order1s/body.txt) and $(grep -vc '^#' results/order2s/body.txt)"
    echo "  in the first alone: $(comm -23 <(grep -v '^#' results/order1s/body.txt | sort) <(grep -v '^#' results/order2s/body.txt | sort) | wc -l); in the second alone: $(comm -13 <(grep -v '^#' results/order1s/body.txt | sort) <(grep -v '^#' results/order2s/body.txt | sort) | wc -l)"
    echo "  lines whose place differs: $(diff <(grep -v '^#' results/order1s/body.txt) <(grep -v '^#' results/order2s/body.txt) | grep -c '^[<>]')"
    for t in base2 slots; do
        echo "  $t: $(readelf -sW $t/build/compiler | awk '$8 == "file_cache_count_miss" {printf "file_cache_count_miss at 0x%s (%s bytes); ", $2, $3}') .text.buster_start $(readelf -SW $t/build/compiler | awk '$2 == ".text.buster_start" {print "0x"$4" + 0x"$6}')"
    done
} > results/order-compare-slots.txt 2>&1
cat results/order-compare-slots.txt >> "$log"
./lock.sh timeout -k 10 600 ./counts.sh results/counts-slots "base2=$PWD/base2/build/compiler" "slots=$PWD/slots/build/compiler" > results/counts-slots.log 2>&1
echo "$? counts" >> "$log"
for spec in hello:41:slots hello:41:same sqlite:21:slots sqlite:21:same musl:11:slots musl:11:same tiny:21:slots tiny:21:same command:5:slots command:5:same syntax:21:slots preprocess:21:slots hello:41:slots:again musl:11:slots:again; do
    IFS=: read -r kind rounds other again <<< "$spec"
    label=$kind-$other${again:+-$again}
    tree=$other
    [ "$other" = same ] && tree=base2
    start=$(date +%s)
    ./lock.sh timeout -k 10 900 ./ab.sh "results/abs-$label" "$kind" "$rounds" "base2=$PWD/base2/build/compiler" "$other=$PWD/$tree/build/compiler" > "results/abs-$label.log" 2>&1
    echo "$? $(( $(date +%s) - start ))s $label" >> "$log"
    tools/abstat "results/abs-$label" base2 "$other" > "results/abstats-$label.txt" 2>&1
done
for spec in musl:11 hello:41; do
    kind=${spec%%:*}
    rounds=${spec#*:}
    start=$(date +%s)
    ./lock.sh timeout -k 10 900 ./ab.sh "results/abs-$kind-final-slots" "$kind" "$rounds" "final=$PWD/final/build/compiler" "slots=$PWD/slots/build/compiler" > "results/abs-$kind-final-slots.log" 2>&1
    echo "$? $(( $(date +%s) - start ))s $kind-final-slots" >> "$log"
    tools/abstat "results/abs-$kind-final-slots" final slots > "results/abstats-$kind-final-slots.txt" 2>&1
done
echo done >> "$log"
echo finished > job-slots.done
