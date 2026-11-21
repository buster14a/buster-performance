#!/bin/bash
set -eu -o pipefail
export CORES_LINK=https://github.com/buster14a/buster/pull/3214
tool_dir=$(cd "$(dirname "$0")" && pwd)
cd "${BUSTER_QA_TREE:-$tool_dir/../qa3204}"
if [[ -n "${BUSTER_QA_LLVM:-}" ]]; then export PATH="$BUSTER_QA_LLVM:$PATH"; fi
clang --version | head -1 | rg -q "clang version 23\.1\.4"
out=${BUSTER_QA_OUT:-$tool_dir/../qa3204-results}/tests
mkdir -p "$out"
export out
clang -dM -E -march=native -fwrapv -funsigned-char -x c /dev/null > build/predefines.h
for kind in checker driver; do
 export kind
 seq 1 8 | CORES_TITLE="3204 all $kind shards" cores -n 2 -- xargs -P "${CORES:-2}" -I'{}' bash -c 'part=$1; if [[ "$kind" == checker ]]; then args=(test-checker --seed 133); else args=(test-checker-driver --executable "$PWD/build/compiler" --in-process); fi; timeout 900 ./build/compiler "${args[@]}" --part "$part/8" > "$out/$kind-$part.log" 2>&1; echo $? > "$out/$kind-$part.status"' bash '{}'
done
