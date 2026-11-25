#!/bin/bash
# eligible.sh COMPILER CHECKOUT: each build source's -c as BUSTER_PGO's training runs it (the units' flags, no -g, no
# -ffunction-sections) with and without -Wall -Werror; which path wrote each object ("buster direct" in .comment).
set -uo pipefail
bin=$1
cd "$2"
out=$(mktemp -d "${TMPDIR:-/tmp}/elig.XXXXXX")
mapfile -d '' -t flags < <(./build.sh print-compile-flags --config Release)
mapfile -d '' -t sources < <(./build.sh print-sources)
train=(); plain=()
for f in "${flags[@]}"; do
    case "$f" in -g|-ffunction-sections) ;; *) train+=("$f") ;; esac
    case "$f" in -g|-ffunction-sections|-Wall|-Werror) ;; *) plain+=("$f") ;; esac
done
printf 'train flags: %s\nplain flags: %s\n' "${train[*]}" "${plain[*]}"
for s in "${sources[@]}"; do
    n=$(basename "$s" .c)
    t0=$(date +%s%N); "$bin" -c "$s" "${train[@]}" -o "$out/$n.train.o" 2> "$out/$n.train.err"; st=$?; t1=$(date +%s%N)
    "$bin" -c "$s" "${plain[@]}" -o "$out/$n.plain.o" 2> "$out/$n.plain.err"; sp=$?; t2=$(date +%s%N)
    BUSTER_NO_DIRECT=1 "$bin" -c "$s" "${plain[@]}" -o "$out/$n.full.o" 2>/dev/null; t3=$(date +%s%N)
    # .comment alone: c_direct.c's object holds the string "buster direct" as data.
    dt=$(readelf -p .comment "$out/$n.train.o" 2>/dev/null | grep -c 'buster direct'); dp=$(readelf -p .comment "$out/$n.plain.o" 2>/dev/null | grep -c 'buster direct')
    printf '%-40s train(status %d direct %s %5d ms) plain(status %d direct %s %5d ms) nodirect %5d ms\n' "$n" $st "${dt:-0}" $(((t1-t0)/1000000)) $sp "${dp:-0}" $(((t2-t1)/1000000)) $(((t3-t2)/1000000))
done
echo "objects in $out"
