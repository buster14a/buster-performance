#!/usr/bin/env bash
# #569's 9700X runs after main's object (queue.sh's steps before it): two holds of the host's lock, about a minute each,
# since one hold per compile waited half an hour each behind CI and other sessions (hold-a.sh, hold-b.sh).
set -u
source "$(dirname "$0")/common.sh"
cd "$D" || exit 1
echo $$ > "$D/queue3.pid"
export EXCLUSIVE_TITLE="#569 tier0 validator: main, head and the switch's modes"
echo "== hold a $(date +%T)"
"$LOCK" "$D/campaign/hold-a.sh"
echo "== hold b $(date +%T)"
"$LOCK" "$D/campaign/hold-b.sh"
echo "== done $(date +%T)"
