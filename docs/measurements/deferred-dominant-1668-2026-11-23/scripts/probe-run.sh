#!/bin/bash
# probe-run.sh: #1667's training and held-out data: the probe build (probe/, main a891cc05 with a per-body line of each
# one-lane walk) on musl src's 1,524 units, c-testsuite's 220, Lua's units and sqlite3.c, 6 passes each, one round;
# holds of 750 units at most. Per-body lines in logs/probe/, the benchmark's lines in logs/probe.log.
cd ~/buster-fast-bench/1667-claude
groups=()
mapfile -t musl < musl-units.txt
for ((i = 0; i < ${#musl[@]}; i += 750)); do groups+=("${musl[*]:i:150}"); done
cts=()
for f in c-testsuite/tests/single-exec/*.c; do cts+=("cts/$(basename "$f")"); done
groups+=("${cts[*]:0:110}" "${cts[*]:110}")
lua=()
for f in lua-5.4.7/src/*.c; do lua+=("lua/$(basename "$f")"); done
groups+=("${lua[*]} sqlite")
scripts/queue.sh probe 1 probe+probe:1 "${groups[@]}"
