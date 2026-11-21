#!/bin/bash
set -euo pipefail
cd "$(dirname "$0")/window-calls"
out=$PWD/../call-all-fields
./build.sh > "$out/build.log" 2>&1
cc=$PWD/build/compiler
export NODE_PROOF_CALLS=1 NODE_PROOF_NO_FP=1 NODE_PROOF_POINTERS=1
base=$PWD
cd ../switch-inputs
source ../switch-local-args.sh
cd "$base"
main_arguments="-march=native -Isrc -fwrapv -funsigned-char --predefines ../proof-predefines.h src/buster/compiler/main.c"
for name in fixture zero one nested two indirect varargs old attrs noreturn target float repeated-64; do
 "$cc" measure-node-machine --shadow --window-rows --front-first --passes 0 ../call-check/"$name".c > "$out/$name.out" 2> "$out/$name.err"
done
NODE_PROOF_TRACE_CALL=1 "$cc" measure-node-machine --shadow --window-rows --front-first --passes 0 ../call-check/fixture.c > "$out/traced.out" 2>"$out/traced.err"
for corpus in sqlite lua musl main; do
 var=${corpus}_arguments
 eval "args=(${!var})"
 "$cc" measure-node-machine --shadow --window-rows --front-first --passes 0 "${args[@]}" > "$out/$corpus.out" 2>"$out/$corpus.err"
done
eval "sql=($sqlite_arguments)"
NODE_PROOF_FAULT_ARGUMENT=1 "$cc" measure-node-machine --shadow --window-rows --front-first --passes 0 "${sql[@]}" > "$out/mutant.out" 2> "$out/mutant.err"
