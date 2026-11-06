#!/bin/bash
# ab.sh NAME ROUNDS BUILD...: each round one lock hold, the builds' sq-c compiles (--time-stages) in a rotated order on CPU 2.
name=$1; rounds=$2; shift 2
builds=("$@")
W=~/buster-fast-bench/1489-opencode
out=$W/ab/$name; mkdir -p $out
cd ~/buster-fast-bench/1340-droid/root || exit 2
source ../repo/tools/microarch/workloads.sh
corpus=corpus
n=${#builds[@]}
for ((r = 0; r < rounds; r++)); do
    order=()
    for ((i = 0; i < n; i++)); do order+=("${builds[$(( (i + r) % n ))]}"); done
    cmds=""
    for b in "${order[@]}"; do
        cmds+="taskset -c 2 $W/$b/build/compiler $(printf '%q ' "${COMMON[@]}" "${SQLITE[@]}") -c -o $W/scratch/$b-sq.o --lanes 1 --time-stages > /dev/null 2> $out/$b.$r.log; "
    done
    EXCLUSIVE_OWNER=opencode-1489 EXCLUSIVE_TITLE="#1489 check-input regression" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/1489 \
        ~/buster-fast-bench/exclusive.sh bash -c "head -1 /var/lib/buster-9700x/owner >> $out/holds.txt; $cmds" 2>> $out/lock.log
done
for b in "${builds[@]}"; do
    for st in check-input check-program check-expressions total; do
        printf '%s\t%s\t' "$b" "$st"
        cat $out/$b.*.log | awk -v s=$st '$1=="time-stage" && $2==s {print $3}' | sort -g | awk '{a[NR]=$1} END{print a[int((NR+1)/2)] "\t(" a[1] " .. " a[NR] ", n=" NR ")"}'
    done
done > $out/summary.tsv
echo done >> $out/summary.tsv
