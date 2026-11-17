#!/bin/bash
# job-final.sh: the include search's asks on today's main, with the start order made again from their build.
#   base2   main 2d8174328
#   order1  main with the asks (files-final.patch), built as the list's header says (znver5, no debug information): the
#           start order made again from its build (order.sh), and written into its cmake/BusterStartOrder.txt
#           (order.patch is that file's change)
#   final   main with the asks and the list made again
#   order2  the list made once more from final's build: the same functions, or the difference
# Then the three compilers' file system calls (counts.sh), base2 against final, a hold of the lock an A/B (ab.sh: CPU 2,
# CPU-wide counts), base2 against a second copy of itself (same) as what two copies of one executable read, and abstat's
# table of each. Every build, trace and A/B in one hold of the lock.
cd "$(dirname "$0")"
main=2d817432864947a0853abd1e79879b0086fbd9b7
: > job-final.done
log=final.log
: > "$log"
./build-tree.sh base2 $main > build-base2.out 2>&1
HOST_ARCH=znver5 DEBUG_INFO=0 ./build-tree.sh order1 $main files-final.patch > build-order1.out 2>&1
for step in "small" "sqlite" "musl 0 334" "musl 334 668" "musl 668 1002" "musl 1002 1336" "list"; do
    ./lock.sh timeout -k 10 600 ./order.sh order1 results/order1 $step >> "$log" 2>&1
    echo "$? order1 $step" >> "$log"
done
{
    sed -n '1,/^# Refresh it as that guide says/p' order1/cmake/BusterStartOrder.txt | sed "s|from main at c7caeb56b with #2873's change|from main at 2d8174328 with #2873's asks of the include search|"
    cat results/order1/body.txt
} > results/order1/BusterStartOrder.txt
cp results/order1/BusterStartOrder.txt order1/cmake/BusterStartOrder.txt
git -C order1 diff -- cmake/BusterStartOrder.txt > order.patch
echo "order.patch: $(grep -c '^[+-][^+-]' order.patch) changed lines" >> "$log"
./build-tree.sh final $main files-final.patch order.patch > build-final.out 2>&1
for step in "small" "sqlite" "musl 0 334" "musl 334 668" "musl 668 1002" "musl 1002 1336" "list"; do
    ./lock.sh timeout -k 10 600 ./order.sh final results/order2 $step >> "$log" 2>&1
    echo "$? order2 $step" >> "$log"
done
{
    echo "the list made from order1's build against the one made again from final's:"
    echo "  functions: $(grep -vc '^#' results/order1/body.txt) and $(grep -vc '^#' results/order2/body.txt)"
    echo "  in the first alone: $(comm -23 <(grep -v '^#' results/order1/body.txt | sort) <(grep -v '^#' results/order2/body.txt | sort) | wc -l); in the second alone: $(comm -13 <(grep -v '^#' results/order1/body.txt | sort) <(grep -v '^#' results/order2/body.txt | sort) | wc -l)"
    echo "  lines whose place differs: $(diff <(grep -v '^#' results/order1/body.txt) <(grep -v '^#' results/order2/body.txt) | grep -c '^[<>]')"
    for t in base2 final; do
        echo "  $t: $(readelf -sW $t/build/compiler | awk '$8 == "file_cache_count_miss" {printf "file_cache_count_miss at 0x%s (%s bytes); ", $2, $3}') .text.buster_start $(readelf -SW $t/build/compiler | awk '$2 == ".text.buster_start" {print "0x"$4" + 0x"$6}')"
    done
} > results/order-compare.txt 2>&1
cat results/order-compare.txt >> "$log"
./lock.sh timeout -k 10 600 ./counts.sh results/counts-final "base2=$PWD/base2/build/compiler" "final=$PWD/final/build/compiler" > results/counts-final.log 2>&1
echo "$? counts" >> "$log"
for spec in hello:41:final hello:41:same sqlite:21:final sqlite:21:same musl:11:final musl:11:same tiny:21:final tiny:21:same command:5:final command:5:same syntax:21:final preprocess:21:final hello:41:final:again musl:11:final:again; do
    IFS=: read -r kind rounds other again <<< "$spec"
    label=$kind-$other${again:+-$again}
    tree=$other
    [ "$other" = same ] && tree=base2
    start=$(date +%s)
    ./lock.sh timeout -k 10 900 ./ab.sh "results/abf-$label" "$kind" "$rounds" "base2=$PWD/base2/build/compiler" "$other=$PWD/$tree/build/compiler" > "results/abf-$label.log" 2>&1
    echo "$? $(( $(date +%s) - start ))s $label" >> "$log"
    tools/abstat "results/abf-$label" base2 "$other" > "results/abstatf-$label.txt" 2>&1
done
echo done >> "$log"
echo finished > job-final.done
