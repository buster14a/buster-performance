#!/bin/bash
# job-head.sh: the pull request's tree (main 05c5d95d7, whose compiler sources are 2d8174328's, with files-head.patch:
# the asks, their tests as committed, and the start order made again), a Release build, against main's build (base2):
# the compilers' file system calls, where the link put file_cache_count_miss, and base2 against head on hello.c
# (41 rounds), on musl's units, a process each (11 rounds), and on sqlite3.c (21 rounds), a hold of the lock each, with
# base2 against a second copy of itself beside them.
cd "$(dirname "$0")"
main=$(cat head-base.txt)
: > job-head.done
log=head.log
: > "$log"
./build-tree.sh head "$main" files-head.patch > build-head.out 2>&1
tail -2 build-head.out >> "$log"
{
    for t in base2 head; do
        echo "$t: $(readelf -sW $t/build/compiler | awk '$8 ~ /^file_cache_(count_miss|miss_component|component_key|find_component|component_absent)$/ {printf "%s at 0x%s (%s bytes); ", $8, $2, $3}') .text.buster_start $(readelf -SW $t/build/compiler | awk '$2 == ".text.buster_start" {print "0x"$4" + 0x"$6}')"
    done
} > results/symbols-head.txt 2>&1
cat results/symbols-head.txt >> "$log"
./lock.sh timeout -k 10 600 ./counts.sh results/counts-head "base2=$PWD/base2/build/compiler" "head=$PWD/head/build/compiler" > results/counts-head.log 2>&1
echo "$? counts" >> "$log"
for spec in hello:41:head hello:41:same musl:11:head musl:11:same sqlite:21:head sqlite:21:same hello:41:head:again musl:11:head:again; do
    IFS=: read -r kind rounds other again <<< "$spec"
    label=$kind-$other${again:+-$again}
    tree=$other
    [ "$other" = same ] && tree=base2
    start=$(date +%s)
    ./lock.sh timeout -k 10 900 ./ab.sh "results/abh-$label" "$kind" "$rounds" "base2=$PWD/base2/build/compiler" "$other=$PWD/$tree/build/compiler" > "results/abh-$label.log" 2>&1
    echo "$? $(( $(date +%s) - start ))s $label" >> "$log"
    tools/abstat "results/abh-$label" base2 "$other" > "results/abstath-$label.txt" 2>&1
done
echo done >> "$log"
echo finished > job-head.done
