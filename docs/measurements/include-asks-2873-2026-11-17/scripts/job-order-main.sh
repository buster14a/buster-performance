#!/bin/bash
# job-order-main.sh: is main's start order still what compiles run, after #2940 (the scalar host removed) and #2941?
#   main3    main at main-rev.txt, built as the list's header says (znver5, no debug information, Release)
#   order3m  the start order made again from its build (order.sh: the four small commands, sqlite3.c, musl's units)
# Then the lists compared; and, if they differ, main3o (main with the list made again) against main3 on hello.c
# (41 rounds) and on musl's units, a process each (11 rounds), with main3 against a second copy of itself.
cd "$(dirname "$0")"
main=$(cat main-rev.txt)
: > job-order-main.done
log=order-main.log
: > "$log"
HOST_ARCH=znver5 DEBUG_INFO=0 ./build-tree.sh main3 "$main" > build-main3.out 2>&1
tail -2 build-main3.out >> "$log"
for step in "small" "sqlite" "musl 0 334" "musl 334 668" "musl 668 1002" "musl 1002 1336" "list"; do
    ./lock.sh timeout -k 10 600 ./order.sh main3 results/order3m $step >> "$log" 2>&1
    echo "$? order3m $step" >> "$log"
done
{
    sed -n '1,/^# Refresh it as that guide says/p' main3/cmake/BusterStartOrder.txt
    cat results/order3m/body.txt
} > results/order3m/BusterStartOrder.txt
{
    echo "main's list against the one made again from its build:"
    echo "  functions: $(grep -vc '^#' main3/cmake/BusterStartOrder.txt) and $(grep -vc '^#' results/order3m/body.txt)"
    echo "  in one alone (< main's, > made again):"
    diff <(grep -v '^#' main3/cmake/BusterStartOrder.txt | sort) <(grep -v '^#' results/order3m/body.txt | sort) | grep '^[<>]' | head -60
    echo "  lines whose place differs: $(diff <(grep -v '^#' main3/cmake/BusterStartOrder.txt) <(grep -v '^#' results/order3m/body.txt) | grep -c '^[<>]')"
    echo "  names of main's list that the build has no function for: $(grep -v '^#' main3/cmake/BusterStartOrder.txt | awk '{print $NF}' | sort -u | comm -23 - <(readelf -sW main3/build/compiler | awk '$4 == "FUNC" {print $8}' | sort -u) | wc -l)"
    grep -v '^#' main3/cmake/BusterStartOrder.txt | awk '{print $NF}' | sort -u | comm -23 - <(readelf -sW main3/build/compiler | awk '$4 == "FUNC" {print $8}' | sort -u) | head -20
    echo "  .text.buster_start $(readelf -SW main3/build/compiler | awk '$2 == ".text.buster_start" {print "0x"$4" + 0x"$6}')"
} > results/order-compare-main3.txt 2>&1
cat results/order-compare-main3.txt >> "$log"
changed=$(diff <(grep -v '^#' main3/cmake/BusterStartOrder.txt | sort) <(grep -v '^#' results/order3m/body.txt | sort) | grep -c '^[<>]')
if [ "$changed" != 0 ]; then
    cp results/order3m/BusterStartOrder.txt main3/cmake/BusterStartOrder.txt.new
    git -C main3 diff --quiet || echo "main3 has changes" >> "$log"
    cp main3/cmake/BusterStartOrder.txt.new /tmp/2873-order3m.txt && rm main3/cmake/BusterStartOrder.txt.new
    cp /tmp/2873-order3m.txt main3/cmake/BusterStartOrder.txt
    git -C main3 diff -- cmake/BusterStartOrder.txt > order-main3.patch
    git -C main3 checkout -q -- cmake/BusterStartOrder.txt
    ./build-tree.sh main3n "$main" > build-main3n.out 2>&1
    ./build-tree.sh main3o "$main" order-main3.patch > build-main3o.out 2>&1
    tail -2 build-main3n.out build-main3o.out >> "$log"
    for spec in hello:41:main3o hello:41:same musl:11:main3o musl:11:same hello:41:main3o:again musl:11:main3o:again; do
        IFS=: read -r kind rounds other again <<< "$spec"
        label=$kind-$other${again:+-$again}
        tree=$other
        [ "$other" = same ] && tree=main3n
        start=$(date +%s)
        ./lock.sh timeout -k 10 900 ./ab.sh "results/abm-$label" "$kind" "$rounds" "main3n=$PWD/main3n/build/compiler" "$other=$PWD/$tree/build/compiler" > "results/abm-$label.log" 2>&1
        echo "$? $(( $(date +%s) - start ))s $label" >> "$log"
        tools/abstat "results/abm-$label" main3n "$other" > "results/abstatm-$label.txt" 2>&1
    done
fi
echo done >> "$log"
echo finished > job-order-main.done
