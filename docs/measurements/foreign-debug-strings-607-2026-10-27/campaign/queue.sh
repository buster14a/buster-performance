#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
export EXCLUSIVE_OWNER=codex-607
export EXCLUSIVE_TITLE='Foreign DWARF string tradeoff #607'
export EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/607
lock="$HOME/buster-fast-bench/exclusive.sh"
while [[ ! -e COMPLETE && ! -e STOP ]]; do
    "$lock" bash campaign/batch.sh
done
printf 'campaign complete\n'
