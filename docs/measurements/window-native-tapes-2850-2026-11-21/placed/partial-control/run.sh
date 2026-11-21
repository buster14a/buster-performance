#!/bin/bash
set -euo pipefail
cd "$(dirname "$0")/window-through-rows"
base=$PWD
out=$base/../partial-ablation
./build.sh >"$out/build.log" 2>&1
cc=$PWD/build/compiler
export NODE_PROOF_NO_FP=1 NODE_PROOF_POINTERS=1 NODE_PROOF_CALLS=1 NODE_PROOF_TO_ROWS=1 NODE_PROOF_PARTIAL_ROWS=1
cd ../switch-inputs
source ../switch-local-args.sh
eval "args=($sqlite_arguments)"
for v in spare exponent taken ordinary;do
 st=0
 NODE_PROOF_RETAIN_FIELD=$v "$cc" measure-node-machine --shadow --window-rows --front-first --passes 0 "${args[@]}" > "$out/$v.out" 2>"$out/$v.err" || st=$?
 echo "$st" >"$out/$v.status"
done
