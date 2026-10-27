#!/usr/bin/env bash
# Each invocation is one bounded preflight or stage-clock experiment under exclusive.sh.
set -euo pipefail
cd "$(dirname "$0")/.."
source evidence/cases.sh
unset CPATH C_INCLUDE_PATH CPLUS_INCLUDE_PATH
export LC_ALL=C SOURCE_DATE_EPOCH=1792454400
mkdir -p logs objects
phase=$1
mark=".measure-$phase-0.done"
[[ ! -e "$mark" ]] || exit 0
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
  stages)
    [[ -e .measure-preflight-0.done ]]
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
  *) exit 2 ;;
esac
touch "$mark"
