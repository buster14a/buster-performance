#!/bin/bash
# ab.sh ROUNDS NAME...: bin/direct-NAME's compiles of the frozen sqlite3.c, the variants in an order that rotates by
# round, 20 compiles a process, CPU 2: per compile, the medians over the rounds of the user and kernel cycles,
# instructions, mispredicted branches and forwarding failures, and the median stage times. One hold.
set -uo pipefail
. "$(dirname "$0")/env.sh"
rounds=$1; shift
names=("$@")
tmp=$(mktemp -d /dev/shm/ab-3585.XXXXXX)
cat /proc/loadavg >&2
for n in "${names[@]}"; do
    "$here/bin/direct-$n" "${hargs[@]}" -o "$tmp/$n.o" > /dev/null 2>&1 || echo "FAILED $n" >&2
    sha256sum "$tmp/$n.o" | cut -c1-16 > "$tmp/$n.sha"
done
count=${#names[@]}
for ((r = 0; r < rounds; r++)); do
    for ((k = 0; k < count; k++)); do
        n=${names[$(((k + r) % count))]}
        taskset -c 2 perf stat -x ';' --no-big-num -e cycles:u,instructions:u,ex_ret_brn_misp:u,ls_bad_status2.stli_other:u,cycles:k -o "$tmp/$n.$r.csv" -- \
            "$here/bin/direct-$n" "${hargs[@]}" -o "$tmp/out.o" --repeat 20 --summary > "$tmp/$n.$r.out" 2> /dev/null
    done
done
printf '%-14s %10s %10s %10s %9s %9s %8s %8s %8s  %s\n' variant cycles:u instr:u cycles:k brmiss stlfail ms pre-ms gen-ms object
for n in "${names[@]}"; do
    med() { sort -n | awk '{a[NR]=$1} END{print a[int((NR+1)/2)]}'; }
    ev() { for ((r = 0; r < rounds; r++)); do awk -F';' -v e="$1" '$3==e {printf "%.0f\n", $1/20}' "$tmp/$n.$r.csv"; done | med; }
    st() { for ((r = 0; r < rounds; r++)); do awk -v k="$1" '/^median-ms/ {for(i=2;i<NF;i+=2) if($i==k) print $(i+1)}' "$tmp/$n.$r.out"; done | med; }
    printf '%-14s %10s %10s %10s %9s %9s %8s %8s %8s  %s\n' "$n" "$(ev cycles:u)" "$(ev instructions:u)" "$(ev cycles:k)" "$(ev ex_ret_brn_misp:u)" "$(ev ls_bad_status2.stli_other:u)" \
        "$(st total)" "$(st preprocess)" "$(st codegen)" "$(cat "$tmp/$n.sha")"
done
cat /proc/loadavg >&2
rm -rf "$tmp"
