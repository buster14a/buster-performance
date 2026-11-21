#!/usr/bin/env bash
set -euo pipefail
ulimit -c 0
rev=$1
d=$(cd "$(dirname "$0")" && pwd)
cd "$d/../source-call-effects"; git switch --detach "$rev"; ./build.sh > "$d/index-control-build.log" 2>&1
cp --reflink=auto build/compiler "$d/index-control"
mkdir -p "$d/index-controls"
for kind in 'signed' 'unsigned'; do
    echo "int from_index(int *p, $kind int i) { return p[i]; }" > "$d/index-controls/$kind.c"
    for fault in ok v p k u; do
        opts=(); if [[ $fault != ok ]]; then opts+=("BUSTER_SUBSCRIPT_INDEX_FAULT=$fault"); fi
        status=0; BUSTER_SUBSCRIPT_VERIFY=1 BUSTER_SUBSCRIPT_PROJECT=1 env "${opts[@]}" "$d/index-control" measure-node-machine --shadow --facts --facts-lean --passes 1 --list 1 "$d/index-controls/$kind.c" > "$d/index-controls/$kind-$fault.txt" 2>&1 || status=$?
        echo "$status" > "$d/index-controls/$kind-$fault.status"
    done
done
if [[ -x "$d/builtin-release" ]]; then
    bash "$d/qualify-builtin.sh"
fi
