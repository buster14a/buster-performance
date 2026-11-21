#!/bin/bash
set -euo pipefail
cd "$(dirname "$0")/window-source-lowering"
out=$PWD/../independent-native-values
base=$PWD
./build.sh > "$out/build.log" 2>&1
cp ../buster/build/predefines.h build/predefines.h
cc=$PWD/build/compiler
export NODE_PROOF_NO_FP=1 NODE_PROOF_POINTERS=1 NODE_PROOF_CALLS=1 NODE_SOURCE_ROWS=1 NODE_PROOF_NATIVE=1
cd ../switch-inputs
source ../switch-local-args.sh
cd "$base"
main_tree="$base/../pregraph-warning-study/compiler-source"
main_arguments="-march=native -I$main_tree/src -fwrapv -funsigned-char --predefines ../proof-predefines.h $main_tree/src/buster/compiler/main.c"
for corpus in sqlite lua musl main; do
 var=${corpus}_arguments
 eval "args=(${!var})"
 "$cc" measure-node-machine --shadow --window-rows --front-first --passes 0 "${args[@]}" > "$out/$corpus.out" 2> "$out/$corpus.err" || fail=$?
done
eval "sql=($sqlite_arguments)"
NODE_SOURCE_SKIP_ROW_INPUTS=1 "$cc" measure-node-machine --shadow --window-rows --front-first --passes 0 "${sql[@]}" > "$out/stale.out" 2> "$out/stale.err" || bad=$?
echo "${bad:-0}" >"$out/stale.status"
for fault in variadic symbol argument; do
  NODE_PROOF_CALL_ROW_FAULT=$fault "$cc" measure-node-machine --shadow --window-rows --front-first --passes 0 "${sql[@]}" >"$out/$fault.out" 2>"$out/$fault.err" || ec=$?
  echo "${ec:-0}" > "$out/$fault.status"
  unset ec
done
NODE_PROOF_NATIVE_FAULT=1 "$cc" measure-node-machine --shadow --window-rows --front-first --passes 0 "${sql[@]}" > "$out/mutant.out" 2> "$out/mutant.err" || fail_mut=$?
echo "${fail:-0} ${fail_mut:-0}" > "$out/status"
exit "${fail:-0}"
