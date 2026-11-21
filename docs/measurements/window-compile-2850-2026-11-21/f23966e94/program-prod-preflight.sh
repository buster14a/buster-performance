#!/bin/bash
set -euo pipefail
cd ~/buster-fast-bench/2850-codex-step2
until test -f results/programbase5bb/.built; do sleep 4; done
out=$PWD/results/programprod239-preflight
mkdir -p "$out"
p=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
flags=(-c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$p" "$p/sqlite3.c")
d=$(mktemp -d /dev/shm/buster-program-roots.XXXXXXXX)
trap 'rm -f "$d/out.o"; rmdir "$d"' EXIT
for mode in default assignments; do
  options=(); [[ $mode == assignments ]] && options=(--node-window-assignments)
  for policy in ordinary wall stage; do
    diagnostic=(); case "$policy" in wall) diagnostic=(-Wall -Wextra);; stage) diagnostic=(--time-stages);; esac
    for c in programbase5bb programprod239; do
      stem=$out/$mode-$policy-$c
      rm -f "$d/out.o"
      ./lock.sh taskset -c 2 bash -c 'exe=$1;stem=$2;shift 2; exec "$exe" "$@" >"$stem.stdout" 2>"$stem.stderr"' _ "$PWD/results/$c/compiler" "$stem" "${options[@]}" "${diagnostic[@]}" "${flags[@]}" -o "$d/out.o" >"$stem.lock" 2>&1
      sha256sum "$d/out.o" | cut -d' ' -f1 >"$stem.sha256"
      wc -c <"$d/out.o" >"$stem.bytes"
      if [[ $mode == assignments && $policy == stage ]]; then grep '^node-window:' "$stem.stderr" > "$stem.admissions"; fi
    done
    for ext in stdout bytes sha256; do cmp "$out/$mode-$policy-programbase5bb.$ext" "$out/$mode-$policy-programprod239.$ext"; done
    if [[ $policy != stage ]]; then cmp "$out/$mode-$policy-programbase5bb.stderr" "$out/$mode-$policy-programprod239.stderr"; fi
  done
done
cmp "$out/assignments-stage-programbase5bb.admissions" "$out/assignments-stage-programprod239.admissions"
echo COMPLETE
