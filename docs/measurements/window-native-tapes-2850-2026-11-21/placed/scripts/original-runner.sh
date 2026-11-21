#!/bin/bash
set -euo pipefail
cd "$(dirname "$0")/window-through-rows"
out=$PWD/../through-rows-abi
base=$PWD
./build.sh > "$out/build.log" 2>&1
cp ../buster/build/predefines.h build/predefines.h
cc=$PWD/build/compiler
export NODE_PROOF_NO_FP=1 NODE_PROOF_POINTERS=1 NODE_PROOF_CALLS=1 NODE_PROOF_TO_ROWS=1 NODE_PROOF_NATIVE=1
cd ../switch-inputs
source ../switch-local-args.sh
cd "$base"
main_arguments="-march=native -Isrc -fwrapv -funsigned-char --predefines ../proof-predefines.h src/buster/compiler/main.c"
for corpus in sqlite lua musl main; do
 var=${corpus}_arguments
 eval "args=(${!var})"
 "$cc" measure-node-machine --shadow --window-rows --front-first --passes 0 "${args[@]}" > "$out/$corpus.out" 2> "$out/$corpus.err" || fail=$?
done
eval "sql=($sqlite_arguments)"
for fault in variadic symbol argument; do
  NODE_PROOF_CALL_ROW_FAULT=$fault "$cc" measure-node-machine --shadow --window-rows --front-first --passes 0 "${sql[@]}" >"$out/$fault.out" 2>"$out/$fault.err" || ec=$?
  echo "${ec:-0}" > "$out/$fault.status"
  unset ec
done
NODE_PROOF_NATIVE_FAULT=1 "$cc" measure-node-machine --shadow --window-rows --front-first --passes 0 "${sql[@]}" > "$out/mutant.out" 2> "$out/mutant.err" || fail_mut=$?
NODE_PROOF_PARTIAL_ROWS=1 "$cc" measure-node-machine --shadow --window-rows --front-first --passes 0 "${sql[@]}" > "$out/partial.out" 2> "$out/partial.err" || fail_partial=$?
echo "${fail:-0} ${fail_mut:-0}" > "$out/status"
exit "${fail:-0}"
