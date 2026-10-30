#!/usr/bin/env bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
set -euo pipefail
stage=${1:?STAGING_ROOT}
kind=${2:?time or stages or validate or identity}
shift=${3:-0}
process=${4:-1}
role=${5:-head}
cd "$stage"
export LC_ALL=C SOURCE_DATE_EPOCH=1792454400
unset CPATH C_INCLUDE_PATH
mkdir -p results/bindings
receipt=results/bindings/$kind-$role-p$process-s$shift.txt
producer_log=
date -u +before_run_utc=%Y-%m-%dT%H:%M:%SZ > "$receipt"
sha256sum --check inputs.sha256 >> "$receipt"
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
sqlite=(-c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE --predefines "$corpus/provenance/gnu17-pinned-predefines.txt" --clang-features -march=znver5 -std=gnu17 -nostdinc -isystem "$corpus/headers/usr/lib/clang/23/include" -isystem "$corpus/headers/usr/local/include" -isystem "$corpus/headers/usr/include" -I"$corpus/sqlite" "$corpus/sqlite/sqlite3.c")
base=$stage/placement-base/compiler-$shift
head=$stage/placement-head/compiler-$shift
case "$kind" in
    identity)
        uname -a
        lscpu
        ldd --version | head -n 1
        cat /sys/devices/system/cpu/cpu2/cpufreq/scaling_governor
        cat /sys/devices/system/cpu/cpu2/cpufreq/energy_performance_preference
        sha256sum "$corpus/sqlite/sqlite3.c" "$corpus/provenance/gnu17-pinned-predefines.txt"
        find -L "$corpus/headers" "$corpus/sqlite" -type f -print0 | sort -z | xargs -0 sha256sum > results/bindings/corpus-before.sha256
        official=/home/david/.cache/buster/benchpress-clang/efdd1dbd089b99bfcfcde7b8eb1236163f2e88df5a981cca4f783ec9cb5e0378
        sha256sum "$official/bin/clang-23" /usr/bin/bash /usr/bin/taskset /usr/lib/libc.so.6 /usr/lib/libm.so.6 > results/bindings/runtime-tools-before.sha256
        find -L "$official/lib/clang/23/include" -type f -print0 | sort -z | xargs -0 sha256sum >> results/bindings/runtime-tools-before.sha256
        ;;
    corpus-after)
        sha256sum --check results/bindings/corpus-before.sha256 > results/bindings/corpus-after-check.txt
        sha256sum --check results/bindings/runtime-tools-before.sha256 > results/bindings/runtime-tools-after-check.txt
        ;;
    time)
        producer_log=results/time-p$process-s$shift.log
        builds=(--build base "$base" --build head "$head")
        if [ "$process" = 2 ]; then builds=(--build head "$head" --build base "$base"); fi
        taskset -c 2 "$head" time-runs --runs 21 --warmups 2 --copies 2 --directory "$stage/results" "${builds[@]}" --list "${sqlite[@]}" -o "$stage/results/timed.o" --list -c -std=gnu17 -march=znver5 controls/access-off.c -o "$stage/results/timed.o" --list -c -std=gnu17 -march=znver5 controls/access-on.c -o "$stage/results/timed.o" > "results/time-p$process-s$shift.log" 2>&1
        ;;
    stages)
        producer_log=results/stages-$role-p$process-s$shift.log
        test "$role" = head || test "$role" = base
        compiler=$head
        reference=$base
        if [ "$role" = base ]; then compiler=$base; reference=$head; fi
        taskset -c 2 "$compiler" measure-compile --runs 21 --warmups 2 --keep --directory "$stage/results" --reference "$reference" -- "${sqlite[@]}" > "results/stages-$role-p$process-s$shift.log" 2>&1
        ;;
    validate)
        mkdir -p results/validation
        for revision in base head; do
            for amount in 0 64 256; do
                compiler=$stage/placement-$revision/compiler-$amount
                for path in vector scalar; do
                    mode=()
                    if [ "$path" = scalar ]; then mode=(--scalar); fi
                    prefix=results/validation/$revision-$amount-$path
                    taskset -c 2 "$compiler" "${mode[@]}" "${sqlite[@]}" -o "$prefix-sqlite.o"
                    cmp results/validation/base-0-vector-sqlite.o "$prefix-sqlite.o"
                    for access in off on; do
                        taskset -c 2 "$compiler" "${mode[@]}" -c -std=gnu17 -march=znver5 controls/access-$access.c -o "$prefix-$access.o"
                        cmp results/validation/base-0-vector-$access.o "$prefix-$access.o"
                    done
                    printf 'PASS revision=%s shift=%s path=%s three_outputs_identical=true\n' "$revision" "$amount" "$path"
                done
            done
        done
        sha256sum results/validation/base-0-vector-{sqlite,off,on}.o
        ;;
    *) exit 2 ;;
esac
printf 'producer_exit_status=0\n' >> "$receipt"
if [ -n "$producer_log" ]; then sha256sum "$producer_log" >> "$receipt"; fi
sha256sum --check inputs.sha256 >> "$receipt"
date -u +after_run_utc=%Y-%m-%dT%H:%M:%SZ >> "$receipt"
