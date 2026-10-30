#!/usr/bin/env bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin.
# Charged whole-driver stage samples in a rotating A/B/A order; one hold.
set -euo pipefail
. "$(dirname "$0")/env.sh"
cd "$Q"
sha256sum --check --status manifests/executables.sha256
test "$(cat logs/semantic.status)" = 0
date -u +%FT%TZ > logs/stages.started
trap 'status=$?; printf "%s\n" "$status" > "$Q/logs/stages.status"; date -u +%FT%TZ > "$Q/logs/stages.ended"' EXIT
cat /var/lib/buster-9700x/owner > logs/stages.lock-owner
mkdir stages
for run in $(seq 0 10); do
  labels=(base candidate base-again)
  for slot in 0 1 2; do
    index=$(((slot + run) % 3))
    label=${labels[$index]}
    kind=$label
    [ "$label" != base-again ] || kind=base
    stem="$Q/stages/run-$run-$slot-$label"
    printf '%s %s %s\n' "$run" "$slot" "$label"
    argv=(taskset -c 2 "$Q/$kind/build/compiler" "${sqlite[@]}" --lanes 1 --time-stages -o "$Q/stage-output.o")
    printf '%s\0' "${argv[@]}" > "$stem.argv.nul"
    "${argv[@]}" > "$stem.stdout" 2> "$stem.stderr"
  done
done
