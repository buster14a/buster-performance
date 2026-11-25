#!/bin/bash
# micro.sh ROUNDS NAME[:SHIFT]...: bin/lexbench-NAME over the sanitized sqlite3.c (every block a full one), 200 passes a
# process, CPU 2, the variants rotated by round: per block, the medians of cycles, instructions, mispredicted branches
# and forwarding failures. One hold.
set -uo pipefail
. "$(dirname "$0")/env.sh"
rounds=$1; shift
names=("$@")
text=$here/sqlite-clean.c
blocks=$(( $(stat -c %s "$text") / 64 * 200 ))
tmp=$(mktemp -d /dev/shm/micro-3585.XXXXXX)
count=${#names[@]}
for ((r = 0; r < rounds; r++)); do
    for ((k = 0; k < count; k++)); do
        idx=$(((k + r) % count)); v=${names[$idx]}; n=${v%%:*}; s=${v#*:}; [ "$s" = "$v" ] && s=64
        taskset -c 2 perf stat -x ';' --no-big-num -e cycles:u,instructions:u,ex_ret_brn_misp:u,ls_bad_status2.stli_other:u -o "$tmp/$idx.$r.csv" -- "$here/bin/lexbench-$n" "$text" 200 "$s" > "$tmp/$idx.$r.out" 2>&1 || echo "FAILED $v" >&2
    done
done
printf '%-16s %9s %9s %9s %9s  %s\n' variant cyc/blk ins/blk misp/kblk stlf/kblk output
for ((k = 0; k < count; k++)); do
    med() { sort -n | awk '{a[NR]=$1} END{print a[int((NR+1)/2)]}'; }
    ev() { for ((r = 0; r < rounds; r++)); do awk -F';' -v e="$1" -v b=$blocks -v m="$2" '$3==e {printf "%.3f\n", $1*m/b}' "$tmp/$k.$r.csv"; done | med; }
    printf '%-16s %9s %9s %9s %9s  %s\n' "${names[$k]}" "$(ev cycles:u 1)" "$(ev instructions:u 1)" "$(ev ex_ret_brn_misp:u 1000)" "$(ev ls_bad_status2.stli_other:u 1000)" "$(head -c 60 "$tmp/$k.0.out")"
done
rm -rf "$tmp"
