#!/bin/bash
set -eu
cd "$(dirname "$0")"
source corpora.sh
exe=$PWD/result/compiler
out=$PWD/result/runs
mkdir -p "$out"
for round in $(seq "${2:-1}" "$1"); do
  for event in cycles instructions branch-misses l1i-misses l1d-misses frontend-stalls; do
    for family in tests contexts rows; do
      for corpus_name in sqlite lua musl; do
        name=$round-$event-$family-$corpus_name
        if [[ -f "$out/$name.done" ]]; then continue; fi
        case "$corpus_name" in sqlite) eval "args=($sqlite_arguments)";; lua) eval "args=($lua_arguments)";; musl) eval "args=($musl_arguments)";; esac
        rc=0
        ./lock.sh taskset -c 2 "$exe" measure-node-machine --shadow --window-rows --passes 0 --window-counter "$family" "$event" "${args[@]}" > "$out/$name.out" 2> "$out/$name.err" || rc=$?
        echo "$rc" > "$out/$name.status"
        if ((rc != 0)); then
          if [[ "$event" == cycles || "$event" == instructions || "$event" == branch-misses ]] || ! grep -q 'could not open or schedule pinned user counter' "$out/$name.err"; then
            echo "$name failed with status $rc"; exit "$rc"
          fi
        fi
        touch "$out/$name.done"
      done
    done
  done
done
