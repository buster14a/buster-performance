#!/bin/bash
# job-fin.sh: the commit's code (files-fin.patch: the asks, their counting without a loop, a key the name's bytes), on
# main 2d8174328; as job-vec.sh, whose code had a key's length in its last byte.
#   order1f  the patch, built as the list's header says: the start order made again from its build (order-fin.patch)
#   fin      the patch and that list
#   finoff   fin with the asks never made (the threshold 0): the counting alone
#   order2f  the list made once more from fin's build
# Then a musl unit's own counters by base2, scratch (the counting by loops), finoff and fin (unit-cost.sh's units), the
# compilers' file system calls, and base2 against fin, a hold of the lock an A/B, with base2 against a second copy of
# itself beside each.
cd "$(dirname "$0")"
here=$PWD
main=2d817432864947a0853abd1e79879b0086fbd9b7
: > job-fin.done
log=fin.log
: > "$log"
HOST_ARCH=znver5 DEBUG_INFO=0 ./build-tree.sh order1f $main files-fin.patch > build-order1f.out 2>&1
for step in "small" "sqlite" "musl 0 334" "musl 334 668" "musl 668 1002" "musl 1002 1336" "list"; do
    ./lock.sh timeout -k 10 600 ./order.sh order1f results/order1f $step >> "$log" 2>&1
    echo "$? order1f $step" >> "$log"
done
{
    sed -n '1,/^# Refresh it as that guide says/p' order1f/cmake/BusterStartOrder.txt | sed "s|from main at c7caeb56b with #2873's change|from main at 2d8174328 with #2873's asks of the include search|"
    cat results/order1f/body.txt
} > results/order1f/BusterStartOrder.txt
cp results/order1f/BusterStartOrder.txt order1f/cmake/BusterStartOrder.txt
git -C order1f diff -- cmake/BusterStartOrder.txt > order-fin.patch
echo "order-fin.patch: $(grep -c '^[+-][^+-]' order-fin.patch) changed lines" >> "$log"
./build-tree.sh fin $main files-fin.patch order-fin.patch > build-fin.out 2>&1
./build-tree.sh finoff $main files-finoff.patch order-fin.patch > build-finoff.out 2>&1
for step in "small" "sqlite" "musl 0 334" "musl 334 668" "musl 668 1002" "musl 1002 1336" "list"; do
    ./lock.sh timeout -k 10 600 ./order.sh fin results/order2f $step >> "$log" 2>&1
    echo "$? order2f $step" >> "$log"
done
{
    echo "the list made from order1f's build against the one made again from fin's:"
    echo "  functions: $(grep -vc '^#' results/order1f/body.txt) and $(grep -vc '^#' results/order2f/body.txt)"
    comm -3 <(grep -v '^#' results/order1f/body.txt | sort) <(grep -v '^#' results/order2f/body.txt | sort) | head -10
    echo "  lines whose place differs: $(diff <(grep -v '^#' results/order1f/body.txt) <(grep -v '^#' results/order2f/body.txt) | grep -c '^[<>]')"
    echo "against the slots build's list: $(diff <(grep -v '^#' results/order1s/body.txt) <(grep -v '^#' results/order1f/body.txt) | grep -c '^[<>]') lines differ"
    for t in base2 scratch fin; do
        echo "  $t: $(readelf -sW $t/build/compiler | awk '$8 ~ /^file_cache_(count_miss|miss_component|component_key|find_component|component_absent)$/ {printf "%s at 0x%s (%s bytes); ", $8, $2, $3}') .text.buster_start $(readelf -SW $t/build/compiler | awk '$2 == ".text.buster_start" {print "0x"$4" + 0x"$6}')"
    done
} > results/order-compare-fin.txt 2>&1
cat results/order-compare-fin.txt >> "$log"
sed -e 's/for name in base2 off scratch; do cp/for name in base2 scratch finoff fin; do cp/' -e 's/for name in base2 off scratch; do$/for name in base2 scratch finoff fin; do/' -e 's/-e cycles:u,instructions:u,branch-misses:u,L1-dcache-load-misses:u,L1-icache-load-misses:u,dTLB-load-misses:u,iTLB-load-misses:u,cycles:k/-e cycles:u,instructions:u,branch-misses:u,branches:u,L1-icache-load-misses:u/' unit-cost.sh > unit-cost-fin.sh
chmod +x unit-cost-fin.sh
./lock.sh timeout -k 10 900 ./unit-cost-fin.sh results/unit-cost-fin >> "$log" 2>&1
echo "$? unit-cost" >> "$log"
./lock.sh timeout -k 10 600 ./counts.sh results/counts-fin "base2=$PWD/base2/build/compiler" "fin=$PWD/fin/build/compiler" > results/counts-fin.log 2>&1
echo "$? counts" >> "$log"
for spec in hello:41:fin hello:41:same musl:11:fin musl:11:same musl:11:finoff sqlite:21:fin sqlite:21:same tiny:21:fin command:9:fin command:9:same syntax:21:fin preprocess:21:fin hello:41:fin:again musl:11:fin:again musl:11:same:again; do
    IFS=: read -r kind rounds other again <<< "$spec"
    label=$kind-$other${again:+-$again}
    tree=$other
    [ "$other" = same ] && tree=base2
    start=$(date +%s)
    ./lock.sh timeout -k 10 900 ./ab.sh "results/abx-$label" "$kind" "$rounds" "base2=$PWD/base2/build/compiler" "$other=$PWD/$tree/build/compiler" > "results/abx-$label.log" 2>&1
    echo "$? $(( $(date +%s) - start ))s $label" >> "$log"
    tools/abstat "results/abx-$label" base2 "$other" > "results/abstatx-$label.txt" 2>&1
done
echo done >> "$log"
echo finished > job-fin.done
