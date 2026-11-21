#!/usr/bin/env bash
set -euo pipefail
root=$PWD
corpus=$1
out=$2
mkdir -p "$out"
out=$(cd "$out" && pwd)
cd "$corpus"
source ./corpora.sh
cd "$root"
clang=${CLANG:-clang}
"$clang" -dM -E -march=native -fwrapv -funsigned-char -x c /dev/null > "$out/predefines.h"
main_arguments="-march=native -Isrc -fwrapv -funsigned-char --predefines $out/predefines.h src/buster/compiler/main.c"
for variant in integer pointers pointers_no_fp; do
 unset NODE_PROOF_POINTERS NODE_PROOF_NO_FP
 if [[ $variant != integer ]]; then export NODE_PROOF_POINTERS=1; fi
 if [[ $variant == pointers_no_fp ]]; then export NODE_PROOF_NO_FP=1; fi
 for c in sqlite lua musl main; do
  key=${c}_arguments
  eval "args=(${!key})"
  build/compiler measure-node-machine --shadow --window-rows --front-first --passes 0 "${args[@]}" > "$out/$variant-$c.stdout" 2> "$out/$variant-$c.stderr"
 done
done
