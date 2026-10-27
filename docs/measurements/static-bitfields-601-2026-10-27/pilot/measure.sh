#!/usr/bin/env bash
# Each invocation is one bounded experiment, run under exclusive.sh.
set -euo pipefail
cd "$(dirname "$0")/.."
source evidence/cases.sh
unset CPATH C_INCLUDE_PATH CPLUS_INCLUDE_PATH
export LC_ALL=C SOURCE_DATE_EPOCH=1792454400
mkdir -p logs objects copies
phase=$1
mark=".measure-$phase-${2:-0}.done"
[[ ! -e "$mark" ]] || exit 0
if [[ "$phase" == whole || "$phase" == stages ]]; then
  [[ -e .measure-preflight-0.done ]] || bash evidence/measure.sh preflight
fi
case "$phase" in
  preflight)
    for case_name in "${cases[@]}"; do
      set_case "$case_name"
      for variant in base head; do
        taskset -c 2 "$variant/build/compiler" "${options[@]}" "$source" -o objects/current.o > "logs/$case_name-$variant-preflight.log" 2>&1
        cp objects/current.o "objects/$case_name-$variant.o"
      done
      cmp "objects/$case_name-base.o" "objects/$case_name-head.o"
      if [[ "$case_name" != sqlite && "$case_name" != lua-* ]]; then
        clang --no-default-config -std=gnu17 -w -O0 -c "$source" -o "objects/$case_name-clang.o"
        for variant in base head clang; do
          objcopy -O binary -j .data "objects/$case_name-$variant.o" "objects/$case_name-$variant.bin"
        done
        cmp "objects/$case_name-base.bin" "objects/$case_name-clang.bin"
      fi
      printf '%s: identical objects and accepted inputs\n' "$case_name"
    done
    ;;
  whole)
    round=$2
    lists=()
    for case_name in "${cases[@]}"; do
      set_case "$case_name"
      lists+=(--list "${options[@]}" "$source" -o objects/current.o)
    done
    taskset -c 2 head/build/compiler time-runs --runs 6 --warmups 1 --copies 2 --directory copies \
      --build base "$PWD/base/build/compiler" --build head "$PWD/head/build/compiler" --build control "$PWD/base/build/compiler" \
      "${lists[@]}" > "logs/matrix-r$round-whole.log" 2>&1
    printf 'whole-process round %s complete\n' "$round"
    ;;
  stages)
    for case_name in "${cases[@]}"; do
      set_case "$case_name"
      for sample in $(seq 0 11); do
        variants=(base head)
        if (( sample % 2 )); then variants=(head base); fi
        for variant in "${variants[@]}"; do
          taskset -c 2 "$variant/build/compiler" "${options[@]}" "$source" -o objects/current.o --time-stages > /dev/null 2> "logs/$case_name-r1-$variant-stage-$sample.log"
        done
      done
      printf '%s: stage measurements complete\n' "$case_name"
    done
    ;;
  split)
    for i in "${!cases[@]}"; do
      awk -v list="$((i+1))" '$1=="run" && $4==list' logs/matrix-r1-whole.log logs/matrix-r2-whole.log > "logs/${cases[$i]}-r1-whole.log"
    done
    ;;
  *) exit 2 ;;
esac
touch "$mark"
