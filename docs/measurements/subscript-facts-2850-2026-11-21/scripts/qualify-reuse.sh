#!/usr/bin/env bash
set -euo pipefail
d=$(cd "$(dirname "$0")" && pwd)
cc="$d/reuse-release"
cd "$d/../switch-inputs"; source ../switch-local-args.sh
mkdir -p "$d/qa-reuse"
for corpus_key in sqlite lua musl; do
    opts="${corpus_key}_arguments"
    for mode in whole lean; do
        extra=(); if [[ $mode == lean ]]; then extra+=(--facts-lean); fi
        for packed in body packed; do
            args=("${extra[@]}"); if [[ $packed == packed ]]; then args+=(--facts-packed); fi
            BUSTER_SUBSCRIPT_PROJECT=1 BUSTER_SUBSCRIPT_VERIFY=1 "$cc" measure-node-machine --shadow --facts "${args[@]}" --passes 1 --list 1 ${!opts} > "$d/qa-reuse/check-$corpus_key-$mode-$packed.txt" 2>&1
        done
    done
    for variant in base project; do
        flags=(); if [[ $variant == project ]]; then flags+=(BUSTER_SUBSCRIPT_VERIFY=1 BUSTER_SUBSCRIPT_PROJECT=1); fi
        env "${flags[@]}" "$cc" measure-node-machine --shadow --window-rows --passes 0 --list 1 ${!opts} > "$d/qa-reuse/front-$corpus_key-$variant.txt" 2>&1
    done
done
BUSTER_SUBSCRIPT_SUITE=directed-reuse python "$d/directed.py" "$cc" > "$d/qa-reuse/directed.log" 2>&1
