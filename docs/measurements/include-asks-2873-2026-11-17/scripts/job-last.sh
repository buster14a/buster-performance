#!/bin/bash
# job-last.sh: the final code (scratch: the asks, their counts in the directory's slots, their path among the cache's;
# built with the start order made from the slots build). The start order made again from scratch's own build
# (order3): the same list, or the difference. Then the compilers' file system calls (counts.sh), and base2 against
# scratch on the kinds job-variants.sh left: sqlite3.c, tiny.c, the units as one command, an empty file's
# -fsyntax-only and -E -P, each with base2 against a second copy of itself where job-slots.sh has none.
cd "$(dirname "$0")"
: > job-last.done
log=last.log
: > "$log"
for step in "small" "sqlite" "musl 0 334" "musl 334 668" "musl 668 1002" "musl 1002 1336" "list"; do
    ./lock.sh timeout -k 10 600 ./order.sh scratch results/order3 $step >> "$log" 2>&1
    echo "$? order3 $step" >> "$log"
done
{
    echo "the list scratch was built with (made from the slots build) against the one made again from scratch's build:"
    echo "  functions: $(grep -vc '^#' results/order1s/body.txt) and $(grep -vc '^#' results/order3/body.txt)"
    echo "  in the first alone: $(comm -23 <(grep -v '^#' results/order1s/body.txt | sort) <(grep -v '^#' results/order3/body.txt | sort) | wc -l); in the second alone: $(comm -13 <(grep -v '^#' results/order1s/body.txt | sort) <(grep -v '^#' results/order3/body.txt | sort) | wc -l)"
    comm -3 <(grep -v '^#' results/order1s/body.txt | sort) <(grep -v '^#' results/order3/body.txt | sort) | head -10
    echo "  lines whose place differs: $(diff <(grep -v '^#' results/order1s/body.txt) <(grep -v '^#' results/order3/body.txt) | grep -c '^[<>]')"
    for t in base2 scratch; do
        echo "  $t: $(readelf -sW $t/build/compiler | awk '$8 == "file_cache_count_miss" {printf "file_cache_count_miss at 0x%s (%s bytes); ", $2, $3}') .text.buster_start $(readelf -SW $t/build/compiler | awk '$2 == ".text.buster_start" {print "0x"$4" + 0x"$6}')"
    done
} > results/order-compare-last.txt 2>&1
cat results/order-compare-last.txt >> "$log"
./lock.sh timeout -k 10 600 ./counts.sh results/counts-last "base2=$PWD/base2/build/compiler" "scratch=$PWD/scratch/build/compiler" > results/counts-last.log 2>&1
echo "$? counts" >> "$log"
for spec in sqlite:21:scratch sqlite:21:same tiny:21:scratch tiny:21:same command:5:scratch command:5:same syntax:21:scratch syntax:21:same preprocess:21:scratch preprocess:21:same hello:41:scratch:again hello:41:same; do
    IFS=: read -r kind rounds other again <<< "$spec"
    label=$kind-$other${again:+-$again}
    tree=$other
    [ "$other" = same ] && tree=base2
    start=$(date +%s)
    ./lock.sh timeout -k 10 900 ./ab.sh "results/abl-$label" "$kind" "$rounds" "base2=$PWD/base2/build/compiler" "$other=$PWD/$tree/build/compiler" > "results/abl-$label.log" 2>&1
    echo "$? $(( $(date +%s) - start ))s $label" >> "$log"
    tools/abstat "results/abl-$label" base2 "$other" > "results/abstatl-$label.txt" 2>&1
done
echo done >> "$log"
echo finished > job-last.done
