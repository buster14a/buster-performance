#!/bin/bash
# thp-round.sh TREE OUT: one interleaved round of huge pages as the system has them (BUSTER_HUGE_PAGES=1) against base
# pages (=0) on CPU 2, inside one hold of the lock: lvm.c -c (10 pairs), sqlite3.c -c (6), main.c -fsyntax-only (3).
tree=$1; out=$2
export LC_ALL=C
inputs=~/buster-fast-bench/1109-claude/inputs
cd "$tree" || exit 1
flags=(-march=native -Isrc -fwrapv -funsigned-char -fno-strict-aliasing -fno-stack-protector -Wno-unused-function -Wno-psabi)
run() {
    local label=$1 setting=$2; shift 2
    local err; err=$(mktemp)
    local begin=$EPOCHREALTIME
    BUSTER_HUGE_PAGES=$setting taskset -c 2 ./build/compiler --time-stages --lanes 1 "$@" 2> "$err" > /dev/null
    local status=$?
    local end=$EPOCHREALTIME
    local us=$(( ${end/[.,]/} - ${begin/[.,]/} ))
    local wall; printf -v wall '%d.%03d' $((us / 1000)) $((us % 1000))
    printf '%s\t%s\t%d\t%s\t%s\t%s\t%s\t%s\n' "$label" "$setting" "$status" "$wall" \
        "$(sed -n 's/^time-stage\ttotal\t\([0-9.]*\).*/\1/p' "$err")" \
        "$(sed -n 's/^time-process\tsystem-ms\t//p' "$err")" \
        "$(sed -n 's/^time-process\tpeak-rss-kb\t//p' "$err")" \
        "$(sed -n 's/^time-process\thuge-pages\t//p' "$err")" >> "$out"
    rm -f "$err"
}
for i in $(seq 10); do for s in 1 0; do run lvm "$s" -c -o /dev/null "$inputs/lua-5.4.8/src/lvm.c"; done; done
for i in $(seq 6); do for s in 1 0; do run sqlite "$s" -c -o /dev/null "$inputs/sqlite3.c"; done; done
for i in $(seq 3); do for s in 1 0; do run main "$s" "${flags[@]}" -fsyntax-only src/buster/compiler/main.c; done; done
echo "round done" >> "$out"
