#!/bin/bash
set -euo pipefail
cd "$(dirname "$0")";d=$PWD;early_compiler=$d/../source-early-release/build/compiler;cd ../switch-inputs;source ../switch-local-args.sh;eval "args=($sqlite_arguments)"
for arm in ordinary source early release;do
 case $arm in ordinary) flags=();; source) flags=(BUSTER_CONTROL_SOURCE_NATIVE=1);; early) flags=(BUSTER_CONTROL_SOURCE_NATIVE=1 BUSTER_CONTROL_EARLY_NATIVE=1);; release) flags=(BUSTER_CONTROL_SOURCE_NATIVE=1 BUSTER_CONTROL_EARLY_NATIVE=1 BUSTER_CONTROL_EARLY_RELEASE=1);; esac
 env "${flags[@]}" "$early_compiler" --lanes 1 --time-stages -c "${args[@]}" -o "$d/stages.o" >"$d/$arm.stages.log" 2>&1
 cmp "$d/stages.o" "$d/../source-typed-study/sqlite.o"
done
