#!/usr/bin/env bash
set -euo pipefail
d=$(cd "$(dirname "$0")" && pwd)
shared="$HOME/buster-fast-bench/2850-codex-step2"
r=$1; label=$2; phase=$3; corpus_key=$4; mode=$5
cd "$shared"
source ./corpora.sh
case $corpus_key in sqlite) eval "args=($sqlite_arguments)";; lua) eval "args=($lua_arguments)";; musl) eval "args=($musl_arguments)";; esac
extra=()
if [[ $mode == lean ]]; then extra+=(--facts-lean); fi
if [[ $label == project ]]; then export BUSTER_SUBSCRIPT_PROJECT=1; else unset BUSTER_SUBSCRIPT_PROJECT; fi
unset BUSTER_SUBSCRIPT_COST BUSTER_SUBSCRIPT_VERIFY
out="$d/results/$phase-$corpus_key-$mode-$r-$label"
mkdir -p "$d/results"
base=("$d/compiler" measure-node-machine --shadow --facts "${extra[@]}" --facts-packed --list 1)
if [[ $phase == cost ]]; then
    BUSTER_SUBSCRIPT_COST=1 taskset -c 2 "${base[@]}" --passes 5 "${args[@]}" > "$out.txt" 2>&1
elif [[ $phase == full ]]; then
    taskset -c 2 perf stat -x ';' -e cycles:u,instructions:u,branch-misses:u -o "$out.stat" -- "${base[@]}" --passes 1 "${args[@]}" > "$out.txt" 2>&1
else
    case $phase in
        cycles) period=300007;;
        instructions) period=800011;;
        branch_misses) period=1009;;
        misses_clean) period=5003;;
        branches) period=100003;;
    esac
    event=${phase/_/-}; if [[ $phase == misses_clean ]]; then event=branch-misses; fi
    taskset -c 2 perf record -e "$event:u" -c "$period" -o "$out.data" -- "${base[@]}" --passes 120 "${args[@]}" > "$out.txt" 2>&1
    perf report -i "$out.data" --stdio -n -F overhead,sample,symbol --percent-limit 0 > "$out.profile" 2>/dev/null
    grep -E 'node_facts_subscripts' "$out.profile" > "$out.symbols"
    perf report --stats -i "$out.data" > "$out.events" 2>/dev/null
    rm -f "$out.data"
fi
grep -Eq 'differences=0 list-differences=0 failures=0' "$out.txt"
grep -Eq 'node-facts: lookup=\[\] records=[1-9]' "$out.txt"
date -u +%FT%TZ > "$out.done"
