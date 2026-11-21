#!/bin/bash
set -eu
cd "$(dirname "$0")";d=$PWD;cc=$d/condition-publisher-compiler
cd ../switch-inputs;source ../switch-local-args.sh
export NODE_SOURCE_CONDITION_ORIGINS=1 NODE_SOURCE_ORIGIN_PUBLISHERS=1 NODE_SPLICE_DUMP=1 NODE_SPLICE_LOCATIONS=1 NODE_SOURCE_CONDITION=1 NODE_CROSS_TYPE_VIEW=1 NODE_CROSS_INCREMENTAL=1 NODE_CROSS_ARG_EPOCH=1 NODE_CROSS_FAST_REQUEST=1 NODE_SOURCE_STRINGS=1 NODE_CROSS_CHUNK=b NODE_PROOF_NO_FP=1 NODE_PROOF_POINTERS=1 NODE_PROOF_CALLS=1 NODE_SOURCE_ROWS=1 NODE_PROOF_NATIVE=1
for g in fixture sqlite lua musl;do
 if [[ $g == fixture ]];then args=("$d/condition-test.c");else v=${g}_arguments;eval "args=(${!v})";fi
 p=$d/publisher-$g
 "$cc" measure-node-machine --shadow --window-rows --front-first --passes 0 "${args[@]}" >"$p.out" 2>"$p.err"
done
