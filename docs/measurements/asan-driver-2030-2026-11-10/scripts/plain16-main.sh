#!/bin/bash
# All 16 parts of test-checker-driver by main's plain build (compiler-plain, dbc76dd7), CORES at a time, each bounded,
# from a tree at the same sources: the laptop's own failures, to tell them from a change's.
set -u
export LC_ALL=C
D=$HOME/.cache/claude-pr2056-review/2030
export DRIVER_TREE=/home/david/dev/ai/claude/buster/.claude/worktrees/asan-driver-2030
seq 1 16 | xargs -P "${CORES:-4}" -I{} timeout 600 "$D/driver.sh" "plainmain16-{}" "$D/compiler-plain" "{}/16"
grep '^plainmain16-' "$D/driver.txt" | awk '$3 != "rc=0" { print $1, $3, substr($0, index($0, "|") + 2) }'
grep -l 'asm placed' "$D"/driver-plainmain16-*.log | xargs -r grep -h 'test-checker:' | cut -c1-200
