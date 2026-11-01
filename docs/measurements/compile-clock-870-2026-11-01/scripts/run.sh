#!/bin/sh
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
# The #870 control campaign on a locked host. Every measured command takes the host lock for its own run.
#
#   ./run.sh COMPILER OUTPUT_DIRECTORY [CORPUS] [CONTROL_ROUNDS]
#
# COMPILER is the buster executable under test. CORPUS defaults to the frozen preprocessor corpus
# (preprocessor-391e729af658), whose sqlite3.c is compile-time.md's input. OUTPUT_DIRECTORY must not exist.
set -eu

compiler=${1:?usage: run.sh COMPILER OUTPUT_DIRECTORY [CORPUS] [CONTROL_ROUNDS]}
out=${2:?usage: run.sh COMPILER OUTPUT_DIRECTORY [CORPUS] [CONTROL_ROUNDS]}
corpus=${3:-"$HOME/buster-fast-bench/corpus-391e729af658"}
rounds=${4:-3}
script_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
lock="$HOME/buster-fast-bench/exclusive.sh"
sqlite="$corpus/sqlite"
owner=opencode-870
title="Issue 870 clock attribution"
link=https://github.com/buster14a/buster/issues/870

[ -x "$compiler" ] || { echo "run.sh: no executable at $compiler" >&2; exit 2; }
[ -f "$sqlite/sqlite3.c" ] || { echo "run.sh: no frozen sqlite3.c under $sqlite" >&2; exit 2; }
[ -x "$lock" ] || { echo "run.sh: no host lock at $lock" >&2; exit 2; }
[ ! -e "$out" ] || { echo "run.sh: $out already exists" >&2; exit 2; }

mkdir -p "$out/logs" "$out/scripts" "$out/analysis"
cp "$script_dir/clock_control.c" "$script_dir/analyze.py" "$out/scripts/"
clang -std=c17 -O2 -Wall -Wextra -Werror -o "$out/clock_control" "$out/scripts/clock_control.c"

exclusive()
{
    EXCLUSIVE_OWNER="$owner" EXCLUSIVE_TITLE="$title" EXCLUSIVE_LINK="$link" "$lock" "$@"
}

{
    date -u
    printf 'compiler\t%s\n' "$compiler"
    printf 'source-revision\t%s\n' "${SOURCE_REVISION:-unknown}"
    sha256sum "$compiler"
    git -C "$(dirname -- "$compiler")/../.." rev-parse HEAD 2>/dev/null || true
    uname -a
    printf '%s\n' '--- /proc/cmdline'
    cat /proc/cmdline
    printf '%s\n' '--- /proc/config.gz (accounting, clocks, NOHZ, HZ)'
    zcat /proc/config.gz 2>/dev/null | grep -E '^CONFIG_(VIRT_CPU_ACCOUNTING|IRQ_TIME_ACCOUNTING|PARAVIRT_TIME_ACCOUNTING|HZ=|NO_HZ|TICK_CPU)' || true
    printf '%s\n' '--- isolated / nohz_full / online'
    cat /sys/devices/system/cpu/isolated 2>/dev/null || true
    cat /sys/devices/system/cpu/nohz_full 2>/dev/null || true
    cat /sys/devices/system/cpu/online 2>/dev/null || true
    printf '%s\n' '--- CPU 2 frequency and governor'
    cat /sys/devices/system/cpu/cpu2/cpufreq/scaling_governor 2>/dev/null || true
    cat /sys/devices/system/cpu/cpu2/cpufreq/scaling_cur_freq 2>/dev/null || true
    printf '%s\n' '--- perf'
    perf --version 2>&1 || true
    cat /proc/sys/kernel/perf_event_paranoid 2>/dev/null || true
    printf '%s\n' '--- sqlite input'
    sha256sum "$sqlite/sqlite3.c" "$corpus/MANIFESTS.sha256" 2>/dev/null || true
    printf '%s\n' '--- tcc reference'
    tcc -v 2>&1 | head -1 || true
    sha256sum /usr/bin/tcc 2>/dev/null || true
} > "$out/logs/environment.txt" 2>&1

# Three fresh-process controls, each a fresh three-round sweep. Passing --fault-mb 512 keeps the 50 ms page-fault
# phases inside the arena on the 9700X; shorter runs remain comparable because every sample reports its work units.
for run in 1 2 3; do
    exclusive taskset -c 2 "$out/clock_control" --rounds "$rounds" --fault-mb 512 > "$out/logs/control-$run.tsv" 2>&1
done

# The control's own hardware counters against perf stat's whole-process accounting, and task-clock:k against the
# hardware kernel cycles. The control's output also carries its per-phase counters; this receipt is an external check.
exclusive perf stat -e cycles,cycles:u,cycles:k,task-clock,task-clock:k -- taskset -c 2 "$out/clock_control" --rounds 1 --lengths 10000 --offsets 0 --only syscall --fault-mb 64 \
    > "$out/logs/perf-stat.txt" 2>&1 || true

options="-c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I$sqlite $sqlite/sqlite3.c"
for run in 1 2 3 4 5 6 7; do
    # shellcheck disable=SC2086
    exclusive taskset -c 2 "$compiler" --time-stages $options -o "$out/logs/sqlite-$run.o" 2> "$out/logs/sqlite-$run.stderr" || true
done

# The whole-process harness's own medians and its warning about the stage split.
# shellcheck disable=SC2086
exclusive taskset -c 2 "$compiler" measure-compile --runs 11 --reference /usr/bin/tcc -- $options > "$out/logs/measure-compile.txt" 2>&1 || true

rm -f "$out"/logs/sqlite-*.o
python3 "$out/scripts/analyze.py" "$out"
