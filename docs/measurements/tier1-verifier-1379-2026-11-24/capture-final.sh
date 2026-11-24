#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
export EXCLUSIVE_OWNER=codex-1379-6b055891 EXCLUSIVE_TITLE="Issue 1379 verifier measurement" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/1379
export SOURCE_DATE_EPOCH=1792454400
unset CPATH C_INCLUDE_PATH
sq=/home/david/buster-fast-bench/1296-codex-20261105/corpus/sqlite
lua=/home/david/buster-fast-bench/3130-claude/inputs/lua
mode=$1
label=$2
workload=$3
round=$4
stem=logs/$mode-$label-$workload-$round
if [[ $workload = sqlite ]]; then
    args=(-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 "-I$sq" "$sq/sqlite3.c")
    repeats=3
else
    args=("-I$lua" "$lua/lvm.c")
    repeats=10
fi
command=("./$label" -c -w --tier1 --lanes=1 "${args[@]}" -o "$stem.o")
if [[ $mode = profile ]]; then
    measure=(taskset -c 2 perf record -q -e cycles:u -F 9999 -o "$stem.data" -- bash -c 'n=$1; shift; for ((i=0;i<n;i++)); do "$@" || exit; done' bash "$repeats" "${command[@]}")
else
    measure=(taskset -c 2 perf stat -x, -e cycles:u,instructions:u -o "$stem.stat" -- "${command[@]}")
fi
~/buster-fast-bench/exclusive.sh bash -c '
    set -eu
    cat /proc/loadavg
    ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -8
    stem=$1; mode=$2; shift 2
    timeout -k 5 120 "$@"
    cat /proc/loadavg
    ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -8
    if [[ $mode = profile ]]; then
        timeout 60 perf report -i "$stem.data" --stdio --no-children --percent-limit 0 -n --show-total-period --sort symbol > "$stem.report"
    fi
' bash "$stem" "$mode" "${measure[@]}" > "$stem.log" 2>&1
sha256sum "$stem.o" > "$stem.sha256"
