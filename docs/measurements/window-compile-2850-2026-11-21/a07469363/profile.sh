#!/bin/bash
set -eu
cd "$(dirname "$0")"
d=$PWD; cc=$PWD/compiler-develop; cd ../switch-inputs; source ../switch-local-args.sh; eval "args=($sqlite_arguments)"
for arm in baseline cached; do
  extra=(); if [[ $arm == cached ]]; then extra=(BUSTER_CONTROL_MEMBER_RULES=1); fi
  perf record -q -e instructions:u -c 20003 --no-buildid -o "$d/$arm.data" -- env "${extra[@]}" BUSTER_CONTROL_SOURCE_NATIVE=1 BUSTER_CONTROL_EARLY_NATIVE=1 BUSTER_CONTROL_EARLY_RELEASE=1 "$cc" --lanes 1 -c "${args[@]}" -o "$d/prof.o"
  cmp "$d/prof.o" "$d/../source-typed-study/sqlite.o"
  perf report --stdio -n -i "$d/$arm.data" --no-children --percent-limit .05 --sort=symbol --field-separator='|' >"$d/$arm.symbols"
done
