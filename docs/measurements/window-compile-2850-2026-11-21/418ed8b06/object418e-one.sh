#!/bin/bash
set -eu
cd "$(dirname "$0")"
top=$PWD
source corpora.sh
main_arguments="-march=native -I$top/pooled-main-source/src -fwrapv -funsigned-char --predefines $top/proof-predefines.h $top/pooled-main-source/src/buster/compiler/main.c"
group=$1
options=${group}_arguments
eval "args=(${!options})"
base=results/factsmain0e1d/compiler
bin=results/object418e/compiler
d=results/object418e-individual/$group
mkdir -p "$d"
common=(BUSTER_SOURCE_ROOT_CURSOR=1 BUSTER_SOURCE_CONTROL_MASKS=1 BUSTER_SOURCE_DIRTY_DIAGNOSTICS=1 BUSTER_SOURCE_WARNING_INDEX=1 BUSTER_SOURCE_CLOSE_CONTEXTS=1 BUSTER_SOURCE_CLASS_CONSUMER=1 BUSTER_SOURCE_BORROW_CHILDREN=1 BUSTER_SOURCE_FIRST_NODE=1 BUSTER_CONTROL_EARLY_RELEASE=1 BUSTER_CONTROL_EARLY_NATIVE=1 BUSTER_SOURCE_WRITE_COLUMNS=1 BUSTER_SOURCE_FILE_DATA=1 BUSTER_SOURCE_GROW_GRAPH=1 BUSTER_SOURCE_RETIRE_LISTS=1 BUSTER_CONTROL_SOURCE_NATIVE=1)
for arm in base bin;do
 ./lock.sh bash capture2850.sh "$d/$arm.stdout" "$d/$arm.stderr" taskset -c 2 "${!arm}" --lanes 1 -c "${args[@]}" -o "$d/$arm.o"
done
cmp "$d/base.o" "$d/bin.o"
cmp "$d/base.stderr" "$d/bin.stderr"
cmp "$d/base.stdout" "$d/bin.stdout"
modes=(legacy fields stream packed)
for r in 0 1 2 3 4 5 6 7; do
 for i in 0 1 2 3; do
  ix=$(((i+r)%4))
  if ((r>=4));then ix=$(((3-i+r)%4));fi
  mode=${modes[ix]};marks=("${common[@]}")
  if [[ "$mode" == fields || "$mode" == stream || "$mode" == packed ]];then marks+=(BUSTER_CONTROL_OBJECT_FIELDS=1);fi
  if [[ "$mode" == stream || "$mode" == packed ]];then marks+=(BUSTER_OBJECT_TEXT_STREAM=1);fi
  if [[ "$mode" == packed ]];then marks+=(BUSTER_OBJECT_TEXT_RUNS=1);fi
  stem=$d/$r-$i-$mode
  ./lock.sh bash capture2850.sh "$stem.stdout" "$stem.stderr" taskset -c 2 python3 source966a-time.py "$stem.time" env "${marks[@]}" "$bin" --lanes 1 -c "${args[@]}" -o "$d/$mode.o"
  cmp "$d/base.o" "$d/$mode.o";cmp "$d/base.stdout" "$stem.stdout";cmp "$d/base.stderr" "$stem.stderr"
  if ((r<3));then
   ./lock.sh bash capture2850.sh "$stem.pmu.stdout" "$stem.pmu.stderr" taskset -c 2 perf stat -x ';' -e cycles,cycles:u,instructions:u,minor-faults -o "$stem.pmu" -- env "${marks[@]}" "$bin" --lanes 1 -c "${args[@]}" -o "$d/$mode.o"
   cmp "$d/base.o" "$d/$mode.o";cmp "$d/base.stdout" "$stem.pmu.stdout";cmp "$d/base.stderr" "$stem.pmu.stderr"
  fi
  if ((r==0));then
   ./lock.sh bash capture2850.sh "$d/$mode.stages.stdout" "$d/$mode.stages" taskset -c 2 env "${marks[@]}" BUSTER_OBJECT_STREAM_AUDIT=1 "$bin" --lanes 1 --time-stages -c "${args[@]}" -o "$d/$mode.o"
   cmp "$d/base.o" "$d/$mode.o"
  fi
 done
done
sha256sum "$d/"{base,bin,legacy,fields,stream,packed}.o >"$d/objects.tsv"
