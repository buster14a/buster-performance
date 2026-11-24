#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
export EXCLUSIVE_OWNER=codex-1340 EXCLUSIVE_TITLE="Issue 1340 call conversion scaling" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/1340
exec "$HOME/buster-fast-bench/exclusive.sh" timeout -k 5 180 bash -eu -c '
for n in 256 1024 4096 8192; do
 flags=(-fsyntax-only "1340-args-$n.c")
 for v in base head; do
     taskset -c 2 "./$v" "${flags[@]}" >"raw/arity-$n-$v.stdout" 2>"raw/arity-$n-$v.stderr"
 done
 cmp "raw/arity-$n-base.stderr" "raw/arity-$n-head.stderr"
 cmp "raw/arity-$n-base.stdout" "raw/arity-$n-head.stdout"
 taskset -c 2 ./uarch time "raw/arity-$n" 15 --list base ./base "${flags[@]}" --time-stages --list head ./head "${flags[@]}" --time-stages
done'
