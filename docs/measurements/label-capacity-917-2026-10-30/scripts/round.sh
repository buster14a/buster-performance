#!/usr/bin/env bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin.
# One bounded whole-process timing round per shared lock hold.
set -euo pipefail
. "$(dirname "$0")/env.sh"
round=${1:?round number}
case "$round" in 1|2|3) ;; *) exit 2;; esac
state=${2:?plain or after-scalar}
case "$state" in plain) settling=();; after-scalar) settling=(--after-scalar 200);; *) exit 2;; esac
cd "$Q"
log="$Q/logs/time-$state-$round"
date -u +%FT%TZ > "$log.started"
trap 'status=$?; printf "%s\n" "$status" > "$log.status"; date -u +%FT%TZ > "$log.ended"' EXIT
test "$(cat logs/semantic.status)" = 0
builds=()
# The reference is the same baseline in all rounds. time-runs rotates slots
# internally, including build/placement/copy order.
for label in base candidate base-again; do
  kind=$label
  [ "$label" != base-again ] || kind=base
  for shift in 0 16 64 256 1024 2048; do builds+=(--build "$label" "$Q/placements-$kind-v4/$shift/compiler"); done
done
argv=(taskset -c 2 "$Q/base/build/compiler" time-runs --runs 3 --warmups 1 --copies 3 "${settling[@]}" "${builds[@]}"
  --list "${sqlite[@]}" --lanes 1 -o /tmp/buster-pr917-timing.o)
printf '%s\0' "${argv[@]}" > "$log.argv.nul"
sha256sum "$0" "$(dirname "$0")/env.sh" > "$log.scripts.sha256"
cat /var/lib/buster-9700x/owner > "$log.lock-owner"
"${argv[@]}"
