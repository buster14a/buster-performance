#!/bin/bash
set -eu
cd "$(dirname "$0")"
d=$PWD
if [[ -f "$d/compiler-90a21788b" ]];then export CHAIN_COMPILER="$d/compiler-90a21788b";fi
if [[ -n "${CHAIN_COMPILER:-}" ]];then mkdir -p "${CHAIN_CORPUS_OUTPUT:-$d/real}";sha256sum "$CHAIN_COMPILER" >"${CHAIN_CORPUS_OUTPUT:-$d/real}/qualified-compiler.sha256";fi
cd ../switch-inputs
source ../switch-local-args.sh
tree=$PWD/../pregraph-warning-study/compiler-source
main_arguments="-march=native -I$tree/src -fwrapv -funsigned-char --predefines $PWD/../proof-predefines.h $tree/src/buster/compiler/main.c"
for g in "$@";do
 v=${g}_arguments
 eval "args=(${!v})"
 python3 "$d/corpus.py" "$g" "${args[@]}"
done
