#!/usr/bin/env bash
# Times CI's c-testsuite SSA command and 00040.c alone with the given compiler(s), alternating builds per round.
# usage: time-runs.sh OUT_DIR ROUNDS MODE LABEL=COMPILER...   (MODE: one | all | both)
set -u
out="$1"; rounds="$2"; mode="$3"; shift 3
mkdir -p "$out"
cd /home/user/buster
files_all=$(sed -n 's|^\([0-9][0-9]*\)$|build/c-testsuite/tests/single-exec/\1.c|p' tests/c-testsuite/subset.txt)
one=build/c-testsuite/tests/single-exec/00040.c
for r in $(seq 1 "$rounds"); do
    for pair in "$@"; do
        label="${pair%%=*}"; compiler="${pair#*=}"
        if [ "$mode" = one ] || [ "$mode" = both ]; then
            log="$out/$label-00040-r$r.log"
            /usr/bin/time -f 'wall %e user %U sys %S maxrss %M' -o "$log.time" "$compiler" test-ssa-source --typed --tier1 $one > "$log" 2>&1
            echo "$label 00040 r$r rc=$? $(cat "$log.time")"
        fi
        if [ "$mode" = all ] || [ "$mode" = both ]; then
            log="$out/$label-all-r$r.log"
            /usr/bin/time -f 'wall %e user %U sys %S maxrss %M' -o "$log.time" "$compiler" test-ssa-source --typed --tier1 $files_all > "$log" 2>&1
            echo "$label all r$r rc=$? $(cat "$log.time")"
        fi
    done
done
