#!/bin/bash
set -euo pipefail
cd "$(dirname "$0")";d=$PWD
cc=/home/david/.cache/buster/toolchain/4444af0bee44de2d/llvm-23.1.4/bin/clang
out=$d/local-origins;mkdir -p "$out"
cd ../switch-inputs;source ../switch-local-args.sh;eval "args=($sqlite_arguments)"
cd "$d"
for arm in eager cursor direct safe;do
 case $arm in eager) t=active-source-eager-base;;cursor) t=pp-live-group-vector;;direct) t=active-source-directives;;safe) t=active-source-safe;;esac
 src=$d/../$t/src
 "$cc" -O1 -g0 -std=gnu17 -march=native -fwrapv -funsigned-char -I"$src" -I"$src/buster/compiler" "$d/rows.c" -o "$out/$arm"
 PP_ROWS="$out/$arm.rows" "$out/$arm" "${args[@]}" >"$out/$arm.tsv"
 python "$d/origin-diff.py" "$out/eager.rows" "$out/$arm.rows" >"$out/$arm.diff"
done
