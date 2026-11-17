#!/bin/bash
# job-vec.sh: the asks with their counting branch-free (files-vec.patch: a component's key by one masked load, its slot by
# one compare of every slot), on main 2d8174328.
#   order1v  the patch, built as the list's header says: the start order made again from its build (order-vec.patch)
#   vec      the patch and that list
#   vecoff   vec with the asks never made (the threshold 0): the counting alone
#   order2v  the list made once more from vec's build
# Then a musl unit's own counters by base2, scratch (the counting by loops), vecoff and vec (unit-cost.sh's units), the
# compilers' file system calls, and base2 against vec, a hold of the lock an A/B, with base2 against a second copy of
# itself beside each.
cd "$(dirname "$0")"
here=$PWD
main=2d817432864947a0853abd1e79879b0086fbd9b7
: > job-vec.done
log=vec.log
: > "$log"
HOST_ARCH=znver5 DEBUG_INFO=0 ./build-tree.sh order1v $main files-vec.patch > build-order1v.out 2>&1
for step in "small" "sqlite" "musl 0 334" "musl 334 668" "musl 668 1002" "musl 1002 1336" "list"; do
    ./lock.sh timeout -k 10 600 ./order.sh order1v results/order1v $step >> "$log" 2>&1
    echo "$? order1v $step" >> "$log"
done
{
    sed -n '1,/^# Refresh it as that guide says/p' order1v/cmake/BusterStartOrder.txt | sed "s|from main at c7caeb56b with #2873's change|from main at 2d8174328 with #2873's asks of the include search|"
    cat results/order1v/body.txt
} > results/order1v/BusterStartOrder.txt
cp results/order1v/BusterStartOrder.txt order1v/cmake/BusterStartOrder.txt
git -C order1v diff -- cmake/BusterStartOrder.txt > order-vec.patch
echo "order-vec.patch: $(grep -c '^[+-][^+-]' order-vec.patch) changed lines" >> "$log"
./build-tree.sh vec $main files-vec.patch order-vec.patch > build-vec.out 2>&1
./build-tree.sh vecoff $main files-vecoff.patch order-vec.patch > build-vecoff.out 2>&1
for step in "small" "sqlite" "musl 0 334" "musl 334 668" "musl 668 1002" "musl 1002 1336" "list"; do
    ./lock.sh timeout -k 10 600 ./order.sh vec results/order2v $step >> "$log" 2>&1
    echo "$? order2v $step" >> "$log"
done
{
    echo "the list made from order1v's build against the one made again from vec's:"
    echo "  functions: $(grep -vc '^#' results/order1v/body.txt) and $(grep -vc '^#' results/order2v/body.txt)"
    comm -3 <(grep -v '^#' results/order1v/body.txt | sort) <(grep -v '^#' results/order2v/body.txt | sort) | head -10
    echo "  lines whose place differs: $(diff <(grep -v '^#' results/order1v/body.txt) <(grep -v '^#' results/order2v/body.txt) | grep -c '^[<>]')"
    echo "against the slots build's list: $(diff <(grep -v '^#' results/order1s/body.txt) <(grep -v '^#' results/order1v/body.txt) | grep -c '^[<>]') lines differ"
    for t in base2 scratch vec; do
        echo "  $t: $(readelf -sW $t/build/compiler | awk '$8 ~ /^file_cache_(count_miss|miss_component|component_key|find_component|component_absent)$/ {printf "%s at 0x%s (%s bytes); ", $8, $2, $3}') .text.buster_start $(readelf -SW $t/build/compiler | awk '$2 == ".text.buster_start" {print "0x"$4" + 0x"$6}')"
    done
} > results/order-compare-vec.txt 2>&1
cat results/order-compare-vec.txt >> "$log"
sed -e 's/for name in base2 off scratch; do cp/for name in base2 scratch vecoff vec; do cp/' -e 's/for name in base2 off scratch; do$/for name in base2 scratch vecoff vec; do/' -e 's/-e cycles:u,instructions:u,branch-misses:u,L1-dcache-load-misses:u,L1-icache-load-misses:u,dTLB-load-misses:u,iTLB-load-misses:u,cycles:k/-e cycles:u,instructions:u,branch-misses:u,branches:u,L1-icache-load-misses:u/' unit-cost.sh > unit-cost-vec.sh
chmod +x unit-cost-vec.sh
./lock.sh timeout -k 10 900 ./unit-cost-vec.sh results/unit-cost-vec >> "$log" 2>&1
echo "$? unit-cost" >> "$log"
./lock.sh timeout -k 10 600 ./counts.sh results/counts-vec "base2=$PWD/base2/build/compiler" "vec=$PWD/vec/build/compiler" > results/counts-vec.log 2>&1
echo "$? counts" >> "$log"
for spec in hello:41:vec hello:41:same musl:11:vec musl:11:same musl:11:vecoff sqlite:21:vec sqlite:21:same tiny:21:vec command:9:vec command:9:same syntax:21:vec preprocess:21:vec hello:41:vec:again musl:11:vec:again musl:11:same:again; do
    IFS=: read -r kind rounds other again <<< "$spec"
    label=$kind-$other${again:+-$again}
    tree=$other
    [ "$other" = same ] && tree=base2
    start=$(date +%s)
    ./lock.sh timeout -k 10 900 ./ab.sh "results/abw-$label" "$kind" "$rounds" "base2=$PWD/base2/build/compiler" "$other=$PWD/$tree/build/compiler" > "results/abw-$label.log" 2>&1
    echo "$? $(( $(date +%s) - start ))s $label" >> "$log"
    tools/abstat "results/abw-$label" base2 "$other" > "results/abstatw-$label.txt" 2>&1
done
echo done >> "$log"
echo finished > job-vec.done
