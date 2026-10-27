#!/usr/bin/env bash
# One bounded comparison round. Each case has its own warmed output and independent time-runs invocation.
set -euo pipefail
cd "$(dirname "$0")/.."
source evidence/cases.sh
unset CPATH C_INCLUDE_PATH CPLUS_INCLUDE_PATH
export LC_ALL=C SOURCE_DATE_EPOCH=1792454400
[[ -e .measure-preflight-0.done ]]
mkdir -p logs objects
copy_directory=$(mktemp -d /tmp/buster-601-copies-XXXXXX)
trap 'rmdir "$copy_directory" 2>/dev/null || true' EXIT
for case_name in "${cases[@]}"; do
  set_case "$case_name"
  taskset -c 2 head/build/compiler time-runs --runs 12 --warmups 1 --copies 2 --directory "$copy_directory" \
    --build base "$PWD/base/build/compiler" --build head "$PWD/head/build/compiler" --build control "$PWD/base/build/compiler" \
    --list "${options[@]}" "$source" -o "objects/$case_name-timed.o" > "logs/$case_name-r1-whole.log" 2>&1
  printf '%s: corrected whole-process comparison complete\n' "$case_name"
done
touch .corrected-whole-complete
