#!/bin/bash
set -euo pipefail
cd ~/buster-fast-bench/2850-codex-step2
group=$1; tag=$2; stem=$3; audit=$4
source ./corpora.sh
study_root=$PWD/pooled-main-source
study_root=$PWD/$(printf '%063d' 0)
test ${#study_root} = 110
inc=
if [[ ${LOCAL_HEADERS:-0} == 1 ]]; then inc="-I$PWD/pool-local-headers"; fi
main_arguments="-march=native -I$study_root/src $inc -fwrapv -funsigned-char --predefines $PWD/proof-predefines.h $study_root/src/buster/compiler/main.c"
v=${group}_arguments
eval "args=(${!v})"
unset NODE_SOURCE_REUSE_C NODE_SOURCE_SELECT_VERIFY NODE_SOURCE_POOL NODE_SOURCE_CACHE_CONTROLS NODE_PROOF_NATIVE_FAULT NODE_PROOF_CALL_ROW_FAULT
export NODE_PROOF_NO_FP=1 NODE_PROOF_POINTERS=1 NODE_PROOF_CALLS=1 NODE_SOURCE_ROWS=1 NODE_PROOF_NATIVE=1 NODE_SOURCE_SELECT_MASKS=1 NODE_SOURCE_LATE_ROWS=1
if [[ $tag == cached || $tag == pooled ]]; then export NODE_SOURCE_CACHE_CONTROLS=1; fi
if [[ $tag == pooled ]]; then export NODE_SOURCE_POOL=1; fi
if [[ $audit != off ]]; then export NODE_SOURCE_SELECT_VERIFY=1; fi
if [[ $audit == class ]]; then export NODE_PROOF_NATIVE_FAULT=1; fi
if [[ $audit == variadic || $audit == symbol || $audit == argument ]]; then export NODE_PROOF_CALL_ROW_FAULT=$audit; fi
set +e
./results/pooledcapture/compiler measure-node-machine --shadow --window-rows --front-first --passes 0 "${args[@]}" > "$stem.out" 2> "$stem.err"
status=$?
set -e
printf '%s\n' "$status" > "$stem.status"
grep -E '^(source-T |source-cost |source-rows )' "$stem.err" > "$stem.timings"
grep -E '^probe-native|^node-shadow: reader-time C and X compared=' "$stem.out" > "$stem.receipt"
if [[ $audit == off || $audit == check ]]; then
 test "$status" = 0
 grep -Eq '^probe-native .*differences=0 ' "$stem.receipt"
 ! grep -Eq 'differences=[1-9]' "$stem.receipt"
else
 grep -Eq '^probe-native .*differences=[1-9]' "$stem.receipt"
fi
