#!/bin/bash
set -euo pipefail
cd ~/buster-fast-bench/2850-codex-step2
root=$PWD;out=$root/results/active-source-origins;mkdir -p "$out"
source corpora.sh;eval "args=($sqlite_arguments)"
./lock.sh taskset -c 2 bash -c '
set -e
root=$1;out=$2;shift 2
export PATH="$(bash trees/factsmain0e1d/tools/ci/session-toolchain.sh stage):$PATH"
for arm in eager cursor direct safe;do
 case $arm in eager) tree=factsmain0e1d;;cursor) tree=livegroupfixed;;direct) tree=activesourcedirectives;;safe) tree=activesourcesafe;;esac
 src=$root/trees/$tree/src
 clang -O1 -g0 -std=gnu17 -fwrapv -funsigned-char -march=native -I"$src" -I"$src/buster/compiler" active-source-rows.c -o "$out/$arm"
 for history in deferred history;do
  if [[ $history == history ]];then PP_RECORD_HISTORY=1 PP_ROWS="$out/$arm.$history.rows" "$out/$arm" "$@" >"$out/$arm.$history.tsv";
  else PP_ROWS="$out/$arm.$history.rows" "$out/$arm" "$@" >"$out/$arm.$history.tsv";fi
 done
done
cd "$out";sha256sum *.rows > hashes.tsv
' _ "$root" "$out" "${args[@]}" >"$out/build.log" 2>&1
