#!/bin/bash
set -eu
cd "$(dirname "$0")"; d=$PWD;cd ../switch-inputs;source ../switch-local-args.sh;eval "args=($sqlite_arguments)"
for mode in ordinary native;do
 for arm in off on;do
  envs=()
  if [[ $mode = native ]];then envs+=(BUSTER_CONTROL_SOURCE_NATIVE=1 BUSTER_CONTROL_EARLY_NATIVE=1 BUSTER_CONTROL_EARLY_RELEASE=1);fi
  if [[ $arm = on ]];then envs+=(BUSTER_CONTROL_MEMBER_OPERANDS=1);fi
  env "${envs[@]}" perf record -q -o "$d/$mode-$arm.perf" -e instructions:u -c 131089 -- "$d/compiler-develop" --lanes 1 -c "${args[@]}" -o "$d/profile-$mode-$arm.o"
  cmp "$d/profile-$mode-$arm.o" "$d/../source-typed-study/sqlite.o"
  perf report -i "$d/$mode-$arm.perf" --stdio -n -s symbol --percent-limit 0 > "$d/$mode-$arm.profile"
 done
done
