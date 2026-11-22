#!/bin/bash
set -eu
cd "$(dirname "$0")"
for item in sqlite main; do
  for arm in ordinary cached; do
    opts=()
    if [[ "$arm" == cached ]]; then opts=(BUSTER_CONTROL_MEMBER_RULES=1); fi
    env "${opts[@]}" BUSTER_CONTROL_SOURCE_AUDIT=1 BUSTER_CONTROL_RULE_ROWS=1 bash ./run.sh "$item" 2>"$item.$arm.log"
    rg '^body-source-row' "$item.$arm.log" >"$item.$arm.rows"
  done
  cmp "$item.ordinary.rows" "$item.cached.rows"
  rg '^source-member-rules' "$item.cached.log"
done
