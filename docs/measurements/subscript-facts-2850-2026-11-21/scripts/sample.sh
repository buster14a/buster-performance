#!/usr/bin/env bash
set -euo pipefail
d=$(cd "$(dirname "$0")" && pwd)
shared="$HOME/buster-fast-bench/2850-codex-step2"
round=$1; variant=$2; source_key=$3
cd "$shared"
source ./corpora.sh
case $source_key in sqlite) eval "args=($sqlite_arguments)";; lua) eval "args=($lua_arguments)";; musl) eval "args=($musl_arguments)";; esac
flags=(); if [[ $variant == AA ]]; then flags+=(BUSTER_SUBSCRIPT_AA=1); fi
if ((round%2 == 0)); then flags+=(BUSTER_SUBSCRIPT_REVERSE=1); fi
out="$d/results/$source_key-$round-$variant.txt"; mkdir -p "$d/results"
taskset -c 2 env "${flags[@]}" BUSTER_SUBSCRIPT_SHARED=1 BUSTER_SUBSCRIPT_COST=1 "$d/compiler" measure-node-machine --shadow --facts --facts-lean --facts-packed --list 1 --passes 1 "${args[@]}" > "$out" 2>&1
test "$(grep -c '^subscript-pair: ' "$out")" -eq 9
grep -Eq 'differences=0 list-differences=0 failures=0' "$out"
