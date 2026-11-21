#!/bin/bash
set -euo pipefail
cd "$HOME/buster-fast-bench/2850-parser-depth-blocks"
root=$PWD
until test -f results/packed/.built && test -f results/after/.built; do sleep 5; done
source ./corpora.sh
eval "sqlite_args=($sqlite_arguments)"
eval "musl_args_raw=($musl_arguments)"
musl_args=()
for arg in "${musl_args_raw[@]}"; do [[ $arg == *.c ]] && break; musl_args+=("$arg"); done
musl_args+=("$musl/src/stdio/vfprintf.c")
lua_args=("$lua/lvm.c")
mkdir -p kernels
exec 9>"$HOME/buster-fast-bench/2850-codex-step2/our-timing.lock"
flock -x 9
labels=(before after packed)
for n in 0 1 2 3 4 5; do
 for c in sqlite lua musl; do
    case "$c" in sqlite) args=("${sqlite_args[@]}");; lua) args=("${lua_args[@]}");; musl) args=("${musl_args[@]}");; esac
    for offset in 0 1 2; do
      k=$(((n+offset)%3)); if ((n>=3)); then k=$((2-k)); fi
      tag=${labels[k]}
      p="$root/kernels/$n-$c-$offset-$tag"
      cp results/"$tag"/compiler kernels/cc
      "$root/lock.sh" bash -c 'dst=$1; shift; exec env BUSTER_HUGE_PAGES=1 taskset -c 2 "$@" >"$dst.out" 2>"$dst.err"' _ "$p" kernels/cc benchmark-parser --only stages --passes 7 "${args[@]}" >"$p.lock" 2>&1
      echo "$n $c $offset $tag" >>kernels/status
    done
 done
done
date -u +%FT%TZ >kernels/done
