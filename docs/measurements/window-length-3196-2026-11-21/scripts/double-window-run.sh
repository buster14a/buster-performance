#!/bin/bash
set -eu
cd ~/buster-fast-bench/2850-codex-window-length-v2
source corpora.sh
r=$1
args=()
for group in sqlite lua musl; do
 case $group in sqlite) eval "args=($sqlite_arguments)";; lua) eval "args=($lua_arguments)";; musl) eval "args=($musl_arguments)";; esac
 if ((r%2)); then order=(1 2 2 1); else order=(2 1 1 2); fi
 for idx in 0 1 2 3; do
  size=${order[idx]}
  tag=result/runs/$r-$idx-$size-$group
  if test -f "$tag.done"; then continue; fi
  mode=(env -u BUSTER_DOUBLE_SHADOW_WINDOW)
  if ((size==2)); then mode=(env BUSTER_DOUBLE_SHADOW_WINDOW=1); fi
  rc=0
  ./lock.sh taskset -c 2 "${mode[@]}" result/compiler measure-node-machine --shadow --window-rows --passes 0 "${args[@]}" > "$tag.out" 2> "$tag.err" || rc=$?
  echo "$rc" > "$tag.status"
  if ((rc!=0)); then cat "$tag.err"; exit "$rc"; fi
  touch "$tag.done"
 done
done
