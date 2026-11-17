#!/bin/bash
# job-threshold.sh: the commit's code with its asks at a component's fourth and fifth miss (fin4, fin5: files-fin4.patch,
# files-fin5.patch, with fin's start order), a Release build each; then base2 against each, and against fin and finoff
# again, on musl's units, a process each (11 rounds), and on hello.c (41 rounds), with base2 against a second copy of
# itself; and the compilers' file system calls.
cd "$(dirname "$0")"
main=2d817432864947a0853abd1e79879b0086fbd9b7
: > job-threshold.done
log=threshold.log
: > "$log"
./build-tree.sh fin4 $main files-fin4.patch order-fin.patch > build-fin4.out 2>&1
./build-tree.sh fin5 $main files-fin5.patch order-fin.patch > build-fin5.out 2>&1
for t in fin4 fin5; do tail -2 build-$t.out >> "$log"; done
./lock.sh timeout -k 10 600 ./counts.sh results/counts-threshold "base2=$PWD/base2/build/compiler" "fin=$PWD/fin/build/compiler" "fin4=$PWD/fin4/build/compiler" "fin5=$PWD/fin5/build/compiler" > results/counts-threshold.log 2>&1
echo "$? counts" >> "$log"
for spec in musl:11:fin5 musl:11:fin4 musl:11:fin musl:11:finoff musl:11:same hello:41:fin5 hello:41:fin4 hello:41:same musl:11:fin5:again musl:11:fin4:again musl:11:fin:again musl:11:finoff:again musl:11:same:again hello:41:fin5:again sqlite:21:fin5; do
    IFS=: read -r kind rounds other again <<< "$spec"
    label=$kind-$other${again:+-$again}
    tree=$other
    [ "$other" = same ] && tree=base2
    start=$(date +%s)
    ./lock.sh timeout -k 10 900 ./ab.sh "results/aby-$label" "$kind" "$rounds" "base2=$PWD/base2/build/compiler" "$other=$PWD/$tree/build/compiler" > "results/aby-$label.log" 2>&1
    echo "$? $(( $(date +%s) - start ))s $label" >> "$log"
    tools/abstat "results/aby-$label" base2 "$other" > "results/abstaty-$label.txt" 2>&1
done
echo done >> "$log"
echo finished > job-threshold.done
