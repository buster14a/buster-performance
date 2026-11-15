#!/bin/bash
# #1360 A/B on the 9700X: base against head, CPU 2, one lock hold per round, the builds' order alternating by round and workload.
set -u
cd ~/buster-fast-bench/1360-claude || exit 2
export LC_ALL=C LC_NUMERIC=C
export EXCLUSIVE_OWNER=claude-1360 EXCLUSIVE_TITLE="claude #1360 debug-build warnings A/B" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/1360
unset CPATH C_INCLUDE_PATH
BASE=$PWD/${BASE_DIR:-base}
HEAD=$PWD/${HEAD_DIR:-head}
ROUNDS=${ROUNDS:-7}
OUT=${OUT:-ab}
mkdir -p $OUT/out
SQ=$PWD/inputs/sqlite3.c
SQOPTS="-c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE"
{ uname -a; perf --version; cat /sys/devices/system/cpu/cpu2/cpufreq/scaling_governor /sys/devices/system/cpu/cpu2/cpufreq/energy_performance_preference;
  grep -m1 'model name' /proc/cpuinfo; for d in "$BASE" "$HEAD"; do echo "$d $(cat "$d/COMMIT")"; sha256sum "$d/build/compiler"; done; } > $OUT/host.txt 2>&1
workloads=(
    "sq-ci|$SQOPTS $SQ"
    "sq-ci-w|$SQOPTS -w $SQ"
    "sq-debug|$SQOPTS -DSQLITE_DEBUG $SQ"
    "sq-debug-w|$SQOPTS -DSQLITE_DEBUG -w $SQ"
    "bodies-1000|-c $PWD/inputs/bodies-1000.c"
    "bodies-2000|-c $PWD/inputs/bodies-2000.c"
    "bodies-4000|-c $PWD/inputs/bodies-4000.c"
    "bodies-8000|-c $PWD/inputs/bodies-8000.c"
    "bodies-8000-w|-c -w $PWD/inputs/bodies-8000.c"
    "asserts-1000|-c $PWD/inputs/asserts-1000.c"
    "asserts-2000|-c $PWD/inputs/asserts-2000.c"
    "asserts-4000|-c $PWD/inputs/asserts-4000.c"
    "asserts-8000|-c $PWD/inputs/asserts-8000.c"
    "lua|"
    "lua-w|-w"
    "lua-assert|-DLUAI_ASSERT"
    "lua-assert-w|-DLUAI_ASSERT -w"
)
[[ -f $OUT/results.tsv ]] || printf 'round\tworkload\tvariant\tstatus\twall_ms\ttotal_ms\tcheck_program_ms\tinstructions_u\tcycles_u\n' > $OUT/results.tsv
for ((r = 1; r <= ROUNDS; r++)); do
    if grep -q "^$r	" $OUT/results.tsv; then continue; fi
    timeout 1500 ~/buster-fast-bench/exclusive.sh ./round.sh "$r" "$BASE" "$HEAD" "$OUT" "${workloads[@]}" > $OUT/round-$r.tsv 2> $OUT/round-$r.err || echo "round $r failed" >&2
    cat $OUT/round-$r.tsv >> $OUT/results.tsv
    sleep 10
done
echo done > $OUT/measure.done
