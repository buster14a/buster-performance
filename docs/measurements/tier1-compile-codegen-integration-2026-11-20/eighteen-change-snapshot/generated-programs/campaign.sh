#!/usr/bin/env bash
set -u
root=$(pwd)
cc=/home/david/.cache/buster/toolchain/4444af0bee44de2d/llvm-23.1.4/bin/clang
for gen in csmith yarpgen; do
 for v in control candidate; do
  bin="$root/eighteen-$v/build/compiler";out="$root/eighteen-evidence/generators/$v-$gen"
  if [[ $gen == csmith ]]; then extra=(--csmith-arg --max-funcs --csmith-arg 3 --csmith-arg --max-block-size --csmith-arg 3 --csmith-arg --max-block-depth --csmith-arg 2); else extra=(--yarpgen-arg --max-array-dims=2); fi
  CORES_TITLE="Check 128 fresh $gen programs with both tiers of the $v compiler" CORES_LINK=https://github.com/buster14a/buster/pull/3136 cores -n 1 -- "$bin" test-differential --buster "$bin" --tier0-default --tier1-arg --tier1 --tier1-arg -fno-asynchronous-unwind-tables --tier1-arg --tier1-report --csmith "$root/independent-corpus/csmith-installed/bin/csmith" --csmith-include "$root/independent-corpus/csmith-installed/include" --yarpgen "$root/independent-corpus/yarpgen-build/yarpgen" --clang "$cc" --generator "$gen" --seed 4270 --count 128 --timeout-ms 15000 "${extra[@]}" --revision "$(git -C "eighteen-$v" rev-parse HEAD)" --generator-revision 'csmith-0cdc710315cfee9035e22ef4363ca479270d1934,yarpgen-1adb290f453505838f3aa33dc571f292b0c1810f' --output "$out" >"$out.log" 2>&1
  echo "$?" > "$out.status"
 done
done
